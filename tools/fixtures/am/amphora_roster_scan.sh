#!/bin/sh
# tools/fixtures/am/amphora_roster_scan.sh -- every authored Amphora module answers to a rostered
# guard, or is counted.
#
# WHAT THIS READS. `amphora/` is the vessel room: pour, carry, restore, and the seal and stamp
# beneath them. `construction/standing-equipment.kyri` is the one roster the cold and hot passes
# read. This scan asks the coverage question those two documents can only answer together -- for
# each authored `.rye` module in the room, does at least one ROSTERED guard name it?
#
# WHY IT EXISTS (`20260907.223214`). The Sound lane has carried this reading for its own room since
# `20260826` (`tools/fixtures/t/tally_roster_scan.sh`, *every tally module answers to a witness, or
# is counted*). Amphora had no twin, so its coverage lived in a roster comment a hand typed and
# re-typed: the block above the vessel rows carried `7 modules and 3,603 lines` on `20260906` and
# the line count had drifted 273 by the next morning with nothing listening (the row booked
# `20260907.215529`), and `amphora/README.md` still reads *twelve standing witnesses run every lap*
# against 15 rostered rows, 13 of them on the lap clock. A count in prose is a claim with no
# instrument -- REDS `%360`'s family -- and this is the instrument for this room.
#
# THE READINGS:
#   modules           authored `.rye` under the room, symlinks excluded
#   linked            symlinks into another lane's room                    reported
#   guards            roster rows whose path sits under the guard room
#   lap_guards        of those, `tier lap` or no tier -- run every pass
#   cadence_guards    of those, `tier cadence` -- run on the fifth round
#   orphan_rows       a roster row naming a guard file the room lacks      GATED at zero
#   uncovered         a module no rostered guard names                     GATED at zero
#   singly_covered    a module exactly one rostered guard names            reported
#
# A SYMLINK IS NOT THIS LANE'S MODULE. `amphora/kumara.rye`, `tally_copy.rye` and `wire_format.rye`
# are links into `tally/` and `comlink/`, and a coverage reading that counted them would hold this
# lane to account for another lane's witnesses. The room is read off the filesystem with `! -type l`
# rather than off `git ls-files`, which lists a link exactly like a file -- the same reading that
# overstated this room 10 against 7 -- and a filesystem read is also what lets the control point
# this scan at a throwaway pen, which is no git repository at all.
#
# A SHIM IS FOLLOWED ONE HOP. Nine files under `tools/am/` are accrete shims that run a target under
# `tools/gen/amphora/` and exit its code, so the module names live in the target rather than in the
# rostered path. Every `.rish` literal a guard names, that exists and is not the guard itself, is
# read alongside it -- bounded at four per guard, since a guard reaching further than that is
# orchestration rather than a shim and should be read for itself.
#
# WHAT IT DOES NOT REACH, named rather than implied. Whether a guard that names a module PROVES
# anything about it: naming is what a text can show, and a claim's worth is a hand's reading. And
# whether a guard runs green -- the standing roster answers that every pass, and this one asks only
# whether the roster is pointed at the whole room.
#
#   sh tools/fixtures/am/amphora_roster_scan.sh [<room>] [<roster>] [<guard_room>]
#
# Exit 0 when the room is covered, 1 when it parts, and 2 when the scan cannot read what it was
# pointed at. An absent room or roster answers `misread`, since zero is the reading a covered room
# gives and the two must never look alike.
set -eu

ROOM=${1:-amphora}
ROSTER=${2:-construction/standing-equipment.kyri}
GUARD_ROOM=${3:-tools/am}

# Bound: the detail listing stops here and says so. An unbounded print is an unbounded allocation
# (TAME), and a room past this wants a fold rather than a longer printout.
MAX_DETAIL=64
# Bound: how far one guard is followed. Four covers a shim and its target with room to spare.
MAX_HOPS=4

if ! test -d "$ROOM"; then
  echo "verdict=misread"
  echo "detail=room_absent"
  echo "detail_room=$ROOM"
  exit 2
fi
if ! test -f "$ROSTER"; then
  echo "verdict=misread"
  echo "detail=roster_absent"
  echo "detail_roster=$ROSTER"
  exit 2
fi

echo "room=$ROOM"
echo "roster=$ROSTER"
echo "guard_room=$GUARD_ROOM"

TMP=$(mktemp -d "${TMPDIR:-/tmp}/amphora_roster.XXXXXX") || exit 2
trap 'rm -rf "$TMP"' EXIT

