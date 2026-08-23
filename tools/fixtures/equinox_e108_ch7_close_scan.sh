#!/bin/sh
# Equinox e108 — Chapter Seven close choir (check · test · prepare).
# Exit 0 only when control reads and all close limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e108_ch7_close_scan.sh
#
# Law: a chapter-close choir is a check. Shred opens Chapter Eight.
# Bundle is a crossing mode for this send. Do not consume the fork.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
MAP=crux/EQUINOX_SEAT_MAP.md
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
FASCIA_SH=tools/fixtures/fascia_metric_v0.sh
REDS=crux/REDS.md
ZERO=tools/fixtures/zero_view_scan.sh
M3=tools/fixtures/oldness_census_scan.sh
M4=tools/fixtures/radiant_h1_fence_scan.sh

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

# --- seat map: 112 close choir this sitting · shred opens Chapter Eight ---
git ls-files --error-unmatch "$MAP" >/dev/null 2>&1 || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=map_not_tracked"
  exit 1
}
rg -q 'seats \*\*97–112\*\*|seats \*\*97-112\*\*|97–112' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_ch7_span"
  exit 1
}
rg -q 'CLOSE CHOIR' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_112_close_choir"
  exit 1
}
rg -q 'check · test · prepare' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_check_prepare"
  exit 1
}
rg -q 'this sitting' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_112_this_sitting"
  exit 1
}
rg -q 'BUNDLE SEND|crossing mode' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_bundle_as_crossing_mode"
  exit 1
}
rg -q 'crossing mode' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_bundle_as_crossing_mode"
  exit 1
}
rg -q 'close-seat row' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_ch5_ch6_park_named"
  exit 1
}
rg -q 'Keaton' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'return_surface_p59 CONSUMED' "$MAP"; then
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=map_must_not_consume_fork"
  exit 1
fi
# Must not still claim 112 only proposed after this close
if rg -q 'seat_map_112=close_choir_proposed|\*\*112\*\*.*\*\*PROPOSED\*\*' "$MAP"; then
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=112_must_not_remain_proposed"
  exit 1
fi
# Shred: e108 named opens-ch8; e109 refined to keaton-gated mode (duty not seat)
SHRED_MODE=unknown
if rg -q 'Keaton-gated' "$MAP" && rg -q 'duty is not a seat|A duty is not a seat' "$MAP"; then
  SHRED_MODE=keaton_gated_mode
elif rg -q 'Chapter Eight' "$MAP"; then
  SHRED_MODE=opens_chapter_eight
else
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_shred_mode_or_ch8_note"
  exit 1
fi
echo "seat_map=honored"
echo "seat_map_path=${MAP}"
echo "seat_map_110=spent_e106"
echo "seat_map_111=spent_e107"
echo "seat_map_112=close_choir_this_sitting"
echo "seat_map_bundle=crossing_mode"
echo "seat_map_shred=${SHRED_MODE}"
echo "seat_map_shred_gate=keaton_word"

# --- REDS 34-37 · container renumbered into tree ---
git ls-files --error-unmatch "$REDS" >/dev/null 2>&1 || {
  echo "reds_cross=failed"
  echo "verdict=misread"
  exit 1
}
for n in 34 35 36 37; do
  rg -q "^\\| ${n} \\|" "$REDS" || {
    echo "reds_cross=failed"
    echo "verdict=misread"
    echo "detail=want_row_${n}"
    exit 1
  }
