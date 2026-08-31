#!/bin/sh
# tools/fixtures/c/comlink_nesting_tie_probe.sh -- the nesting tie, proven on metal both ways.
#
# WHY THIS EXISTS SEPARATELY FROM THE SCAN. The scan reads text, so it proves a tie is WRITTEN
# and can never prove it HOLDS. A comptime block that is never evaluated -- inside dead code, or
# behind a constant the compiler folds away -- reads identically to one the language checks on
# every build. Only the compiler can tell those apart, so the question is handed to it here.
#
# WHAT IS ASKED, TWICE OVER
#
#   HOLDS     comlink/device_wire.rye compiles as it stands, so the relation is true against the
#             real constants rather than against a remembered arithmetic.
#   REFUSES   the same tie inverted stops the build at comptime. A refusal proven only in the
#             passing direction cannot be told from a bypass.
#
# AND THEN A THIRD ASKING, which is the one that matters most. The inverted case proves the block
# is live; the three below it plant the PLAUSIBLE REAL EDITS -- the ones a routine lap would
# actually make -- and require the build to stop:
#
#   wire_capacity 528 -> 576        a capacity a growing tree raises
#   eth_header_len 14 -> 18         an ethernet header that grows a VLAN tag
#   VirtioNetHdr gains one u16      a virtio feature that widens the device header
#
# None of those three touches `max_frame` or its comment, and each was measured to overrun the
# frame before this probe was written: with the capacity at 576 the guest still builds green for
# riscv64-freestanding, and the guests' own arithmetic run hosted reads `index out of bounds:
# index 602, len 554`.
#
# AND A FOURTH, WHICH IS THE OPPOSITE ASKING. Raising `max_frame` to a full ethernet MTU is
# better work rather than a fault, so it must WALK FREE. A guard that reds on an improvement is
# a guard someone turns off, and that is asserted here as hard as any refusal.
#
# The pen is a copy, so the tree is never edited to prove any of this.
#
# WHAT IT READS
#   tie_holds      the tied module compiles as it stands
#   tie_refuses    the tie inverted stops the build at comptime
#   edit_refuses   how many plausible real edits the compiler stops
#   raise_welcomes how many honest raises the compiler lets through
#   verdict        proven, or the first failure found
#
# USAGE
#   sh tools/fixtures/c/comlink_nesting_tie_probe.sh
#
# Driven by tools/co/comlink_nesting_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"

for f in "$zig" "$rye"; do
  [ -x "$f" ] || { echo "verdict=toolchain_missing"; echo "detail: $f"; exit 1; }
done

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The pen dereferences symlinks on purpose: comlink/ reaches mantra/ through a face, and a pen
# holding dangling links would prove nothing.
cp -RL "$root/comlink" "$work/comlink"

tie_holds=0
tie_refuses=0
edit_refuses=0
raise_welcomes=0
verdict=proven

builds() {
  env RYE_ZIG="$zig" "$rye" build-lib "$work/comlink/device_wire.rye" -lc \
    -femit-bin="$work/device_wire.$1.o" >"$work/device_wire.$1.log" 2>&1
}

# $1 tag  $2 file  $3 sed expression  -- 0 refused at comptime, 1 built anyway, 2 refused otherwise
stopped_by_comptime() {
  cp "$work/comlink/$2" "$work/keep-$1.rye"
  sed "$3" "$work/comlink/$2" > "$work/e.tmp" && cat "$work/e.tmp" > "$work/comlink/$2"
  ok=0
  if builds "$1"; then
    ok=1
  else
    grep -q 'called at comptime here' "$work/device_wire.$1.log" || ok=2
  fi
  cat "$work/keep-$1.rye" > "$work/comlink/$2"
  return "$ok"
}

# $1 tag  $2 file  $3 sed expression  -- 0 built, 1 refused
still_builds() {
  cp "$work/comlink/$2" "$work/keep-$1.rye"
  sed "$3" "$work/comlink/$2" > "$work/e.tmp" && cat "$work/e.tmp" > "$work/comlink/$2"
  ok=0
  builds "$1" || ok=1
  cat "$work/keep-$1.rye" > "$work/comlink/$2"
  return "$ok"
}

# -- the tie holds as it stands --------------------------------------------------------------
if builds holds; then
  tie_holds=1
else
  verdict=tie_does_not_hold
  echo "detail: comlink/device_wire.rye does not compile as it stands"
  sed -n '1,6p' "$work/device_wire.holds.log"
fi

# -- the tie inverted stops the build --------------------------------------------------------
if stopped_by_comptime inverted virtio_net.rye \
  's/return virtio_net_hdr_len + eth_header_len + wire_capacity <= max_frame;/return virtio_net_hdr_len + eth_header_len + wire_capacity > max_frame;/'; then
  tie_refuses=1
else
  case $? in
    1) [ "$verdict" = proven ] && verdict=tie_not_live; echo "detail: the inverted tie built anyway -- the comptime block is not evaluated" ;;
    *) [ "$verdict" = proven ] && verdict=tie_refused_otherwise; echo "detail: the inverted tie refused for a reason other than comptime" ;;
  esac
fi

# -- the three plausible real edits, each of which must stop the build -----------------------
press() {
  if stopped_by_comptime "$1" "$2" "$3"; then
    edit_refuses=$((edit_refuses + 1))
  else
    [ "$verdict" = proven ] && verdict="edit_not_stopped_$1"
    echo "detail: $1 did not stop the build at comptime"
  fi
}
press capacity_raised wire_format.rye \
  's/^pub const wire_capacity: u64 = 528;/pub const wire_capacity: u64 = 576;/'
press eth_header_vlan virtio_net.rye \
  's/^pub const eth_header_len: u32 = 14;/pub const eth_header_len: u32 = 18;/'
press device_header_widened virtio_net.rye \
  's/^    num_buffers: u16, \/\/ present under VERSION_1/    num_buffers: u16, \/\/ present under VERSION_1\n    hash_report: u16,/'

# -- the honest raise, which must walk free --------------------------------------------------
if still_builds frame_raised virtio_net.rye 's/^pub const max_frame: u32 = 554;/pub const max_frame: u32 = 1514;/'; then
  raise_welcomes=$((raise_welcomes + 1))
else
  [ "$verdict" = proven ] && verdict=raise_refused
  echo "detail: raising max_frame to a full ethernet MTU was refused -- a guard that reds on an improvement"
fi

echo "tie_holds=$tie_holds"
echo "tie_refuses=$tie_refuses"
echo "edit_refuses=$edit_refuses"
echo "raise_welcomes=$raise_welcomes"
echo "verdict=$verdict"
[ "$verdict" = proven ] || exit 1
