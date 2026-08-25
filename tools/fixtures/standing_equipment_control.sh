#!/bin/sh
# tools/fixtures/standing_equipment_control.sh -- prove the roster meter and its runner, both ways.
#
# WHY. A guard that cannot red guards nothing -- the grain seats that strand
# (foundations/20260702-184312_the-grain-and-the-crossing.md, REDS row 59). This builds
# throwaway rosters and run cards in a temporary directory and proves each refusal the
# scan claims, beside rosters that pass free so every gate is known to have a green side.
#
# WHAT THE SCAN PROVES.
#   A roster naming a path that is absent from disk is refused.
#   A guard record with no path line, or with two, is refused as half-written.
#   A run card naming a guard the roster never seated is refused.
#   A run card recording a red verdict is refused.
#   A tier the runner does not know is refused, and counted.
#   A whole roster whose paths exist, with a card of greens, passes free -- with or without tiers.
#
# WHAT THE RUNNER PROVES, which a scan reading a file cannot. A tier is only a cadence if the
# runner honors it, so the runner is driven over a planted two-row roster with a stub interpreter:
# a bare run takes the every-lap tier alone, `--tier cadence` takes exactly that tier, `--all`
# takes both, a guard named by hand runs whatever its tier, and a pass keeps the run-card lines
# of the guards it did not run. The pen is no git repository, which is its own case: the staged
# reading answers 0 rather than refusing.
#
# USAGE
#   sh tools/fixtures/standing_equipment_control.sh
#
# Driven by tools/s/standing_equipment_witness.rish. Run from the repository root.

set -eu

scan="$(pwd)/tools/fixtures/standing_equipment_scan.sh"
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
runner="$(pwd)/tools/fixtures/standing_equipment_run.sh"
mkdir -p "$pen/rishi/bin"
cat > "$pen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
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
if grep -q "^ran alpha .* lap$" "$pen/run-card.kyri" && ! grep -q "^ran choir " "$pen/run-card.kyri"; then
  echo "default_card_lap_only=yes"
else
  echo "default_card_lap_only=no"
fi

out=$(run_runner --tier cadence)
case "$out" in *"guards_run=1"*) echo "tier_selects_one=yes" ;; *) echo "tier_selects_one=no" ;; esac
# The earlier pass's line survives, so a slower tier never erases the faster one's history.
if grep -q "^ran alpha " "$pen/run-card.kyri" && grep -q "^ran choir .* cadence$" "$pen/run-card.kyri"; then
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

echo "control_verdict=ok"
