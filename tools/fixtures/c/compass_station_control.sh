#!/bin/sh
# tools/fixtures/c/compass_station_control.sh -- prove the station reading by doing, in a pen.
#
# WHY. A guard that cannot red guards nothing (REDS row 59), and the guard this one stands beside
# spent fourteen days green over the exact fault it was named for (REDS %467). So every refusal is
# shown by planting it, every welcome is asserted as hard as every refusal -- a refusal proven only
# in the passing direction cannot be told from a bypass -- and the pen is proven innocent by
# removing each plant and watching the same pen walk free.
#
# USAGE
#   sh tools/fixtures/c/compass_station_control.sh
#
# Driven by tools/co/compass_rose.rish. Run from the repository root. Nothing here touches the tree.

set -u

scan=$(pwd)/tools/fixtures/c/compass_station_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

check() { # name expected_verdict actual_output
  _name=$1; _want=$2; _got=$3
  if printf '%s\n' "$_got" | grep -q "^verdict=$_want$"; then
    pass=$((pass + 1)); echo "ok: $_name -- verdict=$_want"
  else
    fail=$((fail + 1)); echo "FAILED: $_name -- wanted verdict=$_want, got:"; printf '%s\n' "$_got" | sed 's/^/    /'
  fi
}

check_reading() { # name key=value actual_output
  _name=$1; _want=$2; _got=$3
  if printf '%s\n' "$_got" | grep -q "^$_want$"; then
    pass=$((pass + 1)); echo "ok: $_name -- $_want"
  else
    fail=$((fail + 1)); echo "FAILED: $_name -- wanted $_want, got:"; printf '%s\n' "$_got" | sed 's/^/    /'
  fi
}

# A pen tree: the two directories a root walk needs, plus a rose and the pages it names.
build() { # dir
  d=$1
  mkdir -p "$d/rishi/bin" "$d/tools/fixtures" "$d/foundations" "$d/construction" "$d/context"
  for f in foundations/README.md foundations/grain.md context/TWO_ROOMS.md \
           construction/ITINERARY.md construction/LADDER.md construction/ORDER.md; do
    printf '# a page that carries a reading\n\n**Status:** Living\n\nbody\n' > "$d/$f"
  done
  cat > "$d/foundations/rose.md" <<'ROSE'
# Follow Our Compass

## The compass rose (read order)

1. **Foundations** -- [`foundations/README.md`](README.md): why beneath the work.
2. **Grain index** -- [`foundations/grain.md`](grain.md): ten strands.
3. **Two rooms** -- [`context/TWO_ROOMS.md`](../context/TWO_ROOMS.md): checkable vs proposed.
4. **Ladder** -- [`construction/LADDER.md`](../construction/LADDER.md): newest first.
5. **Now** -- [`construction/ITINERARY.md`](../construction/ITINERARY.md): the live front.
6. **Order** -- [`construction/ORDER.md`](../construction/ORDER.md): why and season.

## When the compass disagrees with enthusiasm

- not a station, and never counted as one.
ROSE
}

run_scan() { sh "$scan" --root "$1" --rose foundations/rose.md 2>&1; }

# 1 -- the honest tree walks free.
build "$pen/clean"
out=$(run_scan "$pen/clean"); check "clean rose" ok "$out"
check_reading "clean rose counts six stations" "stations=6" "$out"
check_reading "clean rose has no pointer" "stations_pointer=0" "$out"

# 2 -- a station that forwards instead of reading. The fault that actually happened.
build "$pen/stub"
printf '# Order -- fused\n\n**Status:** Pointer -- the living content moved to ITINERARY.md\n' \
  > "$pen/stub/construction/ORDER.md"
out=$(run_scan "$pen/stub"); check "a station is a pointer stub" station_empty "$out"
check_reading "the stub is counted" "stations_pointer=1" "$out"
# ...and the pen is innocent: give the station its reading back and the same pen walks free.
printf '# Order\n\n**Status:** Living\n\nbody\n' > "$pen/stub/construction/ORDER.md"
out=$(run_scan "$pen/stub"); check "same pen, plant removed" ok "$out"

