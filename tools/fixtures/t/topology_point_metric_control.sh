#!/bin/sh
# tools/fixtures/t/topology_point_metric_control.sh -- the point metric, broken on purpose.
#
# WHY. comlink/topology.rye now carries a second metric, `point_hops`, which measures
# between point NUMBERS along the sponsor chain rather than between two addresses wearing
# tiers. Its selftest proves two properties by doing: every point's sponsor stands exactly
# one hop away, and from anywhere one step gets strictly closer to anywhere else. A proof
# shown only in the passing direction cannot be told from a bypass, so this copies the
# module into a pen, breaks it five ways, and watches each break answer non-zero -- then
# proves the pen innocent with an unbroken copy, and proves the legs earn their keep with a
# copy that is broken AND has the legs removed, which must pass.
#
# THE FAULT ALL OF THIS DEFENDS. REDS %454 measured `route_hops` publishing a hop count for
# 172,524 of the compass sky's 518,400 ordered pairs that no walk realizes, because 132
# points -- every planet whose star index is zero -- have nothing at all standing one hop
# from them. The cause is a metric reading a role rather than a point: `Address.parent`
# sends such a planet to a star that `encode` puts on its galaxy's own number, and `decode`
# reads that number back as a galaxy. `point_hops` walks the chain in number space, where
# those two are one point, so the step exists.
#
# THE SIX PHASES.
#   clean            -- the unmutated copy reaches GREEN, exit 0. This is what lets every
#                       other phase read as the break speaking rather than the pen.
#   search_starts_late -- the nearest-shared-ancestor search skips distance zero, so a point
#                       stops being zero hops from itself. The zero leg catches it.
#   bridge_dropped   -- the one honest hop between two galaxy admins is removed, so every
#                       cross-galaxy pair reads one short. No step can then get strictly
#                       closer, and the next-hop sweep catches it.
#   sponsor_never_rises -- the ancestor walk holds still instead of climbing, so no chain
#                       ever reaches its galaxy. The walk's own bound invariant catches it
#                       before any proof runs, which is the point of asserting the bound.
#   depth_reads_the_outfit -- `point_depth` answers the ADDRESS depth instead of counting
#                       chain steps, so a star-index-zero planet reads 2 where the chain
#                       takes 1. This is the elder fault planted directly.
#   legs_removed     -- bridge_dropped again, with the point-metric legs and their proof cut
#                       out. This phase MUST exit 0, and it is the sharpest one: it shows a
#                       broken metric sailing through while the binary still PRINTS the
#                       claim that every published distance is a road.
#
# Instrument: `sh`, `awk` and `sed`, POSIX-granted, plus the tree's own vendored zig through
# rye. The pen is a fixed name under the host temporary directory, removed on exit; no
# `mktemp`, which is not POSIX.
#
# THE PEN IS A DIRECTORY because zig resolves imports inside the root file's own directory.
# topology.rye imports only std, so one file in one directory is the honest pen.
#
# Driven by tools/co/comlink_topology_witness.rish. Run from anywhere.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

SRC="$ROOT/comlink/topology.rye"
RYE="$ROOT/rye/bin/rye"
ZIG="$ROOT/vendor/zig-toolchain/zig"
[ -f "$SRC" ] || { echo "control: the topology source is missing at $SRC" >&2; exit 2; }
[ -x "$RYE" ] || { echo "control: rye is missing at $RYE" >&2; exit 2; }
[ -x "$ZIG" ] || { echo "control: the vendored zig is missing at $ZIG" >&2; exit 2; }

PEN="${TMPDIR:-/tmp}/topology_point_metric_control_pen"
rm -rf "$PEN"
mkdir -p "$PEN"
trap 'rm -rf "$PEN"' EXIT INT TERM

faults=0

note() {
  if [ "$2" = "$3" ]; then
    printf "  %s %s ok\n" "$1" "$2"
  else
    printf "  %s %s wanted=%s MISMATCH\n" "$1" "$2" "$3"
    faults=$((faults + 1))
  fi
}

# Build one pen copy and run its selftest. Sets PEN_EXIT and PEN_OUT. A build that refuses
# is reported as its own exit, since a plant that fails to compile is still a refusal and
# saying so is more honest than letting it read as a proof leg biting.
run_pen() {
  _name=$1
  _dir="$PEN/$_name"
  mkdir -p "$_dir"
  cp "$2" "$_dir/topology.rye"
  if PEN_OUT=$(cd "$_dir" && env RYE_ZIG="$ZIG" "$RYE" build topology.rye -femit-bin=topology 2>&1); then
    PEN_OUT=$(cd "$_dir" && ./topology selftest 2>&1) && PEN_EXIT=0 || PEN_EXIT=$?
  else
    PEN_EXIT=90
  fi
}

