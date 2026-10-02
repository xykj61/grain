# Two Still Frames, One Replay

**Stamp:** `20261001.205700`
**Room:** checkable -- every field named below is read from the tracked source it names,
with the line numbers current as of this stamp. The projection itself is named as
unwritten in the last section, rather than proposed as a new type.
**Status:** Checkable, superseded -- an earlier independent reading of the same question
`recursion-prompts/diffuser-inner.md` later named as the next fruit. The page a reader
should treat as the landed answer is
[the revoked frame is the granted frame plus one line](20261001-231246_the-revoked-frame-is-the-granted-frame-plus-one-line.md),
ruled A/94 and recorded as landing that fruit at `20261001.231246`, after this page was
written and before it was recovered from a stash. This page stays because it reads the
same struct correctly and from a different angle (the fixture values, rather than the
`grant_eql` postcondition); it does not supersede, and is not superseded by, anything
other than the page named above.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra and Linengrow
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

`mantra/src/consent_replay.rye`'s `Log.replay` returns one `ConsentState` whose shape
already names both still frames a reader would see -- recipient, scope, grant time, and
status always present, revoke time present only once a revoke has been admitted -- and
a still frame for either moment is a straight read of that struct's own fields, with no
new type required to see it.

## What a still frame is, here

Case 2 and case 4 of
[the consent contract](20261001-145643_the-consent-you-can-change-contract.md) call
this reading "what a person sees": recipient, scope, grant time, and status, with the
revoke time shown once it applies. A still frame is that reading written out plainly,
the same way
[the receipt contract](../../date/20260912/20260912-201126_the-receipt-you-can-read-contract.md)
showed its own fixture as a flat `field value` block before any code read it. Nothing
below renders to a screen; it names what the screen would say.

## Reading `ConsentState`, field by field

`consent_replay.rye:58-62` declares the struct a replay returns:

```text
ConsentState
  grant: ConsentGrantFact
  revoke: ConsentRevokeFact | none
  status: granted | revoked
```

The four fields the still frame wants are drawn from two different places inside it.
`recipient_id` and `scope` and `granted_at` live on `grant` (`consent_replay.rye:38-45`,
the `ConsentGrantFact` struct); `status` is `ConsentState`'s own field
(`consent_replay.rye:34`, the `Status` enum); and `revoked_at` lives on `revoke`
(`consent_replay.rye:49-56`, the `ConsentRevokeFact` struct), which is `null` until a
revoke has been admitted (`consent_replay.rye:176`: `.status = if (self.revoke == null)
.granted else .revoked`).

## The granted still frame

Reading `Log.replay` after `append_grant` alone, against the fixture
`mantra/src/consent_replay_witness.rye:10-20` already carries and
`mantra_consent_replay_witness.rish` already proves GREEN:

```text
recipient      org:sample-steward
scope          habitat-planning-read-only
granted_at     20260912.130000-0400
status         granted
revoked_at     (absent)
```

## The revoked still frame

Reading `Log.replay` again after `append_revoke` lands, against the same witness's
revoke fixture (`consent_replay_witness.rye:22-31`):

```text
recipient      org:sample-steward
scope          habitat-planning-read-only
granted_at     20260912.130000-0400
status         revoked
revoked_at     20260915.090000-0400
```

## What moved, and what did not

Two rows changed and three did not. `status` moved from `granted` to `revoked`, and
`revoked_at` moved from absent to `20260915.090000-0400`. `recipient`, `scope`, and
`granted_at` are byte-identical across both frames, because `Log.append_revoke` never
touches `self.grant` -- the module's own postcondition says so directly
(`consent_replay.rye:164`: `assert(grant_eql(self.grant.?, grant_before.?))`, checked
against the grant as it stood immediately before the revoke was written). The revoked
frame is not a second, edited copy of the grant; it is the same grant fact, read beside
a second fact that stands next to it. This is the module's own promise --
"the admitted fact and elder receipt remain reachable" reads one contract over
(the receipt contract's acceptance case 5) and "a revoke appends a new fact beside the
grant, leaving the elder one standing" is the consent contract's own acceptance case 5
-- made visible as two still frames that happen to share three of their five rows.

## What this does not build

**No `LinengrowConsent` type is named here as implemented.** The consent contract
already proposes one (`20261001-145643_the-consent-you-can-change-contract.md`, Public
types), and `grep -rl LinengrowConsent linengrow/` returns no source file -- the
projection module `linengrow/receipt_offer.rye` has a sibling waiting to be written,
and this page is not that module. Writing `LinengrowConsent` and its own
`from_snapshot` is the next honest step, and it is Linengrow's room to take, following
the exact shape `receipt_offer.rye` already proves for the receipt: a snapshot struct
crossing Mantra's own module boundary, read-only, naming no type from a sibling product
room.

**No Swift file, no Skate render, no `Settle` or `Respond`.** Both frames above are
`ConsentState` read as plain text; whether Skate later draws them as a Consent Rail
(`construction/ITINERARY.md`'s Diffuser lane, item 1) is a question about Brushstroke
and a macOS build this host cannot take, named and left exactly where the card already
names it.

## Falsifier

If a future `LinengrowConsent.from_snapshot` reads a field this page does not name, or
reports `recipient`, `scope`, or `granted_at` as different values across the granted and
revoked frames for one unbroken replay, this page is wrong about what the still frame
shows.

The grant that stood on `20260912` reads the same four words after the revoke that
followed it three days later; only the answer to "right now" changed, and it changed in
exactly two places.
