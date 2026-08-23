# Pass 9935 · SHA3 ShakeLike squeeze @memcpy — buffered slice bounds

**Witnesses:** 68 programs (grew from 67)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.204212`

## What this pass covers

**`ShakeLike.squeeze` in `sha3.zig`** — slice bounds on the rate-sized buffer between sponge squeezes. Sits above `keccak_p` (`9936`) on every SHAKE/XOF call.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std.crypto.sha3`**

*see `rye/lib/std` — `crypto.sha3` not auto-located*

## Width notes

**`std.crypto.sha3`** — Authored module or iterator family — width migration lives in Tier A (`992`); std iterator indices remain `usize` until wrapped at our API.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |









## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../../../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../../../context/TAME_STYLE.md), [`10024`](../../../expanding-prompts/date/20260620/20260620-210812_explicit-width-audit.md), [`992`](../../../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std.crypto.sha3`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| `std.crypto.sha3` | — | Live `pub fn` not located — cannot run Tiger/TAME audit | pending |

### Witness `rye/tests/sha3_shake_buffered_memcpy_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `rye/lib/std/crypto/sha3.zig` | `sha3` — Phase 4 `usize` seam policy applied | pending |
| `rye/tests/sha3_shake_buffered_memcpy_test.rye` | witness program | pending |
| `tools/p/parity.rish` | witness registered | pending |
| `external-research/yonder/strengthening-compiler/9935_sha3_shake_buffered_memcpy.md` | pass record + audited surfaces | pending |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | pending |
| `992_strengthening_width_crosswalk.md` | lexicon row 9935 | pending |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../../../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [ ] `std.crypto.sha3` — [`rye/lib/std/crypto/sha3.zig`](../../../rye/lib/std/crypto/sha3.zig)

## Postconditions

- `self.offset <= self.buf.len` on entry and via `defer` on every return path
- Before each `@memcpy`: copy length fits destination; partial drain keeps `self.offset + n <= self.buf.len`
- Tail copy: `out.len <= self.buf.len` before copying from the freshly squeezed block

## What the test asserts

- Split `update` + multi-call `squeeze` matches one-shot `Shake128.hash` for the first 100 bytes
