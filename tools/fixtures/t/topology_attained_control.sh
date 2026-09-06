#!/bin/sh
# tools/fixtures/t/topology_attained_control.sh -- the reachable floor, broken on purpose.
#
#   sh tools/fixtures/t/topology_attained_control.sh
#
# WHY. `tools/fixtures/t/topology_attained_scan.sh` derives a floor and measures six graphs against
# it. A number nobody can watch go wrong is a number a reader takes on trust, so this copies the
# scan into a pen, breaks it eight ways, and watches each break refuse. Then it proves the pen
# innocent with an unbroken copy, and proves the checking legs earn their keep with a copy that is
# broken AND has those legs removed -- which must PASS, because that is what a silent wrong answer
# looks like from the outside.
#
# WHY IT IS CHEAP. The scan takes 79s at full reach, and eleven copies of that is fourteen minutes
# to prove eight plants. Each plant here runs only the legs it tests, through the scan's own
# `SCAN_LEGS` and `SWEEP_BMAX` knobs: a floor plant runs `SCAN_LEGS=floors` in 0.03s, and a walk
# plant runs a 40-generator sweep in 7s. Every reduced run prints its own `legs=` and `sweep_bmax=`
# line, so no reading here can be mistaken for the full one the witness binds.
#
# WHAT EACH PLANT DEFENDS, and why it is the one worth planting:
#
#   1 divide-first     -- the closed form written `(2.0/3.0)*k*(k+1)*(2*k+1)` rather than
#                         multiplying first. Not hypothetical: the draft of this scan had it, and it
#                         reads correctly at ten radii of eleven and wrong at k=7 alone. The
#                         enumeration leg is the only thing between that and a floor of 7.
#   2 floor-plus-one   -- the abelian floor search returning `k + 1`. Caught by the scan's own
#                         bracketing check, which asserts the ball one below the floor does NOT
#                         hold the points and the ball at it does.
#   3 floor-from-zero  -- the same search starting at k=0 rather than k=1. This one does NOT bite,
#                         and the honest reading is recorded rather than dressed as a catch: the
#                         radius-0 ball holds one point, so the loop is a no-op and the floor is
#                         proven unmoved. The comparison `>=` against `>` is likewise not
#                         load-bearing here, since no ball lands exactly on 720.
#   4 split-blind      -- the widest-split search fixed at three inverse-pairs instead of
#                         maximizing. It is right at degree 6 and WRONG at degree 5, where one
#                         involution and two pairs is wider -- so a plant that reads green on the
#                         headline degree is exactly the plant worth having.
#   5 walk-one-short   -- the sweep's one-walk-from-zero returning `lev - 1`. It flatters: the best
#                         reads 8, and `sweep_reaches_abelian_floor` flips to `yes`. Nothing in the
#                         sweep leg can see it; the cross-check against the all-pairs walk is what
#                         catches it, which is the whole reason that leg exists.
#   6 cap-too-low      -- the sweep cap returned to 40, where graphs never close. The scan counted
#                         them in its denominator while printing them in no bucket, and the median
#                         and the share were quietly computed over a total that included them. This
#                         plant reproduces a fault this instrument actually had, before its witness.
#   7 mean-as-diameter -- the shape leg printing the mean where the diameter belongs. Both are real
#                         numbers about the same graph, which is what makes the swap survive a
#                         glance: 7.21 against 14 reads plausible for a 720-point ring stack.
#   8 seated-drift     -- the seated torus built as 8x9x10 rather than 12x5x12. Still 720 points,
#                         still degree 6, and BETTER -- so the shape the whole comparison is against
#                         can drift in the flattering direction while every other line stays green.
#
# Instrument: `sh`, `sed` and `awk`, POSIX-granted. The pen has a fixed name under the host's
# temporary directory and is removed on exit; no `mktemp`, which is not POSIX (`REDS %445`).

set -eu

PEN="${TMPDIR:-/tmp}/topology-attained-control.$$"
cleanup() { rm -rf "$PEN"; }
trap cleanup EXIT INT HUP TERM
rm -rf "$PEN"
mkdir -p "$PEN"

