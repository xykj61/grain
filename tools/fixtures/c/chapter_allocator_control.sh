#!/bin/sh
# tools/fixtures/c/chapter_allocator_control.sh -- prove the chapter-allocator reading from both sides.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal,
# because a refusal proven only in the passing direction cannot be told from a bypass. Both walls
# stand at zero, so each is shown at the wall and one site past it.
#
# The pen this control builds is named by mktemp, because eight checkouts share one /tmp and a
# constant name is a name every ship chose (the shared-pen law, one room over).
#
#   sh tools/fixtures/c/chapter_allocator_control.sh

set -u
root=$(pwd -P)
scan="$root/tools/fixtures/c/chapter_allocator_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=no_scan"; echo "refused: the scan under test is absent" >&2; exit 1; }

pen=$(mktemp -d "${TMPDIR:-/tmp}/chapter_allocator_control.XXXXXX") || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

faults=0
behaviors=0
say() { echo "$1"; }
claim() { # name expected actual
  behaviors=$((behaviors + 1))
  if [ "$2" = "$3" ]; then say "$1=yes"; else say "$1=no ($3, wanted $2)"; faults=$((faults + 1)); fi
}

# A pen tree carries one innocent Rye source, so every reading below is taken over a population
# that is never empty -- an empty tree refuses, and a refusal would hide a miscount.
newtree() {
  d="$pen/$1"
  rm -rf "$d"; mkdir -p "$d/mod" "$d/mod/date/20260101" "$d/rye/lib/std"
  ( cd "$d" && git init -q . && git config user.email c@example.invalid && git config user.name c )
  printf 'const std = @import("std");\nconst assert = std.debug.assert;\n' > "$d/mod/plain.rye"
  ( cd "$d" && git add -A >/dev/null 2>&1 && git commit -qm seed >/dev/null 2>&1 )
}
commit() { ( cd "$pen/$1" && git add -A >/dev/null 2>&1 && git commit -qm plant >/dev/null 2>&1 ); }

readout() { # tree key [mode] -> value
  ( cd "$pen/$1" && CHAPTER_ALLOCATOR_ROOT=. sh "$scan" ${3:-} 2>/dev/null ) | sed -n "s/^$2=//p" | head -1
}
listing() { ( cd "$pen/$1" && CHAPTER_ALLOCATOR_ROOT=. sh "$scan" --list 2>/dev/null ); }
runs_ok() { ( cd "$pen/$1" && CHAPTER_ALLOCATOR_ROOT=. sh "$scan" >/dev/null 2>&1 ); }

# --- a clean tree reads zero on both walls and passes free ----------------------------------------
newtree clean
claim clean_arena_zero 0 "$(readout clean arena_direct_sites)"
claim clean_alias_zero 0 "$(readout clean garden_alias_sites)"
claim clean_verdict_ok ok "$(readout clean verdict)"
runs_ok clean && claim clean_free yes yes || claim clean_free yes no

# --- a planted ArenaAllocator is counted, named, and refused ---------------------------------------
newtree arena
printf 'const std = @import("std");\nvar a = std.heap.ArenaAllocator.init(std.heap.page_allocator);\n' > "$pen/arena/mod/reach.rye"
commit arena
claim arena_planted_counted 1 "$(readout arena arena_direct_sites)"
claim arena_planted_one_file 1 "$(readout arena arena_direct_files)"
claim arena_planted_not_alias 0 "$(readout arena garden_alias_sites)"
claim arena_named 1 "$(listing arena | grep -c 'mod/reach.rye')"
claim arena_over_named over_wall "$(readout arena verdict)"
runs_ok arena && claim arena_over_refused yes no || claim arena_over_refused yes yes

# --- and lifted, the same tree returns to green ------------------------------------------------
rm -f "$pen/arena/mod/reach.rye"
( cd "$pen/arena" && git add -A >/dev/null 2>&1 && git commit -qm lift >/dev/null 2>&1 )
claim arena_lifted_zero 0 "$(readout arena arena_direct_sites)"
runs_ok arena && claim arena_lifted_free yes yes || claim arena_lifted_free yes no

# --- a planted GardenAllocator is its own reading, counted and refused separately -----------------
newtree alias
printf 'const std = @import("std");\npub const GardenAllocator = std.heap.ArenaAllocator;\n' > "$pen/alias/mod/rename.rye"
commit alias
claim alias_planted_counted 1 "$(readout alias garden_alias_sites)"
claim alias_planted_one_file 1 "$(readout alias garden_alias_files)"
# THE TWO READINGS ARE EXCLUSIVE ON A LINE, and this is the case that says why they must be. The
# canonical rename spells BOTH words on one line, so a reading that counted each word separately
# would charge one defect twice and a repair would look half-done. The line is charged to the
# stealing of Tally's name, which is the fault with the different cure.
claim alias_line_not_double_counted 0 "$(readout alias arena_direct_sites)"
claim alias_over_named over_wall "$(readout alias verdict)"
runs_ok alias && claim alias_over_refused yes no || claim alias_over_refused yes yes

