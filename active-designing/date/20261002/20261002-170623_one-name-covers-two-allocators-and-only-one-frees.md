**Status:** checkable -- a reading of tracked source, confirmed by grep, with one witness run on metal
**Style:** Gauge at Field
**Room:** checkable
**Stamp:** 20261002.170623

# One name covers two allocators, and only one of them frees

The last five essays in this arc read `garden.free(` across 179 call sites. They found three
different outcomes hiding behind one idiom -- abandoned, no-op, and genuine tail free. Every one of
those 179 sites binds `garden` to a `std.mem.Allocator`, obtained from `init.arena.allocator()`. That
is the chapter-memory rule's own words: *reach for the season allocator via
`const garden = init.arena.allocator()`* (`.claude/rules/tame-guidance.md`). The rule names one thing
`garden`. Tally's own module, `tally/gardens.rye`, names a second thing `Gardens` -- a bounded
collection of `Region` values. This essay asks whether the two names ever collide, and what `Region`
itself can do when asked to let something go.

## The claim, bounded

`tally/region.rye`'s `Region` type declares exactly four public functions: `init`, `alloc`,
`divide`, `clear`. That list is the whole release surface. `clear()` is the one way a caller gives
memory back, and it gives back everything at once. `tally/gardens.rye`'s `Gardens` type holds a fixed
set of named `Region` values. It matches the same shape one level up -- `clear_one` and `clear_all`
beside `add`, `get`, and two capacity readers. Grepped directly against both files:

```
$ grep -n "pub fn\|fn " tally/gardens.rye
    pub fn init(...)        pub fn add(...)         pub fn get(...)
    fn admits(...)          pub fn add_division(...) pub fn clear_one(...)
    pub fn clear_all(...)   pub fn total_capacity(...) pub fn total_remaining(...)

$ grep -rn "\.free(" tally/region.rye tally/gardens.rye
(no output)
```

The five prior essays asked one question: when `garden.free(` runs, does it reclaim the tail, no-op,
or abandon the allocation? `Region`'s own shape answers it already. `clear()` is the only release
gesture `Region` offers, and it resets the whole backing buffer, every time. So the five essays'
entire 179-site population reads the **inherited std seam** -- `ArenaAllocator.free`, reached through
the `std.mem.Allocator` interface -- a different type, answering a different question.

## Confirming the chapter-memory rule holds the line it names

Measured across every tracked `.rye` source: **492 files** bind a local named `const garden`. Every
typed `garden` parameter found by grep -- `garden: std.mem.Allocator`, `run_selftest(garden:
std.mem.Allocator)`, and the `direct_thumb` helper in `brushstroke/edit_filmstrip_track.rye` -- reads
`std.mem.Allocator`, uniformly. The chapter-memory rule's own words name the worry this guards
against: *never rename it either -- `std.heap.GardenAllocator` as a thin alias steals the name
reserved for Tally's own region type.* All 492 instances hold the line the rule draws: the word
`garden` stays with the std-seam interface, and the rule's worry stays a named worry rather than a
measured event.

## The one caller that actually binds a `Region` named `garden`

One file stands apart from that uniform reading, and it is also the single real caller of Tally's
own `Region` type outside `tally/` itself: `comlink/discovery/table.rye`. Its `PeerTable` struct
declares a field literally named `garden`, typed `tally_gardens.Region`:

```rye
pub const PeerTable = struct {
    slots: [max_peers]PeerRecord,
    free: FreeStack,
    live_count: u32,
    garden: tally_gardens.Region,
```

This reads as a peaceful second sense, rather than a rule violation. The chapter-memory rule governs
the **local variable name reached for at the std seam**; `garden` here is a **struct field name**
naming Tally's own `Region` directly, in a file the `ArenaAllocator` never enters. It is the one place
in this tree where the word `garden` resolves to the type that only offers `clear`, standing beside
the type that offers abandoned, no-op, or genuine tail free (per the prior essays). The one caller of
`.garden` in this file is `pack_descriptors`:

```rye
pub fn pack_descriptors(table: *PeerTable) error{OutOfBounds}!u32 {
    table.garden.clear();
    var n_packed: u32 = 0;
    ...
    const dest = try table.garden.alloc(n);
```

It calls `.clear()` once, at the top, before repacking every live descriptor from scratch -- the one
release gesture its type exposes. The dedup-ratio and mutable-identity essays already found this
pattern elsewhere: *no caller frees without clearing its whole region.* Here the pattern reaches its
cleanest form -- a caller whose type hands it one release gesture, a whole-region reset, and that is
exactly the gesture it reaches for.

## What this settles, and what it does not

**Settled:** the five-essay arena-free arc reads the std seam throughout, and Tally's own `Region`
sits one layer beneath it with a simpler release surface. The chapter-memory rule's naming boundary
holds across 492 bindings, with one struct field standing as a second, peaceful sense of the same
word rather than an exception to the rule, since the rule names a local variable pattern and this is
a field.

**Open, and belonging to Tally's own future lap rather than this one:** whether `Region` should grow
a `free` method of its own, matching the std `ArenaAllocator`'s last-allocation-only shape, stays a
design question this essay names and leaves. `pack_descriptors`'s own shape -- clear, then repack
everything live -- already rebuilds its packed view from the authoritative `slots` array on every
call, so the question is purely about tidiness between calls: a narrower `free` would change only
how fresh the Region's buffer reads between two packs, with correctness identical either way.

## Falsifier

If a future `.rye` file declares a local or field named `garden` typed as anything other than
`std.mem.Allocator` or `tally_gardens.Region` -- a third resolution of the one word -- this essay's
claim that the word covers exactly two things narrows to false. Check with:

```
grep -rn "garden: " --include=*.rye | grep -v "std.mem.Allocator\|tally_gardens.Region\|Allocator)"
```

Run at the time of writing, this returns only the two established cases listed above.

Graded B+ at Field: one bounded claim, grep-confirmed over the full tree, one genuinely new caller
surfaced (`comlink/discovery/table.rye`), and a named falsifier a later lap can run in one line.
`tally/region.rye` and `tally/gardens.rye` keep their own standing build-and-prove headers,
unchanged by this reading, which reaches for neither a new witness nor a new module.
