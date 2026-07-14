# Claude Proposal — Snapshot Lap 3 Is Ready; Caravan Hardening, a Short Menu

**Stamp:** `20260707.042512 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`) · **Lens:** TAME · Gall's Law
**Register:** Proposal — both items assessed as mechanical; one caveat named for the first
**Status:** Research for understanding — counsel and proposal; checkable claims cite code on disk; seats nothing by itself
**Ground:** `counsel/20260704-181612_zero-copy-resins-counsel-answers.md` (part C, the lap numbering) · `mantra/snapshot_export.rye` (confirmed no wire code exists) · `mantra/recall_batch_delivery.rye` (`runSource`/`runFetcher`, read in full)

*Written by Kaeden and Rio 3.*

---

## Two Quick Confirmations

I6's Tilak migration and OA-L5's full wire completion both landed exactly as sequenced last turn — the elder golden preserved, both goldens parsing under one reader, and the open-asks room now wired end to end for every transition that has one. Nothing here needs revisiting.

## Snapshot Lap 3 Is Not a New Idea — It Was Already Numbered

Before recommending anything, this bench checked whether "lap 3" meant something specific or was Cursor's own next guess. It is specific: the original counsel named laps in order — lap one, the batch replay; lap two, "proves the fold on a host," the horizon bundles just landed; lap three, *"the hosted Comlink crossing,"* named as *"the largest export that stays witnessable without thin-edge metalsmoke."* Lap four is Puddle's microVM boot, lap five is Aurora on real metal — both thin-edge, both later, neither this. Lap three is squarely next by the tree's own numbering, not a fresh suggestion.

**It is also genuinely small.** `snapshot_export.rye` has no wire code today — export and import both run in one process, on one host, for the witness's own convenience. `recall_batch_delivery.rye` already does exactly the exchange lap three needs, just aimed at one revision at a time: a fetcher requests a `(peer, bolt, revision)`, a source answers with a sealed, signed resin-batch built by the same `buildBatch` the snapshot exporter already calls locally. Lap three's whole shape is running that exact exchange once per revision group a snapshot wants to carry, assembling the results the same way `exportCatalogHorizon` already assembles them today, and handing the assembled bundle to `importCatalogHorizon` completely unchanged. No new wire mechanism, no new frame kind, no new signature scheme — the same composition pattern every ring in this arc has used, aimed at one more surface.

**One caveat, worth stating plainly rather than leaving implicit.** `importCatalogHorizon` already calls the continuity check, and that check is still the benign placeholder this bench confirmed twice now — epoch non-zero, identity matches signer, nothing about liveness or a host's prior history. Lap three should call that same function exactly as it stands today, and should not reach for anything closer to the real double-boot rules while it is in the neighborhood. Carrying bytes over a wire and deciding whether an identity may safely boot twice are two different claims, and lap three is only ever the first one. If real continuity enforcement gets pulled into scope because "we're already touching import," that would be the custody gate opening by way of a side door rather than a word — worth naming once so it does not happen by accident.

**Recommend: build it.** This is the next mechanical stop by the tree's own prior numbering, it composes rather than invents, and the one caveat above is easy to honor by simply not reaching past it.

## Caravan Production Hardening — a Menu, Since Nothing Names It Precisely Yet

Unlike lap three, "hardening" has no prior specification to check against — this bench looked and found no existing TASKS line or counsel naming a specific next Caravan ring. Rather than guess at one target, four concrete, independently small candidates, each mechanical and none touching a held seam:

- **Source-crash recovery.** Today's supervision watches the fetcher-poll child; nothing yet proves what happens if the long-lived `source-loop` itself dies mid-service. A witness that kills the source out from under a running supervisor and asserts a named, clean failure — rather than a silent hang — closes a real gap the current witnesses do not exercise.
- **Extended-run stability.** Every witness so far bounds itself to a handful of cycles. A longer, still-bounded run — dozens of cycles rather than three or four — would catch anything that only shows up with repetition: a leaking file descriptor, a growing allocation, a socket left half-open across restarts.
- **Witness-mode footgun.** `witness_stop_after` exists purely for tests; nothing currently stops it from being passed to a real invocation by mistake. A loud, named refusal when that argument is supplied outside a test context would cost little and remove one way this could quietly misbehave in real use.
- **Host-mirror under supervision.** The pair-list mirror mode and the Caravan supervisor have each been proven on their own; nothing yet proves them together — a supervised process running the mirror's own multi-pair cycle, crashing mid-list, and recovering cleanly.

Any one of these is small enough to finish in one sitting and touches nothing this bench has held. This bench does not rank them — each answers a different, real question, and any order serves.

---

*May the third lap cross exactly the wire it was always meant to, and stop exactly where the custody gate begins. May hardening find the gaps a bounded witness cannot see on its own. And may every ring still keep composing rather than inventing, this many laps into the climb.*
