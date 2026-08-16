# Crypto — the Season G audit front door

*A Rye-native, parity-checked cryptography library — thirty-five primitives and seventeen compositions, each GREEN on metal.*

**Status:** Checkable — Season G operator + auditor guide
**Depth:** guide
**Ceiling:** ≤300 lines
**Last updated:** 2026-08-16
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

## Rung table — fifty-two files, dependency order

Each rung stands on the GREEN rungs beneath it; none authors cryptography a lower
rung had not already proven. Every file carries a per-file witness
`tools/crypto_<name>_witness.rish` asserting its own `GREEN crypto-<name>` line.

### Hashes

| File | What it is | Reference |
|------|------------|-----------|
| `sha512.rye` | SHA-512 — the hash Ed25519 signs with | FIPS 180-4 · RFC 8032 |
| `blake2b.rye` | BLAKE2b-512 — Monocypher's hash · the key-derivation hash | RFC 7693 |
| `sha3.rye` | SHA3-256 · SHA3-512 over Keccak-f[1600] — the hash Aurora names content with | FIPS 202 |
| `keccak256.rye` | Keccak-256 — the Ethereum-family hash, the same Keccak-f[1600] sponge as SHA3-256 with the original 0x01 delimiter; composes over the GREEN `sha3.rye` | Keccak (pre-FIPS-202) |
| `shake.rye` | SHAKE128 · SHAKE256 extendable-output functions over Keccak-f[1600] | FIPS 202 |
| `sha256.rye` | SHA-256 — the hash Tablecloth keys content with, and Mycelium places and seeds by | FIPS 180-4 |
| `ripemd160.rye` | RIPEMD-160 — the second half of Bitcoin's HASH160 = RIPEMD-160(SHA-256(x)), the address step Base58Check and Bech32 encode; composes over the GREEN `sha256.rye` | RIPEMD-160 (Dobbertin·Bosselaers·Preneel) |

### Keyed hash and key derivation

| File | What it is | Reference |
|------|------------|-----------|
| `hmac_sha512.rye` | HMAC-SHA-512 keyed authentication — the HKDF / PRF stone | RFC 2104 · FIPS 198-1 · RFC 4231 |
| `hmac_sha256.rye` | HMAC-SHA-256 keyed authentication — TLS 1.3 PRF · JWT HS256 · TOTP · the Signal/Bitcoin HKDF stone | RFC 2104 · FIPS 198-1 · RFC 4231 |
| `hkdf_sha512.rye` | HKDF-SHA-512 extract-then-expand — the key schedule every handshake and vault stands on | RFC 5869 |
| `hkdf_sha256.rye` | HKDF-SHA-256 extract-then-expand — the schedule TLS 1.3 · Noise · Signal run, proven against RFC 5869's own SHA-256 vectors | RFC 5869 |
| `argon2.rye` | Argon2d · Argon2i · Argon2id memory-hard password KDF — the stone Vault stands on | RFC 9106 |
| `pbkdf2_sha256.rye` | PBKDF2-HMAC-SHA-256 iteration-hard password KDF — WPA2/WPA3 · LUKS · 1Password; Argon2's iteration-hard counterpart | RFC 8018 · RFC 7914 §11 |
| `pbkdf2_sha512.rye` | PBKDF2-HMAC-SHA-512 iteration-hard password KDF — the SHA-512 PRF; the exact stretch BIP-39 folds a mnemonic and passphrase into a 512-bit wallet seed with (2048 rounds); the stone the coming BIP-39 rung stands on | RFC 8018 · BIP-39 |

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

### The secp256k1 base field (the Bitcoin/Ethereum curve)

