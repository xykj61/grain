# Pass 9953 · mem.order — lexicographic order agrees with equality

**Witnesses:** 50 programs (grew from 49)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.182812`

## What this pass covers

**`std.mem.order`** and **`lessThan`** — lexicographic compare on slices. Backs `SemanticVersion` pre-release ordering and general string sorting.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.order`**

```zig
pub fn order(lhs: Version, rhs: Version) std.math.Order {
    if (lhs.major < rhs.major) return .lt;
    if (lhs.major > rhs.major) return .gt;
    if (lhs.minor < rhs.minor) return .lt;
    if (lhs.minor > rhs.minor) return .gt;
    if (lhs.patch < rhs.patch) return .lt;
    if (lhs.patch > rhs.patch) return .gt;
    if (lhs.pre != null and rhs.pre == null) {
        assert(lhs.major == rhs.major and lhs.minor == rhs.minor and lhs.patch == rhs.patch);
        return .lt;
    }
    if (lhs.pre == null and rhs.pre == null) {
        assert(lhs.major == rhs.major and lhs.minor == rhs.minor and lhs.patch == rhs.patch);
        return .eq;
    }
    if (lhs.pre == null and rhs.pre != null) {
        assert(lhs.major == rhs.major and lhs.minor == rhs.minor and lhs.patch == rhs.patch);
        return .gt;
    }

    // Iterate over pre-release identifiers until a difference is found.
    var lhs_pre_it = std.mem.splitScalar(u8, lhs.pre.?, '.');
    var rhs_pre_it = std.mem.splitScalar(u8, rhs.pre.?, '.');
    while (true) {
        const next_lid = lhs_pre_it.next();
        const next_rid = rhs_pre_it.next();

        // A larger set of pre-release fields has a higher precedence than a smaller set.
        if (next_lid == null and next_rid != null) return .lt;
        if (next_lid == null and next_rid == null) {
            assert(std.mem.eql(u8, lhs.pre.?, rhs.pre.?));
            return .eq;
        }
        if (next_lid != null and next_rid == null) return .gt;

        const lid = next_lid.?; // Left identifier
        const rid = next_rid.?; // Right identifier

        // Attempt to parse identifiers as numbers. Overflows are checked by parse.
        const lnum: ?usize = std.fmt.parseUnsigned(usize, lid, 10) catch |err| switch (err) {
            error.InvalidCharacter => null,
            error.Overflow => unreachable,
        };
        const rnum: ?usize = std.fmt.parseUnsigned(usize, rid, 10) catch |err| switch (err) {
            error.InvalidCharacter => null,
            error.Overflow => unreachable,
        };

        // Numeric identifiers always have lower precedence than non-numeric identifiers.
        if (lnum != null and rnum == null) return .lt;
        if (lnum == null and rnum != null) return .gt;

        // Identifiers consisting of only digits are compared numerically.
        // Identifiers with letters or hyphens are compared lexically in ASCII sort order.
        if (lnum != null and rnum != null) {
            if (lnum.? < rnum.?) return .lt;
            if (lnum.? > rnum.?) return .gt;
        } else {
            const ord = std.mem.order(u8, lid, rid);
            if (ord != .eq) return ord;
        }
    }
}
```

**`std..mem.lessThan`**

```zig
pub fn lessThan(sc: @This(), a_index: usize, b_index: usize) bool {
                    return sc.sub_ctx.lessThan(a_index, b_index);
                }
```

**`std.mem.lessThan`**

```zig
pub fn lessThan(comptime T: type, lhs: []const T, rhs: []const T) bool {
    const ord = order(T, lhs, rhs);
    if (ord == .lt) {
        assert(!eql(T, lhs, rhs));
        return true;
    }
    return false;
}
```

## Width notes

**`std.mem.order`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.order`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.lessThan`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| public signature | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.lessThan`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_order_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `order` — Phase 4 `usize` seam policy applied | done |
| `misc` | `lessThan` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `lessThan` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_order_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9953_mem_order.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9953 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.order` — [`misc`](../misc)

