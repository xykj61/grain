#!/bin/sh
# tools/fixtures/s/shipped_binary_claim_scan.sh -- no living doc may misname the tools a clone carries.
#
# Two checks, one concern: a page must not tell a reader the tools ARRIVE with a clone (they do
# not), nor NAME them in a way a reader cannot run (they are not on a PATH).
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
#   sh tools/fixtures/s/shipped_binary_claim_scan.sh
#   sh tools/fixtures/s/shipped_binary_claim_scan.sh <dir>   # scan a throwaway tree, for the control
#
# Driven by tools/s/shipped_binary_claim_witness.rish. Run from the repository root.

set -eu

scope="${1:-.}"

# THE SCRATCH FILES BELOW ARE PRIVATE, and that is load-bearing rather than tidy. Until
# `20260907.163000` this scan wrote two constant names under the one `/tmp` eight ships share,
# truncating each with `: >`, appending to it, counting it, and removing it. Two ships running this
# scan in the same second interleave on ONE file, and every interleaving is wrong in a different
# direction: a peer's truncation empties the file mid-append and the count reads zero, a peer's
# removal deletes it before `wc -l` reads it, and a peer's hits are counted as this tree's. The
# last is the worst, because it is the shape that reports a false claim against a page that never
# made one. It fired on this pier's cold endurance run of `20260907.150519`, where this guard read red in
# company and GREEN alone. `mktemp -d` asks the kernel for a name no two runs can agree on, and the
# trap removes only what this process made.
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

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
: > "$pen/hits.txt"
printf '%s\n' "$PATTERNS" | while IFS= read -r pat; do
  [ -n "$pat" ] || continue
  grep -rIn --fixed-strings "$pat" \
    --include=*.md --include=*.mdc \
    --exclude-dir=.git --exclude-dir=seed --exclude-dir=vendor --exclude-dir=gratitude \
    --exclude=shipped_binary_claim_scan.sh \
    "$scope" 2>/dev/null \
    | grep -vE '/[0-9]{8}-[0-9]{6}[_.][a-z]' \
    | grep -v 'shipped_binary_claim' \
    | grep -vF 'REDS %' \
    | grep -v '\*"' >> "$pen/hits.txt" || true
done
hits=$(wc -l < "$pen/hits.txt" | tr -d ' ')

echo "claims_found=$hits"
if [ "$hits" -gt 0 ]; then
  sed 's/^/claim: /' "$pen/hits.txt"
fi

# SECOND CHECK, added `20260821.191504` (REDS %119). A page may also mislead by NAMING the tools
# wrongly rather than by claiming they ship. The sandboxing guide invited a reader to run a bare
# `rye build ...`, and two video scripts typed one on camera -- none of which can run, since the
# compiler lives at `rye/bin/rye` in the clone and never on a PATH.
#
# The line between a defect and a legitimate use is mechanical, which is the only reason this is
# checkable at all: a RUNNABLE block is fenced ```bash or ```sh, while usage tables and captured
# version output sit in unlabeled fences. So only labeled fences are read. Archive rooms are
# exempt for the same reason dated artifacts are -- they record what was true then.
bare=0
: > "$pen/bare.txt"
# `while read` over a newline list rather than `for f in $(...)`: one tracked page carries a space
# in its name, and word-splitting silently dropped it from every run this scan ever made.
git ls-files '*.md' | grep -vE '/[0-9]{8}-[0-9]{6}[_.]' | grep -vE '^(session-logs|counsel|gratitude|vendor|seed)/' | grep -v '/archive/' > "$pen/pages.txt"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  # The instrument answers or the scan refuses. `git ls-files` names tracked, existing paths, so an
  # awk failure here means the reader broke rather than that a page held nothing -- and an empty
  # `bare.txt` reads exactly like a clean tree, which is the one answer this scan must never guess.
  if ! awk '/^```(bash|sh)$/{n=1;next} /^```/{n=0} n && /^(rye|rishi) /{print FILENAME ":" FNR ": " $0}' "$f" >> "$pen/bare.txt"; then
    echo "instrument=failed"
    echo "detail=awk_refused_on $f"
    echo "verdict=misread"
    exit 1
  fi
done < "$pen/pages.txt"
bare=$(wc -l < "$pen/bare.txt" | tr -d ' ')
echo "bare_invocations=$bare"
if [ "$bare" -gt 0 ]; then sed 's/^/bare: /' "$pen/bare.txt"; fi

if [ "$tracked" -gt 0 ]; then
  echo "note=binaries are tracked now, so such a claim would be true; the guard stands down"
  echo "verdict=ok"
  exit 0
fi

if [ "$hits" -eq 0 ] && [ "$bare" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
if [ "$bare" -gt 0 ] && [ "$hits" -eq 0 ]; then
  echo "verdict=bare_invocation"
  echo "refused: a runnable block invokes a bare rye or rishi, neither of which is on a PATH" >&2
  exit 1
fi
echo "verdict=false_claim"
echo "refused: a living document says the tools arrive with a clone, and git tracks none of them" >&2
exit 1
