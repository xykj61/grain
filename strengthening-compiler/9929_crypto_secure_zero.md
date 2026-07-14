# Pass 9929 · crypto.secureZero — volatile slice wiped to zero

**Witnesses:** 74 programs (grew from 73)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.013112`

## What this pass covers

**`std.crypto.secureZero`** — volatile `@memset` that compilers cannot elide. Every AEAD decrypt failure path and bcrypt cleanup walks this wipe.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..crypto.secureZero`**

```zig
pub fn secureZero(comptime T: type, s: []volatile T) void {
    const zero = std.mem.zeroes(T);
    @memset(s, zero);
    // Postcondition: every byte of the backing memory is zero (works for any T).
    const byte_len = s.len * @sizeOf(T);
    if (byte_len > 0) {
        const bytes: [*]volatile u8 = @ptrCast(s.ptr);
        var i: usize = 0;
        while (i < byte_len) : (i += 1) {
            assert(bytes[i] == 0);
        }
    }
}
```

## Width notes

**`std.crypto.secureZero`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..crypto.secureZero`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/crypto_secure_zero_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `secureZero` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/crypto_secure_zero_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9929_crypto_secure_zero.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9929 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..crypto.secureZero` — [`misc`](../misc)

```zig
pub fn secureZero(comptime T: type, s: []volatile T) void {
    const zero = std.mem.zeroes(T);
    @memset(s, zero);
    // Postcondition: every byte of the backing memory is zero (works for any T).
    const byte_len = s.len * @sizeOf(T);
    if (byte_len > 0) {
        const bytes: [*]volatile u8 = @ptrCast(s.ptr);
        var i: usize = 0;
        while (i < byte_len) : (i += 1) {
            assert(bytes[i] == 0);
        }
    }
}
```

## Postconditions

After `@memset`:

- Every byte of `s.len * @sizeOf(T)` is zero (read back through volatile `u8` — works for struct state like `Poly1305`)

## What the test asserts

- `u8` and `u32` buffers zeroed completely
- Empty slice is a no-op
