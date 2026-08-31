#!/bin/sh
# tools/fixtures/c/comlink_nesting_scan.sh -- the link-frame nesting relation, read across the
# room that owns the frame and the room that owns the datagram.
#
# WHY THIS SHAPE. Every layer of a network stack wraps the layer above it, so each container has
# to hold its own header plus the whole payload it carries --
#
#     container >= header + payload
#
# -- and Comlink has two such layers. The inner one is DERIVED: comlink/wire_format.rye writes
# `max_message = wire_capacity - off_cipher`, so the payload is whatever the header leaves and
# the relation cannot come apart. The outer one is SPELLED: `max_frame` is the literal 554 in
# comlink/virtio_net.rye and `wire_capacity` is the literal 528 in comlink/wire_format.rye, and
# until 20260830 a doc comment was the only thing joining them.
#
# WHAT BREAKING IT LOOKS LIKE, MEASURED. Raising wire_capacity 528 -> 576 and changing nothing
# else: the freestanding guest still builds green for riscv64, and the same arithmetic run hosted
# reads `index out of bounds: index 602, len 554`. Nothing refuses at build time, and the overrun
# lands in a guest with no operating system underneath it to notice.
#
# THIS SCAN HOLDS NO VALUE OF ITS OWN. It reads the two rows the desk displays, reads the same
# numbers out of the Rye that publishes them, and computes the relation rather than pinning it.
# Raise the frame honestly and the guard stays quiet, because a guard that reds on correct work
# is a guard someone turns off.
#
# WHY THE HEADER WIDTH IS SUMMED RATHER THAN PINNED. `virtio_net_hdr_len` is
# `@sizeOf(VirtioNetHdr)`, not a literal, so this scan sums the struct's own field widths. That
# sum is the size only while the struct carries no padding, which comlink/device_wire.rye proves
# at comptime -- so `padding_proof_written` reads whether that proof still stands. Delete it and
# the sum stops being justified, and this scan says so rather than carrying on.
#
# WHAT THIS SCAN CITES RATHER THAN RESTATES. `off_cipher` is a chain of crypto library widths --
# a nonce, a digest, a signature, a tag -- none of them literals in this tree. Pinning 188 here
# would be the borrowed-number class REDS %341 and %357 both booked. So the datagram row is
# checked for internal agreement and for its derivation still being written, and its header value
# belongs to the wire-payload desk, which tools/co/comlink_glow_tend_witness.rish already guards.
#
# THE PART A SHELL CANNOT REACH is whether a tie the compiler evaluates still stands. `ties_wired`
# counts the comptime block by its text, which proves it is WRITTEN; the sibling probe hands the
# same question to the language, which is the only reader that can prove it HOLDS.
#
# THE TIE COUNT IS A FLOOR RATHER THAN AN EQUALITY. One room sees both numbers today. A guest
# taking its own copy of the tie is better work, and a gate spelled `= 1` would red on it.
#
# WHAT IT READS
#   placard_order          the desk's six placard keywords, in seated order
#   citation               whether the desk names both rooms and the room that ties them
#   desk_layers            how many nesting rows the desk displays
#   desk_rows              those rows, as layer:container:header:payload:need:slack
#   rye_frame              the frame row's three numbers read out of the Rye
#   rye_hdr_sum            VirtioNetHdr's field widths, summed
#   rows_agree             whether the desk and the Rye say the same thing
#   desk_capacity_agrees   whether the need and slack the desk displays match that arithmetic
#   capacity_holds         how many layers satisfy container >= header + payload, computed here
#   tightest               every layer with the least room, and how much room they have
#   derivation_written     whether max_message is still derived from wire_capacity - off_cipher
#   padding_proof_written  whether the no-padding proof the header sum leans on still stands
#   ties_wired             how many rooms carry the nesting relation at comptime (a floor, >= 1)
#   lay_sites              how many guests lay a datagram into the frame (reported, never gated)
#   verdict                ok, or the first disagreement found
#
# USAGE
#   sh tools/fixtures/c/comlink_nesting_scan.sh
#
# Driven by tools/co/comlink_nesting_witness.rish. Run from the repository root.

