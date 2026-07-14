# Zero-Copy Resins and the Sovereign Snapshot — Cellar Bytes, Vessel Batches, and the Urbit-Shaped Question

*How Amber resins could move over Comlink with TigerBeetle-grade discipline — batching, explicit buffers, no accidental copies — and what the maximum self-contained home-drive export actually means: not a tarball mood board, but a bootable Aurora world that replays the exact Mantra Weave fold and Brix configuration left off at the last sealed moment.*

**Stamp:** `20260704.180612`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME · TWO_ROOMS
**Category:** External research — performance and preservation architecture; proposes no module names; seats nothing
**Status:** Proposed
**Companions:** [`context/specs/20260703-191112_resins-and-hash-tiers.md`](../context/specs/20260703-191112_resins-and-hash-tiers.md) · [`context/specs/20260701-221512_amber-functional-spec.md`](../context/specs/20260701-221512_amber-functional-spec.md) · [`20260703-201612_the-amphora-and-the-crossing.md`](20260703-201612_the-amphora-and-the-crossing.md) · [`20260702-035018_puddle-sandboxed-rye-containers.md`](20260702-035018_puddle-sandboxed-rye-containers.md) · [`20260704-002912_gates-arms-and-the-urbit-lineage.md`](20260704-002912_gates-arms-and-the-urbit-lineage.md) · [`../gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) (Apache-2.0 · study only)

*Written by Rio 3 for Kaeden.*

---

## The Question, Named at Its Door

Kaeden asked two questions that share one spine:

1. **Over the wire:** How can Rye **resins** be as **zero-copy** as TigerBeetle discipline allows — tolling TAME style — when Comlink and Amphora carry them?
2. **On the drive:** What is the **maximum self-contained home snapshot** — importable and exportable like an ISO or a bootable **Aurora** · **Kumara** system — that reproduces **exact state**: the append-only log folded to the last **Mantra** · **Weave** moment, **Brix** configuration, and system truth — *just like Urbit*?

This writing keeps both questions in the **checkable room** where design can be witnessed, and names the **vision room** where Urbit parity is an orienting image rather than a claim already green.

---

## Part One — What a Resin Is (and What Zero-Copy Can Mean Here)

A **resin** is one content-addressed unit at grain size: stored bytes at a SHA3 working-tier name, cataloged in a signed manifest, sealed by **Amber (cellar software)**. The digest **is** the address and the proof. Tar, zip, and ISO wrappers may move bytes; they are **transport only** — never the trust boundary ([`resins-and-hash-tiers`](../context/specs/20260703-191112_resins-and-hash-tiers.md)).

**Zero-copy** in TigerBeetle's spirit is not a magic flag. It is a bundle of habits ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md), Apache-2.0, study only):

| Habit | Resin translation |
|-------|-------------------|
| **Control plane vs data plane** | Small signed **manifest deltas** and **toll** headers; large **resin bytes** on their own path |
| **Batching** | Many resin refs per Comlink frame — one toll, one verify pass, one CPU chunk |
| **No accidental copies** | Pass `*const` slices for payloads > 16 bytes; in-place struct init; no alias games |
| **Explicit I/O** | Zig 0.16 `io` threaded through read/send; no hidden globals |
| **Mechanical sympathy** | Sequential read of content-named files; mmap read-only where the host allows; `sendfile`-class seams at the boundary |

**Zero-copy over the wire** therefore means: *the receiver verifies the same bytes the sender named, without deserializing into a second owned buffer unless absorb truly requires it.*

Concretely, three lanes:

1. **Have-already lane** — peer sends `(tilak, sha3-256, length)` only; receiver hits local Tablecloth/Amber resin store; **zero bytes** cross the wire.
2. **Need-resin lane** — peer sends `(tilak, digest, length)` plus **raw resin bytes once**; receiver stores at content address; subsequent crosses use lane 1.
3. **Vessel lane** — **Amphora (vessel software)** carries a Kumara-signed manifest naming many resins; Comlink fetches by digest; verified twice at mouth and receipt.

Bron records and Weave facts should be **views** over immutable resin bytes (shape-cast at the seam), not parsed into heap graphs that re-encode on send. That is the Rye-side echo of TigerBeetle's fixed nouns: **the hot path names bytes; conversion is absorb's job, off the hot path.**

---

## Part Two — Toll, Batching, and Comlink Shape

**Toll** is the price of shared order ([`what-needs-ordering`](../active-designing/20260703-200712_what-needs-ordering.md)). On the resin wire, toll lands as:

- One **signed batch header** per Comlink message (Kumara, bounded fields, algorithm tag when tiers mix).
- One **manifest slice** — N manifest lines, each `<tilak> <sha3-256-hex> <name>`, capped by Tally budgets.
- Optional **resin payloads** only for misses — never re-send hits.

TigerBeetle teaches that the CPU wants **sprints**: one batch, one fold, one verification walk. A resin storm of single-resin RPCs would violate TAME performance second — and violate the itinerary law that prefers smallest **stops**, not smallest **packets**.

**Prepared operations only** enter the hot path: the sender prepares a batch (manifest + optional resins), signs it, sends it; the receiver refuses partial trust (Amphora **wreck rule** at vessel grain; unknown **Tilak** refused whole at type grain).

---

## Part Three — The Urbit-Shaped Goal (Concepts, Not Names)

Urbit's **pier** keeps a ship's life in one persistent folder; boot **replays** an append-only event log until the present returns; **pack** and **meld** husband snapshots; **double-boot** of one identity is a continuity catastrophe ([`puddle` exploration](20260702-035018_puddle-sandboxed-rye-containers.md) · Urbit docs in `gratitude/urbit/`, MIT, study only).

Our clean-room translation:

| Urbit image | Rye stack (our words) |
|-------------|----------------------|
| Pier folder | **Kumara identity** + **Weave** subgraph + **Mantra** HEAD + **Brix** closure + cellar catalog |
| Event log replay | Fold **signed facts** on **Weave** until **Mantra** projection matches pinned HEAD |
| Desk / `%base` | **Brix** descriptors + golden base merge policy (Pond customs) |
| Jam/cue wire | **Not adopted** — we carry **content-addressed resins** and **Bron** views, not noun jam |
| Marks / conversions | **Tilak** + absorb / express / tend |

**We do not import Urbit's gate, arm, or mark syntax** ([`gates-arms-and-the-urbit-lineage`](20260704-002912_gates-arms-and-the-urbit-lineage.md)). We import the **honesty**: *state is a fold over an append-only log of immutable signed facts* — already canon in Mantra · Weave · the receipt lap.

The user-facing promise, stated narrow enough to witness:

> Export the home world at HEAD. Boot Aurora on bare metal or a microVM. Replay the log slice. Land in the same Brix configuration and the same Mantra weave state as at export — with Kumara continuity enforced (one live identity; no double-boot).

That is the **sovereign snapshot**. It is **not** yet green on metal; it is the maximum **coherent** target the tree already points at.

---

## Part Four — Two Artifacts, Not One Blob

Amber's functional spec already names **two artifact kinds** ([`amber-functional-spec`](../context/specs/20260701-221512_amber-functional-spec.md)):

| Artifact | Duty | Urbit analogy | Boot shape |
|----------|------|---------------|------------|
| **Bootable clone** | Fast return — working tier restore | Pier you can boot tomorrow | Aurora installer / microVM image with replay engine |
| **Sealed archive** | Deep keep — disconnected cellar | Offsite pier copy | Resins on bare platters; scrub cold |

Collapsing both into "one ISO" hides the seam. **Cellar software** optimizes for bit-faithful cold keep; **vessel software** optimizes for crossing; **Aurora** optimizes for boot. One file format can **wrap** all three only after each lap is green alone.

---

## Part Five — Maximum Self-Contained Snapshot (Contents)

What belongs inside the **largest honest export** — the bounded union of everything required to reproduce state without network — stated as a checklist, not a build plan:

### A. Identity and trust (Kumara)

- Master and sandbox **public** material (never the cold master private key on export disks).
- Identity continuity facts — epoch, revocation certs, `PUBKEYS.md` slice.
- **Double-boot law** as a signed fact: this export is valid only while no other live instance claims the same identity.

### B. Append-only truth (Weave · Mantra)

- The **Weave** fact slice from genesis (or last amber-sealed checkpoint) through **HEAD**.
- **Mantra** projection metadata sufficient to verify HEAD without network.
- Optional **checkpoint resin**: periodic folded state as its own content-addressed resin (pack analog — defragment replay cost, not truth).

### C. Composition (Brix)

- Closed **Brix** descriptor set for the exported world — every brick's Tilak and digest.
- Build closure pins: Rye chronological stamp, Zig pin, parity count at export (checkable claim).

### D. Data plane (Tablecloth · resins)

- Every **resin** referenced by the fold — content-named resins, manifest lines only point.
- Rolling-chunk lineage ([`puddle` second pass](20260702-035018_puddle-sandboxed-rye-containers.md) · casync study): reproducible tree encoding, random access, mountable index — **tar is not the index**.

### E. Policy and enclosure (Pond · Caravan)

- Pond policy bundle as Bron — what may run, what may be placed.
- Caravan capability seeds for the services the world expects on first boot.

### F. Boot spine (Aurora)

- Minimal **Aurora** stage that knows how to: verify manifest → map resins read-only → replay Weave → hand off to Rishi.

### G. Catalog (Amber)

- Kumara-signed **archive log** copy on the export medium (self-describing drive law).
- Verification records through export stamp.

**Explicitly outside lap-one maximum** (vision room until claimed): live Comlink peers, GPU state, hosted Wayland metalsmoke, warm MALA balances on WOV — each needs its own lap and witness.

---

## Part Six — Import / Export Rites (Zero-Copy at the Drive Seam)

**Export rite (cellar season):**

1. Quiesce — Caravan drains children; Mantra pins HEAD.
2. Fold walk — enumerate Weave + Tablecloth closure; name every resin.
3. Seal — write resins to working-tier paths; compose `.bron` manifest; Kumara-sign.
4. Optional vessel — pour season into **Amphora** for offsite Comlink crossing.
5. Verify twice — write-time digest + independent oracle (`openssl dgst -sha3-256` today).

**Import rite (boot or restore):**

1. Verify manifest and signatures before any replay (Pond customs).
2. Map resins **read-only** — mmap or sendfile-class path; no unpack-to-temp trust boundary.
3. Replay Weave facts to HEAD — pure fold; no network.
4. Shape-cast Brix; run parity subset bundled with snapshot (snapshot carries its own witness claim).
5. Refuse whole on unknown Tilak, bad digest, or continuity violation.

**ISO / bootable USB:** the ISO is a **transport wrapper** around an already-verified Aurora image whose **trust lives in resins + manifest**, same as Amphora's vessel file is one whole file — not the proof itself.

---

## Part Seven — Performance Sketch (Back of the Envelope)

TigerBeetle's ordering: **network → disk → memory → CPU** (after frequency).

For a home snapshot of, say, 50–200 GiB working set:

| Resource | Dominant cost | Zero-copy move |
|----------|---------------|----------------|
| **Network** (Comlink) | Round trips | Batch refs; have-already lane; zstd **inside** resin only |
| **Disk** (archive tier) | Sequential read | Content-named files; one read per resin; checksum FS below Amber |
| **Memory** | Tally budget | Map read-only; stream decode in bounded garden; no whole-tree heap |
| **CPU** | Hash + verify | Batch SHA3; verify manifest once per vessel; replay fold incremental |

**Toll** buys deduplication: the second peer pays refs, not bytes. **Sameness** ([`sameness-is-the-macro`](../foundations/20260703-182612_sameness-is-the-macro.md)) is why one resin law serves cellar and vessel — same resin, same digest, same Tilak vocabulary; different software, same grain.

---

## Part Eight — SLC Laps (Simple, Lovable, Complete)

| Lap | Delivers | Witness idea |
|-----|----------|--------------|
| **1** | Single-directory Amber export (today's ring-1 tree) + manifest line shape | `amber_first_ring` — **144** ✅ |
| **2** | Weave slice + Brix closure in manifest; import replay to HEAD on host (no bare metal yet) | New: `snapshot_replay_witness` — red then green |
| **3** | Amphora vessel over Comlink; have-already + need-resin lanes | `amphora_comlink_resin_batch` |
| **4** | Bootable Aurora image; microVM (Puddle host); double-boot refused | `aurora_snapshot_boot` |
| **5** | Incremental export (rolling beads); pack checkpoint resin | `snapshot_incremental` |

No lap claims the Urbit sentence whole. Each closes one claim.

---

## Part Nine — What We Refuse (TAME Safety First)

- **Tar/zip/ISO as trust boundary** — transport only.
- **Mutable resin bytes** — digest would lie.
- **Silent re-encode on send** — breaks content addressing.
- **Unbounded manifest** — Tally names max lines, max resin size, max batch bytes.
- **Hot Kumara key on export disk** — ciphertext only; unlock is manual.
- **Two live instances, one identity** — continuity fact or refusal.
- **"Whole desktop works" as one witness** — happy-zone violation ([`claims-happy-zone-and-grain`](20260704-025600_claims-happy-zone-and-grain.md)).

---

## Part Ten — Counsel Back to Kaeden

**Should Amber and Amphora process the same resins?** Yes — **same resin bytes, same digest law, same Tilak registry** — different software duties (cellar vs vessel). Zero-copy is the reward for that sameness.

**Is the Urbit-like snapshot possible?** Yes as architecture — **replay the log, boot the pier** is already our fold doctrine. The maximum export is **Weave slice + resin closure + Brix + Kumara trust + Aurora boot spine**, not a mystery ISO.

**What is not decided tonight:** checkpoint frequency, bead size, whether Bron records inline small facts or always point to resins, and the exact Comlink frame layout. Those are **Kaeden-gated** or **witness-gated** stops — not gaps in the goal.

---

## Gratitude

**TigerBeetle** (Apache-2.0) — batching, control/data plane, in-place init, zero-accidental-copy habits in [`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md). **Urbit** (MIT) — pier, replay, pack/meld, double-boot hazard, studied in `gratitude/urbit/`. **systemd casync / desync** — reproducible chunk stores and the tar critique, named in the Puddle second pass. **Zig 0.16** — explicit `io` and `Init` handshake. Prior tree writings cited in companions above.

---

*May every resin cross the wire once, and every second crossing name a digest alone. May the cellar keep truth in place and the vessel keep truth in motion. And may the sovereign snapshot boot to the same HEAD the log earned — replay, not wish.*
