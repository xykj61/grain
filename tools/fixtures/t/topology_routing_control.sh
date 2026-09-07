#!/bin/sh
# tools/fixtures/t/topology_routing_control.sh -- the routing cost, broken on purpose.
#
#   sh tools/fixtures/t/topology_routing_control.sh
#
# WHY. `tools/fixtures/t/topology_routing_scan.sh` prints numbers a design would act on: that one
# 270-byte table routes exactly from all 720 nodes, that a torus routes optimally with no table at
# all, and that a circulant does not and cannot be talked into it by deeper lookahead. A number
# a reader can watch go wrong is a number a reader can trust, so this copies the scan into a pen,
# breaks it ten ways, watches each break refuse, and then lifts every break. It proves the pen
# innocent first, so each plant reads as the break speaking rather than as the pen.
#
# The last two are the ones worth reading twice. One is a plant the printed COUNT catches where the
# verdict word waves it through -- a reduced reach that still says `ok`. The other is a broken copy
# with the checking legs removed, which PASSES, because that is exactly what a silent wrong answer
# looks like from outside.
#
# WHY IT IS CHEAP. The full scan takes 52s, and eleven copies of that is ten minutes to prove ten
# plants. Every plant outside the three checking legs runs `SCAN_LEGS=fast` in about two seconds,
# and each reduced run prints its own `legs=` line, so every reading here announces its own reach
# and only the full one the witness binds can claim to be it.
#
# WHAT EACH PLANT DEFENDS:
#
#   1  branch-last-hop   -- the shared table recording the LAST generator on a shortest path rather
#                           than the first. The distances stay perfect and the table stops routing,
#                           which is the exact shape of a table that looks right in a dump. It bites
#                           on the star graph alone: commuting generators make either end of a
#                           shortest word a valid first step, so the abelian shapes stay exact and
#                           the honest reading is recorded rather than dressed as a catch.
#   2  torus-skips-y     -- the coordinate rule reducing only two of its three axes. A rule that
#                           stalls short is worse than one that wanders, and the leg counts each
#                           miss rather than truncating it.
#   3  negative-sentinel -- `best = -1` with `best < 0 ||` in the lookahead, the defect this
#                           instrument actually carried while it was being written: reaching the
#                           destination scores -1, the sentinel is -1, and the comparison then keeps
#                           the LAST candidate where it means to keep the best.
#   4  diff-without-mod  -- the routing difference computed outside its modulus, so a negative index
#                           reaches past the table's own range.
#   5  translate-blind   -- the transitivity leg comparing a value against itself rather than
#                           against the translated difference, so it reads `agree` while checking
#                           nothing at all. This one PASSES, which is the lesson it carries.
#   6  circulant-even    -- the exhibited circulant replaced by C_720(2,8,74), whose generators are
#                           all even, so half the points are unreachable.
#   7  star-stalls       -- the permutation rule losing the branch that acts when position one is
#                           already home, so it stalls forever on a permutation that fixes the
#                           first symbol.
#   8  entry-too-narrow  -- the table entry width halved, so an entry runs out of room before it
#                           has named every generator. The stored size falls, which is the direction
#                           a flattering number moves.
#   9  one-source-only   -- the any-node leg walking one source rather than 720. It reads `ok`, and
#                           the printed `sources=` is the only thing that says otherwise.
#   10 legless           -- plant 1, with the route and any-node legs removed. It PASSES. That is
#                           what every unchecked number in every instrument looks like.

set -eu

PEN="${TMPDIR:-/tmp}/topology-routing-control.$$"
trap 'rm -rf "$PEN"' EXIT INT TERM
rm -rf "$PEN"
mkdir -p "$PEN"

SRC="tools/fixtures/t/topology_routing_scan.sh"
[ -f "$SRC" ] || { echo "refused: $SRC is absent -- the control has nothing to copy"; exit 1; }

