# 9992 · FS Boundary — Asserting at the Door of Every Path Call

*The native system interface (`../active-designing/985`) asks that unsafe OS idioms appear only inside wrapper functions that assert at entry before crossing the boundary. Four functions in `rye/lib/std/Io/Dir.zig` are the door our file I/O walks through: `openFile`, `createFile`, `readFile`, and `writeFile`. This pass places the boundary assertions at each door — path non-empty, path within the OS limit, read buffer non-empty — and confirms the parity gate stays green.*

**Language:** EN
**Version:** `20260619.185212` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME Style (`../external-research/TAME_STYLE.md`); the method in `9999_STRENGTHENING.md`
**Builds on:** `9993_mem_diff_primitives.md`, `../active-designing/yonder/20260619-160312_native-system-interface.md`
**Status:** Applied to `rye/lib/std/Io/Dir.zig` — parity GREEN, 12 witnesses

---

## The Boundary

In Rye 0.16.0, `std.fs` is deprecated and all file system operations live in `std.Io.Dir`. Four functions gate every file operation our code will make:

- **`openFile`** — opens a file relative to a directory handle; the path-relative pattern from the `*at` syscall family
- **`createFile`** — creates or truncates a file relative to a directory handle
- **`readFile`** — opens, reads into a caller-provided buffer, and closes
- **`writeFile`** — creates/truncates, writes all data, and closes; takes a `WriteFileOptions` struct whose `sub_path` field is the path

The `*Absolute` variants already carry `assert(path.isAbsolute(...))` — the style of boundary assertion that was already present. This pass adds the two path-length assertions to the relative-path functions, which were unguarded.

---

## The Four Assertions

### Path non-empty

```zig
assert(sub_path.len > 0); // empty path is always a caller error
```

An empty path string is never a valid file name on any OS. Passing one to the vtable dispatch would reach the kernel with a zero-length argument, producing a silent `ENOENT` or `EINVAL`. The assertion converts that silent late failure into a loud local stop at the exact point the invalid argument was passed.

Applied to: `openFile`, `createFile`, `readFile` (as `file_path`), `writeFile` (as `options.sub_path`).

### Path within the OS limit

```zig
assert(sub_path.len < max_path_bytes); // path fits within the declared OS limit
```

`max_path_bytes` is the platform-specific maximum path length (4096 on Linux, including the null terminator). A path at or beyond this limit cannot be passed to the kernel as a null-terminated C string without overflowing the OS buffer. The assertion catches over-long paths before they reach `openat`/`creat`, where the error would arrive as `ENAMETOOLONG` — a valid yet opaque error return. The assertion is `<`, not `<=`, because `max_path_bytes` includes the null sentinel byte: a path of `max_path_bytes - 1` bytes would just fit; one of `max_path_bytes` would not.

Applied to: `openFile`, `createFile`, `readFile`, `writeFile`.

### Read buffer non-empty

```zig
assert(buffer.len > 0); // a zero-length buffer reads nothing; pass a real buffer
```

Applied only to `readFile`. Passing a zero-length buffer reads zero bytes and returns `buffer[0..0]`, which is technically correct yet almost certainly a mistake. The assertion names this at the door.

---

## Where `writeFile` Sits

`writeFile` calls `createFile`, which already carries the path assertions after this pass. The assertion at `writeFile` itself is intentionally redundant:

```zig
// (createFile below will also assert these; stating them here names the contract
// at the level the caller sees, before any vtable dispatch.)
assert(options.sub_path.len > 0);
assert(options.sub_path.len < max_path_bytes);
var file = try dir.createFile(io, options.sub_path, options.flags);
```

The principle: assert at every public surface the caller sees, not only at the innermost call. A future maintainer who calls `writeFile` directly benefits from the assertion appearing at the function they called, rather than discovering it only if they trace into `createFile`.

---

## The Test Pattern: `pub fn main(init: std.process.Init) !u8`

The `std.Io.Dir` API requires an `Io` handle, which comes from `init.io`. All previous parity tests used `pub fn main() void` (pure computation, no I/O handle needed). This test introduces a second entry-point pattern: `pub fn main(init: std.process.Init) !u8`, which `zig run` supports and which gives access to the full I/O system.

The test writes a known string to `/tmp/rye_fs_boundary_test.txt`, reads it back into a 64-byte buffer, asserts the round-trip matches, opens the file once more via `openFile`, then deletes the temp file via `deleteFile`. All four strengthened functions are exercised with valid arguments, the live assertions run, and neither fires.

---

## Parity Result

```
PARITY    fs_boundary_test.rye
PARITY    mem_diff_test.rye
... (10 prior entries, all PARITY) ...
---
parity gate: 12 matched, 0 diverged across 12 programs
GREEN: Rye's std is behavior-identical to the baseline across the witnesses.
```

Twelve programs, all green. The write-then-read round-trip produced identical output on both stds, confirming the added assertions compile to nothing in the observable behavior and fire only when an invariant is broken.

---

## Files

| File | Why |
|------|-----|
| `rye/lib/std/Io/Dir.zig` | Four functions strengthened: `openFile`, `createFile`, `readFile`, `writeFile` |
| `rye/tests/fs_boundary_test.rye` | Write–read–open round-trip exercising all four functions |
| `tools/parity.sh` | Corpus extended to 12 programs |
| `tools/parity.rish` | Same witness extension |
| `strengthening-compiler/9992_fs_boundary.md` | This record |

---

*May every path that reaches the OS boundary be non-empty and within the declared limit. May the buffer that awaits a file's contents be ready to receive. May the door hold cleanly — a loud stop near the cause, and the room behind it clean.*

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std.fs`**

*see `rye/lib/std` — `fs` not auto-located*

## Width notes

**`std.fs`** — Authored module or iterator family — width migration lives in Tier A (`992`); std iterator indices remain `usize` until wrapped at our API.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |

**`std.Io.Dir`** — Authored module or iterator family — width migration lives in Tier A (`992`); std iterator indices remain `usize` until wrapped at our API.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |









## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std.fs`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| `std.fs` | — | Live `pub fn` not located — cannot run Tiger/TAME audit | pending |

### Witness `rye/tests/fs_boundary_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `fs` — Phase 4 `usize` seam policy applied | pending |
| `rye/tests/fs_boundary_test.rye` | witness program | pending |
| `tools/parity.rish` | witness registered | pending |
| `strengthening-compiler/9992_fs_boundary.md` | pass record + audited surfaces | pending |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | pending |
| `992_strengthening_width_crosswalk.md` | lexicon row 9992 | pending |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [ ] `std.fs` — [`misc`](../misc)
