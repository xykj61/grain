#!/bin/sh
# tools/fixtures/e/energy_instrument_scan.sh -- which energy instrument, if any, this host will
# actually let us read.
#
# WHY. This tree carries an energy argument several papers deep -- the joule bound, the wake-and-rate
# shape, the compute share of a duty-cycled device -- and not one figure in it was read from a
# counter. Every energy claim so far rests on a CPU-second proxy or on a vendor budget. The question
# that arc never asked out loud is the cheap one: does the machine we run on expose a joule at all,
# and may this user read it?
#
# The distinction this scan is built around is EXISTENCE against READABILITY. A powercap domain can
# stand in sysfs and refuse every read: since the PLATYPUS disclosure (CVE-2020-8694, 2020) Linux
# ships intel-rapl `energy_uj` at mode 0400, so an unprivileged loop finds the file and gets nothing
# from it. A scan that stats the path reports a joule the caller cannot have. So every reading here
# OPENS the counter and requires digits back.
#
# READINGS (key=value on stdout)
#   powercap_domains         energy_uj files present under /sys/class/powercap
#   powercap_readable        of those, the ones that returned digits to this user
#   hwmon_energy             hwmon energy*_input files present
#   hwmon_readable           of those, the ones that returned digits
#   supply_power             power_supply power_now files present
#   supply_readable          of those, the ones that returned digits
#   rapl_perf_events         events under the perf `power` PMU (energy-pkg and kin)
#   msr_device               yes when /dev/cpu/0/msr is present
#   hw_events                events under the perf `cpu` PMU
#   hw_cycles, hw_instructions   yes when that named event is exposed
#   perf_event_paranoid      the kernel's value, or `absent`
#   cpufreq                  yes when cpu0 exposes a cpufreq directory
#   joule_source             powercap|hwmon|supply|none -- the first family that READ
#   joule_present_unreadable count of joule counters that exist and refuse this user
#   tier                     joules | counters | cpu_seconds -- the best instrument actually available
#   verdict                  ok, or a named refusal
#
# A HOST IS NOT A FAULT. This scan gates nothing about the machine it runs on: `tier=cpu_seconds` is
# a true reading, never a red. What the witness gates is the scan's own ability to say `joules` when
# joules are there -- a guard that cannot red guards nothing, and a probe that cannot say `joules`
# proves nothing by saying `none`.
#
# USAGE
#   sh tools/fixtures/e/energy_instrument_scan.sh [--root DIR]
#
# `--root` points every path at a pen instead of `/`, which is how the control plants hosts that
# this pier does not have. Run from the repository root.

set -u

root=""
while [ $# -gt 0 ]; do
  case $1 in
    --root) [ $# -ge 2 ] || { echo "energy_instrument: --root wants a directory" >&2; exit 2; }
            root=$2; shift 2 ;;
    --root=*) root=${1#--root=}; shift ;;
    -h|--help) sed -n '2,40p' "$0"; exit 0 ;;
    *) echo "energy_instrument: unknown argument $1" >&2; exit 2 ;;
  esac
done

if [ -n "$root" ] && [ ! -d "$root" ]; then
  echo "verdict=root_missing"
  exit 2
fi

# Read a counter for real: the file must open AND answer with digits. A path that exists and
# refuses is exactly the case this scan exists to tell apart.
reads_digits() {
  v=$(cat "$1" 2>/dev/null) || return 1
  case "$v" in
    ''|*[!0-9]*) return 1 ;;
    *) return 0 ;;
  esac
}

count_family() {
  # $1 glob pattern -- prints "present readable"
  present=0
  readable=0
  for f in $1; do
    [ -f "$f" ] || continue
    present=$((present + 1))
    if reads_digits "$f"; then readable=$((readable + 1)); fi
  done
  echo "$present $readable"
}

echo "energy-instrument-probe"
echo "root=${root:-/}"

set -- $(count_family "$root/sys/class/powercap/*/energy_uj")
powercap_domains=$1; powercap_readable=$2
echo "powercap_domains=$powercap_domains"
echo "powercap_readable=$powercap_readable"

set -- $(count_family "$root/sys/class/hwmon/*/energy*_input")
hwmon_energy=$1; hwmon_readable=$2
echo "hwmon_energy=$hwmon_energy"
echo "hwmon_readable=$hwmon_readable"

set -- $(count_family "$root/sys/class/power_supply/*/power_now")
supply_power=$1; supply_readable=$2
echo "supply_power=$supply_power"
echo "supply_readable=$supply_readable"

rapl_perf_events=0
for f in "$root"/sys/bus/event_source/devices/power/events/*; do
  [ -e "$f" ] || continue
  rapl_perf_events=$((rapl_perf_events + 1))
done
echo "rapl_perf_events=$rapl_perf_events"

if [ -e "$root/dev/cpu/0/msr" ]; then echo "msr_device=yes"; else echo "msr_device=no"; fi

hw_events=0
hw_cycles=no
hw_instructions=no
for f in "$root"/sys/bus/event_source/devices/cpu/events/*; do
  [ -e "$f" ] || continue
  hw_events=$((hw_events + 1))
  case ${f##*/} in
    cpu-cycles|cycles) hw_cycles=yes ;;
    instructions) hw_instructions=yes ;;
  esac
done
echo "hw_events=$hw_events"
echo "hw_cycles=$hw_cycles"
echo "hw_instructions=$hw_instructions"

paranoid=absent
if [ -r "$root/proc/sys/kernel/perf_event_paranoid" ]; then
  paranoid=$(cat "$root/proc/sys/kernel/perf_event_paranoid" 2>/dev/null || echo absent)
fi
echo "perf_event_paranoid=$paranoid"

if [ -d "$root/sys/devices/system/cpu/cpu0/cpufreq" ]; then echo "cpufreq=yes"; else echo "cpufreq=no"; fi

joule_source=none
if [ "$powercap_readable" -gt 0 ]; then joule_source=powercap
elif [ "$hwmon_readable" -gt 0 ]; then joule_source=hwmon
elif [ "$supply_readable" -gt 0 ]; then joule_source=supply
fi
echo "joule_source=$joule_source"

unreadable=$(( (powercap_domains - powercap_readable) + (hwmon_energy - hwmon_readable) + (supply_power - supply_readable) ))
echo "joule_present_unreadable=$unreadable"

# The ladder. A tier is claimed only from a reading that actually returned, so `joules` means a
# counter answered rather than a path existed. Counters need the two events a cycle-per-operation
# reading is built from, and a paranoid setting that lets a process measure itself: 2 permits
# per-process user-space counting, and 3 forbids perf_event_open outright.
tier=cpu_seconds
if [ "$joule_source" != none ]; then
  tier=joules
elif [ "$hw_cycles" = yes ] && [ "$hw_instructions" = yes ]; then
  case "$paranoid" in
    absent|3|[4-9]*) : ;;
    *) tier=counters ;;
  esac
fi
echo "tier=$tier"
echo "verdict=ok"