```zig
pub fn order(lhs: Version, rhs: Version) std.math.Order {
    if (lhs.major < rhs.major) return .lt;
    if (lhs.major > rhs.major) return .gt;
    if (lhs.minor < rhs.minor) return .lt;
    if (lhs.minor > rhs.minor) return .gt;
    if (lhs.patch < rhs.patch) return .lt;
    if (lhs.patch > rhs.patch) return .gt;
    if (lhs.pre != null and rhs.pre == null) {
        assert(lhs.major == rhs.major and lhs.minor == rhs.minor and lhs.patch == rhs.patch);
        return .lt;
    }
    if (lhs.pre == null and rhs.pre == null) {
        assert(lhs.major == rhs.major and lhs.minor == rhs.minor and lhs.patch == rhs.patch);
        return .eq;
    }
    if (lhs.pre == null and rhs.pre != null) {
        assert(lhs.major == rhs.major and lhs.minor == rhs.minor and lhs.patch == rhs.patch);
        return .gt;
    }

    // Iterate over pre-release identifiers until a difference is found.
    var lhs_pre_it = std.mem.splitScalar(u8, lhs.pre.?, '.');
    var rhs_pre_it = std.mem.splitScalar(u8, rhs.pre.?, '.');
    while (true) {
        const next_lid = lhs_pre_it.next();
        const next_rid = rhs_pre_it.next();

        // A larger set of pre-release fields has a higher precedence than a smaller set.
        if (next_lid == null and next_rid != null) return .lt;
        if (next_lid == null and next_rid == null) {
            assert(std.mem.eql(u8, lhs.pre.?, rhs.pre.?));
            return .eq;
        }
        if (next_lid != null and next_rid == null) return .gt;

        const lid = next_lid.?; // Left identifier
        const rid = next_rid.?; // Right identifier

        // Attempt to parse identifiers as numbers. Overflows are checked by parse.
        const lnum: ?usize = std.fmt.parseUnsigned(usize, lid, 10) catch |err| switch (err) {
            error.InvalidCharacter => null,
            error.Overflow => unreachable,
        };
        const rnum: ?usize = std.fmt.parseUnsigned(usize, rid, 10) catch |err| switch (err) {
            error.InvalidCharacter => null,
            error.Overflow => unreachable,
        };

        // Numeric identifiers always have lower precedence than non-numeric identifiers.
        if (lnum != null and rnum == null) return .lt;
        if (lnum == null and rnum != null) return .gt;

        // Identifiers consisting of only digits are compared numerically.
        // Identifiers with letters or hyphens are compared lexically in ASCII sort order.
        if (lnum != null and rnum != null) {
            if (lnum.? < rnum.?) return .lt;
            if (lnum.? > rnum.?) return .gt;
        } else {
            const ord = std.mem.order(u8, lid, rid);
            if (ord != .eq) return ord;
        }
    }
}
```

- [x] `std..mem.lessThan` — [`misc`](../misc)

```zig
pub fn lessThan(sc: @This(), a_index: usize, b_index: usize) bool {
                    return sc.sub_ctx.lessThan(a_index, b_index);
                }
```

- [x] `std.mem.lessThan` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn lessThan(comptime T: type, lhs: []const T, rhs: []const T) bool {
    const ord = order(T, lhs, rhs);
    if (ord == .lt) {
        assert(!eql(T, lhs, rhs));
        return true;
    }
    return false;
}
```

## Postconditions

**order** — on every return path:

- `.eq` ⇒ `eql(lhs, rhs)`
- `.lt` / `.gt` ⇒ `!eql(lhs, rhs)`

**lessThan** — when true, slices are not equal.

## What the test asserts

- Less, equal, greater by content and by length prefix
- Shared-pointer sub-slice vs full slice
- `lessThan` mirrors `order == .lt`
