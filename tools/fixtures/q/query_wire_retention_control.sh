#!/bin/sh
# tools/fixtures/q/query_wire_retention_control.sh -- prove the retention-cost harness measures work
# rather than an optimizer's absence of it.
#
# WHY. comlink/query_wire_retention_cost.rye compares two shapes a caller may keep an answer in:
# hold the payload and decode on every read, or hold the decoded struct beside it and read fields
# directly. The second loop's body is trivially loop-invariant if it reads one fixed hit, and the
# harness's first draft did exactly that: under -OReleaseFast the whole twenty-thousand-read loop
# compiled to six instructions and the harness published a saving that was an elimination.
#
# The cure was to rotate the hit index so each iteration computes its own address. This control
# proves the cure is load-bearing by planting the fault back: it copies the harness into a pen,
# replaces the rotating index with a fixed one, builds under -OReleaseFast, and REQUIRES the planted
# copy to collapse. A control that only ever shows the fixed version passing cannot tell a defense
# from a coincidence.
#
# THE THIRD SHAPE INHERITS THE SAME HAZARD. `20260909.171151` added KEEP VARIED -- a retained slice
# holding only the hits the answer carries -- and its loop is loop-invariant under a fixed index for
# exactly the reason the cached loop is. So the plant must bite it too, and the check below reads the
# planted kept loop rather than trusting that one demonstration covers three loops. A defense proven
# on two of three sites is a defense with a hole in it.
#
# The pen is .lap/ inside this tree -- gitignored, per ship, and never a shared /tmp name.
#
# Run from the repository root:
#   sh tools/fixtures/q/query_wire_retention_control.sh

set -e

root=$(pwd)
pen="$root/.lap/retention-pen"
rye="${RYE_ZIG:-vendor/zig-toolchain/zig}"
pass=0
fail=0

check() {
  if [ "$2" = "$3" ]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    echo "control: FAIL $1 -- wanted '$3', read '$2'"
  fi
}

check_ge() {
  if [ "$2" -ge "$3" ] 2>/dev/null; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    echo "control: FAIL $1 -- wanted at least $3, read '$2'"
  fi
}

rm -rf "$pen"
mkdir -p "$pen"
# The compiler refuses an import that escapes the root file's directory, so the pen carries the
# whole room by link rather than by copy: one room, no duplicated source, nothing to drift.
for f in "$root"/comlink/*.rye; do
  ln -s "$f" "$pen/$(basename "$f")"
done
rm -f "$pen/query_wire_retention_cost.rye"

# The honest copy, byte for byte from the tree.
cp "$root/comlink/query_wire_retention_cost.rye" "$pen/honest.rye"

# The planted copy: the rotation removed, the fault restored.
sed 's/r % measured_hit_count/measured_hit_count - 1/g' \
  "$pen/honest.rye" > "$pen/planted.rye"

planted_diff=$(diff "$pen/honest.rye" "$pen/planted.rye" | grep -c '^<' || true)
check_ge "the plant changes every rotating read site" "$planted_diff" 3

read_field() {
  # $1 file, $2 key
  sed -n "s/.*[ ]$2=\([0-9][0-9]*\).*/\1/p" "$1" | head -1
}

cd "$root"
RYE_ZIG="$rye" rye/bin/rye run "$pen/honest.rye" -OReleaseFast > "$pen/honest.out" 2>&1 || true
RYE_ZIG="$rye" rye/bin/rye run "$pen/planted.rye" -OReleaseFast > "$pen/planted.out" 2>&1 || true

honest_tier=$(sed -n 's/.*tier=\([a-z_]*\).*/\1/p' "$pen/honest.out" | head -1)
if [ "$honest_tier" != "counters" ]; then
  echo "control: tier=$honest_tier -- this host refuses a self-scoped counter, so the plant cannot be shown"
  echo "control: pass=$pass fail=$fail verdict=skipped_no_counter"
  exit 0
fi

honest_decoded=$(read_field "$pen/honest.out" decoded_median)
planted_decoded=$(read_field "$pen/planted.out" decoded_median)
honest_encoded=$(read_field "$pen/honest.out" encoded_median)
honest_kept=$(read_field "$pen/honest.out" kept_median)
planted_kept=$(read_field "$pen/planted.out" kept_median)
honest_kept_bytes=$(read_field "$pen/honest.out" kept_cache_bytes)
honest_fixed_bytes=$(read_field "$pen/honest.out" cache_bytes)
reads=$(read_field "$pen/honest.out" reads_per_sample)

check "the honest copy reads a counter" "$honest_tier" "counters"
check_ge "the honest cached loop retires at least one instruction per read" \
  "$honest_decoded" "$reads"
check_ge "the honest decoding loop outweighs the cached one" \
  "$((honest_encoded / honest_decoded))" 2
check_ge "the honest retained-slice loop retires at least one instruction per read" \
  "$honest_kept" "$reads"

# THE VARIABLE FORM'S OWN CLAIM, CHECKED. Its whole reason for existing is that it holds fewer bytes
# than the fixed array for an answer short of the format's ceiling, and the harness measures four
# hits of a possible eight. A run where it did not would mean the byte arithmetic had drifted from
# the struct it describes, which is the one way this figure can go wrong in silence.
if [ "$honest_kept_bytes" -lt "$honest_fixed_bytes" ]; then
  pass=$((pass + 1))
else
  fail=$((fail + 1))
  echo "control: FAIL the variable form must hold fewer bytes below the ceiling -- kept=$honest_kept_bytes fixed=$honest_fixed_bytes"
fi

# THE PLANT, BITTEN. A fixed index lets the optimizer hoist the whole loop, so the planted copy
# reports far less work than it performed reads. This is the reading the honest copy must never give.
if [ "$planted_decoded" -lt "$reads" ]; then
  pass=$((pass + 1))
else
  fail=$((fail + 1))
  echo "control: FAIL the plant must collapse -- planted decoded_median=$planted_decoded over $reads reads"
fi

# The same bite, on the third loop. Read rather than assumed, because the two loops index different
# things -- an inline array and a slice -- and only a reading says the optimizer treats them alike.
if [ "$planted_kept" -lt "$reads" ]; then
  pass=$((pass + 1))
else
  fail=$((fail + 1))
  echo "control: FAIL the plant must collapse the kept loop -- planted kept_median=$planted_kept over $reads reads"
fi

echo "control: honest_decoded=$honest_decoded planted_decoded=$planted_decoded reads=$reads honest_encoded=$honest_encoded honest_kept=$honest_kept planted_kept=$planted_kept"
rm -rf "$pen"

if [ "$fail" -gt 0 ]; then
  echo "control: pass=$pass fail=$fail verdict=red"
  exit 1
fi
echo "control: pass=$pass fail=$fail verdict=ok"
