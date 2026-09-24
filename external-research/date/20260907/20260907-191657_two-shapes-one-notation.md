# Two Shapes, One Notation -- what the tree's own records say a store should be

**Stamp:** `20260907.191657`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Mixed. The shape census is checkable and its refusals are proven; every sentence
comparing candidate stores is a documentation reading rather than a measurement, and says so
where it stands ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).
**Grant:** step one of the table-store grant booked `20260907.074815` --
[`../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md`](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md)
**Instrument:** [`../tools/fixtures/s/store_shape_census.sh`](../tools/fixtures/s/store_shape_census.sh),
proven by [`../tools/fixtures/s/store_shape_control.sh`](../tools/fixtures/s/store_shape_control.sh),
bound by [`../tools/s/store_shape_witness.rish`](../tools/s/store_shape_witness.rish)

---

## What this paper claims, before the argument

**The tree keeps two data shapes in one notation, and a store fitted to either one is wrong for
the other.** Measured on `20260907` over the tree's own tracked records: the journal holds
**4,337 records**, and **3,956 of them -- 91 percent -- carry at least one field more than once**.
The four named registries hold **413 rows between them**, and **zero** carry a field twice.

Those two readings come from one census over one notation. Kyri notation leaves the kind of a file
to its reader, who infers it; this census is the first thing in the tree to count it.

**So the deliverable the grant asked for is a name rather than a ranking.** What the journal wants
is a **key-value store keyed by content**, because 91 percent of its records would need a
side table under any single-valued schema. What the registries want is **no store at all**: 413
rows fit in a processor's first cache with room to spare, which the sibling paper
[`20260906-042838_the-table-that-fits.md`](20260906-042838_the-table-that-fits.md) measures at
**1.65 ns** per dependent read on this board against **163.20 ns** once a structure leaves cache.

---

## What was measured, and how it refuses

The census reads exactly one thing -- **field names at line start** -- across two populations it
takes as an argument rather than guessing:

- **journal** -- one record per file. Every session log is one record; the population is the room.
- **registry** -- one table per file, rows delimited by a repeating lead key (`guard `, `seat `).

Measured `20260907.191257` on the Dallas pier, 153 s wall:

| Reading | Journal | Registries |
|---|---|---|
| Records or rows | 4,337 | 413 |
| Distinct field names | 81 | 7, 7, 1, 1 by file |
| Dense core (at or above 90 percent) | 12 | 3, 6, 1, 1 |
| Sparse tail (under 1 percent) | 52 | -- |
| Fields seen exactly once | 22 | -- |
| Records carrying a repeated field | **3,956 (91 pct)** | **0 (0 pct)** |
| Widest repetition seen | `file`, 51 times in one record | none |
| Lines the reading passed over | 276 | -- |

**The blind spot is printed rather than left in prose.** `journal_unread_lines=276` counts every
line the anchored pattern passed over, so the reading's own reach is a number a reader can check.
Three things stay outside its reach: whether two fields under different names mean one thing,
whether a field holds a list crammed onto one line, and whether two records disagree about what a
field's value means.

**The instrument refuses seven ways and each refusal is proven from both sides.** The control
builds record sets of a known shape in a throwaway pen, reads them, moves one line, and watches the
answer move -- then lifts the plant and requires the original reading back. Twenty-two behaviors,
zero faults, 5.3 s. Two of them are load-bearing:

- **The verdict flips on data.** A journal with no repeated field reads `one_shape`; a registry
  given one repeated field in one row reads `one_shape` too. A verdict that never moves is a
  printed constant.
- **The anchored field pattern inverts the finding when loosened.** Counting every line as a
  column makes a row carrying two `#` notes read as multi-valued, which over the real
  `construction/standing-equipment.kyri` is **108 of 235 rows** -- enough to report the registries
  as document-shaped and stand this paper's conclusion on its head.

The witness holds the **separation** rather than any count, since every count here grows daily and
a guard that reds on ordinary writing is a guard somebody turns off. Its floor is 50 percent, where
"mostly" stops meaning mostly; its registry bound is zero, because a registry row gaining a second
copy of one field is a table becoming a document.

---

## What the two shapes are, said plainly

**Observation.** The journal's dense core is **12 fields of 81**, and its tail is long: 52 fields
appear in under 1 percent of records and 22 appear exactly once. The registries invert this --
`construction/fleet-roster.kyri` carries 7 columns of which 6 stand in every row.

**Inference.** A record set with a small dense core, a long sparse tail, and repeated fields is
what the database literature calls document-shaped or log-shaped. A record set whose columns nearly
all stand in every row is table-shaped. These two populations stand as far apart as a record set can
on both readings at once, which is why each wants a scheme of its own.

**Inference, sharper.** The repetition is deliberate. `file`, `think`, `obs`, and `loom` repeat
by design -- the session-log law asks for one `file` line per path touched, and one record reached
**51** of them. A single-valued schema would move those into a child table and turn one record's
read into a join, which is the cost the shape is telling us about.

---

## The candidates, read from documentation rather than measured

