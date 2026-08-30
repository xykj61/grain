#!/bin/sh
# tools/fixtures/c/comlink_glow_tend_scan.sh -- Comlink's payload pedestal and the wire it stands
# on, read apart and compared.
#
# WHY THIS SHAPE. Comlink stood in the shape museum with one desk -- a dual-stack POLICY -- while
# thirty-five bounds went undisplayed, so the widest wire surface in the tree was the least shown.
# The payload ceiling is the one that earns the first desk: it sizes real buffers, gates asserts,
# and two further bounds derive from it.
#
# THIS SCAN HOLDS NO VALUE OF ITS OWN. It reads the number the desk shows, reads what the Rye
# publishes, and compares. Raise the wire honestly in both rooms and the guard stays quiet --
# a guard that reds on correct work is a guard someone turns off.
#
# WHY THE READINGS ARE SHAPED THIS WAY. This bound is a DERIVATION and its parts live in three
# different kinds of room, so no single comparison can carry it.
#
#   `wire_capacity` is a literal comlink/wire_format.rye spells for itself, so it is read there.
#   The header is a CHAIN of offsets, four fifths of it decided inside the crypto library --
#   ChaCha20Poly1305's nonce and tag, Sha3_512's digest, Kumara's signature -- which a shell
#   cannot evaluate. So the desk lists the composition and the scan checks the part it can: the
#   field NAMES and their ORDER against the offset chain the Rye actually composes. Swap two
#   widths and keep the total, and the names still catch the reshaped envelope.
#   The number itself is then read as `wire_capacity - <the header the desk shows>`, which ties
#   the desk to the deciding room through its own arithmetic.
#
# THE PART THE SHELL GENUINELY CANNOT REACH is those four library widths, and the honest answer
# is not to pretend otherwise here. It is the comptime tie: `max_wire_payload <= wf.max_message`
# is evaluated by the COMPILER against the real widths, so the reading a scan cannot take is
# taken by the language. That is why `ties_wired` is a reading rather than a nicety -- delete the
# blocks and every number in this scan still agrees over a wire nothing proves a payload fits.
#
# THE TIE COUNT IS A FLOOR RATHER THAN AN EQUALITY. Two of the three copying modules live in
# mantra/ and hold the tie; amphora/vessel_fetch_wire.rye carries the same literal in the same
# shape and is Amphora's room to tie. A gate spelled `= 2` would red on their honest work the day
# they take it, so the floor welcomes a third and never asks for fewer.
#
# WHAT IT READS
#   placard_order        the desk's first six placard keywords, in seated order
#   citation             whether the desk names the deciding room and the rooms that copy it
#   desk_example         the number the pedestal displays under `example`
#   desk_bound           the number the pedestal spells in its own `shape` line
#   desk_header_names    the header fields the desk lists, in the order it lists them
#   desk_header_sum      those fields' widths, added
#   rye_header_names     the offset chain comlink/wire_format.rye composes, in source order
#   rye_wire_capacity    the capacity that module publishes
#   derived_payload      wire_capacity minus the header the desk shows
#   wire_derives         whether max_message is still DERIVED rather than respelled as a literal
#   literal_rooms        the modules spelling max_wire_payload as a bare number
#   literal_values       the numbers they spell, sorted unique
#   ties_wired           how many of those rooms hold the comptime tie to the wire
#   rehearsal_tie        whether the elder tie in comlink/rehearsal_wire.rye still stands
#   verdict              agree, or the first disagreement found
#
# USAGE
#   sh tools/fixtures/c/comlink_glow_tend_scan.sh [<root>]
#
# Driven by tools/co/comlink_glow_tend_witness.rish. Run from the repository root.

set -eu

root=${1:-.}
desk="$root/src/shape/shape-comlink-wire-payload-bound.glow"
wire="$root/comlink/wire_format.rye"
rehearsal="$root/comlink/rehearsal_wire.rye"

# The rooms that spell the ceiling as a bare literal. Two are Mantra's and one is Amphora's; they
# are named by their comlink/ face because that is the module a reader is standing in.
literal_rooms='comlink/recall_sync_wire.rye comlink/recall_tablecloth_query_wire.rye comlink/vessel_fetch_wire.rye'

expect_order='name shape invariant example readers nib'

# The placard's six lines come before any rune, in one seated order (src/shape/PLACARD.md). Prose
# lines below carry no keyword at column five, so the keywords are gathered and then cut at six.
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

# The bound a pedestal spells in its own `shape` line. A bound desk writes its number TWICE, and
# a desk read only under `example` can part from itself inside one file with nothing to say so.
bound_of() {
  if [ -f "$1" ]; then
    got=$(sed -n 's/^::  shape .*bound \([0-9][0-9]*\).*$/\1/p' "$1" | head -1)
    [ -n "$got" ] || got=none
    printf '%s\n' "$got"
  else
    printf 'none\n'
  fi
}

# The header composition the desk lists, read from a delimited region rather than from prose --
# the same discipline the error and name desks keep, and for the same reason: prose carries other
# words, and a guard reading whichever ones happen to be there is a guard the next paragraph
# breaks. The region opens and closes on two fixed sentences the desk keeps.
header_region() {
  if [ -f "$1" ]; then
    sed -n '/^::  the header the datagram spends before its message, in the order wire_format composes it:$/,/^::  that is /p' "$1" \
      | sed -n 's/^::    //p'
  fi
}

placard_order=$(placard_of "$desk")
echo "placard_order=$placard_order"

