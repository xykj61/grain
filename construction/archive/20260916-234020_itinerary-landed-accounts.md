# Landed account -- COPAL, a resin's bytes are the bytes that landed

**Stamp:** `20260916.234020` (EDT)
**Language:** EN
**Style:** Gauge at Meter
**Voice:** Kyri
**Status:** Landed account, shelved at birth -- historical continuity outside Mitra and shred-prep
**Room:** checkable -- every reading below is held by a named guard or a named command
**Card:** [`../ITINERARY.md`](../ITINERARY.md)

## FIRE SEES -- see the threshold where work should stop

**Rota lap 5192, row 2.** Fire is cut and stop, and its sense is vision: look hard at what must be
seen. What this lap saw is a **wall with one side missing**, standing in the room the fire row would
most expect to be whole -- a cellar of testimony whose whole job is to stay exactly as it landed.

## The mechanism

`kyri-resins/manifest.kyri` is the resin cellar's catalog, and under the heading *WHAT THE SEVENTEEN
DIGESTS ARE* it states the room's law in its own prose: *every resin in this room has exactly one
commit in the tree's whole history, and its blob at that commit is byte-identical to its blob at
HEAD -- checked one file at a time, all seventeen equal.* A hand took that reading on `20260910` and
nothing read it again. In Gauge's fifth question about a figure -- what holds it still -- the answer
was **free**.

`tools/fixtures/b/kyri_resins_landed_scan.sh` takes the reading the paragraph describes, and
`tools/b/kyri_resins_landed_witness.rish` holds it. For each file directly in the room, the scan
resolves the commit that ADDED that path, names the blob that commit recorded, names the blob the
working file would land as, and compares the two.

## Why the seal beside it cannot see this

`kyri_resins_catalog_witness.rish` has recomputed each resin's SHA3-256 against its `seal` line
since `20260910.014500`, so a resin edited in place reds. **Both halves of that comparison live in
the working tree.** An edit landing together with an updated seal is self-consistent, the digest
answers, and every gate in this room stays green. The seal is a wall against drift rather than
against a rewrite.

Git's history is the one copy an edit cannot reach. So the two guards are two walls over one room,
parting on which copy they trust, and each is blind exactly where the other looks.

## What it gates, and what it reports

| Reading | Held at |
|---|---|
| `moved` -- a resin whose bytes differ from its adding commit's blob | **zero, enforced** |
| `uncommitted` -- a resin written and not yet committed | reported |
| `commits_multi` -- a second commit touching the path | reported |
| `readded` -- a delete and a restore | reported |

Three report rather than gate, each for its own reason. A resin written this minute has no history
to disagree with, so `uncommitted` is the ordinary state of the lap that ADDS a resin, and a gate
there would red on honest work. A second commit touching a path changes no byte on its own -- a mode
change, or the rename that carries a room into a fold, which the fold law names as lawful. A re-add
is rarer still and the bytes reading already answers for it. What no lawful act produces is a resin
whose bytes part from the bytes that landed, so that is the one reading with teeth.

**The catalog is excluded by name**, and it is the living file this room holds: it gains an entry
and a seal whenever a resin lands, so its own bytes move by design. Measured `20260916`: three
commits and moved bytes for the catalog, against **one commit and unmoved bytes for all seventeen
resins**.

## The reading, and what holds it

```
room=kyri-resins  resins=17  landed=17  uncommitted=0
moved=0  commits_multi=0  readded=0  verdict=ok
```

Held by `kyri_resins_landed`, rostered at `tier lap`, so it answers at every open on every ship.

## Proven on real history rather than on a directory of files

The subject is a reading taken from git, so every pen the control builds is a **real repository with
real commits**. A plant built without history would prove the scan can count files and nothing about
the claim it exists to hold.

**42 behaviors, 0 failing.** Every refusal is shown from the failing side and then LIFTED. The
defect this guard exists for is planted outright -- a resin rewritten and resealed in one commit,
which the seal reading welcomes and this one refuses. A lawful fold is planted too, and walks free.
The detail listing's bound is proven by planting **70** resins against a ceiling of **64**, with
`detail_dropped` naming the six it dropped, which is last lap's own finding kept on touch.

**Three mutations are asserted to bite**, each a plausible edit that would leave the gate looking
healthy:

- reading the **newest** adding commit rather than the earliest, which lets an unfaithful re-add
  read `same`;
- dropping the **catalog exclusion**, which reds a healthy cellar;
- reporting the move while **exiting clean**, which is how a guard fails most quietly.

## The cost, and how it was bought down

The first working scan asked git twice per file, which walks the whole history once per file: **4.5
seconds** over seventeen resins, and the control ran **21**. That is a guard priced off the lap
clock.

It reads the history **twice** now rather than twice per file -- one `git log --diff-filter=A` and
one plain `git log`, both `--no-renames` -- then batches the object readings through one
`git cat-file --batch-check` and one `git hash-object --stdin-paths`, and joins the five files in a
single awk pass. No per-resin process runs at all.

| | Before | After |
|---|---|---|
| Scan over the real room | 4.5 s | **1.3 s** |
| Control, 42 behaviors | 21 s | **6 s** |

Both readings were taken on a pier already running a cold roster pass, so both are pessimistic.

`--no-renames` is deliberate rather than incidental: a rename then lands as a delete of the old path
and an ADD of the new one, so a resin carried into a fold has an adding commit at its new name whose
blob is the blob it always had, and the reading answers `same` rather than losing the file.

## One thing the cache taught, in the control's own pen

Reading four fields out of one cellar ran the scan four times, so the control caches a transcript
per scan run. Keyed on the repository alone, that cache answered a **lifted** plant with the
**planted** reading -- the pen is edited and re-read inside one run. The key carries the tree state
now, and the line saying so is in the control.

## What this does not reach

**A resin that was wrong when it landed.** This proves a resin stands at the bytes its own commit
put there, and says nothing about whether those bytes were right.

**A history rewrite.** A deep debride rewrites every commit, and the adding commit moves with the
file; the reading would go on answering `same`. That is correct rather than a hole -- a debride is
Keaton's own circled word, and a guard refusing it would refuse the tree's own sanctioned break.

**Every other room of testimony.** This reading is built for one cellar of seventeen files. Whether
`session-logs/`, `counsel/` or the folded shelves want the same wall is a fleet question rather than
this lane's, and the instrument takes a room argument so the answer costs a roster row.

## Grades

| Artifact | Grade |
|---|---|
| `tools/fixtures/b/kyri_resins_landed_scan.sh` | B/83 |
| `tools/b/kyri_resins_landed_witness.rish` | B/82 |
| `tools/fixtures/b/kyri_resins_landed_control.sh` | B/80 |
