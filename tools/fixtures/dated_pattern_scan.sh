#!/bin/sh
# Dated-pattern scan -- one definition, planted both ways.
# Exit 0 only when controls honor and the shared classifier speaks.
# No backtick characters in patterns.
#
#   sh tools/fixtures/dated_pattern_scan.sh           # living green
#   sh tools/fixtures/dated_pattern_scan.sh prove-red  # must exit 1
#
# Law: when two roofs carry one name, either they agree or the name is doing two jobs.
# Canon: context/specs/living-vs-dated.md
set -eu

MODE=${1:-}
# Living mutant: the classifier now speaks Rishi (Python -> Rishi molt 20260809).
CLASSIFY=tools/fixtures/dated_classify.rish
RISH="rishi/bin/rishi run"
LAW=context/specs/living-vs-dated.md
LIVE=tools/fixtures/fascia_health_live_control.md
DATED=tools/fixtures/20260731-150648_fascia_health_dated_control.md
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

for p in "$CLASSIFY" "$LAW" "$LIVE" "$DATED"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    if test -f "$p"; then
      echo "presence=on_disk_untracked"
      echo "verdict=misread"
      echo "detail=on_disk_is_not_in_the_tree"
      echo "detail_path=$p"
      echo "census=withheld"
      exit 1
    fi
    echo "presence=absent"
    echo "verdict=misread"
    echo "detail=control_absent"
    echo "detail_path=$p"
    echo "census=withheld"
    exit 1
  }
done
echo "tracked_instruments=honored"

# prove-red: claim a live control is dated (too harsh) without running classify
if test "$MODE" = "prove-red"; then
  echo "C_live=dated"
  echo "C_dated=dated"
  echo "search_mode=claim_without_classifier"
  echo "verdict=misread"
  echo "detail=RED_dated_definition_blind"
  echo "census=withheld"
  exit 1
fi

C_LIVE=$($RISH "$CLASSIFY" classify "$LIVE")
C_DATED=$($RISH "$CLASSIFY" classify "$DATED")
echo "C_live=${C_LIVE}"
echo "C_dated=${C_DATED}"

if test "$C_LIVE" != "live"; then
  echo "controls_honored=0"
  echo "verdict=misread"
  echo "detail=RED_live-control"
  echo "census=withheld"
  exit 1
fi
if test "$C_DATED" != "dated"; then
  echo "controls_honored=0"
  echo "verdict=misread"
  echo "detail=RED_dated-control"
  echo "census=withheld"
  exit 1
fi
echo "controls_honored=2"
echo "controls: 2 of 2 honored - definition released"

# Law file must name the living header and dated stamp shape
rg -qi 'living ledger' "$LAW" || {
  echo "law=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'YYYYMMDD-HHMMSS' "$LAW" || {
  echo "law=failed"
  echo "verdict=misread"
  exit 1
}
echo "law=honored"
echo "law_path=${LAW}"

CENSUS=$($RISH "$CLASSIFY" census)
echo "$CENSUS" | sed 's/^/shared_/'
echo "$CENSUS" | rg -q '^verdict=ok$' || {
  echo "census=failed"
  echo "verdict=misread"
  exit 1
}

echo "definition=one"
echo "shred=RED"
echo "law_line=when_two_roofs_carry_one_name_they_agree_or_the_name_does_two_jobs"
echo "dated_pattern_scan=ok"
echo "verdict=ok"
exit 0
