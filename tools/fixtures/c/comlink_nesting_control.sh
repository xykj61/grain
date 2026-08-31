#!/bin/sh
# tools/fixtures/c/comlink_nesting_control.sh -- the nesting scan, proven from both sides.
#
# WHY A CONTROL. A guard proven only in the passing direction cannot be told from a guard that
# reads nothing at all. Every refusal below is planted in a throwaway pen and then removed, and
# every welcome is asserted as hard as every refusal -- because a scan that reds on honest work
# is a scan somebody turns off, which is the same failure wearing better clothes.
#
# WHAT THE PEN IS. A copy of the two rooms the scan reads plus the desk, built fresh per case, so
# the tree is never edited to prove any of this. The scan is run with the pen as its root.
#
# THE CASE THAT MATTERS MOST is `frame_short_but_honest`: the desk and the Rye are edited
# TOGETHER, so `rows_agree` stays yes and only the arithmetic sees the fault. That is the shape
# this guard exists for -- two rooms in perfect agreement about a number that cannot work.
#
# THE WELCOMES MATTER JUST AS MUCH. Raising the frame to a full ethernet MTU in both rooms is
# better work, and it walks free. So does a guest dropping its own lay, since `lay_sites` is
# reported rather than gated.
#
# WHAT IT READS
#   cases       how many behaviours were asked
#   refusals    how many planted faults the scan refused
#   welcomes    how many honest trees the scan let through
#   wrong       how many answers disagreed with what this control expects
#   verdict     proven, or the first disagreement found
#
# USAGE
#   sh tools/fixtures/c/comlink_nesting_control.sh
#
# Driven by tools/co/comlink_nesting_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/c/comlink_nesting_scan.sh"
[ -f "$scan" ] || { echo "verdict=scan_missing"; echo "detail: $scan"; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

cases=0
refusals=0
welcomes=0
wrong=0
verdict=proven

pen() {
  rm -rf "$work/pen"
  mkdir -p "$work/pen/src/shape" "$work/pen/comlink"
  cp "$root/src/shape/shape-comlink-link-frame-nesting.glow" "$work/pen/src/shape/"
  cp "$root/comlink/virtio_net.rye" "$root/comlink/device_wire.rye" "$work/pen/comlink/"
  cp -L "$root/comlink/wire_format.rye" "$work/pen/comlink/"
  cp "$root/comlink/guest_2way_source_tx.rye" "$work/pen/comlink/"
}

# $1 label  $2 expected verdict fragment ("ok" for a welcome)  -- run the scan in the pen
ask() {
  cases=$((cases + 1))
  out=$(cd "$work/pen" && sh "$scan" 2>&1 || true)
  got=$(printf '%s' "$out" | sed -n 's/^verdict=//p' | tail -1)
  if [ "$2" = ok ]; then
    if [ "$got" = ok ]; then
      welcomes=$((welcomes + 1))
    else
      wrong=$((wrong + 1))
      [ "$verdict" = proven ] && verdict="welcome_refused_$1"
      echo "detail: $1 should walk free, the scan answered $got"
    fi
  else
    case "$got" in
      "$2") refusals=$((refusals + 1)) ;;
      *) wrong=$((wrong + 1))
         [ "$verdict" = proven ] && verdict="refusal_missed_$1"
         echo "detail: $1 should refuse with $2, the scan answered $got" ;;
    esac
  fi
}

edit() { sed "$2" "$work/pen/$1" > "$work/e.tmp" && cat "$work/e.tmp" > "$work/pen/$1"; }

# -- 1. the tree as it stands walks free -----------------------------------------------------
pen; ask untouched ok

# -- 2. a missing desk names itself ----------------------------------------------------------
pen; rm "$work/pen/src/shape/shape-comlink-link-frame-nesting.glow"; ask desk_absent file_missing

# -- 3. the placard out of seated order ------------------------------------------------------
# BSD sed will not take a brace group on one line, so the swap is three plain reads. The desk
# names this class itself: a sed that silently matches nothing is a guard that fails open.
pen
d="$work/pen/src/shape/shape-comlink-link-frame-nesting.glow"
{ sed -n '2p' "$d"; sed -n '1p' "$d"; sed -n '3,$p' "$d"; } > "$work/e.tmp" && cat "$work/e.tmp" > "$d"
ask placard_swapped placard_wrong

