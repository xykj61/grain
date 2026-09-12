#!/bin/sh
# tools/fixtures/s/standing_equipment_control.sh -- prove the roster meter and its runner, both ways.
#
# WHY. A guard that cannot red guards nothing -- the grain seats that strand
# (foundations/20260826-024942_the-grain-and-the-crossing.md, REDS row 59). This builds
# throwaway rosters and run cards in a temporary directory and proves each refusal the
# scan claims, beside rosters that pass free so every gate is known to have a green side.
#
# WHAT THE SCAN PROVES.
#   A roster naming a path that is absent from disk is refused.
#   A guard record with no path line, or with two, is refused as half-written.
#   A run card naming a guard the roster never seated is refused.
#   A run card recording a red verdict is refused -- unless the red is this scan's OWN row, which
#     is its output rather than its evidence, and is reported instead (REDS %475).
#   A tier the runner does not know is refused, and counted.
#   A whole roster whose paths exist, with a card of greens, passes free -- with or without tiers.
#   A card carrying the sixth field totals it and names its slowest guard; a card written before
#     that field existed counts the row absent rather than reading it as a guard that cost nothing.
#
# WHAT THE RUNNER PROVES, which a scan reading a file cannot. A tier is only a cadence if the
# runner honors it, so the runner is driven over a planted two-row roster with a stub interpreter:
# a bare run takes the every-lap tier alone, `--tier cadence` takes exactly that tier, `--all`
# takes both, a guard named by hand runs whatever its tier, and a pass keeps the run-card lines
# of the guards it did not run. The pen is no git repository, which is its own case: the staged
# reading answers 0 rather than refusing.
#
# WHAT THE REAL REPOSITORY PROVES, which a pen outside git cannot. Two refusals live there, and
# each is shown from the side that bites and the side that passes free. The tree digest: a stub
# guard writing nothing leaves it still, one writing a file moves it (REDS %221). The unclosed lap:
# a clean cold open runs its guard, one staged path refuses the same pass under
# `run_verdict=lap_unclosed` before any guard starts, `--hot` passes that same tree, a guard asked
# for by name runs free over it, and `--hot --all` still selects every tier (REDS %223).
#
# USAGE
#   sh tools/fixtures/s/standing_equipment_control.sh
#
# Driven by tools/s/standing_equipment_witness.rish. Run from the repository root.

set -eu

scan="$(pwd)/tools/fixtures/s/standing_equipment_scan.sh"
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

# A real file for a rostered path to point at, so only the planted fault is ever the cause.
mkdir -p "$pen/tools"
echo "# a standing guard, for the control only" > "$pen/tools/real_witness.rish"

run_scan() {
  ( cd "$pen" && STANDING_ROSTER="$1" STANDING_CARD="$2" sh "$scan" 2>/dev/null ) || true
}

# --- the agreeing roster, so the gate is proven to have a green side -------------------
cat > "$pen/good.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
seated 20260822.000000
EOF
cat > "$pen/good-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran alpha 20260822.100000 green
EOF
out=$(run_scan good.kyri good-card.kyri)
case "$out" in *"verdict=ok"*) echo "agreeing_free=yes" ;; *) echo "agreeing_free=no" ;; esac
case "$out" in *"guards_never_run_here=0"*) echo "recorded_run_counted=yes" ;; *) echo "recorded_run_counted=no" ;; esac

# --- a rostered path that is absent from disk ------------------------------------------
cat > "$pen/gone.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/no_such_witness.rish
seated 20260822.000000
EOF
out=$(run_scan gone.kyri good-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "absent_path_refused=yes" ;; *) echo "absent_path_refused=no" ;; esac

# --- a guard record that never got its path --------------------------------------------
cat > "$pen/half.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
seated 20260822.000000
guard beta
path tools/real_witness.rish
seated 20260822.000000
EOF
out=$(run_scan half.kyri good-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "half_row_refused=yes" ;; *) echo "half_row_refused=no" ;; esac

# --- a guard record carrying two paths, which a runner would read only the first of ------
cat > "$pen/twopath.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
path tools/real_witness.rish
seated 20260822.000000
EOF
out=$(run_scan twopath.kyri good-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "two_path_row_refused=yes" ;; *) echo "two_path_row_refused=no" ;; esac

# --- a card naming a guard the roster never seated --------------------------------------
cat > "$pen/stray-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran alpha 20260822.100000 green
ran ghost 20260822.100000 green
EOF
out=$(run_scan good.kyri stray-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "unrostered_run_refused=yes" ;; *) echo "unrostered_run_refused=no" ;; esac

# --- a card recording a red -------------------------------------------------------------
cat > "$pen/red-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran alpha 20260822.100000 red
EOF
out=$(run_scan good.kyri red-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "recorded_red_refused=yes" ;; *) echo "recorded_red_refused=no" ;; esac

# --- this scan's OWN red is its output, never its evidence (REDS %475) ------------------
# A guard rostered under its own name writes its verdict into the card it then reads, so counting
# that row would make one red absorbing: the reading that produced it reproduces it forever. Both
# sides are shown -- the self row reported and free, and a PEER's red in the same card still
# biting, so the exemption is one name wide rather than a hole in the gate.
cat > "$pen/self.kyri" <<'EOF'
format standing-equipment-v1
guard standing_equipment
path tools/real_witness.rish
seated 20260822.000000
EOF
cat > "$pen/self-red-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran standing_equipment 20260822.100000 red
EOF
out=$(run_scan self.kyri self-red-card.kyri)
case "$out" in *"verdict=ok"*) echo "own_red_free=yes" ;; *) echo "own_red_free=no" ;; esac
case "$out" in *"runs_red_self=1"*) echo "own_red_reported=yes" ;; *) echo "own_red_reported=no" ;; esac
case "$out" in *"runs_red=0"*) echo "own_red_uncounted=yes" ;; *) echo "own_red_uncounted=no" ;; esac

cat > "$pen/self-peer.kyri" <<'EOF'
format standing-equipment-v1
guard standing_equipment
path tools/real_witness.rish
seated 20260822.000000
guard alpha
path tools/real_witness.rish
seated 20260822.000000
EOF
cat > "$pen/self-peer-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran standing_equipment 20260822.100000 red
ran alpha 20260822.100000 red
EOF
out=$(run_scan self-peer.kyri self-peer-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "peer_red_still_bites=yes" ;; *) echo "peer_red_still_bites=no" ;; esac
case "$out" in *"runs_red=1"*) echo "peer_red_counted_alone=yes" ;; *) echo "peer_red_counted_alone=no" ;; esac

# --- a roster with no card at all reads as never-run, and stays free ---------------------
out=$(run_scan good.kyri absent-card.kyri)
case "$out" in *"verdict=ok"*) echo "absent_card_free=yes" ;; *) echo "absent_card_free=no" ;; esac
case "$out" in *"guards_never_run_here=1"*) echo "never_run_counted=yes" ;; *) echo "never_run_counted=no" ;; esac

# --- a tier the runner knows passes free, and is counted on its own line -----------------
cat > "$pen/cadence.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
seated 20260822.000000
guard choir
path tools/real_witness.rish
tier cadence
seated 20260825.000000
EOF
out=$(run_scan cadence.kyri good-card.kyri)
case "$out" in *"verdict=ok"*) echo "known_tier_free=yes" ;; *) echo "known_tier_free=no" ;; esac
case "$out" in *"tier_lap=1"*) echo "lap_counted=yes" ;; *) echo "lap_counted=no" ;; esac
case "$out" in *"tier_cadence=1"*) echo "cadence_counted=yes" ;; *) echo "cadence_counted=no" ;; esac

# A cadence guard the card never names is the one that can go quiet unnoticed, so it is counted.
case "$out" in *"cadence_never_run_here=1"*) echo "cadence_never_run_counted=yes" ;; *) echo "cadence_never_run_counted=no" ;; esac

cat > "$pen/both-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran alpha 20260822.100000 green lap
ran choir 20260825.100000 green cadence
EOF
out=$(run_scan cadence.kyri both-card.kyri)
case "$out" in *"cadence_never_run_here=0"*) echo "cadence_run_lowers_count=yes" ;; *) echo "cadence_run_lowers_count=no" ;; esac
case "$out" in *"verdict=ok"*) echo "tiered_card_free=yes" ;; *) echo "tiered_card_free=no" ;; esac
# A card where every cadence guard has run must print no name at all -- a list that appears on a
# kept promise reads as a finding and stops being read.
case "$out" in *"cadence_never_run_oldest:"*) echo "kept_clock_names_none=no" ;; *) echo "kept_clock_names_none=yes" ;; esac

# --- the never-run cadence reading NAMES what it counts, oldest first --------------------
# The last reading here that printed a quantity and no name, one over from the undeclared ratchet
# REDS %592 repaired. Proven from both sides, since a naming shown only where it fires cannot be
# told from one that names every cadence guard: the two that never ran are named with their own
# seated stamps, the one that DID run is absent from the list, and the order is oldest-first --
# the opposite of the undeclared ratchet, because here the oldest promise is the actionable one.
cat > "$pen/three-cadence.kyri" <<'EOF'
format standing-equipment-v1
guard middle
path tools/real_witness.rish
tier cadence
seated 20260825.000000
guard eldest
path tools/real_witness.rish
tier cadence
seated 20260823.000000
guard ranone
path tools/real_witness.rish
tier cadence
seated 20260824.000000
EOF
cat > "$pen/ranone-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran ranone 20260826.100000 green cadence
EOF
out=$(run_scan three-cadence.kyri ranone-card.kyri)
case "$out" in *"cadence_never_run_here=2"*) echo "three_cadence_counted=yes" ;; *) echo "three_cadence_counted=no" ;; esac
case "$out" in *"cadence_never_run_oldest: eldest seated 20260823.000000"*) echo "never_run_named=yes" ;; *) echo "never_run_named=no" ;; esac
case "$out" in *"cadence_never_run_oldest: middle seated 20260825.000000"*) echo "never_run_named_second=yes" ;; *) echo "never_run_named_second=no" ;; esac
case "$out" in *"cadence_never_run_oldest: ranone"*) echo "ran_guard_unnamed=no" ;; *) echo "ran_guard_unnamed=yes" ;; esac
first_named=$(printf '%s\n' "$out" | sed -n 's/^cadence_never_run_oldest: \([^ ]*\) .*/\1/p' | head -1)
case "$first_named" in eldest) echo "never_run_oldest_first=yes" ;; *) echo "never_run_oldest_first=no" ;; esac
# The bound is named in the output rather than left to a pipe, and it holds: one shown of two.
out=$(CADENCE_NEVER_SHOW=1 run_scan three-cadence.kyri ranone-card.kyri)
named_n=$(printf '%s\n' "$out" | grep -c '^cadence_never_run_oldest: ' || true)
case "$named_n" in 1) echo "never_run_bound_holds=yes" ;; *) echo "never_run_bound_holds=no" ;; esac
case "$out" in *"cadence_never_run_shown=1"*) echo "never_run_bound_printed=yes" ;; *) echo "never_run_bound_printed=no" ;; esac
# A cadence guard carrying no `seated` line sorts first under a zero stamp rather than vanishing,
# the same clause the undeclared ratchet writes, so a row missing two fields is still named.
cat > "$pen/unseated-cadence.kyri" <<'EOF'
format standing-equipment-v1
guard dated
path tools/real_witness.rish
tier cadence
seated 20260823.000000
guard unseated
path tools/real_witness.rish
tier cadence
EOF
cat > "$pen/no-runs-card.kyri" <<'EOF'
format standing-equipment-runs-v1
EOF
out=$(run_scan unseated-cadence.kyri no-runs-card.kyri)
case "$out" in *"cadence_never_run_oldest: unseated seated 00000000.000000"*) echo "unseated_named=yes" ;; *) echo "unseated_named=no" ;; esac
first_named=$(printf '%s\n' "$out" | sed -n 's/^cadence_never_run_oldest: \([^ ]*\) .*/\1/p' | head -1)
case "$first_named" in unseated) echo "unseated_sorts_first=yes" ;; *) echo "unseated_sorts_first=no" ;; esac

# --- the undeclared-tier ratchet NAMES what it counts (REDS %592) ------------------------
# Every other named class here prints its rows; this one printed a quantity alone, and it is the
# one that reds. So two laps in a row hand-walked the roster with awk to answer "which guard is
# new" -- the same question the scan already had the answer to. Proven from both sides, since a
# naming shown only where it fires cannot be told from one that names everything: the undeclared
# guard is named with its own seated stamp, and the guard beside it that DID declare a tier is
# absent from the list while the count stays the whole population.
cat > "$pen/mixed-tier.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
seated 20260822.000000
guard silent
path tools/real_witness.rish
seated 20260901.000000
EOF
out=$(run_scan mixed-tier.kyri good-card.kyri)
case "$out" in *"guards_undeclared_tier=1"*) echo "undeclared_counted=yes" ;; *) echo "undeclared_counted=no" ;; esac
case "$out" in *"undeclared_tier_newest: silent seated 20260901.000000"*) echo "undeclared_named=yes" ;; *) echo "undeclared_named=no" ;; esac
case "$out" in *"undeclared_tier_newest: alpha"*) echo "declared_not_named=no" ;; *) echo "declared_not_named=yes" ;; esac
# A ROSTER WITH NOTHING UNDECLARED NAMES NOTHING. A list printed unconditionally would read as a
# finding on a clean roster, which is the shape a reader stops trusting first.
out=$(run_scan cadence.kyri good-card.kyri)
case "$out" in *"undeclared_tier_newest:"*) echo "clean_roster_names_none=no" ;; *) echo "clean_roster_names_none=yes" ;; esac

# --- what the pass cost, read from the card's sixth field and from its absence -----------
# A verdict without a cost left every lap to size a pass by watching a window of it (REDS %388),
# so the field is proven from both sides: a card carrying it totals, names its slowest guard and
# counts nothing absent, and a card written before the field existed says so rather than reading
# a missing measurement as a guard that cost nothing.
cat > "$pen/timed-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran alpha 20260822.100000 green lap 7
EOF
out=$(run_scan good.kyri timed-card.kyri)
case "$out" in *"runs_seconds_total=7"*) echo "seconds_totalled=yes" ;; *) echo "seconds_totalled=no" ;; esac
case "$out" in *"runs_slowest=alpha:7"*) echo "slowest_named=yes" ;; *) echo "slowest_named=no" ;; esac
case "$out" in *"runs_seconds_absent=0"*) echo "seconds_present_counted=yes" ;; *) echo "seconds_present_counted=no" ;; esac
case "$out" in *"verdict=ok"*) echo "timed_card_free=yes" ;; *) echo "timed_card_free=no" ;; esac

# A guard that finished inside a second is TIMED at 0, and must not read as one that was never
# timed at all. Both cards below total 0; only this one names a guard.
cat > "$pen/zero-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran alpha 20260822.100000 green lap 0
EOF
out=$(run_scan good.kyri zero-card.kyri)
case "$out" in *"runs_slowest=alpha:0"*) echo "zero_second_guard_named=yes" ;; *) echo "zero_second_guard_named=no" ;; esac
case "$out" in *"runs_seconds_absent=0"*) echo "zero_second_not_absent=yes" ;; *) echo "zero_second_not_absent=no" ;; esac

out=$(run_scan good.kyri good-card.kyri)
case "$out" in *"runs_seconds_absent=1"*) echo "untimed_counted_absent=yes" ;; *) echo "untimed_counted_absent=no" ;; esac
case "$out" in *"runs_seconds_total=0"*) echo "untimed_totals_zero=yes" ;; *) echo "untimed_totals_zero=no" ;; esac
case "$out" in *"runs_slowest=-:0"*) echo "untimed_names_nobody=yes" ;; *) echo "untimed_names_nobody=no" ;; esac
case "$out" in *"verdict=ok"*) echo "untimed_card_free=yes" ;; *) echo "untimed_card_free=no" ;; esac

# --- the shape between the sum and the max (REDS row `20260908.020050`) -----------------
# A sum and a maximum cannot tell a uniformly slow suite from a fast one with a short heavy tail,
# and those two trees want opposite repairs. The median and the slowest guards' share of the total
# are what separate them, so both are planted against a card whose arithmetic is checkable by hand:
# seven guards costing 100, 50, 20, 4, 3, 2, 1 -- total 180, median 4, and the five costliest
# summing 177, which is 98 percent. Every number below was computed by hand from that card first.
cat > "$pen/shape.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
seated 20260822.000000
guard beta
path tools/real_witness.rish
seated 20260822.000000
guard gamma
path tools/real_witness.rish
seated 20260822.000000
guard delta
path tools/real_witness.rish
seated 20260822.000000
guard epsilon
path tools/real_witness.rish
seated 20260822.000000
guard zeta
path tools/real_witness.rish
seated 20260822.000000
guard eta
path tools/real_witness.rish
seated 20260822.000000
EOF
cat > "$pen/shape-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran alpha 20260822.100000 green lap 100
ran beta 20260822.100000 green lap 50
ran gamma 20260822.100000 green lap 20
ran delta 20260822.100000 green lap 4
ran epsilon 20260822.100000 green lap 3
ran zeta 20260822.100000 green lap 2
ran eta 20260822.100000 green lap 1
EOF
out=$(run_scan shape.kyri shape-card.kyri)
case "$out" in *"runs_seconds_total=180"*) echo "shape_total=yes" ;; *) echo "shape_total=no" ;; esac
case "$out" in *"runs_seconds_median=4"*) echo "shape_median=yes" ;; *) echo "shape_median=no" ;; esac
case "$out" in *"runs_seconds_slowest_sum=177"*) echo "shape_slowest_sum=yes" ;; *) echo "shape_slowest_sum=no" ;; esac
case "$out" in *"runs_seconds_slowest_share_pct=98"*) echo "shape_share=yes" ;; *) echo "shape_share=no" ;; esac
case "$out" in *"runs_slowest_named: alpha 100s"*) echo "shape_named_costliest=yes" ;; *) echo "shape_named_costliest=no" ;; esac
case "$out" in *"runs_slowest_named: epsilon 3s"*) echo "shape_named_fifth=yes" ;; *) echo "shape_named_fifth=no" ;; esac
# The bound is a bound: the sixth and seventh guards are counted in the total and left unnamed.
case "$out" in *"runs_slowest_named: zeta"*) echo "shape_bound_holds=no" ;; *) echo "shape_bound_holds=yes" ;; esac
case "$out" in *"runs_slowest_shown=5"*) echo "shape_bound_named=yes" ;; *) echo "shape_bound_named=no" ;; esac
case "$out" in *"verdict=ok"*) echo "shape_card_free=yes" ;; *) echo "shape_card_free=no" ;; esac

# THE OTHER TREE, planted so the reading is proven to TELL THEM APART rather than merely to
# compute. Seven guards each costing 26 total 182 -- within two seconds of the card above -- and
# the sum and the max alone read nearly the same. The median rises 4 -> 26 and the share falls
# 98 -> 71, which is the whole reason both readings exist.
cat > "$pen/flat-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran alpha 20260822.100000 green lap 26
ran beta 20260822.100000 green lap 26
ran gamma 20260822.100000 green lap 26
ran delta 20260822.100000 green lap 26
ran epsilon 20260822.100000 green lap 26
ran zeta 20260822.100000 green lap 26
ran eta 20260822.100000 green lap 26
EOF
out=$(run_scan shape.kyri flat-card.kyri)
case "$out" in *"runs_seconds_median=26"*) echo "flat_median=yes" ;; *) echo "flat_median=no" ;; esac
case "$out" in *"runs_seconds_slowest_share_pct=71"*) echo "flat_share=yes" ;; *) echo "flat_share=no" ;; esac

# An untimed card answers with the absence rather than with a zero, on all three readings -- the
# same discipline `runs_seconds_absent` already keeps one layer down.
out=$(run_scan good.kyri good-card.kyri)
case "$out" in *"runs_seconds_median=absent"*) echo "untimed_median_absent=yes" ;; *) echo "untimed_median_absent=no" ;; esac
case "$out" in *"runs_seconds_slowest_share_pct=absent"*) echo "untimed_share_absent=yes" ;; *) echo "untimed_share_absent=no" ;; esac
case "$out" in *"runs_slowest_named:"*) echo "untimed_names_nobody_here=no" ;; *) echo "untimed_names_nobody_here=yes" ;; esac

