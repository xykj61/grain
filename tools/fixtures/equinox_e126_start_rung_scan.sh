#!/bin/sh
# Equinox e126 — start rung named (sh→rish) · census_control climb begun.
# Exit 0 only when Lexicon names the start rung and the climb holds.
# No backtick characters. No git history walks.
#
#   sh tools/fixtures/equinox_e126_start_rung_scan.sh
#   sh tools/fixtures/equinox_e126_start_rung_scan.sh prove-red
#
# Law: foundations first — work starts at the sh→rish seam.
# Law: approve-all seats leans; it circles no gate (128 · shred · geode stay).
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
LEXICON=context/LEXICON.md
COUNSEL=counsel/date/20260731/20260731-231123_e126-start-rung-sh-rish.md
MAP=work-in-progress/EQUINOX_SEAT_MAP.md
REMEMBER=work-in-progress/REMEMBER.md
PRIN=tools/gen/season/prin_scope.rish
ELDER_STACK=tools/fixtures/equinox_e125_build_stack_scan.sh
RISH_ORCH=tools/fixtures/census_control_scan.rish
DRIVE=tools/fixtures/census_control_scan_drive.sh
H1_SEAM=tools/fixtures/census_control_h1_seam.sh
MARKER_SEAM=tools/fixtures/census_control_marker_seam.sh
TRACKED_SEAM=tools/fixtures/census_control_tracked_seam.sh
ENTRY=tools/fixtures/census_control_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_start_rung_mantra_first"
  echo "verdict=misread"
  exit 1
fi

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
echo "$CONTROL_OUT" | rg -q '^duties_honored=3$' || {
  echo "control_gate=failed"
  echo "detail=want_duties_honored_3"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

# prove-red still refuses through the thin entry
set +e
RED_OUT=$(sh "$CONTROL_SCAN" prove-red)
RED_RC=$?
set -e
echo "$RED_OUT"
if test "$RED_RC" -eq 0; then
  echo "prove_red=failed"
  echo "verdict=misread"
  exit 1
fi
echo "$RED_OUT" | rg -q 'verdict=misread' || {
  echo "prove_red=failed"
  echo "verdict=misread"
  exit 1
}
echo "prove_red=honored"

for p in "$LEXICON" "$COUNSEL" "$MAP" "$REMEMBER" "$PRIN" "$ELDER_STACK" "$RISH_ORCH" "$DRIVE" "$H1_SEAM" "$MARKER_SEAM" "$TRACKED_SEAM" "$ENTRY"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

ROW=$(rg -F '| **build stack** |' "$LEXICON" || true)
if test -z "$ROW"; then
  echo "stack=failed"
  echo "verdict=misread"
  echo "detail=want_build_stack_row"
  exit 1
fi
echo "$ROW" | rg -qi 'start rung' || {
  echo "start_rung=failed"
  echo "detail=want_start_rung_in_lexicon"
  echo "verdict=misread"
  exit 1
}
echo "$ROW" | rg -qi 'sh.*rish|sh→rish|sh -> rish|sh to rish' || {
  echo "start_rung=failed"
  echo "detail=want_sh_to_rish_seam"
  echo "verdict=misread"
  exit 1
}
echo "start_rung=honored"
echo "start_rung_name=sh_to_rish_seam"

# Thin entry prefers rish; drive/seams present; rish carries orchestration markers
rg -q 'rishi/bin/rishi' "$ENTRY" || {
  echo "climb=failed"
  echo "detail=want_thin_entry_prefers_rishi"
  echo "verdict=misread"
  exit 1
}
rg -q 'census_control_scan_drive.sh' "$ENTRY" || {
  echo "climb=failed"
  echo "detail=want_drive_fallback"
  echo "verdict=misread"
  exit 1
}
rg -q 'census_control_h1_seam' "$RISH_ORCH" || {
  echo "climb=failed"
  echo "detail=want_rish_calls_h1_seam"
  echo "verdict=misread"
  exit 1
}
rg -q 'census_control_marker_seam' "$RISH_ORCH" || {
  echo "climb=failed"
  echo "detail=want_rish_calls_marker_seam"
  echo "verdict=misread"
  exit 1
}
rg -q 'census_control_tracked_seam' "$RISH_ORCH" || {
  echo "climb=failed"
  echo "detail=want_rish_calls_tracked_seam"
  echo "verdict=misread"
  exit 1
}
# Entry must stay thin — not carry the old fat python body
if rg -q 'duty1_h1_true' "$ENTRY"; then
  echo "climb=failed"
  echo "detail=entry_must_not_hold_duty_logic"
  echo "verdict=misread"
  exit 1
fi
ENTRY_LINES=$(wc -l < "$ENTRY" | tr -d '[:space:]')
if test "$ENTRY_LINES" -gt 40; then
  echo "climb=failed"
  echo "detail=entry_too_fat"
  echo "entry_lines=$ENTRY_LINES"
  echo "verdict=misread"
  exit 1
fi
echo "climb=honored"
echo "climb_note=census_control_seams_plus_rish_orchestration"

rg -qi 'start rung|sh.to.rish|sh→rish|foundations first' "$COUNSEL" "$REMEMBER" "$MAP" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

# Elder build stack still GREEN
ELDER_OUT=$(sh "$ELDER_STACK")
echo "$ELDER_OUT" | rg -q '^verdict=ok$' || {
  echo "elder=failed"
  echo "verdict=misread"
  echo "detail=want_e125_stack_ok"
  exit 1
}
echo "elder=honored"
echo "elder_note=e125_build_stack_kept"

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

rg -q '^### 127\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q '^### 128\.' "$ALMANAC"; then
  echo "almanac=failed"
  echo "verdict=misread"
  echo "detail=seat_128_must_stay_unspent"
  exit 1
fi
echo "almanac=honored"
echo "seats_through=127"
echo "no_content_seat_claimed=honored"

if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
echo "fork=honored"
echo "shred=RED"
echo "gates_kept=shred_safe_geode_128"

echo "story=start_rung>sh_to_rish>census_control_climb>128_reserved"
echo "verdict=ok"
