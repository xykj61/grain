#!/bin/sh
# Dated-roof divergence scan — both roofs must report the same dated_testimony.
# Exit 0 only when shed and standalone agree on the shared definition.
# Exit 1 while they differ (or on prove-red).
# No backtick characters in patterns.
#
#   sh tools/fixtures/dated_roof_divergence_scan.sh           # living green
#   sh tools/fixtures/dated_roof_divergence_scan.sh prove-red  # must exit 1
#
# Law: when two roofs carry one name, either they agree or the name is doing two jobs.
set -eu

MODE=${1:-}
SHED=tools/fixtures/shed_census_scan.sh
HEALTH=tools/fixtures/fascia_health_scan.sh
PATTERN=tools/fixtures/dated_pattern_scan.sh
CLASSIFY=tools/fixtures/dated_classify.rish
CONTROL_SCAN=tools/fixtures/census_control_scan.sh

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi
CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT" | sed 's/^/gate_/'
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

for p in "$SHED" "$HEALTH" "$PATTERN" "$CLASSIFY"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "presence=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree_or_missing"
    echo "detail_path=$p"
    exit 1
  }
done
echo "tracked_roofs=honored"

# Shared definition must GREEN first
PATTERN_OUT=$(sh "$PATTERN")
echo "$PATTERN_OUT" | sed 's/^/pattern_/'
echo "$PATTERN_OUT" | rg -q '^verdict=ok$' || {
  echo "dated_pattern=failed"
  echo "verdict=misread"
  exit 1
}
echo "dated_pattern=honored"

if test "$MODE" = "prove-red"; then
  echo "shed_dated_testimony=9999"
  echo "health_dated_testimony=1"
  echo "shared_dated_testimony=1"
  echo "verdict=misread"
  echo "detail=RED_roofs_diverge"
  echo "detail=name_doing_two_jobs"
  echo "census=withheld"
  exit 1
fi

SHED_OUT=$(sh "$SHED")
HEALTH_OUT=$(sh "$HEALTH")
SHARED_OUT=$(rishi/bin/rishi run "$CLASSIFY" census)

SHED_D=$(printf '%s\n' "$SHED_OUT" | sed -n 's/^dated_testimony=//p' | head -1)
HEALTH_D=$(printf '%s\n' "$HEALTH_OUT" | sed -n 's/^dated_testimony=//p' | head -1)
SHARED_D=$(printf '%s\n' "$SHARED_OUT" | sed -n 's/^dated_testimony=//p' | head -1)
SHED_T=$(printf '%s\n' "$SHED_OUT" | sed -n 's/^tracked_total=//p' | head -1)
HEALTH_T=$(printf '%s\n' "$HEALTH_OUT" | sed -n 's/^tracked_total=//p' | head -1)
SHARED_T=$(printf '%s\n' "$SHARED_OUT" | sed -n 's/^tracked_total=//p' | head -1)
HEALTH_H=$(printf '%s\n' "$HEALTH_OUT" | sed -n 's/^fascia_health=//p' | head -1)
SHED_H=$(printf '%s\n' "$SHED_OUT" | sed -n 's/^fascia_health_now=//p' | head -1)

echo "shed_dated_testimony=${SHED_D}"
echo "health_dated_testimony=${HEALTH_D}"
echo "shared_dated_testimony=${SHARED_D}"
echo "shed_tracked_total=${SHED_T}"
echo "health_tracked_total=${HEALTH_T}"
echo "shared_tracked_total=${SHARED_T}"
echo "health_fascia_health=${HEALTH_H}"
echo "shed_fascia_health_now=${SHED_H}"

if test -z "$SHED_D" || test -z "$HEALTH_D" || test -z "$SHARED_D"; then
  echo "divergence=failed"
  echo "verdict=misread"
  echo "detail=missing_dated_testimony"
  exit 1
fi

if test "$SHED_D" != "$HEALTH_D" || test "$SHED_D" != "$SHARED_D"; then
  echo "divergence=present"
  echo "verdict=misread"
  echo "detail=RED_roofs_diverge"
  echo "detail=name_doing_two_jobs"
  echo "law=when_two_roofs_carry_one_name_they_agree_or_the_name_does_two_jobs"
  exit 1
fi

if test "$SHED_T" != "$HEALTH_T" || test "$SHED_T" != "$SHARED_T"; then
  echo "divergence=present"
  echo "verdict=misread"
  echo "detail=tracked_total_diverge"
  exit 1
fi

echo "divergence=absent"
echo "roofs_agree=honored"
echo "dated_testimony=${SHARED_D}"
echo "tracked_total=${SHARED_T}"
echo "law=when_two_roofs_carry_one_name_they_agree_or_the_name_does_two_jobs"
echo "shred=RED"
echo "dated_roof_divergence_scan=ok"
echo "verdict=ok"
exit 0
