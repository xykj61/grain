#!/bin/sh
# tools/fixtures/m/mantra_tablecloth_hit_census_control.sh -- prove the hit census measures the
# catalog rather than reciting its own expectations.
#
# WHY. mantra/recall_tablecloth_hit_census.rye walks all thirty-one Tablecloth query shapes over
# saturated catalogs and asserts three findings: that exactly two shapes bound an answer to one hit,
# that a version history and a directory of one size read complementary profiles, and that
# `build_response` builds hits which `encode_response` then refuses. Every one of those is an
# assertion inside the program, so a reader has to ask what would happen if the finding were false.
# This control answers by making each one false in a pen and requiring the planted copy to refuse.
#
# The plants, and what each one shows:
#
#   1. THE KEY IS THE ONLY BOUND. Raise the expected count of one-hit shapes from two to three and
#      the worst-case tally must refuse -- so the two is a reading rather than a decoration.
#   2. SATURATION MUST AGREE. Flip `varied_field` to vary the very field the mask names, and the
#      shapes naming revision stop saturating -- their rows read one hit and the tally refuses. A
#      worst case built from a catalog that fails to saturate is a smaller number wearing the name.
#   3. THE NAME CEILINGS CARRY THE WIRE FINDING. Shrink the peer and bolt names to one byte and
#      three hits fit the payload, so the program refuses with `ShapeUnreachable`. This is the
#      honest boundary of the finding: the declared hit ceiling and the byte bound disagree at the
#      DECLARED name lengths, and agree at short ones.
#   4. A DRAWN QUERY FINDS ITS OWN LEAF. Point the peer field at a name no leaf carries and the
#      non-empty-answer invariant refuses, so a shape reading zero can never pass as a small mean.
#   5. THE SHAPE SPACE IS PARTITIONED. Start the walk at mask zero -- the query naming no field --
#      and the comptime partition refuses at build time, so the thirty-one is the whole space
#      rather than a slice of it.
#
# The pen is .lap/ inside this tree -- gitignored, per ship, and never a shared /tmp name.
#
# Run from the repository root:
#   sh tools/fixtures/m/mantra_tablecloth_hit_census_control.sh

set -e

root=$(pwd)
pen="$root/.lap/hit-census-pen"
rye="${RYE_ZIG:-vendor/zig-toolchain/zig}"
source="$root/mantra/recall_tablecloth_hit_census.rye"
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

refuses() {
  # $1 label, $2 pen file, $3 a line the planted run must reach before it refuses -- so a plant
  # that dies early for an unrelated reason reads as a failure rather than as a proof.
  if RYE_ZIG="$rye" rye/bin/rye run "$2" > "$2.out" 2>&1; then
    fail=$((fail + 1))
    echo "control: FAIL $1 -- the planted copy passed"
  elif [ -n "$3" ] && ! grep -q "$3" "$2.out"; then
    fail=$((fail + 1))
    echo "control: FAIL $1 -- the plant refused before reaching '$3'"
  else
    pass=$((pass + 1))
  fi
}

rm -rf "$pen"
mkdir -p "$pen"
# The compiler refuses an import that escapes the root file's directory, so the pen carries the
# whole room by link rather than by copy: one room, no duplicated source, nothing to drift.
for f in "$root"/mantra/*.rye; do
  ln -s "$f" "$pen/$(basename "$f")"
done
rm -f "$pen/recall_tablecloth_hit_census.rye"

cp "$source" "$pen/honest.rye"

sed 's/^pub const bounded_shapes_expected: u32 = 2;/pub const bounded_shapes_expected: u32 = 3;/' \
  "$pen/honest.rye" > "$pen/plant_key.rye"
sed 's/^    if (mask & field_revision == 0) return field_revision;/    if (mask \& field_revision != 0) return field_revision;/' \
  "$pen/honest.rye" > "$pen/plant_saturate.rye"
sed -e 's/^const worst_peer_len: u32 = 16;/const worst_peer_len: u32 = 1;/' \
    -e 's/^const worst_bolt_len: u32 = 32;/const worst_bolt_len: u32 = 1;/' \
  "$pen/honest.rye" > "$pen/plant_names.rye"
sed 's|^    if (mask \& field_peer != 0) q.peer = leaf.peer\[0..leaf.peer_len\];|    if (mask \& field_peer != 0) q.peer = "no-such-peer";|' \
  "$pen/honest.rye" > "$pen/plant_drawn.rye"
sed 's/^pub const first_mask: u32 = 1;/pub const first_mask: u32 = 0;/' \
  "$pen/honest.rye" > "$pen/plant_space.rye"

# A plant that changes nothing is a plant that proves nothing, so each one is read off the bytes.
# The names plant moves two lines because the wire finding rides on two declared ceilings at once.
for pair in key:1 saturate:1 names:2 drawn:1 space:1; do
  p=${pair%:*}
  want=${pair#*:}
  moved=$(diff "$pen/honest.rye" "$pen/plant_$p.rye" | grep -c '^<' || true)
  check "the $p plant changes its lines" "$moved" "$want"
done

cd "$root"
RYE_ZIG="$rye" rye/bin/rye run "$pen/honest.rye" > "$pen/honest.out" 2>&1 || true

read_field() {
  sed -n "s/.*[ ]$2=\([0-9][0-9]*\).*/\1/p" "$1" | head -1
}

bounded=$(read_field "$pen/honest.out" bounded_to_one)
over_wire=$(read_field "$pen/honest.out" over_wire)
shapes=$(read_field "$pen/honest.out" shapes)
history=$(read_field "$pen/honest.out" history_single)
directory=$(read_field "$pen/honest.out" directory_single)
both=$(read_field "$pen/honest.out" both_single)
neither=$(read_field "$pen/honest.out" neither_single)
built=$(read_field "$pen/honest.out" built_hits)
one_hit=$(read_field "$pen/honest.out" one_hit_bytes)

check "the honest copy runs green" "$(grep -c '^GREEN:' "$pen/honest.out")" 1
check "the uniqueness key bounds two shapes" "$bounded" 2
check "every other shape outruns the wire" "$over_wire" 29
check "the walk covers thirty-one shapes" "$shapes" 31
check "a version history is told apart by revision" "$history" 16
check "a directory is told apart by path" "$directory" 16
check "eight shapes name a key both shapes hold unique" "$both" 8
check "seven shapes return the whole catalog whichever way it is shaped" "$neither" 7
check "the build stays inside the declared ceiling" "$built" 3
check "one hit at declared name lengths costs its bytes" "$one_hit" 121
check "the wire refuses the answer it just built" \
  "$(grep -c 'wire encode verdict=refused' "$pen/honest.out")" 1

refuses "the key is the only structural bound" "$pen/plant_key.rye" "worst bounded_to_one="
refuses "saturation must actually saturate" "$pen/plant_saturate.rye" "worst mask=04"
refuses "the wire finding rides on the declared name ceilings" "$pen/plant_names.rye" "shape history_single="
refuses "a query drawn from a leaf finds that leaf" "$pen/plant_drawn.rye" "hit-census: max_bindings="
refuses "the shape space is thirty-one, whole" "$pen/plant_space.rye" ""

echo "control: bounded=$bounded over_wire=$over_wire shapes=$shapes history=$history directory=$directory both=$both neither=$neither built=$built one_hit_bytes=$one_hit"
rm -rf "$pen"

if [ "$fail" -gt 0 ]; then
  echo "control: pass=$pass fail=$fail verdict=red"
  exit 1
fi
echo "control: pass=$pass fail=$fail verdict=ok"
