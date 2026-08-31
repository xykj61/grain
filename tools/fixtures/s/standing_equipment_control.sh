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
#   A run card recording a red verdict is refused.
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
if grep -qE "^ran alpha [0-9.]+ green lap [0-9][0-9]*$" "$pen/run-card.kyri"; then
  echo "runner_records_seconds=yes"
else
  echo "runner_records_seconds=no"
fi
case "$out" in *"guards_seconds="*) echo "runner_totals_seconds=yes" ;; *) echo "runner_totals_seconds=no" ;; esac

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

# A full roster may run past the host's lease on /tmp. The runner's own pen
# therefore lives under .git whenever a repository exists. Plant a hostile
# temporary-directory reclaim inside the guard: the run must still append its
# card and close cleanly. With the elder mktemp-only runner, the guard deletes
# the runner's pen too and the pass dies before it can write `ran alpha`.
mkdir -p "$gitpen/host-tmp"
cat > "$gitpen/rishi/bin/rishi" <<'EOF'
#!/bin/sh
rm -rf "$TMPDIR"
exit 0
EOF
chmod +x "$gitpen/rishi/bin/rishi"
out=$( ( cd "$gitpen" && TMPDIR="$gitpen/host-tmp" STANDING_ROSTER=quiet.kyri \
        STANDING_CARD=lease-card.kyri sh "$runner" 2>/dev/null ) || true )
case "$out" in *"run_verdict=ok"*) echo "git_pen_survives_tmp_reclaim=yes" ;; *) echo "git_pen_survives_tmp_reclaim=no" ;; esac
if grep -q '^ran alpha ' "$gitpen/lease-card.kyri" 2>/dev/null; then
  echo "git_pen_keeps_run_card=yes"
else
  echo "git_pen_keeps_run_card=no"
fi

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
#    cold pass opens rather than refusing, and the only thing that changes is the file's bytes.
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
case "$out" in *"run_verdict=ok"*) echo "clean_cold_passes=yes" ;; *) echo "clean_cold_passes=no" ;; esac

# The refusing side: one path staged and never committed, and the bare pass refuses.
( cd "$gitpen" && echo staged > left_behind.txt && git add left_behind.txt ) >/dev/null 2>&1 || true
out=$(run_gitpen)
case "$out" in *"run_verdict=lap_unclosed"*) echo "staged_cold_refuses=yes" ;; *) echo "staged_cold_refuses=no" ;; esac
# It refuses BEFORE the first guard, so no guard line and no tree digest appear above it.
case "$out" in *"alpha green"*) echo "staged_cold_refuses_early=no" ;; *) echo "staged_cold_refuses_early=yes" ;; esac
case "$out" in *"tree_at_open="*) echo "staged_cold_skips_digest=no" ;; *) echo "staged_cold_skips_digest=yes" ;; esac

# `--hot` is how a round says the staged paths are its own -- the after-`git add` pass.
out=$(run_gitpen --hot)
case "$out" in *"run_verdict=ok"*) echo "staged_hot_passes=yes" ;; *) echo "staged_hot_passes=no" ;; esac
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


# ONE PASS AT A TIME (REDS %359). Two cold passes stood in this pier's own tree for fifty minutes
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

echo "control_verdict=ok"
