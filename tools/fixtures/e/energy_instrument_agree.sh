#!/bin/sh
# tools/fixtures/e/energy_instrument_agree.sh -- sysfs declares an instrument; an open proves one.
#
# WHY. tools/fixtures/e/energy_instrument_scan.sh reads sysfs and reports the best instrument this
# host DECLARES. A declaration is not a reading: a kernel can expose `instructions` under the cpu
# PMU and still refuse perf_event_open, and a guest can pass the event names through without passing
# the counters. So this fixture asks the second question -- when the scan says `counters`, does a
# process actually get a count back?
#
# The two readings must agree, and a disagreement is a genuine fault rather than a host fact: it
# means the tree would believe a tier it cannot reach.
#
# READINGS
#   sysfs_tier    what tools/fixtures/e/energy_instrument_scan.sh reports for this host
#   probe_tier    what tools/rye/perf_self_count.rye got back from the kernel
#   instructions  the count the probe read, when it read one
#   agree         yes when the two readings name the same tier for the counters rung
#   verdict       ok, or a named refusal
#
# USAGE
#   sh tools/fixtures/e/energy_instrument_agree.sh
#
# Driven by tools/e/energy_instrument_witness.rish. Run from the repository root.

set -u

scan=tools/fixtures/e/energy_instrument_scan.sh
probe=tools/rye/perf_self_count.rye
zig=vendor/zig-toolchain/zig

[ -f "$scan" ] || { echo "verdict=scan_missing"; exit 1; }
[ -f "$probe" ] || { echo "verdict=probe_missing"; exit 1; }

sysfs_tier=$(sh "$scan" | sed -n 's/^tier=//p')
echo "sysfs_tier=${sysfs_tier:-unread}"

if [ ! -x "$zig" ]; then
  # The toolchain is a precondition rather than a reading: a clone without it cannot compile the
  # probe, and that is an environment fact. Say so plainly and leave the gate alone.
  echo "probe_tier=toolchain_absent"
  echo "agree=untested"
  echo "verdict=ok"
  exit 0
fi

out=$(RYE_ZIG="$zig" rye/bin/rye run "$probe" 2>&1)
probe_tier=$(echo "$out" | sed -n 's/.*tier=\([a-z_]*\).*/\1/p' | head -1)
instructions=$(echo "$out" | sed -n 's/.*instructions=\([0-9]*\).*/\1/p' | head -1)
echo "probe_tier=${probe_tier:-unread}"
echo "instructions=${instructions:-0}"

if [ "$sysfs_tier" = counters ]; then
  if [ "$probe_tier" = counters ] && [ "${instructions:-0}" -gt 0 ]; then
    echo "agree=yes"
    echo "verdict=ok"
  else
    echo "agree=no"
    echo "verdict=declared_not_countable"
    exit 1
  fi
else
  # A host at another rung makes no claim about perf_event_open, so the probe's word is recorded
  # and nothing is gated.
  echo "agree=untested"
  echo "verdict=ok"
fi
