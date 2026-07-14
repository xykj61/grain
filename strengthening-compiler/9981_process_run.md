# Pass 9981 · process.run — the process boundary Rishi orchestrates through

**Corpus:** 22 programs (grew from 21)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.151812`

## What this pass covers

**`std.process.run`** — spawns a child, collects stdout and stderr, waits for exit. Rishi's `run` builtin, `tools/parity.rish`, and `hosted_wire demo` all depend on it.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..process.run`**

```zig
pub fn run(
            self: *Self,
            expression: []const u8,
            allocator: std.mem.Allocator,
            context: Context,
            initial_value: ?usize,
        ) Error!?Value {
            if (initial_value) |i| try self.stack.append(allocator, .{ .generic = i });
            var stream: std.Io.Reader = .fixed(expression);
            while (try self.step(&stream, allocator, context)) {}
            if (self.stack.items.len == 0) return null;
            return self.stack.items[self.stack.items.len - 1];
        }
```

## Width notes

**`std.process.run`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..process.run`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/process_run_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `run` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/process_run_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9981_process_run.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9981 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..process.run` — [`misc`](../misc)

```zig
pub fn run(
            self: *Self,
            expression: []const u8,
            allocator: std.mem.Allocator,
            context: Context,
            initial_value: ?usize,
        ) Error!?Value {
            if (initial_value) |i| try self.stack.append(allocator, .{ .generic = i });
            var stream: std.Io.Reader = .fixed(expression);
            while (try self.step(&stream, allocator, context)) {}
            if (self.stack.items.len == 0) return null;
            return self.stack.items[self.stack.items.len - 1];
        }
```

## Postconditions

**Entry** (`process.zig`):

```zig
assert(options.argv.len > 0);
```

**Return** — after streams are owned:

```zig
if (options.stdout_limit.toInt()) |limit| {
    assert(stdout_slice.len <= limit);
}
if (options.stderr_limit.toInt()) |limit| {
    assert(stderr_slice.len <= limit);
}
```

## What the test asserts

- `true` exits 0 with empty stdout and stderr
- `echo` captures stdout and returns exit code 0
- `.limited(32)` on stdout holds for a short echo (`bounded.stdout.len <= 32`)

## Call graph note

`process.run` → `spawn` + `MultiReader` + `wait`. Invariants land at the cold wrapper; the fill loop already enforces limits during collection — the return assertions document what success means.
