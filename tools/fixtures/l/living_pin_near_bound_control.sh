#!/bin/sh
# tools/fixtures/l/living_pin_near_bound_control.sh -- duty 6's pin reading, proven from both sides.
#
# WHY. A reading proven only in the direction where it speaks cannot be told from a reading that
# speaks about the wrong set. This pen builds real directory trees holding a real bound law, a real
# seated pin roster, and a real docs roster, plants one shape at a time, and asks
# tools/fixtures/l/living_docs_lint_scan.sh what duty 6 says -- so every page the duty is meant to
# name is shown named, and each of the two faults this control was written for is shown from the
# side where the reading goes quiet.
#
# THE TWO FAULTS, both measured on 20260831 before the repair. Duty 6 walked its own 60-page docs
# roster while reading the bound from the seated law, so four of the seven pins on
# tools/fixtures/l/living_pin_guard_roster.txt were never weighed here -- among them
# construction/REDS.md, which had shipped 1,040 bytes over its bound that morning (REDS %395) and
# stood at 99.9% of it while the duty advised about two other pages. And the near list hung off an
# `elif`, so it printed only while nothing was past bound: the moment one pin crossed, every pin
# about to follow it went silent.
#
# Cases 1 and 2 are that first fault from both sides -- the union names a seated pin the docs roster
# lacks, and the same pen with the union line reverted says nothing about it. Cases 4 and 5 are the
# second the same way. Case 6 holds the message honest: a page carrying its own bound is advised
# against ITS number rather than the general one.
#
# Each case prints one line naming what was planted and what the duty said. The tally at the end is
# what tools/l/living_pin_near_bound_witness.rish asserts on.
#
# Run from the repository root:  sh tools/fixtures/l/living_pin_near_bound_control.sh
set -eu

ROOT=$(pwd)
SCAN_SRC="$ROOT/tools/fixtures/l/living_docs_lint_scan.sh"
BOUND_SRC="$ROOT/tools/fixtures/l/living_pin_max_bytes.sh"
LAW_SRC="$ROOT/context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md"
KEEPS_SRC="$ROOT/tools/fixtures/l/living_docs_lint_keeps.txt"

for f in "$SCAN_SRC" "$BOUND_SRC" "$LAW_SRC"; do
  [ -f "$f" ] || { echo "control: refused -- $f is missing; run from the repository root" >&2; exit 2; }
done

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

# THE PLANTS ARE SIZED FROM THE LAW, never spelled. Every case below plants a page that is NEAR its
# bound, or OVER it, or comfortably UNDER it -- and each of those words names a RATIO rather than a
# number. Spelled as absolutes, they were true of the law as it stood the day they were written and
# false the morning it moved: on 20260906 the pin law seated
# living_pin_max_bytes[construction/REDS.md] at 40,960, and three of this pen's nine checks failed
# at once, because 24,000 bytes had been 97.6% of that page's bound and became 58.6% of it. Nothing
# was wrong with the scan; the pen was testing a snapshot of the law rather than the law. A pen that
# plants a ratio keeps testing the relationship it names, whatever the law says next.
#
# Read through the same fixture every meter reads -- tools/fixtures/l/living_pin_max_bytes.sh, one
# reading and one home since REDS %199 -- and asked per page, since a page carrying its own seated
# exception is weighed against ITS number by the duty under test.
GENERAL_BOUND=$(sh "$BOUND_SRC")
REDS_BOUND=$(sh "$BOUND_SRC" construction/REDS.md)
LOGS_BOUND=$(sh "$BOUND_SRC" session-logs/README.md)

# near_of <bound> -- a size the duty reads as NEAR: at or over 90% of the bound, and under it.
# 95% sits clear of both edges, so neither a rounding step nor a small future change to the near
# line turns a plant into the case beside it.
near_of() { echo $(( $1 * 95 / 100 )); }

# over_of <bound> -- a size past the bound by the 1,040 bytes construction/REDS.md actually shipped
# over on 20260831 (REDS %395), which is the instance case 4 is built from.
over_of() { echo $(( $1 + 1040 )); }

REDS_NEAR=$(near_of "$REDS_BOUND")
REDS_OVER=$(over_of "$REDS_BOUND")
GENERAL_NEAR=$(near_of "$GENERAL_BOUND")
LOGS_NEAR=$(near_of "$LOGS_BOUND")

fail=0
n=0

