#!/bin/sh
# tools/fixtures/w/whitepaper_definitions_scan.sh -- does the whitepaper row's own PREMISE survive
# the measurements the lane has already published? Row 11 of
# active-designing/date/20260910/20260910-060204_the-bounded-torus-moonshots.md is the last unopened row of the
# twelve, and unlike the other eleven it makes no claim about the world. It makes a claim about the
# other rows: "One paper binds the three definitions the other eleven rows lean on: what a BOUND is
# when space wraps, what a RADIUS is when privilege is distance, and what a TOPOS is when every
# proof is a cycle."
#
# So its assumption is "at least two rows above go green first; the definitions survive contact with
# those results", and its falsifier is "the first two green witnesses give definitions that pull
# against each other, which would mean the paper describes two ideas wearing one name."
#
# Nine rows now carry landed readings, so both are checkable today, and this scan checks them by
# RUNNING the sibling instruments and reading their own emitted keys rather than by reading the
# errata that describe them. A reading derived from prose goes stale the first time an instrument
# moves and nobody edits the sentence; a reading derived from keys moves with the instrument.
#
#   READING 1 -- DOES EACH DEFINITION STAND? Each of the three is given a predicate over named keys
#   emitted by sibling scans, chosen so that the definition HOLDING is what makes the predicate
#   true. A definition is `supported`, `refuted`, or `unrun`.
#
#     D1, a bound when space wraps. tools/fixtures/b/bearing_quorum_scan.sh must read
#     cost_half=stands (cost grows with the perimeter rather than the area) and
#     wrap_worth_one_cut=yes (the wrap supplies something a line does not).
#
#     D2, a radius when privilege is distance. For a radius to NAME a privilege, the seated
#     privileges must lie on a line: tools/fixtures/c/capability_lattice_scan.sh must read
#     seated_incomparable_unordered=0 and seated_over_admitted=0. For a falloff to GRADE anything,
#     the population must carry more than a couple of distinct radii:
#     tools/fixtures/a/aether_falloff_scan.sh must read mapped_saturation_radius >= 3.
#
#     D3, a topos when every proof is a cycle. Its instrument is the rostered `cyclic_witness`,
#     which is `tier cadence` because it RUNS other witnesses to digest their residue. This scan
#     does not run it, reports `unrun`, and prints whether the finding turns on it -- see below.
#
#   READING 2 -- HOW MANY AXES DOES EACH DEFINITION NEED? This is the one input DECLARED BY A HAND
#   rather than measured, and it is declared here so a reader can disagree with it in one place. It
#   is read straight off the proposal page's own sentence: "a torus has two angles rather than one,
#   so a name and a privilege can travel on separate axes." A period needs ONE cycle; a name and a
#   privilege on separate axes need TWO. So D1=1, D2=2, D3=1.
#
#   READING 3 -- WHAT SHAPE DO THE SURVIVORS NEED? The maximum axis count among the SUPPORTED
#   definitions. Two independent cycles is a torus; one is a ring. The page is titled for a torus,
#   so a reading of 1 says the surviving definitions rest on a circle while the title says otherwise
#   -- two ideas wearing one name, which is row 11's own falsifier arriving along an axis that
#   falsifier's sentence never named.
#
#   READING 4 -- CAN ROW 11'S FALSIFIER SEE IT? The falsifier as written watches for two SUPPORTED
#   definitions that "pull against each other". The only quantity the three definitions share is the
#   number of independent cycles the space must carry, and each definition states a LOWER BOUND on
#   it -- D1 needs a cycle to exist, it does not need a second one to be absent. That is an
#   INFERENCE about the definitions rather than an observation, and it is the hinge of this reading,
#   so the scan prints it and tests both readings of it.
#
#   Lower bounds compose by MAXIMUM, so under that semantics no pair can be jointly unsatisfiable:
#   a one-axis definition is satisfied on any space a two-axis one needs. The scan enumerates all
#   3^3 = 27 assignments of the three verdicts and counts the assignments in which some supported
#   pair is jointly unsatisfiable, under both semantics -- `atleast`, which is the reading argued
#   above, and `exact`, in which a definition needing one axis would refuse a space carrying two.
#   A count of zero under `atleast` says the falsifier watches for a failure the definitions are
#   structurally incapable of having, which is a stronger statement than the falsifier merely being
#   quiet today.
#
# ROBUSTNESS TO THE UNRUN DEFINITION. D3 needs one axis whether it stands or falls, so it cannot
# raise the maximum above one. The scan proves this rather than asserting it: it recomputes reading
# 3 with D3 forced `supported` and prints whether the answer moved.
#
# WHAT WOULD FALSIFY THE READING. A sibling scan emitting a key this scan does not find, which is
# refused rather than defaulted, since a missing key read as zero would turn an instrument that
# broke into a definition that stands. capability_lattice reading seated_incomparable_unordered=0
# would put privilege back on a line and D2 back in the paper. aether_falloff reading a saturation
# radius of three or more would give a falloff something to grade. A supported definition needing
# two axes would make the shape claim stand.
#
# WHAT THIS DOES NOT READ. Whether the paper is worth writing, which is a judgment. Whether the
# three definitions are the RIGHT three, which is the proposal's choice and not a measurement.
# D3's instrument, named above. Any row of the twelve that bears on none of the three definitions.
#
# USAGE
#   sh tools/fixtures/w/whitepaper_definitions_scan.sh          # the reading
#   sh tools/fixtures/w/whitepaper_definitions_scan.sh --root D # read sibling scans from tree D
set -u

