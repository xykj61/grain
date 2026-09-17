#!/bin/sh
# tools/fixtures/r/read_latency_control.sh -- the latency probe, shown from both sides.
#
#   sh tools/fixtures/r/read_latency_control.sh
#
# WHY THIS EXISTS. `tools/rye/read_latency.rye` is the instrument a design page's central
# mechanism claim now rests on, so its own arithmetic has to be evidence rather than assertion.
# Three families of claim need proving, and each is proven here in the direction that could hide
# a fault:
#
#   THE REFUSALS -- a path outside this tree, a system path, and a peer ship's tree must each
#   refuse. A probe that evicted the wrong inode would charge seven other ships for one ship's
#   measurement. Every refusal is planted on a real path and required to BITE, since a refusal
#   proven only in the passing direction cannot be told from a bypass.
#
#   THE WELCOMES -- this tree's own pen must be measured, and the measurement must print every
#   field a reader downstream reads by name. A checker that refused everything would pass every
#   refusal case above and measure nothing at all.
#
#   THE DISCRIMINATOR -- the probe runs one pen with the kernel's readahead on and then off, per
#   descriptor. Its cases here are STRUCTURAL: both arms ran, both printed, and a ratio came out.
#   They are deliberately weak, and the weakness is measured rather than assumed. Planting
#   `POSIX_FADV_NORMAL` where the probe advises `RANDOM` -- a mutation that turns the second arm
#   into a copy of the first -- produced ratios of 1.000, 1.030 and 0.940 against the real
#   probe's 1.036, 1.059 and 1.006, and NO case here tells them apart. That is not a hole to
#   patch: it is the probe's own answer, which is that the effect it looks for sits under this
#   device's run-to-run noise. A case asserting a difference would be asserting noise. So the
#   finding the probe supports is an UPPER BOUND, it is stated that way in the design page, and
#   these cases guard the plumbing rather than the physics.
#
#   THE ARITHMETIC -- the orderings the readings turn on: a cold read costs more than a warm one,
#   a sequential pass over one file beats the same bytes split across files, and the per-file cost
#   falls toward a floor as files shrink rather than falling to nothing. Each is a relation
#   between two numbers this run produces, so none of them can be satisfied by a stuck constant.
#
# READINGS: `cases=N fail=M` and a `control_verdict=` line. Exit 1 when any case fails.
set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"
BIN="$ROOT/tools/bin/read-latency"

cases=0
fail=0

check() {
  name=$1; want=$2; got=$3
  cases=$((cases + 1))
  if [ "$want" = "$got" ]; then
    echo "ok   $name ($got)"
  else
    echo "FAIL $name -- wanted $want, read $got"
    fail=$((fail + 1))
  fi
}

# A relation between two readings rather than a value, so a stuck constant fails it.
check_gt() {
  name=$1; big=$2; small=$3
  cases=$((cases + 1))
  if [ -n "$big" ] && [ -n "$small" ] && [ "$big" -gt "$small" ] 2>/dev/null; then
    echo "ok   $name ($big > $small)"
  else
    echo "FAIL $name -- wanted $big greater than $small"
    fail=$((fail + 1))
  fi
}

# Every claim line this program prints goes to stderr, as every hosted Rye program in this tree
# prints through `std.debug.print`. The redirect is what puts the readings where awk can see them;
# without it every field below comes back empty and each case fails for the wrong reason.
field() {
  awk -v want="$2" '{for (i=1;i<=NF;i++) { split($i,kv,"="); if (kv[1]==want) print kv[2] } }' <"$1" | head -1
}

# One field off one arm's row, since several arms print the same key names.
arm_field() {
  awk -v arm="$2" -v want="$3" '$1 == "arm=" arm {for (i=1;i<=NF;i++) { split($i,kv,"="); if (kv[1]==want) print kv[2] } }' <"$1" | head -1
}

[ -x "$BIN" ] || { echo "control_verdict=no_binary"; exit 1; }

pen="$ROOT/.lap/read_latency_control"
rm -rf "$pen"
mkdir -p "$pen" || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen" "$ROOT/.lap/read_latency_pen" "$ROOT/.lap/read_latency_sweep" "$ROOT/.lap/read_latency_probe"' EXIT INT TERM

# -- the refusals, each planted on a real path a typo could actually reach ----------------------
#
# The containment check lives inside the program and is exercised through its own selftest, which
# asserts each refusal by name. Running it here as one case would hide which leg bit, so the
# selftest prints one line per leg and this control reads the tally rather than the exit alone.

