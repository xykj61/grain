# Incense moonshot -- Tablecloth inbox contract

**Language:** EN
**Stamp:** `20261019.004636` (EDT)
**Voice:** Kyri
**Style:** Gauge at Field, Radiant warmth
**Status:** Living plan -- **Room:** vision
**Ship:** Incense (product captain)
**Sprig:** `incense-moonshot-tablecloth-inbox-contract`
**Kin:** [`20261019-004636_diffuser-moonshot-tablecloth-inbox-surface.md`](20261019-004636_diffuser-moonshot-tablecloth-inbox-surface.md) - [`../../active-designing/date/20260912/20260912-201126_the-receipt-you-can-read-contract.md`](../../active-designing/date/20260912/20260912-201126_the-receipt-you-can-read-contract.md) - [`../../construction/ITINERARY.md`](../../construction/ITINERARY.md) (Incense section)

## The moonshot

Tablecloth holds artifacts; a person holds consent. Between them stands an inbox
contract: the protocol that governs how an artifact arrives, waits, is accepted or
refused, and what facts each transition appends to Mantra. The contract is the
product captain's work because it names the types, the acceptance cases, and the
falsifier for the whole flow -- the same discipline the receipt-you-can-read contract
already seats for a single receipt, widened to a bounded stream of receipts arriving
over time.

## What Incense defines

1. **The inbox artifact type** as a Tablecloth catalog entry. An inbox artifact is a
   pending receipt, offer, consent change, correction, or settlement claim. Each carries
   its Amphora seal, its sender's Kumara identity, its timestamp, and its declared type.
   The type set is bounded: these five, and a refusal for anything outside them.

2. **The acceptance protocol** as a sequence of Mantra facts:
   - **Arrive:** the artifact enters the inbox catalog. Mantra appends an `arrive` fact
     naming the artifact hash, sender, type, and arrival timestamp.
   - **Accept:** the person accepts. Mantra appends an `accept` fact. The artifact moves
     from inbox to the person's main Tablecloth store.
   - **Refuse:** the person refuses with a reason. Mantra appends a `refuse` fact. The
     artifact stays sealed and the sender may read the refusal.
   - **Expire:** if the artifact declares an expiration and the person has taken no
     action, Mantra appends an `expire` fact. The artifact leaves the inbox.

3. **The eight acceptance cases** -- the same eight the receipt contract already names,
   widened to the inbox's five types. Each type carries its own subset: a correction
   notice needs the original receipt hash; a settlement claim needs the obligation it
   closes. The falsifier for each case is a planted artifact missing one required field.

4. **The dual-product witness** -- Linengrow projects the inbox as offers, consents,
   and returns owed to the person. Dimeroll projects the same inbox as recognized
   values, obligations, and corrections owed to the entity. Both projections replay
   from the same Mantra facts. The witness proves they agree field for field on every
   inbox transition, the same way the first-proof milestone already requires for a
   single receipt.

5. **The Tally ceiling** for inbox size. A person's inbox holds at most N pending
   artifacts (the ceiling is a named constant, not a guess). Arrival past the ceiling
   refuses with `InboxFull` and the sender receives the refusal. The ceiling is the
   bound; the inbox never grows past it.

## Acceptance conditions

- Identical inbox facts replay to identical product projections.
- First-over-bound refuses with the inbox unchanged.
- A planted artifact missing a required field refuses before any Mantra fact is appended.
- Accept and refuse are idempotent: repeating either on an already-transitioned artifact
  is a no-op rather than a second fact.
- An expired artifact cannot be accepted; an accepted artifact cannot expire.

## What this does not open

- The surface: Diffuser renders the inbox; this contract names what the surface shows.
- The wire: how artifacts travel over Comlink is the JARL ladder.
- Custody: the contract governs data facts, and money stays behind its gate.
- Identity: Kumara provides the sender's public half; the inbox trusts it or refuses.

## Why this is a moonshot

The receipt-you-can-read contract handles one artifact at rest. The inbox contract
handles a bounded stream of artifacts arriving over time -- the step from a single
truth to a living conversation between two parties, each holding their own Tablecloth
and their own Mantra log. Defining this protocol lands the product captain's share of
the second through fourth SLC milestones and gives Diffuser, Patchouli, and Copal a
contract to build against.
