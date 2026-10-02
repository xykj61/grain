# The one release gesture has never been exercised twice

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field
**Status:** Vision -- a reading of tracked source, no new witness or module
**Stamp:** `20261002.174555`
**Kin:** [The garden's free reaches the tail, and nothing behind it](../../date/20261002/20261002-155732_the-gardens-free-reaches-the-tail-and-nothing-behind-it.md) - [One name covers two allocators, and only one frees](../../date/20261002/20261002-170623_one-name-covers-two-allocators-and-only-one-frees.md) - [The garden that names three seasons has none](../../date/20261002/20261002-172821_the-garden-that-names-three-seasons-has-none.md)

## What the kin essays already found

Five essays this lap read `tally/region.rye`'s own release surface and `garden.free(` call sites
across this tree and arrived at one standing claim: **no caller frees without clearing its whole
region.** `Region` declares exactly one release gesture, `clear()` at `tally/region.rye:100` -- a
full reset of the cursor to zero, nothing partial. The question the chain never asked directly:
**when a caller does reach for that one gesture, how many times does it reach for it in one
running process?**

## The population, read rather than recalled

A tree-wide grep for `.clear(` returns many hits, and most are a different type entirely --
`linengrow/hearth_lulu3.rye`'s `Draft.clear()`, `mikrophone/carry.rye`'s inbox clear, two `pond/`
line buffers. Reading each call site's own `init(` line narrows the population to genuine
`tally.Region` instances. Five remain:

| File | Line | What runs between allocation and `clear()` |
|---|---|---|
| `caravan/bounded.rye` | 121 | fill a budget to its edge, assert it is full, clear, assert it is empty again, `return 0` |
| `caravan/chain.rye` | 104 | the same shape, inside the `.prove` branch of a one-shot dispatch |
| `caravan/twin.rye` | 103 | the same shape again, inside `run_dependent`, one call per process |
| `tally/seed.rye` | 88 | the library's own selftest: fill to 64, clear, allocate 16 more, prove the cursor restarted |
| `comlink/discovery/table.rye` | 176 | `pack_descriptors`: clear, then repack every live slot's descriptor bytes in order |

`tally/gardens.rye`'s own `clear_one` (line 191) and `clear_all` (line 204) are the library's
*implementation* of the capability one level up `Region`, not a caller of it -- read in the kin
essay immediately above this one, which found `clear_one`'s only caller anywhere in the tree is
`tally/gardens.rye`'s own selftest.

## The falsifier the kin essay's own phrasing invited

The prior essay in this chain described `pack_descriptors` as the cleanest instance of "clear, then
repack everything live from the authoritative slot array" -- language that reads as an ongoing,
in-service operation. Its own public signature, `pub fn pack_descriptors(table: *PeerTable)
error{OutOfBounds}!u32`, carries no caller restriction, so the honest question is whether anything
outside its own test calls it, and whether that test calls it more than once.

```
$ git grep -n "pack_descriptors" -- '*.rye'
comlink/discovery/table.rye:175:    pub fn pack_descriptors(table: *PeerTable) error{OutOfBounds}!u32 {
comlink/discovery/table.rye:294:    const n_packed = try pack_table.pack_descriptors();
```

One call site, inside the module's own selftest (`discovery_table_check`), at line 294 -- a `const`
binding of the result, read once, checked against an expected count, and the test function returns
three lines later. Every one of the other four sites shows the identical shape: a `while (true)`
loop stands nearby in `bounded.rye`, `chain.rye`, and `twin.rye`, and in every case it belongs to a
separate function, the *supervisor* that watches the dependent process from outside -- never the
function that calls `clear()`. The dependent itself runs its fill-clear-assert sequence exactly
once and exits.

## The finding

**Every genuine `Region.clear()` call site in this tree fires exactly once per process, and that one
firing sits a few lines from that process's own exit.** `pack_descriptors` is not a counterexample
to the kin essays' pattern; it is a fifth instance of it, read too quickly by the essay that named
it. The population is small enough to state the negative plainly rather than hedge it: **zero** of
the five call sites clear a region and then go on to allocate against it for a second independent
round of work inside a still-running process.

This sharpens "no caller frees without clearing its whole region" into something stronger: not only
does every release clear the whole thing, every release is also *terminal* to the function that
calls it. The one gesture Tally offers for giving memory back has been built, proven by five
separate demonstrations, and never yet actually exercised as the thing its own name promises --
reclaiming space so the *same* process can use it again for something else. Each of the five reads
as proof that the gesture works, not as the gesture earning its keep.

## What this does not reach

**Whether the gesture should be exercised twice anywhere.** A region cleared once before the
process that owned it exits is correct and sufficient for everything this tree currently runs --
each of `bounded.rye`, `chain.rye`, and `twin.rye` is explicitly a Caravan selftest proving a budget
discipline, not a production service loop. The open question the kin essay named stands exactly
where it left it: a caller with a genuine reason to clear and reuse inside one long-running process
has not been written yet, and this reading finds no evidence it exists even in miniature.

**Whether a long-running Caravan dependent -- one that outlives a single lap rather than a single
process -- would want this.** That caller is hypothetical, same as the kin essay's open crux, and
building toward it is Tally's or Caravan's own next edit rather than a finding this reading can
make on tracked source alone.

## Falsifier

A `Region.clear()` call site inside a loop whose own function does not return or exit on that same
iteration would overturn this reading directly. None exists today; the five-site population above
is small enough that a sixth call site is the whole falsifying condition, checkable in one command:

```
git grep -n "\.clear()" -- '*.rye' | grep -v "clear_one\|clear_all\|Draft\|inbox\|\.line\."
```

## Grade

Register: affirmative, bounded. Reach: five call sites, each cited by file and line, no term
introduced before its use. Truth: every citation re-derivable from the quoted grep and the line
numbers given above. Service: closes a loose end the kin essay's own language left open; no witness
or module follows from it. **A/90 at Field.**
