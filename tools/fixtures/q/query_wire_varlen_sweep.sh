#!/bin/sh
# tools/fixtures/q/query_wire_varlen_sweep.sh -- run the retention harness across answer sizes, so
# the exchange rate between bytes held and instructions per read is a table rather than one row.
#
# WHY. `what a kept answer costs per read` (20260909.152110) measured one answer of four hits and
# projected that a VARIABLE-LENGTH retained form would close most of the 7.3x swing it found between
# a one-hit and an eight-hit answer. It wrote its falsifier down: a variable form whose one-hit cache
# still exceeds roughly a quarter of the fixed form's 456 bytes would place the cost in the per-hit
# representation rather than in the array. This script runs that falsifier.
#
# HOW. The harness fixes its answer size at a comptime constant so two runs on one host compare and
# so the published figures name one concrete answer. Varying it therefore means varying the source,
# which this script does in a pen rather than in the tree: it links the comlink room, copies the
# harness, rewrites `measured_hit_count` to each size in turn, and runs each copy under the same
# build mode. The tree's own harness is left at four, so the elder paper's row still reproduces from
# an unedited checkout.
#
# WHAT THE ONE-HIT ROW IS. At a single hit the rotating index degenerates to a constant and the
# cached loops hoist, exactly as tools/fixtures/q/query_wire_retention_control.sh demonstrates. That
# row's per-read figures are an UPPER BOUND on the saving rather than a reading, and it is marked so
# in the output. Its BYTE figures are unaffected, and the byte figures are what the falsifier reads.
#
# The pen is .lap/ inside this tree -- gitignored, per ship, and never a shared /tmp name.
#
# Run from the repository root:
#   sh tools/fixtures/q/query_wire_varlen_sweep.sh

set -e

root=$(pwd)
pen="$root/.lap/varlen-pen"
rye="${RYE_ZIG:-vendor/zig-toolchain/zig}"
mode="${SWEEP_MODE:--OReleaseFast}"
sizes="${SWEEP_SIZES:-1 2 4 8}"

rm -rf "$pen"
mkdir -p "$pen"
# The compiler refuses an import that escapes the root file's directory, so the pen carries the whole
# room by link rather than by copy: one room, no duplicated source, nothing to drift.
for f in "$root"/comlink/*.rye; do
  ln -s "$f" "$pen/$(basename "$f")"
done
rm -f "$pen/query_wire_retention_cost.rye"

read_field() {
  sed -n "s/.*[ ]$2=\([0-9][0-9]*\).*/\1/p" "$1" | head -1
}

probe="$pen/probe.rye"
sed 's/^const measured_hit_count: u32 = [0-9]*;/const measured_hit_count: u32 = 1;/' \
  "$root/comlink/query_wire_retention_cost.rye" > "$probe"
if ! grep -q 'measured_hit_count: u32 = 1;' "$probe"; then
  echo "sweep: the harness no longer declares measured_hit_count where this script rewrites it"
  echo "sweep: verdict=red"
  exit 1
fi

cd "$root"
RYE_ZIG="$rye" rye/bin/rye run "$probe" $mode > "$pen/probe.out" 2>&1 || true
tier=$(sed -n 's/.*tier=\([a-z_]*\).*/\1/p' "$pen/probe.out" | head -1)
if [ "$tier" != "counters" ]; then
  echo "sweep: tier=$tier -- this host refuses a self-scoped counter, so no rate can be read"
  echo "sweep: verdict=skipped_no_counter"
  exit 0
fi

echo "sweep: mode=$mode sizes=$sizes"
echo "sweep: hits payload_bytes fixed_bytes varied_bytes fixed_per_read varied_per_read decode_per_read note"

rows=0
for n in $sizes; do
  src="$pen/hits_$n.rye"
  sed "s/^const measured_hit_count: u32 = [0-9]*;/const measured_hit_count: u32 = $n;/" \
    "$root/comlink/query_wire_retention_cost.rye" > "$src"
  RYE_ZIG="$rye" rye/bin/rye run "$src" $mode > "$pen/hits_$n.out" 2>&1 || true

  payload=$(read_field "$pen/hits_$n.out" payload_bytes)
  fixed_b=$(read_field "$pen/hits_$n.out" cache_bytes)
  varied_b=$(read_field "$pen/hits_$n.out" kept_cache_bytes)
  fixed_r=$(read_field "$pen/hits_$n.out" decoded_per_read)
  varied_r=$(read_field "$pen/hits_$n.out" kept_per_read)
  decode_r=$(read_field "$pen/hits_$n.out" encoded_per_read)

  if [ -z "$varied_b" ]; then
    echo "sweep: hits=$n produced no reading -- see $pen/hits_$n.out"
    echo "sweep: verdict=red"
    exit 1
  fi

  note=reading
  [ "$n" = "1" ] && note=per_read_is_an_upper_bound
  echo "sweep: $n $payload $fixed_b $varied_b $fixed_r $varied_r $decode_r $note"
  rows=$((rows + 1))

  [ "$n" = "1" ] && one_hit_varied=$varied_b
  [ "$n" = "1" ] && one_hit_fixed=$fixed_b
done

# THE FALSIFIER, READ. The elder paper's projection dies if the variable form's ONE-HIT cache still
# exceeds roughly a quarter of the fixed form's. A quarter is the paper's own word, so the threshold
# is computed from the fixed figure this run read rather than from a number typed here.
quarter=$((one_hit_fixed / 4))
if [ "$one_hit_varied" -gt "$quarter" ]; then
  falsifier=FIRED
else
  falsifier=held
fi
echo "sweep: one_hit_fixed=$one_hit_fixed one_hit_varied=$one_hit_varied quarter=$quarter falsifier=$falsifier"

rm -rf "$pen"
echo "sweep: rows=$rows verdict=ok"
