#!/bin/sh
# tools/fixtures/readme_metrics_check.sh -- is a file's metrics block still true?
#
# WHY. A generated block is only worth more than a hand-typed one while it is REGENERATED. Left
# alone it becomes a hand-typed number wearing a generated number's clothes -- stale, and trusted
# more than a stale number deserves because a comment above it says it was generated. So the block
# is compared against a fresh measurement, and drift is a red rather than a shrug.
#
# It also catches the other failure: a human editing between the markers. The comment asks them
# not to; this notices when they did.
#
# USAGE
#   sh tools/fixtures/readme_metrics_check.sh <file>
#
# Prints each expected row and whether the file holds it, then a verdict. Exit non-zero on drift.
#
# Driven by tools/r/readme_metrics_witness.rish. Run from the repository root.

set -eu

target="${1:?name the file to check}"
[ -f "$target" ] || { echo "check: no such file: $target" >&2; exit 1; }

scan="$(sh tools/fixtures/readme_metrics_scan.sh </dev/null)"
echo "$scan" | grep -q '^verdict=ok$' || { echo "check: the scan did not balance" >&2; exit 1; }

val() { echo "$scan" | sed -n "s/^$1=//p" | head -1; }

fascia="$(val fascia)"
witnesses="$(val witnesses)"
modules="$(val modules)"
rooms="$(val rooms_over)"

drift=0
expect() {
  if grep -qF "$1" "$target"; then
    echo "holds: $1"
  else
    echo "DRIFT: $1"
    drift=$((drift + 1))
  fi
}

expect "| **Fascia** -- can a reader follow any thread home | **${fascia}** / 100 |"
expect "| **Witnesses** running on metal | **${witnesses}** |"
expect "| **Rye modules** they stand over | **${modules}** |"
expect "| **Rooms grown past what a browser can list** | **${rooms}** |"

grep -qF '<!-- metrics:begin' "$target" || { echo "DRIFT: begin marker missing"; drift=$((drift + 1)); }
grep -qF '<!-- metrics:end -->' "$target" || { echo "DRIFT: end marker missing"; drift=$((drift + 1)); }

echo "drift=$drift"
if [ "$drift" -eq 0 ]; then
  echo "verdict=true"
else
  echo "verdict=stale"
  exit 1
fi
