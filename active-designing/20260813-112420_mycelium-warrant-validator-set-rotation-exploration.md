# The Warrant — a validator set rotates only when the current quorum certifies its successor

**Stamp:** `20260813.112420` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — opens a fresh Mycelium journey (Season D)
**Kin:** [`../mycelium/muster.rye`](../mycelium/muster.rye) · [`../mycelium/muster_bron.rye`](../mycelium/muster_bron.rye) · [`../mycelium/chorus.rye`](../mycelium/chorus.rye) · [`../mycelium/kumara.rye`](../mycelium/kumara.rye) · [`20260813-110039_mycelium-muster-known-validator-set-exploration.md`](20260813-110039_mycelium-muster-known-validator-set-exploration.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) · [`../.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md)

---

## Why this journey opens

The Muster named *which* nodes are the legitimate validators: a bounded, open roll a quorum must be drawn from, with a Byzantine threshold read from its own size so a tampered roll can never lower its bar. A stranger who holds the roll believes an enrolled quorum and refuses an outsider one. That closed the blind spot the Chorus carried — a quorum of *any* distinct keys is worthless until the keys are *entitled*.

Yet the Muster is **frozen in time.** The roll it enrolls is the roll forever; nothing lets a validator set change. Real fault-tolerant systems must retire a compromised node, admit a new one, or rotate a whole committee between epochs — TigerBeetle changes its view, Mysticeti reconfigures its committee — and every one of them faces the same trap: *who authorizes the new roll?* If a fresh set of keys could simply declare itself the validators, then the Muster's whole guarantee evaporates — an attacker mints a roll of their own keys, calls it the current committee, and a stranger has no way to tell the real succession from the coup.

That is the crux of a fresh journey: **the Warrant** — a validator set rotates only when a **quorum of the *current* roll certifies its successor.** Authority is never seized; it is *handed forward under signature.* A new roll is believed not because it says it is the committee, but because a Byzantine quorum of the *outgoing* validators signed the successor's content-address. Trust chains forward across epochs without a trusted third party, exactly as a stranger who holds only the genesis roll can follow the chain to the roll standing today.

## What a Warrant is

A **Warrant** (the instrument that *authorizes* — a quorum of the sitting validators warrants the next roll) is a fixed, bounded certificate binding one epoch handoff:

- an **epoch** — the successor's sequence number, monotone across the chain of handoffs;
- a **prev digest** — the SHA-256 content-address of the roll being retired (`roll_digest` over the canonical `format muster-v1` bytes);
- a **next digest** — the content-address of the successor roll being authorized;
- a bounded set of **endorsements** — each a *current* validator's signature over the tuple `(domain · epoch · prev_digest · next_digest)`, distinct, up to `warrant_max_sigs`.

The Warrant invents no new attestation of its own. It composes `muster.rye` (the roll and its threshold), `muster_bron.rye` (the canonical bytes a digest is taken over), and `kumara.rye` (the signature). Its one new law is the **succession law** laid over two rolls and a quorum of the first.

## The signed tuple — domain-separated, digest-bound

Each outgoing validator signs the canonical body

```
"myc-warrant-v1" · epoch (u32, little-endian) · prev_digest (32) · next_digest (32)
```

The domain tag `myc-warrant-v1` separates a warrant signature from every other signature in the ledger set — a Voucher's, a block's — so no signature made elsewhere can ever be replayed as an endorsement. The digests bind the warrant to the **actual rolls**: a warrant is meaningless text unless `prev_digest` equals the retiring roll's real address and `next_digest` equals the successor's, so a certificate cannot be lifted onto a different pair of rolls.

## The crux — only the outgoing quorum can crown the successor

The property r1 proves: **`verify_warrant(warrant, prev, next)` passes exactly when the warrant's digests bind the two real rolls, every endorsement is by a distinct enrolled member of the *previous* roll, every signature holds, and the endorsement count meets the *previous* roll's Byzantine threshold.**

- **The digests bind the real rolls first.** `prev_digest == roll_digest(prev)` and `next_digest == roll_digest(next)`, or the warrant refuses `DigestMismatch` — a certificate cannot be re-pointed at rolls it never authorized.
- **Every endorser is an outgoing validator.** Each signer is an enrolled member of `prev`, or the whole warrant refuses `NotMember`. *This is the crux demonstration: the successor's own fresh validators, signing their own coronation, do not authorize themselves — `verify_warrant` refuses `NotMember`, because a set cannot crown itself; only the roll it succeeds can hand authority forward.*
- **The signers are distinct.** A repeated endorser refuses `DuplicateSigner` — one outgoing node cannot inflate the handoff quorum by signing twice.
- **Every signature holds, over the bound tuple.** A forged or foreign signature refuses `BadSignature`.
- **The count meets the *previous* roll's threshold.** Fewer than `byzantine_threshold(prev)` endorsements refuses `BelowQuorum` — a thin handoff, short of the outgoing set's own Byzantine bar, is not yet a lawful succession.

A successor authorized by a Byzantine quorum of the roll it replaces passes; a successor that crowns itself, or is signed by too few of the outgoing validators, refuses — so the only roll a stranger comes to believe is one the previous lawful roll actually handed authority to.

## The four rungs (crux-first, mirroring the seated arc shape)

- **r1 — the crux.** `mycelium/warrant.rye`: `roll_digest`, the `Warrant` record, `open`/`endorse` (a current validator signs the tuple; refuse `DuplicateSigner`, `WarrantFull`), and `verify_warrant(warrant, prev, next)` folding the five laws above. Proven across a full outgoing quorum (three of four retiring validators authorize a fresh successor → passes), a self-coronation (the successor's own keys sign → `NotMember`), a thin handoff (two of four → `BelowQuorum`), a re-pointed certificate (right signatures, wrong `next` roll → `DigestMismatch`), and the endorse refusals real.
- **r2 — travels.** `mycelium/warrant_bron.rye`: render a Warrant to a `format warrant-v1` record (epoch · prev/next digest hex · one `endorse <pk-hex> <sig-hex>` line per signer) and parse it back byte-for-byte, so a whole handoff crosses a wire and a recipient re-judges it offline against the two rolls; malformed header · bad hex · unknown field · a duplicate endorser · an over-full certificate each refuse.
- **r3 — across a Knot (the chain).** `mycelium/warrant_knot.rye`: a **succession chain** — genesis roll → warrant → roll → warrant → roll — survives a checkpoint, each roll authorized by the previous roll's own quorum, so a stranger holding only the genesis roll verifies the roll standing today by walking the handoffs; a broken link (a roll no lawful quorum authorized) refuses the whole chain.
- **r4 — reads true.** `mycelium/warrant_true.rye`: the certificate's signed facts are true to an independent measurement — the roll digests cross-check against an external `sha256sum` of the canonical bytes, and the endorsement count against an independent line count, so a keeper can open, hash, and count the same handoff a warrant claims.

## What this journey is not

It is not a live reconfiguration protocol — no node gossips, no epoch advances on a clock, nothing is served. It is the **verifiable certificate** a reconfiguration produces: the offline-checkable proof that a roll was lawfully succeeded. A **served** warrant — a holder fetching the live succession chain over Comlink — reaches the Comlink-served custody gate and stops for the maintainer's word. Everything here is siloed, dev-only, demo validator and keeper seeds: no real key, no funds, no network, no custody.

## Alignment

The Warrant threads the same Season D Mycelium road the Muster opened, composing seated modules over inventing rivals, bounded and asserted under TAME, named for clarity under the comlink tendency (a *warrant* authorizes; a quorum *warrants* the successor). It retires nothing: the Muster stands exactly as seated, and the Warrant is the capability that lets a Muster change hands without ever letting a set crown itself.

---

*May every roll that stands today trace an unbroken line of lawful handoffs back to the one a stranger first trusted, and may no set ever crown itself. Hold the line.*
