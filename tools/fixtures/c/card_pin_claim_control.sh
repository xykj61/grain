#!/bin/sh
# tools/fixtures/c/card_pin_claim_control.sh -- prove the card-claim meter on real files.
#
# WHAT THIS IS FOR. `card_pin_claim_scan.sh` gates one reading: the operator card asserting the
# ledger cannot accept a row while the capacity instrument reads a door. A refusal proven only in
# the passing direction cannot be told from a bypass, so every refusal here is planted and then
# removed, and every welcome is asserted as hard as every refusal. The pen holds real files in a
# throwaway directory; the capacity instrument is a stub whose one reading the case chooses, so
# nothing here depends on the tree's own ledger.
#
#   sh tools/fixtures/c/card_pin_claim_control.sh
#
# Exit 0 when every case behaves, 1 otherwise. Prints one line per case and a verdict.
set -eu

SCAN=tools/fixtures/c/card_pin_claim_scan.sh
[ -f "$SCAN" ] || { echo "control: run from the repository root; $SCAN is not here" >&2; exit 2; }
ROOT=$(pwd)

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

fails=0
ok=0
say() {
  if [ "$2" = "yes" ]; then ok=$((ok + 1)); else fails=$((fails + 1)); fi
  echo "case: $1 = $2"
}
has() { case $1 in *"$2"*) echo yes ;; *) echo no ;; esac; }

# A stub instrument printing the one reading this scan quotes. `--` means print nothing at all.
stub() { # stub <deadlocked|--> <foldable>
  if [ "$1" = "--" ]; then
    printf '#!/bin/sh\necho pin_bytes=1\n' > "$pen/cap.sh"
  else
    printf '#!/bin/sh\necho pin_deadlocked=%s\necho pin_foldable_rows=%s\necho pin_headroom=0\n' "$1" "$2" > "$pen/cap.sh"
  fi
  chmod +x "$pen/cap.sh"
}

run_scan() { # run_scan <card>
  ( cd "$ROOT" && env CARD_PATH="$1" CAPACITY_SCAN="$pen/cap.sh" sh "$SCAN" 2>&1 ) || true
}
code_of() { # code_of <card>
  if ( cd "$ROOT" && env CARD_PATH="$1" CAPACITY_SCAN="$pen/cap.sh" sh "$SCAN" >/dev/null 2>&1 ); then echo 0; else echo $?; fi
}

# ---- 1. a claim standing over a healthy pin refuses, and the plant is then lifted --------------
{
  echo '# ITINERARY -- a pen card'
  echo 'The live front runs as usual.'
  echo 'OPEN: the REDS pin holds ~8 bytes with every row OPEN, so no new red can be booked until the bound rises on your word.'
} > "$pen/claim.md"
stub 0 1
out=$(run_scan "$pen/claim.md")
say "a claim over a door refuses"             "$(has "$out" 'verdict=claim_disagrees')"
say "the refusal names the line"              "$(has "$out" 'claim.md:3')"
say "the refusal quotes the phrase"           "$(has "$out" 'no new red can be booked')"
say "the refusal names the remedy"            "$(has "$out" 'reds_fold.sh')"
say "one claim counted"                       "$(has "$out" 'card_blocked_claims=1')"
say "one disagreement counted"                "$(has "$out" 'claim_disagreements=1')"
say "a disagreement exits 2"                  "$([ "$(code_of "$pen/claim.md")" = 2 ] && echo yes || echo no)"

# The plant lifted: the same card with the claim struck walks free.
{
  echo '# ITINERARY -- a pen card'
  echo 'The live front runs as usual.'
  echo 'OPEN: the ledger capacity reading rides the roster pass; read it there.'
} > "$pen/struck.md"
out=$(run_scan "$pen/struck.md")
say "the claim struck walks free"             "$(has "$out" 'verdict=ok')"
say "and counts no claim"                     "$(has "$out" 'card_blocked_claims=0')"

