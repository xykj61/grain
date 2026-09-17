#!/bin/sh
# tools/fixtures/c/control_leg_heard_control.sh -- proves tools/fixtures/c/control_leg_heard_scan.sh
# on planted control-witness pairs in a throwaway git pen, every refusal shown from both sides.
#
#   sh tools/fixtures/c/control_leg_heard_control.sh
#
# Each leg prints `<name>=yes` where the scan behaved and `<name>=no` elsewhere, so a reader sees
# one line per behavior. The tally at the tail is asserted by the witness beside the named legs,
# which is the very wall this family exists to count, kept here so this pen holds itself to the
# standard it measures. Every plant is a real git repository, since the scan enumerates with
# `git ls-files` and a file merely on disk stays invisible to it. Each refusal is shown from both
# sides -- planted, read, then lifted -- because a refusal proven in the passing direction alone
# reads exactly like a bypass.

set -u
pen=$(mktemp -d); trap 'rm -rf "$pen"' EXIT
scan=$(pwd)/tools/fixtures/c/control_leg_heard_scan.sh
pass=0; fail=0
leg() { if [ "$2" = "$3" ]; then pass=$((pass+1)); echo "$1=yes"; else fail=$((fail+1)); echo "$1=no (got $2 want $3)"; fi }
val() { echo "$1" | grep "^$2=" | head -1 | cut -d= -f2-; }

# A pen is a real git repository, because the scan enumerates with `git ls-files` and a plant that
# is merely on disk is a plant the scan never sees.
mkpen() {
  d=$pen/$1; rm -rf "$d"; mkdir -p "$d/tools/fixtures/p" "$d/tools/p"
  ( cd "$d" && git init -q . && git config user.email a@b && git config user.name a \
    && git config commit.gpgsign false )
}
plant() { # plant <pen> <stem> <control body> <witness body>
  d=$pen/$1
  printf '%s\n' "$3" > "$d/tools/fixtures/p/$2_control.sh"
  printf '%s\n' "$4" > "$d/tools/p/$2_witness.rish"
  ( cd "$d" && git add -A && git commit -qm plant )
}
runscan() { ( cd "$pen/$1" && CONTROL_LEG_ROOT=. sh "$scan" ${2:-} ) 2>&1; }

# 1 -- A LEG NAMED IN THE WITNESS IS HEARD. The clean shape, asserted as hard as any refusal:
# a refusal proven only from the failing side cannot be told from a gate that always fires.
mkpen heard
plant heard alpha 'echo "plant_refused=yes"' 'assert control.out contains "plant_refused=yes" else "x"'
o=$(runscan heard)
leg heard_pair_counted "$(val "$o" pairs)" 1
leg heard_leg_reads_zero "$(val "$o" unheard)" 0
leg heard_verdict_ok "$(val "$o" verdict)" ok

# 2 -- AND THE SAME PAIR WITH THE ASSERT LIFTED READS ONE. The plant removed, so the leg is shown
# from both sides rather than asserted in the passing direction alone.
mkpen unheard
plant unheard alpha 'echo "plant_refused=yes"' 'say "nothing is asserted here"'
o=$(runscan unheard)
leg unheard_counted "$(val "$o" unheard)" 1
leg unheard_pair_counted "$(val "$o" pairs_with_unheard)" 1
leg unheard_named "$(runscan unheard --list | grep -c '^unheard alpha plant_refused')" 1

# 3 -- THE CEILING BITES, and is met from both sides. The boundary is READ OUT OF THE SCAN rather
# than spelled here, so a lowering reaches one line and this pen can never disagree with the gate
# it proves -- the same reason the register floor is cited rather than copied one family over.
ceil=$(grep -E '^CEILING=[0-9]+$' "$scan" | head -1 | cut -d= -f2)
leg ceiling_is_readable "$(echo "$ceil" | grep -c '^[0-9][0-9]*$')" 1

