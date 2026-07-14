# Pass 9928 · mem.span — sentinel slice length matches len

**Witnesses:** 75 programs (grew from 74)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.013412`

## What this pass covers

**`std.mem.span`** — sentinel-terminated pointer to slice. Pairs with `len` (9942) and `sliceTo` (9945).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.span`**

```zig
pub fn span(ptr: anytype) Span(@TypeOf(ptr)) {
    if (@typeInfo(@TypeOf(ptr)) == .optional) {
        if (ptr) |non_null| {
            return span(non_null);
        } else {
            return null;
        }
    }
    const Result = Span(@TypeOf(ptr));
    const l = len(ptr);
    const ptr_info = @typeInfo(Result).pointer;
    if (ptr_info.sentinel()) |s| {
        const result = ptr[0..l :s];
        // Postcondition: span length matches len and closes on the sentinel (pairs with len 9942).
        assert(result.len == l);
        assert(ptr[l] == s);
        return result;
    } else {
        const result = ptr[0..l];
        assert(result.len == l);
        return result;
    }
}
```

## Width notes

**`std.mem.span`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.span`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_span_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `span` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_span_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9928_mem_span.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9928 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.span` — [`misc`](../misc)

```zig
pub fn span(ptr: anytype) Span(@TypeOf(ptr)) {
    if (@typeInfo(@TypeOf(ptr)) == .optional) {
        if (ptr) |non_null| {
            return span(non_null);
        } else {
            return null;
        }
    }
    const Result = Span(@TypeOf(ptr));
    const l = len(ptr);
    const ptr_info = @typeInfo(Result).pointer;
    if (ptr_info.sentinel()) |s| {
        const result = ptr[0..l :s];
        // Postcondition: span length matches len and closes on the sentinel (pairs with len 9942).
        assert(result.len == l);
        assert(ptr[l] == s);
        return result;
    } else {
        const result = ptr[0..l];
        assert(result.len == l);
        return result;
    }
}
```

## Postconditions

Returned slice length equals `len(ptr)`. When the result is sentinel-terminated, the element at that index is the sentinel.

## What the test asserts

- Custom sentinel on `[:3]u16` pointer
- `[*:0]const u8` C string with embedded NUL
- String literal span
- Optional null pointer returns null
