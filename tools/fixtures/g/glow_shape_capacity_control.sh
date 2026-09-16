#!/bin/sh
# tools/fixtures/g/glow_shape_capacity_control.sh -- proves the behaviors of
# tools/fixtures/g/glow_shape_capacity_scan.sh in a throwaway pen, every reading shown from both
# sides.
#
# WHAT IS PLANTED AND WHAT IS MUTATED. Both halves of this reading are FILES, so every behavior is
# proven by planting a Glow source and a contract page whose right answer is known by
# construction, then changing one thing and watching the reading move. A refusal proven only in
# the passing direction cannot be told from a bypass, so each refusal is planted and then lifted.
#
# The reading worth the most care is the field count, because it is the one a careless reader gets
# wrong in the direction that looks right: a type whose fields wrap across three lines reads as
# THREE fields to a line counter and as FIFTEEN to a comma splitter, and three is under every
# capacity, so the careless reading answers `expressible=yes` about a type Glow cannot hold. That
# mutation is planted and asserted to bite.
#
#   sh tools/fixtures/g/glow_shape_capacity_control.sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  [ "$_steps" -gt 8 ] && { echo "$0: no tree root" >&2; exit 2; }
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/g/glow_shape_capacity_scan.sh"

# One shell dialect on both piers: `sed -i` takes no argument on GNU and REQUIRES a backup suffix
# on BSD, so the flag is gated at zero tree-wide and `sed_inplace` is the portable form.
. "$ROOT/tools/fixtures/s/shell_portable.sh"

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

pass=0
fail=0
legs=0
LEGS_EXPECTED=44

ok() { legs=$((legs + 1)); pass=$((pass + 1)); echo "ok   $legs $1"; }
no() { legs=$((legs + 1)); fail=$((fail + 1)); echo "FAIL $legs $1"; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else no "$1 -- wanted [$3], read [$2]"; fi; }
field() { awk -v k="$1" -F= '$1 == k { print $2 }' "$2" | tail -1; }

cd "$PEN"

plant_glow() {
  cat > "$PEN/rune_shape.rye" <<EOF
const std = @import("std");
pub const max_name_len: u32 = 64;
pub const max_fields: u32 = $1;
pub const admitted_shape_aura_count: u32 = 4;
pub const admitted_shape_auras = [_][]const u8{ "@u32", "@t", "@ux", "@u64" };
EOF
}

plant_contract() {
  cat > "$PEN/contract.md" <<'EOF'
# a planted contract

## Public types

```text
WideFact
  one, two, three, four, five, six
  seven, eight, nine, ten, eleven
  twelve, thirteen, fourteen, fifteen

TwoField
  offer: WideFact
  status: offered | expired

ElevenField
  a, b, c, d
  e, f, g, h
  i, j, k

NineField
  a, b, c, d, e, f, g, h, i
```

## after
EOF
}

run() { sh "$SCAN" "$@" > "$PEN/out.txt" 2>&1 || true; }

plant_glow 9
plant_contract
export SHAPE_CAPACITY_GLOW="$PEN/rune_shape.rye"
export SHAPE_CAPACITY_CONTRACT="$PEN/contract.md"

run
check "both halves read" "$(field glow_readable "$PEN/out.txt")" "yes"
check "contract read" "$(field contract_readable "$PEN/out.txt")" "yes"
check "capacity found" "$(field capacity_found "$PEN/out.txt")" "yes"
check "capacity is the planted nine" "$(field shape_max_fields "$PEN/out.txt")" "9"
check "the four admitted auras are counted" "$(field shape_admitted_auras "$PEN/out.txt")" "4"
check "the block is found" "$(field types_block_found "$PEN/out.txt")" "yes"
check "four types parse" "$(field types_read "$PEN/out.txt")" "4"

# The field count, read three ways the page actually writes it.
check "a wrapped type counts every comma-separated field" \
  "$(grep '^type WideFact ' "$PEN/out.txt")" "type WideFact fields=15 expressible=no over=6"
