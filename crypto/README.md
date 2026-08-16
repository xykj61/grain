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

## The fifty-three files — thirty-five primitives and eighteen compositions

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
| [`pbkdf2_sha512.rye`](pbkdf2_sha512.rye) | PBKDF2-HMAC-SHA-512 iteration-hard password KDF — the SHA-512 PRF, the exact stretch BIP-39 folds a mnemonic and passphrase into a 512-bit wallet seed with (2048 rounds, salt `mnemonic`‖passphrase), the stone the coming BIP-39 rung stands on. Composes the GREEN `hmac_sha512.rye`; proven byte-for-byte against Zig's independent `std.crypto` PBKDF2 and transitively against the HMAC beneath, no fabricated constant | RFC 8018 · BIP-39 (Trezor vectors, at the BIP-39 rung) |

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
| [`secp256k1_pubkey.rye`](secp256k1_pubkey.rye) | *How is a public key dressed for the wire?* — SEC1 public-key serialization: a curve point in its two published forms, the 33-byte compressed `0x02`/`0x03‖x` (a parity bit alone, since y² = x³ + 7 fixes y up to sign) and the 65-byte uncompressed `0x04‖x‖y`, with `parse` reading either back to (x, y) — a compressed key's y recovered through the curve equation. The rung every address and wallet import reaches for: `serP(point)` is exactly what `bip32.rye` hashes into each child derivation, and the uncompressed 64-byte body is what Ethereum expands a key to. Authors no new cryptography — composed over the GREEN `derive_public` (d·G) and `decompress` (y from x at a parity). Parity holds against Zig's own `std.crypto.ecc.Secp256k1`: our compressed and uncompressed encodings equal `toCompressedSec1`/`toUncompressedSec1` byte-for-byte across eight deterministic scalars, and `parse` recovers Zig's affine coordinates; a wrong length and a tag mismatched to its length each refuse their named error | secp256k1 derive_public · decompress |
| [`eth_address.rye`](eth_address.rye) | *What is this key's Ethereum address?* — the low twenty bytes of the Keccak-256 of a public key, and its EIP-55 mixed-case checksum, the self-verifying human form (the Ethereum sibling of `../encoding/base58check.rye`) | Keccak-256 |
| [`bitcoin_address.rye`](bitcoin_address.rye) | *What is this key's Bitcoin address?* — HASH160 = RIPEMD-160(SHA-256(public key)) wrapped in a self-checking envelope: the legacy Base58Check "1…" address (P2PKH, under a version byte) or the SegWit v0 Bech32 "bc1…" address (P2WPKH, under witness version 0). The Bitcoin sibling of `eth_address.rye`; proven against the canonical Bitcoin-wiki P2PKH worked example (whose HASH160 is the very payload `../encoding/base58check.rye`'s own known-answer wraps) and the BIP-173 P2WPKH vector, both round-tripping back to their HASH160 | SHA-256 · RIPEMD-160 · Base58Check · Bech32 |
| [`eth_personal_sign.rye`](eth_personal_sign.rye) | *Who signed this message?* — the EIP-191 `personal_sign` digest (`"\x19Ethereum Signed Message:\n"` framing, the 0x19 sentinel that can never begin a valid transaction) and `recover_signer`, which reads the twenty-byte sender address out of a 65-byte `r‖s‖v` signature: "Sign in with Ethereum," end to end | Keccak-256 · ecrecover · eth_address |
| [`eip712.rye`](eip712.rye) | *Who signed this typed message, for this app, on this chain?* — the EIP-712 typed-structured-data digest a wallet shows before it signs "typed data" (EIP-2612 permits, DeFi orders, gasless meta-transactions, typed Sign-in-with-Ethereum). Where EIP-191 frames a flat string, EIP-712 hashes a *tree* of typed fields (`type_hash` · `hash_struct` · `eip712_domain_separator`) against a domain separator into `keccak256(0x19 0x01 ‖ domain_separator ‖ struct_hash)`, so a signature for one contract on one chain can never be replayed against another, and `recover_typed_signer` reads the sender back out. Proven three ways runnable now — the EIP-712 spec's own canonical Ether Mail example recovered by the spec's own published signature to Cow's published wallet, an independent Zig-Keccak construction byte-for-byte, and a full TEST-key round-trip | Keccak-256 · ecrecover · eth_address |
| [`eip155_tx.rye`](eip155_tx.rye) | *What does a key sign before every on-chain send, and who signed it?* — the EIP-155 legacy Ethereum transaction digest: `keccak256(rlp([nonce, gasPrice, gas, to, value, data, chainId, 0, 0]))`, the exact bytes a wallet signs. Where `eip712` hashes a *tree* of typed fields off-chain, `eip155_tx` hashes the *flat* nine-field list of an on-chain transaction; the chain id folded into the preimage is replay protection, and `v = recovery_id + 2·chainId + 35` carries it back out, so `recover_sender` reads the twenty-byte sender out of the sighash and signature. Proven three ways anyone can replay — the EIP-155 spec's own canonical example hashes byte-for-byte to the spec's stated sighash `0xdaf5a779…4c8e53`, an independent Zig-Keccak construction over the same RLP gives the identical digest, and the spec's published `(v=37, r, s)` recovers to exactly the example's published sender `0x9d8a62f6…855a4f` | RLP · Keccak-256 · ecrecover · eth_address |
| [`eip1559_tx.rye`](eip1559_tx.rye) | *What does a key sign before every modern (type-2) send, and who signed it?* — the EIP-1559 typed-transaction digest: `keccak256(0x02 ‖ rlp([chainId, nonce, maxPriorityFeePerGas, maxFeePerGas, gasLimit, to, value, data, accessList]))`, the exact bytes a wallet signs since the London fork. Where `eip155_tx` hashes the flat legacy list, `eip1559_tx` prepends the EIP-2718 type byte `0x02` and carries the dynamic-fee market (a tip ceiling and a fee ceiling in place of one gasPrice); the signed wire form appends `[yParity, r, s]` for twelve fields, the recovery bit a plain `yParity` because the chain id already lives in the signed list, and `recover_sender` reads the twenty-byte sender back out. Proven three ways anyone can replay, with no fabricated constant — the example test key `0x4646…46` derives through our secp256k1 + eth_address to exactly the address EIP-155 publishes, `0x9d8a62f6…855a4f`; an independent Zig-Keccak construction over the same type-prefixed RLP gives the identical digest; and deterministically signing the sighash with that test key then recovering returns exactly that derived address | RLP · Keccak-256 · ecdsa_sign · ecrecover · eth_address |
| [`bip32.rye`](bip32.rye) | *From one seed, the whole tree of a wallet's keys.* — BIP-32 hierarchical-deterministic keys: a child private key is `(parse256(I_L) + k_par) mod n` where `I = HMAC-SHA-512(c_par, D)` splits into the offset `I_L` and the child chain code `I_R`, and the data `D` is `0x00‖ser256(k_par)‖ser32(i)` for a hardened child or `serP(point(k_par))‖ser32(i)` for a normal one. `master_from_seed` runs the fixed `"Bitcoin seed"` HMAC; `ckd_priv` derives both kinds; `neuter`/`ckd_pub` derive the public tree from an xpub alone (`K_child = point(I_L) + K_par` over the complete group law, a hardened index refused from a public parent); `serialize_xprv`/`serialize_xpub`/`serialize_ext_pub` wrap any node in its `xprv…`/`xpub…` text (the 78-byte version‖depth‖fingerprint‖index‖chain-code‖key body under Base58Check). This is the rung a wallet's whole account model stands on — one backup phrase, one seed, and the ladder of addresses beneath it, watch-only or spending. Proven against BIP-32's own published Test Vector 1: from the published seed `000102…0f`, all six chain nodes (m, m/0H, m/0H/1, m/0H/1/2H, m/0H/1/2H/2, m/0H/1/2H/2/1000000000) serialize to EXACTLY the spec's published xprv AND xpub strings, character for character; each node's neuter reproduces the same xpub, and every normal index reaches it through CKDpub from the neutered parent alone | HMAC-SHA-512 · secp256k1 pubkey · group law · scalar reduce · HASH160 · Base58Check |
| [`bip39_mnemonic.rye`](bip39_mnemonic.rye) | *The backup phrase itself — made, and checked.* — BIP-39 entropy↔mnemonic, the wallet arc's other half, the one `bip39_seed.rye` named as its own rung: `from_entropy` turns raw entropy into the twelve-to-twenty-four English words a keeper writes down, and `to_entropy` reads a written phrase back to its entropy **while verifying the checksum** — the guard that catches a mistyped or misremembered backup word before it ever grows a wrong wallet. Authors no new cryptography: a `CS = ENT/32` checksum from the GREEN `sha256.rye` (the top CS bits of `SHA-256(entropy)`) plus pure 11-bit bit-packing over BIP-39's fixed 2048-word English list, cut into `MS = (ENT+CS)/11` words. The list is the canonical bitcoin/bips `english.txt`, embedded byte-exact at [`data/bip39_english.txt`](data/bip39_english.txt) and **proven authentic** — SHA-256 of the embedded table equals the published `2f5eed53…3b24dbda`, so a one-word tamper goes RED rather than sign a wrong phrase. Proven against BIP-39's own published Trezor vectors: six entropy values across all three published ENT lengths (128/192/256 bits → 12/18/24 words), both extremes each, encode to EXACTLY their published mnemonics word-for-word and decode back to EXACTLY their entropy byte-for-byte with the checksum verified; a flipped word is refused `InvalidChecksum`. Generating cryptographically strong entropy is the caller's named horizon. With this rung BIP-39 stands whole in our Rye: entropy → mnemonic → seed → the HD tree `bip32.rye` grows | SHA-256 · BIP-39 (Trezor vectors) |
| [`bip39_seed.rye`](bip39_seed.rye) | *One backup phrase folds to the seed the wallet grows from.* — BIP-39 mnemonic→seed: the wallet arc's bridge from a human backup phrase to the 512-bit binary seed `bip32.rye`'s `master_from_seed` grows the whole HD tree from. One fixed recipe — `seed = PBKDF2-HMAC-SHA-512(mnemonic, "mnemonic"‖passphrase, 2048, 64)` — over the GREEN `pbkdf2_sha512.rye`, authoring no new cryptography. Proven against BIP-39's own published Trezor vectors (English, passphrase `TREZOR`, fetched byte-exact): three mnemonics fold to EXACTLY their published 128-hex-char seeds, character for character, and the seed ties transitively to the PBKDF2 beneath. NFKD normalization is a documented precondition (the ASCII vectors make it the identity); entropy→mnemonic with the 2048-word list is its own separate rung | PBKDF2-HMAC-SHA-512 · BIP-39 (Trezor vectors) |
| [`slip10_ed25519.rye`](slip10_ed25519.rye) | *From one seed, the whole tree of a keeper's ed25519 IDENTITY keys.* — SLIP-0010 hierarchical-deterministic keys over the ed25519 curve, the identity arc's HD rung and the bridge from a BIP-39 wallet seed to Grain's OWN signing keys (Kumara signs with ed25519). Where [`bip32.rye`](bip32.rye)'s additive child law fits secp256k1, an ed25519 private key is a 32-byte seed hashed and clamped into a scalar, so SLIP-0010 takes the child key as `I_L` DIRECTLY and derives hardened-only: `master_from_seed` runs the fixed `"ed25519 seed"` HMAC; `ckd_priv` derives a hardened child via `I = HMAC-SHA-512(c_par, 0x00‖ser256(k_par)‖ser32(i))`; `public_key` emits the 33-byte `0x00‖ed25519_public(I_L)` compressed form; `derive` walks a hardened index list to a leaf. Authors NO new cryptography — every byte is the GREEN [`hmac_sha512.rye`](hmac_sha512.rye) PRF and [`ed25519_sign.rye`](ed25519_sign.rye)'s public derivation. Proven against SLIP-0010's OWN published ed25519 test vectors (quoted character for character from satoshilabs/slips): both Test Vector 1 (seed `000102…0f`) and Test Vector 2 (the 64-byte seed) walk EVERY chain node hardened, and at each node the private key, chain code, AND 33-byte public key reproduce EXACTLY the spec's bytes; a non-hardened index refuses `NotHardened`, an over-deep path `DepthTooDeep`. With this rung the identity arc stands: phrase → seed → ed25519 HD tree | HMAC-SHA-512 · Ed25519 public derivation |
| [`bip44.rye`](bip44.rye) | *The path a wallet copies — read, and walked.* — BIP-44 account paths: the convention that gives `bip32.rye`'s HD tree its five-level shape `m/44'/coin_type'/account'/change/address_index`, so every wallet reaches the same address for the same phrase. `parse_path` reads the human path text (the `'`/`h`/`H` marker setting the hardened bit, decimal indices bounded overflow-safe below 2³¹) into the exact 32-bit index list; `derive_path` and `derive_bip44` walk `bip32.rye`'s `ckd_priv` down it from the master to the account leaf a real address is read off. Authors no new cryptography — the mathematics is all one rung down in the GREEN `bip32.rye`. Proven against BIP-32's own published Test Vector 1: all six chain nodes, each walked **by its human path string** (`m` … `m/0'/1/2'/2/1000000000`), serialize to EXACTLY the spec's published xprv AND xpub, character for character, so the parser, the hardened marker, and the walk are all proven against a real answer with no external fetch. The BIP-44 convention itself is proven — `m/44'/60'/0'/0/0` parses to `[44+H, 60+H, 0+H, 0, 0]`, `derive_bip44` and `derive_path` agree byte-for-byte, and a malformed path (no master, a non-digit index, an index at 2³¹, a too-deep path, a trailing slash) each raises its named error. TEST keys only; a real wallet's signature stays the custody gate | BIP-32 (Test Vector 1) |
| [`kumara_path.rye`](kumara_path.rye) | *The path a keeper's identity copies — read, and walked.* — the Kumara identity path, the ed25519 sibling of [`bip44.rye`](bip44.rye): the convention that gives [`slip10_ed25519.rye`](slip10_ed25519.rye)'s ed25519 HD tree its named shape `m/44'/coin_type'/account'/index'`, so a keeper's Kumara identity is reached the same way from the same phrase on any device. The one law ed25519 adds over its secp256k1 sibling: SLIP-0010 admits ONLY hardened derivation, so `parse_path` REQUIRES a `'`/`h`/`H` marker on every level and refuses a bare index `NotHardened`; `derive_path` and `derive_identity` walk `slip10_ed25519.rye`'s `ckd_priv` down the all-hardened list. Authors no new cryptography — the mathematics is one rung down in the GREEN `slip10_ed25519.rye`. Proven against SLIP-0010's OWN published ed25519 Test Vectors 1 and 2: all six nodes of each, walked **by their human path strings** (`m` … `m/0'/1'/2'/2'/1000000000'`), reproduce EXACTLY the spec's private key, chain code, AND 33-byte public key, no external fetch; `m/44'/0'/0'/0'` parses to `[44+H, 0+H, 0+H, 0+H]`, `derive_identity` and `derive_path` agree byte-for-byte, and a malformed path (a bare non-hardened index, no master, a non-digit index, an index at 2³¹, a too-deep path, a trailing slash) each raises its named error. A registered Grain SLIP-44 coin type is a named horizon, so the coin slot stays a caller value. TEST keys only; a real Kumara signature stays the custody gate | SLIP-0010 (Test Vectors 1·2) |
| [`kumara_identity.rye`](kumara_identity.rye) | *From a backup phrase, a keeper's whole signing identity.* — the identity arc's FRONT DOOR, the one composition that ties the arc into a single answer: `from_mnemonic` folds a mnemonic to a 512-bit seed through the GREEN [`bip39_seed.rye`](bip39_seed.rye), walks [`kumara_path.rye`](kumara_path.rye)'s `m/44'/coin'/account'/index'` over the GREEN [`slip10_ed25519.rye`](slip10_ed25519.rye) HD tree, and reads off the raw 32-byte ed25519 public key — Kumara's identity form, the SLIP-0010 33-byte public with its `0x00` domain tag stripped — while `sign`/`verify` are thin wrappers over [`ed25519_sign.rye`](ed25519_sign.rye)+[`ed25519_verify.rye`](ed25519_verify.rye) so a caller reaches identity through one door. The identity-arc sibling of [`eth_address.rye`](eth_address.rye) and [`bitcoin_address.rye`](bitcoin_address.rye): where those render a key to its human address, this renders a phrase to the signing identity every Grain module (Kumara, Vault, Comlink, the Lotus signed carry) reaches through. Authors no new cryptography. Proven three replayable ways with no fabricated constant: the bip39 half anchored to BIP-39's own published Trezor vector seed byte-for-byte; the arc proven drift-free (`from_mnemonic` equals hand-wiring `bip39_seed`→`kumara_path.derive_identity`, and the public key equals both slip10's public form and ed25519_sign's independent `derive_public`, all three agreeing, the ed25519 half proven one rung down against SLIP-0010's own vectors); and the derived key proven a real working signing key by a sign→verify round-trip where a flipped message byte, a flipped signature byte, and a different identity's key each refuse — with determinism, distinctness, and the hardened-offset edge closing it. TEST identities only; a real Kumara identity and signature stays the custody gate | BIP-39 · SLIP-0010 · Ed25519 sign/verify |
| [`kumara_carry.rye`](kumara_carry.rye) | *Did THIS keeper make this record?* — a record sealed AS a named Kumara identity, tying the identity front door to the signed carry so provenance answers not merely "is this a valid signature from someone" but "did this keeper make it." Authors no new cryptography and adds no new frame — a Kumara carry IS a [`signed_carry.rye`](signed_carry.rye) frame sealed under a [`kumara_identity.rye`](kumara_identity.rye)'s own secret seed; because the carry's signer field is `derive_public(seed)` and the identity's public key is `derive_public(that same seed)`, the sealed frame carries exactly that identity's public key as its signer, asserted equal by construction. The value it adds is the **binding**: `open_as` runs signed_carry's verify-before-trust (magic → length → digest → signature) and then refuses, with `UnexpectedSigner`, any frame whose verified signer is not the identity the reader named — a valid signature from the wrong keeper is caught, never mistaken for the right one; `seal_from_mnemonic` folds phrase → identity → sealed record in one call. Proven three replayable ways with no fabricated constant: bound to a real identity (the frame a keeper derived from BIP-39's own Trezor vector mnemonic seals carries that identity's public key as its signer byte-for-byte, agreeing with an independent `signed_carry.open`); the binding refuses the wrong keeper (a valid carry sealed by a different identity, opened while expecting the first, fails `UnexpectedSigner` while the true keeper still opens it); and the whole arc round-trips across seven payload lengths with determinism and the inherited `DigestMismatch` / `BadSignature` guards. TEST identities only; sealing a real record with the maintainer's own Kumara identity stays the custody gate | Kumara identity · signed carry (BLAKE2b · Ed25519) |

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
fifty-three per-file witnesses in the dependency order above, rebuilding and reproving
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
