# The Kumara Passport — the divider grammar, carried on-chain

**Language:** EN
**Stamp:** `20260810.060041` (2026-08-10 06:00 EDT)
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Voice:** Riyo
**Style:** Radiant · a design brief — no code, one witnessed lap named
**Equinox:** JARL (Identity & Network) · a settlement door past names
**Grounds:** `expanding-prompts/20260810-044453_the-3x39-baton-passports-dividers-and-starseeding.md` (the vision baton) · Keaton's own ©2025 "3x39" concept

---

## What this builds

A **Kumara passport** is a settled point's signed claim to a **divider-token** — a short, pronounceable, predictably-spellable string that fastens a name to that point across the incumbent namespaces a family never left. The passport is a new **tilak**, the sixth in the family that already carries point · bind · turn · cap · sponsor (`kumara/tilak.rye`). It says, in one signed record: *this settled point owns this divider-token, in this position, provable on this chain.*

The passport is the bridge Keaton's baton named — the identity a Kumara point already holds on Grain's own d12·d60 fractal, carried whole into the world of `.sol`, `.sui`, DNS, and the platforms where people still are. It touches no chain and holds no key in the tree; the on-chain proof is an attestation the maintainer's own hand produces, off-tree, and the passport records only its **digest**.

## The divider grammar, stated plainly

A claimable token is always one of three shapes, and the passport names which:

- **prefix** — the token leads the name. `hqkvez` before a handle.
- **suffix** — the token trails it. The "3x39" exemplar (*three-ex-three-nine*): append it to a username and the pair is unambiguous across nearly every platform.
- **middle** — the token divides a name from within. Keaton owns `xykj61`, so `kj` sits as a *middle* divider inside it.

The grammar is small on purpose: three positions, one bounded token, one point. A five-year-old can spell it; an artist can decorate around it; a machine can verify it. The token itself is the maintainer's own ©2025 concept, and **how it enters Grain — as a Grain concept, a product, or this passport primitive — stays Keaton's call.** This brief designs the *primitive* only, ready for his word, and grounds "3x39" solely as the exemplar that taught the shape.

## The passport tilak — shape

The passport follows the tilak grammar already proven five times over: a fixed-length canonical message, a keeper signature over it, a version that climbs by exactly one. Nothing here departs from the family a reader of `tilak.rye` already knows.

The fields, in our own words:

