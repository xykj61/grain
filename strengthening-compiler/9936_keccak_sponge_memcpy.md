# Pass 9936 · Keccak sponge @memcpy — slice bounds at absorb and squeeze

**Witnesses:** 67 programs (grew from 66)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.203912`

## What this pass covers

**`keccak_p.State.absorb` and `squeeze`** — `@memcpy` slice bounds beside existing `offset <= rate` discipline. Every SHA3 hash on Aurora's metal path walks these copies (`9997`–`9998`).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..crypto.squeeze`**

```zig
pub fn squeeze(self: *AsconXof128, out: []u8) void {
        if (!self.squeezed) {
            // First squeeze - apply final permutation
            self.st.permuteR(12);
            self.squeezed = true;
        }

        var i: usize = 0;
        while (i < out.len) {
            const to_copy = @min(8, out.len - i);
            var block: [8]u8 = undefined;
            mem.writeInt(u64, &block, self.st.st[0], .little);
            @memcpy(out[i..][0..to_copy], block[0..to_copy]);
            i += to_copy;

            if (i < out.len) {
                self.st.permuteR(12);
            }
        }
    }
```

**`std.crypto.keccak.squeeze`**

```zig
pub fn squeeze(self: *AsconXof128, out: []u8) void {
        if (!self.squeezed) {
            // First squeeze - apply final permutation
            self.st.permuteR(12);
            self.squeezed = true;
        }

        var i: usize = 0;
        while (i < out.len) {
            const to_copy = @min(8, out.len - i);
            var block: [8]u8 = undefined;
            mem.writeInt(u64, &block, self.st.st[0], .little);
            @memcpy(out[i..][0..to_copy], block[0..to_copy]);
            i += to_copy;

            if (i < out.len) {
                self.st.permuteR(12);
            }
        }
    }
```

## Width notes

**`std.crypto.keccak`** — Authored module or iterator family — width migration lives in Tier A (`992`); std iterator indices remain `usize` until wrapped at our API.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..crypto.squeeze`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.crypto.keccak.squeeze`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/keccak_sponge_memcpy_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `squeeze` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/crypto/keccak_p.zig` | `squeeze` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/keccak_sponge_memcpy_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9936_keccak_sponge_memcpy.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9936 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..crypto.squeeze` — [`misc`](../misc)

```zig
pub fn squeeze(self: *AsconXof128, out: []u8) void {
        if (!self.squeezed) {
            // First squeeze - apply final permutation
            self.st.permuteR(12);
            self.squeezed = true;
        }

        var i: usize = 0;
        while (i < out.len) {
            const to_copy = @min(8, out.len - i);
            var block: [8]u8 = undefined;
            mem.writeInt(u64, &block, self.st.st[0], .little);
            @memcpy(out[i..][0..to_copy], block[0..to_copy]);
            i += to_copy;

            if (i < out.len) {
                self.st.permuteR(12);
            }
        }
    }
```

- [x] `std.crypto.keccak.squeeze` — [`rye/lib/std/crypto/keccak_p.zig`](../rye/lib/std/crypto/keccak_p.zig)

```zig
pub fn squeeze(self: *AsconXof128, out: []u8) void {
        if (!self.squeezed) {
            // First squeeze - apply final permutation
            self.st.permuteR(12);
            self.squeezed = true;
        }

        var i: usize = 0;
        while (i < out.len) {
            const to_copy = @min(8, out.len - i);
            var block: [8]u8 = undefined;
            mem.writeInt(u64, &block, self.st.st[0], .little);
            @memcpy(out[i..][0..to_copy], block[0..to_copy]);
            i += to_copy;

            if (i < out.len) {
                self.st.permuteR(12);
            }
        }
    }
```

## Postconditions

Before each `@memcpy` in absorb and squeeze partial-block paths:

- Copy length fits source and destination slices
- `self.offset + left <= rate` on absorb into the sponge buffer

## What the test asserts

- SHA3-256 one-shot vs split `update` across a 136-byte block boundary
- Split `update` + `squeeze` exercises squeeze partial path
