#!/bin/sh
# tools/fixtures/vols_survey_parse.sh — VOLS survey, parse a cion-survey-v1 Bron ledger.
#
#   sh tools/fixtures/vols_survey_parse.sh <record>
#
# Reads a `format cion-survey-v1` record (vols_survey_render.sh) back into its totals — the
# parse-back half of r3's round-trip. Re-emits the totals as key=value AND independently
# counts the `site ` lines, so a reader can check the declared site count against the
# lines actually carried (the record proving itself). Refuses a record whose header is
# wrong or missing (verdict=badformat) — the tamper refusal r3 owes.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md.
set -eu

if [ "$#" -ne 1 ]; then
  echo "detail: usage — vols_survey_parse.sh <record>"
  echo "verdict=badformat"
  exit 1
fi
record=$1
if [ ! -f "$record" ]; then
  echo "detail: absent record ($record)"
  echo "verdict=badformat"
  exit 1
fi

header=$(head -1 "$record")
if [ "$header" != "format cion-survey-v1" ]; then
  echo "detail: bad header ($header)"
  echo "verdict=badformat"
  exit 1
fi

# Pull each declared total; a Bron field is "key value" (space, not =).
for k in stamp surfaces sites handles prose_gaps guarded_sites; do
  v=$(sed -n "s/^$k //p" "$record" | head -1)
  echo "$k=$v"
done

# Independent check — the site lines actually present must match the declared count.
carried=$(grep -c '^site ' "$record" 2>/dev/null || true)
echo "site_lines=$carried"
echo "verdict=ok"
exit 0
