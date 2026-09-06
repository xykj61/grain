#!/bin/sh
# tools/fixtures/m/module_room_reach_scan.sh -- a room's NAME and a room's GLOB are different things.
#
# WHY. On `20260905` a design essay measured `mantra/` six ways in one table, and every number in
# that table is correct. Two rows read the room at every depth -- 32 Rye modules, 9,175 lines --
# and the row its whole conclusion rested on read it flat: ``mantra/*.rye`` files mentioning
# conflict, merge, three-way or diff3, **0**. A flat glob cannot see `mantra/src/`, and
# `mantra/src/weave.rye` is where the shape the essay concluded was unbuilt has stood since the
# tree's root commit. The same commit rostered four guards whose only job is to read that file.
# Three rounds were booked to write it again (REDS %441).
#
# THE SAME LANTERN HAS FIRED TWICE BEFORE, from the other side of one gap. `room_bound`'s
# dated-basename pattern matched none of `tools/`'s 1,917 entries, so it read ZERO for that room's
# whole life while the room stood 7.4x over bound with every guard green. REDS %175 found 237 logs
# carrying a stamp and no sprig, which a pattern requiring one read as living. Pattern-blind and
# depth-blind are two spellings of one fault -- the instrument's reach did not match the room it
# was pointed at, and the reading came back clean. A lantern that fires twice becomes a loom.
#
# WHAT THIS READS. For every top-level room holding tracked authored Rye, the count a flat glob
# `<room>/*.rye` reaches, against the count the room holds at every depth. Where the two differ the
# room has a HIDDEN SHELF, and any flat count published about that room understates it. Measured
# `20260905.225236`: 44 rooms, 14 with a hidden shelf, 513 files below a top level, and 8 rooms
# where a flat reading reports ZERO Rye while the room holds some -- `rye/` with 117 and `tools/`
# with 131 among them.
#
# WHAT THIS DOES NOT SAY, named rather than implied.
#   - A subdirectory is good structure, never a defect. `rye/` and `tools/` keep their Rye below
#     the top level on purpose, and this meter never asks a room to flatten. It publishes which
#     rooms a flat reading lies about, so a hand measuring one sees the trap in one command rather
#     than in a design essay three rounds later.
#   - Whether a published count actually used the wrong glob. That is a claim inside prose, and
#     reading it would mean parsing an essay's intent. This publishes the trap; a hand reads it.
#   - Any extension but the one asked for. `.rye` is where this bit and where the essay measured.
#     MODULE_ROOM_REACH_EXT widens it for a later lap without touching this reasoning.
#
# WHY IT ASKS GIT RATHER THAN find. Authored means tracked; a build output under `mantra/bin/` is
# not a module. The cost is that a pen must be a real repository, which is exactly the lesson
# `room_bound_control.sh` phase three wrote down after its own pens were plain directories and the
# `git ls-files` sweep read nothing in them.
#
# USAGE
#   sh tools/fixtures/m/module_room_reach_scan.sh              # census and gate
#   sh tools/fixtures/m/module_room_reach_scan.sh list         # census only, no gate
#   sh tools/fixtures/m/module_room_reach_scan.sh prove-red    # plant a hidden shelf; must be named
#   sh tools/fixtures/m/module_room_reach_scan.sh prove-vacuum # hand it no sources; must refuse
#
# Run from the repository root.

set -u

mode="${1:-count}"

# The extension a room's modules are written in. `.rye` is this tree's authored Rye and is what
# the essay measured; the variable exists so a later lap can point the same reading at another
# language without copying the file.
EXT="${MODULE_ROOM_REACH_EXT:-rye}"

# Rooms held for reading rather than authoring. `vendor/` and `gratitude/` are third-party and
# left unmodified by law; `seed/` is the public projection of this tree and is its own repository.
# Counting them would report other people's structure as ours.
SKIP_ROOMS='vendor gratitude seed'

sources="$(git ls-files 2>/dev/null | grep "\\.${EXT}\$" || true)"