| Field | Meaning |
|---|---|
| **point** | the settled point number this passport speaks for (`u32`, inside the d12·d60 universe) |
| **token** | the divider-token — bounded lowercase bytes, the same DNS-safe alphabet a name uses, so it can never be mistaken for anything but a token |
| **position** | `prefix` · `suffix` · `middle` — an `enum(u8)`, the divider grammar's three shapes |
| **realm** | which namespace the on-chain proof lives on — `sol` · `sui` — an `enum(u8)`, so a passport names its ground |
| **attestation** | a 32-byte **digest** of the off-tree on-chain proof (a `.sol`/`.sui` ownership record the maintainer's hand produced); the passport commits to it without ever holding the chain or a key |
| **sig** | the keeper's signature over `point ++ token_digest ++ position ++ realm ++ attestation` |
| **version** | climbs by exactly one per change, like every tilak |

The message the keeper signs is fixed-width and canonically ordered, exactly as `Cap.message` and `Sponsor.message` are: the point as little-endian `u32`, the token as its SHA-256 digest (so the signed message is fixed-length no matter the token's spelling), the position and realm bytes, and the attestation digest. A stack buffer holds it; no allocation, no unbounded field.

Why the **keeper** signs, not the identity key: a passport is a custody claim about a name, the same act as claiming a `Cap` or a spoken name — it is the keeper's word that this point owns this token. The keeper already owns the point and grants its powers (`Bind`, `Cap`); the passport is one more thing the keeper says with a signature, and one more thing any reader verifies against the keeper's public key.

## How it composes with settlement/names

Two name-surfaces meet here, and they stay distinct on purpose:

- A **name** (`settlement/names.rye`) is Grain's *internal* spoken label — "alice" resolving to a point inside the shared `NameRegistry`, globally unique on Grain's own consensus surface. It is how the fractal speaks a number as a word to its own network.
- A **passport** is Grain's *outward* claim — the same point's ownership of a divider-token in the *incumbent* namespaces (`.sol`, `.sui`, DNS, platforms), proven by a chain Grain reads rather than owns.

They rhyme by design. Both are custody, not registration: a passport, like a name claim, requires the point to be **settled** (its `Deed` verifies against the `Constellation` by digest, `settlement.verify(con, deed)`) and requires the keeper to **sign the exact token**. A hand that does not own the point can seat neither.

They differ in reach. A name lives on Grain's shared surface and must be unique *there*. A passport's uniqueness lives on the *foreign* chain — Solana or Sui decides who owns `hqkvez` — so the passport does not adjudicate that; it **records and verifies a claim** whose ground truth is the attestation digest. Grain's own bounded **passport registry** (a sibling of `NameRegistry`) can hold at most one passport per (point, realm) for this first lap — one point may carry one token per chain — so the shared surface stays small and legible, and the refusals stay crisp.

This keeps the shared surface honest: Grain never pretends to own the incumbent namespace. It says only "this settled point presented a proof it owns this token, and the keeper signed that claim" — and that sentence is exactly what a passport verifies.

## Custody first — where the chain is, and is not

The on-chain proof is **the maintainer's own hand**, and it never enters the tree:

- **No key, ever.** The passport holds a 32-byte attestation digest, never a private key, never a wallet, never a signing seed. The example seeds are the same plain, obviously-fake `0x11…` / `0x22…` bytes every tilak selftest uses.
- **No chain touched.** The Rye code models what a passport *is* and proves it verifies and refuses; it makes no RPC, signs no transaction, and reads no live ledger. The `.sol`/`.sui` proof is produced off-tree, by Keaton, and only its digest is committed — the same clean-room posture `constellation.rye` keeps with Sui ("no Move, no wallet, no key, no chain touched").
- **No real token as a claim.** Example tokens are plain words used to teach the grammar (`hqkvez` appears only as the baton's own exemplar); no example seats a *real* party's *real* on-chain ownership as settled. Keaton's real tokens are his to seat, by his hand, when he words it.

The attestation digest is the seam between two worlds. Off-tree, a real ownership proof exists on a real chain. In the tree, we hold its fingerprint and a keeper's signature that binds it to a settled point. Verifying the passport proves the *binding* is authentic; trusting the *attestation* is a separate act, done by whoever checks the digest against the live chain — named honestly, never pretended to be free, exactly as topology's cross-galaxy hop is counted rather than hidden.

## The name — "passport"

**passport** is clear, warm, and safe. A newcomer knows what a passport is the instant they hear it: a document that carries your identity across a border you did not dissolve. That is precisely the act — a Kumara point carrying its name across the border into the incumbent namespaces.

Grep confirms it is free to seat: **zero** hits in `.rye` / `.rish` / `.brix` / `.bron`, and a single `.md` hit — the vision baton itself, where Keaton's own word introduces it. It collides with nothing seated, borrows no sacred term, and can never parse as an `@p` address. It is the maintainer's own chosen word, and the comlink-tendency asks for exactly this: the plainest true word, at whatever length it wants to be.

The subordinate words follow the same test:

- **token** — the divider string. Ordinary, exact, already understood.
- **position** — prefix · suffix · middle. Plain geometry.
- **realm** — the chain a proof lives on. Warm, and true: a realm is a domain with its own law, which is what Solana and Sui each are to a name.
- **attestation** — the digest of the off-tree proof. The precise word for "a record that testifies something is so."

## The first witnessed lap

The smallest honest first lap seats the passport tilak beside its five siblings and proves it the way every tilak is proven — made, signed, verified, refused on tamper — plus the one composition that makes it a *settlement* door: a passport claim binds only to a **settled** point.

**One selftest, one witness, GREEN**, in the shape of `settlement/names.rye` and `tools/settlement_names_witness.rish`:

1. **Seat a passport** — from a settled world's `Deed` (a star, say, minted in `seat_world`'s manner), the keeper signs a passport binding token `hqkvez`, position `prefix`, realm `sol`, and a fixed example attestation digest. The passport seats at version one.
2. **Verify it** — `verify_passport(passport, con, deed, keeper_pubkey)` holds: the point is settled (its Deed verifies against the constellation), and the keeper's signature over the canonical message checks.
3. **Refuse every tamper** — a flipped signature byte refuses; a changed position (`prefix` → `suffix`) refuses; a changed realm refuses; a changed attestation digest refuses; a swapped token refuses. Each is a distinct signed field, so each tamper breaks the signature.
4. **Refuse the unsettled** — a passport for a **ghost** point (an `unsettled_deed`, the same device `names.rye` uses) refuses with `NotOwner`: no proof of settlement, no passport. This is the composition with settlement — the whole reason a passport is a *settlement* door and not a free-floating claim.
5. **Refuse the duplicate** — a second passport for the same (point, realm) refuses with `AlreadyPassported`, the primary-per-realm policy for this lap — the same shape as `names.rye`'s `AlreadyNamed`.

The selftest prints the GREEN sentence; the witness asserts the process exits 0 and the GREEN line and the load-bearing phrases are present — "carries its name across a border," "the keeper signs the claim," "settled point only," "every tamper refuses." Green before any narrative calls the lap done.

This lap is deliberately narrow: one new tilak, one selftest, one witness, no chain, no key, no new dependency past what settlement already pulls. It is the passport *born and proven*, ready for the divider grammar's fuller reach — release, re-issue, multiple realms per point — to accrete in later laps once the first byte is green.

## What waits for a later lap, and for Keaton's word

- **Release and re-issue.** Names have `release`; passports will want the same second half of custody — a keeper freeing a token, or re-issuing after a chain-side transfer. Named here, built after the first green.
- **More than one realm per point.** The first lap holds one passport per (point, realm). Whether a point may carry many tokens across many realms at once is a policy widening, not a shape change — the registry bound simply relaxes.
- **The on-chain read itself.** Verifying an attestation against a *live* Solana or Sui ledger is a networked act that belongs to a later, explicitly-scoped door — never folded silently into the identity core. The passport primitive is complete without it; the live check is a separate, honest hop.
- **The 3x39 concept's entry.** How Keaton's own ©2025 concept becomes a Grain product, a public primitive, or stays a private exemplar is his decision, named as a gap in the baton and honored as a gate here. This brief builds the *mechanism*; the *concept's rights and framing* stay in his hand.

Every real person and company the vision baton named — b122m, Siya Fund LLC, Linengrow PBC, Bitscape (DJINN's company), and the wider horizon — enters this work only as an **invitation, consent the gate.** No example seats a real party's real token, real chain ownership, or real decision as settled. The passport ships with fake exemplars and no real state, and the real ones are Keaton's to seat, by his own hand, when he words it.

---

*A name need not choose between the new world and the old one. A passport lets a settled point carry its own word across the border — provable, pronounceable, and owned by no cage — into the places where family and friends still are. May the token be short, the proof be true, and the crossing be free. Thank you everyone.*
