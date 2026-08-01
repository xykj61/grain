#!/bin/sh
# amphora_bounds_agree_scan.sh — shared vessel bounds must agree across roofs.
#
# Discovers every `pub const <name>: <type> = <n>;` for the three shared names
# under AMPHORA_BOUNDS_ROOT (default: amphora). Hardcodes no declaration count.
# Exit 0 when every name that appears has one type and one value.
# Exit 1 when two roofs disagree (or a name is absent when ROOT is living amphora).
#
#   sh tools/fixtures/amphora_bounds_agree_scan.sh
#   AMPHORA_BOUNDS_ROOT=tools/fixtures/amphora_bounds_plants/agree \
#     sh tools/fixtures/amphora_bounds_agree_scan.sh
#   AMPHORA_BOUNDS_ROOT=tools/fixtures/amphora_bounds_plants/disagree \
#     sh tools/fixtures/amphora_bounds_agree_scan.sh
#
# Law: when two roofs carry one name, either they agree or the name is doing
# two jobs (REDS 40). Three roofs is the same law, louder.
set -eu

ROOT=${AMPHORA_BOUNDS_ROOT:-amphora}
NAMES="max_vessel_len max_cargo digest_hex_len"
FAIL=0

if ! test -d "$ROOT"; then
  echo "verdict=misread"
  echo "detail=root_absent"
  echo "detail_root=$ROOT"
  exit 1
fi

echo "root=$ROOT"

for name in $NAMES; do
  TMP=$(mktemp)
  # rg may exit 1 on no match — do not fail the shell under set -e.
  rg -n --no-heading -g '*.rye' \
    "^pub const ${name}: (u[0-9]+) = ([0-9]+);" "$ROOT" 2>/dev/null \
    | grep -Ev '^[^:]+:[0-9]+:[[:space:]]*//' \
    >"$TMP" || true

  COUNT=$(wc -l <"$TMP" | tr -d ' ')
  echo "bound_${name}_declarations=${COUNT}"

  if [ "$COUNT" -eq 0 ]; then
    # Living amphora must carry each shared name; plant trees may test one name.
    if [ "$ROOT" = "amphora" ]; then
      echo "bound_${name}_status=absent"
      FAIL=1
    else
      echo "bound_${name}_status=skipped"
    fi
    rm -f "$TMP"
    continue
  fi

  SIGS=$(sed -E "s/^[^:]+:[0-9]+:pub const ${name}: (u[0-9]+) = ([0-9]+);/\\1=\\2/" "$TMP" | sort -u)
  SIG_COUNT=$(printf '%s\n' "$SIGS" | sed '/^$/d' | wc -l | tr -d ' ')
  echo "bound_${name}_signatures=${SIG_COUNT}"
  echo "bound_${name}_values=$(printf '%s\n' "$SIGS" | sed '/^$/d' | paste -sd, -)"

  if [ "$SIG_COUNT" -ne 1 ]; then
    echo "bound_${name}_status=diverge"
    FAIL=1
  else
    echo "bound_${name}_status=agree"
  fi
  rm -f "$TMP"
done

if [ "$FAIL" -ne 0 ]; then
  echo "verdict=misread"
  echo "detail=shared_bounds_diverge_or_absent"
  exit 1
fi

echo "verdict=ok"
echo "detail=shared_bounds_agree"
exit 0