set -eu

desk="src/shape/shape-comlink-link-frame-nesting.glow"
vnet="comlink/virtio_net.rye"
wfmt="comlink/wire_format.rye"
dwire="comlink/device_wire.rye"

for f in "$desk" "$vnet" "$wfmt" "$dwire"; do
  [ -f "$f" ] || { echo "verdict=file_missing"; echo "detail: $f"; exit 1; }
done

verdict=ok
fail() { [ "$verdict" = ok ] && verdict="$1"; echo "detail: $2"; }

# Read one `pub const <name>: <type> = <literal>;` out of a Rye file. Literals only -- a value
# built from an expression is composed here from its own named parts, never guessed.
rye_const() {
  sed -n "s/^\(pub \)\{0,1\}const $2: u[0-9]* = \([0-9][0-9]*\);.*/\2/p" "$1" | head -1
}

# -- the placard, in seated order -----------------------------------------------------------
placard_order=$(sed -n 's/^::  \([a-z][a-z]*\) .*/\1/p' "$desk" | head -6 | tr '\n' '-' | sed 's/-$//')
echo "placard_order=$placard_order"
[ "$placard_order" = "name-shape-invariant-example-readers-nib" ] \
  || fail placard_wrong "the six placard lines are not in seated order: $placard_order"

citation=ok
for room in "$vnet" "$wfmt" "$dwire"; do
  grep -q "$room" "$desk" || { citation=missing; fail citation_missing "the desk does not name $room"; }
done
echo "citation=$citation"

# -- the rows the desk displays --------------------------------------------------------------
# Each row is nine tokens: layer  cname cval  hname hval  pname pval  need slack. BSD sed BRE has
# no alternation, so the row match is grep -E: a sed \| here reads as a literal pipe on this
# bench and silently matches nothing, which is a guard that fails open (REDS %358's own class).
desk_rows=$(grep -E "^::    (datagram|frame)  " "$desk" \
  | awk '{ printf "%s:%s:%s:%s:%s:%s\n", $2, $4, $6, $8, $9, $10 }' | sort | tr '\n' ' ' | sed 's/ $//')
desk_layers=$(printf '%s' "$desk_rows" | tr ' ' '\n' | grep -c ':' || true)
echo "desk_layers=$desk_layers"
echo "desk_rows=$desk_rows"
[ "$desk_layers" -eq 2 ] || fail desk_layers_wrong "the desk displays $desk_layers nesting rows, wanted 2"

# -- the frame row, read out of the Rye ------------------------------------------------------
max_frame=$(rye_const "$vnet" max_frame)
eth_len=$(rye_const "$vnet" eth_header_len)
wire_cap=$(rye_const "$wfmt" wire_capacity)
for v in "$max_frame" "$eth_len" "$wire_cap"; do
  [ -n "$v" ] || { echo "verdict=constant_unreadable"; echo "detail: a named bound no longer reads as a literal"; exit 1; }
done

# VirtioNetHdr's own width, summed from its field types rather than pinned at 12.
hdr_sum=$(awk '
  /^pub const VirtioNetHdr = extern struct \{/ { inside = 1; next }
  inside && /^\};/ { inside = 0 }
  inside && /: *u(8|16|32|64) *,/ {
    match($0, /u(8|16|32|64)/)
    bits = substr($0, RSTART + 1, RLENGTH - 1) + 0
    total += bits / 8
  }
  END { print total + 0 }
' "$vnet")
echo "rye_hdr_sum=$hdr_sum"
[ "$hdr_sum" -gt 0 ] || fail hdr_unreadable "VirtioNetHdr's fields no longer read as widths"

link_headers=$((hdr_sum + eth_len))
echo "rye_frame=max_frame:$max_frame link_headers:$link_headers wire_capacity:$wire_cap"

# -- the desk and the Rye, compared ----------------------------------------------------------
frame_row=$(printf '%s' "$desk_rows" | tr ' ' '\n' | grep '^frame:' || true)
dgram_row=$(printf '%s' "$desk_rows" | tr ' ' '\n' | grep '^datagram:' || true)
want_frame="frame:$max_frame:$link_headers:$wire_cap"
rows_agree=yes
case "$frame_row" in
  "$want_frame":*) ;;
  *) rows_agree=no; fail rows_disagree "the desk's frame row reads $frame_row, the Rye reads $want_frame" ;;
