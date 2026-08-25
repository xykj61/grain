#!/bin/sh
# tools/fixtures/scan_convention_scan.sh -- the convention stays single-homed.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# Voice v6 - slot 6 - galls_law_graduation.
#
# Two reds shaped this scan, both caught by its own first run:
#
# 1. SCOPE. The first version required every scan in tools/fixtures/ to cite the
#    spec, and found 24 -- eighteen of them elders written long before tonight.
#    Demanding they all cite a convention seated this evening is a SWEEP, which
#    breach doctrine refuses outright: passes go on-touch. So the blocking scope
#    is the named roster below -- the scans authored under the convention -- and
#    every elder is an advisory count that joins on touch, never a failure.
#
# 2. SELF-MATCH. The restatement check grepped for a phrase the guard itself must
#    contain in order to search for it, so the guard flagged itself. It now skips
#    its own path by name.
set -eu
# An optional first argument names one extra path to judge, used only by the
# negative fixture so the refusal is observed on every run.
extra="${1:-}"
spec="context/specs/20260729-215600_scan-seam-convention.md"
[ -f "$spec" ] || { echo "verdict=missing_spec"; exit 2; }
self="tools/fixtures/scan_convention_scan.sh"

# Blocking roster: scans authored under this convention.
roster="tools/fixtures/bounds_typed_scan.sh
tools/fixtures/copy_sameness_scan.sh
tools/fixtures/counsel_flow_scan.sh
tools/fixtures/dep_crawl_scan.sh
tools/fixtures/voice_roster_scan.sh"

kept=0
citing=0
restating=0
for f in $roster; do
  kept=$((kept + 1))
  if grep -q "20260729-215600_scan-seam-convention.md" "$f"; then
    citing=$((citing + 1))
  else
    echo "detail: roster scan does not cite the single home -> $f"
  fi
  if grep -q 'nothing else on the line' "$f"; then
    echo "detail: restates instead of citing -> $f"
    restating=$((restating + 1))
  fi
done

if [ -n "$extra" ]; then
  kept=$((kept + 1))
  grep -q "20260729-215600_scan-seam-convention.md" "$extra" && citing=$((citing + 1)) \
    || echo "detail: roster scan does not cite the single home -> $extra"
  if grep -q 'nothing else on the line' "$extra"; then
    echo "detail: restates instead of citing -> $extra"
    restating=$((restating + 1))
  fi
fi

# Advisory ratchet: elders join on touch. Counted every run, never a failure.
elders=0
for f in tools/fixtures/*_scan.sh; do
  [ "$f" = "$self" ] && continue
  case "$roster" in *"$f"*) continue ;; esac
  elders=$((elders + 1))
done

echo "roster=$kept"
echo "citing=$citing"
echo "restating=$restating"
echo "elders_awaiting_touch=$elders"
if [ "$citing" -eq "$kept" ]; then
  if [ "$restating" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
fi
echo "verdict=convention_not_single_homed"
exit 1
