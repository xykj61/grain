#!/bin/sh
# tools/fixtures/g/glow_ident_duplication_control.sh -- proves
# `tools/fixtures/g/glow_ident_duplication_scan.sh` on planted `glow/` rooms in a throwaway pen.
#
# Every refusal is planted and then LIFTED, because a refusal proven only in the passing
# direction cannot be told from a bypass. Two mutations are asserted to bite: the
# column-one anchor that tells a declaration from a doc comment, and the delegation grep
# that tells a stub from a copy. Remove either and a leg here reds.
#
#   sh tools/fixtures/g/glow_ident_duplication_control.sh

set -u

scan="$(pwd)/tools/fixtures/g/glow_ident_duplication_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT

# The scan is copied into the pen before a single leg runs. The ceiling legs below rewrite
# CEILING, and a control that edits the TRACKED instrument leaves it lowered when a leg dies
# mid-run -- so the tracked file is read once, here, and never written.
cp "$scan" "$pen/scan.sh"
scan="$pen/scan.sh"
legs=0
failed=0

leg() {
    legs=$((legs + 1))
    if [ "$2" = "$3" ]; then
        echo "leg $1 -- ok ($2)"
    else
        echo "leg $1 -- FAILED want=$3 got=$2"
        failed=$((failed + 1))
    fi
}

read_field() {
    # $1 room, $2 key
    ( cd "$1" && sh "$scan" 2>&1 ) | tr ' ' '\n' | sed -n "s/^$2=//p" | head -1
}

plant_copy() {
    # $1 room, $2 basename
    cat > "$1/glow/$2.rye" <<'EOF'
const std = @import("std");
fn zig_safe_ident(face: []const u8, out: *[max_name_len]u8) LowerError!usize {
    if (face.len == 0 or face.len > max_name_len) return error.BadIdent;
    return face.len;
}
EOF
}

plant_stub() {
    cat > "$1/glow/$2.rye" <<'EOF'
const std = @import("std");
const zig_ident = @import("zig_ident.rye");
fn zig_safe_ident(face: []const u8, out: *[max_name_len]u8, field: []const u8) LowerError!usize {
    var slot: refusal.Slot = null;
    return try zig_ident.safe_ident(face, out[0..], max_name_len, field, .refuse, &slot);
}
EOF
}

plant_rule() {
    cat > "$1/glow/zig_ident.rye" <<'EOF'
//! A doc comment naming fn zig_safe_ident, which is prose rather than a declaration.
//! It names fn zig_safe_ident a second time on purpose.
pub fn safe_ident(face: []const u8) u32 {
    return @intCast(face.len);
}
EOF
}

# --- a room with the rule published and nothing else --------------------------------------
a="$pen/a"; mkdir -p "$a/glow"; plant_rule "$a"
leg "an empty room reads zero copies"        "$(read_field "$a" copies)"       "0"
leg "the published rule is seen"             "$(read_field "$a" published)"    "yes"
leg "the rule's own doc comment is read past" "$(read_field "$a" copies)"      "0"

# --- copies and stubs are told apart -------------------------------------------------------
plant_copy "$a" lower_one
plant_copy "$a" lower_two
plant_stub "$a" lower_three
leg "two copies counted"                     "$(read_field "$a" copies)"       "2"
leg "one stub counted, and not as a copy"    "$(read_field "$a" stubs)"        "1"
leg "the copies are named"                   "$( ( cd "$a" && sh "$scan" --list ) | grep -c '^glow/' | tr -d ' ')" "2"

# --- the ceiling refuses, then the plant is lifted -----------------------------------------
# The in-place flag is GNU-only and gated at zero (`shell_dialect`), so the swap reads to a
# new file and writes back through the original.
sed 's/^CEILING=23$/CEILING=1/' "$scan" > "$pen/ceil.sh" && cat "$pen/ceil.sh" > "$scan"
leg "two copies over a ceiling of one refuse" "$(read_field "$a" under_ceiling)" "no"
rm -f "$a/glow/lower_two.rye"
leg "lifting one plant returns it to green"   "$(read_field "$a" under_ceiling)" "yes"
sed 's/^CEILING=1$/CEILING=23/' "$scan" > "$pen/ceil.sh" && cat "$pen/ceil.sh" > "$scan"
leg "the ceiling is restored"                 "$(read_field "$a" ceiling)"      "23"

# --- a stub reverted to a copy is counted again --------------------------------------------
plant_copy "$a" lower_three
leg "a stub reverted to a copy is counted"    "$(read_field "$a" copies)"       "2"
leg "and the stub count falls with it"        "$(read_field "$a" stubs)"        "0"
plant_stub "$a" lower_three

# --- an absent rule is reported rather than assumed ----------------------------------------
rm -f "$a/glow/zig_ident.rye"
leg "an absent published rule reads no"       "$(read_field "$a" published)"    "no"
plant_rule "$a"

# --- an instrument that cannot answer refuses ----------------------------------------------
b="$pen/b"; mkdir -p "$b"
leg "a room with no glow/ refuses"            "$( ( cd "$b" && sh "$scan" 2>&1 ) | head -1 )" "instrument=no_glow_room"

# --- MUTATION 1: drop the column-one anchor ------------------------------------------------
mut1="$pen/mut1.sh"
sed "s/grep -q '\^fn zig_safe_ident'/grep -q 'fn zig_safe_ident'/" "$scan" > "$mut1"
mut1_copies=$( ( cd "$a" && sh "$mut1" 2>&1 ) | tr ' ' '\n' | sed -n 's/^copies=//p' | head -1 )
leg "dropping the column-one anchor bites"    "$mut1_copies"                    "2"
# the rule's own doc comment enters as a copy under the mutation: 1 real copy + the rule = 2,
# against the honest reading of 1 below
leg "the honest reading is one copy"          "$(read_field "$a" copies)"       "1"

# --- MUTATION 2: drop the delegation grep --------------------------------------------------
mut2="$pen/mut2.sh"
sed "s/if grep -q 'zig_ident\\\\.safe_ident' \"\$f\"; then/if false; then/" "$scan" > "$mut2"
mut2_copies=$( ( cd "$a" && sh "$mut2" 2>&1 ) | tr ' ' '\n' | sed -n 's/^copies=//p' | head -1 )
leg "dropping the delegation grep bites"      "$mut2_copies"                    "2"

echo "control_legs=$legs control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; fi
