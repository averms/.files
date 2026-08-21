---
name: fetch-to-markdown
description: >
  Fetch a URL and convert it to Markdown, so a web page can be read, quoted, or
  processed as plain text. Use this whenever the user wants to pull down, fetch, read,
  or convert a web page/URL into Markdown (or grab the text content of a link). Also
  handles local files (PDF/DOCX/PPTX/HTML/etc.)
disable-model-invocation: true
---

# Fetch to Markdown

Turn a URL into **Markdown** so it can be inspected, quoted, or processed like
normal text. `markitdown` fetches the URL and converts it for you.

## Quick usage

Convert a URL to Markdown (prints to stdout):

```bash
uvx --from 'markitdown[pdf]' markitdown <url>
```

The `markitdown[pdf]` extra is included on purpose: many URLs (for example
arXiv links) only reveal that they are PDFs after fetching, so extension-based
detection is unreliable. Including the PDF extra makes PDF URLs work
consistently.

## Saving output

For long pages, redirect to a file so you can open and inspect the full
content:

```bash
uvx --from 'markitdown[pdf]' markitdown <url> > /var/tmp/doc.md
```

## Local files

The same command also converts local files (PDF, DOCX, PPTX, HTML, etc.):

```bash
uvx --from 'markitdown[pdf]' markitdown ./spec.pdf > /var/tmp/spec.md
```