# 3 -- two stubs at once, which is exactly what the tree carried for fourteen days.
build "$pen/two"
for f in construction/ORDER.md construction/ITINERARY.md; do
  printf '# fused\n\n**Status:** Pointer -- moved\n' > "$pen/two/$f"
done
out=$(run_scan "$pen/two"); check "two stations forward" station_empty "$out"
check_reading "both are counted" "stations_pointer=2" "$out"

# 4 -- a station whose file is gone. The older, louder failure the elder guard could see.
build "$pen/gone"
rm -f "$pen/gone/construction/LADDER.md"
out=$(run_scan "$pen/gone"); check "a station file is absent" station_empty "$out"
check_reading "the absence is counted" "stations_missing=1" "$out"

# 5 -- the rose itself is gone. A guard whose subject left must say so rather than pass.
build "$pen/norose"
rm -f "$pen/norose/foundations/rose.md"
out=$(run_scan "$pen/norose"); check "the rose document is absent" rose_missing "$out"

# 6 -- the section exists and names no step. A walk with no steps is not a green walk.
build "$pen/empty"
printf '# Follow Our Compass\n\n## The compass rose (read order)\n\nprose, no numbered station.\n' \
  > "$pen/empty/foundations/rose.md"
out=$(run_scan "$pen/empty"); check "the rose names no station" no_stations "$out"

# 7 -- past the bound. Every collection names a maximum, and the maximum is checked.
build "$pen/over"
{ printf '# Follow Our Compass\n\n## The compass rose (read order)\n\n'
  i=1; while [ "$i" -le 33 ]; do printf '%d. **Step** -- [`README.md`](README.md): a step.\n' "$i"; i=$((i + 1)); done
} > "$pen/over/foundations/rose.md"
out=$(run_scan "$pen/over"); check "past the station bound" stations_over_bound "$out"

# 8 -- a station naming a URL or an anchor is legitimate and unreadable from here: reported, free.
build "$pen/nonfile"
sed 's|(\.\./construction/ORDER\.md)|(https://example.invalid/order)|' \
  "$pen/nonfile/foundations/rose.md" > "$pen/nonfile/foundations/rose.tmp"
cat "$pen/nonfile/foundations/rose.tmp" > "$pen/nonfile/foundations/rose.md"
rm -f "$pen/nonfile/foundations/rose.tmp"
out=$(run_scan "$pen/nonfile"); check "a URL station" ok "$out"
check_reading "the URL is reported, never gated" "stations_nonfile=1" "$out"

# 9 -- a station pointing at a section of a living page keeps its anchor and still reads.
build "$pen/anchor"
sed 's|(\.\./construction/ITINERARY\.md)|(../construction/ITINERARY.md#now)|' \
  "$pen/anchor/foundations/rose.md" > "$pen/anchor/foundations/rose.tmp"
cat "$pen/anchor/foundations/rose.tmp" > "$pen/anchor/foundations/rose.md"
rm -f "$pen/anchor/foundations/rose.tmp"
out=$(run_scan "$pen/anchor"); check "a station with an anchor" ok "$out"

# 10 -- the declaration is a line a person writes, so the reading is case-insensitive.
build "$pen/case"
printf '# Order\n\n**status:** pointer -- moved\n' > "$pen/case/construction/ORDER.md"
out=$(run_scan "$pen/case"); check "a lowercased declaration" station_empty "$out"

# 11 -- the word elsewhere in a living page is not a declaration. A guard that reds on prose about
# pointers would be turned off within a week.
build "$pen/prose"
printf '# Order\n\n**Status:** Living\n\nThis page explains what a Pointer stub is.\n' \
  > "$pen/prose/construction/ORDER.md"
out=$(run_scan "$pen/prose"); check "the word in prose, not in the Status line" ok "$out"

echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=behaviors_unproven" >&2
exit 1
