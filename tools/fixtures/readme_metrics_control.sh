#!/bin/sh
# tools/fixtures/readme_metrics_control.sh -- a drifted block, so the check is proven to notice.
#
# WHY. tools/fixtures/readme_metrics_check.sh refuses a stale metrics block. A check that has
# never refused is a check nobody has tested, and this one guards the most-read file the project
# owns -- the place a wrong number does the most damage and gets the least scrutiny.
#
# This copies the real README, changes ONE digit inside the block the way a stale or hand-edited
# block would differ, and runs the check on the copy. The copy is thrown away; the real README is
# never touched.
#
# EXPECTED: verdict=stale, drift at least 1, exit non-zero.
#
# Driven by tools/readme_metrics_witness.rish. Run from the repository root.

set -eu

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

cp README.md "$work/README.md"

# A number no measurement will ever produce, so the drift is unmistakable rather than a near-miss.
sed -i 's/| \*\*Witnesses\*\* running on metal | \*\*[0-9][0-9]*\*\* |/| **Witnesses** running on metal | **999999** |/' "$work/README.md"

grep -qF '**999999**' "$work/README.md" || { echo "control: the planted drift did not land" >&2; exit 1; }
echo "planted=yes"

code=0
sh tools/fixtures/readme_metrics_check.sh "$work/README.md" > "$work/out" 2>&1 || code=$?
grep -E '^(drift|verdict)=' "$work/out" || true
echo "refused=$([ "$code" -ne 0 ] && echo yes || echo no)"

if [ "$code" -ne 0 ] && grep -q '^verdict=stale$' "$work/out"; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
