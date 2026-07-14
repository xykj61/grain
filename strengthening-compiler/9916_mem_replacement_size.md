# Pass 9916 · mem.replacementSize — buffer size matches replacement count

**Witnesses:** 87 programs (grew from 86)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.032712`

## What this pass covers

**`std.mem.replacementSize`** — calculate output buffer length for `replace`. Pairs with `mem.replace` (9917) and `startsWith` (9939).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.replacementSize`**

```zig
pub fn replacementSize(comptime T: type, input: []const T, needle: []const T, replacement: []const T) usize {
    // Empty needle will loop forever.
    assert(needle.len > 0);

    var i: usize = 0;
    var size: usize = input.len;
    while (i < input.len) {
        if (startsWith(T, input[i..], needle)) {
            size = size - needle.len + replacement.len;
            i += needle.len;
        } else {
            i += 1;
        }
    }

    // Postcondition: consumed the full input (pairs with replace 9917).
    assert(i == input.len);
    const max_replacement_size_input: u32 = 64;
    if (input.len <= @as(usize, max_replacement_size_input)) {
        var reps: usize = 0;
        var j: usize = 0;
        while (j < input.len) {
            if (startsWith(T, input[j..], needle)) {
                reps += 1;
                j += needle.len;
            } else {
                j += 1;
            }
        }
        const delta = @as(isize, @intCast(replacement.len)) - @as(isize, @intCast(needle.len));
        const expected = @as(usize, @intCast(
            @as(isize, @intCast(input.len)) + @as(isize, @intCast(reps)) * delta,
        ));
        assert(size == expected);
    }

    return size;
}
```

## Width notes

**`std.mem.replacementSize`** — Public signature inherits Zig `usize` for slice lengths and return value — keep at the inherited seam per `992` Phase 4. Named verify bound `max_replacement_size_input: u32 = 64` with comparison at the slice seam.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, return `usize`) | `usize` — Zig seam |
| Named verify bound (`max_replacement_size_input`) | `u32` + `@as(usize, …)` |
| Replacement-count delta math | `isize` bridge for `replacement.len - needle.len` |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std...mem.replacementSize`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| `std...mem.replacementSize` | — | Live `pub fn` not located — cannot run Tiger/TAME audit | pending |

### `std..mem.replacementSize`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| `std..mem.replacementSize` | — | Live `pub fn` not located — cannot run Tiger/TAME audit | pending |

### Witness `rye/tests/mem_replacement_size_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `replacementSize` — Phase 4 `usize` seam policy applied | pending |
| `misc` | `replacementSize` — co-strengthened in this pass | pending |
| `rye/tests/mem_replacement_size_test.rye` | witness program | pending |
| `tools/parity.rish` | witness registered | pending |
| `strengthening-compiler/9916_mem_replacement_size.md` | pass record + audited surfaces | pending |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | pending |
| `992_strengthening_width_crosswalk.md` | lexicon row 9916 | pending |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [ ] `std...mem.replacementSize` — [`misc`](../misc)

```zig
pub fn replacementSize(comptime T: type, input: []const T, needle: []const T, replacement: []const T) usize {
    // Empty needle will loop forever.
    assert(needle.len > 0);

    var i: usize = 0;
    var size: usize = input.len;
    while (i < input.len) {
        if (startsWith(T, input[i..], needle)) {
            size = size - needle.len + replacement.len;
            i += needle.len;
        } else {
            i += 1;
        }
    }

    // Postcondition: consumed the full input (pairs with replace 9917).
    assert(i == input.len);
    const max_replacement_size_input: u32 = 64;
    if (input.len <= @as(usize, max_replacement_size_input)) {
        var reps: usize = 0;
        var j: usize = 0;
        while (j < input.len) {
            if (startsWith(T, input[j..], needle)) {
                reps += 1;
                j += needle.len;
            } else {
                j += 1;
            }
        }
        const delta = @as(isize, @intCast(replacement.len)) - @as(isize, @intCast(needle.len));
        const expected = @as(usize, @intCast(
            @as(isize, @intCast(input.len)) + @as(isize, @intCast(reps)) * delta,
        ));
        assert(size == expected);
    }

    return size;
}
```

- [ ] `std..mem.replacementSize` — [`misc`](../misc)

```zig
pub fn replacementSize(comptime T: type, input: []const T, needle: []const T, replacement: []const T) usize {
    // Empty needle will loop forever.
    assert(needle.len > 0);

    var i: usize = 0;
    var size: usize = input.len;
    while (i < input.len) {
        if (startsWith(T, input[i..], needle)) {
            size = size - needle.len + replacement.len;
            i += needle.len;
        } else {
            i += 1;
        }
    }

    // Postcondition: consumed the full input (pairs with replace 9917).
    assert(i == input.len);
    const max_replacement_size_input: u32 = 64;
    if (input.len <= @as(usize, max_replacement_size_input)) {
        var reps: usize = 0;
        var j: usize = 0;
        while (j < input.len) {
            if (startsWith(T, input[j..], needle)) {
                reps += 1;
                j += needle.len;
            } else {
                j += 1;
            }
        }
        const delta = @as(isize, @intCast(replacement.len)) - @as(isize, @intCast(needle.len));
        const expected = @as(usize, @intCast(
            @as(isize, @intCast(input.len)) + @as(isize, @intCast(reps)) * delta,
        ));
        assert(size == expected);
    }

    return size;
}
```

## Postconditions

Precondition: `needle.len > 0`. After walk, `i == input.len`. When `input.len <= 64`, `size == input.len + reps * (replacement.len - needle.len)` via `isize` delta.

## What the test asserts

- Known sizes from std tests (`base`→`Zig`, empty `code`, empty input)
- Adjacent replacements (`abbba`, `\\n\\n`)
