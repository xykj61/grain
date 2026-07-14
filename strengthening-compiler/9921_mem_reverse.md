# Pass 9921 · mem.reverse — reversed order matches snapshot

**Witnesses:** 82 programs (grew from 81)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.024012`

## What this pass covers

**`std.mem.reverse`** — in-place order reversal of a slice. Pairs with `reverseIterator` and the mem mutation arc.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.reverse`**

```zig
pub fn reverse(indirect: *?*Node) void {
        if (indirect.* == null) {
            return;
        }
        var current: *Node = indirect.*.?;
        while (current.next) |next| {
            current.next = next.next;
            next.next = indirect.*;
            indirect.* = next;
        }
    }
```

## Width notes

**`std.mem.reverse`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.reverse`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_reverse_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `reverse` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_reverse_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9921_mem_reverse.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9921 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.reverse` — [`misc`](../misc)

```zig
pub fn reverse(indirect: *?*Node) void {
        if (indirect.* == null) {
            return;
        }
        var current: *Node = indirect.*.?;
        while (current.next) |next| {
            current.next = next.next;
            next.next = indirect.*;
            indirect.* = next;
        }
    }
```

## Postconditions

When `items.len <= 64`, after reversal each element's bytes match the mirrored original (`eql(u8, asBytes(...))` — works for any `T` with defined layout, including structs used by `mem.sort`).

## What the test asserts

- `u8` five-element reversal
- `i32` three-element ends swap