behaviors=0
fails=0
note() { behaviors=$((behaviors + 1)); printf '  %s\n' "$1"; }
bad()  { fails=$((fails + 1)); printf '  FAULT %s\n' "$1"; }

OUT=""; VERDICT=""; CODE=""
run_pen() {
  _file="$1"; _legs="$2"
  if OUT=$(SCAN_LEGS="$_legs" sh "$_file" 2>&1); then CODE=ok; else CODE=refused; fi
  VERDICT=$(printf '%s\n' "$OUT" | sed -n 's/^verdict=\(.*\)$/\1/p' | tail -1)
  [ -n "$VERDICT" ] || VERDICT=none
}
plant() {
  _name="$1"; _expr="$2"; _out="$PEN/$_name.sh"
  sed "$_expr" "$SRC" > "$_out"
  if cmp -s "$SRC" "$_out"; then bad "$_name did not apply -- the scan is spelled differently now"; return 1; fi
  return 0
}

echo "topology-routing-control: ten plants, each lifted, in $PEN"
echo ""

# ---- the pen, unbroken --------------------------------------------------------------------------
cp "$SRC" "$PEN/clean.sh"
run_pen "$PEN/clean.sh" all
echo "clean_verdict $VERDICT $CODE"
if [ "$VERDICT" = ok ] && [ "$CODE" = ok ]; then note "the unbroken pen passes, so a plant below speaks for itself"
else bad "the unbroken pen did not pass -- every plant below is unreadable"; fi
if printf '%s\n' "$OUT" | grep -q '^anynode shape=circ_1_8_75 sources=720 pairs=517680 exact=517680 wrong=0$'; then
  note "and one table routes all 517,680 ordered pairs exactly, from every one of the 720 sources"
else bad "the unbroken pen did not prove the any-node claim it exists to prove"; fi
if printf '%s\n' "$OUT" | grep -q '^claim lookahead_total_hops depth1=4786 depth2=4786 depth3=4786 buys=0$'; then
  note "and three depths of lookahead reach the same 4,786 hops, so the gap is the heuristic's"
else bad "the unbroken pen did not read the lookahead claim this control was built around"; fi
echo ""

# ---- plant 1: the table names the last generator rather than the first ---------------------------
if plant p1 's|BRANCH\[w\] = (lev == 1 ? k : BRANCH\[v\])|BRANCH[w] = k|'; then
  run_pen "$PEN/p1.sh" fast
  echo "plant1_branch_last_hop $VERDICT $CODE"
  if [ "$VERDICT" = instrument_fault ]; then note "a table holding the wrong end of the path is caught by the route leg"
  else bad "plant 1 passed -- a table that does not route reads as one that does"; fi
  if printf '%s\n' "$OUT" | grep -q '^route shape=star_S6 source=identity destinations=719 exact=5 wrong=714$'; then
    note "and it bites on the star graph, naming the shape and counting all 714 wrong walks"
  else bad "plant 1 refused without naming the shape that stopped routing"; fi
  if printf '%s\n' "$OUT" | grep -q '^route shape=circ_1_8_75 source=identity destinations=719 exact=719 wrong=0$'; then
    note "and the abelian shapes are UNMOVED, which is the honest reading: generators that commute make the last generator on a shortest path a valid first one, so only the non-abelian shape can tell the ends apart"
  else bad "plant 1 moved an abelian shape -- the commutativity reading recorded here is wrong"; fi
fi
echo ""

# ---- plant 2: the coordinate rule never reduces the middle axis -----------------------------------
if plant p2 's|    else if (y != ty) y = ((((ty - y + q) % q) \* 2 <= q) ? (y+1)%q : (y-1+q)%q)|    else if (0) y = y|'; then
  run_pen "$PEN/p2.sh" fast
  echo "plant2_torus_skips_y $VERDICT $CODE"
  if [ "$VERDICT" = instrument_fault ]; then note "a rule that cannot reach is counted as a miss rather than truncated"
  else bad "plant 2 passed -- an unreachable destination read as a reached one"; fi
  if printf '%s\n' "$OUT" | grep -q '^greedy shape=torus_12x5x12 .*unreached=[1-9]'; then
    note "and the miss is printed on the shape's own row, so the count is readable beside the verdict"
  else bad "plant 2 refused without printing the unreached count"; fi
