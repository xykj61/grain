#!/bin/sh
# tools/fixtures/reds_first_scan.sh — the reds-first law is single-homed and cited.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value · detail: prefixed · verdict= its own key · status agrees.
#
# Voice v10 · slot 10 · sameness_as_compression. One home, three citations, and
# the crossing kept whole: named study in external-research, teachers in
# gratitude, siloed law in foundations. A law kept in three places becomes three
# laws within a season, which this house measured at v6.
set -eu
law="foundations/20260729-224828_reds-first-and-the-allocation.md"
study="external-research/20260729-224828_the-line-that-stops-itself.md"
thanks="gratitude/toyota-production-system.md"
ledger="construction/REDS.md"

faults=0
for f in "$law" "$study" "$thanks" "$ledger"; do
  [ -f "$f" ] || { echo "detail: absent -> $f"; faults=$((faults + 1)); }
done
[ "$faults" -eq 0 ] || { echo "verdict=crossing_incomplete"; exit 2; }

# Citers must point at the law and must not carry its body.
citers="context/TAME_GUIDANCE.md
.claude/rules/reds-first.md
.cursor/rules/reds-first.mdc"
citing=0
restating=0
for f in $citers; do
  if grep -q "20260729-224828_reds-first-and-the-allocation.md" "$f"; then
    citing=$((citing + 1))
  else
    echo "detail: does not cite the law -> $f"
    faults=$((faults + 1))
  fi
  # The law's own body sentence must live in exactly one file.
  if grep -q "books the remainder of the allocation" "$f"; then
    echo "detail: restates the law body -> $f"
    restating=$((restating + 1))
    faults=$((faults + 1))
  fi
done

# The silo must hold: teachers named in gratitude and study, never in the law.
# Body namings only: the Gratitude header pointer and the Dependencies section
# name the teachers deliberately, which the silo's scoped relaxation permits.
# Counting them as faults would make this advisory read 2 forever and mean 0 --
# caught 20260729.225300 when the advisory fired on a page already corrected.
body_named=$(grep -inE "toyota|jidoka|andon|poka-yoke|sakichi|ohno" "$law" \
  | grep -viE "^\s*[0-9]+:\*\*Gratitude:\*\*|gratitude/toyota-production-system" | wc -l | tr -d ' ')
echo "law_body_namings=$body_named"
if [ "$body_named" -gt 0 ]; then
  echo "detail: law body names the teachers $body_named times — silo asks the body stay in our voice"
fi
if grep -qi "sakichi" "$thanks"; then thanked=1; else thanked=0; echo "detail: gratitude does not name the teachers"; faults=$((faults + 1)); fi

echo "citers=3"
echo "citing=$citing"
echo "restating=$restating"
echo "teachers_thanked=$thanked"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=law_not_single_homed"
exit 1