self_out="$pen/selftest.txt"
"$BIN" selftest >"$self_out" 2>&1
check "selftest_exit_green" 0 $?
check "selftest_legs_all_ran" 7 "$(field "$self_out" selftest_legs)"
check "selftest_none_failed" 0 "$(field "$self_out" selftest_failed)"

for leg in outside_refused sibling_refused inside_welcomed cold_exceeds_warm rounds_bound order_statistics offsets; do
  cases=$((cases + 1))
  if grep -q "^leg=$leg ok" "$self_out"; then
    echo "ok   leg_present_$leg"
  else
    echo "FAIL leg_present_$leg -- the selftest printed no passing line for it"
    fail=$((fail + 1))
  fi
done

# A bad verb and a missing one each refuse with the usage exit rather than measuring something.
"$BIN" >/dev/null 2>&1
check "no_verb_refuses" 2 $?
"$BIN" census /nix/store >/dev/null 2>&1
check "unknown_verb_refuses" 2 $?
"$BIN" measure notanumber >/dev/null 2>&1
check "unparsable_rounds_refuses" 2 $?
"$BIN" measure 0 >/dev/null 2>&1
check "zero_rounds_refuses" 3 $?
"$BIN" measure 999999 >/dev/null 2>&1
check "rounds_over_bound_refuses" 3 $?

# -- the welcomes, asserted as hard as the refusals ---------------------------------------------

meas="$pen/measure.txt"
"$BIN" measure 64 >"$meas" 2>&1
check "measure_exit_green" 0 $?
check "measure_verdict_ok" "ok" "$(field "$meas" measure_verdict)"

for arm in rand_cold rand_warm seq_cold open_read_close; do
  cases=$((cases + 1))
  if grep -q "^arm=$arm " "$meas"; then
    echo "ok   arm_present_$arm"
  else
    echo "FAIL arm_present_$arm -- the measurement printed no row for it"
    fail=$((fail + 1))
  fi
done

for key in per_file_ns per_op_ns file_over_op_milli warm_p50_ns device_share_ns seq_mb_per_s opens_mb_per_s; do
  cases=$((cases + 1))
  v=$(field "$meas" "$key")
  if [ -n "$v" ]; then
    echo "ok   key_present_$key ($v)"
  else
    echo "FAIL key_present_$key -- the measurement printed no such field"
    fail=$((fail + 1))
  fi
done

# -- the arithmetic, each case a relation rather than a value ------------------------------------

cold_p50=$(arm_field "$meas" rand_cold p50_ns)
warm_p50=$(arm_field "$meas" rand_warm p50_ns)
check_gt "cold_costs_more_than_warm" "$cold_p50" "$warm_p50"

# A cold read that cost merely a little more than a warm one would mean the eviction never
# reached the cache, and every number the design page rests on would be a page-cache reading
# wearing a device's name. Ten times is far under the ratio measured and far over noise.
cases=$((cases + 1))
if [ -n "$cold_p50" ] && [ -n "$warm_p50" ] && [ "$warm_p50" -gt 0 ] && [ "$((cold_p50 / warm_p50))" -ge 10 ]; then
  echo "ok   eviction_reached_the_device (cold/warm = $((cold_p50 / warm_p50)))"
else
  echo "FAIL eviction_reached_the_device -- cold $cold_p50 over warm $warm_p50 is under ten"
  fail=$((fail + 1))
fi

seq_mb=$(field "$meas" seq_mb_per_s)
opens_mb=$(field "$meas" opens_mb_per_s)
check_gt "one_open_beats_many_opens" "$seq_mb" "$opens_mb"

# The per-file cost exceeds one round trip. This is the design page's own mechanism stated as a
# case: if a file cost LESS than a single random read, nothing about opens would need explaining.
per_file=$(field "$meas" per_file_ns)
per_op=$(field "$meas" per_op_ns)
check_gt "a_file_costs_more_than_one_trip" "$per_file" "$per_op"

# -- the sweep, whose whole subject is that two costs can be told apart --------------------------

sw="$pen/sweep.txt"
"$BIN" sweep >"$sw" 2>&1
check "sweep_exit_green" 0 $?
check "sweep_verdict_ok" "ok" "$(field "$sw" sweep_verdict)"
check "sweep_holds_the_bytes" 67108864 "$(field "$sw" bytes_held)"

