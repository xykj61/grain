#!/bin/sh
# Equinox e142 — Q2 CLI doc comment · R51 · Crossing lean · zero code.
# Exit 0 when duty file, lean, handback slot, README CLI surface, and gates hold.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e142_q2_cli_doc_scan.sh
#   sh tools/fixtures/equinox_e142_q2_cli_doc_scan.sh prove-red
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/date/20260801/20260801-024840_e142-q2-cli-doc-comment.md
DUTY=counsel/date/20260731/20260731-224453_amphora-cli-nested-equinox-charter.md
ELDER=counsel/date/20260801/20260801-024355_e141-amphora-cli-equinox-charter.md
README=amphora/README.md
LEXICON=context/LEXICON.md
MAP=construction/EQUINOX_SEAT_MAP.md
REMEMBER=construction/REMEMBER.md
REDS=construction/REDS.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_q2_grew_cli_code"
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

for p in "$COUNSEL" "$DUTY" "$ELDER" "$README" "$LEXICON" "$MAP" \
  "$REMEMBER" "$REDS" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# R51
rg -q '^\| 51 \|' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_51"
  echo "verdict=misread"
  exit 1
}
rg -qi 'leans on a name|Crossing Season|working lean' "$REDS" "$COUNSEL" "$DUTY" || {
  echo "reds=failed"
  echo "detail=want_name_lean_law"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_51_counsel_leans_never_seats"

# Crossing lean · not seated as sole living name claim
rg -qi 'Crossing Season' "$DUTY" "$COUNSEL" "$REMEMBER" "$README" || {
  echo "lean=failed"
  echo "detail=want_crossing_lean"
  echo "verdict=misread"
  exit 1
}
rg -qi 'seat is Keaton|seat Keaton|Keaton.s' "$DUTY" "$COUNSEL" || {
  echo "lean=failed"
  echo "detail=want_seat_keatons"
  echo "verdict=misread"
  exit 1
}
echo "lean=honored"
echo "lean_note=crossing_season_offered"

# Handback slot
rg -q 'return_deca_128' "$DUTY" "$COUNSEL" "$ELDER" "$REMEMBER" || {
  echo "handback=failed"
  echo "detail=want_return_deca_128"
  echo "verdict=misread"
  exit 1
}
echo "handback=honored"
echo "handback_slot=return_deca_128"

# Q2 doc surface · amphora version/pour/carry/restore named
rg -qi 'amphora version|amphora pour|amphora carry|amphora restore' "$README" || {
  echo "q2=failed"
  echo "detail=want_cli_commands_in_readme"
  echo "verdict=misread"
  exit 1
}
rg -qi 'doc comment|Q2|zero code' "$COUNSEL" "$README" || {
  echo "q2=failed"
  echo "detail=want_q2_zero_code_named"
  echo "verdict=misread"
  exit 1
}
echo "q2=honored"
echo "q2_note=cli_doc_comment_only"

# Zero new rye · still 10 tracked · 9 rye
AMPH_N=$(git ls-files 'amphora/*' | wc -l | tr -d ' ')
RYE_N=$(git ls-files 'amphora/*.rye' | wc -l | tr -d ' ')
test "$AMPH_N" = "10" || {
  echo "census=failed"
  echo "detail=want_amphora_10_got_$AMPH_N"
  echo "verdict=misread"
  exit 1
}
test "$RYE_N" = "9" || {
  echo "census=failed"
  echo "detail=want_rye_9_got_$RYE_N"
  echo "verdict=misread"
  exit 1
}
# No amphora CLI rye entry yet
if git ls-files 'amphora/*cli*' 'amphora/cli*' 2>/dev/null | rg -q .; then
  echo "zero_code=failed"
  echo "detail=cli_source_appeared"
  echo "verdict=misread"
  exit 1
fi
echo "census=honored"
echo "amphora_tracked=10"
echo "zero_code=honored"

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
  echo "verdict=misread"
  exit 1
fi
echo "reserve_keep=honored"
echo "seat_128=reserved_close_choir"

if rg -q '^### 128\.' "$ALMANAC"; then
  echo "almanac=failed"
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

echo "story=q2_doc>r51>crossing_lean>handback_slot>zero_code>128_reserved"
echo "verdict=ok"
