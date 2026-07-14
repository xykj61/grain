# Pass 9988 · allocPrint and trimEnd — the path conversion and parsing layer

**Witnesses:** 16 programs (grew from 15)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260619.225712`

## What this pass covers

Two `std` functions our recent code depends on, now exercised in the parity witnesses:

1. **`std.fmt.allocPrint`** — allocates a formatted, sentinel-terminated string. Used in Rishi's file I/O builtins (`doReadFile`, `doListDir`, `doWriteFile`) to convert Rishi string values (non-sentinel `[]const u8`) to OS-boundary-safe `[:0]u8` paths. Also used in Mantra's `Store` methods for path construction.

2. **`std.mem.trimEnd`** — removes trailing characters from a slice. Used in Rishi's arithmetic parser (`findLastArithAdd`) to detect binary operators by checking that the trimmed left side ends with a value token rather than another operator.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..fmt.allocPrint`**

```zig
pub fn allocPrint(gpa: Allocator, comptime fmt: []const u8, args: anytype) Allocator.Error![]u8 {
    var aw = try Writer.Allocating.initCapacity(gpa, fmt.len);
    defer aw.deinit();
    aw.writer.print(fmt, args) catch |err| switch (err) {
        error.WriteFailed => return error.OutOfMemory,
    };
    const written_len = aw.writer.end;
    const result = try aw.toOwnedSlice();
    // Postcondition: owned slice length matches bytes formatted before transfer.
    assert(result.len == written_len);
    return result;
}
```

## Width notes

**`std.fmt.allocPrint`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |

**`std.mem.trimEnd`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..fmt.allocPrint`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/alloc_print_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `allocPrint` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/alloc_print_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9988_alloc_print_trimend.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9988 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..fmt.allocPrint` — [`misc`](../misc)

```zig
pub fn allocPrint(gpa: Allocator, comptime fmt: []const u8, args: anytype) Allocator.Error![]u8 {
    var aw = try Writer.Allocating.initCapacity(gpa, fmt.len);
    defer aw.deinit();
    aw.writer.print(fmt, args) catch |err| switch (err) {
        error.WriteFailed => return error.OutOfMemory,
    };
    const written_len = aw.writer.end;
    const result = try aw.toOwnedSlice();
    // Postcondition: owned slice length matches bytes formatted before transfer.
    assert(result.len == written_len);
    return result;
}
```

## What the test asserts

- `allocPrint` produces output matching the format exactly (string interpolation, integer formatting, identity formatting)
- Output length matches expected values
- `trimEnd` removes only trailing matches, leaves leading characters untouched
- `trimEnd` on an empty string returns empty
- `trimEnd` result length is always <= input length

## Design notes

The test uses `page_allocator` (not `init.garden`) so it compiles identically against both the baseline and Rye's strengthened std — the same pattern `mantra_weave_test` and `tally_gardens_test` keep.
