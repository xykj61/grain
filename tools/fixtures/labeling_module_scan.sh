#!/bin/sh
# tools/fixtures/labeling_module_scan.sh — CION guard for module living surfaces.
#
# Scans the given files for a bare count-up ordinal standing as a capability's
# IDENTITY — "lap <N>" — the pattern the chronological-semantic labeling law
# (context/specs/20260810-222755_..., addendum 20260811.130827) retired for module
# READMEs and authored .rye/.brix doc-comments. A capability's living name is its
# semantic label plus its stamp ("object-storage backing · 20260811"), never a bare
# lap ordinal.
#
# NOT scanned here, on purpose: session logs and dated specs are testimony and keep
# the ordinals they recorded (the law governs living surfaces, never history).
#
# Refined 20260811.140623 (the comlink survey): the pattern matches only a BARE lap
# ordinal, and deliberately NOT the meaningful schemes the law permits —
#   * a structured code, where the digit continues into the identifier: "lap 3w-3b",
#     "lap 3w-4", "lap 4b" (a level/revision, the R2/R3 case) — a word char or hyphen
#     right after the digits, so the negative lookahead (?![-\w]) skips it;
#   * "sub-lap N", a hyphen-joined compound, skipped by the negative lookbehind
#     (?<![-\w]).
# A genuine bare "lap 2" riding beside a code ("OA-L3 lap 2") IS still flagged — the
# code is meaningful, the bare ordinal beside it is not. Needs PCRE (grep -P).
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md.
set -eu
ordinal='(?<![-\w])lap [0-9]+(?![-\w])'
fail=0
for f in "$@"; do
  if [ ! -f "$f" ]; then echo "detail: absent ($f)"; fail=$((fail + 1)); continue; fi
  h=$(grep -cPi "$ordinal" "$f" 2>/dev/null || true)
  echo "file=$f lap_ordinal=$h"
  if [ "$h" -gt 0 ]; then
    echo "detail: drifted ($f) names a capability by a bare lap ordinal"
    fail=$((fail + 1))
  fi
done
echo "drift=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=drift"; exit 1
