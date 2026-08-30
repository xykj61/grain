#!/bin/sh
# tools/fixtures/t/tablecloth_glow_tend_scan.sh -- Tablecloth's pedestals and their Rye sources,
# read apart and compared.
#
# WHY THIS SHAPE. A Glow Tend pedestal names a bound that a Rye module already holds, so the
# pedestal earns its place only while the two agree. Every elder Tend witness in this tree checks
# that agreement by grepping for the LITERAL number twice -- `example    48` in the desk and
# `max_name_len: u32 = 48` in the Rye -- which writes the value a THIRD time, inside the guard.
# Raise such a bound honestly in both real rooms and the guard still reds, because the copy nobody
# thought of has not moved. A guard that reds on correct work is a guard someone turns off.
#
# So this scan holds no value of its own. It reads the number each desk shows, reads the number the
# Rye publishes, and compares them. The bound may move; the question it answers does not.
#
# TWO PEDESTALS, AND WHY THE SECOND IS DIFFERENT. `max_artifacts` is a literal that
# brushstroke/tablecloth.rye spells for itself, so its desk is compared against that one file.
# `max_content_bytes` is a DERIVATION -- `= beading.max_resin_bytes` -- so tablecloth.rye names the
# bound and mantra/beading.rye decides it, and the desk's number has to be compared against the
# deciding room. That makes the derivation itself a reading: respell tablecloth's line as a literal
# and every number still agrees while the link is gone, so the next honest raise of
# `max_resin_bytes` would move one room and leave the other behind with nothing to say so.
#
# WHAT IT READS
#   placard_order              the catalog desk's first six placard keywords, in seated order
#   citation                   whether the catalog desk names the Rye file its number comes from
#   desk_example               the number the catalog pedestal displays
#   rye_max_artifacts          the number brushstroke/tablecloth.rye publishes
#   content_placard_order      the content desk's first six placard keywords, in seated order
#   content_citation           whether the content desk names BOTH the declaring and deciding files
#   content_desk_example       the number the content pedestal displays
#   beading_max_resin_bytes    the number mantra/beading.rye publishes
#   cloth_derives              whether tablecloth.rye still derives its budget from beading's
#   verdict                    agree, or the one reading that refused
#
# The catalog readings are decided before the content readings, so a fault in the elder pedestal
# names itself rather than hiding behind a younger one.
#
# WHAT IT DOES NOT READ. Whether 32 is the right capacity and 512 the right budget, and whether the
# desks lower and run -- the witness drives the Zig toolchain for that, and this stays a pure text
# reading so a control can run it nineteen times in a pen for nothing.
#
# USAGE
#   sh tools/fixtures/t/tablecloth_glow_tend_scan.sh [<root>]
#
# Driven by tools/t/tablecloth_glow_tend_witness.rish. Run from the repository root.

set -eu

root=${1:-.}
desk="$root/src/shape/shape-tablecloth-catalog-capacity.glow"
content_desk="$root/src/shape/shape-tablecloth-content-budget.glow"
rye="$root/brushstroke/tablecloth.rye"
beading="$root/mantra/beading.rye"

expect_order='name shape invariant example readers nib'

# The placard's six lines come before any rune, in one seated order (src/shape/PLACARD.md). A
# continuation line under `shape` carries no keyword at column five, so it is read past rather
# than counted -- which is why the keywords are gathered and then cut at six.
placard_of() {
  if [ -f "$1" ]; then
    got=$(sed -n 's/^::  \([a-z][a-z]*\)  .*/\1/p' "$1" | head -6 | tr '\n' ' ' | sed 's/ *$//')
    [ -n "$got" ] || got=none
    printf '%s\n' "$got"
  else
    printf 'none\n'
  fi
}

# The single literal a pedestal displays under `example`.
example_of() {
  if [ -f "$1" ]; then
    got=$(sed -n 's/^::  example  *\([0-9][0-9]*\) *$/\1/p' "$1" | head -1)
    [ -n "$got" ] || got=none
    printf '%s\n' "$got"
  else
    printf 'none\n'
  fi
}

placard_order=$(placard_of "$desk")
echo "placard_order=$placard_order"

# A pedestal that names no source is a number with nowhere to be checked against.
citation=no
if [ -f "$desk" ] && grep -q 'brushstroke/tablecloth.rye' "$desk"; then
  citation=yes
fi
echo "citation=$citation"

desk_example=$(example_of "$desk")
echo "desk_example=$desk_example"

rye_max_artifacts=none
if [ -f "$rye" ]; then
  found=$(sed -n 's/^pub const max_artifacts: u32 = \([0-9][0-9]*\);$/\1/p' "$rye" | head -1)
  [ -z "$found" ] || rye_max_artifacts=$found
fi
echo "rye_max_artifacts=$rye_max_artifacts"

content_placard_order=$(placard_of "$content_desk")
echo "content_placard_order=$content_placard_order"

# A derived bound is decided in one room and declared in another, so its pedestal owes a reader
# both addresses -- the file that names the bound, and the file that holds the number.
content_citation=no
if [ -f "$content_desk" ] \
  && grep -q 'brushstroke/tablecloth.rye' "$content_desk" \
  && grep -q 'mantra/beading.rye' "$content_desk"; then
  content_citation=yes
fi
echo "content_citation=$content_citation"

content_desk_example=$(example_of "$content_desk")
echo "content_desk_example=$content_desk_example"

beading_max_resin_bytes=none
if [ -f "$beading" ]; then
  found=$(sed -n 's/^pub const max_resin_bytes: u32 = \([0-9][0-9]*\);$/\1/p' "$beading" | head -1)
  [ -z "$found" ] || beading_max_resin_bytes=$found
fi
echo "beading_max_resin_bytes=$beading_max_resin_bytes"

# The link itself, read rather than inferred: values agreeing proves nothing about whether the
# artifact budget still follows the resin budget.
cloth_derives=no
if [ -f "$rye" ] \
  && grep -q '^pub const max_content_bytes: u32 = beading\.max_resin_bytes;$' "$rye"; then
  cloth_derives=yes
fi
echo "cloth_derives=$cloth_derives"

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
elif [ ! -f "$content_desk" ]; then
  verdict=content_desk_missing
elif [ ! -f "$beading" ]; then
  verdict=beading_missing
elif [ "$content_placard_order" != "$expect_order" ]; then
  verdict=content_placard_wrong
elif [ "$content_citation" != yes ]; then
  verdict=content_citation_missing
elif [ "$content_desk_example" = none ]; then
  verdict=content_example_missing
elif [ "$beading_max_resin_bytes" = none ]; then
  verdict=beading_bound_missing
elif [ "$cloth_derives" != yes ]; then
  verdict=derivation_broken
elif [ "$content_desk_example" != "$beading_max_resin_bytes" ]; then
  verdict=content_disagree
fi

echo "verdict=$verdict"
[ "$verdict" = agree ] || exit 1
