# Puddle — Sandboxed Rye OS Environments (Exploration)

*A research note on a possible VM layer: many isolated Rye wholes — each with its own Pond, Kumara keys, and module graph — running as state-as-snapshot containers, sealed for Amber the way our archive contract demands rather than as opaque tarballs.*

**Stamp:** `20260702.035018`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Exploration — external research only; no implementation
**Second pass:** `20260702.165412` UDT — searched ground and sources appended; rust-vmm corrected
**Companions:** [`context/specs/20260701-221512_amber-functional-spec.md`](../context/specs/20260701-221512_amber-functional-spec.md) · [`active-designing/20260702-031312_modules-aspects-and-mailable-money.md`](../active-designing/20260702-031312_modules-aspects-and-mailable-money.md)

*Named by Kaeden (`2026-07-02`). Puddle is a small word for many bounded worlds — each whole, each shallow from the host's view, each deep to the agent inside.*

---

## The shape we are exploring

**Puddle** would be our own VM orchestration layer for **Rye OS sandbox containers**:

- Each container carries a **full Rye environment** — Caravan supervision discipline, a **sandboxed Pond** with policy-as-value, and a **Kumara keypair** scoped to that world.
- **State is a snapshot** — the whole machine image plus the append-only logs that fold into it — exportable, verifiable, and restorable through Amber's three verbs (export / verify / restore).
- The host runs many Puddles side by side without sharing memory or identity across the waterline.

This is not Pond itself. Pond is the enclosure aspect inside a running whole. **Puddle** is the layer that *hosts* many Ponds — the way a host runs many QEMU guests, yet each guest believes it owns the machine.

---

## Three gratitude lineages (concepts only)

