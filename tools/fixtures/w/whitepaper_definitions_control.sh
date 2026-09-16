#!/bin/sh
# tools/fixtures/w/whitepaper_definitions_control.sh -- proves tools/fixtures/w/whitepaper_definitions_scan.sh
# by building throwaway pens whose sibling scans are stubs emitting chosen keys, so every branch of
# the classifier is reached from both sides. A refusal shown only in the failing direction cannot be
# told from a bypass, so each plant is lifted again and the reading asserted to return.
#
# The stubs are what make this cheap and total: the real siblings read this tree and take about ten
# seconds together, and three of the four cannot be made to emit a chosen value at all without
# editing the tree they read. A stub emits exactly the keys under test, so the classifier is proven
# against inputs the real tree may never produce.
#
# MUTATIONS. Five edits to the scan are each applied to a copy, run, and asserted to change the
# reading -- a guard whose mutants all pass is a guard asserting nothing. Each mutant is proven to
# have LANDED with cmp before it is run, since a sed that matched nothing would read as a mutation
# that did not bite.
#
# USAGE
#   sh tools/fixtures/w/whitepaper_definitions_control.sh
set -u

ROOT=$(cd "$(dirname "$0")/../../.." && pwd -P)
SCAN="$ROOT/tools/fixtures/w/whitepaper_definitions_scan.sh"
PEN=$(mktemp -d) || { echo "verdict=refused"; exit 1; }
trap 'rm -rf "$PEN"' EXIT INT TERM

LEGS=0
FAILED=0

leg() {
  LEGS=$((LEGS + 1))
  if [ "$2" = "$3" ]; then
    echo "leg $1 ok"
  else
    echo "leg $1 FAILED wanted=$3 got=$2"
    FAILED=$((FAILED + 1))
  fi
}

