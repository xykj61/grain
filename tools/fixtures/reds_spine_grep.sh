#!/bin/sh
# tools/fixtures/reds_spine_grep.sh -- does the REDS ledger record this text, anywhere in its spine?
#
# WHY THIS FILE EXISTS. Twenty-one call sites across the season scans asked the LIVING PIN for a
# lesson's own words -- `rg -qi 'on-touch|campaign|ladder' "$REDS"` -- and each began refusing on the
# lap the row carrying those words folded onto a shelf under `construction/archive/`. Same root as
# the row-number half in tools/fixtures/reds_row_present.sh, one line further down each scan: a fold
# repoints documents and leaves guards standing, because a guard's citation is code rather than a
# link (REDS %231).
#
# The spine's file set is spelled once, in tools/fixtures/reds_spine_files.sh, and this asks that
# script for it rather than repeating the glob.
#
#   sh tools/fixtures/reds_spine_grep.sh 'a pattern'        # exit 0 when the spine records it
#   sh tools/fixtures/reds_spine_grep.sh -i 'a pattern'     # case-insensitively
#   sh tools/fixtures/reds_spine_grep.sh -i 'pat' --say     # and print which file recorded it
#
# Exit 0 present - 1 absent - 2 misuse. A misuse exits DIFFERENTLY from an absence, so a caller
# never reads an empty argument as a lesson the ledger has lost.
set -eu

CASE=
if [ "${1:-}" = "-i" ]; then CASE=-i; shift; fi
PAT=${1:-}
SAY=${2:-}

if [ -z "$PAT" ]; then
  echo "verdict=misuse detail=want_pattern"
  exit 2
fi

files=$(sh tools/fixtures/reds_spine_files.sh) || {
  echo "verdict=misuse detail=no_spine_files"
  exit 2
}

found=
for f in $files; do
  if grep -Eq $CASE -- "$PAT" "$f" 2>/dev/null; then
    found=$f
    break
  fi
done

if [ -z "$found" ]; then
  echo "verdict=absent"
  exit 1
fi

if [ "$SAY" = "--say" ]; then
  echo "verdict=present file=${found}"
fi
exit 0
