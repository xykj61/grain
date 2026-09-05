#!/bin/sh
# tools/fixtures/w/waymark_rung_drift_scan.sh -- ascending rung marks in living files, under a
# ceiling that only falls.
#
# WHY. The mark law (.claude/rules/stamp-and-name.md, seated 20260821.160050) retired the
# ascending rung -- HAWM7, FORA31 -- as a mark for steps of work: a counter forecasts a length,
# whispers a dependency order a reader cannot check, sorts two ways, and reads alone as nothing.
# The law lived in the rules and two ladders numbered right past it for a week (REDS %329),
# because no meter read the mark shapes living files use. This is that meter.
#
# WHAT IT COUNTS. Occurrences of <SEATED-WAYMARK><digits> -- the seated draws and hand-seated
# names from .claude/rules/waymark-ladders.md -- in LIVING tracked files: a file whose own
# basename carries a one-clock stamp is testimony and is never read here, and the closed rooms
# that hold only testimony (session-logs, counsel, waymarks, bron-resins) are left whole.
# Dated marks keep every letter they wrote; this reads only what speaks as now.
#
# THE CEILING ONLY FALLS. The baseline is the drift standing on the day the meter was seated --
# 17,378 measured 20260828.202405 on a checkout carrying a peer's staged pages -- the constel
# sweep removed about 136 and the committed tree's stable reading landed at 17,248, which is
# the seated ceiling; a baseline is taken on a committed tree, never a moving checkout, and honesty about that number: it includes CITATIONS of
# files whose own basenames carry a mark (the 20260814-fill-ales<N> design docs), which are
# true references to real files and fall only when those files molt at their own pace. The
# ceiling holds the whole anyway, because a new numbered rung and a new citation of an old one
# are the same keystroke, and the law wants the stamp-and-name written instead in both cases.
# Every sweep that lowers the count lowers the ceiling with it; a rise reds the witness on the
# lap it arrives.
#
# IT FIRED ON ITS FIRST HEARING, 20260828, and one of the two marks it caught was this law's own.
# The reading stood at 17,249. A `ZETA`-plus-digit mark had entered a living Rye doc comment in
# the macOS grid probe that landed that evening; a `FORA`-plus-digit mark stood inside
# construction/ITINERARY.md's Standing block, in the very sentence teaching that counters are
# retired. The mark law's own clause on illustration answers the second: an example in prose is a
# SHAPE, so the card reads the mark with an `<N>` placeholder now and the sentence stopped being an
# instance of what it forbids. The door row naming that granted door keeps its number, because it
# names a booked thing rather than illustrating a form.
#
# AND THE HEADER YOU ARE READING PAID THE SAME TOLL. The first draft of this paragraph spelled
# both marks in their counter form, the meter read its own explanation, and the count went back up
# by two. A scan is a living tracked file, so a guard that names what it caught in the shape it
# refuses raises its own reading -- which is the law being exactly as literal as it promised.
# Placeholders here, for the same reason the card uses them.
#
# A SYMLINKED SOURCE IS COUNTED ONCE PER TRACKED PATH, and that is most of this number.
# `git ls-files` lists a symlink and its target as two paths, and grep follows the link, so one
# mark in one file is read twice. It showed up small first: the Rye doc comment above stood at
# brushstroke/skate_grid.rye with tools/rye/skate_grid.rye pointing at it, and repairing that one
# line lowered the reading by two. Then it showed up large. This tree tracks 270 symlinks, and a
# peer's rewrite added 23 of them under brushstroke/ in one evening, each doubling its target's
# marks -- which is the whole of a rise from 17,247 to 17,257 that no new line of prose caused.
# Reading only the 6,222 non-symlink tracked paths gives 17,046, so about 200 of this count is one
# file read twice. De-duplicating is the honest instrument and it is its own lap, because the
# ceiling would move by 211 and every rise since seating would want re-attributing.
#
# THE CEILING IS RE-BASELINED, NOT RAISED, ON 20260829. The 17,248 pin and the 17,245 this lap
# repaired to were both measured on a checkout whose history was rewritten out from under it that
# night; a ceiling is only a ceiling against the tree it was read on. 17,257 is the reading on the
# anointed order, with the two repairs above still in it, and the whole of the difference is
# attributed to the symlink count rather than left as drift. It falls from here.
# The recovered CION map candidate reads 17,247 before moving a citation: 17,246 from its first
# reading plus one sibling-owned WADE<N> mark that landed while the candidate waited. The committed
# ceiling still falls 17,257 -> 17,247, and the sibling mark is routed on ITINERARY rather than
# hidden by raising the old candidate's reading.
#
# RUNG_ROOT, RUNG_CEILING, and RUNG_FILE_LIST are the witness's pen knobs -- a control proves
# both sides on planted tracked-path input; none is an override word for the live tree.

