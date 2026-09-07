#!/bin/sh
# tools/fixtures/t/tally_roster_scan.sh -- every tally module answers to a witness, or is counted.
#
# The choir-and-bijection calling reaching the allocator room (the constellation charter,
# active-designing/20260826-174418_the-constellation-and-the-callings.md): witness health is a
# thing this meter READS off disk, never a thing anyone remembers. For each tally/*.rye module it
# asks whether a tools/t check owns it by name, holds the uncovered as a ratchet under a ceiling
# that only falls, and refuses a newborn module arriving with no witness -- so coverage can shrink
# toward whole and can never quietly thin.
#
# What counts as covered, and what stays honestly apart:
#   * A module m is covered when tools/t holds tally_<m>.rish or tally_<m>_*.rish -- the matcher
#     anchors the whole module name at a boundary, so tally_budget_*.rish can never credit `bud`
#     (the flag-inside-a-longer-word lesson, learned on this tree the hard way).
#   * A *_test.rye program is a named exception rather than a gap: it is its own check, run by
#     the witnesses that compose it, and the caravan choir's asymmetry already seats this shape --
#     fixtures prove through the rungs that use them.
#   * Family checks (caller_map, glow_tend, a2 folds, name_len) guard properties across modules
#     and credit no single one; the per-module reading is what this meter exists to take.
#
# Measured 20260826 at seating: 14 modules -- 5 covered (copy, gardens, maybe, no_padding,
# parse_int), 3 test-program exceptions, 6 uncovered (bud, kumara, pedersen, region, seed,
# stack). The ceiling seats at 6 and only falls: cover one and the ceiling follows it down.
# 20260827: region covered (tools/t/tally_region_witness.rish -- divide, the watched refusals,
# the symlink fold, seed re-proven); the ceiling falls 6 -> 5.
# 20260828.212447: bud's known-answer witness returns after the fixture fold, so the ceiling falls
# 5 -> 4. pedersen stays in the ratchet: the bud witness proves the shim as a leg, while this meter
# reads ownership from a witness whose name answers for the module.
# 20260828.222157: seed gains its direct two-sided witness, so the ceiling falls 4 -> 3.
# 20260829: stack gains its direct exact-bound and over-bound witness, so the ceiling falls 3 -> 2.
# 20260830.053458: pedersen's compatibility seam gains its direct passing answer and missing-forward
# refusal, so the ceiling falls 2 -> 1.
# 20260830.102631: Kumara gains its direct fixture-key witness with the typed and raw refusal walls
# proven load-bearing, so the ceiling falls 1 -> 0 and the Tally roster reads whole.
#
# THE SECOND READING, and the gap that earned it (the row stamped `20260906.180651`, unshared
# when this landed, so cited by its key rather than by a number). `covered` counts FILENAMES. The
# sentence beside it in tools/t/tally_roster_witness.rish claimed a clock -- "a covered module has
# a proof the standing roster actually runs" -- and that runner called five of the eleven. Six
# covered modules were carried by no roster row at all: copy, gardens, maybe, no_padding and
# parse_int were named only by tools/t/tensegral_arc_iv_witness.rish and tools/p/parity_ch01.rish,
# neither on the standing roster, and tally/region.rye -- the one memory-carving body in the tree,
# which seed and gardens fold into and three Caravan rungs reach through a symlink -- was named by
# no runner anywhere. So `heard` is read here beside `covered`: for each covered module, does this
# room's own roster runner name its witness IN COMMAND POSITION? The two numbers now stand side by
# side, and a lap that adds a witness and forgets to call it reds on the lap it lands.
#
# WHAT COUNTS AS AN INVOCATION, and the trap that shaped it. A path NAMED is not a path RUN
# (the same line tools/fixtures/w/witness_reach_scan.sh draws). A call here is a non-comment line
# carrying `run [` and the witness path as a QUOTED token -- the leading double quote is what does
# the work, because this witness's own pen writes `${pen}/tools/t/tally_copy.rish` inside a
# `run [` and a looser match would read that plant as proof that `copy` is run. That is the
# flag-inside-a-longer-word lesson this room already learned once, one level up.
#
# Honest limit, named where it can be read: the anchored name-match reads OWNERSHIP by the
# room's own naming convention, and a name is not yet a run -- a witness could name a module and
# exercise nothing. The deeper reading (which files a witness actually consumes) is the fusion
# map's ground, and when that map lands this meter's matcher trades name-adjacency for it.
# `heard` inherits that limit and adds its own: it reads THIS room's runner alone, so a module
# reached by some other rostered choir still reads unheard. That is deliberate rather than
# incidental -- one room, one clock, and a part that stands free when pulled.
#
# Portable POSIX sh (the BSD dialect family's standing lesson).
#
#   sh tools/fixtures/t/tally_roster_scan.sh [root]      # root defaults to ., pen-friendly
#
# Prints modules_total / covered / test_programs / uncovered / heard / unheard, one line naming
# each uncovered module and each unheard one; verdict=ok exits 0, verdict=over_ceiling and
# verdict=unheard_over_ceiling exit 1, and a missing room or a missing runner exits 2 -- a reading
# taken with no runner to read would report every module unheard and name the wrong fault.

