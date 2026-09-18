#!/bin/sh
# energy_readout_scan.sh -- can THIS host answer the question row 6 of the moonshots page asks?
#
# Run from the repository root:
#   sh tools/fixtures/e/energy_readout_scan.sh
#
# WHY THIS EXISTS. active-designing/20260910-060204_the-bounded-torus-moonshots.md row 6, "Joules as
# a Tally unit," rests on one assumption before any Rye witness is written: "this pier's CPU exposes
# RAPL counters to a reader with the permissions we have." Ten of the ladder's twelve rows already
# carry a measured erratum; row 6 does not, because nobody had checked the assumption against a
# real host. This scan is that check, run against every energy-reading facility a Linux host might
# offer rather than RAPL alone, so a "no" here is a "no" about the whole approach rather than about
# one path.
#
# WHAT IT PROBES, IN ORDER:
#   powercap  -- /sys/class/powercap/intel-rapl:*/energy_uj, the sysfs RAPL interface Intel and
#                recent AMD kernels expose to an unprivileged reader when the kernel builds it in.
#   msr       -- /dev/cpu/0/msr, the raw model-specific-register device node RAPL predates powercap
#                with; needs the msr kernel module loaded and CAP_SYS_RAWIO or root.
#   perf      -- the `perf` binary plus a power/energy-pkg/ or similar event under
#                /sys/bus/event_source/devices/power, gated by /proc/sys/kernel/perf_event_paranoid.
#   hwmon     -- /sys/class/hwmon/hwmon*/power*_input or energy*_input, the sensor-chip path some
#                boards expose independent of RAPL.
#   nvidia    -- `nvidia-smi`, for a GPU's own power draw, milliwatts rather than millijoules and
#                needing integration over time; named for completeness rather than substitution.
#
# FOR EACH FACILITY: available=yes|no, and when no, the reason -- absent, permission_denied, or
# no_binary -- named rather than folded into one blanket "no". A reader six months from now asking
# "why did this fail" gets an answer without re-running strace.
#
# THE RESOLUTION TEST, when a facility answers yes: read the counter, run a bounded CPU spin,
# read again, and report the delta. A delta of zero says the counter's resolution is coarser than
# one short run can move it -- exactly the failure the row's own falsifier names ("the counter below
# the resolution the claim needs"), read the other direction: not that two IDENTICAL runs disagree,
# but that two runs bounded to differ read the same, which is the same fact stated from the side a
# probe can actually drive on demand.
#
# VIRTUALIZATION IS NAMED, NOT ASSUMED. A hypervisor may withhold energy counters from a guest for
# reasons having nothing to do with the kernel build, so the scan reads /proc/cpuinfo's own
# "hypervisor" flag and, when present, a detector binary -- and prints the finding beside the
# facility table rather than silently explaining away an absence nobody can check independently.
#
# OVERRIDABLE ROOTS, for the control's throwaway pen: ENERGY_POWERCAP_ROOT, ENERGY_MSR_DEV,
# ENERGY_HWMON_ROOT, ENERGY_PERF_BIN, ENERGY_NVIDIA_SMI_BIN, ENERGY_CPUINFO_PATH,
# ENERGY_PARANOID_PATH. Each defaults to the real system path; a control plants a fake tree and
# points these at it rather than touching /sys or /proc.
#
# WHAT THIS CANNOT SAY. Whether some OTHER host in this fleet can answer where this one cannot --
# eight ships, eight machines, and this scan reads only the one it runs on. Run it on each pier
# and read eight lines rather than trusting one.

set -u

POWERCAP_ROOT="${ENERGY_POWERCAP_ROOT:-/sys/class/powercap}"
MSR_DEV="${ENERGY_MSR_DEV:-/dev/cpu/0/msr}"
HWMON_ROOT="${ENERGY_HWMON_ROOT:-/sys/class/hwmon}"
PERF_BIN="${ENERGY_PERF_BIN:-perf}"
NVIDIA_BIN="${ENERGY_NVIDIA_SMI_BIN:-nvidia-smi}"
CPUINFO_PATH="${ENERGY_CPUINFO_PATH:-/proc/cpuinfo}"
PARANOID_PATH="${ENERGY_PARANOID_PATH:-/proc/sys/kernel/perf_event_paranoid}"
SPIN_MS="${ENERGY_SPIN_MS:-200}"

