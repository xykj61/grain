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
#   sh tools/fixtures/l/living_card_ascii_scan.sh
#   sh tools/fixtures/l/living_card_ascii_scan.sh prove-red
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
# FOUND FROM THIS SCRIPT, NOT FROM THE WORKING DIRECTORY. A `$(pwd)` here resolves wherever the
# caller happens to stand, and the sibling scan repaired in the same hour proved what that costs:
# run by absolute path from inside a throwaway pen, it could not find its helper, and because it
# also discarded awk's complaint it reported a perfectly clean tree. This one is not penned today
# and would have passed either way, which is exactly why it is worth fixing before it is.
# THE HELPER LIVES IN ITS OWN LETTER ROOM, so it is resolved through the tree root rather than
# as a sibling (`20260906`). `tools/` folds by first sprig letter, and `utf8_valid.awk` moved to
# `tools/fixtures/u/` where its basename says it belongs -- at which point a `dirname $0` sibling
# lookup could no longer find it, and this scan reported `utf8_helper_missing`. Resolving from
# the root keeps both laws: the helper sits in its named room, and the caller finds it from
# wherever it is run.
_lca_here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
_lca_root=$(CDPATH= cd -- "$_lca_here/../../.." && pwd)
UTF8_AWK="$_lca_root/tools/fixtures/u/utf8_valid.awk"
[ -f "$UTF8_AWK" ] || {
  echo "instrument=failed"
  echo "detail=utf8_helper_missing"
  echo "detail_path=$UTF8_AWK"
  echo "verdict=misread"
  exit 1
}
trap 'rm -f "$TMPLIST"' EXIT INT TERM

# THE BYTE RANGE IS SPELLED IN THE C LOCALE, not in PCRE. `grep -P` is a GNU extension and BSD
# grep, which is what macOS ships, refuses it -- so a card checked on that pier would be checked
# by nothing. Under `LC_ALL=C` a bracket range is plain byte order, and `[\200-\377]` names bytes
# 0x80 through 0xFF exactly as `[^\x00-\x7F]` did. Built by `printf` because a literal high byte in
# a source file is the very thing this guard exists to catch. Proven equal on this pier
# `20260826.090745` across the enforce roster, the advisory roster, and the mojibake control.
_lca_high_byte=$(printf '[\200-\377]')

# Count lines carrying any byte above 0x7F. grep -c exits 1 on zero matches, so guard it.
# The -a costs nothing and makes the read tool-independent. GNU grep 3.12, which every script here
# runs, classifies a file binary only on a NUL byte and reads an orphan UTF-8 lead byte fine; ugrep,
# which a hand at this bench runs interactively, classifies it binary and returns nothing with
# exit 1 -- which reads exactly like a clean file. Measured 20260824.130807, both ways.
count_non_ascii() {
  LC_ALL=C grep -a -c "$_lca_high_byte" "$1" 2>/dev/null || true
}

# Is the file a valid UTF-8 byte sequence? This measures the DEFECT rather than any one tool's
# reaction to it. An orphan lead byte is corruption whichever grep is installed, and a gate written
# against a tool would move when the tool moved. An empty file holds no sequence to be invalid.
utf8_valid() {
  test -s "$1" || return 0
  # The conversion lands in a regular file rather than /dev/null: Apple's iconv reports a
  # spurious "Inappropriate ioctl for device" and exits 1 when its output is a device or a
  # pipe on some valid multibyte inputs, so the exit code would measure the destination
  # rather than the bytes. A regular file reads the same on both dialects, and an orphan
  # lead byte still refuses through it -- proven both ways on metal (REDS %275).
  _uv_tmp=$(mktemp "${TMPDIR:-/tmp}/utf8v.XXXXXX") || return 1
  iconv -f UTF-8 -t UTF-8 "$1" > "$_uv_tmp" 2>/dev/null
  _uv_rc=$?
  rm -f "$_uv_tmp"
  return $_uv_rc
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
# probe that can only pass cannot be told apart from a probe that reads nothing. Five shapes now
# rather than two: the clean file and the orphan lead byte the elder probe planted, plus a valid
# multibyte file (which a too-eager validator would refuse), a bare continuation byte, and an
# overlong lead. A validator proven only against ASCII would pass every one of the last three.
PEN=$(mktemp -d "${TMPDIR:-/tmp}/ascii-utf8.XXXXXX")
printf 'a clean line\n' > "$PEN/clean.md"
printf 'an orphan lead byte \302- here\n' > "$PEN/orphan.md"
printf 'valid multibyte \303\251 and \344\270\255 here\n' > "$PEN/multibyte.md"
printf 'a bare continuation \277 here\n' > "$PEN/bare.md"
printf 'an overlong lead \300\257 here\n' > "$PEN/overlong.md"
PEN_BAD=$(cd "$PEN" && LC_ALL=C awk -f "$UTF8_AWK" \
  clean.md orphan.md multibyte.md bare.md overlong.md | sort | tr '\n' ' ')
rm -rf "$PEN"
if test "$PEN_BAD" != "bare.md orphan.md overlong.md "; then
  echo "instrument=failed"
  echo "detail=utf8_probe_read_the_pen_wrong"
  echo "detail_pen_verdict=$PEN_BAD"
  echo "verdict=misread"
  exit 1
fi
echo "utf8_probe=proven_both_ways"

# ONE AWK PROCESS FOR THE WHOLE COLLECTION (REDS %412). The elder loop forked mktemp, iconv and rm per
# file across 14,709 tracked text files -- about 44,000 processes for a reading the bytes make
# cheap. NUL-delimited, because `git ls-files` will happily hand back a path with a space in it and
# this tree holds several; a whitespace-split list drops them silently, which is the reading a
# guard can least afford.
# A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO. Captured to a file with the exit status
# checked, because an empty answer from a failed awk is byte-identical to an empty answer from a
# clean collection -- and the second is the reading everyone wants to hear.
if ! git ls-files -z -- '*.md' '*.rish' '*.rye' '*.sh' '*.kyri' '*.bron' '*.brix' '*.txt' \
  | LC_ALL=C xargs -0 awk -f "$UTF8_AWK" > "$TMPLIST.bad" 2>"$TMPLIST.err"; then
  echo "instrument=failed"
  echo "detail=utf8_pass_refused"
  sed -n '1,5p' "$TMPLIST.err" | sed 's/^/detail_awk=/'
  echo "verdict=misread"
  rm -f "$TMPLIST.bad" "$TMPLIST.err"
  exit 1
fi
INVALID_LIST=$(cat "$TMPLIST.bad")
rm -f "$TMPLIST.bad" "$TMPLIST.err"
SCANNED=$(git ls-files -- '*.md' '*.rish' '*.rye' '*.sh' '*.kyri' '*.bron' '*.brix' '*.txt' | grep -c .)
INVALID=$(printf '%s' "$INVALID_LIST" | grep -c . || true)
echo "text_files_scanned=$SCANNED"
echo "text_files_invalid_utf8=$INVALID"
if test "$INVALID" -ne 0; then
  printf '%s\n' "$INVALID_LIST" | while IFS= read -r u; do
    test -n "$u" || continue
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
