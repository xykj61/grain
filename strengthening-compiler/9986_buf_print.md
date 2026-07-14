# Pass 9986 · bufPrint — formatted output stays in the caller buffer

**Corpus:** 18 programs (grew from 17)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.143312`

## What this pass covers

**`std.fmt.bufPrint`** — formats into a caller-owned `[]u8` without allocation. Rishi's value printer, Mantra's weave headers, Skate's selftest line, and rye's multi-file bridge error messages all use it for short, bounded output.

Postcondition at the cold wrapper:

```zig
const result = w.buffered();
assert(result.len <= buf.len);
return result;
```

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..fmt.bufPrint`**

```zig
pub fn bufPrint(buf: []u8, comptime fmt: []const u8, args: anytype) BufPrintError![]u8 {
    var w: Writer = .fixed(buf);
    w.print(fmt, args) catch |err| switch (err) {
        error.WriteFailed => return error.NoSpaceLeft,
    };
    const result = w.buffered();
    // Postcondition: formatted output fits in the caller buffer.
    assert(result.len <= buf.len);
    return result;
}
```

## Width notes

**`std.fmt.bufPrint`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..fmt.bufPrint`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/buf_print_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `bufPrint` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/buf_print_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9986_buf_print.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9986 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..fmt.bufPrint` — [`misc`](../misc)

```zig
pub fn bufPrint(buf: []u8, comptime fmt: []const u8, args: anytype) BufPrintError![]u8 {
    var w: Writer = .fixed(buf);
    w.print(fmt, args) catch |err| switch (err) {
        error.WriteFailed => return error.NoSpaceLeft,
    };
    const result = w.buffered();
    // Postcondition: formatted output fits in the caller buffer.
    assert(result.len <= buf.len);
    return result;
}
```

## What the test asserts

- String interpolation matches expected text
- Integer formatting matches expected text
- Empty format returns length 0
- Single-character format returns length 1 within the buffer
- Result length is always `<=` buffer length (the strengthened postcondition)

## Call graph note

`bufPrint` → `Writer.fixed` → `Writer.print` → `Writer.buffered`. The invariant lands at `bufPrint` so the fixed-buffer writer path stays documented without touching the hot `print` implementation.
