#!/bin/sh
# two_rooms_doorway_roster.sh — glob helper for doorway scan (preserves shell glob order).
for f in external-research/*.md active-designing/*.md docs/*.md; do
  [ -f "$f" ] || continue
  case "$f" in */README.md) continue ;; esac
  echo "$f"
done
