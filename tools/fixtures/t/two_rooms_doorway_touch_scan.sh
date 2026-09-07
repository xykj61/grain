#!/bin/sh
# tools/fixtures/t/two_rooms_doorway_touch_scan.sh -- a round that adds a page proves it names its room.
#
# WHAT THIS IS FOR. `context/TWO_ROOMS.md` seats one line of discipline: a forward-facing page
# names its register in its own `**Status:**` line, in one of four tokens the canon spells --
# checkable, vision, mixed, research for understanding -- so no reader has to guess which room
# they stand in. The canon settled the neighbouring question on `20260907.015907`: `proposed`
# answers how far along a claim is and leaves the register open, so a Status naming only
# `proposed` names no room, exactly as one naming only `design` already did.
#
# WHY IT READS AT COMMIT TIME. The whole reading already existed and it was too slow to teach the
# habit. `two_rooms_doorway` walks 978 pages, costs a full minute, and stands at `tier cadence` --
# so it speaks on the fifth round, hours after the page was written, to a hand who has moved on.
# On `20260907` FOUR pages landed in one day whose Status named `proposed` and no room, three of
# them AFTER the canon and the room's own front door both taught the token that morning. The
# ratchet went from 44 to 48 in a day and a hand swept it back by reading four sentences that were
# already there. The repair rate matched the writing rate exactly, which is the definition of a
# lantern rather than a loom. This is the loom: the same question, asked while the page is still
# free to fix.
#
# WHAT IS GATED, hard, at zero: a page this commit ADDS to the doorway roster whose Status names
# no room. A brand-new page has no accreted testimony to protect and exactly one person who knows
# its register -- the hand writing it, in this commit. So the ratchet can no longer RISE, which is
# the property the elder ceiling could only ever measure after the fact.
#
# WHAT IS REPORTED AND NEVER GATED: a page this commit MODIFIES that names no room. Forty-four
# such pages stand, three of them dated testimony on `date/` shelves that accrete-never-break
# keeps exactly as written. Gating them would refuse an unrelated commit for touching an elder
# page, and a wall that reds on ordinary work is a wall somebody turns off. Their ceiling stays
# with the cadence guard, where it falls as they are repaired.
#
# NOTHING HERE IS RESPELLED. The rooms and their exclusions come from
# two_rooms_doorway_roster.sh; the per-page verdict from two_rooms_doorway_scan_one.sh; the
# seating stamp is read out of two_rooms_doorway_scan.rish, the one file that holds it. A rule
# written in two files is a rule two files may quietly come to disagree about (REDS %382), and a
# scan that cannot find its seating refuses rather than inventing one.
#
#   sh tools/fixtures/t/two_rooms_doorway_touch_scan.sh            # what this commit ships
#   sh tools/fixtures/t/two_rooms_doorway_touch_scan.sh head       # what HEAD shipped
#   sh tools/fixtures/t/two_rooms_doorway_touch_scan.sh prove-red  # the planted refusal
#
# WHAT IT READS, and why off the index rather than off disk. `git cat-file -p :<path>` is the page
# this commit will actually carry. A round that stages a repaired Status and then edits the file
# again would otherwise read green off a worktree the commit does not hold.
#
# WHAT IS NOT PROVEN. That a page naming `checkable` belongs in the checkable room. The token is
# read; the judgment behind it stays a reader's -- the same limit the cadence guard names.
#
# Gated by tools/t/two_rooms_doorway_touch_witness.rish; proven both ways by
# tools/fixtures/t/two_rooms_doorway_touch_control.sh on real git repositories in a throwaway pen.
set -u

MODE=staged
# A collection names its maximum (TAME). The widest single commit in this tree's history moved
# 2,163 files; 4,096 is the next power of two above it and far below a runaway read.
MAX_PAGES=4096

while [ $# -gt 0 ]; do
  case "$1" in
    staged|head|prove-red) MODE=$1 ;;
    *) echo "detail=RED_unknown_argument"; echo "detail_argument=$1"; echo "verdict=misread"; exit 1 ;;
  esac
  shift
done

echo "mode=$MODE"

if [ "$MODE" = prove-red ]; then
  # The planted refusal, so the RED path is exercised without waiting for a real page to carry the
  # fault. The SHAPE is spelled here; the LAW lives in scan_one.sh and in the canon it reads.
  echo "doorway_added_unnamed=external-research/YYYYMMDD-HHMMSS_a-page-that-names-no-room.md"
  echo "detail=RED_added_page_names_no_room"
  echo "detail_page=external-research/YYYYMMDD-HHMMSS_a-page-that-names-no-room.md"
  echo "detail_status=**Status:** Proposed -- external research"
  echo "detail_repair=name one of: checkable, vision, mixed, research for understanding"
  echo "added_unnamed=1"
  echo "verdict=misread"
  exit 1
fi

