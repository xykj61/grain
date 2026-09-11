#!/bin/sh
# tools/fixtures/r/retired_count_control.sh -- the counter gate, shown from both sides.
#
#   sh tools/fixtures/r/retired_count_control.sh
#
# WHY THIS EXISTS. `tools/rye/retired_count.rye` claims that retired instructions is a unit this
# pier can carry, and it says so by holding a spread under a ceiling and by watching the count
# follow a doubled workload. A gate proven only in the passing direction cannot be told from a
# bypass, so each leg is mutated here in a throwaway pen and required to BITE.
#
# The unmutated copy is built and run in the same pen and required to walk free, because a control
# that only plants refusals proves a program that refuses everything just as well as a correct one.
#
# READINGS: `cases=N fail=M` and a `control_verdict=` line. Exit 1 when any case fails.
set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"
ZIG="$ROOT/vendor/zig-toolchain/zig"
SRC="$ROOT/tools/rye/retired_count.rye"

pen=$(mktemp -d) || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

cases=0
fail=0

# Build one .rye in the pen and run its selftest. Prints "exit=<code>" then the output.
build_and_run() {
  src=$1; name=$2
  if ! env RYE_ZIG="$ZIG" "$ROOT/rye/bin/rye" build "$src" -femit-bin="$pen/$name" >"$pen/$name.build" 2>&1; then
    echo "BUILD_REFUSED"
    return 0
  fi
  out=$("$pen/$name" selftest 2>&1)
  code=$?
  echo "exit=$code"
  echo "$out"
}

check() {
  label=$1; want=$2; got=$3
  cases=$((cases + 1))
  if [ "$want" = "$got" ]; then
    echo "case $label ok ($got)"
  else
    echo "case $label FAIL (wanted $want, got $got)"
    fail=$((fail + 1))
  fi
}

# --- the welcome, proven as hard as the refusals ---------------------------------------------
cp "$SRC" "$pen/clean.rye"
clean=$(build_and_run "$pen/clean.rye" clean)
check clean_exit_zero yes "$(echo "$clean" | grep -q '^exit=0' && echo yes || echo no)"
check clean_reaches_green yes "$(echo "$clean" | grep -q 'GREEN: retired-count' && echo yes || echo no)"
# The two branches are exclusive, and which one this host takes is a fact about the host rather
# than a fault: a machine with no readable counter says `unavailable` and still reaches GREEN.
avail=$(echo "$clean" | grep -c '^counter=available')
unavail=$(echo "$clean" | grep -c '^counter=unavailable')
check clean_names_one_branch 1 $((avail + unavail))
echo "host_branch=$([ "$avail" = 1 ] && echo available || echo unavailable)"

# On a host that DOES read a counter, the three measured legs must all have been printed. A run
# that opened a counter and then proved nothing with it is the shape a skipped leg hides.
if [ "$avail" = 1 ]; then
  check clean_prints_spread yes "$(echo "$clean" | grep -q 'instructions_spread_ppm=' && echo yes || echo no)"
  check clean_holds_ceiling yes "$(echo "$clean" | grep -q 'instruction spread holds under' && echo yes || echo no)"
  check clean_doubles yes "$(echo "$clean" | grep -q 'doubling the workload doubled the count' && echo yes || echo no)"
fi

if [ "$avail" != 1 ]; then
  # A host with no counter cannot prove the gates that read one. Say so by name rather than
  # reporting a pass nobody measured.
  echo "detail: this host reads no hardware counter, so the two mutation cases are unrunnable here"
  echo "cases=$cases fail=$fail"
  echo "control_verdict=host_has_no_counter"
  exit 0
fi

# --- mutation 1: the spread ceiling drops to zero, and the gate must bite ---------------------
sed 's/^pub const instruction_spread_ceiling_ppm: u64 = 1000;/pub const instruction_spread_ceiling_ppm: u64 = 0;/' \
  "$SRC" > "$pen/tight.rye"
check tight_is_mutated yes "$(cmp -s "$SRC" "$pen/tight.rye" && echo no || echo yes)"
tight=$(build_and_run "$pen/tight.rye" tight)
check tight_exits_one yes "$(echo "$tight" | grep -q '^exit=1' && echo yes || echo no)"
check tight_names_the_spread yes "$(echo "$tight" | grep -q 'RED: retired-count -- instruction spread' && echo yes || echo no)"

# --- mutation 2: the workload ignores its scale, and the doubling leg must bite ---------------
# A counter that held a tight spread while ignoring the work would be a constant wearing a unit's
# clothes. This is the leg that tells the two apart.
sed 's|const total: u64 = @as(u64, workload_iterations) \* @as(u64, scale);|const total: u64 = @as(u64, workload_iterations);|' \
  "$SRC" > "$pen/flat.rye"
check flat_is_mutated yes "$(cmp -s "$SRC" "$pen/flat.rye" && echo no || echo yes)"
flat=$(build_and_run "$pen/flat.rye" flat)
check flat_exits_one yes "$(echo "$flat" | grep -q '^exit=1' && echo yes || echo no)"
check flat_names_the_doubling yes "$(echo "$flat" | grep -q 'RED: retired-count -- doubling the workload' && echo yes || echo no)"

echo "cases=$cases fail=$fail"
if [ "$fail" -gt 0 ]; then
  echo "control_verdict=case_failed"
  exit 1
fi
echo "control_verdict=ok"
