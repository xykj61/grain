#!/bin/sh
# tend_lap_check -- Q54's proof-machine (banked; the quest seats at lap time).
# Given a lap fixture root, prints "files=N orphans=M" by the census's own
# reach-by-mention v2 logic, scoped to plain files under the root.
# The lap witness calls this before and after a weave, then holds three laws:
#   delta   -- orphans fall by at least the woven count
#   nothing -- no file deleted (list identical)
#   sealed  -- a header-accreted file keeps its old bytes as a suffix
# Open note for the real lap: an in-place current-as-of header marks a file
# tended without creating reach; reach for recursions wants one index line
# too -- that seam waits Keaton's class-and-rooms word.
set -e
root="$1"
[ -n "$root" ] && [ -d "$root" ]
files=0; orphans=0
list=$(find "$root" -type f | sort)
for f in $list; do
  files=$((files+1))
  b=$(basename "$f")
  # Status captured before set -e can bite: an unmentioned name is a zero,
  # never a death -- grep -c exits 1 on zero matches by design.
  n=$(grep -rlF "$b" "$root" 2>/dev/null | grep -cv "^$f$" || true)
  [ -n "$n" ] || n=0
  if [ "$n" -eq 0 ]; then orphans=$((orphans+1)); fi
done
echo "files=$files orphans=$orphans"
