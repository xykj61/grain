# encoding -- Rye-native, parity-checked binary-to-text serialization

**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)

**Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Kin:** [`../crypto/README.md`](../crypto/README.md) -- the mathematics that produces the bytes this module renders
**Design read:** [`../active-designing/date/20260815/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md`](../active-designing/date/20260815/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md)
**Clean-room law:** [`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)

The crypto library authors the mathematics that makes bytes -- hashes, signatures,
sealed boxes. This module authors the **text those bytes travel in**. A key, a
signature, a content address, or a sealed frame wears armor to cross a channel that
passes printable characters. A Bron field is such a channel. So is a URL, and so is a
note pasted between two hands.

Both modules keep one discipline. Each primitive is authored **from the standard**, in
Rye alone. Each is proven **byte-for-byte** against a reference you can run today.

## The rungs

Each file is authored from its own standard and proven on metal. The last column names
exactly what each proof stands on.

| File | What it is | Reference | Proven against |
|---|---|---|---|
| [`base64.rye`](base64.rye) | Base64 -- standard (padded, `+ /`) and URL-safe (unpadded, `- _`) alphabets, encode and decode | RFC 4648 | Zig's own `std.base64`, byte-for-byte, plus the RFC's published known-answers |
| [`base58.rye`](base58.rye) | Base58 -- the Bitcoin alphabet (no `0 O I l`, no `+ /`, no padding) an address, a public key, or a content id wears when a human reads or types it, encode and decode | Bitcoin Core convention | the canonical Bitcoin Core known-answers, plus a second, independent `u128`-integer implementation inside its own selftest |
| [`base58check.rye`](base58check.rye) | Base58Check -- a version byte, the payload, and a four-byte double-SHA-256 checksum rendered in Base58, the self-verifying form a real address wears (a mistyped character fails the check). Composition alone; every cryptographic step is `crypto/sha256.rye` and `base58.rye` | Bitcoin convention | the canonical Bitcoin wiki Base58Check worked example, plus a round-trip and a corrupted-character check on every shape |
| [`base32.rye`](base32.rye) | Base32 -- the case-safe, punctuation-free alphabet (A-Z 2-7) a TOTP secret, an onion address, or a CIDv1 content id wears; five bytes into eight symbols, `=` padding, encode and decode | RFC 4648 | published known-answers, plus a second, independent implementation inside its own selftest |
| [`hex.rye`](hex.rye) | Base16 / hex -- two lowercase characters per byte, the plainest form a digest, a key, or a wire frame wears; decode accepts either case | RFC 4648 | Zig's own `std.fmt` hex codec, byte-for-byte |
| [`bech32.rye`](bech32.rye) | Bech32 - Bech32m -- the checksummed form a modern address wears: a human-readable prefix, a `1` separator, the payload in the case-safe 32-symbol alphabet, and a six-symbol BCH checksum that localizes a mistype where Base58Check only detects one. The form segwit outputs, Nostr `npub`/`nsec` keys, and Cosmos-family accounts travel in; `encode_bytes`/`decode_bytes` dress a proven Ed25519 key as an `npub` directly | BIP-173 - BIP-350 | the BIP-173 and BIP-350 valid checksums, each round-tripped to itself and cross-refused across the two specs (they differ only in the constant a v0 segwit output and a BIP-350 payload are each bound to); the canonical BIP-173 segwit example `bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4` -> witness v0, program `751e76e8199196d454941c45d1b3a323f1433bd6`; and a second, table-driven polymod matching the per-bit residue byte-for-byte |
| [`pem.rye`](pem.rye) | PEM -- the labelled armor a key, certificate, or signed carry wears as text: a `-----BEGIN LABEL-----` line, the payload in standard Base64 wrapped at 64 characters a line, and a `-----END LABEL-----` line. The exact form an Ed25519 key or a signature is pasted into a config file, mailed between two hands, or committed beside its code -- the shape `openssl` prints and every TLS stack reads. A composition over `base64.rye`, adding only the framing and the wrap; `decode` refuses `BadLabel` when a block does not claim the requested label | RFC 7468 | a reproducible RFC-4648-anchored known-answer -- the block wrapping "foobar" is exactly `-----BEGIN GRAIN TEST-----` then `Zm9vYmFy` then `-----END GRAIN TEST-----`, since `Zm9vYmFy` is RFC 4648 section10's published Base64 of "foobar" -- plus a second, independent deframer that recovers the same body across a sweep of payload lengths |
| [`rlp.rye`](rlp.rye) | RLP (Recursive Length Prefix) -- the one serialization the whole Ethereum world stands on: every transaction, account, receipt, and trie node is an RLP-encoded byte string or list. Two shapes only -- a byte string and a list of items -- with a canonical minimal encoding decode enforces, so one transaction can never wear two hashes. `encode_bytes`/`encode_list_header` are the exact operation transaction signing performs (encode each field as a string, wrap them in a list); `encode_item`/`decode_bytes`/`decode_list_header` handle the general recursive form. Not binary-to-text but binary-to-binary -- the frame the Ethereum-family primitives in `crypto/` (keccak256, secp256k1 sign/recover, eth_address, eip712) sign over | Ethereum Yellow Paper Appendix B | the Yellow Paper's own published known-answers -- `dog` -> `83646f67`, `[cat,dog]` -> `c88363617483646f67`, the empty string -> `80`, the empty list -> `c0`, `1024` -> `820400`, the set-theoretic three -> `c7c0c1c0c3c0c1c0`, and the 56-byte Lorem long-string form `b838...` -- byte-for-byte, plus a decoder that reads the length prefixes back (a genuinely different algorithm from the encoder that writes them), round-tripping every vector and a nine-field transaction-shaped list to exactly its own bytes |

## How parity is proven

Two rungs have a runnable `std` cross-check, and each leans on it. Hex is proven against
`std.fmt`'s hex codec, and Base64 against `std.base64`, both byte-for-byte. Zig ships a
codec for that pair alone.

The other six earn parity the way the standards themselves are trusted. Each is proven
against published known-answers, and against a second, independent implementation
written inside its own selftest. Two paths that agree on every vector make a genuine
cross-implementation check.

**Named, and waiting to be built:** a ratchet migration of the per-file `to_hex` each
crypto witness hand-rolls onto the proven `hex.rye` -- its own round, grepped and
repointed -- and the lowercase and unpadded Base32 variants (RFC 4648 section6 and the
CIDv1 form) once a surface asks for them.

## Proving it -- witnesses on metal

Each file carries a per-file witness under [`../tools/`](../tools/) named
`encoding_<name>_witness.rish`. The witness builds `encoding/<name>.rye` fresh to the
gitignored `encoding/bin/`, then asserts its `GREEN encoding-<name>` line against the
checks the table names.

```
rishi/bin/rishi run tools/e/encoding_base64_witness.rish
```

## Honest scope

These primitives run purely **local**. They transform bytes to text and back, and that
is the whole of what they do. Keys, the network, funds, and real devices stay outside
this module. Each rung keeps only the bytes its caller hands it, and
each claims correctness rather than any timing property. The cryptography that produces the bytes,
and the custody of the keys those bytes may carry, stays in `crypto/` and behind the
maintainer's own hand.

---

*May every key, seal, and content address that travels as text arrive exactly as it
left -- and may a hand reading these forms find a door it can read all the way down.*