SRC="tools/fixtures/t/topology_attained_scan.sh"
[ -f "$SRC" ] || { echo "refused: $SRC is absent -- the control has nothing to copy"; exit 1; }

behaviors=0
fails=0
note() { behaviors=$((behaviors + 1)); printf '  %s\n' "$1"; }
bad()  { fails=$((fails + 1)); printf '  FAULT %s\n' "$1"; }

# Run a pen copy at a named reach; leave its whole output in $OUT and its verdict word in $VERDICT.
OUT=""; VERDICT=""; CODE=""
run_pen() {
  _file="$1"; _legs="$2"; _bmax="$3"
  if OUT=$(SCAN_LEGS="$_legs" SWEEP_BMAX="$_bmax" sh "$_file" 2>&1); then CODE=ok; else CODE=refused; fi
  VERDICT=$(printf '%s\n' "$OUT" | sed -n 's/^verdict=\(.*\)$/\1/p' | tail -1)
  [ -n "$VERDICT" ] || VERDICT=none
}
# Apply a sed to the scan; refuse loudly when the pattern no longer matches the source.
plant() {
  _name="$1"; _expr="$2"; _out="$PEN/$_name.sh"
  sed "$_expr" "$SRC" > "$_out"
  if cmp -s "$SRC" "$_out"; then bad "$_name did not apply -- the scan is spelled differently now"; return 1; fi
  return 0
}

echo "topology-attained-control: eight plants, each lifted, in $PEN"
echo ""

# ---- the pen, unbroken -------------------------------------------------------------------------
cp "$SRC" "$PEN/clean.sh"
run_pen "$PEN/clean.sh" all 40
echo "clean_verdict $VERDICT $CODE"
if [ "$VERDICT" = ok ] && [ "$CODE" = ok ]; then note "the unbroken pen passes, so a plant below speaks for itself"
else bad "the unbroken pen did not pass -- every plant below is unreadable"; fi
if printf '%s\n' "$OUT" | grep -q '^legs=all sweep_bmax=40$'; then
  note "and it names its own reduced reach, so this reading cannot pass for the full one"
else bad "a reduced run did not announce its reach"; fi
echo ""

# ---- plant 1: divide before multiplying --------------------------------------------------------
if plant p1 's|function l1ball3(k) { return 1 + (2\*k\*(k+1)\*(2\*k+1))/3 + 2\*k }|function l1ball3(k) { return 1 + (2.0/3.0)*k*(k+1)*(2*k+1) + 2*k }|'; then
  run_pen "$PEN/p1.sh" floors 40
  echo "plant1_divide_first $VERDICT $CODE"
  if [ "$VERDICT" = instrument_fault ]; then note "dividing before multiplying is caught by the enumeration leg"
  else bad "plant 1 passed -- a float-truncated closed form goes unread"; fi
  if printf '%s\n' "$OUT" | grep -q '^l1ball3 k=7 closed=574 enumerated=575 DISAGREE$'; then
    note "and the disagreement is NAMED at k=7, the one radius of eleven that moves"
  else bad "plant 1 refused without naming the radius that disagreed"; fi
fi
echo ""

# ---- plant 2: the floor search returns one high ------------------------------------------------
if plant p2 's|if (abelian_ball(d, k) >= n) return k|if (abelian_ball(d, k) >= n) return k + 1|'; then
  run_pen "$PEN/p2.sh" floors 40
  echo "plant2_floor_plus_one $VERDICT $CODE"
  if [ "$VERDICT" = instrument_fault ]; then note "a floor one high is caught by the scan's own bracketing check"
  else bad "plant 2 passed -- a floor one high flatters every ratio beneath it"; fi
fi
echo ""

# ---- plant 3: the floor search starts one low, and honestly does not bite ------------------------
if plant p3 's|for (k = 1; k <= kmax; k++) if (abelian_ball(d, k) >= n) return k|for (k = 0; k <= kmax; k++) if (abelian_ball(d, k) >= n) return k|'; then
  run_pen "$PEN/p3.sh" floors 40
  echo "plant3_floor_from_zero $VERDICT $CODE"
  if [ "$VERDICT" = ok ] && printf '%s\n' "$OUT" | grep -q 'floor abelian n=720 degree=6 floor=8'; then
    note "starting at zero is a no-op here, and the floor is PROVEN unmoved rather than assumed"
  else bad "plant 3 moved the floor -- the no-op reading recorded above is wrong"; fi
