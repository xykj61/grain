# Pass 9920 · mem.reverseIterator — cursor starts at end, walks in range

**Witnesses:** 83 programs (grew from 82)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.024512`

## What this pass covers

**`mem.reverseIterator`** and **`ReverseIterator.next` / `nextPtr`** — factory and backward iteration. Pairs with `mem.reverse` (9921).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.nextPtr`**

```zig
pub fn nextPtr(it: *Iterator) ?*T {
                const item_ptr = it.peekPtr() orelse return null;
                it.index += 1;
                return item_ptr;
            }
```

**`std.mem.nextPtr`**

```zig
pub fn nextPtr(self: *@This()) ?ElementPointer {
            if (self.index == 0) return null;
            self.index -= 1;
            assert(self.index < self.len);
            return &self.ptr[self.index];
        }
```

## Width notes

**`std.mem.reverse_iterator`** — Authored module or iterator family — width migration lives in Tier A (`992`); std iterator indices remain `usize` until wrapped at our API.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.nextPtr`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.nextPtr`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_reverse_iterator_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `nextPtr` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `nextPtr` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_reverse_iterator_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9920_mem_reverse_iterator.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9920 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.nextPtr` — [`misc`](../misc)

```zig
pub fn nextPtr(it: *Iterator) ?*T {
                const item_ptr = it.peekPtr() orelse return null;
                it.index += 1;
                return item_ptr;
            }
```

- [x] `std.mem.nextPtr` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn nextPtr(self: *@This()) ?ElementPointer {
            if (self.index == 0) return null;
            self.index -= 1;
            assert(self.index < self.len);
            return &self.ptr[self.index];
        }
```

## Postconditions

Factory: `index == len == slice.len`. Each `next` / `nextPtr`: after decrement, `index < len`.

## What the test asserts

- String literal yields `c`, `b`, `a`, then null
- Array pointer `nextPtr` walks `7`, `3`, then null