# pen <name> -- a tree root the scan's own upward walk resolves: rishi/bin and tools/fixtures are
# what it looks for, and neither needs to hold anything. Copies rather than symlinks, so a planted
# scan in one case can never reach the tree or another case.
pen() {
  d="$PEN/$1"
  rm -rf "$d"
  mkdir -p "$d/rishi/bin" "$d/tools/fixtures/l" "$d/context/specs"
  cp "$SCAN_SRC" "$d/tools/fixtures/l/living_docs_lint_scan.sh"
  cp "$BOUND_SRC" "$d/tools/fixtures/l/living_pin_max_bytes.sh"
  cp "$LAW_SRC" "$d/context/specs/"
  [ -f "$KEEPS_SRC" ] && cp "$KEEPS_SRC" "$d/tools/fixtures/l/" || :
  : >"$d/tools/fixtures/l/living_pin_guard_roster.txt"
  printf '#!/bin/sh\n' >"$d/tools/fixtures/l/living_docs_lint_roster.sh"
}

# docs_roster <pen> <path>... -- the pages duty 6 already watched before the union.
docs_roster() {
  d="$PEN/$1"
  shift
  {
    printf '#!/bin/sh\n'
    for p in "$@"; do printf 'echo %s\n' "$p"; done
  } >"$d/tools/fixtures/l/living_docs_lint_roster.sh"
}

# seated <pen> <path> -- one row of the pin roster the law names.
seated() {
  d="$PEN/$1"
  printf '%s\t200\tx\tenforce\n' "$2" >>"$d/tools/fixtures/l/living_pin_guard_roster.txt"
}

# page <pen> <path> <bytes> -- a page of exactly that size.
page() {
  d="$PEN/$1"
  mkdir -p "$d/$(dirname "$2")"
  head -c "$3" /dev/zero | tr '\0' 'x' >"$d/$2"
}

# run <pen> -- duty 6's lines, and nothing else.
run() {
  ( cd "$PEN/$1" && sh tools/fixtures/l/living_docs_lint_scan.sh 2>/dev/null | grep 'duty6' || true )
}

# check <label> <expected yes|no> <actual yes|no>
check() {
  n=$((n + 1))
  if [ "$2" = "$3" ]; then
    echo "$1=$3"
  else
    echo "$1=$3 EXPECTED=$2"
    fail=$((fail + 1))
  fi
}

# said <output> <needle> -- yes when the duty named it.
said() {
  case "$1" in
    *"$2"*) echo yes ;;
    *) echo no ;;
  esac
}

# --- 0. the plants agree with the law they were sized from ------------------------------------
# THE READING THIS PEN OWES ITSELF. Every case below depends on three sizes landing in the right
# band, and until this check existed that dependence was silent: when the law moved on 20260906 the
# pen answered with three failed cases naming symptoms -- `seated_pin_named=no`, `over_bound_named=no`,
# `near_silent_when_hung_off_over=yes` -- and none of them said the plants had gone stale. A pen that
# states its own preconditions fails at the precondition and names the cause in one line.
plants_agree=yes
[ "$REDS_NEAR" -ge $((REDS_BOUND * 90 / 100)) ] || plants_agree=no
[ "$REDS_NEAR" -le "$REDS_BOUND" ] || plants_agree=no
[ "$REDS_OVER" -gt "$REDS_BOUND" ] || plants_agree=no
[ "$GENERAL_NEAR" -ge $((GENERAL_BOUND * 90 / 100)) ] || plants_agree=no
[ "$GENERAL_NEAR" -le "$GENERAL_BOUND" ] || plants_agree=no
[ "$LOGS_NEAR" -ge $((LOGS_BOUND * 90 / 100)) ] || plants_agree=no
[ "$LOGS_NEAR" -le "$LOGS_BOUND" ] || plants_agree=no
# Case 7 wants one page in two bands at once: near by the general reading, nowhere near its own.
[ "$GENERAL_NEAR" -ge $((GENERAL_BOUND * 90 / 100)) ] || plants_agree=no
[ "$GENERAL_NEAR" -lt $((LOGS_BOUND * 90 / 100)) ] || plants_agree=no
check plants_agree_with_law yes "$plants_agree"