# pen <name> <cost_half> <wrap_cut> <incomp> <over> <satrad> <second_axis> -- build a stub tree.
# An empty value plants a MISSING key, which the scan must refuse rather than default.
pen() {
  _d="$PEN/$1"
  rm -rf "$_d"
  mkdir -p "$_d/tools/fixtures/b" "$_d/tools/fixtures/c" "$_d/tools/fixtures/a" "$_d/tools/fixtures/t"
  {
    printf '#!/bin/sh\n'
    [ -n "$2" ] && printf 'echo "cost_half=%s"\n' "$2"
    [ -n "$3" ] && printf 'echo "wrap_worth_one_cut=%s"\n' "$3"
    printf 'echo "verdict=stub"\n'
  } > "$_d/tools/fixtures/b/bearing_quorum_scan.sh"
  {
    printf '#!/bin/sh\n'
    [ -n "$4" ] && printf 'echo "seated_incomparable_unordered=%s"\n' "$4"
    [ -n "$5" ] && printf 'echo "seated_over_admitted=%s"\n' "$5"
    printf 'echo "verdict=stub"\n'
  } > "$_d/tools/fixtures/c/capability_lattice_scan.sh"
  {
    printf '#!/bin/sh\n'
    [ -n "$6" ] && printf 'echo "mapped_saturation_radius=%s"\n' "$6"
    printf 'echo "verdict=stub"\n'
  } > "$_d/tools/fixtures/a/aether_falloff_scan.sh"
  {
    printf '#!/bin/sh\n'
    [ -n "$7" ] && printf 'echo "second_axis_buys_spread=%s"\n' "$7"
    printf 'echo "verdict=stub"\n'
  } > "$_d/tools/fixtures/t/torus_place_scan.sh"
  chmod +x "$_d"/tools/fixtures/*/*.sh
  printf '%s' "$_d"
}

# read_key <output> <name>
read_key() {
  printf '%s\n' "$1" | awk -v k="$2" '
    { for (i = 1; i <= NF; i++) { n = index($i, "=")
        if (n > 0 && substr($i, 1, n - 1) == k) { print substr($i, n + 1); exit } } }'
}

run_on() { sh "${2:-$SCAN}" --root "$1" 2>&1; }

# -- the tree as it stands today ---------------------------------------------------------------
REAL=$(sh "$SCAN" 2>&1)
leg real_answers "$(read_key "$REAL" verdict)" "blind"
leg real_no_absent_keys "$(read_key "$REAL" keys_absent)" "0"
leg real_premise_fails "$(read_key "$REAL" premise_holds)" "no"
leg real_shape_is_ring "$(read_key "$REAL" shape_supported)" "ring"
leg real_falsifier_unsatisfiable "$(read_key "$REAL" falsifier_satisfiable)" "no"

# -- a pen mirroring today's readings answers the same way --------------------------------------
D=$(pen mirror stands yes 32 48 2 no); O=$(run_on "$D")
leg mirror_verdict "$(read_key "$O" verdict)" "blind"
leg mirror_def1 "$(read_key "$O" def1_verdict)" "supported"
leg mirror_def2 "$(read_key "$O" def2_verdict)" "refuted"
leg mirror_def3 "$(read_key "$O" def3_verdict)" "unrun"
leg mirror_def2_axes "$(read_key "$O" def2_axes)" "2"
leg mirror_supported "$(read_key "$O" definitions_supported)" "1"
leg mirror_refuted "$(read_key "$O" definitions_refuted)" "1"
leg mirror_unrun "$(read_key "$O" definitions_unrun)" "1"
leg mirror_maxaxes "$(read_key "$O" max_axes_among_supported)" "1"
leg mirror_robust "$(read_key "$O" finding_robust_to_def3)" "yes"
leg mirror_assignments "$(read_key "$O" assignments)" "27"
leg mirror_conflict_atleast "$(read_key "$O" conflict_assignments_atleast)" "0"
leg mirror_conflict_exact "$(read_key "$O" conflict_assignments_exact)" "5"

# -- D2 restored: privilege on a line, a falloff with something to grade -------------------------
D=$(pen d2ok stands yes 0 0 3 no); O=$(run_on "$D")
leg d2ok_premise "$(read_key "$O" premise_holds)" "yes"
leg d2ok_shape "$(read_key "$O" shape_supported)" "torus"
leg d2ok_maxaxes "$(read_key "$O" max_axes_among_supported)" "2"
leg d2ok_supported "$(read_key "$O" definitions_supported)" "2"
leg d2ok_verdict "$(read_key "$O" verdict)" "premise"
leg d2ok_not_blind "$(read_key "$O" falsifier_blind_to_failure)" "no"

# -- D2 fails on each of its three keys ALONE, so no one key carries the refutation ---------------
D=$(pen d2_incomp stands yes 1 0 3 no); O=$(run_on "$D")
leg d2_incomp_only "$(read_key "$O" premise_holds)" "no"
D=$(pen d2_over stands yes 0 1 3 no); O=$(run_on "$D")
leg d2_over_only "$(read_key "$O" premise_holds)" "no"
D=$(pen d2_sat stands yes 0 0 2 no); O=$(run_on "$D")
leg d2_sat_only "$(read_key "$O" premise_holds)" "no"
D=$(pen d2_sat_high stands yes 0 0 9 no); O=$(run_on "$D")
leg d2_sat_high_ok "$(read_key "$O" premise_holds)" "yes"

# -- D1 fails on each of its two keys alone -------------------------------------------------------
D=$(pen d1_cost broken yes 32 48 2 no); O=$(run_on "$D")
leg d1_cost_refuted "$(read_key "$O" definitions_supported)" "0"
leg d1_cost_shape "$(read_key "$O" shape_supported)" "none"
leg d1_cost_maxaxes "$(read_key "$O" max_axes_among_supported)" "0"
D=$(pen d1_wrap stands no 32 48 2 no); O=$(run_on "$D")
leg d1_wrap_refuted "$(read_key "$O" definitions_supported)" "0"

# -- nothing stands at all -------------------------------------------------------------------------
D=$(pen allbad broken no 32 48 2 no); O=$(run_on "$D")
leg allbad_shape "$(read_key "$O" shape_supported)" "none"
leg allbad_premise "$(read_key "$O" premise_holds)" "no"
leg allbad_verdict "$(read_key "$O" verdict)" "blind"

# -- a missing key is REFUSED, never defaulted to zero ---------------------------------------------
D=$(pen miss_cost "" yes 32 48 2 no); O=$(run_on "$D")
leg missing_cost_refused "$(read_key "$O" verdict)" "refused"
leg missing_cost_counted "$(read_key "$O" keys_absent)" "1"
D=$(pen miss_incomp stands yes "" 48 2 no); O=$(run_on "$D")
leg missing_incomp_refused "$(read_key "$O" verdict)" "refused"
D=$(pen miss_sat stands yes 32 48 "" no); O=$(run_on "$D")
leg missing_sat_refused "$(read_key "$O" verdict)" "refused"
D=$(pen miss_axis stands yes 32 48 2 ""); O=$(run_on "$D")
leg missing_axis_refused "$(read_key "$O" verdict)" "refused"
D=$(pen miss_all "" "" "" "" "" ""); O=$(run_on "$D")
leg missing_all_counted "$(read_key "$O" keys_absent)" "6"
leg missing_all_refused "$(read_key "$O" verdict)" "refused"

# -- an absent sibling scan is the same refusal ------------------------------------------------------
D=$(pen gone stands yes 32 48 2 no); rm -f "$D/tools/fixtures/c/capability_lattice_scan.sh"
O=$(run_on "$D")
leg absent_sibling_refused "$(read_key "$O" verdict)" "refused"

# -- an unreadable root refuses rather than guessing --------------------------------------------------
O=$(sh "$SCAN" --root "$PEN/no-such-tree" 2>&1)
leg bad_root_refused "$(read_key "$O" verdict)" "refused"
O=$(sh "$SCAN" --nonsense 2>&1)
leg bad_flag_refused "$(read_key "$O" verdict)" "refused"

# -- MUTATIONS: each must change the reading, and each must be proven to have landed -------------------
mutate() {
  _name="$1"; _sed="$2"; _pen_dir="$3"; _want_change="$4"
  _m="$PEN/mut_$_name.sh"
  sed "$_sed" "$SCAN" > "$_m"
  if cmp -s "$_m" "$SCAN"; then
    echo "leg mutation_${_name}_landed FAILED -- sed matched nothing"
    LEGS=$((LEGS + 1)); FAILED=$((FAILED + 1)); return
  fi
  LEGS=$((LEGS + 1)); echo "leg mutation_${_name}_landed ok"
  _base=$(run_on "$_pen_dir")
  _mut=$(run_on "$_pen_dir" "$_m")
  if [ "$_want_change" = "yes" ]; then
    if [ "$_base" != "$_mut" ]; then leg "mutation_${_name}_bites" "changed" "changed"
    else leg "mutation_${_name}_bites" "unchanged" "changed"; fi
  fi
}

MIRROR=$(pen mutbase stands yes 32 48 2 no)

# a missing key defaulted to zero rather than refused -- an instrument that broke would read as a
# definition that stands
mutate default_missing 's/^    MISSING=\$((MISSING + 1))$/    :/' "$(pen mutmiss "" yes 32 48 2 no)" yes
# the incomparable-pairs test dropped: privilege goes back on a line for free
mutate drop_incomp 's/\[ "\$INCOMP" -eq 0 \] \&\& //' "$(pen mutincomp stands yes 32 0 3 no)" yes
# the saturation-radius floor lowered to something every population clears
mutate loosen_satrad 's/"\$SATRAD" -ge 3/"$SATRAD" -ge 0/' "$(pen mutsat stands yes 0 0 2 no)" yes
# the shape reading reports a torus whatever the survivors need
mutate shape_always_torus 's/^  1) SHAPE_SUPPORTED="ring" ;;/  1) SHAPE_SUPPORTED="torus" ;;/' "$MIRROR" yes
# the exact-semantics sweep collapsed onto the atleast one, hiding the hinge
mutate hide_hinge 's/^  if \[ "\$3" = "exact" \] \&\& \[ "\$1" -ne "\$2" \]; then printf 1; else printf 0; fi/  printf 0/' "$MIRROR" yes

# The expected count is spelled here so a leg silently lost is heard by the witness. Raise it in
# the same commit that adds a leg.
echo "control_legs_expected=55"
echo "control_legs=$LEGS"
echo "control_failed=$FAILED"
if [ "$FAILED" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; fi
