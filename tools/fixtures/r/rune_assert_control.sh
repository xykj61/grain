#!/bin/sh
# rune_assert_control.sh -- prove the rune-assert scan's readings from both sides.
#
# Run from the repository root:
#   sh tools/fixtures/r/rune_assert_control.sh
#
# WHY A CONTROL. The scan reads a derived population rather than a hand list, so every reading it
# prints is a claim about files nobody typed. A reading proven only where it passes cannot be told
# from one stuck at zero, so each plant below is counted while it stands and read back to zero once
# it is removed.
#
# THE TWO RATCHETS ARE ONE FAULT WEARING TWO NAMES until they are planted apart: a file with no
# assert at all and a file that asserts without naming an invariant are told apart only by the
# `assert(` count, so a single plant would land in one bucket and say nothing about the other.
# Cases 2 and 3 plant them separately and assert that each moves its own counter alone.
#
# THE PEN'S CEILINGS ARE ZERO, which is the whole reason the scan lowers them off the default
# roster: the tree's ratchets stand at 100 and 101, and a control cannot plant a hundred files to
# watch a ceiling refuse.

set -e
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT
ROOMS="$PEN/rooms.txt"
ROOM="$PEN/room"
mkdir -p "$ROOM"

# A comment line naming a REAL second room holding a real `.rye`, plus a blank line. A stripped
# comment leaves that room's file outside the population; a comment read as a room would add it.
COMMENTED="$PEN/commented"
mkdir -p "$COMMENTED"
printf '# %s\n\n%s\n' "$COMMENTED" "$ROOM" > "$ROOMS"

SNAP="$PEN/snap.txt"
snap() {
  sh tools/fixtures/r/rune_assert_sweep_scan.sh "$ROOMS" > "$SNAP" 2>&1
}
field() {
  grep -oE "(^|[[:space:]])$1=[^[:space:]]*" "$SNAP" | head -1 | sed "s/.*$1=//"
}
read_field() {
  snap
  field "$1"
}

# A file that states its invariant the way TAME asks: one assert, one `// invariant:` above it.
clean_file() {
  printf 'const std = @import("std");\nconst assert = std.debug.assert;\npub fn go() void {\n    // invariant: a clean file says why.\n    assert(true);\n}\n' > "$1"
}

# 1 -- a clean authored file is counted, bears a function, and moves neither ratchet.
clean_file "$ROOM/clean.rye"
snap
[ "$(field authored)" = "1" ] && echo "clean_counted=yes" || echo "clean_counted=no"
[ "$(field fn_bearing)" = "1" ] && echo "clean_fn_bearing=yes" || echo "clean_fn_bearing=no"
if [ "$(field zero_assert)" = "0" ] && [ "$(field invariant_gap)" = "0" ]; then
  echo "clean_reads_zero=yes"
else
  echo "clean_reads_zero=no"
fi
[ "$(field ratchets_over_ceiling)" = "0" ] && echo "clean_under_ceiling=yes" || echo "clean_under_ceiling=no"
clean_file "$COMMENTED/also.rye"
[ "$(read_field authored)" = "1" ] && echo "roster_comment_stripped=yes" || echo "roster_comment_stripped=no"

# 2 -- a function-bearing file with no assert moves `zero_assert` alone, and refuses the pen's
# ceiling of zero. Both sides: the plant counted while it stands, read back once it is removed.
printf 'pub fn quiet() void {\n    return;\n}\n' > "$ROOM/quiet.rye"
snap
[ "$(field zero_assert)" = "1" ] && echo "zero_assert_counted=yes" || echo "zero_assert_counted=no"
[ "$(field invariant_gap)" = "0" ] && echo "zero_assert_leaves_gap_alone=yes" || echo "zero_assert_leaves_gap_alone=no"
[ "$(field ratchets_over_ceiling)" = "1" ] && echo "zero_assert_over_ceiling_refused=yes" || echo "zero_assert_over_ceiling_refused=no"
grep -q "detail: zero_assert $ROOM/quiet.rye" "$SNAP" && echo "zero_assert_named=yes" || echo "zero_assert_named=no"
rm -f "$ROOM/quiet.rye"
[ "$(read_field zero_assert)" = "0" ] && echo "zero_assert_cleared=yes" || echo "zero_assert_cleared=no"

