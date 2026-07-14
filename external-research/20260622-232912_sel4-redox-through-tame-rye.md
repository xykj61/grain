# 964 · seL4 and Redox Through the TAME Rye Lens — Can We Improve Upon Them?

*Two microkernels represent the state of the art: seL4 is formally verified in C, the strongest safety guarantee any kernel has achieved; Redox is written in Rust, proving that a safe systems language can build a practical microkernel. This research asks whether Rye — with TAME discipline, Tally gardens, Caravan's supervision model, and Aurora's verified boot — can improve upon both by unifying what each achieves separately: the formal safety of seL4 with the safe-language discipline of Redox, on explicit-width types that mean the same thing on every target.*

**Language:** EN
**Version:** `20260622.232912` (Rye chronological stamp)
**Last updated:** 2026-06-22
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy
**Status:** Research

---

## seL4 — What Formal Verification Achieved

seL4 is the world's first general-purpose OS kernel with a machine-checked formal proof. Its trusted computing base is 9–18K lines of C. The proof, in Isabelle/HOL, guarantees: the C implementation correctly refines the abstract specification; capability integrity holds (no forgery, no escalation); information flow isolation holds between security domains.

**What seL4 does right (TAME-aligned):**

- **The kernel is small enough to prove.** 10K lines of C; every behavior formally verified. This is the deepest form of "safety first" — safety proven by mathematics, not by testing.
- **Capabilities are the only access model.** Every resource is named by a capability; every operation requires a capability with sufficient rights. No ambient authority. No root user.
- **IPC is the only communication.** Synchronous call (send-and-wait) and asynchronous notification. The kernel copies only a few machine words; bulk data travels through shared memory pages.
- **Memory is explicitly managed.** The kernel does not allocate memory dynamically after boot. All memory is pre-allocated by the initial task and distributed as capabilities. No hidden allocator, no fragmentation, no OOM surprise.

**Where TAME Rye can improve upon seL4:**

1. **seL4 is written in C.** The formal proof covers the C implementation — yet C itself offers no compile-time safety. A developer working on code *around* seL4 (drivers, services) writes in C without the proof's protection. Rye's compile-time assertions, explicit widths, and (future) borrow-checking offer structural safety in the language itself, not only in the proof.

2. **seL4's proof is external to the code.** The Isabelle/HOL proof lives beside the C source; changes to either must be re-verified together. Rye's approach: assertions ARE the specification, written in the same language as the implementation, checked by the compiler and the parity gate. The proof and the code are one artifact.

3. **seL4 uses `word_t` (architecture-specific width).** seL4's capability pointers and object sizes use a machine-word type that varies between 32-bit and 64-bit targets. Rye's absolute ban on architecture-specific widths (`u32`/`u64` only) means a capability, a length, and an offset carry the same meaning on every target — no silent widening.

4. **seL4's memory model is pre-allocated but not gardened.** seL4 distributes memory as untyped capabilities; the user retype them. Tally's garden model goes further: memory is bounded by a named budget at construction, cleared whole when the season ends, and asserted at every allocation. The garden is a stated edge; the untyped is a raw resource.

---

## Redox — What a Safe Language Achieved

Redox is a Unix-like microkernel OS written in Rust. Its kernel is ~20K lines — small enough to audit, though not formally verified. Rust's ownership system prevents memory defects (use-after-free, double-free, data races) at compile time.

**What Redox does right (TAME-aligned):**

- **The language prevents whole error classes.** Rust's borrow checker eliminates memory corruption without a garbage collector. The kernel cannot have use-after-free or data races in safe code.
- **Drivers run in user space.** A crashing driver is isolated and restarted — the same supervision discipline Caravan inherits from s6.
- **URLs as the resource namespace.** Redox uses URL-like paths (`disk:`, `net:`, `display:`) to name resources — a uniform, composable naming scheme.
- **Practical and usable.** Redox runs real applications, has a desktop (Orbital/COSMIC), and targets self-hosting — a practical microkernel, not only a research artifact.

**Where TAME Rye can improve upon Redox:**

1. **Redox is not formally verified.** Rust prevents memory defects, yet it does not prove capability integrity, information-flow isolation, or specification conformance. Rye's parity gate and assertion discipline move toward verified behavior — not as strong as seL4's full proof, yet structural and checked at every commit.

2. **Rust uses `usize` for slice lengths.** The same architecture-specific width problem. A `Vec<T>` on a 32-bit target has `usize = u32`; on a 64-bit target, `usize = u64`. Rye's `u32` slice length is the same on every target.

3. **Redox's memory allocator is general-purpose.** Rust's standard allocator handles arbitrary lifetimes. Tally's garden model is simpler and faster — bounded regions, bump allocation, whole-region release. For a microkernel where memory lifetimes are explicit (per-IPC, per-stage, per-request), gardens outperform general allocation.

4. **Redox's supervision is Unix-style.** Processes are supervised by init/systemd conventions. Caravan's model — inherited from s6 — is more structured: one parent per child, restart on fall, chain-loading at startup, readiness as a signal. The supervision is a value, not a convention.

---

## What TAME Rye Unifies

