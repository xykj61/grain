# Every module in `crypto/`

**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- **87 modules** stand in this directory on `20260824.095920`, and every one of them has a row below.
**Held to the directory by** [`../tools/cr/crypto_module_roster_witness.rish`](../tools/cr/crypto_module_roster_witness.rish) over [`../tools/fixtures/module_roster_scan.sh`](../tools/fixtures/module_roster_scan.sh), which gates `unrostered`, `phantom`, `duplicate_rows`, and `mismatched_rows` at zero.

This page exists because the front door could not hold it honestly. On `20260824` [`README.md`](README.md) stood at **88,205 bytes** and [`../docs/CRYPTO.md`](../docs/CRYPTO.md) at **68,547**, and both said the library holds **eighty files** while **87** stand here. Seven modules had landed with nobody adding a line, and the seven split two ways. Two are real modules nobody listed -- `sha3_digest.rye`, and `slhdsa_thash.rye` at 21,812 bytes, the whole first rung of the SLH-DSA ladder. Five are seam symlinks, and their gap is quieter: the pages discuss their *targets* under `../encoding/` names, so a reader running `ls crypto/` meets `encoding_bech32.rye` and finds no page saying those are one file. Both kinds have rows here (REDS %191, the fourth firing of the shape first booked as %184).

Each row's sentence comes from that module's own `//!` head comment, so the page says what the code says. For which rung answered which question, and the order they had to arrive in, read [`README.md`](README.md); this page answers *what is here* and stops there.

**Two counts, and why they differ.** Eighty-seven modules stand here. The primitive suite proves **81**, because five of the 87 are seam symlinks whose code lives in `../encoding/` and one is a command-line tool proven elsewhere. Both numbers are computed by [`../tools/cr/crypto_count_guard_witness.rish`](../tools/cr/crypto_count_guard_witness.rish) rather than typed, so neither can drift (REDS %105).

---

## Hashes -- 7

The one-way functions everything above them stands on. Each is authored over its own permutation or compression function, with no call into `std.crypto`.

| Module | What it does |
|---|---|
| [`sha256.rye`](sha256.rye) | SHA-256 authored in pure Rye |
| [`sha512.rye`](sha512.rye) | the second primitive: SHA-512 authored in pure Rye |
| [`sha3.rye`](sha3.rye) | SHA3-256 and SHA3-512 authored in pure Rye over the Keccak-f[1600] permutation |
| [`shake.rye`](shake.rye) | SHAKE128 and SHAKE256, the SHA-3 extendable-output functions, authored in pure Rye as a composition over the GREEN Keccak-f[1600] sponge in crypto/sha3.rye |
| [`blake2b.rye`](blake2b.rye) | the first primitive: BLAKE2b-512 authored in pure Rye |
| [`keccak256.rye`](keccak256.rye) | Keccak-256 authored in pure Rye as a composition over the GREEN Keccak-f[1600] sponge in crypto/sha3.rye |
| [`ripemd160.rye`](ripemd160.rye) | RIPEMD-160 authored in pure Rye |

## Keyed hash and key derivation -- 7

Turning a secret into more secret material, or into a tag that proves who wrote a message. The memory-hard rung is here too, for the case where the secret is a password a person chose.

| Module | What it does |
|---|---|
| [`hmac_sha256.rye`](hmac_sha256.rye) | a keyed-hash rung: HMAC-SHA-256 authored in pure Rye |
| [`hmac_sha512.rye`](hmac_sha512.rye) | a keyed-hash rung: HMAC-SHA-512 authored in pure Rye |
| [`hkdf_sha256.rye`](hkdf_sha256.rye) | a key-derivation rung: HKDF-SHA-256 (RFC 5869) authored in pure Rye |
| [`hkdf_sha512.rye`](hkdf_sha512.rye) | a key-derivation rung: HKDF-SHA-512 (RFC 5869) authored in pure Rye |
| [`pbkdf2_sha256.rye`](pbkdf2_sha256.rye) | a key-derivation rung: PBKDF2-HMAC-SHA-256 (RFC 8018 / RFC 2898) authored in pure Rye |
| [`pbkdf2_sha512.rye`](pbkdf2_sha512.rye) | a key-derivation rung: PBKDF2-HMAC-SHA-512 (RFC 8018 / RFC 2898) authored in pure Rye |
| [`argon2.rye`](argon2.rye) | the memory-hard password rung: Argon2 (RFC 9106) authored in pure Rye, all three modes -- Argon2d (data-dependent), Argon2i (data-independent), and Argon2id (the hybrid) |

