#!/bin/sh
# tools/fixtures/l/lint_surface_census_scan.sh -- which rows of the lint table does a lap actually run?
#
# WHY THIS EXISTS. `context/TAME_GUIDANCE.md` carries the tree's lint surface as a table under the
# heading **Checkable today** (formerly **Enforced now**), and beneath it a paragraph reading
# `20260911.112513` and written down rather than assumed*. That paragraph is a hand-typed census:
# twenty rows, eight leaning on five tools a roster pass runs, six naming a tool no lap runs. It was
# exact on the morning it was written, and it is a number carried inside prose, which the tree's own
# mark law already rules on -- COUNT, NEVER NUMBER.
#
# It went stale in ONE DAY, and the way it went stale is the interesting part. Measured over the
# file's own history:
#
#     commit 8aa384e0e (20260911.050903)   11 tools named, 5 rostered   <- what the paragraph says
#     commit 7ff4bd269 (20260911.140923)   13 tools named, 6 rostered
#     HEAD   b234288f1 (20260912)          14 tools named, 7 rostered
#
# Two rows seated later the same day -- the line-length census and the one-title witness -- each
# arrived with a rostered guard beside it, which is the tree working exactly as it should. The
# paragraph could not know, because nothing recomputed it.
#
# AND THE TOTAL NEVER SIGNALLED THE DRIFT. Rows read TWENTY at every one of those commits and reads
# twenty today, so the first figure a reader spot-checks agrees, and agreeing is what buys the
# breakdown beneath it a trust it has stopped earning. A census whose headline stays right while its
# parts move is worse than one that goes visibly wrong.
#
# THE THREE STATES A ROW CAN BE IN, which the paragraph drew in prose and nothing counted:
#   rostered    the row names a tool carrying its own `path` row in construction/standing-equipment.kyri
#   driven      the row names an unrostered tool AND a rostered one that drives it -- the table's own
#               words for tools/t/tame_style_scan_bans.rish, *driven by tools/t/tame_style_check.rish*
#   unreached   no lap runs anything this row names
#
# The distinction between the second and third is the whole reason the paragraph's SIX is right while
# a naive count of unrostered tools reads seven. A guard that could not tell them apart would call an
# honest row broken, and be turned off.
#
# THE READINGS.
#   rows                 rule rows in the checkable lint table
#   tools_named          distinct tool paths the table cites
#   tools_rostered       of those, carrying a `path` row on the standing roster
#   tools_driven         unrostered, yet named beside a rostered tool in the same row
#   tools_unreached      unrostered and undriven -- NAMED BELOW, never a bare total
#   rows_held            rows naming at least one rostered tool
#   rows_unheld          rows naming none                          RATCHET, ceiling only falls
#   tools_missing        cited tool paths absent from disk          WALL at zero
#
# NAMES, NOT ONLY SIZES. Both fault populations print their members every run rather than behind a
# `--list` verb. This tree read that lesson on `20260911`: a reported population printed its size and
# sent its names to a verb whose two callers neither ran, and a bare count is visible the way a
# locked door is.
#
# WHY tools_missing IS A WALL AND rows_unheld A RATCHET. A table citing a tool that is GONE tells a
# reader to run something that cannot run -- a promise standing on nothing, repairable on the lap it
# lands, so zero. A row no lap runs is often correct and reasoned: claim_preserve refuses a bare
# invocation by design, designed_not_built waits on a ruling, proven_seat wants a staged bench. A
# wall there would red on rows nobody may repair, and a wall that reds on honest work is a wall
# somebody turns off.
#
# WHAT IT DOES NOT REACH. Whether a rostered guard actually CHECKS the rule its row claims -- a tool
# on the roster may run every lap and read a different question than the row beside it names. This
# asks only whether a lap runs anything the row points at.
#
#   sh tools/fixtures/l/lint_surface_census_scan.sh

set -u
LC_ALL=C
export LC_ALL

UNHELD_CEILING=${LINT_SURFACE_UNHELD_CEILING:-9}
GUIDE=${LINT_SURFACE_GUIDE:-}
ROSTER=${LINT_SURFACE_ROSTER:-}

