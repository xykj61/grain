# 976 · Microkernel or Monolith? — What Caravan Can Learn from seL4 and Redox, and What TAME Demands

*Before Caravan's design hardens, one architectural question deserves a careful answer: should it follow the microkernel path — services isolated in separate address spaces, a minimal trusted core, the design proven safe by seL4 and Redox — or the monolith path — all kernel services in one address space, proven fast by Linux, with TAME discipline holding the safety line inside? This piece reads both traditions, weighs the performance evidence, and states the TAME position plainly.*

**Language:** EN
**Version:** `20260619.171112` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, then the joy of the craft
**Status:** Research

---

## The Question

Would making Caravan a microkernel — in the tradition of seL4 and Redox — lower performance too much for the safety benefits, compared to a TAME-disciplined monolith? Can a TAME monolith match microkernel safety at higher speed? Or is the microkernel objectively safer, making it the right priority for TAME Rye?

The short answer is: **the microkernel is objectively safer by formal criteria, and with the right IPC design — zero-copy via bounded shared regions — the performance gap is real, bounded, and acceptable.** The long answer is what this piece is.

---

## What a Microkernel Is, and What seL4 Proved

A microkernel keeps the kernel as small as possible: typically scheduling, capability-based address space management, and inter-process communication (IPC). Everything else — file systems, device drivers, network stacks — runs in unprivileged user-space processes that communicate with each other and with applications through the kernel's IPC mechanism.

**seL4** is the most rigorous microkernel in existence. Developed at NICTA and Data61 (Australia), it carries a full machine-checked formal proof — in Isabelle/HOL — that the kernel's C implementation correctly refines its abstract specification, and that the specification enforces security and isolation properties. The trusted computing base (TCB) is roughly 10,000 lines of C. Every property that seL4 claims — information flow isolation, capability integrity, memory safety — is derived from the proof, not from testing or review. A bug below the proof boundary would invalidate it; the proof itself catches every class of bug within its scope.

The proof required roughly ten person-years of work and covers only the kernel. The services above it (VFS, drivers) are not proven; they are isolated: a bug in a user-space driver corrupts only that process's address space. The kernel and other services survive.

**Redox OS** takes a more pragmatic path: a microkernel written in Rust, with user-space drivers and a URL-based IPC model. It is not formally proven; the combination of Rust's type system and the microkernel's isolation means that driver bugs cannot corrupt the kernel. Redox demonstrates that a microkernel design in a modern, high-safety language is practical and usable, not merely academic.

---

## The Performance History — Where Microkernels Got Their Reputation

The original microkernel designs of the 1980s — Mach, in particular — were slow. Mach IPC required multiple copies of data as it passed between address spaces, and the overhead added up: a `read()` call on Mach passed through three or four address-space crossings, each with a context switch and a data copy. Benchmarks showed a 10–50× performance penalty over a monolith kernel for I/O-heavy workloads. This gave microkernels a lasting reputation as theoretically pure yet practically slow.

Jochen Liedtke's response, in 1993, was precise: **Mach was slow because its IPC was slow, not because microkernels are inherently slow.** His L4 microkernel redesigned IPC from scratch, keeping IPC message headers in registers and optimizing the common path until round-trip IPC cost ~4µs on 1990s hardware — roughly the cost of a context switch, not the cost of a function call. The "fast IPC" insight became the foundation of the L4 family.