# --- a tier no runner honors would run on no lap at all, silently -----------------------
cat > "$pen/badtier.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier weekly
seated 20260822.000000
EOF
out=$(run_scan badtier.kyri good-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "unknown_tier_refused=yes" ;; *) echo "unknown_tier_refused=no" ;; esac
case "$out" in *"guards_unknown_tier=1"*) echo "unknown_tier_counted=yes" ;; *) echo "unknown_tier_counted=no" ;; esac

# --- the runner honors the tier, which is the half a scan cannot prove ------------------
# A stub interpreter, so the control measures WHICH guards a pass selects rather than what
# any witness answers. The pen is no git repository, which is itself a case: the staged
# reading answers 0 rather than refusing.
runner="$(pwd)/tools/fixtures/s/standing_equipment_run.sh"
mkdir -p "$pen/rishi/bin"
cat > "$pen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
# A guard whose path names `busy` burns a measurable slice of CPU, so the CPU field below can be
# proven LIVE rather than merely present. Every other stub path exits at once, which is what the
# tier legs above want and what makes zero an honest reading for them.
case "$*" in
  *busy*) i=0; while [ $i -lt 400000 ]; do i=$((i + 1)); done ;;
esac
exit 0
EOF
chmod +x "$pen/rishi/bin/rishi"

run_runner() {
  ( cd "$pen" && STANDING_ROSTER=cadence.kyri STANDING_CARD=run-card.kyri \
      sh "$runner" "$@" 2>/dev/null ) || true
}

rm -f "$pen/run-card.kyri"
out=$(run_runner)
case "$out" in *"tier_run=lap"*) echo "default_is_lap=yes" ;; *) echo "default_is_lap=no" ;; esac
case "$out" in *"guards_run=1"*) echo "default_runs_lap_only=yes" ;; *) echo "default_runs_lap_only=no" ;; esac
case "$out" in *"staged_uncommitted=0"*) echo "no_git_reads_zero=yes" ;; *) echo "no_git_reads_zero=no" ;; esac
if grep -qE "^ran alpha .* lap( |$)" "$pen/run-card.kyri" && ! grep -q "^ran choir " "$pen/run-card.kyri"; then
  echo "default_card_lap_only=yes"
else
  echo "default_card_lap_only=no"
fi
# The runner's half of REDS %388: the card line it writes carries the guard's elapsed seconds, and
# the pass reports its own total. A stub guard costs 0, which is a reading rather than an absence.
if grep -qE "^ran alpha [0-9.]+ green lap [0-9][0-9]* [0-9-]+$" "$pen/run-card.kyri"; then
  echo "runner_records_seconds=yes"
else
  echo "runner_records_seconds=no"
fi
case "$out" in *"guards_seconds="*) echo "runner_totals_seconds=yes" ;; *) echo "runner_totals_seconds=no" ;; esac

# CPU-MILLISECONDS BESIDE WALL-SECONDS. Wall time on a shared pier measures the neighbors as much
# as the guard, so the row carries a second clock the shell already keeps: `times`, whose children
# line is cumulative user plus system time for every descendant the shell has waited on.
if grep -qE "^ran alpha [0-9.]+ green lap [0-9][0-9]* [0-9]+$" "$pen/run-card.kyri"; then
  echo "runner_records_cpu=yes"
else
  echo "runner_records_cpu=no"
fi
case "$out" in *"guards_cpu_ms="*) echo "runner_totals_cpu=yes" ;; *) echo "runner_totals_cpu=no" ;; esac
case "$out" in *"guards_cpu_absent=0"*) echo "runner_cpu_all_read=yes" ;; *) echo "runner_cpu_all_read=no" ;; esac

# THE LEG THAT TELLS A LIVE READING FROM A CONSTANT ZERO. Every stub above exits immediately and
# honestly costs 0 ms, so a field wired to a broken instrument -- `$(times)`, whose subshell reads
# 0m0.000s however much work has been done -- would pass every leg written so far. This guard burns
# CPU on purpose, and its recorded field must be greater than zero.
mkdir -p "$pen/tools"
cat > "$pen/tools/busy_witness.rish" <<'EOF'
# a stub the pen's stub interpreter recognises by name and pays for
EOF
cat > "$pen/busycpu.kyri" <<'EOF'
format standing-equipment-v1
guard busy
path tools/busy_witness.rish
tier lap
seated 20260908.000000
EOF
rm -f "$pen/cpu-card.kyri"
( cd "$pen" && STANDING_ROSTER=busycpu.kyri STANDING_CARD=cpu-card.kyri \
    sh "$runner" 2>/dev/null ) > "$pen/cpu-out.txt" || true
busy_cpu=$(awk '$1 == "ran" && $2 == "busy" { print $7 }' "$pen/cpu-card.kyri")
case "$busy_cpu" in
  ''|*[!0-9]*) echo "busy_guard_cpu_positive=no" ;;
  *) if [ "$busy_cpu" -gt 0 ]; then
       echo "busy_guard_cpu_positive=yes"
     else
       echo "busy_guard_cpu_positive=no"
     fi ;;
esac
# And the wall clock reads that same guard at whole seconds, which is why the finer unit was added:
# a guard costing real CPU can still read 0s, and 0s is what most of the roster reads.
busy_wall=$(awk '$1 == "ran" && $2 == "busy" { print $6 }' "$pen/cpu-card.kyri")
case "$busy_wall" in
  ''|*[!0-9]*) echo "busy_guard_wall_present=no" ;;
  *) echo "busy_guard_wall_present=yes" ;;
esac

out=$(run_runner --tier cadence)
case "$out" in *"guards_run=1"*) echo "tier_selects_one=yes" ;; *) echo "tier_selects_one=no" ;; esac
# The earlier pass's line survives, so a slower tier never erases the faster one's history.
if grep -q "^ran alpha " "$pen/run-card.kyri" && grep -qE "^ran choir .* cadence( |$)" "$pen/run-card.kyri"; then
  echo "card_keeps_untouched=yes"
else
  echo "card_keeps_untouched=no"
fi

rm -f "$pen/run-card.kyri"
out=$(run_runner --all)
case "$out" in *"guards_run=2"*) echo "all_runs_every_tier=yes" ;; *) echo "all_runs_every_tier=no" ;; esac

rm -f "$pen/run-card.kyri"
out=$(run_runner choir)
case "$out" in *"guards_run=1"*) echo "name_selects_any_tier=yes" ;; *) echo "name_selects_any_tier=no" ;; esac
if grep -q "^ran choir " "$pen/run-card.kyri" && ! grep -q "^ran alpha " "$pen/run-card.kyri"; then
  echo "name_runs_only_that_guard=yes"
else
  echo "name_runs_only_that_guard=no"
fi

# --- the cadence slice: a clock that turns, proven by turning it -------------------------
# WHY THESE LEGS. `tier cadence` promised a slower clock and delivered none -- measured on this pier
# `20260910.221225`, every one of the 74 cadence guards had never run here. The repair is a rotation
# read off the run card, and a rotation is exactly the kind of mechanism that can look right while
# standing still: a slice that picked the same guard every lap would pass a leg asserting it ran
# one. So the legs below prove the ORDER and its MOVEMENT, not merely the count.
cat > "$pen/slice.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
seated 20260822.000000
guard choir
path tools/real_witness.rish
tier cadence
seated 20260825.000000
guard descant
path tools/real_witness.rish
tier cadence
seated 20260826.000000
EOF

run_slice() {
  ( cd "$pen" && STANDING_ROSTER=slice.kyri STANDING_CARD=slice-card.kyri \
      sh "$runner" "$@" 2>/dev/null ) || true
}
# The refusals below are read from stderr and from the exit status, because a flag that does nothing
# quietly is the exact fault this mechanism exists to end -- a silent no-op would pass any leg that
# only read stdout.
slice_refusal() {
  # The status is caught with `|| st=$?` rather than read from `$?` after the fact, because `set -e`
  # would end the subshell at the refusal itself and the echo below would never run -- which is how
  # a refusal leg can quietly become no leg at all.
  (
    cd "$pen" || exit 1
    st=0
    STANDING_ROSTER=slice.kyri STANDING_CARD=slice-card.kyri \
      sh "$runner" "$@" 2>&1 >/dev/null || st=$?
    echo "status=$st"
  )
}

rm -f "$pen/slice-card.kyri"
out=$(run_slice)
case "$out" in *"cadence_slice=0"*) echo "slice_default_off=yes" ;; *) echo "slice_default_off=no" ;; esac
case "$out" in *"cadence_slice_run=0"*) echo "slice_default_takes_none=yes" ;; *) echo "slice_default_takes_none=no" ;; esac
case "$out" in *"guards_run=1"*) echo "slice_default_lap_only=yes" ;; *) echo "slice_default_lap_only=no" ;; esac

# A slice of one rides the lap pass: two guards run, and the pass is still a lap pass.
rm -f "$pen/slice-card.kyri"
out=$(run_slice --cadence-slice 1)
case "$out" in *"guards_run=2"*) echo "slice_one_adds_one=yes" ;; *) echo "slice_one_adds_one=no" ;; esac
case "$out" in *"cadence_slice_run=1"*) echo "slice_counts_its_turn=yes" ;; *) echo "slice_counts_its_turn=no" ;; esac
case "$out" in *"tier_run=lap"*) echo "slice_stays_a_lap_pass=yes" ;; *) echo "slice_stays_a_lap_pass=no" ;; esac
# Named out loud, with what the card knew: a reader of a cold open can say which guard was heard.
case "$out" in *"cadence_slice_named choir last=never"*) echo "slice_names_its_pick=yes" ;; *) echo "slice_names_its_pick=no" ;; esac
# And the row it writes carries the guard's own tier, so the next pass reads it as a cadence guard
# that has now spoken rather than as a lap guard that appeared from nowhere.
if grep -qE "^ran choir [0-9.]+ green cadence " "$pen/slice-card.kyri"; then
  echo "slice_records_cadence_tier=yes"
else
  echo "slice_records_cadence_tier=no"
fi

# THE LEG THAT PROVES THE CLOCK MOVES. A second pass over the card the first one wrote must take the
# OTHER cadence guard -- a rotation that re-picked `choir` would satisfy every count above.
out=$(run_slice --cadence-slice 1)
case "$out" in *"cadence_slice_named descant last=never"*) echo "slice_rotates=yes" ;; *) echo "slice_rotates=no" ;; esac
if grep -q "^ran choir " "$pen/slice-card.kyri" && grep -q "^ran descant " "$pen/slice-card.kyri"; then
  echo "slice_reaches_whole_tier=yes"
else
  echo "slice_reaches_whole_tier=no"
fi

# And a third pass returns to the guard whose stamp is now the older of the two, which is the same
# rule as the first two passes rather than a special case for an exhausted queue.
out=$(run_slice --cadence-slice 1)
case "$out" in *"cadence_slice_named choir last=2"*) echo "slice_returns_to_oldest=yes" ;; *) echo "slice_returns_to_oldest=no" ;; esac

# A NEVER-RUN GUARD SORTS AHEAD OF A DATED ONE, whatever the roster order says. The card below
# names the FIRST cadence guard as freshly run, so roster order alone would pick it again.
cat > "$pen/slice-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran choir 20260909.120000 green cadence 0 0
EOF
out=$(run_slice --cadence-slice 1)
case "$out" in *"cadence_slice_named descant last=never"*) echo "slice_never_run_first=yes" ;; *) echo "slice_never_run_first=no" ;; esac

# AND AMONG DATED ONES, THE OLDER GOES FIRST -- the half of the ordering the leg above cannot see.
cat > "$pen/slice-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran choir 20260909.120000 green cadence 0 0
ran descant 20260901.120000 green cadence 0 0
EOF
out=$(run_slice --cadence-slice 1)
case "$out" in *"cadence_slice_named descant last=20260901.120000"*) echo "slice_oldest_first=yes" ;; *) echo "slice_oldest_first=no" ;; esac

# A SLICE WIDER THAN THE TIER TAKES THE TIER, never a guard twice.
rm -f "$pen/slice-card.kyri"
out=$(run_slice --cadence-slice 9)
case "$out" in *"cadence_slice_run=2"*) echo "slice_bounded_by_tier=yes" ;; *) echo "slice_bounded_by_tier=no" ;; esac
case "$out" in *"guards_run=3"*) echo "slice_no_duplicate=yes" ;; *) echo "slice_no_duplicate=no" ;; esac

# A CADENCE GUARD THIS HOST CANNOT RUN IS NEVER SPENT AS A TURN. The skip is the lap tier's own,
# taken by the one selector both readings share.
cat > "$pen/slice-host.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
seated 20260822.000000
guard choir
path tools/real_witness.rish
tier cadence
host some-other-pier
seated 20260825.000000
guard descant
path tools/real_witness.rish
tier cadence
seated 20260826.000000
EOF
rm -f "$pen/slice-host-card.kyri"
out=$( ( cd "$pen" && STANDING_ROSTER=slice-host.kyri STANDING_CARD=slice-host-card.kyri \
    sh "$runner" --cadence-slice 1 2>/dev/null ) || true )
case "$out" in *"cadence_slice_named descant last=never"*) echo "slice_honors_host_skip=yes" ;; *) echo "slice_honors_host_skip=no" ;; esac

# THE REFUSALS, each spoken. `--all` and `--tier cadence` already sing the whole choir, a guard named
# by hand already crosses every tier, and a `--scoped` pass proves a delta rather than a rotation.
out=$(slice_refusal --cadence-slice 1 --all)
case "$out" in *"refused: --cadence-slice serves the lap tier"*) echo "slice_refuses_all=yes" ;; *) echo "slice_refuses_all=no" ;; esac
case "$out" in *"status=1"*) echo "slice_refuses_all_status=yes" ;; *) echo "slice_refuses_all_status=no" ;; esac
out=$(slice_refusal --cadence-slice 1 --tier cadence)
case "$out" in *"refused: --cadence-slice serves the lap tier"*) echo "slice_refuses_tier=yes" ;; *) echo "slice_refuses_tier=no" ;; esac
out=$(slice_refusal --cadence-slice 1 --scoped)
case "$out" in *"refused: --cadence-slice with --scoped"*) echo "slice_refuses_scoped=yes" ;; *) echo "slice_refuses_scoped=no" ;; esac
out=$(slice_refusal --cadence-slice 1 choir)
case "$out" in *"refused: --cadence-slice with a guard name"*) echo "slice_refuses_named=yes" ;; *) echo "slice_refuses_named=no" ;; esac
out=$(slice_refusal --cadence-slice two)
case "$out" in *"refused: --cadence-slice wants a whole number"*) echo "slice_refuses_word=yes" ;; *) echo "slice_refuses_word=no" ;; esac
out=$(slice_refusal --cadence-slice)
case "$out" in *"refused: --cadence-slice wants a whole number"*) echo "slice_refuses_empty=yes" ;; *) echo "slice_refuses_empty=no" ;; esac

# A guard whose path is gone answers absent rather than green, so the runner cannot pass a hole.
cat > "$pen/gonepath.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/no_such_witness.rish
tier lap
seated 20260822.000000
EOF
out=$( ( cd "$pen" && STANDING_ROSTER=gonepath.kyri STANDING_CARD=absent-run.kyri \
        sh "$runner" 2>/dev/null ) || true )
case "$out" in *"run_verdict=guard_red"*) echo "absent_path_reds_runner=yes" ;; *) echo "absent_path_reds_runner=no" ;; esac

# --- the detached launch names its own transcript, both sides (REDS row `20260908.113404`) -------
# THE FAULT THIS CLOSES is three reds wide: `%541` signaled a pass by command line, `%549`
# redirected one to a constant name under a shared `/tmp`, and `%620` gave one a unique name and
# then found it again by globbing. Every firing put the redirect in one shell and the naming in
# another. `--detach` puts both in this runner, so the legs below prove the parent returns having
# named the file, the file identifies this launch before the child writes a byte, and an elder file
# standing at that path cannot survive to be read as today's.
detach_transcript() { echo "$pen/session-output/standing-equipment-$1.txt"; }
# A bounded wait rather than an unbounded one: the stub guard costs nothing, so a pass that has not
# closed within a hundred seconds has failed in a way this control must report rather than hang on.
detach_wait() {
  _i=0
  while [ "$_i" -lt 100 ]; do
    if grep -q '^run_verdict=' "$1" 2>/dev/null; then return 0; fi
    sleep 1
    _i=$((_i + 1))
  done
  return 1
}

rm -rf "$pen/session-output"
# The elder file the launch must destroy -- `%620`'s own fault, planted where it would bite.
mkdir -p "$pen/session-output"
echo "elder_pass_from_yesterday" > "$(detach_transcript cold)"
out=$(run_runner --detach)
case "$out" in *"transcript=session-output/standing-equipment-cold.txt"*)
  echo "detach_prints_path=yes" ;; *) echo "detach_prints_path=no" ;; esac
case "$out" in *"pid="[0-9]*) echo "detach_prints_pid=yes" ;; *) echo "detach_prints_pid=no" ;; esac
# The parent returns having launched rather than having run: no guard line, no verdict of its own.
case "$out" in *"ran alpha"*|*"run_verdict="*) echo "detach_parent_returns=no" ;; *) echo "detach_parent_returns=yes" ;; esac
cold=$(detach_transcript cold)
if grep -q '^launch_stamp [0-9]' "$cold" && grep -q '^launch_head ' "$cold" && grep -q '^launch_args' "$cold"; then
  echo "detach_header_written=yes"; else echo "detach_header_written=no"; fi
if grep -q 'elder_pass_from_yesterday' "$cold"; then
  echo "detach_truncates_elder=no"; else echo "detach_truncates_elder=yes"; fi
if detach_wait "$cold"; then echo "detach_child_closes=yes"; else echo "detach_child_closes=no"; fi
if grep -q '^alpha ' "$cold"; then echo "detach_child_runs_roster=yes"; else echo "detach_child_runs_roster=no"; fi

# The MODE is what names the file, so two modes never share one path and a lap never disambiguates
# by hand. `--hot` over the same pen writes its own transcript and leaves the cold one alone.
out=$(run_runner --detach --hot)
case "$out" in *"transcript=session-output/standing-equipment-hot.txt"*)
  echo "detach_mode_names_file=yes" ;; *) echo "detach_mode_names_file=no" ;; esac
hot=$(detach_transcript hot)
if detach_wait "$hot" && [ -f "$cold" ]; then echo "detach_modes_stay_apart=yes"; else echo "detach_modes_stay_apart=no"; fi

# A refusal stays in the FOREGROUND, where the hand that typed it is standing. An absent roster is
# refused before anything is launched, and no transcript is written for a pass that never began.
# THE TRUNCATION PROVEN INNOCENT. `detach_truncates_elder=yes` above is the whole of `%620`'s cure,
# and a leg that only ever passes cannot be told from one testing nothing. So the same launch runs
# again over a runner copy whose header write APPENDS rather than truncates -- the elder shape,
# `%549`'s constant name without the clean start -- and yesterday's bytes must survive it. One
# character changed, and the change is asserted rather than assumed. Every sibling the runner
# sources travels with the copy, since a copy that cannot start prints nothing and reads exactly
# like a repair that worked.
sed 's|^  } > "\$transcript"$|  } >> "$transcript"|' "$runner" > "$pen/run-append.sh"
cp "$(dirname "$runner")/shell_portable.sh" "$pen/shell_portable.sh"
cp "$(dirname "$runner")/scope_match.sh" "$pen/scope_match.sh"
if cmp -s "$runner" "$pen/run-append.sh"; then
  echo "append_runner_built=no"; else echo "append_runner_built=yes"; fi
rm -rf "$pen/session-output"
mkdir -p "$pen/session-output"
echo "elder_pass_from_yesterday" > "$(detach_transcript cold)"
out=$( ( cd "$pen" && STANDING_ROSTER=cadence.kyri STANDING_CARD=run-card.kyri \
        sh "$pen/run-append.sh" --detach 2>/dev/null ) || true )
case "$out" in *"transcript="*) echo "append_runner_ran=yes" ;; *) echo "append_runner_ran=no" ;; esac
if grep -q 'elder_pass_from_yesterday' "$(detach_transcript cold)"; then
  echo "append_runner_keeps_elder=yes"; else echo "append_runner_keeps_elder=no"; fi