## The ChaCha and Poly1305 line -- 4

The stream cipher, the one-time authenticator, and the two authenticated-encryption shapes built from them. This is the line that actually seals a message.

| Module | What it does |
|---|---|
| [`chacha20.rye`](chacha20.rye) | the third primitive: ChaCha20 (IETF, RFC 8439) authored in pure Rye |
| [`poly1305.rye`](poly1305.rye) | the fourth primitive: Poly1305 (RFC 8439) authored in pure Rye |
| [`aead.rye`](aead.rye) | the fifth rung: the ChaCha20-Poly1305 AEAD (RFC 8439 section 2.8) assembled in pure Rye from the two GREEN halves |
| [`xchacha20.rye`](xchacha20.rye) | the seventeenth file: HChaCha20 (the subkey-derivation core) and the XChaCha20-Poly1305 extended-nonce AEAD (draft-irtf-cfrg-xchacha-03), authored in pure Rye |

## The Curve25519 field and the edwards25519 curve -- 9

The arithmetic floor under Ed25519 signing, built one rung at a time: the field, then the group law on it, then scalars, then the two halves of a signature.

| Module | What it does |
|---|---|
| [`fe25519.rye`](fe25519.rye) | the sixth rung: the Curve25519 base field GF(2^255 - 19) authored in pure Rye |
| [`ed25519_group.rye`](ed25519_group.rye) | the seventh rung: the edwards25519 group law authored in pure Rye, composed entirely over the GREEN base field (crypto/fe25519.rye) |
| [`ed25519_scalarmul.rye`](ed25519_scalarmul.rye) | the eighth rung: scalar multiplication on edwards25519 authored in pure Rye, composed entirely over the GREEN group law (crypto/ed25519_group.rye), which itself stands over the GREEN base field (crypto/fe25519.rye) |
| [`ed25519_decode.rye`](ed25519_decode.rye) | the ninth rung: point decompression on edwards25519 authored in pure Rye, composed entirely over the GREEN base field (crypto/fe25519.rye), recovering a full curve point from the 32-byte encoding that the group law's compression produces |
| [`ed25519_scalar.rye`](ed25519_scalar.rye) | the tenth rung: scalar arithmetic modulo the group order L authored in pure Rye |
| [`ed25519_muladd.rye`](ed25519_muladd.rye) | the twelfth rung: scalar multiply-add modulo the group order L authored in pure Rye, the LAST arithmetic piece Ed25519 signing needs |
| [`ed25519_verify.rye`](ed25519_verify.rye) | the eleventh rung: Ed25519 signature VERIFICATION authored in pure Rye, the far side of the Lotus signed carry, Kumara identity, Vault, and Comlink |
| [`ed25519_sign.rye`](ed25519_sign.rye) | the thirteenth rung: Ed25519 SIGNING authored in pure Rye, the near side of the Lotus signed carry |
| [`ed25519_to_x25519.rye`](ed25519_to_x25519.rye) | the birational Edwards<->Montgomery key conversion authored in pure Rye |

## Key agreement and key hiding -- 4

Two parties arriving at a shared secret over an open channel, and the map that makes the public half of such a key look like uniform random bytes to anyone watching.