# --- 1. a seated pin the docs roster lacks is named -----------------------------------------
# The whole of REDS %396 in miniature: construction/REDS.md stood at 99.9% of its bound, on the
# roster the law names and absent from the roster this duty walked.
pen a
docs_roster a docs/front.md
seated a construction/REDS.md
page a docs/front.md 100
page a construction/REDS.md "$REDS_NEAR"
o=$(run a)
check seated_pin_named yes "$(said "$o" 'living-pin-near construction/REDS.md')"

# --- 2. the same pin, with the union line reverted, goes silent -------------------------------
# The plant is one line: the loop reads the docs roster alone, exactly as it did before this repair.
pen b
docs_roster b docs/front.md
seated b construction/REDS.md
page b docs/front.md 100
page b construction/REDS.md "$REDS_NEAR"
sed 's|done <"$TMP/d6roster"|done <"$ROSTER"|' \
  "$PEN/b/tools/fixtures/l/living_docs_lint_scan.sh" >"$PEN/b/plant" \
  && cat "$PEN/b/plant" >"$PEN/b/tools/fixtures/l/living_docs_lint_scan.sh"
o=$(run b)
check seated_pin_silent_without_union no "$(said "$o" 'living-pin-near construction/REDS.md')"

# --- 3. a docs page absent from the seated roster is still named ------------------------------
# glow/README.md is bounded by the law and stands on no seated roster row; the union must add
# without taking away.
pen c
docs_roster c glow/README.md
page c glow/README.md "$GENERAL_NEAR"
o=$(run c)
check docs_page_still_named yes "$(said "$o" 'living-pin-near glow/README.md')"

# --- 4. one pin past bound and another near: BOTH lists print ---------------------------------
pen d
docs_roster d docs/front.md
seated d construction/REDS.md
seated d construction/SHRED_PREP.md
page d docs/front.md 100
page d construction/REDS.md "$REDS_OVER"
page d construction/SHRED_PREP.md "$GENERAL_NEAR"
o=$(run d)
check over_bound_named yes "$(said "$o" 'living-pin-bytes construction/REDS.md')"
check near_printed_beside_over yes "$(said "$o" 'living-pin-near construction/SHRED_PREP.md')"

# --- 5. the same pen, with the near list hung back off the over list, goes silent -------------
pen e
docs_roster e docs/front.md
seated e construction/REDS.md
seated e construction/SHRED_PREP.md
page e docs/front.md 100
page e construction/REDS.md "$REDS_OVER"
page e construction/SHRED_PREP.md "$GENERAL_NEAR"
sed 's|^if \[ -s "$TMP/d6near" \]; then$|if [ ! -s "$TMP/d6" ] \&\& [ -s "$TMP/d6near" ]; then|' \
  "$PEN/e/tools/fixtures/l/living_docs_lint_scan.sh" >"$PEN/e/plant" \
  && cat "$PEN/e/plant" >"$PEN/e/tools/fixtures/l/living_docs_lint_scan.sh"
o=$(run e)
check near_silent_when_hung_off_over no "$(said "$o" 'living-pin-near construction/SHRED_PREP.md')"

# --- 6. a page carrying its own bound is advised against ITS number ---------------------------
# session-logs/README.md carries a seated exception, so the law answers a larger number for it than
# for any other page. Planted at 95% of THAT number it is near its own bound and far past the
# general one, and the advisory must name the page's own bound rather than the general one.
pen f
docs_roster f session-logs/README.md
page f session-logs/README.md "$LOGS_NEAR"
o=$(run f)
check own_bound_in_message yes "$(said "$o" "$LOGS_NEAR of $LOGS_BOUND")"

# --- 7. the same page, comfortably under ITS bound, says nothing -------------------------------
# The same page at 95% of the GENERAL bound is near by the general reading and nowhere near its own,
# so a duty reading the general number here would advise about a page with room to spare. This is
# case 6 read from the other side: one page, two bounds, and only the page's own is correct.
pen g
docs_roster g session-logs/README.md
page g session-logs/README.md "$GENERAL_NEAR"
o=$(run g)
check own_bound_page_silent no "$(said "$o" 'living-pin-near session-logs/README.md')"

# --- 8. a path on both rosters is weighed once -------------------------------------------------
pen h
docs_roster h construction/ITINERARY.md
seated h construction/ITINERARY.md
page h construction/ITINERARY.md 100
o=$(run h)
check union_dedupes yes "$(said "$o" 'weighed=1 paths')"

echo "control_checks=$n"
echo "control_failures=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; fi