# THE VACUUM LEG. A census that reads nothing prints a clean report and gates nothing, which is
# indistinguishable from a tree with no hidden shelves. `a guard that cannot red guards nothing`
# is this tree's own strand (REDS row 59), so an instrument that found no sources refuses and says
# which instrument came back empty rather than reporting zero.
if [ -z "$sources" ]; then
  echo "ext=$EXT"
  echo "rooms_read=0"
  echo "instrument=git ls-files"
  echo "verdict=blind"
  echo "refused: no tracked .$EXT sources -- the census read nothing, which is not the same as finding nothing"
  exit 1
fi

echo "ext=$EXT"

rooms_read=0
hidden_rooms=0
hidden_total=0
inverted=0
inconsistent=0

# A room is a top-level directory holding at least one tracked source of this extension at any
# depth. Discovery rather than a list, so a room made tomorrow is measured like every other.
for room in $(printf '%s\n' "$sources" | awk -F/ 'NF>1 {print $1}' | sort -u); do
  case " $SKIP_ROOMS " in *" $room "*) continue ;; esac

  # THREE INDEPENDENT PATTERNS, and the independence is the whole point. Deriving `hidden` as
  # `recursive - flat` would make the check below `flat + (recursive - flat) == recursive`, which
  # is true for every input and therefore guards nothing -- this tree's own law (REDS row 59: a
  # guard that cannot red guards nothing) applied to a gate that was one subtraction from being
  # decorative. Counted separately, the three readings can disagree, and disagreement means a
  # pattern here is wrong.
  recursive=$(printf '%s\n' "$sources" | grep -c "^$room/" || true)
  flat=$(printf '%s\n' "$sources" | grep -c "^$room/[^/]*\$" || true)
  hidden=$(printf '%s\n' "$sources" | grep -c "^$room/[^/]*/" || true)

  rooms_read=$((rooms_read + 1))
  hidden_total=$((hidden_total + hidden))

  # The arithmetic is the gate with teeth: a flat reading plus what it cannot see must equal the
  # whole room. Two greps over one list can only disagree if a pattern is wrong, so this refuses
  # the instrument rather than the tree -- the one thing a census can honestly check about itself.
  if [ "$((flat + hidden))" -ne "$recursive" ]; then
    inconsistent=$((inconsistent + 1))
    reading=inconsistent
  elif [ "$hidden" -eq 0 ]; then
    reading=flat_reaches_all
  elif [ "$flat" -eq 0 ]; then
    # The inverted reading, and the sharpest one. A flat glob here does not understate the room --
    # it reports that the room holds no Rye at all, which is what `rye/` and `tools/` answer.
    inverted=$((inverted + 1))
    hidden_rooms=$((hidden_rooms + 1))
    reading=flat_reads_zero
  else
    hidden_rooms=$((hidden_rooms + 1))
    reading=hidden_shelf
  fi

  echo "room=$room flat=$flat recursive=$recursive hidden=$hidden reading=$reading"
done

echo "rooms_read=$rooms_read"
echo "hidden_rooms=$hidden_rooms"
echo "hidden_total=$hidden_total"
echo "inverted=$inverted"
echo "inconsistent=$inconsistent"

if [ "$mode" = list ]; then
  exit 0
fi

# TWO GATES, BOTH ABOUT THE INSTRUMENT, NEITHER ABOUT THE TREE'S SHAPE.
#   rooms_read   -- a census that discovered no rooms is blind, not clean.
#   inconsistent -- a room whose two readings do not add up means a pattern here is wrong.
# The census itself gates nothing and is meant to: refusing a subdirectory would refuse `rye/` and
# `tools/` for being organized, and a wall that reds on ordinary work is a wall someone turns off.
if [ "$rooms_read" -eq 0 ]; then
  echo "verdict=blind"
  echo "refused: no room held a tracked .$EXT source -- the instrument reached nothing"
  exit 1
fi

if [ "$inconsistent" -ne 0 ]; then
  echo "verdict=inconsistent"
  echo "refused: $inconsistent room(s) whose flat and hidden readings do not sum to the whole"
  exit 1
fi

echo "verdict=ok"
