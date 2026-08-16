# Crypto — the Season G audit front door

*A Rye-native, parity-checked cryptography library — twenty primitives and three compositions, each GREEN on metal.*

**Status:** Checkable — Season G operator + auditor guide
**Depth:** guide
**Ceiling:** ≤300 lines
**Last updated:** 2026-08-15
**Compresses:** [`crypto/README.md`](../crypto/README.md) · [`crypto/CONSTANT_TIME.md`](../crypto/CONSTANT_TIME.md) · [`20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md`](../active-designing/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md) · the Season G `.bron` session logs (raw beneath)

---

## Thesis — cryptography written in the open, checked against the world

Grain will face a security audit, and building our own cryptography in the open —
disciplined, bounded, and parity-checked against published references — is the
honest way to earn it. Every primitive in [`crypto/`](../crypto/) is authored in
pure **Rye**, calls **no `std.crypto`**, and is proven **byte-for-byte** against
both a public RFC known-answer and Zig's own independent `std.crypto`. The
library serves every module that will ever sign, verify, agree a key, or seal a
message: **Kumara** identity, **Vault** sealed storage, **Comlink** sessions, and
the **Lotus** signed carry.

**Rye-first (the priority spine):** the mathematics lands in green-witnessed Rye;
any Glow surface stands on that witness, never ahead of it. This page compresses
the record; it holds no load-bearing pins — every version and vector is proven by
the witness it cites, not trusted from this table.