detach_wait "$(detach_transcript cold)" || true

rm -rf "$pen/session-output"
out=$( ( cd "$pen" && STANDING_ROSTER=no-such-roster.kyri STANDING_CARD=run-card.kyri \
        sh "$runner" --detach 2>&1 ) || true )
case "$out" in *"refused: no roster"*) echo "detach_refuses_before_launch=yes" ;; *) echo "detach_refuses_before_launch=no" ;; esac
if [ -e "$pen/session-output" ]; then echo "detach_refusal_writes_nothing=no"; else echo "detach_refusal_writes_nothing=yes"; fi

# --- a refused launch leaves a LIVE pass's transcript standing (`20260908.152208`) --------------
# THE FAULT THIS CLOSES. The truncation above is right about an ELDER file and was performing a
# second act nobody asked for: the child discovers the run lock only after this parent has already
# emptied the transcript, so a `--detach` typed while a pass is in flight destroyed the RUNNING
# pass's own record and then refused. Measured on `grain-diffuser` that stamp: twenty-three lines
# went, one of them the only line naming a red, and the pass closed reporting `guards_red=3` above
# a transcript showing two. Both sides are planted -- a live owner must refuse and spare the file,
# and a stale owner must be walked straight past, since refusing on a dead lock would shut every
# later lap out of the instrument its own card opens with.
rm -rf "$pen/session-output"
mkdir -p "$pen/session-output"
echo "live_pass_in_flight" > "$(detach_transcript cold)"
rm -rf "$pen/live.lock.d"
mkdir -p "$pen/live.lock.d"
# The control's own pid is alive by construction, which is the one liveness plant that cannot race.
echo "$$" > "$pen/live.lock.d/pid"
out=$( ( cd "$pen" && STANDING_ROSTER=cadence.kyri STANDING_CARD=run-card.kyri \
        STANDING_LOCK=live.lock.d sh "$runner" --detach 2>&1 ) || true )
case "$out" in *"run_verdict=run_in_flight"*)
  echo "detach_refuses_live_pass=yes" ;; *) echo "detach_refuses_live_pass=no" ;; esac
# THE PATH A REFUSAL NAMES IS THE OWNER'S, NEVER THE REQUESTER'S (REDS `%666`). This leg read
# `transcript=session-output/standing-equipment-cold.txt` until `20260909`, and that was the fault
# written down as a passing check: the path printed was the one THIS launch would have used, which
# agrees with the owner's only when both ran the same mode. The owner here holds no `transcript`
# file, which is what a foreground pass leaves, so the refusal must say `none` rather than derive.
case "$out" in *"owner_transcript=none"*)
  echo "detach_live_refusal_names_owner=yes" ;; *) echo "detach_live_refusal_names_owner=no" ;; esac
# And it must print NO `transcript=` line of its own, since a reader copies that word straight into
# the next command. `owner_transcript=` carries the substring and never starts a line with it.
case "$out" in *"
transcript="*|"transcript="*) echo "detach_refusal_prints_only_owner=no" ;;
  *) echo "detach_refusal_prints_only_owner=yes" ;; esac
if grep -q 'live_pass_in_flight' "$(detach_transcript cold)"; then
  echo "detach_spares_live_transcript=yes"; else echo "detach_spares_live_transcript=no"; fi

# THE FIRING ITSELF, PLANTED. `%666` was a cold launch refused by an owner running `--scoped`: the
# two derived paths differ, so the requester was handed an elder file's name and read it as the live
# pass. The owner's own path goes into the lock it holds, and the refusal must name THAT and never
# the cold one this launch would have written.
echo "session-output/standing-equipment-cold-scoped.txt" > "$pen/live.lock.d/transcript"
out=$( ( cd "$pen" && STANDING_ROSTER=cadence.kyri STANDING_CARD=run-card.kyri \
        STANDING_LOCK=live.lock.d sh "$runner" --detach 2>&1 ) || true )
case "$out" in *"owner_transcript=session-output/standing-equipment-cold-scoped.txt"*)
  echo "detach_refusal_names_other_mode=yes" ;; *) echo "detach_refusal_names_other_mode=no" ;; esac
case "$out" in *"standing-equipment-cold.txt"*)
  echo "detach_refusal_names_requester=yes" ;; *) echo "detach_refusal_names_requester=no" ;; esac
# TASTED TWICE, which is this tree's own test of an infusion: a refusal that reads differently on
# its second run is a refusal a reader cannot trust. The live transcript survives both.
out2=$( ( cd "$pen" && STANDING_ROSTER=cadence.kyri STANDING_CARD=run-card.kyri \
        STANDING_LOCK=live.lock.d sh "$runner" --detach 2>&1 ) || true )
if [ "$out" = "$out2" ]; then echo "detach_refusal_repeats=yes"; else echo "detach_refusal_repeats=no"; fi
if grep -q 'live_pass_in_flight' "$(detach_transcript cold)"; then
  echo "detach_repeat_spares_transcript=yes"; else echo "detach_repeat_spares_transcript=no"; fi
rm -f "$pen/live.lock.d/transcript"

# THE FAULT PROVEN TO BITE, from the failing side. Four legs answering the way this repair wants
# cannot be told from four legs on a runner that never carried `%666`, so the same plant runs again
# against a copy whose refusal names the path IT derived -- the elder line, one word changed. The
# requester's cold path must appear, which is what a reader was handed and read as the live pass.
sed 's|^          owner_transcript "\$lock"$|          echo "transcript=$transcript"|' \
  "$runner" > "$pen/run-derive.sh"
cp "$(dirname "$runner")/shell_portable.sh" "$pen/shell_portable.sh"
cp "$(dirname "$runner")/scope_match.sh" "$pen/scope_match.sh"
if cmp -s "$runner" "$pen/run-derive.sh"; then
  echo "derive_runner_built=no"; else echo "derive_runner_built=yes"; fi
echo "session-output/standing-equipment-cold-scoped.txt" > "$pen/live.lock.d/transcript"
out=$( ( cd "$pen" && STANDING_ROSTER=cadence.kyri STANDING_CARD=run-card.kyri \
        STANDING_LOCK=live.lock.d sh "$pen/run-derive.sh" --detach 2>&1 ) || true )
case "$out" in *"run_verdict=run_in_flight"*) echo "derive_runner_ran=yes" ;; *) echo "derive_runner_ran=no" ;; esac
case "$out" in *"transcript=session-output/standing-equipment-cold.txt"*)
  echo "derive_runner_names_requester=yes" ;; *) echo "derive_runner_names_requester=no" ;; esac
rm -f "$pen/live.lock.d/transcript"

# THE PLANT PROVEN TO LAND. Every leg above reads a file this control wrote by hand, so all four
# would pass over a runner that never records its own path -- the shape `%519` names. So a REAL
# detached launch runs against the pen roster, and the lock it takes must carry its own transcript
# while it holds it.
rm -rf "$pen/session-output" "$pen/own.lock.d"
mkdir -p "$pen/session-output"
( cd "$pen" && STANDING_ROSTER=cadence.kyri STANDING_CARD=run-card.kyri \
    STANDING_LOCK=own.lock.d sh "$runner" --detach --hot >/dev/null 2>&1 ) || true
detach_wait "$(detach_transcript hot)" || true
# READ FROM THE TRANSCRIPT RATHER THAN FROM THE LOCK, and the reason is that the lock leaves with
# the pass. A stub roster closes in well under a second, so polling the lock directory races the
# run it is measuring and answers `no` for a pass that did everything right. The runner prints this
# line by reading the file back, so a transcript carrying it is evidence the write landed.
if grep -q '^run_transcript=session-output/standing-equipment-hot\.txt$' "$(detach_transcript hot)"; then
  echo "detach_owner_records_path=yes"; else echo "detach_owner_records_path=no"; fi
# And the lock leaves with the pass, so no elder path outlives the run that wrote it.
if [ -e "$pen/own.lock.d" ]; then
  echo "detach_lock_leaves=no"; else echo "detach_lock_leaves=yes"; fi

# THE OTHER SIDE, and it is the one a careless repair breaks. A lock whose owner has EXITED is
# reaped by `lock_acquire`, so the launch must walk past it and truncate exactly as before. A pid
# is made dead here rather than guessed: a shell is started, waited on, and its number reused for
# nothing else in the time this leg takes.
( exit 0 ) & dead_pid=$!
wait "$dead_pid" 2>/dev/null || true
rm -rf "$pen/session-output"
mkdir -p "$pen/session-output"
echo "elder_pass_from_yesterday" > "$(detach_transcript cold)"
rm -rf "$pen/live.lock.d"
mkdir -p "$pen/live.lock.d"
echo "$dead_pid" > "$pen/live.lock.d/pid"
out=$( ( cd "$pen" && STANDING_ROSTER=cadence.kyri STANDING_CARD=run-card.kyri \
        STANDING_LOCK=live.lock.d sh "$runner" --detach 2>&1 ) || true )
case "$out" in *"run_verdict=run_in_flight"*)
  echo "detach_stale_lock_refuses=yes" ;; *) echo "detach_stale_lock_refuses=no" ;; esac
if grep -q 'elder_pass_from_yesterday' "$(detach_transcript cold)"; then
  echo "detach_stale_lock_keeps_elder=yes"; else echo "detach_stale_lock_keeps_elder=no"; fi
detach_wait "$(detach_transcript cold)" || true
rm -rf "$pen/live.lock.d"
rm -rf "$pen/session-output"

# THE REPAIR PROVEN LOAD-BEARING. Three legs answering `yes` cannot be told from three legs on a
# runner that never carried the fault, so the same live-lock plant runs again against a copy whose
# liveness test can never fire -- the elder shape, where the parent truncates and the child refuses
# afterwards. Yesterday's bytes must NOT survive it. Every sibling the runner sources travels with
# the copy, since a copy that cannot start prints nothing and reads exactly like a repair that
# worked.
sed 's|^        if kill -0 "$detach_owner" 2>/dev/null; then$|        if false; then|' \
  "$runner" > "$pen/run-elder.sh"
cp "$(dirname "$runner")/shell_portable.sh" "$pen/shell_portable.sh"
cp "$(dirname "$runner")/scope_match.sh" "$pen/scope_match.sh"
if cmp -s "$runner" "$pen/run-elder.sh"; then
  echo "elder_runner_built=no"; else echo "elder_runner_built=yes"; fi
mkdir -p "$pen/session-output"
echo "live_pass_in_flight" > "$(detach_transcript cold)"
rm -rf "$pen/live.lock.d"
mkdir -p "$pen/live.lock.d"
echo "$$" > "$pen/live.lock.d/pid"
out=$( ( cd "$pen" && STANDING_ROSTER=cadence.kyri STANDING_CARD=run-card.kyri \
        STANDING_LOCK=live.lock.d sh "$pen/run-elder.sh" --detach 2>&1 ) || true )
case "$out" in *"transcript="*) echo "elder_runner_ran=yes" ;; *) echo "elder_runner_ran=no" ;; esac
if grep -q 'live_pass_in_flight' "$(detach_transcript cold)"; then
  echo "elder_empties_live_transcript=no"; else echo "elder_empties_live_transcript=yes"; fi
detach_wait "$(detach_transcript cold)" || true
rm -rf "$pen/live.lock.d"
rm -rf "$pen/session-output"
rm -rf "$pen/session-output"

# --- the tree digest, proven from both sides on a REAL git repository ---------------------
# The runner takes twelve characters of `git rev-parse HEAD` plus `git status --porcelain` before
# the first guard and again after the last, so a lap that starts editing while the roster runs is
# told its verdicts describe neither tree (REDS %221). Proving that only in the quiet direction
# would leave a reading nobody could tell from a stub, so a guard here DIRTIES the tree on purpose
# and the runner is watched to say so and refuse.
gitpen="$pen/gitpen"
mkdir -p "$gitpen/rishi/bin"
( cd "$gitpen" && git init -q . && git config user.email a@b.c && git config user.name t \
  && git config commit.gpgsign false && echo seed > kept.txt && git add kept.txt \
  && git commit -qm "seed" ) >/dev/null 2>&1

cat > "$gitpen/quiet.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path guard.sh
tier lap
seated 20260825.000000
EOF
: > "$gitpen/guard.sh"

# A stub that changes nothing: the tree stands still and the run answers ok.
cat > "$gitpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$gitpen/rishi/bin/rishi"
out=$( ( cd "$gitpen" && STANDING_ROSTER=quiet.kyri STANDING_CARD=run-card.kyri \
        sh "$runner" 2>/dev/null ) || true )
case "$out" in *"tree_moved=no"*) echo "still_tree_reads_no=yes" ;; *) echo "still_tree_reads_no=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "still_tree_passes=yes" ;; *) echo "still_tree_passes=no" ;; esac
case "$out" in *"tree_at_open=nogit"*) echo "real_repo_digests=no" ;; *) echo "real_repo_digests=yes" ;; esac

# A stub that writes an untracked file: the tree moves under the run, and the runner refuses.
cat > "$gitpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
: > mid-run.txt
exit 0
EOF
chmod +x "$gitpen/rishi/bin/rishi"
out=$( ( cd "$gitpen" && STANDING_ROSTER=quiet.kyri STANDING_CARD=run-card.kyri \
        sh "$runner" 2>/dev/null ) || true )
case "$out" in *"tree_moved=yes"*) echo "moved_tree_reads_yes=yes" ;; *) echo "moved_tree_reads_yes=no" ;; esac
case "$out" in *"run_verdict=tree_moved"*) echo "moved_tree_refuses=yes" ;; *) echo "moved_tree_refuses=no" ;; esac
# Every guard line still prints above the refusal, so a moved tree loses no reading.
case "$out" in *"alpha green"*) echo "moved_tree_keeps_lines=yes" ;; *) echo "moved_tree_keeps_lines=no" ;; esac

# A guard red is the louder finding and keeps the verdict even when the tree also moved.
cat > "$gitpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
: > mid-run-two.txt
exit 1
EOF
chmod +x "$gitpen/rishi/bin/rishi"
out=$( ( cd "$gitpen" && STANDING_ROSTER=quiet.kyri STANDING_CARD=run-card.kyri \
        sh "$runner" 2>/dev/null ) || true )
case "$out" in *"run_verdict=guard_red"*) echo "red_outranks_moved=yes" ;; *) echo "red_outranks_moved=no" ;; esac

# --- how far behind the anointed order a pass opened, proven in all three answers ---------------
# A cold endurance run costs about forty minutes against a fleet landing five to seven commits an hour, so a
# lap that opens the roster instead of `tools/f/fleet_round_open.sh` measures a tree the fleet has
# already left. The runner reads that distance off the remote-tracking ref the last fetch left --
# no network, so it can only under-report -- and reports it without gating. Three answers stand:
# a repository with no `xy/main` at all says `unknown`; one standing level with it says `0`; and
# one two commits behind says `2`. The third is planted by moving the pen's own ref forward, which
# is exactly what a peer's push does to every ship that has fetched since.
cat > "$gitpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$gitpen/rishi/bin/rishi"
run_gitpen() { ( cd "$gitpen" && STANDING_ROSTER=quiet.kyri STANDING_CARD=run-card.kyri \
        sh "$runner" 2>/dev/null ) || true; }

# 1. no anointed ref at all -- the reading refuses to invent one.
out=$(run_gitpen)
case "$out" in *"head_behind_anointed=unknown"*) echo "behind_unknown_without_ref=yes" ;; *) echo "behind_unknown_without_ref=no" ;; esac

# 2. level with the anointed ref -- zero, and the ref's own stamp printed beside it.
( cd "$gitpen" && git update-ref refs/remotes/xy/main HEAD ) >/dev/null 2>&1
out=$(run_gitpen)
case "$out" in *"head_behind_anointed=0"*) echo "behind_zero_when_level=yes" ;; *) echo "behind_zero_when_level=no" ;; esac
case "$out" in *"anointed_ref_committed=20"*) echo "behind_names_ref_stamp=yes" ;; *) echo "behind_names_ref_stamp=no" ;; esac

# 3. two commits behind -- the number a lap needed at minute one, and the pass still passes.
( cd "$gitpen" && git checkout -q -b anointed && echo one > a.txt && git add a.txt \
  && git commit -qm "peer one" && echo two > b.txt && git add b.txt && git commit -qm "peer two" \
  && git update-ref refs/remotes/xy/main HEAD && git checkout -q main 2>/dev/null \
  || ( cd "$gitpen" && git checkout -q master ) ) >/dev/null 2>&1
out=$(run_gitpen)
case "$out" in *"head_behind_anointed=2"*) echo "behind_counts_the_distance=yes" ;; *) echo "behind_counts_the_distance=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "behind_gates_nothing=yes" ;; *) echo "behind_gates_nothing=no" ;; esac
( cd "$gitpen" && git update-ref -d refs/remotes/xy/main ) >/dev/null 2>&1


# --- the digest reads content, not only the status letter, both sides (REDS %380) ---------
# `git status --porcelain` prints a status letter and a path and nothing else, so a file already
# carrying `M` reads `M path` however often its bytes change -- and so do `??`, `MM`, and a staged
# `M ` re-staged. The digest above therefore stood still while a pass rewrote a file it had already
# marked, and answered `tree_moved=no` over a tree that had moved. Four dirty shapes are proven
# here from the side that bites, each with the file dirty BEFORE the pass opens so that its status
# letter cannot move and only its bytes can. The control first shows the elder reading standing
# still across exactly such an edit, so the new one is known to be doing work the old could not.
# Two green sides follow, cold and hot: a dirty tree that stands still must still read
# `tree_moved=no`, or the repair would refuse every ordinary round instead of the one it is for.
# This pen is its own repository so the sections above and below keep the tree state they expect.
digestpen="$pen/digestpen"
mkdir -p "$digestpen/rishi/bin"
( cd "$digestpen" && git init -q . && git config user.email a@b.c && git config user.name t \
  && git config commit.gpgsign false && echo one > kept.txt && git add kept.txt \
  && git commit -qm "seed" ) >/dev/null 2>&1
cat > "$digestpen/quiet.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path guard.sh
tier lap
seated 20260830.000000
EOF
: > "$digestpen/guard.sh"

run_digestpen() {
  ( cd "$digestpen" && STANDING_ROSTER=quiet.kyri STANDING_CARD=run-card.kyri \
      sh "$runner" "$@" 2>/dev/null ) || true
}
# The stub IS the mid-run edit: whatever it writes, it writes between the open digest and the close.
digest_stub() {
  { printf '#!/bin/sh\n'; printf '%s\n' "$1"; printf 'exit 0\n'; } > "$digestpen/rishi/bin/rishi"
  chmod +x "$digestpen/rishi/bin/rishi"
}

# The elder reading, shown blind on the very edit the new one must catch.
( cd "$digestpen" && printf 'two\n' > kept.txt )
before_status=$( cd "$digestpen" && git status --porcelain )
( cd "$digestpen" && printf 'three\n' > kept.txt )
after_status=$( cd "$digestpen" && git status --porcelain )
if [ "$before_status" = "$after_status" ]; then
  echo "porcelain_blind_to_content=yes"
else
  echo "porcelain_blind_to_content=no"
fi

# 1. A tracked file already unstaged-modified, rewritten under the run. Nothing is staged, so the
#    cold endurance run opens rather than refusing, and the only thing that changes is the file's bytes.
digest_stub "printf 'four\n' > kept.txt"
out=$(run_digestpen)
case "$out" in *"tree_moved=yes"*) echo "modified_rewrite_moves=yes" ;; *) echo "modified_rewrite_moves=no" ;; esac
case "$out" in *"run_verdict=tree_moved"*) echo "modified_rewrite_refuses=yes" ;; *) echo "modified_rewrite_refuses=no" ;; esac

# 2. An untracked file, rewritten under the run. `??` is as fixed a status letter as `M`.
( cd "$digestpen" && git checkout -q -- kept.txt && printf 'u1\n' > loose.txt )
digest_stub "printf 'u2\n' > loose.txt"
out=$(run_digestpen)
case "$out" in *"tree_moved=yes"*) echo "untracked_rewrite_moves=yes" ;; *) echo "untracked_rewrite_moves=no" ;; esac

