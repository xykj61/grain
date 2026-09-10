# A Path Is Not a File

**Language:** EN
**Stamp:** `20260910.004524`
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every figure below is read from this tree by a command
named beside it, and the class is held at zero by
[`../tools/l/link_counted_witness.rish`](../tools/l/link_counted_witness.rish)
**Lane:** Diffuser -- moonshots and research; this lap turned into a repair
**Kin:** [`../foundations/20260826-021733_fire-the-row-that-sees.md`](../foundations/20260826-021733_fire-the-row-that-sees.md) -- [`../foundations/20260816-214652_standfast-the-stopped-line.md`](../foundations/20260816-214652_standfast-the-stopped-line.md) -- [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) -- [`20260910-001454_the-count-in-front-of-the-byte-ceiling.md`](20260910-001454_the-count-in-front-of-the-byte-ceiling.md)

---

`git ls-files` answers with paths. A tree that links a module into every room importing it answers
with more paths than it has modules. Counting the first and reporting the second overstates by
exactly the number of links, silently, in whichever direction the tree happens to grow -- and this
tree published that overstatement on its own front door.

The finding is small and the arithmetic is elementary, so the interesting part is why it survived:
the cure was already written twice, each time with a comment explaining the reason, and both
writings stopped at the file they sat in.

## What this tree links, and how much

Zig refuses an import that escapes the root file's directory, so a module reached by bare name from
two rooms is a real file in one and a symlink in the other. `mantra/recall_lap1.rye` is the file;
`comlink/recall_lap1.rye`, `linengrow/recall_lap1.rye`, and `pond/apps/mantra/recall_lap1.rye` are
links onto it. One module, four tracked paths.

Read `20260910.004524` by `git ls-files -s`, which prints an index mode ahead of each path and gives
symlinks the mode `120000`:

| Population | Tracked paths | Of those, symlinks | Share |
|---|---|---|---|
| whole tree | 17,107 | 282 | 1.6% |
| `*.rye` | 1,964 | **230** | **11.7%** |
| `*.bron` | -- | 22 | -- |
| `*.md` | 6,093 | 9 | 0.15% |
| `amphora/*.rye` | 11 | **4** | **36%** |

```
git ls-files -s '*.rye' | awk '$1 == "120000"' | wc -l
```

**Observation.** The links concentrate almost entirely in the population the code meters read. The
`.rye` share is seventy times the tree-wide share, because linking is how this tree composes Rye
modules and nothing else in it is composed that way.

**Inference.** A per-path census of documents is very nearly a census of documents, while a
per-path census of Rye modules stands 12% above the truth. The hazard scales with how a population
is composed, so it wants a measurement per glob rather than a rule of thumb.

## The bill, on this tree, before the guard existed

### The front door published 1,964 modules and holds 1,734

`README.md` carried, in a generated block:

```
| **Witnesses** running on metal | **1909** |
| **Rye modules** they stand over | **1734** |
```

That second figure read **1964** until this lap. `tools/fixtures/r/readme_metrics_scan.sh` took
`git ls-files '*.rye' | wc -l`, and 230 of those paths are links onto a module already in the count.
The overstatement is **13.3%**, and it lands in the one number a reader divides the witness count
by -- so the block understated its own strongest claim. The honest ratio is 1,909 proofs over 1,734
modules, or **1.10 witnesses per module**, where the published pair read 0.97.

The scan's own header says why these four figures earn the block: *"A README is the most
Lindy-exposed document a project owns."* It is right, and that is what makes the miscount expensive
rather than untidy.

### Two guards had thresholds calibrated on the inflated reading

This is the sharper cost, and it was found by repairing the first one. `equinox_e141` and
`equinox_e142` each assert floors:

```
test "$RYE_N" -ge 9  || { ... }      # amphora/*.rye
test "$CELLAR_N" -ge 10 || { ... }   # amphora/*
```

Amphora holds **7** distinct `.rye` sources at 11 paths, and **8** distinct files at 12 paths. Both
floors were set two links deep into their own populations, so the moment the counts were repaired
both guards refused -- reporting `census=failed`, `verdict=misread`, on a tree holding every file it
held the hour before.

**A threshold calibrated against an inflated number refuses the truth the moment the number is
repaired.** That sentence is the whole finding, and it generalises past symlinks: any floor set from
a metric's output inherits every fault in the metric, and the inheritance is invisible while both
agree. Both floors moved to the distinct counts with the recalibration written into
the file beside them, so a later reader meets the reason rather than a mysterious lowered bar.

## Why it survived: the cure was written twice and gated never

The fix is one line, and this tree had already written it:

```
[ -L "$f" ] && continue
```