# Root by upward walk -- the letter fold moves this script's depth, so fixed `../..` arithmetic
# breaks. Skipped when both inputs are handed in: a control's pen holds two files rather than a
# tree, and asking it for a root would refuse the one caller needing no root.
if [ -z "$GUIDE" ] || [ -z "$ROSTER" ]; then
  ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
  _ls_steps=0
  while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/.git" ]; do
    _ls_steps=$((_ls_steps + 1))
    if [ "$_ls_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
      echo "$0: no tree root within 8 steps (needs tools/fixtures and .git)" >&2
      exit 2
    fi
    ROOT=$(dirname "$ROOT")
  done
  cd "$ROOT" || exit 2
  GUIDE=${GUIDE:-context/TAME_GUIDANCE.md}
  ROSTER=${ROSTER:-construction/standing-equipment.kyri}
fi

if [ ! -f "$GUIDE" ]; then
  echo "rows=0"
  echo "verdict=guide_absent"
  echo "detail: $GUIDE is not here, and an instrument that cannot find its subject reads exactly like a clean table"
  exit 1
fi
if [ ! -f "$ROSTER" ]; then
  echo "rows=0"
  echo "verdict=roster_absent"
  echo "detail: $ROSTER is not here, so every row would read unreached -- a broken reader wearing a finding's clothes"
  exit 1
fi

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

# THE TABLE, bounded at both ends. The heading opens it; the first blank line AFTER a row has been
# seen closes it, so the blank line between the heading and the table header does not end the walk.
awk '
  /^\*\*(Enforced now|Checkable today)/ { f = 1; next }
  f && /^$/ { if (seen) exit; next }
  f && /^\| \*\*/ { seen = 1; print }
' "$GUIDE" > "$pen/rows.txt"
rows=$(wc -l < "$pen/rows.txt" | tr -d ' ')

if [ "$rows" -eq 0 ]; then
  echo "rows=0"
  echo "verdict=table_unread"
  echo "detail: the checkable lint heading was not found, or it opens no rule row -- zero rows reads as a tree with no lint surface at all"
  exit 1
fi

# One line per row: `<state>\t<row title>`. A tool path ends at a boundary on both sides, so
# `tools/t/tame-check.rish` inside a longer word is never mistaken for the tool itself.
: > "$pen/named.txt"
: > "$pen/states.txt"
line_no=0
while IFS= read -r row; do
  line_no=$((line_no + 1))
  title=$(printf '%s' "$row" | sed -n 's/^| \*\*\([^*]*\)\*\*.*/\1/p')
  [ -n "$title" ] || title="row $line_no"
  printf '%s\n' "$row" | grep -oE 'tools/[a-z]+/[a-z0-9_.-]+\.rish' | sort -u > "$pen/rowtools.txt"
  held=no
  while read -r t; do
    [ -n "$t" ] || continue
    printf '%s\n' "$t" >> "$pen/named.txt"
    grep -qx "path $t" "$ROSTER" && held=yes
  done < "$pen/rowtools.txt"
  if [ "$held" = yes ]; then
    # Every unrostered tool sharing a row with a rostered one is DRIVEN by it -- the table's own
    # reading of the bans scan, promoted from prose to a state.
    while read -r t; do
      [ -n "$t" ] || continue
      grep -qx "path $t" "$ROSTER" || printf '%s\n' "$t" >> "$pen/driven.txt"
    done < "$pen/rowtools.txt"
  fi
  printf '%s\t%s\n' "$held" "$title" >> "$pen/states.txt"
done < "$pen/rows.txt"

[ -f "$pen/driven.txt" ] || : > "$pen/driven.txt"
sort -u "$pen/named.txt" > "$pen/tools.txt"
sort -u "$pen/driven.txt" > "$pen/driven_u.txt"
tools_named=$(wc -l < "$pen/tools.txt" | tr -d ' ')

: > "$pen/rostered.txt"
: > "$pen/unrostered.txt"
: > "$pen/missing.txt"
while read -r t; do
  [ -n "$t" ] || continue
  if grep -qx "path $t" "$ROSTER"; then
    printf '%s\n' "$t" >> "$pen/rostered.txt"
  else
    printf '%s\n' "$t" >> "$pen/unrostered.txt"
  fi
  # Disk presence is asked of the TREE rather than the pen: a control hands in two files and owns
  # no tools/ room, so it names its own guide and roster and leaves this reading to the live tree.
  [ -e "$t" ] || printf '%s\n' "$t" >> "$pen/missing.txt"
done < "$pen/tools.txt"

comm -23 "$pen/unrostered.txt" "$pen/driven_u.txt" > "$pen/unreached.txt"

tools_rostered=$(wc -l < "$pen/rostered.txt" | tr -d ' ')
tools_driven=$(wc -l < "$pen/driven_u.txt" | tr -d ' ')
tools_unreached=$(wc -l < "$pen/unreached.txt" | tr -d ' ')
tools_missing=$(wc -l < "$pen/missing.txt" | tr -d ' ')
rows_held=$(awk -F'\t' '$1 == "yes"' "$pen/states.txt" | wc -l | tr -d ' ')
rows_unheld=$(awk -F'\t' '$1 == "no"' "$pen/states.txt" | wc -l | tr -d ' ')

verdict=ok
if [ "$tools_missing" -gt 0 ]; then
  verdict=tool_missing
elif [ "$rows_unheld" -gt "$UNHELD_CEILING" ]; then
  verdict=unheld_over_ceiling
fi

echo "rows=$rows"
echo "tools_named=$tools_named"
echo "tools_rostered=$tools_rostered"
echo "tools_driven=$tools_driven"
echo "tools_unreached=$tools_unreached"
echo "tools_missing=$tools_missing"
echo "rows_held=$rows_held"
echo "rows_unheld=$rows_unheld"
echo "unheld_ceiling=$UNHELD_CEILING"
echo "verdict=$verdict"

echo "unreached_list:"
while read -r t; do
  [ -n "$t" ] && echo "  unreached $t"
done < "$pen/unreached.txt"
echo "missing_list:"
while read -r t; do
  [ -n "$t" ] && echo "  missing $t"
done < "$pen/missing.txt"

[ "$verdict" = ok ] || exit 1
exit 0
