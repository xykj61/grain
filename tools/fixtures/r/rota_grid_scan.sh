#!/bin/sh
# rota_grid_scan.sh -- the council rota is an instruction to open twenty documents, and fifteen of
# them are written in a form no link wall reads.
#
# WHY. The 5 x 3 grid in `recursion-prompts/seed/autonomous-loop.seed.md` is the one mechanism that
# returns this tree's canon to living awareness on a schedule: each lap deep-reads one row -- the
# row's threshold page first, then its three seat documents. Measured at fleet scale on
# `20260906.213125`, eight ships read the five rows 11, 12, 13, 20 and 12 times across 105 logs, so
# every document comes back roughly daily.
#
# THAT PROMISE RESTS ON TWENTY PATHS BEING RIGHT, and no guard was reading them as a set. The five
# thresholds are Markdown links; the fifteen seats are backticked bare paths.
# `tools/fixtures/r/readme_reach_scan.sh` follows links alone -- its own `LINK` pattern is
# `\[[^\]]*\]\(([^)\s]+)` -- so a seat cell is part of no reachability claim. Fold a seat and the
# grid goes on naming a dead path in silence, while whatever OTHER citer linked that file reds
# instead; the repair then lands over there and the grid stays wrong.
#
# THE DRIFT THAT ACTUALLY HAPPENED IS INVISIBLE TO EVERY LINK WALL BY CONSTRUCTION, and that is the
# sharper half. Earth-Cardinal changed hands on `20260905`, from `context/specs/20260627-102012_one-clock-naming-law.md`
# to `foundations/20260905-154954_the-clock-and-the-mark.md`, on the reasoning that a rota reads
# foundations and the mark law sat on no seat at all. The change reached the grid and not the Earth
# threshold page -- the FIRST thing an earth lap reads -- which went on routing its reader to the
# retired seat. **Both paths exist and both resolve.** Nothing was broken; the door simply opened on
# the seat it had replaced, and only a check comparing the door against the grid can see that. A lap
# obeying the door got the clock half of the concern and missed the mark half, which was the whole
# reason the seat moved. Measured `20260907`: fourteen of fifteen seats agreed, and the one that did
# not was in the row being read that morning.
#
#   sh tools/fixtures/r/rota_grid_scan.sh          # the counts
#   sh tools/fixtures/r/rota_grid_scan.sh list     # one line per fault
#
# WHAT IS GATED, hard, at zero.
#   unresolved       -- a path the grid names that does not exist on disk.
#   sections_missing -- a threshold page lacking one of its three modality headings.
#   seat_undeclared  -- a modality section that does not name the grid's seat for its own cell.
#
# WHAT IS REPORTED. `rows` and `cells`, empty or full, so a reader can tell a healthy grid from a
# grid this scan could not parse -- the shape `rota_declared_scan.sh` keeps one room over.
#
# WHAT PASSES FREE. Whether a seat is worth reading, and whether the threshold's PROSE about a seat
# is still true. This reads paths and headings, which are concrete; the rest is a reader's job.
#
# BOUNDS: 5 element rows, 3 seats each, one seed file, five threshold pages, at most 64 reported.
set -eu

root=${ROTA_GRID_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-count}
SEED=${ROTA_GRID_SEED:-recursion-prompts/seed/autonomous-loop.seed.md}
MAX_ROWS=5
MAX_SEATS=3
MAX_REPORT=64

[ -f "$SEED" ] || { echo "refused: no rota seed at $SEED -- every count below would read zero" >&2; exit 2; }

work=$(mktemp -d "${TMPDIR:-/tmp}/rota-grid.XXXXXX" 2>/dev/null) || work=${TMPDIR:-/tmp}/rota-grid-$$
mkdir -p "$work"
trap 'rm -rf "$work"' EXIT INT TERM

