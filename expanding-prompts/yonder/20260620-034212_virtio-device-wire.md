# 10016 · Virtio-Net Device Wire

*Expanded at `034212` after Comlink's hosted wire: the same sealed datagram that crossed shared memory (`posted.rye`) and localhost UDP (`comlink/hosted_wire.rye`) is ready to cross a **real emulated link** — virtio-net between two QEMU guests — without braiding driver study, close-reading, and format hardening into one push.*

**Language:** EN
**Version:** `20260620.034212` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — Gall's Law; `993` bounded network; `10014` device-wire frame

---

## The Seed

> Hosted wire is green at `034212`. The device wire is next.

## The Mission

**Track E** from `10014`: carry the sealed datagram shape over virtio-net between two freestanding guests.

| Track | Milestone | Gall's test |
|-------|-----------|-------------|
| **A** | **virtio-net bring-up** — one guest sees a virtio NIC, can TX/RX a raw frame | Smallest NIC that speaks |
| **B** | **Two-guest wire** — guest A sends bytes; guest B receives | One hop, one proof |
| **C** | **Sealed payload** — same layout as `hosted_wire.rye` / `posted.rye` | Format unchanged |
| **D** | **Close-reading notes** — virtio queue layout from `gratitude/` | Before format hardens |

**Defer this run:** Caravan capability table (`984` step 5) unless a virtio stage needs named capabilities.

## Discipline

- **Gall:** one guest NIC first, then two guests, then seal — no capability table braid.
- Reuse datagram offsets and crypto from `hosted_wire.rye`; do not fork the format.
- Session log + commit when each track is green.

---

*May the packet cross the emulated link as honestly as it crossed localhost — same shape, new ground.*
