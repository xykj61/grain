# Pass 9925 · mem.asBytes — byte view length matches value size

**Witnesses:** 78 programs (grew from 77)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.021112`

## What this pass covers

**`std.mem.asBytes`** — reinterprets a pointer to one value as its underlying bytes. Pairs with `sliceAsBytes` (9926).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.asBytes`**

```zig
pub fn asBytes(set: *const Set) *const [byte_count]u8 {
                return std.mem.sliceAsBytes(&set.ints)[0..byte_count];
            }
```

## Width notes

**`std.mem.asBytes`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.asBytes`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_as_bytes_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `asBytes` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_as_bytes_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9925_mem_as_bytes.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9925 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.asBytes` — [`misc`](../misc)

```zig
pub fn asBytes(set: *const Set) *const [byte_count]u8 {
                return std.mem.sliceAsBytes(&set.ints)[0..byte_count];
            }
```

## Postconditions

Returned byte slice length equals `@sizeOf(@TypeOf(ptr.*))` (zero for zero-sized types).

## What the test asserts

- `u32` yields four bytes; zeroing bytes clears the word
- Zero-sized type yields zero bytes
- Packed two-byte struct yields two bytes