# 3. A staged file re-staged under the run -- the sharpest shape, because `--hot` is exactly the
#    pass that runs over a round's own staged paths, and re-staging an edit is what a round does.
( cd "$digestpen" && rm -f loose.txt && printf 's1\n' > kept.txt && git add kept.txt )
digest_stub "printf 's2\n' > kept.txt; git add kept.txt"
out=$(run_digestpen --hot)
case "$out" in *"tree_moved=yes"*) echo "restaged_rewrite_moves=yes" ;; *) echo "restaged_rewrite_moves=no" ;; esac
case "$out" in *"run_verdict=tree_moved"*) echo "restaged_rewrite_refuses=yes" ;; *) echo "restaged_rewrite_refuses=no" ;; esac

# 4. A file both staged and modified, rewritten again under the run: `MM` before and `MM` after.
( cd "$digestpen" && printf 'm1\n' > kept.txt && git add kept.txt && printf 'm2\n' > kept.txt )
digest_stub "printf 'm3\n' > kept.txt"
out=$(run_digestpen --hot)
case "$out" in *"tree_moved=yes"*) echo "staged_modified_rewrite_moves=yes" ;; *) echo "staged_modified_rewrite_moves=no" ;; esac

# The green sides. A tree can be dirty for a whole pass and move not one byte, which is what an
# ordinary round looks like from here, and the content reading must leave it entirely alone.
digest_stub ":"
( cd "$digestpen" && git reset -q && git checkout -q -- kept.txt && printf 'still\n' > kept.txt )
out=$(run_digestpen)
case "$out" in *"tree_moved=no"*) echo "dirty_still_tree_reads_no=yes" ;; *) echo "dirty_still_tree_reads_no=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "dirty_still_tree_passes=yes" ;; *) echo "dirty_still_tree_passes=no" ;; esac

( cd "$digestpen" && git add kept.txt )
out=$(run_digestpen --hot)
case "$out" in *"tree_moved=no"*) echo "staged_still_tree_reads_no=yes" ;; *) echo "staged_still_tree_reads_no=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "staged_still_tree_passes=yes" ;; *) echo "staged_still_tree_passes=no" ;; esac
# --- the unclosed lap, proven from both sides on the same real repository -----------------
# A full-roster pass opening on a dirty index is a lap that ended at `git add` (REDS %188, %220,
# %223). The refusal has to be shown against the case it must NOT bite -- a clean cold open -- or a
# guard that always refuses cannot be told from one that reads the index at all.
cat > "$gitpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$gitpen/rishi/bin/rishi"

run_gitpen() {
  ( cd "$gitpen" && STANDING_ROSTER=quiet.kyri STANDING_CARD=run-card.kyri \
      sh "$runner" "$@" 2>/dev/null ) || true
}

# The green side: nothing staged, and a bare pass runs its guard and answers ok.
( cd "$gitpen" && git reset -q ) >/dev/null 2>&1 || true
rm -f "$gitpen/mid-run.txt" "$gitpen/mid-run-two.txt"
out=$(run_gitpen)
case "$out" in *"staged_uncommitted=0"*) echo "clean_cold_reads_zero=yes" ;; *) echo "clean_cold_reads_zero=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "clean_cold_endurance_runs=yes" ;; *) echo "clean_cold_endurance_runs=no" ;; esac

# The refusing side: one path staged and never committed, and the bare pass refuses.
( cd "$gitpen" && echo staged > left_behind.txt && git add left_behind.txt ) >/dev/null 2>&1 || true
out=$(run_gitpen)
case "$out" in *"run_verdict=lap_unclosed"*) echo "staged_cold_refuses=yes" ;; *) echo "staged_cold_refuses=no" ;; esac
# It refuses BEFORE the first guard, so no guard line and no tree digest appear above it.
case "$out" in *"alpha green"*) echo "staged_cold_refuses_early=no" ;; *) echo "staged_cold_refuses_early=yes" ;; esac
case "$out" in *"tree_at_open="*) echo "staged_cold_skips_digest=no" ;; *) echo "staged_cold_skips_digest=yes" ;; esac

# `--hot` is how a round says the staged paths are its own -- the after-`git add` pass.
out=$(run_gitpen --hot)
case "$out" in *"run_verdict=ok"*) echo "staged_hot_endurance_runs=yes" ;; *) echo "staged_hot_endurance_runs=no" ;; esac
case "$out" in *"staged_uncommitted=1"*) echo "hot_still_reads_staged=yes" ;; *) echo "hot_still_reads_staged=no" ;; esac

# A guard asked for by name is no lap open, so it runs free over the same dirty index.
out=$(run_gitpen alpha)
case "$out" in *"guards_run=1"*) echo "staged_named_guard_free=yes" ;; *) echo "staged_named_guard_free=no" ;; esac

# The flags compose, which is the whole reason the parser became a loop.
cat > "$gitpen/twotier.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path guard.sh
tier lap
seated 20260825.000000
guard choir
path guard.sh
tier cadence
seated 20260825.000000
EOF
out=$( ( cd "$gitpen" && STANDING_ROSTER=twotier.kyri STANDING_CARD=run-card.kyri \
        sh "$runner" --hot --all 2>/dev/null ) || true )
case "$out" in *"guards_run=2"*) echo "hot_composes_with_all=yes" ;; *) echo "hot_composes_with_all=no" ;; esac


# THE EVIDENCE A RED LEAVES (REDS %266). A verdict with no words behind it cannot be rooted, and
# this tree paid for that when caravan_suite read red under the roster and GREEN alone with the
# record holding nothing to tell the two apart. So a red keeps its guard's own stdout and stderr,
# and a green keeps nothing -- both halves proven here, in a pen, because a proof that plants a row
# in the LIVING roster leaves the run card naming a guard that no longer exists.
cat > "$gitpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
echo "planted guard speaking on stdout"
echo "planted guard speaking on stderr" >&2
exit 1
EOF
chmod +x "$gitpen/rishi/bin/rishi"
rm -rf "$gitpen/construction/standing-equipment-reds"
# `--hot` because an earlier behaviour above left this pen's index dirty, and a cold full-roster
# pass over a dirty index refuses before a single guard runs -- which is the runner working.
out=$( ( cd "$gitpen" && STANDING_ROSTER=quiet.kyri STANDING_CARD=run-card.kyri \
        sh "$runner" --hot 2>/dev/null ) || true )
ev="$gitpen/construction/standing-equipment-reds/alpha.txt"
if [ -f "$ev" ] && grep -q "speaking on stdout" "$ev" && grep -q "speaking on stderr" "$ev"; then
  echo "red_keeps_both_streams=yes"
else
  echo "red_keeps_both_streams=no"
fi
case "$out" in *"evidence construction/standing-equipment-reds/alpha.txt"*) echo "red_names_its_evidence=yes" ;; *) echo "red_names_its_evidence=no" ;; esac

# A green leaves no room at all, and the next run clears whatever the last one left -- so a stale
# file can never be read as this run's verdict.
cat > "$gitpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$gitpen/rishi/bin/rishi"
out=$( ( cd "$gitpen" && STANDING_ROSTER=quiet.kyri STANDING_CARD=run-card.kyri \
        sh "$runner" --hot 2>/dev/null ) || true )
if [ -e "$gitpen/construction/standing-equipment-reds" ]; then
  echo "green_leaves_no_evidence=no"
else
  echo "green_leaves_no_evidence=yes"
fi


# A PASS CLEARS WHAT IT ANSWERED, AND NOTHING ELSE (REDS `20260907.093000`). The room above exists
# to root a guard that reads red under the roster and GREEN alone, and the motion that confirms
# exactly that is a by-name pass on the one guard. While the clear was `rm -rf` on every pass, that
# motion deleted every OTHER guard's words as well -- so the load-bearing case is a by-name pass on
# a peer, which must leave the red guard's evidence standing.
cat > "$gitpen/two.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path guard.sh
tier lap
seated 20260825.000000

guard beta
path guard.sh
tier lap
seated 20260825.000000
EOF
cat > "$gitpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
echo "planted guard speaking on stdout"
exit 1
EOF
chmod +x "$gitpen/rishi/bin/rishi"
run_twopen() {
  ( cd "$gitpen" && STANDING_ROSTER=two.kyri STANDING_CARD=run-card.kyri \
      sh "$runner" "$@" 2>/dev/null ) || true
}
# Seed both files: a full pass over two red guards.
run_twopen --hot >/dev/null
evdir="$gitpen/construction/standing-equipment-reds"
if [ -f "$evdir/alpha.txt" ] && [ -f "$evdir/beta.txt" ]; then
  echo "full_pass_seeds_both=yes"
else
  echo "full_pass_seeds_both=no"
fi

# The load-bearing case: a green by-name pass on beta clears beta and leaves alpha whole.
cat > "$gitpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$gitpen/rishi/bin/rishi"
run_twopen beta >/dev/null
if [ -f "$evdir/alpha.txt" ]; then
  echo "named_pass_keeps_peer_evidence=yes"
else
  echo "named_pass_keeps_peer_evidence=no"
fi
if [ -f "$evdir/beta.txt" ]; then
  echo "named_pass_clears_its_own=no"
else
  echo "named_pass_clears_its_own=yes"
fi

# And a by-name pass that clears the LAST red leaves no room, so a partial green reads the same as
# a full one.
run_twopen alpha >/dev/null
if [ -e "$evdir" ]; then
  echo "named_pass_emptied_room_leaves=no"
else
  echo "named_pass_emptied_room_leaves=yes"
fi


# --- the dead-letter box, proven on its own real repository ------------------------------
# The runner reads `git stash list` on the same line-one pass as the index (REDS %321, and the
# second firing three hours later). This reading NEVER gates -- `fleet_round_open.sh` parks a dirty
# tree there by design -- so the load-bearing case is the one that proves it stays a REPORT: a pass
# with mail in the box still answers `run_verdict=ok`. A reading proven only where it is quiet
# cannot be told from a line that never looked.
stashpen="$pen/stashpen"
mkdir -p "$stashpen/rishi/bin"
( cd "$stashpen" && git init -q . && git config user.email a@b.c && git config user.name t \
  && git config commit.gpgsign false && echo seed > kept.txt && git add kept.txt \
  && git commit -qm "seed" ) >/dev/null 2>&1
cat > "$stashpen/quiet.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path guard.sh
tier lap
seated 20260825.000000
EOF
: > "$stashpen/guard.sh"
cat > "$stashpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$stashpen/rishi/bin/rishi"
( cd "$stashpen" && git add -A && git commit -qm "roster" ) >/dev/null 2>&1

run_stashpen() {
  ( cd "$stashpen" && STANDING_ROSTER=quiet.kyri STANDING_CARD=run-card.kyri \
      sh "$runner" "$@" 2>/dev/null ) || true
}

# The empty box: zero, no detail line, and the pass runs its guard.
out=$(run_stashpen)
case "$out" in *"stashed_entries=0"*) echo "empty_box_reads_zero=yes" ;; *) echo "empty_box_reads_zero=no" ;; esac
case "$out" in *"detail: stash@{"*) echo "empty_box_stays_quiet=no" ;; *) echo "empty_box_stays_quiet=yes" ;; esac
case "$out" in *"run_verdict=ok"*) echo "empty_box_passes=yes" ;; *) echo "empty_box_passes=no" ;; esac

# One piece of mail: counted, named by its own message, and sized by its file count -- because a
# bare number is exactly what %321 already had and nobody opened.
#
# BOTH PLANTED FILES ARE UNTRACKED, and that is the needle rather than a convenience. `git stash
# show --name-only` omits untracked files, while `fleet_round_open.sh` stashes with `-u`, so a lap
# whose leavings are all NEW files -- a fresh scan, a fresh witness, fresh fixtures, which is
# exactly what %321 lost -- reads `0 files` and looks like an empty envelope. Drop
# `--include-untracked` from the runner and this case reads 0 and bites (REDS %328).
# The run card the pass above wrote is untracked, and `git stash push -u` would sweep it in, so the
# stash would hold three files where the case is about two. Removed first, so the count this reads
# is the count the case plants rather than a leftover of the reading before it.
( cd "$stashpen" && rm -f run-card.kyri \
  && echo unsent > work_one.txt && echo unsent > work_two.txt \
  && git stash push -u -q -m "a lap's unsent work" ) >/dev/null 2>&1
out=$(run_stashpen)
case "$out" in *"stashed_entries=1"*) echo "one_letter_counted=yes" ;; *) echo "one_letter_counted=no" ;; esac
case "$out" in *"a lap's unsent work"*) echo "one_letter_named=yes" ;; *) echo "one_letter_named=no" ;; esac
case "$out" in *"stash@{0} 2 files"*) echo "one_letter_sized=yes" ;; *) echo "one_letter_sized=no" ;; esac
# THE LOAD-BEARING CASE: mail in the box is reported and never refused.
case "$out" in *"run_verdict=ok"*) echo "full_box_still_passes=yes" ;; *) echo "full_box_still_passes=no" ;; esac
case "$out" in *"guards_run=1"*) echo "full_box_still_runs_guards=yes" ;; *) echo "full_box_still_runs_guards=no" ;; esac

# The enumeration bound, from both sides. Sixteen entries are all named; the seventeenth pushes the
# count past `max_stash_entries` and the overflow says so on its own line rather than vanishing.
i=2
while [ "$i" -le 16 ]; do
  ( cd "$stashpen" && echo "$i" > "filler_$i.txt" && git stash push -u -q -m "filler $i" ) >/dev/null 2>&1
  i=$((i + 1))
done
out=$(run_stashpen)
case "$out" in *"stashed_entries=16"*) echo "bound_at_sixteen_counted=yes" ;; *) echo "bound_at_sixteen_counted=no" ;; esac
case "$out" in *"unenumerated"*) echo "bound_at_sixteen_no_overflow=no" ;; *) echo "bound_at_sixteen_no_overflow=yes" ;; esac
case "$out" in *"stash@{15} "*) echo "bound_at_sixteen_names_last=yes" ;; *) echo "bound_at_sixteen_names_last=no" ;; esac

( cd "$stashpen" && echo 17 > filler_17.txt && git stash push -u -q -m "filler 17" ) >/dev/null 2>&1
out=$(run_stashpen)
case "$out" in *"stashed_entries=17"*) echo "past_bound_counted=yes" ;; *) echo "past_bound_counted=no" ;; esac
case "$out" in *"1 further entries unenumerated"*) echo "past_bound_says_so=yes" ;; *) echo "past_bound_says_so=no" ;; esac
case "$out" in *"stash@{16} "*) echo "past_bound_stops_enumerating=no" ;; *) echo "past_bound_stops_enumerating=yes" ;; esac
case "$out" in *"run_verdict=ok"*) echo "past_bound_still_passes=yes" ;; *) echo "past_bound_still_passes=no" ;; esac

# --- the capability tier, proven in all three of its answers ------------------------------------
# `capability` is a tier for what a host CAN DO, beside `host` (a tier for PLACE) and `tier` (a tier
# for TIME). Its probe returns present, absent, or unknown, and the third answer is the one that
# decides whether the field is a cadence or an exemption -- so all three are planted here.
#
# HOW ABSENCE IS PLANTED, without putting an override into the runner. The probe reads the host's
# own loopback interface through `ip` and `ifconfig`, so the control shadows those two commands on
# PATH and hands the probe a fake host. Nothing in the runner learns it is being tested, and there
# is no environment variable that turns the field off -- a gate with a door beside it is a habit
# again, and this control would be the one holding the door.
mkdir -p "$pen/fakebin"
cat > "$pen/fakebin/ip" <<'EOF'
#!/bin/sh
exit 1
EOF
chmod +x "$pen/fakebin/ip"

cat > "$pen/capable.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
seated 20260822.000000

guard needs_six
path tools/real_witness.rish
tier lap
capability ipv6
seated 20260829.000000
EOF

run_capability() {
  # $1 -- what the fake ifconfig says; every argument after it goes to the runner. The shift is
  # load-bearing: without it the stub's own body arrives as a guard name and every case reads a
  # one-guard pass, which is what the first draft of this block did.
  _lo_says="$1"
  shift
  cat > "$pen/fakebin/ifconfig" <<EOF
#!/bin/sh
$_lo_says
EOF
  chmod +x "$pen/fakebin/ifconfig"
  rm -f "$pen/cap-card.kyri"
  ( cd "$pen" && PATH="$pen/fakebin:$PATH" STANDING_ROSTER=capable.kyri STANDING_CARD=cap-card.kyri \
      sh "$runner" "$@" 2>/dev/null ) || true
}

# present -- the host keeps the promise, so the guard runs like any other row
out=$(run_capability 'echo "inet6 ::1 prefixlen 128"')
case "$out" in *"guards_run=2"*) echo "capability_present_runs=yes" ;; *) echo "capability_present_runs=no" ;; esac
case "$out" in *"skipped_capability=0"*) echo "capability_present_skips_none=yes" ;; *) echo "capability_present_skips_none=no" ;; esac

# absent -- the guard is skipped, and NAMED, and counted. All three, because a skip nobody can read
# is the exemption this field exists not to be.
out=$(run_capability 'echo "inet 127.0.0.1 netmask 0xff000000"')
case "$out" in *"guards_run=1"*) echo "capability_absent_skips=yes" ;; *) echo "capability_absent_skips=no" ;; esac
case "$out" in *"skipped_capability=1"*) echo "capability_absent_counted=yes" ;; *) echo "capability_absent_counted=no" ;; esac
case "$out" in *"skipped_capability needs_six wants=ipv6"*) echo "capability_absent_named=yes" ;; *) echo "capability_absent_named=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "capability_absent_still_passes=yes" ;; *) echo "capability_absent_still_passes=no" ;; esac
if grep -q "^ran alpha " "$pen/cap-card.kyri" && ! grep -q "^ran needs_six " "$pen/cap-card.kyri"; then
  echo "capability_absent_card_silent=yes"
else
  echo "capability_absent_card_silent=no"
fi

# unknown -- the probe could read nothing, and the guard RUNS. This is the safety direction: a bench
# whose probe tools go missing must not quietly thin its own roster to nothing while reading green.
out=$(run_capability 'exit 1')
case "$out" in *"guards_run=2"*) echo "capability_unknown_runs=yes" ;; *) echo "capability_unknown_runs=no" ;; esac
case "$out" in *"skipped_capability=0"*) echo "capability_unknown_skips_none=yes" ;; *) echo "capability_unknown_skips_none=no" ;; esac

# a hand asking for the guard BY NAME runs it wherever it stands, so the refusal that follows names
# the real absence rather than this filter -- the same escape `host` already keeps.
out=$(run_capability 'echo "inet 127.0.0.1 netmask 0xff000000"' needs_six)
case "$out" in *"guards_run=1"*) echo "capability_by_name_runs=yes" ;; *) echo "capability_by_name_runs=no" ;; esac
case "$out" in *"skipped_capability=0"*) echo "capability_by_name_unfiltered=yes" ;; *) echo "capability_by_name_unfiltered=no" ;; esac

# a capability the probe has never heard of reads unknown and therefore RUNS. The scan is what
# refuses that roster; the runner's job is to never make a guard vanish.
cat > "$pen/badcap-roster.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
capability telepathy
seated 20260829.000000
EOF
out=$( ( cd "$pen" && PATH="$pen/fakebin:$PATH" STANDING_ROSTER=badcap-roster.kyri STANDING_CARD=badcap-card.kyri \
        sh "$runner" 2>/dev/null ) || true )
case "$out" in *"guards_run=1"*) echo "unknown_capability_still_runs=yes" ;; *) echo "unknown_capability_still_runs=no" ;; esac

# --- and the scan refuses that same roster, which is the half the runner deliberately does not ---
out=$(run_scan badcap-roster.kyri good-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "unknown_capability_refused=yes" ;; *) echo "unknown_capability_refused=no" ;; esac
case "$out" in *"guards_unknown_capability=1"*) echo "unknown_capability_counted=yes" ;; *) echo "unknown_capability_counted=no" ;; esac
out=$(run_scan capable.kyri good-card.kyri)
case "$out" in *"guards_capability_gated=1"*) echo "capability_gated_counted=yes" ;; *) echo "capability_gated_counted=no" ;; esac
case "$out" in *"guards_unknown_capability=0"*) echo "known_capability_free=yes" ;; *) echo "known_capability_free=no" ;; esac