mkpen ceiling
i=0; body=''; while [ $i -le "$ceil" ]; do body="$body
echo \"leg_$i=yes\""; i=$((i+1)); done
plant ceiling alpha "$body" 'say "nothing asserted"'
o=$(runscan ceiling)
leg ceiling_bites_one_past "$(val "$o" unheard_ok)" no
leg ceiling_verdict_names_it "$(val "$o" verdict)" over_ceiling

mkpen at_ceiling
i=1; body=''; while [ $i -le "$ceil" ]; do body="$body
echo \"leg_$i=yes\""; i=$((i+1)); done
plant at_ceiling alpha "$body" 'say "nothing asserted"'
o=$(runscan at_ceiling)
leg ceiling_frees_at_the_bound "$(val "$o" unheard_ok)" yes
leg ceiling_bound_is_the_plant "$(val "$o" unheard)" "$ceil"

# 3b -- A LEG A SIBLING CAN ANSWER FOR IS MASKED, shown from both sides. `contains` is a raw
# substring, so the witness assert on `debt_paid` is satisfied by `ledger_debt_paid=yes` alone.
mkpen masked
plant masked alpha 'echo "debt_paid=yes"
echo "ledger_debt_paid=yes"' 'assert control.out contains "debt_paid=yes" else "x"
assert control.out contains "ledger_debt_paid=yes" else "x"'
o=$(runscan masked)
leg masked_counted "$(val "$o" masked)" 1
leg masked_pair_counted "$(val "$o" pairs_with_masked)" 1
leg masked_named "$(runscan masked --list | grep -c '^masked alpha debt_paid ledger_debt_paid$')" 1
leg masked_off_the_unheard_gate "$(val "$o" unheard)" 0

# And the same pair with the sibling renamed so neither name ends the other -- the cure, read.
mkpen unmasked
plant unmasked alpha 'echo "debt_paid=yes"
echo "ledger_debt_settled=yes"' 'assert control.out contains "debt_paid=yes" else "x"
assert control.out contains "ledger_debt_settled=yes" else "x"'
o=$(runscan unmasked)
leg unmasked_reads_zero "$(val "$o" masked)" 0
leg unmasked_verdict_ok "$(val "$o" verdict)" ok

# TWO SIBLINGS OVER ONE SHORT LEG ARE ONE HOLE, because one rename closes both.
mkpen masked_twice
plant masked_twice alpha 'echo "bitten=yes"
echo "fenced_bitten=yes"
echo "staged_bitten=yes"' 'assert control.out contains "bitten=yes" else "x"
assert control.out contains "fenced_bitten=yes" else "x"
assert control.out contains "staged_bitten=yes" else "x"'
o=$(runscan masked_twice)
leg masked_distinct_not_pairs "$(val "$o" masked)" 1
leg masked_lists_both_siblings "$(runscan masked_twice --list | grep -c '^masked alpha bitten ')" 2

# A LEG THE WITNESS NEVER NAMES IS UNHEARD RATHER THAN MASKED. The two readings name two faults
# with two cures, so a leg counted twice would book one repair against both ceilings.
mkpen masked_unnamed
plant masked_unnamed alpha 'echo "debt_paid=yes"
echo "ledger_debt_paid=yes"' 'say "nothing asserted"'
o=$(runscan masked_unnamed)
leg unnamed_is_unheard_not_masked "$(val "$o" masked)" 0
leg unnamed_counts_unheard "$(val "$o" unheard)" 2

# A GENERIC WALL IS IMMUNE, because it derives whole `=no` LINES and no substring reaches it.
mkpen masked_walled
plant masked_walled alpha 'echo "debt_paid=yes"
echo "ledger_debt_paid=yes"' 'assert control.out contains "legs_fail=0" else "x"'
o=$(runscan masked_walled)
leg walled_pair_not_masked "$(val "$o" masked)" 0

