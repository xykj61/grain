# Comlink Device Wire — The Virtio Carriage for the Sealed Datagram

**Language:** EN
**Stamp:** `20260705.225412 UDT`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first at the untrusted channel; performance second; joy in the rye-field message crossing a real device
**Register:** active-designing — names only our modules
**Status:** Seated — checkable-room lap brief; sub-laps 1–3 GREEN on metal; parity **154** wired
**Ground:** [`comlink/hosted_wire.rye`](../comlink/hosted_wire.rye) · [`comlink/wire_format.rye`](../comlink/wire_format.rye) · [`20260705-233012_virtio-tx-ruling.md`](20260705-233012_virtio-tx-ruling.md) · [`20260705-231300_virtio-tx-counsel-handoff.md`](20260705-231300_virtio-tx-counsel-handoff.md) · [`yonder/20260620-041412_virtio-the-device-wire.md`](yonder/20260620-041412_virtio-the-device-wire.md) · [`20260704-211012_the-rye-core-and-the-shell.md`](20260704-211012_the-rye-core-and-the-shell.md) · [`../external-research/20260705-235412_device-wire-dependencies-down-to-caravan-tally.md`](../external-research/20260705-235412_device-wire-dependencies-down-to-caravan-tally.md) · lineage: [`../external-research/20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md`](../external-research/20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md) · [`../counsel/20260704-181612_zero-copy-resins-counsel-answers.md`](../counsel/20260704-181612_zero-copy-resins-counsel-answers.md)

*Written in Rio 3's Radiant voice, counseled with Kaeden and Claude.*

---

## The lap in one sentence

The device wire carries the **same** sealed datagram from `hosted_wire.rye` across virtio-net between two Aurora RISC-V guests on QEMU `virt` — virtio moves the octets, Comlink keeps the meaning. No format fork: the letter stays, only the carriage changes.

## Why this lap

It is the exact carriage **SLC-L2** needs. Once sub-lap three greens, a signed sanctuary receipt can travel identity to identity under seal, and the civic flow becomes real end to end. One lap carries both the Rye compose spine and the Linengrow why.

**Edit-5:** this lap reuses the frozen frame and does **not** occupy the Edit-5 slot. Snapshot export (I2) still precedes resin-batch frame (I1) when that slot opens.

## Lineage — what this lap inherits and what it defers

Yes — the safety and performance discipline on Comlink wire datagrams shares DNA with the zero-copy resins research, yet the device wire inherits that discipline **through the single-datagram letter** in `wire_format.rye`, not by building the resin-batch frame those documents design for the step after.

**Shared habits (already in `hosted_wire.rye`, carried unchanged to the device wire):**

| Habit | Where it lives today |
|-------|----------------------|
| **Control before data** | Ed25519 signature covers the **name** (SHA3 digest of ciphertext); the payload proves itself by digest — one verify pass, no second integrity walk |
| **Shape-cast at the edge** | Receiver refuses malformed lengths; opens only after crypto checks — view over arrived bytes, not a re-encoded owned graph |
| **Bounded everything** | `wire_capacity`, `max_message`, Tally-bounded virtqueue depth and `max_frame` on `WireSubject` |

The core-and-shell brief names this vow at the wire: *control before data — signed headers verified once; payloads prove by digest.* TAME carries TigerStyle ordering (network, disk, memory, CPU) into every host-touching lap; the resins research translates that same discipline into Amphora grammar.

**Deferred deliberately (I1 — Edit-5 slot, after I2):**

Batching many resins under one signed batch header, the have-already and need-resin lanes, and the frame fields in counsel **I1** — that is the **batched generalization** of the single datagram this lap moves. Same law, more resins. When I1 opens, [`20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md`](../external-research/20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md) and [`20260704-181612_zero-copy-resins-counsel-answers.md`](../counsel/20260704-181612_zero-copy-resins-counsel-answers.md) are its direct blueprint.

**Order on the table (coherent, not in tension):** device wire proves rung three now · I2 snapshot export takes Edit-5 first when opened · I1 resin-batch frame second · this lap runs beside Edit-5 on its own ladder.

## Core and shell

| Layer | Artifact | Duty |
|-------|----------|------|
| **Format** | `comlink/wire_format.rye` | Shared offsets, seal, open — one letter for every rung |
| **Core** | `comlink/device_wire.rye` | Virtio-net driver algebra; explicit `WireSubject`; freestanding on `virt` |
| **Shell** | `tools/comlink_device_wire.rish` | Run lab (pattern + sealed); observer only |
| **Hosted rung** | `comlink/hosted_wire.rye` | Imports `wire_format` — localhost UDP unchanged in meaning |

### Explicit subject (`WireSubject`)

```text
mmio_base     — virtio-net MMIO region on virt
queue_depth   — Tally-bounded virtqueue depth
max_frame     — maximum RX/TX frame bytes accepted
datagram      — buffer holding the sealed payload (wire_capacity)
```

Horizon holds: the core trusts its own layout and crypto, never the bytes as they arrived.

## The ladder — three sub-laps

Gall's Law seed from yonder brief `10016` — each sub-lap is one proof; parity wires only after sub-lap three.

| Sub-lap | Proof | Status |
|---------|-------|--------|
| **1** | Fixture virtio descriptor validation + `wire_format` seal/open — no live link | **Landed** — `device_wire selftest` GREEN |
| **2** | Two QEMU `virt` guests — fixed pattern TX/RX, lengths and bytes match | **Landed** — `run_device_wire_lab.sh` pattern lap GREEN |
| **3** | Sealed datagram payload — receiver opens; message reads *Meet me where the rye grows.* | **Landed** — sealed lap GREEN → parity **154** when wired |

## Lab topology (confirmed)

Two guests join through a **QEMU socket netdev** with `-global virtio-mmio.force-legacy=false` (modern transport). See [`20260705-233012_virtio-tx-ruling.md`](20260705-233012_virtio-tx-ruling.md).

## Witness discipline

- Sub-laps 1–3: `tools/comlink_device_wire.rish` — wired parity **154**
- Hosted wire witness stays green — `wire_format` extraction must not fork offsets

## TAME order

1. **Safety** — corrupt frames fail attestation; duplicate names refused; descriptor chains validated before trust; MMIO reads/writes in narrow asserted functions
2. **Performance** — bounded queues and RX buffers; no silent heap growth
3. **Joy** — the rye-field message crossing a real device

---

*May the letter stay one letter as the carriage widens. May sub-lap one green on fixtures before the guests wake. And may the wire that serves the spine also carry the why home.*
