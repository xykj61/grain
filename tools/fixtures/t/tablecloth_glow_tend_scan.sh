#!/bin/sh
# tools/fixtures/t/tablecloth_glow_tend_scan.sh -- the Tablecloth pedestal and its Rye source,
# read apart and compared.
#
# WHY THIS SHAPE. A Glow Tend pedestal names a bound that a Rye module already holds, so the
# pedestal earns its place only while the two agree. Every elder Tend witness in this tree checks
# that agreement by grepping for the LITERAL number twice -- `example    48` in the desk and
# `max_name_len: u32 = 48` in the Rye -- which writes the value a THIRD time, inside the guard.
# Raise such a bound honestly in both real rooms and the guard still reds, because the copy nobody
# thought of has not moved. A guard that reds on correct work is a guard someone turns off.
#
# So this scan holds no value of its own. It reads the number the desk shows, reads the number the
# Rye publishes, and compares them. The bound may move; the question it answers does not.
#
# WHAT IT READS
#   placard_order      the first six placard keywords, in the order src/shape/PLACARD.md seats
#   citation           whether the desk names the Rye file its number comes from
#   desk_example       the number the pedestal displays
#   rye_max_artifacts  the number brushstroke/tablecloth.rye publishes
#   verdict            agree, or the one reading that refused
#
# WHAT IT DOES NOT READ. Whether 32 is the right capacity, and whether the desk lowers and runs --
# the witness drives the Zig toolchain for that, and this stays a pure text reading so a control
# can run it eight times in a pen for nothing.
#
# USAGE
#   sh tools/fixtures/t/tablecloth_glow_tend_scan.sh [<root>]
#
# Driven by tools/t/tablecloth_glow_tend_witness.rish. Run from the repository root.

set -eu

root=${1:-.}
desk="$root/src/shape/shape-tablecloth-catalog-capacity.glow"
rye="$root/brushstroke/tablecloth.rye"

# The placard's six lines come before any rune, in one seated order (src/shape/PLACARD.md). A
# continuation line under `shape` carries no keyword at column five, so it is read past rather
# than counted -- which is why the keywords are gathered and then cut at six.
placard_order=none
if [ -f "$desk" ]; then
  placard_order=$(sed -n 's/^::  \([a-z][a-z]*\)  .*/\1/p' "$desk" \
    | head -6 | tr '\n' ' ' | sed 's/ *$//')
  [ -n "$placard_order" ] || placard_order=none
fi
echo "placard_order=$placard_order"

# A pedestal that names no source is a number with nowhere to be checked against.
citation=no
if [ -f "$desk" ] && grep -q 'brushstroke/tablecloth.rye' "$desk"; then
  citation=yes
fi
echo "citation=$citation"

desk_example=none
if [ -f "$desk" ]; then
  found=$(sed -n 's/^::  example  *\([0-9][0-9]*\) *$/\1/p' "$desk" | head -1)
  [ -z "$found" ] || desk_example=$found
fi
echo "desk_example=$desk_example"

rye_max_artifacts=none
if [ -f "$rye" ]; then
  found=$(sed -n 's/^pub const max_artifacts: u32 = \([0-9][0-9]*\);$/\1/p' "$rye" | head -1)
  [ -z "$found" ] || rye_max_artifacts=$found
fi
echo "rye_max_artifacts=$rye_max_artifacts"

expect_order='name shape invariant example readers nib'

verdict=agree
if [ ! -f "$desk" ]; then
  verdict=desk_missing
elif [ ! -f "$rye" ]; then
  verdict=rye_missing
elif [ "$placard_order" != "$expect_order" ]; then
  verdict=placard_wrong
elif [ "$citation" != yes ]; then
  verdict=citation_missing
elif [ "$desk_example" = none ]; then
  verdict=desk_example_missing
elif [ "$rye_max_artifacts" = none ]; then
  verdict=rye_bound_missing
elif [ "$desk_example" != "$rye_max_artifacts" ]; then
  verdict=disagree
fi

echo "verdict=$verdict"
[ "$verdict" = agree ] || exit 1
