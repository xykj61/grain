#!/bin/sh
# tools/fixtures/shipped_binary_claim_scan.sh -- no living doc may say the tools ship in a clone.
#
# WHY. This fault has now fired twice. REDS %117: the manual's first-hour page told a newcomer the
# two tools "already live inside your clone" and "came with the copy." REDS %118: the machines
# guide said it three more times, including "the shipped `rye` and `rishi` binaries are built for
# exactly this architecture." Neither was true, and both sat in the pages most likely to be a
# stranger's first contact -- false on the one point a stranger cannot check for themselves,
# because checking it requires the very thing the page says they already have.
#
# A lantern that fires twice becomes a loom. This is the loom.
#
# HOW IT DECIDES. Two halves, and the second only matters because of the first:
#   1. MEASURE the fact -- how many files under `rye/bin` and `rishi/bin` are tracked by git.
#   2. If that count is ZERO, refuse any living document that CLAIMS otherwise.
# When the count is not zero the world has changed, the claims would be true, and the guard says so
# and passes rather than enforcing a stale rule. A guard that cannot notice its own premise
# expiring is a guard that will one day be wrong with confidence.
#
# A QUOTATION IS NOT A CLAIM, and this guard learned that the first time it ran. Every one of its
# first three hits was a page EXPLAINING that the claim had been false -- the record of a fault
# necessarily contains the fault's own words. So two exemptions, both principled rather than
# convenient: a line citing a `REDS %` row is discussing the fault, and a phrase wrapped in the
# tree's own emphasis-quote form `*"..."*` is being quoted rather than asserted. A guard that reds
# on the ledger describing it would make the ledger unwritable, which is how a rule quietly erases
# its own reason.
#
# WHAT IS DELIBERATELY OUT OF SCOPE. Dated artifacts -- a session log or a dated brief that said
# something true-then keeps saying it, per accrete-never-break. Only living documents are held to
# what is true now. `gratitude/`, `vendor/`, and `seed/` are third-party or projected.
#
# USAGE
#   sh tools/fixtures/shipped_binary_claim_scan.sh
#   sh tools/fixtures/shipped_binary_claim_scan.sh <dir>   # scan a throwaway tree, for the control
#
# Driven by tools/shipped_binary_claim_witness.rish. Run from the repository root.

set -eu

scope="${1:-.}"

tracked=$(git ls-files rye/bin rishi/bin 2>/dev/null | wc -l | tr -d ' ')
echo "tracked_binaries=$tracked"

# The phrases that assert the tools arrive with a clone. Each is drawn from a real page that said
# it, so the list is evidence rather than imagination.
PATTERNS='came with the copy
already live inside your clone
already lives inside your clone
shipped `rye`
shipped rye and rishi
binaries ship with
ships with the clone
comes with the clone'

hits=0
: > /tmp/sbc_hits.txt
printf '%s\n' "$PATTERNS" | while IFS= read -r pat; do
  [ -n "$pat" ] || continue
  grep -rIn --fixed-strings "$pat" \
    --include=*.md --include=*.mdc \
    --exclude-dir=.git --exclude-dir=seed --exclude-dir=vendor --exclude-dir=gratitude \
    --exclude=shipped_binary_claim_scan.sh \
    "$scope" 2>/dev/null \
    | grep -vE '/[0-9]{8}-[0-9]{6}_[a-z]' \
    | grep -v 'shipped_binary_claim' \
    | grep -vF 'REDS %' \
    | grep -v '\*"' >> /tmp/sbc_hits.txt || true
done
hits=$(wc -l < /tmp/sbc_hits.txt | tr -d ' ')

echo "claims_found=$hits"
if [ "$hits" -gt 0 ]; then
  sed 's/^/claim: /' /tmp/sbc_hits.txt
fi
rm -f /tmp/sbc_hits.txt

if [ "$tracked" -gt 0 ]; then
  echo "note=binaries are tracked now, so such a claim would be true; the guard stands down"
  echo "verdict=ok"
  exit 0
fi

if [ "$hits" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=false_claim"
echo "refused: a living document says the tools arrive with a clone, and git tracks none of them" >&2
exit 1
