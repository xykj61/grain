#!/bin/sh
# amphora_bounds_agree_scan.sh — shared Amphora bounds must agree across roofs.
#
# (1) Same-name roofs: every `pub const <name>` / `const <name>` for
#     max_vessel_len · max_cargo · digest_hex_len must share one type=value.
# (2) Alias value groups (e147): differently named ceilings that mean one
#     quantity must share one numeric value (width may differ):
#       cargo_ceiling  — max_resin_bytes · max_seal_plain · max_cargo_bytes
#       datagram       — max_wire_payload · max_chunk_datagram
# (3) Declared couples (e148): `/// couples: <module>.<name>` above a const
#     must match the partner's VALUE (width free; report widths). Coupling is
#     declared, never inferred — coincidences carry no marker.
#
# Hardcodes no declaration count. Discovers under AMPHORA_BOUNDS_ROOT
# (default: amphora).
#
#   sh tools/fixtures/amphora_bounds_agree_scan.sh
#   AMPHORA_BOUNDS_ROOT=tools/fixtures/amphora_bounds_plants/agree sh …
#
# Law: when two roofs carry one name, either they agree or the name is doing
# two jobs (REDS 40). Three roofs — and three names for one number — louder.
# Coupling must be declared (REDS 56 lean): the number finds coincidences.
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

# Resolve partner module.NAME → first matching const value under ROOT.
# Tries: ROOT/module.rye · ROOT/src/module.rye · ROOT/src/main.rye (module=main).
partner_value() {
  mod=$1
  name=$2
  cand=""
  if test -f "$ROOT/${mod}.rye"; then
    cand="$ROOT/${mod}.rye"
  elif test -f "$ROOT/src/${mod}.rye"; then
    cand="$ROOT/src/${mod}.rye"
  elif [ "$mod" = "main" ] && test -f "$ROOT/src/main.rye"; then
    cand="$ROOT/src/main.rye"
  fi
  if [ -z "$cand" ]; then
    echo ""
    return 0
  fi
  # Single-file rg prints line:text (no path). Emit type=value only.
  rg --no-heading -N \
    "^(pub )?const ${name}: (u[0-9]+) = ([0-9]+);" "$cand" 2>/dev/null \
    | grep -Ev '^[[:space:]]*//' \
    | head -n1 \
    | sed -E "s/^(pub )?const ${name}: (u[0-9]+) = ([0-9]+);/\\2=\\3/" \
    || true
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

# Declared couples — parse `/// couples: module.name` then the next const.
# Discovers marker count; does not hardcode how many couplings exist.
COUPLE_HITS=$(mktemp)
rg -n --no-heading -g '*.rye' '/// couples: ([a-z0-9_]+)\.([a-z0-9_]+)' "$ROOT" 2>/dev/null \
  >"$COUPLE_HITS" || true
COUPLE_N=$(wc -l <"$COUPLE_HITS" | tr -d ' ')
echo "couples_declarations=${COUPLE_N}"

if [ "$COUPLE_N" -eq 0 ]; then
  if [ "$ROOT" = "amphora" ]; then
    echo "couples_status=absent"
    FAIL=1
  else
    echo "couples_status=skipped"
  fi
else
  COUPLE_FAIL=0
  COUPLE_OK=0
  while IFS= read -r hit; do
    [ -z "$hit" ] && continue
    # path:line:text
    file=${hit%%:*}
    rest=${hit#*:}
    line=${rest%%:*}
    text=${rest#*:}
    partner=$(printf '%s\n' "$text" | sed -E 's/.*\/\/\/ couples: ([a-z0-9_]+)\.([a-z0-9_]+).*/\1.\2/')
    pmod=${partner%%.*}
    pname=${partner#*.}

    # Walk forward from marker line to the next real const in this file.
    SRC_SIG=$(awk -v start="$line" '
      NR > start && /^(pub )?const [a-zA-Z0-9_]+: u[0-9]+ = [0-9]+;/ {
        print; exit
      }
    ' "$file" | sed -E 's/^(pub )?const ([a-zA-Z0-9_]+): (u[0-9]+) = ([0-9]+);/\2:\3=\4/')

    if [ -z "$SRC_SIG" ]; then
      echo "couple_${pmod}_${pname}_status=orphan_marker"
      COUPLE_FAIL=1
      continue
    fi

    src_name=${SRC_SIG%%:*}
    src_tv=${SRC_SIG#*:}
    src_type=${src_tv%%=*}
    src_val=${src_tv#*=}

    DST_SIG=$(partner_value "$pmod" "$pname")
    if [ -z "$DST_SIG" ]; then
      echo "couple_${src_name}_to_${pmod}_${pname}_status=partner_absent"
      echo "couple_${src_name}_to_${pmod}_${pname}_src=${src_type}=${src_val}"
      COUPLE_FAIL=1
      continue
    fi
    dst_type=${DST_SIG%%=*}
    dst_val=${DST_SIG#*=}

    echo "couple_${src_name}_to_${pmod}_${pname}_src=${src_type}=${src_val}"
    echo "couple_${src_name}_to_${pmod}_${pname}_dst=${dst_type}=${dst_val}"
    if [ "$src_val" = "$dst_val" ]; then
      echo "couple_${src_name}_to_${pmod}_${pname}_status=agree"
      if [ "$src_type" != "$dst_type" ]; then
        echo "couple_${src_name}_to_${pmod}_${pname}_width_note=${src_type}_vs_${dst_type}"
      fi
      COUPLE_OK=$((COUPLE_OK + 1))
    else
      echo "couple_${src_name}_to_${pmod}_${pname}_status=diverge"
      COUPLE_FAIL=1
    fi
  done <"$COUPLE_HITS"

  echo "couples_agree_count=${COUPLE_OK}"
  if [ "$COUPLE_FAIL" -ne 0 ]; then
    echo "couples_status=diverge"
    FAIL=1
  else
    echo "couples_status=agree"
  fi
fi
rm -f "$COUPLE_HITS"

if [ "$FAIL" -ne 0 ]; then
  echo "verdict=misread"
  echo "detail=shared_bounds_diverge_or_absent"
  exit 1
fi

echo "verdict=ok"
echo "detail=shared_bounds_agree"
exit 0
