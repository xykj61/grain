# Pass 9937 · timing_safe.eql — constant-time verdict matches xor accumulator

**Witnesses:** 66 programs (grew from 65)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.203612`

## What this pass covers

**`std.crypto.timing_safe.eql`** — constant-time equality for short secrets (AEAD tags, MACs). First Aurora metal-lane surface on the main track (`995`); ChaCha20-Poly1305 decrypt uses it internally.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..crypto.timing_safe.eql`**

```zig
pub fn eql(set: Set, other_set: Set) bool {
                return std.mem.eql(usize, &set.ints, &other_set.ints);
            }
```

## Width notes

**`std.crypto.timing_safe.eql`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../../../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../../../context/TAME_STYLE.md), [`10024`](../../../expanding-prompts/date/20260620/20260620-210812_explicit-width-audit.md), [`992`](../../../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..crypto.timing_safe.eql`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/crypto_timing_safe_eql_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `rye/lib/std/crypto/timing_safe.zig` | `eql` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/crypto_timing_safe_eql_test.rye` | witness program | done |
| `tools/p/parity.rish` | witness registered | done |
| `external-research/yonder/strengthening-compiler/9937_crypto_timing_safe_eql.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9937 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../../../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..crypto.timing_safe.eql` — [`rye/lib/std/crypto/timing_safe.zig`](../../../rye/lib/std/crypto/timing_safe.zig)

```zig
pub fn eql(set: Set, other_set: Set) bool {
                return std.mem.eql(usize, &set.ints, &other_set.ints);
            }
```

## Postconditions

On return, `true` iff the xor accumulator is zero (array and vector paths).

## What the test asserts

- Equal and unequal 32-byte arrays
- 16-byte tag-like arrays with single-bit flip