# --- the seed_projection probe, planted in all four of its refusals (REDS %492, widened here) ----
# The second capability arm this tree probes, and the first that asks a CHECKOUT question rather
# than a host one: does a seed projection stand where `sow_allow_reach` reads the shipped side.
#
# THE ELDER PLANT WAS A BARE DIRECTORY, because the elder probe was a bare `test -d`. Both were one
# question where the guard asks four: `tools/fixtures/s/sow_allow_reach_scan.sh` refuses with no
# directory, with no receipt at `$SEED/.sow-projection.log`, with a receipt naming no inputs, and
# with a receipt whose coverage inputs have MOVED. The fourth is the one that fires -- the receipt
# hashes the manifest together with `git ls-files` over every `allow` room, `tools` is one of them,
# and 12 of the 40 commits before `20260909.215500` changed a tracked path under one. So the guard
# read `red` across an eight-ship pier for an environment fact, and the receipt was withheld.
#
# Each refusal is planted and then LIFTED, since a probe shown only in the refusing direction cannot
# be told from one that refuses everything.
cat > "$pen/seedcap.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
seated 20260822.000000

guard needs_seed
path tools/real_witness.rish
tier lap
capability seed_projection
seated 20260906.140000
EOF

# A REAL FIELD, since the coverage reading calls `git ls-files` and `git hash-object` and a probe
# proven outside a repository would be proven against its own `unknown` arm rather than its answer.
reach="$(pwd)/tools/fixtures/s/sow_reach_inputs.sh"
seedpen="$pen/seedtree"
mkdir -p "$seedpen/tools" "$seedpen/seed"
cp "$pen/seedcap.kyri" "$seedpen/seedcap.kyri"
cp "$pen/tools/real_witness.rish" "$seedpen/tools/real_witness.rish"
( cd "$seedpen" \
    && git init -q . && git config user.email a@b.c && git config user.name t \
    && printf 'allow tools\n' > template-manifest.bron \
    && git add -A >/dev/null && git commit -q -m "pen: a field with one allowed room" ) >/dev/null 2>&1
project() { ( cd "$seedpen" && . "$reach" && sow_reach_inputs template-manifest.bron ) ; }

run_seed_in() { # run_seed_in <cwd> [env-assignment...]
  _cwd=$1; shift
  rm -f "$_cwd/seed-card.kyri"
  ( cd "$_cwd" && env "$@" STANDING_ROSTER=seedcap.kyri STANDING_CARD=seed-card.kyri \
      sh "$runner" 2>/dev/null ) || true
}
ran_both() { case "$1" in *"guards_run=2"*) echo yes ;; *) echo no ;; esac; }
skipped_one() { case "$1" in *"skipped_capability=1"*) echo yes ;; *) echo no ;; esac; }

# 1. A BARE DIRECTORY, which is what the elder plant and the elder probe both stopped at.
out=$(run_seed_in "$seedpen")
echo "seed_bare_directory_refused=$(skipped_one "$out")"

# 2. A RECEIPT NAMING NOTHING. An empty file is a projection that answers no coverage question.
: > "$seedpen/seed/.sow-projection.log"
out=$(run_seed_in "$seedpen")
echo "seed_empty_receipt_refused=$(skipped_one "$out")"

# 3. A FRESH RECEIPT -- the lift. The guard runs like any other row and nothing is skipped.
project > "$seedpen/seed/.sow-projection.log"
out=$(run_seed_in "$seedpen")
fresh_red=$(printf '%s\n' "$out" | sed -n 's/^guards_red=//p')
echo "seed_fresh_runs=$(ran_both "$out")"
# invariant: the witness has asserted this name since REDS %492 and it means the same thing --
# a checkout whose projection the guard can read runs the guard.
echo "seed_present_runs=$(ran_both "$out")"
echo "seed_present_skips_none=$(case "$out" in *"skipped_capability=0"*) echo yes ;; *) echo no ;; esac)"
case "$out" in *"skipped_capability=0"*) echo "seed_fresh_skips_none=yes" ;; *) echo "seed_fresh_skips_none=no" ;; esac

# 4. THE STALE RECEIPT, and the whole reason this arm was widened. One new tracked path under the
#    one allowed room -- the ordinary shape of a lap that lands a tool -- moves the inventory hash
#    the receipt is pinned to, and the projection can no longer answer for the field it names.
( cd "$seedpen" && printf '# a tool that landed after the projection\n' > tools/later.rish \
    && git add -A >/dev/null && git commit -q -m "pen: a lap lands a tool" ) >/dev/null 2>&1
out=$(run_seed_in "$seedpen")
echo "seed_stale_receipt_refused=$(skipped_one "$out")"
case "$out" in *"skipped_capability needs_seed wants=seed_projection"*) echo "seed_stale_named=yes" ;; *) echo "seed_stale_named=no" ;; esac
# A SKIP ADDS NO RED, which is the claim rather than the pen's own verdict: the pen's `alpha` row
# points at a stub, so a git pen reds it either way, and asserting `run_verdict=ok` here would be
# asserting something about the stub.
stale_red=$(printf '%s\n' "$out" | sed -n 's/^guards_red=//p')
case "${fresh_red:-9}:${stale_red:-9}" in 2:1) echo "seed_stale_adds_no_red=yes" ;; *) echo "seed_stale_adds_no_red=no (fresh=${fresh_red:-?} stale=${stale_red:-?})" ;; esac

# 5. THE ELDER PROBE OVER THE SAME STALE PLANT, which must call it present -- otherwise the four
#    legs above pass for some reason other than this repair, which is the shape four of this
#    family's wrong readings had in common.
if [ -d "$seedpen/seed" ]; then elder_seed=present; else elder_seed=absent; fi
echo "elder_probe_called_the_stale_one_present=$elder_seed"

# 6. RE-PROJECTED, and the guard comes back. A capability that never lifts is an exemption.
project > "$seedpen/seed/.sow-projection.log"
out=$(run_seed_in "$seedpen")
echo "seed_reprojected_runs_again=$(ran_both "$out")"

# 7. ABSENT -- skipped, named, counted, and the pass still passes. All four, because the whole point
#    is that a fresh clone with no projection stops paying a full cold endurance run for an environment fact.
mkdir -p "$pen/seed" && rmdir "$pen/seed"
out=$(run_seed_in "$pen")
case "$out" in *"guards_run=1"*) echo "seed_absent_skips=yes" ;; *) echo "seed_absent_skips=no" ;; esac
case "$out" in *"skipped_capability=1"*) echo "seed_absent_counted=yes" ;; *) echo "seed_absent_counted=no" ;; esac
case "$out" in *"skipped_capability needs_seed wants=seed_projection"*) echo "seed_absent_named=yes" ;; *) echo "seed_absent_named=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "seed_absent_still_passes=yes" ;; *) echo "seed_absent_still_passes=no" ;; esac

# 8. The probe reads SOW_SEED exactly as the guard's own scan does, so the two cannot disagree about
#    where the projection is. Planted somewhere else entirely, FRESH, with nothing at the default
#    path -- a bare directory there would now prove the widening rather than the environment read.
mkdir -p "$seedpen/elsewhere"
project > "$seedpen/elsewhere/.sow-projection.log"
out=$(run_seed_in "$seedpen" SOW_SEED=elsewhere)
case "$out" in *"guards_run=2"*) echo "seed_env_followed=yes" ;; *) echo "seed_env_followed=no" ;; esac
rm -rf "$seedpen/elsewhere"

# --- the jail_nesting probe, planted in all three answers (REDS %516) ---------------------------
# The third capability arm, and the first that asks a KERNEL question: can this bench build a second
# mount namespace, which is what each of `agent_jail_enclosure`'s four legs needs before it can
# start. Planted by shadowing `bwrap` on PATH, since the arm resolves the tool with `command -v` and
# a plant that skipped that step would prove a shorter function than the one that ships.
#
# WHY THIS ARM EARNED ITS OWN BLOCK RATHER THAN RIDING THE ipv6 ONE. The tier machinery above is
# proven with `ipv6`, and that proves the RUNNER. It says nothing about whether a particular arm
# answers the question its name claims -- and `jail_nesting` did not: it handed bwrap `/bin/true`,
# which NixOS does not ship, so bwrap built the namespace, failed to exec, exited non-zero, and was
# read as a refused namespace on the one bench where the guard's legs actually pass.
cat > "$pen/jailcap.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
seated 20260822.000000

guard needs_jail
path tools/real_witness.rish
tier lap
capability jail_nesting
seated 20260906.000000
EOF

plant_bwrap() {
  # A real executable rather than a variable, because the arm resolves the tool with `command -v`.
  printf '%s\n%s\n' '#!/bin/sh' "$1" > "$pen/fakebin/bwrap"
  chmod +x "$pen/fakebin/bwrap"
}
run_jail_capability() {
  rm -f "$pen/jail-card.kyri"
  ( cd "$pen" && PATH="$1" STANDING_ROSTER=jailcap.kyri STANDING_CARD=jail-card.kyri \
      sh "$runner" 2>/dev/null ) || true
}

# present -- a bwrap that builds the namespace, so the guard runs like any other row.
plant_bwrap 'exit 0'
out=$(run_jail_capability "$pen/fakebin:$PATH")
case "$out" in *"guards_run=2"*) echo "jail_present_runs=yes" ;; *) echo "jail_present_runs=no" ;; esac
case "$out" in *"skipped_capability=0"*) echo "jail_present_skips_none=yes" ;; *) echo "jail_present_skips_none=no" ;; esac

# absent -- the kernel refusing the second wrapper, which is the line every jailed ship reads. The
# wording is the one this pier actually printed when bwrap was nested inside bwrap, measured rather
# than recalled; the arm reads the exit status rather than the words, so the words are here for the
# next reader instead of for the code.
plant_bwrap 'echo "bwrap: setting up uid map: Read-only file system" >&2; exit 1'
out=$(run_jail_capability "$pen/fakebin:$PATH")
case "$out" in *"guards_run=1"*) echo "jail_refused_skips=yes" ;; *) echo "jail_refused_skips=no" ;; esac
case "$out" in *"skipped_capability=1"*) echo "jail_refused_counted=yes" ;; *) echo "jail_refused_counted=no" ;; esac
case "$out" in *"skipped_capability needs_jail wants=jail_nesting"*) echo "jail_refused_named=yes" ;; *) echo "jail_refused_named=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "jail_refused_still_passes=yes" ;; *) echo "jail_refused_still_passes=no" ;; esac

# THE RESIDUE, pinned so the next hand moves it on purpose. The arm reads bwrap's exit status
# rather than its words, so a failure that is not a refused namespace -- an unsupported flag, a
# broken install, the execvp message `/bin/true` produced here -- still reads `absent` and still
# skips. This leg does NOT reproduce REDS %516: a planted bwrap never execs anything, so the missing
# payload is unreachable from this side and is proven at the source instead, two legs below. What it
# fixes is the residue's value, so a later wording table changes this reading rather than sliding
# past it.
plant_bwrap 'echo "bwrap: execvp /bin/true: No such file or directory" >&2; exit 1'
out=$(run_jail_capability "$pen/fakebin:$PATH")
case "$out" in *"guards_run=1"*) echo "jail_unrecognized_failure_skips=yes" ;; *) echo "jail_unrecognized_failure_skips=no" ;; esac

# unknown -- no bwrap at all. A pier without bubblewrap cannot run `agent-jail.sh` either, so this
# must NOT skip: the guard runs and reds honestly rather than vanishing, which is the safety
# direction the whole capability field rests on.
#
# HOW ABSENCE OF THE TOOL IS PLANTED. `command -v` finds any executable anywhere on PATH, so
# shadowing cannot hide one -- the pen must be a PATH that genuinely holds no `bwrap`. Dropping the
# directories that carry it is not available here: this pier keeps `bwrap` and `sh` in the same
# directory, so dropping it takes the shell with it. A pen of symlinks to every tool but that one is
# the shape that works, and it is bounded -- a PATH past `max_pen_links` entries means something
# stranger than a test bench, and the leg says so rather than building forever.
max_pen_links=8192
mkdir -p "$pen/nobwrap"
pen_links=0
_oldifs=$IFS
IFS=:
for _d in $PATH; do
  [ -d "$_d" ] || continue
  for _f in "$_d"/*; do
    _b=${_f##*/}
    [ "$_b" = bwrap ] && continue
    [ "$_b" = '*' ] && continue
    [ -e "$pen/nobwrap/$_b" ] && continue
    pen_links=$((pen_links + 1))
    [ "$pen_links" -gt "$max_pen_links" ] && break
    ln -s "$_f" "$pen/nobwrap/$_b" 2>/dev/null || true
  done
done
IFS=$_oldifs
if [ "$pen_links" -le "$max_pen_links" ] && ! ( PATH="$pen/nobwrap"; export PATH; command -v bwrap >/dev/null 2>&1 ); then
  echo "jail_pen_hides_bwrap=yes"
else
  echo "jail_pen_hides_bwrap=no"
fi
out=$(run_jail_capability "$pen/nobwrap")
case "$out" in *"guards_run=2"*) echo "jail_missing_runs=yes" ;; *) echo "jail_missing_runs=no" ;; esac
case "$out" in *"skipped_capability=0"*) echo "jail_missing_skips_none=yes" ;; *) echo "jail_missing_skips_none=no" ;; esac
# THE PEN PROVEN INNOCENT. A PATH missing some tool the runner needs would print no guard line at
# all, and the two readings above would then answer for a reason that has nothing to do with bwrap.
case "$out" in *"alpha green"*) echo "jail_pen_runner_ran=yes" ;; *) echo "jail_pen_runner_ran=no" ;; esac
rm -f "$pen/fakebin/bwrap"

# --- and the arm's payload must exist where the probe runs --------------------------------------
# The leg that would have caught this on the day. The three plants above prove what the runner DOES
# with each answer; they cannot prove the arm asks its question of a real program, because a fake
# bwrap never execs anything. So the payload is read off the runner's own source and executed here:
# a path this bench does not carry makes every real bwrap attempt exit non-zero for a reason that is
# not the namespace. A pattern matching nothing reports broken rather than passing, since a control
# that quietly stops reading is the failure it exists to prevent.
jail_payload=$(sed -n 's/^ *if bwrap --ro-bind \/ \/ --dev \/dev \([^ ]*\) .*/\1/p' "$runner" | head -1)
if [ -z "$jail_payload" ]; then
  echo "jail_payload_read=no"
else
  echo "jail_payload_read=yes"
  if [ -x "$jail_payload" ]; then echo "jail_payload_exists=yes"; else echo "jail_payload_exists=no"; fi
fi
# and the arm proves that payload outside the wrapper before it blames the wrapper, so a bench
# lacking it answers unknown rather than absent. Asserted against the source, because the plants
# above cannot reach a step that runs before bwrap is ever called.
if grep -q '^ *\/bin\/sh -c : >\/dev\/null 2>&1 || { echo unknown; return 0; }' "$runner"; then
  echo "jail_payload_proven_outside=yes"
else
  echo "jail_payload_proven_outside=no"
fi

# --- the day_shelf probe, planted in both of its answers ----------------------------------------
# The fourth capability arm, and the first that asks a CALENDAR question rather than one about the
# host, the checkout, or the kernel: does the day this pass stands in have a shelf with tracked logs
# in it? `rota_declared` counts how many of TODAY's session logs declare the rota row they read, so
# before the day's first log lands there is nothing to count and its scan refuses (REDS %170).
# Rostered without a capability it reddened the fleet's first cold endurance run of every day -- and a red
# guard withholds the roster receipt, so every ship then paid a FULL pass for a fact about the clock.
#
# PLANTED IN A REAL GIT REPOSITORY, because the probe asks git the same `ls-files` its guard asks. A
# shelf holding an UNTRACKED log is exactly the state a filesystem-only probe would call present
# while its guard refused, so both halves of the guard's precondition are planted apart: no shelf at
# all, a shelf whose only log is untracked, and a shelf carrying a tracked one. `ROTA_DAY` is read by
# probe and scan alike, which is what keeps the two asking one question.
daypen="$pen/daypen"
mkdir -p "$daypen/tools" "$daypen/rishi/bin"
echo "# a standing guard, for the control only" > "$daypen/tools/real_witness.rish"
# The same stand-in rishi the shared pen carries above: the runner invokes a guard through it, so a
# pen without one answers `alpha red` and every count below would then read for the wrong reason.
printf '#!/bin/sh\nexit 0\n' > "$daypen/rishi/bin/rishi"
chmod +x "$daypen/rishi/bin/rishi"
cat > "$daypen/daycap.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
seated 20260822.000000

guard needs_day
path tools/real_witness.rish
tier lap
capability day_shelf
seated 20260907.003211
EOF
( cd "$daypen" && git init -q . && git config user.email a@b.c && git config user.name t \
  && git config commit.gpgsign false ) >/dev/null 2>&1

run_day_capability() {
  rm -f "$daypen/day-card.kyri"
  ( cd "$daypen" && ROTA_DAY=20260101 STANDING_ROSTER=daycap.kyri STANDING_CARD=day-card.kyri \
      sh "$runner" 2>/dev/null ) || true
}

# absent -- no shelf for that day at all, which is the state of every day between midnight and its
# first landing. Skipped, named, counted, and the pass still passes: all four, because the whole
# point is that a day which has not started yet stops costing the fleet a full cold endurance run.
out=$(run_day_capability)
case "$out" in *"guards_run=1"*) echo "day_absent_skips=yes" ;; *) echo "day_absent_skips=no" ;; esac
case "$out" in *"skipped_capability=1"*) echo "day_absent_counted=yes" ;; *) echo "day_absent_counted=no" ;; esac
case "$out" in *"skipped_capability needs_day wants=day_shelf"*) echo "day_absent_named=yes" ;; *) echo "day_absent_named=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "day_absent_still_passes=yes" ;; *) echo "day_absent_still_passes=no" ;; esac

# absent, THE SECOND HALF -- the shelf stands and its only log is untracked. The guard's own scan
# reads `git ls-files` and refuses here, so a probe answering on the directory alone would call this
# present and hand its guard a refusal it had just promised would not come.
mkdir -p "$daypen/session-logs/date/20260101"
printf 'stamp 20260101.010101\n' > "$daypen/session-logs/date/20260101/20260101-010101_a.kyri"
out=$(run_day_capability)
case "$out" in *"skipped_capability=1"*) echo "day_untracked_skips=yes" ;; *) echo "day_untracked_skips=no" ;; esac

# present -- the same log, committed. The guard runs like any other row. Committed rather than left
# staged on purpose: a cold endurance run over a dirty index refuses under `lap_unclosed`, and this leg would
# then read absent for a reason that has nothing to do with the shelf.
( cd "$daypen" && git add -A && git commit -q -m "pen: the day's first log lands" ) >/dev/null 2>&1
out=$(run_day_capability)
case "$out" in *"guards_run=2"*) echo "day_present_runs=yes" ;; *) echo "day_present_runs=no" ;; esac
case "$out" in *"skipped_capability=0"*) echo "day_present_skips_none=yes" ;; *) echo "day_present_skips_none=no" ;; esac

# THE PEN PROVEN INNOCENT, the reading the jail arm takes above: a pen where the runner never ran at
# all would answer these counts for a reason that has nothing to do with the calendar.
case "$out" in *"alpha green"*) echo "day_pen_runner_ran=yes" ;; *) echo "day_pen_runner_ran=no" ;; esac

# unknown -- git itself gone. It cannot be planted the way a missing bwrap can: the runner reads the
# stash, the index and the tree with git, so a PATH without it answers for a reason that is not the
# probe. Asserted against the source instead, exactly as the jail arm asserts its own pre-check.
# Unknown RUNS, so a bench whose probe tool went missing keeps its guard rather than quietly thinning
# the roster while every meter reads green.
if grep -q 'command -v git >/dev/null 2>&1 || { echo unknown; return 0; }' "$runner"; then
  echo "day_unknown_runs_on_missing_git=yes"
else
  echo "day_unknown_runs_on_missing_git=no"
fi

# and the scan counts a day_shelf row as gated rather than refusing it, because it reads the
# capability words off the runner's own `capability_state()` arms rather than keeping a second list
# beside them -- the drift REDS %493's arm names and this one inherits for free.
cat > "$pen/dayscan.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
capability day_shelf
seated 20260907.003211
EOF
out=$(run_scan dayscan.kyri good-card.kyri)
case "$out" in *"guards_unknown_capability=0"*) echo "day_capability_known_to_scan=yes" ;; *) echo "day_capability_known_to_scan=no" ;; esac