done
rg -q 'git ls-files' "$REDS" || {
  echo "reds_cross=failed"
  echo "verdict=misread"
  echo "detail=want_row_34_git_ls_files"
  exit 1
}
rg -q 'Verify a zero' "$REDS" || {
  echo "reds_cross=failed"
  echo "verdict=misread"
  echo "detail=want_row_35_verify_zero"
  exit 1
}
rg -q 'Fence-aware' "$REDS" || {
  echo "reds_cross=failed"
  echo "verdict=misread"
  echo "detail=want_row_36_fence_aware"
  exit 1
}
rg -q 'No backtick' "$REDS" || {
  echo "reds_cross=failed"
  echo "verdict=misread"
  echo "detail=want_row_37_no_backtick"
  exit 1
}
MONO=$(sh tools/fixtures/reds_ledger_monotone_scan.sh)
echo "$MONO"
echo "$MONO" | rg -q '^verdict=ok$' || {
  echo "reds_cross=failed"
  echo "verdict=misread"
  echo "detail=want_monotone"
  exit 1
}
echo "$MONO" | rg -q '^rows=37$' || {
  echo "reds_cross=failed"
  echo "verdict=misread"
  echo "detail=want_rows_37"
  exit 1
}
echo "$MONO" | rg -q '^expect_next=38$' || {
  echo "reds_cross=failed"
  echo "verdict=misread"
  exit 1
}
echo "reds_cross=honored"
echo "reds_rows=37"
echo "reds_expect_next=38"
echo "reds_note=container_33-36_renumbered_34-37"

# --- planted zero-view kept ---
ZERO_OUT=$(sh "$ZERO")
echo "$ZERO_OUT"
echo "$ZERO_OUT" | rg -q '^verdict=ok$' || {
  echo "zero_view=failed"
  echo "verdict=misread"
  exit 1
}
echo "zero_view=honored"

# --- M3 / M4 home land kept ---
M3_OUT=$(sh "$M3")
echo "$M3_OUT"
echo "$M3_OUT" | rg -q '^verdict=ok$' || {
  echo "m3_keep=failed"
  echo "verdict=misread"
  exit 1
}
echo "m3_keep=honored"
M4_OUT=$(sh "$M4")
echo "$M4_OUT"
echo "$M4_OUT" | rg -q '^verdict=ok$' || {
  echo "m4_keep=failed"
  echo "verdict=misread"
  exit 1
}
echo "m4_keep=honored"
echo "m3_m4_status=e105_consumed_kept"

# --- fascia hold + window carry kept ---
FASCIA_OUT=$(sh "$FASCIA_SH" measure)
echo "$FASCIA_OUT"
echo "$FASCIA_OUT" | rg -q '^GREEN: fascia-metric-v0' || {
  echo "fascia_keep=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'metric_rev=i9' || {
  echo "fascia_keep=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'law=hold_not_exclude' || {
  echo "fascia_keep=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'window_carry=honored' || {
  echo "fascia_keep=failed"
  echo "verdict=misread"
  exit 1
}
FASCIA_GRADE=$(echo "$FASCIA_OUT" | rg -o 'fascia=[0-9]+' | head -n1 | cut -d= -f2)
if test -z "$FASCIA_GRADE" || test "$FASCIA_GRADE" -ne 92; then
  echo "fascia_keep=failed"
  echo "verdict=misread"
  echo "detail=want_fascia_92"
  exit 1
fi
echo "fascia_keep=honored"
echo "fascia_keep_grade=${FASCIA_GRADE}"

# --- fork still unconsumed ---
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

# --- almanac: seats 97-111 present · ch7 at 15/16 before this choir appends 112 ---
rg -q '^### 111\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  echo "detail=want_seat_111"
  exit 1
}
CH7_LINE=$(rg -n '^## Chapter Seven \([0-9]+ of 16\)$' "$ALMANAC" | head -n1 || true)
case "$CH7_LINE" in
  *"Chapter Seven (15 of 16)"*|*"Chapter Seven (16 of 16)"*)
    ;;
  *)
    echo "almanac=failed"
    echo "verdict=misread"
    echo "detail=want_ch7_at_least_15"
    exit 1
    ;;
esac
for n in 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "almanac=honored"
echo "ch7_line=$CH7_LINE"
echo "seats=97-111"
echo "seats_remaining_before_choir=112"

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
echo "close_mode=check_test_prepare"
echo "bundle_mode=crossing"

echo "story=seat_112_close_choir>reds_34-37>shred_opens_ch8>bundle_crossing>fork_waiting>ch7_full"
echo "e108_ch7_close=ok"
echo "verdict=ok"
