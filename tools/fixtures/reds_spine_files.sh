#!/bin/sh
# tools/fixtures/reds_spine_files.sh -- which files are the REDS ledger's spine, right now?
#
# WHY THIS FILE EXISTS. The ledger folds: `construction/REDS.md` keeps the rows still flat and every
# elder row moves onto a shelf under `construction/archive/`. So "the ledger" is a SET of files, and
# which file holds row 42 changes every time the pin folds. Two readings ask about that set --
# reds_row_present.sh for a row number and reds_spine_grep.sh for a lesson's text -- and a set
# spelled twice is a set two files may come to disagree about (REDS %231).
#
# So the set is spelled once, here, and both readings ask this script for it. The shelves come
# first and the living pin last, which is fold order and therefore reading order.
#
#   sh tools/fixtures/reds_spine_files.sh          # one path per line
#   REDS_SPINE_GLOB="pen/*.md" sh ...              # for a control's pen
#
# Exit 0 with at least one file, 2 when the glob names nothing that exists -- because a reading that
# answers "absent" over an empty set is reporting its own blindness rather than the ledger's
# contents, which is REDS %97's shape.
set -eu

SPINE=${REDS_SPINE_GLOB:-"construction/archive/REDS-*rows-*.md construction/REDS.md"}

n=0
for f in $SPINE; do
  [ -f "$f" ] || continue
  echo "$f"
  n=$((n + 1))
done

if [ "$n" -eq 0 ]; then
  echo "verdict=misuse detail=no_spine_files glob=${SPINE}" >&2
  exit 2
fi
