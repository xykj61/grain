# Pass 9984 · readFileAlloc — result respects the stated limit

**Corpus:** 20 programs (grew from 19)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.144112`

## What this pass covers

**`std.Io.Dir.readFileAllocOptions`** (and therefore `readFileAlloc`) — allocates the full file contents. The rye multi-file bridge and Rishi `read-file` lean on this path.

Postcondition at the cold wrapper:

```zig
const max = @intFromEnum(limit);
if (max != std.math.maxInt(usize)) assert(result.len <= max);
return result;
```

`.unlimited` skips the check; every finite limit is enforced at return.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..Io.Dir.readFileAllocOptions`**

```zig
pub fn readFileAllocOptions(
    dir: Dir,
    io: Io,
    /// On Windows, should be encoded as [WTF-8](https://wtf-8.codeberg.page/).
    /// On WASI, should be encoded as valid UTF-8.
    /// On other platforms, an opaque sequence of bytes with no particular encoding.
    sub_path: []const u8,
    /// Used to allocate the result.
    gpa: Allocator,
    /// If reached or exceeded, `error.StreamTooLong` is returned instead.
    limit: Io.Limit,
    comptime alignment: std.mem.Alignment,
    comptime sentinel: ?u8,
) ReadFileAllocError!(if (sentinel) |s| [:s]align(alignment.toByteUnits()) u8 else []align(alignment.toByteUnits()) u8) {
    var file = try dir.openFile(io, sub_path, .{
        // We can take advantage of this on Windows since it doesn't involve any extra syscalls,
        // so we can get error.IsDir during open rather than during the read.
        .allow_directory = if (native_os == .windows) false else true,
    });
    defer file.close(io);
    var file_reader = file.reader(io, &.{});
    const result = file_reader.interface.allocRemainingAlignedSentinel(gpa, limit, alignment, sentinel) catch |err| switch (err) {
        error.ReadFailed => return file_reader.err.?,
        error.OutOfMemory, error.StreamTooLong => |e| return e,
    };
    // Postcondition: a successful read never exceeds the stated limit.
    const max = @intFromEnum(limit);
    if (max != std.math.maxInt(usize)) assert(result.len <= max);
    return result;
}
```

## Width notes

**`std.Io.Dir.readFileAllocOptions`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..Io.Dir.readFileAllocOptions`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/read_file_alloc_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `readFileAllocOptions` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/read_file_alloc_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9984_read_file_alloc.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9984 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..Io.Dir.readFileAllocOptions` — [`misc`](../misc)

```zig
pub fn readFileAllocOptions(
    dir: Dir,
    io: Io,
    /// On Windows, should be encoded as [WTF-8](https://wtf-8.codeberg.page/).
    /// On WASI, should be encoded as valid UTF-8.
    /// On other platforms, an opaque sequence of bytes with no particular encoding.
    sub_path: []const u8,
    /// Used to allocate the result.
    gpa: Allocator,
    /// If reached or exceeded, `error.StreamTooLong` is returned instead.
    limit: Io.Limit,
    comptime alignment: std.mem.Alignment,
    comptime sentinel: ?u8,
) ReadFileAllocError!(if (sentinel) |s| [:s]align(alignment.toByteUnits()) u8 else []align(alignment.toByteUnits()) u8) {
    var file = try dir.openFile(io, sub_path, .{
        // We can take advantage of this on Windows since it doesn't involve any extra syscalls,
        // so we can get error.IsDir during open rather than during the read.
        .allow_directory = if (native_os == .windows) false else true,
    });
    defer file.close(io);
    var file_reader = file.reader(io, &.{});
    const result = file_reader.interface.allocRemainingAlignedSentinel(gpa, limit, alignment, sentinel) catch |err| switch (err) {
        error.ReadFailed => return file_reader.err.?,
        error.OutOfMemory, error.StreamTooLong => |e| return e,
    };
    // Postcondition: a successful read never exceeds the stated limit.
    const max = @intFromEnum(limit);
    if (max != std.math.maxInt(usize)) assert(result.len <= max);
    return result;
}
```

## What the test asserts

- Round-trip read with `.unlimited` matches written content
- Read with `.limited(n)` where `n` exceeds file size still returns full content
- Empty file read with `.unlimited` returns zero-length slice
- Parity holds against baseline std

## Pair with 9985

9985 strengthened `writeStreamingAll` (stdout/file write path); 9984 strengthens the symmetric read-alloc path our bridge and shell use.
