# 975 · Virtio — The Parity Device at the Emulated Wire

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*Comlink's wire grew in three rungs: shared memory between two harts, localhost datagrams between two processes, and next — a true device between two machines. Virtio is the name the industry gives to that third ground: a paravirtual device interface where guest and host agree on queues and descriptors rather than pretending to be legacy hardware. This brief silos what virtio *means* for our family — Aurora, Caravan, Tally, Comlink — so the device-wire seed grows from understanding, not from copying.*

**Language:** EN
**Version:** `20260620.041412` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety first; Gall's Law; `993` bounded network; `992` shape-casting at the edge
**Status:** Active Design (siloed)

---

## Our Own Ground

This is a clean room. We name only what is ours — **Rye**, **Rishi**, **Aurora**, **Caravan**, **Tally**, **Brix**, **Mantra**, **Pond**, **Comlink**, **Brushstroke**, **Skate** — together with **RISC-V** and **x86_64** where the machine matters. **Virtio** enters here as an open paravirtual device protocol: a concept for how a guest speaks to a host-provided device through shared memory queues, not as an invitation to import foreign driver code wholesale. Close reading of what we vendored in `gratitude/` informs the shapes; the driver we grow remains ours.

---

## What Virtio Is

Virtio is a **parity device** contract. The guest runs our freestanding code — Aurora's relay on RISC-V, Comlink's carrier, a future Caravan user-space stack. The host — today an emulator, tomorrow perhaps a thin hypervisor — offers a device that both sides understand without emulating a full PCI Ethernet card from the 1990s.

Three ideas carry the whole interface:

| Idea | What it means |
|------|----------------|
| **Feature bits** | Guest and host negotiate what the device can do before any packet moves. Capabilities are declared, not assumed. |
| **Virtqueues** | A bounded descriptor queue in memory both sides can see. The guest places work; the host completes it. Each queue has a stated depth. |
| **Descriptors** | Small records pointing at guest buffers — address, length, flags. A chain of descriptors can describe one logical transfer. |

The guest never trusts the host to guess buffer sizes. The host never trusts the guest to write past stated lengths. Every transfer names its edges — the same discipline Tally holds in a garden and `985` holds at the OS wrapper.

---

## Virtio-Net — One NIC, Two Roles

**Virtio-net** is the network device flavor of virtio. For Comlink's device wire, it is the honest next hop after `comlink/hosted_wire.rye`: two freestanding guests, each with a virtio NIC, frames moving through the emulator's switch rather than through loopback UDP on one kernel.

At a high level:

```
Guest A (sender)                Host / emulator                 Guest B (receiver)
     |                                |                                |
     |  TX virtqueue: "send this      |                                |
     |  frame from my buffer"         |                                |
     +------------------------------->|  route frame                   |
                                      +------------------------------->|
                                       |  RX virtqueue: "here is a     |
                                       |  frame; write into my buffer"  |
```

The **payload** we care about is still the sealed datagram from `posted.rye` — sender key, nonce, content-name, attestation, tag, ciphertext. Virtio carries **bytes**; Comlink carries **meaning**. Shape-casting (`992`) happens at the guest edge after the frame arrives: too short for the header, too long for the wire capacity, and the datagram is refused before a byte is trusted.

---

## The Wire Ladder — Where Virtio Sits

Comlink's wire grew by accretion. Each rung proved the datagram shape before the next added ground.

| Rung | Ground | What it proved |
|------|--------|----------------|
| **1 · Shared memory** | `aurora/src/posted.rye` — two harts, one mailbox | Seal, shape-cast, open on bare metal |
| **2 · Hosted UDP** | `comlink/hosted_wire.rye` — localhost port 38472 | Same datagram across processes and libc sockets |
| **3 · Device wire** | virtio-net between two guests (`10016`) | Same datagram across an emulated link |
| **4 · Living network** | Comlink v1 — typed delivery, exactly-once by name (`993`) | Values in motion, channel untrusted |

Virtio is rung three. We do not skip to rung four while rung three is still a sketch.

---

## How Our Modules Meet Virtio

