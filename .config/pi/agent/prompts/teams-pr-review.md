---
description: Draft a Teams message asking teammates to review my open PRs, and copy it to the clipboard as rich text
argument-hint: "[further instructions]"
---

Compose a Teams message asking my teammates to review my open PRs in the current
repo, then put it on the macOS clipboard as rich text so it pastes into Teams
with real headings and clickable hyperlinks.

## Step 1: gather the PRs

```
gh pr list --author "@me" --state open --json number,title,url,body,isDraft,additions,deletions,changedFiles --limit 50
```

- Skip drafts unless I say otherwise (mention you skipped them if any exist).
- If there are no open PRs, say so and stop.

## Step 2: compose the message as Markdown

The file is throwaway, so make a fresh scratch directory for it with `mktemp -d`
and write the Markdown there. Content rules:

- Opening paragraph: friendly greeting, how many PRs, the repo name (NOT bolded,
  plain text), and a note about which PRs are stacked and what order to review
  them in. Detect stacks from `<!-- start jj-vine stack -->` comment blocks in
  PR bodies.
- One section per PR, with:
  - A level 2 heading that is a hyperlink, and nothing else:
    `## [#<number> — <title>](<url>)`. No leading number or counter, and do NOT
    add `**` around it — pandoc already renders headings bold and larger in the
    RTF, so bold markup is redundant.
  - A size line in italics using the `additions`/`deletions`/`changedFiles`
    fields, e.g. `*(+120 −45 across 6 files)*`. Append the stack position here
    when applicable, e.g. `(stack 1 of 2)`.
  - The full PR body, verbatim Markdown. The only content change allowed: strip
    HTML comments and the stack block, represent stack info in the visible text
    instead.
- Close with a short thanks.

Markdown formatting constraints. These govern the text you write (opening
paragraph, headings, size lines, closing). PR bodies pass through verbatim and
are exempt: if a body contains a code span, table, or heading, leave it
byte-for-byte and accept whatever the RTF does with it.

- Plain GitHub-flavored Markdown only — no raw HTML. pandoc's `gfm` reader will
  pass raw HTML through untouched into the RTF, where it shows up as literal
  angle brackets.
- Blank line between blocks for a paragraph break; two trailing spaces for a
  line break inside a paragraph.
- Headings, italics, links, lists, and emoji survive the Markdown → RTF → Teams
  trip fine, including a link nested inside a heading.
- Code spans and fenced code blocks degrade to plain text in the RTF (no visible
  backticks). That is acceptable. Never strip backticks to "pre-degrade" them.
- Don't go deeper than `##`. The PR headings are the only structure needed; no
  `#` title and no `###` subsections.

## Step 3: copy as rich text and verify

```
pandoc <md-file> -f gfm -t rtf -s | pbcopy
osascript -e 'clipboard info'
```

Confirm the clipboard info output includes `«class RTF »`.

Finish by telling me it's on the clipboard ready to paste, remind me that Teams
may attach link preview cards for the PR links (dismissable with the X before
sending), and give the `open` command for the Markdown file as a fallback in
case Teams mangles the RTF paste.

$@
