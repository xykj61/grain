#!/bin/sh
# tools/fixtures/r/rank_outcome_control.sh -- proves tools/fixtures/r/rank_outcome_scan.sh from
# both sides on PLANTED pages, then bites four mutations.
#
# The scan reads exactly one input -- the page handed to --page -- and opens no other file, so a
# planted Markdown page in a pen directory is a COMPLETE subject and no git repository is needed
# to hold it. The pen lives under this root rather than under the system temporary directory,
# because the scan resolves the repository root before it reads and a subject outside that root
# makes a walk failure look exactly like a bitten mutation. A SHAM leg runs an unmutated copy of
# the scan from the same pen, so a pen that breaks every copy is visible rather than silent.
#
# Ordering statistics are proven against closed forms: the identity permutation reads rho 1 and
# tau 1, a full reversal reads rho -1 and tau -1, and one adjacent swap in a run of ten reads
# rho = 1 - 6*2/(10*99) = 0.9879 with 44 concordant pairs against 1 discordant.
#
# Exit 0 always. Prints leg=<name> pass|fail lines, a leg tally, and control_verdict.
set -u

MAX_LEGS=128
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
SCAN="$ROOT/tools/fixtures/r/rank_outcome_scan.sh"
[ -f "$SCAN" ] || SCAN="$ROOT/.lap/rank_outcome_scan.sh"
PEN="$ROOT/.lap/pen-rank-outcome-$$"
legs=0; failed=0

cleanup() { rm -rf "$PEN"; }
trap cleanup EXIT HUP INT TERM
mkdir -p "$PEN" || { echo "control_verdict=no_pen"; exit 0; }

leg() { # leg <name> <expected> <actual>
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg=$1 pass"
  else
    echo "leg=$1 fail expected=$2 actual=$3"
    failed=$((failed + 1))
  fi
}
key() { grep -m1 "^$2=" "$1" | sed "s/^$2=//"; }

# ---- page builder -------------------------------------------------------------
# ranks: a space-separated list giving, for read position 1..n, the RANK read at that position.
# Each row gets a distinct stamp in read order, so the page bytes carry the order.
build() { # build <file> <ranks-in-read-order> [extra-body]
  f=$1; order=$2; extra=${3:-}
  n=0; for r in $order; do n=$((n + 1)); done
  {
    echo "# A planted page"
    echo
    i=0
    for r in $order; do
      i=$((i + 1))
      mm=$(printf '%02d' "$i")
      echo "**Row $r erratum:** \`20260101.0000$mm\` -- planted. Recommended re-aim: keep it."
    done
    [ -n "$extra" ] && echo "$extra"
    echo
    echo "## The ranking"
    echo
    echo "| Rank | Row | Why here |"
    echo "|---|---|---|"
    k=0
    while [ "$k" -lt "$n" ]; do
      k=$((k + 1))
      echo "| $k | $k. planted row $k | planted |"
    done
  } > "$f"
}

run() { sh "$1" --page "$2" 2>/dev/null; }

# ---- leg group 1: closed forms on planted permutations ------------------------
build "$PEN/identity.md" "1 2 3 4 5 6 7 8 9 10"
run "$SCAN" "$PEN/identity.md" > "$PEN/out.identity"
leg identity_verdict graded "$(key "$PEN/out.identity" verdict)"
leg identity_rho "1.0000" "$(key "$PEN/out.identity" all_spearman_rho)"
leg identity_tau "1.0000" "$(key "$PEN/out.identity" all_kendall_tau)"
leg identity_discordant 0 "$(key "$PEN/out.identity" all_discordant)"
leg identity_concordant 45 "$(key "$PEN/out.identity" all_concordant)"
leg identity_sumd2 0 "$(key "$PEN/out.identity" all_sum_d2)"
leg identity_fully_read yes "$(key "$PEN/out.identity" page_fully_read)"

build "$PEN/reverse.md" "10 9 8 7 6 5 4 3 2 1"
run "$SCAN" "$PEN/reverse.md" > "$PEN/out.reverse"
leg reverse_rho "-1.0000" "$(key "$PEN/out.reverse" all_spearman_rho)"
leg reverse_tau "-1.0000" "$(key "$PEN/out.reverse" all_kendall_tau)"
leg reverse_concordant 0 "$(key "$PEN/out.reverse" all_concordant)"
leg reverse_discordant 45 "$(key "$PEN/out.reverse" all_discordant)"
leg reverse_sumd2 330 "$(key "$PEN/out.reverse" all_sum_d2)"

build "$PEN/swap.md" "1 2 3 4 5 6 7 9 8 10"
run "$SCAN" "$PEN/swap.md" > "$PEN/out.swap"
leg swap_rho "0.9879" "$(key "$PEN/out.swap" all_spearman_rho)"
leg swap_sumd2 2 "$(key "$PEN/out.swap" all_sum_d2)"
leg swap_concordant 44 "$(key "$PEN/out.swap" all_concordant)"
leg swap_discordant 1 "$(key "$PEN/out.swap" all_discordant)"
leg swap_tau "0.9556" "$(key "$PEN/out.swap" all_kendall_tau)"

