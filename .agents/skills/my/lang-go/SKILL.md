---
name: lang-go
description: >-
  Go coding rules. Use whenever reviewing, writing, or editing Go code — covers general
  advice, docs, etc.
---

Use `go doc foo.Bar` or `go doc -all foo` to read documentation for packages, types,
functions, etc.

To see source files from a dependency, which should be done whenever you have questions
that aren't answered by the docs, run `go mod download -json MODULE | jq -r .Dir` to
find the module's local path.

Use `go run .` or `go run ./cmd/foo` instead of `go build` to run programs.