# -- 4. the desk stops naming a room it reads ------------------------------------------------
pen; edit src/shape/shape-comlink-link-frame-nesting.glow 's|comlink/device_wire.rye|comlink/somewhere_else.rye|g'; ask citation_dropped citation_missing

# -- 5. the desk loses a row -----------------------------------------------------------------
pen; edit src/shape/shape-comlink-link-frame-nesting.glow '/^::    datagram  /d'; ask row_dropped desk_layers_wrong

# -- 6. the Rye moves and the desk does not --------------------------------------------------
pen; edit comlink/virtio_net.rye 's/^pub const max_frame: u32 = 554;/pub const max_frame: u32 = 600;/'; ask frame_moved_alone rows_disagree

# -- 7. the capacity moves and the desk does not ---------------------------------------------
pen; edit comlink/wire_format.rye 's/^pub const wire_capacity: u64 = 528;/pub const wire_capacity: u64 = 512;/'; ask capacity_moved_alone rows_disagree

# -- 8. the desk lies in its own arithmetic --------------------------------------------------
pen; edit src/shape/shape-comlink-link-frame-nesting.glow 's/^::    frame     max_frame      554   link_headers    26   wire_capacity  528    554      0/::    frame     max_frame      554   link_headers    26   wire_capacity  528    540     14/'; ask desk_arithmetic_lies desk_arithmetic_wrong

# -- 9. THE ONE THAT MATTERS -- both rooms agree on a frame that cannot carry ----------------
pen
edit comlink/virtio_net.rye 's/^pub const max_frame: u32 = 554;/pub const max_frame: u32 = 540;/'
edit src/shape/shape-comlink-link-frame-nesting.glow 's/^::    frame     max_frame      554   link_headers    26   wire_capacity  528    554      0/::    frame     max_frame      540   link_headers    26   wire_capacity  528    554    -14/'
ask frame_short_but_honest capacity_short

# -- 10. the derivation the inner layer rests on is removed ----------------------------------
pen; edit comlink/wire_format.rye 's/^pub const max_message: u64 = wire_capacity - off_cipher;/pub const max_message: u64 = 340;/'; ask derivation_removed derivation_gone

# -- 11. the padding proof the header sum leans on is removed --------------------------------
pen; edit comlink/device_wire.rye '/comptime assert(no_padding(vn.VirtioNetHdr));/d'; ask padding_proof_removed padding_proof_gone

# -- 12. the comptime tie is removed ---------------------------------------------------------
pen; edit comlink/device_wire.rye '/comptime assert(vn.frame_carries(/d'; ask tie_removed tie_missing

# -- 13. the published relation is removed ---------------------------------------------------
pen; edit comlink/virtio_net.rye 's/^pub fn frame_carries(wire_capacity: u32) bool {/pub fn frame_fits(wire_capacity: u32) bool {/'; ask relation_renamed relation_missing

# -- 14. an honest raise in BOTH rooms walks free --------------------------------------------
pen
edit comlink/virtio_net.rye 's/^pub const max_frame: u32 = 554;/pub const max_frame: u32 = 1514;/'
edit src/shape/shape-comlink-link-frame-nesting.glow 's/^::    frame     max_frame      554   link_headers    26   wire_capacity  528    554      0/::    frame     max_frame     1514   link_headers    26   wire_capacity  528    554    960/'
ask frame_raised_honestly ok

# -- 15. a guest dropping its lay walks free -- lay_sites is reported, never gated ------------
pen; edit comlink/guest_2way_source_tx.rye '/const total: u32 = poff + dg_len;/d'; ask lay_site_dropped ok

# -- 16. a second room taking its own tie walks free -- the count is a floor ------------------
pen; cp "$work/pen/comlink/device_wire.rye" "$work/pen/comlink/device_wire_second.rye"; ask second_tie_added ok

echo "cases=$cases"
echo "refusals=$refusals"
echo "welcomes=$welcomes"
echo "wrong=$wrong"
[ "$cases" -eq 16 ] || { verdict=case_count_wrong; echo "detail: $cases behaviours asked, this control describes 16"; }
[ "$refusals" -eq 12 ] || { [ "$verdict" = proven ] && verdict=refusal_count_wrong; echo "detail: $refusals refusals, this control plants 12"; }
[ "$welcomes" -eq 4 ] || { [ "$verdict" = proven ] && verdict=welcome_count_wrong; echo "detail: $welcomes welcomes, this control asserts 4"; }
echo "verdict=$verdict"
[ "$verdict" = proven ] || exit 1
