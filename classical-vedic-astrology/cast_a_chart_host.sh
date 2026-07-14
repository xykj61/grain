#!/usr/bin/env sh
# cast_a_chart_host.sh — POSIX seam for Swiss Ephemeris (pyswisseph).
#
# Hosted by cast_a_chart.rish. Edit birth constants in cast_a_chart.py before casting.
# Canonical entry from repository root:
#   rishi/bin/rishi run classical-vedic-astrology/cast_a_chart.rish
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "${ROOT}"

SCRIPT="classical-vedic-astrology/cast_a_chart.py"

echo "cast: prepare — dual-zodiac natal chart (tropical signs, Lahiri stars, whole-sign houses)"
echo "cast: prepare — source ${SCRIPT}"

if ! command -v python3 >/dev/null 2>&1; then
  echo "cast: RED — python3 missing on PATH"
  exit 1
fi
echo "cast: prepare — python3 present"

if ! python3 -c "import swisseph" 2>/dev/null; then
  echo "cast: RED — pyswisseph not installed (pip install pyswisseph)"
  exit 1
fi
echo "cast: prepare — ephemeris seam ready"

echo "cast: compute — printing placements"
python3 "${SCRIPT}"
echo "cast: GREEN — chart lines printed"