printf "phase clean\n"
run_pen clean "$SRC"
note "clean_exit"  "$PEN_EXIT" "0"
note "clean_green" "$(printf '%s\n' "$PEN_OUT" | grep -c 'every published distance is a road')" "1"

# --- plant one: the search skips distance zero --------------------------------
printf "phase search_starts_late\n"
sed -e 's/^        var sum: u32 = 0;$/        var sum: u32 = 1;/' "$SRC" > "$PEN/a.rye"
note "search_starts_late_planted" "$(cmp -s "$SRC" "$PEN/a.rye" && echo no || echo yes)" "yes"
run_pen search_late "$PEN/a.rye"
note "search_starts_late_exit" "$([ "$PEN_EXIT" -ne 0 ] && echo refused || echo passed)" "refused"
note "search_starts_late_named" "$(printf '%s\n' "$PEN_OUT" | grep -c 'PointSelfNotZero')" "1"

# --- plant two: the bridge between two galaxy admins is dropped ---------------
printf "phase bridge_dropped\n"
sed -e 's/^        const bridged = self.point_depth(a).? + self.point_depth(b).? + 1;$/        const bridged = self.point_depth(a).? + self.point_depth(b).?;/' \
    "$SRC" > "$PEN/b.rye"
note "bridge_dropped_planted" "$(cmp -s "$SRC" "$PEN/b.rye" && echo no || echo yes)" "yes"
run_pen bridge "$PEN/b.rye"
note "bridge_dropped_exit" "$([ "$PEN_EXIT" -ne 0 ] && echo refused || echo passed)" "refused"
note "bridge_dropped_named" "$(printf '%s\n' "$PEN_OUT" | grep -c 'PointBridgeWrong')" "1"

# --- plant three: the ancestor walk holds still instead of climbing -----------
printf "phase sponsor_never_rises\n"
sed -e 's/^            chain\[k\] = self.sponsor_of(chain\[k - 1\]).?;$/            chain[k] = chain[k - 1];/' \
    "$SRC" > "$PEN/c.rye"
note "sponsor_never_rises_planted" "$(cmp -s "$SRC" "$PEN/c.rye" && echo no || echo yes)" "yes"
run_pen stall "$PEN/c.rye"
note "sponsor_never_rises_exit" "$([ "$PEN_EXIT" -ne 0 ] && echo refused || echo passed)" "refused"

# --- plant four: the depth reads the outfit, which is the elder fault ---------
printf "phase depth_reads_the_outfit\n"
sed -e 's/^        var here = number;$/        var here = number; return self.decode(number).?.depth();/' \
    "$SRC" > "$PEN/d.rye"
note "depth_reads_the_outfit_planted" "$(cmp -s "$SRC" "$PEN/d.rye" && echo no || echo yes)" "yes"
run_pen outfit "$PEN/d.rye"
note "depth_reads_the_outfit_exit" "$([ "$PEN_EXIT" -ne 0 ] && echo refused || echo passed)" "refused"

# --- plant five: the same break, with the legs that catch it removed ----------
# The one phase that must PASS. It cuts every line between the two markers the selftest
# carries, which is the concrete legs and the call to prove_point_metric_is_a_walk, and
# leaves the broken bridge in place. What survives is a binary that prints the claim while
# the property is false -- the exact shape a proof exists to prevent.
printf "phase legs_removed\n"
awk '/POINT METRIC LEGS BEGIN/{cut=1} /POINT METRIC LEGS END/{cut=0; next} !cut' \
    "$PEN/b.rye" > "$PEN/e.rye"
note "legs_removed_cut" \
     "$(grep -c 'prove_point_metric_is_a_walk();' "$PEN/e.rye")" "0"
note "legs_removed_still_broken" \
     "$(grep -c 'const bridged = self.point_depth(a).? + self.point_depth(b).?;' "$PEN/e.rye")" "1"
run_pen legs_removed "$PEN/e.rye"
note "legs_removed_exit" "$PEN_EXIT" "0"
note "legs_removed_still_claims" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'every published distance is a road')" "1"

printf "faults=%d\n" "$faults"
printf "verdict=%s\n" "$([ "$faults" -eq 0 ] && echo proven || echo failed)"
[ "$faults" -eq 0 ]
