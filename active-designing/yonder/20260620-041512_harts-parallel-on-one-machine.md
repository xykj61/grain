# 974 · Harts — Parallel Execution on One Machine

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*Before Comlink carried a sealed datagram between two machines, it carried one between two harts — two hardware threads on the same RISC-V silicon, sharing RAM, waking together at `_start`. A **hart** is the smallest honest unit of parallel execution on bare metal: not a process, not a hosted thread, but a core the architecture names with `mhartid` and expects us to stack, route, and fence correctly. This brief silos what harts *mean* for Aurora and Comlink so every two-hart stage reads as deliberate design, not emulator accident.*

**Language:** EN
**Version:** `20260620.041512` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety first; Gall's Law; `991` Aurora relay; `992` shape-casting at the edge
**Status:** Active Design (siloed)

---

## Our Own Ground

This is a clean room. We name only what is ours — **Rye**, **Aurora**, **Caravan**, **Tally**, **Comlink**, **Mantra**, **Brix**, **Pond**, **Rishi** — together with **RISC-V**, the instruction set where *hart* is the architecture's own word for a hardware execution thread. On **x86_64**, the analogous idea is a logical processor sharing an address space with its siblings; Aurora speaks RISC-V first, so *hart* is the vocabulary we keep on bare metal. Hosted parallelism — processes, supervised children — lives in Caravan's world; harts live in Aurora's.

---

## What a Hart Is

A **hart** is one runnable RISC-V execution context: its own program counter, registers, and stack pointer, sharing physical memory with every other hart on the same chip or in the same emulator.

| Term | What it names |
|------|----------------|
| **Hart** | One hardware thread on RISC-V — the unit QEMU counts with `-smp N` |
| **`mhartid`** | A read-only CSR: the hart's small integer identity (0, 1, 2, …) |
| **SMP** | Symmetric multiprocessing — several harts, one memory map, one entry point |

When the machine resets with `-bios none -kernel`, **every hart begins at the same `_start`**. There is no operating system to assign roles. Aurora's freestanding code reads `mhartid`, gives each hart its own stack, and routes to sender or receiver — or, in later stages, to wake, prove, decide, and rest in sequence on a single hart.

One hart waking alone is Aurora's **seed** (`aurora/src/seed.rye`): stack, one line on the UART, clean halt. Two harts waking together is the **wire** — the smallest parallel machine Comlink needed before localhost UDP and before virtio.

---

## Hart, Process, and Supervised Child

The words stay separate so the design stays legible.

| Ground | Unit of parallel work | Memory | Who assigns the role |
|--------|----------------------|--------|---------------------|
| **Bare metal (Aurora)** | Hart | Shared RAM; stacks must not overlap | Our `_start` + `mhartid` |
| **Hosted Linux (Caravan seeds)** | Process | Separate address spaces | Parent supervisor |
| **Future Caravan v1** | Supervised service | Capabilities + Tally gardens | Kernel + capability table |

A sealed datagram between **two harts** (`aurora/src/posted.rye`) proves the crypto and shape-cast on silicon where fences are real. The same datagram between **two processes** (`comlink/hosted_wire.rye`) proves the format across an OS boundary. The same datagram between **two guests** (`975`, virtio-net) proves it across a device. The value is one; the ground changes.

---

## How Aurora Wakes More Than One Hart

QEMU's `virt` machine honors `-smp 2` (or more): multiple harts, one RAM image, one kernel ELF. Aurora's multi-hart entry (`wire.rye`, `posted.rye`) follows one discipline:

**1. Naked `_start`, then stacks.** The hart arrives with no valid stack. `_start` is `callconv(.naked)` — no prologue before `sp` points at RAM. Each hart loads a base address and subtracts `hartid × 64 KiB` so stacks descend in parallel columns and never collide.

**2. Route by `mhartid`.** The same entry passes `hartid` in the first argument register to `kmain`. Hart 0 seals and posts; hart 1 receives and opens — or, on the wire seed, hart 0 sends and hart 1 speaks what arrived.

**3. Shared mailbox in RAM.** A fixed region holds the ready flag, length, and payload bytes. Both harts see the same addresses; the layout is part of the protocol, stated in the source.

**4. Fences and `volatile`.** The sender writes the buffer, issues a full memory **fence**, then raises the flag. The receiver spins until the flag is set, **fences**, then reads. `volatile` on flag and buffer forces each access to go to memory — essential when two harts truly share RAM and caches might otherwise lie.

