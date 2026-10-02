**Style:** Gauge at Field
**Status:** Living -- vision room, no witness, a reading of tracked source confirmed by line-by-line trace
**Room:** vision (context/TWO_ROOMS.md) -- nothing here binds a checkable claim

# The production driver reclaims three of ten

Every essay in this kin arc so far has read a test witness -- `drawn_terminal.rye`, `weave_apply_witness.rye`,
`store_witness.rye`, the `pond/apps/*theme*.rye` family. One essay noted in passing that
`rye/src/main.rye`'s own build driver "carries the identical pattern in production code, as well
as in test witnesses," and left it there. This essay reads that file's own ten `garden.free(` call
sites in full, and finds a distribution the test-witness catalog had yet to show: **three of the
ten genuinely reclaim.**

## The ten sites

`rye/src/main.rye` carries exactly ten `garden.free(` calls, across six functions:

| Line | Function | Shape |
|---|---|---|
| 368, 370 | `build_lock_claim` | two sequential `defer`, LIFO order |
| 717, 721 | `bridge_to_zig` | two per-item loops inside `defer` blocks |
| 1158 | `record_family_evict` | one per-item loop inside a `defer` block |
| 1371 | `hash_library_into` | one per-item loop inside a `defer` block |
| 1553 | `resolve_self_exe` | one `defer`, single value |
| 1637 | `resolve_rye_lib` | one `defer`, single value |
| 1778 | `bridge_rye_tree` | one per-item loop inside a `defer` block |
| 1806 | `bridge_rye_tree` | one direct call, through a scan loop, carrying its own `defer` |

## Two genuine reclaims, paired and in order

`build_lock_claim` (lines 366-411) allocates `staging` then `staged_pid`, and registers their
frees in that same order: `defer garden.free(staging)` first, `defer garden.free(staged_pid)`
second. Zig's `defer` fires in reverse of registration, so at return the *second*-registered free
-- `staged_pid` -- runs first, and every call standing between `staged_pid`'s own birth (line 369)
and that free stays clear of `garden`: `build_lock_stall`, `dir.writeFile`, and `dir.rename` each
take `io` or a stack buffer alone. `staged_pid` is the tail, so the free reclaims it cleanly. With
`staged_pid`'s bytes rolled back, `staging` becomes the tail in turn, and the second defer to fire
-- `garden.free(staging)` -- reclaims it too. **Both frees in this function reclaim, in the order
they run, because each allocation stands alone between its own birth and its own release.**

## A third reclaim, immediate rather than deferred

`bridge_rye_tree`'s embed-file scan (lines 1787-1812) carries a different shape again: inside a
`while` loop over every `@embedFile("...")` match in a source file, line 1799 allocates
`embed_bytes` via `readFileAlloc`, lines 1800-1805 feed it to the hasher, and line 1806 frees it
right there, through a direct call rather than a registered `defer`. The allocation and the free
sit adjacent, with `hasher.update` touching the hash state alone in between, so each loop
iteration's `embed_bytes` reclaims the instant it is spent, ahead of the next iteration's own
`embed_path` or `embed_bytes` claiming the arena's tail. The companion variable `embed_path`,
allocated one step earlier at line 1794, survives the loop uncleared; that is a real difference
between the two near-neighbor allocations, and a separate question from this essay's own, since a
buffer left standing inside an arena that resets whole at process exit carries a cost outside what
a correctness reading can price.

## Seven that stay inert, and two distinct reasons why

The remaining seven sites divide into the kin arc's own established shape, and a sharper one the
test-witness catalog had yet to isolate.

**`record_family_evict` (line 1158) matches the dominant drawn_terminal.rye template exactly.**
A walk fills `records`, a sort runs (`record_older_than`, touching the comparison alone), a delete
loop runs (`dir.deleteFile` through `io`, touching the filesystem alone), and the defer fires with
`garden` exactly as the walk left it. Forward-order freeing over an unchanged tail reclaims only
the last-freed item; every earlier one in the loop is already buried beneath it. One function, one
clean instance of the catalog essay's own population.

**`bridge_to_zig` (lines 717, 721), `hash_library_into` (line 1371), and `bridge_rye_tree`'s
`import_paths` loop (line 1778) carry the pattern a step past that template: every item in each
loop stays inert, the last one included.** In each case, a further call through `garden` lands
after the list's own last item is appended and ahead of that list's defer firing:

- `bridge_to_zig` builds `bridge_zigs` and `staged_rye` through a recursive call to
  `bridge_rye_tree` (line 724), and the two hundred-plus lines that follow -- `receipt_path`,
  the digest read, `standing_key`, the toolchain spawn -- reach `garden` repeatedly before either
  list's defer runs at function exit.
- `hash_library_into` builds `paths` via a directory walk, then loops back over every one of
  those same paths to allocate a fresh `full_path` for each (line 1396) ahead of the content pass
  that follows -- so by the time `paths`'s own defer fires, the arena's tail sits past every
  `full_path` the stat pass ever made.
- `bridge_rye_tree`'s `import_paths` loop builds its list, then recurses into itself once per
  import (line 1838), then allocates `zig_path` (1841) and `bridged_source` (1851) ahead of its
  own defer running -- three further allocations standing between the list's last item and its
  own free.

**`resolve_self_exe` (line 1553) and `resolve_rye_lib` (line 1637) share the flagship
`drawn_terminal.rye` shape precisely.** Both allocate `args` via `toSlice`, then ahead of their
`defer garden.free(args)` firing, both allocate a *second* buffer from the same `args` data --
`garden.dupe(u8, argv0)` in one, `std.fmt.allocPrint(garden, ...)` in the other -- as the value
they are about to return. That second allocation happens during the `return` statement's own
evaluation, which completes ahead of any defer running, so `args` stops being the tail by the time
its own free executes. The exact mechanism the kin essay traced in a UI composition function is
here driving every `rye build` this tree runs.

## What this changes about the arc's own shape

The test-witness catalog read as uniformly inert: 74 of 75 functions in one file, all sharing one
cause, and the genuine-reclaim count across that whole population stood at zero. Reading the one
production file in this arc shows the mechanism carries both directions evenly -- an arena's free
reclaims exactly when a buffer's birth and release stand adjacent, with every intervening call
reaching elsewhere than `garden`, and that condition holds about as often as it misses when a
human writes the call site directly, by hand, right beside the allocation it frees. The three
reclaims found here share that one property: each free sits beside its own allocation, the only
call touching `garden` in that stretch. The seven inert frees share the opposite property: each
sits behind a loop, a recursive call, or a `return` expression that reaches the allocator again
first. Correctness stays intact across both groups -- the std allocator's own tail check declines
rather than guesses, so the seven inert frees stay harmless rather than mistaken, and every case
here runs inside a process whose own exit is the real reset.

## Falsifier

Any of the ten sites can be re-checked by reading the lines between the cited allocation and its
own free (or, for the three loop sites, the lines between the list's last `.append` and its own
defer) for a further call through `garden`. A reclaim claim stands only while such a call stays
absent; an inert claim stands only once one turns up.
