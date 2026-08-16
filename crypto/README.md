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

## The forty-five files — thirty-four primitives and eleven compositions

Built in dependency order: each rung stands on the GREEN rungs beneath it, none
authoring cryptography a lower rung had not already proven.

### Hashes

| File | What it is | Reference |
|---|---|---|
| [`sha512.rye`](sha512.rye) | SHA-512 | FIPS 180-4 · RFC 8032 (the hash Ed25519 signs with) |
| [`blake2b.rye`](blake2b.rye) | BLAKE2b-512 | RFC 7693 (Monocypher's hash · the key-derivation hash) |
| [`sha3.rye`](sha3.rye) | SHA3-256 · SHA3-512 over Keccak-f[1600] (the hash Aurora's content-addressed store names content with) | FIPS 202 |
| [`sha256.rye`](sha256.rye) | SHA-256 (the hash Tablecloth keys content with, and the Mycelium consensus spine places worlds and seeds constel identities by) | FIPS 180-4 |
| [`keccak256.rye`](keccak256.rye) | Keccak-256 — the Ethereum-family hash (an account address is the low 20 bytes of the Keccak-256 of a public key, an EVM function dispatches on the first 4 bytes of the Keccak-256 of its signature, every EIP-191/712 digest is a Keccak-256). NOT SHA3-256: same permutation, one differing byte — the original Keccak `0x01` delimiter rather than FIPS 202's `0x06`. Composes the GREEN `sha3.rye` sponge; authors no new cryptography | original Keccak · FIPS 202 |
| [`ripemd160.rye`](ripemd160.rye) | RIPEMD-160 — the 160-bit hash that completes Bitcoin's HASH160 = RIPEMD-160(SHA-256(x)), the address-derivation step [`../encoding/base58check.rye`](../encoding/base58check.rye) and [`../encoding/bech32.rye`](../encoding/bech32.rye) encode. Two parallel eighty-step lines over a five-word state, little-endian. Zig ships no RIPEMD reference, so proven against the RIPEMD-160 authors' published known-answer suite; HASH160 composes live over the GREEN `sha256.rye` | RIPEMD-160 (Dobbertin·Bosselaers·Preneel) |
| [`shake.rye`](shake.rye) | SHAKE128 · SHAKE256 — the SHA-3 extendable-output functions (any-length output rather than a fixed digest): the XOF inside Ed448 and SPHINCS+, seeding ML-KEM (Kyber) and ML-DSA (Dilithium), and the base of cSHAKE / KMAC. Same permutation and pad10\*1 rule as SHA3, one differing byte — the `0x1f` delimiter — and a squeeze that walks across as many rate blocks as the output needs. Composes the GREEN `sha3.rye` sponge (whose squeeze this rung generalized to multi-block); authors no new cryptography | FIPS 202 §6.2 |

### Keyed hash and key derivation

| File | What it is | Reference |
|---|---|---|
| [`hmac_sha512.rye`](hmac_sha512.rye) | HMAC-SHA-512 keyed message authentication (the HKDF / PRF stone) | RFC 2104 · FIPS 198-1 · RFC 4231 (vectors) |
| [`hmac_sha256.rye`](hmac_sha256.rye) | HMAC-SHA-256 keyed message authentication (TLS 1.3 PRF · JWT HS256 · TOTP · the Signal/Bitcoin HKDF stone) | RFC 2104 · FIPS 198-1 · RFC 4231 (vectors) |
| [`hkdf_sha512.rye`](hkdf_sha512.rye) | HKDF-SHA-512 extract-then-expand key derivation (the key schedule every handshake and vault stands on) | RFC 5869 |
| [`hkdf_sha256.rye`](hkdf_sha256.rye) | HKDF-SHA-256 extract-then-expand key derivation (the schedule TLS 1.3 · Noise · Signal run — proven against RFC 5869's own SHA-256 vectors) | RFC 5869 |
| [`argon2.rye`](argon2.rye) | Argon2d · Argon2i · Argon2id memory-hard password KDF (a remembered password into a key at a large RAM cost — the stone Vault stands on) | RFC 9106 |
| [`pbkdf2_sha256.rye`](pbkdf2_sha256.rye) | PBKDF2-HMAC-SHA-256 iteration-hard password KDF (WPA2/WPA3 · LUKS · 1Password — a password stretched by iterating the HMAC, the counterpart to Argon2's memory hardness) | RFC 8018 · RFC 7914 §11 (vectors) |

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

### The secp256k1 curve (the Bitcoin/Ethereum curve)

| File | What it is | Reference |
|---|---|---|
| [`fe_secp256k1.rye`](fe_secp256k1.rye) | The base field GF(2²⁵⁶ − 2³² − 977), eight 32-bit limbs — the durable stone the whole secp256k1 tower stands on. Not in Monocypher, so parity is by-hand known-answers plus Zig's independent `std.crypto.ecc.Secp256k1.Fe` | secp256k1 (SEC 2) |
| [`secp256k1_group.rye`](secp256k1_group.rye) | The group law — point add, double, negate in complete homogeneous projective coordinates, exception-free for every pair. Parity is algebraic known-answers plus Zig's `std.crypto.ecc.Secp256k1` on affine coordinates | RCB eprint 2015/1060 (a = 0) |
| [`secp256k1_scalarmul.rye`](secp256k1_scalarmul.rye) | Scalar multiplication k·P over the group law (double-and-add) — variable-time; a constant-time ladder for secret scalars is the named horizon. Parity against Zig's `std.crypto.ecc.Secp256k1.mul` | double-and-add over RCB |
| [`secp256k1_scalar.rye`](secp256k1_scalar.rye) | Arithmetic modulo the group order n — reduce, multiply, invert (Fermat), is_canonical; n built from its defining form, never a pasted limb. Parity against Zig's `std.crypto.ecc.Secp256k1.scalar` | secp256k1 (SEC 2) · Fermat |
| [`secp256k1_ecdsa.rye`](secp256k1_ecdsa.rye) | ECDSA signature **verification** — the scheme Bitcoin and Ethereum sign with, composed over the tower above, with an added on-curve check that refuses an off-curve key. Every value is public, so verification is non-gated; signing stays the custody gate. Parity against Zig's `std.crypto.sign.ecdsa.EcdsaSecp256k1Sha256`, true-for-true and false-for-false | SEC 1 · secp256k1 (SEC 2) |
| [`secp256k1_ecdsa_sign.rye`](secp256k1_ecdsa_sign.rye) | ECDSA signature **signing** — the rung that completes the scheme, deriving a deterministic per-message nonce (Zig's null-noise RFC 6979 DRBG, reproduced exactly) and emitting (r, s) **byte-identical** to Zig's. Signs only with a caller-supplied **test** key; the maintainer's identity key stays the custody gate, constant-time signing the named horizon. Parity is an algebraic round-trip through the verifier plus Zig's `EcdsaSecp256k1Sha256` signature byte-for-byte | RFC 6979 · SEC 1 · secp256k1 (SEC 2) |
| [`secp256k1_ecrecover.rye`](secp256k1_ecrecover.rye) | ECDSA public-key **recovery** — the Ethereum `ecrecover` primitive (the EVM precompile at address `0x01`) that reads the **sender** back out of a signature: the operation behind every Sign-in-with-Ethereum, every EIP-191/712 authentication, and every transaction-sender derivation the account model rests on. Given (r, s), a recovery id of 0 or 1, and the hash, it recovers Q = r⁻¹·(s·R − z·G), adding exactly one new base-field arithmetic — a square root √a = a^((p+1)/4) for point decompression, valid because p ≡ 3 (mod 4). Recovery touches only public values, so it is non-gated; it answers *who signed this?*, never *sign this*. Parity is an algebraic round-trip (each key recovers back from its own signature at exactly one recovery id) plus Zig's `Secp256k1.fromSec1` decompression byte-for-byte | SEC 1 §4.1.6 · secp256k1 (SEC 2) · EIP-191/712 |

### Compositions (no new cryptography — proven stones assembled)

| File | What it answers | Composes |
|---|---|---|
| [`signed_carry.rye`](signed_carry.rye) | *Who made this record?* — a content-addressed, signed carry frame | BLAKE2b-512 · Ed25519 sign/verify |
| [`sealed_session.rye`](sealed_session.rye) | *Only you can read this* — an anonymous seal-to-a-public-key box | X25519 · BLAKE2b-512 · ChaCha20-Poly1305 |
| [`vault_seal.rye`](vault_seal.rye) | *Only your password can open this* — a password-sealed box, so the key need never live on the device | Argon2id · XChaCha20-Poly1305 |
| [`eth_address.rye`](eth_address.rye) | *What is this key's Ethereum address?* — the low twenty bytes of the Keccak-256 of a public key, and its EIP-55 mixed-case checksum, the self-verifying human form (the Ethereum sibling of `../encoding/base58check.rye`) | Keccak-256 |
| [`bitcoin_address.rye`](bitcoin_address.rye) | *What is this key's Bitcoin address?* — HASH160 = RIPEMD-160(SHA-256(public key)) wrapped in a self-checking envelope: the legacy Base58Check "1…" address (P2PKH, under a version byte) or the SegWit v0 Bech32 "bc1…" address (P2WPKH, under witness version 0). The Bitcoin sibling of `eth_address.rye`; proven against the canonical Bitcoin-wiki P2PKH worked example (whose HASH160 is the very payload `../encoding/base58check.rye`'s own known-answer wraps) and the BIP-173 P2WPKH vector, both round-tripping back to their HASH160 | SHA-256 · RIPEMD-160 · Base58Check · Bech32 |
| [`eth_personal_sign.rye`](eth_personal_sign.rye) | *Who signed this message?* — the EIP-191 `personal_sign` digest (`"\x19Ethereum Signed Message:\n"` framing, the 0x19 sentinel that can never begin a valid transaction) and `recover_signer`, which reads the twenty-byte sender address out of a 65-byte `r‖s‖v` signature: "Sign in with Ethereum," end to end | Keccak-256 · ecrecover · eth_address |
| [`eip712.rye`](eip712.rye) | *Who signed this typed message, for this app, on this chain?* — the EIP-712 typed-structured-data digest a wallet shows before it signs "typed data" (EIP-2612 permits, DeFi orders, gasless meta-transactions, typed Sign-in-with-Ethereum). Where EIP-191 frames a flat string, EIP-712 hashes a *tree* of typed fields (`type_hash` · `hash_struct` · `eip712_domain_separator`) against a domain separator into `keccak256(0x19 0x01 ‖ domain_separator ‖ struct_hash)`, so a signature for one contract on one chain can never be replayed against another, and `recover_typed_signer` reads the sender back out. Proven three ways runnable now — the EIP-712 spec's own canonical Ether Mail example recovered by the spec's own published signature to Cow's published wallet, an independent Zig-Keccak construction byte-for-byte, and a full TEST-key round-trip | Keccak-256 · ecrecover · eth_address |
| [`eip155_tx.rye`](eip155_tx.rye) | *What does a key sign before every on-chain send, and who signed it?* — the EIP-155 legacy Ethereum transaction digest: `keccak256(rlp([nonce, gasPrice, gas, to, value, data, chainId, 0, 0]))`, the exact bytes a wallet signs. Where `eip712` hashes a *tree* of typed fields off-chain, `eip155_tx` hashes the *flat* nine-field list of an on-chain transaction; the chain id folded into the preimage is replay protection, and `v = recovery_id + 2·chainId + 35` carries it back out, so `recover_sender` reads the twenty-byte sender out of the sighash and signature. Proven three ways anyone can replay — the EIP-155 spec's own canonical example hashes byte-for-byte to the spec's stated sighash `0xdaf5a779…4c8e53`, an independent Zig-Keccak construction over the same RLP gives the identical digest, and the spec's published `(v=37, r, s)` recovers to exactly the example's published sender `0x9d8a62f6…855a4f` | RLP · Keccak-256 · ecrecover · eth_address |
| [`eip1559_tx.rye`](eip1559_tx.rye) | *What does a key sign before every modern (type-2) send, and who signed it?* — the EIP-1559 typed-transaction digest: `keccak256(0x02 ‖ rlp([chainId, nonce, maxPriorityFeePerGas, maxFeePerGas, gasLimit, to, value, data, accessList]))`, the exact bytes a wallet signs since the London fork. Where `eip155_tx` hashes the flat legacy list, `eip1559_tx` prepends the EIP-2718 type byte `0x02` and carries the dynamic-fee market (a tip ceiling and a fee ceiling in place of one gasPrice); the signed wire form appends `[yParity, r, s]` for twelve fields, the recovery bit a plain `yParity` because the chain id already lives in the signed list, and `recover_sender` reads the twenty-byte sender back out. Proven three ways anyone can replay, with no fabricated constant — the example test key `0x4646…46` derives through our secp256k1 + eth_address to exactly the address EIP-155 publishes, `0x9d8a62f6…855a4f`; an independent Zig-Keccak construction over the same type-prefixed RLP gives the identical digest; and deterministically signing the sighash with that test key then recovering returns exactly that derived address | RLP · Keccak-256 · ecdsa_sign · ecrecover · eth_address |
| [`bip32.rye`](bip32.rye) | *From one seed, the whole tree of a wallet's keys.* — BIP-32 hierarchical-deterministic keys: a child private key is `(parse256(I_L) + k_par) mod n` where `I = HMAC-SHA-512(c_par, D)` splits into the offset `I_L` and the child chain code `I_R`, and the data `D` is `0x00‖ser256(k_par)‖ser32(i)` for a hardened child or `serP(point(k_par))‖ser32(i)` for a normal one. `master_from_seed` runs the fixed `"Bitcoin seed"` HMAC; `ckd_priv` derives both kinds; `serialize_xprv`/`serialize_xpub` wrap any node in its `xprv…`/`xpub…` text (the 78-byte version‖depth‖fingerprint‖index‖chain-code‖key body under Base58Check). This is the rung a wallet's whole account model stands on — one backup phrase, one seed, and the ladder of addresses beneath it. Proven against BIP-32's own published Test Vector 1: from the published seed `000102…0f`, all six chain nodes (m, m/0H, m/0H/1, m/0H/1/2H, m/0H/1/2H/2, m/0H/1/2H/2/1000000000) serialize to EXACTLY the spec's published xprv AND xpub strings, character for character. Public-only CKDpub is the named next rung | HMAC-SHA-512 · secp256k1 pubkey · scalar reduce · HASH160 · Base58Check |

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
forty-five per-file witnesses in the dependency order above, rebuilding and reproving
each from source, and refuses whole — naming the file that stopped it — the moment
any one goes RED, and then runs the **count guard**
([`../tools/crypto_count_guard_witness.rish`](../tools/crypto_count_guard_witness.rish)) —
a bijection asserting the suite registers exactly the `crypto/*.rye` files on disk, so
a file and its proof can never disagree, and printing the computed count as the source
of truth for the spelled numbers above. A GREEN suite means every claim in this library
is re-provable by tooling, not trusted from a commit message alone.

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
