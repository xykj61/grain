# Mantra Referential Namespace — Reference Specification

**Stamp:** `20260707.011412 UDT` (Kaeden's clock; this stamp is the specification's version)
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Seated — reference; canon `20260707.011812` (Kaeden's word); describes surfaces landed through parity **175** at tip `8acdbc7`, batch rebind repair `20260707.011412`
**Register:** Reference — the third room of the manual program; *must* and *should* carry conformance weight
**Normative sources:** the `.rye` files named per section; where prose and code disagree, the landed code and its green witness govern, and this document earns a correction

*Written by Kaeden and Rio 3.*

---

## §1 Scope and Conformance Terms

This specification names the stable surface of Mantra's referential namespace: names, resins, the catalog, beading, the wire, the batch frame, chunking, and the read-and-sync family composed over the foundation. It covers what a conforming implementation or peer **must** and **should** do; it does not teach (tutorials), guide a task (how-tos), or argue the why (the briefs do that).

**Refuse whole** means: on any failed check, the operation returns a named error, and no partial state is appended, kept, or trusted — the catalog, store, or output is exactly as it was before the call. **must** marks a conformance requirement; **should** marks strong guidance a conforming implementation departs from only with stated reason; **may** marks a permitted option.

## §2 Names and Their Bounds

Normative source: `mantra/recall_lap1.rye`.

A name is the quadruple **peer / bolt / revision / path**. Bounds are fixed and **must** be enforced at append:

| Field | Bound | Notes |
|-------|-------|-------|
| peer | ≤ 16 bytes | identity label of the holder |
| bolt | ≤ 32 bytes | the coherent versioned unit |
| revision | `u32`, first is **1** | strictly dense: next **must** equal `prev + 1` |
| path | ≤ 64 bytes | leaf name within the bolt revision |
| tilak | ≤ 32 bytes | layout mark on the leaf |

A resin's bytes are bounded by `max_resin_bytes = 512`. A catalog holds at most `max_bindings = 16` leaves; a full catalog **must** refuse append with `CatalogFull`.

## §3 Resins and Digests

The digest is SHA3-256. In the catalog and on the wire it travels as 64 lowercase hex bytes; inside a bead-index it travels as 32 raw bytes. The digest is address and proof at once: identical content is one resin, and any content **must** hash to its named digest before it is trusted, or the operation refuses whole with `DigestMismatch`.

## §4 The Catalog

Normative source: `mantra/recall_lap1.rye` (`BoltCatalog`).

**Append.** `appendLeaf` **must** refuse a duplicate name with `RevisionImmutable` (a revision, once written, never rewrites) and **must** refuse a non-dense revision with `RevisionOutOfOrder`. A successful append records the leaf's digest at write time.

**Resolve.** `resolveBinding` answers exactly one of three, and **must** never guess: `here` (the name is bound), `not_yet` (the name is the next dense revision of an existing path, honestly absent so far), `never` (the name can no longer or could never bind).

**Recall.** `recall` on a `here` name **must** re-verify the stored bytes against the recorded digest before returning them, and **must** return byte-identical content for the same name on every call, for all time. `not_yet` and `never` return their outcome with zero length rather than an error.

## §5 The Read Family

Each reader composes over §4 and **must** preserve its outcomes and refusals unchanged.

**By mark** (`recall_by_mark.rye`). Within a fixed peer/bolt/revision, a Tilak resolving to exactly one leaf recalls it; a shared mark **must** refuse with `MarkAmbiguous` unless a `path_hint` narrows it to one.

**Tablecloth query** (`recall_tablecloth_query.rye`). `TableclothQuery` makes peer, bolt, revision, tilak, and path_hint all optional. The query is one walk over the bounded catalog; matches **must** return in held (append) order; an empty result is a count of zero, never an error; an output slice too small for the matches **must** refuse with `ResultOverflow`. This surface is a filter, deliberately: no index, no plan, no store.

**Beaded recall** (`recall_beaded.rye`). `appendLeafBeaded` stores content at or below one bead budget directly under the caller's Tilak; larger content beads content-defined, the bead-index lands at the name under Tilak `bead-index`, and **each bead also lands as an ordinary leaf at the derived path `{path}.b{N}`** (ordinal `N` from 0) under `plain-bytes`, so every existing sync, batch, and have-already mechanism carries beads unchanged. `recallBeaded` returns byte-identical content whichever way it was stored, proven at two layers (the catalog's digest on the index; beading's digest on every bead and the whole). After a crossing, `hydrateBeadStoreFromCatalog` **must** rebuild a bead store from the derived leaves such that reassembly succeeds. Stated scope line: the reported Tilak for a beaded resin is `bead-index`, not the caller's original mark.

## §6 Beading

Normative source: `mantra/beading.rye`.

Constants: `max_bead_bytes = 256`; content-defined beads between `cdc_min_bead = 64` and `cdc_max_bead = 256`, boundary where a per-bead gear hash meets mask `0x1F` (average near 80 bytes; gear table is the fixed xorshift expansion of seed `0x2545F4914F6CDD1D`); at most `max_beads = 8` per index.

**Bead-index layout** (little-endian, 36-byte header):

```
[whole_digest: 32 raw][whole_len: u16][bead_count: u16][bead_digests: count × 32 raw]
```

The index is itself a valid resin (≤ 292 bytes at the bound). A resin's name is its whole-content digest, **identical beaded or unbeaded** — beading is representation, never identity.

**Reassembly and verify** share one header gate and **must** refuse whole on: unknown Tilak, truncated or slack index length, bead count past the bound, promised length past the bound, a missing bead, a bead failing its digest, a total departing the promised length, or a whole failing the recorded digest. `verifyBeadIndex` proves all of this in one-bead memory, folding a streaming hash instead of materializing the whole.

## §7 Sync — In Process

Normative source: `mantra/recall_lap1.rye` (`syncRevision`) and its compositions.

`syncRevision(dest, src, peer, bolt, revision)` runs two passes: verify every resin in the revision against its digest (any mismatch **must** refuse the whole crossing before anything appends), then append, counting the lanes — `had_already` when the destination holds the digest (a ref crosses; bytes stay home) and `needed` when bytes cross once. Re-syncing a held revision **must** refuse as `RevisionImmutable`. After a crossing, recall **must** be identical on both catalogs for every carried name.

**Two-way** (`recall_two_way_sync.rye`): both directions are two symmetric calls with roles and peer swapped; no asymmetry exists to add. **Catch-up** (`recall_catch_up.rye`): from the highest revision held, try the next until one ask returns empty; a second call with nothing new **must** cost exactly one empty ask. **Subscribe poll** (`recall_subscribe_poll.rye`): repeat catch-up on a cycle; witnesses **must** bound cycles (`max_cycles`) and **may** zero the interval; production **may** pass a named `interval_ns` (`default_poll_interval_ns` = one second) and `sleepIntervalNs` fires between cycles (parity **181**); wire delivery honors the same sleep at `fetcher-poll` cycle boundary; **host mirror** is the same loop over a named list of at most `max_mirror_pairs = 4` peer/bolt pairs — configuration, not a second mechanism. **Production scheduling** (`caravan/subscribe_poll_service.rye`, parity **176**→**179**): Caravan supervises `recall_subscribe_poll_delivery` — a long-lived source child plus fetcher-poll workers. **Exit vocabulary** (`caravan/supervisor_exit.rye`, parity **177**): `cycle_ok` (0) spawns again; `stop_requested` (8) halts; other non-zero is a fall. **Stop sentinel** (`fetcher-poll <path>`, parity **178**): delivery checks the sentinel at each cycle boundary and exits 8 when present; `fetcher-poll-legacy` keeps the two-cycle demo path. **SIGTERM ring** (`caravan/supervisor_signal.rye`, parity **179**): handler flips one atomic flag; supervisor loop top creates the same sentinel for signal, witness hook, or manual `touch`.

## §8 The Wire — Sealed Datagrams and Sync Payloads

Normative sources: `comlink/wire_format.rye`, `mantra/recall_sync_wire.rye`.

**Envelope.** One sealed datagram is `wire_capacity = 528` bytes: sender key (32) · nonce · SHA3-512 name (64) · Ed25519 signature (64) · Poly1305 tag (16) · ciphertext. `max_message = 340` bytes of plaintext ride one frame. A failed seal **must** drop the datagram whole.

**Sync request** (kind `0x01` region of `recall_sync_wire.rye`):

```
[kind:u8][peer_len:u8][peer][bolt_len:u8][bolt][revision:u32 LE][held_count:u8][held: count × 64 hex]
```

with `held_count ≤ max_held_digests = 8`.

**Sync response** carries peer/bolt/revision echoed, then `entry_count ≤ max_wire_entries = 8` entries of:

```
[path_len:u8][path][digest:64 hex][tilak_len:u8][tilak][bytes_len:u16 LE][bytes…]
```

where a held digest **must** cross with `bytes_len = 0` (the have-already lane) and the receiver reconstructs from its own store. Every carried resin **must** verify against its digest before append; the response payload fits `max_wire_payload = 340`.

**Ports** (hosted request/response · device labs): per-resin sync **38478/38479 · 15561/15562**; batch **38480/38481 · 15563/15564**; two-way **38482/38483**; catch-up **38484/38485 · 15565/15566**; subscribe poll **38486/38487**.

## §9 The Resin-Batch Frame (kind `0x03`)

Normative source: `mantra/resin_batch.rye`. Bounds: `max_batch_entries = 16`, `max_batch_bytes = 4096`.

```
[kind = 0x03]
[peer: u16-LE-len field][bolt: u16-LE-len field][revision: u32 LE][count: u32 LE]
count × [path field][tilak field][digest: 64 hex][length: u32 LE][has_payload: u8]
[signature: Ed25519 over everything above]
payloads, in manifest order, for each has_payload = 1 entry
```

The **one signature covers header and manifest only**; payloads prove themselves by digest, because each digest already rides signed. Apply **must** refuse whole on: bad kind, truncation, count past bound, an unknown Tilak, a duplicate path, a bad signature, any payload failing its digest, or a have-already entry whose bytes the destination cannot reconstruct (`StoreMissing`). The Tilak allowlist is exactly `plain-text`, `plain-bytes`, `manifest`, `bead-index`; a second sync of a fully held revision **must** move zero payload bytes.

## §10 Chunking (kind `0x04`) and the Assembler

Normative source: `mantra/recall_batch_wire.rye`; delivery in `mantra/recall_batch_delivery.rye`.

A batch at or under `max_batch_wire = 340` crosses as one `0x03`-prefixed response. A larger batch crosses as chunk frames:

```
[kind = 0x04][chunk_index: u16 LE][chunk_count: u16 LE][batch_total: u32 LE][body ≤ 331]
```

with `chunk_count ≤ max_batch_chunks = 16` and header length 9. `BatchAssembler.feed` **must** refuse: a bad kind, a truncated header, zero or over-bound count, an index at or past count, a total of zero or past `max_batch_bytes`, a count disagreeing with the total's arithmetic, a body length departing its slot, any total/count changing mid-assembly, and **a duplicate chunk index** (bitmask-tracked). Assembly is `ready` exactly when all `count` distinct chunks have landed.

**Delivery liveness (this stamp).** The receiving side **must** hold one bound socket across an entire assembly — the kernel then queues back-to-back frames, and no frame can land in an unbound window — and **must** carry a receive timeout (`batch_recv_timeout_sec = 2`) so a silent peer yields `RecvFailed` rather than an unbounded wait. The prior per-frame rebind lost this race often enough to hang the multi-frame witnesses; the repair and its ten-of-ten stress proof are recorded in the session log at this stamp.

## §11 Witness and Parity Registry

Every claim above is held by a witness the parity suite runs; counts are pinned on Cursor's metal, never predicted. Landed pins through this specification's tip:

| Parity | Claim | Witness |
|--------|-------|---------|
| 159–161 | recall · write revision · in-process sync | `mantra_recall_lap1/2/3.rish` |
| 162 | per-resin sync wire (hosted + device) | `mantra_recall_lap3_wire.rish` |
| 163 | resin-batch frame | `mantra_resin_batch.rish` |
| 164 | beading (three rings) | `mantra_beading.rish` |
| 165 | beaded recall + derived paths | `mantra_recall_beaded.rish` |
| 166 | batch wire: hosted + device + chunk + beaded | `mantra_recall_batch_wire.rish` |
| 167 | `stones/` → `resins/` hygiene | (rename witness) |
| 168 | marks-on-read | `mantra_recall_by_mark.rish` |
| 169–170 | two-way sync, in-process + wire | `mantra_recall_two_way_sync*.rish` |
| 171–172 | catch-up-to-latest, in-process + wire | `mantra_recall_catch_up*.rish` |
| 173–174 | subscribe poll + host mirror, in-process + wire | `mantra_recall_subscribe_poll*.rish` |
| 175 | Tablecloth query | `mantra_recall_tablecloth_query.rish` |
| 180 | I2 snapshot export lap 1 | `mantra_snapshot_replay.rish` |
| 181 | poll interval at cycle boundary | `mantra_recall_subscribe_poll_interval.rish` |
| 182 | snapshot horizon bundles | `mantra_snapshot_horizon.rish` |

## §12 Open Items (Non-Normative)

Graceful stop complete through parity **179**; **snapshot export** through lap 2 (parity **180**→**182**); **poll interval** (parity **181**). **Weave slice** closed — Kaeden `20260707.030412`: I2 `catalog/` export is the sovereign slice. **Brix** closure and **Pond** customs held per counsel `025212`. Continuity custody gate (live-instance + per-host epoch) remains Kaeden's only.

---

*May this page and the code never disagree for long, and the witness always say which one owes the correction. May every bound here stay named before it is needed. And may a stranger, holding only this specification and the tree, rebuild the namespace and watch every witness turn green.*
