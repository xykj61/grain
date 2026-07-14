# Pass 9982 · allocPrint and trimEnd — postconditions on the formatting and trim layer

**Witnesses:** 21 programs (unchanged — `alloc_print_test` from pass 9988)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.150112`

## What this pass covers

Pass 9988 added `rye/tests/alloc_print_test.rye` to the parity witnesses. This pass lands TAME postconditions in the strengthened `std` so the gate exercises assertions at runtime, not only in the test file.

1. **`std.fmt.allocPrint`** — Rishi path conversion (`doReadFile`, `doListDir`, `doWriteFile`), Mantra path construction.

2. **`std.mem.trimEnd`** — Rishi arithmetic parser (`findLastArithAdd`) and line trimming in the interpreter loop.

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
| `strengthening-compiler/9982_alloc_print_trimend_strengthen.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9982 | done |

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

## Postconditions

**allocPrint** (`fmt.zig`):

```zig
const written_len = aw.writer.end;
const result = try aw.toOwnedSlice();
assert(result.len == written_len);
return result;
```

**trimEnd** (`mem.zig`):

```zig
assert(end <= slice.len);
assert(result.len <= slice.len);
```

## Design notes

`allocPrint` captures `writer.end` before `toOwnedSlice` resets the allocating writer. The invariant pairs with `bufPrint`'s `result.len <= buf.len` (pass 9986): fixed-buffer and heap paths both document length discipline at the cold wrapper.

Corpus entry unchanged — parity already runs `alloc_print_test` on both arms via `rye run`.
