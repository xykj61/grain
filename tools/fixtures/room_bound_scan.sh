#!/bin/sh
# tools/fixtures/room_bound_scan.sh -- how many dated files stand flat in each room.
#
# WHY. A room that grows without a bound eventually stops being readable. GitHub's web listing
# stops at 1,000 entries, and `session-logs/` held 1,492 flat files on `20260821` -- genuinely
# unopenable in a browser. The fold to `date/YYYYMMDD/` fixed that room; this scan is what keeps
# it fixed, and what notices the next room before it crosses.
#
# THE BOUND IS 256, not 1,000. A bound placed AT the cliff is a bound that fails on the day it
# matters, and two hundred fifty-six is already past what a person scrolls. It is a power of two,
# which is this tree's own idiom for a named maximum.
#
# ROOMS ARE DISCOVERED, NOT LISTED. Every top-level directory holding at least one dated file at
# its own level is reported, so a room created tomorrow cannot escape the meter by not being
# named here. The roster then decides what happens:
#
#   ENFORCE -- over the bound is a RED. A room earns this by FOLDING: once it has been carried
#              across, its references repointed and its resolver proven, letting it drift back
#              over the bound is a choice rather than an inheritance. Five rooms earned it that
#              way on `20260821` -- `session-logs` first, then `counsel`, `active-designing`,
#              `expanding-prompts`, and `waymarks` when the four folded together.
#              A room BORN under the law is enforced from birth instead, since it never
#              accumulated a backlog and so has nothing to grandfather: `active-development`
#              opened `20260821.174047` already bounded.
#   ADVISE  -- over the bound prints and books nothing. Every unfolded room starts here, because
#              a ratchet turns on touch and a sweep nobody asked for is not a fix. `external-
#              research` at 160 is the next one likely to cross, and it will be reported for a
#              while before anyone has to act.
#
# `foundations/` is deliberately small and the most-cited room in the tree; folding it would
# break the most references for the least relief. It stays flat and stays advisory.
#
# USAGE
#   sh tools/fixtures/room_bound_scan.sh          # the roster, at the seated bound
#   sh tools/fixtures/room_bound_scan.sh 2        # a smaller bound, for proving the RED path
#
# Driven by tools/r/room_bound_witness.rish. Run from the repository root.

set -eu

BOUND="${1:-256}"
ENFORCE="session-logs counsel active-designing active-development expanding-prompts waymarks"

# TWO KINDS OF ROOM, AND THEY ARE COUNTED DIFFERENTLY. Every room above folds by DAY, so a file
# that matters to its bound is a file carrying a one-clock stamp, and `count_flat` counts exactly
# those. `tools/` folds by FIRST SPRIG LETTER instead -- a tool is found by what it does rather
# than by when it was written -- and not one of its 1,917 entries carried a stamp. So the dated
# count read ZERO for that room for its whole life, which is precisely why it reached 7.4x the
# bound with every guard green: the meter could not see it.
#
# A room joins this list the same way a room joins the one above, by folding. `tools/` folded on
# `20260823.144100`; `glow/gen` folded by first sprig letter on `20260828` (REDS %301), once the
# compiler's two import-path sites learned the letter room.
ENFORCE_ALL="tools glow/gen"

echo "bound=$BOUND"

enforced_over=0
advised_over=0
seen=""

# A room is counted the same way everywhere: the whole one-clock stamp, matching what the fold
# moves and what the resolver can recover. A day-only name is neither, so it is not counted here.
count_flat() {
  find "$1" -maxdepth 1 -type f -name '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]*' 2>/dev/null | wc -l | tr -d ' '
}

# Every flat entry, files and symlinks alike, for a room that folds by letter rather than by day.
# Symlinks count because the fold moves them and a browser lists them.
count_flat_all() {
  find "$1" -maxdepth 1 -mindepth 1 \( -type f -o -type l \) 2>/dev/null | wc -l | tr -d ' '
}

for dir in */; do
  room="${dir%/}"
  case "$room" in .*|seed|vendor) continue ;; esac
  [ -d "$room" ] || continue

  flat=$(count_flat "$room")
  [ "$flat" -gt 0 ] || continue
  seen="$seen $room"

  roster=advise
  for e in $ENFORCE; do
    [ "$room" = "$e" ] && roster=enforce
  done

  if [ "$flat" -le "$BOUND" ]; then
    verdict=under
  else
    verdict=over
    if [ "$roster" = enforce ]; then
      enforced_over=$((enforced_over + 1))
    else
      advised_over=$((advised_over + 1))
    fi
  fi

  echo "room=$room flat=$flat verdict=$verdict roster=$roster"
done

