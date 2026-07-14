# 967 · Caravan — Improving Upon the State of the Art

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*A siloed design brief for how Caravan's microkernel improves upon what formal verification and safe-language kernels achieved separately. The insight: one tradition proved the kernel correct yet left the language unsafe; another made the language safe yet left the kernel unproven. Caravan aims to do both — a safe language building a verified kernel, on widths that never silently change.*

**Language:** EN
**Version:** `20260622.232912` (Rye chronological stamp)
**Last updated:** 2026-06-22
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety first; explicit widths; assertions as specification
**Status:** Active Design (siloed)

---

## Our Own Ground

This is a clean room. We name only **Rye**, **Caravan**, **Tally**, **Aurora**, **Rishi**, **Pond**, **Brix**, **Comlink**, and **Mantra**. The formal-verification tradition and the safe-language-kernel tradition enter as concepts — what each achieved and where each stopped. Here we speak what Caravan implements.

---

## What the Traditions Achieved — and Where Each Stopped

### The formally verified tradition

A kernel proven correct by machine-checked mathematics: every behavior matches the specification. Capability integrity and information-flow isolation guaranteed by proof. The strongest safety any kernel has offered.

**Where it stopped:** The kernel is correct; the language it is written in is not safe. A developer writing code around the kernel works without compile-time safety guarantees. The proof is external to the code — changes to either must be re-verified together. And the kernel's internal widths vary by target, so a capability or an offset silently changes meaning on different hardware.

### The safe-language tradition

A kernel written in a language with compile-time memory safety: no use-after-free, no double-free, no data races in safe code. A practical, usable operating system with drivers in user space and a real desktop.

**Where it stopped:** The kernel is not formally proven. Memory defects are prevented, yet capability integrity, information-flow isolation, and specification conformance are not verified. The language still uses architecture-specific widths for slice lengths — the same silent cross-target drift. And supervision follows convention (init/systemd), not structure.

---

## Five Improvements Caravan Makes

### 1. Explicit widths — same meaning on every target

A capability reference is `u32`. A memory offset is `u64`. A garden budget is `u32`. These widths do not change between RISC-V and x86_64. A value that is `u32` on one machine is `u32` on every machine. Architecture-specific integer types are banned from the language — the compiler rejects them.

This eliminates an entire class of cross-target bugs: silent widening, silent narrowing, and pointer-width assumptions that hold on one machine and fail on another.

### 2. Assertions as specification — the proof in the code

Every invariant in the kernel is a `std.debug.assert` preceded by a `// invariant:` comment. The assertion IS the specification, written in the same language as the implementation. The parity gate proves behavior is preserved across every strengthening pass. The additive gate proves shape is purely invariant-stating.

This is not as strong as a full machine-checked formal proof — that requires a separate proof language and 10+ person-years. It is a practical middle ground: **structural verification through assertions and gates**, applied to every line, checked at every commit, with the discipline to grow toward formal verification as the codebase matures.

### 3. Tally gardens — bounded memory by construction

The formally verified tradition distributes raw memory as untyped capabilities; the user retypes them. The safe-language tradition uses a general-purpose allocator with arbitrary lifetimes. Caravan uses neither.

Each process receives a **Tally garden** — a bounded region with a stated budget, a bump cursor, and whole-region release. The budget is named at construction; a request past the budget fails with `error.OutOfBounds`, named and loud. When the process exits (or its season ends), the garden is cleared whole — one gesture, no fragmentation, no leak.

The garden is asserted at every allocation: `pos <= buf.len` is the invariant that never breaks. For IPC, two processes share a garden region; the capability names the range each may access. Zero-copy by construction.

### 4. Supervision as a value — not a convention

The safe-language tradition supervises processes through init/systemd conventions — daemon scripts, PID files, restart policies written in shell. Caravan's supervision is structural:

- One parent per child — the supervision tree has no ambiguity
- Restart on fall — a child that exits non-zero is restarted, up to the stated limit
- Chain-loading at startup — each boot stage sets one piece of state and hands off to the next
- Readiness as a signal — a service announces readiness by a known mechanism, not by "wait and hope"
- The policy is a **value** (a Bron record) — not scattered flags, not daemon conventions

