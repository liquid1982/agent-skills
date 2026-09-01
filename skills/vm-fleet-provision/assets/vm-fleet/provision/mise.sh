#!/usr/bin/env bash
set -euo pipefail

version="2026.9.0"

case "$(uname -m)" in
  aarch64 | arm64)
    platform="linux-arm64"
    sha256="0b5c4586353010378d9caca62c95166588c3dc4e310eb2d276aac1068397faec"
    ;;
  x86_64 | amd64)
    platform="linux-x64"
    sha256="c9b089f2be1db4d4262eacaf367e480e7a328848adcc37d9d1612996902485d0"
    ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

destination="$HOME/.local/bin/mise"

if [[ ! -x "$destination" ]] || [[ "$("$destination" --version)" != "$version "* ]]; then
  download="$(mktemp)"
  trap 'rm -f "$download"' EXIT
  curl -fsSL "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-${platform}" -o "$download"
  printf '%s  %s\n' "$sha256" "$download" | sha256sum --check --status
  install -D -m 0755 "$download" "$destination"
fi

"$destination" --version