# THE MASK CEILING BITES, met from both sides and READ OUT OF THE SCAN, like the one above.
mceil=$(grep -E '^MASK_CEILING=[0-9]+$' "$scan" | head -1 | cut -d= -f2)
leg mask_bound_is_readable "$(echo "$mceil" | grep -c '^[0-9][0-9]*$')" 1
maskbody() { # maskbody <count>
  i=1; b=''; w=''
  while [ $i -le "$1" ]; do
    b="$b
echo \"short_$i=yes\"
echo \"long_short_$i=yes\""
    w="$w
assert control.out contains \"short_$i=yes\" else \"x\"
assert control.out contains \"long_short_$i=yes\" else \"x\""
    i=$((i+1))
  done
}
mkpen mask_over; maskbody $((mceil + 1)); plant mask_over alpha "$b" "$w"
o=$(runscan mask_over)
leg mask_bound_bites_one_past "$(val "$o" masked_ok)" no
leg mask_bound_verdict_names_it "$(val "$o" verdict)" over_mask_ceiling

mkpen mask_at; maskbody "$mceil"; plant mask_at alpha "$b" "$w"
o=$(runscan mask_at)
leg mask_bound_frees_at_it "$(val "$o" masked_ok)" yes
leg mask_bound_is_the_plant "$(val "$o" masked)" "$mceil"

# A NAME THE WITNESS QUOTES THAT THE CONTROL NEVER EMITS IS NO HOLE. `bound=4096` is a diagnostic
# figure rather than a leg, so nothing can read `no` there and nothing is masked -- the plant the
# intersect guard alone reaches.
mkpen masked_nonleg
plant masked_nonleg alpha 'echo "bound=4096"
echo "over_bound=yes"' 'assert control.out contains "bound=4096" else "x"
assert control.out contains "over_bound=yes" else "x"'
o=$(runscan masked_nonleg)
leg nonleg_name_not_masked "$(val "$o" masked)" 0

# 4 -- BOTH WALL SPELLINGS ARE CREDITED, each planted alone. Reading for the derived spelling
# alone, this scan first answered generic_wall=1 across the tree and called forty walls holes.
mkpen wall_derived
plant wall_derived alpha 'echo "a_leg=yes"' 'let failing = where (lines control.out) as l: l contains "=no"
assert (length failing) == 0 else "x"'
o=$(runscan wall_derived)
leg wall_derived_credited "$(val "$o" generic_wall)" 1
leg wall_derived_hears_all "$(val "$o" unheard)" 0

mkpen wall_tally
plant wall_tally alpha 'echo "a_leg=yes"' 'assert control.out contains "legs_fail=0" else "x"'
o=$(runscan wall_tally)
leg wall_tally_credited "$(val "$o" generic_wall)" 1
leg wall_tally_hears_all "$(val "$o" unheard)" 0

# 5 -- A DIAGNOSTIC FIELD IS NOT A LEG. A control printing a number for a reader owes no assert,
# and counting one would set the ceiling on noise. This is the reading that took the tree's first
# unheard count from 42 to 39.
mkpen diag
plant diag alpha 'echo "actual=$got"
echo "max_legs=$n"' 'say "nothing asserted"'
o=$(runscan diag)
leg diagnostic_not_a_leg "$(val "$o" unheard)" 0

# 6 -- A VARIABLE-VALUED LEG IS A LEG. Most controls in this tree emit `name=$var` where the
# control assigns the variable yes or no, and reading literals alone would miss nearly all of them.
mkpen varleg
plant varleg alpha 'v=yes
echo "over_named_by_room=$v"' 'say "nothing asserted"'
o=$(runscan varleg)
leg variable_valued_leg_counted "$(val "$o" unheard)" 1

# 7 -- A DYNAMICALLY NAMED LEG IS READ PAST. `echo "$name=yes"` names a different leg on every
# call, so the literal word `name` is no leg at all; counting it reported a hole in a pair whose
# witness quotes the real names.
mkpen dynamic
plant dynamic alpha 'name=$1
echo "$name=yes"' 'say "nothing asserted"'
o=$(runscan dynamic)
leg dynamic_name_read_past "$(val "$o" unheard)" 0