# ---- leg group 2: refusals, each planted then lifted --------------------------
run "$SCAN" "$PEN/nothing-here.md" > "$PEN/out.absent"
leg absent_verdict no_page "$(key "$PEN/out.absent" verdict)"
leg absent_present no "$(key "$PEN/out.absent" page_present)"

printf '# no ranking at all\n\n**Row 1 erratum:** `20260101.000001` -- planted.\n' > "$PEN/norank.md"
run "$SCAN" "$PEN/norank.md" > "$PEN/out.norank"
leg norank_verdict no_ranking "$(key "$PEN/out.norank" verdict)"
leg norank_ranked 0 "$(key "$PEN/out.norank" ranked_rows)"

build "$PEN/partly.md" "1 2 3"
sed -i.bak '/^\*\*Row 3 erratum/d' "$PEN/partly.md" && rm -f "$PEN/partly.md.bak"
run "$SCAN" "$PEN/partly.md" > "$PEN/out.partly"
leg partly_verdict partly_read "$(key "$PEN/out.partly" verdict)"
leg partly_missing 1 "$(key "$PEN/out.partly" rows_without_erratum)"
leg partly_fully_read no "$(key "$PEN/out.partly" page_fully_read)"
# lift the plant: the same page whole reads graded again
build "$PEN/partly2.md" "1 2 3"
run "$SCAN" "$PEN/partly2.md" > "$PEN/out.partly2"
leg partly_lifted graded "$(key "$PEN/out.partly2" verdict)"
leg partly_lifted_missing 0 "$(key "$PEN/out.partly2" rows_without_erratum)"

# ---- leg group 3: ties, second errata, prebuilt subset ------------------------
build "$PEN/tie.md" "1 2 3"
sed -i.bak 's/20260101.000002/20260101.000001/' "$PEN/tie.md" && rm -f "$PEN/tie.md.bak"
run "$SCAN" "$PEN/tie.md" > "$PEN/out.tie"
leg tie_counted 1 "$(key "$PEN/out.tie" stamp_ties)"
leg tie_no_tie_baseline 0 "$(key "$PEN/out.identity" stamp_ties)"

build "$PEN/second.md" "1 2 3" "**Row 2 second erratum:** \`20260101.000099\` -- planted. Recommended disposition: **breach** -- superseded."
run "$SCAN" "$PEN/second.md" > "$PEN/out.second"
leg second_counted 1 "$(key "$PEN/out.second" later_errata)"
leg second_first_unchanged 3 "$(key "$PEN/out.second" errata_first)"
leg second_lines 4 "$(key "$PEN/out.second" errata_lines)"
leg second_breach_final 1 "$(key "$PEN/out.second" final_breach)"
leg second_breach_first 0 "$(key "$PEN/out.second" rec_breach)"
leg baseline_no_second 0 "$(key "$PEN/out.identity" later_errata)"

# a prebuilt row is lifted out of the subset statistic: plant one at rank 1, read LAST
build "$PEN/pre.md" "2 3 4 5 6 7 8 9 10 1"
sed -i.bak 's/^\(\*\*Row 1 erratum:\*\* `[0-9.]*` -- planted\.\)/\1 The first witness landed on `20251231.000000`./' "$PEN/pre.md" && rm -f "$PEN/pre.md.bak"
run "$SCAN" "$PEN/pre.md" > "$PEN/out.pre"
leg pre_detected 1 "$(key "$PEN/out.pre" prebuilt_rows)"
leg pre_rank "1" "$(key "$PEN/out.pre" prebuilt_ranks)"
leg pre_position "10" "$(key "$PEN/out.pre" prebuilt_read_positions)"
# with the prebuilt row in, the order is badly out; with it lifted, the rest is perfect
leg pre_all_rho_low "0.4545" "$(key "$PEN/out.pre" all_spearman_rho)"
leg pre_own_rho_perfect "1.0000" "$(key "$PEN/out.pre" own_spearman_rho)"
leg pre_own_discordant 0 "$(key "$PEN/out.pre" own_discordant)"
leg pre_own_pairs 36 "$(key "$PEN/out.pre" own_pairs)"
leg baseline_pre_none 0 "$(key "$PEN/out.identity" prebuilt_rows)"

# ---- leg group 4: the falsifier classifier, each class planted ---------------
fal() { # fal <name> <sentence> <expected-key>
  build "$PEN/f.md" "1"
  sed -i.bak "s/planted\. Recommended re-aim: keep it\./planted. $2/" "$PEN/f.md" && rm -f "$PEN/f.md.bak"
  run "$SCAN" "$PEN/f.md" > "$PEN/out.f"
  leg "$1" 1 "$(key "$PEN/out.f" "$3")"
}
fal fals_incapable "The row own falsifier cannot fire at all." falsifier_incapable
fal fals_incapable_zero "Its falsifier fires at radius ZERO here." falsifier_incapable
fal fals_settled "The row own falsifier is refused by construction rather than by a race." falsifier_settled
fal fals_misaimed "Its falsifier fires on seated code rather than on a future process." falsifier_misaimed
fal fals_named "Its falsifier is stated and stands." falsifier_named
fal fals_silent "Nothing is said about that word here." falsifier_silent

