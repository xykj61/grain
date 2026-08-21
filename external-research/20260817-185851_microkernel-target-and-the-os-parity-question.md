# The Microkernel Target and the OS-Parity Question

**Stamp:** `20260817.185851` - **Status:** Mixed -- Living (research capture) - **Voice:** Kyri
**Register:** Radiant - **Kin:** [`gratitude-licenses`](../.claude/rules/gratitude-licenses.md) - [`thin-frontend SLC direction`](../active-designing/20260628-043542_thin-frontend-slc-direction.md) - the Caravan/Tally lineage in [`20260620-014412_system.md`](20260620-014412_system.md)
**Clean room:** studies the world with attribution; names only our own modules where we build. No copyleft source enters our tree.

---

## What an Acme Corporation employee reading this will decide

This document captures a direction and the open questions beneath it, so that a later round can act on facts rather than enthusiasm. The direction: give **Caravan** (our supervision layer) and **Tally** (our bounded-allocation library) a real **microkernel** home, and give the **Rye** compiler a target that lowers onto that home. The questions are where the honest work is, and three of them are blind spots the compass catches before any fetch is approved.

## The direction, stated plainly

- **Caravan on a microkernel.** Study **seL4** (the formally verified microkernel) and **Genode** (the component OS framework built above microkernels) as the design ground for Caravan's supervision reaching all the way down to a kernel that is proven, not merely tested. Caravan before Tally -- supervision is the spine; the allocation library follows it.
- **Tally on s6 / skalibs.** Continue Tally's inheritance of skalibs' bounded-allocation discipline, now with s6's process model as the userland supervision reference beside the microkernel.
- **Utilities where the microkernel world lacks them.** Where a desirable Grain OS behavior has no analog in seL4/Genode, study **Alpine Linux** packages built on **musl libc** that run under **s6** (never systemd), and fuse the behavior into TAME-guided Caravan instructions of our own.
- **A Rye compiler target for Tally/Caravan, microkernel-fashion.** The larger prize: the Rye compiler itself lowering to a Tally/Caravan target, so a Grain program compiles directly for the supervised microkernel world rather than a general-purpose OS.
- **Aurora on RISC-V under QEMU, microkernel-fashion.** Bring the microkernel target up first in emulation (Aurora's freestanding riscv64 path already cross-builds with no emulator dependency), so the boot chain is exercised before any real hardware is bought.

## Blind spot one -- the licenses are not all permissive (the load-bearing one)

The request said "as long as the licenses are permissive." Two of the named projects are **not** permissive, and treating them as if they were would be the error:

- **seL4** -- the kernel is **GPLv2** (copyleft), with parts of its userland/libraries under BSD-style terms. *To verify per component before any use.*
- **Genode** -- **AGPLv3** (strong network copyleft), dual-licensed commercially by Genode Labs. *To verify.*
- **CORRECTED `20260821.041056` by the granted license read** -- see [`the microkernel license read`](20260821-041056_the-microkernel-license-read.md). Both *to verify* marks are now verified, and one is **wrong in the half that matters**: seL4 splits its licensing, and only the **kernel** is GPL-2.0. The **userlevel -- `libsel4`, the libraries, the tools, the syscall headers -- is BSD-2-Clause**, and seL4's own `LICENSE.md` states the GPL *"does not cover user-level code that uses kernel services by normal system calls"* and that such usage *"does not fall under the heading of 'derived work'."* Caravan is a root task on the userlevel side of that line, so it may **link** `libsel4` rather than clean-room it. Genode's AGPLv3 verdict stands unchanged. The conclusion below -- *clean-room study to completion* -- therefore holds for Genode and for the seL4 **kernel**, and is retired for the seL4 **userlevel**.
- **s6 / skalibs** -- **ISC** (permissive). Already recorded in [`gratitude-licenses`](../.claude/rules/gratitude-licenses.md); freer to study, and the closest to code we could ever reuse.
- **musl libc** -- **MIT** (permissive). *To verify version.* The one C library here that could, in principle, be linked rather than only studied.
- **Alpine packages** -- **per-package**; Alpine's base is largely permissive yet individual packages vary. Each wanted package needs its own license read before fetch.

**The clean-room consequence, which does not change:** a copyleft project is studied for its **design concepts** -- the IPC model, the capability system, the supervision tree -- and its source never enters our git history. Caravan and Tally stay **our own Rye code**, inheriting discipline rather than lines, exactly as they already do from s6. "Fetch seL4/Genode to implement Caravan to completion" therefore means **clean-room study to completion**, not code incorporation. Where the license is permissive (s6, musl), the study boundary is looser and a genuine dependency is thinkable; where it is copyleft (seL4, Genode), the boundary is the one we already keep. The gratitude-licenses rule is the compass here, and it is why this blind spot is named first.

## Blind spot two -- the compiler target lives past a deferred fork

Rye today is a **thin frontend** over Zig; the compiler fork (F1-F5) is a **deferred horizon**, not the active primary track ([`thin-frontend SLC direction`](../active-designing/20260628-043542_thin-frontend-slc-direction.md), and the TAME rule's own note). A "Tally/Caravan compiler target" is a compiler-**backend** feature, so it either advances that fork or leans on Zig's existing target machinery. Which leads to the first real research question:

- **ANSWERED `20260821.040637`, on metal** -- see the addendum at the foot of this document. Short form: the vendored toolchain carries **no `sel4` OS target**, so freestanding-plus-kernel-libs is confirmed as the only path, and on that path the Rye compiler reaches riscv64, aarch64, and x86_64 freestanding with no libc, linking C sources directly. What remains is the license read and the fetch gate, not a toolchain question. Witness: [`../tools/microkernel_zig_target_probe_witness.rish`](../tools/microkernel_zig_target_probe_witness.rish).
- **Can Zig target seL4 / Genode today?** Zig cross-compiles to `freestanding` and to many OS targets, and seL4 is fundamentally "bring your own runtime on top of the kernel's capability API," so **Zig-on-seL4 via a freestanding target plus the seL4 libraries is plausible** and worth a focused check against the current toolchain. Genode's C++ component framework is a harder fit for a Zig frontend and needs its own answer. *This is the external-research question the request named, and it should be answered against real toolchain versions, not from memory.*

## Blind spot three -- hardware freedom trades against speed

A fully GNU-FOSS-approved boot chain (Coreboot / Libreboot) runs on a **limited, often old and slow** set of machines, because modern x86 requires proprietary firmware blobs -- **AMD's PSP**, **Intel's ME** -- that a fully-free boot cannot replace. So:

- **Firmware / BIOS question.** What does seL4 boot on, and what does Genode boot on -- UEFI, Coreboot, a custom loader? Can that path apply to RISC-V the way the **Mikrophone** and **SiFive**'s boot (the SKI-style interface) already reach open firmware? *To research.*
- **AMD firmware.** Whether a microkernel can boot on AMD hardware without surrendering the freedom story, given the PSP blob. *To research; the honest expectation is "not fully free on modern AMD."*
- **The RISC-V escape.** **RISC-V (SiFive) is where open boot is real today**, which is exactly why bringing the microkernel target up on **RISC-V under QEMU first** is the pragmatic move: emulation sidesteps the firmware-blob question entirely, proves the target, and defers the "which real hardware" decision to a research round rather than a purchase. The freedom-vs-speed tradeoff on real metal is a named horizon, not a today-decision.

## Priorities, and the proof that closes it

1. **Caravan before Tally** -- supervision first, allocation library second.
2. **RISC-V under QEMU first** -- emulated target before any hardware.
3. **The parity-witness happy-zone suite runs on the new target.** A Tally/Caravan compilation target is not done until the existing GREEN parity-witness suite (the happy-zone tests and their kin) runs GREEN **on that target**, on metal or its faithful emulation. Proof-before-narrative is the close; the target earns "done" from a green witness, never a claim. This belongs in the itinerary as an explicit rung, not an afterthought.

## What this document does not do

It approves no fetch by itself, incorporates no source, and buys no hardware. It names a direction, corrects the one framing that would have mislicensed it, and lists the questions a later round must answer with real toolchain and real license reads. The double-seat that carries it into the road is in the eight-season itinerary; the clean-room boundary that governs it is the gratitude-licenses rule.

## Study-weight recenter (`20260819`)

A later round reordered the *reading weight* used while designing Caravan and Tally on this target, without moving any gate. The prior emphasis on Genode and experimental Sculpt-on-seL4 as the primary living models steps back; the center of gravity moves to the static, verification-minded, simplicity-first part of the ecosystem -- **seL4 itself, then Microkit, then LionsOS plus sDDF**, then s6, then selective Genode, with Sculpt and CAmkES as reality-check and historical context. That posture matches TAME's Safety-over-Performance-over-Joy ranking more tightly than a large dynamic Genode userland. Every equinox, the Caravan-before-Tally order, the RISC-V/QEMU-first pragmatism, the three blind spots, and the parity-witness close stand exactly as seated above. Full ordering, reasons, and three clean-room briefs (seL4 core model, Microkit protection domains and channels, LionsOS modularity thesis): [`20260819-094721_microkernel-target-study-weight-recenter.md`](20260819-094721_microkernel-target-study-weight-recenter.md).


---

## Addendum -- the toolchain question, answered on metal (`20260821.040637`)

This document asked its central question and left it open with an instruction attached: *answer it against real toolchain versions, not from memory.* [`tools/microkernel_zig_target_probe_witness.rish`](../tools/microkernel_zig_target_probe_witness.rish) does that, and is GREEN.

**The finding, in one line: yes, by freestanding -- and the remaining obstacles are legal rather than technical.**

| Question | Measured on this pier, Zig 0.16.0 |
|---|---|
| Is there an `sel4` OS target? | **No.** 42 OS targets; `sel4` is not among them |
| Is `freestanding` available? | **Yes** -- so the study's "plausible" path is confirmed as the *only* path |
| Can the **Rye compiler** reach the family's architectures? | **Yes** -- `riscv64` (`e_machine` 243), `aarch64` (183), `x86_64` (62), each built freestanding and each architecture read back from its own ELF header |
| Does anything expect a libc? | **No** -- zero dynamic `NEEDED` entries across all three images |
| Can it call a kernel's **C ABI**? | **Yes** -- `rye build` links C sources directly beside a `.rye`, and the binding is proven by its RED path: withholding the C side makes the link refuse with an unresolved symbol |

**Why this needed no gate.** Answering it required no fetch, no license read, and no hardware. The probe calls [`tools/fixtures/microkernel_cap_stub.c`](../tools/fixtures/microkernel_cap_stub.c) -- **our own** capability-shaped stub carrying the shape the whole family shares: a capability is an opaque handle, an invocation takes a handle, a label, and a word, and returns a word. No seL4 or Genode source, header, or line is fetched or reproduced. The toolchain either emits that call shape freestanding or it does not, and which kernel sits on the far side changes nothing about the answer.

**What this does not answer.** Genode's C++ component framework remains the harder fit and is untouched here -- this probe speaks to the C-ABI capability path only. No kernel is booted, no real capability is invoked, and nothing is linked against a real kernel library. Blind spot one still governs: the per-component license read precedes any fetch, and copyleft stays study-only.

**What it changes for the arc.** Equinox 3's leading question no longer blocks design. The compiler question is settled in the affirmative, so the remaining work on that equinox is clean-room design against the capability model rather than a toolchain investigation -- and the next honest gate is the license read, which is Keaton's word.
