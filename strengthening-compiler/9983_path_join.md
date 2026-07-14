# Pass 9983 · path.join — buffer fully filled, empty components documented

**Corpus:** 21 programs (grew from 20)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.144812`

## What this pass covers

**`std.fs.path.join`** (via `joinSepMaybeZ`) — composes path components with the native separator. Pond policy (`10009`) and future Rishi path helpers lean on this.

At `joinSepMaybeZ` return:

```zig
assert(buf_index == buf.len - @as(usize, @intFromBool(zero)));
```

At `join` cold wrapper — empty components are valid input (skipped, same as `formatJoin`):

```zig
for (paths) |p| std.debug.maybe(p.len == 0);
```

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..fs.path.join`**

```zig
pub fn join(self: Directory, allocator: Allocator, paths: []const []const u8) ![]u8 {
    if (self.path) |p| {
        // TODO clean way to do this with only 1 allocation
        const part2 = try fs.path.join(allocator, paths);
        defer allocator.free(part2);
        return fs.path.join(allocator, &[_][]const u8{ p, part2 });
    } else {
        return fs.path.join(allocator, paths);
    }
}
```

## Width notes

**`std.fs.path.join`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..fs.path.join`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/path_join_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `join` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/path_join_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9983_path_join.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9983 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..fs.path.join` — [`misc`](../misc)

```zig
pub fn join(self: Directory, allocator: Allocator, paths: []const []const u8) ![]u8 {
    if (self.path) |p| {
        // TODO clean way to do this with only 1 allocation
        const part2 = try fs.path.join(allocator, paths);
        defer allocator.free(part2);
        return fs.path.join(allocator, &[_][]const u8{ p, part2 });
    } else {
        return fs.path.join(allocator, paths);
    }
}
```

## What the test asserts

- Multi-component join matches expected POSIX-style path
- Empty middle component skipped
- Adjacent separators merged (`base/` + `file`)
- Single component, zero components, all-empty components
- Parity holds against baseline std

## Pond note

Full “stay within declared root” enforcement belongs in Pond policy code, not in `path.join` itself — join stays parity-identical while stating its buffer invariant.
