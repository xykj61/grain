#!/bin/sh
# tools/fixtures/t/topology_floor_control.sh -- the diameter floor, broken on purpose.
#
#   sh tools/fixtures/t/topology_floor_control.sh
#
# WHY. `tools/fixtures/t/topology_graph_census.sh` now reports, per connected leg, the
# smallest diameter any graph of that many points and that maximum degree could have -- the
# Moore bound solved for the diameter rather than for the node count. A number nobody can see
# go wrong is a number a reader has to take on trust, so this copies the census into a pen,
# breaks the floor five ways, and watches each break refuse. Then it proves the pen innocent
# with an unbroken copy, and proves the four attainer legs earn their keep with a copy that is
# broken AND has those legs removed, which must pass.
#
# WHY AN ATTAINER IS THE TEST WORTH HAVING. The Moore bound is a ceiling almost no graph
# reaches, so a formula that is wrong by a little still brackets most inputs correctly and
# looks fine. Four graphs pin it exactly: the complete graph on ten nodes at degree nine and
# diameter one, the Petersen graph at degree three and diameter two, the Hoffman-Singleton
# graph at degree seven and diameter two, and a fifteen-cycle, which pins the degree-two
# branch that skips the general form. A formula off by one anywhere fails at least one.
#
# WHAT THE REFUSAL LEG DEFENDS. The census refuses to report a floor on a split graph, and
# both sponsor legs are split -- 133 components on the compass sky, 121 on the council. Their
# `walk_diameter` is the widest walk the largest component happens to hold while half the
# ordered pairs never connect at all, so a ratio against it would be a number about nothing.
# Plant five removes that refusal and watches the census print two floors it has no business
# printing.
#
# Instrument: `sh`, `sed` and `awk`, POSIX-granted. The pen has a fixed name under the host's
# temporary directory and is removed on exit; no `mktemp`, which is not POSIX.
#
# Read against: external-research/20260906-010402_the-ring-and-the-ladder.md, whose third
# erratum this reading corrects, and tools/fixtures/t/topology_graph_census.sh.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

CENSUS="$ROOT/tools/fixtures/t/topology_graph_census.sh"
SRC="$ROOT/comlink/topology.rye"
[ -f "$CENSUS" ] || { echo "control: the census is missing at $CENSUS" >&2; exit 2; }
[ -f "$SRC" ]    || { echo "control: the topology source is missing at $SRC" >&2; exit 2; }

PEN="${TMPDIR:-/tmp}/topology_floor_control_pen"
rm -rf "$PEN"
mkdir -p "$PEN"
# REDS %487: a handler that cleans up without exiting does not stop the script -- POSIX runs
# it and RESUMES where the signal landed, so the run carries on against the pen it just
# deleted. EXIT cleans once; INT and TERM exit with the signal numbers they carry.
trap 'rm -rf "$PEN"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

faults=0

# `note` prints one asserted line. `$3` is what this control expects to see.
note() {
  if [ "$2" = "$3" ]; then
    printf "  %s %s ok\n" "$1" "$2"
  else
    printf "  %s %s wanted=%s MISMATCH\n" "$1" "$2" "$3"
    faults=$((faults + 1))
  fi
}

run_pen() {
  # $1 census path. Prints nothing; sets PEN_OUT and PEN_CODE.
  set +e
  PEN_OUT=$(TOPOLOGY_SRC="$SRC" sh "$1" 2>&1)
  PEN_CODE=$?
  set -e
}

verdict_of()  { printf '%s\n' "$PEN_OUT" | awk -F= '/^verdict=/ {print $2; exit}'; }
count_of()    { printf '%s\n' "$PEN_OUT" | grep -c "$1" || :; }

echo "pen $PEN"

# --- clean: the pen is innocent ----------------------------------------------
# Everything below reads as the break speaking only because this leg passes first.
run_pen "$CENSUS"
note "clean_verdict"        "$(verdict_of)"                          "ok"
note "clean_exit"           "$PEN_CODE"                              "0"
note "clean_attainers_ok"   "$(count_of 'moore_attainer .* ok')"     "4"
note "clean_floors_reported" "$(count_of '_floor degree_max=')"      "4"
note "clean_floors_refused"  "$(count_of '_floor not_connected')"    "2"

# --- plant one: the exponent is off by one -----------------------------------
# `(d-1)^k` becomes `(d-1)^(k-1)`, so every ceiling is a factor of (d-1) small and every
# floor reads one high. Three of the four attainers catch it; the cycle is on the other branch.
sed -e 's/  return 1 + d \* (((d - 1) \^ k) - 1) \/ (d - 2)/  return 1 + d * (((d - 1) ^ (k - 1)) - 1) \/ (d - 2)/' \
    "$CENSUS" > "$PEN/exponent.sh"
