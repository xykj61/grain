# secp256k1 Scalar — Arithmetic Modulo the Group Order n

**Stamp:** `20260816.023743` · **Status:** Mixed -- Living (design capture, raw layer) · **Voice:** Kyri · **Style:** Radiant
**Kin:** [`crypto/secp256k1_scalarmul.rye`](../crypto/secp256k1_scalarmul.rye) (the point ladder, GREEN) · [`crypto/ed25519_scalar.rye`](../crypto/ed25519_scalar.rye) (the sibling scalar field mod L) · [`the crypto front door`](../docs/CRYPTO.md) · [`the decision wave`](20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md)

---

## The claim

Every secp256k1 rung so far has worked over the **base field** GF(p) and the
**group** of points on the curve. ECDSA also needs arithmetic in a *second*
field: the integers modulo **n**, the prime order of the base point G. On every
verification ECDSA computes the modular inverse `s⁻¹ mod n`, then the two scalars
`u1 = z·s⁻¹` and `u2 = r·s⁻¹` (both mod n), and finally checks that the affine
x-coordinate of `u1·G + u2·Q`, itself reduced mod n, equals r. This rung authors
exactly that arithmetic — **reduce · multiply · invert · is_canonical** modulo n —
so ECDSA verification becomes a pure composition over it and the GREEN point
ladder above it.

It is the crux stone: the *hardest still-tractable* move that opens the rest of
the secp256k1 tower (ECDSA verify, then public-key recovery). Exactly the sibling
of `ed25519_scalar.rye`, which stands between GREEN SHA-512 and the Ed25519 verify
equation.

## The order n, derived not pasted

The group order is, in the SEC 2 closed form,

```
n = 2²⁵⁶ − δ,   δ = 2¹²⁸ + 0x4551231950b75fc4402da1732fc9bebf
```

so n is **built** from its defining form — δ's sub-2¹²⁸ remainder carried as a
`u128`, the 2¹²⁸ bit placed by a limb, then subtracted from 2²⁵⁶ — never pasted as
a limb pattern, the same discipline `ed25519_scalar.rye` keeps for L.

## The four operations

- **reduce** — a 64-byte little-endian value → a canonical 32-byte scalar below n,
  by bytewise Horner from the most-significant byte down, keeping the running
  residue below n with a run of subtractions proven to number fewer than 256 per
  byte (because the residue stays below n, `acc·256 + byte < 256·n`).
- **mul** — `a·b mod n` for canonical a, b: a schoolbook 256×256→512-bit product
  into eight 64-bit limbs, serialized to 64 little-endian bytes, then folded by the
  same **reduce**. No new modular machinery — multiply is reduce over a wide
  product.
- **invert** — `a⁻¹ mod n` by Fermat's little theorem, `a^(n−2) mod n`, via
  left-to-right binary exponentiation over the 256 bits of the fixed exponent
  `n − 2` (n's low limb minus two, no borrow), squaring at every bit and
  multiplying by a where the bit is set — a named 256-round bound, every step a
  **mul**.
- **is_canonical** — whether a 32-byte little-endian encoding is already below n,
  the same limbwise comparison reduce runs, without the arithmetic.

## Honest scope

Software only, purely local: a scalar is an integer, not a secret and not a
signature. This file holds no key, signs nothing, and calls no `std.crypto` in
the primitive. In ECDSA **verification** every value here — r, s, z, and the
inverse — is **public**, so the variable-time reduction and exponentiation leak no
secret; a constant-time scalar field for secret scalars (ECDSA *signing*, gate
#3/#4) stays the Season's named horizon. secp256k1 is not in Monocypher, so parity
is proven against algebraic known-answers anyone can check (0 reduces to 0, n
reduces to 0, `a·1 = a`, `a·a⁻¹ = 1`) **and** Zig's independent
`std.crypto.ecc.Secp256k1.scalar` — `reduce64`, `mul`, `Scalar.invert`, and
`rejectNonCanonical` — byte-for-byte and verdict-for-verdict across a spread.

## What it unblocks

With reduce · mul · invert · is_canonical GREEN, every arithmetic piece ECDSA
verification needs stands: the verify equation is then a composition over this
scalar field, the GREEN point ladder, and the GREEN base field — and public-key
recovery follows the same way. The Bitcoin/Ethereum signature check, the reach the
whole address arc (Keccak-256 · RIPEMD-160 · Base58Check · Bech32 · EIP-55) was
climbing toward, becomes engineering.

*May the second field stand as plainly as the first, and may the door it opens
read all the way down.*
