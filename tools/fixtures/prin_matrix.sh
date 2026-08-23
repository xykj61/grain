#!/usr/bin/env bash
# prin_matrix.sh — Matrix-style live view of Grain loops / parity / twin progress.
# Worker under tools/p/prin.rish (%prin · Prin). Outer terminal: source tools/p/prin_aliases.sh

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

MODE="${1:-matrix}"          # matrix | rain | once | love
INTERVAL="${PRIN_INTERVAL:-1}"
G=$'\033[32m'; C=$'\033[36m'; Y=$'\033[33m'; M=$'\033[35m'; R=$'\033[31m'; D=$'\033[2m'; B=$'\033[1m'; Z=$'\033[0m'
HEART=$'\xe2\x9d\xa4'

rain_line() {
  local w="${COLUMNS:-80}" i c
  local chars='01アイウエオカキクケコサシスセソ·*+░▒'
  local out=""
  for ((i=0; i<w; i++)); do
    c=${chars:RANDOM%${#chars}:1}
    out+="${G}${c}${Z}"
  done
  printf '%s\n' "$out"
}

verdict_color() {
  case "$1" in
    TWIN) printf '%s' "$G$B" ;;
    SLOW-BOTH) printf '%s' "$Y" ;;
    NONDET-TIME|NONDET-BUILD|WRITES-DETECTED) printf '%s' "$C" ;;
    RED|RED-TIME) printf '%s' "$R$B" ;;
    *) printf '%s' "$D" ;;
  esac
}

print_header() {
  local nib stamp love="${1:-}"
  nib=$(git rev-parse --short=10 HEAD 2>/dev/null || echo unknown)
  stamp=$(TZ=America/New_York date '+%Y%m%d.%H%M%S')
  printf '%s╭─ %%prin · Prin · Grain matrix ─╮%s\n' "$C$B" "$Z"
  printf '%s│%s nib %s%s%s  stamp %s%s%s' "$C" "$Z" "$G$B" "$nib" "$Z" "$D" "$stamp" "$Z"
  if [ -n "$love" ]; then printf '  %s%s bhakti%s' "$M" "$HEART" "$Z"; fi
  printf '\n'
  printf '%s╰────────────────────────────────╯%s\n' "$C$B" "$Z"
}

print_combined() {
  local f files=()
  shopt -s nullglob
  files=(work-in-progress/*_corpus-twin-verdicts*.tsv)
  shopt -u nullglob
  if [ ${#files[@]} -eq 0 ]; then
    printf '%s(no corpus-twin ledgers yet)%s\n' "$D" "$Z"
    return
  fi
  printf '%s── combined twin verdicts ──%s\n' "$B" "$Z"
  cat "${files[@]}" 2>/dev/null | cut -f2 | sort | uniq -c | while read -r n v; do
    printf '  %s%4s%s  %s%s%s\n' "$(verdict_color "$v")" "$n" "$Z" "$(verdict_color "$v")" "$v" "$Z"
  done
  local latest
  latest=$(ls -t work-in-progress/*_corpus-twin-verdicts*.tsv 2>/dev/null | head -1 || true)
  if [ -n "$latest" ]; then
    printf '%s── living ledger %s (%s lines) ──%s\n' "$B" "$latest" "$(wc -l < "$latest")" "$Z"
    tail -n 8 "$latest" | while IFS=$'\t' read -r script verdict ee ne rest; do
      printf '  %s%-14s%s %s\n' "$(verdict_color "$verdict")" "$verdict" "$Z" "$script"
    done
  fi
}

print_live_procs() {
  printf '%s── live rishi / rye / timeout ──%s\n' "$B" "$Z"
  local hit=0
  while IFS= read -r line; do
    hit=1
    printf '  %s›%s %s\n' "$G" "$Z" "$line"
  done < <(pgrep -af 'rishi|rye build|timeout 300' 2>/dev/null | grep -v 'pgrep\|prin_\|zsh -c snap' | head -12 || true)
  if [ "$hit" = 0 ]; then
    printf '  %s(quiet — no twin/rishi workers)%s\n' "$D" "$Z"
  fi
}

print_git() {
  printf '%s── pier ──%s\n' "$B" "$Z"
  git status -sb 2>/dev/null | head -6 | while read -r line; do
    printf '  %s%s%s\n' "$D" "$line" "$Z"
  done
}

frame() {
  local love=0
  [ "$MODE" = love ] && love=1
  [ "$MODE" = rain ] && rain_line
  clear 2>/dev/null || printf '\033[2J\033[H'
  print_header "$( [ "$love" = 1 ] && echo 1 )"
  print_combined
  print_live_procs
  print_git
  if [ "$love" = 1 ]; then
    printf '%s── %s devoted print — every green line is seva ──%s\n' "$M" "$HEART" "$Z"
  fi
  printf '%s[q in parent · Ctrl-C to leave · interval %ss · mode %s]%s\n' "$D" "$INTERVAL" "$MODE" "$Z"
}

case "$MODE" in
  once)
    MODE=matrix
    frame
    ;;
  matrix|rain|love)
    while true; do
      frame
      sleep "$INTERVAL"
    done
    ;;
  *)
    echo "usage: prin_matrix.sh [matrix|rain|love|once]" >&2
    exit 2
    ;;
esac
