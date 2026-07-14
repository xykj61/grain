# Claude Counsel — MALA Graduation Has Not Fired, and a Sharper Finding Underneath It

**Stamp:** `20260707.023512 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`) · **Lens:** TAME · the grain · graduation rule
**Register:** Counsel only, on the seam explicitly named as needing a seated ruling
**Status:** Research for understanding — counsel only; checkable claims cite code on disk; seats nothing by itself
**Ground:** `linengrow/open_asks.rye` (`classifyFact`, `foldReputationLog`, `foldEscrowLog`, `appendCompletedAsk`, read in full) · `active-designing/20260706-013012_open-asks-escrow-hammock.md` · `context/specs/20260702-035018_graduation-rule.md`

*Written by Kaeden and Rio 3.*

---

## First, Two Quiet Confirmations

The SIGTERM ring landed exactly as the last counsel described it — one atomic store, both signals, the loop-top block unified rather than duplicated — and I2's snapshot lap reused `resin_batch.rye`'s grammar exactly as the `232812` ruling asked. Neither needs more from this bench today.

## The Question Asked, Answered Directly

**MALA's graduation has not fired.** The graduation rule is precise about what counts: *a module that imports and relies on the aspect's public surface* — not the host using its own submodule internally. Reading `foldReputationLog` end to end, it never calls `foldEscrowLog`, never reads the escrow balance, never checks a hold or release fact by name. Its own `switch` recognizes exactly five fact kinds — request, application, acceptance, completion, consent — and none of the branches touches escrow's vocabulary at all. What actually sits in `linengrow/open_asks.rye` is two independent folds reading two disjoint slices of one shared log, not one depending on the other's surface. That is not yet the second consumer the rule asks for.

## The Finding Underneath, Which Matters More

Reading closer than the graduation question required turned up something worth more of Kaeden's attention than the naming question did. `classifyFact` buckets *any* fact carrying `from` and `amount` as `.completion` — a plain payment, an escrow hold, and an escrow release all land in that one bucket, because at the receipt-core layer they are the same shape. `foldEscrowLog` already knows this and reads the memo afterward to tell the three apart. `foldReputationLog` does not: its `.completion` branch requires the memo to start with the exact string `"completion request_ref="`, and an escrow-release fact's memo starts with `"escrow-release request_ref="` instead — a different string entirely. The two never match. A log containing an escrow-mediated bounty would reach that branch and return `error.FoldFailed`, whole, the moment the fold's own hardening — refuse rather than half-believe — does exactly what it is built to do.

The reason parity has never caught this is worth stating plainly: `appendCompletedAsk`, the very witness-bolt builder OA-L4's own selftest uses, writes only the plain `"completion request_ref="` memo, on every path, in every unwelcome case this bench found. The witness cannot fail on an interaction it never constructs. And the escrow-hammock brief is unambiguous about which path actually matters: escrow is named there as *"the smallest honest form of MALA's ladder,"* the very mechanism this project has been building toward since OA-L3, where *"completion becomes the release."* A reputation fold that cannot read the payment path its own foundation calls the honest one is a real gap, quietly waiting behind a green witness that never asked it the one question that would have found it.

## Two Shapes for the Fix, Named Rather Than Chosen

The smaller fix teaches `foldReputationLog`'s completion branch to recognize a second memo prefix — treat an escrow-release exactly as a completion for reputation purposes, matching the hammock brief's own reading, and skip an escrow-hold silently rather than mistaking it for a payment at all, since a hold alone is a promise, not a delivery. This costs one more string comparison and no new dependency; it does not touch escrow's own fold, and it does not change what OA-L4 imports.

The deeper fix has the reputation fold ask escrow's own logic whether a bounty's value truly moved, rather than re-deriving the same answer from a second reading of the same memo strings. That version is the one that would genuinely satisfy the graduation rule's own test — *if the host module vanished, would this other capability still need this under its own name* — because at that point OA-L4 would be a real second reader of the escrow aspect's answer, not a parallel guesser at the same fact through a narrower keyhole. This bench names it and does not choose it; it is a real design decision about how tightly reputation should lean on escrow's own word, and that decision sits inside the value-model seam Kaeden's own recommendation already flagged as his to make.

## The Direct Answer, Restated

Hold graduation. It has not triggered by the rule's own test, and building `mala/` today would be extracting a boundary that has not yet become real, the same *breadth thinning depth* the rule already refuses for Weave. Close the fold-compatibility gap first, with the smaller fix at minimum — a reputation fold that cannot process the honest payment path is worth fixing regardless of what MALA ever becomes. And it is worth asking, once that word comes, whether the fix is written the smaller way or the deeper way, because only the deeper way is the thing that would actually answer this counsel's own question the next time it is asked.

## Witness Shape for the Fix, Sketched

Extend OA-L4's own witness bolt with one bounty paid through escrow — a hold at acceptance, a release at completion, exactly as `foldEscrowLog`'s own witness already proves elsewhere on this tree — sitting beside the plain-completion bounties the fold already handles, one of the escrow-paid bounties consented and one withheld. The fold should recognize the escrow-paid bounty exactly as it recognizes a plain one: counted when consent was granted, excluded when it was withheld, and refusing whole only on a genuine fault, never merely because the payment took the honest path rather than the plain one.

---

*May a fold refuse whole exactly when something is truly wrong, and never merely because it was never taught to recognize what is right. May a boundary graduate only the day it is real, and stay a promise until then. And may the next reading of one log always find both readers speaking of the same money, however differently they arrived at knowing it moved.*
