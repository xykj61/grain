#!/bin/sh
# tools/fixtures/l/landed_line_control.sh -- the landed-line scan can red.
#
# Four behaviors, in a throwaway directory. A present path passes. A page with
# no marker passes as unmarked. An absent path reds. A line with two paths reds.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"
scan=tools/fixtures/l/landed_line_scan.sh
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

mkdir -p "$pen/ship" "$pen/essay"
printf 'face\n' > "$pen/ship/face.md"
printf 'Landed: ship/face.md\n' > "$pen/essay/good.md"
printf 'A page with no marker.\n' > "$pen/essay/plain.md"
printf 'Landed: ship/gone.md\n' > "$pen/essay/bad.md"
printf 'Landed: ship/face.md extra\n' > "$pen/essay/wide.md"

behaviors=0
failed=0

one() {
  behaviors=$((behaviors + 1))
  name=$1
  shift
  if "$@"; then
    echo "behavior=$name ok"
  else
    echo "behavior=$name FAIL"
    failed=$((failed + 1))
  fi
}

one present sh "$scan" --root "$pen" essay/good.md
one unmarked sh "$scan" --root "$pen" essay/plain.md
one absent sh -c "sh '$scan' --root '$pen' essay/bad.md; test \$? -eq 1"
one wide sh -c "sh '$scan' --root '$pen' essay/wide.md; test \$? -eq 1"

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=failed"
exit 1
