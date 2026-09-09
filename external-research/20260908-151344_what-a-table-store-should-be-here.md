# What a Table Store Should Be Here

**Status:** Fossil, mixed -- superseded by [The bounds a store actually promises](20260909-035800_the-bounds-a-store-promises.md).
The elder body stays whole as testimony. The new reading corrects its claims about database
limits, typing, planner search, index cost, and the proposed reuse of vector records.

**Stamp:** `20260908.151344`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Mixed. Every figure about *this tree* is measured on this bench today and cited to the
file it was read from; every sentence about PostgreSQL, SQLite and turbopuffer is recalled from
their published documentation and is marked **recalled** where it stands, because neither binary
is installed here ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).
**Grant:** step one of grant two in
[`../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md`](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md),
booked `20260907.074815` on Keaton's word -- card row *Next, the ranked remainder*.
**Elder:** [`yonder/20260619-220012_tablecloth-tame-datastore.md`](yonder/20260619-220012_tablecloth-tame-datastore.md)
read LMDB, TigerBeetle, DuckDB, redb and Turbopuffer in June. This paper reads the two the world
actually runs, checks the grant's own falsifier against the modules as they stand today, and
answers the question the elder left open: **table or key-value, and whose lane.**

---

## What this paper claims, before the argument

**The most TAME-alignable scheme is a keyed store with declared indexes, where the caller names
the index and a planner chooses nothing** -- SQLite's storage half, its optimizer half left
behind. The reason is one sentence: a planner is an unbounded search over plans, and this tree
bounds everything at the edge and names the bound.

**Tablecloth answers a neighbouring question.** The grant's falsifier is checked in section 3 and
comes back negative, with the measurement that decides it.

**The work belongs to bakery, and it grows Mandate rather than opening a module.** Sections 6 and
7 argue both halves, and section 7 names the one condition under which a new name is right
instead.

## 1 -- What this paper bounds

Every figure about this tree was read on `20260908` on this bench, by `grep -c`, `wc -l` and
direct reading of the named file, at git nib `82281186a7`. Those figures are **free** in the Gauge
sense -- they stand free of any guard, so a later reader runs the command rather than trusting the
number.

Every claim about **PostgreSQL**, **SQLite** and **turbopuffer** is **recalled** from published
documentation and is not verified against source on this bench. That limit is measured rather than
assumed: `which sqlite3` and `which psql` both answer *no such binary* here, and `gratitude/`
holds 87 teacher pages of which none names a relational database. So this paper reads those three
systems for their **design scheme** -- what shape they chose and what that shape costs -- and
leaves every performance claim to a bench that has them installed. A paper that measured them
would be a different paper and would need a network fetch, a build, and Keaton's word.

**Nothing here implements anything.** No `.rye` file is added or changed by this round.

## 2 -- The question, in the form that decides something

The grant states it plainly and it is worth keeping in that form: *not which is best, but which
scheme is most TAME-aligned* -- bounded allocation, explicit widths, named errors, invariants a
reader can check, and one value model that stays one model.

That reframing does real work. **Best** is a question about a workload, and this tree's workload
is still ahead of it. **Most alignable** is a question about a *shape*, and a shape can be read
from documentation honestly, which is exactly what a bench holding documentation alone is able to
do.

So the readings below ask three questions of each scheme, the elder paper's own three, kept
because they held up:

1. **What are the invariants, and are they stated?**
2. **What happens at the boundary** -- an over-budget write, a malformed key, two writers?
3. **Is the design bounded** -- can a reader know, before starting, how much memory and disk it takes?

## 3 -- The falsifier, checked first

The grant names its own falsifier: *if the reading shows Tablecloth already answers what a table
store would answer, the deliverable is a page saying so and the laps are never planned.*

It answers a different question, and the measurement is short.

