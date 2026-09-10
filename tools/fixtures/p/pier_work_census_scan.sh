#!/bin/sh
# pier_work_census_scan.sh -- what this machine's CPU seconds are actually spent on.
#
# Door: a pier running an always-on fleet has no energy meter (this host exposes
# no RAPL, no perf, no cpufreq, no hwmon), so the honest proxies are CPU seconds,
# process creations, and context switches -- all of them in /proc, all of them
# readable without privilege. This scan samples them twice and prints the delta.
#
# Reported, never gated: every number here is FREE -- it moves with whatever the
# fleet is doing this minute. Run it; do not cite a figure copied out of a page.
#
# WHAT THE COUNTERS COUNT, so a reader knows what a number is worth.
#   forks_per_s reads /proc/stat `processes`, which counts forks AND clones, so a
#   thread creation raises it exactly as a new process does. It is an upper bound.
#   The per-seat cpu_s is LUMPY rather than bounded on either side, and this was
#   measured rather than reasoned: a process gains a descendant's time in cutime
#   and cstime only at wait(), so a seat running a long pass reads near zero while
#   it runs and then receives the pass's WHOLE lifetime at the moment it is reaped,
#   including the part spent before this window opened. One 22-second reading on
#   20260910 answered fleet_share_of_busy_pct=129.5 for exactly that reason, with
#   one seat alone at 102.9. So read a seat's share over a window long enough to
#   hold whole passes, and treat a share above 100 as a reap rather than as a fault.
#   The machine-level lines above it carry no such caveat -- /proc/stat's own
#   counters are exact over any window.
#
# Reading: external-research/20260910-072912_the-seconds-this-pier-actually-spends.md
#
# Usage: sh tools/fixtures/p/pier_work_census_scan.sh [--interval SECONDS]

set -u
interval=20
while [ $# -gt 0 ]; do
  case $1 in
    --interval) interval=${2:-20}; shift 2 ;;
    *) echo "unknown_flag=$1" >&2; exit 2 ;;
  esac
done

snap() {
  date +%s.%N | awk '{ print "T " $1 }'
  awk '/^cpu /{ print "C " $2, $3, $4, $5, $6, $7, $8, $9 }
       /^ctxt /{ print "K ctxt " $2 }
       /^processes /{ print "K processes " $2 }
       /^intr /{ print "K intr " $2 }' /proc/stat
  for p in /proc/[0-9]*; do
    pid=${p#/proc/}
    [ -r "$p/stat" ] || continue
    cwd=$(readlink "$p/cwd" 2>/dev/null) || cwd=-
    [ -n "$cwd" ] || cwd=-
    awk -v pid="$pid" -v cwd="$cwd" '{
      i = index($0, ")");
      rest = substr($0, i + 2);
      n = split(rest, f, " ");
      # f[1] state, f[2] ppid; utime is stat field 14 -> f[12]
      if (n < 15) next;
      print "P", pid, f[2], f[12], f[13], f[14], f[15], cwd;
    }' "$p/stat" 2>/dev/null
  done
}

snap > "${TMPDIR:-.}/pier_a.$$" 2>/dev/null
sleep "$interval"
snap > "${TMPDIR:-.}/pier_b.$$" 2>/dev/null

awk -v home="${HOME:-/home}" '
function root(cwd,   r, n, a) {
  if (cwd == "-" || cwd == "") return "-";
  if (index(cwd, home "/") != 1) return "-";
  r = substr(cwd, length(home) + 2);
  n = split(r, a, "/");
  return a[1];
}
FNR == NR {
  if ($1 == "T") { ta = $2 }
  else if ($1 == "C") { for (i = 1; i <= 8; i++) ca[i] = $(i + 1) }
  else if ($1 == "K") { ka[$2] = $3 }
  else if ($1 == "P") { au[$2] = $4; as[$2] = $5; acu[$2] = $6; acs[$2] = $7 }
  next
}
$1 == "T" { tb = $2 }
$1 == "C" { for (i = 1; i <= 8; i++) cb[i] = $(i + 1) }
$1 == "K" { kb[$2] = $3 }
$1 == "P" { pid[$2] = 1; ppid[$2] = $3; bu[$2] = $4; bs[$2] = $5; bcu[$2] = $6; bcs[$2] = $7; seat[$2] = root($8) }
END {
  dt = tb - ta;
  if (dt <= 0) { print "verdict=refused reason=no_interval"; exit 1 }
  tot = 0;
  for (i = 1; i <= 8; i++) { d[i] = cb[i] - ca[i]; tot += d[i] }
  if (tot <= 0) { print "verdict=refused reason=no_ticks"; exit 1 }
  busy = tot - d[4] - d[5];
  ncpu = 0;
  while ((getline line < "/proc/stat") > 0) if (line ~ /^cpu[0-9]/) ncpu++;
  close("/proc/stat");
  printf "interval_s=%.2f cores=%d\n", dt, ncpu;
  printf "busy_pct=%.1f user_pct=%.1f system_pct=%.1f idle_pct=%.1f\n",
    100 * busy / tot, 100 * d[1] / tot, 100 * d[3] / tot, 100 * d[4] / tot;
  printf "kernel_share_of_busy_pct=%.1f\n", 100 * d[3] / busy;
  printf "forks_per_s=%.0f ctxt_per_s=%.0f intr_per_s=%.0f\n",
    (kb["processes"] - ka["processes"]) / dt,
    (kb["ctxt"] - ka["ctxt"]) / dt,
    (kb["intr"] - ka["intr"]) / dt;
  fleet = 0;
  for (p in pid) {
    s = seat[p];
    if (s == "-") continue;
    par = ppid[p];
    if (par in pid && seat[par] == s) continue;   # count each seat tree once, at its root
    dd = (bu[p] - au[p]) + (bs[p] - as[p]) + (bcu[p] - acu[p]) + (bcs[p] - acs[p]);
    if (dd < 0) dd = 0;
    tick[s] += dd; roots[s]++;
    fleet += dd;
  }
  n = 0;
  for (s in tick) {
    n++;
    printf "seat %s roots=%d cpu_s=%.1f share_of_busy_pct=%.1f\n",
      s, roots[s], tick[s] / 100, 100 * tick[s] / busy;
  }
  printf "seats=%d fleet_cpu_s=%.1f fleet_share_of_busy_pct=%.1f\n",
    n, fleet / 100, 100 * fleet / busy;
  if (100 * fleet / busy > 100)
    print "detail: a share above 100 means a long pass was reaped inside this window and brought its whole lifetime with it -- widen the interval";
  print "verdict=ok";
}
' "${TMPDIR:-.}/pier_a.$$" "${TMPDIR:-.}/pier_b.$$"
rc=$?
rm -f "${TMPDIR:-.}/pier_a.$$" "${TMPDIR:-.}/pier_b.$$"
exit $rc