| File | What it is | Reference |
|------|------------|-----------|
| `fe_secp256k1.rye` | The base field GF(2²⁵⁶ − 2³² − 977), eight 32-bit limbs — the durable stone the whole secp256k1 tower (group law, ECDSA verify, public-key recovery) will stand on; the crux the address arc above (Keccak-256 · RIPEMD-160 · Base58Check · Bech32 · EIP-55) was climbing toward. Not in Monocypher, so parity is by-hand known-answers plus Zig's independent `std.crypto.ecc.Secp256k1.Fe` | secp256k1 (SEC 2) |
| `secp256k1_group.rye` | The group law over the field above — point add, double, negate in complete homogeneous projective coordinates (x = X/Z, y = Y/Z), exception-free for every pair; the composition a scalar-multiplication ladder repeats, the last step before ECDSA verify and public-key recovery. Parity is algebraic known-answers plus Zig's independent `std.crypto.ecc.Secp256k1` on affine coordinates | RCB eprint 2015/1060 (a = 0) |
| `secp256k1_scalarmul.rye` | Scalar multiplication k·P over the group law — the double-and-add ladder ECDSA repeats for Q = d·G and for u1·G + u2·Q on every verify; variable-time (a constant-time ladder for secret scalars is the named horizon). Parity is algebraic known-answers plus Zig's `std.crypto.ecc.Secp256k1.mul` on affine coordinates | double-and-add over RCB |
| `secp256k1_scalar.rye` | Arithmetic modulo the group order n — reduce, multiply, invert (Fermat a^(n−2)), and is_canonical, the second field ECDSA needs beside the base field: verification computes s⁻¹ mod n, then u1 = z·s⁻¹ and u2 = r·s⁻¹, and checks the affine x of u1·G + u2·Q reduced mod n against r. n = 2²⁵⁶ − δ is built from its defining form, never a pasted limb. Parity is algebraic known-answers plus Zig's `std.crypto.ecc.Secp256k1.scalar` (reduce64 · mul · invert · rejectNonCanonical) | secp256k1 (SEC 2) · Fermat |
| `secp256k1_ecdsa.rye` | ECDSA signature **verification** — the assembly the whole secp256k1 tower was climbing toward, the scheme Bitcoin and Ethereum sign with. Given a public key Q = (Qx, Qy), a message hash z, and a signature (r, s), it refuses unless r, s ∈ [1, n−1], folds z mod n, computes w = s⁻¹, u1 = z·w, u2 = r·w, forms R = u1·G + u2·Q, refuses infinity, and accepts iff the affine x of R reduced mod n equals r. The base point G is the SEC 2 generator parsed through the proven base field, never raw limbs; one strengthening beyond the reference is an on-curve check (y² = x³ + 7) that refuses an off-curve key. Every value is public, so verification is the non-gated rung — signing stays the custody gate. Parity is algebraic known-answers plus Zig's independent `std.crypto.sign.ecdsa.EcdsaSecp256k1Sha256`, true-for-true and false-for-false | SEC 1 · secp256k1 (SEC 2) |
| `secp256k1_ecdsa_sign.rye` | ECDSA signature **signing** — the rung that completes the scheme the verifier could only check. Given a private scalar d ∈ [1, n−1] and a message, it derives a per-message nonce k **deterministically** from d and the raw SHA-256 hash (no randomness, so the same key and message always sign to the same bytes), forms R = k·G, takes r = affine x of R mod n (refusing r = 0), computes s = k⁻¹·(z + r·d) mod n (refusing s = 0), and emits (r, s) big-endian. The nonce reproduces Zig's null-noise "Deterministic ECDSA with Additional Randomness" DRBG — RFC 6979's HMAC-DRBG with a 32-byte zero noise block and the raw digest — so the whole signature is **byte-identical** to Zig's. Signing touches a secret, so it signs only with a caller-supplied **test** key: the maintainer's own identity key stays the custody gate (#3/#4), and constant-time signing arithmetic stays the named horizon. Parity is an algebraic round-trip through the GREEN verifier plus Zig's independent `EcdsaSecp256k1Sha256` signature byte-for-byte across a spread of deterministic key pairs and messages | RFC 6979 · SEC 1 · secp256k1 (SEC 2) |
| `secp256k1_ecrecover.rye` | ECDSA public-key **recovery** — the Ethereum `ecrecover` primitive (the EVM precompile at address `0x01`) that reads the **sender** back out of a signature: the operation behind every Sign-in-with-Ethereum, every EIP-191/712 authentication, and every transaction-sender derivation the account model rests on. Given (r, s), a recovery id of 0 or 1, and the hash z, it refuses r, s outside [1, n−1], takes R's x = r (r < n < p, always canonical — the j = 1 overflow ids 2 and 3 are outside v = 27/28 and refused as the precompile refuses them), decompresses R by solving y² = x³ + 7 for the root whose low bit matches the recovery id, and recovers Q = r⁻¹·(s·R − z·G). It adds exactly one new base-field arithmetic — a square root √a = a^((p+1)/4), valid because p ≡ 3 (mod 4), by the same ladder the base field's inverse walks over a public exponent. Recovery touches only public values, so it is non-gated — it answers *who signed this?*, never *sign this*. Parity is an algebraic round-trip (each key recovers back from its own signature at exactly one recovery id, and the recovered key's Ethereum address matches) plus Zig's independent `std.crypto.ecc.Secp256k1.fromSec1` decompression byte-for-byte on R's recovered y | SEC 1 §4.1.6 · secp256k1 (SEC 2) · EIP-191/712 |
| `secp256k1_pubkey.rye` | SEC1 public-key **serialization** — a public key is a curve point, and a curve point has two published dresses: the 33-byte COMPRESSED form (tag `0x02` even / `0x03` odd, then x — the form BIP-32's `serP(point)` hashes) and the 65-byte UNCOMPRESSED form (tag `0x04`, then x‖y — Ethereum's expanded body). `compress_xy`/`uncompress_xy` write both from a point, `from_private_*` from a private scalar over the GREEN `derive_public`, and `parse` reads either back to (x, y), recovering a compressed key's y through the GREEN `ecrecover.decompress`; authors no new cryptography. Parity against Zig's own `std.crypto.ecc.Secp256k1`: for eight deterministic scalars our encodings equal `toCompressedSec1`/`toUncompressedSec1` byte-for-byte, and our parse recovers Zig's own affine coordinates. Edges `BadLength`/`BadTag` refuse | SEC 1 §2.3.3 · derive_public · decompress |

### Compositions (no new cryptography — proven stones assembled)

| File | What it answers | Composes |
|------|-----------------|----------|
| `signed_carry.rye` | *Who made this record?* — a content-addressed, signed carry frame | BLAKE2b-512 · Ed25519 |
| `sealed_session.rye` | *Only you can read this* — a seal-to-a-public-key box | X25519 · BLAKE2b-512 · ChaCha20-Poly1305 |
| `vault_seal.rye` | *Only your password can open this* — a password-sealed box | Argon2id · XChaCha20-Poly1305 |
| `eth_address.rye` | *What Ethereum address is this key?* — the low 20 bytes of Keccak-256(pubkey), EIP-55 mixed-case checksum | Keccak-256 |
| `bitcoin_address.rye` | *What Bitcoin address is this key?* — HASH160 = RIPEMD-160(SHA-256(pubkey)) wrapped as a Base58Check "1…" address (P2PKH) or a SegWit v0 Bech32 "bc1…" address (P2WPKH). Parity: the canonical Bitcoin-wiki P2PKH worked example (its HASH160 the very payload `base58check.rye`'s own known-answer wraps) and the BIP-173 P2WPKH vector, both round-tripping back to their HASH160 | SHA-256 · RIPEMD-160 · Base58Check · Bech32 |
| `eth_personal_sign.rye` | *Who signed this message?* — the EIP-191 `personal_sign` digest and `recover_signer`, reading the sender address out of a 65-byte `r‖s‖v` signature: "Sign in with Ethereum" | Keccak-256 · ecrecover · eth_address |
| `eip712.rye` | *Who signed this typed message, for this app, on this chain?* — the EIP-712 typed-structured-data digest a wallet shows before signing "typed data" (EIP-2612 permits, DeFi orders, gasless meta-transactions, typed Sign-in-with-Ethereum). Hashes a tree of typed fields (`type_hash`, `hash_struct`, `eip712_domain_separator`) into `keccak256(0x19 0x01 ‖ domain_separator ‖ struct_hash)`, so a signature for one contract on one chain never replays against another; `recover_typed_signer` reads the sender back out. Parity three ways: the EIP-712 spec's own canonical Ether Mail example recovered by the spec's own published signature to Cow's published wallet, an independent Zig-Keccak construction byte-for-byte, and a full TEST-key round-trip | Keccak-256 · ecrecover · eth_address |
| `eip155_tx.rye` | *What does a key sign before every on-chain send, and who signed it?* — the EIP-155 legacy Ethereum transaction digest `keccak256(rlp([nonce, gasPrice, gas, to, value, data, chainId, 0, 0]))`, the exact bytes a wallet signs. Hashes the flat nine-field transaction list (where `eip712` hashes a typed tree off-chain); the chain id folded into the preimage is replay protection, and `v = recovery_id + 2·chainId + 35` carries it back out, so `recover_sender` reads the twenty-byte sender out of the sighash and signature. Parity three ways: the EIP-155 spec's own canonical example hashes byte-for-byte to the spec's stated sighash `0xdaf5a779…4c8e53`, an independent Zig-Keccak construction over the same RLP gives the identical digest, and the spec's published `(v=37, r, s)` recovers to exactly the example's published sender `0x9d8a62f6…855a4f` | RLP · Keccak-256 · ecrecover · eth_address |
| `eip1559_tx.rye` | *What does a key sign before every modern (type-2) send, and who signed it?* — the EIP-1559 typed-transaction digest `keccak256(0x02 ‖ rlp([chainId, nonce, maxPriorityFeePerGas, maxFeePerGas, gasLimit, to, value, data, accessList]))`, the exact bytes a wallet signs since the London fork. Prepends the EIP-2718 type byte `0x02` and carries the dynamic-fee market (a tip ceiling and a fee ceiling in place of one gasPrice); the signed wire form appends `[yParity, r, s]` for twelve fields, the recovery bit a plain `yParity` because the chain id already lives in the signed list, so `recover_sender` reads the twenty-byte sender back out. Parity three ways with no fabricated constant: the example test key `0x4646…46` derives to exactly the address EIP-155 publishes, `0x9d8a62f6…855a4f`; an independent Zig-Keccak construction over the same type-prefixed RLP gives the identical digest; and deterministically signing then recovering returns exactly that derived address | RLP · Keccak-256 · ecdsa_sign · ecrecover · eth_address |
| `bip32.rye` | *From one seed, the whole tree of a wallet's keys.* — BIP-32 hierarchical-deterministic keys: a child private key is `(parse256(I_L) + k_par) mod n` where `I = HMAC-SHA-512(c_par, D)` splits into the offset `I_L` and the child chain code `I_R`; `D` is `0x00‖ser256(k_par)‖ser32(i)` for a hardened child or `serP(point(k_par))‖ser32(i)` for a normal one. `master_from_seed` runs the fixed `"Bitcoin seed"` HMAC, `ckd_priv` derives both kinds, `neuter`/`ckd_pub` derive the public tree from an xpub alone (`K_child = point(I_L) + K_par` over the complete group law, a hardened index refused from a public parent), and `serialize_xprv`/`serialize_xpub`/`serialize_ext_pub` wrap any node in the 78-byte version‖depth‖fingerprint‖index‖chain-code‖key body under Base58Check. The rung a wallet's whole account model stands on — one backup phrase, one seed, the ladder of addresses beneath it, watch-only or spending. Parity against BIP-32's own published Test Vector 1: from the published seed `000102…0f`, all six chain nodes serialize to EXACTLY the spec's published xprv AND xpub strings, character for character; each node's neuter reproduces the same xpub, and every normal index reaches it through CKDpub from the neutered parent alone | HMAC-SHA-512 · secp256k1 pubkey · group law · scalar reduce · HASH160 · Base58Check |
| `bip39_mnemonic.rye` | BIP-39 entropy↔mnemonic — the wallet arc's other half: `from_entropy` makes the twelve-to-twenty-four English words a keeper writes down, `to_entropy` reads a phrase back to its entropy **and verifies the checksum**, catching a mistyped backup word. A `CS = ENT/32` checksum from the GREEN `sha256.rye` plus 11-bit bit-packing over BIP-39's fixed 2048-word list; the list is the canonical bitcoin/bips `english.txt`, embedded and proven authentic (SHA-256 = `2f5eed53…3b24dbda`). Proven against BIP-39's own Trezor vectors across ENT 128/192/256 both extremes, encode and decode byte-for-byte, a flipped word refused; entropy generation a named horizon | SHA-256 · BIP-39 |
| `bip39_seed.rye` | BIP-39 mnemonic→seed — the wallet arc's bridge from a human backup phrase to the 512-bit seed `bip32.rye` grows the HD tree from. One recipe over the GREEN `pbkdf2_sha512.rye`: `seed = PBKDF2-HMAC-SHA-512(mnemonic, "mnemonic"‖passphrase, 2048, 64)`. Proven against BIP-39's own published Trezor vectors byte-for-byte; NFKD normalization a documented precondition, entropy→mnemonic a separate rung | PBKDF2-HMAC-SHA-512 · BIP-39 |
| `bip44.rye` | BIP-44 account paths — the convention giving `bip32.rye`'s HD tree its five-level shape `m/44'/coin_type'/account'/change/address_index`, so every wallet reaches the same address for the same phrase. `parse_path` reads the human path text (the `'`/`h`/`H` hardened marker, decimal indices bounded overflow-safe below 2³¹) into the exact 32-bit index list; `derive_path`/`derive_bip44` walk `bip32.rye`'s `ckd_priv` down it to the account leaf. Authors no new cryptography. Parity against BIP-32's own Test Vector 1: all six nodes walked **by their human path strings** serialize to EXACTLY the spec's published xprv AND xpub, no external fetch; `m/44'/60'/0'/0/0` parses to the exact hardened index list, `derive_bip44` and `derive_path` agree byte-for-byte, malformed paths refused. TEST keys only; a real signature stays the custody gate | BIP-32 |
| `slip10_ed25519.rye` | SLIP-0010 HD keys over the **ed25519** curve — the identity arc's HD rung, the bridge from a BIP-39 seed to Grain's OWN ed25519 identity keys (Kumara signs with ed25519). BIP-32's additive child law does not fit ed25519, so SLIP-0010 takes the child key as `I_L` directly and derives **hardened-only**: `master_from_seed` runs the `"ed25519 seed"` HMAC; `ckd_priv` derives a hardened child via `I = HMAC-SHA-512(c_par, 0x00‖ser256(k_par)‖ser32(i))`; `public_key` emits `0x00‖ed25519_public(I_L)`; `derive` walks a hardened index list. Authors no new cryptography — composes the GREEN `hmac_sha512.rye` and `ed25519_sign.rye`. Parity against SLIP-0010's own ed25519 Test Vectors 1 and 2: every chain node's private key, chain code, AND 33-byte public key reproduce EXACTLY the spec's bytes; a non-hardened index refuses `NotHardened`, an over-deep path `DepthTooDeep`. TEST keys only; a real Kumara signature stays the custody gate | HMAC-SHA-512 · Ed25519 |
| `kumara_path.rye` | The **Kumara identity path** — the ed25519 sibling of `bip44.rye`: the convention giving `slip10_ed25519.rye`'s ed25519 HD tree its named shape `m/44'/coin_type'/account'/index'`, so a keeper's Kumara identity is reached the same way from the same phrase on any device. ed25519 admits only hardened derivation, so `parse_path` REQUIRES a `'`/`h`/`H` marker on every level (a bare index refused `NotHardened`); `derive_path`/`derive_identity` walk `slip10_ed25519.rye`'s `ckd_priv` down the all-hardened list. Authors no new cryptography. Parity against SLIP-0010's own ed25519 Test Vectors 1 and 2: all six nodes of each, walked **by their human path strings**, reproduce EXACTLY the spec's private key, chain code, AND 33-byte public key, no external fetch; `m/44'/0'/0'/0'` parses to `[44+H, 0+H, 0+H, 0+H]`, `derive_identity` and `derive_path` agree byte-for-byte, malformed paths refused. A registered Grain SLIP-44 coin type is a named horizon. TEST keys only; a real Kumara signature stays the custody gate | SLIP-0010 (Test Vectors 1·2) |
| `kumara_identity.rye` | The **identity arc's front door** — the one composition tying the arc into a single answer: `from_mnemonic` folds a mnemonic to a 512-bit seed through the GREEN `bip39_seed.rye`, walks `kumara_path.rye`'s `m/44'/coin'/account'/index'` over the GREEN `slip10_ed25519.rye` HD tree, and reads off the raw 32-byte ed25519 public key (Kumara's identity form — the SLIP-0010 33-byte public with its `0x00` tag stripped); `sign`/`verify` are thin wrappers over `ed25519_sign.rye`+`ed25519_verify.rye` so a caller reaches identity through one door. The identity-arc sibling of `eth_address.rye`/`bitcoin_address.rye`: where those render a key to its address, this renders a phrase to the signing identity every module (Kumara, Vault, Comlink, Lotus) reaches through. Authors no new cryptography. Proven three ways: the bip39 half anchored to BIP-39's own Trezor vector seed byte-for-byte; the arc drift-free (`from_mnemonic` = hand-wiring `bip39_seed`→`kumara_path.derive_identity`, public key = slip10's public form = ed25519_sign's `derive_public`, all three agreeing, the ed25519 half proven one rung down); the derived key a real signing key by a sign→verify round-trip with three refusals (flipped message, flipped signature, wrong key). TEST identities only; a real Kumara identity and signature stays the custody gate | BIP-39 · SLIP-0010 · Ed25519 |

---

## Proving it — one command greens the whole library

```bash
rishi/bin/rishi run tools/crypto_suite_witness.rish
```

[`crypto_suite_witness.rish`](../tools/crypto_suite_witness.rish) rebuilds each
`crypto/<name>.rye` fresh from source to the gitignored `crypto/bin/` and runs all
fifty-two per-file witnesses in the dependency order above, refusing whole —
naming the file that stopped it — the moment any one goes RED. A GREEN suite means
every claim here is re-provable by tooling, not trusted from a commit message
alone (measurement beats memory). It then runs the **count guard**
([`crypto_count_guard_witness.rish`](../tools/crypto_count_guard_witness.rish)) — a
bijection asserting the suite registers exactly the `crypto/*.rye` files on disk and
printing the computed count, so the spelled number above can never silently drift
from the files again (booked by [`REDS`](../work-in-progress/REDS.md) #80).

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
