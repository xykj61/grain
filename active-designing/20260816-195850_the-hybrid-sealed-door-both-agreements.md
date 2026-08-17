# The Hybrid Sealed Door — Confidentiality That Stands on Both Agreements

**Stamp:** `20260816.195850` · **Status:** Living (design decision, LANDED same round) · **Voice:** Kyri · **Style:** Radiant
**Season:** G — Cryptography (the Six-Season double-seat)
**Kin:** [`the dual-key discovery`](20260816-192400_post-quantum-identity-is-dual-key.md) · [`crypto/hybrid_sealed.rye`](../crypto/hybrid_sealed.rye) · [`crypto/hybrid_identity.rye`](../crypto/hybrid_identity.rye) · [`crypto/kumara_sealed.rye`](../crypto/kumara_sealed.rye) · [`crypto/mlkem_sealed.rye`](../crypto/mlkem_sealed.rye) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## What this document decides, and why it exists now

The hybrid **identity** now stands ([`crypto/hybrid_identity.rye`](../crypto/hybrid_identity.rye)): one backup phrase grown into all three keys the transition years want, with a **hybrid signature** genuine only when both the Ed25519 and the ML-DSA halves verify — a forger must break *both* families, not one. The signing side of the transition is whole. Its missing twin is the **confidentiality** side: a message a keeper can seal so that reading it also demands breaking both families, never one.

**The decision: seal to a hybrid identity as an ONION of the two sealed doors already GREEN — the classical X25519 box inside the post-quantum ML-KEM box — so a message is readable only when BOTH agreements open.** This is the exact confidentiality analog of the hybrid signature's "both must verify," and it authors no new cryptography.

## The learned shape — why an onion, and why nothing new is written

The tree already proves two sealed-to-identity doors:

- [`crypto/kumara_sealed.rye`](../crypto/kumara_sealed.rye) — the **classical** box, addressing a Kumara identity through the Ed25519→X25519 birational map (one key both signs and agrees).
- [`crypto/mlkem_sealed.rye`](../crypto/mlkem_sealed.rye) — the **post-quantum** box, addressing an identity's ML-KEM half through a key-encapsulation mechanism.

Nesting them gives the hybrid guarantee for free, with no new primitive:

```
seal:  inner = kumara_sealed.seal_to(recipient Ed25519 public, fresh ephemeral, plaintext)
       out   = mlkem_sealed.seal(recipient ML-KEM ek, fresh KEM message, inner)
open:  inner = mlkem_sealed.open(recipient ML-KEM dk, out)   # peel the post-quantum layer
       plain = kumara_sealed.open_as(recipient Ed25519 seed, inner)   # peel the classical layer
```

To read the plaintext an adversary must break **both**: the outer ML-KEM box to reach the inner frame, *and* the inner X25519 box to reach the plaintext. Break the classical family alone and the outer post-quantum box still holds; break the post-quantum family alone and, having peeled the outer layer, the inner classical box still holds. This mirrors the hybrid signature precisely — where that is a *conjunction of two verifications*, this is a *composition of two seals* — and each failure names the layer that refused (`OuterOpenFailed`, `InnerOpenFailed`), which is exactly what the selftest measures to prove break-one-is-not-enough.

## The honest bound

The outer box carries the inner frame as its plaintext, so the hybrid plaintext bound is the ML-KEM box's own plaintext bound **minus** the classical frame's 60-byte overhead. Named at the module as `max_plain_bytes = outer.max_plain_bytes - inner_overhead`, so the inner frame always fits the outer box — a bound the tighter of the two layers sets, not a looser one invented here.

## Why this is a double-seated rung, not a rewrite

Nothing already GREEN moves. [`crypto/kumara_sealed.rye`](../crypto/kumara_sealed.rye) stays the correct classical door and [`crypto/mlkem_sealed.rye`](../crypto/mlkem_sealed.rye) the correct post-quantum one — a keeper who trusts one family alone uses that door directly. The hybrid door double-seats beside them for the keeper who wants both agreements guarding one message at once, exactly as the hybrid identity double-seats beside the two single-family identities.

## The gate stays where it is

Every rung here is gate-free and purely local — TEST hybrid identities from published vectors, no real key, no network, no funds, no device. Both the X25519 ephemeral and the ML-KEM message must be fresh randomness in real use, the caller's own duty; the library invents no entropy. Sealing to or opening as the maintainer's **own** hybrid identity stays the custody gate, precisely as each single-family sealed door's real key does.

---

*May a keeper's message, like a keeper's name, stand on both worlds at once — the eavesdropper held off by two families and the forger by two more, while the phrase remembered stays only one.*
