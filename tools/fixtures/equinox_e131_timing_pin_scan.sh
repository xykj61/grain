#!/bin/sh
# Equinox e131 — timing figure is a pin · manifest living-doc limb · shred held.
# Exit 0 when laws are tracked, REDS 43 lands, shred stays RED, 128 reserved.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e131_timing_pin_scan.sh
#   sh tools/fixtures/equinox_e131_timing_pin_scan.sh prove-red
#
# Law: a timing figure is a pin — carry a range or re-cut, never a number.
# Law: kg names a lean; it does not circle shred yes.
# Law: living_doc sizes make a restore verified rather than trusted.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/date/20260801/20260801-000833_e131-timing-pin-manifest-limb.md
LEXICON=context/LEXICON.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
REDS=construction/REDS.md
MANIFEST=waymarks/20260731-234032_e129-first-bundle-send.manifest
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_kg_opened_shred_without_word"
  echo "verdict=misread"
  exit 1
fi

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi
CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

for p in "$COUNSEL" "$LEXICON" "$MAP" "$ITINERARY" "$REDS" "$MANIFEST" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Lexicon: timing figure law
rg -qi 'timing figure' "$LEXICON" || {
  echo "timing=failed"
  echo "detail=want_timing_figure_in_lexicon"
  echo "verdict=misread"
  exit 1
}
rg -qi 'range or re-cut|re-cut every round|not a constant' "$LEXICON" "$COUNSEL" || {
  echo "timing=failed"
  echo "detail=want_range_or_recut"
  echo "verdict=misread"
  exit 1
}
echo "timing=honored"
echo "timing_law=figure_is_a_pin_range_or_recut"

# Manifest living-doc limb (e129 artifact · e131 names why)
LIVING_N=$(rg -c '^living_doc ' "$MANIFEST" || true)
LIVING_N=${LIVING_N:-0}
if test "$LIVING_N" -lt 6; then
  echo "manifest_limb=failed"
  echo "detail=want_six_living_doc_rows"
  echo "living_doc_n=${LIVING_N}"
  echo "verdict=misread"
  exit 1
fi
rg -q 'verified_rather_than_trusted' "$MANIFEST" || {
  echo "manifest_limb=failed"
  echo "detail=want_verified_restore"
  echo "verdict=misread"
  exit 1
}
rg -qi 'living.doc|living_doc|verified rather than trusted|e121 wipe' "$COUNSEL" "$LEXICON" "$ITINERARY" || {
  echo "manifest_limb=failed"
  echo "detail=want_living_doc_named_in_pins"
  echo "verdict=misread"
  exit 1
}
echo "manifest_limb=honored"
echo "living_doc_rows=${LIVING_N}"
echo "restore=verified_rather_than_trusted"

# Bundle blob stays out of the tree
BUNDLE_TRACKED=$(git ls-files 'bundles/**' 2>/dev/null | wc -l | tr -d ' ')
if test "$BUNDLE_TRACKED" -ne 0; then
  echo "bundle_tree=failed"
  echo "detail=want_zero_tracked_under_bundles"
  echo "tracked=${BUNDLE_TRACKED}"
  echo "verdict=misread"
  exit 1
fi
echo "bundle_tree=honored"
echo "bundles_tracked=0"

# REDS row 43
rg -q '^\| 43 \|' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_43"
  echo "verdict=misread"
  exit 1
}
rg -qi 'timing|desk.tier|stopwatch|cache warmth' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_timing_lesson_in_43"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_43_timing_figure_is_a_pin"

# Counsel refuses kg-as-shred-open
rg -qi 'does not circle shred|do not open|does not open' "$COUNSEL" || {
  echo "shred_gate=failed"
  echo "detail=want_kg_does_not_open_shred"
  echo "verdict=misread"
  exit 1
}
rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$ITINERARY" "$MAP" "$COUNSEL" || {
  echo "shred_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "shred_gate=honored"
echo "shred=RED"
echo "kg_opened_shred=refused"

rg -q 'RESERVED' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'seat \*\*128\*\*.*SPENT|128.*LANDED' "$MAP"; then
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
fi
echo "reserve_keep=honored"
echo "seat_128=reserved_close_choir"

if rg -q '^### 128\.' "$ALMANAC"; then
  echo "almanac=failed"
  echo "detail=seat_128_must_stay_unspent"
  echo "verdict=misread"
  exit 1
fi
echo "almanac=honored"
echo "no_content_seat_claimed=honored"

if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
echo "fork=honored"
echo "gates_kept=shred_safe_geode_128"
echo "itinerary=n2_done_n1_shred_waits_n_close_waits"

echo "story=timing_pin>manifest_living_doc>shred_held>128_reserved"
echo "verdict=ok"
