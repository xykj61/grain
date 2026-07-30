#!/bin/sh
# tools/fixtures/reds_ledger_scan.sh — every red carries its three fields.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value · detail: prefixed · verdict= its own key · status agrees.
#
# Voice v9 · slot 9 · happy_zone_witnesses_first (second appearance this journey).
#
# A red with fewer than three fields teaches nothing: what went wrong, what
# caught it, what it taught. This guard also refuses "I noticed" in the caught
# column, because the whole value of that column is naming the instrument.
set -eu
f="${1:-work-in-progress/REDS.md}"
[ -f "$f" ] || { echo "verdict=missing_ledger"; exit 2; }

rows=0
thin=0
vague=0
# Rows are table lines beginning with a digit cell.
while IFS= read -r line; do
  case "$line" in
    '| '[0-9]*'|'*) : ;;
    *) continue ;;
  esac
  rows=$((rows + 1))
  # Four pipes minimum: | n | what | caught | taught |
  cells=$(printf '%s' "$line" | tr -cd '|' | wc -c | tr -d ' ')
  if [ "$cells" -lt 5 ]; then
    echo "detail: row missing a field -> $(printf '%s' "$line" | cut -c1-58)"
    thin=$((thin + 1))
  fi
  case "$line" in
    *'I noticed'*|*'i noticed'*|*'realized'*)
      echo "detail: caught-column names no instrument -> $(printf '%s' "$line" | cut -c1-58)"
      vague=$((vague + 1)) ;;
  esac
done < "$f"

bytes=$(wc -c < "$f" | tr -d ' ')
echo "rows=$rows"
echo "thin_rows=$thin"
echo "vague_rows=$vague"
echo "bytes=$bytes"
echo "living_pin_max_bytes=24576"
if [ "$bytes" -gt 24576 ]; then
  echo "detail: ledger past the living-pin bound; fold closed seasons to archive"
  echo "verdict=past_bound"; exit 1
fi
if [ "$rows" -eq 0 ]; then echo "verdict=no_rows"; exit 1; fi
if [ "$thin" -eq 0 ]; then
  if [ "$vague" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
fi
echo "verdict=incomplete_rows"
exit 1
