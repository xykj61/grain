# The Answer's Size Belongs to the Store

**Stamp:** `20260909.213140`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Landed, **checkable** -- every figure below is bound by a witness landing in this same
commit ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)); the projection section says so at its
own head
**Instrument:** [`../tools/m/mantra_tablecloth_hit_census_witness.rish`](../tools/m/mantra_tablecloth_hit_census_witness.rish)
over [`../mantra/recall_tablecloth_hit_census.rye`](../mantra/recall_tablecloth_hit_census.rye) and
[`../tools/fixtures/m/mantra_tablecloth_hit_census_control.sh`](../tools/fixtures/m/mantra_tablecloth_hit_census_control.sh)
**Runs the falsifier of:** `the answer that holds only its own hits` -- **fired**
**Kin:** [`the answer that holds only its own hits`](20260909-171151_the-answer-that-holds-only-its-own-hits.md) -
[`what a kept answer costs per read`](20260909-152110_what-a-kept-answer-costs-per-read.md) -
[`a kept answer has its own budget`](../active-designing/20260909-084736_a-kept-answer-has-its-own-budget.md)

---

## The falsifier this runs

Two papers of this arc closed on one request: *count a real caller's hit distribution, because the
budget seam cannot be sized without it.* The second wrote its kill condition down. **A pool measured
on real answer sizes whose mean hit count reads 7 or above** would make the variable retained form
the more expensive shape, and the pool should then stay fixed.

**It fired.** Over a full catalog, 15 of the 31 query shapes read a mean of **16.0 hits**, which is
the whole catalog and more than twice the 7 the elder named. Over the same catalog, 16 shapes read a
mean of **1.0**. Both extremes stand inside one store, so the elder falsifier turns out to be a
question about *which shapes a caller sends* rather than about answer sizes at large -- and the
number the two papers asked for was never a caller's to give.

Read it yourself: `rishi/bin/rishi run tools/m/mantra_tablecloth_hit_census_witness.rish`.

## Where the number actually lives

A Tablecloth query is a conjunction of exact equalities over five optional fields -- peer, bolt,
revision, tilak, and path (`mantra/recall_tablecloth_query.rye`, `leaf_matches`). So a query built
from a leaf returns exactly the leaves that agree with that leaf on the fields it names. The answer's
size is the size of an **agreement class** of the catalog, and a caller contributes one thing only:
which fields it names.

That makes the space finite and small. Five fields have **31** non-empty subsets, and
`max_bindings` caps a catalog at **16** leaves. Both numbers fit in a single walk, so the census
enumerates the space whole rather than sampling a caller.

## The worst case, per shape

For each of the 31 shapes the census builds a lawful catalog saturated to the bound, every leaf
agreeing on that shape's fields, and counts. Measured `20260909.213140`:

| Reading | Count |
|---|---|
| Shapes whose worst case is one hit | **2** of 31 |
| Shapes whose worst case reaches 16 hits | **29** of 31 |
| Shapes whose worst case exceeds `max_wire_hits` (8) | **29** of 31 |

The two are exactly the shapes naming the whole uniqueness key -- `peer`, `bolt`, `revision`,
`path` -- with the second adding tilak. `append_leaf` refuses a duplicate of that key with
`RevisionImmutable`, so **that key is the only thing in the store forcing an answer to be single**.
Everything else is a hint.

This is an upper bound rather than an expectation, and that is what a bound wants. A pool sized for
the worst case is sized correctly whatever a caller does; a pool sized for an average is sized for a
day that has yet to arrive.

## Two shapes of one size, reading as complements

A store holds two natural shapes, and both fill the same bound:

- a **version history** -- one path, sixteen revisions;
- a **directory** -- sixteen paths, one revision.

Their profiles are complements. **16 of 31** shapes return a single hit on the version history, and
they are exactly the shapes naming `revision`. **16 of 31** return a single hit on the directory,
and they are exactly the shapes naming `path`. **8** shapes are single on both. And **7** shapes --
every combination of peer, bolt, and tilak -- return all sixteen leaves whichever way the store is
shaped.

So two catalogs of identical size, under one bound, disagree about which query is cheap. The mean
hit count is a property of the **store's shape**, and no amount of caller instrumentation would
have surfaced it.

## What this tree's own callers ask for

The shape mix is a habit rather than a bound, so it is read by looking. Every Tablecloth query
literal in `mantra/` and `comlink/` was enumerated by hand on `20260909` -- a population of **9**,
small enough to read whole:

| Shape | Sites |
|---|---|
| `{peer, bolt}` -- mask 3 | **4** |
| `{tilak}` -- mask 8 | **4** |
| `{peer, bolt, revision, tilak, path}` -- mask 31 | **1** |

