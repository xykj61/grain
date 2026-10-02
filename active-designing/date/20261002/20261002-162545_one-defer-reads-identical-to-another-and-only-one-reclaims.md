# One defer reads identical to another, and only one reclaims

**Status:** Checkable -- this essay names a reading of tracked source and verifies it by reading
the called function it depends on; no witness, no new module.
**Style:** Gauge at Field
**Lineage:** [`20261002-160924_nine-of-the-179-never-reach-the-arena-at-all.md`](20261002-160924_nine-of-the-179-never-reach-the-arena-at-all.md)
left three confirmed-arena, non-`drawn_terminal.rye`, non-`main.rye` witness files open after
closing the nine `pond/apps/*theme*.rye` sites -- `mantra/src/store_witness.rye`,
`mantra/src/weave_apply_witness.rye`, and `mantra/src/weave_v1_lift_witness.rye` -- and read only
the first closely, finding `altered` abandoned beside `too_big`'s own deferred free. This essay
reads the other two.

## The question

All three files write the same idiom once: allocate, then `defer garden.free(<that allocation>)`.
`store_witness.rye` breaks the idiom by allocating a second time (`too_big`) without ever freeing
the first (`altered`). The other two never allocate a visible second time in the same scope -- so
do their single `defer`s actually reach the tail, or does something else allocate through `garden`
between the `defer` and the return, the way `resolve_theme`'s own theme files never even call the
arena at all?

## What each file's one call site does

**`mantra/src/weave_v1_lift_witness.rye:286-287`**, inside `prove_bound_refused`:

```
const rows = try garden.alloc(weave.V1Row, over);
defer garden.free(rows);
for (rows, 0..) |*row, i| { row.* = .{ .text = "x", .gen = 1, .pos = @intCast(i) }; }
const outcome = weave.Weave.from_v1(garden, rows);
assert(outcome == weave.WeaveError.TooManyLines);
```

The loop at line 288 writes into `rows`'s own memory and allocates nothing. `from_v1` is the one
call standing between the `defer` and the function's return, and the function's own comment says
why it is safe: *"the bound is named before a line is lifted, so a record too large to hold is
refused rather than half-read."* Read in `weave.rye`, `from_v1`'s `TooManyLines` check runs ahead
of every append in the function (not reproduced here; the check is the first live statement in the
body). Nothing allocates through `garden` after `rows` and before the `defer` fires. This is the
clean case: `rows` is still the arena's last allocation when it is freed, and the free rolls it
back for real.

**`mantra/src/weave_apply_witness.rye:271-285`**, inside `prove_insert_refusals`:

```
const flood = try garden.alloc([]const u8, weave.max_weave_lines);
defer garden.free(flood);
for (flood) |*slot| slot.* = "x";
if (w.apply(garden, .{ ..., .inserts = flood, ... })) |_| { unreachable; }
else |err| { assert(err == weave.WeaveError.TooManyLines); }
...
var spent = try planted(garden, &[_][]const u8{"alpha"});
spent.next_pos = weave.max_weave_lines;
if (spent.apply(garden, .{ ..., .inserts = &[_][]const u8{"beta"}, ... })) |_| { unreachable; }
else |err| { assert(err == weave.WeaveError.CounterPastCeiling); }
```

Two calls stand between `flood`'s `defer` and the function's return, not one. `w.apply` with
`flood` as its insert list refuses `TooManyLines` at the same early bound check `from_v1` uses
(`weave.rye:1392-1394`), before any append -- no allocation there. But `spent = try planted(garden,
...)` on the next line calls `planted`, whose own body (`weave_apply_witness.rye:90-100`) runs
`w.apply(garden, .{ .inserts = texts, ... })` with one real text, `"alpha"` -- an insert this
weave's own counter has room for, so this `apply` does not refuse. It appends a line, which grows
`w.lines`, an `ArrayList` holding its storage through `garden`. That append is a real allocation
through the same arena, issued after `flood` and before `flood`'s `defer` fires. `spent.apply`
immediately after refuses `CounterPastCeiling` at the same pre-allocation bound check
(`weave.rye:1406-1408`), so it adds nothing further -- the one live allocation between `flood` and
its free is the single line `planted` appends for `spent`.

So `garden.free(flood)` fires onto an arena whose last allocation is no longer `flood` -- it is
whatever `planted`'s internal append claimed. Under the tail-only reclaim rule the kin essay
already established (`tally/region.rye`, `tally/gardens.rye`, and the vendored
`ArenaAllocator.free` all share it), a free that does not name the current tail is a no-op: nothing
is rolled back, and `flood`'s bytes stay claimed until the whole region clears. The `defer` reads
identical to `weave_v1_lift_witness.rye`'s own -- same shape, same distance from its allocation --
and reclaims nothing.

## Three files, three outcomes

| File | Shape | Outcome |
|---|---|---|
| `store_witness.rye` | two allocations, one `defer` | the un-deferred one (`altered`) is abandoned outright |
| `weave_apply_witness.rye` | one allocation, one `defer`, one intervening call that allocates | the deferred free (`flood`) fires as a no-op |
| `weave_v1_lift_witness.rye` | one allocation, one `defer`, no intervening allocation | the deferred free (`rows`) genuinely reclaims |

Three files writing what looks like the same idiom -- allocate, then `defer free` -- land in three
different relationships to the arena's own tail. The idiom's safety was never visible at the call
site; it depended on what, if anything, the lines between the `defer` and the return went on to
allocate.

## Falsifier, named and checked in the same essay

The claim for `weave_apply_witness.rye` is that `planted`'s call to `w.apply` at line 95 performs a
real append rather than refusing early, which requires the weave it is handed (`weave.Weave.empty()`
at line 94) to have room under both of `apply`'s pre-allocation bound checks for one more line.
Checked: `empty()` starts `next_pos` and `next_run` at zero and `lines.items.len` at zero, so
`0 + 1 > max_weave_lines` and `1 > max_weave_lines - 0` both read false for any `max_weave_lines`
above one -- and `weave.rye` defines it in the thousands. The append proceeds. Finding
`max_weave_lines` at zero or one, or `planted`'s `texts` argument empty in this call site, would
retract the claim that an allocation happens here at all.

**Confidence: high.** Both bound checks are read directly from `weave.rye:1392-1413`, the same
lines `weave_v1_lift_witness.rye`'s own clean case was checked against, and the inputs at this call
site (`max_weave_lines` in the thousands, one non-empty insert) are read from the same file rather
than assumed.

## What this leaves for Mantra

Nothing to build, and nothing wrong to report. No file here produces an incorrect result: the std
allocator's own no-op-on-non-tail behavior is exactly what the kin essay already named as safe, and
a witness proving a refusal path has no stake in whether its own scratch allocation gets reclaimed
before the test process exits and the whole arena goes with it. What this closes is the open
population from the prior essay -- all three confirmed-arena witness files are now read, and each
reads differently, which is itself the finding: the `defer`-right-after-`alloc` idiom looks uniform
at the call site and is not uniform in what it actually reclaims.

No witness, no new module, no Swift file. Graded A-/89 at Field.