**Bound first: this section is a reading rather than a measurement.** This pier holds neither
PostgreSQL nor SQLite -- `command -v psql` and `command -v sqlite3` both answer empty on
`20260907` -- and turbopuffer is a hosted service whose copy lives elsewhere. So every sentence here is a reading of
each project's own public documentation, and a later lap that installs one of them may correct it.
Confidence: **moderate** on the structural claims, which are stable and widely documented; **low**
on performance, which stays unrun here.

The question the grant asks is **which scheme is most TAME-aligned** -- bounded allocation,
explicit widths, named errors, invariants a reader can check, one value model.

**SQLite** is the closest of the three, and it is close for reasons a Rye author recognizes. It
ships as a single translation unit with a documented ceiling on every dimension it grows in --
the `SQLITE_MAX_*` compile-time limits name a maximum for column count, statement length, attached
databases, and the rest -- which is *bound everything, name the max* stated in another language.
It returns named integer result codes rather than raising, which is the shape of a Rye `try` over
a named error set. Its whole state is one file, so what a record keeps when it is put away is
answerable by looking.

**PostgreSQL** carries one idea this tree already has a word for: **memory contexts**, where an
allocation belongs to a context that is reset wholesale rather than freed piecemeal. That is the
season allocator, `garden` over `init.arena`, arrived at independently by both projects. Against
it stands the shape of the thing: a client-server system with a process per connection, a
write-ahead log, and a planner whose cost model is a runtime judgment rather than a stated bound.
A planner decides where TAME asks for *say why beside the number*, and it keeps its
reasons to itself.

**turbopuffer**, read from its published architecture page (fetched `20260907`), stores each
namespace as a prefix in object storage, makes writes durable through a write-ahead log directory,
and caches on NVMe after first query. Its own published figures: **p50 165 ms** write latency for
a 500 kB payload, **p50 874 ms** for a cold query over 1M documents, **p50 14 ms** cached.
Those are honest numbers for a network service, and they are three to five orders of magnitude
above the 1.65 ns a cached lookup costs here -- which is the point rather than a criticism. Its
lesson for this tree is architectural: **cold and warm are different systems wearing one name**,
and a store that names which one answered has told you what it cost.

---

## The recommendation, and whose lane it is

**A key-value store keyed by content, for the journal.** Two facts point at it together. The
journal is 91 percent multi-valued, so a table refuses it; and the tree already addresses by
content through **Tablecloth**, where the same bytes answer to the same name from any room. A
content-addressed key-value store is Tablecloth's own shape with an index over it.

**No store for the registries.** 413 rows across four files, read by scan, is a table that fits
the first cache. Adding a store here buys a query language and spends the one property those files
have that no database gives back: a human reads them, and `git log` says who changed a row and why.

**The falsifier the grant named, answered.** The grant said: *if the reading shows Tablecloth
already answers what a table store would answer, the deliverable is a page saying so and the laps
are never planned.* It answers **half**. Tablecloth answers *give me these bytes by their name*.
It stays silent on *give me every record whose `voice` field reads Kyri*, which is the query the
journal's 81 field names invite and which nothing in this tree answers today without a full walk --
153 s of one, measured above. **So a store is worth planning, and it is an index rather than a
database.**

**Whose lane.** The grant asks the proposal to name an owner rather than leave it open. **Copal**
holds the resins -- vessels, sealing, and what a record keeps when it is put away -- and an index
over content-addressed records is exactly that room. **Bakery** holds core infrastructure and owns
the modules this would sit beside. The honest split: **copal owns the store's shape and its
sealing; bakery owns wherever it is called from.** Naming one owner for both halves would put a
seam inside one seat.

---

## Falsifiers, horizon, and confidence

**The falsifier that would kill the central claim, and it is cheap.** Run the census against a
journal population from a single month rather than the whole room. If the multi-valued share falls
under 50 percent on recent records, the repetition is a habit of the elder logs rather than a
property of the notation, and the whole recommendation weakens to *the old records are
document-shaped*. Horizon: one lap. Confidence the claim survives: **high** -- the repeated fields
are asked for by a living law rather than left over from one.

**The second falsifier, aimed at the recommendation rather than the reading.** Count the queries
the tree's own tools actually ask of the journal. This paper measured the **data** alone and left the
**queries** for another lap, which is a real gap and is named here rather than papered over. If nearly every tool
asks *the newest N records* and nearly none asks a field predicate, then a sorted room is worth more
than an index, and the plan shrinks to that. Horizon: one lap, over `tools/`.

**Projection, stated as one.** If the tree keeps writing roughly a hundred records a day, the
journal reaches **8,192** -- the census's own named ceiling -- in about **38 days** from
`20260907`, and a full walk that costs 153 s today costs roughly **290 s** then. Assumptions: the
rate holds, and the walk stays linear in records. The falsifier is the ceiling itself, which
refuses rather than truncating, so the tree is told rather than surprised.

## What this does not reach

**Whether any of the three candidates would actually run well here**, since none of them was run.
**What the store should be named** -- the Comlink tendency asks for the clearest, warmest, safest
word, checked against the tree before it is spoken twice, and a name chosen inside a research
paper is a name chosen by whoever happened to be writing.
**The laps.** Step two silos this reading under our own module names; step three lays the work out
Lindy-first and crux-first. Both wait on this page being read.
