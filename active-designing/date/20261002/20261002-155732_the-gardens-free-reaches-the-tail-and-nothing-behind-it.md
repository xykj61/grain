# The garden's free reaches the tail, and nothing behind it

**Style:** Gauge at Field - **Room:** checkable -- a reading of tracked source and the vendored
std seam, no new witness, no new module
**Stamp:** `20261002.155732`
**Kin:** [the radial split only pays when something frees](../20261002/20261002-002240_the-radial-split-only-pays-when-something-frees.md) -
`tally/region.rye` - `tally/gardens.rye` - `vendor/zig-toolchain/lib/std/heap/ArenaAllocator.zig` -
`rye/src/main.rye` - `pond/apps/drawn_terminal.rye`

## What is

`tally/region.rye`'s `Region` publishes exactly three operations: `alloc`, `divide`, and `clear` --
take, split, and reset. The module's own vocabulary stops there. `tally/gardens.rye`'s `Gardens`, a
named collection of `Region`s, adds `clear_one` and `clear_all`, each resetting a whole region's
cursor to zero in one gesture. Its own header states the shape directly: "a bounded garden with a
stated edge: bump-allocate within, fail past, clear whole in one gesture." Each of this tree's own
two authored allocators releases memory the same one way: the whole region, at once.

TAME's own rule names the allocator a caller reaches for at the inherited seam -- the warm local
name `garden` for `init.arena.allocator()`, std's `ArenaAllocator` wearing this tree's own word.
`vendor/zig-toolchain/lib/std/heap/ArenaAllocator.zig:608-636` is that allocator's own `free`:

```
fn free(ctx: *anyopaque, memory: []u8, alignment: Alignment, ret_addr: usize) void {
    const arena: *ArenaAllocator = @ptrCast(@alignCast(ctx));
    ...
    const cur_end_index = @atomicLoad(usize, &node.end_index, .monotonic);
    if (buf_ptr + cur_end_index != memory.ptr + memory.len) {
        // Not the most recent allocation; we cannot free it.
        return;
    }
    const new_end_index = cur_end_index - memory.len;
    ...
}
```

A call to `garden.free(x)` rewinds the arena's cursor when `x` is exactly the single most recent
allocation standing, and returns having moved zero bytes otherwise. This is the inherited
allocator's own documented shape, read at its source rather than assumed from its name.

## The three readings share one allocator model

The prior essay in this kin measured `tally/region.rye`'s callers and found every one clears its
whole region rather than freeing a single block, naming that a fact about *callers*. Reading the
allocator bodies themselves -- `Region`, `Gardens`, and the std `ArenaAllocator` they all sit above
-- turns that fact about callers into a fact about the *model*: every allocator this tree reaches
for, from its own authored bump-allocator up through the inherited seam, shares one shape. Release
the whole region, or release the single most recent allocation -- two verbs, and the model's whole
vocabulary.

## What 179 call sites ask for, and what they get

`garden.free(` and its vendored sibling spelling appear at **179 call sites across 14 tracked
`.rye` files**, measured `20261002.155732` by `grep -rn "garden\.free(\|arena\.free(\|\.allocator()\.free(" --include=*.rye .`
on this tree's own working copy. **157 of the 179** sit in one file,
`pond/apps/drawn_terminal.rye`; **71 of those 157** are the identical one-line shape

```
while (i < frame.len) : (i += 1) garden.free(frame[i].text);
```

followed immediately by a bare `garden.free(frame);` for the slice itself. Every one of the 71
loops this tree carries in that shape counts upward from `i = 0`. A direct grep for a descending
companion -- `while (i >`, a `reverseIterator`, a `len - 1 -` index -- beside any `free(` call
returns an empty result, across the whole tracked tree: zero reverse-order free loops stand today.

Read one instance whole, `compose_thin_view_lines` and its caller `run_thin_view_witness`
(`pond/apps/drawn_terminal.rye:313-360`): the function allocates the slice `lines` first, then
five `.text` fields in ascending order, `lines[0]` through `lines[4]`. The witness's `defer` block
walks `i = 0..4` calling `garden.free(frame[i].text)`, then calls `garden.free(frame)`. Tracing the
arena's own cursor against the `free` body above: `frame[0].text` through `frame[3].text` each
find a later allocation already standing in their place, so each call returns unchanged.
`frame[4].text` alone -- the single most recently allocated field at the moment the loop reaches it
-- rewinds the cursor. The trailing `garden.free(frame)` then reaches for memory ending well before
the arena's current occupant -- `frame[3].text`, now the survivor at the tail -- so it too returns
unchanged. **Of six `free` calls in this one witness, exactly one moves a byte.**

