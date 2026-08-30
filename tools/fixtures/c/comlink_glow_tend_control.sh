#!/bin/sh
# tools/fixtures/c/comlink_glow_tend_control.sh -- the Comlink payload scan, proven both ways.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every reading is
# shown from both sides: planted and refused, then removed and welcomed. Twenty-four cases run in
# a throwaway pen holding just the six files the scan reads.
#
# THE CASES THIS GUARD EXISTS FOR, named rather than left to be found:
#
#   Case 15 is the sharpest. `max_message` is respelled as a literal 340 -- and EVERY number in
#   the scan still agrees, because 340 is what the derivation produced. The link is gone and the
#   arithmetic is untouched, so only a reading of the derivation itself can see it. That is the
#   whole argument for reading a link rather than comparing values.
#
#   Case 20 is its welcome and the reason the scan holds no value of its own: the wire is honestly
#   widened -- capacity in the Rye, both spellings on the desk, all three literals -- and walks
#   free. A guard that reds on correct work is a guard someone turns off.
#
#   Case 21 proves the composition is read rather than a remembered 188: a header field is widened
#   by four and the capacity raised by four, so the ceiling lands back on 340 by a different route.
#   The names are unchanged, so it walks free.
#
#   Case 11 is that reading's refusal. Two offsets are swapped in the Rye, which reshapes the
#   envelope while leaving its total width alone -- every number agrees and the order does not.
#
#   Case 17 holds the tie. One comptime block is deleted, and the desk, the derivation, and all
#   three literals still agree perfectly over a wire nothing proves a payload fits.
#
#   Case 22 is the tie count's own welcome. Amphora ties its room too and the count goes to three,
#   which walks free -- the reading is a floor rather than an equality, so another hand taking
#   their half is never punished for it.
#
# EXPECTED: control_verdict=ok, with welcomes=5 and refusals=21, across 26 cases.
#
# Driven by tools/co/comlink_glow_tend_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/c/comlink_glow_tend_scan.sh"
desk_src="$root/src/shape/shape-comlink-wire-payload-bound.glow"
wire_src="$root/comlink/wire_format.rye"
rehearsal_src="$root/comlink/rehearsal_wire.rye"
sync_src="$root/comlink/recall_sync_wire.rye"
query_src="$root/comlink/recall_tablecloth_query_wire.rye"
vessel_src="$root/comlink/vessel_fetch_wire.rye"

for f in "$scan" "$desk_src" "$wire_src" "$rehearsal_src" "$sync_src" "$query_src" "$vessel_src"; do
  [ -f "$f" ] || { echo "control: missing $f" >&2; exit 1; }
done

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

welcomes=0
refusals=0
wrong=0

desk="$work/pen/src/shape/shape-comlink-wire-payload-bound.glow"
wire="$work/pen/comlink/wire_format.rye"
rehearsal="$work/pen/comlink/rehearsal_wire.rye"
sync="$work/pen/comlink/recall_sync_wire.rye"
query="$work/pen/comlink/recall_tablecloth_query_wire.rye"
vessel="$work/pen/comlink/vessel_fetch_wire.rye"

# pen -- a fresh copy of exactly the six files the scan reads, and nothing else. The three literal
# rooms are copied through their comlink/ face, which is where the scan looks for them.
pen() {
  rm -rf "$work/pen"
  mkdir -p "$work/pen/src/shape" "$work/pen/comlink"
  cp "$desk_src" "$desk"
  cp "$wire_src" "$wire"
  cp "$rehearsal_src" "$rehearsal"
  cp "$sync_src" "$sync"
  cp "$query_src" "$query"
  cp "$vessel_src" "$vessel"
}

# edit <file> <sed-script> -- rewrite in place through the original inode, so a pen file keeps the
# mode it was copied with (.claude/rules/exec-bit.md).
edit() {
  f=$1
  shift
  sed "$@" "$f" > "$f.tmp" && cat "$f.tmp" > "$f" && rm -f "$f.tmp"
}