It stands at `tools/fixtures/r/rye_comment_ascii_scan.sh:227` and
`tools/fixtures/r/rye_spoken_ascii_scan.sh:168`, each above a comment saying exactly why -- *"`git
ls-files` lists a link AND its target as two paths, and following both counts the same bytes."* The
knowledge stood present, correct, written down, and reachable by grep.

`.claude/rules/reds-first.md` names what should have happened next: **a lantern that fires twice
becomes a loom.** Two files had lit the lantern. Nothing had built the loom, so five other sites
counted paths and called them things, one of them on the front door.

**Inference, stated as one.** A comment cures the file it sits in. Its reach ends there, and the file written
next month by a hand that never opened it starts fresh. The distance between *documented* and *enforced* is
where this class lived, and the measurement supports that reading rather than proving it: of 23
tracked runners enumerating tracked `.rye`, **5 carry the link skip and 18 count paths** -- and the 5
belong to the authors who happened to hit the problem.

## The loom

[`../tools/fixtures/l/link_counted_scan.sh`](../tools/fixtures/l/link_counted_scan.sh) reads, per
line, whether a runner counts paths through a glob a symlink actually answers:

- **A counting line** reaches `git ls-files`, names a glob, and pipes into `wc -l`.
- **The cure** takes `git ls-files -s` and drops mode `120000`, the idiom `exec_bit_scan.sh` and
  `empty_document_scan.sh` already use.
- **The glob is asked of git**, per run, memoized. So a count over `*.md` on a tree with no linked
  page is honest arithmetic and walks free -- and becomes a finding on the lap a link lands under
  it, which the control proves by landing one.

**Held at zero rather than ratcheted.** Every instance found on the seating lap was repaired in the
same commit, and the cure is one line of an idiom already in the tree, so a ceiling above zero would
be slack nobody asked for. Nine sites across seven files were repaired: the README metrics scan, two
`commence` inventories, two `equinox` amphora censuses, a census control seam, and a provenance
scan.

Proven from both sides by
[`../tools/fixtures/l/link_counted_control.sh`](../tools/fixtures/l/link_counted_control.sh) --
**fifteen behaviors on real git repositories with real symlinks in a throwaway pen**, every refusal
planted and then lifted, every welcome asserted as hard as every refusal, including the cured form
returning the honest number (2 modules where 3 paths stand) rather than merely passing the scan.

## The reading this lap got wrong twice, since a paper that hides that teaches less

Two ad-hoc greps ran before the census above, and both were wrong in ways worth naming.

**The first over-collected.** A pattern for the sibling paper's byte-and-count ceiling class, widened
to the whole tree, reported 48 files. Eight were `caravan/`, and every one of the eight matched on
`const walled_count: u32 = 1;` -- a **local inside a self-test** rather than a published ceiling -- or on
`max_address_len`, a **name-length** bound the `len` suffix miscategorised as byte-shaped.
Tightening to `^pub const max_...` at module scope brought 48 to 13, and dropping the `len` suffix
was what removed the last of the noise.

**The second under-collected, and nearly booked a red against a healthy ledger.** A grep for
`\*\*(OPEN|BOOKED|CLOSED)\*\*` over the REDS pin reported that 9 of 16 rows declared no status --
which would mean the pin folds forever and every future red arrives with nowhere to go. The rows
read `**OPEN.**`, with the period inside the bold, and the pattern passed over every one. The tree's own
`reds_fold.sh` matches `\*\*(OPEN|CLOSED|BOOKED)[^*]*\*\*` and has been right the whole time. All
16 rows are OPEN, exactly as the previous lap recorded.

**What both share:** a hand-written pattern is a claim about a corpus, and the corpus is the
authority. The first was checked by reading the matches; the second was checked by reading the
guard that already existed. **Measurement beats memory, and reading the matches beats trusting the
pattern.**

## What would falsify this

- **The census.** Run `git ls-files -s '*.rye' | awk '$1 == "120000"' | wc -l`. A figure far from
  230 means the population moved, and the ratio in the table above is stale rather than wrong --
  which is why the command sits beside the number.
- **The front-door repair.** Run `rishi/bin/rishi run tools/r/readme_metrics_witness.rish`. If the
  block drifts from a fresh measurement, the repair did not hold.
- **The loom's reach.** Plant `n=$(git ls-files '*.rye' | wc -l)` in any tracked `.sh` or `.rish`
  and run the scan. A reading of zero means the pattern misses a real form, and the guard is
  weaker than this paper claims.
- **The distinct-count choice itself.** A consumer that genuinely wants paths -- a duty visiting
  each link in turn -- makes the repair wrong for that site, and the scan should read past it by
  name. All nine printed a population figure instead, so all nine wanted files.

## What this does not reach

**Whether a linked module earns its link.** A build-graph question, and a different lap.

**The 273 remaining tracked symlinks outside a counting line.** They are correct as they stand; the
guard reads counting, never linking.

**The byte-and-count ceiling class** that opened this lap. It stands where the sibling paper left
it: two real instances in `mantra/`, the repair a format decision awaiting Keaton's word, and the
census patterns now known to need `^pub const` at module scope before anyone builds a loom over
them.
