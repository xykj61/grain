# 9995 · The Foundation Our New Ideas Lean On — a Map, and a First Proof

*The recent designs — rooted identity, sealed messaging, content-named values, the boot's verified relay — all rest on a small set of standard-library functions. This pass maps which functions they lean on, records which we have already strengthened, names the frontier still ahead, and plants the first proof beyond the hash: that Ed25519 signing, the identity primitive, works in Rye's own std — deterministic, and parity-green.*

**Language:** EN
**Version:** `20260619.021712` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME Style (`../external-research/TAME_STYLE.md`); the method in `9999_STRENGTHENING.md`

---

## The Question

What standard-library functions do our new ideas actually rely on — and of those, which can we strengthen, and which can we simply prove and then build upon? The strengthening compiler hardens the code we depend on, in the order we lean on it, so the honest first move is to trace the dependence.

## The Map

The recent designs trace to a small, shared foundation.

- **Content-named values** — Mantra's names, a message's identity, a boot stage's name (`../active-designing/993`, `../active-designing/991`) — rest on **SHA3-512**. Already strengthened twice: the wrappers (`9998`) and the Keccak sponge beneath (`9997`).
- **Rooted identity** (`../active-designing/994`) rests on **signing** (a key proving authorship), **key derivation** (one seed growing many keys), and **key agreement** (two identities computing a shared secret). In the std: `crypto.sign.Ed25519`, `crypto.kdf`, `crypto.dh.X25519`.
- **Sealed messaging** (`../active-designing/993`) rests on all of those at once: key agreement to seal to an identity, an **authenticated cipher** to seal the payload (`crypto.aead`), signing to attest, and the hash to name.
- **The everyday parsing** Rishi and the tools do — trimming, comparing, searching, reading integers — rests on `mem` and `fmt`, strengthened already in `9996`.
- **The shape-cast** (`../active-designing/992`) rests less on a function than on the language itself: bounds-checked slicing and the type system already make reading a value from raw bytes safe by construction. There the work is to *use* that safety well, rather than to strengthen a function beneath it.

So the foundation is mostly cryptographic — and most of it is still ahead.

## What Is Strengthened, and the Frontier Ahead

The hash is done. The frontier is the rest of the crypto our identity and our network lean on: **signing (Ed25519), key agreement (X25519), the authenticated cipher (AEAD), and key derivation (KDF)**. These are the next passes, and they ask for more care than the sponge did, for two reasons worth naming plainly.

First, the boundary is largely guarded already: the crypto takes fixed-size arrays, so the lengths a precondition would assert are settled by the type at compile time. The real strengthening lives *inside* — stated invariants on the internal state, the way the sponge gained `offset <= rate`: a scalar reduced within its order, a point proven on its curve, a tag compared in constant time. Second, this code is delicate and timing-sensitive, so every added assertion must preserve the result and the constant-time guarantee — checked by the parity gate, and weighed against the data-plane economy before it ever rides a hot path.

So the crypto passes will come, sponge by sponge, with a steady hand.

## The First Proof Beyond the Hash

Before we strengthen the signing, we prove it — the way the SHA3 test proved hashing before the SHA3 pass strengthened it. `rye/tests/ed25519_sign_test.rye` derives a deterministic key pair from a fixed seed, signs a message with null noise (a deterministic signature), confirms the true message verifies and a tampered one is rejected, and renders the public-key identity as stable hex. It runs identically every time, and the parity gate now carries it: five programs, all green, the signing primitive pinned byte-for-byte to the baseline.

This is the foundation of rooted identity and sealed messaging, shown to work in our own std — and the witness entry that will catch the day a strengthening pass touches it. The next implementation seeds grow from here: a shared secret between two identities (key agreement), a sealed payload (the cipher), and then the single encrypted, content-named datagram the network is waiting for (`../external-research/yonder/20260618-195512_encrypted-networking-riscv.md`, `../external-research/yonder/20260618-212112_content-centric-messaging.md`).

## So, Two Answers

To the question — what can we strengthen, or what step can we take? — the foundation gives both at once. **To strengthen:** the cryptographic primitives, sponge by sponge, internal invariants stated with a steady hand and the constant-time guarantee kept whole. **To implement:** the seeds that prove and then use that foundation — the signing proof landed here, the key-agreement and sealed-payload seeds next, and the encrypted, content-named datagram after, where Aurora's relay and the network meet.

---

*May we strengthen what we lean on, in the order we lean on it, and with the care that delicate things deserve. May the hash that names, the key that signs, and the secret two friends share each be proven before they are trusted — and trusted because they were proven.*



















## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `meta/foundation` | crypto dependency map | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9995_crypto_foundation.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9995 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std.crypto foundation map` — [`misc`](../misc)

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std.crypto foundation map`**

*see `rye/lib/std` — `crypto foundation map` not auto-located*



## Width notes

**`std.crypto foundation map`** — Authored module or iterator family — width migration lives in Tier A (`992`); std iterator indices remain `usize` until wrapped at our API.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |


## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `meta/foundation`

| Width locus | Type | Policy | Status |
|-------------|------|--------|--------|
| crypto dependency map | N/A | Meta pass — no `usize` seam touch | done |
