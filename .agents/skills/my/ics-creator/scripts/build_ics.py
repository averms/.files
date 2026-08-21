#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "icalendar>=7.2.2",
# ]
# ///
"""Turn a structured event spec into a minimal, clean, RFC 5545 .ics file."""

import argparse
import json
import re
import sys
import unicodedata
from dataclasses import dataclass, field
from datetime import date, datetime, time, timedelta, timezone
from pathlib import Path
from zoneinfo import ZoneInfo

from icalendar import Alarm, Calendar, Event


@dataclass(kw_only=True, slots=True)
class EventSpec:
    summary: str
    date: str
    start: str | None = None
    end: str | None = None
    end_date: str | None = None
    duration_minutes: int | None = None
    timezone: str | None = None
    location: str | None = None
    description: str | None = None
    url: str | None = None
    reminders: list[str] = field(default_factory=list)
    all_day: bool = False


@dataclass(kw_only=True, slots=True)
class CalendarSpec:
    events: list[EventSpec]
    filename: str | None = None


def slugify(text: str | None) -> str:
    text = unicodedata.normalize("NFKD", text or "event")
    text = text.encode("ascii", "ignore").decode("ascii").lower()
    text = re.sub(r"[^a-z0-9]+", "-", text).strip("-")
    return (text or "event")[:48]


def parse_time(value: str) -> tuple[int, int]:
    m = re.match(r"^(\d{2}):(\d{2})$", str(value).strip())
    if not m:
        raise ValueError(f"time must be 'HH:MM' (24-hour), got {value!r}")
    return int(m.group(1)), int(m.group(2))


def parse_date(value: str) -> date:
    y, mo, d = (int(x) for x in str(value).split("-"))
    return date(y, mo, d)


def parse_dt(date_str: str, time_val: str | None) -> datetime:
    hh, mm = parse_time(time_val) if time_val is not None else (0, 0)
    # naive on purpose: no timezone means an RFC 5545 floating time
    return datetime.combine(parse_date(date_str), time(hh, mm))


def parse_trigger(value: str) -> timedelta:
    s = str(value).strip().upper()
    m = re.match(r"^(-)?P(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?)?$", s)
    if not m or not any(m.group(2, 3, 4, 5)):
        raise ValueError(f"reminder must be an ISO 8601 duration, got {value!r}")
    sign, days, hours, minutes, seconds = (
        -1 if m.group(1) else 1,
        *(int(g) if g else 0 for g in m.group(2, 3, 4, 5)),
    )
    return sign * timedelta(days=days, hours=hours, minutes=minutes, seconds=seconds)


def resolve_times(ev: EventSpec) -> tuple[date, date]:
    if ev.all_day:
        start = parse_date(ev.date)
        if ev.end is not None:
            if "-" not in ev.end:
                raise ValueError(
                    f"all-day event 'end' must be a YYYY-MM-DD date, got {ev.end!r}"
                )
            end = parse_date(ev.end)
        else:
            end = start + timedelta(days=1)
        return start, end

    start = parse_dt(ev.date, ev.start)
    if ev.end is not None:
        end = parse_dt(ev.end_date or ev.date, ev.end)
        if end <= start:  # end crossed midnight
            end += timedelta(days=1)
    elif ev.duration_minutes is not None:
        end = start + timedelta(minutes=int(ev.duration_minutes))
    else:
        end = start + timedelta(hours=1)  # sane default
    return start, end


def build_event(ev: EventSpec, dtstamp: datetime) -> Event:
    start, end = resolve_times(ev)
    component = Event()
    component.add(
        "UID", f"{slugify(ev.summary)}-{start.strftime('%Y%m%d')}@claude-ics-creator"
    )
    component.add("DTSTAMP", dtstamp)
    if ev.timezone and isinstance(start, datetime) and isinstance(end, datetime):
        tz = ZoneInfo(ev.timezone)
        component.add("DTSTART", start.replace(tzinfo=tz))
        component.add("DTEND", end.replace(tzinfo=tz))
    else:
        component.add("DTSTART", start)
        component.add("DTEND", end)
    component.add("SUMMARY", ev.summary)
    if ev.location:
        component.add("LOCATION", ev.location)
    if ev.description:
        component.add("DESCRIPTION", ev.description)
    if ev.url:
        component.add("URL", ev.url)
    for trig in ev.reminders:
        alarm = Alarm()
        alarm.add("ACTION", "DISPLAY")
        alarm.add("DESCRIPTION", "Reminder")
        alarm.add("TRIGGER", parse_trigger(trig))
        component.add_component(alarm)
    return component


def build_calendar(spec: CalendarSpec) -> bytes:
    dtstamp = datetime.now(timezone.utc)
    cal = Calendar(
        version="2.0", prodid="-//Claude//ICS Creator//EN", calscale="GREGORIAN"
    )

    starts, ends = [], []
    for ev in spec.events:
        start, end = resolve_times(ev)
        starts.append(start)
        ends.append(end)
        cal.add_component(build_event(ev, dtstamp))

    if any(ev.timezone and not ev.all_day for ev in spec.events):
        # starts/ends mixes date and datetime, which can't be compared directly
        years = [d.year for d in (*starts, *ends)]
        cal.add_missing_timezones(
            first_date=date(min(years), 1, 1),
            last_date=date(max(years) + 1, 1, 1),
        )
    return cal.to_ical()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "spec", nargs="?", default="-", help="JSON spec path, or '-' for stdin"
    )
    parser.add_argument("-o", "--output", help="output .ics path")
    opts = parser.parse_args()

    if opts.spec == "-":
        raw = sys.stdin.read()
    else:
        raw = Path(opts.spec).read_text(encoding="utf-8")
    data = json.loads(raw)
    if not isinstance(data, dict):
        raise TypeError("spec must be a JSON object")
    raw_events = data.get("events")
    if not raw_events:
        raise ValueError("spec has no events")
    spec = CalendarSpec(
        events=[EventSpec(**e) for e in raw_events],
        filename=data.get("filename"),
    )

    ics = build_calendar(spec)

    out_path = opts.output
    if out_path is None:
        fname = spec.filename or slugify(spec.events[0].summary)
        if not fname.endswith(".ics"):
            fname += ".ics"
        out_path = fname

    Path(out_path).write_bytes(ics)


if __name__ == "__main__":
    main()