# AND A DYNAMIC NAME THE COMPOSITE FILTER CANNOT REACH. `$name=` is refused twice over -- by that
# filter and by the dollar guard in the regex -- so a mutation of either one alone reads clean on
# it and proves nothing. This plant carries a variable the filter never names, leaving the guard
# standing alone and mutable.
mkpen dynamic_only
plant dynamic_only alpha 'verdict=yes
echo "$verdict=yes"' 'say "nothing asserted"'
o=$(runscan dynamic_only)
leg dynamic_only_read_past "$(val "$o" unheard)" 0

# 8 -- A COMPOSITE LINE IS HEARD THROUGH ITS IDENTITY FIELD. `leg=<name> agree=yes` carries the
# identity in `leg=` and the verdict beside it, so `agree` is a field rather than a leg.
mkpen composite
plant composite alpha 'echo "leg=over_ceiling agree=yes exit=1"' 'assert control.out contains "leg=over_ceiling agree=yes" else "x"'
o=$(runscan composite)
leg composite_field_not_a_leg "$(val "$o" unheard)" 0

# 9 -- A CONTROL WITH NO SIBLING WITNESS IS REPORTED APART. A different fault with a different
# cure, so folding it into the gated number would book work this instrument cannot describe.
mkpen unpaired
d=$pen/unpaired; printf 'echo "a_leg=yes"\n' > "$d/tools/fixtures/p/lonely_control.sh"
( cd "$d" && git add -A && git commit -qm plant )
o=$(runscan unpaired)
leg unpaired_counted "$(val "$o" unpaired)" 1
leg unpaired_off_the_gate "$(val "$o" unheard)" 0
leg unpaired_named "$(runscan unpaired --list | grep -c 'unpaired_control.*lonely_control')" 1

# 10 -- THE EXPLAIN DOOR NAMES THE LEG, since a count nobody can locate is a count nobody repairs.
mkpen explain
plant explain alpha 'echo "plant_refused=yes"' 'say "nothing asserted"'
o=$( cd "$pen/explain" && CONTROL_LEG_ROOT=. sh "$scan" --explain tools/fixtures/p/alpha_control.sh 2>&1 )
leg explain_names_the_leg "$(echo "$o" | grep -c 'unheard_leg plant_refused')" 1
leg explain_verdict "$(val "$o" verdict)" unheard
o=$( cd "$pen/heard" && CONTROL_LEG_ROOT=. sh "$scan" --explain tools/fixtures/p/alpha_control.sh 2>&1 )
leg explain_clean_verdict "$(val "$o" verdict)" heard

# 11 -- REFUSALS. An unknown flag and an unreadable root refuse rather than reading zero, because a
# meter that cannot answer must say so rather than call a tree clean.
o=$( cd "$pen/heard" && CONTROL_LEG_ROOT=. sh "$scan" --nonsense 2>&1 ); rc=$?
leg unknown_flag_refused "$rc" 2
o=$( CONTROL_LEG_ROOT=/nonexistent-pen-path sh "$scan" 2>&1 ); rc=$?
leg unreadable_root_refused "$rc" 2

# 12 -- MUTATIONS, each planted in its own copy of the scan and thrown away, so the legs above are
# shown biting rather than merely passing.
mutate() { m=$1; shift; sed "$@" "$scan" > "$pen/$m.sh"; cmp -s "$pen/$m.sh" "$scan" && { echo MUTNOOP; return; }
  ( cd "$pen/$2x" 2>/dev/null || cd "$pen/unheard"; CONTROL_LEG_ROOT=. sh "$pen/$m.sh" ) 2>&1; }

m=$(sed "/grep -qE 'contains \"(legs_fail|control_failed/d" "$scan" > "$pen/m1.sh"; \
    cmp -s "$pen/m1.sh" "$scan" && echo MUTNOOP || ( cd "$pen/wall_tally" && CONTROL_LEG_ROOT=. sh "$pen/m1.sh" ) 2>&1)
