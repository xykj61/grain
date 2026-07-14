# 975 · Tablecloth — A TAME-Aligned Datastore: Close Reading of the Field

*What would a datastore look like if it were designed in the TAME order — correctness first, performance second, joy third? This research reads five stores that each push one or more of those properties hard: LMDB, TigerBeetle, DuckDB, redb, and Turbopuffer. The goal is concrete: distill what each does well that Tablecloth should inherit, and name what each does that Tablecloth should decline.*

**Language:** EN
**Version:** `20260619.220012` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy

---

## The Design Space

A datastore answers one question: given a key, what is the value? Everything else is a consequence of how that question is answered — whether by a file page, a hash table, a B-tree, a log, or a sorted string table. The space of answers is large; the TAME lens narrows it to three questions of its own:

1. **What are the invariants, and are they stated?** A store that keeps its promises about durability, ordering, and transactional safety has stated invariants; one that silently corrupts on a write has not.
2. **What happens at the boundary?** When a write exceeds a budget, when a key is malformed, when two writers race — does the store name the failure loudly, or does it corrupt in place?
3. **Is the design bounded?** Can a user know, before they start, how much memory and disk the store will use? Or does it grow without a stated limit?

---

## LMDB — Lightning Memory-Mapped Database

*Written by Howard Chu. Extremely fast reads. Copy-on-write B-tree. Memory-mapped files.*

**What it does right (TAME-aligned):**
- **Zero copy reads.** The map is the data; a read returns a pointer into the mmap, not a copy. Fast because it is simple.
- **Readers never block writers; writers never block readers.** This invariant is stated and held by construction: the copy-on-write tree ensures a reader always sees a consistent snapshot.
- **One writer at a time.** A hard constraint, not a soft advisory. The lock is explicit and the semantics are clear.
- **Write once per key per transaction.** LMDB's design precludes phantom writes; what you committed, you keep.

**What it does that Tablecloth should decline:**
- **No content-addressing.** Keys are arbitrary bytes; the store makes no claim about the relationship between a key and its value. Tablecloth names values by their content hash — that identity guarantee is Tablecloth's whole point.
- **No hard memory bound.** The mmap grows to fit the database. A bound is declared at open time and can be exceeded with a remap. Tablecloth should enforce a hard ceiling, named at initialization.

**Lesson:** The zero-copy, single-writer, copy-on-write design is elegant and correct. LMDB's discipline of "state the constraint in the API" is a model. Its weakness is the unconstrained mmap growth and the absence of content-identity.

---

## TigerBeetle — A Database for Financial Accounting

*Written by Joran Dirk Greef and contributors. Designed for exactly-once debit/credit accounting. Deterministic, verified, formally constrained.*

**What it does right (TAME-aligned):**
- **All invariants are stated and enforced.** Every account, every transfer has a type; the type system prevents a debit-only account from being credited. The database refuses invalid operations loudly — no silent corruption.
- **Explicit, bounded writes.** Batch size is bounded; no operation grows without limit.
- **Deterministic replay.** The state of the database at any point is fully determined by its input log. Audit is not an afterthought; it is the primary structure.
- **No general-purpose queries.** By refusing to be general, it stays fast, correct, and auditable. A narrow surface is a safe surface.
- **Designed for storage fault tolerance.** TigerBeetle assumes disks fail; it uses a two-phase write and verifies checksums. Every write is known to have landed.

**What it does that Tablecloth should consider carefully:**
- **Tightly coupled to a single domain (accounting).** The discipline is admirable; the scope is narrow. Tablecloth is a general-purpose content-addressed store — it should inherit the discipline, not the accounting schema.
- **No content-addressing.** Identity is assigned by the caller, not derived from content. Tablecloth derives identity from the SHA3-256 digest; content-naming makes the store self-verifying.

**Lesson:** TigerBeetle proves that a narrower interface, stated invariants, and explicit bounds produce a faster and more trustworthy store than a general one. Its fault-tolerance design (two-phase write, checksum on every record) is directly applicable to Tablecloth's durability contract.

---

## DuckDB — An Analytical In-Process Database

*Columnar, in-process, OLAP. Designed to run in a single process, analyzing data without a server.*

**What it does right (TAME-aligned):**
- **In-process, no server.** The complexity of a client-server protocol and a separate server process disappears. Tablecloth is similarly in-process: a module called directly, not a service.
- **Query over structured values.** DuckDB's strength is reading structured data without schema migration penalties. For Tablecloth, this suggests: structured metadata (content hash, size, timestamp, tags) should be first-class and queryable.
- **Vectorized execution is fast without being magic.** The speed comes from a clear design decision (column-oriented storage, SIMD-friendly layout) rather than hidden cleverness.

**What it does that Tablecloth should decline:**
- **SQL is a large surface.** DuckDB accepts arbitrary SQL; Tablecloth's interface should be narrower: `get(hash) → blob` and `put(blob) → hash`. Narrow surfaces are safe surfaces.
- **No content-addressing.** Tables are mutable; a value can be changed after being stored. Tablecloth is write-once.

**Lesson:** The in-process, no-server architecture is right for Tablecloth. Structured metadata over stored values — type, size, hash, and user-defined tags alongside the raw blob — is worth building from the start.

