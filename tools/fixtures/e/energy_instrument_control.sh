#!/bin/sh
# tools/fixtures/e/energy_instrument_control.sh -- prove the energy-instrument reading by doing, on
# planted hosts.
#
# WHY. A guard that cannot red guards nothing (REDS row 59). This pier exposes no joule at all, so
# the probe's honest `tier=cpu_seconds` on real hardware is indistinguishable from a probe stuck at
# `none` -- unless the same code is shown saying `joules` on a host that has one. This control builds
# sysfs-shaped pens in a temporary directory, points the scan at each with `--root`, and checks that
# every tier is reached and every refusal bites.
#
# The case worth naming twice is `powercap_locked`: a counter that EXISTS and refuses to be read.
# Since PLATYPUS (CVE-2020-8694, 2020) that is the normal state of intel-rapl for an unprivileged
# process, so a probe that stats the path would report a joule nobody can have.
#
# USAGE
#   sh tools/fixtures/e/energy_instrument_control.sh
#
# Driven by tools/e/energy_instrument_witness.rish. Nothing here touches the tree it runs from.

set -u

scan=$(pwd)/tools/fixtures/e/energy_instrument_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'chmod -R u+rwX "$pen" 2>/dev/null; rm -rf "$pen"' EXIT INT TERM

# A pen host with nothing in it beyond the directories a Linux sysfs always carries.
bare() {
  d=$pen/$1
  mkdir -p "$d/sys/class/powercap" "$d/sys/class/hwmon" "$d/sys/class/power_supply" \
           "$d/sys/bus/event_source/devices" "$d/proc/sys/kernel"
  echo 2 > "$d/proc/sys/kernel/perf_event_paranoid"
  echo "$d"
}

# The two hardware events a cycles-per-operation reading is built from.
plant_counters() {
  mkdir -p "$1/sys/bus/event_source/devices/cpu/events"
  echo 'event=0x3c' > "$1/sys/bus/event_source/devices/cpu/events/cpu-cycles"
  echo 'event=0xc0' > "$1/sys/bus/event_source/devices/cpu/events/instructions"
}

read_of() { sh "$scan" --root "$1" 2>/dev/null; }
has() { echo "$1" | grep -q "$2"; }

# 1. A host with no counter of any kind falls to CPU seconds, and says so rather than refusing.
d=$(bare nothing)
out=$(read_of "$d")
has "$out" 'tier=cpu_seconds' && echo "bare_falls_to_cpu_seconds=yes" || echo "bare_falls_to_cpu_seconds=no"
has "$out" 'joule_source=none' && echo "bare_names_no_source=yes" || echo "bare_names_no_source=no"
has "$out" 'verdict=ok' && echo "bare_free=yes" || echo "bare_free=no"

# 2. A readable powercap domain IS a joule, and the probe must say so. Without this leg every
#    `none` on this pier would be unfalsifiable.
d=$(bare powercap); mkdir -p "$d/sys/class/powercap/pen-rapl:0"
echo 918273645 > "$d/sys/class/powercap/pen-rapl:0/energy_uj"
out=$(read_of "$d")
has "$out" 'tier=joules' && echo "powercap_reads_joules=yes" || echo "powercap_reads_joules=no"
has "$out" 'joule_source=powercap' && echo "powercap_named=yes" || echo "powercap_named=no"
has "$out" 'powercap_readable=1' && echo "powercap_counted=yes" || echo "powercap_counted=no"

# 3. The PLATYPUS case: the counter exists and refuses. Existence is not readability.
d=$(bare locked); mkdir -p "$d/sys/class/powercap/pen-rapl:0"
echo 918273645 > "$d/sys/class/powercap/pen-rapl:0/energy_uj"
chmod 000 "$d/sys/class/powercap/pen-rapl:0/energy_uj"
out=$(read_of "$d")
has "$out" 'powercap_domains=1' && echo "locked_domain_seen=yes" || echo "locked_domain_seen=no"
has "$out" 'powercap_readable=0' && echo "locked_not_readable=yes" || echo "locked_not_readable=no"
has "$out" 'joule_present_unreadable=1' && echo "locked_counted=yes" || echo "locked_counted=no"
has "$out" 'tier=cpu_seconds' && echo "locked_claims_no_joule=yes" || echo "locked_claims_no_joule=no"

# 4. A counter that opens and answers with words rather than digits is not a reading either.
d=$(bare words); mkdir -p "$d/sys/class/powercap/pen-rapl:0"
echo 'n/a' > "$d/sys/class/powercap/pen-rapl:0/energy_uj"
out=$(read_of "$d")
has "$out" 'joule_source=none' && echo "nondigits_refused=yes" || echo "nondigits_refused=no"

# 5. The other two joule families, each reached on its own.
d=$(bare hwmon); mkdir -p "$d/sys/class/hwmon/hwmon0"
echo 4242 > "$d/sys/class/hwmon/hwmon0/energy1_input"
has "$(read_of "$d")" 'joule_source=hwmon' && echo "hwmon_named=yes" || echo "hwmon_named=no"

d=$(bare supply); mkdir -p "$d/sys/class/power_supply/BAT0"
echo 7100000 > "$d/sys/class/power_supply/BAT0/power_now"
has "$(read_of "$d")" 'joule_source=supply' && echo "supply_named=yes" || echo "supply_named=no"

# 6. Hardware counters without a joule are the middle rung, and both events are required.
d=$(bare counters); plant_counters "$d"
out=$(read_of "$d")
has "$out" 'tier=counters' && echo "counters_rung=yes" || echo "counters_rung=no"
has "$out" 'hw_instructions=yes' && echo "counters_named=yes" || echo "counters_named=no"

d=$(bare halfcounters); mkdir -p "$d/sys/bus/event_source/devices/cpu/events"
echo 'event=0x3c' > "$d/sys/bus/event_source/devices/cpu/events/cpu-cycles"
has "$(read_of "$d")" 'tier=cpu_seconds' && echo "cycles_alone_insufficient=yes" || echo "cycles_alone_insufficient=no"

# 7. A kernel that forbids perf_event_open takes the counters rung away, events and all.
d=$(bare locked_perf); plant_counters "$d"
echo 3 > "$d/proc/sys/kernel/perf_event_paranoid"
has "$(read_of "$d")" 'tier=cpu_seconds' && echo "paranoid3_drops_rung=yes" || echo "paranoid3_drops_rung=no"

# 8. The ladder is ordered: a host with both reports the better instrument.
d=$(bare both); plant_counters "$d"; mkdir -p "$d/sys/class/powercap/pen-rapl:0"
echo 5 > "$d/sys/class/powercap/pen-rapl:0/energy_uj"
has "$(read_of "$d")" 'tier=joules' && echo "joules_outrank_counters=yes" || echo "joules_outrank_counters=no"

# 9. The scan refuses what it cannot read, out loud, rather than reporting an empty host.
out=$(sh "$scan" --root "$pen/no-such-host" 2>/dev/null); code=$?
[ "$code" -eq 2 ] && has "$out" 'verdict=root_missing' && echo "absent_root_refused=yes" || echo "absent_root_refused=no"

sh "$scan" --weather >/dev/null 2>&1; code=$?
[ "$code" -eq 2 ] && echo "unknown_argument_refused=yes" || echo "unknown_argument_refused=no"

echo "control_verdict=ok"
