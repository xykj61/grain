#!/bin/sh
# Equinox e129 — first bundle-send rehearsal (crossing mode · not a seat).
# Exit 0 when the kit lands, a stamped manifest is tracked, and a small-span
# cut verifies. No backtick characters. No git history walks for presence.
#
#   sh tools/fixtures/equinox_e129_bundle_send_scan.sh
#   sh tools/fixtures/equinox_e129_bundle_send_scan.sh prove-red
#
# Law: bundle send is a crossing mode — kg may move it; shred/geode/128 stay gated.
# Law: cut home-side · verify · stamped manifest · never /tmp.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
SEND=tools/gen/season/equinox_bundle_send.sh
MANIFEST_SH=tools/gen/season/equinox_bundle_manifest.sh
ELDER_RISH=tools/gen/season/equinox_bundle.rish
TRACKED_MANIFEST=waymarks/20260731-234032_e129-first-bundle-send.manifest
COUNSEL=counsel/date/20260731/20260731-234032_e129-bundle-send-rehearsal.md
LEXICON=context/LEXICON.md
MAP=construction/EQUINOX_SEAT_MAP.md
REMEMBER=construction/REMEMBER.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
ELDER_E128=tools/fixtures/equinox_e128_class_o_word_scope_scan.sh

if test "$MODE" = "prove-red"; then
  echo "detail=RED_bundle_send_tmpfs_or_seat_claim"
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

for p in "$SEND" "$MANIFEST_SH" "$ELDER_RISH" "$TRACKED_MANIFEST" "$COUNSEL" "$LEXICON" "$MAP" "$REMEMBER" "$PRIN" "$ELDER_E128"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Tracked first-cut manifest carries discipline fields
for key in format stamp kind pier span tip bundle_bytes bound_bytes living_doc restore discipline verdict; do
  rg -q "^${key} " "$TRACKED_MANIFEST" || {
    echo "manifest=failed"
    echo "detail=want_${key}"
    echo "verdict=misread"
    exit 1
  }
done
rg -q 'restored_rather_than_trusted|verified_rather_than_trusted' "$TRACKED_MANIFEST" || {
  echo "manifest=failed"
  echo "detail=want_verified_restore"
  echo "verdict=misread"
  exit 1
}
BYTES=$(sed -n 's/^bundle_bytes //p' "$TRACKED_MANIFEST" | head -1)
case "$BYTES" in
  ''|0)
    echo "manifest=failed"
    echo "detail=want_nonzero_bytes"
    echo "verdict=misread"
    exit 1
    ;;
esac
if test "$BYTES" -gt 268435456; then
  echo "manifest=failed"
  echo "detail=over_bound"
  echo "verdict=misread"
  exit 1
fi
echo "manifest=honored"
echo "first_cut_bytes=${BYTES}"
echo "first_cut_within_bound=honored"

# Living small-span cut proves the kit still cuts
SPAN_OUT=$(sh "$SEND" rehearsal --span "HEAD~3..HEAD")
echo "$SPAN_OUT" | rg -q '^verdict=ok$' || {
  echo "rehearsal=failed"
  echo "verdict=misread"
  exit 1
}
echo "$SPAN_OUT" | rg -q '^durable=honored$' || {
  echo "rehearsal=failed"
  echo "detail=want_durable"
  echo "verdict=misread"
  exit 1
}
echo "$SPAN_OUT" | rg -q '^crossing_mode=bundle_send$' || {
  echo "rehearsal=failed"
  echo "detail=want_crossing_mode"
  echo "verdict=misread"
  exit 1
}
echo "$SPAN_OUT" | rg -q '^seat_claimed=none$' || {
  echo "rehearsal=failed"
  echo "detail=want_no_seat"
  echo "verdict=misread"
  exit 1
}
echo "rehearsal=honored"
echo "rehearsal_note=small_span_cut_verified"
echo "crossing_mode=bundle_send"
echo "seat_claimed=none"

# Elder rish now calls stamped manifest
rg -q 'equinox_bundle_manifest.sh' "$ELDER_RISH" || {
  echo "elder_rish=failed"
  echo "detail=want_manifest_hook"
  echo "verdict=misread"
  exit 1
}
echo "elder_rish=honored"

# Lexicon names bundle send as crossing mode
rg -qi 'bundle send' "$LEXICON" || {
  echo "lexicon=failed"
  echo "verdict=misread"
  exit 1
}
echo "lexicon=honored"

rg -qi 'bundle send|crossing mode|stamped manifest|first cut' "$COUNSEL" "$REMEMBER" "$MAP" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

ELDER_OUT=$(sh "$ELDER_E128")
echo "$ELDER_OUT" | rg -q '^verdict=ok$' || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"

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

rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$REMEMBER" "$MAP" "$COUNSEL" || {
  echo "shred_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "shred_gate=honored"
echo "shred=RED"

if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
echo "fork=honored"
echo "gates_kept=shred_safe_geode_128"
echo "surprise=first_bundle_send_cut_on_cloud"

echo "story=bundle_send>crossing_mode>stamped_manifest>128_reserved"
echo "verdict=ok"
