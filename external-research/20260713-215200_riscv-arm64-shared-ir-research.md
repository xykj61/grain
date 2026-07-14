# RISC-V and ARM64 — Does a New Shared IR Earn Its Keep?

**Language:** EN
**Version:** `20260713.215200`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Research — answers a question, proposes no new compiler component

---

## What This Answers

Kaeden asked for "our macOS local ARM64 Apple Silicon compilation in terms of the RISC-V implementation," with both as real native targets sharing one shared intermediate representation. This document checks that against what this project's toolchain already has, before treating a new IR as a given.

**The finding, stated first: this project already has a shared IR for both targets, and it is Zig's own compiler backend — no new component is needed to get both targets from one frontend.** The open work is proving parity actually holds on both, not building something new to make that possible.

---

## What Already Exists in This Tree

- **Aurora is already RISC-V, freestanding, and running under QEMU.** `aurora/layout.ld` discards `.riscv.attributes` sections (a RISC-V-specific linker concern), and `aurora/README.md` documents booting via `qemu-system-riscv64 -machine virt`. This project's own stated horizon ("Aurora on RISC-V... Rye OS on open silicon," per `work-in-progress/ROADMAP.md`'s Horizon 3) is not aspirational — it is already the freestanding boot target today.
- **Hosted Rye leans on Zig's own `std` through pristine symlinks** (per `TAME_GUIDANCE.md`'s Root discipline and the `rye/lib/std` re-fork noted in `work-in-progress/ROADMAP.md`). Zig is a single compiler frontend with one shared intermediate representation (Zig IR, lowering to LLVM IR or Zig's own self-hosted backends depending on target) that already emits code for dozens of target triples — `aarch64-macos`, `x86_64-linux`, `riscv64-linux`, `riscv64-none` (freestanding), and more — from the exact same source, selected purely by a `-target` flag or, when omitted, defaulting to the host's own native triple.
- **This Mac is `arm64` (Apple Silicon, confirmed in `context/specs/20260713-211800_local-host-system-hardware-anonymized.md`)**, so any hosted Rye code that already compiles and runs correctly on this project's prior x86_64 Linux hosts should, in principle, cross-compile and run natively here with no source change — Zig's whole design premise is that portable, `usize`-disciplined, std-symlinked source (which is exactly what TAME's Rye Supplement already enforces: fixed widths, asserted bounds, no architecture-specific leakage into authored code) is the thing that makes this cheap.

## The Real Question This Research Answers

**"Does supporting ARM64 and RISC-V well require a new shared IR beyond what Zig already provides?"** No — Zig's own backend already is that shared IR, and this project's own TAME width discipline (Root rule: "Prefer fixed widths; avoid `usize` in authored Rye... at the inherited-std seam... assert the bound and cast") is *already* the discipline that keeps authored Rye code target-portable across word sizes and architectures. The project was, without naming it this way, already building toward exactly the multi-target guarantee Kaeden is asking for — the width-migration arc (`TH-3` through `TH-7`, "complete and blocking in parity" per the ROADMAP) is the concrete proof this guarantee already holds for the hosted corpus.

**What remains real, un-done work — not IR design, but verification:**

1. **Prove hosted `parity.rish` actually passes when compiled natively for `aarch64-macos`** on this specific machine — this project's parity suite has, to this research's knowledge, only been confirmed green on prior Linux/x86_64 hosts (`context/specs/` and `work-in-progress/ROADMAP.md`'s "host re-pin `20260712.193958`" language refers to a Framework — Linux — host). Running the existing suite here, unmodified, is the actual next step, and it is a **witness run**, not a design task.
2. **Confirm which RISC-V target Aurora's freestanding path needs versus what a hosted RISC-V Linux target would need** — these are different Zig target triples (`riscv64-none` freestanding vs. `riscv64-linux` hosted) even though both are "RISC-V"; Kaeden's ask to relate ARM64 compilation "in terms of" RISC-V likely means the freestanding Aurora path specifically, which is a different comparison than hosted-Rye-on-ARM64-Mac vs. hosted-Rye-on-RISC-V-Linux.
3. **If Kaeden's Mac ever needs to run Aurora's freestanding RISC-V image directly** (rather than only via the existing `qemu-system-riscv64` path already documented), that is exactly the QEMU-vs-Virtualization.framework question already answered in the earlier macOS-enclosure study — QEMU with `-accel hvf` is the recommended path there too, and nothing about ARM64-vs-RISC-V changes that recommendation, since QEMU's RISC-V *guest* emulation runs the same way regardless of the ARM64 *host* underneath it.

---

## What This Document Does Not Propose

- No new intermediate representation, no new compiler pass, no fork of Zig's backend.
- No claim that hosted Rye already runs correctly on this Mac — that is asserted as *likely, by design*, not confirmed; confirming it is a witness-run task for a future pass, not a research conclusion this document can honestly claim on its own.

---

*May the one frontend keep serving every target honestly, and may the next proof be a green witness run, not a new layer we did not yet need.*