# check <label> <want-verdict> <refuse|welcome>
check() {
  label=$1
  want=$2
  side=$3
  code=0
  out=$(sh "$scan" "$work/pen" 2>/dev/null) || code=$?
  got=$(printf '%s\n' "$out" | sed -n 's/^verdict=//p' | head -1)
  if [ "$side" = refuse ]; then
    if [ "$got" = "$want" ] && [ "$code" -ne 0 ]; then
      refusals=$((refusals + 1))
      echo "  refused $label ($got)"
    else
      wrong=$((wrong + 1))
      echo "  WRONG   $label -- wanted $want and a refusal, got $got exit $code"
    fi
  else
    if [ "$got" = "$want" ] && [ "$code" -eq 0 ]; then
      welcomes=$((welcomes + 1))
      echo "  welcome $label ($got)"
    else
      wrong=$((wrong + 1))
      echo "  WRONG   $label -- wanted $want and a welcome, got $got exit $code"
    fi
  fi
}

echo "comlink glow tend control -- both directions"

# 1 -- the pen as copied, before anything is planted.
pen
check "01 untouched pen" agree welcome

# 2 -- the desk itself is gone.
pen
rm -f "$desk"
check "02 desk removed" desk_missing refuse

# 3 -- the placard's seated order disturbed.
pen
edit "$desk" -e 's/^::  invariant  /::  zzinvariant  /'
check "03 placard reordered" placard_wrong refuse

# 4 -- the deciding room no longer named.
pen
edit "$desk" -e 's|comlink/wire_format.rye|comlink/somewhere_else.rye|g'
check "04 deciding room uncited" citation_missing refuse

# 5 -- the room whose compiler already held the law, uncited.
pen
edit "$desk" -e 's|comlink/rehearsal_wire.rye|comlink/nothing.rye|g'
check "05 elder tie room uncited" citation_missing refuse

# 6 -- the sibling room named as another hand's, dropped.
pen
edit "$desk" -e 's|amphora/vessel_fetch_wire.rye|amphora/other.rye|g'
check "06 sibling room uncited" citation_missing refuse

# 7 -- the example line keeps its placard keyword and stops naming a number. Deleting the line
# outright would drop a keyword and red as placard_wrong instead, leaving this reading unproven
# from the failing side -- so the value is spoiled rather than the line removed.
pen
edit "$desk" -e 's/^::  example    340$/::  example    many/'
check "07 example not a number" example_missing refuse

# 8 -- the shape line stops naming its bound.
pen
edit "$desk" -e 's/, bound 340 -- / -- /'
check "08 shape bound removed" bound_missing refuse

# 9 -- the two spellings part, example side. This is the drift that never leaves the desk.
pen
edit "$desk" -e 's/^::  example    340$/::  example    400/'
check "09 example alone moved" desk_self_disagree refuse

# 10 -- the two spellings part, shape side. Anchored on the comma and the trailing prose, since
# this desk's bound is not at end of line.
pen
edit "$desk" -e 's/bound 340 -- /bound 400 -- /'
check "10 shape line alone moved" desk_self_disagree refuse

# 11 -- the envelope reshaped and its total width kept: two offsets swapped in the Rye. Every
# number agrees; the order does not.
pen
edit "$wire" \
  -e 's/^pub const off_nonce: u64 = off_sender + 32;$/@@NONCE@@/' \
  -e 's/^pub const off_name: u64 = off_nonce + ChaCha20Poly1305.nonce_length;$/pub const off_nonce: u64 = off_sender + 32;/' \
  -e 's/^@@NONCE@@$/pub const off_name: u64 = off_nonce + ChaCha20Poly1305.nonce_length;/'
edit "$wire" -e 's/^pub const off_name: u64 = off_sender + 32;$/pub const off_name: u64 = off_sender + 32;/'
check "11 offset chain reordered" header_names_disagree refuse

# 12 -- the desk's composition region gone.
pen
edit "$desk" -e '/^::  the header the datagram spends/,/^::  that is 188 bytes/d'
check "12 composition removed" header_missing refuse

