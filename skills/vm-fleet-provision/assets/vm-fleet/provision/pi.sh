#!/usr/bin/env bash
set -euo pipefail

version="0.84.4"

case "$(uname -m)" in
  aarch64 | arm64)
    asset="pi-linux-arm64.tar.gz"
    sha256="135580f6b942151646e67b8b866d987d28ce3cff5a497030775ddd29659f943d"
    ;;
  x86_64 | amd64)
    asset="pi-linux-x64.tar.gz"
    sha256="c2f3c3e6a1850bd87654cc3ca8811013272397c3d042a4e2a64c43ee1b423972"
    ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

install_directory="$HOME/.local/share/pi/$version"
binary="$install_directory/pi"
destination="$HOME/.local/bin/pi"

if [[ -x "$binary" ]]; then
  installed_version="$("$binary" --version)"
  if [[ "$installed_version" == *"$version"* ]]; then
    mkdir -p "$HOME/.local/bin"
    rm -f "$destination"
    printf '#!/usr/bin/env bash\nexec "%s" "$@"\n' "$binary" > "$destination"
    chmod 0755 "$destination"
    printf 'pi %s\n' "$installed_version"
    exit 0
  fi
fi

archive="$(mktemp)"
extract_directory="$(mktemp -d)"
trap 'rm -f "$archive"; rm -rf "$extract_directory"' EXIT

curl -fsSL "https://github.com/earendil-works/pi/releases/download/v${version}/${asset}" -o "$archive"
printf '%s  %s\n' "$sha256" "$archive" | sha256sum --check --status
tar -xzf "$archive" -C "$extract_directory"
mkdir -p "$(dirname "$install_directory")" "$HOME/.local/bin"
rm -rf "$install_directory"
mv "$extract_directory/pi" "$install_directory"
chmod 0755 "$binary"
rm -f "$destination"
printf '#!/usr/bin/env bash\nexec "%s" "$@"\n' "$binary" > "$destination"
chmod 0755 "$destination"
printf 'pi %s\n' "$("$destination" --version)"