| Source | What we study | What we borrow into our vocabulary |
|--------|---------------|-------------------------------------|
| **Urbit** — pier / ship / desk | A pier is a persistent identity world; Clay desks version code; `%sandbox` desk is an isolated workspace merged from `%base` ([Urbit filesystem docs](https://docs.urbit.org/user-manual/os/filesystem)) | One **identity per container**, revision-controlled interior, explicit merge from a golden base — not the Urbit stack itself |
| **Urbit Fleet** ([github.com/urbit/fleet](https://github.com/urbit/fleet)) | Scripts to spawn and federate many testnet ships | **Fleet orchestration** — start N isolated worlds, wire them for test — adapted as Caravan-supervised child processes or VMs, not Nock |
| **KVM / QEMU** | Hardware virtualisation; snapshot, restore, live migration | **Snapshot semantics** — pause, seal state, resume — the mechanical floor under Amber-compatible export |
| **rust-vmm** ([github.com/rust-vmm](https://github.com/rust-vmm)) | Shared Rust crates for building minimal virtual machine monitors; the foundation beneath Firecracker and Cloud Hypervisor, whose microVMs boot in milliseconds with a tiny device model | A **Rust seam candidate** for the hypervisor host path — identity-bearing frontier work stays Rust until Rye proves the lap |

Clean-room rule holds: we read public docs and study design; Puddle's implementation enters through `active-designing/` in our words only.

---

## Amber-compatible snapshots (not tar and zip)

Amber asks for **bit-faithful, signed, verifiable** archives — not convenience bundles that hide corruption.

Explored families (external names for gratitude only):

| Approach | Strength | Fit for Puddle + Amber |
|----------|----------|-------------------------|
| **Content-addressed sealed records** (our Amber contract) | Export / verify / restore on two paths; Kumara-signed | **Primary** — same shape as Mantra log slices and package bodies |
| **Zstandard framed streams** | Fast, checksum-friendly, streamable | Compression **inside** the sealed record, not as the trust boundary |
| **Filesystem send/receive** (e.g. btrfs) | Block-level incremental snapshots | Host seam for **live** snapshot; still wrapped in Amber verify on export |
| **Restic / casync-style** | Dedup, incremental | Study for **incremental** export; must still fold to content-named resins in Tablecloth |
| **tar / zip** | Universal | **Not** the trust boundary — opaque bags; at most a transport wrapper around an already-verified seal |

The TAME-guided archive is: **fold state → seal with Kumara → content-name in Tablecloth → verify on two paths → restore as log replay**. Puddle snapshots should export that shape, not a opaque blob alone.

---

## Module map (exploration)

| Piece | Role in Puddle |
|-------|----------------|
| **Caravan** | Supervises Puddle host and child lifetimes |
| **Pond** | Enclosure inside each container — policy bounds what runs |
| **Kumara** | One keypair per container; no cross-Puddle signing |
| **Tally** | Memory budgets per container |
| **Amber** | Export whole-container snapshot cold; verify without warm keys |
| **Comlink** | Fact lane between host and guest Puddles when networking lap opens |

first lap (horizon): one QEMU (or equivalent) guest running one hosted seed, export snapshot, verify digest, restore — witnessed once.

---

## Open questions

- Hypervisor: KVM/QEMU first vs userspace container with virtio devices only?
- Identity: Kumara per Puddle generated at spawn, or derived from owner seed with namespace salt?
- Fleet size: how Caravan restart policy applies when a Puddle falls?
- Relationship to **Mantrapod** export door — same Amber record shape?

---

## The searched ground — second pass (`20260702.165412`)

Kaeden asked for the sources themselves, so this pass reads them directly and brings back what they teach.

**What the pier teaches.** The identity-world lineage keeps a ship's entire life in one folder — the *pier* — and its documentation is a chorus of our own convictions sung back to us. Boot is literally a fold: the runtime *replays events* from an append-only log until the present returns (`pier: replaying events … play: done`). Snapshot husbandry has two named verbs — *pack* defragments the snapshot, *meld* deduplicates it, sometimes halving its size. Development runs on *fake ships*: keyless local worlds spawned with one flag that automatically network with each other on the same machine — which is precisely Puddle's first-lap shape, a fleet of small worlds on one host, wired for witness. And the sternest lesson is the double-boot law: run two copies of one identity, or boot from a stale copy, and continuity breaks so badly the network must be asked to forget you. Puddle adopts that as an invariant from birth: **one live instance per Kumara identity**, enforced by a signed continuity fact, so the hazard the pier documents becomes a state Puddle rules out by construction.

**The microVM lineage.** The Rust virtualization ecosystem gathers its shared machinery in the rust-vmm crates, and the monitors built on them prove the shape Puddle wants for its host: a device model kept tiny on purpose, guests that boot in milliseconds, and a security posture that treats the monitor as the smallest possible trusted surface. When Puddle's season opens, the host path is a minimal monitor in that family at the seam — while QEMU remains the roomier vehicle we already run for cross-architecture work.

**The archive verdict — beyond tar and zip.** The strongest modern answer to the archive question was designed by the content-addressed synchronization lineage, and its author names tar's dishonesties plainly: no index, no random access, and many valid serializations of one tree, so the same directory can produce different bytes on different days. The replacement shape has four parts. A **rolling hash** cuts the stream at content-defined boundaries — sixteen to two-hundred-fifty-six kilobytes in practice — so a small edit reseals a small region rather than the whole. Each chunk is **named by its strong digest** and stored as its own compressed resin. A small **index** lists the resins in order, and reassembly is concatenation plus verification; the index can even be mounted read-only, the whole archive standing as a filesystem without unpacking. And the directory serialization itself is **reproducible and random-access** — exactly one valid representation per tree, verifiable end to end. A faster sibling implementation proves the format travels across languages and adds parallel chunking, chunk servers, and seed-based reassembly from files already on disk.

Read through TAME, the verdict writes itself, and it is the one this memo's first pass reached on instinct: **Amber's seal is a Kumara-signed manifest naming content-addressed resins** — the manifest a `.bron` value, the resins SHA3-named, the whole archive a Weave subgraph that folds back into state. What the search adds is confidence and a seam: the chunk-store family above is the proven implementation to lean on at the host boundary today, the mountable index is the shape of a bootable clone, and tar survives only as a transport wrapper around an already-sealed, already-verified record — never as the trust boundary itself.

---

## Sources

- https://docs.urbit.org/user-manual/running/vere
- https://docs.urbit.org/build-on-urbit/environment
- https://docs.urbit.org/manual/os/ship-troubleshooting
- https://0pointer.net/blog/casync-a-tool-for-distributing-file-system-images.html
- https://github.com/systemd/casync
- https://github.com/folbricht/desync
- https://github.com/rust-vmm
- https://firecracker-microvm.github.io/

---

*May each Puddle hold its own sky. May snapshots seal honestly. May the host carry many worlds without confusing their keys.*
