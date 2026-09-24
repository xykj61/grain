# The Bounds a Store Actually Promises

**Stamp:** 20260909.035800
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Living, mixed -- observations from sources and a local refusal probe; the design remains proposed.
**Grant:** [The table-store reading](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md), step one.
**Elder:** [What a table store should be here](20260908-151344_what-a-table-store-should-be-here.md).
**Scope:** Read on 2026-09-09. Documentation describes capabilities; the probe below describes one installed library.

A store earns an index when a real query needs it. The first question is which work must finish
inside which budget. A bounded scan can answer that question; a declared index can answer it too.
The choice needs the cost of reads, writes, and recovery together.

The elder preferred a keyed store with caller-named indexes. That remains a useful candidate.
Its reasons need repair: SQLite has explicit limits, a planner can bound its search, and naming
an index alone gives neither constant work nor a time guarantee. This revision replaces those
claims before they enter the design room.

## The field, checked against its own documents

**Observation -- SQLite.** Its limits documentation describes configurable ceilings for values,
statements, columns, and database pages. Crossing the page ceiling refuses an insert with
`SQLITE_FULL`. The claim that it can grow only until the disk stops it is therefore withdrawn.
These are application controls whose settings still need review.
[SQLite limits](https://www.sqlite.org/limits.html).

**Observation -- SQLite types.** STRICT tables constrain column types while allowing lossless
conversion; an ANY column deliberately accepts different types. STRICT is an available choice,
so flexible typing is not an unavoidable property of every SQLite table.
[STRICT tables](https://www.sqlite.org/stricttables.html).

**Observation -- SQLite planning.** Its next-generation planner retains a limited set of candidate
paths. `INDEXED BY` requires a named index and fails preparation if that index is unavailable or
unusable. SQLite documents that clause as a regression safeguard, used late in development.
A planner can make a bounded choice.
[Planner](https://www.sqlite.org/queryplanner-ng.html),
[index requirement](https://www.sqlite.org/lang_indexedby.html).

**Inference.** A caller-named index makes an access path explicit. The cost still depends on the
number of entries visited, matches returned, bytes compared, and any remaining sorting or joins.
A stable choice of index and a bounded amount of work are separate promises. A wall-clock bound
also needs assumptions about scheduling and storage.

**Observation -- SQLite's remaining boundaries.** A database-page limit covers the main database,
rather than every byte used by a process. Its WAL documentation describes checkpoint starvation
and large transactions as causes of log growth. Its progress callback can interrupt work, and its
hard heap limit governs accounted SQLite heap allocations across connections in a process.
[WAL](https://www.sqlite.org/wal.html),
[progress callback](https://www.sqlite.org/c3ref/progress_handler.html),
[heap limit](https://www.sqlite.org/c3ref/hard_heap_limit64.html).

**Inference.** Those controls deserve a composed test: database, log, temporary space, memory,
busy waits, and application buffers each need a budget. An in-memory page-limit probe proves
one boundary. It cannot establish disk durability or a deadline.

**Observation -- PostgreSQL.** Its resource settings distinguish memory for query operations,
maintenance, and temporary files. The documentation warns that several operations and sessions
may each use their own memory allowance. Thus a per-operation setting is not a whole-server cap.
[Resource settings](https://www.postgresql.org/docs/current/runtime-config-resource.html).

**Inference.** A service with concurrent callers needs an aggregate admission budget. That is a
cost to account for, rather than evidence that a relational store is inherently unbounded.
This lap runs no PostgreSQL workload and ranks no implementation by speed.

**Observation -- turbopuffer.** Its documentation separates durable object storage from cache,
describes asynchronous indexing after log commitment, and keeps recent unindexed data searchable.
It also describes small ranged reads that can serve a cold query without loading a whole namespace.
[Architecture](https://turbopuffer.com/docs/architecture),
[concepts](https://turbopuffer.com/docs/concepts).

**Inference.** Portable durable state and disposable derived indexes are useful ideas to carry
forward. They do not imply that a whole database must arrive as one blob, or that every query
pays a full reload. This lap runs no hosted workload and makes no latency or cost comparison.

## A small refusal probe, with its limits visible

On 2026-09-09, the Python binding on this bench reported SQLite version `3.51.2`.
The probe uses one in-memory connection, a ceiling of **4 pages**, and **4,096 bytes per page**.
That is **16,384 bytes of main-database capacity**, by multiplication; it is not a process-memory
measurement. The source for each result is the executable probe below.

The wrong-type insert returned extended error code **3091**. The oversized **65,536-byte** value
returned `SQLITE_FULL`, error code **13**. The earlier committed **100-byte** value remained.
The named index returned that row; an absent index refused; the integrity check returned `ok`.
All **6 behavioral checks** passed. The final database occupied **3 pages**.

Run this block with `python3`. It writes no database file and needs a binding with STRICT support.
The numeric datatype code is checked directly because this binding labels that extended code
`unknown`; the code and the label are separate readings.

```python
import sqlite3

db = sqlite3.connect(":memory:")
print("sqlite_version", sqlite3.sqlite_version)
db.execute("pragma page_size=4096")
assert db.execute("pragma max_page_count=4").fetchone()[0] == 4
db.execute("create table entry(k integer primary key,v blob) strict")
passed = 0

try:
    db.execute("insert into entry values(1,'text')")
except sqlite3.IntegrityError as exc:
    assert exc.sqlite_errorcode == 3091
    passed += 1
else:
    raise AssertionError("wrong type admitted")

db.execute("insert into entry values(1,zeroblob(100))")
db.commit()
try:
    db.execute("insert into entry values(2,zeroblob(65536))")
except sqlite3.DatabaseError as exc:
    assert exc.sqlite_errorcode == sqlite3.SQLITE_FULL
    passed += 1
else:
    raise AssertionError("over-budget insert admitted")

assert db.execute("select count(*) from entry").fetchone()[0] == 1
passed += 1
db.execute("create index entry_v on entry(v)")
assert db.execute(
    "select k from entry indexed by entry_v where v=?", (bytes(100),)
).fetchall() == [(1,)]
passed += 1
try:
    db.execute("select k from entry indexed by missing where v=?", (bytes(100),))
except sqlite3.OperationalError as exc:
    assert str(exc) == "no such index: missing"
    passed += 1
else:
    raise AssertionError("missing index admitted")
assert db.execute("pragma integrity_check").fetchone()[0] == "ok"
passed += 1
print("checks_passed", passed)
print("page_count", db.execute("pragma page_count").fetchone()[0])
print("page_size_bytes", db.execute("pragma page_size").fetchone()[0])
db.close()
```

This is a reproducible boundary witness, rather than a benchmark. Its falsifier is any asserted
condition failing on the named library and setup. A different version earns its own receipt.
Confidence is high in the recorded run and limited to these operations.

## What the tree already offers

The following observations come from source at Git nib `9230cb0f0e`, read on 2026-09-09.
They describe declarations and algorithms, rather than a new runtime proof.

| Surface | Observed contract | Source |
|---|---|---|
| Tablecloth catalog | Capacity of 32 artifacts; names bind content addresses | [tablecloth](../brushstroke/tablecloth.rye) |
| Tablecloth attribute query | One pass over the catalog; output overflow is a named error | [query](../comlink/recall_tablecloth_query.rye) |
| Mandate records | Capacity of 64 records; numeric identity, tag, signature, and normalized vector | [store](../mandate/store.rye) |
| Mandate mutation log | Capacity of 256 entries; replay calls the vector store's mutations | [log](../mandate/wal.rye) |

**Inference.** The Tablecloth query is already bounded by its catalog. An index might lower its
cost, but a full scan is not proof that the grant's reuse option has failed. The workload must
supply the missing distinction: does the existing operation exceed an agreed budget?

**Inference.** Mandate offers useful patterns for a fixed representation and replay. Its payload
is specifically a vector, and replay normalizes it. An exact-record store cannot assume that
arbitrary bytes fit that contract. Reuse must preserve existing vector semantics and prove
exact recovery for the proposed record type.

The [earlier journal study](20260907-201914_the-workload-and-the-index.md) already found a case
where the query mix did not justify an index. That dated result is a reason to repeat its method,
rather than a claim about today's workload.

## The handoff to Bakery

**Proposed, for the next workload experiment.** Bakery owns the implementation candidate under
the grant; Diffuser owns this reading. First name a real caller, its record shape, maximum live
rows, result budget, mutation rate, recovery requirement, and storage tier. Compare the current
bounded scan with a derived index on that same input.

Keep the simplest version that meets the agreed budgets. Measure comparisons or entries visited,
peak bytes, bytes rewritten per mutation, and recovery work. Report elapsed time separately,
with the machine and conditions. An index earns its extra representation only when its whole
cost improves the workload that needs it.

**Horizon:** the next measured workload experiment, before a storage implementation plan.
**Assumptions:** a finite record cap, declared query shapes, and one writer for the first experiment.
**Falsifier:** the current scan meets every agreed budget, or index maintenance and recovery exceed
them. Either result closes the case for that index.
**Confidence:** high in testing the contract first; uncertain about which implementation wins.

The grant's silo and plan remain booked. The clean-room design should carry these distinctions:
capacity versus time, primary records versus derived indexes, and successful replay versus
durable publication. Module naming stays at its existing ruling. This lap hands Bakery a testable
decision, with the storage build still conditional on its result.

Thanks to the SQLite, PostgreSQL, and turbopuffer maintainers for public explanations that a reader can check.