fi
echo ""

# ---- plant 3: the negative sentinel, which this instrument actually had ---------------------------
sed 's@^  best = GAP_MAX$@  best = -1@; s@if (g < best) best = g@if (best < 0 || g < best) best = g@' "$SRC" > "$PEN/p3.sh"
if cmp -s "$SRC" "$PEN/p3.sh"; then bad "plant 3 did not apply -- the sentinel is spelled differently now"; else
  run_pen "$PEN/p3.sh" fast
  echo "plant3_negative_sentinel $VERDICT $CODE"
  if printf '%s\n' "$OUT" | grep -q '^claim lookahead_total_hops depth1=4786 depth2=4786 depth3=4786 buys=0$'; then
    bad "plant 3 left the lookahead reading unmoved -- the sentinel defends nothing"
  else note "a negative sentinel beside a negative reading moves the lookahead numbers, and is seen"
  fi
fi
echo ""

# ---- plant 4: the routing difference loses its modulus ---------------------------------------------
if plant p4 's|    if (kind == "circ") d = (dst - v + n) % n|    if (kind == "circ") d = dst - v|'; then
  run_pen "$PEN/p4.sh" fast
  echo "plant4_diff_without_mod $VERDICT $CODE"
  if [ "$VERDICT" = instrument_fault ]; then note "a difference outside the group indexes an absent entry, and the route leg says so"
  else bad "plant 4 passed -- an out-of-range table read went unnoticed"; fi
fi
echo ""

# ---- plant 5: the transitivity check compares against the wrong thing --------------------------------
if plant p5 's|if (DS\[t\] != D0\[(t - s + N) % N\]) mism++|if (DS[t] != DS[t]) mism++|'; then
  run_pen "$PEN/p5.sh" all
  echo "plant5_translate_blind $VERDICT $CODE"
  if [ "$VERDICT" = ok ] && printf '%s\n' "$OUT" | grep -q '^transit shape=circ_1_8_75 pairs=517680 mismatches=0 agree$'; then
    note "a check comparing a value to itself PASSES, which is why the clean run's agreement is proven elsewhere too"
  else bad "plant 5 did not reproduce the vacuous-check reading this control exists to show"; fi
fi
echo ""

# ---- plant 6: the exhibited circulant loses its odd generator ----------------------------------------
if plant p6 's|S_TAG\[2\]="circ_1_8_75";   S_KIND\[2\]="circ";  S_A\[2\]=1;  S_B\[2\]=8;  S_C\[2\]=75|S_TAG[2]="circ_1_8_75";   S_KIND[2]="circ";  S_A[2]=2;  S_B[2]=8;  S_C[2]=74|'; then
  run_pen "$PEN/p6.sh" fast
  echo "plant6_circulant_even $VERDICT $CODE"
  if [ "$VERDICT" = instrument_fault ]; then note "generators sharing a factor reach half the points, and the table leg refuses"
  else bad "plant 6 passed -- a disconnected graph was measured as if it were whole"; fi
  if printf '%s\n' "$OUT" | grep -q '^table shape=circ_1_8_75 not_connected reached=360 of=720$'; then
    note "and it names the 360 points it reached, so the failure is diagnosable from one line"
  else bad "plant 6 refused without naming how far it got"; fi
fi
echo ""

