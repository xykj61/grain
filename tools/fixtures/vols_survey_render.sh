#!/bin/sh
# tools/fixtures/vols_survey_render.sh — VOLS survey, the census rendered as a Bron ledger.
#
#   sh tools/fixtures/vols_survey_render.sh <root> <guardlist> <stamp>
#
# Renders the classified survey census (vols_classify_scan.sh) to a `format cion-survey-v1`
# Bron record — a durable artifact the molt (LOWE) reads, rather than a console print that
# scrolls away. Bron is plain key-value, one field per line, parsed not evaluated
# (context/TAME_GUIDANCE.md; the pond apps' format X-v1 records are kin).
#
# Shape:
#   format cion-survey-v1
#   stamp <stamp>
#   surfaces <n>
#   sites <n>
#   handles <n>
#   prose_gaps <n>
#   guarded_sites <n>
#   site <path> <kind> <guard>        # one per site, sorted; kind prose|handle, guard gap|guarded
#
# Deterministic: the census sorts its files, so the same tree renders the same bytes twice
# (the round-trip idempotence r3 proves). Output convention: the record IS the payload
# (context/specs/20260729-215600_scan-seam-convention.md — a rendered artifact, not a scan
# verdict; the parser carries the verdict).
set -eu

if [ "$#" -ne 3 ]; then
  echo "detail: usage — vols_survey_render.sh <root> <guardlist> <stamp>" 1>&2
  exit 2
fi
root=$1
guardlist=$2
stamp=$3
if [ ! -d "$root" ]; then echo "detail: absent root ($root)" 1>&2; exit 2; fi
if [ ! -f "$guardlist" ]; then echo "detail: absent guardlist ($guardlist)" 1>&2; exit 2; fi

classified=$(sh tools/fixtures/vols_classify_scan.sh "$root" "$guardlist" 2>/dev/null)

surfaces=$(sh tools/fixtures/vols_survey_scan.sh "$root" 2>/dev/null | sed -n 's/^surfaces=//p')
sites=$(printf '%s\n' "$classified" | sed -n 's/^sites=//p')
handles=$(printf '%s\n' "$classified" | sed -n 's/^handles=//p')
prose_gaps=$(printf '%s\n' "$classified" | sed -n 's/^prose_gaps=//p')
guarded_sites=$(printf '%s\n' "$classified" | sed -n 's/^guarded_sites=//p')

echo "format cion-survey-v1"
echo "stamp $stamp"
echo "surfaces $surfaces"
echo "sites $sites"
echo "handles $handles"
echo "prose_gaps $prose_gaps"
echo "guarded_sites $guarded_sites"

# One site line per classified finding — a gap= or handle= line from the classifier.
# (A drifted guarded site prints a detail: line, never a site line, so a clean render
# carries only the two honest kinds.)
printf '%s\n' "$classified" | while IFS= read -r line; do
  case "$line" in
    gap=*)    echo "site ${line#gap=} prose gap" ;;
    handle=*) echo "site ${line#handle=} handle gap" ;;
  esac
done
