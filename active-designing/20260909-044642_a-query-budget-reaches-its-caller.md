# A Query Budget Reaches Its Caller

**Stamp:** 20260909.044642
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed, mixed -- the linked experiment binds present behavior; the contract is design.
**Grant:** [The table-store grant](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md), the silo step.
**Evidence:** [The query and reply experiment](../external-research/20260909-044642_the-query-and-the-reply-budget.md), run on 2026-09-09 at Git nib `17c942e736`.

When does a faster search make a better answer? A caller needs the search to finish, the result to
fit, and the result to mean what the request asked. Each part deserves its own promise. A store
choice begins with those promises, because improving one resource can leave the binding limit
elsewhere.

This design keeps Tablecloth's existing scan as the reference operation. A new index earns its
place when a named caller needs less search work and can afford the index's writes and recovery.
The primary state is the held set of records. A derived index is a lookup structure rebuilt
from those records. The design introduces no new module name.

## Read the whole path

**Observation.** In the linked experiment, the namespace catalog declares capacity for **16 leaf bindings**,
the wire response holds **8 names**, and the caller's reply buffer holds **340 bytes**. These
are source declarations read on 2026-09-09. The local filter returned nine matching names;
the wire response builder refused that result. Three maximum-width names also exceeded the
reply byte budget, while eight short names fit.

**Inference.** Search work, hit count, and encoded bytes are independent resources. An index can
change how a match is found while leaving the same match too large to send. Replacing storage
in response to that refusal would address a different part of the path.

**Observation.** The [query function](../comlink/recall_tablecloth_query.rye) writes names into a
caller-provided array and returns `ResultOverflow` when the next match cannot fit. The wire
adapter maps that to `Overflow`. The [encoder](../comlink/recall_tablecloth_query_wire.rye) can
also return `Overflow` when its byte buffer fills. These are source readings at the evidence
nib, rather than a proof of complete error delivery across the network.

**Inference.** Callers must consume results only after success. Written scratch bytes and a
partial prefix are intermediate state, even if they look like useful matches. A future reply
protocol needs to make completion explicit before a receiver treats a prefix as a full answer.

## The contract to declare first

**Proposed.** The caller declares the following budgets before an implementation comparison.
Each quantity carries a unit and a refusal policy; the values come from that caller's need.

| Resource | Contract question | Evidence needed |
|---|---|---|
| Live state | How many records and payload bytes may be held? | full capacity and one over it |
| Search | How many entries and key bytes may one query inspect? | absent, common, and exact matches |
| Result | How many names and encoded bytes may be returned? | exact fit and first overflow |
| Mutation | How many bytes may one change copy or rewrite? | insert, replace, delete, and refusal |
| Recovery | How much state and work may restore an answer? | interrupted publication and repeat replay |
| Admission | How many requests may share these budgets? | aggregate live bytes at the accepted load |

A wall-clock deadline adds a separate agreement about scheduling and storage. An operation count
is useful before that agreement exists, because it describes the work independently of a fast
or slow bench. It remains an operation count when the bench happens to finish quickly.

For the present experiment, the source-defined count and byte limits are known. A caller-approved
search-time budget, mutation rate, aggregate memory budget, and durable recovery target remain
unmeasured. They stay blank in a storage decision rather than receiving convenient values after
the result is known.

## Give each candidate its strongest case

**Proposed baseline: the bounded scan.** It preserves catalog order, reads the authoritative
records directly, and adds no persistent index state. It earns a continued place while it meets
the caller's declared search budget. Its cost grows with the number and width of records examined.

**Proposed alternative: a derived index.** It narrows search when a repeated query selects a
small part of the catalog. Its
representation binds to the exact primary-state identity it indexes. Publication exposes matching
primary and derived state together, or the reader takes a complete scan of the held primary state.
If the scan also exceeds the budget, admission refuses or defers by a named policy.

The index pays for extra bytes, changes after writes, and rebuilding after interruption. A fresh
index and a smaller search count alone settle none of those costs. Rebuilding the same derived
state twice should give the same query answers and ordering; that is a property to witness before
sharing the index with callers.

**Proposed alternative: bounded result pages.** Several replies can carry a larger answer, if a
caller needs that behavior. Each page must bind its query, primary-state identity, and continuation
position. A receiver can then distinguish a complete result from an interrupted sequence. Paging
adds retained state and recovery rules, so the current overflow contract remains the smaller
choice until such a caller is named.

These choices can combine. An index answers where to look; paging answers how much to return.
Neither implies that the other is needed.

## What the module boundaries buy

**Proposed ownership.** Bakery owns a possible storage implementation under the grant. Copal
reviews persisted representation and interrupted recovery; Patchouli reviews the Mantra and Tally
contracts. Diffuser carries this research and its falsifiers. Comlink's existing query and wire
modules remain the caller reference, with their owning seat consulted before changes there.

Tablecloth keeps names bound to content. Mantra supplies the primary-state identity chosen for a
trial. Tally supplies explicit resource accounting, and Caravan limits which requests may start when
requests become a supervised service. These are proposed collaboration points, rather than a
claim that the composed service runs today. Aurora only gains a startup recovery obligation if
persistent storage is selected.

A derived index is disposable only while its primary data and rebuilding procedure are sufficient.
A successful in-memory replay proves a computation; durable publication also needs an interruption
experiment at the storage boundary. Keeping those witnesses separate makes each promise readable.

## The decision that can close the plan

**Proposal.** First compare the same query against the current scan and any candidate index,
using the same inputs, ordering, result encoding, and failure policy. Count search work, live
bytes, mutation bytes, and rebuild work. Read elapsed time separately, with its machine and load.
The caller benefits when the whole accepted workload fits; the design rewards that outcome rather
than a larger feature list.

**Horizon:** the next budgeted workload trial, before the grant's storage build plan.
**Assumptions:** a finite record set, one writer for the first trial, declared queries, and a stable
primary-state identity through each answer.
**Falsifier:** if the existing Tablecloth path meets every agreed requirement, the new-store plan
closes and reuse is the deliverable. If the scan exceeds a declared search budget, the index
candidate proceeds only while its other costs fit. A reply overflow alone fails to justify it.
**Confidence:** high in separating these obligations; uncertain whether a new store will earn its
place for any future caller.

The silo step is complete as a contract and a decision rule. The implementation plan stays
conditional on that trial, with a useful answer already available: the present example needs an
honest reply boundary before it offers any evidence for a different store.