# An ENFORCED room is ALWAYS reported, even at zero flat files. Discovery finds rooms that hold
# something; a room emptied by folding holds nothing and would silently drop off the meter, and a
# room that vanishes from a meter is not a room that passed it -- it is a room nobody is watching.
# `counsel` and `expanding-prompts` reached zero on the lap they folded and taught this.
for e in $ENFORCE; do
  case " $seen " in *" $e "*) continue ;; esac
  if [ -d "$e" ]; then
    echo "room=$e flat=$(count_flat "$e") verdict=under roster=enforce"
  else
    echo "room=$e flat=absent verdict=missing roster=enforce"
    enforced_over=$((enforced_over + 1))
  fi
done

# The letter-folded rooms, counted by every flat entry rather than by dated basenames. Always
# reported, for the same reason as above: a room that vanishes from a meter is not a room that
# passed it.
for e in $ENFORCE_ALL; do
  if [ -d "$e" ]; then
    flat=$(count_flat_all "$e")
    if [ "$flat" -le "$BOUND" ]; then
      verdict=under
    else
      verdict=over
      enforced_over=$((enforced_over + 1))
    fi
    echo "room=$e flat=$flat verdict=$verdict roster=enforce counts=all"
  else
    echo "room=$e flat=absent verdict=missing roster=enforce counts=all"
    enforced_over=$((enforced_over + 1))
  fi
done

# THE UNDATED SWEEP -- every tracked directory over the bound, whether or not anything dated it.
# Discovery above finds a room by its DATED files, so a room whose members are named for their
# subject rather than their day reads zero for its whole life and never appears at all. `tools/`
# reached 7.4x the bound that way and was caught by a hand; `glow/gen/` stood at 340 on
# `20260827` with every meter green, and was caught the same way. A reading that only sees rooms
# it already knows about cannot report the room nobody thought to name, so this pass asks git for
# every directory instead and reports the ones over. It is ADVISORY by design: a room over the
# bound has a real fold ahead of it, and some folds are not mechanical -- `glow/gen/` could not
# fold until `glow/glow_run.rye`'s two import-path sites learned the letter room, which they did
# on `20260828` (REDS %301), and the room now stands on the ENFORCE_ALL roster above. Reporting
# is the honest act; the cure belongs to the round that can pay for it.
#
# TWO SHAPES STAND OVER THE BOUND, AND ONLY ONE HAS A FOLD AHEAD OF IT. The mark law names
# exactly two fold shapes: a room found by WHEN folds to `<room>/date/YYYYMMDD/`, and a room found
# by WHAT folds to `<room>/<letter>/`. A DAY SHELF is already the output of the first, so there is
# no third shape left for it to move into. tools/d/dated_path_resolve.rish computes
# `<room>/date/<day>/<basename>` as a PURE FUNCTION of the basename, and a directory below the day
# would break it -- that function is the whole reason a stale reference is RESOLVED rather than
# rewritten across thousands of dated citations, so it is not a thing to spend on tidiness.
#
# So a day shelf over the bound prints as `terminal_shelf=` rather than as a room awaiting a fold.
# Reading the two alike told a lap there was mechanical work where the law provides none:
# `counsel/date/20260728` at 311 stood among REDS %301's five booked folds and is the one with
# nowhere to go (REDS %315). The live number for a shelf is GitHub's 1,000-entry listing cap, past
# which it stops being openable in a browser, so the headroom to that cap prints beside it.
#
# It GATES NOTHING, on purpose and twice over. 256 sits deliberately below the cliff, so gating a
# shelf at the cliff would be the very placement this file's own header argues against; and
# seating a shelf-specific bound -- or the hour fold that would answer it, `date/YYYYMMDD/HH/`,
# which is equally pure since the hour is characters 10 and 11 of the basename -- is a change to a
# seated law rather than a meter's to make. Reporting is the honest act.
LISTING_CAP=1000

undated_over=0
terminal_shelves=0
sweep="$(mktemp)"
trap 'rm -f "$sweep"' EXIT
git ls-files 2>/dev/null | awk -F/ 'NF>1 { d=$0; sub("/[^/]*$","",d); print d }' | sort | uniq -c > "$sweep"
while read -r n dir; do
  [ "$n" -gt "$BOUND" ] || continue
  case " $ENFORCE_ALL $ENFORCE " in *" $dir "*) continue ;; esac
  case "$dir" in vendor/*|gratitude/*|seed/*|rye/lib/*|.git/*) continue ;; esac
  case "$dir" in
    */date/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
      echo "terminal_shelf=$dir flat=$n verdict=over shape=day_fold_terminal cap_headroom=$((LISTING_CAP - n))"
      terminal_shelves=$((terminal_shelves + 1))
      ;;
    *)
      echo "undated_room=$dir flat=$n verdict=over roster=advise"
      undated_over=$((undated_over + 1))
      ;;
  esac
done < "$sweep"

echo "enforced_over=$enforced_over"
echo "advised_over=$advised_over"
echo "undated_over=$undated_over"
echo "terminal_shelves=$terminal_shelves"

if [ "$enforced_over" -eq 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=over"
  exit 1
fi