| Module | What it does |
|---|---|
| [`x25519.rye`](x25519.rye) | the fourteenth rung: X25519 elliptic-curve Diffie-Hellman authored in pure Rye |
| [`x25519_dirty.rye`](x25519_dirty.rye) | the "dirty" X25519 public key, the piece that makes Elligator key-hiding actually uniform. crypto/elligator.rye maps a representative to a curve point and back, yet crypto_elligator_rev only succeeds for about half of all public keys, and a CLEAN X25519 public key always lands in the prime-order subgroup -- so hiding a clean key would leak that structure to an observer who knows the trick |
| [`elligator.rye`](elligator.rye) | Elligator 2 over Curve25519, the map that hides an X25519 public key as a uniformly random 32-byte string and reads it back |
| [`elligator_key_pair.rye`](elligator_key_pair.rye) | the hidden keypair, the composition that closes the Elligator key-hiding arc end to end. crypto/elligator.rye maps a curve point to a uniformly random representative and back, yet only about half of all points are representable; crypto/x25519_dirty.rye produces a public key that ranges over the WHOLE curve so its representative is genuinely indistinguishable from noise |

## The secp256k1 curve -- 8

The Bitcoin and Ethereum curve, with the same floor-first shape as edwards25519: field, scalars, group law, scalar multiplication, then signing, verification, and public-key recovery.

| Module | What it does |
|---|---|
| [`fe_secp256k1.rye`](fe_secp256k1.rye) | the secp256k1 base field GF(2^256 - 2^32 - 977) authored in pure Rye |
| [`secp256k1_scalar.rye`](secp256k1_scalar.rye) | scalar arithmetic modulo the group order n authored in pure Rye |
| [`secp256k1_group.rye`](secp256k1_group.rye) | the secp256k1 group law authored in pure Rye, composed entirely over the GREEN base field (crypto/fe_secp256k1.rye) |
| [`secp256k1_scalarmul.rye`](secp256k1_scalarmul.rye) | scalar multiplication on secp256k1 authored in pure Rye, composed entirely over the GREEN group law (crypto/secp256k1_group.rye), which itself stands over the GREEN base field (crypto/fe_secp256k1.rye) |
| [`secp256k1_ecdsa.rye`](secp256k1_ecdsa.rye) | ECDSA signature VERIFICATION on secp256k1 authored in pure Rye, composed entirely over the GREEN rungs beneath it -- the base field (crypto/fe_secp256k1.rye), the group law (crypto/secp256k1_group.rye), the scalar ladder (crypto/secp256k1_scalarmul.rye), and the scalar field modulo the group order n (crypto/secp256k1_scalar.rye) |
| [`secp256k1_ecdsa_sign.rye`](secp256k1_ecdsa_sign.rye) | ECDSA signature SIGNING on secp256k1 authored in pure Rye, the rung that completes the signature scheme the verifier (crypto/secp256k1_ecdsa.rye) could only check |
| [`secp256k1_ecrecover.rye`](secp256k1_ecrecover.rye) | ECDSA public-key RECOVERY on secp256k1 authored in pure Rye -- the Ethereum `ecrecover` primitive, which reads the SENDER of a signature back out of it |
| [`secp256k1_pubkey.rye`](secp256k1_pubkey.rye) | SEC1 public-key serialization for secp256k1, authored in pure Rye as a COMPOSITION over stones already GREEN in this tree: the public-key derivation d-G (crypto/secp256k1_ecdsa_sign.rye - derive_public), the point decompression that lifts a compressed x back to its y (crypto/secp256k1_ecrecover.rye - decompress), and the base field beneath both |

## Post-quantum key encapsulation -- ML-KEM -- 7

The NIST lattice standard for agreeing a key, FIPS 203, built ring upward. `mlkem_sealed.rye` is the composition that puts it to work as a sealed session.

| Module | What it does |
|---|---|
| [`mlkem_ring.rye`](mlkem_ring.rye) | the ML-KEM base ring, the first rung of the post-quantum arc |
| [`mlkem_encode.rye`](mlkem_encode.rye) | the ML-KEM serialization rung, the second stone of the post-quantum arc |
| [`mlkem_sample.rye`](mlkem_sample.rye) | the ML-KEM sampling rung, the third stone of the post-quantum arc |
| [`mlkem_keygen.rye`](mlkem_keygen.rye) | the ML-KEM key-generation rung, the FOURTH stone of the post-quantum arc and the FIRST with a doubled oracle |
| [`mlkem_encaps.rye`](mlkem_encaps.rye) | the ML-KEM encapsulation rung, the FIFTH stone of the post-quantum arc and the SECOND with a doubled oracle |
| [`mlkem_decaps.rye`](mlkem_decaps.rye) | the ML-KEM decapsulation rung, the SIXTH stone of the post-quantum arc and the rung that closes the KEM round-trip |
| [`mlkem_sealed.rye`](mlkem_sealed.rye) | the POST-QUANTUM sealed session: the ML-KEM sibling of crypto/sealed_session.rye and the confidential door Comlink reaches for once the old elliptic curves fall |

