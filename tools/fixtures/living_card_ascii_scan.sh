#!/bin/sh
# Living-card ASCII guard (REDS %83) -- the operator card stays plain 7-bit ASCII.
#
# The operator card corrupted itself once: crux/REMEMBER.md silently triple-encoded
# into 2,797 runs of capital-A-tilde mojibake before anyone caught it (REDS %83),
# because a tool read the UTF-8 file as Latin-1 and rewrote it, and each later edit
# re-encoded the mangled bytes another layer. This guard catches the NEXT mojibake on
# the lap it enters, not months later -- measurement beats memory.
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
ENFORCE="crux/REMEMBER.md crux/REDS.md"
# ADVISORY roster -- legacy dated non-ASCII reported as a ratchet, never a hard fail.
ADVISORY="crux/ROADMAP.md crux/TASKS.md crux/EQUINOX_SEAT_MAP.md crux/SHRED_PREP.md crux/THREADS.md crux/CAIRNS.md"
CONTROL=tools/fixtures/living_card_ascii_control/mojibake_control.md

# Count lines carrying any byte above 0x7F. grep -c exits 1 on zero matches, so guard it.
count_non_ascii() {
  LC_ALL=C grep -c -P '[^\x00-\x7F]' "$1" 2>/dev/null || true
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

echo "story=operator_card_pure_ascii>legacy_pins_ratcheted>mojibake_control_caught"
echo "verdict=ok"
