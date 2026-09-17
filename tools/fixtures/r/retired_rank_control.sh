#!/bin/sh
# tools/fixtures/r/retired_rank_control.sh -- prove the ranking reading by doing, on synthetic arms
# whose right answer is known before the run.
#
# WHY. A guard that cannot red guards nothing (REDS %59). The interesting output of
# tools/fixtures/r/retired_rank_scan.sh is one word -- agree=yes -- and a scan hard-wired to print
# it would read identically on this pier. So every leg here plants an arm pair whose true order is
# arranged rather than discovered, and asserts both the verdict and the arm the scan names.
#
# THE CENTREPIECE IS THE DISAGREEMENT. A pair where one arm SLEEPS and the other COMPUTES is the
# demarcation case the scan's own header names: the clock ranks the sleeper expensive and the
# counter ranks it cheap, because a sleeping process retires almost no instructions. That is the
# proxy's true boundary rather than a defect in it, and the scan must say `agree=no` out loud when
# it meets one. A reading that could never disagree would tell a lane nothing when it agreed.
#
# WHAT IS NOT PROVEN HERE. Whether retired instructions track joules -- no joule is readable on this
# pier (tools/fixtures/e/energy_instrument_scan.sh, joule_source=none), so that stays a stated
# assumption of the row rather than a measurement. Only that the instrument reports what it read,
# names the cheaper arm correctly on each reading, and refuses rather than guessing when it cannot.
#
# USAGE
#   sh tools/fixtures/r/retired_rank_control.sh
#
# Driven by tools/r/retired_rank_witness.rish. Nothing here writes to the tree it runs from.

set -u

scan=$(pwd)/tools/fixtures/r/retired_rank_scan.sh
bin=$(pwd)/tools/bin/retired-exec
[ -f "$scan" ] || { echo "control_verdict=scan_missing"; exit 1; }

legs=0
failed=0

# One leg: run the scan over a planted pair and require a key line back.
leg() {
  _name=$1; _want=$2; shift 2
  legs=$((legs + 1))
  _out=$(sh "$scan" "$@" 2>&1)
  if echo "$_out" | grep -qxF "$_want"; then
    echo "leg=$_name reading=$_want ok"
  else
    failed=$((failed + 1))
    echo "leg=$_name reading=$_want MISSING"
    echo "$_out" | sed 's/^/  detail: /'
  fi
}

# A bounded shell spin of a named size: more iterations is strictly more retired instructions and
# strictly more wall time, so both readings have the same right answer by construction.
spin() { echo "i=0; while [ \$i -lt $1 ]; do i=\$((i+1)); done"; }

# -- the refusals, each planted and then lifted -------------------------------------------------
leg arms_missing        "verdict=arms_missing"
leg arm_unreadable      "verdict=arm_unreadable"      --a "nocolon" --b "b:true"
leg reps_out_of_bounds  "verdict=reps_out_of_bounds"  --a "a:true" --b "b:true" --reps 2
leg reps_unreadable     "verdict=reps_unreadable"     --a "a:true" --b "b:true" --reps many
leg arm_failed          "verdict=arm_failed"          --a "a:exit 1" --b "b:$(spin 2000)" --reps 3

# -- the agreements: more work is dearer on both readings ---------------------------------------
leg agree_small_first   "agree=yes"                   --a "small:$(spin 2000)"  --b "large:$(spin 400000)" --reps 3
leg agree_verdict_ok    "verdict=ok"                  --a "small:$(spin 2000)"  --b "large:$(spin 400000)" --reps 3
leg names_cheaper_ins   "instructions_cheaper=small"  --a "small:$(spin 2000)"  --b "large:$(spin 400000)" --reps 3
leg names_cheaper_wall  "wall_cheaper=small"          --a "small:$(spin 2000)"  --b "large:$(spin 400000)" --reps 3
# The arms are handed over in the opposite order, so a scan that simply always names its `--a` arm
# passes the two legs above and reds here.
leg order_not_position  "instructions_cheaper=small"  --a "large:$(spin 400000)" --b "small:$(spin 2000)" --reps 3

# -- the disagreement, which is the boundary the header names -----------------------------------
leg disagree_verdict    "verdict=rank_disagreement"   --a "sleeper:sleep 2" --b "worker:$(spin 80000)" --reps 3
leg disagree_word       "agree=no"                    --a "sleeper:sleep 2" --b "worker:$(spin 80000)" --reps 3
leg disagree_counter    "instructions_cheaper=sleeper" --a "sleeper:sleep 2" --b "worker:$(spin 80000)" --reps 3
leg disagree_clock      "wall_cheaper=worker"         --a "sleeper:sleep 2" --b "worker:$(spin 80000)" --reps 3

# -- two arms that are one arm: no order is claimed ----------------------------------------------
leg too_close_verdict   "verdict=too_close"           --a "twin_a:$(spin 200000)" --b "twin_b:$(spin 200000)" --reps 5
leg too_close_word      "agree=undecided"             --a "twin_a:$(spin 200000)" --b "twin_b:$(spin 200000)" --reps 5

# -- the counter is read rather than declared ----------------------------------------------------
leg tier_named          "tier=counters"               --a "small:$(spin 2000)" --b "large:$(spin 400000)" --reps 3

# -- a mutation that must bite: strike the interleave and both arms still rank the same way, so the
#    reading that actually holds is the non-zero refusal above. This leg instead mutates the ORDER
#    function to always name the first arm, and requires the order_not_position leg to have caught
#    it -- proven by running that same pair against the mutated copy.
mut=$(mktemp) || { echo "control_verdict=pen_refused"; exit 2; }
sed 's|print (x < y) ? la : lb|print la|' "$scan" > "$mut"
legs=$((legs + 1))
mut_out=$(sh "$mut" --a "large:$(spin 400000)" --b "small:$(spin 2000)" --reps 3 2>&1)
if echo "$mut_out" | grep -qxF "instructions_cheaper=large"; then
  echo "leg=mutation_bites reading=always_first_arm ok"
else
  failed=$((failed + 1))
  echo "leg=mutation_bites reading=always_first_arm MISSING"
fi
rm -f "$mut"

# -- the binary's own seam: an absent counter is named rather than guessed -----------------------
legs=$((legs + 1))
if [ -x "$bin" ] && "$bin" "true" 2>&1 >/dev/null | grep -q 'tier='; then
  echo "leg=binary_names_tier reading=tier ok"
else
  failed=$((failed + 1))
  echo "leg=binary_names_tier reading=tier MISSING"
fi

echo "control_legs=$legs"
echo "control_failed=$failed"
[ "$failed" -eq 0 ] && echo "control_verdict=ok" || echo "control_verdict=legs_failed"
