#!/bin/sh
# Living-card ASCII guard (REDS %83) -- the operator card stays plain 7-bit ASCII.
#
# The operator card corrupted itself once: construction/ITINERARY.md silently triple-encoded
# into 2,797 runs of capital-A-tilde mojibake before anyone caught it (REDS %83),
# because a tool read the UTF-8 file as Latin-1 and rewrote it, and each later edit
# re-encoded the mangled bytes another layer. This guard catches the NEXT mojibake on
# the lap it enters, not months later -- measurement beats memory.
#
# A THIRD READING joined on 20260824.130807 (REDS %198): every tracked text file must be a valid
# UTF-8 byte sequence. Four tracked specs carried a lone orphan lead byte left by an earlier ASCII
# sweep -- corruption a reader could not see and ugrep read as binary silence, while GNU grep read
# it fine. Gated at zero, on the byte sequence rather than on any one tool's verdict about it.
#
# Two rosters, by the ASCII-first tier (.claude/rules/ascii-first.md):
#   ENFORCE  -- pins actively written ASCII-first; ANY byte above 0x7F fails hard.
#   ADVISORY -- pins still carrying legacy dated non-ASCII that ASCII-first does not
#               retrofit; their line counts are REPORTED as a ratchet (sweep on touch),
#               never a hard fail, so a dated artifact is never force-rewritten.
#
# This is a DISTINCT roof from the e123 living-pin content guard (which watches empty
# and bound); byte-encoding is its own concern, so a second witness is correct here,
# not a duplicate of one name (the e123 "two roofs" law guards its own subject only).
#
#   sh tools/fixtures/living_card_ascii_scan.sh
#   sh tools/fixtures/living_card_ascii_scan.sh prove-red
#
# No backtick characters. No git history walks. Plain 7-bit ASCII throughout.
set -eu

MODE=${1:-}

# ENFORCE roster -- pins swept ASCII-first; zero bytes above 0x7F allowed.
ENFORCE="construction/ITINERARY.md construction/REDS.md"
# ADVISORY roster -- legacy dated non-ASCII reported as a ratchet, never a hard fail.
ADVISORY="construction/ROADMAP.md construction/TASKS.md construction/EQUINOX_SEAT_MAP.md construction/SHRED_PREP.md construction/THREADS.md construction/CHECKPOINTS.md"
CONTROL=tools/fixtures/living_card_ascii_control/mojibake_control.md
TMPLIST=$(mktemp "${TMPDIR:-/tmp}/ascii-list.XXXXXX")
trap 'rm -f "$TMPLIST"' EXIT INT TERM

# Count lines carrying any byte above 0x7F. grep -c exits 1 on zero matches, so guard it.
# The -a costs nothing and makes the read tool-independent. GNU grep 3.12, which every script here
# runs, classifies a file binary only on a NUL byte and reads an orphan UTF-8 lead byte fine; ugrep,
# which a hand at this bench runs interactively, classifies it binary and returns nothing with
# exit 1 -- which reads exactly like a clean file. Measured 20260824.130807, both ways.
count_non_ascii() {
  LC_ALL=C grep -a -c -P '[^\x00-\x7F]' "$1" 2>/dev/null || true
}

# Is the file a valid UTF-8 byte sequence? This measures the DEFECT rather than any one tool's
# reaction to it. An orphan lead byte is corruption whichever grep is installed, and a gate written
# against a tool would move when the tool moved. An empty file holds no sequence to be invalid.
utf8_valid() {
  test -s "$1" || return 0
  iconv -f UTF-8 -t UTF-8 "$1" >/dev/null 2>&1
}

if test "$MODE" = "prove-red"; then
  # The control MUST carry non-ASCII, and the enforce rule MUST catch it.
  if ! git ls-files --error-unmatch "$CONTROL" >/dev/null 2>&1; then
    echo "detail=RED_control_untracked"
    echo "verdict=misread"
    exit 1
  fi
  CHITS=$(count_non_ascii "$CONTROL")
  if test "$CHITS" -lt 1; then
    echo "detail=RED_control_is_pure_ascii"
    echo "verdict=misread"
    exit 1
  fi
  echo "control_non_ascii_lines=$CHITS"
  echo "detail=RED_living_card_non_ascii_caught"
  echo "verdict=misread"
  exit 1
fi

