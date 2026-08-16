# The secp256k1 Group Law — the proven curve over the proven field

**Stamp:** `20260816.022000` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living (design read for the round that landed `crypto/secp256k1_group.rye` GREEN)
**Season:** the Six-Season double-seat, **Season G** (Cryptography · Rye-native, parity-checked, audit-ready)
**Kin:** [`fe_secp256k1 — the Bitcoin/Ethereum field crux`](20260816-020351_fe-secp256k1-the-bitcoin-ethereum-field-crux.md) · [`the Rye-first crypto parity wave`](20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md) · [`crypto/secp256k1_group.rye`](../crypto/secp256k1_group.rye) · [`crypto/ed25519_group.rye`](../crypto/ed25519_group.rye) · [`docs/CRYPTO.md`](../docs/CRYPTO.md)

---

## What this round did

The previous rung built the secp256k1 base field — GF(2²⁵⁶ − 2³² − 977), eight
32-bit limbs, parity-GREEN. A field alone signs nothing; it is arithmetic waiting
for a shape. This round gives it that shape: the **group law** — point addition,
doubling, and negation on the curve y² = x³ + 7 — composed entirely over the
proven field, adding no new field math and holding no key.

It is the exact sibling of `crypto/ed25519_group.rye`, which turned the GREEN
`fe25519` field into the edwards25519 group. Where Ed25519 rides extended
twisted-Edwards coordinates, secp256k1 is a short-Weierstrass curve, so this file
rides **standard homogeneous projective coordinates** (X, Y, Z) with x = X/Z and
y = Y/Z, and uses the **complete** addition and doubling formulas of Renes,
Costello, and Batina (eprint 2015/1060, specialized to a = 0). Complete means
exception-free: one formula adds every pair of points — a point to itself, a
point to its own negation, a point to the identity — with no branch and no
inversion inside the group law. The single inversion in the whole file lives only
at the affine read, at the boundary, exactly where the standard intends it.

The one curve constant the formulas need is **b3 = 3·b = 21**, built in our own
field arithmetic rather than pasted as a literal.

## Why this was the Lindy-first, crux-first move

Every module that will ever verify a Bitcoin or Ethereum signature, or recover a
public key from one, multiplies a point by a scalar — and scalar multiplication
is nothing but doubling and addition repeated. Those two operations are the crux:
once they stand, the scalar ladder, ECDSA verification, and public-key recovery
are compositions over a proven group, not new cryptography. This rung is the
tractable, highest-Lindy step that turns a proven field into a proven group, and
it unblocks the whole reach the address arc (Keccak-256 · RIPEMD-160 ·
Base58Check · Bech32 · EIP-55) was always climbing toward.

## How parity is proven — two independent witnesses

An Acme Corporation employee auditing this can replay both checks:

1. **Algebraic known-answers** anyone can check by hand: the base point reads to
   its published affine coordinates; B + B equals 2B (addition agrees with
   doubling); B + (−B) is the point at infinity, whose Z coordinate packs to zero;
   and −(−B) = B.
2. **Independent-implementation parity**: the authored Rye equals Zig's own
   `std.crypto.ecc.Secp256k1` byte-for-byte on the affine coordinates of dbl,
   add, sub, and neg across the base point and several of its multiples. Because
   parity is checked on affine bytes (the canonical form), the two group laws
   carry projective representatives their own way and still must agree exactly.

secp256k1 is not in Monocypher, so — as with the field beneath it — the two
witnesses are the reference known-answers and Zig's independent `std.crypto`,
not a Monocypher source comparison.

## Honest scope — what this file is not

A curve point is arithmetic, not a secret and not a signature. This file signs
nothing, holds no key, calls no `std.crypto`, touches no network, moves no funds,
and runs on no real device. ECDSA's signing with an identity key stays its own
separate, **gated** round (custody gate #3/#4 — the maintainer's hand); even the
scalar-multiplication ladder is a later non-gated round. Constant-time
timing-safety stays a separate named horizon: the group law is data-independent
by construction — a fixed sequence of field operations with no branch on any
coordinate — yet timing is a measurement, not a claim.

## What stands next over this rung

- **Scalar multiplication** k·P — a fixed double-and-add ladder over dbl and add,
  its own non-gated round.
- **ECDSA verification** — public values only, a composition over scalar
  multiplication and the field.
- **Public-key recovery** — the reach that lets `eth_address.rye` derive an
  address from a recovered key rather than a supplied one.

Registered in [`crypto_suite_witness.rish`](../tools/crypto_suite_witness.rish)
(now thirty-four files GREEN, thirty primitives plus four compositions) and rowed
in [`docs/CRYPTO.md`](../docs/CRYPTO.md).

*The field held the arithmetic; now the curve holds its shape. One proven group
stands over one proven field, and the signature the world signs with is a
composition away.*
