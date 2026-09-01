#!/usr/bin/env bash
set -euo pipefail

version="0.151.0"
installer_sha256="ba92dd27e5c06f0d3bbc58bfa4b9cfb6599cd2742fbb1f92a2765e6c07dedb5a"
destination="$HOME/.local/bin/codex"

if [[ -x "$destination" ]]; then
  installed_version="$("$destination" --version)"
  if [[ "$installed_version" == *"$version"* ]]; then
    printf '%s\n' "$installed_version"
    exit 0
  fi
fi

installer="$(mktemp)"
trap 'rm -f "$installer"' EXIT

curl -fsSL "https://releases.openai.com/codex/releases/${version}/install.sh" -o "$installer"
printf '%s  %s\n' "$installer_sha256" "$installer" | sha256sum --check --status
CODEX_NON_INTERACTIVE=1 sh "$installer" --release "$version"
"$destination" --version
