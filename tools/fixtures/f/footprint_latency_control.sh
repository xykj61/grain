#!/bin/sh
# tools/fixtures/f/footprint_latency_control.sh -- proving the footprint census refuses.
#
# WHY. A census proven only in the passing direction cannot be told from a bypass. This builds
# a pen, plants a wrong answer in it six ways, and asserts each is bitten BY NAME -- then
# asserts two unplanted readings pass in the same pen, so the pen itself is proven innocent of
# the refusals.
#
# THE SIX PLANTS, each breaking a different leg:
#
#   stride       -- the probe's shuffle is disabled, so the chase becomes a constant stride of
#                   one cache line. This is the plant worth having: the walk is STILL a single
#                   cycle over every node, so the probe's own cycle-length invariant passes
#                   happily -- it is only PREDICTABLE, and the hardware prefetcher hides every
#                   miss. Nothing inside the probe can catch it. Only the shape of the curve
#                   can, which is what `cliff_present` is for. Compiled and run on metal.
#   not_monotone -- a reading that gets faster as the working set grows. Memory does not do
#                   this; a probe reporting it has stopped touching the memory it names.
#   line_mismatch-- the kernel reports a 128-byte line where the probe compiled 64. Two nodes
#                   would share a line, and every miss would be understated by half.
#   short_sweep  -- a sweep that stops before twice L3, so it cannot see the boundary it
#                   reports crossing.
#   flat_l1      -- a curve with no step at the kernel's L1d. The two instruments disagree
#                   about where the first cache ends, and the census must not pick a side.
#   flat_l3      -- a curve that never leaves cache speed, monotone throughout and spanning a
#                   real ratio, so `monotone` and `cliff_present` both stay quiet and only the
#                   L3 span is left to catch it.
#
# THE TWO CLEAN LEGS. `clean_metal` runs the real probe against this host's real topology.
# `clean_synthetic` runs a hand-written good curve against a planted topology, so the pen is
# proven innocent independently of whatever machine this is.
#
# Instrument: `sh` and `awk`, POSIX-granted, plus the tree's vendored Zig toolchain for the one
# on-metal plant. The pen is a fixed name under the host temporary directory and is removed on
# exit; no `mktemp`, which is not POSIX.
#
# Read against: external-research/20260906-042838_the-table-that-fits.md
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

CENSUS="$ROOT/tools/fixtures/f/footprint_latency_census.sh"
PROBE_SRC="$ROOT/tools/fixtures/f/footprint_latency_probe.rye"
ZIG="$ROOT/vendor/zig-toolchain/zig"
RYE="$ROOT/rye/bin/rye"
[ -f "$CENSUS" ]    || { echo "control: the census is missing at $CENSUS" >&2; exit 2; }
[ -f "$PROBE_SRC" ] || { echo "control: the probe source is missing at $PROBE_SRC" >&2; exit 2; }

PEN="${TMPDIR:-/tmp}/footprint_latency_control_pen"
rm -rf "$PEN"
mkdir -p "$PEN"
trap 'rm -rf "$PEN"' EXIT INT TERM

faults=0
assertions=0

# say NAME EXPECT-SUBSTRING FILE -- one assertion, named, counted.
say() {
  assertions=$((assertions + 1))
  if grep -q -- "$2" "$3"; then
    echo "ok   $1 -- found '$2'"
  else
    echo "FAULT $1 -- expected '$2' and it is absent"
    faults=$((faults + 1))
  fi
}

# ---- a planted cache topology, so the synthetic legs do not depend on this machine ----------
plant_sysfs() {
  d="$1"; line="$2"
  rm -rf "$d"; mkdir -p "$d/index0" "$d/index2" "$d/index3"
  printf '1\n'       > "$d/index0/level";  printf 'Data\n'    > "$d/index0/type"
  printf '32K\n'     > "$d/index0/size";   printf '%s\n' "$line" > "$d/index0/coherency_line_size"
  printf '2\n'       > "$d/index2/level";  printf 'Unified\n' > "$d/index2/type"
  printf '512K\n'    > "$d/index2/size";   printf '%s\n' "$line" > "$d/index2/coherency_line_size"
  printf '3\n'       > "$d/index3/level";  printf 'Unified\n' > "$d/index3/type"
  printf '16384K\n'  > "$d/index3/size";   printf '%s\n' "$line" > "$d/index3/coherency_line_size"
}
plant_sysfs "$PEN/sysfs" 64
plant_sysfs "$PEN/sysfs_128" 128