| Module | What it answers | Bound, as written | Read from |
|---|---|---|---|
| **Tablecloth** | one human **name** -> one content address | `max_artifacts = 32` | `brushstroke/tablecloth.rye:40` |
| **beading** (under it) | bytes -> resin, resin -> bytes | `max_store_beads = 256`, `max_bead_bytes = 256` | `mantra/beading.rye:46,54` |
| **Mandate** | a vector -> its nearest neighbours | `max_records = 64`, `max_dim = 8`, `max_k = 16` | `mandate/store.rye:36,40,41` |

Tablecloth is a **catalog over a content-addressed blob store**: 530 lines carrying 48 `assert(`
calls, binding a name to a digest and a reassembly recipe. Ask it *which artifacts carry tag
`harvest`, newest first* and it answers by walking all 32 names and opening every blob. That is
Tablecloth keeping to its own subject -- content addressing answers *is this the thing I mean*,
and it answers it beautifully. It is simply a different question from the one a table answers.

Mandate comes closer than Tablecloth does, and this matters for section 6. It already holds
**records with a tag beside the payload**, already filters a query by that tag, and already
carries the three durability organs a store needs: a snapshot (`store.rye`, 701 lines, 28
asserts), a write-ahead log (`wal.rye`, 289 lines, 8 asserts) and a named-object bucket
(`bucket.rye`, 159 lines, 2 asserts). What it still wants is a **key beyond the vector**, and an
index beside the signature it uses for nearest-neighbour.

**So the gap is real and it is narrow**: this tree finds a record by content and by nearness, and
finds one by an attribute only at the price of a full walk.

**What would falsify this section.** A module in the tree that answers an attribute query over
more than a few dozen records without a full walk. I looked, and the module that comes closest
states the answer itself. `git ls-files comlink` names seven query files; six carry a query over
the wire, and the seventh, `comlink/recall_tablecloth_query.rye`, genuinely answers one -- an
optional peer, bolt and revision filter returning every matching leaf in catalog order. Its own
opening comment gives the mechanism in one line: *a filter walked once over the bounded array,
rather than an index*. So the tree already has the attribute query, written honestly as a walk,
and what it wants is the index that would bound it.

## 4 -- Three schemes, read for shape

### SQLite -- one file, fixed pages, one writer

**The scheme.** A database is a single file divided into fixed-size pages, and every structure --
tables, indexes, the schema itself -- is a B-tree of those pages. One writer at a time; readers
see a consistent snapshot through a rollback journal or a write-ahead log.

**What to inherit, and why each is TAME.** *(recalled)*

