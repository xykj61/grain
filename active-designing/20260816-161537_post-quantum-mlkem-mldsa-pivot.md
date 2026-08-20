# The Post-Quantum Pivot — ML-KEM and ML-DSA on the Doubled Oracle

**Stamp:** `20260816.161537` · **Status:** Mixed -- Living (design decision) · **Voice:** Kyri · **Style:** Radiant
**Season:** G — Cryptography (the Six-Season double-seat)
**Kin:** [`rye-first crypto parity and the decision wave`](20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md) · [`crypto/README.md`](../crypto/README.md) · [`the 1024-round itinerary`](20260812-171050_the-1024-round-itinerary.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) · [`.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)

---

## What this document decides

The classical crypto arc stands whole: sixty Rye files, nineteen byte-for-byte
Monocypher-source parity rungs, the key-hiding family (Elligator 2 · dirty
X25519 · the hidden keypair) closed end to end. The next durable thread is the
**post-quantum** one — the signatures and key agreement that outlive the day a
large quantum computer breaks the elliptic curves Kumara and Comlink lean on
today. This document settles **which** post-quantum primitives Grain builds, and
**against what oracle** it proves them.

**The decision: build the NIST standards — ML-KEM (FIPS 203) for key
encapsulation and ML-DSA (FIPS 204) for signatures — because each is
parity-checkable against an independent implementation, exactly as every rung of
this library already is.** A learned discovery grounds the choice.

## The learned discovery — Zig ships the standards, and not the alternative

The prior loop, closing the Elligator arc, named the next post-quantum crux as
**SLH-DSA (SPHINCS+) on SHAKE-256**. Reading the ground before building it
surfaced a fact that reshapes the choice: the vendored Zig toolchain
(`vendor/zig-toolchain`) ships, in its own `std.crypto`, independent
implementations of the two *lattice* NIST standards —

- `std/crypto/ml_kem.zig` — ML-KEM / CRYSTALS-Kyber, **FIPS 203**, modulus
  `Q = 3329`, with a deterministic-seed entry `KeyPair.generateDeterministic(seed)`
  whose encapsulation and decapsulation keys are byte-exact from a 64-byte seed.
- `std/crypto/ml_dsa.zig` — ML-DSA / CRYSTALS-Dilithium, **FIPS 204**, modulus
  `Q = 8380417`, with the same deterministic keygen shape.

Zig ships **no SLH-DSA** at all. That single fact tips the whole choice, because
this library's core discipline is the **doubled oracle**: every primitive is
proven both against its published RFC/FIPS known-answer *and* against a second,
independent implementation — Zig's `std.crypto` or the vendored Monocypher —
agreeing byte-for-byte. A rung proven only against its own selftest is weaker
than one two strangers confirm.

- **SLH-DSA** would have had a *single* external oracle (the NIST KAT alone); no
  second independent implementation is on hand to diff against. Its security is
  hash-based and conservative — a fine primitive — yet it would break the very
  discipline that lets an auditor trust this library without re-deriving it.
- **ML-KEM and ML-DSA** each carry the *doubled* oracle this library rests on:
  the NIST FIPS known-answer test *and* Zig's independent `std.crypto`
  implementation, deterministic from a seed, diffable to the byte.

So the post-quantum path pivots from SLH-DSA to **ML-KEM + ML-DSA**. SLH-DSA
stays a named **horizon** — a later hash-based rung worth building on `shake.rye`
when a second implementation to diff against is vendored, or when the NIST KAT
alone is judged oracle enough — never discarded, only deferred behind the two
standards that prove themselves the same way everything here already does.

This is precisely the kind of *learned discovery* the road asks the loop to fold
in as it goes, rather than march past because a prior note named a different
turn.

## Why post-quantum, and why these two serve Grain

- **ML-DSA is the post-quantum successor to Ed25519** — the signature every
  Kumara identity, subkey, attestation, and Lotus signed carry ultimately rests
  on. A keeper's identity that must last decades wants a signature a future
  quantum adversary cannot forge. ML-DSA is that signature, standardized.
- **ML-KEM is the post-quantum successor to X25519** — the key agreement the
  sealed session (`sealed_session.rye`, `kumara_sealed.rye`) and Comlink's
  private-message door lean on. A KEM, not a Diffie-Hellman, so the composition
  differs slightly; the confidentiality it buys is the same, hardened against the
  quantum day.

Both are **lattice** schemes over a polynomial ring `Z_q[X]/(X^256 + 1)`, and
both accelerate their ring multiplication with the same tool — the **Number
Theoretic Transform (NTT)**. That shared foundation is where the arc begins.

## The Rye-first order, and the honest parity boundary

Rye is the prioritized language; each rung lands GREEN in Rye before anything
composes on it (the priority spine). One care worth naming plainly so no future
rung trips on it:

- **FIPS 203/204 specify *standard-domain* arithmetic** (plain / Barrett
  reduction, primitive root `ζ = 17` for ML-KEM). Zig's `std.crypto` computes
  internally in **Montgomery domain** for speed. The two disagree on the
  representation of an *intermediate* NTT coefficient, yet **agree byte-for-byte
  at every published boundary** — the encoded keys, ciphertexts, and signatures
  — because both normalize to the canonical standard-domain residue before
  encoding to bytes.
- Therefore our Rye authors the **spec's standard-domain** arithmetic (clean,
  auditable, FIPS-faithful), and parity against Zig is taken at the **byte
  boundary** (`generateDeterministic` → `toBytes`), never on an internal
  coefficient. The internal ring rung proves itself by **self-consistency** — the
  NTT round-trip and the negacyclic-convolution identity — standing exactly where
  Elligator's round-trip identity stood when Zig shipped no Elligator to diff.

## The rung ladder (agent-doable, each its own GREEN round)

Built in dependency order, each rung standing on the GREEN rung beneath it,
Rye-first, one send per rung:

1. **`mlkem_ring.rye` — the base ring (this arc's first rung).** Arithmetic mod
   `q = 3329` over the 256-coefficient polynomial: modular add/sub/mul, the
   `zetas` table (`17^BitRev7(k) mod q`, computed and asserted against the FIPS
   203 definition, never a pasted limb), the forward **NTT**, the inverse
   **NTT**, and the NTT-domain pointwise multiply (`BaseCaseMultiply` /
   `MultiplyNTTs`). **Oracle:** self-consistency — `invNTT(NTT(f)) = f` and
   `invNTT(NTT(f) ∘ NTT(g)) = f ⊛ g` (negacyclic schoolbook convolution) over
   many deterministic pseudo-random polynomials, plus the zetas table matching an
   independent `17^BitRev7(k)` computation. No external dependency, fully
   deterministic, non-trivial — the Elligator-round-trip pattern.
2. **`mlkem_encode.rye` — ByteEncode/ByteDecode and Compress/Decompress.** The
   bit-packing between coefficients and bytes (`d`-bit encodings), proven by the
   encode/decode round-trip and the FIPS 203 compression bound.
3. **`mlkem_sample.rye` — SampleNTT (uniform, rejection) and SamplePolyCBD.** The
   SHAKE-driven sampling on the GREEN `shake.rye`, proven against FIPS 203's
   sampling of `A` from a fixed `rho` (byte-exact vs a hand-run reference).
4. **`mlkem_keygen.rye` — K-PKE + ML-KEM.KeyGen.** The first rung with a
   **doubled** oracle: `generateDeterministic(seed)` producing encapsulation and
   decapsulation keys **byte-for-byte against Zig's `std.crypto` ML-KEM-512/768/1024
   AND the NIST FIPS-203 KAT**.
5. **`mlkem_encaps.rye` / `mlkem_decaps.rye` — Encaps and Decaps.** The KEM whole,
   the Fujisaki–Okamoto transform, proven encaps→decaps round-trip and byte-exact
   against Zig + KAT. With this, the post-quantum sealed-session sibling of
   `kumara_sealed.rye` becomes buildable.
6. **The ML-DSA ladder — `mldsa_ring.rye` … `mldsa_sign.rye`/`mldsa_verify.rye`.**
   The signature standard over its own ring (`q = 8380417`), the same rung shapes,
   proven against Zig's `std.crypto` ML-DSA-44/65/87 and the FIPS-204 KAT. Its
   front door is the post-quantum successor to Kumara's Ed25519 identity.

## The gate stays exactly where it is

Every rung above is **gate-free and purely local** — the RFC/FIPS test seeds and
KAT vectors, no real key, no network, no funds, no device. Generating or signing
with the maintainer's **own** post-quantum identity key stays the **custody
gate**, precisely as the classical arc's real Kumara signature does. The library
builds and verifies the mathematics in the open; it never holds the key.

## Clean-room, as ever

We study FIPS 203 and FIPS 204 (public NIST standards) and read Zig's
`std.crypto` and the vendored Monocypher only as *reference implementations to
diff against* — never a copied line. Zig is MIT, studied freely; the arithmetic
is authored fresh in our Rye under TAME Guidance (`.claude/rules/gratitude-licenses.md`).

---

*May the mathematics we write today still guard a keeper's name on the morning
the old curves fall — proven twice over, held in the open, and honest about the
one key it will never touch.*