# A GUARD THIS HOST CANNOT RUN LOSES ITS ELDER CARD ROW (REDS %492, second half). The carry-forward
# keeps a `tier cadence` guard's history between its runs, which is right; it is wrong for a guard
# that cannot run here at all, whose last verdict was recorded in a different world and which nothing
# will ever overwrite. `sow_allow_reach` taught it inside one lap: red on the cold endurance run for a missing
# `seed/`, given its capability in the same lap, and its red then stood on the card permanently.
# Planted as a stale RED, because that is the direction that costs -- the roster's own guard counts
# card reds, so an immortal one reds the fleet forever.
printf 'format standing-equipment-runs-v1\nran alpha 20260101.000000 green lap 1\nran needs_seed 20260101.000000 red lap 1\n' > "$pen/stale-card.kyri"
( cd "$pen" && STANDING_ROSTER=seedcap.kyri STANDING_CARD=stale-card.kyri sh "$runner" >/dev/null 2>&1 ) || true
if grep -q '^ran needs_seed ' "$pen/stale-card.kyri"; then
  echo "unrunnable_card_row_dropped=no"
else
  echo "unrunnable_card_row_dropped=yes"
fi
if grep -q '^ran alpha ' "$pen/stale-card.kyri"; then
  echo "runnable_card_row_kept=yes"
else
  echo "runnable_card_row_kept=no"
fi

# and the scan counts the row as gated rather than refusing it, since the runner knows the word
out=$(run_scan seedcap.kyri good-card.kyri)
case "$out" in *"guards_unknown_capability=0"*) echo "seed_capability_known_to_scan=yes" ;; *) echo "seed_capability_known_to_scan=no" ;; esac

# --- the tigerbeetle_clone probe, planted in both of its answers --------------------------------
# The sixth capability arm, and the first that asks about a READING LIBRARY. `gratitude/tigerbeetle`
# is a gitlink the gratitude-licenses rule says we study and never copy, so a correct clone may hold
# it empty forever -- and twenty-two census witnesses read its `src/` and red beneath it, which is
# why every one of them stood unrostered rather than turning a study nobody must fetch into every
# body's red lap.
#
# Planted by making and removing the directory, exactly as `seed_projection` is, because the probe
# performs the same `test -d gratitude/tigerbeetle/src` the guards' own asserts perform, character
# for character. A probe asking git about the gitlink instead would answer a DIFFERENT question:
# a submodule declared and never added carries no gitlink, and an initialised gitlink whose
# directory is empty is exactly what the witnesses find. There is no unknown answer to plant --
# `test -d` has no tool that can go missing, which is written into the arm rather than faked here.
cat > "$pen/tbcap.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
seated 20260822.000000

guard needs_clone
path tools/real_witness.rish
tier lap
capability tigerbeetle_clone
seated 20260908.000000
EOF

run_tb_capability() {
  rm -f "$pen/tb-card.kyri"
  ( cd "$pen" && STANDING_ROSTER=tbcap.kyri STANDING_CARD=tb-card.kyri \
      sh "$runner" 2>/dev/null ) || true
}

# present -- the held clone stands, so the guard runs like any other row
mkdir -p "$pen/gratitude/tigerbeetle/src"
out=$(run_tb_capability)
case "$out" in *"guards_run=2"*) echo "tb_present_runs=yes" ;; *) echo "tb_present_runs=no" ;; esac
case "$out" in *"skipped_capability=0"*) echo "tb_present_skips_none=yes" ;; *) echo "tb_present_skips_none=no" ;; esac

# absent -- skipped, named, counted, and the pass still passes. All four, because the point is that
# a clone which studies rather than fetches stops reading an environment fact as a fault.
rm -rf "$pen/gratitude"
out=$(run_tb_capability)
case "$out" in *"guards_run=1"*) echo "tb_absent_skips=yes" ;; *) echo "tb_absent_skips=no" ;; esac
case "$out" in *"skipped_capability=1"*) echo "tb_absent_counted=yes" ;; *) echo "tb_absent_counted=no" ;; esac
case "$out" in *"skipped_capability needs_clone wants=tigerbeetle_clone"*) echo "tb_absent_named=yes" ;; *) echo "tb_absent_named=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "tb_absent_still_passes=yes" ;; *) echo "tb_absent_still_passes=no" ;; esac

# an EMPTY gitlink is absence, which is the whole state this arm exists to read: the directory the
# submodule hangs from stands, and `src/` does not. A probe testing the parent would read present
# here and skip nothing, which is the fault this leg is planted to refuse.
mkdir -p "$pen/gratitude/tigerbeetle"
out=$(run_tb_capability)
case "$out" in *"guards_run=1"*) echo "tb_empty_gitlink_absent=yes" ;; *) echo "tb_empty_gitlink_absent=no" ;; esac
rm -rf "$pen/gratitude"

# and the scan counts the row as gated rather than refusing it, since the runner knows the word
out=$(run_scan tbcap.kyri good-card.kyri)
case "$out" in *"guards_unknown_capability=0"*) echo "tb_capability_known_to_scan=yes" ;; *) echo "tb_capability_known_to_scan=no" ;; esac
case "$out" in *"guards_capability_gated=1"*) echo "tb_capability_gated_counted=yes" ;; *) echo "tb_capability_gated_counted=no" ;; esac

# --- the host tier, which arrived at REDS %295 with no case of its own --------------------------
# Found while seating the capability field beside it: `host` was proven by neither this control nor
# the witness, so the axis it copies had no green side and no red one. Its two answers are planted
# here now, against the host this pass actually stands on, so neither axis is taken on trust.
here_host=$(uname -s)
case "$here_host" in
  Darwin) mine=macos; theirs=linux ;;
  Linux)  mine=linux;  theirs=macos ;;
  *)      mine=other;  theirs=linux ;;
esac
cat > "$pen/hosted.kyri" <<EOF
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
seated 20260822.000000

guard elsewhere
path tools/real_witness.rish
tier lap
host $theirs
seated 20260828.000000
EOF
out=$( ( cd "$pen" && STANDING_ROSTER=hosted.kyri STANDING_CARD=host-card.kyri \
        sh "$runner" 2>/dev/null ) || true )
case "$out" in *"guards_run=1"*) echo "host_elsewhere_skips=yes" ;; *) echo "host_elsewhere_skips=no" ;; esac
case "$out" in *"skipped_host=1"*) echo "host_elsewhere_counted=yes" ;; *) echo "host_elsewhere_counted=no" ;; esac
case "$out" in *"skipped_host elsewhere wants=$theirs"*) echo "host_elsewhere_named=yes" ;; *) echo "host_elsewhere_named=no" ;; esac

cat > "$pen/hosted-here.kyri" <<EOF
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
host $mine
seated 20260828.000000
EOF
out=$( ( cd "$pen" && STANDING_ROSTER=hosted-here.kyri STANDING_CARD=host-here-card.kyri \
        sh "$runner" 2>/dev/null ) || true )
case "$out" in *"guards_run=1"*) echo "host_here_runs=yes" ;; *) echo "host_here_runs=no" ;; esac
case "$out" in *"skipped_host=0"*) echo "host_here_skips_none=yes" ;; *) echo "host_here_skips_none=no" ;; esac

cat > "$pen/badhost.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
tier lap
host solaris
seated 20260828.000000
EOF
out=$(run_scan badhost.kyri good-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "unknown_host_refused=yes" ;; *) echo "unknown_host_refused=no" ;; esac
case "$out" in *"guards_unknown_host=1"*) echo "unknown_host_counted=yes" ;; *) echo "unknown_host_counted=no" ;; esac

# A pen outside git answers zero rather than refusing -- the same shape the staged reading keeps,
# so a control can drive this runner without standing inside a repository.
out=$( ( cd "$pen" && STANDING_ROSTER=cadence.kyri STANDING_CARD=run-card.kyri \
        sh "$runner" 2>/dev/null ) || true )
case "$out" in *"stashed_entries=0"*) echo "nogit_box_reads_zero=yes" ;; *) echo "nogit_box_reads_zero=no" ;; esac

# THE SCOPED PASS, proven from both sides (the fusion build, 20260829). A fresh git pen with a
# seed commit, a stub rishi, a one-guard roster, and a pen-local map naming what alpha watches.
# The receipt basis is written by a FULL run first; then a watched edit must RUN the guard, an
# unwatched edit must SKIP it by name, an unmapped guard must always run, a scoped close must
# WITHHOLD the receipt, and a missing basis must refuse the mode outright.
scopepen="$pen/scopepen"
mkdir -p "$scopepen/rishi/bin"
( cd "$scopepen" && git init -q . && git config user.email a@b.c && git config user.name t \
  && git config commit.gpgsign false && echo seed > watched.txt && echo seed > other.txt \
  && git add watched.txt other.txt && git commit -qm "seed" ) >/dev/null 2>&1
cat > "$scopepen/roster.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path guard.sh
tier lap
seated 20260829.000000
EOF
: > "$scopepen/guard.sh"
cat > "$scopepen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$scopepen/rishi/bin/rishi"
cat > "$scopepen/map.sh" <<'EOF'
#!/bin/sh
echo "alpha watched.txt guard.sh roster.kyri"
EOF
# The scaffolding commits, exactly as a real tree's does -- otherwise every untracked pen file
# rides the porcelain into every changed set and roster.kyri (watched) defeats the skip case.
( cd "$scopepen" && git add -A && git commit -qm scaffold ) >/dev/null 2>&1

# Refusal first: --scoped with no receipt at all.
out=$( ( cd "$scopepen" && STANDING_ROSTER=roster.kyri STANDING_CARD=card.kyri \
        STANDING_RECEIPT=receipt.kyri STANDING_HITRATE=hits.kyri STANDING_SCOPE_MAP=map.sh \
        sh "$runner" --scoped 2>/dev/null ) || true )
case "$out" in *"run_verdict=scoped_no_basis"*) echo "scoped_no_basis_refused=yes" ;; *) echo "scoped_no_basis_refused=no" ;; esac

# The full run writes the v2 receipt with a head to diff from.
out=$( ( cd "$scopepen" && STANDING_ROSTER=roster.kyri STANDING_CARD=card.kyri \
        STANDING_RECEIPT=receipt.kyri STANDING_HITRATE=hits.kyri \
        sh "$runner" 2>/dev/null ) || true )
if grep -q '^head ' "$scopepen/receipt.kyri" 2>/dev/null && grep -q '^scope full' "$scopepen/receipt.kyri" 2>/dev/null; then
  echo "full_receipt_carries_head=yes"
else
  echo "full_receipt_carries_head=no"
fi

# A watched edit runs the guard.
echo moved >> "$scopepen/watched.txt"
out=$( ( cd "$scopepen" && STANDING_ROSTER=roster.kyri STANDING_CARD=card.kyri \
        STANDING_RECEIPT=receipt.kyri STANDING_HITRATE=hits.kyri STANDING_SCOPE_MAP=map.sh \
        sh "$runner" --scoped 2>/dev/null ) || true )
case "$out" in *"guards_run=1"*) echo "scoped_watched_runs=yes" ;; *) echo "scoped_watched_runs=no" ;; esac

# An unwatched edit skips it by name, and the scoped close withholds the receipt.
( cd "$scopepen" && git checkout -q -- watched.txt )
echo moved >> "$scopepen/other.txt"
receipt_before=$(cat "$scopepen/receipt.kyri" 2>/dev/null || true)
out=$( ( cd "$scopepen" && STANDING_ROSTER=roster.kyri STANDING_CARD=card.kyri \
        STANDING_RECEIPT=receipt.kyri STANDING_HITRATE=hits.kyri STANDING_SCOPE_MAP=map.sh \
        sh "$runner" --scoped 2>/dev/null ) || true )
case "$out" in *"skipped_scope alpha"*) echo "scoped_unwatched_skips_by_name=yes" ;; *) echo "scoped_unwatched_skips_by_name=no" ;; esac
case "$out" in *"roster_receipt_write=withheld_scope_scoped"*) echo "scoped_close_withholds_receipt=yes" ;; *) echo "scoped_close_withholds_receipt=no" ;; esac
receipt_after=$(cat "$scopepen/receipt.kyri" 2>/dev/null || true)
if [ "$receipt_before" = "$receipt_after" ]; then echo "scoped_receipt_unmoved=yes"; else echo "scoped_receipt_unmoved=no"; fi

# A guard the map does not know always runs -- absence is the answer that runs.
cat > "$scopepen/map.sh" <<'EOF'
#!/bin/sh
echo "somebody_else nothing.txt"
EOF
out=$( ( cd "$scopepen" && STANDING_ROSTER=roster.kyri STANDING_CARD=card.kyri \
        STANDING_RECEIPT=receipt.kyri STANDING_HITRATE=hits.kyri STANDING_SCOPE_MAP=map.sh \
        sh "$runner" --scoped 2>/dev/null ) || true )
case "$out" in *"guards_run=1"*) echo "scoped_unmapped_runs=yes" ;; *) echo "scoped_unmapped_runs=no" ;; esac

# THE RED THAT COSTS THE RECEIPT, proven from both sides (REDS %374). A receipt is written past the
# red exit, so a full pass carrying any red writes none and --scoped has no basis forever after --
# which on a tree whose reds are parked at a custody gate is a permanent state rather than a delay.
# Four readings: a red close NAMES the withholding and writes no receipt; the --scoped that follows
# names the guards that blocked it; a run card with no red at all keeps the elder sentence's
# `none`; and a green close writes the receipt while printing no withholding, so the line is caused
# by the red rather than always printed. Three of the four BITE -- a runner stripped of both
# lines flips red_close_names_withholding, blocked_basis_names_the_guard, and
# unblocked_basis_reads_none to no. The fourth cannot: a stripped runner also prints no
# withholding, so green_close_names_no_withholding is a COMPANION to the first rather than a
# gate of its own, and it is written down that way rather than counted as a refusal it is not.
# The stub interpreter is what reds and greens here, since
# the runner's verdict is the guard's own exit status.
cat > "$scopepen/rishi/bin/rishi" <<'STUB'
#!/bin/sh
exit 1
STUB
chmod +x "$scopepen/rishi/bin/rishi"
rm -f "$scopepen/receipt.kyri"
out=$( ( cd "$scopepen" && STANDING_ROSTER=roster.kyri STANDING_CARD=card.kyri \
        STANDING_RECEIPT=receipt.kyri STANDING_HITRATE=hits.kyri \
        sh "$runner" 2>/dev/null ) || true )
case "$out" in *"roster_receipt_write=withheld_guard_red"*) echo "red_close_names_withholding=yes" ;; *) echo "red_close_names_withholding=no" ;; esac
if [ -f "$scopepen/receipt.kyri" ]; then echo "red_close_writes_no_receipt=no"; else echo "red_close_writes_no_receipt=yes"; fi

out=$( ( cd "$scopepen" && STANDING_ROSTER=roster.kyri STANDING_CARD=card.kyri \
        STANDING_RECEIPT=receipt.kyri STANDING_HITRATE=hits.kyri STANDING_SCOPE_MAP=map.sh \
        sh "$runner" --scoped 2>/dev/null ) || true )
case "$out" in *"scoped_basis_blocked=alpha"*) echo "blocked_basis_names_the_guard=yes" ;; *) echo "blocked_basis_names_the_guard=no" ;; esac
case "$out" in *"run_verdict=scoped_no_basis"*) echo "blocked_basis_still_refuses=yes" ;; *) echo "blocked_basis_still_refuses=no" ;; esac

# The other side of the same reading: no card, so nothing blocked, and the elder advice stands.
mv "$scopepen/card.kyri" "$scopepen/card.kept"
out=$( ( cd "$scopepen" && STANDING_ROSTER=roster.kyri STANDING_CARD=card.kyri \
        STANDING_RECEIPT=receipt.kyri STANDING_HITRATE=hits.kyri STANDING_SCOPE_MAP=map.sh \
        sh "$runner" --scoped 2>/dev/null ) || true )
case "$out" in *"scoped_basis_blocked=none"*) echo "unblocked_basis_reads_none=yes" ;; *) echo "unblocked_basis_reads_none=no" ;; esac

# And the green side, so the withholding line is known to be caused rather than constant.
cat > "$scopepen/rishi/bin/rishi" <<'STUB'
#!/bin/sh
exit 0
STUB
chmod +x "$scopepen/rishi/bin/rishi"
out=$( ( cd "$scopepen" && STANDING_ROSTER=roster.kyri STANDING_CARD=card.kyri \
        STANDING_RECEIPT=receipt.kyri STANDING_HITRATE=hits.kyri \
        sh "$runner" 2>/dev/null ) || true )
case "$out" in *"withheld_guard_red"*) echo "green_close_names_no_withholding=no" ;; *) echo "green_close_names_no_withholding=yes" ;; esac
if [ -f "$scopepen/receipt.kyri" ]; then echo "green_close_writes_receipt=yes"; else echo "green_close_writes_receipt=no"; fi


# ONE PASS AT A TIME (REDS %359). Two cold endurance runs stood in this pier's own tree for fifty minutes
# with nothing in the runner to say so, and the contention is not merely slow: a choir that clears
# its own bin directory before it sings deletes the binaries another pass's rungs are partway
# through using. The lock PRIMITIVE -- taken, refused, released, and reaped when its owner has
# died -- is proven in tools/fixtures/s/shell_portable_control.sh; what is proven HERE is the
# runner's own use of it. A pass takes the lock and says so, a second pass refuses BY NAME rather
# than queueing, a refusing pass runs no guard and leaves the holder's lock exactly where it found
# it, a lock whose owner has died is reaped rather than waited out, and a pen with no room to lock
# in says so and still runs.
lockpen="$pen/lockpen"
mkdir -p "$lockpen/rishi/bin"
cat > "$lockpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$lockpen/rishi/bin/rishi"
: > "$lockpen/guard.sh"
cat > "$lockpen/roster.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path guard.sh
tier lap
seated 20260830.000000
EOF

# <lock-path> <card> [args...] -- the lock path is a parameter so the pen can hold a real one,
# where every other case in this file runs where no lock room exists at all.
run_locked() {
  _lk=$1
  _cd=$2
  shift 2
  ( cd "$lockpen" && STANDING_ROSTER=roster.kyri STANDING_CARD="$_cd" STANDING_LOCK="$_lk" \
      sh "$runner" "$@" 2>/dev/null ) || true
}

# The free side first: an unheld lock is taken, the pass runs, and the lock leaves with it.
out=$(run_locked lock.d card.kyri)
case "$out" in *"run_lock=held"*) echo "lock_taken=yes" ;; *) echo "lock_taken=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "locked_pass_still_ok=yes" ;; *) echo "locked_pass_still_ok=no" ;; esac
if [ -d "$lockpen/lock.d" ]; then echo "lock_released_at_exit=no"; else echo "lock_released_at_exit=yes"; fi

# A live owner refuses the second pass, by name, before a single guard runs.
mkdir -p "$lockpen/lock.d"
printf '%s\n' "$$" > "$lockpen/lock.d/pid"
rm -f "$lockpen/held-card.kyri"
out=$(run_locked lock.d held-card.kyri)
case "$out" in *"run_verdict=run_in_flight"*) echo "held_lock_refuses=yes" ;; *) echo "held_lock_refuses=no" ;; esac
case "$out" in *"pid=$$"*) echo "held_lock_names_owner=yes" ;; *) echo "held_lock_names_owner=no" ;; esac
case "$out" in *"guards_run="*) echo "held_lock_runs_no_guard=no" ;; *) echo "held_lock_runs_no_guard=yes" ;; esac
if [ -f "$lockpen/held-card.kyri" ]; then echo "held_lock_writes_no_card=no"; else echo "held_lock_writes_no_card=yes"; fi
# THE LOAD-BEARING ONE. A pass that never took the lock must never remove one -- a release armed
# on the refusing side would free the holder's lock and walk a third pass straight in.
if [ -d "$lockpen/lock.d" ]; then echo "refusal_keeps_holders_lock=yes"; else echo "refusal_keeps_holders_lock=no"; fi
# WHOSE LAP IS THE HOLDER RUNNING FOR -- the negative side, taken from the case just above. The
# control's own pid holds that lock and the control's parent is alive, so a reading that answered
# `gone` here would answer it for every holder, and a refusal that always fires tells a hand
# nothing. This is the same discipline the refusals keep: a reading proven only where it fires
# cannot be told from a reading that is stuck on.
case "$out" in *"parent=alive"*) echo "live_parent_reads_alive=yes" ;; *) echo "live_parent_reads_alive=no" ;; esac