run_pen "$PEN/exponent.sh"
note "exponent_verdict"   "$(verdict_of)"                            "instrument_fault"
note "exponent_exit"      "$PEN_CODE"                                "1"
note "exponent_bites"     "$(count_of 'moore_attainer .* MISMATCH')" "3"

# --- plant two: the degree-two branch is dropped ------------------------------
# A cycle falls into the general form, which divides by `d - 2` and is zero there. The
# fifteen-cycle is the one attainer that reads that branch, and it is why it is in the set.
sed -e 's/^  if (d == 2) return 2 \* k + 1$/  if (d == 99) return 2 * k + 1/' \
    "$CENSUS" > "$PEN/cycle.sh"
run_pen "$PEN/cycle.sh"
# A cycle sent through the general form divides by `d - 2` at d=2, and awk makes that fatal.
# The right reading is the LOUD death: no verdict line at all, and the run stopping at the
# fifteen-cycle with the three attainers before it already green -- which locates the crash
# rather than merely observing one.
note "cycle_dies_loudly"        "$(verdict_of)"                      ""
note "cycle_stops_at_the_cycle" "$(count_of 'moore_attainer .* ok')" "3"
note "cycle_never_reaches_it"   "$(count_of 'moore_attainer cycle_C15')" "0"

# --- plant three: the comparison loses its equals ------------------------------
# `>=` becomes `>`, so a graph sitting EXACTLY on the bound is read as not fitting and every
# floor reads one high. This is the plant that justifies choosing attainers: a graph that
# attains the bound is the only kind that sits exactly on it, so all four bite at once where
# a bracketing test would see nothing.
sed -e 's/    if (moore_cap(d, k) >= PC) return k/    if (moore_cap(d, k) > PC) return k/' \
    "$CENSUS" > "$PEN/strict.sh"
run_pen "$PEN/strict.sh"
note "strict_verdict"     "$(verdict_of)"                            "instrument_fault"
note "strict_bites_all"   "$(count_of 'moore_attainer .* MISMATCH')" "4"

# --- plant four: the bound is spent ------------------------------------------
# `moore_k_max` at zero means the search never runs and every floor is a named refusal. This
# proves the bound is real rather than decorative: a search with no ceiling cannot be told
# from one whose ceiling is never reached.
sed -e 's/^  moore_k_max = 64 /  moore_k_max = 0 /' \
    "$CENSUS" > "$PEN/bound.sh"
run_pen "$PEN/bound.sh"
note "bound_verdict"      "$(verdict_of)"                            "instrument_fault"
note "bound_bites"        "$(count_of 'moore_attainer .* MISMATCH')" "4"
note "bound_names_itself" "$(count_of '_floor degree_max=.* moore_floor=none_within_0')" "4"

# --- plant five: the split-graph refusal is removed ---------------------------
# Both sponsor legs are disconnected, so a floor there compares a bound against the widest
# walk of one component while half the ordered pairs never connect. With the refusal gone the
# census prints two such ratios, and the attainers stay green -- which is exactly why this
# plant needs its own reading rather than riding on `verdict`.
sed -e 's/^  if (comps != 1 || iso != 0) {$/  if (comps != 1 \&\& iso != 0 \&\& 0) {/' \
    "$CENSUS" > "$PEN/split.sh"
run_pen "$PEN/split.sh"
note "split_attainers_still_ok" "$(count_of 'moore_attainer .* ok')" "4"
note "split_reports_a_floor_it_should_refuse" \
     "$(count_of '_floor degree_max=')"                              "6"
note "split_refuses_nothing"    "$(count_of '_floor not_connected')" "0"

# --- the legs earn their keep -------------------------------------------------
# The exponent broken AND the four attainer legs removed. This MUST pass: a control whose
# plants red even with the checking legs gone is measuring something other than the legs.
sed -e 's/  return 1 + d \* (((d - 1) \^ k) - 1) \/ (d - 2)/  return 1 + d * (((d - 1) ^ (k - 1)) - 1) \/ (d - 2)/' \
    -e 's/^  faults += mooreagree()$/  mooreagree_skipped = 1/' \
    "$CENSUS" > "$PEN/legless.sh"
run_pen "$PEN/legless.sh"
note "legless_verdict"    "$(verdict_of)"                            "ok"
note "legless_exit"       "$PEN_CODE"                                "0"
# The break is still there and now reads GREEN. The torus`s floor moves 4 to 5 and its
# over_floor 3.50 to 2.80 -- a fifth of the finding, in the flattering direction, silently.
note "legless_still_wrong" \
     "$(count_of 'torus_compass_floor degree_max=6 moore_floor=5 .* over_floor=2.80')" "1"
note "legless_prints_no_attainer" "$(count_of 'moore_attainer')"     "0"

printf "faults=%d\n" "$faults"
if [ "$faults" -eq 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=broken"
  exit 1
fi
