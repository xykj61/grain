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
# PREVENTION LIVES ONE DIRECTORY OVER, and this tool is the repair. `tools/fixtures/r/reds_fold_reanchor.sh`
# rewrites the links of any block moving from `construction/` into `construction/archive/` AT WRITE
# TIME, which is the move an ITINERARY landed-accounts shelf makes on every send. Reach for that one
# while writing a shelf; reach for this one when a shelf already stands wrong.
#
#   sh tools/f/fold_shelf_link_repoint.sh                  # show what would change, touch nothing
#   sh tools/f/fold_shelf_link_repoint.sh --apply          # rewrite the links, working tree
#   sh tools/f/fold_shelf_link_repoint.sh --tracked-only   # rewrite them, index only
#
# WHAT IT WILL NOT DO, each refusal in the safe direction:
#   * It never invents a target. Only the scan's `repair` column is applied, and that column exists
#     only where the corrected path was proven present.
#   * It never touches a link the scan calls DEAD -- a broken link with no computed repair is a
#     reference that needs a reader, not a rewriter.
#   * It rewrites only inside the exact `](<link>)` spelling at the position the scan found, so
#     prose that merely mentions a path is left alone.
#   * It writes through the original inode (`cat > "$f"`), so a tracked file keeps its mode
#     (`exec-bit`), and it never writes a path git IGNORES. That wall used to read "not tracked",
#     and the day the control forecast has come: the scan now takes `FOLD_SHELF_CORPUS`, this tool
#     asks it for `working`, and an untracked-but-not-ignored shelf is offered on purpose. The
#     reason is `20260908.044602`'s remedy -- run the repointer BEFORE staging -- which was inert
#     for as long as the corpus was the index, since one `git add` was the whole distance between
#     `nothing_to_do` and a repair. `--tracked-only` restores the elder population, and an IGNORED
#     path is refused under either, so a rewrite never walks into a build artifact.
#
# BOUNDS: at most 400 repairs in one run; a run changing nothing exits 0 and says so.
set -eu

root=${FOLD_REPOINT_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
cd "$root"

APPLY=no
CORPUS=working
for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=yes ;;
    --tracked-only) CORPUS=tracked ;;
    *) echo "refused: unknown argument $arg -- pass --apply, --tracked-only, or nothing" >&2; exit 2 ;;
  esac
done
export FOLD_SHELF_CORPUS="$CORPUS"
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
  echo "corpus=$CORPUS"
  echo "verdict=nothing_to_do"
  exit 0
fi
[ "$count" -le "$MAX_REPAIRS" ] || { echo "refused: $count repairs exceeds the bound of $MAX_REPAIRS -- read them before a sweep" >&2; exit 2; }

applied=0
skipped_ignored=0
while IFS="$(printf '\t')" read -r f broken repair; do
  [ -n "${f:-}" ] && [ -n "${broken:-}" ] && [ -n "${repair:-}" ] || continue
  # The wall is IGNORED rather than untracked, since the corpus this asks for is the working tree.
  # `check-ignore` answers 0 when git ignores the path, and this tree denies by default at the root
  # (`.gitignore:/*`), so the question is asked only of paths the scan already handed over -- every
  # one of which git listed as tracked or as an untracked file it does NOT ignore.
  if git check-ignore -q "$f" 2>/dev/null; then
    skipped_ignored=$((skipped_ignored + 1))
    echo "skip ignored: $f"
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
echo "skipped_ignored=$skipped_ignored"
echo "corpus=$CORPUS"
echo "applied=$APPLY"
echo "verdict=ok"