set -eu

ROOT="${RUNG_ROOT:-.}"
CEILING="${RUNG_CEILING:-17212}"

marks='HAWM|TUBE|ZETA|JABS|LULU|STOA|SETU|SUNN|POLE|SOON|JARL|BUHR|TACT|GISM|AYRE|DAHL|KOFF|CION|VOLS|LOWE|OFFY|GRAD|AHOY|WADE|HUNK|DREY|FORA|ALES|DISC|SEVA|MAND|MONA'

mkdir -p .mind-state/tmp
state_tmp=$(CDPATH= cd .mind-state/tmp && pwd)
files=$(mktemp "$state_tmp/rung-drift-files.XXXXXX"); trap 'rm -f "$files"' EXIT
if [ -n "${RUNG_FILE_LIST:-}" ]; then
  [ -f "$RUNG_FILE_LIST" ] || { echo "verdict=file_list_absent"; exit 1; }
  grep -qE '(^/|(^|/)\.\.(/|$))' "$RUNG_FILE_LIST" \
    && { echo "verdict=file_list_escapes"; exit 1; }
  cp "$RUNG_FILE_LIST" "$files"
else
  # A FOLDED LEDGER SHELF IS TESTIMONY THE STAMP TEST CANNOT SEE. The line above reads a file as
  # testimony when its BASENAME carries a one-clock stamp, which is the tree's own rule -- and REDS
  # fold shelves are named by row range instead, `REDS-<sprig>-rows-N-M.md`, so a shelf headed
  # *Archived, complete, never edited* was being counted as living prose. A row citing five retired
  # announcements as its evidence then read as sixteen fresh rung marks, and folding a shelf reddened
  # this guard on the lap it landed. The glob is the same one the monotone witness uses to DISCOVER
  # shelves, so both readers agree on what a shelf is.
  ( cd "$ROOT" && git ls-files 2>/dev/null ) \
    | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' \
    | grep -vE '^(session-logs|counsel|waymarks|bron-resins|vendor|gratitude|seed)/' \
    | grep -vE '^construction/archive/REDS-.*rows-.*\.md$' \
    > "$files" || : > "$files"
fi

# NUL-delimited into grep: a bare xargs splits on spaces inside tracked filenames, and the
# count then drifts by whatever a half-name happens to reach -- measured +/-6 between two
# checkouts of one identical tree on the day this meter landed.
count=0
if [ -s "$files" ]; then
  # Keep command substitution and its inner subshell visibly separate. The ambiguous `$((` form
  # ran as Bash and as arithmetic under different shells, where the latter reported a false zero.
  count=$( ( cd "$ROOT" && tr '\n' '\0' < "$files" | xargs -0 grep -ahoE "(^|[^A-Za-z])($marks)[0-9]+" ) 2>/dev/null | grep -c . || true )
fi

echo "rung_marks_living=$count"
echo "rung_ceiling=$CEILING"
if [ "$count" -gt "$CEILING" ]; then
  echo "verdict=rung_drift"
  echo "detail: a numbered rung mark entered living prose past the ceiling -- mark by waymark, stamp, and plain name instead (.claude/rules/stamp-and-name.md)"
  exit 1
fi
echo "verdict=ok"
