# The Hybrid Signed Carry — provenance on both worlds, in the open

**Stamp:** `20260816.201310` · **Status:** Living (design decision, self-approved) · **Voice:** Kyri · **Style:** Radiant
**Season:** G — Cryptography (the Six-Season double-seat)
**Kin:** [`crypto/signed_carry.rye`](../crypto/signed_carry.rye) (the classical sibling, GREEN) · [`crypto/hybrid_identity.rye`](../crypto/hybrid_identity.rye) (the hybrid signature, GREEN) · [`crypto/hybrid_signed_sealed.rye`](../crypto/hybrid_signed_sealed.rye) (the confidential-and-signed door, GREEN) · [`the post-quantum pivot`](20260816-161537_post-quantum-mlkem-mldsa-pivot.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## What this document decides

The hybrid surface stands whole for *messages*: a keeper's name signs on both
families ([`crypto/hybrid_identity.rye`](../crypto/hybrid_identity.rye)), a
message hides on both ([`crypto/hybrid_sealed.rye`](../crypto/hybrid_sealed.rye)),
and one frame both hides and proves who sent it
([`crypto/hybrid_signed_sealed.rye`](../crypto/hybrid_signed_sealed.rye)). One
shape the message surface does not yet carry to the post-quantum day is the
**open** one — a record whose payload stays *public* on purpose, yet whose
authorship must still hold after the elliptic curves fall.

That shape already lives, classically, as
[`crypto/signed_carry.rye`](../crypto/signed_carry.rye): a self-describing,
content-addressed, Ed25519-signed frame — the "who made this record, and has a
byte moved since" that every provenance path (Lotus's signed carry, Tablecloth's
chain of custody, a published Realidream page) reaches for. Its confidentiality
is *none by design*; the payload is meant to be read by anyone, and the signature
is the whole point.

**The decision: build `crypto/hybrid_signed_carry.rye` — the exact shape of the
classical signed carry, with the single Ed25519 signature replaced by a hybrid
signature (Ed25519 beside ML-DSA, genuine only when both verify).** A published
record's authorship then survives a break in *either* family: forge it and you
must break both Ed25519 *and* ML-DSA over the same content address, not one.

## Why this rung, and why now (Lindy-first, crux-first)

- **Lindy.** Provenance on a *public* artifact is what publishing, right-to-repair
  parts records, fair-trade certificates, and a chain of custody all rest on —
  read thousands of times over the artifact's life. Hardening it against the
  quantum day is durable work, not ephemeral.
- **Crux.** It is the one still-open corner of the hybrid surface: the sealed
  doors guard *secret* payloads; the open carry guards *public* ones. With it, the
  transition-years matrix is complete across confidentiality **and** open
  provenance.
- **Agent-doable, gate-free.** Like every rung of this library it composes only
  GREEN primitives (`hybrid_identity` + `blake2b`), authors no new cryptography,
  and proves itself over TEST identities from published vectors. Signing a real
  record with the maintainer's own hybrid identity stays the custody gate.

## The frame

A hybrid signed carry is a flat, self-describing byte string, laid out so a reader
deframes it with no ambiguity and no allocation. The widths of the two
post-quantum fields depend on the ML-DSA parameter set, so the frame is
comptime-parameterized exactly as `hybrid_signed_sealed` is:

```
magic    4 bytes    "GHC1"  (Grain Hybrid Carry, version 1)
ed_pub   32 bytes   signer Ed25519 public key
ml_pub   pk_len     signer ML-DSA public key         (per parameter set)
paylen   8 bytes    u64 big-endian — the opaque payload length
payload  paylen     the opaque PUBLIC record — this library carries it, never reads its meaning
digest   64 bytes   BLAKE2b-512 of (magic ‖ ed_pub ‖ ml_pub ‖ paylen ‖ payload) — the CONTENT ADDRESS
ed_sig   64 bytes   Ed25519 signature over the digest
ml_sig   sig_len    ML-DSA signature over the digest  (per parameter set)
```

The signer's two public keys sit *inside* the preimage, so a forger who swaps a
key changes the content address the real signature commits to — the substitution
fails at the digest step, before the signature is even consulted, exactly as the
classical carry's swapped-signer case does.

## Verify before trust

`open()` recomputes the digest from the frame's own bytes and refuses, in order:
magic → declared length → digest mismatch → hybrid signature. Only when the
hybrid signature verifies — **both** families genuine over the recomputed content
address — does one zero-copy payload byte leave the door, alongside the two
verified signer public keys. A caller never sees an unverified byte, and a
single-family forgery is caught: tamper the Ed25519 half alone, or the ML-DSA half
alone, and the hybrid verify refuses.

## Why a carry, not the sealed door

`hybrid_signed_sealed` seals the payload — its bytes are ciphertext, unreadable
without the recipient's keys. `hybrid_signed_carry` leaves the payload in the
clear — its bytes are the record itself, readable by anyone, with the signature
proving who stands behind them. Two honest shapes for two honest needs: a private
letter, and a public notice signed in the town square. The carry is the shape a
*published* artifact wants.

## The gate stays where it is

Every function here is gate-free and purely local — TEST hybrid identities from a
published-vector mnemonic, no real key, no network, no funds, no device. Signing a
real record with the maintainer's **own** hybrid identity stays the custody gate,
precisely as the classical carry's real key does. The library builds and verifies
the mathematics in the open; it never holds the key.

---

*May a keeper's public word — the notice, the receipt, the record freely read —
carry a signature that still names its author on the morning the old curves fall,
proven twice over and held in the open.*