# THE POSITIVE SIDE, planted for real. A lap that dies with its pass still running leaves the pass
# reparented to init, holding this lock, its output going to nobody -- twice in two laps on
# 20260831. The plant is a grandchild whose parent exits immediately, which is exactly how the real
# orphan is made.
#
# THE PLANT IS VERIFIED BEFORE IT IS TRUSTED. A host running a subreaper reparents an orphan to the
# reaper rather than to init, so on such a host this plant cannot be made at all and the case would
# fail for the host's reason rather than the runner's. So the control reads the plant's own parent
# first and says `orphan_plant=unavailable` where the plant did not take, because a silent skip is
# how this reading would go quietly false on the day the host changed.
mkdir -p "$lockpen/lock.d"
sh -c 'sleep 30 & printf "%s\n" "$!" > "$0"' "$lockpen/orphan.pid"
orphan=$(cat "$lockpen/orphan.pid" 2>/dev/null || true)
orphan_parent=$(ps -o ppid= -p "$orphan" 2>/dev/null | tr -d ' ')
if [ "$orphan_parent" = 1 ]; then
  echo "orphan_plant=ok"
  printf '%s\n' "$orphan" > "$lockpen/lock.d/pid"
  rm -f "$lockpen/orphan-card.kyri"
  orphan_out=$(run_locked lock.d orphan-card.kyri 2>&1)
  orphan_err=$( ( cd "$lockpen" && STANDING_ROSTER=roster.kyri STANDING_CARD=orphan-err.kyri \
      STANDING_LOCK=lock.d sh "$runner" 2>&1 >/dev/null ) || true )
  case "$orphan_out" in *"parent=gone"*) echo "orphan_parent_reads_gone=yes" ;; *) echo "orphan_parent_reads_gone=no" ;; esac
  case "$orphan_out" in *"run_verdict=run_in_flight"*) echo "orphan_still_refuses=yes" ;; *) echo "orphan_still_refuses=no" ;; esac
  # The repair is named, and it names SIGTERM: the runner's trap releases the lock on TERM, where
  # SIGKILL bypasses it and leaves the lock for the next pass to reap. The previous lap paid that
  # difference by hand.
  case "$orphan_err" in *"kill -TERM $orphan"*) echo "orphan_names_the_repair=yes" ;; *) echo "orphan_names_the_repair=no" ;; esac
  # AND IT STILL TAKES NO ACTION. An orphan is a live writer, so a pass that reaped one would be
  # one body ending another's work (REDS %291). The holder must be alive after the refusal.
  if kill -0 "$orphan" 2>/dev/null; then echo "orphan_left_running=yes"; else echo "orphan_left_running=no"; fi
  if [ -d "$lockpen/lock.d" ]; then echo "orphan_keeps_its_lock=yes"; else echo "orphan_keeps_its_lock=no"; fi
  kill "$orphan" 2>/dev/null || true
else
  echo "orphan_plant=unavailable"
fi
rm -rf "$lockpen/lock.d"

# THE SHAPE THE FLEET ACTUALLY MAKES, and the one the plant above cannot reach. The orphan above is
# two generations -- parent exits, child adopted by init -- and the parent reading catches it. A lap
# that launches its hot endurance run detached makes THREE: `( sh runner --hot > out; echo EXIT=$? ) &` forks
# a subshell to carry the compound command, so the runner's parent is that subshell. When the lap
# ends it is the SUBSHELL that reparents to init, while the runner's own ppid goes on naming a live
# process. The parent reading answers `alive` for a lap that has gone, which is how a pass came to
# hold this tree's lock at `20260906.231137` while the next seat was refused with no repair named.
#
# The plant reproduces it in three processes, and `set -m` is what makes it reachable at all. A
# LEADER shell backgrounds a MIDDLE shell and exits at once; the middle shell reparents to init,
# stays alive, and spawns the planted HOLDER. All three share the leader's process group, so the
# holder ends with a live parent and a leader that has gone -- the real case, exactly.
#
# WHY `set -m`. Job control is off in a non-interactive shell, so `&` starts no new process group
# and every plant would simply inherit THIS control's group, whose leader is alive for as long as
# the control runs -- which is how the first draft of this case read `unavailable` on a host that
# could make the shape perfectly well. `set -m` is POSIX and turns the backgrounded leader into the
# leader of its own group, which is the one thing the plant needs and cannot fake.
cat > "$lockpen/deep-leader.sh" <<'EOF'
sh "$1" "$2" &
EOF
cat > "$lockpen/deep-middle.sh" <<'EOF'
sleep 45 &
printf '%s\n' "$!" > "$1"
sleep 45
EOF
rm -f "$lockpen/deep.pid"
sh -c 'set -m; sh "$0" "$1" "$2" &' \
  "$lockpen/deep-leader.sh" "$lockpen/deep-middle.sh" "$lockpen/deep.pid"
deep=""
for _try in 1 2 3 4 5 6 7 8 9 10; do
  deep=$(cat "$lockpen/deep.pid" 2>/dev/null || true)
  [ -n "$deep" ] && break
  sleep 1
done
deep_parent=$(ps -o ppid= -p "$deep" 2>/dev/null | tr -d ' ')
deep_group=$(ps -o pgid= -p "$deep" 2>/dev/null | tr -d ' ')
deep_group_alive=$(ps -o pid= -p "$deep_group" 2>/dev/null | tr -d ' ')
# VERIFIED BEFORE IT IS TRUSTED, the same discipline the two-generation plant keeps. The plant has
# only taken when the holder's parent is ALIVE and not init -- otherwise this is the elder orphan
# wearing a new name -- and when its group leader has actually gone. A host that arranges either
# differently reads `unavailable` rather than failing for the host's reason.
if [ -n "$deep" ] && [ -n "$deep_parent" ] && [ "$deep_parent" != 1 ] && [ -z "$deep_group_alive" ]; then
  echo "deep_orphan_plant=ok"
  mkdir -p "$lockpen/lock.d"
  printf '%s\n' "$deep" > "$lockpen/lock.d/pid"
  rm -f "$lockpen/deep-card.kyri"
  deep_out=$(run_locked lock.d deep-card.kyri 2>&1)
  deep_err=$( ( cd "$lockpen" && STANDING_ROSTER=roster.kyri STANDING_CARD=deep-err.kyri \
      STANDING_LOCK=lock.d sh "$runner" 2>&1 >/dev/null ) || true )
  # THE LOAD-BEARING READING. The elder parent check must still answer `alive` here -- that is the
  # defect, shown rather than described -- while the pass is nonetheless called gone. A control
  # that only proved the new reading fires could not tell a widened check from one that had merely
  # started saying `gone` about everything.
  case "$deep_out" in *"parent=alive"*) echo "deep_orphan_parent_reads_alive=yes" ;; *) echo "deep_orphan_parent_reads_alive=no" ;; esac
  case "$deep_out" in *"group_leader=gone"*) echo "deep_orphan_group_reads_gone=yes" ;; *) echo "deep_orphan_group_reads_gone=no" ;; esac
  case "$deep_out" in *"lap=gone"*) echo "deep_orphan_lap_reads_gone=yes" ;; *) echo "deep_orphan_lap_reads_gone=no" ;; esac
  case "$deep_out" in *"run_verdict=run_in_flight"*) echo "deep_orphan_still_refuses=yes" ;; *) echo "deep_orphan_still_refuses=no" ;; esac
  # The repair is named for this shape too, and the sentence says which reading fired, since a hand
  # reading `parent=alive` beside `stop it` deserves to be told why those two stand together.
  case "$deep_err" in *"kill -TERM $deep"*) echo "deep_orphan_names_the_repair=yes" ;; *) echo "deep_orphan_names_the_repair=no" ;; esac
  case "$deep_err" in *"process group leader has exited"*) echo "deep_orphan_names_the_reading=yes" ;; *) echo "deep_orphan_names_the_reading=no" ;; esac
  # AND IT STILL TAKES NO ACTION, exactly as the two-generation case must not (REDS %291).
  if kill -0 "$deep" 2>/dev/null; then echo "deep_orphan_left_running=yes"; else echo "deep_orphan_left_running=no"; fi
  if [ -d "$lockpen/lock.d" ]; then echo "deep_orphan_keeps_its_lock=yes"; else echo "deep_orphan_keeps_its_lock=no"; fi
  kill "$deep" 2>/dev/null || true
else
  echo "deep_orphan_plant=unavailable"
fi
rm -rf "$lockpen/lock.d"

# THE LEADER THAT IS ALIVE AND ORPHANED AT ONCE -- the shape BOTH readings above answer `alive` for,
# and the one that actually held this tree's lock at `20260907.065148`. The harness a lap reaches
# for when it wants a pass to outlive a tool call starts the command in its OWN SESSION:
# `sh -c 'sh runner --hot --scoped > /tmp/hot.txt 2>&1; ...'` detached. That `sh -c` is therefore
# the leader of its own group rather than a member of the lap's, and it is what reparents to init
# when the lap ends -- while going right on running. The holder's parent is that leader (alive, not
# init) and the leader exists, so the parent reading says `alive`, the group reading says `alive`,
# and a pass whose lap died minutes ago reads as a live writer.
#
# THE PLANT IS THE DEEP ONE WITH THE LEADER LEFT STANDING. Same three processes and the same
# `set -m` (job control off would put every plant in this control's own live group, which is the
# host fact that makes the shape unreachable rather than absent): an outer shell backgrounds the
# LEADER under `set -m` and exits at once, so the leader takes its own group and is adopted by
# init; the leader then spawns the HOLDER inside that group and stays alive. Where the deep plant
# above kills its leader, this one keeps it -- which is the whole difference between the two cases.
cat > "$lockpen/session-leader.sh" <<'EOF'
sleep 45 &
printf '%s\n' "$!" > "$1"
sleep 45
EOF
rm -f "$lockpen/session.pid"
sh -c 'set -m; sh "$0" "$1" &' "$lockpen/session-leader.sh" "$lockpen/session.pid"
sess=""
for _try in 1 2 3 4 5 6 7 8 9 10; do
  sess=$(cat "$lockpen/session.pid" 2>/dev/null || true)
  [ -n "$sess" ] && break
  sleep 1
done
sess_parent=$(ps -o ppid= -p "$sess" 2>/dev/null | tr -d ' ')
sess_group=$(ps -o pgid= -p "$sess" 2>/dev/null | tr -d ' ')
sess_group_alive=$(ps -o pid= -p "$sess_group" 2>/dev/null | tr -d ' ')
sess_leader_ppid=$(ps -o ppid= -p "$sess_group" 2>/dev/null | tr -d ' ')
# VERIFIED BEFORE IT IS TRUSTED, four ways, because three of them are exactly what the elder plants
# already cover and only the fourth is this case: the holder's parent alive and not init (else this
# is the two-generation orphan), the group leader alive (else it is the deep orphan), and the
# LEADER'S OWN parent at init (else the plant has not taken at all).
if [ -n "$sess" ] && [ -n "$sess_parent" ] && [ "$sess_parent" != 1 ] \
   && [ -n "$sess_group_alive" ] && [ "$sess_leader_ppid" = 1 ]; then
  echo "session_orphan_plant=ok"
  mkdir -p "$lockpen/lock.d"
  printf '%s\n' "$sess" > "$lockpen/lock.d/pid"
  rm -f "$lockpen/session-card.kyri"
  sess_out=$(run_locked lock.d session-card.kyri 2>&1)
  sess_err=$( ( cd "$lockpen" && STANDING_ROSTER=roster.kyri STANDING_CARD=session-err.kyri \
      STANDING_LOCK=lock.d sh "$runner" 2>&1 >/dev/null ) || true )
  # THE LOAD-BEARING READINGS, and there are two of them here rather than one. BOTH elder checks
  # must still answer `alive` -- that is the defect shown rather than described -- while the pass is
  # nonetheless called gone. A control proving only that the new reading fires could not tell a
  # widened check from one that had simply started saying `gone` about every holder.
  case "$sess_out" in *"parent=alive"*) echo "session_orphan_parent_reads_alive=yes" ;; *) echo "session_orphan_parent_reads_alive=no" ;; esac
  case "$sess_out" in *"group_leader=alive"*) echo "session_orphan_group_reads_alive=yes" ;; *) echo "session_orphan_group_reads_alive=no" ;; esac
  case "$sess_out" in *"leader_parent=gone"*) echo "session_orphan_leader_parent_reads_gone=yes" ;; *) echo "session_orphan_leader_parent_reads_gone=no" ;; esac
  case "$sess_out" in *"lap=gone"*) echo "session_orphan_lap_reads_gone=yes" ;; *) echo "session_orphan_lap_reads_gone=no" ;; esac
  case "$sess_out" in *"run_verdict=run_in_flight"*) echo "session_orphan_still_refuses=yes" ;; *) echo "session_orphan_still_refuses=no" ;; esac
  case "$sess_err" in *"kill -TERM $sess"*) echo "session_orphan_names_the_repair=yes" ;; *) echo "session_orphan_names_the_repair=no" ;; esac
  # The advice must name THIS reading, not one of the other two -- a hand reading `parent=alive
  # group_leader=alive` beside `stop it` is owed the sentence that reconciles them.
  case "$sess_err" in *"adopted by init"*) echo "session_orphan_names_the_reading=yes" ;; *) echo "session_orphan_names_the_reading=no" ;; esac
  # AND IT STILL TAKES NO ACTION, exactly as both elder orphan cases must not (REDS %291).
  if kill -0 "$sess" 2>/dev/null; then echo "session_orphan_left_running=yes"; else echo "session_orphan_left_running=no"; fi
  if [ -d "$lockpen/lock.d" ]; then echo "session_orphan_keeps_its_lock=yes"; else echo "session_orphan_keeps_its_lock=no"; fi
  kill "$sess" 2>/dev/null || true
  kill "$sess_group" 2>/dev/null || true
else
  echo "session_orphan_plant=unavailable"
fi
rm -rf "$lockpen/lock.d"

# THE NEGATIVE SIDE OF THE GROUP READING, and it needs its own plant. The live case above holds the
# lock with this control's own pid, whose group leader is whatever launched the control -- true, and
# not something this file may assume. So a holder is made whose group leader is certainly alive.
# Verified before it is trusted, and `unavailable` where the host arranges groups differently,
# since a reading proven only where it fires cannot be told from one that is stuck on.
#
# THE HOLDER LEADS ITS OWN GROUP, rather than borrowing this shell's. `&` in a shell WITHOUT job
# control starts no new process group, so a plain `sleep 45 &` inherits the group of whatever
# launched this control -- and when a lap launches its roster pass detached, that launcher exits
# while the twenty-five-minute pass runs on. The leader is then gone, this plant reads
# `unavailable`, and tools/s/standing_equipment_witness.rish -- which asserts `ok` and knows no
# third answer -- reads the control's honest abstention as a failure. So the instrument reddened on
# HOW IT WAS STARTED rather than on what it measured, on every detached pass and on no hand-run
# one (REDS `20260908.093729`). `set -m` enables job control for this one command, and
# POSIX then puts each background job in a process group of its own: measured on this pier
# `20260908.104016`, the holder's pgid equals its own pid under `set -m` and equals the launcher's
# without it, in a detached shell and an interactive one alike. Job control is turned off again
# immediately, because it also changes how background children take SIGINT and SIGQUIT, and this
# plant is the only place that trade is wanted.
set -m
sleep 45 & live_holder=$!
set +m
live_group=$(ps -o pgid= -p "$live_holder" 2>/dev/null | tr -d ' ')
live_group_alive=$(ps -o pid= -p "$live_group" 2>/dev/null | tr -d ' ')
if [ -n "$live_group_alive" ]; then
  echo "live_group_plant=ok"
  mkdir -p "$lockpen/lock.d"
  printf '%s\n' "$live_holder" > "$lockpen/lock.d/pid"
  rm -f "$lockpen/live-group-card.kyri"
  live_out=$(run_locked lock.d live-group-card.kyri 2>&1)
  case "$live_out" in *"group_leader=alive"*) echo "live_group_reads_alive=yes" ;; *) echo "live_group_reads_alive=no" ;; esac
  # THE NEGATIVE SIDE OF THE THIRD READING, and this is the plant that carries it: a live holder in
  # a live group whose leader was itself started by something still running must NOT read
  # `leader_parent=gone`. `lap=alive` below is the composite that would break first, and this line
  # says which of the three readings held, so a stuck-on check is visible rather than merely absent.
  case "$live_out" in *"leader_parent=gone"*) echo "live_leader_parent_reads_gone=yes" ;; *) echo "live_leader_parent_reads_gone=no" ;; esac
  case "$live_out" in *"lap=alive"*) echo "live_lap_reads_alive=yes" ;; *) echo "live_lap_reads_alive=no" ;; esac
  # A live lap earns no repair advice: the refusal's own sentence, read its output, is the whole
  # answer, and a `kill -TERM` printed beside a running lap would invite exactly the cross-hand act.
  live_err=$( ( cd "$lockpen" && STANDING_ROSTER=roster.kyri STANDING_CARD=live-group-err.kyri \
      STANDING_LOCK=lock.d sh "$runner" 2>&1 >/dev/null ) || true )
  case "$live_err" in *"kill -TERM"*) echo "live_lap_names_no_repair=no" ;; *) echo "live_lap_names_no_repair=yes" ;; esac
else
  echo "live_group_plant=unavailable"
fi
kill "$live_holder" 2>/dev/null || true
rm -rf "$lockpen/lock.d"

# A lock whose owner has died is reaped rather than waited out, so a killed pass costs one retry
# rather than every later pass. The pid is a child run and waited on, which has certainly exited.
# The lock is re-made first: a runner that wrongly released the holder's lock leaves nothing to
# write a pid into, and a leg that dies takes every reading after it down with it. A broken runner
# should print a full card of noes rather than a truncated one.
mkdir -p "$lockpen/lock.d"
( exit 0 ) & dead=$!
wait "$dead" 2>/dev/null || true
printf '%s\n' "$dead" > "$lockpen/lock.d/pid"
out=$(run_locked lock.d dead-card.kyri)
case "$out" in *"run_verdict=ok"*) echo "dead_owner_reaped=yes" ;; *) echo "dead_owner_reaped=no" ;; esac
rm -rf "$lockpen/lock.d"

# A pen with no room to lock in says so and still runs, exactly as the hit ledger and the receipt
# already do -- a silent skip is how this reading would go quietly false the day that room moved.
out=$(run_locked no/such/room/lock.d room-card.kyri)
case "$out" in *"run_lock=skipped_no_room"*) echo "no_lock_room_says_so=yes" ;; *) echo "no_lock_room_says_so=no" ;; esac
case "$out" in *"guards_run=1"*) echo "no_lock_room_still_runs=yes" ;; *) echo "no_lock_room_still_runs=no" ;; esac


