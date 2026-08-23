#!/bin/sh
# Equinox e113 — fascia-health v1 land + REDS 38 on-disk is not in-the-tree.
# Exit 0 only when control reads and all limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e113_fascia_health_scan.sh
#
# Law: on-disk is not in-the-tree. Test presence with git ls-files.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
HEALTH_SCAN=tools/fixtures/fascia_health_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
MAP=construction/EQUINOX_SEAT_MAP.md
REDS=construction/REDS.md
ELDER=tools/gen/season/equinox_e112_date_dialect_witness.rish

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

# --- instruments tracked (REDS 38 — never test -f alone) ---
for p in \
  "$HEALTH_SCAN" \
  tools/fixtures/fascia_health_live_control.md \
  tools/fixtures/20260731-150648_fascia_health_dated_control.md \
  tools/gen/season/fascia_health_witness.rish \
  context/specs/living-vs-dated.md
do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    if test -f "$p"; then
      echo "instrument=failed"
      echo "verdict=misread"
      echo "detail=on_disk_is_not_in_the_tree"
      echo "detail_path=$p"
      exit 1
    fi
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=control_absent"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# --- fascia-health standing instrument ---
HEALTH_OUT=$(sh "$HEALTH_SCAN")
echo "$HEALTH_OUT" | sed 's/^/health_/'
echo "$HEALTH_OUT" | rg -q '^verdict=ok$' || {
  echo "fascia_health=failed"
  echo "verdict=misread"
  exit 1
}
echo "$HEALTH_OUT" | rg -q '^fascia_health=(41|42)$' || {
  echo "fascia_health=failed"
  echo "verdict=misread"
  echo "detail=want_fascia_health_41_or_42"
  exit 1
}
echo "fascia_health=honored"

RED_OUT=$(sh "$HEALTH_SCAN" prove-red || true)
echo "$RED_OUT" | rg -q 'RED_on_disk_is_not_in_the_tree' || {
  echo "fascia_prove_red=failed"
  echo "verdict=misread"
  exit 1
}
echo "$RED_OUT" | rg -q '^verdict=ok$' && {
  echo "fascia_prove_red=failed"
  echo "verdict=misread"
  exit 1
}
echo "fascia_prove_red=honored"

# --- REDS row 38 ---
git ls-files --error-unmatch "$REDS" >/dev/null 2>&1 || {
  echo "reds_row=failed"
  echo "verdict=misread"
  exit 1
}
rg -q '^\| 38 \|' "$REDS" || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_row_38"
  exit 1
}
# Case-insensitive: ledger taught-column may capitalize the law sentence.
rg -qi 'on-disk is not in-the-tree' "$REDS" || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_on_disk_law"
  exit 1
}
rg -q 'git ls-files' "$REDS" || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_git_ls_files_taught"
  exit 1
}
MONO=$(sh tools/fixtures/reds_ledger_monotone_scan.sh)
echo "$MONO"
echo "$MONO" | rg -q '^verdict=ok$' || {
  echo "reds_row=failed"
  echo "verdict=misread"
  exit 1
}
# Accrete-never-break: pin row 38's presence, not the living ledger total.
ROWS=$(printf '%s\n' "$MONO" | sed -n 's/^rows=//p' | head -1)
EXPECT=$(printf '%s\n' "$MONO" | sed -n 's/^expect_next=//p' | head -1)
if test "${ROWS:-0}" -lt 38; then
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_rows_at_least_38"
  exit 1
fi
if test "${EXPECT:-0}" -lt 39; then
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_expect_next_at_least_39"
  exit 1
fi
LEDGER=$(sh tools/fixtures/reds_ledger_scan.sh)
echo "$LEDGER"
echo "$LEDGER" | rg -q '^verdict=ok$' || {
  echo "reds_row=failed"
  echo "verdict=misread"
  exit 1
}
echo "reds_row=honored"
echo "reds_row_n=38"
echo "reds_rows_living=${ROWS}"
echo "reds_law=on_disk_is_not_in_the_tree"

# --- elder e112 still tracked (accrete) ---
git ls-files --error-unmatch "$ELDER" >/dev/null 2>&1 || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"
echo "elder_seat=e112"

# --- seat 128 reserved ---
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

# --- surface census six (e119 ch5+ch6 tools; elder four is historical) ---
COUNT=$(git ls-files 'tools/gen/season/equinox_ch*_surface_witness.rish' | wc -l | tr -d ' ')
if test "$COUNT" -ne 6; then
  echo "surface_keep=failed"
  echo "verdict=misread"
  echo "detail=want_surface_count_6"
  echo "surface_count=${COUNT}"
  exit 1
fi
echo "surface_keep=honored"
echo "surface_count=6"

# --- almanac through 116 ---
rg -q '^### 116\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "seats_through=116"

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

echo "story=fascia_health_v1>reds_38_on_disk_not_in_tree>128_reserved>census_six>fork_waiting"
echo "e113_fascia_health=ok"
echo "verdict=ok"
