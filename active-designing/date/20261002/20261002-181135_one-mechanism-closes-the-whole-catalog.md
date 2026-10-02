**Style:** Gauge at Field
**Status:** Living -- vision room, no witness, a reading of tracked source confirmed by a script
**Room:** vision (context/TWO_ROOMS.md) -- nothing here binds a checkable claim

# One mechanism closes the whole catalog

The kin arc's prior essay
([`20261002-175448_the-signature-call-moved-the-tail-before-the-defer-fired.md`](20261002-175448_the-signature-call-moved-the-tail-before-the-defer-fired.md))
traced two of `pond/apps/drawn_terminal.rye`'s `run_*_witness` functions by hand and found both
share one shape: `content_signature(garden, frame)` allocates a `skate.Grid` through `garden`
*after* `frame` is composed and *before* the function's registered `defer garden.free(frame[i].text)`
loop actually fires at return, so the arena's tail has already moved past `frame`'s own bytes by
the time the free runs, and `ArenaAllocator.free`'s own tail check
(`vendor/zig-toolchain/lib/std/heap/ArenaAllocator.zig:608-623`) declines to reclaim anything. The
essay left roughly seventy more instances of the file's own `run_*_witness` functions unchecked.

This essay closes that count by script rather than by a third hand-trace, and finds the open
population is smaller and the mechanism wider than either prior reading assumed.

## The count

`pond/apps/drawn_terminal.rye` declares exactly **75** functions matching
`fn run_*_witness(garden: std.mem.Allocator, ...)`. A script locating, inside each function's own
body, the line composing a frame (`= try compose_\w+\(`), the line registering the per-member free
loop or single free (`while (i < frame.len)` or an equivalent `defer garden.free(...)`), and every
call to `surface.content_signature(garden, <var>)`, finds:

| Reading | Count |
|---|---|
| Total `run_*_witness` functions | 75 |
| Match the `frame[].text` loop-free template, `content_signature(garden, frame)` registered after the free loop and before return | 71 |
| Use a different template (single-slice free, not a `frame[].text` loop) | 4 |
| Of those 4, genuinely touch `garden` at all | 3 |
| Of those 4, discard `garden` entirely (`_ = garden;`) | 1 (`run_rw5_collaboration_witness`) |

**74 of 75 use the allocator; all 74 share the identical root cause.** The one exception,
`run_rw5_collaboration_witness`, tests `lantern_compat.complete_fixture` against four fixture
files read with `std.Io.Dir.cwd().readFile` into a stack buffer, allocating only on the stack, so
it stands outside this population by construction rather than by a differently-shaped free.

## The three that the narrow template missed, read by hand

The script's regex looked for the variable name `frame` and the `while (i < frame.len)` loop
shape the first 71 share. Three functions -- `run_session_witness`, `run_rw2_collaboration_witness`,
`run_keyboard_witness` -- compose a differently-named slice (`frame_lines`, `mid_lines`,
`typing_lines`) and free it with a single `defer garden.free(<name>)` rather than a per-member
loop, so the regex passed over them as a shape it had never been told to look for. Read directly:

**`run_rw2_collaboration_witness`** (`pond/apps/drawn_terminal.rye:5324-5363`) registers three
`defer garden.free(...)` calls at function scope -- `frame_one`, `empty_lines`, `frame_after_bad`
-- and calls `content_signature(garden, frame_one)` **three separate times** after `frame_one`'s
own defer is registered, the last of them (`sig_before_bad`) coming after two more composed
frames have each allocated their own `content_signature` buffer in between. By the time any of the
three defers fire, at function return, the tail sits past all three frames and both intervening
signature calls. Every free in this function fails the same tail check, over a wider gap between
allocation and free than any of the 71.

**`run_keyboard_witness`** (`pond/apps/drawn_terminal.rye:5482-5543`) registers `defer
garden.free(mid_lines)` then calls `content_signature(garden, mid_lines)` on the next line, then
composes and defers `typing_lines` the same way, then a third `frame_lines`. Same shape, three
times over, same conclusion.

**`run_session_witness`** (`pond/apps/drawn_terminal.rye:5256-5321`) is the one genuinely new
control-flow shape in the file: its first `defer garden.free(frame_lines)` sits inside a `for
(script, 0..) |line, idx|` loop body, so it fires **once per iteration** rather than once at
function exit -- three times across the loop's three passes. Zig's `defer` resolves to the end of
its own enclosing block, and a loop body is a block, so the witness follows the language's own
rule correctly. Within one iteration, `content_signature(garden, frame_lines)` runs between the
composition and the loop's own end, so the tail still moves past `frame_lines` before that
iteration's defer fires -- the same mechanism, now proven to survive a change in **where** the
defer's governing scope ends, as well as a change in **how far away** the intervening allocation
sits.

## What this changes about the open population

The kin essay's own count, "roughly seventy ... stand unchecked," is now exact and closed: **74 of
75 confirmed, by two different reading methods converging on one cause, and 1 outside the
population by construction.** Every instance checked -- the scripted 71 and the hand-read 3 alike
-- declines to reclaim. The mechanism generalizes past the specific shape the prior essay traced
(a per-member loop at function scope) to a single-slice free at function scope and to a free
scoped to a loop iteration -- three distinct control-flow shapes, one arithmetic cause: any
allocation through the same arena between a value's own creation and the defer that frees it moves
the tail past that value, and the std allocator's own tail check -- quoted by the prior essay
rather than restated -- declines by design.

This finding stays a measurement rather than a red, for the reason the whole arc has named at
every step: a bump allocator that declines an out-of-order free is choosing safety over
reclaiming, and every instance here runs inside a process whose own exit resets the whole arena.

## Grade

Field setting. Observation (the 71-function script match and the 3-function hand read) stands
separate from inference (the shared cause) and from the one claim that stays a judgment call
(whether this ever rises to a red). Figures carry their own citation -- the file and line range
for each of the three hand-read functions, the regex for the 71. Graded **A-/90** at Field: a
closed, falsifiable count completing an open population named three essays back, with no new
witness and no new module.

## What stays open

This essay closes one file's own catalog; whether any `garden.free` call elsewhere in this tree
reaches a genuinely different shape is a separate, still-open reading. The two shapes already
proven to reclaim for real -- `comlink/discovery/table.rye`'s `pack_descriptors` and
`mantra/src/weave_v1_lift_witness.rye` -- live in other files, past the edge of this count.