cases=$((cases + 1))
rows=$(grep -c '^sweep files=' "$sw")
if [ "$rows" = "5" ]; then
  echo "ok   sweep_rows_all_five"
else
  echo "FAIL sweep_rows_all_five -- read $rows"
  fail=$((fail + 1))
fi

# Every row carries the same byte total, which is the sweep's entire premise: if the rows differed
# in bytes, the per-file and per-byte costs could never be told apart by comparing them.
cases=$((cases + 1))
distinct=$(awk '$1 == "sweep" {for (i=1;i<=NF;i++) { split($i,kv,"="); if (kv[1]=="files") f=kv[2]; if (kv[1]=="part_bytes") p=kv[2] } print f * p }' "$sw" | sort -u | wc -l)
if [ "$distinct" = "1" ]; then
  echo "ok   sweep_rows_share_one_byte_total"
else
  echo "FAIL sweep_rows_share_one_byte_total -- read $distinct distinct totals"
  fail=$((fail + 1))
fi

# The per-file cost FALLS as files shrink and the total RISES. Both directions are asserted,
# because a per-byte-only world keeps the total flat and a per-file-only world keeps the per-file
# number flat -- and only a reading that moves the right way in both can tell them apart.
small_total=$(awk '$2 == "files=64" {for (i=1;i<=NF;i++) { split($i,kv,"="); if (kv[1]=="total_us") print kv[2] } }' "$sw")
large_total=$(awk '$2 == "files=1024" {for (i=1;i<=NF;i++) { split($i,kv,"="); if (kv[1]=="total_us") print kv[2] } }' "$sw")
check_gt "more_files_costs_more_for_the_same_bytes" "$large_total" "$small_total"

small_per=$(awk '$2 == "files=64" {for (i=1;i<=NF;i++) { split($i,kv,"="); if (kv[1]=="per_file_p50_ns") print kv[2] } }' "$sw")
large_per=$(awk '$2 == "files=1024" {for (i=1;i<=NF;i++) { split($i,kv,"="); if (kv[1]=="per_file_p50_ns") print kv[2] } }' "$sw")
check_gt "a_bigger_file_costs_more_than_a_smaller_one" "$small_per" "$large_per"

# And the floor: the per-file cost of the smallest files stays well above the warm read that would
# be all it cost if opening were free. This is the fixed cost the design page names, asserted as a
# relation rather than as the fitted constant, which belongs in the page and not in a gate.
check_gt "the_per_file_floor_stands_above_a_warm_read" "$large_per" "$warm_p50"

# -- the probe, whose subject is an alternative reading rather than a number ---------------------

pr="$pen/probe.txt"
"$BIN" probe >"$pr" 2>&1
check "probe_exit_green" 0 $?
check "probe_verdict_ok" "ok" "$(field "$pr" probe_verdict)"

for arm in readahead_on readahead_off; do
  cases=$((cases + 1))
  if grep -q "^arm=$arm " "$pr"; then
    echo "ok   probe_arm_present_$arm"
  else
    echo "FAIL probe_arm_present_$arm -- the probe printed no row for it"
    fail=$((fail + 1))
  fi
done

# Both arms produced a median. Identical to the nanosecond would mean one arm never ran at all --
# which is the only failure this case can honestly catch, for the reason the header measures.
on_p50=$(arm_field "$pr" readahead_on p50_ns)
off_p50=$(arm_field "$pr" readahead_off p50_ns)
cases=$((cases + 1))
if [ -n "$on_p50" ] && [ -n "$off_p50" ] && [ "$on_p50" != "$off_p50" ]; then
  echo "ok   probe_arms_differ ($on_p50 vs $off_p50)"
else
  echo "FAIL probe_arms_differ -- both arms read $on_p50, so the advice reached nothing"
  fail=$((fail + 1))
fi

# And the ratio is printed, since it is what a reader downstream quotes. Its VALUE is a finding
# about this device and belongs in the design page rather than in a gate that another pier's
# storage would red.
cases=$((cases + 1))
ratio=$(field "$pr" off_over_on_milli)
if [ -n "$ratio" ] && [ "$ratio" -gt 0 ] 2>/dev/null; then
  echo "ok   probe_ratio_present ($ratio per mille of one)"
else
  echo "FAIL probe_ratio_present -- the probe printed no ratio"
  fail=$((fail + 1))
fi

echo "cases=$cases fail=$fail"
if [ "$fail" -gt 0 ]; then
  echo "control_verdict=failed"
  exit 1
fi
echo "control_verdict=ok"
exit 0
