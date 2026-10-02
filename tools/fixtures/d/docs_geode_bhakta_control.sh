#!/bin/sh
# tools/fixtures/d/docs_geode_bhakta_control.sh -- the declaration reading, proven both ways.
set -eu

scan=$(CDPATH= cd -- "$(dirname "$0")" && pwd)/docs_geode_bhakta_scan.sh
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

mkdir -p "$pen/ok" "$pen/bad"
printf '%s\n' '# Ok' '' '**Style:** Bhakta at the Door setting, with Radiant warmth' > "$pen/ok/a.md"
printf '%s\n' '# Gauge' '' '**Style:** Gauge, Door setting' > "$pen/bad/gauge.md"
printf '%s\n' '# Bare' '' 'Hello.' > "$pen/bad/bare.md"

set +e
sh "$scan" "$pen/ok" > "$pen/ok.out"
ok_exit=$?
sh "$scan" "$pen/bad" > "$pen/bad.out"
bad_exit=$?
set -e

cat "$pen/ok.out"
echo "plant_ok_exit=$ok_exit"
cat "$pen/bad.out"
echo "plant_bad_exit=$bad_exit"

grep -q 'verdict=ok' "$pen/ok.out"
grep -q 'style_names_gauge' "$pen/bad.out"
grep -q 'no_style_line' "$pen/bad.out"
[ "$ok_exit" -eq 0 ]
[ "$bad_exit" -eq 1 ]
echo "control_verdict=ok"