# A derived bound is decided in one room and copied into others, so its pedestal owes a reader
# every address: the room that decides the number, the room whose compiler already proved the
# law, and the room the desk names as another hand's to tie.
citation=no
if [ -f "$desk" ] \
  && grep -q 'comlink/wire_format.rye' "$desk" \
  && grep -q 'comlink/rehearsal_wire.rye' "$desk" \
  && grep -q 'amphora/vessel_fetch_wire.rye' "$desk"; then
  citation=yes
fi
echo "citation=$citation"

desk_example=$(example_of "$desk")
echo "desk_example=$desk_example"
desk_bound=$(bound_of "$desk")
echo "desk_bound=$desk_bound"

region=$(header_region "$desk")
desk_header_names=$(printf '%s\n' "$region" | tr ' -' '\n\n' | sed -n 's/^\([a-z][a-z_]*\)$/\1/p' | tr '\n' ' ' | sed 's/ *$//')
echo "desk_header_names=$desk_header_names"
desk_header_sum=$(printf '%s\n' "$region" | tr ' -' '\n\n' | sed -n 's/^\([0-9][0-9]*\)$/\1/p' \
  | awk 'BEGIN{s=0} {s+=$1} END{print s+0}')
echo "desk_header_sum=$desk_header_sum"

# The offset chain the Rye composes, in source order. The last offset names where the ciphertext
# starts rather than a field the header spends, so it is dropped: five spends, five names.
rye_header_names=none
if [ -f "$wire" ]; then
  got=$(sed -n 's/^pub const off_\([a-z_]*\): u64 = .*/\1/p' "$wire" | sed '$d' | tr '\n' ' ' | sed 's/ *$//')
  [ -z "$got" ] || rye_header_names=$got
fi
echo "rye_header_names=$rye_header_names"

rye_wire_capacity=none
if [ -f "$wire" ]; then
  got=$(sed -n 's/^pub const wire_capacity: u64 = \([0-9][0-9]*\);$/\1/p' "$wire" | head -1)
  [ -z "$got" ] || rye_wire_capacity=$got
fi
echo "rye_wire_capacity=$rye_wire_capacity"

derived_payload=none
if [ "$rye_wire_capacity" != none ] && [ "$desk_header_sum" -gt 0 ] 2>/dev/null; then
  derived_payload=$((rye_wire_capacity - desk_header_sum))
fi
echo "derived_payload=$derived_payload"

# The link itself, read rather than inferred: values agreeing proves nothing about whether the
# ceiling still follows the envelope. Respell this line as a literal and every number still
# agrees while the derivation is gone.
wire_derives=no
if [ -f "$wire" ] \
  && grep -q '^pub const max_message: u64 = wire_capacity - off_cipher;$' "$wire"; then
  wire_derives=yes
fi
echo "wire_derives=$wire_derives"

echo "literal_rooms=$literal_rooms"

# The numbers the copying rooms spell, gathered as a set. One room drifting shows up as a second
# value here, which is what a desk-only reading would stay quiet about.
values=''
rooms_found=0
for rel in $literal_rooms; do
  f="$root/$rel"
  [ -f "$f" ] || continue
  rooms_found=$((rooms_found + 1))
  v=$(sed -n 's/^pub const max_wire_payload: u32 = \([0-9][0-9]*\);$/\1/p' "$f" | head -1)
  [ -n "$v" ] || v=none
  values="$values $v"
done
literal_values=$(printf '%s\n' $values | sort -u | tr '\n' ' ' | sed 's/ *$//')
[ -n "$literal_values" ] || literal_values=none
echo "literal_rooms_found=$rooms_found"
echo "literal_values=$literal_values"

# The comptime tie, counted per room. This is the reading a shell cannot take for itself: the
# compiler evaluates `max_wire_payload <= wf.max_message` against the real library widths.
ties_wired=0
for rel in $literal_rooms; do
  f="$root/$rel"
  [ -f "$f" ] || continue
  if grep -q 'assert(max_wire_payload <= wf\.max_message);' "$f"; then
    ties_wired=$((ties_wired + 1))
  fi
done
echo "ties_wired=$ties_wired"

rehearsal_tie=no
if [ -f "$rehearsal" ] && grep -q 'assert(payload_max <= wf\.max_message);' "$rehearsal"; then
  rehearsal_tie=yes
fi
echo "rehearsal_tie=$rehearsal_tie"

verdict=agree
if [ ! -f "$desk" ]; then
  verdict=desk_missing
elif [ "$placard_order" != "$expect_order" ]; then
  verdict=placard_wrong
elif [ "$citation" != yes ]; then
  verdict=citation_missing
elif [ "$desk_example" = none ]; then
  verdict=example_missing
elif [ "$desk_bound" = none ]; then
  verdict=bound_missing
elif [ "$desk_bound" != "$desk_example" ]; then
  verdict=desk_self_disagree
elif [ -z "$desk_header_names" ]; then
  verdict=header_missing
elif [ "$rye_header_names" = none ]; then
  verdict=rye_header_missing
elif [ "$desk_header_names" != "$rye_header_names" ]; then
  verdict=header_names_disagree
elif [ "$rye_wire_capacity" = none ]; then
  verdict=capacity_missing
elif [ "$derived_payload" = none ]; then
  verdict=derivation_unreadable
elif [ "$desk_example" != "$derived_payload" ]; then
  verdict=payload_disagree
elif [ "$wire_derives" != yes ]; then
  verdict=derivation_lost
elif [ "$rooms_found" -eq 0 ]; then
  verdict=literal_rooms_missing
elif [ "$literal_values" != "$desk_example" ]; then
  verdict=literals_disagree
elif [ "$ties_wired" -lt 2 ]; then
  verdict=tie_unwired
elif [ "$rehearsal_tie" != yes ]; then
  verdict=rehearsal_tie_lost
fi

echo "verdict=$verdict"
[ "$verdict" = agree ] || exit 1