check "a colon form counts one field per line" \
  "$(grep '^type TwoField ' "$PEN/out.txt")" "type TwoField fields=2 expressible=yes over=0"
check "an eleven-field type is over by two" \
  "$(grep '^type ElevenField ' "$PEN/out.txt")" "type ElevenField fields=11 expressible=no over=2"
check "a type exactly at capacity is expressible" \
  "$(grep '^type NineField ' "$PEN/out.txt")" "type NineField fields=9 expressible=yes over=0"

check "two of four stand over" "$(field types_over_capacity "$PEN/out.txt")" "2"
check "the widest type is named" "$(field widest_type "$PEN/out.txt")" "WideFact"
check "the widest type's count" "$(field widest_type_fields "$PEN/out.txt")" "15"
check "the gap is widest less capacity" "$(field capacity_gap "$PEN/out.txt")" "6"
check "the verdict names the state" "$(field verdict "$PEN/out.txt")" "over_capacity"

# --explain prints the reason the gap is reported rather than gated.
run --explain
check "explain names the seated freeze" \
  "$(grep -c 'Keaton' "$PEN/out.txt")" "1"

# Raise the capacity and every type fits: the reading follows the file rather than a constant.
plant_glow 16
run
check "a raised capacity is read from the file" "$(field shape_max_fields "$PEN/out.txt")" "16"
check "nothing stands over at sixteen" "$(field types_over_capacity "$PEN/out.txt")" "0"
check "the gap closes" "$(field capacity_gap "$PEN/out.txt")" "0"
check "the verdict follows" "$(field verdict "$PEN/out.txt")" "within_capacity"
check "the widest type is still named" "$(field widest_type "$PEN/out.txt")" "WideFact"
plant_glow 9

# REFUSAL 1 -- the Glow source is absent.
mv "$PEN/rune_shape.rye" "$PEN/rune_shape.away"
run
check "an absent Glow source refuses" "$(field verdict "$PEN/out.txt")" "unreadable"
check "and says which half lost its source" "$(field glow_readable "$PEN/out.txt")" "no"
mv "$PEN/rune_shape.away" "$PEN/rune_shape.rye"
run
check "and the refusal lifts when it returns" "$(field verdict "$PEN/out.txt")" "over_capacity"

# REFUSAL 2 -- the ceiling was renamed or removed.
sed_inplace 's/^pub const max_fields.*$/pub const max_faces: u32 = 9;/' "$PEN/rune_shape.rye"
run
check "a renamed ceiling refuses" "$(field verdict "$PEN/out.txt")" "uncapacitated"
check "and never guesses a capacity" "$(field capacity_found "$PEN/out.txt")" "no"
plant_glow 9
run
check "and the refusal lifts when the name returns" "$(field verdict "$PEN/out.txt")" "over_capacity"

# REFUSAL 3 -- the contract page is absent.
mv "$PEN/contract.md" "$PEN/contract.away"
run
check "an absent contract refuses" "$(field verdict "$PEN/out.txt")" "uncontracted"
check "and says which half lost its source" "$(field contract_readable "$PEN/out.txt")" "no"
mv "$PEN/contract.away" "$PEN/contract.md"
run
check "and the refusal lifts when it returns" "$(field verdict "$PEN/out.txt")" "over_capacity"

# REFUSAL 4 -- the page carries no Public types block.
sed_inplace 's/^## Public types$/## Private types/' "$PEN/contract.md"
run
check "a missing block refuses" "$(field verdict "$PEN/out.txt")" "unblocked"
check "and never reports a type count" "$(field types_block_found "$PEN/out.txt")" "no"
plant_contract
run
check "and the refusal lifts when the heading returns" "$(field verdict "$PEN/out.txt")" "over_capacity"

# REFUSAL 5 -- a block that parses to no type at all. This is the silent-pass shape: without the
# gate the scan would print types_over_capacity=0 about a page it had read and understood none of.
cat > "$PEN/contract.md" <<'EOF'
## Public types

