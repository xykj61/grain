#!/bin/sh
# Equinox e141 — commence Amphora CLI wave Q1 · relay APPLY 1-5 · seat 128 held.
# Exit 0 when charter/bow/REDS50/wave mode/census land and gates hold.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e141_commence_amphora_scan.sh
#   sh tools/fixtures/equinox_e141_commence_amphora_scan.sh prove-red
#
# Law: commence opens the wave; name and handback stay HELD; kg opens no 128.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/date/20260801/20260801-024355_e141-amphora-cli-equinox-charter.md
BOW=counsel/date/20260801/20260801-024355_e141-q1-bow.md
SEND=tools/gen/season/equinox_bundle_send.sh
LEXICON=context/LEXICON.md
MAP=crux/EQUINOX_SEAT_MAP.md
REMEMBER=crux/REMEMBER.md
ROADMAP=crux/ROADMAP.md
REDS=crux/REDS.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
BENCH=manual/guides/20260731-014410_opus-bench-raise.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_seat_128_opened_on_kg"
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

for p in "$COUNSEL" "$BOW" "$SEND" "$LEXICON" "$MAP" "$REMEMBER" \
  "$ROADMAP" "$REDS" "$BENCH" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# APPLY 1 — REDS 50
rg -q '^\| 50 \|' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_50"
  echo "verdict=misread"
  exit 1
}
rg -qi 'timing figure is a pin|amphora_resin_chunk' "$REDS" "$COUNSEL" || {
  echo "reds=failed"
  echo "detail=want_timing_pin_law"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_50_timing_figure_is_a_pin"
echo "apply1=honored"

# APPLY 2 — bench raise
rg -qi 'mkdir -p rishi/bin' "$BENCH" || {
  echo "bench=failed"
  echo "detail=want_mkdir_rishi_bin"
  echo "verdict=misread"
  exit 1
}
rg -qi 'ripgrep' "$BENCH" || {
  echo "bench=failed"
  echo "detail=want_ripgrep"
  echo "verdict=misread"
  exit 1
}
echo "bench=honored"
echo "apply2=honored"

# APPLY 3 — amphora census 10 tracked · 9 rye
CELLAR_N=$(git ls-files 'amphora/*' | wc -l | tr -d ' ')
RYE_N=$(git ls-files 'amphora/*.rye' | wc -l | tr -d ' ')
test "$CELLAR_N" = "10" || {
  echo "census=failed"
  echo "detail=want_amphora_tracked_10_got_$CELLAR_N"
  echo "verdict=misread"
  exit 1
}
test "$RYE_N" = "9" || {
  echo "census=failed"
  echo "detail=want_amphora_rye_9_got_$RYE_N"
  echo "verdict=misread"
  exit 1
}
rg -qi '10 tracked|9 .rye|nine .rye|10 \(9' "$COUNSEL" "$BOW" "$REMEMBER" || {
  echo "census=failed"
  echo "detail=want_census_named_in_pins"
  echo "verdict=misread"
  exit 1
}
echo "census=honored"
echo "amphora_tracked=10"
echo "amphora_rye=9"
echo "apply3=honored"

# APPLY 4 — charter · name HELD · N=64 · commence
rg -q '\*\*64\*\*' "$COUNSEL" || {
  echo "charter=failed"
  echo "detail=want_n_64"
  echo "verdict=misread"
  exit 1
}
rg -qi 'HELD' "$COUNSEL" "$BOW" || {
  echo "charter=failed"
  echo "detail=want_name_held"
  echo "verdict=misread"
  exit 1
}
rg -qi 'commence|OPEN' "$COUNSEL" "$BOW" "$REMEMBER" || {
  echo "charter=failed"
  echo "detail=want_commence_open"
  echo "verdict=misread"
  exit 1
}
rg -qi 'amphora pour|amphora carry|amphora restore|amphora version' "$COUNSEL" || {
  echo "charter=failed"
  echo "detail=want_cli_shape"
  echo "verdict=misread"
  exit 1
}
echo "charter=honored"
echo "commence=open"
echo "name=held"
echo "n=64"
echo "apply4=honored"

# APPLY 5 — wave mode · no hardcoded e129 in new rehearsal paths
rg -Fq 'wave)' "$SEND" || {
  echo "bundle=failed"
  echo "detail=want_wave_mode"
  echo "verdict=misread"
  exit 1
}
rg -q 'e129-rehearsal' "$SEND" && {
  echo "bundle=failed"
  echo "detail=e129_still_hardcoded_in_rehearsal"
  echo "verdict=misread"
  exit 1
}
rg -q 'rehearsal-all-' "$SEND" || {
  echo "bundle=failed"
  echo "detail=want_rehearsal_all_without_e129"
  echo "verdict=misread"
  exit 1
}
# closing four rounds still present
rg -q 'e63|e127|e191|e255' "$SEND" || {
  echo "bundle=failed"
  echo "detail=want_closing_four_kept"
  echo "verdict=misread"
  exit 1
}
echo "bundle=honored"
echo "wave_mode=honored"
echo "apply5=honored"

# Living small-span rehearsal still greens (path renamed)
SPAN_OUT=$(sh "$SEND" rehearsal --span "HEAD~3..HEAD")
echo "$SPAN_OUT" | rg -q '^verdict=ok$' || {
  echo "rehearsal=failed"
  echo "verdict=misread"
  exit 1
}
echo "$SPAN_OUT" | rg -q 'rehearsal-span-' || {
  echo "rehearsal=failed"
  echo "detail=want_new_rehearsal_span_path"
  echo "verdict=misread"
  exit 1
}
echo "rehearsal=honored"

rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$REMEMBER" "$MAP" "$COUNSEL" || {
  echo "shred_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "shred_gate=honored"
echo "shred=RED"

rg -q 'RESERVED' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'seat \*\*128\*\*.*SPENT|128.*LANDED' "$MAP"; then
  echo "reserve_keep=failed"
  echo "detail=seat_128_must_stay_reserved"
  echo "verdict=misread"
  exit 1
fi
echo "reserve_keep=honored"
echo "seat_128=reserved_close_choir"
echo "kg_no_gate=honored"

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

echo "story=commence>q1_charter>reds_50>wave_mode>census_10>128_reserved"
echo "verdict=ok"
