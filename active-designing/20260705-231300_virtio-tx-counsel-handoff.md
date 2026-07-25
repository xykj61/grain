# Virtio TX Counsel Handoff — Sub-lap 2 Blocker on QEMU 8.2 `virt`

**Language:** EN
**Stamp:** `20260705.231300 UDT`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Register:** active-designing — counsel request for Claude; Rio 3 → Claude ruling
**Status:** Answered — checkable-room counsel handoff; ruling seated at [`20260705-233012_virtio-tx-ruling.md`](20260705-233012_virtio-tx-ruling.md); sub-laps 2–3 GREEN on metal
**Ground:** [`20260705-225412_comlink-device-wire.md`](20260705-225412_comlink-device-wire.md) · [`../comlink/virtio_net.rye`](../comlink/virtio_net.rye) · [`session-logs/archive/20260705/20260705-230100_device-wire-sub-lap2-grain.md`](../session-logs/archive/20260705/20260705-230100_device-wire-sub-lap2-grain.md) · yonder [`20260620-041412_virtio-the-device-wire.md`](yonder/20260620-041412_virtio-the-device-wire.md)

*Rio 3 prepared this handoff at Kaeden's invitation so Claude can rule without re-climbing the same blind alleys.*

---

## What we need from counsel

A **ruled answer** on how freestanding Rye should program virtio-net TX (and RX) on **QEMU 8.2.2** `riscv64 -machine virt` with `-device virtio-net-device` — legacy vs modern MMIO queue path, init order, and whether our lab topology is correct. Once ruled, sub-lap 2 (fixed pattern TX/RX) and sub-lap 3 (sealed datagram) are mechanical on the ladder already seated.

---

## What is already GREEN

| Proof | Evidence |
|-------|----------|
| Sub-lap 1 hosted | `device_wire selftest` — descriptor chain validation + `wire_format` seal/open |
| Guest boot | Freestanding guests reach UART; `initDevice()` completes; `driverOk()` runs |
| MMIO discovery | `findNetDevice()` finds net at slot **7**, base **`0x10008000`** |
| Feature negot | `FEATURES_OK` sticks (`status == 0x0b` after init) |
| RX path (partial) | RX guest posts buffer, polls; times out with explicit FAIL line (no silent hang) |

**Parity:** 153 holds. Linktest **not** wired to witness until GREEN.

---

## What fails

**Symptom:** After posting a TX descriptor and writing `QUEUE_NOTIFY` for queue **1**, **`used.idx` never advances** from 0. Guest spins until timeout.

**Lab:** `comlink/run_device_wire_lab.sh` — RX `listen`, TX `connect` on socket netdev. Same hang on single-guest TX with `-netdev user`.

**Not the problem (ruled out in session):**
- Wrong MMIO base (discovery scan finds id=1 at slot 7)
- Hang before `driverOk` (UART progress: `q init` → `driver ok` → `send` → hang)
- Non-volatile read of `used.idx` alone (volatile poll added; still zero)
- Stack-allocated vring (moved to fixed guest RAM pages)

---

## QEMU / MMIO observations (metal)

Host: `qemu-system-riscv64` **8.2.2** (Debian). Command pattern:

```bash
qemu-system-riscv64 -machine virt -bios none -nographic \
  -device virtio-net-device,netdev=net0 -netdev user,id=net0 \
  -kernel comlink/.build/pattern-tx.elf
```

**MMIO slot scan** (magic `0x74726976`):

| Slot | Base | Version | Device ID |
|------|------|---------|-----------|
| 0–6 | `0x10001000` + n×0x1000 | 1 | 0 (empty transports) |
| **7** | **`0x10008000`** | **1** | **1 (net)** |

**After `initDevice()` on slot 7:**

| Probe | Modern offset (`0x028` sel) | Legacy offset (`0x030` sel) |
|-------|-----------------------------|-----------------------------|
| TX queue max | `queue_num_max` @ `0x02c` → **0** | `queue_num_max` @ `0x034` → **0x400** (1024?) |
| `QUEUE_READY` @ `0x044` | 0 | — |

**Device features (before negot):** `feat0=0x39bf8064`, `feat1=0` — **no `VIRTIO_F_VERSION_1` in high word**.

**Driver features we accept today:** `feat_mac` only (`negotiateFeatures`).

**Reference tension:** MIT `xv6-riscv` `virtio_disk.c` / sa2304 `virtio_net.c` expect **`VERSION == 2`**, modern split queues (`QUEUE_DESC_LOW` @ `0x080`, separate pages for desc/avail/used), `QUEUE_READY`. Our device reports **version 1** at the net slot; modern `queue_num_max` reads **zero**.

