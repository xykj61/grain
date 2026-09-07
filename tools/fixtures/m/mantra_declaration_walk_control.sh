#!/bin/sh
# tools/fixtures/m/mantra_declaration_walk_control.sh -- break the room in a pen,
# and prove the declaration walk answers each break.
#
# A witness nobody has watched fail is a witness nobody has tested. This control
# copies mantra/src into a throwaway pen, plants one fault at a time, and asserts
# the walk refuses each -- then plants the SAME method-level fault against a
# one-level walk and asserts that one walks past it, which is the measurement
# that makes the recursive descent load-bearing rather than decorative.
#
# Every phase starts from a fresh clean copy, so each refusal is proven from both
# sides: planted it reds, absent it greens.
#
# Run from the repository root:
#   sh tools/fixtures/m/mantra_declaration_walk_control.sh

set -u

# The root is found by walking up, so the control runs from anywhere, and `plant.sh` is imported
# rather than re-written here: a plant is a CLAIM that a literal line stands in the module today,
# and this control's own elder-ArrayList phase went on naming `u32` after the type became `LineId`
# -- reading `elder_arraylist_exit=0` against a module it had never broken (REDS %519's family).
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "control_verdict=no_root"
    echo "detail: no tree root within 8 steps of $0 (needs rishi/bin and tools/fixtures)"
    exit 1
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/p/plant.sh"

root=$_fd_root
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
src="$root/mantra/src"

if [ ! -x "$zig" ]; then
  echo "control_verdict=no_toolchain"
  echo "detail: $zig is absent -- a control without its compiler names the compiler, never a file"
  exit 1
fi

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT

fresh() {
  rm -rf "$pen/src"
  mkdir -p "$pen/src"
  cp "$src"/*.rye "$pen/src/"
}

# build_walk: build the room's own witness in the pen; echo its exit status.
build_walk() {
  ( cd "$pen/src" && env RYE_ZIG="$zig" "$rye" build declaration_walk_witness.rye \
      -femit-bin="$pen/walk_bin" ) >"$pen/out.txt" 2>&1
  echo $?
}

# run_walk: build, then RUN, since a floor is a runtime assert rather than a
# compile error; echo the first non-zero of the two.
run_walk() {
  b=$(build_walk)
  if [ "$b" -ne 0 ]; then echo "$b"; return; fi
  "$pen/walk_bin" >>"$pen/out.txt" 2>&1
  echo $?
}

# build_shallow: build a ONE-LEVEL walk over store.rye in the pen.
build_shallow() {
  cat > "$pen/src/shallow_probe.rye" <<'PROBE'
const std = @import("std");
const s = @import("store.rye");

pub fn main() void {
    inline for (@typeInfo(s).@"struct".decls) |decl| {
        _ = &@field(s, decl.name);
    }
    std.debug.print("SHALLOW OK\n", .{});
}
PROBE
  ( cd "$pen/src" && env RYE_ZIG="$zig" "$rye" build shallow_probe.rye \
      -femit-bin="$pen/shallow_bin" ) >"$pen/shallow_out.txt" 2>&1
  echo $?
}

fails=0
note() { echo "$1"; }
want() { # want <name> <got> <expected>
  if [ "$2" != "$3" ]; then
    fails=$((fails + 1))
    note "FAIL $1: got exit $2, wanted $3"
  fi
}

# --- 1. the pen is innocent -------------------------------------------------
fresh
clean_exit=$(run_walk)
note "clean_exit=$clean_exit"
want clean "$clean_exit" 0

# The room's own count, read from the clean run rather than spelled here. A floor phase proves the
# bound from both sides, and both sides are one past each other -- so the two numbers have to move
# with the room. Spelled, they stood at 19 and 20 while the room grew to 31, and both phases passed
# for the same reason: a floor far under the count refuses nothing.
room_count=$(sed -n 's/.* room=\([0-9][0-9]*\).*/\1/p' "$pen/out.txt" | tail -1)
case "$room_count" in
  ''|*[!0-9]*)
    fails=$((fails + 1))
    note "FAIL room_count: the clean run printed no room= count, so the floor phases have no number"
    room_count=0 ;;
