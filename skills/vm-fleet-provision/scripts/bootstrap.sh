#!/usr/bin/env bash
set -euo pipefail

skill_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_project="$skill_root/assets/vm-fleet"
project="$HOME/Projects/vm-fleet"
check_only=0

usage() {
  cat <<'USAGE'
Usage: bootstrap.sh [--check] [--project PATH]

  --check         Check Mac host dependencies without creating files.
  --project PATH  Create the fleet project at PATH.
USAGE
}

while (($#)); do
  case "$1" in
    --check)
      check_only=1
      shift
      ;;
    --project)
      (($# >= 2)) || { echo "--project requires a path" >&2; exit 2; }
      project="$2"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$project" in
  '~') project="$HOME" ;;
  '~/'*) project="$HOME/${project#\~/}" ;;
esac

failures=0

check_command() {
  local command_name="$1"
  local guidance="$2"
  if command -v "$command_name" >/dev/null 2>&1; then
    printf 'OK      %s\n' "$command_name"
  else
    printf 'MISSING %s — %s\n' "$command_name" "$guidance"
    failures=$((failures + 1))
  fi
}

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "OK      macOS"
else
  echo "MISSING macOS — this revision supports OrbStack on macOS only"
  failures=$((failures + 1))
fi

check_command orb "install and open OrbStack: https://orbstack.dev/download"
check_command ssh "install the Apple Command Line Tools with: xcode-select --install"

if command -v orb >/dev/null 2>&1; then
  if orb status >/dev/null 2>&1; then
    echo "OK      OrbStack is running"
  else
    echo "ACTION  OrbStack is installed but stopped; run: orb start"
  fi
fi

if ((failures)); then
  echo
  echo "Preflight failed with $failures missing requirement(s)." >&2
  exit 1
fi

echo "OK      required Mac host dependencies"

((check_only)) && exit 0

if [[ -e "$project" || -L "$project" ]]; then
  echo "Refusing to overwrite existing path: $project" >&2
  echo "Use that project, choose another --project path, or move it yourself." >&2
  exit 1
fi

mkdir -p "$(dirname "$project")"
cp -R "$source_project" "$project"
chmod +x "$project/bin/apply" "$project"/provision/*.sh

printf '\nCreated %s\n\n' "$project"
echo "Next steps:"
echo "  1. Review $project/config/fleet.sh"
echo "  2. Run: cd $project && ./bin/apply plan"
echo "  3. Run: cd $project && ./bin/apply apply"
