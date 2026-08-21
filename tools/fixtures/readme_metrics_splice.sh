#!/bin/sh
# tools/fixtures/readme_metrics_splice.sh -- put a rendered block between its markers.
#
# WHY A SHELL FIXTURE FOR THIS. Rishi renders the block and asserts every number in it, which is
# the part that carries a claim. What it cannot do is hold a whole README in one value -- Rishi
# strings are bounded, and an 18 KB file overruns that bound (`StringTooLong`). So the claim stays
# in Rishi and the byte-shuffling comes here, which is the honest division: the language that
# checks the fact owns the fact, and the tool that moves bytes moves bytes.
#
# USAGE
#   sh tools/fixtures/readme_metrics_splice.sh <target-file> <block-file>
#
# The block file replaces everything between the begin and end markers, inclusive. The markers
# must both already exist in the target -- this never invents a place to put the block, since a
# tool guessing where a generated block belongs is a tool that will one day guess wrong.
#
# Driven by tools/readme_metrics.rish; proven by tools/readme_metrics_witness.rish.

set -eu

target="${1:?name the file to splice into}"
block="${2:?name the file holding the rendered block}"

BEGIN='<!-- metrics:begin'
END='<!-- metrics:end -->'

grep -qF "$BEGIN" "$target" || { echo "splice: no begin marker in $target" >&2; exit 1; }
grep -qF "$END" "$target" || { echo "splice: no end marker in $target" >&2; exit 1; }

work="$(mktemp)"
trap 'rm -f "$work"' EXIT

awk -v blockfile="$block" -v b="$BEGIN" -v e="$END" '
  index($0, b) == 1 && !seen {
    seen = 1
    while ((getline line < blockfile) > 0) print line
    close(blockfile)
    inside = 1
    next
  }
  inside { if (index($0, e) == 1) { inside = 0 }; next }
  { print }
' "$target" > "$work"

# invariant: a splice never empties the file it edits.
[ -s "$work" ] || { echo "splice: refused -- the result was empty" >&2; exit 1; }
cat "$work" > "$target"
echo "spliced=$target"
