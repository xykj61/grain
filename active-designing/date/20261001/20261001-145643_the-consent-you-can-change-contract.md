# The Consent You Can Change -- product contract

**Stamp:** `20261001.145643` (EDT)
**Language:** EN
**Style:** Bhakta with Gauge's Field discipline
**Voice:** Kyri
**Status:** Accepted for bounded synthetic implementation on Keaton's `20261001.200649` word -- local and synthetic, the same bounds as the receipt contract. No money, no real identity, no network, no legal claim. **Vision room** until the first witness passes: the fixture, types, bounds, and cases below are the implementation. Patchouli lowers `ConsentGrantFact` and `ConsentRevokeFact`. Petrichor teaches the fixtures once that witness is green.
**Milestone:** The consent you can change ([`construction/ITINERARY.md`](../../../construction/ITINERARY.md) row 2 of the growth ladder)
**Falsifier:** If one replay of a grant and its later revoke cannot produce both "currently granted" and "currently revoked" readings from the same two admitted facts, or a revoke can erase the grant's own history, this contract is wrong.

## The promise

One person who has already offered a receipt (milestone one) can grant a named recipient permission to use it for one stated purpose, and can later revoke that permission. The moment a revoke lands, any further permitted use refuses. The grant itself, and the fact that it happened, stay in the record forever -- revoking a permission leaves that history standing exactly as it stood.

This milestone stays local and synthetic, exactly as the first did. It moves no money, uses no real personal data or identity, opens no network service, and makes no legal claim about what "consent" means in a jurisdiction. It teaches one small, honest thing: a yes a person gave can become a no, and the record of both stays whole.

## Why this needs its own milestone, in plain words

Milestone one's receipt already carries a `purpose` field and an `expires_at` time. A reader could ask: doesn't the receipt already say what it's for and how long it lasts? It does -- and that is exactly why consent has to be a *separate* fact rather than a field on the receipt. The receipt is what was offered. Consent is whether that offer is, right now, still good to act on. Folding the two together would mean revoking consent requires editing the receipt itself, which would mean the receipt could say something different tomorrow than it says today. A receipt that can quietly change what it said has already stopped being trustworthy. So a grant and a revoke are their own facts, appended beside the receipt rather than written into it, and a replay of both together is what tells you today's answer.

## The one fixture

Every first witness uses these values, building on milestone one's own fixture
(`receipt_id receipt:sample-pollinator-counts:20260912`). A test may change one field to prove a
refusal; the passing case stays byte-identical.

**The grant:**

```text
schema                 grain.consent-grant.v1
grant_id               consent:sample-pollinator-counts:grant-1
receipt_id             receipt:sample-pollinator-counts:20260912
holder_id              person:sample-holder
recipient_id           org:sample-steward
scope                  habitat-planning-read-only
granted_at             20260912.130000-0400
signer_id              person:sample-holder
signature              fixture-signature-v1
```

**The revoke:**

```text
schema                 grain.consent-revoke.v1
revoke_id              consent:sample-pollinator-counts:revoke-1
grant_id               consent:sample-pollinator-counts:grant-1
holder_id              person:sample-holder
revoked_at             20260915.090000-0400
signer_id              person:sample-holder
signature              fixture-signature-v2
```

`scope` names the one bounded use the recipient may make of the receipt's product -- narrower than
or equal to the receipt's own `purpose`, never wider. `signature` is a deterministic test signature
accepted only by the fixture verifier, exactly as milestone one's. Neither fixture value may be
presented as production cryptography.

## Public types

The seam exposes four types, continuing the count milestone one began rather than restarting it.
Their names describe their jobs; module-private storage and drawing types stay private.

```text
ConsentGrantFact
  schema, grant_id, receipt_id, holder_id, recipient_id
  scope, granted_at, signer_id, signature

ConsentRevokeFact
  schema, revoke_id, grant_id, holder_id
  revoked_at, signer_id, signature

ConsentState
  grant: ConsentGrantFact
  revoke: ConsentRevokeFact | none
  status: granted | revoked

LinengrowConsent
  grant_id, receipt_id, recipient_id, scope
  granted_at, status, revoked_at | none
```

`ConsentGrantFact` and `ConsentRevokeFact` are the shared immutable inputs, exactly as
`ReceiptOfferFact` was milestone one's. `ConsentState` is Mantra's replay result: the grant always
stands, the revoke is present only once one has been admitted, and `status` is the one word that
answers "can this recipient act on this receipt right now." `LinengrowConsent` is what a person
sees: who was granted what, when, and -- when it applies -- when that grant was revoked. The
revoked record is never removed from the view; it is shown, named, and dated.

No public type contains raw product bytes, a private key, mutable widget state, or a Dimeroll
account number. **Dimeroll holds no projection of consent in this milestone** -- a grant or a
revoke is a permission fact, not a value fact, and Dimeroll's own residence (books: value,
obligation, settlement) has nothing yet to recognize. This mirrors the braid discipline milestone
one already proved: a type belongs to the room whose question it answers, and "may this recipient
act" is Linengrow's question alone.

