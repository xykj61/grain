# The receipt contract, reviewed -- where the clock enters

**Status:** Review -- proposed, not applied. The contract is Keaton's accepted text and changes only on his word.
**Room:** checkable -- every finding names a file, a line, or a command.
**Reviews:** [`../../20260912/20260912-201126_the-receipt-you-can-read-contract.md`](../20260912/20260912-201126_the-receipt-you-can-read-contract.md)
**Card:** `construction/ITINERARY.md`, Incense item 1 (review and revise the contract).

## What was read

The contract's promise, fixture, public types, bounds, module residences, the eight acceptance cases, and the completion edge. Then the code that answers the time question: `mantra/src/receipt_offer.rye`, `dimeroll/receipt_offer.rye`, and the two witnesses that call them.

Counted reading, free to re-run: `sh tools/fixtures/q/qa_report_card.sh <contract> --setting field --service 90` printed `composite=90 letter=A`, with `truth_mode=counted`. The grade names the counted half only, so this review supplies the judged half.

## Finding 1 -- the contract never says where time comes from

The fixture sets `expires_at 20261012.120000-0400`, three days after this review. Case 5 says replaying "at the expiration boundary changes status to `expired`", and the falsifier turns on replay output. A reader of the contract cannot tell whether replay consults a wall clock or takes the instant as an argument.

The code takes it as an argument. `mantra/src/receipt_offer.rye:173` reads `pub fn replay(self: *const Log, now: u64)`, and line 177 sets `.expired` when `now >= fact.expires_at`. Dimeroll takes a boolean, `dimeroll/receipt_offer.rye:37`, and never a clock. So the passing case does not flip on `20261012`. The clock is an input, and the contract should say so.

**Proposed sentence, for Case 5 or the Public types section:** "Replay takes the instant as an explicit input. Any instant before `expires_at` reads `offered`, and any instant at or after it reads `expired`." That moves no field and changes no case.

## Finding 2 -- the witnesses pass fixed instants, so nothing flips

The grep is run. `mantra/src/receipt_offer_witness.rye:48-49` and `:63` replay at `fact.issued_at` for the offered reads, and `:56` replays at `fact.expires_at` for the expired read. `mantra/src/receipt_offer_snapshot_witness.rye:47` and `:74` do the same. No witness reads a live clock, so the passing case stays `offered` at the fixture's own issue instant on any later day. Finding 1 is a clarity gap, and it does not reach the witnesses.

## Finding 3 -- the boundary is inclusive, and the contract agrees

`>=` at line 177 makes the expiry instant itself `expired`. Case 5's "at the expiration boundary" reads the same way. No change is needed; this is recorded so a later reviewer does not re-derive it.

## What this review leaves alone

No code, no witness, and no contract text changed. The contract was accepted on `20260913`, and a clarifying sentence waits for Keaton's word. Finding 2 waits for its one grep.

What this lap can say plainly: the design holds, the clock is an explicit input in the code, and the document does not yet say so.
