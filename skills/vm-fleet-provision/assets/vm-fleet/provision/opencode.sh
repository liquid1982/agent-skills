#!/usr/bin/env bash
set -euo pipefail

version="1.18.25"

case "$(uname -m)" in
  aarch64 | arm64)
    asset="opencode-linux-arm64.tar.gz"
    sha256="35ef77897425e41b5183a2c21ac4fb1d4d944d82a94e3c920f57b5490af11ac5"
    ;;
  x86_64 | amd64)
    asset="opencode-linux-x64-baseline.tar.gz"
    sha256="ccd10586611b598b1eaed7c05cfbcbc68e3ec09e736b360da09b1d615d922968"
    ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

destination="$HOME/.local/bin/opencode"

if [[ -x "$destination" ]]; then
  installed_version="$("$destination" --version)"
  if [[ "$installed_version" == *"$version"* ]]; then
    printf 'opencode %s\n' "$installed_version"
    exit 0
  fi
fi

archive="$(mktemp)"
extract_directory="$(mktemp -d)"
trap 'rm -f "$archive"; rm -rf "$extract_directory"' EXIT

curl -fsSL "https://github.com/anomalyco/opencode/releases/download/v${version}/${asset}" -o "$archive"
printf '%s  %s\n' "$sha256" "$archive" | sha256sum --check --status
tar -xzf "$archive" -C "$extract_directory"
install -D -m 0755 "$extract_directory/opencode" "$destination"
printf 'opencode %s\n' "$("$destination" --version)"