---

## Approaches tried (all: `used.idx` stays 0)

1. **Modern split queues** — three 4 KiB guest pages @ `0x80400000` / `0x80401000` / `0x80402000`; `QUEUE_READY=1`; single-descriptor TX (hdr+eth+pattern); `hdr_len` set in virtio-net header.
2. **Legacy PFN vring** — single page vring; `QUEUE_SEL` @ `0x030`, PFN @ `0x040`; align 4 and 4096; buffers inside PFN page.
3. **Two-descriptor chain** — hdr desc + body desc (matches sub-lap 1 fixture algebra).
4. **Feature sets** — MAC only; all low 32 bits of offered features.
5. **Interrupt ack** — considered; polling should still work per spec.
6. **PCI virtio-net** — scan shows no MMIO net at slot 7; not pursued (no PCI driver in tree).

---

## Current tree layout

```
comlink/virtio_net.rye          # types, findNetDevice, initDevice, TxQueue/RxQueue
comlink/guest_pattern_tx.rye    # freestanding TX guest
comlink/guest_pattern_rx.rye    # freestanding RX guest
comlink/run_device_wire_lab.sh  # two-guest socket lab
comlink/device_wire.rye         # hosted sub-lap 1; imports virtio_net
```

Fixed guest RAM (current):

```
0x8040_0000  desc page
0x8040_1000  avail page
0x8040_2000  used page
0x8040_3000  TX buffer
0x8040_4000  RX buffer
```

Link pattern: 32 bytes `0xAB` after virtio-net hdr + ethernet hdr; ethertype `0x1201` (lab).

---

## Questions for Claude

1. **Which queue programming model is canonical for QEMU 8.2 `virt` + `virtio-net-device` when the net device shows `version=1` at slot 7 and modern `queue_num_max=0`?** Legacy PFN only, or modern split queues after a feature bit we are not negotiating?

2. **Is `0x400` at legacy `0x034` after sel=1 actually `queue_num_max`?** If yes, does PFN vring layout require the Linux `vring_size()` padding (`+2` halfwords after avail ring) — we tried offset 76 and 80 for used ring.

3. **Must both RX and TX virtqueues be initialized before `DRIVER_OK`?** xv6 `virtio_net_init` sets up queues 0 and 1; our guests currently init only their role's queue.

4. **Is our QEMU command line missing a bus attachment or property** that would expose version 2 (like xv6's `VIRTIO1` at `0x10008000` with version 2)? Should we attach with `bus=virtio-mmio-bus.N` or a different device type?

5. **Ruled init order** — confirm: ACK → DRIVER → features → FEATURES_OK → setup all queues → DRIVER_OK → post avail → notify → poll used. Any MMIO fence requirements on RISC-V we missed beyond `fence iorw, iorw`?

6. **Gratitude close-reading target** — which source in `gratitude/` (Linux `virtio_mmio.c`, QEMU `hw/riscv/virt.c`, OASIS virtio 1.2 §4.2) should we treat as authoritative for the next pass?

---

## Repro for Claude on metal

```bash
cd ~/veganreyklah2
export RYE_ZIG=vendor/zig-toolchain/zig

# Build TX guest
rye/bin/rye build comlink/guest_pattern_tx.rye \
  -target riscv64-freestanding-none -mcmodel=medium -fno-entry \
  -T aurora/layout.ld -femit-bin=comlink/.build/pattern-tx.elf

# Single-guest hang (8s timeout)
timeout 8 qemu-system-riscv64 -machine virt -bios none -nographic \
  -device virtio-net-device,netdev=net0 -netdev user,id=net0 \
  -kernel comlink/.build/pattern-tx.elf
# Expect: no output after init; or add UART markers in guest_pattern_tx if needed

# Sub-lap 1 still green
rye/bin/rye build comlink/device_wire.rye -lc -femit-bin=comlink/bin/device-wire
comlink/bin/device-wire selftest
```

---

## Grain constraints (non-negotiable for the ruling)

- No format fork — `wire_format.rye` unchanged for sub-lap 3.
- Clean room — study `gratitude/`; implement in our vocabulary only.
- Gall's Law — smallest TX completion before sealed payload.
- Witnesses first — no parity **154** until sub-lap 3 greens.

---

*May counsel name the queue path honestly. May the next pass climb one ruled rung rather than three guessed ones.*