# ---- 2. the same claim over a genuinely deadlocked pin is honest prose -------------------------
stub 1 0
out=$(run_scan "$pen/claim.md")
say "a claim over a wall walks free"          "$(has "$out" 'verdict=ok')"
say "and is named as agreeing"                "$(has "$out" 'detail: claim_agrees')"
say "the claim still counted"                 "$(has "$out" 'card_blocked_claims=1')"
say "no disagreement counted"                 "$(has "$out" 'claim_disagreements=0')"

# ---- 3. silence is reported on both sides, and gated on neither --------------------------------
out=$(run_scan "$pen/struck.md")
say "a silent card over a wall is reported"   "$(has "$out" 'silent_deadlock=1')"
say "and gated at nothing"                    "$(has "$out" 'verdict=ok')"
say "the silent deadlock is named"            "$(has "$out" 'detail: silent_deadlock')"
stub 0 1
out=$(run_scan "$pen/struck.md")
say "a silent card over a door is quiet"      "$(has "$out" 'silent_deadlock=0')"

# ---- 4. a line naming the instrument is a citation, never a claim ------------------------------
# A page teaching a reader to run the meter must be able to quote its refusal words. Planted with
# the citation, then MUTATED by taking the citation away, so the leg proves the exemption rather
# than the phrase list.
{
  echo '# ITINERARY -- a pen card'
  echo 'Run tools/fixtures/r/reds_pin_capacity_scan.sh -- it prints no lawful fold when the pin is walled.'
} > "$pen/cite.md"
out=$(run_scan "$pen/cite.md")
say "a citation is not a claim"               "$(has "$out" 'verdict=ok')"
say "the citation is seen as a citation"      "$(has "$out" 'card_cites_scan=yes')"
{
  echo '# ITINERARY -- a pen card'
  echo 'Run the meter -- it prints no lawful fold when the pin is walled.'
} > "$pen/mutant.md"
out=$(run_scan "$pen/mutant.md")
say "the same words without it refuse"        "$(has "$out" 'verdict=claim_disagrees')"

# ---- 5. the net is wide enough to catch a hand's own spelling ----------------------------------
{
  echo '# ITINERARY -- a pen card'
  echo 'No lawful fold exists here, so the pin is deadlocked and yours, Keaton.'
  echo 'Nothing foldable stands, and nothing CANNOT BE BOOKED until you speak.'
} > "$pen/many.md"
out=$(run_scan "$pen/many.md")
say "two claim-bearing lines counted"         "$(has "$out" 'card_blocked_claims=2')"
say "both disagreements counted"              "$(has "$out" 'claim_disagreements=2')"
say "an uppercase claim is caught"            "$(has "$out" 'many.md:3')"

# ---- 6. an instrument that cannot answer refuses rather than reading as agreement --------------
stub -- 0
out=$(run_scan "$pen/claim.md")
say "a silent instrument refuses"             "$(has "$out" 'verdict=capacity_silent')"
say "and exits 2"                             "$([ "$(code_of "$pen/claim.md")" = 2 ] && echo yes || echo no)"

# ---- 7. misuse refuses rather than guessing ----------------------------------------------------
stub 0 1
out=$(run_scan "$pen/absent.md")
say "an absent card refuses"                  "$(has "$out" 'verdict=card_absent')"
if ( cd "$ROOT" && env CARD_PATH="$pen/claim.md" CAPACITY_SCAN="$pen/nothing.sh" sh "$SCAN" >/dev/null 2>&1 ); then c=0; else c=$?; fi
say "an absent instrument refuses"            "$([ "$c" = 2 ] && echo yes || echo no)"

# ---- 8. the phrase list's own size is published, so a reader sees the net ----------------------
out=$(run_scan "$pen/struck.md")
say "the phrase count is printed"             "$(has "$out" 'claim_phrases=12')"

echo "cases_ok=$ok"
echo "cases_failed=$fails"
if [ "$fails" -gt 0 ]; then echo "control_verdict=behaviors_changed"; exit 1; fi
echo "control_verdict=ok"
