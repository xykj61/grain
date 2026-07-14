# 9991 — Dir.iterate: name invariants and exhaustion state

**Target:** `rye/lib/std/Io/Dir.zig` — `Iterator.next`
**Parity:** 13/13 GREEN

---

## What we state

`Iterator.next` wraps `Reader.next`. The `Reader` filters `.` and `..` internally — every entry it returns is a real directory entry. That means the two classes of return are well-defined:

- **non-null**: a real entry whose name the OS accepted and stored
- **null**: the directory is exhausted and the reader has settled into `.finished`

Pass 9991 makes both classes explicit with postcondition assertions.

### The strengthened function

```zig
pub fn next(it: *Iterator, io: Io) Error!?Entry {
    it.reader.buffer = &it.reader_buffer;
    const result = try it.reader.next(io);
    // Postcondition: every returned entry has a non-empty name within the OS
    // limit; null means the directory is exhausted and the reader is finished.
    if (result) |entry| {
        assert(entry.name.len > 0);               // every directory entry has a name
        assert(entry.name.len <= max_name_bytes);  // the name fits the OS limit
    } else {
        assert(it.reader.state == .finished);      // null means iteration is complete
    }
    return result;
}
```

### Assertions and their authority

| Assertion | Kind | Authority |
|-----------|------|-----------|
| `entry.name.len > 0` | postcondition | POSIX: `d_name` is never the empty string |
| `entry.name.len <= max_name_bytes` | postcondition | `max_name_bytes` mirrors `NAME_MAX`; the OS already enforced this |
| `it.reader.state == .finished` | postcondition | `Reader.next` settles to `.finished` before returning null |

All three state facts the kernel already enforces — we surface them so callers can read them at a glance and so a future regression in the reader triggers an assertion rather than silent misbehavior.

---

## Parity test

`rye/tests/dir_iterate_test.rye` — `pub fn main(init: std.process.Init) !u8`

Creates `/tmp/rye_dir_iterate_test` with one known file (`rye_seed.txt`), iterates, confirms name invariants hold, confirms the second call returns null and `reader.state == .finished`, then cleans up.

Deterministic by construction: exactly one entry, no ordering uncertainty.

Output (both baseline and Rye std):
```
rye: Dir.iterate assertions confirmed (name invariants, exhaustion state).
```
Exit code: 0.

---

## Corpus after this pass

13 programs. All GREEN.

`dir_iterate_test fs_boundary_test mem_diff_test sha3_256_test sha3_256_boundary_test sha3_512_test sha3_boundary_test version_test call_paths_test ed25519_sign_test x25519_agree_test aead_seal_test sealed_message_test`

---

## Position in the stack

| Pass | Subject |
|------|---------|
| 9999 | Manifesto |
| 9998 | SHA3-512 |
| 9997 | Keccak generic |
| 9996 | SHA3-512 boundary |
| 9995 | Ed25519 + X25519 + AEAD |
| 9994 | SHA3-256 |
| 9993 | mem diff primitives |
| 9992 | std.Io.Dir filesystem boundary |
| **9991** | **Dir.iterate name invariants + exhaustion state** |

The four-pass strengthening frontier (9994–9991) is now complete. Mantra seed may begin.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..Io.Dir.iterate`**

```zig
pub fn iterate(a: Args) Iterator {
    return .init(a);
}
```

## Width notes

**`std.Io.Dir.iterate`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..Io.Dir.iterate`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/dir_iterate_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `iterate` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/dir_iterate_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9991_dir_iterate.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9991 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..Io.Dir.iterate` — [`misc`](../misc)

```zig
pub fn iterate(a: Args) Iterator {
    return .init(a);
}
```