fi
echo ""

# ---- plant 4: the widest split fixed rather than maximized -------------------------------------
if plant p4 's|for (t = 0; 2\*t <= d; t++) {|for (t = 3; t <= 3; t++) {|'; then
  run_pen "$PEN/p4.sh" floors 40
  echo "plant4_split_blind $VERDICT $CODE"
  if printf '%s\n' "$OUT" | grep -q 'floor abelian n=720 degree=6 floor=8'; then
    note "fixing three pairs is right at degree 6, which is exactly why it survives a glance"
  else bad "plant 4 moved the degree-6 floor, so it is not the silent plant it was built to be"; fi
  if printf '%s\n' "$OUT" | grep -q 'floor abelian n=720 degree=5 floor=14'; then
    bad "plant 4 left the degree-5 floor standing -- the split search is not load-bearing"
  else note "and it moves the degree-5 floor, where one involution and two pairs is the wider split"; fi
fi
echo ""

# ---- plant 5: the sweep's walk reports one hop short --------------------------------------------
if plant p5 's|    if (seen == n) return lev|    if (seen == n) return lev - 1|'; then
  run_pen "$PEN/p5.sh" all 40
  echo "plant5_walk_one_short $VERDICT $CODE"
  if [ "$VERDICT" = instrument_fault ]; then note "a walk one hop short is caught by the cross-check against the all-pairs walk"
  else bad "plant 5 passed -- the sweep's own legs cannot see a short walk"; fi
  if printf '%s\n' "$OUT" | grep -q 'transitivity_crosscheck .* DISAGREE'; then
    note "and it is the cross-check that names it, which is why that leg exists"
  else bad "plant 5 refused somewhere other than the cross-check"; fi
  # The flattering half needs the FULL sweep: at bmax=40 the best is 11, so one hop short is 10 and
  # the floor is never claimed. This is the one plant that pays the 79s, because it is the one
  # making the strongest claim -- that a wrong answer here reads BETTER rather than merely different.
  run_pen "$PEN/p5.sh" all 359
  echo "plant5_full_reach $VERDICT $CODE"
  if printf '%s\n' "$OUT" | grep -q 'sweep_reaches_abelian_floor floor=8 reached=yes'; then
    note "at full reach the sweep leg alone reports REACHING the floor -- the flattering direction"
  else bad "plant 5 did not produce the flattering reading the cross-check is there to catch"; fi
fi
echo ""

# ---- plant 6: the cap this instrument actually had ----------------------------------------------
if plant p6 's|    e = ecc0(N, 1, b, c, N)|    e = ecc0(N, 1, b, c, 40)|'; then
  run_pen "$PEN/p6.sh" all 40
  echo "plant6_cap_too_low $VERDICT $CODE"
  if [ "$VERDICT" = instrument_fault ]; then note "a cap of 40 leaves graphs unclosed, and the scan refuses rather than bucketing them"
  else bad "plant 6 passed -- graphs that never closed were counted anyway"; fi
  n_open=$(printf '%s\n' "$OUT" | grep -c '^sweep_open ' || true)
  echo "plant6_unclosed=$n_open"
  if [ "$n_open" -gt 0 ]; then note "and it NAMES each unclosed pair, so the fault is locatable rather than a bare count"
  else bad "plant 6 refused without naming a single unclosed pair"; fi
fi
echo ""

# ---- plant 7: the mean printed where the diameter belongs --------------------------------------
if plant p7 '/shape torus_12x5x12/ s|DIA, MEAN, PAIRS|MEAN, MEAN, PAIRS|'; then
  run_pen "$PEN/p7.sh" all 40
  echo "plant7_mean_as_diameter $VERDICT $CODE"
  if printf '%s\n' "$OUT" | grep -q 'shape torus_12x5x12 degree=6 diameter=14 '; then
    bad "plant 7 did not move the seated torus's diameter"
  else note "the mean standing in for the diameter moves the line the witness binds by name"; fi
