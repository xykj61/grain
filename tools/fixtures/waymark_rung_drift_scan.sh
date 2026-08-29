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
# 17,378 measured 20260828.202405, lowered to 17242 by the first sweep the same day, and honesty about that number: it includes CITATIONS of
# files whose own basenames carry a mark (the 20260814-fill-ales<N> design docs), which are
# true references to real files and fall only when those files molt at their own pace. The
# ceiling holds the whole anyway, because a new numbered rung and a new citation of an old one
# are the same keystroke, and the law wants the stamp-and-name written instead in both cases.
# Every sweep that lowers the count lowers the ceiling with it; a rise reds the witness on the
# lap it arrives.
#
# RUNG_ROOT and RUNG_CEILING are the witness's pen knobs -- a control proves both sides on a
# planted repository; neither is an override word for the live tree.

set -eu

ROOT="${RUNG_ROOT:-.}"
CEILING="${RUNG_CEILING:-17242}"

marks='HAWM|TUBE|ZETA|JABS|LULU|STOA|SETU|SUNN|POLE|SOON|JARL|BUHR|TACT|GISM|AYRE|DAHL|KOFF|CION|VOLS|LOWE|OFFY|GRAD|AHOY|WADE|HUNK|DREY|FORA|ALES|DISC|SEVA|MAND|MONA'

files=$(mktemp); trap 'rm -f "$files"' EXIT
( cd "$ROOT" && git ls-files 2>/dev/null ) \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' \
  | grep -vE '^(session-logs|counsel|waymarks|bron-resins|vendor|gratitude|seed)/' \
  > "$files" || : > "$files"

count=0
if [ -s "$files" ]; then
  count=$(( cd "$ROOT" && xargs grep -ahoE "(^|[^A-Za-z])($marks)[0-9]+" < "$files" ) 2>/dev/null | grep -c . || true)
fi

echo "rung_marks_living=$count"
echo "rung_ceiling=$CEILING"
if [ "$count" -gt "$CEILING" ]; then
  echo "verdict=rung_drift"
  echo "detail: a numbered rung mark entered living prose past the ceiling -- mark by waymark, stamp, and plain name instead (.claude/rules/stamp-and-name.md)"
  exit 1
fi
echo "verdict=ok"