ROOT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --root) ROOT="${2:-}"; shift 2 ;;
    *) echo "detail: unknown argument $1" >&2; echo "verdict=refused"; exit 1 ;;
  esac
done

if [ -z "$ROOT" ]; then
  ROOT=$(cd "$(dirname "$0")/../../.." 2>/dev/null && pwd -P) || ROOT=""
fi
if [ -z "$ROOT" ] || [ ! -d "$ROOT" ]; then
  echo "detail: no readable tree root"
  echo "verdict=refused"
  exit 1
fi

# run_scan <relative path> -- emit a sibling scan's output, or nothing when it cannot run.
run_scan() {
  _p="$ROOT/$1"
  [ -f "$_p" ] || return 1
  sh "$_p" 2>/dev/null
}

# key <output> <name> -- print the value of a `name=value` key, or the empty string when absent.
key() {
  printf '%s\n' "$1" | awk -v k="$2" '
    { for (i = 1; i <= NF; i++) { n = index($i, "=")
        if (n > 0 && substr($i, 1, n - 1) == k) { print substr($i, n + 1); exit } } }'
}

MISSING=0
# need <varname> <label> -- refuse a missing key rather than defaulting it to zero, since an
# instrument that broke and a definition that stands must never read alike. The counter is bumped
# in THIS shell rather than inside a command substitution, which the pen caught reading zero while
# four keys were absent.
need() {
  eval "_v=\${$1}"
  if [ -z "$_v" ]; then
    echo "detail: key absent -- $2"
    MISSING=$((MISSING + 1))
    eval "$1=absent"
  fi
}

OUT_BEARING=$(run_scan tools/fixtures/b/bearing_quorum_scan.sh)
OUT_LATTICE=$(run_scan tools/fixtures/c/capability_lattice_scan.sh)
OUT_AETHER=$(run_scan tools/fixtures/a/aether_falloff_scan.sh)
OUT_PLACE=$(run_scan tools/fixtures/t/torus_place_scan.sh)

COST_HALF=$(key "$OUT_BEARING" cost_half);    need COST_HALF "bearing_quorum cost_half"
WRAP_CUT=$(key "$OUT_BEARING" wrap_worth_one_cut); need WRAP_CUT "bearing_quorum wrap_worth_one_cut"
INCOMP=$(key "$OUT_LATTICE" seated_incomparable_unordered); need INCOMP "capability_lattice seated_incomparable_unordered"
OVER=$(key "$OUT_LATTICE" seated_over_admitted); need OVER "capability_lattice seated_over_admitted"
SATRAD=$(key "$OUT_AETHER" mapped_saturation_radius); need SATRAD "aether_falloff mapped_saturation_radius"
SECOND_AXIS=$(key "$OUT_PLACE" second_axis_buys_spread); need SECOND_AXIS "torus_place second_axis_buys_spread"