# 13 -- a field renamed on the desk alone.
pen
edit "$desk" -e 's/^::    sender 32 - nonce 12/::    origin 32 - nonce 12/'
check "13 desk field renamed" header_names_disagree refuse

# 14 -- the Rye's offset chain gone entirely.
pen
edit "$wire" -e '/^pub const off_/d'
check "14 offset chain removed" rye_header_missing refuse

# 15 -- THE ONE. The derivation respelled as a literal. Every number still agrees.
pen
edit "$wire" -e 's/^pub const max_message: u64 = wire_capacity - off_cipher;$/pub const max_message: u64 = 340;/'
check "15 derivation respelled a literal" derivation_lost refuse

# 16 -- the capacity gone.
pen
edit "$wire" -e '/^pub const wire_capacity: u64 = 528;$/d'
check "16 capacity removed" capacity_missing refuse

# 17 -- the capacity raised in the Rye alone, desk left behind.
pen
edit "$wire" -e 's/^pub const wire_capacity: u64 = 528;$/pub const wire_capacity: u64 = 560;/'
check "17 capacity raised alone" payload_disagree refuse

# 18 -- a header width widened on the desk alone, names kept.
pen
edit "$desk" -e 's/^::    sender 32 - /::    sender 64 - /'
check "18 desk width widened alone" payload_disagree refuse

# 19 -- one copying room drifts. A desk-only reading stays quiet here.
pen
edit "$sync" -e 's/^pub const max_wire_payload: u32 = 340;$/pub const max_wire_payload: u32 = 300;/'
check "19 one literal drifted" literals_disagree refuse

# 20 -- every copying room gone.
pen
rm -f "$sync" "$query" "$vessel"
check "20 copying rooms absent" literal_rooms_missing refuse

# 21 -- the tie deleted from one room. Desk, derivation and literals all still agree.
pen
edit "$sync" -e '/assert(max_wire_payload <= wf\.max_message);/d'
check "21 one comptime tie deleted" tie_unwired refuse

# 22 -- the elder tie in rehearsal_wire deleted.
pen
edit "$rehearsal" -e '/assert(payload_max <= wf\.max_message);/d'
check "22 elder tie deleted" rehearsal_tie_lost refuse

# 23 -- WELCOME. The wire honestly widened in every room that holds the number.
pen
edit "$wire" -e 's/^pub const wire_capacity: u64 = 528;$/pub const wire_capacity: u64 = 560;/'
edit "$desk" -e 's/^::  example    340$/::  example    372/' -e 's/bound 340 -- /bound 372 -- /'
for f in "$sync" "$query" "$vessel"; do
  edit "$f" -e 's/^pub const max_wire_payload: u32 = 340;$/pub const max_wire_payload: u32 = 372;/'
done
check "23 honest raise, every room" agree welcome

# 24 -- WELCOME. A header field widened by four and the capacity raised by four: the ceiling lands
# back on 340 by a different route, and the names are unchanged.
pen
edit "$wire" -e 's/^pub const wire_capacity: u64 = 528;$/pub const wire_capacity: u64 = 532;/'
edit "$desk" -e 's/^::    sender 32 - /::    sender 36 - /'
check "24 composition changed, ceiling held" agree welcome

# 25 -- WELCOME. Amphora ties its own room, and the count rises to three.
pen
edit "$vessel" -e 's|^pub const max_wire_payload: u32 = 340;$|pub const max_wire_payload: u32 = 340;\
comptime { assert(max_wire_payload <= wf.max_message); }|'
check "25 third room ties its own half" agree welcome

# 26 -- WELCOME. The desk's prose reworded, its six lines and its region intact.
pen
edit "$desk" -e 's/^::  Comlink.s second pedestal, and its first bound\./::  A second Comlink desk, and the vane1s first bound displayed anywhere./'
check "26 prose reworded" agree welcome

echo "welcomes=$welcomes"
echo "refusals=$refusals"
echo "wrong=$wrong"
if [ "$wrong" -eq 0 ] && [ "$welcomes" -eq 5 ] && [ "$refusals" -eq 21 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=failed"
  exit 1
fi