| Property | seL4 | Redox | Caravan (TAME Rye) |
|----------|------|-------|-------------------|
| **Safety proof** | Full formal verification (Isabelle/HOL) | Compile-time memory safety (Rust borrow checker) | Assertions as specification + parity gate + explicit widths. Not as strong as seL4's proof; stronger than testing alone. |
| **Language safety** | None (C) | Strong (Rust ownership) | Explicit widths, assertions, (future) borrow-checking over gardens |
| **Width model** | `word_t` (architecture-specific) | `usize` (architecture-specific) | `u32`/`u64` only — same on every target |
| **Memory model** | Untyped capabilities, pre-allocated | General-purpose allocator | Tally gardens: bounded, bump, whole-region release |
| **Capability model** | Finest-grained in any kernel | Basic process isolation | Capabilities as values; policy as a Bron record |
| **Supervision** | Not part of the kernel | Unix-style init | s6-inherited: one parent, one child, restart on fall, chain-loading |
| **Boot** | Not formally modeled | Standard BIOS/UEFI | Aurora: verified relay of named values from owner key |
| **IPC** | Synchronous call + notification | URL-based scheme calls | Call + notify; data via Tally shared regions (zero-copy) |

The insight: **seL4 proved the kernel correct but left the language unsafe. Redox made the language safe but left the kernel unproven. TAME Rye aims to do both** — a safe language (explicit widths, assertions, future borrow-checking) building a kernel whose behavior is checked at every commit by structural gates, on a width model that never silently changes between targets.

We do not claim to match seL4's full formal proof — that is a 10-person-year investment. We claim a practical middle ground: **structural verification through assertions, gates, and explicit types**, applied to every line of kernel code, checked on every commit, with the discipline to grow toward formal verification as the codebase matures.

---

## The Specific Improvements

1. **Explicit widths replace `word_t`/`usize`.** A capability reference is `u32`. A memory offset is `u64`. These do not change between targets. Cross-target bugs that silently widen or narrow are designed out of existence.

2. **Tally gardens replace untyped memory.** Each process receives a garden with a stated budget. The garden is asserted at every allocation. When the process exits, the garden is cleared whole. No fragmentation, no leak, no OOM surprise — and the assertion fires before the overflow, not after.

3. **Assertions are the specification.** Every invariant in the kernel is a `std.debug.assert` with a `// invariant:` comment. The parity gate proves behavior is preserved across strengthening passes. The assertion IS the spec; the gate IS the proof (structural, not formal).

4. **Aurora chains the boot to the kernel.** seL4 and Redox do not formally model the boot. Aurora verifies every stage from the owner key through privilege transitions to the kernel handoff. The boot and the kernel share one verification chain.

5. **Supervision is structural, not conventional.** Caravan's one-parent-per-child, restart-on-fall, chain-loading model is proven in running code (seed through chain). The supervision is a value (Bron policy), not a daemon convention.

---

## SixOS Through the Microkernel Lens — s6 + Nix infuse Meets Caravan + Tally + Brix

SixOS composes s6 supervision with Nix infuse's reproducible declarations — yet SixOS runs on a borrowed monolithic kernel. It declares services and supervises them, yet the kernel beneath is not part of the composition. The isolation between services is the borrowed kernel's, not the composition language's.

Caravan changes this. In a microkernel Rye OS, the composition language (Brix) does not merely declare services for a borrowed kernel to run — **Brix declares what Caravan isolates.** The capability table, the garden budgets, the restart policies, the chain-loading order — all are Brix declarations that Caravan's microkernel enforces through hardware isolation.

| SixOS (s6 + Nix infuse + borrowed kernel) | Rye OS (Caravan + Brix + Tally) |
|---|---|
| Nix infuse declares services | Brix declares services AND their capabilities AND their Tally garden budgets |
| s6 supervises processes | Caravan supervises processes with hardware-enforced isolation |
| The borrowed kernel provides isolation | Caravan IS the isolation — capabilities enforced by the microkernel |
| Memory is the kernel's concern | Tally gardens ARE the memory — bounded, named, asserted at every allocation |
| The composition stops at the service directory | The composition reaches into the kernel — Brix declares what Caravan enforces |

The improvement: **the composition language, the supervision, and the memory model are designed together.** In SixOS, three independent systems (Nix, s6, Linux) meet at conventions. In Rye OS, Brix, Caravan, and Tally are one coherent design — the declaration reaches into the capability table, the capability names a Tally garden, the garden bounds the memory the process may use. Declaration, isolation, and memory are not three layers composed through convention; they are one architecture expressed in Rye.

This is Adam Joseph's SixOS insight carried into the kernel: declaration and supervision belong together. We honor that insight and carry it further — into the hardware isolation boundary, into the memory model, and into the boot chain that Aurora verifies.

---

## Sources

- seL4: sel4.systems — formally verified microkernel. 9–18K SLOC, capability-based, IPC-only.
- Redox: redox-os.org — Rust microkernel. ~20K SLOC, user-space drivers, URL resource naming.
- SixOS + Nix infuse: codeberg.org/amjoseph/sixos, codeberg.org/amjoseph/infuse.nix — declaration meets supervision on a borrowed kernel.
- Tiger Style: gratitude/TIGER_STYLE.md — explicit widths, assertions, safety first.
- Caravan: active-designing/yonder/20260619-223712_caravan-microkernel.md
- Tally: active-designing/yonder/20260619-051212_correctness-by-construction.md (bounded gardens)
- Brix: active-designing/yonder/20260618-184912_recommended-architecture.md (composition)
- Aurora: active-designing/yonder/20260618-225712_aurora.md

---

*May the kernel we build carry what seL4 proved, what Redox demonstrated, and what SixOS composed — safety by mathematics, safety by language, and declaration meeting supervision — unified in one system where Brix declares, Caravan isolates, and Tally bounds. May the language that builds the kernel be the same language the kernel speaks — safe all the way down.*