# ---- plant 7: the permutation rule loses its second branch --------------------------------------------
if plant p7 's|    else { for (i = 2; i <= 6; i++) if (arr\[i\] != i) break; arr\[1\] = arr\[i\]; arr\[i\] = 1 }|    else { hops = cap }|'; then
  run_pen "$PEN/p7.sh" fast
  echo "plant7_star_stalls $VERDICT $CODE"
  if [ "$VERDICT" = instrument_fault ]; then note "a permutation rule that cannot leave a fixed first symbol is counted as unreached"
  else bad "plant 7 passed -- a stalled rule read as an exact one"; fi
fi
echo ""

# ---- plant 8: the table entry cannot name every generator ----------------------------------------------
if plant p8 's|function bits_for(x,   b) { b = 0; while ((2\^b) < x) b++; return (b < 1 ? 1 : b) }|function bits_for(x,   b) { b = 0; while ((2^b) < x/2) b++; return (b < 1 ? 1 : b) }|'; then
  run_pen "$PEN/p8.sh" fast
  echo "plant8_entry_too_narrow $VERDICT $CODE"
  if [ "$VERDICT" = instrument_fault ]; then note "an entry too narrow to name a generator refuses, rather than reporting a smaller table"
  else bad "plant 8 passed -- a flattering table size went unread"; fi
  if printf '%s\n' "$OUT" | grep -q '^table shape=torus_12x5x12 entry_too_narrow bits=2 degree=6$'; then
    note "and the width and the degree are both printed, so the reader sees which one is wrong"
  else bad "plant 8 refused without naming the width it rejected"; fi
fi
echo ""

# ---- plant 9: the any-node leg walks one source, and still says ok -------------------------------------
awk '{ if ($0 ~ /^    for \(s = 0; s < N; s\+\+\) for \(t = 0; t < N; t\+\+\) \{$/ && !done) { print "    for (s = 0; s < 1; s++) for (t = 0; t < N; t++) {"; done=1 } else print }' "$SRC" > "$PEN/p9.sh"
if cmp -s "$SRC" "$PEN/p9.sh"; then bad "plant 9 did not apply -- the any-node loop is spelled differently now"; else
  run_pen "$PEN/p9.sh" all
  echo "plant9_one_source_only $VERDICT $CODE"
  if [ "$VERDICT" = ok ]; then note "a reduced reach still says ok -- the verdict word is not the reading"
  else bad "plant 9 refused, so this control cannot show what a silent reach cut looks like"; fi
  if printf '%s\n' "$OUT" | grep -q '^anynode shape=circ_1_8_75 sources=720 pairs=719 '; then
    note "and the printed sources and pairs are what disagree, which is why they are printed"
  else bad "plant 9 did not print a pair count a reader could catch it by"; fi
fi
echo ""

# ---- plant 10: the same break, with the checking legs removed, PASSES -----------------------------------
sed 's|BRANCH\[w\] = (lev == 1 ? k : BRANCH\[v\])|BRANCH[w] = k|' "$SRC" \
  | sed 's|      if (h == DIST0\[v\]) ok++; else wrong++|      if (h == DIST0[v]) ok++; else ok++|' \
  | sed 's|      if (h == DIST0\[(t - s + N) % N\]) ok++; else wrong++|      if (h == DIST0[(t - s + N) % N]) ok++; else ok++|' \
  > "$PEN/p10.sh"
run_pen "$PEN/p10.sh" all
echo "plant10_legless $VERDICT $CODE"
if [ "$VERDICT" = ok ] && [ "$CODE" = ok ]; then
  note "a table that does not route reads GREEN once the legs that read it are gone"
else bad "plant 10 refused -- the legless copy must pass, or the legs prove nothing"; fi
if printf '%s\n' "$OUT" | grep -q '^route shape=circ_1_8_75 source=identity destinations=719 exact=719 wrong=0$'; then
  note "and it prints a perfect route line over a table that cannot route -- the shape of every unchecked number"
else bad "plant 10 did not reproduce the flattering line"; fi
echo ""

echo "behaviors=$behaviors failures=$fails"
if [ "$fails" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=control_fault"; exit 1