fi
echo ""

# ---- plant 8: the seated shape itself drifts ----------------------------------------------------
if plant p8 's|delete NB; torus(12, 5, 12, NB)|delete NB; torus(8, 9, 10, NB)|'; then
  run_pen "$PEN/p8.sh" all 40
  echo "plant8_seated_drift $VERDICT $CODE"
  if printf '%s\n' "$OUT" | grep -q 'shape torus_12x5x12 degree=6 diameter=14 '; then
    bad "plant 8 left the seated diameter standing -- a drifted shape reads as the seated one"
  else note "a different 720-point degree-6 torus reads 13 under the seated label, in the flattering direction"; fi
fi
echo ""

# ---- the legs removed: what a silent wrong answer looks like -----------------------------------
# The floor search returning one high, with the bracketing check gone. This is the copy that reads
# GREEN while a headline number has moved -- the floor at 9 rather than 8, which lowers every
# `over_abelian` ratio in the shape leg and makes the seated torus look 1.56x above the floor where
# it is 1.75x. Nothing prints a complaint.
sed 's|if (abelian_ball(d, k) >= n) return k|if (abelian_ball(d, k) >= n) return k + 1|' "$SRC" \
  | sed 's|    if (b_bel >= N \|\| b_at < N) bad++|    if (0) bad++|' > "$PEN/legless.sh"
run_pen "$PEN/legless.sh" floors 40
echo "legless_verdict $VERDICT $CODE"
if [ "$VERDICT" = ok ] && [ "$CODE" = ok ]; then note "with the bracketing check gone the same break reads GREEN -- the check is what catches it"
else bad "the legless copy refused, so the bracketing check is not what does the catching"; fi
legless_floor=$(printf '%s\n' "$OUT" | sed -n 's/^floor abelian n=720 degree=6 floor=\([0-9]*\) .*/\1/p' | tail -1)
echo "legless_degree6_floor=$legless_floor"
if [ "$legless_floor" = 9 ]; then note "and it reads a floor of 9 rather than 8, lowering every ratio beneath it, silently"
else bad "the legless copy did not move the floor to 9 -- the plant is not reaching the floor"; fi
echo ""

# ---- and the honest negative: the float slip does NOT move this floor ---------------------------
# Claiming the enumeration leg saved the finding would be the same flattering move this control
# refuses everywhere else. The truth is narrower and worth writing down: 574 and 575 both sit below
# 720, so at THIS point count the floor is 8 either way. The leg catches a real defect that is not
# load-bearing here -- and at a sky of exactly 575 points it would flip the floor from 7 to 8.
sed 's|function l1ball3(k) { return 1 + (2\*k\*(k+1)\*(2\*k+1))/3 + 2\*k }|function l1ball3(k) { return 1 + (2.0/3.0)*k*(k+1)*(2*k+1) + 2*k }|' "$SRC" \
  | sed 's|    if (c != e) { bad++; disagreements++ }|    if (0) { bad++; disagreements++ }|' > "$PEN/floatless.sh"
run_pen "$PEN/floatless.sh" floors 40
echo "floatless_verdict $VERDICT $CODE"
float_floor=$(printf '%s\n' "$OUT" | sed -n 's/^floor abelian n=720 degree=6 floor=\([0-9]*\) .*/\1/p' | tail -1)
echo "floatless_degree6_floor=$float_floor"
if [ "$VERDICT" = ok ] && [ "$float_floor" = 8 ]; then
  note "the float slip reads GREEN with the leg gone and leaves the floor at 8 -- wrong, and not load-bearing at 720 points"
else bad "the float slip moved the degree-6 floor, so the reading recorded here is wrong"; fi
if printf '%s\n' "$OUT" | grep -q '^l1ball3 k=7 closed=574 '; then
  note "and the wrong ball stands printed at k=7 with nothing counting it, which is the shape of a defect nobody sees"
else bad "the float slip did not produce a wrong ball at k=7"; fi
echo ""

printf 'behaviors=%d\n' "$behaviors"
printf 'faults=%d\n' "$fails"
if [ "$fails" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=control_fault"
exit 1