---

## redb — A ACID-Compliant Embedded Database in Rust

*Written by Christopher Berner. Pure Rust, no unsafe dependencies in the core. MVCC, B-tree, copy-on-write.*

**What it does right (TAME-aligned):**
- **No unsafe in the critical path.** redb's design constraints mirror TAME's: safety is structural, not relying on programmer vigilance.
- **Explicit transactions.** Every read and write happens inside a transaction. There is no accidental concurrent write; the type system enforces it.
- **Crash-safe by design.** Two-phase commit; the durability guarantee is explicit and testable.
- **Single writer, multiple readers.** Like LMDB, with a cleaner type-level enforcement.

**What it does that Tablecloth should adapt:**
- **Type-parameterized keys and values.** redb's generics allow typed keys and values — a direct model for Tablecloth's typed blob metadata (hash type, size type).

**Lesson:** redb proves that a safe-by-design embedded database is achievable and fast. Its type-level transaction enforcement is the right model for Tablecloth's API.

---

## Turbopuffer — An Embedded Vector Database

*Written in Rust. Designed for simplicity and speed over a narrowly scoped problem: vector similarity search over a small-to-medium collection.*

**What it does right (TAME-aligned):**
- **Extreme simplicity.** The API is: insert vectors, query by similarity, delete. The surface is narrow enough to understand in an afternoon.
- **Written to run fast without special hardware.** Turbopuffer's performance comes from a well-designed data layout and cache-friendly access, not from GPU offload or distributed complexity.
- **Embeddable.** No server, no configuration file, no daemon. Exactly right for Tablecloth's role as a module, not a service.

**What it does that Tablecloth should note:**
- **Vector-specific, not general.** The similarity-search model doesn't directly apply; the *embeddability* and *narrow surface* principles apply directly.
- **No content-addressing.** Turbopuffer's identity model is caller-assigned. Tablecloth derives identity from content.

**Lesson:** The extreme simplicity of Turbopuffer's API is a target for Tablecloth. A store that can be understood in an afternoon is one that can be trusted in a system.

---

## What Tablecloth Should Inherit

From the close reading, five principles emerge:

**1. Write-once, content-addressed identity.** A blob is named by its SHA3-256 digest. A name is a promise: the bytes behind it will never change. This is stronger than any of the stores above — it makes the store self-verifying. (Mantra's `.mantra/blobs/` already works this way.)

**2. Hard, stated bounds.** At construction, Tablecloth knows its memory budget and its disk budget. A write that would exceed the budget fails with a named error, not a silent growth. LMDB's unconstrained mmap is the failure mode to avoid.

**3. Write-once ACID.** A blob is written in one transaction; if the transaction completes, the blob is durable. If it does not complete, nothing is stored. TigerBeetle's two-phase write is the model.

**4. Single writer, MVCC reads.** One writer at a time; readers see a consistent snapshot. LMDB and redb prove this is achievable without a server. The type system enforces it.

**5. Narrow API.** `put(blob) → hash` and `get(hash) → blob?` are the two operations. Metadata (size, type tag, write timestamp) is a third query. Nothing else.

---

## What Tablecloth Should Decline

- **Mutable values.** Content-addressed storage makes mutation incoherent — if the content changes, the name changes. The store never updates; it only accretes. An old version stays, under its old name.
- **Unbounded growth.** A store with no ceiling is a store that will one day fill a disk without warning. State the ceiling at construction; enforce it at write.
- **A server process.** Tablecloth is a module, not a service. It is called in-process, from Rye.
- **SQL or a query language.** The surface is `get`, `put`, and metadata query. Narrowness is safety.

---

## Relation to Brix

Tablecloth stores; Brix composes. A `.brix` descriptor names the bricks a system is made of. A full Brix build:

1. For each brick: hash the inputs.
2. Ask Tablecloth: "do you have a blob named by this hash?"
3. If yes: done. If no: build, `put` the result, proceed.

Tablecloth is Brix's substrate: it provides the content-addressed storage that makes a Brix build reproducible. Tablecloth's API is narrow so that Brix's dependency on it is narrow.

---

## Sources

- **LMDB**: Howard Chu, "LMDB Technical Summary", symas.com/lmdb. Copy-on-write B-tree, memory-mapped files.
- **TigerBeetle**: tigerbeetle.com, tigerbeetle/tigerbeetle on GitHub. Exactly-once accounting, deterministic replay.
- **DuckDB**: duckdb.org, duckdb/duckdb on GitHub. Columnar in-process OLAP.
- **redb**: redb.org, cberner/redb on GitHub. Safe embedded ACID database in Rust.
- **Turbopuffer**: turbopuffer.com, turbopuffer/turbopuffer on GitHub. Embedded vector search.

All read for concepts, not for code or naming conventions. The design decisions are our own.

---

*Tablecloth holds. Its name is a hash; its promise is the bytes behind the hash, unchanged. Five stores showed us what that promise requires: stated bounds, write-once ACID, single-writer discipline, and a narrow surface. The rest is accretion — a store that grows only by adding, never by changing what it already holds. A ledger, not an eraser.*
