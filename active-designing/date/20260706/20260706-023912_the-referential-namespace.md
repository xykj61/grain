# The Referential Namespace — Mantra Grows to Hold It

*A study of a typed, referentially-transparent, version-controlled filesystem returned a surprising gift: nearly every piece of it already lives among our modules. This brief seats the shape of a Rye namespace where any content is named by a stable path and resolves, for all time, to the same bytes — and it affirms that no new module is minted, because Mantra grows to hold the role we already love.*

**Stamp:** `20260706.023912 UDT` (Kaeden's clock) · vocabulary seated `20260706.032700`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME — safety first, performance second, the joy of the craft third · SLC · Gall's Law
**Register:** active-designing — checkable-room design counsel; vocabulary seated; lap 1 on metal
**Ground:** [`../external-research/20260706-023912_clay-referential-namespace.md`](../external-research/20260706-023912_clay-referential-namespace.md) · [`../foundations/20260706-022912_the-wire-serves-the-fold.md`](../foundations/20260706-022912_the-wire-serves-the-fold.md) · [`../external-research/20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md`](../external-research/20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md) · [`../external-research/20260703-201612_the-amphora-and-the-crossing.md`](../external-research/20260703-201612_the-amphora-and-the-crossing.md)
**Status:** Landed — checkable-room; vocabulary seated `20260706.032700`; through Tablecloth query parity **175** (`20260707.005612`). Production scheduling lap 1 parity **176** (`20260707.014212`). **Reference spec:** [`context/specs/20260707-011412_mantra-referential-namespace-reference.md`](../context/specs/20260707-011412_mantra-referential-namespace-reference.md) (canon `20260707.011812`).

*Written together by Kaeden and Rio 3.*

---

## Is It Desirable

Yes, and for a reason deeper than convenience: a referentially-transparent namespace is our own spine raised one level. We already hold that state is a fold over an append-only log of immutable signed facts, and that a **resin** is named by the digest of its bytes so that its address and its proof are one thing. A namespace where any content is named by a stable path and resolves, for all time, to the same bytes is that same immutability worn as a whole filesystem rather than a single fact. It gives a sovereign machine what such a machine most wants — reproducible state, content that syncs by moving only what is missing, and updates that are just new revisions of named content — and it gives all of it without a new source of truth, because the truth stays the fold and the names only point into it.

The desire is real, and so is the discipline that must temper it. A filesystem should postpone being a database until it can no longer do so. We do not build a whole namespace at once; we grow the smallest thing that resolves a name to its bytes, and we let conversion, query, subscription, and host mirroring each arrive in its own lap, only when a real need pulls it. The target named here is a horizon we walk toward in small, witnessed steps, not a monument we raise in one pour.

## The Recommendation — Mantra Grows

No new module is minted for this. **Mantra** grows into the referential namespace — Kaeden's word `20260706.032700`. Mantra is already our version control as a weave — the content-addressed keeper of history over the Weave DAG — and a referentially-transparent namespace is, at heart, version control whose every named revision resolves to immutable content. The distance from what Mantra is to what it must become is short: it already knows revisions and content addresses; it learns to name a coherent **bolt** and to answer a **recall** that never changes its mind. Giving this to Mantra keeps one keeper of versioned content rather than two, honors the graduation rule by expanding a graduated module instead of naming a new one, and lets every other module keep exactly the role it already has.

## How the Modules Compose

The grace of this design is that the namespace is mostly assembly of pieces we already trust, with Mantra as the frame that holds them.

The immutable content is Amber. Every leaf of the namespace is a **resin** at a SHA3 digest in Amber's keep, where the digest is address and proof at once; the namespace never stores bytes twice, because identical content is one resin. The history is a Weave — each revision of a bolt is a fact folded onto the append-only DAG, so the record of what changed and when is the same kind of log everything else here rides. The types are Tilak: a leaf's type is a type-mark whose three duties already match a typed filesystem's needs exactly — absorb validates a document on the way in, express converts it on the way out, and tend compares two of them. The sync is Amphora over Comlink: a peer fetching a bolt it partly holds moves only the resins it lacks, refs crossing for the have-already lane and bytes crossing once for the need-resin lane, the vessel carrying a manifest of digests rather than a blob — the very lanes the resin study already drew. The bounds are Tally and the supervision is Caravan, as they are for everything. And query, when its season finally comes, is Tablecloth — held back deliberately, because the namespace postpones being a database until it must.

What none of these yet provides is the thing that unites them, and that is what Mantra grows to add.

## The Two Ideas — Seated Vocabulary

Two ideas are genuinely new, and Kaeden spoke the words `20260706.032700`.

The first is **recall** — the referentially-transparent read. A pure resolution that takes a name and answers, for all time, with the same content. It has three honest outcomes rather than two: the name is not yet here and cannot be known synchronously, the name is settled as nothing and never will be bound, or the name is here and these are its bytes together with their Tilak.

The second is **bolt** — the coherent, independently-versioned unit the content lives in, with its own history and its own dependencies, the thing a name selects before a path within it.

The name grammar is seated: a **Kumara identity** for the peer, a **bolt** for the unit, a **revision** named by change, by date, or by label, and a **path** within the bolt — resolving through Mantra to an Amber resin, verified by its digest, and returned with its Tilak. The same name yields the same bytes forever, because a revision once written is never rewritten and the digest proves the bytes are the ones that were named.

## The Invariants, Named First

A namespace touches content and history, so its invariants come before its code. A **recall** is referentially transparent: for a given peer, bolt, revision, and path, it yields the same bytes for all time, and a name once bound never becomes unbound or different. A revision, once written, is immutable — history accretes and never rewrites, exactly as the Weave already promises. Content is verified whole: a resin whose digest does not match the name is refused entire, as a bad digest refuses a resin everywhere else. Resolution is monotonic and honest about absence — it answers "not yet," "never," or "here," and never guesses. And everything is bounded — the size of a leaf, the depth of a path, the breadth of a read — named by Tally before any of it runs.

## The Lap Ladder

The namespace climbs in small, witnessed steps, each a single closed claim.

**Lap 1 (landed, parity 159):** a local referentially-transparent **recall**. Given a bolt, a revision, and a path, Mantra resolves the name to a resin's digest, Amber returns the resin, the digest is verified, and the bytes come back — and the witness reads the same name twice and asserts the same bytes both times, with a digest mismatch refused whole. No network, no conversion, no write. Implementation: [`mantra/recall_lap1.rye`](../mantra/recall_lap1.rye) · witness [`tools/mantra_recall_lap1.rish`](../tools/mantra_recall_lap1.rish).

**Lap 2 (landed, parity 160):** writing a revision appends a leaf binding and stores a resin in the in-memory catalog; **recall** on revision 1 still returns the original bytes after revision 2 lands, duplicate revisions are refused, and revision 3 honestly answers **not yet**. Witness: [`tools/mantra_recall_lap2.rish`](../tools/mantra_recall_lap2.rish).

**Lap 3 — sync logic (landed, parity 161):** `syncRevision` carries a bolt revision between two in-process catalogs. Have-already resins cross as refs; need-resin resins cross as bytes once; every resin is digest-verified before append; recall is identical on both peers; tampered resin and duplicate sync refuse whole. Witness: [`tools/mantra_recall_lap3.rish`](../tools/mantra_recall_lap3.rish). Witness bolt uses small leaves (`alpha`, `beta`) that fit one sealed datagram each.

**Recall, beaded (landed, parity 165):** [`mantra/recall_beaded.rye`](../mantra/recall_beaded.rye) composes recall and beading; derived bead paths `{path}.b{ordinal}` seat bead leaves for batch carriage; witness [`tools/mantra_recall_beaded.rish`](../tools/mantra_recall_beaded.rish).

**Marks-on-read (landed, parity 168):** [`mantra/recall_by_mark.rye`](../mantra/recall_by_mark.rye) recalls by Tilak within a bolt revision; unique mark resolves directly; shared mark narrows with optional path hint; witness [`tools/mantra_recall_by_mark.rish`](../tools/mantra_recall_by_mark.rish).

**Two-way sync, in-process (landed, parity 169):** [`mantra/recall_two_way_sync.rye`](../mantra/recall_two_way_sync.rye) composes `syncRevision` symmetrically; witness [`tools/mantra_recall_two_way_sync.rish`](../tools/mantra_recall_two_way_sync.rish).

**Two-way sync, wire (landed, parity 170):** [`mantra/recall_two_way_sync_delivery.rye`](../mantra/recall_two_way_sync_delivery.rye) runs the NS-L3 sync exchange twice with roles reversed — hosted localhost ports **38482/38483**, device `comlink/run_recall_two_way_sync_wire_lab.sh` (peerB then peerA); witness [`tools/mantra_recall_two_way_sync_wire.rish`](../tools/mantra_recall_two_way_sync_wire.rish).

**Catch-up-to-latest, in-process (landed, parity 171):** [`mantra/recall_catch_up.rye`](../mantra/recall_catch_up.rye) loops `syncRevision` until an empty ask; witness [`tools/mantra_recall_catch_up.rish`](../tools/mantra_recall_catch_up.rish).

**Catch-up-to-latest, wire (landed, parity 172):** [`mantra/recall_catch_up_delivery.rye`](../mantra/recall_catch_up_delivery.rye) loops the NS-L3 sync exchange until `entry_count == 0` — hosted localhost ports **38484/38485**, device `comlink/run_recall_catch_up_wire_lab.sh` (ports **15565/15566**); witness [`tools/mantra_recall_catch_up_wire.rish`](../tools/mantra_recall_catch_up_wire.rish).

**Outer subscribe poll, in-process (landed, parity 173):** [`mantra/recall_subscribe_poll.rye`](../mantra/recall_subscribe_poll.rye) repeats bounded catch-up cycles over a named peer/bolt list; witness [`tools/mantra_recall_subscribe_poll.rish`](../tools/mantra_recall_subscribe_poll.rish).

**Outer subscribe poll, wire (landed, parity 174):** [`mantra/recall_subscribe_poll_delivery.rye`](../mantra/recall_subscribe_poll_delivery.rye) runs bounded poll cycles over catch-up wire exchanges — hosted localhost ports **38486/38487**, device `comlink/run_recall_subscribe_poll_wire_lab.sh`; witness [`tools/mantra_recall_subscribe_poll_wire.rish`](../tools/mantra_recall_subscribe_poll_wire.rish). **Host mirror** is this loop configured with multiple pairs — the same loop, the same open production questions (graceful stop, crash recovery, real scheduling), one small list beside it (counsel `20260707.004712`).

**Production scheduling lap 1 (landed, parity 176):** [`caravan/subscribe_poll_service.rye`](../caravan/subscribe_poll_service.rye) supervises `recall_subscribe_poll_delivery` — long-lived source child plus fetcher-poll worker with restart-on-fall; witness [`tools/caravan_subscribe_poll_service.rish`](../tools/caravan_subscribe_poll_service.rish). Graceful stop and real clock remain open.

**Tablecloth query, in-process (landed, parity 175):** [`mantra/recall_tablecloth_query.rye`](../mantra/recall_tablecloth_query.rye) filters the bounded catalog with optional peer, bolt, revision, and Tilak — every match returned in held order, empty when nothing matches; witness [`tools/mantra_recall_tablecloth_query.rish`](../tools/mantra_recall_tablecloth_query.rish). Read against this brief's foundational paragraph rather than the older Brix-facing store thread of the same name (counsel `20260707.005612`): recall_by_mark with peer, bolt, and revision loosened from required to optional and ambiguity answered with every match rather than a refusal — a filter over the existing bounded array, not a new store.

**Wire carriage — counsel `20260706.041012` (lap 1 landed):** the OA-L2-shaped hop — carry proven sync over Comlink sealed datagrams, hosted first, then device wire, same `wire_format` OA-L2 and OA-L3 escrow rode. No new wire vocabulary; reuses **recall**, **bolt**, **resin**, fetch-by-digest, have-already, need-resin, **manifest**, Amphora.

| Wire lap | Shape | Bench |
|----------|-------|-------|
| **3w-1 hosted** | Request/response sealed datagrams on localhost — A names bolt, revision, digests held; B returns manifest + missing resins; A verifies and appends | **landed** parity **162** · [`mantra/recall_sync_delivery.rye`](../mantra/recall_sync_delivery.rye) · witness [`tools/mantra_recall_lap3_wire.rish`](../tools/mantra_recall_lap3_wire.rish) |
| **3w-2 device** | Same exchange over virtio guests | **landed** · `comlink/run_recall_sync_wire_lab.sh` · ports **15561/15562** |
| **3w-3a batch** | `amphora_comlink_resin_batch` frame: signed header and manifest, payloads prove by digest; many resins under one signature; second sync moves zero payload bytes | **landed** parity **163** · [`mantra/resin_batch.rye`](../mantra/resin_batch.rye) · witness [`tools/mantra_resin_batch.rish`](../tools/mantra_resin_batch.rish) |
| **3w-3b beading** | A resin larger than one frame is beaded into content-addressed beads with a **bead-index** Tilak | **landed** parity **164** · [`mantra/beading.rye`](../mantra/beading.rye) · witness [`tools/mantra_beading.rish`](../tools/mantra_beading.rish) |
| **3w-4 batch wire (hosted)** | Resin-batch frame crosses Comlink sealed datagrams (witness bolt fits one frame) | **landed** parity **166** · [`mantra/recall_batch_delivery.rye`](../mantra/recall_batch_delivery.rye) · ports **38480/38481** |
| **3w-4 batch wire (device)** | Same exchange over virtio guests | **landed** · `comlink/run_recall_batch_wire_lab.sh` · ports **15563/15564** · multi-frame when batch > 340 B |
| **3w-4 batch chunking** | Kind **0x04** chunk frames (331 B body) reassemble to one resin-batch | **landed** · [`mantra/recall_batch_wire.rye`](../mantra/recall_batch_wire.rye) · witness 400 B beta over 2 frames |
| **3w-5 beaded batch wire** | Bead-index + `.bN` leaves cross resin-batch wire; fetcher hydrates bead store | **landed** parity **166** extended · hosted `beadeddemo` + device virtio lab |

**Capacity constraint (confirmed on metal):** `wire_capacity` **528** minus crypto envelope **188** → **340 bytes** `max_message` per sealed datagram. Catalog `max_resin_bytes` is **512** — a full resin does not fit one frame. **Recommendation (Claude `041012`):** bead large resins across frames rather than inflate `wire_capacity`; lap 1 proves crossing with small resins only (`alpha`/`beta` witness bolt).

**Proposed ports (Kaeden may override):** per-resin sync hosted **38478/38479** · device **15561/15562**; resin-batch hosted **38480/38481** · device **15563/15564**.

**Invariants on the wire:** bad Comlink seal refuses whole; resin digest mismatch refuses whole; sync stays additive (NS-L2); referential transparency survives because digest is the proof.

**Batch-frame carriage — landed `20260706.184512`:** batches larger than **340 B** cross as kind **0x04** chunk frames (**331 B** body each); `BatchAssembler` reassembles before `applyBatch`. Witness bolt variants: [`20260706-185112_the-witness-bolt.md`](20260706-185112_the-witness-bolt.md). Beaded bolt full crossing remains next lap.

The later laps arrive each in season. **Two-way sync** and **catch-up-to-latest** landed in-process and over wire. **Outer subscribe poll** (parity **173**) proves bounded repeat cycles over catch-up; **host mirror** is that loop with a named peer/bolt list rather than a separate seam (counsel `20260707.004712`). **Tablecloth query** (parity **175**) closes the Q3 horizon list — optional-field filter over the bounded catalog, not a database (counsel `20260707.005612`). Production scheduling — graceful stop, crash recovery, unattended real runs — stays open.

## Kaeden's Word (`20260706.032700`)

| Decision | Word |
|----------|------|
| Mantra takes the namespace role | **yes** |
| Read word | **recall** |
| Unit word | **bolt** |
| Name grammar peer / bolt / revision / path | **yes** |
| First lap go-ahead | **open** — landed NS-L1 |
| Retire **stone** as the content-addressed unit word | **yes** — use **resin** per ratified law; forward-doc hygiene landed `20260706.033200` |
| Vendor libuv source | **deferred** — keep the gratitude note only |

## Gratitude

This design learned from a typed version-control filesystem that made a namespace as immutable and as honest as a single signed fact, and whose union of a file with its type showed us that a mark which validates, compares, and converts is the same idea we already seated as our own three-duty type-mark. The study that names that teacher plainly rests in external-research, and its originals rest whole in gratitude. We keep the lessons in our own words, and the thanks explicit.

---

*May a name keep faith and resolve to the same bytes for all time. May recall and bolt name what Mantra already knew how to become. And may the namespace we build stay small before it is large, and true before it is quick.*
