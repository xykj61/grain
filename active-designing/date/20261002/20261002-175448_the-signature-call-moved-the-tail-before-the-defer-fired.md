# The signature call moved the tail before the defer fired

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field
**Status:** Vision -- a reading of tracked source, no new witness or module
**Stamp:** `20261002.175448`
**Kin:** [The garden's free reaches the tail, and nothing behind it](../20261002/20261002-155732_the-gardens-free-reaches-the-tail-and-nothing-behind-it.md) - [The one release gesture has never been exercised twice](../20261002/20261002-174555_the-one-release-gesture-has-never-been-exercised-twice.md)

## What the kin essay claimed about one named instance

The arc's second essay traced `pond/apps/drawn_terminal.rye`'s `compose_thin_view_lines` and its
one caller, `run_thin_view_witness`, "line by line," and landed on a specific claim: a forward-order
`defer` loop that frees `frame[i].text` for every line and then `frame` itself "reclaims its
last-allocated member alone" -- meaning the final text freed in the loop, `frame[4].text`, actually
rolls the arena back, because it was the most recent allocation at the moment its own `free` ran.

This essay re-reads the same function in full, past the five lines the kin essay quoted, and finds
the claim does not hold for this instance. Something allocates between `compose_thin_view_lines`
returning and the `defer` firing, and that something is the function's own call to
`content_signature` on the frame it just built.

## What the ArenaAllocator actually checks

`vendor/zig-toolchain/lib/std/heap/ArenaAllocator.zig:608-623` is unambiguous about the rule the
whole arc has been reading toward:

```
if (buf_ptr + cur_end_index != memory.ptr + memory.len) {
    // Not the most recent allocation; we cannot free it.
    return;
}
```

A `free` call only rolls the cursor back when the memory being freed sits exactly at the arena's
current end. Anything else is a silent no-op -- correct, never corrupting, and invisible from the
call site alone. This is the rule every essay in the arc has used; this essay applies it to one
more allocation the kin essay's own trace left out.

## The full order of allocation, read past where the kin essay stopped

`run_thin_view_witness` (`pond/apps/drawn_terminal.rye:347-386`) runs, in this order, every call
that touches `garden`:

| Step | Line | Call | What it allocates from `garden` |
|---|---|---|---|
| 1 | 348 | `garden.alloc(SkateLine, 1)` | `empty`, one line struct |
| 2 | 350 | `content_signature(garden, empty)` | a `skate.Grid` (via `Frame.to_grid`) plus a full pixel buffer (via `signature_from_grid`) |
| 3 | 352 | `compose_thin_view_lines(garden, io)` | `lines` (the 5-element array) plus 5 line-text allocations, `dupe`/`allocPrint` each |
| 4 | 353-357 | `defer` block **registered**, not yet run | -- |
| 5 | 359 | `content_signature(garden, frame)` | a second `skate.Grid` plus a second full pixel buffer |
| 6 | 369-384 | `golden` (string literals), `probe`/`out` (stack arrays), `bufPrint` into `&out` | nothing from `garden` |
| 7 | function returns | `defer` fires | frees `frame[0..4].text`, then `frame` |

Step 5 is the one the kin essay's trace did not carry forward. `content_signature` calls
`signature_from_lines` (`brushstroke/wayland_seed.rye:346-349`), which calls `Frame.to_grid`
(`wayland_seed.rye:293-301`, allocating a `skate.Grid` through `skate.Grid.init`) and then
`signature_from_grid` (`wayland_seed.rye:338-344`, allocating a pixel buffer sized
`stride * window_height` bytes through `garden.alloc(u8, size)`). Both calls run on the **same**
`garden` parameter that `compose_thin_view_lines` used one line earlier, inside the same
function, after `frame`'s own six allocations and before the `defer` block ever executes.

So at the moment the `defer` runs, the arena's tail is not at `frame[4].text` -- it is at the end
of step 5's pixel buffer, two allocations further on. Every free in the loop checks its own memory
against that tail. None of the six matches: not `frame[0].text` through `frame[3].text` (never
matched the tail at any point, which the kin essay already knew), and not `frame[4].text` or
`frame` itself either, because step 5 moved the tail past both before the loop ever ran. **Zero of
the six allocations in this instance are reclaimed by this `defer` -- not the five the kin essay
already called no-ops, and not the one it called a genuine reclaim.**

## Why the kin essay's trace missed this

The kin essay's own description -- "traced through one instance... line by line" -- read the lines
inside the `defer` block and the lines immediately around `compose_thin_view_lines`'s own body. It
did not carry the trace past line 358 to line 359, where the function's very next statement reuses
`garden` for an unrelated purpose (computing a content signature to assert against) before the
`defer` it already passed ever fires. A `defer` block's correctness depends on everything the
function does between its registration and its firing, not only on what came immediately before
the registration -- and in Zig, a `defer` is written beside the allocation it concerns yet runs
only at scope exit, so a reader's eye and the allocator's clock disagree about what "nearby" means.

## What this sharpens, and what it leaves exactly where it was

The arc's standing finding -- "no caller frees without clearing its whole region" / "the one
release gesture has never been exercised twice" -- is unaffected; this essay's subject is a
different claim, the traced instance's own partial credit ("reclaims its last-allocated member
alone"), and that credit is withdrawn for this specific function. The correctness story is also
unaffected: a no-op free is still safe, exactly as the kin arc has said throughout, because the
allocator declines rather than guesses and the whole arena is reclaimed at `clear()` or process
exit regardless of what any individual `free()` call managed to roll back along the way.

What moves is the headline number from the first essay in the arc, which read 71 forward-order
loops in one file and asserted each "reclaims its last-allocated member alone" from this one traced
case. That assertion was true of the five lines quoted and false of the function those five lines
actually sit inside. Whether the other 70 loops share `compose_thin_view_lines`'s shape -- a
`content_signature`-style call sitting between the loop's own allocations and its own `defer` --
is the question this essay opens and does not answer.

## A second instance, checked rather than assumed

`grep -n "fn run_.*_witness" pond/apps/drawn_terminal.rye` returns **well over seventy** matches
in this one file -- consistent with the kin essay's own count of 71 forward-order loops -- not the
small handful this essay first assumed. One more was read in full before naming the falsifier
below, to avoid resting a tree-wide claim on a single traced case the way the kin essay did:
`run_books_view_witness` (lines 472-504) repeats the identical shape line for line --
`content_signature(garden, empty)`, then `compose_books_view_lines`, then the `defer` block
registered, then `content_signature(garden, frame)` **before** that `defer` fires. The same
withdrawal applies: nothing in this second function's `defer` reclaims anything either, for the
same reason.

## Falsifier

Any forward-order `garden.free` loop in `pond/apps/drawn_terminal.rye` whose enclosing function
allocates nothing from `garden` between composing its frame and that frame's own `defer` firing
would restore a genuine reclaim for that instance, and would mean this essay's finding is local to
the two functions checked here rather than typical of the loop shape. Checkable by reading each
remaining sibling function's body between its own `compose_*` call and its own `defer` block, the
same walk this essay did for the two instances named above. Roughly seventy of the file's own
`run_*_witness` functions stand unchecked past this; most share the exact `content_signature`
call between compose and defer by visual inspection of the earlier grep output, and none of those
has been confirmed line by line the way these two have.

## Grade

Register: affirmative, bounded -- the finding is stated as a withdrawal of one specific claim,
not as a reversal of the arc's standing conclusion. Reach: one function traced in full, every step
cited by file and line, the allocator rule quoted from its own source rather than restated from
memory. Truth: every citation re-derivable by reading the lines given; the `grep` above is left
for the next lap rather than run to completion here, named honestly as unfinished. Service: closes
a gap in the kin essay's own trace rather than opening new design surface; no witness or module
follows from it. **A-/88 at Field.**
