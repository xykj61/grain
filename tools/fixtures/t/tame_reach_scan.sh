#!/bin/sh
# tools/fixtures/t/tame_reach_scan.sh -- the reach of the TAME style law over authored Rye.
#
# WHY. `tools/fixtures/t/tame_style_rooms.txt` is a hand-written list of rooms, and it decides
# which authored `.rye` the tree's own style law is ever read over. Its head argues that case well
# and names a twenty-first room it deliberately declines to add. Nothing measures how much of the
# tree stands outside it, so the roster's reach has only ever been reasoned about -- and a
# hand-written enumeration standing in for a population reads as coverage from every side, which
# is the shape REDS %532 booked one room over.
#
# WHAT THAT COST, measured `20260908.184342` and the reason this meter exists. The roster's own
# note sizes the deferred widening from ONE advisory ratchet: the camelCase reading, seven names,
# six after an inherited-name exemption. Read the BAN class over the same uncovered population --
# the class that FAILS parity rather than printing a count -- and it stands at 736 hits across 122
# files, 718 of them `std.debug.assert(` in `rye/tests`, none of them in a comment. The deferral
# was sound and its stated size was three orders short, because the number that sized it came from
# the half of the law that only advises.
#
# WHAT IT READS. Tracked authored Rye, tree-wide, against the roster.
#
#   roster_rooms      non-comment lines in the roster file
#   phantom_rooms     roster lines holding no tracked authored Rye        -- GATED AT ZERO
#   population        tracked *.rye, no symlink, no .cache/, no bin/
#   covered           population standing under a roster room
#   uncovered         the rest
#   uncovered_plant   uncovered files under tools/fixtures/ -- read past, and why below
#   uncovered_authored  uncovered minus the plants                        -- FREE, reported
#   uncovered_rooms   top-level rooms holding uncovered authored Rye      -- reported
#   uncovered_rooms_unknown  those the debt-room list does not name       -- GATED AT ZERO
#   debt_rooms        lines in the debt-room list                         -- RATCHET
#   unwatched_ban_files  uncovered_authored files carrying a ban          -- reported
#   unwatched_ban_rooms  the top-level rooms those files stand in          -- reported
#   unwatched_ban_hits   ban hits in uncovered_authored                   -- RATCHET
#
# WHY THE POPULATION IS TRACKED RATHER THAN FOUND. The bans half walks its rooms with `find`, so
# it reads an untracked scratch file beside an authored one. Pointed at the whole tree that flag
# set would sweep `vendor/` and every build leftover, so this meter asks git instead: what the
# tree tracks is what the tree governs and what a clone receives. The two agree exactly on the
# roster's own rooms today, and where they could part, tracked is the honest side.
#
# WHY tools/fixtures/ IS READ PAST. A guard proves its refusals by planting them, so
# `tame_style_ban_err_eq_code.rye` and its siblings MUST carry the bans they exist to trip. Both
# `) == error.` hits in the uncovered population are exactly those plants. Counting a control's
# plant as unwatched debt would red this meter over the very files that prove the law works.
#
# WHY phantom_rooms IS THE ONLY GATE. A roster line is hand-typed, so a rename anywhere in the
# tree can leave it naming nothing -- and the law then narrows in silence, which is this file's
# whole subject wearing its smallest form. Zero costs nothing to hold and is loud the day it goes.
#
# WHY uncovered_rooms_unknown IS THE SECOND GATE, AND WHY THE FILE COUNT IS NOT. Neither backlog
# was made today, and a gate that reds on work nobody did is a gate somebody turns off. The elder
# reading gated `uncovered_authored` -- a FILE count -- under a ceiling that only falls, and it
# answered two questions at once: how much debt stands, which falls only as repairs land, and how
# many authored Rye files exist outside the roster, which rises whenever anyone writes one. So it
# red on the first lawful new file in an already-uncovered room. Twice: `tools/rye/perf_self_count.rye`
# on `20260909.002917`, answered by raising the ceiling 551 -> 552, and `tools/rye/wrap_ring.rye`
# on `20260910.061931`. A lantern that fires twice becomes a loom.
#
# The two strands are read apart from `20260910.081500`. A top-level ROOM is what a widening
# actually moves -- a room joins the style roster or it does not, and its files move with it -- so
# `uncovered_rooms_unknown` is gated at zero against tools/fixtures/t/tame_reach_debt_rooms.txt and
# `debt_rooms` ratchets under a ceiling that only falls. That pair delivers the promise this header
# claimed and the file count never kept: a room born tomorrow joins the roster, or this guard hears
# it on the lap it arrives, where a new room's first file used to read exactly like a new file in
# an old room. `uncovered_authored` stays printed and is FREE -- nothing holds it, it rises with
# ordinary work, and a hand sizing a widening wants the population rather than a gate.
#
# WHAT THE ROOM READING DOES NOT REACH. Debt growing INSIDE an already-named room: fifty new files
# under `lotus/` move nothing gated. That is deliberate -- it is the ordinary work the elder gate
# refused -- and the free file count is where a reader sees it happen. A room is also the top path
# segment, so a `.rye` at the tree root belongs to no room and is left out of both room readings
# while still standing in the file count; none exists today.
#
# WHAT THIS DOES NOT SAY. Whether a room BELONGS on the roster. `crypto/` is absent on purpose --
# it implements Ed25519 rather than calling it -- and this meter never asks for it. It publishes
# what the law does not reach, so the hand that owns the ratchet ceilings sizes its widening from
# a measurement rather than from the one number that happened to be at hand.
#
#   sh tools/fixtures/t/tame_reach_scan.sh

