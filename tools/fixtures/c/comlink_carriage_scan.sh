#!/bin/sh
# tools/fixtures/c/comlink_carriage_scan.sh -- the chunked-carriage relation, read across the
# rooms that split a whole and the rooms that carry the pieces.
#
# WHY THIS SHAPE. Three families in this tree cut a whole into pieces and carry them, and each
# publishes three numbers: the whole's ceiling, one piece's size, and the most pieces allowed.
# For a whole the module ACCEPTS to actually cross, one relation must hold --
#
#     whole <= pieces * piece_size
#
# -- and it held in all three, stated nowhere, until 20260830. The bead family held it by
# exactly zero margin: 512 <= 8 * 64, where the 64 is a chunker TUNING constant filed beside a
# hash mask rather than beside a carriage bound.
#
# WHAT BREAKING IT LOOKS LIKE, MEASURED. Raising max_resin_bytes 512 -> 576 and changing nothing
# else refuses 9 of 3,999 pseudorandom wholes with TooManyBeads -- a legal input refused by the
# module that accepted it two lines earlier. It is content-dependent, so 3,990 of those wholes
# pass, which is exactly why a single-fixture test would ship it.
#
# THIS SCAN HOLDS NO VALUE OF ITS OWN. It reads the trios the desk displays, reads the same
# numbers out of the Rye, and computes the relation rather than pinning it. Raise a bound
# honestly in both rooms and the guard stays quiet, because a guard that reds on correct work is
# a guard someone turns off.
#
# THE SLACK IS REPORTED, NEVER GATED, for the same reason. A lap that gives beading real
# headroom moves the tightest slack from 0 upward, and that is better work rather than a fault.
#
# THE PART A SHELL CANNOT REACH is whether a tie the compiler evaluates still stands. `ties_wired`
# counts the comptime blocks by their text, which proves they are WRITTEN; the sibling probe
# hands the same question to the language, which is the only reader that can prove they HOLD.
#
# EVERY CARRIAGE ROOM CARRIES ITS OWN TIE, and the gate wants all three. Two families live in
# mantra/ and a third in amphora/vessel_fetch_wire.rye, which tied its own room 20260906. The
# elder gate was a floor of two, written while only the mantra pair was tied, and it read every
# room for ANY of the three patterns rather than for its own. That was single-drop detection by
# accident of the population: with two rooms tied, one dropping its tie read 1 and refused. The
# third tie took the count to 3, a single drop left 2, and the floor stopped biting -- control
# cases 16 and 17 went quiet the same hour, which is how this was found. Three of three is what
# the sentence meant, it is the same shape as capacity_holds below, and a fourth family joins
# the list and the count in the commit that creates it.
#
# WHAT IT READS
#   placard_order    the desk's six placard keywords, in seated order
#   citation         whether the desk names the rooms each family lives in
#   desk_families    how many carriage trios the desk displays
#   desk_rows        those trios, as family:whole:piece:pieces
#   rye_rows         the same trios read out of the Rye that publishes them
#   rows_agree       whether the desk and the Rye say the same thing
#   desk_capacity_agrees  whether the capacity and slack the desk displays match that arithmetic
#   capacity_holds   how many trios satisfy whole <= pieces * piece, by arithmetic here
#   tightest         the family with the least room, and how much room it has
#   ties_wired       how many rooms carry the carriage relation at comptime (wanted: all 3)
#   verdict          ok, or the first disagreement found
#
# USAGE
#   sh tools/fixtures/c/comlink_carriage_scan.sh
#
# Driven by tools/co/comlink_carriage_witness.rish. Run from the repository root.

set -eu

desk="src/shape/shape-comlink-chunked-carriage-bound.glow"
beading="mantra/beading.rye"
lap1="mantra/recall_lap1.rye"
batch_wire="mantra/recall_batch_wire.rye"
resin_batch="mantra/resin_batch.rye"
sync_wire="mantra/recall_sync_wire.rye"
vessel="amphora/vessel_fetch_wire.rye"

for f in "$desk" "$beading" "$lap1" "$batch_wire" "$resin_batch" "$sync_wire" "$vessel"; do
  [ -f "$f" ] || { echo "verdict=file_missing"; echo "detail: $f"; exit 1; }