- **The page is the unit of everything.** A fixed page size makes a file's structure arithmetic
  rather than narrative: a reader who knows the page size and the page count knows the file's
  shape without parsing it. This tree already writes this way -- Mandate's blob is `magic -
  version - dim - filled` then a **fixed-width record each**, so `max_blob_bytes` is computed at
  compile time from `off_records + max_records * record_bytes` (`mandate/store.rye:79`). The
  agreement is earned; it is what bounding at the edge looks like in a file format.
- **One writer, stated as an invariant rather than managed by cleverness.** A single-writer store
  spares itself a lock manager, a deadlock detector, and a lock-escalation heuristic -- three
  unbounded subsystems retired by one stated rule. This tree already reasons this way one room
  over: *one writer per checkout* is REDS `%291` and it is on the baton.
- **The header carries the format's own contract**, so a file refuses at the door rather than in
  the middle. Mandate's `restore` already does exactly this, refusing bad magic, wrong version, an
  out-of-bound dimension, an over-count and a truncated buffer -- five named refusals before a
  byte is trusted (`mandate/store.rye:381-395`).

**What to decline.**

- **The query planner.** SQLite chooses an index by estimating costs, and the estimate depends on
  statistics that may be stale. The consequence a TAME reader cares about concerns cost rather
  than speed: **the same query costs one thing today and another tomorrow**, so a caller names a
  bound only by luck. SQLite itself supplies the escape hatch -- `INDEXED BY` forces a chosen
  index -- which is evidence that the planner is separable from the storage engine. Declining it
  is subtraction rather than invention.
- **Dynamic typing per value.** SQLite stores a type tag per cell, so a column may hold an integer
  in one row and text in the next. That is one value model becoming several at runtime, which is
  the tangle TAME's *one value model* rule exists to prevent.
- **Unbounded growth.** A SQLite file grows until the disk stops it. A bound belongs in the
  schema.

### PostgreSQL -- heap files, MVCC, a process per connection

**The scheme.** Rows live in heap files; every update writes a **new row version** and leaves the
old one for a background vacuum to reclaim; each connection is its own operating-system process; a
cost-based planner rewrites queries against collected statistics.

**What to inherit.** *(recalled)*

- **Write-ahead logging as the durability spine**, with recovery replaying the log against a
  checkpoint. Mandate's `wal.rye` already holds this shape and holds it in the strong form: replay
  calls **the same** `upsert` and `remove` the live path used, so a recovered store is identical
  rather than approximate.
- **A catalog that is itself tables.** The schema described in the same structure as the data
  means one reader answers both. Attractive, and it costs a bootstrap problem worth naming before
  adopting.
- **Refusal at the type boundary.** A column has one type, and a value of another is rejected on
  write rather than silently coerced.

**What to decline, and this is the paper's sharpest decline.**

- **MVCC with background reclamation.** Under MVCC the disk a table occupies follows three things
  at once -- the data, the update history, and whether vacuum has kept up. A reader answering *how
  much disk does this take* therefore needs the history as well as the schema, which leaves
  question 3 open. Autovacuum is a **background process whose scheduling decides your steady
  state** -- the opposite of a bound named at the edge.
- **A process per connection.** Memory then scales with callers rather than with data. On the
  hardware this tree writes for -- *a machine a small farm can afford* -- that dependency runs
  backwards.
- **The planner**, for the reason given above, one order of magnitude more so.

The honest summary: **PostgreSQL is a superb answer to a question this tree leaves to others.** It
is built to serve many concurrent unpredictable callers over data of unknown shape. This tree
serves a household's own records, of a shape it declares.

### turbopuffer -- object storage as the durable tier

**The scheme.** *(recalled)* Durable state lives in object storage as written-once objects;
compute nodes are stateless and hydrate from those objects into local cache; a namespace is a unit
that can be pulled whole.

**What to inherit -- and what this tree already inherited.** Mandate's README names turbopuffer as
its teacher and the borrowing is structural rather than admiring: the whole store serializes to
**one portable blob**, so a fresh node hydrates by a single read, and `bucket.rye` makes that blob
a named object among many in a directory. **Object names are validated path-safe before use** -- 1
to `max_name` bytes of `[a-zA-Z0-9_-]`, no slash, no dot, no separator -- so a `get` can never
climb out of its directory. That is a boundary refusal in the exact place a store usually grows a
security red.

**What to decline.** The elasticity argument. Stateless compute over object storage earns its keep
when node count varies with load; a household server has one node, and paying object-storage
latency per query to buy elasticity a single node leaves idle is a poor trade. **Keep the shape**
-- a store that is one portable object -- and decline the deployment model it was invented for.

### The three, side by side

| | Invariants stated | Boundary behavior | Bounded before you start |
|---|---|---|---|
| **SQLite** | strong -- format is arithmetic | good -- header refuses; planner does not refuse, it guesses | **no** -- grows to the disk |
| **PostgreSQL** | strong at the type edge | good on write, deferred on space | **no** -- disk is a function of history |
| **turbopuffer** | object is written once | good -- an object is whole or absent | **partly** -- per object, yes |
| **the scheme proposed here** | format is arithmetic | every edge refuses by name | **yes** -- capacity is a declared constant |

## 5 -- Table or key-value

The grant asks this directly and names it a real alternative rather than a rhetorical one. Here is
the argument, and it ends somewhere between the two.

**What a table buys beyond a key-value store** is exactly one thing: **finding a record by
something other than its key.** Everything else people attribute to tables -- typed columns,
constraints, a schema -- is available to a key-value store whose values are typed records, and
this tree already has typed records with a fixed-width serialization.

**What that one thing costs, in the general form, is unbounded.** *Find by anything* means the
store must decide *how* to find, which is a planner, which is unbounded. So the general table is
declined on the same grounds PostgreSQL's planner is refused.

**The middle is where the answer lives.** Take the one thing a table buys and pay for it
explicitly:

> **A keyed store with declared indexes, where the caller names the index.** Records are found by
> key. Any *other* way of finding a record is an **index declared in the schema**, named by the
> caller at the call site. A query that leaves the index unnamed is a full walk, and it says so.

Read that against TAME's own list and every line answers:

- **Bounded allocation.** Each index is a declared structure with a declared capacity, so the
  store's total footprint is `sum(declared capacities)` -- computable at compile time, exactly as
  `max_blob_bytes` already is.
- **Named errors.** *This index is undeclared* is a refusal at the call site, where a planner
  would have silently chosen a full walk.
- **Invariants a reader can check.** *Every declared index covers every record* is one loop and
  one assert, and it is checkable after every mutation.
- **One value model.** A record is a record; an index holds keys and record positions and only
  those.
- **A fixed cost per call.** The caller names the index, so the caller knows the cost. This is the
  property both PostgreSQL and SQLite give away, and it is the one a bounded system most needs.

**The honest cost, stated rather than hidden.** A caller must know which index to use, and adding
a new way to search means changing the schema and rebuilding an index rather than writing a new
`WHERE` clause. For a store serving a declared set of records -- a household's own -- that cost is
paid once per question, by the person who knows the data. For an ad-hoc analytics surface it would
be intolerable, and this tree is building something else.

**So: the middle, precisely.** A table store carries the planner along with it; a bare key-value
store leaves out the one thing a table buys, which is the thing actually needed. **A keyed store
with declared indexes** is the name of the middle, and it is the recommendation.

## 6 -- Where it lives: the happy zone and the thin edge

Read through the Water row's fixed seat
([`../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md`](../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md)),
a store divides cleanly, and the division is the design:

**The happy zone -- pure, bounded, proven by fast isolated witnesses.** The record shape and its
fixed-width serialization; the index structures and their maintenance; every refusal; the snapshot
and restore round-trip; the write-ahead log and its replay. All of it is bytes-in, bytes-out, and
all of it can be proven with the filesystem left alone. Mandate already demonstrates this is
achievable rather than aspirational: its snapshot round-trip, its five restore refusals and its
WAL replay-equals-live proof are all pure.

**The thin edge -- where only the world can tell the truth.** Exactly two seams: **write these
bytes to this path** and **read the bytes at this path**. Everything else in a store is arithmetic
over bytes. Mandate has already drawn its edge this thin, and proven it on metal in both places --
`prove_file_backing` writes a real blob to a real file and reads it back identical, and the WAL is
replayed from real files.

**The reading that follows.** A store whose edge is two calls wide can hold nearly all of itself
in the happy zone, which is why the elder paper's LMDB admiration needs one qualification: memory
mapping is *fast*, and it makes the edge wide, because a page fault anywhere is now a seam to the
world. Explicit read and write calls are slower and keep the edge thin. Under TAME's order --
safety first, performance second -- the thin edge wins until a measurement forces the trade, and
that measurement is still ahead of us.

## 7 -- Whose lane, and what it is called

The grant requires this be named rather than left open.

**The owner is bakery.** The roster gives bakery *core infrastructure* and copal *the resins --
vessels, sealing, and what a record keeps when it is put away*. A keyed store with indexes is
infrastructure a household's applications call; a resin is a sealed vessel and its custody. The
distinction that decides it: **copal owns what a record keeps when it is put away, and this
store's subject is what a record answers while it is out.** Where the two meet -- a store's
snapshot sealed for archive -- is copal's, and the handoff is one function boundary rather than a
shared module.

**It grows Mandate rather than opening a module.** Three measured reasons:

1. **The durability organs already exist and are proven.** Snapshot, WAL and bucket are 1,149 lines
carrying 38 asserts between them, each with its own `prove_` routine. A new module would rewrite
all three, and rewriting a proven thing to gain a name is the trade Lindy-first refuses.
2. **The record shape is already right.** Mandate holds `id - tag - payload` at fixed width. A keyed
store needs `key - tag - payload` at fixed width. That is a widening of what a key may be, rather
than a new data model.
3. **The one genuinely new part is small and separable**: a declared index over the tag, and a lookup
that uses it. Mandate's SimHash signature index is already an index maintained on upsert, so the
maintenance discipline is present and has a shape to copy.

**The name, and the condition.** Under the Comlink tendency a new name is the exception that must
justify itself, and here it stays unspent: an aspect of Mandate wants the word it already has.
**If** the store later grows past Mandate's subject -- if the vector half becomes the smaller half
-- then the aspect earns its own name, and **Pantry** is the candidate this paper puts on the
table: a place where things go in labelled and come out found, clear to a newcomer, warm to say,
and checked against the tree today -- one prose mention in a 2026-07 bandwidth paper, free of any
module or seated term. Checked `20260908`; check again before speaking it twice.

## 8 -- What would kill each claim

Gauge asks for the falsifier in plain words, so here they are, one per claim, in the order the
claims were made.

- **"The planner is the part to decline."** Killed by a measurement showing that a fixed,
  planner-free index choice costs materially more than a planned one on a workload this tree
  actually runs. That measurement needs a workload, and this tree's is still ahead; **confidence
  high** that the reasoning holds for a declared-schema household store, **low** that it would
  hold for an ad-hoc query surface.
- **"Tablecloth answers a neighbouring question."** Killed by an attribute query answered over the
  catalog without a full walk. Checked today at 32 artifacts; **confidence high**, and the check
  is one `grep` deep so any reader can repeat it.
- **"It grows Mandate."** Killed if widening the key breaks the vector path's invariants -- most
  plausibly if a variable-width key breaks the fixed-width record that `max_blob_bytes` is
  computed from. **Confidence medium**, and this is the first thing an implementation lap should
  test, because it is the cheapest way to learn the recommendation missed.
- **"Bakery rather than copal."** Killed by Keaton's word, which outranks a roster reading.
  **Confidence medium-high** on the roster's own text.
- **"The thin edge beats the memory map."** Killed by a measurement on this tree's own hardware
  where the explicit-call path costs enough to change what the household machine can do.
  [`20260906-042838_the-table-that-fits.md`](20260906-042838_the-table-that-fits.md) already
  measured the instrument that would answer it -- 1.65 ns for a dependent read that fits the first
  cache against 163.20 ns for one that overflows it, on that bench, on `20260906` -- so the
  experiment has a shape. **Confidence medium**; this is the claim most likely to move.

**Horizon for all of the above: one chapter.** Nothing here depends on a fact that changes weekly;
the modules it reads are stable and the systems it recalls are decades old. Re-read it when a
workload exists, because a workload is what turns most of these from readings into measurements.

## 9 -- Where this paper stops

**Any performance number for SQLite, PostgreSQL or turbopuffer.** Neither binary is here and no
benchmark was run.

**A schema language.** *How* an index is declared -- in Brix, in Bron, or in Rye source -- is a
real design question and it is the next paper rather than a paragraph in this one.

**Concurrency past one writer.** The single-writer invariant is inherited without argument,
because this tree already holds it one room over and no reading here challenged it.

**The plan.** The grant's step three asks for laps counted in fives and fifteens, unified with the
ranked remainder. That waits on step two -- the silo into `active-designing/` under our own names
-- which is the next lap in this lane and is deliberately kept separate: external research studies
the world with attribution, and design names only what is ours.

---

*A store earns its place by what it refuses. May this one refuse plainly, at the door, by name.*