# --- a comment teaches; it constructs nothing -----------------------------------------------------
newtree comment
printf 'const std = @import("std");\n// never construct ArenaAllocator in authored Rye\n' > "$pen/comment/mod/teach.rye"
printf '/// The season arena, never a GardenAllocator rename.\npub const x = 1;\n' > "$pen/comment/mod/doc.rye"
printf '//! Module head: ArenaAllocator stays in inherited std.\npub const y = 2;\n' > "$pen/comment/mod/head.rye"
printf 'pub fn f() void {\n    // reach init.arena rather than ArenaAllocator here\n}\n' > "$pen/comment/mod/indent.rye"
commit comment
claim comment_free 0 "$(readout comment arena_direct_sites)"
claim comment_alias_free 0 "$(readout comment garden_alias_sites)"
claim comment_absent_from_listing 0 "$(listing comment | grep -c 'teach.rye')"
runs_ok comment && claim comment_passes_free yes yes || claim comment_passes_free yes no

# --- and the comment rule is not a door: the same word on a code line still counts ------------------
newtree notdoor
printf 'pub fn f() void {\n    // a comment about it\n    var a = std.heap.ArenaAllocator.init(x);\n}\n' > "$pen/notdoor/mod/mixed.rye"
commit notdoor
claim comment_rule_not_a_door 1 "$(readout notdoor arena_direct_sites)"

# --- dated testimony keeps every word it wrote -----------------------------------------------------
newtree dated
printf 'var a = std.heap.ArenaAllocator.init(x);\n' > "$pen/dated/mod/date/20260101/20260101-010101_elder.rye"
commit dated
claim dated_testimony_free 0 "$(readout dated arena_direct_sites)"
claim dated_absent_from_listing 0 "$(listing dated | grep -c 'elder.rye')"

# --- inherited std may keep the name, per inherited-names.md ---------------------------------------
# On the live tree rye/lib/std is a symlink into vendor/zig-toolchain, so git lists no byte inside
# it and this rule costs nothing to honor. It is proven here so a later lap that vendors std INTO
# the index does not red this wall for obeying the spec.
newtree std
printf 'pub const ArenaAllocator = struct { };\n' > "$pen/std/rye/lib/std/heap.rye"
commit std
claim inherited_std_free 0 "$(readout std arena_direct_sites)"
claim inherited_std_absent 0 "$(listing std | grep -c 'lib/std')"

# --- and THAT rule is not a door either: the same bytes one room over still count -------------------
newtree stdnotdoor
mkdir -p "$pen/stdnotdoor/rye/lib/stdish"
printf 'pub const ArenaAllocator = struct { };\n' > "$pen/stdnotdoor/rye/lib/stdish/heap.rye"
commit stdnotdoor
claim inherited_rule_not_a_door 1 "$(readout stdnotdoor arena_direct_sites)"

# --- this reading is of authored Rye ---------------------------------------------------------------
newtree other
printf 'const a = std.heap.ArenaAllocator;\n' > "$pen/other/mod/carrier.zig"
printf 'Never construct ArenaAllocator in authored Rye.\n' > "$pen/other/mod/law.md"
commit other
claim other_extension_free 0 "$(readout other arena_direct_sites)"

# --- an untracked source is not read, because the population is the index --------------------------
newtree untracked
printf 'var a = std.heap.ArenaAllocator.init(x);\n' > "$pen/untracked/mod/loose.rye"
claim untracked_free 0 "$(readout untracked arena_direct_sites)"

# --- the affirmative half is reported, and reads what it claims -------------------------------------
newtree seam
printf 'pub fn f() void {\n    const garden = init.arena.allocator();\n    _ = garden;\n}\n' > "$pen/seam/mod/reach.rye"
commit seam
claim seam_reach_counted 1 "$(readout seam seam_reach_files)"
claim seam_is_not_a_hit 0 "$(readout seam arena_direct_sites)"
runs_ok seam && claim seam_passes_free yes yes || claim seam_passes_free yes no

# --- a tree with no Rye sources refuses rather than reading clean ----------------------------------
mkdir -p "$pen/bare"
( cd "$pen/bare" && git init -q . && git config user.email c@example.invalid && git config user.name c \
  && printf 'x\n' > only.md && git add -A >/dev/null 2>&1 && git commit -qm seed >/dev/null 2>&1 )
claim no_sources_refused no_sources "$(readout bare verdict)"

# --- a root that is not a checkout refuses ----------------------------------------------------------
mkdir -p "$pen/nogit"
claim no_git_refused no_git "$( cd "$pen/nogit" && CHAPTER_ALLOCATOR_ROOT=. sh "$scan" 2>/dev/null | sed -n 's/^verdict=//p' | head -1 )"

# --- a root that is not a directory refuses -----------------------------------------------------------
claim no_root_refused no_root "$( CHAPTER_ALLOCATOR_ROOT="$pen/absent" sh "$scan" 2>/dev/null | sed -n 's/^verdict=//p' | head -1 )"

# COUNTED RATHER THAN SPELLED, for the reason the sibling control learned by drifting: a number
# carried in prose parts from the thing it counts on the first lap nobody edits both.
echo "behaviors=$behaviors"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then echo "control_verdict=proven"; else echo "control_verdict=faulted"; exit 1; fi
