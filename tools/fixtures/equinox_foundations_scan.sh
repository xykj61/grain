#!/bin/sh
# tools/fixtures/equinox_foundations_scan.sh -- foundations join the equinox map.
# Orchestrated by tools/gen/season/equinox_foundations_witness.rish.
set -eu
f="${1:-context/equinox_foundations.brix}"
map="${2:-context/equinox_map.brix}"
[ -f "$f" ] || { echo "verdict=missing_descriptor"; exit 2; }
[ -f "$map" ] || { echo "verdict=missing_map"; exit 2; }

faults=0
houses=""
foundations=""
angulars=""
# per-equinox house lists (space-separated, discovery order)
ha=""; hb=""; hc=""; hd=""
cur_h=""; cur_eq=""; cur_role=""; cur_fnd=""

flush() {
  if [ -z "$cur_h" ] || [ -z "$cur_eq" ] || [ -z "$cur_role" ] || [ -z "$cur_fnd" ]; then
    echo "detail: incomplete house block"
    faults=$((faults + 1))
    return
  fi
  houses="$houses $cur_h"
  foundations="$foundations $cur_fnd"
  case "$cur_role" in
    angular)
      case "$cur_h" in
        1|4|7|10) angulars="$angulars $cur_h" ;;
        *) echo "detail: angular role on non-kendra house $cur_h"; faults=$((faults + 1)) ;;
      esac
      ;;
    flank)
      case "$cur_h" in
        1|4|7|10) echo "detail: flank role on kendra house $cur_h"; faults=$((faults + 1)) ;;
      esac
      ;;
    *) echo "detail: bad role $cur_role"; faults=$((faults + 1)) ;;
  esac
  case "$cur_eq" in
    A) ha="$ha $cur_h" ;;
    B) hb="$hb $cur_h" ;;
    C) hc="$hc $cur_h" ;;
    D) hd="$hd $cur_h" ;;
    *) echo "detail: bad equinox $cur_eq"; faults=$((faults + 1)) ;;
  esac
}

while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    ''|'#'*) continue ;;
  esac
  key=${line%% *}
  val=${line#* }
  if [ "$key" = "$line" ]; then
    echo "detail: field without value -> $line"
    faults=$((faults + 1))
    continue
  fi
  case "$key" in
    house)
      if [ -n "$cur_h" ]; then flush; fi
      cur_h="$val"; cur_eq=""; cur_role=""; cur_fnd=""
      ;;
    equinox) cur_eq="$val" ;;
    role) cur_role="$val" ;;
    foundation) cur_fnd="$val" ;;
    kind|name|count) ;;
  esac
done < "$f"
if [ -n "$cur_h" ]; then flush; fi

# 1) houses 1..12 exactly once
sorted=$(printf '%s\n' $houses | sort -n | tr '\n' ' ' | sed 's/ *$//')
if [ "$sorted" != "1 2 3 4 5 6 7 8 9 10 11 12" ]; then
  echo "detail: houses not exact 1..12 once -> [$sorted]"
  faults=$((faults + 1))
fi

# 2) twelve distinct foundations
fn=$(printf '%s\n' $foundations | sort -u | wc -l | tr -d ' ')
ft=$(printf '%s\n' $foundations | wc -l | tr -d ' ')
if [ "$fn" != "12" ] || [ "$ft" != "12" ]; then
  echo "detail: want 12 distinct foundations got unique=$fn total=$ft"
  faults=$((faults + 1))
fi

# 3) three houses per equinox
count_words() { printf '%s\n' $1 | grep -c . || true; }
na=$(count_words "$ha"); nb=$(count_words "$hb"); nc=$(count_words "$hc"); nd=$(count_words "$hd")
if [ "$na" != "3" ] || [ "$nb" != "3" ] || [ "$nc" != "3" ] || [ "$nd" != "3" ]; then
  echo "detail: want 3 houses per equinox got A=$na B=$nb C=$nc D=$nd"
  faults=$((faults + 1))
fi

# 4) angular set = kendras
as=$(printf '%s\n' $angulars | sort -n | tr '\n' ' ' | sed 's/ *$//')
if [ "$as" != "1 4 7 10" ]; then
  echo "detail: angular set not kendras -> [$as]"
  faults=$((faults + 1))
fi

# 5) join map flanks -- sorted equality (order in foundations file is flank order, but compare as sets via sort)
map_flank() {
  # extract "flank X Y Z" for equinox $1 from map file
  awk -v eq="$1" '
    $1=="equinox" { cur=$2 }
    $1=="flank" && cur==eq { print $2,$3,$4; exit }
  ' "$map"
}
join_one() {
  eq="$1"; got="$2"
  want=$(map_flank "$eq")
  gs=$(printf '%s\n' $got | sort -n | tr '\n' ' ' | sed 's/ *$//')
  ws=$(printf '%s\n' $want | sort -n | tr '\n' ' ' | sed 's/ *$//')
  if [ "$gs" != "$ws" ]; then
    echo "detail: equinox $eq houses [$gs] != map flank [$ws]"
    faults=$((faults + 1))
  fi
}
join_one A "$ha"
join_one B "$hb"
join_one C "$hc"
join_one D "$hd"

# 6) required angular foundations present
for req in tame_guidance accrete_never_break propose_never_seat simple_lovable_complete; do
  printf '%s\n' $foundations | grep -qx "$req" || {
    echo "detail: angular foundation missing -> $req"
    faults=$((faults + 1))
  }
done

echo "houses=$(printf '%s' "$sorted" | tr ' ' '\n' | grep -c . || true)"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then echo "verdict=ok"; exit 0; else echo "verdict=foundations_unlawful"; exit 1; fi