# The room's own modules: every authored .rye at any depth, links left to the lane that owns them.
find "$ROOM" -name '*.rye' -type f ! -type l | LC_ALL=C sort > "$TMP/modules"
find "$ROOM" -name '*.rye' -type l | LC_ALL=C sort > "$TMP/linked"
modules=$(grep -c '' "$TMP/modules" || true)
linked=$(grep -c '' "$TMP/linked" || true)
echo "modules=$modules"
echo "linked=$linked"

# The roster's rows for this guard room, each carrying the tier it was seated at. A row with no
# tier line runs every lap, which is the roster's own default, so absence is spelled `lap` here.
awk -v room="$GUARD_ROOM/" '
  /^guard /  { if (path != "") print path, tier; path = ""; tier = "lap"; next }
  /^path /   { if (index($2, room) == 1) path = $2; next }
  /^tier /   { if (path != "") tier = $2; next }
  END        { if (path != "") print path, tier }
' "$ROSTER" > "$TMP/rows"

guards=$(grep -c '' "$TMP/rows" || true)
lap_guards=$(awk '$2 == "lap"' "$TMP/rows" | grep -c '' || true)
cadence_guards=$(awk '$2 == "cadence"' "$TMP/rows" | grep -c '' || true)
other_tier_guards=$(awk '$2 != "lap" && $2 != "cadence"' "$TMP/rows" | grep -c '' || true)
echo "guards=$guards"
echo "lap_guards=$lap_guards"
echo "cadence_guards=$cadence_guards"
echo "other_tier_guards=$other_tier_guards"

# A row naming a file the guard room lacks: the roster promising a guard nobody can run.
: > "$TMP/orphans"
while read -r p _t; do
  test -f "$p" || echo "$p" >> "$TMP/orphans"
done < "$TMP/rows"
orphan_rows=$(grep -c '' "$TMP/orphans" || true)
echo "orphan_rows=$orphan_rows"

# Every guard's own text, plus the text of the .rish files it delegates to -- one hop, bounded.
: > "$TMP/texts"
while read -r p _t; do
  test -f "$p" || continue
  echo "$p" >> "$TMP/texts"
  hops=0
  for d in $(grep -o '[A-Za-z0-9_./-]*\.rish' "$p" 2>/dev/null | LC_ALL=C sort -u); do
    [ "$hops" -ge "$MAX_HOPS" ] && break
    [ "$d" = "$p" ] && continue
    test -f "$d" || continue
    echo "$d" >> "$TMP/texts"
    hops=$((hops + 1))
  done
done < "$TMP/rows"
LC_ALL=C sort -u "$TMP/texts" > "$TMP/texts_uniq"

# A module is covered when a rostered guard's text names its path. The whole relative path is the
# token, so `vessel_seal.rye` can never credit a guard that only ever named `vessel_seal_demo.rye`.
: > "$TMP/uncovered"
: > "$TMP/singly"
while read -r m; do
  n=0
  if [ -s "$TMP/texts_uniq" ]; then
    n=$(grep -lF "$m" $(cat "$TMP/texts_uniq") 2>/dev/null | grep -c '' || true)
  fi
  if [ "$n" -eq 0 ]; then
    echo "$m" >> "$TMP/uncovered"
  elif [ "$n" -eq 1 ]; then
    echo "$m" >> "$TMP/singly"
  fi
done < "$TMP/modules"

uncovered=$(grep -c '' "$TMP/uncovered" || true)
singly_covered=$(grep -c '' "$TMP/singly" || true)
covered=$((modules - uncovered))
echo "covered=$covered"
echo "uncovered=$uncovered"
echo "singly_covered=$singly_covered"

# Name every one of them. A count nobody can act on is the complaint the dated-path census made of
# itself: it printed no list, so nobody could name the thing it was refusing over.
name_them() { # name_them <key> <file>
  shown=0
  while IFS= read -r n; do
    if [ "$shown" -ge "$MAX_DETAIL" ]; then
      echo "${1}_truncated_at=$MAX_DETAIL"
      break
    fi
    echo "detail_${1}=$n"
    shown=$((shown + 1))
  done < "$2"
}
name_them uncovered "$TMP/uncovered"
name_them singly "$TMP/singly"
name_them orphan_row "$TMP/orphans"
name_them linked "$TMP/linked"

if [ "$uncovered" -eq 0 ] && [ "$orphan_rows" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi

echo "verdict=drifted"
exit 1
