#!/bin/sh
# tools/fixtures/s/sunn_source_thickness_scan.sh -- refuse a thin SOURCE front door.
# Orchestrated by tools/gen/chapter/sunn14_witness_choir.rish.
#
# Usage:
#   sh tools/fixtures/s/sunn_source_thickness_scan.sh [path]
# Default path: SOURCE.md
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
set -eu
path="${1:-SOURCE.md}"
min_bytes=20000
min_lines=300
fail=0

if [ ! -f "$path" ]; then
  echo "detail: absent $path"
  echo "bytes=0"
  echo "lines=0"
  echo "verdict=absent"
  exit 1
fi

bytes=$(wc -c < "$path" | tr -d ' ')
lines=$(wc -l < "$path" | tr -d ' ')
echo "bytes=$bytes"
echo "lines=$lines"
echo "min_bytes=$min_bytes"
echo "min_lines=$min_lines"
echo "path=$path"

if [ "$bytes" -lt "$min_bytes" ]; then
  echo "detail: thin bytes $bytes < $min_bytes"
  fail=$((fail + 1))
fi
if [ "$lines" -lt "$min_lines" ]; then
  echo "detail: thin lines $lines < $min_lines"
  fail=$((fail + 1))
fi

check() {
  needle="$1"
  label="$2"
  # Fixed-string: markdown stars must not become regex quantifiers.
  if grep -Fq "$needle" "$path"; then
    echo "detail: ok $label"
  else
    echo "detail: missing $label ($needle)"
    fail=$((fail + 1))
  fi
}

# TWO CHECKS FOLLOW THE ONE-PAGE DECISION (`20260908.183744`, Keaton's grant). `7191a938b` made one
# README serve BOTH repositories and the onboarding page followed it, so SOURCE teaches the PUBLIC
# clone a newcomer can actually take, and the maintainer's name lives where naming it is the point --
# `context/PUBKEYS.md` and the LICENSE files. Requiring a personal name in a page that ships to the
# public seed asks the scrub and this scan to disagree forever. Neither check was ever heard: nothing
# in the roster ran the witness that drives this scan.
check "grain-os/grain" "public clone route"
check "standing writing voice is **Kyri**" "kyri writing"
check "dual-push" "dual-push"
check "**Waymark:** **SUNN**" "sunn waymark"
check "fifth OS variant" "quin os hat"
check "Q-vane" "q-vane"

echo "drift=$fail"
if [ "$fail" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
if [ "$bytes" -lt "$min_bytes" ] || [ "$lines" -lt "$min_lines" ]; then
  echo "verdict=thin"
else
  echo "verdict=drift"
fi
exit 1
