#!/bin/sh
# tools/fixtures/d/disk_reclaim_scan.sh -- report and, on --apply, clear a ship's own rebuildable
# build output, checked against .gitignore before anything is removed.
#
#   sh tools/fixtures/d/disk_reclaim_scan.sh            # report only, removes nothing
#   sh tools/fixtures/d/disk_reclaim_scan.sh --apply     # removes what the report names
#
# WHY. REDS `20260925.130901`: a shared root filesystem read 96% full, 7.6G free, and nothing in
# the tree measured which bytes were safe to remove. The repair that lap made was a typed loop
# naming twenty-four `*/bin/` directories by hand and confirming each with `git check-ignore -q`
# before deleting it -- correct, and left as a lap this row named rather than built: "whether a
# rostered tool belongs in tools/ so each ship runs one command rather than a typed loop."
#
# WHAT IS COUNTED. Every path `.gitignore` names ending in `/bin/`, plus `/tools/.build`, read from
# the tracked `.gitignore` itself rather than guessed at, so a line added there is read the next
# time this runs without anybody updating a second list. A candidate is REBUILDABLE only when BOTH
# hold: `git check-ignore -q` answers yes (it is genuinely untracked build output, never a file this
# tree ships), and the path is not in the EXCLUDE list below.
#
# THE EXCLUDE LIST is the load-bearing toolchain this tree cannot rebuild itself without:
# `rye/bin` and `rishi/bin`. Removing either strands every other repair this script, and every
# other tool in this tree, depends on to run at all. Never removed, --apply or not.
#
# ONE WRITER PER CHECKOUT. This reads and clears the CALLING ship's own tree alone -- it never
# reaches for another checkout's path, and it never removes a directory this script did not itself
# just confirm is gitignored build output.
#
# READINGS: `candidates=N excluded=N rebuildable=N bytes_before=N`, one `dir <path> bytes=N
# verdict=rebuildable|excluded|not_ignored` line per candidate, then `disk_before=` and (after
# --apply) `disk_after=` from `df`. Exit 0 always in report mode; --apply exits 1 if any confirmed
# candidate fails to remove.
set -eu

# The tree read is the CALLING directory's own repository -- `git rev-parse` reads from the
# working directory a caller invoked this from, rather than from this script's own path, so a
# control can point it at a throwaway pen's repository without touching the real checkout.
ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"

APPLY=no
if [ "${1:-}" = "--apply" ]; then
  APPLY=yes
fi

EXCLUDE="
/rye/bin/
/rishi/bin/
"
is_excluded() {
  case "
$EXCLUDE
" in
    *"
$1
"*) return 0 ;;
    *) return 1 ;;
  esac
}

disk_line() {
  df -P . | awk 'NR==2 {print "size="$2" used="$3" avail="$4" use_pct="$5}'
}

echo "disk_before=$(disk_line)"

candidates=0
excluded=0
rebuildable=0
bytes_total=0

# Read every gitignore line ending in /bin/, plus the one non-bin build cache this tree names by
# hand in the founding row. Comment lines and blank lines are skipped by the leading-slash test.
list=$(grep -E '^/.*bin/$' .gitignore | sed 's#/$##'; echo /tools/.build)

for rel in $list; do
  path=".$rel"
  [ -d "$path" ] || continue
  candidates=$((candidates + 1))
  if is_excluded "$rel/"; then
    excluded=$((excluded + 1))
    echo "dir $rel bytes=0 verdict=excluded"
    continue
  fi
  if ! git check-ignore -q -- "$path"; then
    echo "dir $rel bytes=0 verdict=not_ignored"
    continue
  fi
  size=$(du -sk "$path" 2>/dev/null | awk '{print $1*1024}')
  rebuildable=$((rebuildable + 1))
  bytes_total=$((bytes_total + size))
  echo "dir $rel bytes=$size verdict=rebuildable"
  if [ "$APPLY" = yes ]; then
    rm -rf "$path"
  fi
done

echo "candidates=$candidates excluded=$excluded rebuildable=$rebuildable bytes_total=$bytes_total"

if [ "$APPLY" = yes ]; then
  echo "disk_after=$(disk_line)"
  echo "verdict=applied"
else
  echo "verdict=reported"
fi
