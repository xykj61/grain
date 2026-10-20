format session-log-v1
stamp 20260811.202757
editor Zed + Claude Agent
model Opus 4.8
voice Kyri
host cloud pier sandbox — Eastern (EDT) time convention
title Open Aurora — freestanding cross-build witness; consolidate the emulator choice (QEMU vs modern Rust VMs) as a silo
prompt search our research and conduct more about newer alternative modern Rust VMs — i remember we decided we need features exclusive only to QEMU; think about it again, continue forward, molt old docs found otherwise write new research and silo to active
think searched external-research + active-designing for prior qemu/emulator/rust-vm decisions; the memory is right — the QEMU dependence is settled, yet it lived scattered across dated device-wire and boot notes rather than one place
obs the prior reasons, gathered: Comlink device-wire carries a sealed datagram over virtio-net modern MMIO split queues between two Aurora guests on QEMU virt (20260705-225412 · 20260705-233012); "emulator first — QEMU's virtio-net on virt is the honest lab" (yonder/20260620-041412); SMP harts via -smp on virt (yonder/20260620-041512); and KVM was RETIRED as an enclosure-escape hazard (20260712-113900) so pure TCG emulation is the standing floor
think the "feature exclusive to QEMU" is not one flag but the UNION: pure-emulation riscv64 virt board + -bios none bare boot + real modern virtio-net + SMP, portable across every dev host with no /dev/kvm — no single other tool offers all four
think re-examined the modern Rust VMs against those four demands. Firecracker + Cloud Hypervisor (rust-vmm) are KVM-only kernel-booters, wrong boot contract + hardware-virt dependency; rust-vmm is a library not a VM; rvemu-class pure-Rust RISC-V emulators have the arch and need no KVM yet lack the negotiated virtio-net device the device-wire depends on. QEMU alone sits at the intersection (pure emulation AND full virt device model)
obs verdict: QEMU stays ON MERIT — confirms the earlier decision, now consolidated in one note. Kept honest two ways: the dependency is thin/swappable-by-contract (Aurora leans on emulated device contracts, not QEMU internals), and the future clean-room bridge is named (rust-vmm virtio crates studied for concepts, per gratitude-licenses, beneath a pure-Rust RISC-V core) — horizon, not a task
obs chose "otherwise write new" over molt: the decision was scattered testimony with no single canonical dated doc to make a living mutant of; dated yonder notes stay as testimony (accrete-never-break), the new note is the living consolidated decision citing them
obs continued forward — seated tools/aurora_seed_freestanding_witness.rish: cross-builds aurora/src/seed.rye freestanding riscv64-freestanding-none against aurora/layout.ld, confirms the artifact is a RISC-V ELF (e_machine byte 18 == 243). GREEN in-sandbox with NO emulator present — the language reaches metal wherever the toolchain lives; QEMU enters only to WAKE the binary
loom witness=aurora_seed_freestanding elf_bytes=2075680 e_machine=243 emulator=none build_exit=0
file tools/aurora_seed_freestanding_witness.rish the boot seed compiles for metal, no QEMU — RISC-V ELF confirmed
file active-designing/20260811-202757_the-emulator-choice-qemu-and-the-modern-rust-vms.md the consolidated emulator decision — QEMU on merit, Rust VMs measured against Aurora's four demands, bridge named
file work-in-progress/REMEMBER.md Aurora opened + emulator choice consolidated; git nib refreshed in this same commit
recommend check-in (Keaton) — Aurora's freestanding half is witnessed on metal (no emulator) and the emulator choice is consolidated: QEMU stays on merit, the Rust-VM bridge named as horizon. Waking the seed + the two-guest device-wire stay gated on a qemu-capable bench. Next door — a qemu bench pass, a further Aurora limb, or a fresh direction — is yours to name