## Bounds and refusals

Tally declares these ceilings before Mantra appends anything, following the same derivation
discipline milestone one settled on `20260918.100854` -- each number sized to what the field
actually needs, rather than borrowed from a wider neighbor.

| Field or population | Ceiling | Unit |
|---|---:|---|
| encoded grant fact | 1024 | bytes |
| encoded revoke fact | 512 | bytes |
| each identifier (grant_id, revoke_id, receipt_id, holder_id, recipient_id, signer_id) | 96 | ASCII bytes |
| scope | 80 | ASCII bytes |
| signature | 192 | ASCII bytes |
| consent facts in this replay | 2 | facts (one grant, at most one revoke) |

`scope`'s ceiling matches the receipt contract's `purpose` ceiling exactly, since a scope is a
purpose statement read against an already-admitted receipt rather than a new kind of value. The
grant and revoke encoded-fact ceilings are each smaller than the receipt's 4096-byte ceiling,
because neither carries a value amount, a product digest, or an expiration -- a grant or a revoke
says who, what, and when, and nothing more.

Admission refuses before durable state changes when a required field is empty, text is non-ASCII,
a ceiling is exceeded, the schema is unknown, the signature fails, a revoke names a `grant_id` with
no admitted grant, or a revoke's `holder_id` does not match the grant it names. A refusal names
`field`, `value`, `ceiling`, `unit`, and `reason` where a ceiling applies; other refusals name the
field and reason -- the same shape milestone one's refusals already take, so a reader who learned
one learns both.

## Module residences

| Residence | Owns |
|---|---|
| Kyri | canonical encoding and decoding of `ConsentGrantFact` and `ConsentRevokeFact` |
| Tally | field, identifier, and fact-count ceilings above |
| Mantra | append-only admission and deterministic replay to `ConsentState` |
| Linengrow | `ConsentState -> LinengrowConsent` |
| Brushstroke | the bounded Consent Rail description, read from `LinengrowConsent` |
| Skate | the Consent Rail's still frame and accessibility snapshot |
| Brix | the declared build and proof closure; no product state |

Dimeroll, Amphora, Comlink, Caravan, Pond, Granary, Mandi, MUR, Lantern, Mycelium, and Cellar stay
out of this milestone, exactly as they stayed out of milestone one. The Consent Rail named in
`construction/ITINERARY.md` row "Acceptance case 4" waits on this contract's `ConsentGrantFact` and
`ConsentRevokeFact` existing -- this page is that waiting answered.

## Acceptance cases

One witness runs every case against the same two admitted facts and proves prior durable bytes
remain unchanged after every refusal.

1. **Admit the grant.** Encode, verify, append, and replay the grant fixture alone. `status` reads
   `granted`. A second replay is byte-identical.
2. **Read as Linengrow, granted.** The projection shows recipient, scope, grant time, and `granted`
   status, with `revoked_at` absent.
3. **Admit the revoke.** Append the revoke fixture against the already-admitted grant and replay
   both. `status` reads `revoked`.
4. **Read as Linengrow, revoked.** The projection shows the same recipient, scope, and grant time
   as case 2, now carrying `revoked` status and the revoke time. Every one of the grant's own
   fields stays exactly as case 2 read it -- revoking changes only the status read on top of
   the grant.
5. **History stays visible.** After case 3, the grant fact remains reachable by replay exactly as
   it stood after case 1. A revoke appends a new fact beside the grant, leaving the elder one standing.
6. **Refuse an orphaned revoke.** A revoke naming a `grant_id` with no admitted grant refuses
   before append, and durable state is unchanged from before the attempt.
7. **Refuse a mismatched revoke.** A revoke whose `holder_id` differs from the grant's own
   `holder_id` refuses before append.
8. **Refuse incomplete or false input.** Removing each required field from either fact, or
   changing either signature, refuses by that field's name before append.

## Completion and review edge

The milestone lands only when the same two admitted fixtures pass all eight cases on metal and the
falsifier stays false. Keaton's `20261001.200649` word accepted this page for implementation.
The first replay, grant then revoke with the grant left standing, is witnessed, and so is the
mismatched-holder refusal. An empty `grant_id`, `receipt_id`, and `holder_id` are the first three incomplete-field witnesses.
The other fields, and the false signature, stay proposed until their own witnesses pass.

A sibling task was named for Pheromone: sketching `GrantFact` and `RevokeFact` as Glow
shapes -- field names, ceilings, one refusal case each -- sized the way milestone one's desk was
before any code existed. [That sketch now
stands](20261001-181632_grant-and-revoke-fact-glow-shapes.md), and it and this contract describe
the same two facts from two directions -- the prose promise here, the Glow shape there -- and each
stands ready to be read on its own.

May the yes a person gives stay as plain as the no that follows it, and may both remain readable,
side by side, in the record they share.
