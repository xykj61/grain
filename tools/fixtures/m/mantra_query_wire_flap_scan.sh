#!/bin/sh
# query_wire_flap_scan.sh -- run one rostered guard many times on one unchanged tree, and count.
#
# Run from the repository root:
#   sh tools/fixtures/m/mantra_query_wire_flap_scan.sh [--repeat N] [--guard PATH]
#
# WHY THIS EXISTS (REDS %700). `tools/m/mantra_recall_tablecloth_query_wire.rish` answered red on a
# cold roster pass and green on a re-run minutes later over a tree that had not moved. The row's
# own third field names the wound plainly: **a guard that answers differently on one tree proves
# nothing, and every instrument in this room reads ONE run.** A single reading cannot tell a law
# that holds from a law that holds most of the time, and the ledger's three fields have no shape
# for a fault whose *what went wrong* is sometimes nothing at all. So the row named its own first
# repair -- a repeat count -- and this is that count.
#
# WHAT IT ANSWERS. `green` and `red` over `repeat` runs of one guard, `flap=yes` the moment both
# are above zero, and for every red the run index, the exit status, and the guard's own refusal
# line. That last field is the harvest of the `20260910.203444` repair, which gave this guard's
# five bindings their targets' own sentences: before it, a red here could name only which LEG
# refused, so a flap could be inferred and never diagnosed. The voice was built one lap and is
# listened to here.
#
# LOAD IS OBSERVED RATHER THAN GENERATED, and the choice is deliberate. The row's repair reads
# "a repeat count under load", and a scan that manufactured its own load would spend CPU on a pier
# where eight ships run their own passes -- harming the peers whose work IS the load this guard
# flapped under. So each run records the one-minute load average it actually ran at, and the
# summary names the range. A reading taken on a quiet pier says so in its own numbers, which is
# honest, where a reading taken beside a fabricated load says nothing about the fleet at all.
#
# WHAT IT CANNOT SAY. Whether a red would have arrived at repeat+1. A flap with a low rate needs a
# larger count to surface, and this instrument reports the count it ran rather than implying the
# count was enough -- `flap=no` reads "not seen in N", never "absent".
#
# Bounds: at most MAX_REPEAT runs, because a guard costing about sixteen seconds turns a careless
# repeat into an hour nobody meant to spend.

set -u

MAX_REPEAT=64
DEFAULT_REPEAT=20
guard="tools/m/mantra_recall_tablecloth_query_wire.rish"
repeat="$DEFAULT_REPEAT"

while [ $# -gt 0 ]; do
  case "$1" in
    --repeat)
      [ $# -ge 2 ] || { echo "verdict=bad_flag" ; echo "detail: --repeat wants a count" >&2 ; exit 2 ; }
      repeat="$2"
      shift 2
      ;;
    --guard)
      [ $# -ge 2 ] || { echo "verdict=bad_flag" ; echo "detail: --guard wants a path" >&2 ; exit 2 ; }
      guard="$2"
      shift 2
      ;;
    *)
      echo "verdict=bad_flag"
      echo "detail: unknown flag $1" >&2
      exit 2
      ;;
  esac
done

case "$repeat" in
  ''|*[!0-9]*)
    echo "verdict=bad_flag"
    echo "detail: --repeat wants a whole number, read '$repeat'" >&2
    exit 2
    ;;
esac

if [ "$repeat" -lt 1 ] || [ "$repeat" -gt "$MAX_REPEAT" ]; then
  echo "verdict=over_bound"
  echo "detail: --repeat $repeat sits outside 1..$MAX_REPEAT" >&2
  exit 2
fi

if [ ! -f "$guard" ]; then
  echo "verdict=no_guard"
  echo "detail: $guard is not a file here -- sh tools/fixtures/p/path_absence_scan.sh $guard" >&2
  exit 2
fi

