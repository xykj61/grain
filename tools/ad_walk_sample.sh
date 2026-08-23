#!/bin/sh
# tools/ad_walk_sample.sh — the round's walkthrough sampler (e224).
#
#   sh tools/ad_walk_sample.sh [count]
#
# Draws a bounded sample from active-designing/, skipping SHELVED classes —
# named groups already ruled once, so the ritual stops re-finding the same
# shelf every round — and prints each file's inbound reference count, because
# the law says count before any verdict past KEEP.
#
# Reference counting excludes two rooms on purpose:
#   counsel/ and expanding-prompts/ — a verdict written about a file becomes a
#   reference to that file, so counting them lets discussion inflate the very
#   number the discussion depends on. The census is otherwise self-perturbing:
#   e137-recursion read 1 inbound before it was discussed and 4 after, with no
#   change in how the tree actually uses it (e224).
#
# SHELVED CLASSES (ruled once, standing KEEP):
#   *recursion*.md — the season's per-round baton trail, 45 files, ~29 KB whole.
#
# DATED ARTIFACTS ONLY: the draw keeps names matching YYYYMMDD-HHMMSS_sprig. Living
# docs — README.md, the hammocks, steep.md — are indexes, workbenches and standing
# name-seats, not finished pages, and none of the four verdicts belongs to them. Their
# bare basenames also break the count: README matched 703 files tree-wide, measuring the
# word rather than the file (found live at e228; generalized at e229 when the draw
# produced steep.md).
#
# AGE BESIDE THE COUNT (e230): each line prints the artifact's age in days from its own
# stamp. A brief at inbound=0 written yesterday is young, not abandoned, and no verdict
# past KEEP should ever rest on a low count without its age standing next to it.

set -e
COUNT="${1:-4}"
cd "$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"

ls active-designing/*.md \
  | grep -E '/[0-9]{8}-[0-9]{6}_' \
  | grep -v 'recursion' \
  | awk 'BEGIN{srand()} {print rand() "\t" $0}' \
  | sort -n \
  | head -n "$COUNT" \
  | cut -f2 \
  | while read -r f; do
      base=$(basename "$f" .md)
      refs=$(grep -rl "$base" --include='*.md' . 2>/dev/null \
             | grep -v '^./.git' \
             | grep -v '^./counsel/' \
             | grep -v '^./expanding-prompts/' \
             | grep -v "^$f\$" \
             | wc -l | tr -d ' ')
      stamp_day=$(echo "$base" | cut -c1-8)
      age_days=$(( ( $(date +%s) - $(date -d "$stamp_day" +%s 2>/dev/null || echo "$(date +%s)") ) / 86400 ))
      printf '%s\tinbound=%s\tage=%sd\n' "$base" "$refs" "$age_days"
    done
