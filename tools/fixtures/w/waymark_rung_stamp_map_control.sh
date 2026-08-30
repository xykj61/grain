#!/bin/sh
# waymark_rung_stamp_map_control.sh -- press the CION map at its history and coverage seams.

set -eu

map=tools/fixtures/w/waymark_rung_stamp_map.tsv
scan=tools/fixtures/w/waymark_rung_stamp_map_scan.sh
mkdir -p .mind-state/tmp
pen_dir=$(mktemp -d .mind-state/tmp/rung-map-control.XXXXXX)
trap 'rm -rf "$pen_dir"' EXIT HUP INT TERM

bad_stamp=$pen_dir/bad-author-stamp.tsv
awk -F '\t' 'BEGIN { OFS="\t" }
  $1 == "ALES" && $2 == "0" { $3="19000101.000000" }
  { print }
' "$map" > "$bad_stamp"
if RUNG_MAP_PATH="$bad_stamp" bash "$scan" > "$pen_dir/bad-stamp.out" 2>&1; then
  echo "author_stamp_refusal=no"
  exit 1
fi
grep -q '^verdict=history$' "$pen_dir/bad-stamp.out"
grep -q '^detail=author_stamp_mismatch ' "$pen_dir/bad-stamp.out"
echo "author_stamp_refusal=yes"

bad_ledger=$pen_dir/bad-ledger.md
awk '
  index($0, "| **STOA" "332**") { sub(/20260724\.145539/, "19000101.000000") }
  { print }
' docs/STOA.md > "$bad_ledger"
if RUNG_STOA_LEDGER="$bad_ledger" bash "$scan" > "$pen_dir/bad-ledger.out" 2>&1; then
  echo "ledger_stamp_refusal=no"
  exit 1
fi
grep -q '^verdict=ledger$' "$pen_dir/bad-ledger.out"
grep -q '^detail=ledger_stamp_mismatch ' "$pen_dir/bad-ledger.out"
echo "ledger_stamp_refusal=yes"

missing=$pen_dir/missing.tsv
awk -F '\t' 'BEGIN { OFS="\t" }
  !($1 == "STOA" && $2 == "346") { print }
' "$map" > "$missing"
if RUNG_MAP_PATH="$missing" bash "$scan" > "$pen_dir/missing.out" 2>&1; then
  echo "coverage_refusal=no"
  exit 1
fi
grep -q '^verdict=coverage$' "$pen_dir/missing.out"
echo "coverage_refusal=yes"

census=$pen_dir/census.tsv
awk -F '\t' 'BEGIN { OFS="\t" }
  $1 == "ALES" && $2 == "1" { $3="CENSUS"; $4="-"; $5="underivable" }
  { print }
' "$map" > "$census"
RUNG_MAP_PATH="$census" bash "$scan" > "$pen_dir/census.out"
grep -q '^resolved_rows=587$' "$pen_dir/census.out"
grep -q '^census_rows=1$' "$pen_dir/census.out"
grep -q '^verdict=ok$' "$pen_dir/census.out"
echo "census_fallback=yes"

# Git launchers may scrub TZ, and a second host may sit on another local clock. The scanner reads
# epochs from Git and performs the one-clock conversion outside it, so the answer is independent of
# the caller's host zone.
TZ=Pacific/Honolulu bash "$scan" > "$pen_dir/host-zone.out"
grep -q '^resolved_rows=588$' "$pen_dir/host-zone.out"
grep -q '^verdict=ok$' "$pen_dir/host-zone.out"
echo "one_clock_host_independent=yes"
echo "control_verdict=ok"