set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT" || exit 2

ROSTER=${TAME_REACH_ROSTER:-tools/fixtures/t/tame_style_rooms.txt}
if [ ! -f "$ROSTER" ]; then
  echo "$0: no roster at $ROSTER -- the population this meter compares against is absent" >&2
  exit 2
fi

DEBT_ROOMS=${TAME_REACH_DEBT_ROOMS:-tools/fixtures/t/tame_reach_debt_rooms.txt}
if [ ! -f "$DEBT_ROOMS" ]; then
  echo "$0: no debt-room list at $DEBT_ROOMS -- with none, every uncovered room reads unknown" >&2
  exit 2
fi

WORK=$(mktemp -d) || exit 2
trap 'rm -rf "$WORK"' EXIT INT TERM

# The alphabet must be one alphabet. A meter that sorts and a meter that compares disagreeing
# about collation is how %532's scan first read ten phantom desks that were all present on disk.
LC_ALL=C
export LC_ALL

grep -v '^#' "$ROSTER" | grep -v '^[[:space:]]*$' | sed 's/[[:space:]]*$//' | sort -u > "$WORK/rooms"
roster_rooms=$(grep -c . "$WORK/rooms")

git ls-files -- '*.rye' \
  | grep -v '/\.cache/' \
  | grep -v '/bin/' \
  | while IFS= read -r f; do [ -L "$f" ] || printf '%s\n' "$f"; done \
  | sort -u > "$WORK/population"
population=$(grep -c . "$WORK/population")

: > "$WORK/covered"
: > "$WORK/phantom"
while IFS= read -r room; do
  [ -n "$room" ] || continue
  n=$(grep -c "^$room/" "$WORK/population" 2>/dev/null) || n=0
  if [ "$n" -eq 0 ]; then
    printf '%s\n' "$room" >> "$WORK/phantom"
  else
    grep "^$room/" "$WORK/population" >> "$WORK/covered"
  fi
done < "$WORK/rooms"
sort -u "$WORK/covered" -o "$WORK/covered"

covered=$(grep -c . "$WORK/covered")
phantom_rooms=$(grep -c . "$WORK/phantom" 2>/dev/null) || phantom_rooms=0

comm -23 "$WORK/population" "$WORK/covered" > "$WORK/uncovered"
uncovered=$(grep -c . "$WORK/uncovered")

grep '^tools/fixtures/' "$WORK/uncovered" > "$WORK/plant" 2>/dev/null || : > "$WORK/plant"
uncovered_plant=$(grep -c . "$WORK/plant" 2>/dev/null) || uncovered_plant=0
grep -v '^tools/fixtures/' "$WORK/uncovered" > "$WORK/authored" 2>/dev/null || : > "$WORK/authored"
uncovered_authored=$(grep -c . "$WORK/authored" 2>/dev/null) || uncovered_authored=0

# The rooms the uncovered files stand in, and which of them the debt-room list already names. A
# top-level room is the reading because it is what a widening actually moves: a room joins the
# style roster or it does not, and every file inside it moves with it. A count of files answers a
# different question and rises with ordinary work, which is the braid this pair replaces.
awk -F/ 'NF > 1 {print $1}' "$WORK/authored" | sort -u > "$WORK/uncovered_rooms"
uncovered_rooms=$(grep -c . "$WORK/uncovered_rooms" 2>/dev/null) || uncovered_rooms=0
grep -v '^#' "$DEBT_ROOMS" | grep -v '^[[:space:]]*$' | sed 's/[[:space:]]*$//' | sort -u > "$WORK/debt_rooms"
debt_rooms=$(grep -c . "$WORK/debt_rooms" 2>/dev/null) || debt_rooms=0
comm -23 "$WORK/uncovered_rooms" "$WORK/debt_rooms" > "$WORK/unknown_rooms"
uncovered_rooms_unknown=$(grep -c . "$WORK/unknown_rooms" 2>/dev/null) || uncovered_rooms_unknown=0

