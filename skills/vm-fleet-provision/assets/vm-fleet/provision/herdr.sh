#!/usr/bin/env bash
set -euo pipefail

version="0.8.2"

case "$(uname -m)" in
  aarch64 | arm64)
    asset="herdr-linux-aarch64"
    sha256="f55610658e1c2e0d2aaef730b4b2ab885f7f8ba00285ab372bfb14f2e3d5b40d"
    ;;
  x86_64 | amd64)
    asset="herdr-linux-x86_64"
    sha256="976150a14d490c94b243ea2e1a7eb2dfb67f12e36b182db90936f6728e6aecf4"
    ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

destination="$HOME/.local/bin/herdr"

if [[ -x "$destination" ]]; then
  installed_version="$("$destination" --version)"
  if [[ "$installed_version" == *"$version"* ]]; then
    printf '%s\n' "$installed_version"
    exit 0
  fi
fi

download="$(mktemp)"
trap 'rm -f "$download"' EXIT

curl -fsSL "https://github.com/herdrdev/herdr/releases/download/v${version}/${asset}" -o "$download"
printf '%s  %s\n' "$sha256" "$download" | sha256sum --check --status
install -D -m 0755 "$download" "$destination"
"$destination" --version
