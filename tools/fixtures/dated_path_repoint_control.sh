#!/bin/sh
# tools/fixtures/dated_path_repoint_control.sh -- the repointer proven on a tree with a known answer.
#
# WHY. tools/fixtures/dated_path_repoint_scan.sh EDITS FILES. Its whole safety rests on one rule --
# a file whose own basename carries a one-clock stamp is dated testimony and is never written to --
# and a rule that has never been tested is a rule nobody has kept. This builds four files whose
# right answers are known before the tool runs, applies the repointer, and prints what happened.
#
# THE FOUR CASES
#   living.md      cites a flat path whose file has folded          -> MUST be repointed
#   20260102-000000_testimony.md  cites the very same flat path     -> MUST be left untouched
#   already.md     cites the folded path directly                   -> MUST be left untouched
#   elsewhere.md   cites a dated path that never folded             -> MUST be left untouched
#
# EXPECTED: repointed_living=1 untouched_testimony=1 untouched_already=1 untouched_elsewhere=1
#
# Driven by tools/d/dated_path_repoint_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

mkdir -p "$work/room/date/20260101"
echo folded > "$work/room/date/20260101/20260101-000000_moved.md"
echo standing > "$work/room/20260103-000000_stayed.md"

printf 'see room/20260101-000000_moved.md for the reason\n' > "$work/living.md"
printf 'see room/20260101-000000_moved.md for the reason\n' > "$work/20260102-000000_testimony.md"
printf 'see room/date/20260101/20260101-000000_moved.md already\n' > "$work/already.md"
printf 'see room/20260103-000000_stayed.md which never folded\n' > "$work/elsewhere.md"

cd "$work"
sh "$root/tools/fixtures/dated_path_repoint_scan.sh" apply > /dev/null 2>&1 || true

living=0;    grep -q 'room/date/20260101/20260101-000000_moved.md' living.md && living=1
testimony=0; grep -q '^see room/20260101-000000_moved.md for the reason$' 20260102-000000_testimony.md && testimony=1
already=0;   [ "$(grep -c 'date/20260101/date' already.md || true)" = 0 ] && grep -q 'room/date/20260101/20260101-000000_moved.md already' already.md && already=1
elsewhere=0; grep -q '^see room/20260103-000000_stayed.md which never folded$' elsewhere.md && elsewhere=1

echo "repointed_living=$living"
echo "untouched_testimony=$testimony"
echo "untouched_already=$already"
echo "untouched_elsewhere=$elsewhere"

# Idempotence: a second apply must change nothing at all.
before=$(cat living.md already.md elsewhere.md 20260102-000000_testimony.md | cksum)
sh "$root/tools/fixtures/dated_path_repoint_scan.sh" apply > /dev/null 2>&1 || true
after=$(cat living.md already.md elsewhere.md 20260102-000000_testimony.md | cksum)
if [ "$before" = "$after" ]; then echo "idempotent=yes"; else echo "idempotent=no"; fi

if [ "$living" = 1 ] && [ "$testimony" = 1 ] && [ "$already" = 1 ] && [ "$elsewhere" = 1 ]; then
  echo "verdict=ok"
else
  echo "verdict=wrong"
  exit 1
fi
