#!/bin/sh
# tools/fixtures/i/itinerary_list_scan.sh -- a living pin's numbered list is a spine, and a spine
# with a vertebra missing is the one tell a rewrite-by-line leaves behind.
#
# WHY. REDS %789 and the row of `20260916.220730` are the same defect forty minutes apart, from two hands. Both replaced
# item 7 of the INNER LOOP in construction/ITINERARY.md -- the directive telling every lap to run
# the endurance runs -- with a duplicate Git nib line, and both left the list reading 6, nib, 8.
# Every standing guard passed through both firings, and each for a reason worth naming:
# nib_honesty reads the nib BY ITS KEY and finds it whichever line carries it; ascii_document,
# tracked_link and the pin bound read bytes rather than meaning; and no instrument in this tree
# reads a list's own numbering. The card was absent its directive for ten hours and roughly 120
# commits the first time, on the one page an eight-ship fleet reads at every lap open.
#
# %789 named this cure in its own third field and left it unbuilt on the stated ground that the
# lantern had fired once. It fired twice. So: the loom.
#
#   sh tools/fixtures/i/itinerary_list_scan.sh          # counts
#   sh tools/fixtures/i/itinerary_list_scan.sh list     # one line per broken run
#
# THE READING. Inside each rostered living pin, a RUN is a maximal stretch of ordered-list items at
# one indent, in which only blank lines and more-indented lines stand between consecutive items. A
# run must read 1..N: it starts at 1, rises by one, repeats nothing, skips nothing. A foreign line
# at or left of the run's own indent ENDS the run, so the %789 shape produces two runs -- 1..6,
# which passes, and 8..12, which starts at 8 and is refused. That is the catch, and it needs no
# knowledge of what the foreign line said.
#
# WHY A BLANK LINE DOES NOT END A RUN. Markdown's loose list keeps its numbering across a blank
# line, and refusing one would red on ordinary writing. A guard that reds on ordinary work is a
# guard somebody turns off.
#
# WHY THE ROSTER RATHER THAN THE TREE. The defect is a rewrite of a page a lap reads WHOLE, and
# tools/fixtures/l/living_pin_guard_roster.txt is exactly the list of those pages -- already the
# authority for the byte bound, so this adds no second copy of who the pins are. A numbered list
# in a dated log is testimony and keeps every number it wrote (accrete-never-break).
#
# WHAT IT REFUSES, each in the safe direction:
#   roster_absent  -- the roster file is missing. Without it nothing can be called a living pin,
#                     and a scan that defaults to the whole tree would red on every dated page.
#   pin_absent     -- a rostered path is not in the tree. Reported by name rather than counted as
#                     broken: a missing page is a different fact from a damaged list, and only the
#                     roster's own guard can say which.
#
# BOUNDS: at most 64 rostered pins, 4096 lines read per pin, 256 runs per pin, 200 reported rows.
set -eu

ROOT=${ITINERARY_LIST_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$ROOT"

MODE=${1:-count}
MAX_PINS=64
MAX_LINES=4096
MAX_RUNS=256
MAX_REPORT=200

roster=${ITINERARY_LIST_ROSTER:-tools/fixtures/l/living_pin_guard_roster.txt}
[ -f "$roster" ] || { echo "refused: no living-pin roster at $roster -- nothing can be called a pin" >&2; exit 2; }

work=$(mktemp -d "${TMPDIR:-/tmp}/pin-list.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

: > "$work/broken.txt"
: > "$work/absent.txt"
pins_read=0
pins_absent=0
runs=0
items=0

# The roster's first column is the path; comment and blank lines are skipped, exactly as its own
# header describes. Bounded at MAX_PINS so a roster that grows without anyone noticing says so.
sed -e 's/[[:space:]].*$//' "$roster" | grep -vE '^(#|$)' | head -"$MAX_PINS" > "$work/pins.txt"

while IFS= read -r pin; do
  [ -n "$pin" ] || continue
  if [ ! -f "$pin" ]; then
    pins_absent=$((pins_absent + 1))
    printf '%s\n' "$pin" >> "$work/absent.txt"
    continue
  fi
  pins_read=$((pins_read + 1))
  head -"$MAX_LINES" "$pin" | awk -v pin="$pin" '
    # A STACK, RATHER THAN ONE RUN. A nested list is a run of its own standing INSIDE its parent,
    # and the parent resumes when the nesting closes -- so one open run per indent depth, closed
    # from the deepest inward. The first draft kept a single run and closed it on every indent
    # change, which read an ordinary nested list as a parent broken at its own second item.
    function close_depth(d,   want, i, k, seq) {
      if (cnt[d] == 0) { stack_ind[d] = -1; return }
      runs++
      want = 1
      seq = ""
      for (i = 1; i <= cnt[d]; i++) seq = seq (i > 1 ? "," : "") num[d SUBSEP i]
      for (i = 1; i <= cnt[d]; i++) {
        if (num[d SUBSEP i] + 0 != want) {
          printf "BROKEN\t%s\t%d\t%d\t%s\t%d\n", pin, open_line[d], line[d SUBSEP i], seq, want
          break
        }
        want++
      }
      cnt[d] = 0
      stack_ind[d] = -1
    }
    function unwind(to_ind, inclusive) {
      while (depth > 0 && (inclusive ? to_ind <= stack_ind[depth] : to_ind < stack_ind[depth])) {
        close_depth(depth); depth--
      }
    }
    {
      match($0, /^[ \t]*/); ind = RLENGTH
      if ($0 ~ /^[[:space:]]*$/) next          # a loose list keeps its numbering across a blank line
      if ($0 ~ /^[ \t]*[0-9]+\.[ \t]/) {
        v = $0; sub(/^[ \t]*/, "", v); sub(/\..*$/, "", v)
        unwind(ind, 0)                         # shallower than an open run: that run has finished
        if (depth > 0 && ind == stack_ind[depth]) {
          cnt[depth]++
        } else {
          depth++; stack_ind[depth] = ind; cnt[depth] = 0; open_line[depth] = NR; cnt[depth] = 1
        }
        if (cnt[depth] == 1 && open_line[depth] != NR) open_line[depth] = NR
        num[depth SUBSEP cnt[depth]] = v + 0
        line[depth SUBSEP cnt[depth]] = NR
        items++
        next
      }
      unwind(ind, 1)                           # a foreign line at or left of a run ends that run
    }
    END { while (depth > 0) { close_depth(depth); depth-- }
          printf "COUNT\t%d\t%d\n", runs, items }
  ' > "$work/pin-out.txt"

  grep '^BROKEN' "$work/pin-out.txt" >> "$work/broken.txt" || true
  c=$(grep '^COUNT' "$work/pin-out.txt" | head -1)
  runs=$((runs + $(printf '%s' "$c" | cut -f2)))
  items=$((items + $(printf '%s' "$c" | cut -f3)))
done < "$work/pins.txt"

broken=$(wc -l < "$work/broken.txt" | tr -d ' ')

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/broken.txt" | while IFS="$(printf '\t')" read -r _ pin start bad seq want; do
    printf 'broken: %s run opening at line %s reads %s -- line %s should have been %s\n' \
      "$pin" "$start" "$seq" "$bad" "$want"
  done
  while IFS= read -r p; do
    [ -n "$p" ] && printf 'absent: %s is rostered and not in the tree\n' "$p"
  done < "$work/absent.txt"
fi

echo "pins_read=$pins_read"
echo "pins_absent=$pins_absent"
echo "ordered_runs=$runs"
echo "ordered_items=$items"
echo "broken_runs=$broken"
