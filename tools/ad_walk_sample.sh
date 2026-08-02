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
# ALSO SKIPPED: README.md — a living index, not a dated artifact. Its bare basename
# matches 703 files tree-wide, so counting its 'inbound references' measures the word
# README rather than the file (found live, e228). Verdicts belong to dated artifacts.

set -e
COUNT="${1:-4}"
cd "$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"

ls active-designing/*.md \
  | grep -v 'recursion' \
  | grep -v '/README.md$' \
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
      printf '%s\tinbound=%s\n' "$base" "$refs"
    done
