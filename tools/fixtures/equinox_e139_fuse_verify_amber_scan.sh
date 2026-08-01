#!/bin/sh
# Equinox e139 — fuse verify Amber accretion already GREEN (e138). No second retirement.
# Exit 0 when living tree carries e138 accretion, Silo template is named, shred held,
# seat 128 reserved, and kg did not open the close.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e139_fuse_verify_amber_scan.sh
#   sh tools/fixtures/equinox_e139_fuse_verify_amber_scan.sh prove-red
#
# Law: do not manufacture a second retirement for a lane already closed.
# Law: kg does not lift seat 128.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/20260801-013236_e139-fuse-verify-amber-accretion.md
ELDER=counsel/20260801-012557_e138-amber-retire-by-accretion.md
ELDER_SCAN=tools/fixtures/equinox_e138_amber_accretion_scan.sh
LEXICON=context/LEXICON.md
MAP=work-in-progress/EQUINOX_SEAT_MAP.md
REMEMBER=work-in-progress/REMEMBER.md
REDS=work-in-progress/REDS.md
SHRED=work-in-progress/SHRED_PREP.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
AMBER_WITNESS=tools/amber_first_ring.rish
RISHI=rishi/bin/rishi

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

for p in "$COUNSEL" "$ELDER" "$ELDER_SCAN" "$LEXICON" "$MAP" "$REMEMBER" \
  "$REDS" "$SHRED" "$AMBER_WITNESS" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Elder e138 living scan still greens
E138_OUT=$(sh "$ELDER_SCAN")
echo "$E138_OUT" | rg -q '^verdict=ok$' || {
  echo "e138=failed"
  echo "verdict=misread"
  exit 1
}
echo "$E138_OUT" | rg -q '^breach=withdrawn_to_accretion$' || {
  echo "e138=failed"
  echo "detail=want_breach_withdrawn"
  echo "verdict=misread"
  exit 1
}
echo "e138=honored"
echo "elder_seat=e138"
echo "accretion=already_green"

# Amber witness green
if ! test -x "$RISHI"; then
  echo "amber_witness=failed"
  echo "detail=rishi_absent"
  echo "verdict=misread"
  exit 1
fi
AMBER_OUT=$("$RISHI" run "$AMBER_WITNESS" 2>&1) || {
  echo "amber_witness=failed"
  echo "verdict=misread"
  exit 1
}
echo "$AMBER_OUT" | rg -qi 'GREEN: amber first lap witness passed' || {
  echo "amber_witness=failed"
  echo "detail=want_amber_first_lap_green"
  echo "verdict=misread"
  exit 1
}
echo "amber_witness=honored"
echo "amber_witness_note=parity_144_green"

AMBER_N=$(git ls-files 'amber/*' | wc -l | tr -d ' ')
test "$AMBER_N" = "2" || {
  echo "amber_kept=failed"
  echo "detail=want_amber_tracked_2_got_$AMBER_N"
  echo "verdict=misread"
  exit 1
}
echo "amber_kept=honored"
echo "amber_tracked=2"

# Silo template present · named in this counsel
rg -qi 'Silo.*as a Rye OS module name' "$LEXICON" || {
  echo "silo_template=failed"
  echo "detail=want_silo_retirement_row"
  echo "verdict=misread"
  exit 1
}
rg -qi 'Silo template|silo template' "$COUNSEL" || {
  echo "silo_template=failed"
  echo "detail=want_silo_named_in_counsel"
  echo "verdict=misread"
  exit 1
}
rg -qi 'Silo template|silo template' "$LEXICON" "$REMEMBER" "$COUNSEL" || {
  echo "silo_template=failed"
  echo "detail=want_silo_kinship_named"
  echo "verdict=misread"
  exit 1
}
rg -q '174500' "$LEXICON" || {
  echo "silo_template=failed"
  echo "detail=want_silo_174500_stamp"
  echo "verdict=misread"
  exit 1
}
echo "silo_template=honored"
echo "template=silo_174500"

# Living pins — fuse verify · no second retirement
rg -qi 'fuse verify|already GREEN|already green|Silo template' "$COUNSEL" "$REMEMBER" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
rg -qi 'Absorbs cellar|Unified under Amphora|cellar \*\*and\*\* vessel under one living name' "$LEXICON" && {
  echo "living=failed"
  echo "detail=living_still_folds_cellar"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"
echo "no_second_retirement=honored"

# REDS 48 still present
rg -q '^\| 48 \|' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_48"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_48_retire_by_accretion"

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
echo "queue=empty_for_counsel"

echo "story=fuse_verify>e138_already_green>silo_template>kg_no_128>shred_held>128_reserved"
echo "verdict=ok"
