#!/usr/bin/env bash
set -euo pipefail

version="2.1.252"

case "$(uname -m)" in
  aarch64 | arm64)
    platform="linux-arm64"
    sha256="6c0b32eaa936954a0f4d4ad2595f8416af288d9b3cbaf19e3cdd9a95d7c8853e"
    ;;
  x86_64 | amd64)
    platform="linux-x64"
    sha256="a715a45105e593fc9808d035d77781f88480b9897975a9df41837f0c591bd4b3"
    ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

version_directory="$HOME/.local/share/claude/versions"
binary="$version_directory/$version"
destination="$HOME/.local/bin/claude"

if [[ ! -x "$binary" ]] || [[ "$("$binary" --version)" != "$version "* ]]; then
  download="$(mktemp)"
  trap 'rm -f "$download"' EXIT
  curl -fsSL "https://downloads.claude.ai/claude-code-releases/${version}/${platform}/claude" -o "$download"
  printf '%s  %s\n' "$sha256" "$download" | sha256sum --check --status
  install -D -m 0755 "$download" "$binary"
fi

launcher="$(mktemp)"
trap 'rm -f "${download:-}" "$launcher"' EXIT
printf '#!/usr/bin/env bash\nexport DISABLE_UPDATES=1\nexec "%s" "$@"\n' "$binary" > "$launcher"
rm -f "$destination"
install -D -m 0755 "$launcher" "$destination"
"$destination" --version