root=${1:-.}
CEILING="${TALLY_ROSTER_CEILING:-0}"
UNHEARD_CEILING="${TALLY_ROSTER_UNHEARD_CEILING:-0}"

# The room's own roster runner -- the single row on construction/standing-equipment.kyri that
# carries this room's clock. `heard` is measured against this file and nothing else.
runner="$root/tools/t/tally_roster_witness.rish"

if [ ! -d "$root/tally" ] || [ ! -d "$root/tools/t" ]; then
  echo "verdict=no_room"
  exit 2
fi

if [ ! -f "$runner" ]; then
  echo "verdict=no_runner"
  echo "refused: $runner is absent, so no invocation can be read -- reporting every module unheard would name the wrong fault."
  exit 2
fi

total=0; covered=0; tests=0; uncovered=0; heard=0; unheard=0
uncovered_names=""
unheard_names=""

for f in "$root"/tally/*.rye; do
  [ -f "$f" ] || continue
  m=${f##*/}; m=${m%.rye}
  total=$((total+1))
  case "$m" in
    *_test) tests=$((tests+1)); continue ;;
  esac
  hit=no
  called=no
  # The anchored matcher: the module name whole, then end-of-name or an underscore seam.
  for w in "$root"/tools/t/tally_"$m".rish "$root"/tools/t/tally_"$m"_*.rish; do
    [ -f "$w" ] || continue
    hit=yes
    # The invocation reader. A call is a non-comment line carrying `run [` and the witness path
    # as a QUOTED token; the leading double quote is what keeps a pen path like
    # ${pen}/tools/t/tally_copy.rish from reading as proof that copy is run.
    rel="tools/t/${w##*/}"
    if grep -v '^[[:space:]]*#' "$runner" | grep -F 'run [' | grep -Fq "\"$rel\""; then
      called=yes
    fi
  done
  if [ "$hit" = yes ]; then
    covered=$((covered+1))
    if [ "$called" = yes ]; then
      heard=$((heard+1))
    else
      unheard=$((unheard+1))
      unheard_names="$unheard_names $m"
    fi
  else
    uncovered=$((uncovered+1))
    uncovered_names="$uncovered_names $m"
  fi
done

echo "modules_total=$total"
echo "covered=$covered"
echo "test_programs=$tests"
echo "uncovered=$uncovered"
echo "uncovered_ceiling=$CEILING"
echo "heard=$heard"
echo "unheard=$unheard"
echo "unheard_ceiling=$UNHEARD_CEILING"
for n in $uncovered_names; do
  echo "uncovered: tally/$n.rye"
done
for n in $unheard_names; do
  echo "unheard: tally/$n.rye"
done

if [ "$uncovered" -gt "$CEILING" ]; then
  echo "verdict=over_ceiling"
  echo "refused: $uncovered tally modules stand without a witness against a ceiling of $CEILING -- a newborn module arrives with its check, or the ceiling stays where it was."
  exit 1
fi

if [ "$unheard" -gt "$UNHEARD_CEILING" ]; then
  echo "verdict=unheard_over_ceiling"
  echo "refused: $unheard covered tally modules have a witness this room's roster runner never calls, against a ceiling of $UNHEARD_CEILING -- a proof nothing runs is a filename, and covered would be claiming a clock it does not keep."
  exit 1
fi

echo "verdict=ok"
exit 0
