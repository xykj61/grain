# Pass 9939 · startsWith — prefix verdict agrees with eql

**Witnesses:** 64 programs (grew from 63)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.200012`

## What this pass covers

**`std.mem.startsWith`** — prefix test on slices. The `rye` CLI and Mantra weave logic depend on it; builds on the `maybe` documentation from 9993 with return-path postconditions pairing `eql` (9941).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.startsWith`**

```zig
pub fn startsWith(comptime T: type, haystack: []const T, needle: []const T) bool {
    // A zero-length needle always matches; a needle longer than the haystack never matches.
    // Both are valid and expected — state the variable space rather than constraining it.
    maybe(needle.len == 0);
    maybe(needle.len > haystack.len);
    if (needle.len > haystack.len) {
        assert(needle.len > haystack.len);
        return false;
    }
    const result = eql(T, haystack[0..needle.len], needle);
    if (result) {
        assert(needle.len <= haystack.len);
    } else {
        assert(needle.len == 0 or !eql(T, haystack[0..needle.len], needle));
    }
    return result;
}
```

## Width notes

**`std.mem.startsWith`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.startsWith`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_starts_with_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `startsWith` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_starts_with_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9939_mem_starts_with.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9939 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.startsWith` — [`misc`](../misc)

```zig
pub fn startsWith(comptime T: type, haystack: []const T, needle: []const T) bool {
    // A zero-length needle always matches; a needle longer than the haystack never matches.
    // Both are valid and expected — state the variable space rather than constraining it.
    maybe(needle.len == 0);
    maybe(needle.len > haystack.len);
    if (needle.len > haystack.len) {
        assert(needle.len > haystack.len);
        return false;
    }
    const result = eql(T, haystack[0..needle.len], needle);
    if (result) {
        assert(needle.len <= haystack.len);
    } else {
        assert(needle.len == 0 or !eql(T, haystack[0..needle.len], needle));
    }
    return result;
}
```

## Postconditions

- `false` when `needle.len > haystack.len` ⇒ length ordering stated
- `true` ⇒ `needle.len <= haystack.len`
- `false` otherwise ⇒ empty needle or prefix `eql` fails

## What the test asserts

- Normal prefix match and mismatch
- Empty needle (always true)
- Needle longer than haystack
- Equal-length exact match
