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

# --- 1. a seated pin the docs roster lacks is named -----------------------------------------
# The whole of REDS %396 in miniature: construction/REDS.md stood at 99.9% of its bound, on the
# roster the law names and absent from the roster this duty walked.
pen a
docs_roster a docs/front.md
seated a construction/REDS.md
page a docs/front.md 100
page a construction/REDS.md 24000
o=$(run a)
check seated_pin_named yes "$(said "$o" 'living-pin-near construction/REDS.md')"

# --- 2. the same pin, with the union line reverted, goes silent -------------------------------
# The plant is one line: the loop reads the docs roster alone, exactly as it did before this repair.
pen b
docs_roster b docs/front.md
seated b construction/REDS.md
page b docs/front.md 100
page b construction/REDS.md 24000
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
page c glow/README.md 24100
o=$(run c)
check docs_page_still_named yes "$(said "$o" 'living-pin-near glow/README.md')"

# --- 4. one pin past bound and another near: BOTH lists print ---------------------------------
pen d
docs_roster d docs/front.md
seated d construction/REDS.md
seated d construction/SHRED_PREP.md
page d docs/front.md 100
page d construction/REDS.md 25616
page d construction/SHRED_PREP.md 24000
o=$(run d)
check over_bound_named yes "$(said "$o" 'living-pin-bytes construction/REDS.md')"
check near_printed_beside_over yes "$(said "$o" 'living-pin-near construction/SHRED_PREP.md')"

# --- 5. the same pen, with the near list hung back off the over list, goes silent -------------
pen e
docs_roster e docs/front.md
seated e construction/REDS.md
seated e construction/SHRED_PREP.md
page e docs/front.md 100
page e construction/REDS.md 25616
page e construction/SHRED_PREP.md 24000
sed 's|^if \[ -s "$TMP/d6near" \]; then$|if [ ! -s "$TMP/d6" ] \&\& [ -s "$TMP/d6near" ]; then|' \
  "$PEN/e/tools/fixtures/l/living_docs_lint_scan.sh" >"$PEN/e/plant" \
  && cat "$PEN/e/plant" >"$PEN/e/tools/fixtures/l/living_docs_lint_scan.sh"
o=$(run e)
check near_silent_when_hung_off_over no "$(said "$o" 'living-pin-near construction/SHRED_PREP.md')"

# --- 6. a page carrying its own bound is advised against ITS number ---------------------------
# session-logs/README.md is bounded at 57,344 by the law's own exception line. At 52,000 it is past
# 90% of that and well past the general bound, and the advisory must name 57344.
pen f
docs_roster f session-logs/README.md
page f session-logs/README.md 52000
o=$(run f)
check own_bound_in_message yes "$(said "$o" '52000 of 57344')"

# --- 7. the same page, comfortably under ITS bound, says nothing -------------------------------
# 24,000 is 97% of the general bound and 41% of this page's own, so a duty reading the general
# number here would advise about a page with 33,344 bytes to spare.
pen g
docs_roster g session-logs/README.md
page g session-logs/README.md 24000
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
