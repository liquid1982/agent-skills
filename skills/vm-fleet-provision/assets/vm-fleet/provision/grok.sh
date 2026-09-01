#!/usr/bin/env bash
set -euo pipefail

version="1.0.13"

case "$(uname -m)" in
  aarch64 | arm64)
    platform="linux-aarch64"
    sha256="eb34ea3d88ed81d3526c137307aaa21d59d4c9983e722c0d07651234733bd2d8"
    ;;
  x86_64 | amd64)
    platform="linux-x86_64"
    sha256="1ce35694ecd8c9af4af7d89431bd3db4efbf5a6645391095a018c18a5c7710a4"
    ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

binary="$HOME/.local/share/grok/versions/$version/grok"
destination="$HOME/.local/bin/grok"

if [[ -x "$binary" ]] && [[ "$("$binary" --version)" == *"$version"* ]]; then
  mkdir -p "$HOME/.local/bin"
  rm -f "$destination"
  printf '#!/usr/bin/env bash\nexec "%s" "$@"\n' "$binary" > "$destination"
  chmod 0755 "$destination"
  "$destination" --version
  exit 0
fi

archive="$(mktemp)"
executable="$(mktemp)"
trap 'rm -f "$archive" "$executable"' EXIT

curl -fsSL "https://x.ai/cli/grok-${version}-${platform}.gz" -o "$archive"
printf '%s  %s\n' "$sha256" "$archive" | sha256sum --check --status
gzip -dc "$archive" > "$executable"
install -D -m 0755 "$executable" "$binary"
mkdir -p "$HOME/.local/bin"
rm -f "$destination"
printf '#!/usr/bin/env bash\nexec "%s" "$@"\n' "$binary" > "$destination"
chmod 0755 "$destination"
"$destination" --version