# The seating stamp, read from the one file that holds it. A scan that cannot find it refuses:
# guessing would silently grandfather every page in the tree.
SEATING=$(sed -n 's/^let seating = "\([0-9]\{8\}-[0-9]\{6\}\)".*/\1/p' \
  tools/fixtures/t/two_rooms_doorway_scan.rish 2>/dev/null | head -1)
if [ -z "$SEATING" ]; then
  echo "detail=RED_seating_stamp_unreadable"
  echo "detail_source=tools/fixtures/t/two_rooms_doorway_scan.rish"
  echo "verdict=misread"
  exit 1
fi
echo "seating=$SEATING"

# The doorway's own subject: three rooms, README and yonder and archive left out, every depth
# reached. Read from the roster rather than respelled, so a room added there is read here.
ROSTER=$(sh tools/fixtures/t/two_rooms_doorway_roster.sh 2>/dev/null || true)
if [ -z "$ROSTER" ]; then
  echo "detail=RED_roster_empty"
  echo "verdict=misread"
  exit 1
fi

case "$MODE" in
  staged)
    ADDED=$(git diff --cached --name-only --diff-filter=A 2>/dev/null || true)
    CHANGED=$(git diff --cached --name-only --diff-filter=M 2>/dev/null || true) ;;
  head)
    ADDED=$(git diff-tree --no-commit-id --name-only -r --diff-filter=A HEAD 2>/dev/null || true)
    CHANGED=$(git diff-tree --no-commit-id --name-only -r --diff-filter=M HEAD 2>/dev/null || true) ;;
esac

# Read the page out of the store the mode names, into a pen whose file keeps the page's own
# BASENAME -- the per-page verdict reads the stamp off that basename. The pen is made by mktemp
# rather than given a constant name under /tmp: eight ships share this pier, and a fixed name is a
# collision the tree cannot see (REDS %512, %541).
PEN=$(mktemp -d 2>/dev/null) || {
  echo "detail=RED_pen_unavailable"; echo "verdict=misread"; exit 1
}
trap 'rm -rf "$PEN"' EXIT INT TERM HUP

body_of() {
  case "$MODE" in
    staged) git cat-file -p ":$1" 2>/dev/null ;;
    head)   git cat-file -p "HEAD:$1" 2>/dev/null ;;
  esac
}

# Is this path one the doorway speaks for? Matched whole-line against the roster, so a room's
# exclusions travel here without being written twice.
in_roster() {
  printf '%s\n' "$ROSTER" | grep -Fxq "$1"
}

verdict_of() {
  _v_path=$1
  _v_base=$(basename "$_v_path")
  body_of "$_v_path" > "$PEN/$_v_base" 2>/dev/null || return 2
  sh tools/fixtures/t/two_rooms_doorway_scan_one.sh "$PEN/$_v_base" "$SEATING" 2>&1
  _v_code=$?
  rm -f "$PEN/$_v_base"
  return $_v_code
}

PAGES=0
ADDED_READ=0
ADDED_UNNAMED=0
CHANGED_UNNAMED=0
REPORT=""

for page in $ADDED; do
  in_roster "$page" || continue
  PAGES=$((PAGES + 1))
  if [ "$PAGES" -gt "$MAX_PAGES" ]; then
    echo "detail=RED_pages_past_bound"; echo "detail_max=$MAX_PAGES"; echo "verdict=misread"; exit 1
  fi
  ADDED_READ=$((ADDED_READ + 1))
  if line=$(verdict_of "$page"); then
    continue
  fi
  # The verdict's own words, with the pen path swapped back for the page's real one -- a reader
  # repairs the file they wrote, never a temporary this scan made.
  said=$(printf '%s' "$line" | sed "s|$PEN/[^ ]*|$page|")
  ADDED_UNNAMED=$((ADDED_UNNAMED + 1))
  REPORT="$REPORT
doorway_added_unnamed=$page
detail=RED_added_page_names_no_room
detail_page=$page
detail_said=${said#FAIL }
detail_repair=name one of: checkable, vision, mixed, research for understanding"
done

for page in $CHANGED; do
  in_roster "$page" || continue
  PAGES=$((PAGES + 1))
  if [ "$PAGES" -gt "$MAX_PAGES" ]; then
    echo "detail=RED_pages_past_bound"; echo "detail_max=$MAX_PAGES"; echo "verdict=misread"; exit 1
  fi
  if line=$(verdict_of "$page"); then
    continue
  fi
  said=$(printf '%s' "$line" | sed "s|$PEN/[^ ]*|$page|")
  CHANGED_UNNAMED=$((CHANGED_UNNAMED + 1))
  REPORT="$REPORT
doorway_changed_unnamed=${said#FAIL }"
done

printf '%s\n' "$REPORT" | sed '/^$/d'
echo "added_read=$ADDED_READ"
echo "added_unnamed=$ADDED_UNNAMED"
echo "changed_unnamed_reported=$CHANGED_UNNAMED"

if [ "$ADDED_UNNAMED" -gt 0 ]; then
  echo "verdict=misread"
  exit 1
fi

echo "story=a_page_this_round_adds_says_its_room"
echo "verdict=ok"
