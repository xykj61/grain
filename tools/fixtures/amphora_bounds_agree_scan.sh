#!/bin/sh
# amphora_bounds_agree_scan.sh — shared Amphora bounds must agree across roofs.
#
# (1) Same-name roofs: every `pub const <name>` / `const <name>` for
#     max_vessel_len · max_cargo · digest_hex_len must share one type=value.
# (2) Alias value groups (e147): differently named ceilings that mean one
#     quantity must share one numeric value (width may differ):
#       cargo_ceiling  — max_resin_bytes · max_seal_plain · max_cargo_bytes
#       datagram       — max_wire_payload · max_chunk_datagram
#
# Hardcodes no declaration count. Discovers under AMPHORA_BOUNDS_ROOT
# (default: amphora).
#
#   sh tools/fixtures/amphora_bounds_agree_scan.sh
#   AMPHORA_BOUNDS_ROOT=tools/fixtures/amphora_bounds_plants/agree sh …
#
# Law: when two roofs carry one name, either they agree or the name is doing
# two jobs (REDS 40). Three roofs — and three names for one number — louder.
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

# Collect matching const lines for one identifier into TMP (path:line:text).
collect_name() {
  name=$1
  out=$2
  rg -n --no-heading -g '*.rye' \
    "^(pub )?const ${name}: (u[0-9]+) = ([0-9]+);" "$ROOT" 2>/dev/null \
    | grep -Ev '^[^:]+:[0-9]+:[[:space:]]*//' \
    >"$out" || true
}

for name in $NAMES; do
  TMP=$(mktemp)
  collect_name "$name" "$TMP"

  COUNT=$(wc -l <"$TMP" | tr -d ' ')
  echo "bound_${name}_declarations=${COUNT}"

  if [ "$COUNT" -eq 0 ]; then
    if [ "$ROOT" = "amphora" ]; then
      echo "bound_${name}_status=absent"
      FAIL=1
    else
      echo "bound_${name}_status=skipped"
    fi
    rm -f "$TMP"
    continue
  fi

  SIGS=$(sed -E "s/^[^:]+:[0-9]+:(pub )?const ${name}: (u[0-9]+) = ([0-9]+);/\\2=\\3/" "$TMP" | sort -u)
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

# Alias value groups — same number under different names (width free).
# Format: group_label:name1,name2,name3
ALIAS_GROUPS="cargo_ceiling:max_resin_bytes,max_seal_plain,max_cargo_bytes datagram:max_wire_payload,max_chunk_datagram"

for group in $ALIAS_GROUPS; do
  label=${group%%:*}
  names=${group#*:}
  VALS=$(mktemp)
  : >"$VALS"
  FOUND=0
  OLDIFS=$IFS
  IFS=,
  for name in $names; do
    TMP=$(mktemp)
    collect_name "$name" "$TMP"
    N=$(wc -l <"$TMP" | tr -d ' ')
    if [ "$N" -gt 0 ]; then
      FOUND=$((FOUND + N))
      sed -E "s/^[^:]+:[0-9]+:(pub )?const ${name}: (u[0-9]+) = ([0-9]+);/\\3/" "$TMP" >>"$VALS"
    fi
    rm -f "$TMP"
  done
  IFS=$OLDIFS

  echo "alias_${label}_declarations=${FOUND}"
  if [ "$FOUND" -eq 0 ]; then
    echo "alias_${label}_status=skipped"
    rm -f "$VALS"
    continue
  fi
  if [ "$FOUND" -lt 2 ]; then
    # A single declaration cannot diverge with itself; living amphora should
    # eventually carry the full group — require >=2 when ROOT is amphora.
    if [ "$ROOT" = "amphora" ]; then
      echo "alias_${label}_status=thin"
      FAIL=1
    else
      echo "alias_${label}_status=skipped"
    fi
    rm -f "$VALS"
    continue
  fi

  UNIQ=$(sort -u "$VALS" | sed '/^$/d' | wc -l | tr -d ' ')
  echo "alias_${label}_signatures=${UNIQ}"
  echo "alias_${label}_values=$(sort -u "$VALS" | sed '/^$/d' | paste -sd, -)"
  if [ "$UNIQ" -ne 1 ]; then
    echo "alias_${label}_status=diverge"
    FAIL=1
  else
    echo "alias_${label}_status=agree"
  fi
  rm -f "$VALS"
done

if [ "$FAIL" -ne 0 ]; then
  echo "verdict=misread"
  echo "detail=shared_bounds_diverge_or_absent"
  exit 1
fi

echo "verdict=ok"
echo "detail=shared_bounds_agree"
exit 0
