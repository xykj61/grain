#!/bin/sh
# tame_check_control.sh -- prove the tame-check scan's readings from both sides.
#
# Run from the repository root:
#   sh tools/fixtures/t/tame_check_control.sh
#
# WHY A CONTROL. The scan reads a derived population rather than a hand list, so every reading it
# prints is a claim about files nobody typed. A reading proven only where it passes cannot be told
# from one stuck at zero -- so each plant below is counted while it stands and read back to zero
# once it is removed.
#
# THE ONE READING THAT NEEDS BOTH SIDES MOST is the trailing-whitespace split. `trailing_content`
# and `trailing_authored` are two names over one fault, told apart only by whether the line opens a
# `\\` multiline string, so a single planted file cannot prove them: it would land in one bucket and
# say nothing about the other. Cases 5 and 6 plant the same trailing space twice, once inside a
# string literal and once outside it, and assert that each moves its own counter and leaves the
# other at zero.
#
# The pen is a throwaway directory named to the scan through its optional rooms argument, which is
# the whole reason that argument exists: the real roster names real rooms, and a control must own
# its own files.

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

# ONE SCAN PER STATE, not one per field -- diffuser's `20260908` finding, taken before shipping
# rather than after. `snap` captures the scan once into the pen and `field` reads that capture.
SNAP="$PEN/snap.txt"
snap() {
  rishi/bin/rishi run tools/fixtures/t/tame_check_scan.rish "$ROOMS" > "$SNAP" 2>&1
}
field() {
  grep -oE "(^|[[:space:]])$1=[^[:space:]]*" "$SNAP" | head -1 | sed "s/.*$1=//"
}
read_field() {
  snap
  field "$1"
}

clean_file() {
  printf 'const std = @import("std");\nconst assert = std.debug.assert;\npub fn go() void {\n    assert(true);\n}\n' > "$1"
}

# 1 -- a clean authored file is counted, and reads zero on every reading.
clean_file "$ROOM/clean.rye"
snap
[ "$(field authored)" = "1" ] && echo "clean_counted=yes" || echo "clean_counted=no"
if [ "$(field qualified_assert)" = "0" ] && [ "$(field self_this)" = "0" ] \
  && [ "$(field tabs)" = "0" ] && [ "$(field trailing_authored)" = "0" ] \
  && [ "$(field trailing_content)" = "0" ]; then
  echo "clean_reads_zero=yes"
else
  echo "clean_reads_zero=no"
fi
clean_file "$COMMENTED/also.rye"
[ "$(read_field authored)" = "1" ] && echo "roster_comment_stripped=yes" || echo "roster_comment_stripped=no"

# 2 -- a file that never imports std is still authored, which is where these four rules part from
# the opening triad: a tab is a fault whether or not the file is hosted.
printf 'pub const Kind = enum { one, two };\n' > "$ROOM/plain.rye"
[ "$(read_field authored)" = "2" ] && echo "non_hosted_counted=yes" || echo "non_hosted_counted=no"
rm -f "$ROOM/plain.rye"

# 3 -- a qualified assert is counted, and the count falls when it is removed.
clean_file "$ROOM/qual.rye"
printf 'pub fn q() void { std.debug.assert(true); }\n' >> "$ROOM/qual.rye"
[ "$(read_field qualified_assert)" = "1" ] && echo "qualified_assert_counted=yes" || echo "qualified_assert_counted=no"
# The looser predicate must also reach a spacing the elder literal missed.
clean_file "$ROOM/qual.rye"
printf 'pub fn q() void { std.debug.assert (true); }\n' >> "$ROOM/qual.rye"
[ "$(read_field qualified_assert)" = "1" ] && echo "qualified_assert_spaced_counted=yes" || echo "qualified_assert_spaced_counted=no"
rm -f "$ROOM/qual.rye"
[ "$(read_field qualified_assert)" = "0" ] && echo "qualified_assert_cleared=yes" || echo "qualified_assert_cleared=no"

# 4 -- `Self = @This()` is counted at any spacing, and clears when removed.
clean_file "$ROOM/self.rye"
printf 'const Self = @This();\n' >> "$ROOM/self.rye"
[ "$(read_field self_this)" = "1" ] && echo "self_this_counted=yes" || echo "self_this_counted=no"
clean_file "$ROOM/self.rye"
printf 'const Self=@This();\n' >> "$ROOM/self.rye"
[ "$(read_field self_this)" = "1" ] && echo "self_this_tight_counted=yes" || echo "self_this_tight_counted=no"
rm -f "$ROOM/self.rye"
[ "$(read_field self_this)" = "0" ] && echo "self_this_cleared=yes" || echo "self_this_cleared=no"

