#!/usr/bin/env bash
set -eu

SKILL_LOCK="$HOME/.agents/.skill-lock.json"

while read -r name source; do
    if [ "${1:-}" = --dry-run ]; then
        echo "skills add $source --skill $name"
    else
        npx -y skills add "$source" -g --agent zed --skill "$name" --yes </dev/null
    fi
done < <(jq -r '.skills | to_entries[] |
    "\(.key) \(.value.source)/\(.value.skillPath | rtrimstr("/SKILL.md"))"' "$SKILL_LOCK")