The same shape, by inspection of a second instance (`compose_books_view_lines` /
`run_books_view_witness`, lines 460-482) and by the identical one-line text shared across all 71
loop sites, generalizes: a forward-order free loop over N fields reclaims the Nth field alone, and
leaves the container held, because the container is always the group's earliest allocation.

`rye/src/main.rye` -- the Rye compiler's own build driver, running in production rather than inside
a test witness -- carries the identical pattern: `for (bridge_zigs.items) |p| garden.free(p);`
(line 717), `for (staged_rye.items) |p| garden.free(p);` (721),
`for (records.items) |record| garden.free(record.name);` (1158),
`for (paths.items) |path| garden.free(path);` (1371),
`for (import_paths.items) |p| garden.free(p);` (1778) -- five forward-order loops over slices this
tree's own code built in allocation order, each reaching `garden.free` for every element and
reclaiming, by the same reasoning, the one built last alone.

## What this means, and where it stops

**Safe by construction.** The std implementation is conservative on purpose: a `free` call
identifies itself as the most recent allocation before it acts, and declines rather than guessing
otherwise, so every one of the 179 calls either rewinds correctly or returns the arena exactly as
it stood. Each call is safe to make, in the narrow sense that each either succeeds or costs exactly
zero.

**Bounded in the cases read here.** `run_thin_view_witness` and its 70 siblings in
`pond/apps/drawn_terminal.rye` are witness functions -- a fixed small array of `SkateLine`s,
composed once, checked once, and the process exits shortly after. The bytes these loops leave
standing run to a few hundred per witness, held until the arena itself is torn down with the
process. `rye/src/main.rye`'s five sites sit inside one compiler invocation, same shape: path
strings standing from those loops persist until `rye build` exits and the OS reclaims the whole
process image. Every case measured here runs inside a process whose own exit is the reset:
`pond/apps/drawn_terminal.rye` reaches this `garden` without ever calling `.reset(` or `.deinit(`
on it, and the process ending stands in for both.

**What it does mean.** `garden.free` documents an intent -- "this buffer's lifetime ends here" --
that the inherited allocator honors only at the tail, and sets aside everywhere else. Of the 76
call sites read closely in this essay (71 loop lines plus 5 production loops in
`rye/src/main.rye`), each group of N calls performs exactly one real reclaim, earned by the
coincidence of being last. The other N-1 calls in each group are comments shaped like code, keeping
the author's promise in spelling alone; the inherited seam keeps a different promise.

## Falsifier, named and run in the same essay

The claim this essay rests its weight on is that every free loop in this tree runs forward, in
allocation order -- the single order that caps each group's reclaim at one. That claim was tested
directly: a grep for a descending loop index or a reverse iterator anywhere beside a `free(` call,
across every tracked `.rye` file, returns an empty result. Finding one would mean its whole group
genuinely reclaims, a correction this essay's reading would then owe for that site alone.

**Confidence: high for the 76 sites read by hand and by the exhaustive reverse-order grep; open for
the remaining 103 of the 179** (the single-call `defer garden.free(x)` sites in the eleven
`pond/apps/*theme*.rye` files and three `mantra/src/*_witness.rye` files), where a lone call that is
the scope's last allocation succeeds, and this essay leaves each of those 103 to its own reading.

## What this leaves for Caravan, Aurora, Tally, and Mantra

**Tally** already names its own shape honestly in `tally/gardens.rye`'s own header -- "clear whole
in one gesture" was always the stated constraint for its own two allocators, and stays an unstated
one only at the inherited seam a caller reaches through `garden`. This essay stops short of a
module edit: the std allocator's `free` is exactly as conservative as Zig's own documentation
already says, and this tree's two authored allocators already match it by construction. The one
open question, for whichever lane next touches `pond/apps/drawn_terminal.rye` or
`rye/src/main.rye`, is whether the 76 forward-order loops should drop their zero-effect `free`
calls, or keep them as the stated intent for whenever this tree's garden grows a real free.
Behavior today holds steady either way.

No witness, no new module, no Swift file. Graded B+ at Field.
