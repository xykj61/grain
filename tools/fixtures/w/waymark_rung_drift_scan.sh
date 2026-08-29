#!/bin/sh
# tools/fixtures/waymark_rung_drift_scan.sh -- ascending rung marks in living files, under a
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
# A SYMLINKED SOURCE IS COUNTED ONCE PER TRACKED PATH. `git ls-files` lists a symlink and its
# target as two paths, and grep follows the link, so one mark in one file can be read twice: the
# Rye doc comment above stood at brushstroke/skate_grid.rye with tools/rye/skate_grid.rye pointing
# at it, and repairing the one line lowered this reading by two. That inflates the count and can
# never hide a mark, which is the safe direction for a ratchet, so it is written down here rather
# than repaired -- de-duplicating by content would move the ceiling by an amount nobody has
# measured, and that is its own lap.
#
# RUNG_ROOT and RUNG_CEILING are the witness's pen knobs -- a control proves both sides on a
# planted repository; neither is an override word for the live tree.

set -eu

ROOT="${RUNG_ROOT:-.}"
CEILING="${RUNG_CEILING:-17245}"

marks='HAWM|TUBE|ZETA|JABS|LULU|STOA|SETU|SUNN|POLE|SOON|JARL|BUHR|TACT|GISM|AYRE|DAHL|KOFF|CION|VOLS|LOWE|OFFY|GRAD|AHOY|WADE|HUNK|DREY|FORA|ALES|DISC|SEVA|MAND|MONA'

files=$(mktemp); trap 'rm -f "$files"' EXIT
( cd "$ROOT" && git ls-files 2>/dev/null ) \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' \
  | grep -vE '^(session-logs|counsel|waymarks|bron-resins|vendor|gratitude|seed)/' \
  > "$files" || : > "$files"

# NUL-delimited into grep: a bare xargs splits on spaces inside tracked filenames, and the
# count then drifts by whatever a half-name happens to reach -- measured +/-6 between two
# checkouts of one identical tree on the day this meter landed.
count=0
if [ -s "$files" ]; then
  count=$(( cd "$ROOT" && tr '\n' '\0' < "$files" | xargs -0 grep -ahoE "(^|[^A-Za-z])($marks)[0-9]+" ) 2>/dev/null | grep -c . || true)
fi

echo "rung_marks_living=$count"
echo "rung_ceiling=$CEILING"
if [ "$count" -gt "$CEILING" ]; then
  echo "verdict=rung_drift"
  echo "detail: a numbered rung mark entered living prose past the ceiling -- mark by waymark, stamp, and plain name instead (.claude/rules/stamp-and-name.md)"
  exit 1
fi
echo "verdict=ok"
