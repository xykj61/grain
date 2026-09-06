#!/bin/sh
# tools/fixtures/c/comlink_carriage_control.sh -- the carriage scan, proven able to bite and
# proven able to stay quiet, on real files in a throwaway pen.
#
# WHY A CONTROL AT ALL. A guard proven only in the passing direction cannot be told from a guard
# that reads nothing. Every refusal below is planted and then removed, and every welcome is
# asserted as hard as every refusal -- because the failure this family exists to prevent is a
# guard that reds on an honest raise, which is a guard someone turns off.
#
# THE CASES THAT MATTER MOST are the ones where the Rye and the desk move TOGETHER. Cases 9-11
# plant the three real edits that break carriage while keeping the desk perfectly consistent with
# the Rye, so `rows_agree` stays yes and only the arithmetic sees it. Cases 12-13 do the mirror:
# an honest raise that gives a family MORE room, which must walk free.
#
# USAGE
#   sh tools/fixtures/c/comlink_carriage_control.sh
#
# Driven by tools/co/comlink_carriage_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/c/comlink_carriage_scan.sh"
[ -f "$scan" ] || { echo "verdict=scan_missing"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

cases=0
refusals=0
welcomes=0
wrong=0

# Lay a fresh copy of every file the scan reads. The pen is a copy, so the tree is never edited
# to prove any of this.
fresh() {
  rm -rf "$pen/work"
  mkdir -p "$pen/work/src/shape" "$pen/work/mantra" "$pen/work/amphora"
  cp "$root/src/shape/shape-comlink-chunked-carriage-bound.glow" "$pen/work/src/shape/"
  for m in beading recall_lap1 recall_batch_wire resin_batch recall_sync_wire; do
    cp "$root/mantra/$m.rye" "$pen/work/mantra/"
  done
  cp "$root/amphora/vessel_fetch_wire.rye" "$pen/work/amphora/"
}

# Rewrite a pen file through its original inode, so the mode it was copied with survives
# (.claude/rules/exec-bit.md).
edit() {
  f="$pen/work/$1"
  sed "$2" "$f" > "$f.tmp" && cat "$f.tmp" > "$f" && rm -f "$f.tmp"
}

# `set -e` would kill the subshell the moment a planted case makes the scan exit non-zero,
# so the status is caught with `|| rc=$?` -- a control that dies on its first refusal proves
# only that the scan can pass.
run_scan() {
  rc=0
  ( cd "$pen/work" && sh "$scan" ) >"$pen/out" 2>&1 || rc=$?
  echo "$rc" > "$pen/rc"
}
verdict_of() { sed -n 's/^verdict=//p' "$pen/out" | tail -1; }

# $1 label  $2 wanted verdict ("ok" asserts a welcome, anything else asserts a refusal)
check() {
  cases=$((cases + 1))
  run_scan
  got=$(verdict_of)
  rc=$(cat "$pen/rc")
  if [ "$2" = ok ]; then
    if [ "$got" = ok ] && [ "$rc" -eq 0 ]; then
      welcomes=$((welcomes + 1)); printf '  %-52s WELCOME\n' "$1"
    else
      wrong=$((wrong + 1)); printf '  %-52s WRONG (wanted ok, got %s rc=%s)\n' "$1" "$got" "$rc"
    fi
  else
    if [ "$got" = "$2" ] && [ "$rc" -ne 0 ]; then
      refusals=$((refusals + 1)); printf '  %-52s REFUSES %s\n' "$1" "$got"
    else
      wrong=$((wrong + 1)); printf '  %-52s WRONG (wanted %s, got %s rc=%s)\n' "$1" "$2" "$got" "$rc"
    fi
  fi
}

echo "-- the tree as it stands, and the readings that must stay quiet --"
fresh; check "1  clean pen" ok
fresh; rm -f "$pen/work/src/shape/shape-comlink-chunked-carriage-bound.glow"
check "2  the desk is gone" file_missing
fresh; rm -f "$pen/work/mantra/beading.rye"
check "3  a Rye room is gone" file_missing

echo "-- the placard and the citation --"
fresh; edit src/shape/shape-comlink-chunked-carriage-bound.glow '1,8{s/^::  invariant /::  zzz       /;}'
check "4  a placard line out of seated order" placard_wrong
fresh; edit src/shape/shape-comlink-chunked-carriage-bound.glow 's|mantra/resin_batch|mantra/resin_bundle|g'
check "5  the desk stops naming a room it displays" citation_missing

echo "-- the desk's own table --"
fresh; edit src/shape/shape-comlink-chunked-carriage-bound.glow '/^::    vessel  /d'
check "6  the desk drops a carriage family" desk_families_wrong
fresh; edit src/shape/shape-comlink-chunked-carriage-bound.glow 's/512     64       8       512      0$/640     64       8       512      0/'
check "7  the desk shows a whole the Rye does not" rows_disagree
fresh; edit src/shape/shape-comlink-chunked-carriage-bound.glow 's/331      16      5296   1200$/331      32      5296   1200/'
check "8  the desk shows a piece count the Rye does not" rows_disagree

echo "-- the failure this family exists for: Rye and desk agreeing, and wrong --"
fresh
edit mantra/beading.rye 's/^const cdc_min_bead: u32 = 64;/const cdc_min_bead: u32 = 32;/'
edit src/shape/shape-comlink-chunked-carriage-bound.glow 's/512     64       8       512      0$/512     32       8       256   -256/'
check "9  cdc_min_bead lowered, desk kept honest" capacity_broken
fresh
edit mantra/beading.rye 's/^pub const max_resin_bytes: u32 = 512;/pub const max_resin_bytes: u32 = 576;/'
edit src/shape/shape-comlink-chunked-carriage-bound.glow 's/512     64       8       512      0$/576     64       8       512    -64/'
check "10 max_resin_bytes raised, desk kept honest" capacity_broken
fresh
edit mantra/recall_batch_wire.rye 's/^pub const max_batch_chunks: u16 = 16;/pub const max_batch_chunks: u16 = 8;/'
edit src/shape/shape-comlink-chunked-carriage-bound.glow 's/4096    331      16      5296   1200$/4096    331       8      2648  -1448/'
check "11 max_batch_chunks halved, desk kept honest" capacity_broken

echo "-- the mirror: honest work that must walk free --"
fresh
edit mantra/beading.rye 's/^const cdc_min_bead: u32 = 64;/const cdc_min_bead: u32 = 128;/'
edit src/shape/shape-comlink-chunked-carriage-bound.glow 's/512     64       8       512      0$/512    128       8      1024    512/'
check "12 beading given real headroom" ok
fresh
edit mantra/resin_batch.rye 's/^pub const max_batch_bytes: u32 = 4096;/pub const max_batch_bytes: u32 = 5296;/'
edit src/shape/shape-comlink-chunked-carriage-bound.glow 's/4096    331      16      5296   1200$/5296    331      16      5296      0/'
check "13 a batch raised exactly to its capacity" ok

echo "-- the desk's displayed capacity, which is a teaching surface --"
fresh; edit src/shape/shape-comlink-chunked-carriage-bound.glow 's/16      5296   1200$/16      9999   1200/'
check "14 the desk's capacity column is arithmetic-wrong" desk_capacity_wrong
fresh; edit src/shape/shape-comlink-chunked-carriage-bound.glow 's/8       512      0$/8       512    999/'
check "15 the desk's slack column is arithmetic-wrong" desk_capacity_wrong

echo "-- the ties the compiler evaluates --"
fresh; edit mantra/beading.rye '/max_resin_bytes <= max_beads \* cdc_min_bead/d'
check "16 beading drops its carriage tie" ties_missing
fresh; edit mantra/recall_batch_wire.rye '/max_batch_bytes <= @as(u32, max_batch_chunks) \* max_chunk_body/d'
check "17 the batch wire drops its carriage tie" ties_missing
fresh
edit mantra/beading.rye '/max_resin_bytes <= max_beads \* cdc_min_bead/d'
edit mantra/recall_batch_wire.rye '/max_batch_bytes <= @as(u32, max_batch_chunks) \* max_chunk_body/d'
check "18 both rooms drop the tie" ties_missing
# Amphora tied its own room on 20260906, so this case turned over: planting the tie proved
# nothing once the real file carried it, and the gate that welcomed the third tie stopped
# catching the first two rooms dropping theirs. Dropping Amphora's own tie is the case that
# earns its place now, and 16-19 are the three single drops plus the pair.
fresh; edit amphora/vessel_fetch_wire.rye '/max_resin_bytes <= @as(u32, max_resin_chunks) \* max_chunk_body/d'
check "19 Amphora drops its own carriage tie" ties_missing

echo "-- a bound that stops being a readable literal --"
fresh; edit mantra/beading.rye 's/^pub const max_resin_bytes: u32 = 512;/pub const max_resin_bytes: u32 = 8 * 64;/'
check "20 a bound respelled as an expression" constant_unreadable

echo ""
echo "cases=$cases"
echo "refusals=$refusals"
echo "welcomes=$welcomes"
echo "wrong=$wrong"
if [ "$wrong" -eq 0 ] && [ "$cases" -eq 20 ] && [ "$refusals" -eq 17 ] && [ "$welcomes" -eq 3 ]; then
  echo "verdict=proven"
else
  echo "verdict=control_disagrees"
  exit 1
fi
