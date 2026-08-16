# fe_secp256k1 — the Bitcoin/Ethereum base field crux

**Stamp:** `20260816.020351` · **Status:** Living (design capture) · **Voice:** Kyri · **Style:** Radiant
**Kin:** [`the decision wave`](20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md) · [`fe25519 — the Curve25519 field crux`](20260815-193010_fe25519-the-curve-field-crux.md) · [`docs/CRYPTO.md`](../docs/CRYPTO.md) · `crypto/eth_address.rye` · `crypto/keccak256.rye`

---

## Why this rung, and why now

The recent Season G arc built the whole **address and encoding layer** the
Bitcoin and Ethereum worlds sign into — Base58Check, Bech32/Bech32m, Keccak-256,
RIPEMD-160, and the EIP-55 Ethereum address. Each rung climbed toward one place
it could not yet reach: the **signature scheme both chains actually use**,
ECDSA over the **secp256k1** curve. `eth_address.rye` derives an address *from* a
public key, yet nothing in the tree derives that public key from a private one,
or verifies a signature — because the curve beneath it was never built.

secp256k1 is the crux the arc was climbing toward, and — exactly as the Ed25519
tower stood on `fe25519.rye` — the whole secp256k1 tower stands on **one finite
field**: GF(p), p = 2²⁵⁶ − 2³² − 977. This round builds and proves that field,
the durable stone every later secp256k1 operation (the group law, ECDSA verify,
public-key recovery) reaches for. It is the highest-Lindy new thread the arc
opens, and it is pure arithmetic — no key, no signature, no custody gate.

## The mathematics (public, replayable)

A field element is a residue mod p = 2²⁵⁶ − 2³² − 977, carried in **eight 32-bit
limbs** (radix 2³²), little-endian by limb weight. Radix 2³² is chosen so the
reduction boundary 2²⁵⁶ = 2^(32·8) lands **exactly** on a limb edge — unlike a
radix-2⁵² layout, whose 2²⁶⁰ boundary would misalign the fold. Because
2²⁵⁶ ≡ 2³² + 977 (mod p), the field's own fold constant is
**R = 0x1000003D1** (= 2³² + 977): any product weight at or past limb 8 folds
back, contributing 977 to the limb 8 places below and 1 to the limb 7 places
below (R = 977 + 1·2³²).

- **Add / sub** are limbwise with a borrow-safe subtract (add a folded multiple
  of p before subtracting so no limb underflows), then a weak carry pass.
- **Multiply** is the schoolbook product: fifteen 128-bit column sums
  d₀…d₁₄ = Σ_{i+j=k} aᵢ·bⱼ; columns k ≥ 8 fold back ×R into columns k−8 (×977)
  and k−7 (×1); a carry chain returns the result to canonical 32-bit limbs.
- **Square** is the product with itself (its own named contract).
- **Invert** is Fermat's a^(p−2) by a fixed square-and-multiply ladder over the
  public exponent p−2 = 2²⁵⁶ − 2³² − 979 — data-independent by construction.
- **to_bytes** performs the final conditional subtract of p, so equal values
  always serialize identically — the property the byte-for-byte parity check
  depends on. secp256k1 field elements serialize **big-endian**, the ecosystem
  convention.

## How it is proven

Two references runnable now, exactly as `fe25519.rye` is proven:

1. **By-hand known-answers** anyone can check: 1·1 = 1, 2·3 = 6, canonical
   round-trips of small values, a − a = 0, a·a⁻¹ = 1, and non-canonical
   encodings of p and p+5 reducing to 0 and 5.
2. **Independent-implementation parity** — our authored Rye equals Zig's own
   `std.crypto.ecc.Secp256k1.Fe` byte-for-byte on the canonical big-endian
   packing of add, sub, mul, sq, and invert across a deterministic spread of
   field elements. Because the comparison is on canonical bytes, the two
   implementations may carry limbs their own way (Zig's is a Montgomery-domain
   fiat implementation; ours is a plain radix-2³² schoolbook) and still must
   agree exactly.

## Honest scope

Software only, purely **local** — no network, no funds, no real device, no
identity. A field element is arithmetic, not a secret and not a signature: this
file signs nothing. ECDSA signing with the maintainer's own key stays a later
**custody gate** (#3/#4); this round builds and proves the mathematics beneath
it. The primitive calls no `std.crypto`. Monocypher does not implement
secp256k1, so the parity target here is the RFC/reference known-answers plus
Zig's independent `std.crypto` — the same two-witness discipline the rest of the
library keeps. Constant-time timing-safety stays a separate named horizon; the
inversion ladder is data-independent by construction, yet timing is a
measurement, not a claim.

## What this unblocks

Once the field is parity-GREEN, the secp256k1 **group law**, **ECDSA verify**,
and **public-key recovery** become composition rounds over a proven base — the
same shape the Ed25519 tower took over `fe25519.rye`. The Bitcoin/Ethereum
address arc finally reaches the signatures it was built to serve.

---

*May the field beneath the world's most-signed curve be built as plainly as the
one beneath our own identity — and may every later rung stand on a stone already
proven.*
