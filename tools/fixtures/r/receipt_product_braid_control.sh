#!/bin/sh
# tools/fixtures/r/receipt_product_braid_control.sh -- proves receipt_product_braid_scan.sh from
# both sides on a planted braid.
#
# Every refusal is planted and then LIFTED, and every welcome is asserted as hard as every refusal:
# a refusal proven only in the passing direction cannot be told from a bypass. The pen is a real git
# repository holding a real residence table and real Rye sources, so the scan under test is the live
# script reading planted bytes through its own environment overrides, never a copy.
#
# The three legs that carry the most weight are the ones about ROLE rather than ROOM. A module head
# explaining the boundary it keeps names the peer's type in a comment; a fixture names it in a
# string. Both must pass free, because a meter reading for truth has to hear a sentence that must
# stay false exactly as it hears one asserting it. The type reading blanks strings AND comments; the
# import reading blanks comments alone, since an `@import` argument IS a string literal -- and the
# first draft of the scan blanked both for both, read every import as empty, and reported a
# comfortable zero over a planted braid.
#
# Five mutations are asserted to BITE. Each removes one line the reading rests on, and a mutation
# that changes no count is a line the guard does not need.

set -eu
export LC_ALL=C

# The root by upward walk rather than by relative hops, so the fixtures room folding one level
# deeper leaves this file correct (`tools/f/fixture_depth_witness.rish`).
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done

# The plant law, imported rather than re-spelled: a plant is a claim about a file, and every
# mutation below depends on its own break having landed (REDS %519).
. "$_fd_root/tools/fixtures/p/plant.sh"

SCAN="${SCAN:-tools/fixtures/r/receipt_product_braid_scan.sh}"
[ -f "$SCAN" ] || { echo "detail: cannot read $SCAN"; echo "control_verdict=unreadable"; exit 1; }
SCAN=$(cd "$(dirname "$SCAN")" && pwd)/$(basename "$SCAN")

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT HUP INT TERM

# `sed -i` is a GNU extension this tree gates at zero, so every edit writes through the original
# file rather than moving a temporary over it -- which is also what keeps a mode the repository
# tracks (`.claude/rules/exec-bit.md`).
edit() {
  script=$1; target=$2
  sed "$script" "$target" > "$target.tmp" && cat "$target.tmp" > "$target" && rm -f "$target.tmp"
}

legs=0
failed=0

leg() {
  name=$1; want=$2; got=$3
  legs=$((legs + 1))
  if [ "$want" = "$got" ]; then
    echo "leg_ok: $name want=$want got=$got"
  else
    failed=$((failed + 1))
    echo "leg_failed: $name want=$want got=$got"
  fi
}

git_pen() {
  git -C "$PEN" -c user.email=pen@example.invalid -c user.name=pen "$@"
}

# --- the healthy tree --------------------------------------------------------
build_pen() {
  rm -rf "$PEN"
  mkdir -p "$PEN/active-designing" "$PEN/linengrow" "$PEN/dimeroll" "$PEN/mantra/src"
  cat > "$PEN/active-designing/contract.md" <<'EOF'
# a planted contract

| Residence | Owns |
|---|---|
| Kyri | canonical encoding |
| Tally | ceilings |
| Mantra | append-only admission and deterministic replay to `ReceiptState` |
| Linengrow | `ReceiptState -> LinengrowReceipt` |
| Dimeroll | `ReceiptState -> DimerollReceiptIntake` |
| Brix | the declared build closure |
EOF
  cat > "$PEN/linengrow/project.rye" <<'EOF'
const std = @import("std");
const state = @import("../mantra/src/state.rye");
pub const LinengrowReceipt = struct { receipt_id: []const u8 };
EOF
  cat > "$PEN/dimeroll/intake.rye" <<'EOF'
const std = @import("std");
pub const DimerollReceiptIntake = struct { receipt_id: []const u8 };
EOF
  cat > "$PEN/mantra/src/state.rye" <<'EOF'
// Mantra is the shared room on purpose: it may name both LinengrowReceipt and
// DimerollReceiptIntake without either product reaching the other.
pub const ReceiptState = struct { status: u8 };
EOF
  git_pen init -q .
  git_pen add -A
  git_pen commit -qm pen
}

# The `Mantra` row above names `ReceiptState` with no arrow, so the residence reader must take
# exactly the two arrow rows -- a table row mentioning a type is not a product.

run() {
  ( cd "$PEN" && CONTRACT=active-designing/contract.md sh "$SCAN" "$@" ) 2>&1 || true
}

verdict() { run | sed -n 's/^verdict=//p'; }
field() { run | tr ' ' '\n' | sed -n "s/^$1=//p"; }
# `set -e` would kill the substitution on a non-zero subshell, so the status is taken
# explicitly rather than read from `$?` after the fact.
code() { if ( cd "$PEN" && CONTRACT=active-designing/contract.md sh "$SCAN" >/dev/null 2>&1 ); then echo 0; else echo $?; fi; }

