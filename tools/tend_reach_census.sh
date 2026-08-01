#!/bin/sh
# tend_reach_census — reach instrument, method v2 (self-mention excluded).
# Seated at Q52 (v1); upgraded e198: a file whose only mention is its own
# body now counts ORPHAN — the stricter subtraction v1 stated as owed.
# Output shape (held for the witness): method line · one line per room
# "room tracked=N orphans=M" · one TOTAL line.
set -e
cd "$(git rev-parse --show-toplevel)"
git ls-files > /tmp/trc_all.txt
# One pass: (file:name) pairs, unique, for every basename-shaped token.
rg -o --no-heading -H '[A-Za-z0-9_.-]+\.(md|bron|rish|rye|glow|sh)' $(cat /tmp/trc_all.txt | tr '\n' ' ') 2>/dev/null | sort -u > /tmp/trc_pairs.txt
# Distinct-file mention count per name.
awk -F: '{print $2}' /tmp/trc_pairs.txt | sort | uniq -c | awk '{print $2" "$1}' > /tmp/trc_counts.txt
echo "method v2-self-mention-excluded"
total_orphans=0; total_files=0
for room in session-logs counsel waymarks expanding-prompts active-designing docs-geode; do
  [ -d "$room" ] || continue
  files=0; orphans=0
  for f in $(git ls-files "$room"); do
    files=$((files+1))
    b=$(basename "$f")
    c=$(awk -v n="$b" '$1==n {print $2; exit}' /tmp/trc_counts.txt)
    [ -n "$c" ] || c=0
    if [ "$c" -eq 0 ]; then
      orphans=$((orphans+1))
    elif [ "$c" -eq 1 ]; then
      # The single mentioning file: itself means orphan, another means reached.
      src=$(grep -m1 -F ":$b" /tmp/trc_pairs.txt | awk -F: '{print $1}')
      if [ "$src" = "$f" ]; then orphans=$((orphans+1)); fi
    fi
  done
  echo "$room tracked=$files orphans=$orphans"
  total_orphans=$((total_orphans+orphans)); total_files=$((total_files+files))
done
echo "TOTAL rooms_files=$total_files orphans=$total_orphans"
