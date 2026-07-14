# Caravan as a Microkernel — Siloed Design Brief

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*Caravan is the supervision and isolation layer of the family. This brief silos the microkernel decision — reached through external research (`../external-research/976`) — into a concrete, clean-room design that names only our own modules and says precisely what goes inside the kernel, what lives outside it, and how the two meet.*

**Language:** EN
**Version:** `20260619.223712` (Rye chronological stamp)
**Last updated:** 2026-06-30
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, then the joy of the craft
**Status:** Active Design (siloed) — **Reviewed and kept** (`2026-06-30`).

---

## Our Own Ground

This is a clean room. We name only our own modules — TAME, Aurora, Rye, Brix, Tablecloth, Tally, Caravan, Mantra, Pond, Rishi, Comlink, and Brushstroke — together with **RISC-V**, the open instruction set we treat as solid ground. The microkernel tradition enters as a concept, weighed on its own merit; the specific systems we studied live in the external research that brought us here.

---

## The Decision, Stated

Caravan is a microkernel. The trusted core holds only what must run in privileged mode: capability-based address space management, scheduling, and inter-process communication. Everything else — file access, device drivers, the network stack, the display surface — runs in separate, isolated processes above it. A fault in any service crashes only that service; the kernel and every other service survive.

The TAME priority order required this choice. Safety is structural in a microkernel: the isolation boundary is hardware-enforced, not discipline-enforced. A monolith asks every contributor to hold the safety line through convention; a microkernel designs the dangerous states out of existence for everything outside the core. A check the hardware performs is a class of fault that never reaches a running service.

The performance cost — inter-process communication is slower than a function call — is real, bounded, and addressed by Tally's shared regions.

---

## What Lives Inside the Kernel

The trusted core is deliberately minimal. Three responsibilities, and no more:

### 1. Capability-Based Address Spaces

A **capability** is a token that names a resource and the rights to use it. Every process holds capabilities; it can exercise only what its capabilities name. The kernel manages the capability tables and enforces the boundary: a process that presents a capability it does not hold receives a named error, not silent access.

Capabilities name:
- **Tally regions** — bounded memory that the process may read, write, or share
- **Communication endpoints** — the channels through which a process sends and receives
- **Device registers** — for drivers that need hardware access, issued only to the driver process

A capability is a value: it can be passed from one process to another through IPC, so delegation is a message rather than a privilege escalation.

### 2. Scheduling

One scheduler, inside the kernel, decides which process runs and for how long. The scheduling discipline is stated: bounded time slices, priority levels declared at process creation, preemption when the slice expires. A process cannot extend its own slice or raise its own priority.

### 3. Inter-Process Communication

IPC is the seam between the kernel and every service. Two forms:

- **Call** — a synchronous send-and-wait: the caller names an endpoint capability, places a small message (a few machine words plus zero or more capability transfers), and blocks until the reply arrives. The kernel copies only the message header; data stays in the shared region.
- **Notify** — an asynchronous signal: the caller sets a bit in the receiver's notification word. The receiver polls or waits. No data moves; the notification says only "something is ready."

The IPC message is small on purpose. Bulk data travels through **Tally-bounded shared regions**: the sender places data in a region it shares with the receiver, then sends a capability to the region (or a sub-range of it) through IPC. The receiver reads from the region directly. No kernel copy, no unbounded buffer, no data that outlives the region's lifetime.

This is the zero-copy discipline that closes most of the performance gap with a monolith.

---

## What Lives Outside the Kernel

Everything else. Each is a user-space process with its own address space, supervised by Caravan's process manager:

### The Supervision Tree

Caravan's process manager is itself a user-space process — the first one the kernel starts. It is the root of a supervision tree:

```
Caravan (process manager, root supervisor)
  ├── VFS service (filesystem access, path allow-lists)
  ├── Network service (Comlink's wire, sealed datagrams)
  ├── Display service (Brushstroke's surface)
  ├── Audio service (when it grows)
  └── Pond enclosures (application processes)
        ├── Rishi REPL
        ├── Mantra commands
        └── (other applications)
```

Each service has a stated **restart policy**: if the service crashes, Caravan restarts it. The kernel does not restart; the kernel does not crash. The separation is the whole point.

### Chain-Loading at Startup

Each boot stage sets one piece of state, then execs to the next. The startup sequence reads as a list of named steps, each loading only what it needs:

1. Aurora wakes the machine and loads the kernel
2. The kernel starts Caravan (the root supervisor)
3. Caravan reads the Brix descriptor and starts each service
4. Each service opens the capabilities Caravan gave it and begins work

