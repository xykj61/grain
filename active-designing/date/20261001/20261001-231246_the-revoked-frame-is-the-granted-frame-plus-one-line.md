# The revoked frame is the granted frame plus one line

**Stamp:** `20261001.231246` (EDT)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Vision -- no witness binds this page. It proposes a field selection and row order for
a still-frame rendering of `ConsentState` that no type in this tree reads today.
**Falsifier:** If a future consent card needs a field this page leaves off either frame -- the
signer, the grant id, the receipt id, the raw signature -- to do its job, the selection below is
wrong and should be revised rather than carried forward unchanged.
**Related:** [`mantra/src/consent_replay.rye`](../../../mantra/src/consent_replay.rye) --
[The receipt you can read](../20260912/20260912-201126_the-receipt-you-can-read-contract.md),
whose own `ReceiptCard.stillFrame()` names the pattern this page borrows --
[The consent you can change](20261001-145643_the-consent-you-can-change-contract.md), the contract
this page reads `ConsentState` from -- [No caller wants a mutable identity](20261001-193541_no-caller-wants-a-mutable-identity.md),
the prior lap on this same ladder.

## The question, named plainly

Milestone one's receipt card has a still frame: a fixed, row-ordered rendering of a
`ReceiptState` that a Swift view draws and an accessibility reader walks back in the same order
(`skate/Sources/SkateCore/ReceiptCard.swift:115`, `ReceiptAccessibilitySnapshot.swift`). Milestone
two's `ConsentState` (`mantra/src/consent_replay.rye:58`) is still waiting for that frame: this
pier carries only Rye and Rishi, so Item 2 of the receipt contract already waits on a macOS-capable
lap (`diffuser-inner.md`, ruled `20261001.200649`). This page names the two frames a future
still-frame reader would need, reasoned from the fixture alone: one for a grant standing alone,
and one for a grant a revoke has reached.

## What `ConsentState` actually holds

```zig
pub const ConsentState = struct {
    grant: ConsentGrantFact,
    revoke: ?ConsentRevokeFact,
    status: Status,  // .granted or .revoked
};
```

`ConsentGrantFact` carries nine fields (`grant_fact_fields: u32 = 9`): `schema`, `grant_id`,
`receipt_id`, `holder_id`, `recipient_id`, `scope`, `granted_at`, `signer_id`, `signature`.
`ConsentRevokeFact` carries seven (`revoke_fact_fields: u32 = 7`): `schema`, `revoke_id`,
`grant_id`, `holder_id`, `revoked_at`, `signer_id`, `signature`. `Log.replay()` keeps the grant
exactly as written when a revoke lands: `append_revoke` asserts `grant_eql(self.grant.?,
grant_before.?)` immediately after writing the revoke slot, which is the contract's own structural
proof that revoking leaves the grant's history standing exactly as it stood.

## The two still frames

A still frame is a reader-facing projection, standing apart from the admitted fact itself.
`ReceiptCard` already draws this line: the card holds ten fields of the eleven a `ReceiptOffer`
admits, in a fixed row order, keeping `signature` and the raw schema string off the screen
entirely. Following that precedent, a consent still frame shows what a recipient or holder needs
to read to know where a permission stands -- **recipient, scope, granted_at, status, and
`revoked_at` when the revoke slot is set** -- and leaves `grant_id`, `receipt_id`, `holder_id`,
`signer_id`, and every `signature` off the card. Those five fields are custody, proven once at
admission time by the witness, and they stay there: a person asking "can this still be used"
re-reads the five display fields, rather than the five custody fields the witness already closed.

**The granted still frame**, read from a `ConsentState` whose `revoke` is `null`:

```text
recipient  org:sample-steward
scope      habitat-planning-read-only
granted    20260912.130000-0400
status     granted
```

**The revoked still frame**, read from the same state after a revoke replays:

```text
recipient  org:sample-steward
scope      habitat-planning-read-only
granted    20260912.130000-0400
status     revoked
revoked    20260915.090000-0400
```

## The one finding worth writing down

The two frames above are one card wearing two faces. The revoked frame is the granted frame with
one row appended and one word changed. `recipient`, `scope`, and `granted` stay byte-identical
across both, and `grant_eql` is exactly why: the contract already proves, at the fact level, that
a revoke leaves the grant it stands beside untouched, and this page's only contribution is
pointing out that a still-frame reader inherits that proof for free. A future `ReceiptCard`-shaped
`ConsentCard` wants one frame-builder rather than a `revoked` variant and a `granted` variant with
different field sets: draw the first four rows from the grant and `status`, then append a fifth
row exactly when `state.revoke` is set. One code path, one append, rather than two cards to keep
in sync.

## What this page leaves for another lap

This page leaves `LinengrowConsent`, a `ConsentCard` Swift struct, and any projection for a later
lap: both types stay absent from `linengrow/` and `skate/` today, and naming that gap is as far as
this page goes. `Settle` and `Respond` beside `Still` on the Skate grid stay Item 2's own question,
and Item 2 waits on a macOS build this host lacks. A wire format, a byte-column layout, and a card
width stay outside this page's scope too: `ReceiptCard`'s 72-by-18 plane was a Swift-side decision
made against real terminal and screen-reader constraints, and checking those constraints would
need the same macOS build Item 2 is already waiting on.

## Assumptions, and what would overturn them

**Assumption:** the five fields excluded above (`grant_id`, `receipt_id`, `holder_id`,
`signer_id`, `signature`) are custody rather than display. `ReceiptCard` draws a looser line for
the same reason: its own admitted fact carries fewer identity-bearing fields to begin with, so ten
of eleven reach the screen, against this page's four of nine. This page's selection is a
judgment call rather than a measured fact. **Confidence:** medium -- reasoned from one precedent,
unverified against any real reader's need. **Falsifier**, restated: a `ConsentCard` that needs
`holder_id` to disambiguate two grants on one screen, or `grant_id` for an audit trail a user can
click through, would prove this page's exclusion list too narrow.

## Grade

Graded at Field: register leads with what is (`ConsentState` holds, `Log.replay` asserts), every
claim about the code cites a line or a field name rather than a restated feeling, and the one
finding -- one frame-builder, one conditional row -- is stated once rather than repeated. The two
open questions (Item 2's macOS build, the field-selection judgment call) are named as open rather
than answered past what this host can prove.