# The tree digest is the standing runner's own, cited rather than re-invented, so a reading here
# and a reading there name one tree by one name: HEAD, porcelain, the tracked diff, and the
# untracked files' hashes, folded to twelve characters. See tools/fixtures/s/standing_equipment_run.sh.
tree_digest() {
  if git rev-parse --git-dir >/dev/null 2>&1; then
    {
      git rev-parse HEAD 2>/dev/null || echo no_head
      git status --porcelain 2>/dev/null
      if git rev-parse --verify --quiet HEAD >/dev/null 2>&1; then
        git diff HEAD --binary 2>/dev/null
      else
        git ls-files -s 2>/dev/null
      fi
      git ls-files --others --exclude-standard 2>/dev/null \
        | git hash-object --stdin-paths 2>/dev/null
    } | sha256sum | cut -c1-12
  else
    echo nogit
  fi
}

load_now() {
  if [ -r /proc/loadavg ]; then
    cut -d' ' -f1 < /proc/loadavg
  else
    echo unread
  fi
}

pen=$(mktemp -d "${TMPDIR:-/tmp}/grain_flap.XXXXXX") || {
  echo "verdict=no_pen"
  exit 2
}
trap 'rm -rf "$pen"' EXIT INT TERM

tree_open=$(tree_digest)
load_open=$(load_now)

echo "guard=$guard"
echo "repeat=$repeat"
echo "tree_at_open=$tree_open"
echo "load_at_open=$load_open"

green=0
red=0
load_min="$load_open"
load_max="$load_open"
run=1
while [ "$run" -le "$repeat" ]; do
  load_here=$(load_now)
  start_ms=$(date +%s%3N 2>/dev/null || echo 0)
  rishi/bin/rishi run "$guard" > "$pen/out.$run" 2>&1
  status=$?
  end_ms=$(date +%s%3N 2>/dev/null || echo 0)
  if [ "$start_ms" != 0 ] && [ "$end_ms" != 0 ]; then
    elapsed=$((end_ms - start_ms))
  else
    elapsed=unread
  fi

  if [ "$status" -eq 0 ]; then
    green=$((green + 1))
  else
    red=$((red + 1))
    # The guard's own refusal sentence, which the 20260910.203444 repair made sayable. Rishi
    # prints a failed assert as TWO lines -- `rishi: assertion failed -- <the else message>`, then
    # an indented `at line N:` echoing the source. The message is the FIRST of the pair, so a
    # reading that took the last non-blank line would harvest the line number and discard the
    # compiler's or the selftest's own words -- which is the exact loss the 20260910.203444 repair
    # was built to end, re-made one room over. Fall back to the last line only when nothing here
    # looks like an assert, so a guard that dies some other way still says something.
    reason=$(grep -m1 'assertion failed' "$pen/out.$run" 2>/dev/null | cut -c1-240)
    if [ -z "$reason" ]; then
      reason=$(grep -v '^[[:space:]]*$' "$pen/out.$run" | tail -1 | cut -c1-240)
    fi
    echo "red_run=$run exit=$status load=$load_here ms=$elapsed"
    echo "red_reason=$reason"
  fi

  # The load range across the whole count, so a summary reader can tell a quiet pier from a busy
  # one without reading every line.
  case "$load_here" in
    unread) : ;;
    *)
      if [ "$(printf '%s\n%s\n' "$load_here" "$load_min" | sort -g | head -1)" = "$load_here" ]; then
        load_min="$load_here"
      fi
      if [ "$(printf '%s\n%s\n' "$load_here" "$load_max" | sort -g | tail -1)" = "$load_here" ]; then
        load_max="$load_here"
      fi
      ;;
  esac

  run=$((run + 1))
done

tree_close=$(tree_digest)
echo "tree_at_close=$tree_close"
if [ "$tree_open" = "$tree_close" ]; then
  echo "tree_moved=no"
else
  echo "tree_moved=yes"
fi
echo "load_min=$load_min"
echo "load_max=$load_max"
echo "green=$green"
echo "red=$red"

if [ "$tree_open" != "$tree_close" ]; then
  # A count over a tree that moved counts two trees, so it answers the question nobody asked.
  echo "flap=unread"
  echo "verdict=tree_moved"
  exit 1
fi

if [ "$green" -gt 0 ] && [ "$red" -gt 0 ]; then
  echo "flap=yes"
  echo "verdict=flap"
  exit 1
fi

echo "flap=no"
if [ "$red" -gt 0 ]; then
  echo "verdict=red_every_run"
  exit 1
fi
echo "verdict=ok"
exit 0