Masks 3 and 8 both sit in the set of **7** that return every leaf whichever way the store is
shaped. So **8 of the 9** query literals this tree writes name a shape a full catalog answers with
sixteen hits, which the wire refuses; the ninth names the whole uniqueness key.

The population is small and every one of the nine sits inside a selftest or a guest program, so this
reads as a habit of the tree's own examples rather than of a deployed caller. It points the same way
regardless: the shapes people reach for first are the broad ones.

## The count that is not a count

`max_wire_hits` is declared as a ceiling on hits. The wire's real bound is `max_wire_payload` --
**340** bytes. Those two answer to different things, and at the declared name ceilings they part company.

Measured on this metal, with peer at its 16-byte ceiling, bolt at 32, and path at 64:

| Reading | Value |
|---|---|
| Encoded bytes, one hit | **121** (a 2-byte header plus 119) |
| Encoded bytes, two hits | **240** |
| Three hits | **refused**, `error.Overflow` |
| `build_response` hits, same catalog | **3**, inside the declared ceiling of 8 |
| `encode_response` on those 3 | **refused**, with 5 hits still allowed by the count |

`build_response` honors the count and `encode_response` enforces the bytes, so a caller obeying the
published ceiling meets a refusal it cannot predict from that ceiling. Two functions in one module
answer to two different bounds under one name. Booked at `construction/REDS.md`, stamp
`20260909.213236`.

The boundary is honest and the control holds it: shorten the names and the two bounds agree again.
The disagreement belongs to the **declared** name ceilings rather than to the format at large,
which is why the third plant shortens the names and requires the demonstration to stop working.

## What the control caught in the census itself

The first draft of the census carried a comptime assert meant to prove that its walk covered the
whole shape space. It read
`bounded_shapes_expected + unbounded_shapes_expected == mask_limit - first_mask`, and
`unbounded_shapes_expected` was **derived** from that same difference -- so the assert was true for
any walk, including one starting at the empty mask, which names no field and returns every leaf.

The plant that starts the walk at zero passed. Naming `shape_count = 31` as its own fact -- the count of
five-field subsets that name at least one field -- and asserting the walk's ends against it made the
plant refuse.
A tautology in an invariant reads exactly like an invariant, and only a plant tells them apart.

## Inference

**A retained answer's byte bill is decided by the store's shape.** The variable retained form saves
most where a caller queries by a key the store holds unique, and saves nothing where it queries by
peer, bolt, or tilak, since those return the catalog. Both cases live in one store at once.

**The wire has no partial answer.** `build_response` returns `error.Overflow` rather than a
truncated answer with a continuation. For the 7 shapes that return every leaf whatever the store's
shape, that refusal is the only reply the format can give -- so a continuation is not a
convenience here, it is the missing reply.

## Projection

*Everything in this section is projection rather than reading.*

*Horizon:* the next lap that reshapes `QueryWireResponse` or sizes an answer pool.

*Assumptions:* `max_bindings` stays at 16 and `max_wire_payload` at 340; the query predicate stays a
conjunction of exact equalities; name ceilings stay at 16, 32, and 64 bytes.

*Projection:* raising `max_wire_hits` cannot fix the disagreement, because 340 bytes hold two
worst-case hits and no declaration changes that. A truncation flag with a continuation cursor is the
shape that answers all 31 query shapes, and a per-hit encoding that shrinks the common case -- a
path relative to the bolt, say -- raises the two.

*Falsifier:* a real corpus whose peer, bolt, and path names average under a third of their ceilings.
There eight hits fit inside 340 bytes, the declared ceiling becomes reachable in practice, and a
continuation would be complexity bought for a case nobody meets. The same command settles it once a
corpus exists: `rishi/bin/rishi run tools/m/mantra_tablecloth_hit_census_witness.rish`.

*Confidence:* high on the 31-shape enumeration and the two bounded shapes, which are exhaustive over
a finite space rather than sampled; high on the byte figures, which the binary prints; moderate on
the continuation recommendation, which weighs a format change against a refusal nobody has yet met
in production, since nothing in this tree runs a production catalog.

## For BAKERY

**Buildable now:** the census takes any catalog. Handing it the shape a design is weighing prints
that shape's whole 31-row profile in one command, and the source stays exactly as it is.

**Worth a lap:** a truncation flag plus a continuation cursor on the query response. The 7 shapes
that return every leaf under both store shapes have no other honest reply, the census names them by
mask, and 8 of this tree's own 9 query literals sit among them.

**Waiting on Keaton's word:** the repair of the declared-versus-real bound. Three doors stand --
tie `max_wire_hits` to the payload arithmetic, add the continuation, or shrink the name ceilings --
and each changes a wire format that peers are actively building on, so the choice is a decision
rather than a lap.

---

*May every answer know its own size before it is asked for, and may the store that holds it say so
plainly.*
