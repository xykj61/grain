#!/bin/sh
# tools/fixtures/s/seat_prompt_figure_scan.sh -- a charter says what a ship is FOR, never how big its lane is.
#
# WHAT THIS READS. Every live seat in `construction/fleet-roster.kyri` has a prompt file, found the
# way `tools/f/fleet-loop.sh` finds it -- `tools/<first letter of seat>/<seat>_seat_prompt.txt` --
# and that file is the first thing a ship reads on every lap it will ever run. This scan counts the
# **tree measurements** standing in those prompts: a number asserting how many modules, lines, or
# witnesses a lane holds.
#
# THE LAW IT KEEPS is already seated one room over. `construction/ITINERARY.md`'s roster directive
# reads *Counts come from the scan, never here*, and Gauge asks that **every figure carry unit,
# date, and source**. A charter can carry none of the three: it is read aloud at the head of a lap,
# nothing runs it, and no reader can tell a figure written this morning from one written in June.
#
# WHAT WAS MEASURED (`20260907.011258`). Eight live seats, eight prompts, and **two** carried tree
# measurements -- six figures between them, and every one had parted from the tree:
#
#   copal      `10 Rye modules and 3,861 lines` and `16 witnesses`, none on the roster
#   patchouli  `32 Rye modules and 9,175 lines` and `four rostered witnesses`
#
# The witness figures were EXACT at their seating and went stale on ordinary work: copal's seat was
# written when 16 tracked paths named both `amphora` and `witness` and none stood on the standing
# roster, and by `20260907` that reading was 17 with 9 rostered. The line figure is the sharper one
# -- `3,861` matched no reading of the room on the day it was written, where the ten `.rye` paths
# read **3,582**. A figure nothing reads cannot be corrected, only replaced.
#
# THE READINGS:
#   seats      live seats the roster names
#   prompts    prompt files found for them
#   missing    a live seat with no prompt file          reported -- fleet-loop refuses this itself
#   figures    tree measurements standing in prompts    RATCHET, a ceiling that only falls
#   rates      law-rates seen and deliberately NOT counted
#
# A RATE IS A LAW; A TOTAL IS A MEASUREMENT. `two asserts a function` is TAME's rule and can go
# stale only on a word, so it is counted under `rates` and excluded. `10 Rye modules` claims what
# the tree holds this morning and is a measurement. That one distinction is the whole discriminator,
# and it is why `rates` is printed rather than silently dropped -- an exclusion nobody can see is an
# exclusion nobody can check.
#
# THE READING IS A FLOOR, AND THE FLOOR IS DELIBERATE. Only nouns that can name a code census are
# read -- module, line, witness, guard, assert, function, scan, control. `files`, `rows`, and
# `pages` are left out because a charter says `read its top three rows` as an instruction, and a
# guard that reds on an instruction is a guard somebody turns off. So patchouli's `120 files
# outside it reaching in` is a measurement this scan cannot see, named here rather than hidden.
# A possessive is skipped for the same reason: `one module's meaning reaches another` is an article.
#
#   sh tools/fixtures/s/seat_prompt_figure_scan.sh [<root>] [--seat <name>] [--ceiling <n>]
#
# Default root `.`. Exit 0 when the prompts read at or under the ceiling, 1 when they stand above
# it, 2 when they cannot be read at all. WITHOUT `--ceiling` the count is reported and nothing is
# gated, so a hand can measure without arguing with a number. The ceiling lives in
# `tools/s/seat_prompt_figure_witness.rish`, which is the one place it falls.
set -eu

ROOT=.
WANT=
CEILING=

while [ $# -gt 0 ]; do
  case "$1" in
    --seat) [ $# -ge 2 ] || { echo "$0: --seat wants a name" >&2; exit 2; }; WANT=$2; shift 2 ;;
    --ceiling) [ $# -ge 2 ] || { echo "$0: --ceiling wants a number" >&2; exit 2; }; CEILING=$2; shift 2 ;;
    -*) echo "$0: unknown argument: $1" >&2; exit 2 ;;
    *) ROOT=$1; shift ;;
  esac
done

ROSTER="$ROOT/construction/fleet-roster.kyri"

