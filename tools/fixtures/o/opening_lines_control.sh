#!/bin/sh
# opening_lines_control.sh -- prove the opening-triad scan's readings from both sides.
#
# Run from the repository root:
#   sh tools/fixtures/o/opening_lines_control.sh
#
# WHY A CONTROL. The scan reads a derived population rather than a hand list, so every reading it
# prints is a claim about files nobody typed. A reading proven only where it passes cannot be told
# from one stuck at zero -- so each plant below is counted while it stands and read back to zero
# once it is removed.
#
# The pen is a throwaway directory named to the scan through its optional rooms argument, which is
# the whole reason that argument exists: the real roster names real rooms, and a control must own
# its own files.

set -e
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT
ROOT=$(pwd -P)
ROOMS="$PEN/rooms.txt"
ROOM="$PEN/room"
mkdir -p "$ROOM"

# A comment line naming a REAL second room holding a real hosted file, plus a blank line. A stripped
# comment leaves that room's file outside the population; a comment read as a room would add it. The
# elder draft asserted stripping from the clean count alone, which is the same reading wearing two
# names -- it could not have failed while the first one passed.
COMMENTED="$PEN/commented"
mkdir -p "$COMMENTED"
printf '# %s\n\n%s\n' "$COMMENTED" "$ROOM" > "$ROOMS"

# ONE SCAN PER STATE, not one per field. The first draft re-ran the scan for every reading it
# wanted, so a case asking five fields paid five scans; the control ran 22.7s against a witness that
# had cost 966ms. `snap` captures the scan once into the pen and `field` reads that capture, which
# is the same per-item fork the ledger guards were repaired for on `20260908`.
SNAP="$PEN/snap.txt"
snap() {
  rishi/bin/rishi run tools/fixtures/o/opening_lines_scan.rish "$ROOMS" > "$SNAP" 2>&1
}
field() {
  grep -oE "(^|[[:space:]])$1=[^[:space:]]*" "$SNAP" | head -1 | sed "s/.*$1=//"
}
read_field() {
  snap
  field "$1"
}

triad() {
  printf 'const std = @import("std");\nconst assert = std.debug.assert;\nconst print = std.debug.print;\n' > "$1"
}

# 1 -- a clean hosted file reads zero on every reading, and is counted as hosted.
triad "$ROOM/clean.rye"
snap
clean_hosted=$(field hosted)
clean_qa=$(field qualified_assert)
clean_qp=$(field qualified_print)
clean_ba=$(field missing_assert_bind)
clean_bp=$(field missing_print_bind)
[ "$clean_hosted" = "1" ] && echo "clean_counted_hosted=yes" || echo "clean_counted_hosted=no"
if [ "$clean_qa" = "0" ] && [ "$clean_qp" = "0" ] && [ "$clean_ba" = "0" ] && [ "$clean_bp" = "0" ]; then
  echo "clean_reads_zero=yes"
else
  echo "clean_reads_zero=no"
fi
# The commented room's file exists and is hosted, so hosted stays 1 only if the comment is stripped.
printf 'const std = @import("std");\nconst assert = std.debug.assert;\nconst print = std.debug.print;\n' > "$COMMENTED/also.rye"
[ "$(read_field hosted)" = "1" ] && echo "roster_comment_stripped=yes" || echo "roster_comment_stripped=no"

# 2 -- a .rye that never binds std is not hosted, so it is outside every reading.
printf 'pub fn add(a: u32, b: u32) u32 { return a + b; }\n' > "$ROOM/bare.rye"
[ "$(read_field hosted)" = "1" ] && echo "non_hosted_uncounted=yes" || echo "non_hosted_uncounted=no"
rm -f "$ROOM/bare.rye"

# 3 -- a hosted file that never binds bare assert is counted, and clears when it does.
printf 'const std = @import("std");\nconst print = std.debug.print;\n' > "$ROOM/noassert.rye"
[ "$(read_field missing_assert_bind)" = "1" ] && echo "missing_assert_bind_counted=yes" || echo "missing_assert_bind_counted=no"
triad "$ROOM/noassert.rye"
[ "$(read_field missing_assert_bind)" = "0" ] && echo "missing_assert_bind_cleared=yes" || echo "missing_assert_bind_cleared=no"
rm -f "$ROOM/noassert.rye"

