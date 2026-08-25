#!/bin/sh
# Thing-not-name scan -- find values by emission, not by filename.
# Exit 0 only when the planted emitter's value is found while its name is absent
# from tracked paths, and both living fascia-health roofs emit their keys.
# No backtick characters in patterns.
#
#   sh tools/fixtures/thing_not_name_scan.sh           # living green
#   sh tools/fixtures/thing_not_name_scan.sh prove-red  # must exit 1
#
# Law: look for the thing, not for the name of the thing.
# Faces: wrong set (REDS 34) - wrong place (REDS 38) - wrong key (REDS 39).
set -eu

MODE=${1:-}
EMITTER=tools/fixtures/thing_not_name_emitter.sh
SHED=tools/fixtures/shed_census_scan.sh
HEALTH=tools/fixtures/fascia_health_scan.sh
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

# --- presence: git ls-files only ---
for p in "$EMITTER" "$SHED" "$HEALTH"; do
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

# prove-red: declare the meter homeless because no filename matches the key
if test "$MODE" = "prove-red"; then
  echo "name_hits_demo_meter=0"
  echo "search_mode=filename_only"
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=RED_looked_for_name_not_thing"
  echo "detail=filename_search_declared_homeless"
  echo "census=withheld"
  echo "demo_meter=withheld"
  exit 1
fi

# --- planted: value present, name absent from tracked paths ---
EMIT_OUT=$(sh "$EMITTER")
echo "$EMIT_OUT" | sed 's/^/emit_/'
echo "$EMIT_OUT" | rg -q '^demo_meter=7$' || {
  echo "planted_value=failed"
  echo "verdict=misread"
  echo "detail=want_demo_meter_7"
  echo "census=withheld"
  exit 1
}
echo "planted_value=honored"
echo "demo_meter=7"

NAME_HITS=$(git ls-files -z | tr '\0' '\n' | rg -c 'demo_meter' || true)
NAME_HITS=${NAME_HITS:-0}
if test "$NAME_HITS" -ne 0; then
  echo "planted_name_absent=failed"
  echo "name_hits_demo_meter=${NAME_HITS}"
  echo "verdict=misread"
  echo "detail=planted_emitter_must_not_carry_key_in_path"
  echo "census=withheld"
  exit 1
fi
echo "planted_name_absent=honored"
echo "name_hits_demo_meter=0"
echo "controls: value found · name absent - lesson released"

# --- living roofs: shed emits fascia_health_now; standalone emits fascia_health ---
SHED_OUT=$(sh "$SHED")
echo "$SHED_OUT" | rg -q '^fascia_health_now=[0-9]+$' || {
  echo "shed_roof=failed"
  echo "verdict=misread"
  echo "detail=want_fascia_health_now_emitted"
  echo "census=withheld"
  exit 1
}
SHED_VAL=$(printf '%s\n' "$SHED_OUT" | sed -n 's/^fascia_health_now=//p' | head -1)
echo "shed_roof=honored"
echo "shed_key=fascia_health_now"
echo "shed_fascia_health_now=${SHED_VAL}"

HEALTH_OUT=$(sh "$HEALTH")
echo "$HEALTH_OUT" | rg -q '^fascia_health=[0-9]+$' || {
  echo "health_roof=failed"
  echo "verdict=misread"
  echo "detail=want_fascia_health_emitted"
  echo "census=withheld"
  exit 1
}
HEALTH_VAL=$(printf '%s\n' "$HEALTH_OUT" | sed -n 's/^fascia_health=//p' | head -1)
echo "health_roof=honored"
echo "health_key=fascia_health"
echo "health_fascia_health=${HEALTH_VAL}"

# Filename-only search for fascia_health* finds the standalone roof, never shed.
NAME_HEALTH=$(git ls-files -z | tr '\0' '\n' | rg -c 'fascia_health' || true)
NAME_HEALTH=${NAME_HEALTH:-0}
if test "$NAME_HEALTH" -lt 1; then
  echo "name_inventory=failed"
  echo "verdict=misread"
  echo "detail=want_some_fascia_health_names_after_e113"
  exit 1
fi
# shed path must NOT match the fascia_health filename token
case "$SHED" in
  *fascia_health*)
    echo "shed_name=failed"
    echo "verdict=misread"
    echo "detail=shed_must_keep_distinct_filename"
    exit 1
    ;;
esac
echo "roofs=2"
echo "roof_note=shed_emits_now_key · standalone_emits_fascia_health · names_miss_shed"
echo "law=look_for_the_thing_not_the_name"
echo "shred=RED"
echo "thing_not_name_scan=ok"
echo "verdict=ok"
exit 0
