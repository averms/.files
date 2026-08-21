---
name: linear-walkthrough
description: Write a linear walkthrough of a codebase or specific part of a codebase. Use when the user asks for a linear walkthrough.
---

# Linear Walkthrough Skill

Use this skill when the user asks you to explain how some part of a codebase
works in a linear, narrative form. The deliverable is a markdown file built
with `uvx showboat` that interleaves commentary with executed shell commands
that print real code snippets from the repo. The result is reproducible:
anyone can run `uvx showboat verify <file>` to confirm the snippets still
match the source.

## Process

1. **Understand the topic.** Clarify what `{{topic}}` is — a feature, a
   module, a code path, an algorithm. If it's ambiguous, ask before reading.
2. **Read the source first.** Use `read`, `rg`, `find`, etc. to locate the
   relevant files and trace the code path end to end. Do this *before*
   writing any showboat commands so the walkthrough has a clear arc.
3. **Plan a linear path.** Decide the order in which a reader should
   encounter the code: entry point → call sites → core logic → supporting
   helpers → edge cases. Walkthroughs are linear, not hierarchical.
4. **Build the document with showboat.** Pick a `{{file_name}}.md` (e.g.
   `auth-walkthrough.md`) inside the repo. Run `uvx showboat init` then
   alternate `note` (commentary) and `exec` (snippets) entries.
5. **Verify at the end.** Run `uvx showboat verify <file>` to confirm every
   captured snippet still matches the source. If it fails, investigate
   (the source may have moved) and re-run rather than blindly accepting.

## Including code snippets

When showing code from the repo, **never trim lines out of the middle of a
snippet without an explicit heading separating the pieces**. A reader should
be able to trust that a snippet is contiguous unless told otherwise.

The preferred pattern for a snippet is:

```
printf '{{heading}}\n'
nl -ba {{file path}} | sed -n '{{starting line}},{{ending line}}p'
```

- `printf` gives the snippet a clear in-document heading.
- `nl -ba` numbers every line (including blanks) so the reader can correlate
  with the file on disk.
- `sed -n 'A,Bp'` extracts a contiguous range.

If you genuinely need to skip lines (e.g. a giant import block), do it as
two separate `exec` calls each with its own `printf` heading, so the gap
is visible to the reader.

For short, surgical lookups (a single function signature, a constant) it's
fine to use `grep -n` instead:

```
printf '{{heading}}\n'
grep -n '{{pattern}}' {{file path}}
```

## Workflow tips

- Use `--workdir` if running showboat from outside the repo, so relative
  paths in snippets resolve correctly.
- If a command produces noisy or wrong output, use `uvx showboat pop` to
  remove the last entry and try again.
- Pipe long commentary via stdin: `echo "..." | uvx showboat note file.md`.
- At the end, run `uvx showboat extract <file>` if the user wants to see
  the recipe that built the document.

## Documentation for `uvx showboat`

Run `uvx showboat --help` to get the full documentation for the tool. Always do this
before anything else.
