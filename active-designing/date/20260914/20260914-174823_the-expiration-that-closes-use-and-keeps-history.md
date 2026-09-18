# The Expiration That Closes Use and Keeps History

**Stamp:** `20260914.174823` (EDT)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Reverse-reading packet -- **Room:** mixed; the cited product texts are checkable, while the disposition is a product reading
**Present priority:** [`The Receipt You Can Read`](20260912-201126_the-receipt-you-can-read-contract.md)

## The matter

The accepted receipt contract makes two promises about expiration. Replay is deterministic, and
replay at the expiration boundary changes a receipt from `offered` to `expired` while keeping its
fact reachable. Both can hold together only when the replay names the time it is evaluating. The
four public types name `issued_at` and `expires_at`, yet none names that evaluation input.

## Reverse walk -- newest to oldest

The accepted `20260912.201126` contract is the newest deciding edge. Acceptance case 1 requires a
second replay to be byte-identical. Case 5 requires replay at the expiration boundary to change
status without erasing the admitted fact. The contract does not say whether that boundary arrives
as an argument, a fact, or an ambient clock read.

The `20260912.142909` Linengrow itinerary keeps one expiration visible in the first whole. Its next
milestone adds grant and revoke facts, so expiry in this first receipt is narrower: it classifies an
offer at a stated time and grants no authority by itself.

The oldest deciding premise is [The Foundation Beneath the Work](../foundations/20260628-121512_the-foundation-beneath-the-work.md),
written `20260628`. It says state is a pure fold over an append-only log of signed facts so a person
can recompute the truth. A fold that consults an unnamed wall clock gives two answers from the same
facts and hides the deciding input from the person doing the recomputation.

## Forward judgment -- oldest evidence first

The pure-fold premise keeps the admitted offer immutable. Expiration belongs in the projection,
computed from `expires_at` and one explicit evaluation stamp. The same facts plus the same stamp
must produce the same `ReceiptState`; a later stamp may produce `expired`. The replay receipt should
name that stamp so a witness can distinguish a changed input from nondeterminism.

**Disposition: REVIVED.** The first dual-product witness should pass an explicit `evaluated_at`
stamp into replay, prove equality for two runs at the same stamp, and prove the boundary with two
named readings: one immediately before `expires_at` and one at it. Both readings must leave the
admitted fact bytes unchanged. This revives the oldest pure-fold promise at the exact seam where an
ambient clock could otherwise enter unseen.

## Evidence and handoff

- Oldest deciding premise: `foundations/20260628-121512_the-foundation-beneath-the-work.md`; state is
  a pure fold over signed facts that a person can recompute.
- Living product edge: `active-designing/20260912-201126_the-receipt-you-can-read-contract.md`;
  deterministic replay and expiration-boundary replay are both acceptance conditions.
- Handoff: Incense owns contract wording. Patchouli owns Mantra and Tally implementation. They can
  choose the public parameter name and representation while keeping the evaluation stamp explicit.
  No module file or accepted contract moves in this lap.
