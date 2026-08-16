# encoding — Rye-native, parity-checked binary-to-text serialization

**Language:** EN · **Voice:** Kyri · **Style:** Radiant · **Status:** Living
**Kin:** [`../crypto/README.md`](../crypto/README.md) — the mathematics that produces the bytes this module renders
**Design read:** [`../active-designing/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md`](../active-designing/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md)
**Clean-room law:** [`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)

The crypto library authors the mathematics that produces bytes — hashes, signatures,
sealed boxes. This module authors the **text those bytes travel in**: the armor a
key, a signature, a content address, or a sealed frame wears when it crosses a channel
that passes only printable characters — a Bron field, a URL, a note pasted between two
hands. Both keep one discipline: authored **from the standard**, calling **no
`std`-provided codec** in the primitive, and proven **byte-for-byte** against a
reference runnable now.

## The rungs

Built in the same measurement-first spirit as `crypto/`: each file authored from its
standard, each proven against a public known-answer *and* Zig's independent `std`
implementation.

| File | What it is | Reference |
|---|---|---|
| [`base64.rye`](base64.rye) | Base64 — standard (padded, `+ /`) and URL-safe (unpadded, `- _`) alphabets, encode and decode | RFC 4648 |
| [`base58.rye`](base58.rye) | Base58 — the Bitcoin alphabet (no `0 O I l`, no `+ /`, no padding) an address, a public key, or a content id wears when a human reads or types it, encode and decode | Bitcoin Core convention |
| [`base58check.rye`](base58check.rye) | Base58Check — a version byte, the payload, and a four-byte double-SHA-256 checksum rendered in Base58, the self-verifying form a real address wears (a mistyped character fails the check). Composition, no new cryptography | Bitcoin convention |
| [`base32.rye`](base32.rye) | Base32 — the case-safe, punctuation-free alphabet (A–Z 2–7) a TOTP secret, an onion address, or a CIDv1 content id wears; five bytes into eight symbols, `=` padding, encode and decode | RFC 4648 |
| [`hex.rye`](hex.rye) | Base16 / hex — two lowercase characters per byte, the plainest form a digest, a key, or a wire frame wears; decode accepts either case. Proven byte-for-byte against Zig's own `std.fmt` hex | RFC 4648 |
| [`bech32.rye`](bech32.rye) | Bech32 · Bech32m — the checksummed form a modern address wears: a human-readable prefix, a `1` separator, the payload in the case-safe 32-symbol alphabet, and a six-symbol BCH checksum that localizes a mistype where Base58Check only detects one. The form segwit outputs, Nostr `npub`/`nsec` keys, and Cosmos-family accounts travel in; `encode_bytes`/`decode_bytes` dress a proven Ed25519 key as an `npub` directly | BIP-173 · BIP-350 |

**Natural next rungs** (named, not yet built): a ratchet migration of the per-file
`to_hex` each crypto witness hand-rolls onto the proven `hex.rye` (its own round,
grepped and repointed), and the lowercase / no-pad Base32 variants (RFC 4648 §6 and
the CIDv1 form) when a surface needs them.

Bech32 carries no `std` codec (Zig ships none), so its parity is proven the way the
standard is trusted: against the BIP-173 and BIP-350 valid checksums (each
round-tripped to itself and cross-refused across the two specs, since they differ
only in the constant a v0 segwit output and a BIP-350 payload are each bound to),
against the canonical BIP-173 segwit example
(`bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4` → witness v0, program
`751e76e8199196d454941c45d1b3a323f1433bd6`), and against a second, independent
table-driven polymod matching the per-bit residue byte-for-byte.

Hex is the one rung with a runnable `std` cross-check — Zig ships `std.fmt`'s hex
codec, so `hex.rye` is proven byte-for-byte against it, the way `base64.rye` is
proven against `std.base64`. Base58 and Base32 carry no `std` codec (Zig ships
none), so each is proven against published known-answers and a second, independent
implementation written inside its own selftest.

Base58 carries no independent `std` codec to check against (Zig ships none), so
its parity is proven the way the standard itself is trusted: against the canonical
Bitcoin Core known-answers *and* a second, independent `u128`-integer
implementation written inside its own selftest — a genuine cross-implementation
check standing in for the missing `std` reference.

## Proving it — witnesses on metal

Each file carries a per-file witness under [`../tools/`](../tools/) named
`encoding_<name>_witness.rish`, which builds `encoding/<name>.rye` fresh to the
gitignored `encoding/bin/` and asserts its `GREEN encoding-<name>` line against the
standard's known-answers and Zig's independent `std` implementation:

```
rishi/bin/rishi run tools/encoding_base64_witness.rish
```

## Honest scope

Purely **local** — no key, no network, no funds, no real device. These primitives
transform bytes to text and back; they hold no secret and make no timing claim. The
cryptography that produces the bytes, and the custody of the keys those bytes may
carry, stays in `crypto/` and behind the maintainer's own hand.

---

*May every key, seal, and content address that travels as text arrive exactly as it
left — and may a hand reading these forms find a door it can read all the way down.*