```text
  indented, only, lines
```
EOF
run
check "a block with no type name refuses" "$(field verdict "$PEN/out.txt")" "untyped"
check "and reports the zero it read" "$(field types_read "$PEN/out.txt")" "0"
plant_contract

# MUTATION 1 -- count LINES rather than comma-separated fields. WideFact then reads three, which
# is under every capacity, so the careless reading calls an inexpressible type expressible.
MUT="$PEN/mutant_lines.sh"
sed 's/cnt = split(line, parts, ",")/cnt = 1; parts[1] = line/' "$SCAN" > "$MUT"
sh "$MUT" > "$PEN/mut.txt" 2>&1 || true
mutant_wide=$(grep '^type WideFact ' "$PEN/mut.txt" || true)
if [ "$mutant_wide" = "type WideFact fields=15 expressible=no over=6" ]; then
  no "the line-counting mutation must bite -- it read the same fifteen"
else
  ok "the line-counting mutation bites: [$mutant_wide]"
fi
check "and the mutant's over-count disagrees" \
  "$([ "$(field types_over_capacity "$PEN/mut.txt")" = "2" ] && echo same || echo moved)" "moved"

# MUTATION 2 -- read the capacity as at-or-over rather than over. NineField sits exactly at nine,
# so an off-by-one there would call a type Glow holds inexpressible.
MUT2="$PEN/mutant_boundary.sh"
sed 's/\$3 > cap/$3 >= cap/' "$SCAN" > "$MUT2"
sh "$MUT2" > "$PEN/mut2.txt" 2>&1 || true
check "the boundary mutation bites on the type sitting exactly at capacity" \
  "$(field types_over_capacity "$PEN/mut2.txt")" "3"

# MUTATION 3 -- drop the colon trim. TwoField's `offer: WideFact` then reads as one field still,
# yet `status: offered | expired` stays one too, so the trim is proven where it matters: a field
# whose type itself carries a comma. Plant exactly that.
cat > "$PEN/contract.md" <<'EOF'
## Public types

```text
Commas
  offer: map<a, b>
```
EOF
run
check "a field whose type carries a comma still counts once" \
  "$(grep '^type Commas ' "$PEN/out.txt")" "type Commas fields=1 expressible=yes over=0"
MUT3="$PEN/mutant_colon.sh"
sed 's|if (index(line, ":") > 0) {|if (0) {|' "$SCAN" > "$MUT3"
sh "$MUT3" > "$PEN/mut3.txt" 2>&1 || true
check "and splitting a colon line on commas first bites" \
  "$(grep '^type Commas ' "$PEN/mut3.txt")" "type Commas fields=2 expressible=yes over=0"
plant_contract

# THE LIVE LEG -- the real tree, read as it stands. This is the reading the lap was taken for, and
# a control that only ever reads its own pen proves nothing about the tree it ships in. The scan's
# defaults are tree-relative, so the live leg is taken from the root rather than from the pen.
unset SHAPE_CAPACITY_GLOW SHAPE_CAPACITY_CONTRACT
( cd "$ROOT" && sh "$SCAN" ) > "$PEN/live.txt" 2>&1 || true
check "the tree's own Glow source is readable" "$(field glow_readable "$PEN/live.txt")" "yes"
check "the tree's own contract is readable" "$(field contract_readable "$PEN/live.txt")" "yes"
live_types=$(field types_read "$PEN/live.txt")
if [ "${live_types:-0}" -ge 1 ]; then
  ok "the tree's contract parses to at least one type: $live_types"
else
  no "the tree's contract parsed to no type at all"
fi

# The leg tally is asserted by the witness beside the verdict, so a pen that lost a leg cannot
# read as a full one -- a control reaching its last line proves only that it reached its last line.
echo "control_expected=$LEGS_EXPECTED"
echo "control_legs=$legs"
echo "control_passed=$pass"
echo "control_failed=$fail"
if [ "$fail" -eq 0 ] && [ "$legs" -eq "$LEGS_EXPECTED" ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=failed"
fi