# One record per grid cell: element, modality, threshold path, seat path.
# A grid row is a table line whose first cell opens `| **<Element> - <Planet>**`.
awk -v maxrows="$MAX_ROWS" -F'|' '
  /^\| \*\*[A-Z][a-z]+ - [A-Z][a-z]+\*\*/ {
    if (rows >= maxrows) next
    head = $2
    element = head
    sub(/^[ \t]*\*\*/, "", element)
    sub(/ .*$/, "", element)
    threshold = ""
    if (match(head, /\]\(\.\.\/\.\.\/[^)]+\)/)) {
      threshold = substr(head, RSTART + 8, RLENGTH - 9)
    }
    split("Cardinal Fixed Dual", mode, " ")
    for (i = 1; i <= 3; i++) {
      cell = $(i + 2)
      seat = ""
      if (match(cell, /`[^`]+`/)) seat = substr(cell, RSTART + 1, RLENGTH - 2)
      printf "%s\t%s\t%s\t%s\n", element, mode[i], threshold, seat
    }
    rows++
  }
' "$SEED" > "$work/cells.txt"

rows=$(cut -f1 "$work/cells.txt" | sort -u | grep -c . || true)
cells=$(grep -c . "$work/cells.txt" || true)

# A CORPUS OF ZERO IS A RED, NEVER A READING (REDS %170).
[ "$rows" -eq "$MAX_ROWS" ] || { echo "refused: parsed $rows element rows of $MAX_ROWS in $SEED -- the grid's shape moved and every count below would be measuring the parser" >&2; exit 2; }
[ "$cells" -eq "$((MAX_ROWS * MAX_SEATS))" ] || { echo "refused: parsed $cells cells of $((MAX_ROWS * MAX_SEATS)) -- the grid's shape moved" >&2; exit 2; }

unresolved=0
sections_missing=0
seat_undeclared=0
: > "$work/faults.txt"

# Every path the grid names must exist: the five thresholds and the fifteen seats.
{ cut -f3 "$work/cells.txt"; cut -f4 "$work/cells.txt"; } | sort -u | while IFS= read -r p; do
  [ -n "$p" ] || { printf 'unresolved\t(empty)\tthe grid names no path in a cell\n'; continue; }
  [ -f "$p" ] || printf 'unresolved\t%s\tthe grid names it and it is not on disk\n' "$p"
done >> "$work/faults.txt"

# Each threshold page carries `## Cardinal:`, `## Fixed:` and `## Dual:`, and each of those sections
# names its own cell's seat. The heading is the door; the path inside it is what the door opens.
while IFS="$(printf '\t')" read -r element modality threshold seat; do
  [ -f "$threshold" ] || continue
  if ! grep -qE "^## $modality:" "$threshold"; then
    printf 'sections_missing\t%s\t%s has no "## %s:" section\n' "$threshold" "$element" "$modality" >> "$work/faults.txt"
    continue
  fi
  awk -v want="^## $modality:" '
    $0 ~ want { inside = 1; next }
    inside && /^## / { exit }
    inside { print }
  ' "$threshold" > "$work/section.txt"
  if ! grep -qF "$seat" "$work/section.txt"; then
    printf 'seat_undeclared\t%s\t%s %s names no path matching %s\n' "$threshold" "$element" "$modality" "$seat" >> "$work/faults.txt"
  fi
done < "$work/cells.txt"

unresolved=$(grep -c '^unresolved	' "$work/faults.txt" || true)
sections_missing=$(grep -c '^sections_missing	' "$work/faults.txt" || true)
seat_undeclared=$(grep -c '^seat_undeclared	' "$work/faults.txt" || true)

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/faults.txt" | while IFS="$(printf '\t')" read -r kind where why; do
    printf '%s: %s -- %s\n' "$kind" "$where" "$why"
  done
fi

echo "seed=$SEED"
echo "rows=$rows"
echo "cells=$cells"
echo "unresolved=$unresolved"
echo "sections_missing=$sections_missing"
echo "seat_undeclared=$seat_undeclared"
if [ "$unresolved" -eq 0 ] && [ "$sections_missing" -eq 0 ] && [ "$seat_undeclared" -eq 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=drift"
fi