## Post-quantum signatures -- ML-DSA and SLH-DSA -- 8

Two NIST signature standards with different bets. ML-DSA (FIPS 204) rests on lattices; SLH-DSA (FIPS 205) rests on hash functions alone, so it survives a break of the lattice assumption.

| Module | What it does |
|---|---|
| [`mldsa_ring.rye`](mldsa_ring.rye) | the ML-DSA base ring, the first rung of the post-quantum SIGNATURE ladder |
| [`mldsa_encode.rye`](mldsa_encode.rye) | the ML-DSA serialization and rounding rung, the second stone of the post-quantum SIGNATURE ladder |
| [`mldsa_sample.rye`](mldsa_sample.rye) | the ML-DSA sampling rung, the third stone of the post-quantum SIGNATURE ladder |
| [`mldsa_keygen.rye`](mldsa_keygen.rye) | the ML-DSA key-generation rung, the FOURTH stone of the ML-DSA ladder and the first ML-DSA rung carrying a DOUBLED oracle |
| [`mldsa_sign.rye`](mldsa_sign.rye) | the ML-DSA signing rung, the FIFTH stone of the ML-DSA ladder and the crux of the whole ladder |
| [`mldsa_verify.rye`](mldsa_verify.rye) | the ML-DSA verification rung, the SIXTH and final stone of the ML-DSA ladder -- the rung that closes the whole post-quantum arc the pivot doc opened |
| [`mldsa_identity.rye`](mldsa_identity.rye) | the POST-QUANTUM identity FRONT DOOR: the one composition that ties the whole ML-DSA ladder into a single answer -- from a 32-byte seed to a keeper's quantum-resistant signing identity, and the signature it makes |
| [`slhdsa_thash.rye`](slhdsa_thash.rye) | DISC0, the first rung of the SLH-DSA ladder: the ADDRESS structure and the TWEAKABLE HASH FAMILY that every other rung of a hash-based signature is built from |

## Compositions -- sealing, signing, and carrying -- 4

No new cryptography here: proven stones assembled into the shapes an application actually reaches for.

| Module | What it does |
|---|---|
| [`verify.rye`](verify.rye) | constant-time byte-string equality, Monocypher's crypto_verify16/32/64 |
| [`signed_carry.rye`](signed_carry.rye) | the fifteenth rung: the FIRST composition over the GREEN Monocypher-parity primitives |
| [`sealed_session.rye`](sealed_session.rye) | the sixteenth rung: the SECOND composition over the GREEN primitives, and the one Comlink reaches for -- a sealed session carry that lets one keeper send another a confidential message over an open channel |
| [`vault_seal.rye`](vault_seal.rye) | the twenty-first rung: the THIRD composition over the GREEN Monocypher-parity primitives, and the one Vault reaches for -- a password-sealed box that lets a keeper lock a blob behind a remembered password, so the key that opens it need never live on the device |

## Kumara identity -- 9

Grain's own identity arc -- one backup phrase grown into a whole keyed household, with per-record subkeys and signed delegation between them.