echo "root_ok=yes"
echo "bearing_cost_half=$COST_HALF bearing_wrap_worth_one_cut=$WRAP_CUT"
echo "lattice_incomparable=$INCOMP lattice_over_admitted=$OVER"
echo "aether_saturation_radius=$SATRAD"
echo "place_second_axis_buys_spread=$SECOND_AXIS"
echo "keys_absent=$MISSING"

if [ "$MISSING" -gt 0 ]; then
  echo "detail: a bearing instrument did not answer; no definition is classified from a partial read"
  echo "verdict=refused"
  exit 1
fi

# -- reading 1: does each definition stand? ---------------------------------------------------
D1="refuted"
if [ "$COST_HALF" = "stands" ] && [ "$WRAP_CUT" = "yes" ]; then D1="supported"; fi

D2="refuted"
if [ "$INCOMP" -eq 0 ] && [ "$OVER" -eq 0 ] && [ "$SATRAD" -ge 3 ]; then D2="supported"; fi

D3="unrun"

# -- reading 2: axes each definition needs (DECLARED, see header) ------------------------------
D1_AXES=1
D2_AXES=2
D3_AXES=1

# Each definition's classification carries its OWN key name. A bare `verdict=` on these three lines
# would be the fourth, fifth and sixth `verdict=` in this output, and a reader taking the first
# match would read a definition's classification as the scan's own answer -- which the pen caught.
echo "def1_name=bound_when_space_wraps def1_axes=$D1_AXES def1_verdict=$D1"
echo "def2_name=radius_when_privilege_is_distance def2_axes=$D2_AXES def2_verdict=$D2"
echo "def3_name=topos_when_proof_is_cycle def3_axes=$D3_AXES def3_verdict=$D3"

SUPPORTED=0
REFUTED=0
UNRUN=0
for d in "$D1" "$D2" "$D3"; do
  case "$d" in
    supported) SUPPORTED=$((SUPPORTED + 1)) ;;
    refuted) REFUTED=$((REFUTED + 1)) ;;
    *) UNRUN=$((UNRUN + 1)) ;;
  esac
done
echo "definitions_supported=$SUPPORTED definitions_refuted=$REFUTED definitions_unrun=$UNRUN"

# -- reading 3: what shape do the survivors need? ----------------------------------------------
# max_axes <d1 verdict> <d2 verdict> <d3 verdict> -- highest axis count among the supported ones,
# or 0 when none stands.
max_axes() {
  _m=0
  [ "$1" = "supported" ] && [ "$D1_AXES" -gt "$_m" ] && _m=$D1_AXES
  [ "$2" = "supported" ] && [ "$D2_AXES" -gt "$_m" ] && _m=$D2_AXES
  [ "$3" = "supported" ] && [ "$D3_AXES" -gt "$_m" ] && _m=$D3_AXES
  printf '%s' "$_m"
}

MAXAXES=$(max_axes "$D1" "$D2" "$D3")
MAXAXES_D3=$(max_axes "$D1" "$D2" "supported")
ROBUST="no"
[ "$MAXAXES" = "$MAXAXES_D3" ] && ROBUST="yes"

SHAPE_SUPPORTED="none"
case "$MAXAXES" in
  0) SHAPE_SUPPORTED="none" ;;
  1) SHAPE_SUPPORTED="ring" ;;
  *) SHAPE_SUPPORTED="torus" ;;
esac

echo "max_axes_among_supported=$MAXAXES max_axes_if_def3_stands=$MAXAXES_D3 finding_robust_to_def3=$ROBUST"
echo "shape_claimed=torus shape_supported=$SHAPE_SUPPORTED"

PREMISE="yes"
[ "$REFUTED" -gt 0 ] && PREMISE="no"
[ "$SHAPE_SUPPORTED" = "torus" ] || PREMISE="no"
echo "premise_holds=$PREMISE"