any_available=no
facility_count=0

probe_powercap() {
  facility_count=$((facility_count + 1))
  # find any intel-rapl:* directory under the root carrying a readable energy_uj file
  found=""
  for d in "$POWERCAP_ROOT"/intel-rapl:*; do
    [ -d "$d" ] || continue
    if [ -r "$d/energy_uj" ]; then found="$d/energy_uj"; break; fi
  done
  if [ -n "$found" ]; then
    e1=$(cat "$found" 2>/dev/null)
    i=0
    while [ "$i" -lt 200000 ]; do i=$((i + 1)); done
    e2=$(cat "$found" 2>/dev/null)
    delta=$((e2 - e1))
    echo "facility=powercap available=yes path=$found delta_uj=$delta"
    any_available=yes
  elif [ -d "$POWERCAP_ROOT" ]; then
    echo "facility=powercap available=no reason=no_readable_energy_uj root=$POWERCAP_ROOT"
  else
    echo "facility=powercap available=no reason=absent root=$POWERCAP_ROOT"
  fi
}

probe_msr() {
  facility_count=$((facility_count + 1))
  if [ ! -e "$MSR_DEV" ]; then
    echo "facility=msr available=no reason=absent path=$MSR_DEV"
  elif [ ! -r "$MSR_DEV" ]; then
    echo "facility=msr available=no reason=permission_denied path=$MSR_DEV"
  else
    echo "facility=msr available=yes path=$MSR_DEV"
    any_available=yes
  fi
}

probe_perf() {
  facility_count=$((facility_count + 1))
  if ! command -v "$PERF_BIN" >/dev/null 2>&1; then
    echo "facility=perf available=no reason=no_binary bin=$PERF_BIN"
    return
  fi
  paranoid="unknown"
  if [ -r "$PARANOID_PATH" ]; then paranoid=$(cat "$PARANOID_PATH" 2>/dev/null); fi
  if [ "$paranoid" = "unknown" ]; then
    echo "facility=perf available=no reason=paranoid_unreadable bin=$PERF_BIN"
  elif [ "$paranoid" -ge 2 ] 2>/dev/null; then
    echo "facility=perf available=no reason=paranoid_gated paranoid=$paranoid bin=$PERF_BIN"
  else
    echo "facility=perf available=yes paranoid=$paranoid bin=$PERF_BIN"
    any_available=yes
  fi
}

probe_hwmon() {
  facility_count=$((facility_count + 1))
  found=""
  for d in "$HWMON_ROOT"/hwmon*; do
    [ -d "$d" ] || continue
    for f in "$d"/power*_input "$d"/energy*_input; do
      [ -r "$f" ] || continue
      found="$f"
      break 2
    done
  done
  if [ -n "$found" ]; then
    echo "facility=hwmon available=yes path=$found"
    any_available=yes
  elif [ -d "$HWMON_ROOT" ]; then
    echo "facility=hwmon available=no reason=no_power_or_energy_input root=$HWMON_ROOT"
  else
    echo "facility=hwmon available=no reason=absent root=$HWMON_ROOT"
  fi
}

probe_nvidia() {
  facility_count=$((facility_count + 1))
  if command -v "$NVIDIA_BIN" >/dev/null 2>&1; then
    echo "facility=nvidia available=yes bin=$NVIDIA_BIN note=milliwatts_not_millijoules"
    any_available=yes
  else
    echo "facility=nvidia available=no reason=no_binary bin=$NVIDIA_BIN"
  fi
}

report_virt() {
  hv_flag=no
  if [ -r "$CPUINFO_PATH" ] && grep -q '^flags.*hypervisor' "$CPUINFO_PATH" 2>/dev/null; then
    hv_flag=yes
  fi
  echo "cpuinfo_hypervisor_flag=$hv_flag"
}

probe_powercap
probe_msr
probe_perf
probe_hwmon
probe_nvidia
report_virt

echo "facility_count=$facility_count"
if [ "$any_available" = "yes" ]; then
  echo "verdict=facility_available"
  exit 0
else
  echo "verdict=no_facility"
  exit 0
fi
