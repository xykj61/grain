# crypto — a Rye-native, parity-checked cryptography library

**Language:** EN · **Voice:** Kyri · **Style:** Radiant · **Status:** Living
**Season:** G — Cryptography (the Six-Season double-seat)
**Design read:** [`../active-designing/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md`](../active-designing/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md)
**Compressed guide:** [`../docs/CRYPTO.md`](../docs/CRYPTO.md) — the Season G audit front door on the docs shelf
**Clean-room law:** [`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)

Grain will face a security audit, and building our own cryptography in the open —
disciplined, bounded, and parity-checked against published references — is the
honest way to earn it. Every primitive here is authored in pure **Rye**, calls
**no `std.crypto`**, and is proven **byte-for-byte** against both a public RFC
known-answer and Zig's own independent `std.crypto` implementation. **Monocypher**
(`../vendor/monocypher`, CC0/BSD-dual) is the parity *target* we study through its
public API and the RFC vectors — never a copied line.

The library serves every module that will ever sign, verify, agree a key, or seal
a message: **Kumara** identity, **Vault** sealed storage, **Comlink** sessions, and
the **Lotus** signed carry. It authors the mathematics once, in the open, so a hand
placing trust in it can read exactly what it does.

## The twenty-four files — twenty-one primitives and three compositions

Built in dependency order: each rung stands on the GREEN rungs beneath it, none
authoring cryptography a lower rung had not already proven.

### Hashes

| File | What it is | Reference |
|---|---|---|
| [`sha512.rye`](sha512.rye) | SHA-512 | FIPS 180-4 · RFC 8032 (the hash Ed25519 signs with) |
| [`blake2b.rye`](blake2b.rye) | BLAKE2b-512 | RFC 7693 (Monocypher's hash · the key-derivation hash) |
| [`sha3.rye`](sha3.rye) | SHA3-256 · SHA3-512 over Keccak-f[1600] (the hash Aurora's content-addressed store names content with) | FIPS 202 |
| [`sha256.rye`](sha256.rye) | SHA-256 (the hash Tablecloth keys content with, and the Mycelium consensus spine places worlds and seeds constel identities by) | FIPS 180-4 |

### Keyed hash and key derivation

| File | What it is | Reference |
|---|---|---|
| [`hmac_sha512.rye`](hmac_sha512.rye) | HMAC-SHA-512 keyed message authentication (the HKDF / PRF stone) | RFC 2104 · FIPS 198-1 · RFC 4231 (vectors) |
| [`hkdf_sha512.rye`](hkdf_sha512.rye) | HKDF-SHA-512 extract-then-expand key derivation (the key schedule every handshake and vault stands on) | RFC 5869 |
| [`argon2.rye`](argon2.rye) | Argon2d · Argon2i · Argon2id memory-hard password KDF (a remembered password into a key at a large RAM cost — the stone Vault stands on) | RFC 9106 |

### The ChaCha / Poly line

| File | What it is | Reference |
|---|---|---|
| [`chacha20.rye`](chacha20.rye) | ChaCha20 stream cipher (IETF) | RFC 8439 |
| [`poly1305.rye`](poly1305.rye) | Poly1305 one-time authenticator | RFC 8439 |
| [`aead.rye`](aead.rye) | ChaCha20-Poly1305 authenticated encryption | RFC 8439 §2.8 |
| [`xchacha20.rye`](xchacha20.rye) | HChaCha20 · XChaCha20-Poly1305 extended-nonce AEAD (safe random nonces) | draft-irtf-cfrg-xchacha-03 |

### The Curve25519 base field and the edwards25519 curve

| File | What it is | Reference |
|---|---|---|
| [`fe25519.rye`](fe25519.rye) | The base field GF(2²⁵⁵−19), five 51-bit limbs | — |
| [`ed25519_group.rye`](ed25519_group.rye) | The edwards25519 group law (extended coordinates) | RFC 8032 §5.1.4 |
| [`ed25519_decode.rye`](ed25519_decode.rye) | Point decompression (the inverse of compression) | RFC 8032 §5.1.2 |
| [`ed25519_scalar.rye`](ed25519_scalar.rye) | Scalar arithmetic mod the group order L | RFC 8032 |
| [`ed25519_scalarmul.rye`](ed25519_scalarmul.rye) | Scalar multiplication k·P (double-and-add) | RFC 8032 |
| [`ed25519_muladd.rye`](ed25519_muladd.rye) | Scalar multiply-add (a·b + c) mod L | RFC 8032 |
| [`ed25519_verify.rye`](ed25519_verify.rye) | Ed25519 signature verification, [S]B = R + [k]A | RFC 8032 §5.1.7 |
| [`ed25519_sign.rye`](ed25519_sign.rye) | Ed25519 signing (the whole scheme, sign + verify) | RFC 8032 §5.1.6 |

### Key agreement

| File | What it is | Reference |
|---|---|---|
| [`x25519.rye`](x25519.rye) | X25519 elliptic-curve Diffie-Hellman (Montgomery ladder) | RFC 7748 |
| [`ed25519_to_x25519.rye`](ed25519_to_x25519.rye) | The birational Edwards↔Montgomery key conversion — one Ed25519 identity key made usable for X25519 agreement, and back | RFC 7748 §4.1 |

### Compositions (no new cryptography — proven stones assembled)

| File | What it answers | Composes |
|---|---|---|
| [`signed_carry.rye`](signed_carry.rye) | *Who made this record?* — a content-addressed, signed carry frame | BLAKE2b-512 · Ed25519 sign/verify |
| [`sealed_session.rye`](sealed_session.rye) | *Only you can read this* — an anonymous seal-to-a-public-key box | X25519 · BLAKE2b-512 · ChaCha20-Poly1305 |
| [`vault_seal.rye`](vault_seal.rye) | *Only your password can open this* — a password-sealed box, so the key need never live on the device | Argon2id · XChaCha20-Poly1305 |

## Proving it — witnesses on metal

Every file carries a per-file witness under [`../tools/`](../tools/) named
`crypto_<name>_witness.rish`, which builds `crypto/<name>.rye` fresh to the
gitignored `crypto/bin/` and asserts its `GREEN crypto-<name>` line against the
RFC known-answer and Zig's independent `std.crypto`. To re-prove the **whole
library** with one command:

```
rishi/bin/rishi run tools/crypto_suite_witness.rish
```

[`../tools/crypto_suite_witness.rish`](../tools/crypto_suite_witness.rish) runs all
twenty-four per-file witnesses in the dependency order above, rebuilding and reproving
each from source, and refuses whole — naming the file that stopped it — the moment
any one goes RED. A GREEN suite means every claim in this library is re-provable by
tooling, not trusted from a commit message alone.

## Honest horizons and the custody gate

- **Constant-time timing-safety** is a named **horizon**, not a claim — it wants
  measurement on metal, not an assertion. The primitives that touch a secret scalar
  (signing, key agreement) are correct before they are proven timing-safe. The whole
  posture is gathered in one auditor-facing place — which files touch a secret, which
  are data-independent by construction, and the one path (Ed25519 signing) that is
  **deliberately variable-time** — in [`CONSTANT_TIME.md`](CONSTANT_TIME.md), the
  Season's constant-time discipline note.
- **Monocypher-source parity** is a **horizon** behind the held `vendor/monocypher`
  network fetch; today's parity is proven against the RFC vectors and Zig's
  `std.crypto`, both runnable now.
- **The keys stay the maintainer's hand.** Every witness runs over **TEST** keys and
  the RFC's public vectors — no real identity key, no network, no funds, no real
  device. Signing a record, or agreeing a session, with the maintainer's **own**
  identity key stays a **custody gate**: the library builds and verifies; it never
  holds the key.

---

*May this crypto, written in the open and checked against the world, be worthy of
the trust a hand places in it — and may every keeper who reaches for it find a
door they can read all the way down.*