done

verdict=ok
fail() { [ "$verdict" = ok ] && verdict="$1"; echo "detail: $2"; }

# Read one `pub const <name>: <type> = <literal>;` out of a Rye file. Literals only -- an
# expression is composed here from its own named parts, so the scan never guesses a value.
rye_const() {
  sed -n "s/^\(pub \)\{0,1\}const $2: u[0-9]* = \([0-9][0-9]*\);.*/\2/p" "$1" | head -1
}

# -- the placard, in seated order -----------------------------------------------------------
placard_order=$(sed -n 's/^::  \([a-z][a-z]*\) .*/\1/p' "$desk" | head -6 | tr '\n' '-' | sed 's/-$//')
echo "placard_order=$placard_order"
[ "$placard_order" = "name-shape-invariant-example-readers-nib" ] \
  || fail placard_wrong "the six placard lines are not in seated order: $placard_order"

citation=ok
for room in "$beading" "$batch_wire" "$resin_batch" "$vessel"; do
  grep -q "$room" "$desk" || { citation=missing; fail citation_missing "the desk does not name $room"; }
done
echo "citation=$citation"

# -- the trios the desk displays ------------------------------------------------------------
# The desk's table rows read: family  rooms...  whole  piece  pieces  capacity  slack
# BSD sed BRE has no alternation, so the row match is grep -E: a sed \| here reads as a
# literal pipe on this bench and silently matches nothing, which is a guard that fails open.
desk_rows=$(grep -E "^::    (batch|vessel|bead) " "$desk" \
  | awk '{ n = NF; printf "%s:%s:%s:%s\n", $2, $(n-4), $(n-3), $(n-2) }' | sort | tr '\n' ' ' | sed 's/ $//')
desk_families=$(printf '%s' "$desk_rows" | tr ' ' '\n' | grep -c ':' || true)
echo "desk_families=$desk_families"
echo "desk_rows=$desk_rows"
[ "$desk_families" -eq 3 ] || fail desk_families_wrong "the desk displays $desk_families carriage trios, wanted 3"

# -- the same trios, read out of the Rye ----------------------------------------------------
batch_whole=$(rye_const "$resin_batch" max_batch_bytes)
batch_wire_payload=$(rye_const "$sync_wire" max_wire_payload)
batch_hdr=$(rye_const "$batch_wire" chunk_header_len)
batch_pieces=$(rye_const "$batch_wire" max_batch_chunks)

bead_whole=$(rye_const "$beading" max_resin_bytes)
bead_piece=$(rye_const "$beading" cdc_min_bead)
bead_pieces=$(rye_const "$beading" max_beads)

vessel_whole=$(rye_const "$vessel" max_resin_bytes)
vessel_payload=$(rye_const "$vessel" max_wire_payload)
vessel_digest_hex=$(rye_const "$vessel" digest_hex_len)
vessel_pieces=$(rye_const "$vessel" max_resin_chunks)

for v in "$batch_whole" "$batch_wire_payload" "$batch_hdr" "$batch_pieces" \
         "$bead_whole" "$bead_piece" "$bead_pieces" \
         "$vessel_whole" "$vessel_payload" "$vessel_digest_hex" "$vessel_pieces"; do
  [ -n "$v" ] || { echo "verdict=constant_unreadable"; echo "detail: a named bound no longer reads as a literal"; exit 1; }
done

# `max_chunk_body` is an expression in both wire rooms, so it is COMPOSED here from the named
# parts rather than read as a number -- the same reading the compiler takes.
batch_piece=$((batch_wire_payload - batch_hdr))
# amphora's chunk header: kind + digest hex + index + count + total_len.
vessel_hdr=$((1 + vessel_digest_hex + 2 + 2 + 4))
vessel_piece=$((vessel_payload - vessel_hdr))

rye_rows=$(printf 'batch:%s:%s:%s\nbead:%s:%s:%s\nvessel:%s:%s:%s\n' \
  "$batch_whole" "$batch_piece" "$batch_pieces" \
  "$bead_whole" "$bead_piece" "$bead_pieces" \
  "$vessel_whole" "$vessel_piece" "$vessel_pieces" | sort | tr '\n' ' ' | sed 's/ $//')
