# SLC-L2 — Sealed Delivery

*A signed sanctuary receipt travels identity to identity under Comlink's seal — SLC-L1's fact loop unchanged, the carriage proven on hosted UDP first, device wire for the civic story already green.*

**Stamp:** `20260706.000812`
**Voice:** Rio 3
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · SLC · Gall's Law · core+shell
**Register:** active-designing — names only our modules
**Status:** Seated — checkable-room lap brief; hosted path GREEN on metal; parity **155**
**Ground:** [`20260702-195426_slcl1-verifiable-receipt.md`](20260702-195426_slcl1-verifiable-receipt.md) · [`20260705-225412_comlink-device-wire.md`](20260705-225412_comlink-device-wire.md) · [`../external-research/20260705-235412_device-wire-dependencies-down-to-caravan-tally.md`](../external-research/20260705-235412_device-wire-dependencies-down-to-caravan-tally.md) · [`comlink/wire_format.rye`](../comlink/wire_format.rye) · [`comlink/hosted_wire.rye`](../comlink/hosted_wire.rye)

---

## The lap in one sentence

**SLC-L2** is SLC-L1's signed receipt sealed with `wire_format` and delivered over Comlink — Bob opens the datagram, verifies the inner signature, and folds balance without trusting the UDP seam.

---

## What SLC-L2 is

| Word | Meaning for this lap |
|------|----------------------|
| **Simple** | One fixture fact, one compact payload, one localhost UDP hop |
| **Lovable** | Alice's stipend record reaches Bob's machine under seal |
| **Complete** | sign → seal → send → open → verify → fold closes on metal |

The **outer seal** uses Comlink fixture keys (Alice → Bob). The **inner receipt** uses the SLC-L1 deterministic signer — two layers, honestly named.

---

## Payload shape — compact, bounded

The hex log line from SLC-L1 exceeds `wire_format.max_message`; this lap carries a **compact binary payload**:

| Region | Size | Content |
|--------|------|---------|
| signature | 64 bytes | Ed25519 over canonical fact |
| fact_len | u32 LE | length of canonical `.bron` bytes |
| fact | ≤ 256 bytes | canonical fact (fixture fits) |

Encoded in `linengrow/receipt_core.rye`; sealed by `wire_format.sealMessage`.

---

## Modules

| Module | Role |
|--------|------|
| `linengrow/receipt_core.rye` | Shared parse, verify, fold, compact payload |
| `linengrow/receipt.rye` | SLC-L1 selftest (unchanged witness surface) |
| `linengrow/delivery.rye` | SLC-L2 send / recv / demo / selftest |
| `comlink/wire_format.rye` | `sealMessage` — arbitrary bounded plaintext |

Port **38473** — distinct from hosted wire demo (**38472**).

### Device wire variant (landed `20260706.001512`)

| Guest | Role |
|-------|------|
| `comlink/guest_receipt_tx.rye` | Sign witness fact, `sealMessage`, virtio TX |
| `comlink/guest_receipt_rx.rye` | Open datagram, verify receipt, fold balance |
| `comlink/run_receipt_wire_lab.sh` | QEMU socket lab on port **15556** |

`virtio_net.max_frame` raised to **554** — virtio/eth headers plus full `wire_format.wire_capacity` datagram (**528**; receipt, OA request/application, and OA escrow payloads).

`comlink/receipt_core.rye` symlinks `linengrow/receipt_core.rye` for freestanding import.

---

## Witness — `tools/slcl2_receipt.rish`

**Welcome path:**

1. Build `linengrow/bin/delivery`
2. `selftest` — seal, open, verify in one process
3. `demo` — recv child, send child, balance 100

**Witness:** one block after SLC-L1 receipt → **155** (hosted demo + device wire lab).

---

## Edge of complete

### In scope

- Hosted UDP delivery of signed receipt under Comlink seal
- Reuse `tools/fixtures/slcl1_fact.bron`
- Witness green on metal

### Horizon for later laps

- Device wire variant of SLC-L2 (civic proof path — carriage already green)
- Caravan-supervised peers
- Open Asks room
- Sui settlement (SLC-L3)
- Resin-batch frame (I1)

---

*May the receipt stay verifiable after the seal opens. May the wire carry the fact unchanged.*