**Comlink** owns the datagram. Offsets, crypto, and content-naming stay identical to `hosted_wire.rye`. Virtio moves the octets; Comlink opens the value.

**Aurora** wakes the guest. The virtio driver is freestanding Rye on RISC-V: map the device's MMIO region, negotiate features, set up TX and RX queues in a Tally-bounded region, poll or interrupt for completion. The boot relay that already runs on QEMU's `virt` machine is the same ground the NIC attaches to.

**Caravan** will own the process that holds the NIC long-term. Today the seed runs hosted; on the device wire, a user-space Comlink process (supervised, restart on fall) is the shape Caravan v1 composes toward. The kernel forwards frames; Caravan decides who may speak.

**Tally** bounds every queue depth, every RX buffer, every pending descriptor chain. A flood meets `error.OutOfBounds` at the garden edge rather than silent heap growth.

**Mantra** names what crossed the wire if we persist a capture — content-addressed proof that a particular datagram was seen. Exactly-once delivery in `993` leans on those names.

**Rye** types the driver and the datagram layout. **Rishi** will script bring-up tests once the guest can speak. **Brix** will declare which guests peer and which virtio features are required — a value read before the machines boot.

---

## The Smallest Seed (Gall's Law)

The device wire is not "Comlink v1." It is the smallest NIC that speaks:

1. **One guest, one virtio-net device** — map BAR, negotiate, post one TX descriptor, see completion GREEN.
2. **Two guests** — guest A transmits a fixed test pattern; guest B receives it on RX; lengths and bytes match.
3. **Sealed payload** — replace the test pattern with the 216-byte datagram from `hosted_wire.rye`; guest B shape-casts and opens; message reads `Meet me where the rye grows.`

Each step is one file or one pair of binaries, one proof, behind the gates where hosted code allows. Driver study (`10016` Track D) stays parallel and lands in strengthening notes — format hardening waits on honest close reading, not on hurry.

---

## What We Wrap and What We Trust

Virtio invites the same wrapping discipline as `985`:

- **MMIO reads and writes** stay inside narrow functions that assert offset and width.
- **Descriptor chains** are validated before trust: length within buffer, chain length within stated maximum, indices within queue depth.
- **RX completion** copies into a Tally-bounded buffer, then shape-casts — the guest trusts its own layout and crypto, not the bytes as they arrived.

The channel remains untrusted (`993`). A corrupted frame fails attestation or AEAD open; a duplicated frame is a name already seen. Virtio is transport; Comlink is meaning.

---

## Caveats

- **Emulator first.** QEMU's virtio-net on `virt` is the honest lab. Metal hypervisors and assigned devices are horizon; the protocol contract is the same.
- **No format fork.** Datagram offsets and algorithms stay aligned with `posted.rye` and `hosted_wire.rye`. Virtio changes the carriage, not the letter.
- **Study before harden.** Queue layouts and endian details belong in close-reading notes under `gratitude/` before we freeze driver structs.
- **Hosted parallel.** Caravan chain-loading and Skate's glyph grid remain valid threads; virtio is deep work and earns its own runs (`10017` ordering).

---

## Longer Horizon

When the device wire is green, Comlink grows toward full **bounded network** semantics: peers declared in Brix, identities rooted in `994`, relay behavior informed by close reading, Pond enclosures holding the processes that speak. Caravan v1 names which guest may open which capability — including the virtio queue handles. Aurora's last boot stage hands a verified system to that supervisor. Virtio is one device in a larger machine; the datagram that crosses it is the same value that already crossed memory and localhost.

---

## Conclusion

Virtio is how a freestanding guest asks the host for network service without feigning antique hardware. For us it is the third rung of Comlink's wire — shared memory, then UDP, then a parity NIC — each rung carrying the same sealed datagram shape. We grow the driver the way we grow everything: one queue that works, one frame that moves, one message that opens, each step named and proved before the next speaks.

---

*May the queues stay bounded, the descriptors honest, and the datagram unchanged in meaning as it crosses new ground. May virtio be transport only — and may Comlink still recognize the rye when it arrives.*