# 3 -- a file that asserts and names no invariant moves `invariant_gap` alone, and clears when the
# comment arrives.
printf 'const std = @import("std");\nconst assert = std.debug.assert;\npub fn loud() void {\n    assert(true);\n}\n' > "$ROOM/loud.rye"
snap
[ "$(field invariant_gap)" = "1" ] && echo "invariant_gap_counted=yes" || echo "invariant_gap_counted=no"
[ "$(field zero_assert)" = "0" ] && echo "invariant_gap_leaves_zero_alone=yes" || echo "invariant_gap_leaves_zero_alone=no"
[ "$(field ratchets_over_ceiling)" = "1" ] && echo "invariant_gap_over_ceiling_refused=yes" || echo "invariant_gap_over_ceiling_refused=no"
clean_file "$ROOM/loud.rye"
[ "$(read_field invariant_gap)" = "0" ] && echo "invariant_gap_cleared=yes" || echo "invariant_gap_cleared=no"
rm -f "$ROOM/loud.rye"

# 4 -- a file with no functions is authored and is asked for nothing. A data table or an enum
# declaring no `fn` states no invariant because it has none to state.
printf 'pub const Kind = enum { one, two };\n' > "$ROOM/plain.rye"
snap
[ "$(field authored)" = "2" ] && echo "no_fn_counted_authored=yes" || echo "no_fn_counted_authored=no"
[ "$(field fn_bearing)" = "1" ] && echo "no_fn_not_fn_bearing=yes" || echo "no_fn_not_fn_bearing=no"
[ "$(field zero_assert)" = "0" ] && echo "no_fn_moves_nothing=yes" || echo "no_fn_moves_nothing=no"
rm -f "$ROOM/plain.rye"

# 5 -- a qualified `std.debug.assert(` counts as an assert. The question here is whether the file
# states an invariant; `tame_check` separately holds the qualified spelling at zero, and two guards
# asking one question of one line is the braid this family keeps untying.
printf 'const std = @import("std");\npub fn q() void {\n    // invariant: the qualified form still asserts.\n    std.debug.assert(true);\n}\n' > "$ROOM/qual.rye"
[ "$(read_field zero_assert)" = "0" ] && echo "qualified_counts_as_assert=yes" || echo "qualified_counts_as_assert=no"
rm -f "$ROOM/qual.rye"

# 6 -- a longer identifier ENDING in assert is a different function and is left alone.
printf 'pub fn x() void {\n    xassert(true);\n}\n' > "$ROOM/near.rye"
[ "$(read_field zero_assert)" = "1" ] && echo "near_miss_not_an_assert=yes" || echo "near_miss_not_an_assert=no"
rm -f "$ROOM/near.rye"

# 7 -- a symlink and a `bin/` path stay outside the population, which is what the find flags claim.
ln -s clean.rye "$ROOM/link.rye"
mkdir -p "$ROOM/bin"
clean_file "$ROOM/bin/built.rye"
[ "$(read_field authored)" = "1" ] && echo "symlink_and_bin_skipped=yes" || echo "symlink_and_bin_skipped=no"
rm -rf "$ROOM/link.rye" "$ROOM/bin"

# 8 -- the elder roster is absent on a pen, because a pen owns no tree paths, and present on the
# real roster, where it reads twelve.
snap
grep -q "elder_roster=absent" "$SNAP" && echo "pen_elder_absent=yes" || echo "pen_elder_absent=no"
sh tools/fixtures/r/rune_assert_sweep_scan.sh > "$SNAP" 2>&1
[ "$(field elder_roster)" = "12" ] && echo "tree_elder_roster_twelve=yes" || echo "tree_elder_roster_twelve=no"
[ "$(field elder_faults)" = "0" ] && echo "tree_elder_clean=yes" || echo "tree_elder_clean=no"

# 9 -- an absent rooms file refuses rather than reading an empty population, which would print a
# green over nothing at all.
if sh tools/fixtures/r/rune_assert_sweep_scan.sh "$PEN/nowhere.txt" > "$SNAP" 2>&1; then
  echo "absent_roster_refused=no"
else
  grep -q "verdict=unread" "$SNAP" && echo "absent_roster_refused=yes" || echo "absent_roster_refused=no"
fi

echo "control=done"