echo "rye_rows=$rye_rows"

if [ "$desk_rows" = "$rye_rows" ]; then
  rows_agree=yes
else
  rows_agree=no
  fail rows_disagree "the desk shows [$desk_rows] and the Rye publishes [$rye_rows]"
fi
echo "rows_agree=$rows_agree"

# -- the relation itself, computed rather than pinned ---------------------------------------
capacity_holds=0
tightest_family=none
tightest_slack=-1
for row in $rye_rows; do
  fam=$(printf '%s' "$row" | cut -d: -f1)
  whole=$(printf '%s' "$row" | cut -d: -f2)
  piece=$(printf '%s' "$row" | cut -d: -f3)
  pieces=$(printf '%s' "$row" | cut -d: -f4)
  cap=$((pieces * piece))
  slack=$((cap - whole))
  if [ "$slack" -ge 0 ]; then
    capacity_holds=$((capacity_holds + 1))
  else
    fail capacity_broken "$fam accepts $whole and carries at most $cap -- a legal whole cannot cross"
  fi
  if [ "$tightest_slack" -lt 0 ] || [ "$slack" -lt "$tightest_slack" ]; then
    tightest_slack=$slack
    tightest_family=$fam
  fi
done
# The desk DISPLAYS a capacity and a slack beside each trio, and a teaching surface that
# lies in its own table teaches the wrong number. Read here against the arithmetic above,
# so the desk cannot show a whole and a capacity that disagree.
desk_capacity_agrees=yes
for row in $(grep -E "^::    (batch|vessel|bead) " "$desk" \
  | awk '{ n = NF; printf "%s:%s:%s:%s:%s:%s\n", $2, $(n-4), $(n-3), $(n-2), $(n-1), $n }'); do
  fam=$(printf '%s' "$row" | cut -d: -f1)
  whole=$(printf '%s' "$row" | cut -d: -f2)
  piece=$(printf '%s' "$row" | cut -d: -f3)
  pieces=$(printf '%s' "$row" | cut -d: -f4)
  shown_cap=$(printf '%s' "$row" | cut -d: -f5)
  shown_slack=$(printf '%s' "$row" | cut -d: -f6)
  want_cap=$((pieces * piece))
  want_slack=$((want_cap - whole))
  if [ "$shown_cap" != "$want_cap" ] || [ "$shown_slack" != "$want_slack" ]; then
    desk_capacity_agrees=no
    fail desk_capacity_wrong "$fam shows capacity $shown_cap slack $shown_slack, the arithmetic gives $want_cap and $want_slack"
  fi
done
echo "desk_capacity_agrees=$desk_capacity_agrees"

echo "capacity_holds=$capacity_holds"
echo "tightest=$tightest_family:$tightest_slack"
[ "$capacity_holds" -eq 3 ] || fail capacity_incomplete "only $capacity_holds of 3 trios satisfy the relation"

# -- the ties the compiler evaluates --------------------------------------------------------
# Counted by their text, which proves they are written. The probe proves they hold.
# Each room is asked for ITS OWN tie, so one room dropping its tie is visible whatever the
# other rooms carry -- the elder form asked every room for any of the three patterns.
ties_wired=0
if grep -q 'max_resin_bytes <= max_beads \* cdc_min_bead' "$beading"; then
  ties_wired=$((ties_wired + 1))
fi
if grep -q 'max_batch_bytes <= @as(u32, max_batch_chunks) \* max_chunk_body' "$batch_wire"; then
  ties_wired=$((ties_wired + 1))
fi
if grep -q 'max_resin_bytes <= @as(u32, max_resin_chunks) \* max_chunk_body' "$vessel"; then
  ties_wired=$((ties_wired + 1))
fi
echo "ties_wired=$ties_wired"
[ "$ties_wired" -eq 3 ] || fail ties_missing "only $ties_wired of 3 rooms carry the carriage tie at comptime"

echo "verdict=$verdict"
[ "$verdict" = ok ] || exit 1
