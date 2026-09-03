#!/bin/bash
# Split the calling Herdr pane into a 10-pane sci-fi terminal wall and start an effect in each.
# Usage: launch.sh            (uses $HERDR_PANE_ID as the anchor pane)
set -euo pipefail
FX="$(cd "$(dirname "$0")" && pwd)"
[ "${HERDR_ENV:-}" = 1 ] || { echo "scifi: not running inside Herdr (HERDR_ENV != 1)" >&2; exit 1; }
ANCHOR="${1:-${HERDR_PANE_ID:?HERDR_PANE_ID not set}}"
command -v jq >/dev/null || { echo "scifi: jq is required" >&2; exit 1; }
STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/scifi"; mkdir -p "$STATE_DIR"
STATE="$STATE_DIR/${ANCHOR//:/_}.ids"
[ -f "$STATE" ] && { echo "scifi: already running for $ANCHOR (state: $STATE). Run teardown.sh first." >&2; exit 1; }

read -r W H < <(herdr pane layout --pane "$ANCHOR" | jq -r --arg p "$ANCHOR" '.result.layout.panes[] | select(.pane_id==$p) | "\(.rect.width) \(.rect.height)"')
[ "$W" -ge 120 ] && [ "$H" -ge 30 ] || { echo "scifi: anchor pane is ${W}x${H}; need at least 120x30" >&2; exit 1; }

sp() { herdr pane split --pane "$1" --direction "$2" --ratio "$3" --cwd "$PWD" --no-focus | jq -r '.result.pane.pane_id'; }
# --ratio is the share the ORIGINAL pane keeps.
R=$(sp "$ANCHOR" right 0.35)
L2=$(sp "$ANCHOR" down 0.55); L3=$(sp "$L2" down 0.5); L4=$(sp "$L3" right 0.5)
R2=$(sp "$R" down 0.5); R3=$(sp "$R2" down 0.5)
R2b=$(sp "$R2" right 0.33); R2c=$(sp "$R2b" right 0.5)
R3b=$(sp "$R3" right 0.33); R3c=$(sp "$R3b" right 0.5)
printf '%s\n' "$R" "$R2" "$R2b" "$R2c" "$R3" "$R3b" "$R3c" "$L2" "$L3" "$L4" > "$STATE"
sleep 1.5

if command -v btop >/dev/null; then MON="btop -p 3"; else MON="top -s 1 -o cpu"; fi   # btop default layout needs 35 rows; preset 3 fits 24
if command -v log >/dev/null && [ "$(uname)" = Darwin ]; then LOG="log stream --style compact --level info"
elif command -v journalctl >/dev/null; then LOG="journalctl -f -o short"; else LOG="tail -f /var/log/syslog"; fi

run() { herdr pane run "$1" "$2" >/dev/null; }
run "$R"   "$MON"
run "$R2"  "python3 $FX/matrix.py"
run "$R2b" "python3 $FX/intrusion.py"
run "$R2c" "python3 $FX/hex.py"
run "$R3"  "python3 $FX/crack.py"
run "$R3b" "$LOG"
run "$R3c" "bash $FX/netconn.sh"
run "$L2"  "python3 $FX/telemetry.py"
run "$L3"  "python3 $FX/radar.py"
run "$L4"  "python3 $FX/clock.py"
echo "scifi: 10 panes launched around $ANCHOR. State: $STATE"
