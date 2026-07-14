#!/usr/bin/env sh
# chrono_version_scan_drive.sh — split roster, run chunk scanner, emit OK/FAIL lines.
set -eu
ROOT="$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
mkdir -p tools/.cache
sh tools/fixtures/chrono_version_roster.sh > tools/.cache/chrono-roster-full.txt
rm -f tools/.cache/chrono-chunk-*.txt
# Prefer numeric suffixes; fall back if split lacks -d
if split -l 200 -d -a 2 tools/.cache/chrono-roster-full.txt tools/.cache/chrono-chunk- 2>/dev/null; then
  :
else
  split -l 200 tools/.cache/chrono-roster-full.txt tools/.cache/chrono-chunk-
fi
OUT=tools/.cache/chrono-scan-out.txt
: > "$OUT"
status=0
for chunk in tools/.cache/chrono-chunk-*; do
  [ -f "$chunk" ] || continue
  cp -f "$chunk" tools/.cache/chrono-chunk.txt
  if ! rishi/bin/rishi run tools/fixtures/chrono_version_scan_chunk.rish >>"$OUT"; then
    status=1
  fi
done
fail_n=$(grep -c '^FAIL' "$OUT" || true)
ok_n=$(grep -c '^OK' "$OUT" || true)
if [ "$fail_n" -eq 0 ]; then
  verdict=GREEN
else
  verdict=RED
fi
printf 'fail=%s\nok=%s\nverdict=%s\n' "$fail_n" "$ok_n" "$verdict" > tools/.cache/chrono-scan-summary.txt
cat "$OUT"
exit "$status"
