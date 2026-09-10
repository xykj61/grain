#!/bin/sh
# tools/fixtures/g/guard_cpu_census.sh -- where does a standing guard spend its CPU?
#
# WHAT THIS IS. A research probe, reported and never gated, and rostered nowhere. It prices the
# guards rather than proving anything about the tree. Sibling of
# `tools/fixtures/g/guard_process_census.sh`, which counts the programs a guard starts; this one
# asks where the CPU those programs burn actually goes.
#
# WHY IT EXISTS. The process census separated the roster into two families -- guards that pay for
# starting programs and guards that are doing arithmetic -- and it separated them with `strace`,
# which needs ptrace and roughly doubles the guard's own wall time. If the same split shows up in
# the KERNEL SHARE of a guard's CPU, then triage costs one shell wrapper instead, and every guard
# on the roster can be classified in one pass rather than sixteen at a time.
#
# WHAT IT MEASURES. The POSIX `times` builtin, whose second line is the cumulative user and system
# CPU of all reaped children. So `sys_share = sys / (user + sys)` is the fraction of a guard's CPU
# spent inside the kernel -- and forking, exec'ing, mapping and tearing down a program is kernel
# work, where an arithmetic loop is not.
#
# WHY CPU RATHER THAN WALL. CPU time is LOAD-INDEPENDENT, near enough: eight ships sailing beside
# this probe lengthen a guard's wall clock and leave its user and system seconds where they were.
# Every wall figure this tree holds was read under fleet load, which is why neither this probe nor
# its sibling offers one as a finding. `wall_ms` is printed here for scale and for nothing else.
#
# THE DECLARED LIMIT. `times` counts REAPED children, so a guard that leaves a dependent running
# past its own exit is undercounted, and CPU stolen by a busy host is charged to whoever was
# running. Neither reaches the sys/user split this probe reports, which is a ratio inside one
# guard's own accounting.
#
# USAGE
#   sh tools/fixtures/g/guard_cpu_census.sh --top 10      # the N most expensive by run card
#   sh tools/fixtures/g/guard_cpu_census.sh --every 20    # every 20th guard down the ranking
#   sh tools/fixtures/g/guard_cpu_census.sh --guard NAME  # one named guard
#
# Run from the repository root.
set -u

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "instrument=failed"; echo "detail=not_a_git_tree"; echo "verdict=misread"; exit 1
}
cd "$root" || exit 1

CARD="construction/standing-equipment-runs.kyri"
ROSTER="construction/standing-equipment.kyri"

[ -f "$CARD" ] || {
  echo "instrument=failed"
  echo "detail=no_run_card -- this pier has run no standing pass yet"
  echo "verdict=misread"; exit 1
}
[ -f "$ROSTER" ] || {
  echo "instrument=failed"; echo "detail=no_roster"; echo "verdict=misread"; exit 1
}

mode=top; arg=10
while [ $# -gt 0 ]; do
  case "$1" in
    --top)   mode=top;   arg="${2:-10}"; shift 2 ;;
    --every) mode=every; arg="${2:-20}"; shift 2 ;;
    --guard) mode=guard; arg="${2:-}";   shift 2 ;;
    *) echo "detail=unknown_flag $1"; echo "verdict=misread"; exit 1 ;;
  esac
done

case "$mode" in
  top)   names=$(awk '$1=="ran"{print $7+0, $2}' "$CARD" | sort -rn | head -"$arg" | awk '{print $2}') ;;
  every) names=$(awk '$1=="ran"{print $7+0, $2}' "$CARD" | sort -rn | awk -v s="$arg" 'NR%s==0{print $2}') ;;
  guard) names="$arg" ;;
esac

[ -n "$names" ] || { echo "detail=no_guards_selected"; echo "verdict=misread"; exit 1; }

# seconds_of MINUTESmSECONDSs -> seconds with three decimals
seconds_of() {
  echo "$1" | awk -F'[ms]' '{ printf "%.3f", $1 * 60 + $2 }'
}

sum_user=0; sum_sys=0; measured=0; unmapped=0

for g in $names; do
  p=$(awk -v g="$g" '$1=="guard" && $2==g {f=1; next} f && $1=="path" {print $2; exit}' "$ROSTER")
  if [ -z "$p" ]; then
    echo "guard=$g cpu=unmapped -- named on the run card, absent from the roster"
    unmapped=$((unmapped + 1)); continue
  fi
  card_ms=$(awk -v g="$g" '$1=="ran" && $2==g {print $7+0; exit}' "$CARD")
  [ -n "$card_ms" ] || card_ms=0
  t0=$(date +%s%3N)
  # the child's own accounting: `times` line two is cumulative reaped-child user and system CPU
  line=$(sh -c "rishi/bin/rishi run '$p' >/dev/null 2>&1; times" | tail -1)
  t1=$(date +%s%3N)
  u=$(seconds_of "$(echo "$line" | awk '{print $1}')")
  s=$(seconds_of "$(echo "$line" | awk '{print $2}')")
  share=$(awk -v u="$u" -v s="$s" 'BEGIN{ t = u + s; if (t > 0) printf "%.3f", s/t; else printf "na" }')
  echo "guard=$g path=$p card_wall_ms=$card_ms probe_wall_ms=$((t1 - t0)) user_s=$u sys_s=$s sys_share=$share"
  sum_user=$(awk -v a="$sum_user" -v b="$u" 'BEGIN{printf "%.3f", a+b}')
  sum_sys=$(awk -v a="$sum_sys" -v b="$s" 'BEGIN{printf "%.3f", a+b}')
  measured=$((measured + 1))
done

pooled=$(awk -v u="$sum_user" -v s="$sum_sys" 'BEGIN{ t = u + s; if (t > 0) printf "%.3f", s/t; else printf "na" }')
echo "measured=$measured unmapped=$unmapped user_s=$sum_user sys_s=$sum_sys pooled_sys_share=$pooled"
echo "verdict=ok"
