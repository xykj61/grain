# Parity, timing, and the custody gate

**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- moved here word for word from `README.md` on `20260824.095920` when that page split.
**Companions:** [`README.md`](README.md) - [`LADDER.md`](LADDER.md) - [`MODULES.md`](MODULES.md) - [`CONSTANT_TIME.md`](CONSTANT_TIME.md)

Three things an auditor asks about a cryptography library, answered in one place: what our code was
checked against, what we have *not* yet proven, and where the library stops and a hand takes over.

---


- **Constant-time timing-safety** is a named **horizon**, not a claim -- it wants
  measurement on metal, not an assertion. The primitives that touch a secret scalar
  (signing, key agreement) are correct before they are proven timing-safe. The whole
  posture is gathered in one auditor-facing place -- which files touch a secret, which
  are data-independent by construction, and the one path (Ed25519 signing) that is
  **deliberately variable-time** -- in [`CONSTANT_TIME.md`](CONSTANT_TIME.md), the
  Season's constant-time discipline note.
- **Monocypher-source parity** is **landed**: the vendored `vendor/monocypher`
  (CC0/BSD-dual, unmodified) is compiled fresh and diffed byte-for-byte against our
  authored Rye over the published vectors. Seventeen rungs stand GREEN -- **BLAKE2b**,
  **X25519**, **Ed25519**, the **ChaCha20-Poly1305 AEAD**, **Argon2** (all three
  modes), the **XChaCha20-Poly1305 flagship** (Monocypher's `crypto_aead_lock`,
  the 24-byte extended-nonce AEAD Lotus's signed carry, Vault, and Comlink reach for),
  the **Edwards<->Montgomery conversion** (`crypto_eddsa_to_x25519` /
  `crypto_x25519_to_eddsa`, the map that lets one Ed25519 identity key both sign and
  agree -- the one-key story `kumara_sealed.rye` rests on), the **standalone
  Poly1305** authenticator (Monocypher's `crypto_poly1305`, the MAC every Vault,
  Comlink, and Lotus sealed carry rests on -- proven in its own right, not merely
  embedded in the AEAD), the **standalone ChaCha20** stream cipher (Monocypher's
  `crypto_chacha20_ietf`, the keystream the whole ChaCha/Poly line enciphers against
  -- likewise proven in its own right, the stream-cipher counterpart to the Poly1305 rung),
  the **standalone SHA-512** hash (Monocypher's optional `crypto_sha512`, the
  hash Ed25519 signs with and the hash every HMAC-SHA512, HKDF-SHA512, and BIP32
  seed derivation folds through -- proven in its own right rather than only embedded
  in Ed25519 signing, the hash-cipher counterpart to the ChaCha20 and Poly1305 rungs),
  and **HMAC-SHA-512** (Monocypher's optional `crypto_sha512_hmac`, the keyed MAC
  HKDF-SHA512 and BIP32 key derivation are built on -- the keyed-MAC counterpart to
  the standalone SHA-512 hash it rests on, anchored to RFC 4231's published tags),
  and the **standalone HChaCha20** subkey-derivation core (Monocypher's
  `crypto_chacha20_h`, the XChaCha nonce-extension every random-nonce sealed message --
  Vault, Comlink, the Lotus signed carry -- folds a 24-byte nonce through before
  enciphering, proven in its own right rather than only inside the XChaCha20-Poly1305
  flagship, the nonce-extension counterpart to the standalone ChaCha20 and Poly1305
  rungs, anchored to draft-irtf-cfrg-xchacha-03 section2.2.1's published subkey),
  and the **standalone variable-length BLAKE2b** (`crypto_blake2b` at output
  lengths below 64 -- the length-parameterized hash core the first BLAKE2b rung
  never exercised, proving `blake2b.rye`'s `hash_var` at 16/20/28/32/48 bytes, the
  mode Argon2's `blake2b_long` chain and RFC 9106 key derivation lean on, anchored
  by its 64-byte case to RFC 7693's published BLAKE2b-512("abc")),
  and the **keyed BLAKE2b MAC** (Monocypher's `crypto_blake2b_keyed`, the message
  authenticator no one without the key can forge -- proving `blake2b.rye`'s
  `hash_keyed` over six (output-length, key, message) triples under keys of 1..64
  bytes, the mode Grain's per-record authentication and key derivation reach for,
  the keyed-MAC counterpart to the unkeyed BLAKE2b rungs; since RFC 7693 publishes
  only the unkeyed answer, its oracle is three independent implementations agreeing
  byte-for-byte -- our Rye, the vendored Monocypher, and Zig's `std.crypto`),
  and **constant-time equality** (Monocypher's `crypto_verify16/32/64`, the compare
  every MAC, tag, and signature-equality check rests on and the piece the two HMAC
  modules named as an open horizon -- proving `verify.rye`'s verdict against the
  vendored Monocypher over equal, one-bit-differing, and all-differing inputs at all
  three widths, matching Monocypher's 0-for-equal / -1-for-differing contract; its
  correctness oracle beside the parity is Zig's independent `std.crypto.timing_safe.eql`
  across every single-bit difference, the constant-time corner of the Season's
  timing-safety horizon that is correct by structure rather than by measurement),
  and **HKDF-SHA-512** (Monocypher's optional `crypto_sha512_hkdf`, the
  extract-then-expand key-derivation function the sealed session, the per-record
  subkey, and every future vault key ladder fold their shared secret through --
  proving `hkdf_sha512.rye` over RFC 5869's Test Case 1, 2, and 3 input structures
  plus a two-block-crossing request; since RFC 5869 publishes no SHA-512
  known-answer, its oracle is a second real implementation agreeing byte-for-byte,
  with the module independently tying its extract and first expand block back to the
  RFC-4231-anchored HMAC in its own selftest, the key-derivation counterpart to the
  HMAC-SHA-512 rung beneath it),
  and **Elligator 2** (Monocypher's `crypto_elligator_map` / `crypto_elligator_rev`,
  the map that hides an X25519 public key as a uniformly random 32-byte string and
  reads it back -- the obfuscated-handshake primitive -- proving `elligator.rye` over
  sixteen direct representative->u-coordinate answers and sixteen inverse
  point+tweak->representative-or-fail answers, the failures failing together and the
  representatives matching to the byte; the first rung for a primitive Zig's
  `std.crypto` does not ship at all, so the second real implementation agreeing is the
  external anchor, standing beside the round-trip identity and Monocypher's own
  published `elligator_dir`/`elligator_inv` vectors proven in the module's own witness)
  -- each also anchored to its RFC or published known-answer, so the oracle is a real
  second implementation. Parity against Zig's `std.crypto` still holds beside it (save
  Elligator, which Zig does not implement -- there the vendored Monocypher and the
  round-trip identity are the anchor).
- **The keys stay the maintainer's hand.** Every witness runs over **TEST** keys and
  the RFC's public vectors -- no real identity key, no network, no funds, no real
  device. Signing a record, or agreeing a session, with the maintainer's **own**
  identity key stays a **custody gate**: the library builds and verifies; it never
  holds the key.
