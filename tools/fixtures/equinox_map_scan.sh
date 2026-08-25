#!/bin/sh
# tools/fixtures/equinox_map_scan.sh -- equinox map canon is lawful and complete.
# Orchestrated by tools/gen/season/equinox_map_witness.rish.
#
# Output: key=value - detail: - verdict= - status agrees with exit.
# Readable by splitLines + first-space split -- no grammar.
set -eu
f="${1:-context/equinox_map.brix}"
[ -f "$f" ] || { echo "verdict=missing_descriptor"; exit 2; }

blocks=0
faults=0
flanks=""
elements=""
directions=""
hours=""
angulars=""
cur_ang=""
cur_flank=""

flush_block() {
  if [ -z "$cur_ang" ] || [ -z "$cur_flank" ]; then
    echo "detail: incomplete equinox block"
    faults=$((faults + 1))
    return
  fi
  # flank: three space-separated houses - middle equals angular
  set -- $cur_flank
  if [ "$#" -ne 3 ]; then
    echo "detail: flank must be three houses -> $cur_flank"
    faults=$((faults + 1))
    return
  fi
  a="$1"; b="$2"; c="$3"
  if [ "$b" != "$cur_ang" ]; then
    echo "detail: angular not middle of flank -> angular=$cur_ang flank=$cur_flank"
    faults=$((faults + 1))
  fi
  # descending contiguous: angular+1, angular, angular-1 (A wraps 2 1 12)
  plus=$((cur_ang + 1))
  if [ "$plus" -gt 12 ]; then plus=1; fi
  minus=$((cur_ang - 1))
  if [ "$minus" -lt 1 ]; then minus=12; fi
  if [ "$a" != "$plus" ] || [ "$c" != "$minus" ]; then
    echo "detail: flank not descending angular+1,angular,angular-1 -> flank=$cur_flank angular=$cur_ang"
    faults=$((faults + 1))
  fi
  flanks="$flanks $a $b $c"
  angulars="$angulars $cur_ang"
}

while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    ''|'#'*) continue ;;
  esac
  key=${line%% *}
  val=${line#* }
  if [ "$key" = "$line" ]; then
    echo "detail: field without a value -> $line"
    faults=$((faults + 1))
    continue
  fi
  case "$line" in
    *'  '*) echo "detail: more than one space after key -> $key"; faults=$((faults + 1)) ;;
  esac
  case "$key" in
    equinox)
      if [ -n "$cur_ang" ] || [ -n "$cur_flank" ]; then
        flush_block
      fi
      blocks=$((blocks + 1))
      cur_ang=""
      cur_flank=""
      ;;
    angular) cur_ang="$val" ;;
    flank) cur_flank="$val" ;;
    element) elements="$elements $val" ;;
    direction) directions="$directions $val" ;;
    hour) hours="$hours $val" ;;
    kind|name|count|h10_north_reason) ;;
    *) ;;
  esac
done < "$f"

if [ -n "$cur_ang" ] || [ -n "$cur_flank" ]; then
  flush_block
fi

# 1) four blocks
if [ "$blocks" -ne 4 ]; then
  echo "detail: block count want 4 got $blocks"
  faults=$((faults + 1))
fi

# 2) flanks cover 1..12 exactly once -- sort and compare
sorted=$(printf '%s\n' $flanks | sort -n | tr '\n' ' ' | sed 's/ *$//')
want="1 2 3 4 5 6 7 8 9 10 11 12"
if [ "$sorted" != "$want" ]; then
  echo "detail: flank houses not exact 1..12 once -> got [$sorted]"
  faults=$((faults + 1))
fi

# 3-5) elements, directions, hours each complete (sort compare)
es=$(printf '%s\n' $elements | sort | tr '\n' ' ' | sed 's/ *$//')
if [ "$es" != "air earth fire water" ]; then
  echo "detail: elements incomplete -> [$es]"
  faults=$((faults + 1))
fi
ds=$(printf '%s\n' $directions | sort | tr '\n' ' ' | sed 's/ *$//')
if [ "$ds" != "east north south west" ]; then
  echo "detail: directions incomplete -> [$ds]"
  faults=$((faults + 1))
fi
hs=$(printf '%s\n' $hours | sort | tr '\n' ' ' | sed 's/ *$//')
if [ "$hs" != "dawn dusk midnight noon" ]; then
  echo "detail: hours incomplete -> [$hs]"
  faults=$((faults + 1))
fi

# 6) angular set = kendras {1,4,7,10}
as=$(printf '%s\n' $angulars | sort -n | tr '\n' ' ' | sed 's/ *$//')
if [ "$as" != "1 4 7 10" ]; then
  echo "detail: angular set not kendras 1 4 7 10 -> [$as]"
  faults=$((faults + 1))
fi

# H10-north reason must be present (closes the ask forever beside the rule)
grep -q '^h10_north_reason ' "$f" || {
  echo "detail: h10_north_reason key absent"
  faults=$((faults + 1))
}

echo "blocks=$blocks"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then echo "verdict=ok"; exit 0; else echo "verdict=map_unlawful"; exit 1; fi
