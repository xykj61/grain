#!/bin/sh
# tools/fixtures/g/guard_process_census.sh -- how many processes does a standing guard create?
#
# WHAT THIS IS. A research probe, reported and never gated, and rostered nowhere. It prices the
# guards rather than proving anything about the tree, which is why it has no witness and no
# ceiling. Sibling of `tools/fixtures/p/pier_work_census_scan.sh`, which reads the machine; this
# one reads one guard at a time.
#
# WHY IT EXISTS. `external-research/20260910-072912_the-seconds-this-pier-actually-spends.md`
# priced this pier's assurance bill and projected that a resident reader -- one process that
# opens the tree once and answers many questions -- would remove the kernel half of it. A later
# lap proved that projection on ONE guard at 17.4x. The open question was whether that saving is
# the roster's shape or one guard's, and answering it needs a per-guard process count.
#
# WHAT IT MEASURES, and what it declines to. `execve` calls, counted exactly by
# `strace -f --seccomp-bpf -c -e trace=execve` over the witness the roster actually runs. A
# process count is LOAD-INDEPENDENT: it is the same number on a quiet pier and a saturated one,
# which is exactly what recommends it, since every wall figure this tree holds was read under an
# eight-ship load. Wall time is reported from two sources and neither is offered as a clean
# overhead reading -- `card_wall_ms` comes from the pier's own run card, `traced_wall_ms` from
# this run under ptrace, and the two were taken minutes apart under different load.
#
# WHY execve RATHER THAN clone. `execve` counts programs started. `clone` counts forks and
# threads alike, so a shell's own subshell and a runtime's worker thread both raise it, and the
# question here is how many PROGRAMS a guard runs.
#
# THE DECLARED LIMIT. `--seccomp-bpf` traps only the filtered syscall, yet ptrace still costs
# real time: a process-bound guard runs roughly twice as long traced. So this probe is for
# measuring counts, never for measuring seconds.
#
# USAGE
#   sh tools/fixtures/g/guard_process_census.sh --top 10      # the N most expensive by run card
#   sh tools/fixtures/g/guard_process_census.sh --every 20    # every 20th guard down the ranking
#   sh tools/fixtures/g/guard_process_census.sh --guard NAME  # one named guard
#
# Run from the repository root.
set -u

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "instrument=failed"; echo "detail=not_a_git_tree"; echo "verdict=misread"; exit 1
}
cd "$root" || exit 1

CARD="construction/standing-equipment-runs.kyri"
ROSTER="construction/standing-equipment.kyri"
PEN="${TMPDIR:-.lap}"

command -v strace >/dev/null 2>&1 || {
  echo "instrument=failed"; echo "detail=no_strace"; echo "verdict=misread"; exit 1
}
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

mkdir -p "$PEN" 2>/dev/null || true
sum_wall=0; sum_exec=0; measured=0; unmapped=0

for g in $names; do
  p=$(awk -v g="$g" '$1=="guard" && $2==g {f=1; next} f && $1=="path" {print $2; exit}' "$ROSTER")
  if [ -z "$p" ]; then
    echo "guard=$g execve=unmapped -- named on the run card, absent from the roster"
    unmapped=$((unmapped + 1)); continue
  fi
  card_ms=$(awk -v g="$g" '$1=="ran" && $2==g {print $7+0; exit}' "$CARD")
  [ -n "$card_ms" ] || card_ms=0
  t0=$(date +%s%3N)
  strace -f --seccomp-bpf -c -e trace=execve rishi/bin/rishi run "$p" \
    >/dev/null 2>"$PEN/gpc-$g.txt"
  t1=$(date +%s%3N)
  n=$(awk '$NF=="execve"{print $4}' "$PEN/gpc-$g.txt" | tail -1)
  [ -n "$n" ] || n=0
  traced=$((t1 - t0))
  rate=$(awk -v w="$card_ms" -v e="$n" 'BEGIN{ if (e > 0) printf "%.2f", w/e; else printf "na" }')
  echo "guard=$g path=$p card_wall_ms=$card_ms traced_wall_ms=$traced execve=$n ms_per_process=$rate"
  sum_wall=$((sum_wall + card_ms)); sum_exec=$((sum_exec + n)); measured=$((measured + 1))
done

pooled=$(awk -v w="$sum_wall" -v e="$sum_exec" 'BEGIN{ if (e > 0) printf "%.2f", w/e; else printf "na" }')
echo "measured=$measured unmapped=$unmapped card_wall_ms=$sum_wall execve=$sum_exec pooled_ms_per_process=$pooled"
echo "verdict=ok"
