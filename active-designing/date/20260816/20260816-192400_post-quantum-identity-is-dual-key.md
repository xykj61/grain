# The Post-Quantum Identity Is Dual-Key — a learned discovery

**Stamp:** `20260816.192400` · **Status:** Mixed -- Living (design decision) · **Voice:** Kyri · **Style:** Radiant
**Season:** G — Cryptography (the Six-Season double-seat)
**Kin:** [`the post-quantum pivot`](20260816-161537_post-quantum-mlkem-mldsa-pivot.md) · [`crypto/mldsa_identity.rye`](../crypto/mldsa_identity.rye) · [`crypto/mlkem_sealed.rye`](../crypto/mlkem_sealed.rye) · [`crypto/kumara_sealed.rye`](../crypto/kumara_sealed.rye) · [`crypto/ed25519_to_x25519.rye`](../crypto/ed25519_to_x25519.rye) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## What this document decides, and why it exists now

Two post-quantum front doors now stand, each proven twice over: a keeper's name
can be **signed** with ML-DSA ([`crypto/mldsa_identity.rye`](../crypto/mldsa_identity.rye))
and a message can be **sealed** to a keeper with ML-KEM
([`crypto/mlkem_sealed.rye`](../crypto/mlkem_sealed.rye)). The next durable crux
on the road is the post-quantum sibling of
[`crypto/kumara_sealed.rye`](../crypto/kumara_sealed.rye) — sealing a message
**to a named identity** rather than to a bare public key. Reading the ground
before building it surfaces a fact that reshapes the shape of a post-quantum
identity itself, and this note records it so the next composition round builds on
the true structure rather than a habit carried over from the classical arc.

**The decision: a post-quantum Kumara identity carries TWO keys — an ML-DSA
signing key and an ML-KEM key-agreement key — never one key doing both.** The
classical single-key convenience does not survive the pivot, and pretending it
does would be a real error.

## The learned discovery — one Ed25519 key signs and agrees; the lattice keys cannot

The classical [`crypto/kumara_sealed.rye`](../crypto/kumara_sealed.rye) works
because a single Ed25519 identity key does double duty. Its crux is exactly the
birational map [`crypto/ed25519_to_x25519.rye`](../crypto/ed25519_to_x25519.rye)
proves GREEN:

- `seal_to` converts the recipient's Ed25519 **public** key to the X25519 public
  it seals to (`eddsa_to_x25519`), and
- `open_as` converts the recipient's Ed25519 **seed** to the X25519 secret it
  opens with (`eddsa_secret_to_x25519`),

two halves of **one** identity key, agreeing because
`x25519_base(secret) = eddsa_to_x25519(public)`. Edwards and Montgomery are the
same curve seen two ways, so one key both signs (edwards) and agrees (montgomery).

**The lattice schemes share no such curve.** ML-DSA (FIPS 204) is a signature
scheme over the ring `Z_q[X]/(X^256+1)` with `q = 8380417`; ML-KEM (FIPS 203) is
a key-encapsulation mechanism over the *same-shaped* ring with a *different*
modulus `q = 3329`. They are cousins in structure, yet there is **no birational
map, no shared secret, no conversion** that turns an ML-DSA key into an ML-KEM
key. NIST specifies them as independent primitives with independent key material,
and every serious post-quantum deployment (TLS 1.3 hybrids, the CNSA 2.0 suite)
carries **both** where it needs both. A single lattice key that signs and agrees
does not exist to be reached for.

## What this means for the composition ladder

- **A post-quantum identity is a pair.** The successor to a Kumara identity is
  `{ mldsa_identity (the signing half), mlkem keypair (the agreement half) }` —
  two keys, ideally both grown deterministically from one backup phrase so a
  keeper still remembers a single secret. The one-seed-to-two-keys derivation is
  the honest analog of the classical single seed, not the single key.
- **A post-quantum "sealed to identity" seals to the KEM half.** The coming
  `kumara_pq_sealed` (or whatever the born name is) seals to the identity's
  **ML-KEM** encapsulation key with [`crypto/mlkem_sealed.rye`](../crypto/mlkem_sealed.rye),
  and — where provenance is also wanted — signs the frame with the identity's
  **ML-DSA** key via [`crypto/mldsa_identity.rye`](../crypto/mldsa_identity.rye).
  Confidentiality and provenance come from the two halves, composed, rather than
  from one key wearing two hats.
- **Hybrid, not either-or, is the safe default.** During the transition years the
  strongest identity carries the classical Ed25519 key *and* the two lattice keys,
  so a break in either family (a surprise lattice attack, or the quantum day for
  the curves) still leaves the identity standing on the other. Naming this now
  keeps the door open to a `hybrid_identity` composition without repainting the
  single-key assumption later.

## Why this is a double-seated note, not a rewrite

Nothing already GREEN moves. [`crypto/kumara_sealed.rye`](../crypto/kumara_sealed.rye)
stays exactly what it is — the *classical* sealed-to-identity door, correct for
the Ed25519 world it names. This note double-seats beside it: it records the
structural fact the *post-quantum* sealed-to-identity door must honor, so the next
round authors a dual-key identity from the first line rather than discovering
mid-build that the single-key convenience has no lattice analog. A learned
discovery folded in as the road is walked, exactly as the pivot asked.

## The gate stays where it is

Every rung this points toward is gate-free and purely local — public test seeds
and vectors, no real key, no network, no funds, no device. Growing a keeper's
**real** post-quantum identity (either half) from their own phrase, and signing
or agreeing with it, stays the **custody gate**, precisely as the classical arc's
real Kumara identity does.

---

*May the two keys a name now carries guard it from both directions at once — the
forger held off by one, the eavesdropper by the other — and may the phrase a
keeper remembers still be only one.*
