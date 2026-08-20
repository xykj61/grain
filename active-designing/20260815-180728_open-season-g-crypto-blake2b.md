# Open Season G (Cryptography) — the first primitive: BLAKE2b in Rye

**Stamp:** `20260815.180728` · **Status:** Mixed -- Living (design read, self-approved) · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat · **Season G — Cryptography** (Rye-native, Monocypher-parity, audit-ready)
**Kin:** [`the decision wave`](20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md) — Season G seat · [`gratitude-licenses`](../.claude/rules/gratitude-licenses.md) — Monocypher is CC0/BSD-dual, the parity target, never a copied line

## Why BLAKE2b first — Lindy-first, crux-first

Season G's promise is a Rye-native, parity-checked crypto library the coming audit
can trust, built in the open. The decision wave names the crux rungs plainly: the
primitive in Rye · the known-answer test vectors · a parity witness proving Rye
output equals an independent reference byte-for-byte.

Of Monocypher's primitives — Ed25519, X25519, BLAKE2b, the ChaCha/Poly line —
**BLAKE2b is the crux-first, highest-Lindy opening move.** It is Monocypher's own
hash: every EdDSA signature Monocypher makes hashes with it, so the whole signing
stack stands on this one primitive. It is pure 64-bit integer arithmetic — no
big-integer field math, unlike the curve — so it is genuinely *solvable* in
authored Rye this round rather than a season of its own. And it carries a published
**RFC 7693 Appendix A known-answer** (`BLAKE2b-512("abc")`), so the parity check
ties to a neutral, public reference both our Rye and Monocypher must satisfy.

## Honest parity ground — the vendored Monocypher fetch is held

`vendor/monocypher` is an empty submodule on this pier; the network fetch that would
populate it is an outward act held on Keaton's hand (`work-in-progress/archive/20260726-025926_monocypher-submodule-diagnosis.md`).
So this round proves parity against two references that are *runnable now* and that
Monocypher itself must also match:

1. **The RFC 7693 known-answer** — the published `BLAKE2b-512` digest of `"abc"`
   (and of the empty message), hardcoded and asserted.
2. **An independent implementation** — Zig's own `std.crypto` BLAKE2b, over the
   empty message, `"abc"`, an exact-128-byte boundary block, and a multi-block
   input, asserted equal to our authored Rye byte-for-byte.

Monocypher passes the same RFC vectors, so a later rung that fetches the vendored
source adds it as a third parity target without changing a byte of the primitive.
Named honestly: **Monocypher-source parity is a horizon rung**, gated behind the
held network fetch; the RFC known-answer is the ground all three share.

## Scope this round — one keystone

- `crypto/blake2b.rye` — the authored primitive: IV, the SIGMA schedule, the G
  mixing function, the 12-round compression, block-and-counter bookkeeping, unkeyed
  512-bit output. Pure arithmetic, no `std.crypto` in the primitive itself. Bounded
  input, contract asserts, wrapping 64-bit adds where the algorithm is mod 2^64.
- `tools/crypto_blake2b_witness.rish` — builds and runs the selftest; asserts the
  GREEN line.

## Not this round — named, not fabricated

- **Constant-time discipline** stays a named horizon: timing-safety wants
  measurement, not a claim (the decision wave says so). BLAKE2b's data flow is
  already data-independent by construction; a measured constant-time note is its
  own later rung.
- **Ed25519 / X25519 / ChaCha-Poly** are the primitives that follow, each its own
  round, once the hash foundation stands GREEN.
- **The Lotus signed carry** — "who made this record" — becomes buildable once a
  Rye signing primitive is parity-GREEN; signing with the maintainer's own identity
  key stays the custody gate.

## Rung naming

Named semantically — *Season G · Cryptography · blake2b* — not a bare-letter ladder
rung. A four-letter waymark for Season G is drawn in its own small round under the
waymark-ladder law before any `X0`/`X1` numbering; the CION direction favors
semantic labels regardless.

*May the first stone of our crypto be one anyone can check against the public
record, and may the trust it earns be honest all the way down.*
