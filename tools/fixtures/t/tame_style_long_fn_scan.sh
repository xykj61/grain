#!/bin/sh
# tame_style_long_fn_scan.sh -- the >70-line function ledger over the authored .rye roster.
#
# It prints a summary line and the top ten, in that order:
#   functions_over_70=321 longest=809 roster_files=611
#     caravan/farewell.rye: check_suffice_runs = 809 lines
#     ...
#
# WHY THE WALK MOVED HERE FROM THE `.rish` (REDS %519). The elder orchestration spawned one rishi
# subprocess per file and then joined every chunk into one string to rank it. With the counter
# repaired the ledger holds 321 rows rather than 15, and interpolating that blob into a command
# refuses with `StringTooLong` -- a bound doing its job. A scan that walks once and prints a
# summary keeps the reading small enough to hold, and matches the scan-plus-witness shape every
# other guard family in this tree already uses.
#
# WHY THE TOTAL IS PRINTED AT ALL. A ledger showing ten rows and no total lets a reader take the
# ten for the whole set -- `%505`'s lesson one room over, where an unprinted reach is a reach
# claimed by implication. The total is also the floor the witness gates on: zero across 611 files
# means the counter has gone blind, and blindness prints what a healthy tree prints.
#
# Run from the repository root:
#   sh tools/fixtures/t/tame_style_long_fn_scan.sh
set -u
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
one="$here/tame_style_long_fn_one.sh"
roster="$here/tame_style_long_fn_roster.sh"
[ -f "$one" ] && [ -f "$roster" ] || { echo "instrument=failed"; exit 1; }

ledger=$(mktemp) || exit 1
trap 'rm -f "$ledger"' EXIT

files=0
sh "$roster" | while IFS= read -r f; do
  [ -n "$f" ] || continue
  sh "$one" "$f"
done > "$ledger"
files=$(sh "$roster" | grep -c .)

total=$(grep -c ' = ' "$ledger" || true)
longest=$(grep ' = ' "$ledger" | sort -t= -k2 -rn | head -1 | sed 's/.*= //' | sed 's/ lines$//')
[ -n "$longest" ] || longest=0

echo "functions_over_70=$total longest=$longest roster_files=$files"
grep ' = ' "$ledger" | sort -t= -k2 -rn | head -10
