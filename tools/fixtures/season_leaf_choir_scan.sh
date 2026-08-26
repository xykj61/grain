#!/bin/sh
# tools/fixtures/season_leaf_choir_scan.sh -- sing the season room's LEAF witnesses.
#
# WHAT THIS IS FOR. tools/gen/season/ holds 298 tracked witnesses and, until this choir, three
# of them were reached by a roster clock. The other 295 were the single largest unheard family in
# the tree -- 24.6% of its whole unreached population, in one directory (REDS %231). This scan is
# how that room starts being heard, and it sings the part of the room that can afford to be sung.
#
# WHY THE LEAVES RATHER THAN THE WHOLE ROOM. Of the 144 equinox rungs, 111 chain an elder rung,
# and each re-runs the entire chain beneath it -- so singing the family rung by rung is quadratic.
# Measured 20260825: 47 of 144 rungs cost 1,117 seconds, one of them 204 seconds by itself. The
# 33 LEAVES -- rungs that call scans and chain nobody -- cost 436 seconds for all of them, and
# every chained failure in that census resolved to a leaf or to a scan a leaf already reads. So
# the leaves are where a root lives, and singing them turns a multiplication into an addition.
#
# HOW A LEAF IS FOUND. Discovered, never listed: an equinox witness in the room that names no
# other witness. A leaf written tomorrow is sung on the lap it lands, and a rung that grows a
# chain leaves this choir on the lap it grows one, both without anybody editing a roster.
#
#   sh tools/fixtures/season_leaf_choir_scan.sh              # sing the room
#   sh tools/fixtures/season_leaf_choir_scan.sh prove-red    # plant one refusal, prove it is caught
#   sh tools/fixtures/season_leaf_choir_scan.sh --list       # print what it WOULD sing, run nothing
#
# reach-list: sh tools/fixtures/season_leaf_choir_scan.sh --list
set -eu

MODE=${1:-live}
ROOM=${SEASON_LEAF_ROOM:-tools/gen/season}
RISHI=rishi/bin/rishi

test -x "$RISHI" || { echo "choir=failed"; echo "detail=rishi_absent"; exit 1; }

PEN=$(mktemp -d "${TMPDIR:-/tmp}/season-leaf-choir.XXXXXX")
trap 'rm -rf "$PEN"' EXIT INT TERM

# --- discovery -----------------------------------------------------------------
# A leaf names no other witness. `git ls-files` rather than a glob, so an untracked stray in the
# room is never sung as though the repository carried it.
# THE PATTERN IS WRITTEN OUT, NOT ASSEMBLED (REDS %238). Hiding the room behind `$ROOM` in the
# ls-files call costs two readers at once: tools/fixtures/witness_reach_scan.sh cannot tell what
# this choir reaches, so it counted all 33 of these as unreached while they were being sung; and
# a person opening the file has to trace a variable to learn which room it stands over. A
# discovery rule a meter can read is a discovery rule a person can read. The env override still
# works for the control -- it takes the other branch, and the default names itself.
if [ "$ROOM" = "tools/gen/season" ]; then
  git ls-files "tools/gen/season/equinox_*_witness.rish" > "$PEN/all" 2>/dev/null || true
else
  git ls-files "$ROOM/equinox_*_witness.rish" > "$PEN/all" 2>/dev/null || true
fi
: > "$PEN/leaves"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  if grep -q '_witness\.rish"' "$f"; then continue; fi
  printf '%s\n' "$f" >> "$PEN/leaves"
done < "$PEN/all"

TOTAL=$(wc -l < "$PEN/all" | tr -d ' ')
LEAVES=$(wc -l < "$PEN/leaves" | tr -d ' ')

# --list prints exactly the set the sing below will run, and runs none of it. It exists for
# tools/fixtures/witness_reach_scan.sh, which otherwise has to guess a discovering choir's reach
# from its glob -- and the glob selects 144 where this sings 33, so the guess would overstate
# reach by 111 witnesses (REDS %238). A meter that asks is exact; a meter that infers is not.
if [ "$MODE" = "--list" ]; then
  cat "$PEN/leaves"
  exit 0
fi

echo "room=$ROOM"
echo "equinox_witnesses=$TOTAL"
echo "leaves=$LEAVES"

# A FLOOR, NEVER A PIN (REDS %235). The room grows, so an exact count would be a refusal waiting
# for the next rung. A floor still catches the failure that matters: a discovery rule that quietly
# stops matching reads exactly like a room in perfect health, and 33 is what the census measured.
LEAF_FLOOR=${SEASON_LEAF_FLOOR:-33}
if [ "$LEAVES" -lt "$LEAF_FLOOR" ]; then
  echo "choir=failed"
  echo "detail=want_at_least_${LEAF_FLOOR}_leaves_got_${LEAVES}"
  exit 1
fi
echo "leaf_floor=honored"

# --- the planted refusal -------------------------------------------------------
# A choir proven only in the passing direction cannot be told from a choir that sings nothing.
# prove-red adds one rung that refuses and nothing else, so the ONLY difference between the two
# runs is the planted failure.
# WHY prove-red SINGS THE PLANT ALONE. The live sing costs about 436 seconds on this pier
# (33 leaves, 20260825, dominated by e134 at 118 s, which reaches ten more witnesses through
# a scan). Singing the room a second time to prove the catch would double a cadence guard's
# cost to prove something the second pass does not touch: what prove-red has to show is that a
# refusal REACHES the verdict rather than being counted and swallowed, and one rung shows that.
# The live mode above is what proves the room.
if [ "$MODE" = "prove-red" ]; then
  mkdir -p "$PEN/plant"
  cat > "$PEN/plant/equinox_planted_refusal_witness.rish" <<'PLANT'
say "planted: this rung refuses on purpose"
assert false else "planted: the choir must hear a refusal"
PLANT
  printf '%s\n' "$PEN/plant/equinox_planted_refusal_witness.rish" > "$PEN/leaves"
  echo "planted=1"
  echo "sing_scope=plant_only"
fi

# --- the sing ------------------------------------------------------------------
GREEN=0
RED=0
: > "$PEN/red"
while IFS= read -r w; do
  [ -n "$w" ] || continue
  if "$RISHI" run "$w" > "$PEN/out" 2>&1; then
    GREEN=$((GREEN + 1))
  else
    RED=$((RED + 1))
    printf '%s\n' "$w" >> "$PEN/red"
    echo "RED_leaf $w"
    sed -n 's/^rishi: assertion failed -- /  reason /p' "$PEN/out" | head -1
  fi
done < "$PEN/leaves"

echo "sung=$((GREEN + RED))"
echo "green=$GREEN"
echo "red=$RED"

if [ "$MODE" = "prove-red" ]; then
  if [ "$RED" -ge 1 ] && grep -q 'equinox_planted_refusal_witness' "$PEN/red"; then
    echo "RED_planted_refusal_caught"
    echo "choir=refused_as_it_should"
    exit 1
  fi
  echo "choir=failed"
  echo "detail=planted_refusal_went_unheard"
  exit 1
fi

if [ "$RED" -ne 0 ]; then
  echo "choir=failed"
  echo "detail=leaf_refusals_${RED}"
  exit 1
fi

echo "choir=honored"
echo "verdict=ok"
