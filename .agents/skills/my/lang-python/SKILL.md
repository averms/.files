---
name: lang-python
description: Python coding rules. Use whenever reviewing, writing, or editing Python code — covers general advice, comment usage, docs, error handling, and Python 3.14 conventions.
---

# Python

Rules to apply whenever reviewing, creating or modifying Python files.

## Comments

- Do not use comments to demarcate sections of a file. No banner comments, no `# --- Helpers ---`, no `# ======` dividers. Organize code with module structure and naming instead.

## Docstrings

- Do not add docstrings to private functions (names starting with `_`).
- Only add a docstring if it says more than a restatement of the function or class name. If the docstring would just be `"""Get the user."""` on `get_user`, omit it entirely.
- Formatting inside docstrings should be CommonMark but kept minimal. No headings, just simple stuff that's readable in raw form, e.g., code spans and shortcut reference links.

## Exceptions

- Exception messages are lowercase (except proper nouns) with no ending punctuation.

```python
# Good
raise ValueError("expected a non-empty taxonomy for Neo4j ingestion")

# Bad
raise ValueError("Expected a non-empty taxonomy.")
```

## Error handling

When to catch exceptions: catch at the level where you can do something meaningful about them.

- At the lowest level, catch only exceptions you can handle concretely: retrying a transient network error, translating a dependency's exception into your own exception type, or adding context via `add_note()`.
- At the top level, have a catch-all safety net. FastAPI provides this for you — don't add another.
- Everywhere in between, let exceptions propagate.

Where to log: log at the point the exception is handled, and log once per exception.

- Never catch-log-reraise. Instead, either catch and raise a different, more detailed exception, or catch and add context via `add_note()`.

```python
# Good — translate with context
try:
    record = client.fetch(record_id)
except DependencyError as e:
    raise IngestionError(f"failed to fetch record {record_id}") from e

# Good — annotate and propagate
try:
    record = client.fetch(record_id)
except DependencyError as e:
    e.add_note(f"while fetching record {record_id}")
    raise

# Bad — catch-log-reraise (the handler will log it again)
try:
    record = client.fetch(record_id)
except DependencyError:
    logger.exception("failed to fetch record")
    raise
```

## General advice

Never add `from __future__ import annotations` — it is unnecessary.

Import at the top of the file, not inside functions.

Use modern syntax freely: `X | None` unions, builtin generics (`list[str]`, `dict[str,
int]`), `match` statements, etc.

Practice type-driven design: use dataclasses, make invalid states
unrepresentable, and parse instead of validating
