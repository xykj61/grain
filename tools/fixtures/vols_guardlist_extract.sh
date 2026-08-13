#!/bin/sh
# tools/fixtures/vols_guardlist_extract.sh — VOLS survey, the guarded-file list, derived.
#
#   sh tools/fixtures/vols_guardlist_extract.sh <guard-witness>
#
# Prints, one per line, the living surfaces the CION module labeling guard actually
# scans — extracted from the guard witness's own labeling_module_scan.sh invocation, so
# "guarded" is DERIVED from the guard in force, never hand-copied beside it. VOLS-J13r2
# classifies each survey site against this list to name the gap set (sites no guard yet
# watches). Output convention: context/specs/20260729-215600_scan-seam-convention.md,
# here the plain list is the payload — one path per line, no key=value framing.
set -eu

if [ "$#" -ne 1 ]; then
  echo "detail: usage — vols_guardlist_extract.sh <guard-witness>" 1>&2
  exit 2
fi
guard=$1
if [ ! -f "$guard" ]; then
  echo "detail: absent guard witness ($guard)" 1>&2
  exit 2
fi

# The guard invokes labeling_module_scan.sh with every scanned file as a quoted arg on
# one line; pull that line, split on quotes, keep the living-surface paths.
grep -oE 'labeling_module_scan.sh"[^]]*' "$guard" \
  | head -1 \
  | tr '"' '\n' \
  | grep -E '\.(rye|md|brix)$' \
  | sort -u
