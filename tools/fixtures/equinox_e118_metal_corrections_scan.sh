#!/bin/sh
# Equinox e118 -- metal corrections: roofs CLOSED - stale Cloud-blocked retired.
# Exit 0 only when control reads and correction limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e118_metal_corrections_scan.sh
#   sh tools/fixtures/equinox_e118_metal_corrections_scan.sh prove-red
#
# Law: when two roofs carry one name, either they agree or the name does two jobs.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
DIVERGE=tools/fixtures/dated_roof_divergence_scan.sh
COUNSEL=counsel/date/20260731/20260731-172902_e118-metal-corrections.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
ELDER=tools/gen/season/equinox_e117_fork_extend_breach_close_witness.rish
CLASSIFY=tools/fixtures/dated_classify.py

if test "$MODE" = "prove-red"; then
  echo "roofs=diverge"
  echo "detail=RED_claimed_diverge_while_agree"
  echo "census=withheld"
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
echo "control_gate=honored"

for p in "$COUNSEL" "$MAP" "$ITINERARY" "$PRIN" "$ELDER" "$CLASSIFY" "$DIVERGE"; do
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

DIV_OUT=$(sh "$DIVERGE")
echo "$DIV_OUT" | sed 's/^/div_/'
echo "$DIV_OUT" | rg -q '^verdict=ok$' || {
  echo "roofs=failed"
  echo "verdict=misread"
  exit 1
}
echo "$DIV_OUT" | rg -q '^divergence=absent$' || {
  echo "roofs=failed"
  echo "verdict=misread"
  echo "detail=want_divergence_absent"
  exit 1
}
echo "$DIV_OUT" | rg -q '^roofs_agree=honored$' || {
  echo "roofs=failed"
  echo "verdict=misread"
  exit 1
}
DT=$(printf '%s\n' "$DIV_OUT" | sed -n 's/^dated_testimony=//p' | head -1)
echo "roofs=honored"
echo "roofs_status=CLOSED"
echo "dated_testimony=${DT}"
echo "job_fascia_health=live_over_total"
echo "job_fascia_health_now=orphan_share"
echo "law=when_two_roofs_carry_one_name_they_agree_or_the_name_does_two_jobs"

rg -qi 'CLOSED|roofs agree|two jobs|orphan-share' "$COUNSEL" || {
  echo "correction=failed"
  echo "verdict=misread"
  echo "detail=want_roofs_closed_in_counsel"
  exit 1
}
rg -qi 're-cut|Cloud-blocked|stale|retire' "$COUNSEL" || {
  echo "correction=failed"
  echo "verdict=misread"
  echo "detail=want_stale_blocked_retired"
  exit 1
}
rg -qi 'roofs.*CLOSED|CLOSED ·|roofs agree CLOSED|two jobs' "$ITINERARY" "$MAP" || {
  echo "correction=failed"
  echo "verdict=misread"
  echo "detail=want_closed_in_living_pins"
  exit 1
}
# Living pins must not carry standing Cloud-blocked debt as current truth
if rg -qi 'Cloud rishi limbs need zig/rye bootstrap' "$ITINERARY" "$PRIN"; then
  echo "correction=failed"
  echo "verdict=misread"
  echo "detail=stale_cloud_blocked_still_standing"
  exit 1
fi
echo "correction=honored"
echo "stale_cloud_blocked=retired"
echo "tool_presence=per_bench_recut"

# Per-bench honesty: report local binary presence without inventing suite green
if test -x rishi/bin/rishi; then
  echo "local_rishi=PRESENT"
else
  echo "local_rishi=ABSENT"
fi
if test -x vendor/zig-toolchain/zig; then
  echo "local_zig=PRESENT"
else
  echo "local_zig=ABSENT"
fi
echo "local_note=binaries_gitignored_each_bench_proves"

git ls-files --error-unmatch "$ELDER" >/dev/null 2>&1 || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"
echo "elder_seat=e117"

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

# surface census six (e119 ch5+ch6 tools; elder four is historical)
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

rg -q '^### 121\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "seats_through=121"

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
echo "fork_word=EXTEND"
echo "handback_status=not_consumed"

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

echo "story=roofs_CLOSED>two_jobs>stale_cloud_blocked_retired>per_bench_recut>128_reserved"
echo "e118_metal_corrections=ok"
echo "verdict=ok"