# --- a DETACHED pass is named rather than accused (`20260909.234718`) --------------------------
# THE FAULT THESE CLOSE, and it is the fourth firing of the family above. `--detach` runs
# `nohup sh "$0" "$@" &` from a parent that exits at once, so EVERY detached pass is reparented to
# init within milliseconds of launch -- by construction, with its lap alive and waiting on the
# transcript. All three ancestry readings then answer `gone`, and the advice that word carries is
# `kill`. Measured on this pier that stamp: a two-minute-old pass the measuring lap had itself
# launched read `lap=gone`, and 7 of 17 passes across eight trees read the same. `%548` closed by
# stating the reading `cannot call a live pass gone`; that was true when written and false one day
# later, when the flag was seated.
#
# THE PLANT IS THE ONE `--detach` ACTUALLY MAKES: a live process reparented to init, whose lock
# ALSO carries a `transcript` file -- written by the detach parent and by nobody else, so its
# presence is the launch form. An orphan without one is the elder shape and keeps every elder
# reading, which the legs above already hold. Verified before it is trusted, exactly as the orphan
# plant above is, because a host running a subreaper reparents elsewhere and the plant would not
# take.
#
# THE HEAD THE PEN READS IS `nogit`, since `pen` is a `mktemp -d` with no repository in it. That is
# precisely what the runner reads there, so comparing against it exercises the same equality a real
# hash would; the moved leg plants a literal that can never equal it.
pen_head=$( ( cd "$lockpen" && git rev-parse --short=10 HEAD 2>/dev/null ) || echo nogit )
[ -n "$pen_head" ] || pen_head=nogit
sh -c 'sleep 45 & printf "%s\n" "$!" > "$0"' "$lockpen/detached.pid"
detpid=$(cat "$lockpen/detached.pid" 2>/dev/null || true)
detppid=$(ps -o ppid= -p "$detpid" 2>/dev/null | tr -d ' ')
plant_detached() {
  rm -rf "$lockpen/detached.lock.d"
  mkdir -p "$lockpen/detached.lock.d"
  printf '%s\n' "$detpid" > "$lockpen/detached.lock.d/pid"
  printf '%s' "$1" > "$lockpen/detached-run.txt"
  echo "detached-run.txt" > "$lockpen/detached.lock.d/transcript"
}
if [ "$detppid" = 1 ]; then
  echo "detached_plant=ok"

  # 1 -- a live detached pass whose launch_head still names this tree: named, and left alone.
  plant_detached "launch_head $pen_head
"
  det_out=$(run_locked detached.lock.d detached-card.kyri 2>&1)
  # THE DETAIL GOES TO STDERR, which `run_locked` sends to /dev/null -- the same split the orphan
  # legs above already read, captured the same way, since the sentences are the whole repair.
  det_err=$( ( cd "$lockpen" && STANDING_ROSTER=roster.kyri STANDING_CARD=detached-err.kyri \
      STANDING_LOCK=detached.lock.d sh "$runner" ) 2>&1 >/dev/null || true )
  case "$det_out" in *"lap=detached"*) echo "detached_reads_detached=yes" ;; *) echo "detached_reads_detached=no" ;; esac
  case "$det_out" in *"lap=gone"*) echo "detached_accused_of_gone=yes" ;; *) echo "detached_accused_of_gone=no" ;; esac
  case "$det_err" in *"kill -TERM"*) echo "live_detached_told_to_kill=yes" ;; *) echo "live_detached_told_to_kill=no" ;; esac
  case "$det_err" in *"is still HEAD"*) echo "detached_names_live_head=yes" ;; *) echo "detached_names_live_head=no" ;; esac
  case "$det_out" in *"run_verdict=run_in_flight"*) echo "detached_still_refuses=yes" ;; *) echo "detached_still_refuses=no" ;; esac
  # THE ELDER READINGS MUST STILL FIRE UNDERNEATH, or a widened check could not be told from one
  # that had simply stopped reading the process table at all.
  case "$det_out" in *"parent=gone"*) echo "detached_parent_still_reads_gone=yes" ;; *) echo "detached_parent_still_reads_gone=no" ;; esac

  # 2 -- a detached pass whose launch_head has moved: its verdict is already void, so the repair IS named.
  plant_detached "launch_head deadbeef00
"
  moved_out=$(run_locked detached.lock.d detached-moved.kyri 2>&1)
  moved_err=$( ( cd "$lockpen" && STANDING_ROSTER=roster.kyri STANDING_CARD=detached-moved-err.kyri \
      STANDING_LOCK=detached.lock.d sh "$runner" ) 2>&1 >/dev/null || true )
  case "$moved_err" in *"no longer HEAD"*) echo "detached_moved_named=yes" ;; *) echo "detached_moved_named=no" ;; esac
  case "$moved_err" in *"kill -TERM"*) echo "detached_moved_names_repair=yes" ;; *) echo "detached_moved_names_repair=no" ;; esac
  case "$moved_out" in *"lap=detached"*) echo "detached_moved_still_detached=yes" ;; *) echo "detached_moved_still_detached=no" ;; esac

  # 3 -- a transcript naming no launch_head answers neither way rather than guessing.
  plant_detached "launch_args --scoped
"
  bare_out=$(run_locked detached.lock.d detached-bare.kyri 2>&1)
  bare_err=$( ( cd "$lockpen" && STANDING_ROSTER=roster.kyri STANDING_CARD=detached-bare-err.kyri \
      STANDING_LOCK=detached.lock.d sh "$runner" ) 2>&1 >/dev/null || true )
  case "$bare_err" in *"names no launch_head"*) echo "detached_bare_says_so=yes" ;; *) echo "detached_bare_says_so=no" ;; esac
  case "$bare_err" in *"kill -TERM"*) echo "detached_bare_told_to_kill=yes" ;; *) echo "detached_bare_told_to_kill=no" ;; esac

  # 4 -- THE FAULT PROVEN TO BITE, from the failing side, on the SAME plant. Legs answering the way
  # this repair wants cannot be told from legs on a runner that never carried it. Disabling the
  # DETECTION rather than the `lap=detached` line is deliberate: deleting the assignment would leave
  # `if ... then` standing on `elif` and the copy would refuse to parse, which is a broken script
  # rather than the elder behavior.
  sed 's|if \[ -s "$2/transcript" \]; then detached=yes; fi|detached=no|' "$runner" > "$pen/run-accuse.sh"
  cp "$(dirname "$runner")/shell_portable.sh" "$pen/shell_portable.sh" 2>/dev/null || true
  cp "$(dirname "$runner")/scope_match.sh" "$pen/scope_match.sh" 2>/dev/null || true
  if cmp -s "$runner" "$pen/run-accuse.sh"; then echo "accuse_runner_built=no"; else echo "accuse_runner_built=yes"; fi
  plant_detached "launch_head $pen_head
"
  accuse_out=$( ( cd "$lockpen" && STANDING_ROSTER=roster.kyri STANDING_CARD=accuse-card.kyri \
      STANDING_LOCK=detached.lock.d sh "$pen/run-accuse.sh" 2>&1 ) || true )
  accuse_err=$( ( cd "$lockpen" && STANDING_ROSTER=roster.kyri STANDING_CARD=accuse-err.kyri \
      STANDING_LOCK=detached.lock.d sh "$pen/run-accuse.sh" ) 2>&1 >/dev/null || true )
  case "$accuse_out" in *"lap=gone"*) echo "elder_accuses_live_detached=yes" ;; *) echo "elder_accuses_live_detached=no" ;; esac
  case "$accuse_err" in *"kill -TERM"*) echo "elder_tells_lap_to_kill=yes" ;; *) echo "elder_tells_lap_to_kill=no" ;; esac

  # AND NOTHING IS REAPED HERE EITHER (REDS %291) -- naming a pass changes the diagnosis, never the act.
  if kill -0 "$detpid" 2>/dev/null; then echo "detached_left_running=yes"; else echo "detached_left_running=no"; fi
  if [ -d "$lockpen/detached.lock.d" ]; then echo "detached_keeps_its_lock=yes"; else echo "detached_keeps_its_lock=no"; fi
else
  echo "detached_plant=unavailable"
fi
kill "$detpid" 2>/dev/null || true

# 5 -- and the reading reaches the refusal the BATON names, which had carried none of it. One
# refusal stood in two copies, and only the copy a lap is NOT told to use had ever learned any of
# this -- so a `--detach` launch refused by a live owner was told to read a transcript, with no word
# on whether a reader was left. A live pid suffices here: the leg asks whether the reading is taken
# at all, which is what that site was missing.
rm -rf "$pen/session-output"; mkdir -p "$pen/session-output"
printf 'launch_head deadbeef00\n' > "$pen/detach-owner.txt"
rm -rf "$pen/live.lock.d"; mkdir -p "$pen/live.lock.d"
echo "$$" > "$pen/live.lock.d/pid"
echo "detach-owner.txt" > "$pen/live.lock.d/transcript"
dl_out=$( ( cd "$pen" && STANDING_ROSTER=cadence.kyri STANDING_CARD=run-card.kyri \
        STANDING_LOCK=live.lock.d sh "$runner" --detach 2>&1 ) || true )
case "$dl_out" in *"run_lock=in_flight"*) echo "detach_refusal_takes_reading=yes" ;; *) echo "detach_refusal_takes_reading=no" ;; esac
case "$dl_out" in *"lap=detached"*) echo "detach_refusal_names_detached=yes" ;; *) echo "detach_refusal_names_detached=no" ;; esac
rm -rf "$pen/live.lock.d"

# --- the custody gate, proven from both sides (REDS %374, Keaton's word `20260904`) ------------
#
# A red at a card-named custody gate is a PARKED reading rather than a broken one, so a full pass
# carrying only such reds earns its receipt. This is the one roster field a hand types about its
# own tree, so every leg below is asked in the direction that would make it a free pass.
gatepen=$(mktemp -d)
mkdir -p "$gatepen/rishi/bin" "$gatepen/construction"
cat > "$gatepen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
# argv is `run <path>`; a guard file holding the word `red` fails, anything else passes.
grep -q red "$2" 2>/dev/null && exit 1
exit 0
EOF
chmod +x "$gatepen/rishi/bin/rishi"
: > "$gatepen/ok.sh"
echo red > "$gatepen/parked.sh"
echo red > "$gatepen/broken.sh"
cat > "$gatepen/roster.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path ok.sh
tier lap
seated 20260830.000000

guard parked
path parked.sh
tier lap
gate %5
seated 20260830.000000
EOF

run_gate() { ( cd "$gatepen" && STANDING_ROSTER=roster.kyri STANDING_CARD="$1" \
  STANDING_RECEIPT=construction/receipt.kyri sh "$runner" 2>/dev/null ) || true; }

# A gated red does not refuse the pass, is counted apart from a broken one, and is DISCLOSED.
out=$(run_gate gate-card.kyri)
case "$out" in *"guards_red=0"*) echo "gated_red_not_counted_red=yes" ;; *) echo "gated_red_not_counted_red=no" ;; esac
case "$out" in *"guards_gated=1"*) echo "gated_counted_apart=yes" ;; *) echo "gated_counted_apart=no" ;; esac
case "$out" in *"gated_at=parked(%5)"*) echo "gate_disclosed_on_run=yes" ;; *) echo "gate_disclosed_on_run=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "gated_only_close_passes=yes" ;; *) echo "gated_only_close_passes=no" ;; esac

# ...and the receipt it earns says what it chained past, rather than a bare green.
if grep -q '^gated 1$' "$gatepen/construction/receipt.kyri" 2>/dev/null; then
  echo "receipt_names_gate_count=yes"; else echo "receipt_names_gate_count=no"; fi
if grep -q '^gated_at parked(%5)$' "$gatepen/construction/receipt.kyri" 2>/dev/null; then
  echo "receipt_names_the_gate=yes"; else echo "receipt_names_the_gate=no"; fi

# THE BITING DIRECTION. One ungated red still costs the receipt and still refuses -- otherwise the
# field is an off switch for the roster rather than a name for a parked reading.
rm -f "$gatepen/construction/receipt.kyri"
cat >> "$gatepen/roster.kyri" <<'EOF'

guard broken
path broken.sh
tier lap
seated 20260830.000000
EOF
out=$(run_gate broken-card.kyri)
case "$out" in *"guards_red=1"*) echo "ungated_red_still_red=yes" ;; *) echo "ungated_red_still_red=no" ;; esac
case "$out" in *"run_verdict=guard_red"*) echo "ungated_red_still_refuses=yes" ;; *) echo "ungated_red_still_refuses=no" ;; esac
case "$out" in *"roster_receipt_write=withheld_guard_red"*) echo "ungated_red_costs_receipt=yes" ;; *) echo "ungated_red_costs_receipt=no" ;; esac
if [ -f "$gatepen/construction/receipt.kyri" ]; then echo "broken_wrote_receipt=yes"; else echo "broken_wrote_receipt=no"; fi

# AN ABSENT PATH IS NEVER GATED. A guard whose file is gone proves nothing, whatever its row says,
# and letting a gate excuse absence turns the field into the exemption the tier words refuse to be.
cat > "$gatepen/roster.kyri" <<'EOF'
format standing-equipment-v1
guard vanished
path no-such-file.sh
tier lap
gate %5
seated 20260830.000000
EOF
out=$(run_gate absent-card.kyri)
case "$out" in *"guards_red=1"*) echo "gated_absent_still_red=yes" ;; *) echo "gated_absent_still_red=no" ;; esac
case "$out" in *"run_verdict=guard_red"*) echo "gated_absent_still_refuses=yes" ;; *) echo "gated_absent_still_refuses=no" ;; esac

# THE VOCABULARY IS THE CARD'S. A gate the card never declares is refused by the scan, and a card
# that cannot be read empties the vocabulary and refuses EVERY gate -- fail closed, since an
# unreadable card is the one state where a gate claim has nothing at all behind it.
scan_gate() { ( cd "$gatepen" && CARD_PIN="$1" STANDING_ROSTER=roster.kyri \
  STANDING_CARD=absent-card.kyri sh "$scan" 2>&1 ) || true; }
cat > "$gatepen/card-with-5.md" <<'EOF'
## Custody gates -- an autonomous agent STOPS here and surfaces (never crosses)
5. **Deep debride** -- named target, the maintainer's explicit word.
Everything else is agent-doable.
EOF
cat > "$gatepen/card-without-5.md" <<'EOF'
## Custody gates -- an autonomous agent STOPS here and surfaces (never crosses)
1. **The seed** -- each refresh takes its own word.
Everything else is agent-doable.
EOF
out=$(scan_gate card-with-5.md)
case "$out" in *"guards_unknown_gate=0"*) echo "card_declared_gate_welcomed=yes" ;; *) echo "card_declared_gate_welcomed=no" ;; esac
out=$(scan_gate card-without-5.md)
case "$out" in *"guards_unknown_gate=1"*) echo "undeclared_gate_refused=yes" ;; *) echo "undeclared_gate_refused=no" ;; esac
out=$(scan_gate no-such-card.md)
case "$out" in *"guards_unknown_gate=1"*) echo "unreadable_card_fails_closed=yes" ;; *) echo "unreadable_card_fails_closed=no" ;; esac
rm -rf "$gatepen"

# --- a guard running mid-pass reads THIS pass's verdicts, not the last pass's (REDS %483) -------
# The run card in the working tree is written once, at the close, so every guard reading it mid-pass
# read the PREVIOUS pass's verdict for its peers -- including reds that same pass had already
# repaired. The repair has two halves and this pen proves both: each guard is handed a pen-local
# live view through `STANDING_CARD`, and the runner's own guard is deferred to the end of the todo
# list, so the record describes the pass that is running AND is complete by the time the guard that
# reads it runs.
#
# The planted card records `alpha` RED. `alpha` runs green this pass, and `beta` -- running after it
# -- reads the card it was handed and refuses unless alpha reads green there. So `beta green` proves
# the live view reached the guard and `beta red` proves it did not. `standing_equipment` is listed
# FIRST in the roster and must print LAST, which is the only reading that can tell a deferred guard
# from a roster that happened to be in a lucky order.
livepen="$pen/livepen"
mkdir -p "$livepen/rishi/bin"
( cd "$livepen" && git init -q . && git config user.email a@b.c && git config user.name t \
  && git config commit.gpgsign false && echo seed > kept.txt && git add kept.txt \
  && git commit -qm "seed" ) >/dev/null 2>&1

cat > "$livepen/roster.kyri" <<'EOF'
format standing-equipment-v1
guard standing_equipment
path se.sh
tier lap
seated 20260825.000000
guard alpha
path alpha.sh
tier lap
seated 20260825.000000
guard beta
path beta.sh
tier lap
seated 20260825.000000
EOF
: > "$livepen/se.sh"
: > "$livepen/alpha.sh"
: > "$livepen/beta.sh"
plant_live_card() {
  cat > "$livepen/run-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran standing_equipment 20260101.000000 green lap 1
ran alpha 20260101.000000 red lap 1
ran beta 20260101.000000 green lap 1
EOF
}
plant_live_card

# The stub reads the card it was handed only when it stands in for beta, so every other guard's run
# is an ordinary green and the single reading under test is what beta could see when its turn came.
cat > "$livepen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
case "${2:-}" in
  *beta.sh)
    [ -n "${STANDING_CARD:-}" ] || exit 1
    grep -q '^ran alpha [0-9.]* green ' "$STANDING_CARD" || exit 1
    ;;
esac
exit 0
EOF
chmod +x "$livepen/rishi/bin/rishi"

out=$( ( cd "$livepen" && STANDING_ROSTER=roster.kyri STANDING_CARD=run-card.kyri \
        sh "$runner" 2>/dev/null ) || true )
case "$out" in *"beta green"*) echo "live_card_reaches_guard=yes" ;; *) echo "live_card_reaches_guard=no" ;; esac
case "$out" in *"guards_red=0"*) echo "live_card_clears_stale_red=yes" ;; *) echo "live_card_clears_stale_red=no" ;; esac
case "$out" in *"run_verdict=ok"*) echo "live_card_pass_ok=yes" ;; *) echo "live_card_pass_ok=no" ;; esac
# The self guard is listed first and runs last, so the live view it reads is complete.
se_line=$(printf '%s\n' "$out" | grep -n '^standing_equipment ' | head -1 | cut -d: -f1)
beta_line=$(printf '%s\n' "$out" | grep -n '^beta ' | head -1 | cut -d: -f1)
if [ -n "$se_line" ] && [ -n "$beta_line" ] && [ "$se_line" -gt "$beta_line" ]; then
  echo "self_guard_runs_last=yes"; else echo "self_guard_runs_last=no"; fi
# The working-tree card is still written once, at the close, and now carries this pass's verdicts.
if grep -q '^ran alpha [0-9.]* green ' "$livepen/run-card.kyri"; then
  echo "live_card_close_writes_tree=yes"; else echo "live_card_close_writes_tree=no"; fi

# THE PEN PROVEN INNOCENT. A runner with the hand-off stripped leaves every guard reading the
# working-tree card, which records alpha RED at the moment beta runs -- so beta refuses and the pass
# carries a red nothing in it caused. Same pen, same roster, same stub; one line removed, the card
# re-planted so the elder reading is the only difference, and the removal asserted rather than
# assumed -- a grep that matched nothing would prove a repair by testing the repaired runner twice.
# The runner sources `shell_portable.sh` from its OWN directory rather than from the root, so a copy
# that stands anywhere else cannot start at all -- which is a refusal that looks exactly like the
# repair working. The sibling travels with the copy, and the run below is read for a GUARD line
# rather than only for the absence of one.
grep -v '^export STANDING_CARD=' "$runner" > "$pen/run-blind.sh"
# EVERY SIBLING THE RUNNER SOURCES TRAVELS WITH A PEN COPY OF IT. The runner resolves its own
# directory and sources from there, so a copy placed in a pen reads the pen's siblings -- and a
# missing one kills the copy at its first line, which reads exactly like the hand-off fault this
# phase exists to show. Adding `scope_match.sh` to the runner caught this the same lap: every
# reading below answered `no` for a reason that had nothing to do with the card.
cp "$(dirname "$runner")/shell_portable.sh" "$pen/shell_portable.sh"
cp "$(dirname "$runner")/scope_match.sh" "$pen/scope_match.sh"
if [ "$(wc -l < "$runner")" -gt "$(wc -l < "$pen/run-blind.sh")" ]; then
  echo "blind_runner_built=yes"; else echo "blind_runner_built=no"; fi
plant_live_card
out=$( ( cd "$livepen" && STANDING_ROSTER=roster.kyri STANDING_CARD=run-card.kyri \
        sh "$pen/run-blind.sh" 2>/dev/null ) || true )
case "$out" in *"beta red"*) echo "blind_runner_reads_stale=yes" ;; *) echo "blind_runner_reads_stale=no" ;; esac
case "$out" in *"run_verdict=guard_red"*) echo "blind_runner_refuses=yes" ;; *) echo "blind_runner_refuses=no" ;; esac
# THE BLIND RUNNER MUST ACTUALLY RUN. A copy that cannot start prints no guard line at all, and
# every reading above would then answer `no` for a reason that has nothing to do with the hand-off.
case "$out" in *"alpha green"*) echo "blind_runner_ran=yes" ;; *) echo "blind_runner_ran=no" ;; esac
rm -rf "$livepen"

echo "control_verdict=ok"
