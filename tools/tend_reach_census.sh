#!/bin/sh
# Q50 tend census — reach by mention: a room file is REACHED when its
# Seated at Q52 — the counsel reach-by-mention census as a standing instrument.
# Output: one line per room "room tracked=N orphans=M", then a TOTAL line.
# basename appears in at least one other tracked file; otherwise ORPHAN.
set -e
cd "$(git rev-parse --show-toplevel)"
git ls-files > /tmp/all_tracked.txt
# one pass: every basename-shaped token mentioned anywhere in tracked text
rg -o --no-filename -I '[A-Za-z0-9_.-]+\.(md|bron|rish|rye|glow|sh)' $(cat /tmp/all_tracked.txt | tr '\n' ' ') 2>/dev/null | sort -u > /tmp/mentions.txt
total_orphans=0; total_files=0
for room in session-logs counsel waymarks expanding-prompts active-designing docs-geode; do
  [ -d "$room" ] || continue
  files=$(git ls-files "$room" | wc -l)
  orphans=0
  for f in $(git ls-files "$room"); do
    b=$(basename "$f")
    n=$(grep -cxF "$b" /tmp/mentions.txt || true)
    # Known limit, stated: a file whose only mention is its own body still
    # counts reached; the stricter self-mention subtraction waits its own seat.
    if [ "$n" -eq 0 ]; then orphans=$((orphans+1)); fi
  done
  echo "$room tracked=$files orphans=$orphans"
  total_orphans=$((total_orphans+orphans)); total_files=$((total_files+files))
done
echo "TOTAL rooms_files=$total_files orphans=$total_orphans"
