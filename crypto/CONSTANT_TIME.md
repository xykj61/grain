# crypto — the constant-time discipline note

**Language:** EN · **Voice:** Kyri · **Style:** Radiant · **Status:** Living
**Season:** G — Cryptography (the Six-Season double-seat)
**Design read:** [`../active-designing/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md`](../active-designing/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md)
**Front door:** [`README.md`](README.md) · **Compressed guide:** [`../docs/CRYPTO.md`](../docs/CRYPTO.md) · **Clean-room law:** [`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)

This note is the crux rung the Season G design named plainly: *"a constant-time
discipline note — timing-safety as a named horizon, since it wants measurement,
not a claim."* Every primitive in this library is proven **correct** and
**byte-for-byte parity-GREEN** against the RFC vectors and Zig's independent
`std.crypto`. Correctness is settled. **Timing-safety is not a settled claim
here — it is a scoped horizon**, and this note draws the scope: which operations
touch a secret, which are data-independent *by construction*, which are
*deliberately variable-time*, and exactly what a future measurement round must
put on metal before any timing claim is earned.

The discipline, in one line: **a timing claim is a measurement, never a boast.**
This document claims no measurement. It names honestly what would have to be
measured, so an auditor reads the same posture the code already carries in its
own comments — gathered once, in one place.

## The three postures a primitive can hold

Every file below sits in exactly one posture toward a secret. The posture is a
property of the *code as written*, verifiable by reading it; it is **not** a
timing measurement.

- **public-only** — the operation reads only public values (a public key, a
  signature, a challenge, a length). Variable-time behavior here leaks nothing
  secret, because there is no secret in the operation. Correct and safe as-is.
- **data-independent by construction** — the operation *does* touch a secret,
  yet its control flow and memory-access pattern are fixed regardless of the
  secret's value: no branch on a secret bit, no table index by a secret, no
  early return on a secret comparison. This is the *design intent* of the
  operation, readable in the code. It is the strongest posture a pure-Rye
  primitive can assert **without** a measurement — and it still awaits one before
  a timing claim is earned, because a compiler may undo by optimization what the
  source wrote branchless.
- **deliberately variable-time** — the operation touches a secret and *does*
  branch on it, knowingly, because correctness and parity were authored first.
  This is **named, not hidden.** It is correct; it is not yet timing-safe; it is
  the sharpest horizon in the library.

## The map — every file, its posture, its citation

| File | Touches a secret? | Posture | Where the code says so |
|---|---|---|---|
| `sha512.rye` · `blake2b.rye` · `sha3.rye` | message data (may be secret) | data-independent by construction — fixed rounds per block; block count follows the public length | fixed-round compression, no secret-driven branch |
| `hmac_sha512.rye` · `hmac_sha256.rye` | the HMAC key | data-independent — the key enters only as block-XOR and hash input | key XOR is unconditional |
| `hkdf_sha512.rye` · `hkdf_sha256.rye` · `argon2.rye` · `pbkdf2_sha256.rye` | the input keying material / password | data-independent — HKDF and PBKDF2 are HMAC calls (PBKDF2 a fixed `c`-deep iterate-and-XOR whose count is a public parameter, not a secret); Argon2's memory addressing is data-independent for the `i`/`id` (indexing) passes it is used through | `argon2.rye` header scope note |
| `chacha20.rye` · `poly1305.rye` | the key / one-time key | data-independent by construction — the ChaCha quarter-round and the Poly1305 limb schedule are fixed arithmetic, no secret branch | fixed arithmetic; no secret-driven control flow |
| `aead.rye` · `xchacha20.rye` | the key; **the tag compare** | data-independent — **the tag verify accumulates the byte difference with OR and tests once at the end, never returning early on the first mismatch** | `aead.rye:126` — the constant-time equality |
| `fe25519.rye` | field elements derived from secret scalars | data-independent by construction — reduction rides in the carry not a branch (`fe25519.rye:81`); the inversion ladder is fixed-shape (`fe25519.rye:243`) | `fe25519.rye:81`, `:243` |
| `x25519.rye` | **the secret scalar** | **data-independent by construction** — the Montgomery ladder runs a fixed count of steps, each a **branchless conditional swap driven through an XOR mask so the memory pattern never depends on the secret bit** | `x25519.rye:67`–`68`, `:17`–`18` |
| `fe_secp256k1.rye` | field elements (public today — no secret scalar flows through it yet) | mixed — the multiply/square arithmetic and the inversion ladder are fixed-shape (`fe_secp256k1.rye` `invert`), **yet the canonical conditional subtract currently branches on the value** (`reduce_canonical`'s `if (take_diff)`); a **named horizon** to make branchless before any secret secp256k1 scalar reaches it (ECDSA signing, a later gated round) | `fe_secp256k1.rye` `reduce_canonical`, `invert` |
| `secp256k1_group.rye` | point coordinates (public today) | public-only — the complete addition and doubling formulas are exception-free fixed-shape arithmetic; ECDSA verification runs them over public points | `secp256k1_group.rye` header |
| `secp256k1_scalarmul.rye` | the scalar (public in verify: u1, u2) | **deliberately variable-time** — the double-and-add **branches on the scalar's bits**; correct and parity-GREEN, run over *public* verify scalars today. A constant-time ladder for a secret scalar (ECDSA signing) is the **named horizon** | `secp256k1_scalarmul.rye:28`, `:65` |
| `secp256k1_scalar.rye` | scalars mod n (public in verify: r, s, z, s⁻¹) | **deliberately variable-time** — reduce's subtraction run and invert's Fermat exponentiation **branch on the value**; correct and parity-GREEN over *public* verification values today. A constant-time scalar field for a secret scalar (ECDSA signing) is the **named horizon** | `secp256k1_scalar.rye` `reduce`, `invert` |
| `ed25519_to_x25519.rye` | a public-key coordinate | public-only — converts a *public* key between curves | header scope note |
| `ed25519_group.rye` · `ed25519_decode.rye` · `ed25519_verify.rye` | public values only | public-only — verify reads `[S]B = R + [k]A`, all public | `ed25519_verify.rye` header |
| `ed25519_scalar.rye` · `ed25519_muladd.rye` | the secret scalar (in signing) | data-independent for the modular reduction; used variable-time by the multiply below | scalar reduction is fixed-shape |
| `ed25519_scalarmul.rye` | **the secret scalar** | **deliberately variable-time** — the double-and-add **branches on the scalar's bits**; correct and parity-GREEN, **not yet timing-safe** | `ed25519_scalarmul.rye:27`, `:67` |
| `ed25519_sign.rye` | **the secret scalar** | **deliberately variable-time** — signing composes the variable-time scalar-mul above; authored for correctness and parity first | `ed25519_sign.rye:28` |
| `signed_carry.rye` | inherits from `ed25519_sign` | **deliberately variable-time** (signing path) | composes `ed25519_sign.rye` |
| `sealed_session.rye` | inherits from `x25519` | data-independent by construction (agreement path) | composes `x25519.rye` |
| `vault_seal.rye` | the password | data-independent (Argon2id + XChaCha20-Poly1305); the derived key is **wiped from the stack after use as best-effort hygiene, not a timing claim** | `vault_seal.rye:159` |

## The two sharp horizons an auditor must weigh

**1. Ed25519 signing is deliberately variable-time.** The signing scalar
multiplication (`ed25519_scalarmul.rye`, reached through `ed25519_sign.rye` and
`signed_carry.rye`) branches on the secret scalar's bits. This is authored
honestly for correctness and byte-for-byte RFC 8032 parity first. A **constant-time
signing ladder** — a fixed-window or Montgomery-style scalar multiply that never
branches on a secret bit — is a named, unbuilt rung. Until it lands, **Ed25519
signing here must not run over a long-lived secret key on a shared or adversarially
co-located host.** The custody gate already forbids signing with the maintainer's
own identity key; this horizon is *why* that gate is the right posture, not only a
policy. Key agreement (X25519) does **not** carry this horizon — its ladder is
branchless by construction.

**2. No timing measurement has been taken.** Every "data-independent by
construction" posture above is read from the *source*, and a compiler is free to
reintroduce a branch, a variable-latency instruction, or a secret-dependent memory
access the source did not write. A real timing claim needs a **measurement round
on metal**: `dudect`-style differential timing over fixed-vs-random secret inputs,
per primitive, on the target hardware, with the built binary — not the source —
under test. That round is booked as a horizon, not run here. Wall-clock timing in
a witness would be noise wearing a proof's clothes, so this library takes none and
claims none.

## What this note does *not* do

- It does **not** assert any primitive is timing-safe. It asserts each primitive's
  *posture* — a property of the code — and books the measurement that would earn a
  timing claim.
- It does **not** weaken any correctness or parity claim. Those are GREEN, re-provable
  by `tools/crypto_suite_witness.rish`, and independent of timing.
- It does **not** hold or touch a real key. Every witness runs over TEST keys and the
  RFC's public vectors. Signing or agreeing with the maintainer's own identity key
  stays the custody gate: the library builds and verifies; it never holds the key.

## The measurement round, when it comes

A future timing round earns the right to soften a posture into a claim by putting,
per secret-touching primitive, a differential-timing witness on metal:

1. Build the primitive's binary (not source) for the target.
2. Feed fixed-secret and random-secret inputs in an interleaved schedule.
3. Measure per-call latency; test for a distinguisher (Welch's *t*, dudect-style).
4. A GREEN timing witness — no distinguisher above the noise floor across enough
   samples — is what converts "data-independent by construction" into a measured
   claim. **A deliberately variable-time primitive cannot pass this**; it must first
   be rewritten branchless. That rewrite is the Ed25519-signing horizon above.

Until that round runs, correctness stands proven and timing stands scoped — which
is the honest state, and the state this note keeps in one readable place.

---

*May every hand that audits this library find its timing posture stated plainly,
its horizons named rather than hidden, and its one variable-time path flagged in
daylight — so the trust it earns is trust it has actually shown.*