| Module | What it does |
|---|---|
| [`kumara_identity.rye`](kumara_identity.rye) | the identity arc's FRONT DOOR: the one composition that ties the whole arc into a single answer -- from a backup phrase to a keeper's Kumara signing identity, and the signature it makes |
| [`kumara_path.rye`](kumara_path.rye) | the identity arc's account-path rung: the ed25519 sibling of crypto/bip44.rye |
| [`kumara_sealed.rye`](kumara_sealed.rye) | a message sealed TO a named Kumara identity, and opened AS that identity |
| [`kumara_carry.rye`](kumara_carry.rye) | the EIGHTEENTH composition: a record sealed AS a named Kumara identity |
| [`kumara_subkey.rye`](kumara_subkey.rye) | the NINETEENTH composition: a per-record subkey, a hardened child of the identity node |
| [`kumara_attestation.rye`](kumara_attestation.rye) | the TWENTIETH composition: the parent->subkey attestation, a signed delegation. crypto/kumara_subkey.rye left one honest boundary as its named next rung: ed25519/SLIP-0010 admits only HARDENED derivation, so a subkey's public key CANNOT be derived from the parent identity's public key alone |
| [`kumara_pq_identity.rye`](kumara_pq_identity.rye) | the POST-QUANTUM identity FRONT DOOR: the one composition that grows a keeper's whole quantum-resistant identity from a single backup phrase |
| [`kumara_pq_sealed.rye`](kumara_pq_sealed.rye) | the POST-QUANTUM sealed-to-identity door: a message sealed TO a named post-quantum identity AND signed BY a named post-quantum identity, so one frame carries both confidentiality and provenance, hardened against the quantum day |
| [`slip10_ed25519.rye`](slip10_ed25519.rye) | the identity arc's HD rung: SLIP-0010 hierarchical-deterministic keys over the ed25519 curve |

## Hybrid identity -- the transition years -- 4

One phrase growing all three key families at once, so a message can be sealed and signed against both the classical and the post-quantum assumption while the world decides which it trusts.

| Module | What it does |
|---|---|
| [`hybrid_identity.rye`](hybrid_identity.rye) | the HYBRID identity: one backup phrase grown into all THREE keys the transition years want -- the classical Ed25519 signing key every Grain module uses today, AND the two lattice keys a post-quantum identity carries (an ML-DSA signing key and an ML-KEM key-agreement key) |
| [`hybrid_sealed.rye`](hybrid_sealed.rye) | the HYBRID sealed-to-identity door: a message sealed TO a hybrid identity so its confidentiality survives a break in EITHER family -- the classical X25519 key agreement Comlink uses today, AND the post-quantum ML-KEM agreement a lattice identity carries |
| [`hybrid_signed_carry.rye`](hybrid_signed_carry.rye) | the HYBRID signed carry: the exact shape of crypto/signed_carry.rye -- a self-describing, content-addressed, signed frame whose payload stays PUBLIC on purpose -- with the single Ed25519 signature replaced by a HYBRID signature (Ed25519 beside ML-DSA, genuine only when BOTH verify) |
| [`hybrid_signed_sealed.rye`](hybrid_signed_sealed.rye) | the HYBRID sealed-AND-signed door: a message sealed TO a hybrid identity AND signed BY a hybrid identity, so one frame carries both CONFIDENTIALITY and PROVENANCE hardened on BOTH families at once -- the classical Ed25519/X25519 world Comlink uses today, AND the post-quantum ML-DSA/ML-KEM world a lattice identity carries |

## Wallet derivation -- the BIP ladder -- 4

The published standards for growing a tree of keys from one phrase, and for writing that phrase down in words a person can copy.

| Module | What it does |
|---|---|
| [`bip32.rye`](bip32.rye) | BIP-32 hierarchical-deterministic keys, authored in pure Rye as a COMPOSITION over stones already GREEN in this tree, authoring NO new cryptography |
| [`bip39_mnemonic.rye`](bip39_mnemonic.rye) | the wallet arc's entropy<->mnemonic rung: BIP-39's OTHER half -- the one the seed rung (crypto/bip39_seed.rye) explicitly left as "its own separate rung" |
| [`bip39_seed.rye`](bip39_seed.rye) | the wallet arc's mnemonic->seed rung: BIP-39's derivation of a 512-bit binary seed from a mnemonic sentence and an optional passphrase |
| [`bip44.rye`](bip44.rye) | the wallet arc's account-path rung: BIP-44's "Multi-Account Hierarchy" |

## Addresses and transactions -- 6

Where a key becomes something you can hand to somebody, and where a transaction becomes the exact bytes a chain will sign.

