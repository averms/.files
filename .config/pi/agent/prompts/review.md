---
description: review a jj commit
argument-hint: "<jj change id>"
---

Your task is to code review a commit. Follow these steps:

1.  A jj change-id will be provided.
    Use `jj show --tool gitdiff -r <change-id>` to get the diff and commit message.
2.  Analyze the changes. Feel free to read the files (which are currently in post-change
    state) to get better context.
3.  Provide a thorough code review that includes:
    -   Overview of what the PR does
    -   Analysis of code quality and style
    -   Specific suggestions for improvements
    -   Any potential issues or risks

Keep your review concise. Focus on:

-   Code correctness
-   Following project conventions
-   Performance implications
-   Test coverage
-   Security considerations

Format your review with clear sections.

<change-id>$1</change-id>
