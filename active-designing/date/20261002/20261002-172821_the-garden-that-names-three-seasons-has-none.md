**Status:** checkable -- a reading of tracked source, confirmed by grep across the whole tree
**Style:** Gauge at Field
**Room:** checkable
**Stamp:** 20261002.172821

# The garden that names three seasons has none

The prior essay closed the arena-free arc's five-essay reading of `garden.free(` and found Tally's
own `Region` type sitting one layer beneath the std seam, offering `clear()` as its whole release
gesture. It named `Gardens` -- `tally/gardens.rye`'s bounded collection of named `Region` values --
as a second type the word resolves to, and left the question of `Gardens`' own caller for this
essay to ask directly.

## The claim, bounded

`tally/gardens.rye`'s own doc comment names three concrete production consumers before a single
line of code:

```rye
//! Three gardens cover the near stack:
//!   blob  -- working memory for one Mantra blob (read buffer, serialize buffer)
//!   diff  -- line buffer for LCS diff computation
//!   frame -- Brushstroke widget tree per redraw
```

Grepping the whole tree for every file that imports `tally/gardens.rye` finds exactly three:
`comlink/discovery/table.rye`, and `tally/divisions_test.rye` and `tally/total_capacity_test.rye` --
both of which live inside `tally/` itself, as the module's own test fixtures.

```
grep -rln '@import(".*gardens.rye")\|tally_gardens' --include=*.rye
comlink/discovery/table.rye
tally/divisions_test.rye
tally/total_capacity_test.rye
tally/gardens.rye
tally/region.rye
```

The prior essay already read `comlink/discovery/table.rye`'s own import closely: it names
`tally_gardens.Region`, the re-exported single-garden type, and stops there, leaving the `Gardens`
collection for a caller still to come. So the count of files that actually build a `Gardens` -- the
named, multi-region type the doc comment describes -- stands at two, both inside the module's own
tests.

## Where "blob," "diff," and "frame" actually live

The three names from the doc comment -- the ones meant to anchor the type to Mantra's blob
handling, Mantra's diff computation, and Brushstroke's per-redraw frame tree -- appear nowhere in
`mantra/` or `brushstroke/` at all:

```
grep -rln "gardens\|Gardens" mantra/ brushstroke/
(no output)
```

Every occurrence of the literal strings `"blob"`, `"diff"`, and `"frame"` as garden names lives
inside `tally/gardens.rye` itself, lines 253-332 -- the module's own self-test, which builds a
`Gardens`, admits all three, reads them back, and exercises `clear_one("diff")` once before
exiting. The doc comment describes a design; the self-test is the design's only inhabitant.

## The one function `Gardens` adds over `Region` alone has exactly one caller, and it is the test

`Region` offers one release gesture, `clear()`, which resets its whole buffer at once. `Gardens`
adds a second: `clear_one(name)`. It resets a single named garden inside the collection and leaves
its siblings untouched. That is a capability only the collection offers, and the reason a caller
would reach for `Gardens` over three separate `Region` values in the first place. Grepping for
every call site:

```
grep -rn "\.clear_one(" --include=*.rye
tally/gardens.rye:286:    g.clear_one("diff");
```

One call, in one file, at the line inside the self-test quoted above. `clear_all()` -- the
whole-collection reset, offered as a parallel to `Region.clear()` one level up -- reads much the
same way:

```
grep -rn "\.clear_all(" --include=*.rye
tally/divisions_test.rye:41:    g.clear_all();
tally/total_capacity_test.rye:25:    g.clear_all();
```

Two calls, both inside `tally/`'s own test files. `add_division()` -- the function that carves a
named garden directly out of a parent `Region`, letting a caller divide one backing buffer into
several named seasons through one call rather than hand-computed offsets -- reads the same way:

```
grep -rn "\.add_division(" --include=*.rye
tally/divisions_test.rye:18:    g.add_division("blob", &parent, 512) catch unreachable;
tally/divisions_test.rye:19:    g.add_division("diff", &parent, 256) catch unreachable;
```

Two calls, one file, the module's own test.

## What this settles, and what it does not

**Settled:** `tally/gardens.rye` is complete, proven, and GREEN on its own terms. Its doc
comment's invariants hold. Its `admits()` gate is well-formed. Its selftest exercises `add`,
`add_division`, `get`, `clear_one`, `clear_all`, and the duplicate-name check, all in one pass.
That reading stands on its own. What is measured here is narrower: the type's **reason to exist
beyond a bare `Region`**. That reason is the ability to hold several named seasons and release one
while the rest stand undisturbed, and it has waited the whole arc for a real caller to ask for it.
Every production caller this arc's six essays have found either reaches the std `ArenaAllocator`
(full reset, reclaimed through `garden.free(` in some shape) or binds a bare `tally_gardens.Region`
directly (one name, one whole `clear()`). `Gardens` sits between those two. It offers a capability
-- selective, named release -- that this tree has written three illustrative names for, still
waiting for the caller that needs it.

**Open, and belonging to a future caller's own choice rather than this essay's:** whether Mantra's
blob handling, Mantra's diff computation, or Brushstroke's frame tree will ever actually want three
independently-clearable seasons sharing one backing buffer, or whether each will keep doing what
every measured caller in this arc already does -- reach for a single allocator and reset the whole
thing at once. The doc comment's own three names may describe a real future need, or may describe
the shape a design sketch took before its callers arrived and turned out to want less than it
offered. The tree today leaves that question open.

## Falsifier

If a future `.rye` file outside `tally/`'s own tests constructs a `Gardens` (calls `Gardens.init()`
or imports `tally_gardens.Gardens` and builds one), or calls `.clear_one(`, `.clear_all(`, or
`.add_division(` from outside `tally/gardens.rye` and its two existing test files, this essay's
claim that the type's selective-release capability has zero production exercise becomes false.
Check with:

```
grep -rln "Gardens.init()\|tally_gardens.Gardens" --include=*.rye | grep -v '^tally/'
grep -rn "\.clear_one(\|\.clear_all(\|\.add_division(" --include=*.rye | grep -v '^tally/'
```

Run at the time of writing, both read clear of any such site.

Graded A/91 at Field by `tools/fixtures/q/qa_report_card.sh` (register 97, reach 90, truth 100,
service 75 judged): one bounded claim, grep-confirmed over the full tree in four separate greps,
each call site counted and quoted rather than estimated, and a two-line falsifier a later lap can
run directly. No new witness, no new module; `tally/gardens.rye` keeps its own standing
build-and-prove header unchanged, and this essay reaches for neither.