commit_pen() { git_pen add -A; git_pen commit -qm step; }

# --- 1. the healthy tree welcomes -------------------------------------------
build_pen
leg clean_verdict unbraided "$(verdict)"
leg clean_exit 0 "$(code)"
leg clean_files_a 1 "$(field files | sed -n 1p)"
leg clean_pair_a Linengrow "$(run | sed -n 's/^product_a=\([A-Za-z]*\) .*/\1/p')"
leg clean_pair_b Dimeroll "$(run | sed -n 's/^product_b=\([A-Za-z]*\) .*/\1/p')"

# --- 2. an import reaching the peer room refuses, then lifts ------------------
printf 'const peer = @import("../dimeroll/intake.rye");\n' >> "$PEN/linengrow/project.rye"
commit_pen
leg import_planted cross_import "$(verdict)"
leg import_planted_exit 1 "$(code)"
leg import_planted_count 1 "$(field cross_import)"
edit '/dimeroll\/intake.rye/d' "$PEN/linengrow/project.rye"
commit_pen
leg import_lifted unbraided "$(verdict)"

# --- 3. the peer's projection type in code refuses, then lifts ---------------
printf 'pub fn read(v: DimerollReceiptIntake) u8 { return 0; }\n' >> "$PEN/linengrow/project.rye"
commit_pen
leg type_planted cross_type "$(verdict)"
leg type_planted_exit 1 "$(code)"
leg type_planted_count 1 "$(field cross_type)"
edit '/pub fn read/d' "$PEN/linengrow/project.rye"
commit_pen
leg type_lifted unbraided "$(verdict)"

# --- 4. the braid refuses in the other direction too -------------------------
printf 'const peer = @import("../linengrow/project.rye");\n' >> "$PEN/dimeroll/intake.rye"
commit_pen
leg reverse_import cross_import "$(verdict)"
edit '/linengrow\/project.rye/d' "$PEN/dimeroll/intake.rye"
printf 'pub fn show(v: LinengrowReceipt) u8 { return 1; }\n' >> "$PEN/dimeroll/intake.rye"
commit_pen
leg reverse_type cross_type "$(verdict)"
edit '/pub fn show/d' "$PEN/dimeroll/intake.rye"
commit_pen
leg reverse_lifted unbraided "$(verdict)"

# --- 5. role, not room: a comment and a string pass free ---------------------
printf '// this module never reaches DimerollReceiptIntake, by the contract\n' >> "$PEN/linengrow/project.rye"
commit_pen
leg comment_welcome unbraided "$(verdict)"
leg comment_counted 1 "$(field cross_mention)"
printf 'const note = "DimerollReceiptIntake";\n' >> "$PEN/linengrow/project.rye"
commit_pen
leg string_welcome unbraided "$(verdict)"
leg string_counted 2 "$(field cross_mention)"

# --- 6. a trailing comment does not hide real code ---------------------------
printf 'pub fn late(v: DimerollReceiptIntake) u8 { return 0; } // and a note\n' >> "$PEN/linengrow/project.rye"
commit_pen
leg trailing_comment_bites cross_type "$(verdict)"
edit '/pub fn late/d' "$PEN/linengrow/project.rye"
commit_pen
leg trailing_comment_lifted unbraided "$(verdict)"

# --- 7. a Zig multiline string tail is prose, never code ---------------------
printf '    \\\\ DimerollReceiptIntake rides in this text\n' >> "$PEN/linengrow/project.rye"
commit_pen
leg multiline_welcome unbraided "$(verdict)"

# --- 8. the peer room's own word is a tell, and gates nothing ----------------
printf 'const dimeroll_note: u8 = 1;\n' >> "$PEN/linengrow/project.rye"
commit_pen
leg peer_word_welcome unbraided "$(verdict)"
leg peer_word_counted 1 "$(field peer_word)"
edit '/dimeroll_note/d' "$PEN/linengrow/project.rye"
commit_pen

# --- 9. the shared room may name both ----------------------------------------
leg shared_room_welcome unbraided "$(verdict)"

# --- 10. the index decides, never the disk ----------------------------------
printf 'pub fn untracked(v: DimerollReceiptIntake) u8 { return 0; }\n' > "$PEN/linengrow/scratch.rye"
leg untracked_ignored unbraided "$(verdict)"
git_pen add -A >/dev/null 2>&1
git_pen commit -qm tracked
leg tracked_bites cross_type "$(verdict)"
git_pen rm -q "linengrow/scratch.rye"
git_pen commit -qm untrack
leg tracked_lifted unbraided "$(verdict)"