# a row that stands wants BOTH a green reading and no recommendation
build "$PEN/stands.md" "1"
sed -i.bak 's/planted\. Recommended re-aim: keep it\./planted. It is GREEN on metal./' "$PEN/stands.md" && rm -f "$PEN/stands.md.bak"
run "$SCAN" "$PEN/stands.md" > "$PEN/out.stands"
leg stands_counted 1 "$(key "$PEN/out.stands" claim_stands)"
build "$PEN/greenreaim.md" "1"
sed -i.bak 's/planted\. Recommended re-aim: keep it\./planted. It is GREEN on metal. Recommended re-aim: keep it./' "$PEN/greenreaim.md" && rm -f "$PEN/greenreaim.md.bak"
run "$SCAN" "$PEN/greenreaim.md" > "$PEN/out.greenreaim"
leg green_with_reaim_not_standing 0 "$(key "$PEN/out.greenreaim" claim_stands)"
leg green_with_reaim_altered 1 "$(key "$PEN/out.greenreaim" claim_altered)"
build "$PEN/blocked.md" "1"
sed -i.bak 's/planted\. Recommended re-aim: keep it\./planted. The witness cannot be built here./' "$PEN/blocked.md" && rm -f "$PEN/blocked.md.bak"
run "$SCAN" "$PEN/blocked.md" > "$PEN/out.blocked"
leg blocked_counted 1 "$(key "$PEN/out.blocked" claim_blocked)"
leg blocked_not_standing 0 "$(key "$PEN/out.blocked" claim_stands)"

# ---- leg group 5: the bound refuses an overlong erratum line -----------------
build "$PEN/long.md" "1 2"
pad=$(awk 'BEGIN{ for(i=0;i<70000;i++) printf "x" }')
sed -i.bak "s/^\(\*\*Row 2 erratum:\*\* \`[0-9.]*\`\)/\1 $pad/" "$PEN/long.md" && rm -f "$PEN/long.md.bak"
run "$SCAN" "$PEN/long.md" > "$PEN/out.long"
leg long_refused 1 "$(key "$PEN/out.long" overlong_lines)"
leg long_leaves_row_unread 1 "$(key "$PEN/out.long" rows_without_erratum)"
leg baseline_none_overlong 0 "$(key "$PEN/out.identity" overlong_lines)"

# ---- leg group 6: the sham, then four mutations ------------------------------
cp "$SCAN" "$PEN/sham.sh"
run "$PEN/sham.sh" "$PEN/swap.md" > "$PEN/out.sham"
leg sham_unmutated_agrees "0.9879" "$(key "$PEN/out.sham" all_spearman_rho)"
leg sham_verdict graded "$(key "$PEN/out.sham" verdict)"

mutate() { # mutate <name> <sed-expr> <page> <key> <baseline>
  cp "$SCAN" "$PEN/m.sh"
  sed -i.bak "$2" "$PEN/m.sh" && rm -f "$PEN/m.sh.bak"
  run "$PEN/m.sh" "$3" > "$PEN/out.m"
  got=$(key "$PEN/out.m" "$4")
  legs=$((legs + 1))
  if [ "$got" != "$5" ]; then
    echo "leg=$1 pass bit baseline=$5 mutant=$got"
  else
    echo "leg=$1 fail mutation not bitten: $4 still $5"
    failed=$((failed + 1))
  fi
}
# M1 -- drop the subset relative-rank conversion; the offset reads as disagreement
mutate mutation_relative_rank 's/if (sub_rank\[j\] < sub_rank\[i\]) rel++/if (0) rel++/' \
  "$PEN/pre.md" own_spearman_rho "1.0000"
# M2 -- let a green reading alone mean the row stands
mutate mutation_stands_conjunction 's/green_of\[rw\] \&\& lc == "none"/green_of[rw]/' \
  "$PEN/greenreaim.md" claim_stands 0
# M3 -- count a second erratum as a first one
mutate mutation_second_erratum 's/second = (body ~ \/\^\\\*\\\*Row \[0-9\]+ second erratum\/) ? 1 : 0/second = 0/' \
  "$PEN/second.md" errata_first 3
# M4 -- sort the read order the other way
mutate mutation_sort_direction 's/if (ord_stamp\[j\] < ord_stamp\[j-1\])/if (ord_stamp[j] > ord_stamp[j-1])/' \
  "$PEN/swap.md" all_spearman_rho "0.9879"

echo "legs=$legs"
echo "legs_failed=$failed"
echo "max_legs=$MAX_LEGS"
if [ "$legs" -gt "$MAX_LEGS" ]; then echo "control_verdict=over_bound"; else
  if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=legs_failed"; fi
fi
