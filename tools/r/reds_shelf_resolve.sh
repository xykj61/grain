#!/bin/sh
# tools/r/reds_shelf_resolve.sh -- resolve a REDS fold-shelf citation to the shelf holding
# those rows TODAY, when the shelf has since been renamed.
#
# WHY THIS FILE EXISTS. A REDS fold shelf is named REDS-<title>-rows-<N>.md, and a later refold
# RENAMES it -- absorbing the row into a wider range, or retitling the same rows. That is a
# BREACH in this tree's own vocabulary (foundations/20260818-081438_the-three-depths-of-removal.md):
# a rename the present forgets and the past remembers. Living citers repoint; dated testimony
# keeps every word it wrote, and accrete-never-break forbids rewriting it. So every elder
# citation of the departed basename resolves nowhere, permanently, by law.
#
# Measured 20260916 over the whole tree: 574 distinct shelf basenames are cited and 99 of them
# exist on no path. RUN tools/fixtures/r/reds_shelf_resolve_scan.sh rather than trusting those
# two figures -- both are FREE, and the missing count RISES on every ordinary refold.
#
# WHY NO STANDING RESOLVER REACHED THEM. tools/d/dated_path_resolve.rish computes a day
# directory out of a one-clock stamp, and a REDS shelf basename carries no stamp at all.
# tools/f/fold_shelf_link_scan.sh reads link DEPTH from inside a shelf rather than a renamed
# target. Neither can answer this question, so it had no answer.
#
# THE KEY, and it is the derived spine's own (.claude/rules/derived-spine.md): the shelf's TITLE
# is a view and its ROW NUMBERS are the identity. A refold may retitle freely; it may not move a
# published row off its number. So this resolver reads the row headlines standing on disk today
# -- `**REDS %N (`stamp`) -- ...` at the head of a line -- and answers from them.
#
#   sh tools/r/reds_shelf_resolve.sh REDS-a-borrowed-scope-rows-396.md
#   sh tools/r/reds_shelf_resolve.sh %501
#   sh tools/r/reds_shelf_resolve.sh construction/archive/REDS-...-rows-512.md
#   sh tools/r/reds_shelf_resolve.sh --map > /tmp/m   # emit the row map, resolve nothing
#   REDS_SHELF_MAP=/tmp/m sh tools/r/reds_shelf_resolve.sh %501   # reuse it
#
# WHY THE MAP IS REUSABLE. Building it costs a read of all 489 shelves, and the census beside
# this file resolves a hundred references in a row. A caller that built its OWN map would be a
# second reader of one question, which is the drift %768 booked one room over -- so the resolver
# both EMITS the map and ACCEPTS it back, and there stays exactly one builder.
#
# VERDICTS, weakest first:
#   missing          -- no shelf and no pin carries a headline for any requested row.
#   ambiguous        -- a requested row stands in MORE THAN ONE shelf, so no answer is safe.
#                       Nine rows read this way today, %512 and %530 among them: the published
#                       doubles the derived-spine law names and no lap may repair.
#   split            -- the requested rows resolved, to different shelves. A refold absorbed
#                       part of the range; every holder is named.
#   living-pin       -- the rows have yet to fold; they stand on construction/REDS.md.
#   recovered-by-rows-- the cited basename is gone and its rows resolve to exactly one shelf.
#                       This is the whole point of the file.
#   home             -- the cited basename exists on disk. Nothing was renamed.
#
# Exit 0 when every requested row resolved to a named holder (home, recovered-by-rows,
# living-pin, split) - 1 when any row is ambiguous or missing, since a reader must choose -
# 2 on misuse. A misuse exits DIFFERENTLY from an unresolvable reference, so a caller never
# reads a broken invocation as a clean recovery.
set -eu

# Every collection names a maximum (TAME). 4,096 is an order of magnitude above the 489 shelves
# standing today and far below anything a shell sort would labour over.
MAX_SHELVES=4096

SHELF_GLOB=${REDS_SHELF_GLOB:-construction/archive/REDS-*.md}
PIN=${REDS_PIN:-construction/REDS.md}

usage() {
  echo "usage: reds_shelf_resolve.sh <shelf-basename|path|%N|N>" >&2
  exit 2
}