# --- 11. a path holding a space is read -------------------------------------
printf 'pub fn spaced(v: DimerollReceiptIntake) u8 { return 0; }\n' > "$PEN/linengrow/a file.rye"
git_pen add -A >/dev/null 2>&1
git_pen commit -qm spaced
leg spaced_path_read cross_type "$(verdict)"
git_pen rm -q "linengrow/a file.rye"
git_pen commit -qm unspace
leg spaced_path_lifted unbraided "$(verdict)"

# --- 12. the contract names the pair, so a rename moves the guard ------------
edit 's/DimerollReceiptIntake`/DimerollIntakeV2`/' "$PEN/active-designing/contract.md"
printf 'pub fn v2(v: DimerollIntakeV2) u8 { return 0; }\n' >> "$PEN/linengrow/project.rye"
commit_pen
leg rename_follows cross_type "$(verdict)"
edit '/pub fn v2/d' "$PEN/linengrow/project.rye"
edit 's/DimerollIntakeV2`/DimerollReceiptIntake`/' "$PEN/active-designing/contract.md"
commit_pen
leg rename_restored unbraided "$(verdict)"

# --- 13. a contract this scan cannot read REFUSES rather than reads zero ------
cp "$PEN/active-designing/contract.md" "$PEN/contract.keep"
edit '/^| Dimeroll |/d' "$PEN/active-designing/contract.md"
commit_pen
leg one_row_unreadable unreadable "$(verdict)"
leg one_row_exit 1 "$(code)"
cat "$PEN/contract.keep" > "$PEN/active-designing/contract.md"
commit_pen
leg contract_restored unbraided "$(verdict)"

MISSING=$( ( cd "$PEN" && CONTRACT=active-designing/absent.md sh "$SCAN" ) 2>&1 | sed -n 's/^verdict=//p' )
leg missing_contract_unreadable unreadable "$MISSING"

# --- 14. an empty product room refuses rather than reporting a clean zero -----
git_pen rm -q "dimeroll/intake.rye"
git_pen commit -qm empty
leg empty_room_unreadable unreadable "$(verdict)"
build_pen
leg rebuilt unbraided "$(verdict)"

# --- the mutations, each asserted to bite ------------------------------------
mutate() {
  name=$1; script=$2; want=$3
  cp "$SCAN" "$PEN/mutant.sh"
  edit "$script" "$PEN/mutant.sh"
  if ! plant_landed "$SCAN" "$PEN/mutant.sh" "$name"; then
    legs=$((legs + 1)); failed=$((failed + 1))
    echo "leg_failed: ${name}_planted want=changed got=identical"
    return
  fi
  got=$( ( cd "$PEN" && CONTRACT=active-designing/contract.md sh "$PEN/mutant.sh" ) 2>&1 | sed -n 's/^verdict=//p' )
  leg "$name" "$want" "$got"
}

# The braid the healthy legs proved, re-planted so each mutation has something to miss.
printf 'const peer = @import("../dimeroll/intake.rye");\n' >> "$PEN/linengrow/project.rye"
printf '// never reaches DimerollReceiptIntake\n' >> "$PEN/linengrow/project.rye"
printf 'const note = "DimerollReceiptIntake";\n' >> "$PEN/linengrow/project.rye"
commit_pen
leg mutation_ground cross_import "$(verdict)"

# M1: the import reading takes the blanked line, so every import argument reads empty.
mutate import_blanked_misses 's/if (match(live, \/@import/if (match(code, \/@import/' unbraided
# M2: the type reading keeps the strings, so a fixture naming the type reads as a braid.
#     Proven on a tree whose only type hit is the comment and the string.
edit '/dimeroll\/intake.rye/d' "$PEN/linengrow/project.rye"
commit_pen
leg mutation_ground_prose unbraided "$(verdict)"
mutate strings_kept_false_bite 's/code = strip(raw, 0)/code = strip(raw, 1)/' cross_type
# M3: comments are no longer cut, so a module head explaining the boundary reads as a braid.
mutate comments_kept_false_bite 's|if (c == "/" \&\& substr(line, i + 1, 1) == "/") return out||' cross_type
# M4: the pair check goes, so a one-row contract reads a comfortable zero.
edit '/^| Dimeroll |/d' "$PEN/active-designing/contract.md"
commit_pen
mutate pair_check_dropped 's/\[ "$PAIRS" = "2" \]/[ "$PAIRS" != "" ]/' unreadable
cat "$PEN/contract.keep" > "$PEN/active-designing/contract.md" 2>/dev/null || true
build_pen

# M5: the population comes off the disk rather than the index, so an untracked scratch counts.
printf 'pub fn untracked(v: DimerollReceiptIntake) u8 { return 0; }\n' > "$PEN/linengrow/scratch.rye"
leg mutation_ground_untracked unbraided "$(verdict)"
mutate disk_not_index 's|git ls-files "$A_DIR" 2>/dev/null|find "$A_DIR" -type f 2>/dev/null|' cross_type

echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=legs_failed"; exit 1; fi
