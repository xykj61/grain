#!/bin/sh
# radiant_select_wave.sh -- oldest untouched in-scope paths for the next wave.
# Seated 20260725.110354 - bound default 50.
#
#   sh tools/fixtures/r/radiant_select_wave.sh [count]
set -eu

# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT"

BOUND=${1:-50}
LEDGER="tools/fixtures/r/radiant_pass_ledger.txt"
POOL=$(mktemp)
CAND=$(mktemp)
LED=$(mktemp)
trap 'rm -f "$POOL" "$CAND" "$LED"' EXIT

{
  find active-designing external-research expanding-prompts counsel \
    classical-vedic-astrology context work-in-progress waymarks foundations manual edu \
    -type f -name '*.md' ! -path '*/archive/*' 2>/dev/null
  find . -maxdepth 1 -name '*.md' -type f 2>/dev/null
  find . -mindepth 2 -maxdepth 2 -name 'README.md' \
    ! -path './gratitude/*' ! -path './vendor/*' ! -path './session-logs/*' ! -path './.git/*' 2>/dev/null
} | sed 's|^\./||' | sort -u >"$POOL"

awk -F'\t' '/^[^#]/ && NF>=2 {print $1}' "$LEDGER" | sort >"$LED"

while IFS= read -r f; do
  [ -f "$f" ] || continue
  case "$f" in
    counsel/replies/*_re-radiant-wave*.md|waymarks/*_radiant-wave*.md)
      continue
      ;;
  esac
  if head -n 20 "$f" | grep -q 'Living twin:'; then
    continue
  fi
  if grep -qxF "$f" "$LED"; then
    continue
  fi
  echo "$f"
done <"$POOL" | awk -F/ '{
  n=$NF
  sub(/\.md$/, "", n)
  if (match(n, /^[0-9]{8}-[0-9]{6}/)) { key=substr(n,1,15) } else { key=n }
  print key " " $0
}' | sort -k1,1 | awk '{ $1=""; sub(/^ /,""); print }' | head -n "$BOUND"
