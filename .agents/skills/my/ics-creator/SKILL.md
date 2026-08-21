---
name: ics-creator
description: >-
  Build standards-compliant .ics (iCalendar) files from event details. Always trigger
  when the user explicitly asks for a .ics / calendar file / "add to calendar" file, or
  names this skill.
---

# ICS Creator

Turn event descriptions written in plain language into minimal, correct `.ics`
files. The aesthetic goal is *clean*: only the fields that carry meaning, no
boilerplate the user didn't ask for. The correctness goal is *portable*: the
event must show at the right local time in any calendar app, anywhere.

You handle the part you're good at — reading messy human text and figuring out
what the event actually is. The bundled script handles the `.ics` serialization.
Don't hand-write ICS; let the script emit it so the output is correct and
consistent every time.

## Workflow

1. **Parse the event(s)** from the user's text into the JSON spec below. Pull
   out title, date, start/end times, venue, and anything else present.
2. **Resolve the timezone.** This is the step that matters most for
   correctness — see "Timezones" below.
3. **Write the spec to a JSON file** and run the builder directly — its
   uv shebang must be respected so never invoke it via `python3`:
   ```bash
   ./scripts/build_ics.py spec.json -o <name>.ics
   ```
   If you can't do that, use `uv run`.

## The JSON spec

```json
{
  "filename": "evening-of-shorts",
  "events": [
    {
      "summary": "An Evening of Shorts",
      "date": "2026-06-12",
      "start": "19:00",
      "end": "22:30",
      "timezone": "America/New_York",
      "location": "eyedrum, 515 Ralph David Abernathy Blvd SW, Atlanta, GA 30312",
      "description": "Optional longer blurb",
      "url": "https://optional-event-page",
      "reminders": ["-PT1H"],
      "all_day": false
    }
  ]
}
```

Field notes:
- `summary` and `date` (YYYY-MM-DD) are required. Unknown fields are rejected.
- `start` and `end` must be `"HH:MM"` in 24-hour time (zero-padded). Convert
  anything the user wrote — `"7 PM"`, `"7:00 PM"`, `"19:00"` — to that form
  before writing the spec. If `start` is omitted on a timed event, it defaults
  to `"00:00"`. If `end` is missing, pass `duration_minutes`, or the script
  defaults to a 1-hour event. If `end` is earlier than `start`, the script
  assumes it crosses midnight and rolls to the next day.
- `end_date` (YYYY-MM-DD) is only needed for timed events that end on a later
  calendar day than `date` — pair it with `end` (a time). For midnight-crossing
  events to the next day, just give `end` and the script rolls forward
  automatically; use `end_date` only when the gap is more than one day.
- Omit `timezone` only when you truly can't determine one (see below).
- `reminders` is a list of ISO 8601 duration strings, negative for "before"
  (e.g. `"-PT1H"`, `"-PT30M"`, `"-P1D"`, `"-PT15M"`). Translate any phrasing
  the user gives into this form before writing the spec. Only include it if
  the user asks for a reminder.
- For a multi-day all-day event, set `all_day: true` and pass `end` as the
  YYYY-MM-DD day *after* the last day (ICS all-day ends are exclusive); the
  script handles single all-day events automatically. The `end` field on an
  all-day event must be a date — passing a time will error.
- `filename` (top-level, optional) sets the output basename when `-o` isn't
  passed; defaults to a slug of the first event's summary.

Put several events in the `events` array to produce one file containing all of
them (good for a festival lineup or a class schedule). Make separate files only
if the user wants separate downloads.

## Timezones

A venue event happens at a wall-clock local time — "7 PM at this address" — so
pin that local time by giving the script the IANA timezone name.

Infer the IANA zone from the location using what you know about the world:
- Atlanta, GA → `America/New_York`
- Los Angeles → `America/Los_Angeles`
- London → `Europe/London`
- Seoul → `Asia/Seoul`
- Sydney → `Australia/Sydney`

The script derives the correct offset and daylight-saving rules from the name,
so never compute offsets yourself — just identify the city/region. If the
text gives an explicit timezone abbreviation (PST, CET) or a UTC offset, map it
to the closest IANA name.

If there's genuinely no location and no timezone hint, omit `timezone`. The
script then writes a *floating* time (no zone), which every calendar interprets
as the viewer's own local time — usually the right fallback. Mention you did
this so the user can correct it.

## What to tell the user

After presenting the file, keep it short. Worth mentioning when relevant:
- Long `SUMMARY`/`LOCATION` lines wrap mid-word with a leading space — that's
  required ICS line folding, not a typo.
- **Reminders and import:** if the user mentioned a reminder, note that some
  apps ignore `VALARM` data on import. Fastmail in particular does not import
  alarms from `.ics` files (its docs say alarms must be set up manually after
  importing), and Google Calendar applies its own default instead. Apple
  Calendar, Outlook, and Thunderbird honor the embedded reminder. So the alarm
  is in the file and works in many apps, but for Fastmail they'll set it by hand.

Don't over-explain. The user wants the file, not a tutorial.

## Examples

**Single venue event with a reminder**

Input: *"An Evening of Shorts — Friday, June 12, 2026, 7:00 PM–10:30 PM,
eyedrum, 515 Ralph David Abernathy Blvd SW, Atlanta, GA 30312. Add a 1-hour
reminder."*

→ One event, `timezone: "America/New_York"` (Atlanta), `reminders: ["-PT1H"]`,
filename like `evening-of-shorts`. After presenting, note the Fastmail alarm
caveat since a reminder was requested.

**Festival lineup → one file, several events**

Input: a pasted multi-day lineup with a band per night at the same venue.

→ One spec with multiple entries in `events`, all sharing the venue's timezone,
one combined `.ics` the user can import in a single action.

**No location given**

Input: *"team sync, June 3 at 10am for 30 min."*

→ Omit `timezone` (floating time), `duration_minutes: 30`. Tell the user it's
set to floating local time and to add a zone if the meeting spans regions.
