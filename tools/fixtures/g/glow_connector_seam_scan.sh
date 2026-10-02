#!/bin/sh
# tools/fixtures/g/glow_connector_seam_scan.sh -- Glow source never speaks Wayland C.
# Orchestrated by tools/gen/chapter/glow_connector_seam_witness.rish and its negative sibling.
#
#   sh tools/fixtures/g/glow_connector_seam_scan.sh [root]
#
# Why this exists: glow_connector_seam_witness.rish's own hop 5 check had the count inlined --
# `rg -l 'wayland-client.h' src --glob '*.glow'` -- spelled once, in one file, with no way to
# prove the refusal bites short of planting a leak in a live Glow source. Pulled out here with a
# root argument, the positive leg reads the live `src` tree and the negative leg reads
# context/fixtures/glow_connector_seam_leak/, a standing fixture holding one planted reference, so
# the refusal is observed on every run and no tracked Glow source is ever made to hold the
# violation.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
set -eu
root="${1:-src}"
[ -d "$root" ] || { echo "root=$root"; echo "verdict=missing_root"; exit 2; }
hits=$(rg -l 'wayland-client.h' "$root" --glob '*.glow' 2>/dev/null || true)
count=0
for f in $hits; do
  count=$((count + 1))
  echo "detail: leak $f"
done
echo "root=$root"
echo "leak_count=$count"
if [ "$count" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
else
  echo "verdict=leak"
  exit 1
fi