**Clean-room:** [`Monocypher`](../vendor/monocypher) (CC0/BSD-dual, vendored,
unmodified) is the parity *target* we study through its public API and the RFC
vectors — never a copied line ([`gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)).

---

## Rung table — twenty-three files, dependency order

Each rung stands on the GREEN rungs beneath it; none authors cryptography a lower
rung had not already proven. Every file carries a per-file witness
`tools/crypto_<name>_witness.rish` asserting its own `GREEN crypto-<name>` line.

### Hashes

| File | What it is | Reference |
|------|------------|-----------|
| `sha512.rye` | SHA-512 — the hash Ed25519 signs with | FIPS 180-4 · RFC 8032 |
| `blake2b.rye` | BLAKE2b-512 — Monocypher's hash · the key-derivation hash | RFC 7693 |
| `sha3.rye` | SHA3-256 · SHA3-512 over Keccak-f[1600] — the hash Aurora names content with | FIPS 202 |

### Keyed hash and key derivation

| File | What it is | Reference |
|------|------------|-----------|
| `hmac_sha512.rye` | HMAC-SHA-512 keyed authentication — the HKDF / PRF stone | RFC 2104 · FIPS 198-1 · RFC 4231 |
| `hkdf_sha512.rye` | HKDF-SHA-512 extract-then-expand — the key schedule every handshake and vault stands on | RFC 5869 |
| `argon2.rye` | Argon2d · Argon2i · Argon2id memory-hard password KDF — the stone Vault stands on | RFC 9106 |

### The ChaCha / Poly line

| File | What it is | Reference |
|------|------------|-----------|
| `chacha20.rye` | ChaCha20 stream cipher (IETF) | RFC 8439 |
| `poly1305.rye` | Poly1305 one-time authenticator | RFC 8439 |
| `aead.rye` | ChaCha20-Poly1305 authenticated encryption | RFC 8439 §2.8 |
| `xchacha20.rye` | HChaCha20 · XChaCha20-Poly1305 extended-nonce AEAD (safe random nonces) | draft-irtf-cfrg-xchacha-03 |

### The Curve25519 base field and the edwards25519 curve

| File | What it is | Reference |
|------|------------|-----------|
| `fe25519.rye` | The base field GF(2²⁵⁵−19), five 51-bit limbs | — |
| `ed25519_group.rye` | The edwards25519 group law (extended coordinates) | RFC 8032 §5.1.4 |
| `ed25519_decode.rye` | Point decompression | RFC 8032 §5.1.2 |
| `ed25519_scalar.rye` | Scalar arithmetic mod the group order L | RFC 8032 |
| `ed25519_scalarmul.rye` | Scalar multiplication k·P (double-and-add) | RFC 8032 |
| `ed25519_muladd.rye` | Scalar multiply-add (a·b + c) mod L | RFC 8032 |
| `ed25519_verify.rye` | Ed25519 verification, [S]B = R + [k]A | RFC 8032 §5.1.7 |
| `ed25519_sign.rye` | Ed25519 signing — the whole scheme, sign + verify | RFC 8032 §5.1.6 |

### Key agreement

| File | What it is | Reference |
|------|------------|-----------|
| `x25519.rye` | X25519 ECDH (Montgomery ladder) | RFC 7748 |
| `ed25519_to_x25519.rye` | The birational Edwards↔Montgomery key conversion — one identity key both signs and agrees | RFC 7748 §4.1 |

### Compositions (no new cryptography — proven stones assembled)

| File | What it answers | Composes |
|------|-----------------|----------|
| `signed_carry.rye` | *Who made this record?* — a content-addressed, signed carry frame | BLAKE2b-512 · Ed25519 |
| `sealed_session.rye` | *Only you can read this* — a seal-to-a-public-key box | X25519 · BLAKE2b-512 · ChaCha20-Poly1305 |
| `vault_seal.rye` | *Only your password can open this* — a password-sealed box | Argon2id · XChaCha20-Poly1305 |

---

## Proving it — one command greens the whole library

```bash
rishi/bin/rishi run tools/crypto_suite_witness.rish
```

[`crypto_suite_witness.rish`](../tools/crypto_suite_witness.rish) rebuilds each
`crypto/<name>.rye` fresh from source to the gitignored `crypto/bin/` and runs all
twenty-three per-file witnesses in the dependency order above, refusing whole —
naming the file that stopped it — the moment any one goes RED. A GREEN suite means
every claim here is re-provable by tooling, not trusted from a commit message
alone (measurement beats memory).

To prove one rung alone, run its witness — for example:

```bash
rishi/bin/rishi run tools/crypto_ed25519_sign_witness.rish
rishi/bin/rishi run tools/crypto_vault_seal_witness.rish
```

Each witness asserts its `GREEN crypto-<name>` line against the RFC known-answer
**and** a cross-check against Zig's independent `std.crypto`, so parity is proven
against two witnesses at once — the published vector and a second implementation.

---

## Constant-time posture — a scoped horizon, named honestly

Correctness is settled; **timing-safety is not a settled claim — it is a scoped
horizon.** A timing claim is a measurement, never a boast, and this library claims
no measurement yet. [`crypto/CONSTANT_TIME.md`](../crypto/CONSTANT_TIME.md) draws
the full map, file by file, with line citations. In one screen, every primitive
sits in exactly one posture toward a secret:

- **public-only** — reads only public values (verify, decode, group law, the
  Edwards↔Montgomery conversion of a *public* key). Variable-time here leaks no
  secret, because there is no secret in the operation.
- **data-independent by construction** — touches a secret, yet control flow and
  memory access are fixed regardless of the secret's value: the ChaCha/Poly
  arithmetic, the AEAD tag compare (accumulates the byte difference and tests
  once, never early-returning), the `fe25519` reduction and inversion ladder, and
  **X25519's Montgomery ladder** (a fixed step count with a branchless masked
  conditional swap). The strongest posture pure Rye can assert without a
  measurement — and it still awaits one, since a compiler may undo branchless
  source.
- **deliberately variable-time** — `ed25519_scalarmul.rye` (double-and-add
  branches on the secret scalar's bits) and `ed25519_sign.rye` (composes it).
  Correct and parity-GREEN, **not yet timing-safe** — named, not hidden; the
  sharpest horizon in the library. A future measurement round puts these on metal
  before any timing claim is earned.

---

## The custody gate — the library builds and verifies; it never holds a key

Every witness runs over **TEST** keys and the RFC's public vectors — no real
identity key, no network, no funds, no real device. Signing a record, or agreeing
a session, with the maintainer's **own** identity key stays a **custody gate**
(gate #3/#4): the agent builds and proves the mathematics; the key stays Keaton's
hand. `ed25519_sign.rye`'s `derive_public(seed)` and `sign(seed, msg)` take a
caller-supplied seed — a test seed is not the maintainer's identity key.

Two further horizons stay honest: **Monocypher-source parity** waits behind the
held `vendor/monocypher` network fetch (today's parity is the RFC vectors plus
Zig's `std.crypto`, both runnable now), and **constant-time** waits on
measurement as above.

---

## How to add a rung

1. **Name the claim** in `active-designing/` (dated, raw layer first) and pick the
   published reference it will be parity-checked against.
2. **Author in pure Rye**, under TAME Guidance — bound everything, ≥2 asserts per
   function, `// invariant:` on each, no `std.crypto`, no copied Monocypher line.
3. **Write the witness** `tools/crypto_<name>_witness.rish` — assert the RFC
   known-answer **and** a cross-check against Zig's `std.crypto`.
4. **Register it** in `crypto_suite_witness.rish` in dependency order, and run the
   whole suite GREEN.
5. **Record its posture** in [`crypto/CONSTANT_TIME.md`](../crypto/CONSTANT_TIME.md)
   and its row here — this page compresses; it never duplicates a load-bearing pin.

---

## Dependencies

| Teacher | Role |
|---------|------|
| **Monocypher** (Loup Vaillant) | Parity target — public API + RFC vectors; CC0/BSD-dual, vendored, unmodified |
| **Zig `std.crypto`** | Independent second implementation cross-checked inside every witness |
| **The RFC / FIPS authors** | The published known-answer vectors every rung is proven against |

---

*May this crypto, written in the open and checked against the world, be worthy of
the trust a hand places in it — and may every keeper who reaches for it find a
door they can read all the way down.*