leg mutation_tally_wall_bites "$(val "$m" generic_wall)" 0

m=$(sed "s/^CEILING=[0-9][0-9]*$/CEILING=0/" "$scan" > "$pen/m2.sh"; \
    cmp -s "$pen/m2.sh" "$scan" && echo MUTNOOP || ( cd "$pen/unheard" && CONTROL_LEG_ROOT=. sh "$pen/m2.sh" ) 2>&1)
leg mutation_ceiling_bites "$(val "$m" verdict)" over_ceiling

# The composite filter and the dollar guard are TWO refusals, and the first draft aimed this
# mutation at the pen the second one covers -- so it read 0 and proved nothing. A mutation must be
# pointed at the plant only its own line can reach.
m=$(sed "/grep -vE .\\\\b(leg|name|case|label)=./d" "$scan" > "$pen/m3.sh"; \
    cmp -s "$pen/m3.sh" "$scan" && echo MUTNOOP || ( cd "$pen/composite" && CONTROL_LEG_ROOT=. sh "$pen/m3.sh" ) 2>&1)
leg mutation_composite_filter_bites "$(val "$m" unheard)" 1

# And the dollar guard, aimed at the pen only IT reaches -- the one carrying a variable the
# composite filter never names. The sed script is single-quoted, so the
# shell leaves `$a` alone -- a double-quoted script expands it and ships a broken scan.
m=$(sed 's/(\^|\[\^\$a-zA-Z0-9_\])/(^|[^a-zA-Z0-9_])/' "$scan" > "$pen/m4.sh"; \
    cmp -s "$pen/m4.sh" "$scan" && echo MUTNOOP || ( cd "$pen/dynamic_only" && CONTROL_LEG_ROOT=. sh "$pen/m4.sh" ) 2>&1)
leg mutation_dollar_guard_bites "$(val "$m" unheard)" 1

# MASKED MUTATIONS. Each is pointed at the plant only its own line can reach, because a mutation
# that reads clean on the pen it was aimed at proves nothing about the line it removed.

# The character class before the name is what keeps a leg from masking ITSELF: `comm -12` hands
# the sibling search a name the control emits, so a bare `<name>$` matches that very line.
m=$(sed 's/\[a-z0-9_\]\${_h}/${_h}/' "$scan" > "$pen/m5.sh"; \
    cmp -s "$pen/m5.sh" "$scan" && echo MUTNOOP || ( cd "$pen/masked" && CONTROL_LEG_ROOT=. sh "$pen/m5.sh" ) 2>&1)
leg mutation_self_match_bites "$(val "$m" masked)" 2

m=$(sed 's/ | sort -u | grep -c/ | grep -c/g' "$scan" > "$pen/m6.sh"; \
    cmp -s "$pen/m6.sh" "$scan" && echo MUTNOOP || ( cd "$pen/masked_twice" && CONTROL_LEG_ROOT=. sh "$pen/m6.sh" ) 2>&1)
leg mutation_distinct_count_bites "$(val "$m" masked)" 2

m=$(sed 's/comm -12 "\$1" "\$2"/cat "$2"/' "$scan" > "$pen/m7.sh"; \
    cmp -s "$pen/m7.sh" "$scan" && echo MUTNOOP || ( cd "$pen/masked_nonleg" && CONTROL_LEG_ROOT=. sh "$pen/m7.sh" ) 2>&1)
leg mutation_intersect_guard_bites "$(val "$m" masked)" 1

m=$(sed 's/^MASK_CEILING=[0-9][0-9]*$/MASK_CEILING=0/' "$scan" > "$pen/m8.sh"; \
    cmp -s "$pen/m8.sh" "$scan" && echo MUTNOOP || ( cd "$pen/masked" && CONTROL_LEG_ROOT=. sh "$pen/m8.sh" ) 2>&1)
leg mutation_mask_bound_bites "$(val "$m" verdict)" over_mask_ceiling

echo "legs_pass=$pass"
echo "legs_fail=$fail"
echo "control_verdict=ok"