esac
note "room_count=$room_count"

# --- 2. the elder ArrayList init form, REDS %449's own shape ----------------
fresh
plant_apply "$pen/src/diff.rye" \
  's|var deletes: std\.ArrayListUnmanaged(LineId) = \.empty;|var deletes = std.ArrayListUnmanaged(LineId){};|' \
  elder_arraylist || fails=$((fails + 1))
elder_arraylist_exit=$(build_walk)
note "elder_arraylist_exit=$elder_arraylist_exit"
[ "$elder_arraylist_exit" -eq 0 ] && { fails=$((fails+1)); note "FAIL elder_arraylist: the elder init form must refuse"; }

# --- 3. a std function the toolchain renamed --------------------------------
fresh
plant_apply "$pen/src/store.rye" 's|std\.mem\.trimEnd(|std.mem.trimRight(|' elder_trim \
  || fails=$((fails + 1))
elder_trim_exit=$(build_walk)
note "elder_trim_exit=$elder_trim_exit"
[ "$elder_trim_exit" -eq 0 ] && { fails=$((fails+1)); note "FAIL elder_trim: a renamed std function must refuse"; }

# --- 4. a dropped try on an optional return ---------------------------------
fresh
plant_apply "$pen/src/store.rye" 's|return try allocator\.dupe(u8, name);|return allocator.dupe(u8, name);|' \
  missing_try || fails=$((fails + 1))
missing_try_exit=$(build_walk)
note "missing_try_exit=$missing_try_exit"
[ "$missing_try_exit" -eq 0 ] && { fails=$((fails+1)); note "FAIL missing_try: a dropped try must refuse"; }

# --- 5. a fault in a top-level function -------------------------------------
fresh
printf '\npub const planted_top_fault: u32 = "not a number";\n' >> "$pen/src/diff.rye"
toplevel_exit=$(build_walk)
note "toplevel_exit=$toplevel_exit"
[ "$toplevel_exit" -eq 0 ] && { fails=$((fails+1)); note "FAIL toplevel: a top-level type error must refuse"; }

# --- 6. a fault inside a STRUCT METHOD, and the depth it proves -------------
fresh
plant_apply "$pen/src/store.rye" \
  's|        const buf = try allocator\.alloc(u8, 1024 \* 1024);|        const planted: u32 = "not a number"; _ = planted; const buf = try allocator.alloc(u8, 1024 * 1024);|' \
  method || fails=$((fails + 1))
method_exit=$(build_walk)
note "method_exit=$method_exit"
[ "$method_exit" -eq 0 ] && { fails=$((fails+1)); note "FAIL method: a fault inside a struct method must refuse"; }

# the same planted tree, read by a ONE-LEVEL walk
shallow_exit=$(build_shallow)
note "shallow_exit=$shallow_exit"
want shallow_walks_past "$shallow_exit" 0

# --- 7. the room floor, proven from both sides ------------------------------
fresh
plant_apply "$pen/src/declaration_walk_witness.rye" \
  "s|const min_room_declarations: u32 = 16;|const min_room_declarations: u32 = ${room_count};|" \
  floor_at || fails=$((fails + 1))
floor_at_exit=$(run_walk)
note "floor_at_exit=$floor_at_exit"
want floor_at "$floor_at_exit" 0

fresh
plant_apply "$pen/src/declaration_walk_witness.rye" \
  "s|const min_room_declarations: u32 = 16;|const min_room_declarations: u32 = $((room_count + 1));|" \
  floor_over || fails=$((fails + 1))
floor_over_exit=$(run_walk)
note "floor_over_exit=$floor_over_exit"
[ "$floor_over_exit" -eq 0 ] && { fails=$((fails+1)); note "FAIL floor_over: one past the measured count must refuse"; }

# --- verdict ----------------------------------------------------------------
note "behaviors=9 fails=$fails"
if [ "$fails" -eq 0 ]; then
  note "control_verdict=ok"
  exit 0
fi
note "control_verdict=failed"
exit 1