**5. One hart powers down.** The test finisher shuts the whole machine. The receiver writes it only after the message is read; the sender waits in `wfi` so it never halts the guest while the other hart still works.

These five moves are the **two-hart contract**. Every Aurora stage that says "hart 0" and "hart 1" inherits them.

---

## The Wire Ladder — Harts at Rung One

Comlink's transport grew outward from the smallest parallel ground:

```
Rung 1 · Two harts, shared RAM     aurora/src/wire.rye, posted.rye
Rung 2 · Two processes, localhost  comlink/hosted_wire.rye
Rung 3 · Two guests, virtio-net    975, 10016
```

Harts are not a detour. They are the **first** proof that a value can move between executors without an operating system mediating. Shared memory between harts is the mailbox virtio and UDP later imitate at larger distance.

---

## What Each Module Does With Harts

**Aurora** owns the boot on RISC-V. Single-hart stages (seed, relay, named, sealed, deciding) grow the relay; two-hart stages (wire, posted) grow the wire. Each stage is a `.rye` file, `rye build`, QEMU — Gall's Law made concrete.

**Comlink** inherits the datagram shape from `posted.rye`. Hart 0 is Alice; hart 1 is Bob. The names are roles, not identities — deterministic seeds stand in for keys until unified identity (`994`) lands on the wire.

**Tally** will bound each hart's stack region and mailbox slice in freestanding builds. Today the stack step (64 KiB per hart) and wire capacity (512 bytes) are constants asserted in source; Tally makes the edges a named garden.

**Mantra** content-names what a hart sealed or opened — the same SHA3-512 discipline as hosted tests, running with pure arrays on bare metal.

**Caravan** arrives after Aurora hands off. The supervisor schedules **processes**, not harts — yet the discipline rhymes: one parent, clear roles, restart on fall, readiness as a signal. The two-hart mailbox is a foreshadow of IPC with a bounded shared region (`984`).

**Rye** compiles all of it to `riscv64-freestanding-none`. The strengthened crypto runs on a hart with no allocator — proof that the language and the silicon meet.

---

## The Smallest Parallel Seed (Gall's Law)

Multi-hart work grows in order:

1. **One hart** — `seed.rye`: stack, speak, halt.
2. **One hart, relay** — named values passed stage to stage on the same stack.
3. **Two harts, plaintext** — `wire.rye`: mailbox, fence, UART proof.
4. **Two harts, sealed** — `posted.rye`: full datagram, shape-cast, open.

Skipping from one hart to virtio skips the proof that fences and `mhartid` routing work. We do not skip.

Run two harts with:

```sh
RYE_SMP=2 aurora/run.sh wire
RYE_SMP=2 aurora/run.sh posted
```

`RYE_SMP` is the host's knob for how many harts QEMU wakes; Aurora's code must still earn correctness at `N = 2` before we imagine more.

---

## Caveats

- **Roles are coded, not scheduled.** Without an OS, hart 0 is always sender until we write a richer boot. Caravan's scheduler is horizon; Aurora's two-hart stages are a fixed duet.
- **More than two harts.** The `virt` machine can wake many; our proofs today are two-party. Scaling out is design, not yet seed.
- **Emulator fidelity.** QEMU's SMP is good enough to teach fences and mailboxes; metal may need extra care for cache coherence. The contract — publish, fence, flag, fence, read — stays the same.
- **Do not confuse with hosted twin.** `caravan/twin.rye` supervises two **processes** on Linux. `wire.rye` coordinates two **harts** on bare metal. Both say "two children"; the ground differs.

---

## Longer Horizon

Aurora's full relay will wake many harts for parallel bring-up — always with stated stacks, stated mailboxes, and shape-cast handoffs. Comlink's device wire (`975`) moves the datagram off shared RAM while keeping its shape. Caravan will schedule services across processes that may each pin to harts the kernel assigns. The word **hart** stays tied to RISC-V and bare metal; the word **process** stays tied to supervision and isolation. Clear vocabulary keeps the whole system single-stranded (`995`).

---

## Conclusion

A hart is how RISC-V names one thread of execution on open hardware. Aurora wakes harts with naked entry, private stacks, and `mhartid` routing. Two harts sharing RAM are Comlink's first wire — fences honest, mailbox bounded, sealed datagram proven before localhost or virtio widen the distance. We grow from one hart speaking, to two harts passing a word, to two harts passing a sealed value — each rung green before the next.

---

*May every hart wake with its own stack, and may no two trample the same memory. May the fence publish before the flag, and may the value that crosses between harts be the same value that later crosses between worlds.*
