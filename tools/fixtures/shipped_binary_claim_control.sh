#!/bin/sh
# tools/fixtures/shipped_binary_claim_control.sh -- the guard proven to refuse, and to allow.
#
# WHY. tools/fixtures/shipped_binary_claim_scan.sh refuses a living document that says Grain's
# tools arrive with a clone. A guard that has never refused is a guard nobody has tested -- and
# this one guards the pages a stranger reads first, where a false claim does the most damage and
# gets the least scrutiny.
#
# It must also ALLOW, which is the half that is easy to forget: the guard's own first run reddened
# on three pages that were quoting the false claim in order to explain it was false. A guard that
# makes the record of a fault unwritable has erased its own reason.
#
# THREE CASES, answers known before the tool runs:
#   asserted  -- a living page that plainly states the tools come with the clone -> REFUSED
#   quoted    -- a living page quoting that phrase while citing its REDS row     -> ALLOWED
#   dated     -- a dated artifact that said it when it was true                  -> ALLOWED
#
# Driven by tools/shipped_binary_claim_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

mkdir -p "$work/manual"

# A living page asserting it. This must be refused.
printf 'The two tools came with the copy, so nothing needs building.\n' > "$work/manual/asserted.md"

run_scan() {
  code=0
  ( cd "$root" && sh tools/fixtures/shipped_binary_claim_scan.sh "$1" ) > "$work/out" 2>/dev/null || code=$?
  grep -E '^(claims_found|verdict)=' "$work/out" | sed 's/^/  /'
  echo "  refused=$([ "$code" -ne 0 ] && echo yes || echo no)"
  return 0
}

echo "case=asserted"
run_scan "$work"
asserted_code=0
( cd "$root" && sh tools/fixtures/shipped_binary_claim_scan.sh "$work" ) >/dev/null 2>&1 || asserted_code=$?

# Now make the same sentence a quotation that cites its ledger row, and a dated artifact.
rm -f "$work/manual/asserted.md"
printf 'The page once said *"came with the copy"*, which was false (REDS %%117).\n' > "$work/manual/quoted.md"
printf 'The two tools came with the copy, so nothing needs building.\n' > "$work/manual/20260101-000000_dated.md"

echo "case=quoted_and_dated"
run_scan "$work"
allowed_code=0
( cd "$root" && sh tools/fixtures/shipped_binary_claim_scan.sh "$work" ) >/dev/null 2>&1 || allowed_code=$?

echo "asserted_refused=$([ "$asserted_code" -ne 0 ] && echo yes || echo no)"
echo "quoted_and_dated_allowed=$([ "$allowed_code" -eq 0 ] && echo yes || echo no)"

if [ "$asserted_code" -ne 0 ] && [ "$allowed_code" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