[ $# -eq 1 ] || usage
ref=$1
[ -n "$ref" ] || usage

build_map() {
  shelf_count=0
  for f in $SHELF_GLOB; do
    [ -f "$f" ] || continue
    shelf_count=$((shelf_count + 1))
    if [ "$shelf_count" -gt "$MAX_SHELVES" ]; then
      echo "reds_shelf_resolve: shelf count above MAX_SHELVES=$MAX_SHELVES" >&2
      exit 2
    fi
    grep -oE '^\*\*REDS %[0-9]+' "$f" 2>/dev/null \
      | grep -oE '[0-9]+' \
      | sed "s|\$| $f|" || true
  done
  if [ -f "$PIN" ]; then
    grep -oE '^\*\*REDS %[0-9]+' "$PIN" 2>/dev/null \
      | grep -oE '[0-9]+' \
      | sed "s|\$| $PIN|" || true
  fi
  echo "shelves_read $shelf_count" 
}

if [ "$ref" = "--map" ]; then
  build_map | sort -u
  exit 0
fi

base=${ref##*/}

# Parse the reference into the row numbers it names. A shelf basename spells its range as
# -rows-<first>[-<last>]; a bare reference spells one row. Taking the literal numbers present
# is what keeps this a pure function of the name -- a range's interior is never guessed at,
# because a shelf is free to hold only some of the rows its title spans (REDS-...-rows-701-704
# holds %701 and %704 and nothing between).
kind=""
rows=""
case "$base" in
  REDS-*-rows-*.md)
    kind=shelf
    tail=${base%.md}
    tail=${tail##*-rows-}
    case "$tail" in
      *[!0-9-]*) usage ;;
    esac
    rows=$(echo "$tail" | tr '-' ' ')
    ;;
  *)
    n=${base#%}
    case "$n" in
      ''|*[!0-9]*) usage ;;
    esac
    kind=row
    rows=$n
    ;;
esac
[ -n "$rows" ] || usage

# The map, built once: every row headline standing on disk today, paired with the file holding
# it. The pattern anchors at line start and takes the whole run of digits, so %52 can never be
# read out of %520 -- the same boundary lesson the dated-path census learned (stamp-and-name).
map=$(mktemp) || exit 2
trap 'rm -f "$map"' EXIT INT TERM

if [ -n "${REDS_SHELF_MAP:-}" ]; then
  [ -f "$REDS_SHELF_MAP" ] || { echo "reds_shelf_resolve: map unreadable: $REDS_SHELF_MAP" >&2; exit 2; }
  cp "$REDS_SHELF_MAP" "$map"
else
  build_map | sort -u > "$map"
fi
shelf_count=$(awk '$1 == "shelves_read" { print $2 }' "$map")
[ -n "$shelf_count" ] || shelf_count=0

echo "reference=$ref"
echo "kind=$kind"
echo "rows=$(echo $rows)"
echo "shelves_read=$shelf_count"

# A cited basename that still stands needs no recovery at all, and saying so plainly is what
# keeps an ordinary citation cheap.
home_path=""
if [ "$kind" = shelf ]; then
  for f in $SHELF_GLOB; do
    [ -f "$f" ] || continue
    [ "${f##*/}" = "$base" ] || continue
    home_path=$f
    break
  done
fi

holders=""
unresolved=0
ambiguous=0
for r in $rows; do
  hits=$(awk -v want="$r" '$1 == want { print $2 }' "$map" | sort -u)
  count=$(printf '%s' "$hits" | grep -c . || true)
  if [ "$count" -eq 0 ]; then
    echo "row=$r holders=0"
    unresolved=$((unresolved + 1))
    continue
  fi
  if [ "$count" -gt 1 ]; then
    ambiguous=$((ambiguous + 1))
  fi
  echo "row=$r holders=$count"
  for h in $hits; do
    echo "holder=$h"
    holders="$holders $h"
  done
done

distinct=$(printf '%s\n' $holders | grep -c . || true)
distinct=$(printf '%s\n' $holders | sort -u | grep -c . || true)

# The verdict, written weakest first so each stronger reading overwrites it -- the shape the
# sibling resolver at tools/d/dated_path_resolve.rish already uses, kept so a reader who knows
# one knows both.
verdict=missing
if [ "$distinct" -gt 0 ]; then verdict=split; fi
if [ "$distinct" -eq 1 ]; then
  only=$(printf '%s\n' $holders | sort -u)
  if [ "$only" = "$PIN" ]; then verdict=living-pin; else verdict=recovered-by-rows; fi
fi
if [ "$ambiguous" -gt 0 ]; then verdict=ambiguous; fi
if [ -n "$home_path" ]; then verdict=home; fi

echo "unresolved_rows=$unresolved"
echo "ambiguous_rows=$ambiguous"
echo "holders_distinct=$distinct"
echo "verdict=$verdict"

case "$verdict" in
  home|recovered-by-rows|living-pin|split) exit 0 ;;
  *) exit 1 ;;
esac
