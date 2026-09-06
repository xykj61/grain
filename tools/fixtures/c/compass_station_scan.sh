#!/bin/sh
# tools/fixtures/c/compass_station_scan.sh -- a station of the rose must carry the reading it names.
#
# WHY. On 20260823.103804 commit 98a8ee481 fused three cards into construction/ITINERARY.md.
# construction/TASKS.md and construction/ROADMAP.md stayed on disk as POINTER STUBS -- each
# declaring `**Status:** Pointer` on its own face -- because roughly thirty equinox_e* fixtures and
# tools/co/compass_rose.rish read them, and a guard reading a file that is gone reports green while
# measuring nothing. So the paths kept resolving and the content left. For fourteen days the compass
# rose, this tree's own return habit and the aether row's cardinal seat, sent a reader to those two
# stubs to learn the now and the order, and six living surfaces repeated it -- including the
# cold-start compressor docs/COMPASS.md and the unattended loop's own route. Nothing could see it:
# every standing link check asks whether a link RESOLVES, and a pointer stub resolves. The QA card
# read this document's Truth at 100 for exactly that reason. The guard named for the rose asked
# `test -f` on both paths and printed GREEN, which is the cheaper question wearing the answer of the
# expensive one (REDS %467; the family is %458).
#
# WHAT IS GATED, hard, both at zero.
#   stations_missing -- a numbered station of the rose whose file is absent.
#   stations_pointer -- a numbered station whose file declares itself a pointer stub. A station is
#   a promise that a reading lives there; a redirect is not that reading, and a reader walking the
#   rose to recover direction is the reader least able to absorb one.
#
# WHAT IS REPORTED, never gated. stations_nonfile -- a station naming an anchor or a URL rather than
# a path in this tree. Those are legitimate and unreadable from here.
#
# WHAT IS NOT PROVEN. That a station's file says anything WORTH reading, or that the rose names the
# right six stations. Only that each station this document sends a reader to still holds a reading
# rather than a forwarding address.
#
# USAGE
#   sh tools/fixtures/c/compass_station_scan.sh [--root DIR] [--rose PATH-RELATIVE-TO-ROOT]
#
# Driven by tools/co/compass_rose.rish. Run from the repository root.

set -u

# Root by upward walk (seated 20260828): the letter fold moved fixtures one directory deeper, and
# fixed ../.. depth arithmetic is what broke. Bounded at 8 steps, loud past the bound.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done

root=$_fd_root
rose=foundations/20260826-024943_follow-our-compass.md

# --root lets the control point the SAME code path at a pen, so what ships is what is proven.
while [ $# -gt 0 ]; do
  case "$1" in
    --root) [ $# -ge 2 ] || { echo "$0: --root needs a directory" >&2; exit 2; }
            root=$2; shift 2 ;;
    --rose) [ $# -ge 2 ] || { echo "$0: --rose needs a path" >&2; exit 2; }
            rose=$2; shift 2 ;;
    *) echo "$0: unknown argument $1" >&2; exit 2 ;;
  esac
done

rose_path=$root/$rose
if [ ! -f "$rose_path" ]; then
  echo "rose=$rose"
  echo "verdict=rose_missing"
  echo "refused: the compass rose document is not at $rose_path" >&2
  exit 1
fi

# The station's link is relative to the rose document's own directory, so that is where a station
# path is resolved from.
rose_dir=$(dirname "$rose_path")

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# Every collection names a maximum. A rose a reader can hold is a short list; 32 is well past the
# six it has carried since 20260706 and far under anything that would read as a walk.
max_stations=32

# The stations are the numbered list inside the rose section: `N. **Name** -- [`x`](target): ...`.
# Read the FIRST markdown link target on each such line -- the station's own door.
awk '
  /^## The compass rose/ { in_rose = 1; next }
  in_rose && /^## / { in_rose = 0 }
  in_rose && /^[0-9]+\./ {
    line = $0
    if (match(line, /\]\([^)]*\)/)) {
      target = substr(line, RSTART + 2, RLENGTH - 3)
      print target
    }
  }
' "$rose_path" > "$work/targets.txt"

stations=$(wc -l < "$work/targets.txt" | tr -d ' ')

if [ "$stations" -gt "$max_stations" ]; then
  echo "rose=$rose"
  echo "stations=$stations"
  echo "max_stations=$max_stations"
  echo "verdict=stations_over_bound"
  echo "refused: the rose declares $stations stations, past the bound of $max_stations" >&2
  exit 1
fi

: > "$work/missing.txt"
: > "$work/pointer.txt"
nonfile=0

while IFS= read -r target; do
  [ -n "$target" ] || continue
  case "$target" in
    ''|'#'*|http://*|https://*|mailto:*) nonfile=$((nonfile + 1)); continue ;;
  esac
  # Strip a trailing anchor: a station may point at a section of a living page.
  file=${target%%#*}
  [ -n "$file" ] || { nonfile=$((nonfile + 1)); continue; }
  if [ ! -f "$rose_dir/$file" ]; then
    echo "$target" >> "$work/missing.txt"
    continue
  fi
  # A stub declares itself. The fusion left both elders saying so on their own face, which is the
  # honest shape -- so the guard reads the declaration rather than guessing from size or age.
  if grep -qiE '^\*\*Status:\*\*[[:space:]]*Pointer' "$rose_dir/$file"; then
    echo "$target" >> "$work/pointer.txt"
  fi
done < "$work/targets.txt"

missing=$(wc -l < "$work/missing.txt" | tr -d ' ')
pointer=$(wc -l < "$work/pointer.txt" | tr -d ' ')

echo "rose=$rose"
echo "stations=$stations"
echo "max_stations=$max_stations"
echo "stations_nonfile=$nonfile"
echo "stations_missing=$missing"
echo "stations_pointer=$pointer"

[ "$missing" -eq 0 ] || sed 's/^/missing: /' "$work/missing.txt"
[ "$pointer" -eq 0 ] || sed 's/^/pointer: /' "$work/pointer.txt"

if [ "$stations" -eq 0 ]; then
  echo "verdict=no_stations"
  echo "refused: the rose section names no numbered station -- the walk has no steps" >&2
  exit 1
fi

if [ "$missing" -eq 0 ] && [ "$pointer" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=station_empty"
echo "refused: a station of the rose forwards rather than reads -- see the lines above" >&2
exit 1