if ! test -f "$ROSTER"; then
  echo "verdict=misread"
  echo "detail=roster_absent"
  echo "detail_roster=$ROSTER"
  exit 2
fi

# Bound: the detail listing stops here and says so. An unbounded print is an unbounded
# allocation (TAME), and a fleet past this wants a fold rather than a longer printout.
MAX_DETAIL=64

# A number this tree would write in a charter: digits with optional thousands commas, or a spelled
# small number. `one` is left out on purpose -- it is an article far more often than a count here.
NUM='([0-9][0-9,]*|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|thirty|forty|fifty)'
# A noun that can only name a code census. See the floor note above for what is left out and why.
NOUN='(modules?|lines?|witnesses|witness|guards?|asserts?|functions?|scans?|controls?)'
# One optional word between them carries `10 Rye modules` and `four rostered witnesses`.
FIG="(^|[^-a-z0-9])$NUM( [a-zA-Z-]+)? $NOUN"

echo "roster=$ROSTER"

seats=0
prompts=0
missing=0
figures=0
rates=0
shown=0

# The roster is the one seat table (REDS %409). A live seat is read from it rather than listed here,
# so a ship added tomorrow is measured on its first lap with no edit to this scan.
for seat in $(awk '$1 == "seat" { s = $2 } $1 == "status" && $2 == "live" && s != "" { print s; s = "" }' "$ROSTER"); do
  [ -z "$WANT" ] || [ "$WANT" = "$seat" ] || continue
  seats=$((seats + 1))

  # The prompt path is DERIVED exactly as fleet-loop.sh derives it, rather than tabled here --
  # a second table is a second thing to drift (REDS %409).
  room=$(printf '%s' "$seat" | cut -c1)
  prompt="$ROOT/tools/${room}/${seat}_seat_prompt.txt"

  if ! test -f "$prompt"; then
    missing=$((missing + 1))
    [ "$shown" -ge "$MAX_DETAIL" ] || { echo "detail_missing=$seat"; shown=$((shown + 1)); }
    continue
  fi
  prompts=$((prompts + 1))

  flat=$(tr '\n' ' ' < "$prompt")
  all=$(printf '%s' "$flat" | grep -oEi "$FIG" | grep -vEi "'s$" || true)
  rate=$(printf '%s' "$flat" | grep -oEi "$FIG,? (a|an|per) [a-z]" || true)

  r=0; [ -z "$rate" ] || r=$(printf '%s\n' "$rate" | grep -c .)
  rates=$((rates + r))

  # A detail line that names a figure the count excluded is worse than no detail line at all, so
  # the rate hits are removed from the list BEFORE it is either counted or printed. Every rate hit
  # begins with the figure text it excludes, which is what makes the prefix test exact.
  keep=$all
  if [ -n "$rate" ] && [ -n "$all" ]; then
    keep=$(printf '%s\n' "$all" | while IFS= read -r hit; do
      printf '%s\n' "$rate" | grep -qF -- "$hit" || printf '%s\n' "$hit"
    done)
  fi

  a=0; [ -z "$keep" ] || a=$(printf '%s\n' "$keep" | grep -c .)
  figures=$((figures + a))

  if [ -n "$keep" ]; then
    printf '%s\n' "$keep" | while IFS= read -r hit; do
      echo "detail_figure=$seat:$hit"
    done
  fi
  if [ -n "$rate" ]; then
    printf '%s\n' "$rate" | while IFS= read -r hit; do
      echo "detail_rate=$seat:$hit"
    done
  fi
done

echo "seats=$seats"
echo "prompts=$prompts"
echo "missing=$missing"
echo "figures=$figures"
echo "rates=$rates"

if [ -n "$CEILING" ]; then
  echo "ceiling=$CEILING"
  if [ "$figures" -gt "$CEILING" ]; then
    echo "verdict=over_ceiling"
    echo "refused: $figures tree measurement(s) stand in seat prompts against a ceiling of $CEILING -- a charter says what a ship is for, and a count in it can carry neither date nor source" >&2
    exit 1
  fi
fi

echo "verdict=ok"
exit 0
