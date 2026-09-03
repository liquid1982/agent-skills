#!/bin/bash
# Live TCP socket table (lsof on macOS/Linux, ss fallback), refreshed every 2s.
printf '\e[?25l'; trap 'printf "\e[?25h\e[0m"; exit' INT TERM
AWK='function emit(st, pr, ad) {
  gsub(/[()]/, "", st); sub(/\\.*/, "", pr); c = "\033[32m"
  if (st == "ESTABLISHED" || st == "ESTAB") c = "\033[1;92m"
  else if (st ~ /WAIT|CLOS|SYN/) c = "\033[33m"
  else if (st == "LISTEN") c = "\033[90m"
  printf "  %s%-11s\033[0m \033[36m%-10s\033[0m \033[35m%s\033[0m\n", c, st, substr(pr, 1, 10), substr(ad, 1, 16)
}
NR > 1 { if (mode == "lsof") emit($NF, $1, $(NF-1)); else emit($1, "sock", $5) }'
while :; do
  if command -v lsof >/dev/null; then out=$(lsof -nP -iTCP 2>/dev/null | awk -v mode=lsof "$AWK" | sort -r | uniq)
  else out=$(ss -tan 2>/dev/null | awk -v mode=ss "$AWK" | sort -r | uniq); fi
  printf '\e[H\e[2J\e[1;36m  ▌ ACTIVE SOCKETS :: %s\e[0m\n%s\n' "$(date +%T)" "$(printf '%s\n' "$out" | head -n $(( $(tput lines) - 2 )))"
  sleep 2
done