The Brix descriptor declares which services to start and what capabilities each receives. The descriptor is a value: a `.brix` file read at startup, not a configuration buried in code.

### Pond as the Enclosure

A Pond enclosure is a user-space process that Caravan supervises. Its policy is a value:

- **Path allow-list** — which files the process may read or write (Caravan's VFS service enforces this)
- **Memory bound** — the total Tally garden size the process may use (the kernel enforces this through the capability table)
- **Network access** — whether the process may communicate outside its enclosure (Caravan's network service enforces this)
- **Process limit** — how many child processes the enclosure may spawn

Pond is Caravan's isolation composed with Tally's bounds, expressed as a single policy that is a value. The enclosure gains only what the policy names; everything else is denied by the absence of a capability.

---

## How Tally and Caravan Meet

Tally provides the memory discipline; Caravan provides the isolation. Together:

- At process creation, Caravan allocates a **Tally garden** (a bounded region) for the new process and gives it the capability
- The process allocates within its garden using Tally's bump allocator; a request past the garden's edge fails with `error.OutOfBounds`, named and loud
- For IPC, two processes share a region: one writes, the other reads, the capability names the range each may access
- When a process exits (or is restarted), its garden is cleared whole — one gesture, no fragmentation, no leak

The garden is the unit of memory that the capability system governs. A capability to a garden names the garden, the allowed operations (read, write, or both), and the valid range. The kernel checks the capability at every access; Tally checks the bounds at every allocation. Two layers of safety, each structural.

---

## What Rye and Rishi Offer the Microkernel

**Rye** is the language Caravan is written in. The assertions, the explicitly sized types, the named errors, the bounds on everything — these are the TAME disciplines that make a small, correct kernel achievable. The kernel's code is Rye code, strengthened pass by pass, each divergence proven by the gate.

**Rishi** is how the system is configured and supervised at a higher level. A `.rish` script describes what services to start, what policies to apply, what capabilities to grant:

```rish
# Start the VFS service with read access to /usr and /lib
let vfs = start-service "vfs" { read: ["/usr" "/lib"], write: [] }

# Start the display service with GPU access
let display = start-service "display" { device: ["gpu0"] }

# Open a Pond enclosure for the Rishi REPL
let repl = start-pond { read: ["/home/xy/veganreyklah2"], write: [here], mem_mb: 512, net: false }
```

Rishi is not the kernel; it is the hand that arranges what the kernel isolates. The shell and the kernel share one value model, so a policy written in Rishi is the same value that Caravan reads — no serialization seam opens between intention and enforcement.

---

## The Path from Seed to Kernel

The Caravan seed (`../active-designing/987`) is the first step: one parent, one child, restart on fall. It runs in hosted Rye, where the gates can reach it. The seed proves the supervision loop; it does not prove isolation.

The path from seed to kernel grows by accretion:

1. **Seed** — parent/child restart loop in hosted Rye (the next horizon)
2. **Seed + Tally** — the child runs inside a bounded garden; the parent controls the garden
3. **Multi-child** — the parent supervises two children with separate gardens
4. **Chain-loading** — startup as a sequence of named stages, each loading the next
5. **Capability table** — a small Rye data structure that names what each child may do
6. **Freestanding kernel** — the supervision loop, the capability table, and the scheduler, compiled to bare metal by Aurora's relay pattern. The kernel is born.

Each step is the smallest thing that runs from what already runs beneath it. No step designs the whole from scratch; each accretes from the last proven version.

---

## The Invariants the Kernel Must Keep

Stated before they are implemented, in the TAME order:

1. **Isolation**: no process may access memory outside its own gardens and the shared regions named by its capabilities. This is the load-bearing invariant; every other property rests on it.
2. **Capability integrity**: a capability cannot be forged, duplicated outside the kernel's grant path, or widened in scope. A process holds only what it was given.
3. **Bounded scheduling**: every process receives at most its stated time slice before preemption. No process can starve the system.
4. **IPC safety**: a message carries at most a fixed number of words and capability transfers. No message grows without a stated limit.
5. **Restart guarantee**: when a supervised process exits, its supervisor is notified and may restart it. The kernel delivers the notification; the policy decides the action.

These five invariants, once stated, become the assertions that Caravan's code keeps — preconditions at every entry, postconditions at every exit, and structural enforcement at every capability check.

---

*May Caravan keep the trusted core small enough to prove and strong enough to hold. May every service that lives outside it earn its freedom by the isolation that contains it. May the capabilities name only what was given, and may the gardens bound what the capabilities grant. And may the system we build from these parts — supervision, isolation, bounded memory, and restart — be one a person can understand all the way down, and trust all the way up.*
