# Pass 9915 · mem.replaceOwned — allocation matches replacement walk

**Witnesses:** 88 programs (grew from 87)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.033412`

## What this pass covers

**`std.mem.replaceOwned`** — allocate output via `replacementSize`, fill with `replace`. Completes the replace trio with `replacementSize` (9916) and `replace` (9917).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.replaceOwned`**

```zig
pub fn replaceOwned(comptime T: type, allocator: Allocator, input: []const T, needle: []const T, replacement: []const T) Allocator.Error![]T {
    const expected_len = replacementSize(T, input, needle, replacement);
    const output = try allocator.alloc(T, expected_len);
    const replacements = replace(T, input, needle, replacement, output);
    // Postcondition: allocation matches replacementSize (pairs with 9916–9917).
    assert(output.len == expected_len);
    const max_replace_owned_input: u32 = 64;
    if (input.len <= @as(usize, max_replace_owned_input)) {
        var slide: usize = 0;
        var i: usize = 0;
        while (slide < input.len) {
            if (startsWith(T, input[slide..], needle)) {
                assert(eql(T, output[i..][0..replacement.len], replacement));
                i += replacement.len;
                slide += needle.len;
            } else {
                assert(output[i] == input[slide]);
                i += 1;
                slide += 1;
            }
        }
        assert(i == expected_len);
        _ = replacements;
    }
    return output;
}
```

## Width notes

**`std.mem.replaceOwned`** — Public signature inherits Zig `usize` for slice lengths via `replacementSize` / `replace`. Named verify bound `max_replace_owned_input: u32 = 64` at the slice seam.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]const T`, alloc length) | `usize` — Zig seam |
| Named verify bound | `u32` + `@as(usize, …)` |
| Allocator length | from `replacementSize` (9916) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.replaceOwned`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |
| `max_replace_owned_input` | `u32` (Tiger explicit) | Named snapshot/verify bound = 64 — design width, not `usize` | done |
| `@as(usize, usize, max_replace_owned_input)` | seam widen | TAME: `usize` only at slice seam — widen `u32` bound for `.len` compare | done |

### Witness `rye/tests/mem_replace_owned_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `replaceOwned` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_replace_owned_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9915_mem_replace_owned.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9915 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.replaceOwned` — [`misc`](../misc)

```zig
pub fn replaceOwned(comptime T: type, allocator: Allocator, input: []const T, needle: []const T, replacement: []const T) Allocator.Error![]T {
    const expected_len = replacementSize(T, input, needle, replacement);
    const output = try allocator.alloc(T, expected_len);
    const replacements = replace(T, input, needle, replacement, output);
    // Postcondition: allocation matches replacementSize (pairs with 9916–9917).
    assert(output.len == expected_len);
    const max_replace_owned_input: u32 = 64;
    if (input.len <= @as(usize, max_replace_owned_input)) {
        var slide: usize = 0;
        var i: usize = 0;
        while (slide < input.len) {
            if (startsWith(T, input[slide..], needle)) {
                assert(eql(T, output[i..][0..replacement.len], replacement));
                i += replacement.len;
                slide += needle.len;
            } else {
                assert(output[i] == input[slide]);
                i += 1;
                slide += 1;
            }
        }
        assert(i == expected_len);
        _ = replacements;
    }
    return output;
}
```

## Postconditions

`output.len == replacementSize(...)`. When `input.len <= 64`, independent verify walk confirms each emitted span in the allocated slice.

## What the test asserts

- `base` → `Zig` replacement with length 29
- ` code` → empty in zen string
