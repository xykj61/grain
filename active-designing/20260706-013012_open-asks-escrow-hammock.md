# Open Asks — Escrow Hammock (OA-L3 Counsel)

*OA-L1 closed the ask loop on one log, and its completion is already a signed payment fact from poster to applicant. OA-L3 grows the money between them into two visible moments — a hold at acceptance and a release at completion — so a bounty is pledged in the open and paid in the open, with the ledger conserving every unit. This is MALA's first real M1-to-M2 movement, grown from the seed already running, and it needs no external chain to be whole. It counsels the shape; the names and the go-ahead stay Kaeden's.*

**Stamp:** `20260706.013012 UDT` (Kaeden's clock)
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME — safety first, performance second, the joy of the craft third · SLC · Gall's Law
**Register:** active-designing — hammock scope and counsel; proposes candidate names that park for Kaeden's word; seats nothing
**Ground:** [`../linengrow/open_asks.rye`](../linengrow/open_asks.rye) · [`20260706-002912_open-asks-hammock-scope.md`](20260706-002912_open-asks-hammock-scope.md) · [`20260706-011512_open-asks-cross-party-delivery.md`](20260706-011512_open-asks-cross-party-delivery.md) · [`../external-research/20260702-211312_names-builds-and-the-ledger-map.md`](../external-research/20260702-211312_names-builds-and-the-ledger-map.md) · [`../external-research/20260706-005512_settlement-seat-verification-and-verdict.md`](../external-research/20260706-005512_settlement-seat-verification-and-verdict.md)
**Status:** Landed — checkable-room lap 1 and lap 2 GREEN; escrow hold and release on one log plus hosted and device wire carriage, parity **158**. Vocabulary sealed `20260706.014512`: the escrow account is **Nyasa**; memo prefixes stay `escrow-hold` and `escrow-release`. **OA-L4** reputation-as-fold lap 1 landed parity **167** (ruling `20260706.232812`). **Next:** MALA graduation when OA-L4 becomes escrow's second consumer.

*Written together by Kaeden and Rio 3.*

---

## What OA-L3 Adds, and What It Leaves Alone

OA-L1 already carries money. Its completion fact names a sender, a receiver, an amount, and a memo, signed by the poster and folded against the accepted request, so the stipend moves from poster to applicant in a single step the fold verifies. OA-L3 keeps every other rung exactly as it stands and grows only that final step into two, so the value becomes visible while the work is underway. At acceptance the poster holds the stipend in escrow, in the open, where the applicant can see the bounty is real. At completion the poster releases it to the applicant. The request, the application, the acceptance, and the one-log discipline all stay untouched, which is accrete-never-break applied to money: the working payment grows a middle, rather than the loop being rebuilt.

This is the smallest honest form of MALA's ladder. Holding is the committed rung — value locked from the poster's spendable balance into a named escrow, mailable to no one yet. Releasing is the delivered rung — value moving from escrow to the applicant, the same movement OA-L2 already carries between machines for other facts. The precise mapping of these two moments onto MALA's M0-through-M4 naming is Kaeden's to confirm, since the ladder is his design; this brief reads the hold as the M1 commitment and the release as the M2 delivery, and marks that reading as a proposal.

## The Invariants, Stated First

Money asks for its invariants before its algorithm, so these come first and the fold is built to preserve them. Each is a checkable property a witness can bind.

Conservation holds across the loop: the sum of every hold equals the sum of every release when a bounty completes, and the escrow balance returns to zero. No unit is created and no unit is destroyed inside the loop. No balance ever runs negative — not the poster's spendable balance after a hold, and not the escrow balance at any moment. A release reaches only the accepted applicant, only for the accepted request, and only in the amount that was held. A release requires a prior matching hold, a hold requires a prior acceptance, and neither a hold nor a release repeats — a second hold or a second release on the same bounty is refused at the fold. Every escrow fact is signed by the poster, because the poster commits and releases their own value, and the signature is verified as the fact folds. Every amount stays inside the signed-integer bound the receipt core already keeps, and the log stays inside its named length. The whole story is internal — own log, own keys, test units — so no external ledger and no real-dollar peg enters here; that crossing is the settlement rail, named separately and parked.

## The Smallest Encoding That Serves

The receipt core already holds the shape this needs. An escrow fact can reuse the same signed fact the completion payment uses today — a sender, a receiver, an amount, a memo, a stamp — and distinguish its role by a memo prefix, so a hold reads as an escrow-hold naming its request, and a release reads as an escrow-release naming the same request. The fold gains one projected value, an escrow balance, and two booleans beside the ones it already keeps, so held and released join posted, applied, accepted, and completed. Completion becomes the release: the fold asserts the release matches the accepted applicant, the accepted request, and the held amount, and that the escrow balance closes at zero. Reusing the existing fact keeps the wire format and the log grammar unforked, which is the same discipline OA-L2 kept when it carried facts across machines without inventing a second shape.

A distinct escrow fact shape is the alternative, cleaner to read and heavier to grow, and it earns its place only if the reused memo prefix ever strains. The recommendation is to reuse the receipt-core fact now and let a distinct shape graduate later if a second consumer asks for it.

## The Lap Ladder

The rung climbs in the same happy-zone spirit as every rung before it, smallest first, each lap a single closed claim.

The first lap proves escrow on one local log. The fold walks post, apply, accept, hold, release, and reads the bounty as pledged, then held, then released, then complete, with conservation asserted and the escrow balance closing at zero. The unwelcome paths are exercised and refused: a release with no prior hold, a release in the wrong amount, a release to the wrong applicant, and a second release on a settled bounty. This lap adds one witness and earns its parity number on Kaeden's metal, pinned there rather than predicted here.

The second lap, taken only if wanted, carries the escrow facts between machines exactly as OA-L2 carries the request and the application, so a hold and a release cross the hosted wire and the device wire under seal. The first lap holds the whole invariant story already, so this lap proves carriage rather than new money logic.

The horizon stays plainly named and unclimbed. Escrow graduates from the Open Asks log into a MALA module at its second consumer, per the graduation rule, carrying its invariants with it. Reputation-as-fold over completed bounties waits for OA-L4, where consent-before-counting governs every field. And the movement of real value — a bounty denominated in actual dollars — waits for the settlement rail, which the settlement verdict holds pending a witness and which this rung deliberately does not touch.

## Why No Chain Belongs Here

The settlement verdict named the safest settlement as the one we do not outsource, and OA-L3 is exactly that case. Because the escrow lives on our own append-only log, under our own keys, holding and releasing test units, it needs no external network to be correct or complete. The fold is the source of truth, the signatures are the proof, and conservation is checked in the open. An external rail enters the story only when a bounty must be paid in real dollars, and that is a separate rung with its own gate. Keeping OA-L3 internal keeps its trust surface small, which is the whole reason the escrow can be trusted at all.

## What Parks for Kaeden's Word

Four decisions rest with Kaeden, because each touches naming, ordering, or the value model. The escrow vocabulary parks first — the words hold and release, and the name of the escrow account itself, proposed here as candidates and unopened until Kaeden speaks them, per the rule that no new name enters the tree without his word. The encoding parks second — the reused receipt-core fact with a memo prefix, recommended here, against a distinct escrow shape. The home parks third, and it is the ordering question: escrow can grow inline in the Open Asks module now, in Gall's-Law fashion from the running seed, or it can wait for a dedicated MALA design lap, which the tasks currently place after the Edit-5 ruling and Amber's first lap; the inline path is safe because it stays internal and invariant-guarded, and the choice of whether to honor the stated MALA ordering or to let OA-L3 begin the money story early is Kaeden's. The ladder mapping parks fourth — which MALA rung the hold and the release each name.

## Gratitude

This brief stands on the ledger-map counsel that named MALA's single-issuer honesty and the monarch boundary, and on the receipt core whose signed fact already carried a payment cleanly enough that escrow needs only to grow a middle. The Open Asks laps before this one drew the shape that made the next one small.

---

*May the bounty be pledged in the open and paid in the open. May every unit the ledger holds be a unit the ledger can account for. And may the escrow that keeps faith on our own log be the ground a wider promise grows from, when its season comes.*
