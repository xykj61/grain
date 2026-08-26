#!/bin/sh
# Equinox e111 -- context date dialect compact (hyphen -> YYYYMMDD backticks).
# Exit 0 only when control reads and dialect limbs honor.
# No backtick characters in patterns (except none in this file).
#
#   sh tools/fixtures/equinox_e111_date_dialect_scan.sh
#
# Law: carry the transformation, never the claim that it was done.
# Change only Last updated values; advance no date; rename no file.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/chapter/prin_scope.rish
MAP=construction/EQUINOX_SEAT_MAP.md

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi

CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT"
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

# --- eleven transformed files present and compact ---
# Compact Last updated is YYYYMMDD or full one-clock YYYYMMDD.HHMMSS, wrapped
# in backticks. Optional seconds keep a date and a timestamp both compact
# (e132 - instrument aged when the tree moved to stamps). Build the pattern
# without a literal backtick character in this source (shell-pattern hard line).
BT=$(printf '\140')
COMPACT_RE="^\\*\\*Last updated:\\*\\* ${BT}[0-9]{8}(\\.[0-9]{6})?${BT}"
HYPHEN_RE='^\*\*Last updated:\*\* [0-9]{4}-[0-9]{2}-[0-9]{2}'
FILES='BREACH.md CIVIC_STYLE.md LEXICON.md PUBKEYS.md QUIN.md RADIANT_STYLE.md README.md SILO_TECHNIQUE.md SIMPLE_LOVABLE_COMPLETE.md TAME_GUIDANCE.md TWO_ROOMS.md'
expect_n=11
got=0
for f in $FILES; do
  path="context/${f}"
  git ls-files --error-unmatch "$path" >/dev/null 2>&1 || {
    echo "dialect=failed"
    echo "verdict=misread"
    echo "detail=want_tracked_${f}"
    exit 1
  }
  if ! rg -q "$COMPACT_RE" "$path"; then
    echo "dialect=failed"
    echo "verdict=misread"
    echo "detail=want_compact_last_updated_${f}"
    exit 1
  fi
  if rg -q "$HYPHEN_RE" "$path"; then
    echo "dialect=failed"
    echo "verdict=misread"
    echo "detail=hyphen_remains_${f}"
    exit 1
  fi
  got=$((got + 1))
done
if test "$got" -ne "$expect_n"; then
  echo "dialect=failed"
  echo "verdict=misread"
  exit 1
fi
echo "dialect=honored"
echo "dialect_transformed=${got}"

# --- zero hyphenated Last updated across context/*.md ---
HYPHEN_HITS=$(rg -l "$HYPHEN_RE" context/*.md 2>/dev/null | wc -l | tr -d ' ')
if test "$HYPHEN_HITS" -ne 0; then
  echo "dialect_zero=failed"
  echo "verdict=misread"
  echo "detail=hyphenated_last_updated_remain=${HYPHEN_HITS}"
  exit 1
fi
echo "dialect_zero=honored"
echo "hyphenated_last_updated=0"

# --- at least seventeen context files carry Last updated / Seated / Stamp ---
# A FLOOR RATHER THAN A PIN (REDS %235), for the reason its sibling
# tools/fixtures/date_dialect_scan.sh carries in full: the room grows, a label is what a new
# document correctly brings with it, and an exact count turns that growth into a refusal. The
# hyphen check above is the reading with the stake in it, and it is exact at zero.
LABEL_N=$(rg -l '^\*\*(Last updated|Seated|Stamp):\*\*' context/*.md | wc -l | tr -d ' ')
if test "$LABEL_N" -lt 17; then
  echo "dialect_roster=failed"
  echo "verdict=misread"
  echo "detail=want_at_least_17_got_${LABEL_N}"
  exit 1
fi
echo "dialect_roster=honored"
echo "context_date_label_files=${LABEL_N}"
echo "context_date_label_floor=17"
echo "dialect_status=${LABEL_N}_of_${LABEL_N}_compact"

# --- radiant_lint dependency: label only, not value shape ---
rg -q 'Last updated' tools/fixtures/radiant_lint_scan.sh || {
  echo "lint_dep=failed"
  echo "verdict=misread"
  exit 1
}
# prove the scan still speaks (does not require zero advises -- only that it runs)
LINT_OUT=$(sh tools/fixtures/radiant_lint_scan.sh 2>&1 || true)
echo "$LINT_OUT" | rg -q 'duty3|header|OK|ADVISE|fascia|radiant' || {
  echo "lint_dep=failed"
  echo "verdict=misread"
  echo "detail=radiant_lint_silent"
  exit 1
}
echo "lint_dep=honored"
echo "lint_dep_note=label_only_first_25_lines"

# --- seat 128 still reserved - not spent ---
rg -q 'RESERVED' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
rg -q '128' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'seat \*\*128\*\*.*SPENT|128.*LANDED' "$MAP"; then
  echo "reserve_keep=failed"
  echo "verdict=misread"
  echo "detail=128_must_stay_reserved"
  exit 1
fi
echo "reserve_keep=honored"
echo "seat_128=reserved_close_choir"

# --- surface census six (e119 ch5+ch6 tools; e110's four is historical) ---
COUNT=$(git ls-files 'tools/gen/chapter/equinox_ch*_surface_witness.rish' | wc -l | tr -d ' ')
if test "$COUNT" -ne 6; then
  echo "surface_keep=failed"
  echo "verdict=misread"
  echo "detail=want_surface_count_6"
  echo "surface_count=${COUNT}"
  exit 1
fi
echo "surface_keep=honored"
echo "surface_count=6"

# --- almanac: seat 114 present - ch8 at least 2/16 ---
rg -q '^### 114\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
rg -q '^## Chapter Eight \([0-9]+ of 16\)$' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "seats_through=114"

# --- fork ---
if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
rg -q 'equinox_handback: return_surface_p59' "$PRIN" || {
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
}
echo "fork=honored"
echo "fork_status=not_consumed"

EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "shelf=failed"
  echo "verdict=misread"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "shelf=failed"
  echo "verdict=misread"
  exit 1
fi
echo "shelf=honored"
echo "shelf_end=ep045"
echo "shred=RED"

echo "story=date_dialect_compact>at_least_17_all_compact>128_reserved_kept>census_six_kept>fork_waiting"
echo "e111_date_dialect=ok"
echo "verdict=ok"
