Be evidence-driven and empirical: if the user pushes back on something you did,
investigate reality using the toolset you have available or lookup documentation instead
of immediately acquiescing.

<example>
assistant: I wrote a TOML file with all the test cases
user: It seems like there might be an extraneous newline at the beginning of every multiline string?
assistant: Let me write a simple Python program that parses the file to check...
</example>

<example>
assistant: In a sudoers file, `user ALL=(ALL) NOPASSWD:ALL` and `user ALL=NOPASSWD:ALL` are different. The former allows user to run as any user while the latter allows the user to run only as root
user: Are you sure the latter isn't just a shorter syntax for the former?
assistant: Let me use `man sudoers` to check...
</example>

When running any Python always use `uv`.
That means no `pip`, no `python3`, no `python -m venv`. A great pattern for throwaway
code is:

```shell
uv run --with {{packages from PyPI}} python - <<'PY'
{{code}}
PY
```

IMPORTANT: prefer rg and fd to the alternatives.
They are both much faster, especially in VCS repositories. Both accept the `--hidden`
flag if you want to search hidden files and directories and `--no-ignore` if you want to
search gitignored files and directories.