# ENFORCE: any byte above 0x7F is a red, caught on the lap it enters.
for p in $ENFORCE; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "enforce=failed"
    echo "detail=pin_untracked"
    echo "detail_path=$p"
    echo "verdict=misread"
    exit 1
  }
  HITS=$(count_non_ascii "$p")
  if test "$HITS" -ne 0; then
    echo "enforce=failed"
    echo "detail=non_ascii_in_enforced_pin"
    echo "detail_path=$p"
    echo "detail_lines=$HITS"
    echo "verdict=misread"
    exit 1
  fi
  echo "enforce_ok=$p"
done
echo "enforce=honored"

# ADVISORY: report the legacy count as a ratchet; a rise is debt, never a break.
ADV_TOTAL=0
for p in $ADVISORY; do
  if ! test -f "$p"; then
    echo "advisory_absent=$p"
    continue
  fi
  HITS=$(count_non_ascii "$p")
  echo "advisory_non_ascii_lines=$p=$HITS"
  ADV_TOTAL=$((ADV_TOTAL + HITS))
done
echo "advisory_total_non_ascii_lines=$ADV_TOTAL"
echo "advisory=ratchet_report"

# The control fixture must stay non-ASCII, or prove-red would silently stop proving.
CHITS=$(count_non_ascii "$CONTROL")
if test "$CHITS" -lt 1; then
  echo "control_kept=failed"
  echo "detail=control_went_pure_ascii"
  echo "verdict=misread"
  exit 1
fi
echo "control_kept=honored"
echo "control_non_ascii_lines=$CHITS"

# --- every tracked text file is a valid UTF-8 byte sequence (REDS %198) ---
#
# On 20260824.130807 four tracked text files carried a lone 0xC2 -- a middot whose continuation
# byte an earlier ASCII sweep replaced with '-', leaving the lead byte orphaned. Two were living
# specs, one of them context/specs/append-only-growth-law.md, the growth law the room folds rest
# on, and another the spec that seats living_pin_max_bytes.
#
# What it cost, measured rather than assumed: GNU grep 3.12, which every script in this tree runs,
# reads those files correctly, so no guard was blinded. ugrep, which a hand at this bench runs
# interactively, classifies them binary and returns nothing with exit 1 -- so a person searching
# the tree found silence where the text was. The corruption is real either way and repairing it is
# a fix rather than a style rewrite (.claude/rules/ascii-first.md), which is why this gates on the
# byte sequence rather than on any one tool's verdict about it.
#
# The instrument proves itself both ways first, on files planted in a throwaway pen, because a
# probe that can only pass cannot be told apart from a probe that reads nothing.
PEN=$(mktemp -d "${TMPDIR:-/tmp}/ascii-utf8.XXXXXX")
printf 'a clean line\n' > "$PEN/clean.md"
printf 'a line with an orphan lead byte \302- here\n' > "$PEN/orphan.md"
if ! utf8_valid "$PEN/clean.md"; then
  rm -rf "$PEN"
  echo "instrument=failed"
  echo "detail=probe_refuses_a_clean_file"
  echo "verdict=misread"
  exit 1
fi
if utf8_valid "$PEN/orphan.md"; then
  rm -rf "$PEN"
  echo "instrument=failed"
  echo "detail=probe_accepts_an_orphan_lead_byte"
  echo "verdict=misread"
  exit 1
fi
rm -rf "$PEN"
echo "utf8_probe=proven_both_ways"

INVALID=0
SCANNED=0
INVALID_LIST=""
git ls-files -- '*.md' '*.rish' '*.rye' '*.sh' '*.kyri' '*.bron' '*.brix' '*.txt' > "$TMPLIST"
while IFS= read -r f; do
  test -f "$f" || continue
  SCANNED=$((SCANNED + 1))
  if ! utf8_valid "$f"; then
    INVALID=$((INVALID + 1))
    INVALID_LIST="$INVALID_LIST $f"
  fi
done < "$TMPLIST"
rm -f "$TMPLIST"
echo "text_files_scanned=$SCANNED"
echo "text_files_invalid_utf8=$INVALID"
if test "$INVALID" -ne 0; then
  for u in $INVALID_LIST; do
    echo "detail=invalid_utf8_byte_sequence"
    echo "detail_path=$u"
  done
  echo "utf8=failed"
  echo "verdict=misread"
  exit 1
fi
echo "utf8=honored"

echo "story=operator_card_pure_ascii>legacy_pins_ratcheted>mojibake_control_caught>every_text_file_valid_utf8"
echo "verdict=ok"