| Module | What it does |
|---|---|
| [`bitcoin_address.rye`](bitcoin_address.rye) | the Bitcoin address, authored in pure Rye as a composition over three already-GREEN stones -- SHA-256 (crypto/sha256.rye), RIPEMD-160 (crypto/ripemd160.rye), and the two self-verifying encoders (encoding/base58check.rye and encoding/bech32.rye) |
| [`eth_address.rye`](eth_address.rye) | the Ethereum address and its EIP-55 mixed-case checksum, authored in pure Rye as a composition over the GREEN Keccak-256 in crypto/keccak256.rye |
| [`eth_personal_sign.rye`](eth_personal_sign.rye) | the Ethereum EIP-191 personal_sign message digest and its signer recovery, authored in pure Rye as a composition over three already-GREEN rungs -- the Keccak-256 in crypto/keccak256.rye, the ECDSA public-key recovery in crypto/secp256k1_ecrecover.rye, and the address derivation in crypto/eth_address.rye |
| [`eip155_tx.rye`](eip155_tx.rye) | the EIP-155 legacy Ethereum transaction digest, authored in pure Rye as a COMPOSITION over stones already GREEN in this tree: the Recursive Length Prefix serialization (encoding/rlp.rye), the Keccak-256 hash (crypto/keccak256.rye), the secp256k1 public-key recovery (crypto/secp256k1_ecrecover.rye), and the Ethereum address derivation (crypto/eth_address.rye) |
| [`eip1559_tx.rye`](eip1559_tx.rye) | the EIP-1559 typed-transaction (type-2) digest, authored in pure Rye as a COMPOSITION over stones already GREEN in this tree: the Recursive Length Prefix serialization (encoding/rlp.rye), the Keccak-256 hash (crypto/keccak256.rye), the secp256k1 ECDSA signer (crypto/secp256k1_ecdsa_sign.rye -- over a PUBLIC TEST KEY only), the secp256k1 public-key recovery (crypto/secp256k1_ecrecover.rye), and the Ethereum address derivation (crypto/eth_address.rye) |
| [`eip712.rye`](eip712.rye) | the Ethereum EIP-712 typed-structured-data hashing scheme, authored in pure Rye as a composition over the already-GREEN Keccak-256 (crypto/keccak256.rye), the ECDSA public-key recovery (crypto/secp256k1_ecrecover.rye), and the address derivation (crypto/eth_address.rye) |

## Encoding seams -- symlinks into `../encoding/` -- 5

Five of the modules here are symlinks, and they are listed because a reader who runs `ls crypto/` finds them and expects them explained. Rye resolves a nested import relative to the importing file's own directory, so a composition in `crypto/` reaches an `encoding/` module through a link that stands beside it. The code lives in `../encoding/`.

| Module | What it does |
|---|---|
| [`base58.rye`](base58.rye) | Base58 (Bitcoin alphabet) authored in pure Rye |
| [`encoding_base58check.rye`](encoding_base58check.rye) | Base58Check authored in pure Rye as a composition, no new cryptography |
| [`encoding_bech32.rye`](encoding_bech32.rye) | Bech32 (BIP-173) and Bech32m (BIP-350) authored in pure Rye |
| [`encoding_rlp.rye`](encoding_rlp.rye) | Recursive Length Prefix (RLP) authored in pure Rye |
| [`crypto_sha256.rye`](crypto_sha256.rye) | SHA-256 authored in pure Rye |

## Tools -- 1

A command-line program rather than a primitive, standing here because it imports `sha3.rye` by bare name and Rye binds that to this directory. It is proven by [`../tools/s/sha3_file_witness.rish`](../tools/s/sha3_file_witness.rish) against the published FIPS 202 answers rather than by the primitive suite, and that redirect is declared in [`../tools/fixtures/crypto_tool_modules.txt`](../tools/fixtures/crypto_tool_modules.txt).

| Module | What it does |
|---|---|
| [`sha3_digest.rye`](sha3_digest.rye) | the SHA3-256 or SHA3-512 of a file, over this tree's own Keccak |

---

*May every stone here be one a reader can check for themselves.*