This model is proven in running code: the Caravan seed through chain-loading, each asserted.

### 5. Aurora chains the boot to the kernel

Neither the formally verified nor the safe-language tradition formally models the boot. Caravan does: Aurora verifies every stage from the owner key through privilege transitions to the kernel handoff. Each stage is content-named (SHA3-256 of its bytes), shape-cast before execution, and proven before trust. The boot and the kernel share one verification chain.

---

## The IPC Model

Caravan's IPC follows the strongest tradition — synchronous call and asynchronous notification — with Tally gardens for data:

- **Call** — send a few machine words + capability transfers, block until reply. The kernel copies only the message header.
- **Notify** — set a bit in the receiver's notification word. No data moves.
- **Data** — travels through a shared Tally region. The sender places data; the capability names the range; the receiver reads directly. Zero-copy, bounded, asserted.

Every IPC message has a stated maximum size. No unbounded buffers.

---

## The Growth Path

The Caravan seed already runs through chain-loading. The improvements grow by accretion:

| Step | What | Status |
|------|------|--------|
| Seed | Parent/child restart | Running |
| Bounded | Child in Tally garden | Running |
| Twin | Two children, separate gardens | Running |
| Chain | Ordered startup, per-stage restart | Running |
| **Capability table** | Small Rye struct naming what each child may do | **Next** |
| **Freestanding kernel** | Supervision + capabilities on bare metal via Aurora | After capability table |

Each step is proven by the gate before the next begins.

---

## How Brix and Tally Reach Into the Kernel

In the composition tradition we inherit as a concept, a declaration language and a supervision daemon run on a borrowed monolithic kernel. The declaration stops at the service directory; the supervision stops at the process boundary; the kernel's own isolation and memory are not part of the composition.

Caravan changes this. The composition language (Brix) and the memory model (Tally) do not stop at the process boundary — they reach into the kernel:

### Brix declares what Caravan isolates

A Brix descriptor does not merely name a service. It names:
- The **capabilities** the service receives — what it may touch
- The **Tally garden budget** — how much memory it may use
- The **restart policy** — what happens when it falls
- The **chain-loading order** — when it wakes relative to other services

Caravan reads the Brix declaration and enforces it through hardware isolation. The capability table IS the declaration made real. A service that exceeds its declared capabilities meets an absent capability; a service that exceeds its garden budget meets `error.OutOfBounds`.

### Tally bounds what Caravan isolates

Each capability names a Tally garden. The garden's budget is stated in the Brix declaration. The garden's edge is asserted at every allocation. The capability system and the memory model reinforce each other:

- The **capability** says "this process may touch this garden"
- The **garden** says "this garden is 4096 bytes, bump-allocated, cleared whole on exit"
- The **assertion** says "pos <= budget" at every `alloc`
- The **Brix declaration** says all three in one value

This is the insight that composition and isolation belong together — carried into the kernel, into the memory model, and into the assertion discipline. Three concerns (declaration, isolation, memory) are one coherent design expressed in Rye, not three separate systems meeting at conventions.

---

## The Answer — Can We Improve?

Yes. Not by matching the full formal proof (that is a future horizon), yet by unifying what separate traditions achieved:

- **Safe language + verified behavior** — assertions as specification, gates as structural proof, explicit widths as language law
- **Composition reaches into the kernel** — Brix declares what Caravan enforces; Tally bounds what Caravan isolates
- **Verified boot** — Aurora's relay chains trust from the owner key to the running kernel
- **One width model** — `u32` and `u64` only, the same on every target

The kernel the traditions imagined separately, Caravan builds together — with Brix and Tally as the declaration and memory that reach all the way in.

---

*May the kernel we build honor what came before — the proof, the safe language, the composition model — and carry each forward in one system. May Brix declare what Caravan isolates, may Tally bound what Caravan protects, and may the language that builds the kernel be safe all the way down.*