esac
dgram_container=$(printf '%s' "$dgram_row" | cut -d: -f2)
[ "$dgram_container" = "$wire_cap" ] \
  || { rows_agree=no; fail rows_disagree "the desk's datagram container reads $dgram_container, wire_format publishes $wire_cap"; }
echo "rows_agree=$rows_agree"

# -- the relation, computed here rather than pinned ------------------------------------------
capacity_holds=0
tightest=""
tightest_slack=""
desk_capacity_agrees=yes
for row in $desk_rows; do
  layer=$(printf '%s' "$row" | cut -d: -f1)
  container=$(printf '%s' "$row" | cut -d: -f2)
  header=$(printf '%s' "$row" | cut -d: -f3)
  payload=$(printf '%s' "$row" | cut -d: -f4)
  shown_need=$(printf '%s' "$row" | cut -d: -f5)
  shown_slack=$(printf '%s' "$row" | cut -d: -f6)
  need=$((header + payload))
  slack=$((container - need))
  [ "$shown_need" = "$need" ] && [ "$shown_slack" = "$slack" ] \
    || { desk_capacity_agrees=no; fail desk_arithmetic_wrong "$layer displays need=$shown_need slack=$shown_slack, the arithmetic gives $need and $slack"; }
  if [ "$slack" -ge 0 ]; then
    capacity_holds=$((capacity_holds + 1))
  else
    fail capacity_short "$layer holds $container and needs $need -- short by $((0 - slack))"
  fi
  # Both layers sit at zero today, so a first-wins tightest would name one of them arbitrarily.
  # Every layer at the minimum is listed instead, since which ones are on the line is the reading.
  if [ -z "$tightest_slack" ] || [ "$slack" -lt "$tightest_slack" ]; then
    tightest_slack=$slack
    tightest="$layer"
  elif [ "$slack" -eq "$tightest_slack" ]; then
    tightest="$tightest,$layer"
  fi
done
tightest="$tightest:$tightest_slack"
echo "desk_capacity_agrees=$desk_capacity_agrees"
echo "capacity_holds=$capacity_holds"
echo "tightest=$tightest"
[ "$capacity_holds" -eq "$desk_layers" ] || fail capacity_short "not every layer carries what it nests"

# -- the derivation the inner layer's safety rests on ----------------------------------------
if grep -q '^pub const max_message: u64 = wire_capacity - off_cipher;' "$wfmt"; then
  derivation_written=yes
else
  derivation_written=no
  fail derivation_gone "max_message is no longer derived from wire_capacity - off_cipher"
fi
echo "derivation_written=$derivation_written"

# -- the proof the summed header width leans on ----------------------------------------------
if grep -q 'comptime assert(no_padding(vn.VirtioNetHdr));' "$dwire"; then
  padding_proof_written=yes
else
  padding_proof_written=no
  fail padding_proof_gone "the no-padding proof is gone, so summing VirtioNetHdr's fields no longer gives its size"
fi
echo "padding_proof_written=$padding_proof_written"

# -- the tie, counted by its text (the probe asks the compiler) ------------------------------
ties_wired=$(grep -rlF 'comptime assert(vn.frame_carries(' comlink/ --include='*.rye' 2>/dev/null | wc -l | tr -d ' ')
echo "ties_wired=$ties_wired"
[ "$ties_wired" -ge 1 ] || fail tie_missing "no room evaluates frame_carries at comptime"
grep -q '^pub fn frame_carries(wire_capacity: u32) bool {' "$vnet" \
  || fail relation_missing "virtio_net.rye no longer publishes frame_carries"

# -- who leans on it, reported and never gated -----------------------------------------------
lay_sites=$(grep -lF 'const total: u32 = poff + dg_len;' comlink/guest_*.rye 2>/dev/null | wc -l | tr -d ' ')
echo "lay_sites=$lay_sites"

echo "verdict=$verdict"
[ "$verdict" = ok ] || exit 1