seL4, descended from L4, carries this forward. On a modern ARM Cortex-A57 (the benchmark platform in seL4's published results):

- seL4 round-trip IPC (short message, no capability transfer): **~500 ns**
- seL4 "FastPath" (optimized common case): **~150–250 ns**
- Linux `getpid()` syscall (a near-zero-cost baseline): **~50–100 ns**
- Linux `read()` on `/dev/null` (a real syscall with kernel work): **~300–400 ns**

The IPC cost is real: 2–5× a Linux syscall. It is not the 10–50× of Mach. For workloads where each operation requires one or two IPC round trips, the overhead is measurable and manageable.

---

## The Copy Problem — and the Zero-Copy Solution

The deeper performance question is data movement more than IPC latency. If passing a 4 KB block to a file-system server requires copying it from the application into an IPC message buffer and then into the server's buffer, every file write costs two copies: roughly 1–2 µs on modern hardware. Composed across all I/O, this accumulates.

The solution — the same solution the Wayland display protocol uses, and the same one Aurora's wire already uses — is **zero-copy IPC via bounded shared memory regions.** The IPC message carries only a capability reference and a length; the data stays in a shared region that both parties hold read and/or write access to. Sender: write into the region, send a short IPC notification. Receiver: read from the region, process, reply.

In seL4 terms, this is "page mapping" or "memory grant" — the kernel's address space management transfers access to a physical page from one process to another without copying the page's contents. The operation costs one IPC plus the grant operation: roughly 500–800 ns, independent of the data size. At 4 KB, this is already faster than a copy; at 64 KB, it is 10× faster than copying.

This is the Tally-bounded shared region IPC model: a `Region` struct holds the data, its length declared at creation; the IPC message passes a capability to the region. The region's edges are asserted at the wrapper boundary. The data never moves. The same memory discipline Tally already provides is the IPC data layer.

---

## What a Monolith Can and Cannot Offer

A monolith kernel places all its services in one address space. The benefits are real: kernel code can call into drivers and filesystems directly, without context switches; shared data structures can be read without IPC; the hot path for a `read()` call is a function call, not an address-space crossing. Linux's performance on storage and network I/O reflects this.

Can a TAME monolith match microkernel safety? It can get substantially closer than a traditional C kernel. Rye's type system, TAME's wrapping discipline, and the assertion culture all reduce the probability of a kernel bug reaching dangerous state. Two structural limits remain.

**First, TCB size.** A monolith kernel that includes the network stack, storage drivers, and VFS has a trusted computing base in the hundreds of thousands of lines, or millions. Even with TAME discipline, the probability of a correctness-affecting bug scales with the size of the trusted base. A microkernel separates the concern: the kernel is 10,000 lines (seL4) or 20,000 lines; the rest is untrusted code whose bugs cannot reach the kernel.

**Second, formal verifiability.** seL4's proof was possible precisely because the kernel was small enough to prove. A monolith is not a practical verification target. TAME's stance on correctness — prove invariants at boundaries, state what holds at every edge — is tractable for individual modules and functions. It is not a substitute for a machine-checked proof of the kernel's core properties. Safety as a priority, in TAME's own terms, means the design should be verifiable. The microkernel is verifiable; the monolith, at kernel scale, is not.

---

## The TAME Reading

TAME names its priorities in order: safety above performance, performance above joy. The question "microkernel or monolith?" is a question about that order, applied at the kernel level.

**Safety.** The microkernel wins, and it is not close. A formally verifiable minimal core — with isolation guaranteeing that a buggy driver cannot corrupt the kernel — is a stronger safety guarantee than TAME discipline applied inside a monolith. Type safety inside a monolith helps; it does not isolate a buggy network driver from the memory management code. The microkernel separates them by hardware boundary. If safety comes first, the microkernel design is the correct choice.

**Performance.** The monolith wins a narrow IPC-latency argument and loses the zero-copy argument on large transfers. For Caravan's use case — supervising processes, routing named values between them, bounding their memory — the IPC pattern is: pass a capability to a bounded region, notify the receiver, wait for a reply. This is one round-trip IPC per "operation," where operations are things like "open a file" or "commit a Mantra weave" — not tight inner loops. At 500 ns per IPC, a design with 100 operations per second costs 50 µs of IPC overhead per second: negligible. At 100,000 operations per second (high-frequency Rishi pipeline), it costs 50 ms/s: noticeable, yet still within a 5% budget if operations take ~10 µs each on average.

**Joy.** The capability model is cleaner than the monolith's implicit sharing. A capability is an unforgeable, transferable reference to a resource — the same concept Rye's value model builds on. Caravan issuing capabilities to bounded regions, processes exchanging them for access to named resources: this is more legible than a monolith's shared kernel state.

**Conclusion.** TAME's priority order points at the microkernel. The performance gap is real and bounded; it is not the 10–50× cost of 1980s Mach. A Tally-bounded zero-copy IPC path closes most of it. The safety guarantee the microkernel offers — isolation by hardware boundary, a TCB small enough to verify — is something TAME discipline inside a monolith cannot replicate. The microkernel design is safer, and when safety comes before performance, that settles the question.

---

## The Design Implication for Caravan

Caravan is Rye's process supervisor and enclosure. Under a microkernel design, it has a natural structure.

**The minimal trusted core** holds three things: capability-based address space management, scheduling, and IPC. Nothing else. This core is the one piece that must be proven correct; everything else is a user-space service supervised by Caravan.

**Caravan's kernel-adjacent layer** maps directly to a capability-based process manager: fork a new address space, issue capabilities to Tally-bounded regions, define which capabilities the new process may exercise. This is "what process may do" stated as a value — a policy — rather than a flag in a monolith. The enclosure that `pond.rish` describes is this layer's manifestation in Rishi.

**The service tree** — VFS, network driver, display driver — lives above the kernel, each supervised by Caravan. A buggy display driver crashes, Caravan restarts it, the kernel and other services continue. The Caravan seed (one parent, one child, restart on fall) is the supervision model at this level.

**IPC data paths** use Tally-bounded shared regions: the IPC message carries a capability + length; the data stays in the region. The Tally garden's `alloc` and `clear` lifecycle maps to the shared region's lifetime. The region is asserted at the boundary wrapper before the IPC call, exactly as the POSIX wrappers assert before a `read()`.

This design is not near work — it belongs to the Pond full-OS horizon, after Caravan v1 exists. The study should happen before Caravan's supervision design hardens, so the later move toward a microkernel core does not require redesigning what was built before it.

---

## Sources and Gratitude

- **seL4** — the L4 microkernel, formally verified; research and development at NICTA and Data61 (now CSIRO's Data61). The proof and the IPC benchmark figures are published in *An Empirically Validated, Formally Verified Implementation of the seL4 Microkernel* and related papers. The seL4 Foundation maintains the open-source kernel at `github.com/seL4`.
- **Redox OS** — a microkernel OS in Rust; `gitlab.redox-os.org/redox-os/redox`. Demonstrates that a microkernel design in a high-safety language is practical.
- **Jochen Liedtke, "On µ-Kernel Construction" (SOSP 1995)** — the paper that proved fast IPC is possible and defined the L4 design principles. The source of the "Mach was slow because its IPC was slow" argument.
- **seL4 Benchmark Suite (sel4bench)** — published latency figures for seL4 IPC on ARM and x86. `github.com/seL4/sel4bench`.

---

*May the design of Caravan rest on a core small enough to prove and fast enough to trust. May the capability be an unforgeable reference, the region be bounded at every edge, and the supervision loop never fall without rising again. May safety come first — and may the performance follow, as it does when the foundation holds.*
