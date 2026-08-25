#!/usr/bin/env bash
# prin_ticker.sh -- foundations + edu closing lines as a stock-ticker / slideshow.
# Companion side panel for %prin. Matches edu: learn - build - gather - rest.

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

LINES="${PRIN_VERSE:-$ROOT/tools/fixtures/prin_verse_lines.txt}"
INTERVAL="${PRIN_TICKER_INTERVAL:-8}"
MODE="${1:-slide}"   # slide | scroll | once
G=$'\033[32m'; C=$'\033[36m'; M=$'\033[35m'; D=$'\033[2m'; B=$'\033[1m'; Z=$'\033[0m'
HEART=$'\xe2\x9d\xa4'

mapfile -t ROWS < <(grep -v '^#' "$LINES" | grep -v '^$' || true)
n=${#ROWS[@]}
if [ "$n" -eq 0 ]; then
  echo "prin_ticker: no verse lines in $LINES" >&2
  exit 1
fi

show_one() {
  local idx="$1" row text src
  row="${ROWS[$idx]}"
  text="${row%%	*}"
  src="${row#*	}"
  clear 2>/dev/null || printf '\033[2J\033[H'
  printf '%s╭─ Prin verse · edu ticker ─╮%s\n' "$M$B" "$Z"
  printf '%s│%s %s%d/%d%s  %s%s%s\n' "$M" "$Z" "$C" "$((idx+1))" "$n" "$Z" "$D" "$src" "$Z"
  printf '%s╰───────────────────────────╯%s\n\n' "$M$B" "$Z"
  printf '%s%s%s\n\n' "$G$B" "$text" "$Z"
  printf '%s%s learn · build · gather · rest — the shape of a day%s\n' "$D" "$HEART" "$Z"
  printf '%s[interval %ss · mode %s]%s\n' "$D" "$INTERVAL" "$MODE" "$Z"
}

scroll_one() {
  local idx="$1" row text src
  row="${ROWS[$idx]}"
  text="${row%%	*}"
  src="${row#*	}"
  printf '\r%s%s%s  %s· %s%s   ' "$G" "$text" "$Z" "$D" "$src" "$Z"
}

i=0
case "$MODE" in
  once)
    show_one 0
    ;;
  scroll)
    while true; do
      scroll_one "$i"
      i=$(( (i + 1) % n ))
      sleep "$INTERVAL"
    done
    ;;
  slide|*)
    while true; do
      show_one "$i"
      i=$(( (i + 1) % n ))
      sleep "$INTERVAL"
    done
    ;;
esac