# The ban roster is the bans half's own, fixed-string every one. Kept here as a literal list
# rather than parsed out of that script: a parser that silently matched nothing would report a
# clean tree, which is the failure this whole meter exists to refuse.
BANS=') == error.
) != error.
std.debug.assert(
copyForwards
copyBackwards
Self = @This()
usingnamespace
!comptime
FIXME
dbg('

: > "$WORK/ban_files"
unwatched_ban_hits=0
if [ "$uncovered_authored" -gt 0 ]; then
  printf '%s\n' "$BANS" | while IFS= read -r ban; do
    [ -n "$ban" ] || continue
    c=$(grep -ohF -- "$ban" $(cat "$WORK/authored") 2>/dev/null | grep -c .) || c=0
    printf '%s\t%s\n' "$c" "$ban" >> "$WORK/ban_counts"
    grep -lF -- "$ban" $(cat "$WORK/authored") 2>/dev/null >> "$WORK/ban_files"
  done
  unwatched_ban_hits=$(awk -F'\t' '{s+=$1} END{print s+0}' "$WORK/ban_counts" 2>/dev/null)
  [ -n "$unwatched_ban_hits" ] || unwatched_ban_hits=0
fi
sort -u "$WORK/ban_files" -o "$WORK/ban_files" 2>/dev/null || :
unwatched_ban_files=$(grep -c . "$WORK/ban_files" 2>/dev/null) || unwatched_ban_files=0
# The rooms carrying them, named rather than left to a grep. A count says how much; a room says
# where, and where is what a hand widening the roster needs.
unwatched_ban_rooms=$(awk -F/ '{print $1}' "$WORK/ban_files" 2>/dev/null | sort -u | tr '\n' ' ' | sed 's/ $//')

#
# THE ELDER CEILING AND ITS TWO FIRINGS, KEPT AS THE RECORD. `TAME_REACH_UNCOVERED_CEILING` gated
# the file count from `20260908.195706` at 551 and rose to 552 on `20260909.002917`, for
# `tools/rye/perf_self_count.rye` -- whose home is fixed by the naming law (a `.rye` source of
# `tools/` lives in `tools/rye/`), and whose absence reds `energy_instrument` in turn, so no
# placement satisfied both guards. It was raised rather than gamed: moving the file under
# `tools/fixtures/` would have read as a plant and passed, which is the meter measuring its own
# blind spot. That lap booked the split by stamp and left it, since `construction/REDS.md` stood
# within a row's length of its bound. The second firing, `tools/rye/wrap_ring.rye` on
# `20260910.061931`, is what took it: the ceiling and its variable are retired here, replaced by
# the room pair above.
# THE DEBT-ROOM CEILING ONLY FALLS, and it fell once: 25 -> 24 on `20260910.123000`, when `brix`
# joined the style roster and left the debt list. A room leaves by its Rye coming under the law,
# which is the one lawful exit, so the ceiling follows it down in the same commit.
DEBT_ROOM_CEILING=${TAME_REACH_DEBT_ROOM_CEILING:-24}
BAN_CEILING=${TAME_REACH_BAN_CEILING:-736}

verdict=ok
if [ "$phantom_rooms" -gt 0 ]; then
  verdict=phantom_room
  echo "detail: the roster names $phantom_rooms room(s) holding no tracked authored Rye -- the law narrowed without a word --"
  sed 's/^/  /' "$WORK/phantom"
fi
if [ "$uncovered_rooms_unknown" -gt 0 ]; then
  verdict=unknown_debt_room
  echo "detail: $uncovered_rooms_unknown room(s) hold authored Rye the style law never reads and the debt-room list does not name --"
  sed 's/^/  /' "$WORK/unknown_rooms"
  echo "detail: put the room's Rye under a style-roster room, or add it to $DEBT_ROOMS and raise its ceiling with the reason."
fi
if [ "$debt_rooms" -gt "$DEBT_ROOM_CEILING" ]; then
  verdict=over_debt_room_ceiling
  echo "detail: the debt-room list names $debt_rooms rooms, past the ceiling of $DEBT_ROOM_CEILING -- a ceiling only falls."
fi
if [ "$unwatched_ban_hits" -gt "$BAN_CEILING" ]; then
  verdict=over_ban_ceiling
  echo "detail: $unwatched_ban_hits TAME ban hits stand in authored Rye the law never reads, past the ceiling of $BAN_CEILING --"
  sort -rn "$WORK/ban_counts" 2>/dev/null | awk -F'\t' '$1 > 0 {printf "  %s  %s\n", $1, $2}' | head -8
fi

echo "roster_rooms=$roster_rooms"
echo "phantom_rooms=$phantom_rooms"
echo "population=$population"
echo "covered=$covered"
echo "uncovered=$uncovered"
echo "uncovered_plant=$uncovered_plant"
echo "uncovered_authored=$uncovered_authored"
echo "uncovered_authored_gated=no"
echo "uncovered_rooms=$uncovered_rooms"
echo "uncovered_rooms_unknown=$uncovered_rooms_unknown"
echo "debt_rooms=$debt_rooms"
echo "debt_room_ceiling=$DEBT_ROOM_CEILING"
echo "unwatched_ban_files=$unwatched_ban_files"
echo "unwatched_ban_rooms=$unwatched_ban_rooms"
echo "unwatched_ban_hits=$unwatched_ban_hits"
echo "ban_ceiling=$BAN_CEILING"
echo "verdict=$verdict"

[ "$verdict" = "ok" ] || exit 1
exit 0
