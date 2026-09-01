#!/usr/bin/env bash
set -euo pipefail

host_skills_root="${1:?host skills root is required}"
manifest="${2:?skills manifest is required}"
targets=(
  "$HOME/.agents/skills"
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
  "$HOME/.config/opencode/skills"
  "$HOME/.pi/agent/skills"
  "$HOME/.grok/skills"
)

skills=()
while IFS= read -r skill; do
  skill="${skill%%#*}"
  skill="${skill#"${skill%%[![:space:]]*}"}"
  skill="${skill%"${skill##*[![:space:]]}"}"
  [[ -n "$skill" ]] || continue
  [[ "$skill" =~ ^[a-z0-9][a-z0-9-]*$ ]] || {
    echo "Invalid skill name: $skill" >&2
    exit 1
  }
  [[ -f "$host_skills_root/$skill/SKILL.md" ]] || {
    echo "Missing host skill: $host_skills_root/$skill/SKILL.md" >&2
    exit 1
  }
  skills+=("$skill")
done < "$manifest"

is_shared() {
  local candidate="$1"
  local skill
  for skill in "${skills[@]}"; do
    [[ "$candidate" == "$skill" ]] && return 0
  done
  return 1
}

for target in "${targets[@]}"; do
  mkdir -p "$target"

  while IFS= read -r link; do
    destination="$(readlink "$link")"
    [[ "$destination" == "$host_skills_root/"* ]] || continue
    is_shared "$(basename "$link")" || rm -f "$link"
  done < <(find "$target" -mindepth 1 -maxdepth 1 -type l -print)

  for skill in "${skills[@]}"; do
    source="$host_skills_root/$skill"
    link="$target/$skill"
    if [[ -e "$link" && ! -L "$link" ]]; then
      echo "Refusing to replace unmanaged path: $link" >&2
      exit 1
    fi
    ln -sfn "$source" "$link"
    [[ -f "$link/SKILL.md" ]]
  done
done

if ((${#skills[@]})); then
  printf 'Shared skills: %s\n' "${skills[*]}"
else
  echo "Shared skills: none"
fi