# -- reading 4: can row 11's own falsifier see it? ---------------------------------------------
# Each definition states a LOWER BOUND on the number of independent cycles the space must carry.
# Lower bounds compose by maximum, so a supported pair is jointly unsatisfiable only under an
# `exact` reading, in which a definition needing one axis would refuse a space carrying two. Both
# readings are enumerated over all 27 verdict assignments so the hinge is visible rather than
# argued.
#
# pair_unsat <axes a> <axes b> <semantics> -- 1 when the two requirements cannot share one space.
pair_unsat() {
  if [ "$3" = "exact" ] && [ "$1" -ne "$2" ]; then printf 1; else printf 0; fi
}

# sweep <semantics> -- assignments of the 27 in which some supported pair is jointly unsatisfiable.
sweep() {
  _sem="$1"
  _hit=0
  _seen=0
  for _a in supported refuted unrun; do
    for _b in supported refuted unrun; do
      for _c in supported refuted unrun; do
        _seen=$((_seen + 1))
        _bad=0
        if [ "$_a" = supported ] && [ "$_b" = supported ]; then
          [ "$(pair_unsat "$D1_AXES" "$D2_AXES" "$_sem")" = 1 ] && _bad=1
        fi
        if [ "$_a" = supported ] && [ "$_c" = supported ]; then
          [ "$(pair_unsat "$D1_AXES" "$D3_AXES" "$_sem")" = 1 ] && _bad=1
        fi
        if [ "$_b" = supported ] && [ "$_c" = supported ]; then
          [ "$(pair_unsat "$D2_AXES" "$D3_AXES" "$_sem")" = 1 ] && _bad=1
        fi
        [ "$_bad" = 1 ] && _hit=$((_hit + 1))
      done
    done
  done
  printf '%s %s' "$_hit" "$_seen"
}

set -- $(sweep atleast)
ATLEAST_HIT=$1
ASSIGNMENTS=$2
set -- $(sweep exact)
EXACT_HIT=$1

# the conflict standing in the tree today, under the semantics this reading argues for
CONFLICTS=0
if [ "$D1" = supported ] && [ "$D2" = supported ]; then
  [ "$(pair_unsat "$D1_AXES" "$D2_AXES" atleast)" = 1 ] && CONFLICTS=$((CONFLICTS + 1))
fi
if [ "$D1" = supported ] && [ "$D3" = supported ]; then
  [ "$(pair_unsat "$D1_AXES" "$D3_AXES" atleast)" = 1 ] && CONFLICTS=$((CONFLICTS + 1))
fi
if [ "$D2" = supported ] && [ "$D3" = supported ]; then
  [ "$(pair_unsat "$D2_AXES" "$D3_AXES" atleast)" = 1 ] && CONFLICTS=$((CONFLICTS + 1))
fi

FALSIFIER_FIRES="no"
[ "$CONFLICTS" -gt 0 ] && FALSIFIER_FIRES="yes"
SATISFIABLE="yes"
[ "$ATLEAST_HIT" -eq 0 ] && SATISFIABLE="no"
BLIND="no"
[ "$FALSIFIER_FIRES" = "no" ] && [ "$PREMISE" = "no" ] && BLIND="yes"

echo "requirement_semantics=atleast assignments=$ASSIGNMENTS"
echo "conflict_assignments_atleast=$ATLEAST_HIT conflict_assignments_exact=$EXACT_HIT"
echo "supported_pairs_conflicting=$CONFLICTS falsifier_as_written_fires=$FALSIFIER_FIRES"
echo "falsifier_satisfiable=$SATISFIABLE falsifier_blind_to_failure=$BLIND"

if [ "$PREMISE" = "yes" ]; then
  echo "detail: the three definitions survive contact and the shape claim stands"
  echo "verdict=premise"
elif [ "$BLIND" = "yes" ]; then
  echo "detail: the premise fails on a refuted definition and a shape claim the survivors do not"
  echo "detail: need, while the falsifier -- which watches for two standing definitions to pull"
  echo "detail: against each other -- cannot fire in any of the $ASSIGNMENTS assignments, because"
  echo "detail: each definition bounds the space from below and lower bounds compose by maximum"
  echo "verdict=blind"
else
  echo "detail: the premise fails and row 11's own falsifier fires on it"
  echo "verdict=fires"
fi
