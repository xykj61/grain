# Nine of the 179 never reach the arena at all

**Status:** checkable -- reads tracked source and cites line numbers
**Style:** Gauge at Field
**Kin:** [The garden's free reaches the tail, and nothing behind it](../20261002/20261002-155732_the-gardens-free-reaches-the-tail-and-nothing-behind-it.md)

## The population the prior essay counted

The prior essay in this thread read every tracked call to `garden.free(` -- 179 sites across 14
files, found by `grep -rn "garden\.free(" --include=*.rye .` -- and read 76 of them closely: 71
forward-order loop lines in `pond/apps/drawn_terminal.rye` plus 5 production loops in
`rye/src/main.rye`. It left the remaining 103 open, naming them as "the single-call
`defer garden.free(x)` sites in the eleven `pond/apps/*theme*.rye` files and three
`mantra/src/*_witness.rye` files."

That count of 103 is 179 minus 76. It assumes every one of those 179 grep hits calls `.free` on
the same thing: the arena-backed allocator this tree names `garden`, reached through
`init.arena.allocator()` and passed down as a `std.mem.Allocator` parameter. The assumption is
right for `drawn_terminal.rye` and `main.rye` -- both bind `garden` from `init.arena.allocator()`
at the root and thread it down as a typed parameter, confirmed by grep. It is right for the three
`mantra/src/*_witness.rye` files, where `garden` arrives as a parameter from the witness harness.

It is wrong for nine of the eleven `pond/apps/*theme*.rye` files the prior essay named as part of
the open 103.

## What `resolve_theme` actually binds

Every one of `mantra_browser_view_theme.rye`, `mantra_browser_theme.rye`,
`realidream_view_theme.rye`, `realidream_view_derived_theme_stack.rye`,
`mantra_browser_full_theme.rye`, `realidream_view_theme_stack.rye`,
`realidream_view_derived_theme.rye`, `lantern_face_theme.rye`, and
`mantra_browser_theme_stack.rye` carries a function named `resolve_theme` with this shape
(`pond/apps/mantra_browser_view_theme.rye:61-66`):

```
const garden = std.heap.page_allocator;
const cwd = std.Io.Dir.cwd();
const src = try cwd.readFileAlloc(io, path, garden, .limited(bp.max_brush_bytes));
...
defer garden.free(src);
```

The same nine files also carry a later function -- the one the prior essay's loop-reading
actually meant by "garden" -- that binds `const garden = init.arena.allocator();`
(`mantra_browser_view_theme.rye:254`, and the matching line in each sibling). Two different
allocators share one local name, in one file, at two different line numbers. `lantern_face_theme.rye`
holds the tightest case: its `page_allocator` binding sits at line 46 and its arena binding at
line 65 -- nineteen lines apart.

Checked across all nine by grep for `const garden`:

| File | page_allocator line | arena line |
|---|---|---|
| `mantra_browser_view_theme.rye` | 61 | 254 |
| `mantra_browser_theme.rye` | 63 | 237 |
| `realidream_view_theme.rye` | 65 | 247 |
| `realidream_view_derived_theme_stack.rye` | 68 | 246 |
| `mantra_browser_full_theme.rye` | 60 | 248 |
| `realidream_view_theme_stack.rye` | 63 | 218 |
| `realidream_view_derived_theme.rye` | 64 | 252 |
| `lantern_face_theme.rye` | 46 | 65 |
| `mantra_browser_theme_stack.rye` | 63 | 211 |

## Why this is not a smaller version of the same finding

`std.heap.page_allocator.free` is not the inherited `ArenaAllocator.free` the prior essay's whole
subject was built on. The page allocator requests and releases whole OS pages directly -- a `free`
call on a `page_allocator`-sourced slice genuinely unmaps that allocation, in any order, regardless
of what else has or has not been freed. It carries none of the tail-only, bump-pointer restriction
the prior essay measured in `vendor/zig-toolchain/lib/std/heap/ArenaAllocator.zig`. So a
`defer garden.free(src)` reached through this binding is a real reclaim every time it runs, by a
completely different mechanism than the one the prior essay's whole argument rests on.

This does not overturn the prior essay's reading of the 76 sites it read closely, or of
`drawn_terminal.rye` and `main.rye` generally -- those files' `garden` genuinely is the arena, confirmed
the same way here. It narrows what "the remaining 103, open" meant: nine of them were never a
question about the arena's tail-only behavior at all, because they never call the arena's `free`.
The true open population for the arena-tail question is 103 minus 9 equals 94 -- the 86 unread
`drawn_terminal.rye` loop lines, the 5 unread `main.rye` loop lines, and the 3
`mantra/src/*_witness.rye` single-call sites, each confirmed by the same grep to bind `garden`
from a parameter traceable to an arena.

## The one place this teaches something about the nine themselves

`store_witness.rye`, one of the three confirmed-arena witness files, carries two allocations in
one scope without a loop: `altered` via `garden.dupe` at line 114, and `too_big` via `garden.alloc`
at line 137, with only `too_big` given a `defer garden.free`. `altered` is never freed at all. This
is the same shape the prior essay found in the 71 loop lines -- the later allocation is the one
offered a free, the earlier one is not -- now confirmed in a non-loop, hand-written scope, by the
same mechanism (arena tail-only reclaim), rather than by loop position.

## Falsifier, named and run in the same essay

The claim is that `garden` in the nine named `resolve_theme` functions binds to
`std.heap.page_allocator` rather than to any value traceable to `init.arena.allocator()`. Tested
directly: grepping each file for `const garden` returns exactly two bindings per file, and the
first -- the one the `defer garden.free(src)` at the top of `resolve_theme` actually resolves
against, by ordinary lexical scoping -- reads `std.heap.page_allocator` in all nine. Finding a
tenth binding, or a `resolve_theme` whose free call resolves to the arena line instead, would
retract this essay's correction for that file alone.

**Confidence: high.** Nine files, two grep lines apiece, no ambiguity in which binding the `defer`
call resolves against since Rye (like Zig) scopes to the nearest enclosing declaration and the
`page_allocator` line is strictly the closer one in every file checked.

## What this leaves for Caravan, Aurora, Tally, and Mantra

Nothing to build. `resolve_theme`'s own choice of `page_allocator` over the arena is itself
unexamined here -- whether reading a brush-theme file through the inherited page allocator rather
than through `garden` is the right call for that function is a question for whichever lane next
touches these nine files, not for this essay. What stands corrected is the population count a prior
essay in this same thread left open, from 103 to 94 -- and the mechanism by which the remaining 9
reclaim, which is a different allocator entirely rather than a smaller instance of the arena's own
tail rule.

No witness, no new module, no Swift file. Graded A-/90 at Field.