# 4 -- the same, one line over, for the print bind.
printf 'const std = @import("std");\nconst assert = std.debug.assert;\n' > "$ROOM/noprint.rye"
[ "$(read_field missing_print_bind)" = "1" ] && echo "missing_print_bind_counted=yes" || echo "missing_print_bind_counted=no"
triad "$ROOM/noprint.rye"
[ "$(read_field missing_print_bind)" = "0" ] && echo "missing_print_bind_cleared=yes" || echo "missing_print_bind_cleared=no"
rm -f "$ROOM/noprint.rye"

# 5 -- a qualified debug call is the wall's own subject, so it is planted and then lifted.
triad "$ROOM/qual.rye"
printf 'pub fn f() void { std.debug.assert(true); }\n' >> "$ROOM/qual.rye"
[ "$(read_field qualified_assert)" = "1" ] && echo "qualified_assert_counted=yes" || echo "qualified_assert_counted=no"
triad "$ROOM/qual.rye"
[ "$(read_field qualified_assert)" = "0" ] && echo "qualified_assert_cleared=yes" || echo "qualified_assert_cleared=no"
printf 'pub fn f() void { std.debug.print("x", .{}); }\n' >> "$ROOM/qual.rye"
[ "$(read_field qualified_print)" = "1" ] && echo "qualified_print_counted=yes" || echo "qualified_print_counted=no"
rm -f "$ROOM/qual.rye"

# 6 -- the find flags are about what a FILE is rather than which rooms the law reaches, so a symlink
# and a `bin/` path stay outside the population whatever the roster says.
triad "$PEN/target.rye"
ln -s "$PEN/target.rye" "$ROOM/link.rye"
[ "$(read_field hosted)" = "1" ] && echo "symlink_skipped=yes" || echo "symlink_skipped=no"
rm -f "$ROOM/link.rye"
mkdir -p "$ROOM/bin"
triad "$ROOM/bin/tool.rye"
[ "$(read_field hosted)" = "1" ] && echo "bin_path_skipped=yes" || echo "bin_path_skipped=no"
rm -rf "$ROOM/bin"

# 7 -- a ratchet ceiling, shown from both sides. Five qualified-print files sit at the ceiling and
# pass free; a sixth is one over and is counted, so the ceiling refuses rather than saturates.
i=1
while [ $i -le 5 ]; do
  triad "$ROOM/qp$i.rye"
  printf 'pub fn f() void { std.debug.print("x", .{}); }\n' >> "$ROOM/qp$i.rye"
  i=$((i + 1))
done
[ "$(read_field ratchets_over_ceiling)" = "0" ] && echo "ratchet_at_ceiling_free=yes" || echo "ratchet_at_ceiling_free=no"
triad "$ROOM/qp6.rye"
printf 'pub fn f() void { std.debug.print("x", .{}); }\n' >> "$ROOM/qp6.rye"
snap
[ "$(field qualified_print)" = "6" ] && echo "ratchet_over_counted=yes" || echo "ratchet_over_counted=no"
[ "$(field ratchets_over_ceiling)" = "1" ] && echo "ratchet_over_ceiling_refused=yes" || echo "ratchet_over_ceiling_refused=no"
i=1
while [ $i -le 6 ]; do rm -f "$ROOM/qp$i.rye"; i=$((i + 1)); done

# 8 -- the elder twenty-four are named on the default roster and absent on a pen's, because they are
# real tree paths and a pen owns different files.
snap
pen_elder=$(grep -c 'elder_roster=absent' "$SNAP" || true)
[ "$pen_elder" = "1" ] && echo "pen_roster_absents_elder=yes" || echo "pen_roster_absents_elder=no"
default_elder=$(rishi/bin/rishi run tools/fixtures/o/opening_lines_scan.rish 2>&1 | grep -c 'elder_roster=24' || true)
[ "$default_elder" = "1" ] && echo "default_roster_names_elder=yes" || echo "default_roster_names_elder=no"

echo "control_verdict=ok"
