#!/bin/bash
# Stop every effect started by launch.sh and close its panes.
set -uo pipefail
ANCHOR="${1:-${HERDR_PANE_ID:?HERDR_PANE_ID not set}}"
STATE="${XDG_CACHE_HOME:-$HOME/.cache}/scifi/${ANCHOR//:/_}.ids"
[ -f "$STATE" ] || { echo "scifi: no state file for $ANCHOR ($STATE)" >&2; exit 1; }
while read -r p; do [ -n "$p" ] && herdr pane send-keys "$p" ctrl+c >/dev/null 2>&1; herdr pane send-keys "$p" q >/dev/null 2>&1; done < "$STATE"
sleep 1
n=0; while read -r p; do [ -n "$p" ] && herdr pane close "$p" >/dev/null 2>&1 && n=$((n+1)); done < "$STATE"
rm -f "$STATE"; echo "scifi: closed $n panes"