# 5 -- a tab is counted, and clears.
clean_file "$ROOM/tab.rye"
printf 'pub fn t() void {\n\tassert(true);\n}\n' >> "$ROOM/tab.rye"
[ "$(read_field tabs)" = "1" ] && echo "tab_counted=yes" || echo "tab_counted=no"
rm -f "$ROOM/tab.rye"
[ "$(read_field tabs)" = "0" ] && echo "tab_cleared=yes" || echo "tab_cleared=no"

# 6 -- trailing whitespace OUTSIDE a multiline string is authored debt: it moves
# `trailing_authored` and leaves `trailing_content` at zero.
clean_file "$ROOM/trail.rye"
printf 'pub fn a() void { assert(true); } // named \n' >> "$ROOM/trail.rye"
snap
ta=$(field trailing_authored)
tc=$(field trailing_content)
[ "$ta" = "1" ] && [ "$tc" = "0" ] && echo "trailing_authored_counted=yes" || echo "trailing_authored_counted=no"

# 7 -- the ceiling is 1, so that single plant passes free and a second file refuses. Both sides,
# because a ceiling proven only in the passing direction cannot be told from a bypass.
[ "$(field ratchets_over_ceiling)" = "0" ] && echo "ratchet_at_ceiling_free=yes" || echo "ratchet_at_ceiling_free=no"
clean_file "$ROOM/trail2.rye"
printf 'pub fn b() void { assert(true); } // also \n' >> "$ROOM/trail2.rye"
snap
[ "$(field trailing_authored)" = "2" ] && echo "ratchet_over_counted=yes" || echo "ratchet_over_counted=no"
[ "$(field ratchets_over_ceiling)" = "1" ] && echo "ratchet_over_ceiling_refused=yes" || echo "ratchet_over_ceiling_refused=no"
rm -f "$ROOM/trail2.rye" "$ROOM/trail.rye"
[ "$(read_field trailing_authored)" = "0" ] && echo "trailing_authored_cleared=yes" || echo "trailing_authored_cleared=no"

# 8 -- the SAME trailing space INSIDE a `\\` multiline string is program content: it moves
# `trailing_content` and leaves `trailing_authored` at zero. This is the split the widening found,
# and neither plant alone would prove it.
clean_file "$ROOM/emit.rye"
printf 'pub const t =\n    \\\\const x = .{ \n;\n' >> "$ROOM/emit.rye"
snap
ta=$(field trailing_authored)
tc=$(field trailing_content)
[ "$tc" = "1" ] && [ "$ta" = "0" ] && echo "trailing_content_counted=yes" || echo "trailing_content_counted=no"
[ "$(field ratchets_over_ceiling)" = "0" ] && echo "trailing_content_ungated=yes" || echo "trailing_content_ungated=no"
rm -f "$ROOM/emit.rye"
[ "$(read_field trailing_content)" = "0" ] && echo "trailing_content_cleared=yes" || echo "trailing_content_cleared=no"

# 9 -- a symlink and a `bin/` path are not authored source.
ln -s clean.rye "$ROOM/link.rye"
[ "$(read_field authored)" = "1" ] && echo "symlink_skipped=yes" || echo "symlink_skipped=no"
rm -f "$ROOM/link.rye"
mkdir -p "$ROOM/bin"
clean_file "$ROOM/bin/built.rye"
[ "$(read_field authored)" = "1" ] && echo "bin_path_skipped=yes" || echo "bin_path_skipped=no"
rm -rf "$ROOM/bin"

# 10 -- a pen roster owns its own files and names no elder set; the default roster still names all
# sixteen, so the by-name wall cannot be quietly dropped by a pen run.
snap
grep -q 'elder_roster=absent' "$SNAP" && echo "pen_roster_absents_elder=yes" || echo "pen_roster_absents_elder=no"
rishi/bin/rishi run tools/fixtures/t/tame_check_scan.rish 2>&1 | grep -q 'elder_roster=16' \
  && echo "default_roster_names_elder=yes" || echo "default_roster_names_elder=no"

echo "control_verdict=ok"