# ---- a hand-written good curve, shaped against the planted topology -------------------------
# 1.65 ns inside L1, a step to 4.30 at 32 KiB, a ramp through L2 and L3, 156 ns in DRAM.
write_reading() {
  out="$1"
  {
    echo "probe_version 1"
    echo "line_bytes 64"
    echo "steps_per_rep 2000000"
    echo "reps 4"
    echo "max_working_set_bytes 67108864"
    shift
    for pair in "$@"; do
      k=${pair%%:*}; rest=${pair#*:}; v=${rest%%:*}; sp=${rest#*:}
      [ "$sp" = "$rest" ] && sp=3
      echo "reading kib=$k nodes=$((k * 16)) ns_hundredths=$v spread_pct=$sp"
    done
    echo "checksum 1"
    echo "probe_done"
  } > "$out"
}
GOOD="4:165 8:165 16:165 32:165 48:430 64:430 256:450 512:990 1024:1500 4096:1790 8192:3000 16384:12000 32768:14800 65536:15600"

# ---- clean_synthetic: the pen is innocent ---------------------------------------------------
write_reading "$PEN/good.txt" $GOOD
sh "$CENSUS" --from "$PEN/good.txt" --sysfs "$PEN/sysfs" > "$PEN/out_good.txt" 2>&1 || true
say clean_synthetic "verdict ok" "$PEN/out_good.txt"
say clean_synthetic_l1 "leg l1_boundary_step ok" "$PEN/out_good.txt"
say clean_synthetic_l3 "leg l3_boundary_span ok" "$PEN/out_good.txt"

# ---- plant: not_monotone --------------------------------------------------------------------
write_reading "$PEN/p_mono.txt" 4:165 8:165 16:165 32:165 48:430 64:430 256:450 512:990 1024:1500 4096:1100 8192:3000 16384:12000 32768:14800 65536:15600
sh "$CENSUS" --from "$PEN/p_mono.txt" --sysfs "$PEN/sysfs" > "$PEN/out_mono.txt" 2>&1 || true
say not_monotone "leg monotone FAULT" "$PEN/out_mono.txt"
say not_monotone_refuses "verdict refused" "$PEN/out_mono.txt"

# ---- plant: noise_forgiven -- the other side of the monotone rule ---------------------------
# The same 27% fall, at a point that declares a 157% spread between its own repetitions. The
# probe has said it cannot measure this pair to better than 157%, so the census must forgive
# the drop rather than call it a fault. Without this leg the spread-aware tolerance could be
# forgiving everything and no assertion would notice.
write_reading "$PEN/p_noise.txt" 4:165 8:165 16:165 32:165 48:430 64:430 256:450 512:990 1024:1500 4096:1100:157 8192:3000 16384:12000 32768:14800 65536:15600
sh "$CENSUS" --from "$PEN/p_noise.txt" --sysfs "$PEN/sysfs" > "$PEN/out_noise.txt" 2>&1 || true
say noise_forgiven "leg monotone ok" "$PEN/out_noise.txt"
say noise_forgiven_reported "reported noisy_readings 1" "$PEN/out_noise.txt"

# ---- plant: line_mismatch -------------------------------------------------------------------
sh "$CENSUS" --from "$PEN/good.txt" --sysfs "$PEN/sysfs_128" > "$PEN/out_line.txt" 2>&1 || true
say line_mismatch "leg line_size_bind FAULT probe=64 sys=128" "$PEN/out_line.txt"
say line_mismatch_refuses "verdict refused" "$PEN/out_line.txt"

# ---- plant: short_sweep ---------------------------------------------------------------------
write_reading "$PEN/p_short.txt" 4:165 8:165 16:165 32:165 48:430 64:430 256:450 512:990 1024:1500 4096:1790 8192:3000 16384:12000
sh "$CENSUS" --from "$PEN/p_short.txt" --sysfs "$PEN/sysfs" > "$PEN/out_short.txt" 2>&1 || true
say short_sweep "leg sweep_covers FAULT" "$PEN/out_short.txt"

# ---- plant: flat_l1 -------------------------------------------------------------------------
write_reading "$PEN/p_flatl1.txt" 4:165 8:165 16:165 32:165 48:165 64:165 256:450 512:990 1024:1500 4096:1790 8192:3000 16384:12000 32768:14800 65536:15600
sh "$CENSUS" --from "$PEN/p_flatl1.txt" --sysfs "$PEN/sysfs" > "$PEN/out_flatl1.txt" 2>&1 || true
say flat_l1 "leg l1_boundary_step FAULT" "$PEN/out_flatl1.txt"
say flat_l1_l3_still_ok "leg l3_boundary_span ok" "$PEN/out_flatl1.txt"

# ---- plant: flat_l3 -------------------------------------------------------------------------
# Monotone throughout and spanning a real ratio, so only the L3 span is left to catch it.
write_reading "$PEN/p_flatl3.txt" 4:165 8:165 16:165 32:165 48:430 64:430 256:450 512:990 1024:1500 4096:1790 8192:1800 16384:1800 32768:1800 65536:1800
sh "$CENSUS" --from "$PEN/p_flatl3.txt" --sysfs "$PEN/sysfs" > "$PEN/out_flatl3.txt" 2>&1 || true
say flat_l3 "leg l3_boundary_span FAULT" "$PEN/out_flatl3.txt"
say flat_l3_monotone_quiet "leg monotone ok" "$PEN/out_flatl3.txt"
say flat_l3_cliff_quiet "leg cliff_present ok" "$PEN/out_flatl3.txt"

# ---- plant: stride, on metal ----------------------------------------------------------------
# The one plant that needs a compiler. Disabling the shuffle leaves the identity permutation,
# which still links into ONE cycle over ALL nodes -- so the probe's own invariant is satisfied
# and only the curve's shape can tell.
if [ -x "$ZIG" ] && [ -x "$RYE" ]; then
  mkdir -p "$PEN/stride"
  # The shuffle's draw is kept and multiplied away rather than deleted: Zig refuses to compile
  # a local that nothing reads, so a plant that simply removed the draw would fail to build and
  # prove nothing -- which is exactly what the first version of this control did. The
  # replacement text carries no `&`, because in an awk substitution `&` means the whole match
  # and the first version quietly planted garbage.
  awk '{ gsub(/% \(k \+ 1\);/, "* 0 + k;"); print }' "$PROBE_SRC" > "$PEN/stride/probe.rye"
  if grep -q 'lcg_next(&state) \* 0 + k;' "$PEN/stride/probe.rye"; then
    if ( cd "$PEN/stride" && RYE_ZIG="$ZIG" "$RYE" build probe.rye -OReleaseFast --cache-dir "$PEN/stride/cache" ) >"$PEN/stride/build.log" 2>&1 && [ -x "$PEN/stride/probe" ]; then
      "$PEN/stride/probe" > "$PEN/stride/reading.txt" 2>&1 || true
      sh "$CENSUS" --from "$PEN/stride/reading.txt" --sysfs "$PEN/sysfs" > "$PEN/out_stride.txt" 2>&1 || true
      say stride_refuses "verdict refused" "$PEN/out_stride.txt"
      # The prefetcher flattens the curve; whichever shape leg names it first, the census must
      # not report a healthy hierarchy. Assert the positive claim is ABSENT rather than guessing
      # which of two legs bites on a given part.
      assertions=$((assertions + 1))
      if grep -q "verdict ok" "$PEN/out_stride.txt"; then
        echo "FAULT stride_not_ok -- a constant-stride walk was reported as a healthy curve"
        faults=$((faults + 1))
      else
        echo "ok   stride_not_ok -- a constant-stride walk is not reported as a healthy curve"
      fi
      echo "note stride span was $(awk '$1=="span_hundredths"{print $2; exit}' "$PEN/out_stride.txt")/100x against the random walk's own"
    else
      echo "FAULT stride_builds -- the planted probe did not build; see $PEN/stride/build.log"
      echo "      a plant that cannot run proves nothing, so this is a fault rather than a skip"
      assertions=$((assertions + 1)); faults=$((faults + 1)); cp -r "$PEN/stride" "${TMPDIR:-/tmp}/footprint_stride_build_failure" 2>/dev/null || true
    fi
  else
    echo "FAULT stride_plants -- the draw line was not found to plant; the probe's source has moved"
    assertions=$((assertions + 1)); faults=$((faults + 1))
  fi

  # ---- clean_metal: the real probe, this host's real topology --------------------------------
  sh "$CENSUS" > "$PEN/out_metal.txt" 2>&1 || true
  say clean_metal "verdict ok" "$PEN/out_metal.txt"
else
  echo "skip stride clean_metal -- no vendored toolchain at $ZIG"
fi

echo "assertions $assertions"
echo "faults $faults"
if [ "$faults" -eq 0 ]; then echo "verdict proven"; else echo "verdict unproven"; exit 1; fi
