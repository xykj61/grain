# The Emulator Choice — QEMU and the Modern Rust VMs

**Stamp:** `20260811.202757`
**Language:** EN
**Style:** Radiant (`../context/RADIANT_STYLE.md`)
**Voice:** Kyri
**Status:** Checkable-room where it cites a landed witness; horizon where it names a bridge not yet built
**Ladder:** SOON (Aurora, the boot floor) · **Ground:** the freestanding cross-build witness below

---

## Why this note exists

An Acme Corporation engineer opening Aurora asks a fair question: Aurora is a fresh boot floor written in a young language, so why lean on QEMU — a large C emulator — rather than one of the modern emulators written in Rust? The memory is right that we settled this once; the settling lived scattered across dated device-wire and boot notes rather than in one place. This note gathers the reasons, re-examines them against today's Rust VM landscape, and states the verdict plainly so the next reader need not re-derive it.

The short answer: **QEMU stays the honest lab for Aurora, because Aurora needs a specific combination that only QEMU offers in one tool today** — and the combination, not habit, is the reason.

## What Aurora actually asks of an emulator

Aurora is freestanding Rye on RISC-V: no operating system beneath it, the hart starting at the base of RAM. Four demands fall out of that, and every one is load-bearing:

1. **A pure-emulation RISC-V machine.** The bench must run a `riscv64` guest with *no* hardware-virtualization requirement — the sandbox, the Framework, and the cloud pier are not all RISC-V hosts, and none may assume `/dev/kvm`. QEMU's `virt` board under TCG (pure translation) gives exactly this, portable across every dev host.
2. **Bare boot, no firmware.** `-bios none` starts the hart at RAM base and hands control straight to `_start`. Aurora's `layout.ld` is written to that contract; the boot-fault lesson in `20260705-233012_virtio-tx-ruling.md` (unwind sections landing on the reset address) is a lesson *about* that contract.
3. **A real virtio-net device model.** Comlink's device-wire carries a sealed datagram between two Aurora guests across **virtio-net, modern MMIO transport, split queues (OASIS 1.2)** — see `20260705-225412_comlink-device-wire.md` and the TX ruling. This is not a toy NIC; it is the negotiated modern device, and the guest driver is freestanding Rye programming real queue registers.
4. **SMP harts on one RAM image.** `-smp 2` teaches fences and mailboxes for the multi-hart entry (`wire.rye`, `posted.rye`), per `yonder/20260620-041512_harts-parallel-on-one-machine.md`.

QEMU answers all four in one command line, in pure emulation, on any host. That is the "feature exclusive to QEMU" the memory reached for — not one flag, but the *union*: `virt` + `-bios none` + rich virtio + SMP + TCG, portable and KVM-free.

## The modern Rust VMs, measured against those four

Rust has produced excellent virtual-machine work. None of it yet meets Aurora's union — and it is worth being precise about *why*, because the gap is structural, not a matter of maturity alone.

| Project | What it is | Where it meets Aurora | Where it falls short |
|---|---|---|---|
| **Firecracker** (AWS) | KVM microVM for serverless | Rust, rust-vmm virtio, tiny attack surface | **KVM-only** (no pure emulation); x86_64/aarch64 first; boots a Linux kernel, not a freestanding `-bios none` ELF. Wrong shape for a bare boot floor. |
| **Cloud Hypervisor** | KVM/MSHV VMM (rust-vmm) | Rust, rich virtio, active RISC-V interest | **KVM/MSHV-only**; kernel-booter, not a bare-`virt` lab; assumes matching host arch + virt extensions. |
| **rust-vmm** | Library ecosystem (`virtio-*`, `vm-memory`, `kvm-ioctls`) | Clean-room-worthy virtio crates; the best future bridge | Not a VM — a toolkit; KVM-oriented; no CPU emulation of its own. |
| **rvemu / pure-Rust RISC-V emulators** | Instruction-level RISC-V emulation | Pure emulation, correct arch, no KVM | **No real virtio-net device model** — cannot run the device-wire; teaching-grade device support. |

The landscape splits cleanly along one seam. The Rust **VMMs** (Firecracker, Cloud Hypervisor) are KVM accelerators that boot kernels — powerful, yet they need hardware virtualization and speak the wrong boot contract for a freestanding floor. The Rust **pure emulators** (rvemu and kin) have the right arch and need no KVM, yet they lack the negotiated virtio-net device the device-wire depends on. QEMU alone sits at the intersection: pure emulation *and* the full `virt` device model.

Our own history already walked one step of this seam and stepped back. `20260712-113900_lane-kvm-retire-dbus-escape.md` retired the KVM acceleration lane as an enclosure-escape hazard; QEMU's **pure TCG emulation is the standing floor**, KVM gated off behind `/dev/kvm` and a refuse-witness. A KVM-first Rust VMM would reopen exactly the dependency we deliberately closed.

## The verdict

**QEMU stays, on merit.** For Aurora's boot floor and Comlink's device-wire, QEMU's pure-emulation `virt` board with modern virtio-net, `-bios none`, and SMP is the one tool that meets every demand on every dev host, with no KVM and no host-arch assumption. This confirms the earlier decision rather than overturning it — and now the reasons live in one place.

**Two things keep it honest, not dogmatic:**

- **The dependency is thin and swappable by contract.** Aurora leans on QEMU's *emulated device contracts* (the `virt` memory map, virtio-mmio, the RISC-V ISA), not on QEMU internals. The freestanding cross-build below proves the language reaches metal with **no emulator at all**; QEMU enters only to *wake* the artifact. The protocol contract — "publish, fence, flag, fence, read" for harts; the OASIS 1.2 queue for virtio — is emulator-independent by design.
- **The bridge is named, for the day it is worth building.** Should Grain ever want to shed the C dependency, the clean-room path is **rust-vmm's virtio crates studied for concepts** (permissive-licensed, per `gratitude-licenses.md`) beneath a pure-Rust RISC-V core — a Grain-native emulator that keeps the same device contracts. That is a real season of work, held as horizon, not a task. Naming it now means the choice stays a choice.

## What landed with this note

The freestanding half of the pipeline is witnessed **in-sandbox, with no emulator present**:

- `tools/aurora_seed_freestanding_witness.rish` — cross-builds `aurora/src/seed.rye` freestanding for `riscv64-freestanding-none` against `aurora/layout.ld` and confirms the artifact is a RISC-V ELF (`e_machine == 243`). **GREEN** — the language compiles to metal wherever the toolchain lives.

Waking the built seed (and the two-guest device-wire) stays gated on a QEMU-capable bench, exactly as this note argues it should be.

## Related

- `20260705-225412_comlink-device-wire.md` · `20260705-233012_virtio-tx-ruling.md` — the virtio-net device-wire contract on QEMU `virt`.
- `yonder/20260620-041412_virtio-the-device-wire.md` ("Emulator first. QEMU's virtio-net on `virt` is the honest lab.") · `yonder/20260620-041512_harts-parallel-on-one-machine.md` — SMP.
- `20260712-113900_lane-kvm-retire-dbus-escape.md` — KVM lane retired; pure TCG emulation is the floor.
- `research-silo/README.md` — starseeded silo; this note is a design-time consolidation, cross-filed there in spirit.
