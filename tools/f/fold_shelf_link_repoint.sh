#!/bin/sh
# fold_shelf_link_repoint.sh -- apply the repair the scan already computed.
#
# WHY THIS EXISTS RATHER THAN A HABIT. A shelf sits one directory below the pin it was folded out of,
# so every climbing link in it must gain a level. Nothing writes these shelves: a hand writes each
# one, which means every hand must remember, and in the week to `20260907` FOUR different hands did
# not -- the same fault arriving from a different direction each time, repaired by hand each time.
# A lantern that fires twice becomes a loom; this one fired four times.
#
# The repair was never the hard part. `fold_shelf_link_scan.sh list` prints
# `<file>\t<broken link>\t<repair>` for every one, and it only proposes a repair after confirming
# the corrected target EXISTS on disk. So the answer was already computed and a human was being asked
# to retype it -- six links across three spellings, on the night this was written.
#
#   sh tools/f/fold_shelf_link_repoint.sh            # show what would change, touch nothing
#   sh tools/f/fold_shelf_link_repoint.sh --apply    # rewrite the links
#
# WHAT IT WILL NOT DO, each refusal in the safe direction:
#   * It never invents a target. Only the scan's `repair` column is applied, and that column exists
#     only where the corrected path was proven present.
#   * It never touches a link the scan calls DEAD -- a broken link with no computed repair is a
#     reference that needs a reader, not a rewriter.
#   * It rewrites only inside the exact `](<link>)` spelling at the position the scan found, so
#     prose that merely mentions a path is left alone.
#   * It writes through the original inode (`cat > "$f"`), so a tracked file keeps its mode
#     (`exec-bit`), and it skips a file that is not tracked. That last check is a SECOND wall rather
#     than the first: the scan reads `git ls-files`, so an untracked shelf is never offered at all,
#     and the control asserts that stronger fact. The check stays for the day the scan's corpus widens.
#
# BOUNDS: at most 400 repairs in one run; a run changing nothing exits 0 and says so.
set -eu

root=${FOLD_REPOINT_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
cd "$root"

APPLY=no
[ "${1:-}" = "--apply" ] && APPLY=yes
MAX_REPAIRS=400

scan=tools/fixtures/f/fold_shelf_link_scan.sh
[ -f "$scan" ] || { echo "refused: $scan is absent -- the repair is computed there, never here" >&2; exit 2; }

work=$(mktemp -d "${TMPDIR:-/tmp}/fold-repoint.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

# THE SCAN IS THE AUTHORITY. Its exit status is 1 when it finds work, which is not a failure here,
# so the status is read rather than swallowed and only a REFUSAL (2 or worse) stops this tool.
sh "$scan" list > "$work/lost" 2>"$work/err" || {
  st=$?
  [ "$st" -le 1 ] || { echo "refused: the scan could not run -- no repair can be trusted" >&2; cat "$work/err" >&2; exit 2; }
}

count=$(grep -c . "$work/lost" 2>/dev/null || true)
[ -n "$count" ] || count=0
if [ "$count" -eq 0 ]; then
  echo "repairs=0"
  echo "verdict=nothing_to_do"
  exit 0
fi
[ "$count" -le "$MAX_REPAIRS" ] || { echo "refused: $count repairs exceeds the bound of $MAX_REPAIRS -- read them before a sweep" >&2; exit 2; }

applied=0
skipped_untracked=0
while IFS="$(printf '\t')" read -r f broken repair; do
  [ -n "${f:-}" ] && [ -n "${broken:-}" ] && [ -n "${repair:-}" ] || continue
  if ! git ls-files --error-unmatch "$f" >/dev/null 2>&1; then
    skipped_untracked=$((skipped_untracked + 1))
    echo "skip untracked: $f"
    continue
  fi
  if [ "$APPLY" = no ]; then
    printf 'would repoint %s: %s -> %s\n' "$f" "$broken" "$repair"
    applied=$((applied + 1))
    continue
  fi
  # Only the exact link spelling, and only where it stands as a markdown target.
  BROKEN="$broken" REPAIR="$repair" python3 - "$f" <<'PY' > "$work/out" || { echo "refused: the rewrite failed for $f" >&2; exit 2; }
import os, sys
p = sys.argv[1]
b = os.environ["BROKEN"]; r = os.environ["REPAIR"]
s = open(p, encoding="utf-8").read()
old = "](" + b + ")"
new = "](" + r + ")"
assert old in s, "the scan named a link this file does not carry"
sys.stdout.write(s.replace(old, new))
PY
  [ -s "$work/out" ] || { echo "refused: the rewrite of $f came back empty -- refusing to truncate a tracked file" >&2; exit 2; }
  cat "$work/out" > "$f"
  printf 'repointed %s: %s -> %s\n' "$f" "$broken" "$repair"
  applied=$((applied + 1))
done < "$work/lost"

echo "repairs=$applied"
echo "skipped_untracked=$skipped_untracked"
echo "applied=$APPLY"
echo "verdict=ok"
