# Pass 9911 · mem.concat — slice concat fills the allocated buffer

**Witnesses:** 92 programs (grew from 91)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.002412`

## What this pass covers

**`std.mem.concat`**, **`concatWithSentinel`**, and **`concatMaybeSentinel`** — allocate and concatenate slices without a separator. Pairs with `join` (9961); used when buffers abut directly.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std.mem.concatMaybeSentinel`**

```zig
pub fn concatMaybeSentinel(allocator: Allocator, comptime T: type, slices: []const []const T, comptime s: ?T) Allocator.Error![]T {
    // ...
    // Postcondition: buffer size matches computed total; slices packed in order (pairs with join 9961).
    assert(buf.len == total_len);
    assert(buf_index + @as(usize, @intFromBool(s != null)) == total_len);
    const max_concat_check: u32 = 64;
    if (total_len <= @as(usize, max_concat_check)) {
        var off: usize = 0;
        for (slices) |slice| {
            assert(eql(T, buf[off..][0..slice.len], slice));
            off += slice.len;
        }
        if (s) |sentinel| {
            assert(buf[buf.len - 1] == sentinel);
        }
    }
    return buf;
}
```

## Width notes

**`std.mem.concatMaybeSentinel`** — Public signatures inherit Zig `usize` for slice lengths. Snapshot bound `max_concat_check: u32 = 64` at the slice seam.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot bound | `u32` + `@as(usize, …)` |
| Postcondition compare | `eql` per packed slice |

## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.

### `std.mem.concatMaybeSentinel`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only | done |
| `max_concat_check` | `u32` (Tiger explicit) | Named snapshot bound = 64 | done |

### Witness `rye/tests/mem_concat_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — no authored `usize` fields | done |
| witness body | value checks only | `concat` + `concatWithSentinel` paths | done |

## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `rye/lib/std/mem.zig` | `concatMaybeSentinel` — named `u32` bounds; payload verify | done |
| `rye/tests/mem_concat_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9911_mem_concat.md` | pass record + audited surfaces | done |

## Postconditions

`buf.len == total_len`; write cursor plus optional sentinel byte equals total. When `total_len <= 64`, each input slice matches the corresponding buffer prefix byte-for-byte; sentinel byte verified when present.

## What the test asserts

- `concat(u8, {"abc","def","ghi"})` → `"abcdefghi"`
- `concat(u32, …)` with empty middle slice → `{0,1,2,3,4,5}`
- `concatWithSentinel` NUL-terminates `"abcdef"`
- empty `concatWithSentinel` → `[:0]u8` with lone `0`
