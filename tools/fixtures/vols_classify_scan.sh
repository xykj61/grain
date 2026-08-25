#!/bin/sh
# tools/fixtures/vols_classify_scan.sh -- VOLS survey census, classified by kind and guard.
#
#   sh tools/fixtures/vols_classify_scan.sh <root> <guardlist>
#
# Reads the derived survey census (vols_survey_scan.sh) and classifies each site two ways,
# so the molt (LOWE) knows exactly what to touch:
#
#   kind  -- prose  : a living prose surface naming a capability by a bare "lap N".
#                    LOWE relabels these to semantic label + stamp.
#           handle : a kept witness-handle FILE (basename matches *_lap<N>*), a stable
#                    identifier the labeling law deliberately keeps (Keaton's prose-only
#                    ruling -- tools/g/granary_lap1.rish and kin). Named, never relabeled.
#   guard -- guarded: the site's file is in <guardlist> (the CION guard already scans it).
#           gap    : no guard watches it yet -- the set LOWE must grow the guard to cover.
#
# <guardlist> is one path per line, relative to <root> (produced by
# vols_guardlist_extract.sh from the guard witness in force). A key invariant falls out:
# because the guard passes GREEN, every guarded file carries NO bare ordinal, so no site
# can sit in a guarded file -- guarded_sites must be 0. The scan proves it rather than
# assuming it, and would report a nonzero count (a real fault) if a guarded file drifted.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md.
set -eu

if [ "$#" -ne 2 ]; then
  echo "detail: usage — vols_classify_scan.sh <root> <guardlist>"
  echo "verdict=noroot"
  exit 2
fi
root=$1
guardlist=$2
if [ ! -d "$root" ]; then echo "detail: absent root ($root)"; echo "verdict=noroot"; exit 2; fi
if [ ! -f "$guardlist" ]; then echo "detail: absent guardlist ($guardlist)"; echo "verdict=noroot"; exit 2; fi

sites=0
handles=0
prose_gaps=0
guarded_sites=0

# The census emits one "site=<path> lap_ordinal=<n>" line per site; classify each path.
census=$(sh tools/fixtures/vols_survey_scan.sh "$root" 2>/dev/null | grep '^site=' || true)

# IFS newline so each census line is one iteration.
OLD_IFS=$IFS
IFS='
'
for line in $census; do
  path=$(printf '%s' "$line" | sed -n 's/^site=\(.*\) lap_ordinal=.*$/\1/p')
  [ -n "$path" ] || continue
  sites=$((sites + 1))
  base=$(basename "$path")

  # kind: a witness-handle filename (..._lap<digits>...) is a kept stable identifier.
  case "$base" in
    *_lap[0-9]*) kind=handle; handles=$((handles + 1)) ;;
    *)           kind=prose ;;
  esac

  # guard: is this exact path in the guardlist? Guardlist paths are relative to root.
  guard=gap
  IFS=$OLD_IFS
  for g in $(cat "$guardlist"); do
    if [ "$path" = "$root/$g" ] || [ "$path" = "$g" ]; then guard=guarded; break; fi
  done
  IFS='
'

  if [ "$guard" = "guarded" ]; then
    guarded_sites=$((guarded_sites + 1))
    echo "detail: guarded site drifted ($path) — a guarded file carries a bare ordinal"
  elif [ "$kind" = "prose" ]; then
    prose_gaps=$((prose_gaps + 1))
    echo "gap=$path"
  else
    echo "handle=$path"
  fi
done
IFS=$OLD_IFS

echo "sites=$sites"
echo "handles=$handles"
echo "prose_gaps=$prose_gaps"
echo "guarded_sites=$guarded_sites"
if [ "$guarded_sites" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=drift"; exit 1
