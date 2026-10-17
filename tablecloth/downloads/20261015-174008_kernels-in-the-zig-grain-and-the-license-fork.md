# Kernels in the Zig Grain, and the License Fork

**Language:** EN
**Stamp:** `20261015.174008` -- system clock, America/Los_Angeles (PDT), taken into a shell variable
**Voice:** Kyri
**Kind:** Counsel -- a kernel survey and a license reading, offered for Keaton's word
**Style:** New Gauge, Field setting, carrying Radiant warmth (see `context/GAUGE_STYLE.md`)
**Room:** mixed -- the survey and the license facts are proven against sources; every path forward is proposed
**Basis:** kernel survey asked and answered in counsel `20261015`; elder `LICENSE` read `20261015` (code Apache-2.0 OR MIT, prose CC-BY-4.0); fresh-start repos `xykj61/20261015-grain` and `grain-ww/20261015-grain` held private and GPLv3, on Keaton's word
**Legal note:** this page is study counsel from a writing companion. A license choice that binds outside parties seats only after licensed counsel reads it.
**Carries:** the license survey, the new tree read whole, a QEMU determinism witness measured in a Claude Code cloud session, and a task packet for DJINN of Bit Trading Company

---

## The reading, in one paragraph

Two young Zig microkernels carry real seL4 lineage, and both are copyleft. The permissively licensed kernels mature enough to learn code from live in other languages: Zircon, Redox, and Tock, joined by seL4's own BSD-licensed user-level frameworks. On the license question, one finding leads the rest. The seL4 kernel is GPL-2.0-only, and GPLv2 by itself is incompatible with GPLv3 [3][9]. A Glow, Rye, or Rishi translation of seL4 kernel code would therefore carry GPL-2.0-only. A clean-room kernel written from public documentation may carry any license Grain chooses. So GPLv3 answers neither of the two reasons the fresh-start repos chose it for, yet it earns a different and genuine place, described below. Both repos are private and single-authored, so the window to choose stays wide open. It closes at the first outside consumer, the same seam that closes Grain's breach window.

## The survey -- proven room

### Zig microkernels with seL4 lineage

| Project | License | Standing as read `20261015` | What Grain can learn |
|---|---|---|---|
| **hiillos** [1] | AGPL-3.0 | about 1,011 commits, 30 stars, a CI test workflow | Zircon-style reference-counted capabilities, seL4-style synchronous endpoints and asynchronous signals, Redox-style URI service names; a published call-and-reply round trip of about 342 ns under QEMU+KVM on a Ryzen 9 5950X |
| **innigkeit** [2] | EUPL-1.2 | 69 commits; boots to 148 kernel tests on x86-64 and 104 (with 14 skipped) on AArch64; RISC-V64 links | typed capability handles whose rights only narrow; every app Ed25519-signed and entitlement-checked at spawn; builds on Zig 0.16.0, the same pin as Grain |
| **.OS** [13] | unconfirmed | described on one public profile; no repository located | a heapless kernel with explicit retype accounting and rendezvous IPC, as described |

**A note on the premise.** The question asked for permissively licensed Zig microkernels, and the two located are copyleft. Their designs stay fully open to study in our own words. Their code joins a permissive tree only after counsel reads the licenses.

### Permissive teachers, in any language

| Project | Language | License | What Grain can learn |
|---|---|---|---|
| **Zircon** kernel [5] | C++ | MIT-style for the kernel; BSD-style for the rest | the object-and-handle capability model that hiillos and .OS both reach for |
| **Redox OS** [6] | Rust | MIT | a microkernel whose services answer to URI schemes |
| **Tock** [7] | Rust | Apache-2.0 and MIT | a microkernel shaped for small embedded parts |
| **seL4 Microkit** [4] | C, with Rust support | BSD-2-Clause code; CC-BY-SA-4.0 documentation | static protection domains, channels, and memory regions fixed at build time |
| **sdfgen** [8] | Zig | license file absent from the repository page at reading; verify before use | describing a Microkit, sDDF, or LionsOS system from a Zig program; still marked experimental |
| **seL4** kernel [3] | C | GPL-2.0-only; syscall headers BSD | the design itself, through the manual, papers, and documentation |

## The license fork -- what each source of code asks for

A kernel's license follows the code it is made from. Read that way, the fork resolves into lanes rather than a single choice.

| If the kernel's code comes from | It carries | Why |
|---|---|---|
| our own hands, written from public documents and papers | any license; Apache-2.0 OR MIT keeps parity with the elder tree | copyright guards expression, and the expression is ours [3] |
| seL4 kernel C source, translated into Rye or Glow | GPL-2.0-only | a translation is a derived work of a GPL-2.0-only kernel [3] |
| hiillos or innigkeit code | GPLv3 reaches both | the FSF reads EUPL-1.2 as allowing relicense to GPLv3, and AGPLv3 modules may sit beside GPLv3 modules in one project [9] |
| Zircon, Redox, Tock, or Microkit code | the elder Apache-2.0 OR MIT tree, keeping each attribution notice | all four are permissive [4][5][6][7] |

**The elder dual license already flows into every lane.** The FSF reads Apache-2.0 as compatible with GPLv3 and incompatible with GPLv2 [9][10]. Grain's code offers Apache-2.0 OR MIT, so the MIT arm carries elder Grain into a GPL-2.0-only lane and either arm carries it into GPLv3. The choice the elder tree already made turns out generous in every direction.

### Translation carries the license and leaves the proof behind

seL4's singular value is its machine-checked proof that the C implementation matches its formal specification [12]. A Rye translation inherits the GPL-2.0-only obligation in full. The proof covers the C it was written against, so the translated kernel arrives unverified. The port path pays the copyleft and returns a kernel whose assurance must be earned again from the beginning. That trade deserves a clear look before any lane opens for it.

### Running beside rather than rebuilding

The seL4 GPL stops at the kernel and user boundary, and its syscall headers are BSD [3]. Grain running as user-level protection domains on an unmodified seL4 kernel keeps Apache-2.0 OR MIT with zero relicensing, and the proof stays whole beneath it. One trademark detail rides along: a modified kernel may carry the GPL, yet it may only call itself seL4 while it stays unmodified [3]. Microkit's supported boards still need a reading against the Strix Halo target before this path is planned in earnest.

### The window, and the seam that closes it

A private repository with a single author has offered its license to nobody yet, and the copyright holder may choose again freely. The moment a version reaches an outside consumer, that version's license travels with it for good, while later versions remain free to change. This is accrete-never-break applied to licensing: a relicense lands as a new commit with its reason stated, and the GPLv3 commit stays in history as honest testimony. Two questions belong with licensed counsel before that commit seats. First, whether any other hand contributed code to either fresh repo. Second, how AI-assisted portions are best described in the copyright notice.

## Three harmonious shapes -- proposed room

**Shape one, Parity -- counsel's lean.** Both fresh-start repos accrete to Apache-2.0 OR MIT for code and CC-BY-4.0 for prose before any outside consumer, matching the elder tree exactly. Kernel work follows Gall's Law in two steps. First, Grain runs on unmodified seL4 through Microkit, keeping the proof. Later, a clean-room Zig kernel grows from public seL4 documents, taking code freely from Zircon, Redox, Tock, and Microkit with their notices kept. The seL4 kernel source takes the stance Grain already gives River: study the design, keep the source outside the tree.

**Shape two, seL4's own split.** The tree licenses by boundary, exactly as seL4 licenses itself: a `kernel/` lane under GPL-2.0-only, and everything above the syscall boundary under Apache-2.0 OR MIT, with the syscall ABI permissive. This lane opens only on Keaton's word that a translation of seL4 code is chosen, with the proof trade above read first.

**Shape three, copyleft by conviction.** GPLv3 stays, chosen for its own merits: strong copyleft for civic infrastructure, an explicit patent grant, and the door it opens to hiillos and innigkeit code. The costs come along with it. seL4 kernel code stays out of reach of that lane, and every permissive downstream consumer meets a stronger license than the elder tree offered. If this shape seats, the reason worth writing in the commit is conviction about copyleft, rather than seL4.

## A clean-room practice for the permissive lane -- proposed

The practice Grain already keeps for River extends cleanly here. A study note at `gratitude/sel4.md` would name the stance: public manual, papers, and documentation are read; kernel C source and proofs stay unread in the permissive lane. Each kernel source file would carry a **Basis** line naming the public documents that informed it, and a thin witness could assert that every kernel file carries one. The bench implements; Keaton seats.

Two details sharpen the practice. The seL4 documentation itself is CC-BY-SA, so its sentences enter Grain re-voiced under the silo rule, with names in gratitude alone [3]. And the U.S. Supreme Court in *Google v. Oracle* decided fair use while leaving API copyrightability open [11]. So mirroring seL4's syscall shapes closely is the precise place to ask counsel, eased by the fact that seL4's syscall headers are BSD [3]. For a single author, the clean-room boundary he can honestly keep is the line between documents and source, and Basis lines are its evidence.

## What stands, what is proposed, what would show this wrong

**What stands.** Two copyleft Zig microkernels with seL4 lineage, one unconfirmed Zig Zircon effort, and a set of permissive teachers in C++, Rust, and C. The seL4 kernel is GPL-2.0-only, GPLv2 by itself is incompatible with GPLv3, and the elder Grain license reaches every lane through its MIT arm.

**What is proposed.** Shape one: the fresh-start repos return to Apache-2.0 OR MIT and CC-BY-4.0 before any outside consumer; Grain runs on unmodified seL4 first and grows a clean-room Zig kernel second; the seL4 kernel source takes the River stance. Shapes two and three remain seated as honest alternatives, each waiting on its own word.

**What would show this wrong.** A permissive, tested Zig microkernel appearing, such as .OS publishing under MIT with a suite, would add a code teacher in our own language. A licensed reading that treats a clean-room syscall mirror as derived from seL4 would move that work into the GPL-2.0-only lane. And a conviction that Grain's civic mission calls for copyleft would make shape three the truer door.

## What the new tree already says

The new tree arrived whole as a 44-file archive, and three of its sentences bear on this page.

**The tree has already written its GPLv3 reason, and it is conviction.** Its `README.md` builds under GPLv3 "so the freedom to read, run, study, and share this work travels with every copy of it." That is the honest reason shape three asks for, written in the tree's own words before this page proposed it. Shape one remains counsel's lean for the elder-parity reasons above. Shape three now stands as the tree's stated choice, and it holds steady with one condition: the seL4 kernel stays outside it. The tree's own round note, `active-development/20261015-155216_the-new-tree-round.md`, already names that GPL-2.0 and GPL-3.0 linking question and asks for counsel before the first link. Caravan as a root task links only BSD-licensed `libsel4`, and BSD code flows into GPLv3 freely [3][9]. The GPLv3 tree and seL4 meet cleanly at the syscall boundary.

**Caravan's role is ready for one word.** The new `README.md` and `docs-geode/tutorials/the-first-hour.md` name Caravan "a supervisor written in Rye, standing as a root task on seL4." The packet below names Caravan the microkernel, with Tally as the memory allocator and Aurora as the boot stage, as Keaton asked on `20261015`. Gall's Law reconciles the two readings as a sequence. Caravan first stands as a root task on seL4, and it grows into its own kernel once that root task runs green. Which reading the tree carries forward is Keaton's word.

**The tree's name is ready for one word too.** The archive is `20261015-grain-main`, the repositories are `20261015-grain`, and the README and first-hour page say `20261016-grain`. The round note stages a rebase that would redate the root commit to `20261016`. One clock, one name: Keaton chooses which date the tree carries.

## Tasks for DJINN of Bit Trading Company

**For:** DJINN, and DJINN's Claude agent working on DJINN's own account and machines
**From:** Keaton, through counsel
**Standing gates:** the agent proposes and Keaton seats. Spending on any cloud provider, any wallet, key, or deploy, and any push to a Grain repository waits for Keaton's or DJINN's own word. Each machine uses its own keys, and private key material stays on the machine where it was born.

### The question

Grain's new tree needs a place to run Caravan (the microkernel), Tally (its memory allocator), and Aurora (its boot stage) under emulation, deterministically, again and again. RISC-V comes first for emulation, and every Zig compile target stays welcome, so the project's AMD workstations can lend their speed. Three homes are on the table: a Claude Code cloud session, a cloud VPS converted to NixOS, and Grain's own AMD hardware. The tasks below ask DJINN's agent to measure all three and propose one path for the `20261015` tree.

### What counsel already measured, `20261015`, in this Claude Code cloud session

| Reading | Value | Source |
|---|---|---|
| Host OS | Ubuntu 24.04.5 LTS, x86_64 | `/etc/os-release` |
| CPU and memory | 2 vCPU (Xeon, 2.80 GHz), about 7 GiB RAM | `nproc`, `free -g` |
| Documented ceiling | about 4 vCPU, 16 GB RAM, 30 GB disk | [20] |
| Hardware virtualization | `/dev/kvm` absent; zero `vmx`/`svm` flags | `/proc/cpuinfo` |
| QEMU | 8.2.2, from the Ubuntu archive through `apt` | `qemu-system-riscv64 --version` |
| Zig | 0.16.0, from the PyPI `ziglang` wheel | `zig version` |
| Zig target architectures | 58, including `riscv64`, `aarch64`, `x86_64`, `amdgcn`, `nvptx64`, `spirv64` | `zig targets` |
| Nix | 2.34.6 present; `cache.nixos.org` answered 403 through the session proxy | `nix --version`, `curl` |
| `ziglang.org` | answered 403 through the session proxy | `curl` |
| Determinism, `-icount shift=0,sleep=off` | 3 runs, **1** distinct serial output | sha256 of output |
| Witness-both-sides, free-running | 3 runs, **3** distinct outputs (CLINT `mtime` follows the host clock) | sha256 of output |
| One deterministic boot, wall time | 59 ms for a 100,000-step bounded loop | shell clock |
| icount and multi-threaded TCG | refused: "No MTTCG when icount is enabled" | QEMU 8.2.2 |

**Two readings shape everything below.** First, RISC-V guests on an x86 host run on QEMU's translator (TCG) on every home, cloud and VPS and workstation alike, because KVM accelerates only a guest of the host's own architecture. Second, deterministic icount runs use a single TCG thread. So for deterministic RISC-V work, the three homes differ mainly in per-core speed, in how many runs fit side by side, and in how long a machine stays up. The witness source and commands rest in the appendix at the foot of this page.

### Task 1 -- Reproduce the witness in DJINN's own cloud session

Start a Claude Code cloud session on DJINN's account and run the appendix witness unchanged. Record the same rows as the table above, plus the environment's network access level. The documentation lists `*.nixos.org` in the **Trusted** allowlist [20]. This session's proxy answered 403, so the network level in use here is worth confirming against DJINN's. **Deliverable:** the filled table and the three output hashes. **Falsifier:** a different output hash for the same ELF and QEMU version would mean determinism depends on something counsel missed.

### Task 2 -- Write the cloud setup script, and time it

Cloud environments run a setup script before each session, and a script cached under roughly five minutes carries its installs into every later session [20]. Draft one that installs `qemu-system-misc` and Zig 0.16.0 and prints both versions. **Deliverable:** the script and its measured run time. **Falsifier:** a run longer than five minutes means the cache is skipped, and the script needs trimming.

### Task 3 -- Pin QEMU with Nix, so every home runs the same emulator

A flake that pins `qemu` and `zig` gives the cloud session, a VPS, and a workstation one identical emulator, so a hash measured in one home means the same thing in another. Test whether `nix shell` reaches nixpkgs from DJINN's cloud session at **Trusted**. **Deliverable:** a minimal `flake.nix` with a dev shell that pins `qemu` and `zig`, and the witness hash from inside it. **Falsifier:** different hashes from the Ubuntu QEMU and the Nix QEMU for the same ELF would show that the QEMU version itself belongs in the determinism record.

### Task 4 -- Extend the determinism harness

Grow the witness into a harness shape worth keeping. It should pin icount, pin or omit firmware (the witness boots with `-bios none`; OpenSBI is the other road), and hash serial output. Run each case twice under icount and once free-running, and expect two equal hashes and one different one. Study QEMU's record and replay mode as a second road to reproducible runs. **Deliverable:** a proposed witness shape, written as a plain script Keaton can port to Rishi. **Falsifier:** a free-running hash that matches the icount hash means the case measures nothing timing-dependent and needs a sharper probe.

### Task 5 -- Compare three roads to a NixOS VPS

On a fresh Ubuntu 22.04 or 24.04 springboard at a provider such as Vultr, GCP, or Hetzner, compare three roads:

1. **nixos-infect**, read from its current README [17]. GPL-3.0. Its examples mostly pin `nixos-24.05`. It lists Vultr Ubuntu 22.04 x64 and GCP Debian 11 among its successes. It names `doNetConf=y` for hosts whose network stays quiet after reboot.
2. **The kexec installer plus disko**, the road the frozen `20260618-grain` tree witnessed green. The frozen tree's `SOURCE.md` and `nixos-guide/` record that nixos-infect left IPv4 silent on `20260903`, and that the kexec road finished with `status=0`.
3. **nixos-anywhere** [18]. MIT. It installs over SSH from any machine with Nix, boots into a kexec installer, and partitions with disko. It asks for at least 1 GB RAM and targets x86-64 by default.

**Deliverable:** one witnessed install per road, recording provider and SKU, minutes taken, metered cost, whether IPv4 and IPv6 both answer, and whether `/dev/kvm` exists on that SKU. The frozen tree measured `/dev/kvm` absent on its shared VPS. **Falsifier:** if nixos-infect with `doNetConf=y` comes up clean on both stacks, the frozen tree's reason for leaving it no longer holds.

### Task 6 -- Decide whether Grain forks nixos-infect

Weigh three choices with Task 5's evidence in hand: a Grain fork of nixos-infect, modernized with Grain's own tools; an upstream contribution; or adopting nixos-anywhere with a thin Grain wrapper. The fork's GPL-3.0 license sits comfortably beside the new GPLv3 tree. **Counsel's lean:** a thin wrapper over the kexec and nixos-anywhere roads. The frozen tree has already witnessed that road green, and a wrapper keeps Grain's surface small, which Gall's Law favors. **Deliverable:** a one-page recommendation that cites its measurements.

### Task 7 -- Carry the frozen NixOS templates forward, smallest first

The frozen tree holds `nixos-guide/templates/flake.nix` (20 lines, pinned to `nixos-26.05`), `disk-config.nix` (a disko GPT layout for `/dev/vda`), and `configuration.nix.example` (placeholder keys only), along with guides 0 through 3 and the `docs-geode` teaching rooms. The frozen tree offers its code under Apache-2.0 OR MIT and its prose under CC-BY-4.0, so templates and guides both flow into the GPLv3 tree, carrying attribution. **Deliverable:** a proposal naming the smallest set that stands a pier able to run the harness, as one new `docs-geode` lesson. Everything else waits for a later lap.

### Task 8 -- Measure Grain's own AMD hardware

Two ways run Claude Code on hardware Grain owns. **Remote Control** runs a local session on the machine and steers it from a phone or browser, on Pro and Max plans [19][21]. **Self-hosted environments** route cloud sessions to Grain's own runners, in public beta on Team and Enterprise plans [21]. On an AMD workstation, x86_64 guests gain KVM, while RISC-V guests stay on TCG. **Deliverable:** the appendix witness plus one heavier case (a longer bounded loop, or an seL4 test image once one builds), timed on the cloud session, one VPS, and one AMD workstation. Report runs side by side per machine as well as single-run time.

### Task 9 -- Survey the hardware ladder, without purchasing

Build a dated table covering price band, Zig target, which guests gain KVM, firmware openness, and source, for:

- **AMD workstations of several price ranges**, Minisforum boxes and a Tinybox among them. Read the current state of open firmware on recent Ryzen and EPYC, including AMD's openSIL effort and coreboot ports.
- **Apple Silicon** under Linux, for aarch64 guests with KVM.
- **ARM server racks** for aarch64 at scale.
- **RISC-V boards and racks**, noting which boot open firmware and which implement the hypervisor (H) extension that native RISC-V KVM needs.
- **Cerebras WSE.** Zig 0.16.0's 58 target architectures carry no Cerebras entry, so a WSE would serve as an accelerator reached through its own SDK rather than as a Caravan target. Record price and availability.

**Falsifier:** any row without a dated source stays marked proposed.

### Task 10 -- Propose one path for the `20261015` tree

Bring Tasks 1 through 9 together into one decision memo, framed by Gall's Law and Conway's Law. Conway's Law suggests a shape where the work's structure mirrors its two hands. DJINN tends the test piers and the harness. Keaton tends Caravan, Tally, and Aurora in Rye. The harness is the interface the two share. **Counsel's lean, for the memo to confirm or overturn:** begin in the cloud session, which needs zero setup and already runs RISC-V deterministically. Pin QEMU with Nix as soon as the cache answers. Stand one NixOS VPS by the kexec road for always-on runs. Bring the AMD workstations in for x86_64 KVM and throughput. All three run one flake-pinned emulator, so every hash compares. **Deliverable:** the memo, with what stands, what is proposed, and what would show it wrong. Keaton seats the path.

### What DJINN reads first

This page; the new tree's `README.md`, `foundations/20261015-000002_gall-and-conway.md`, `gratitude/sel4-microkit.md`, and `active-development/20261015-155216_the-new-tree-round.md`; and the frozen tree's `nixos-guide/README.md`, `nixos-guide/20260803-194743_virt-horizon-on-the-cloud-pier.md`, `SOURCE.md`, and `aurora/README.md`.

## Appendix -- the Aurora determinism witness

One hart wakes on QEMU's `virt` machine with no firmware, writes a greeting to the UART, runs a bounded loop of 100,000 steps, prints the CLINT `mtime` it reached, and asks the machine to rest through the test device. Under icount the `mtime` reading is fixed; free-running it follows the host clock, which is what lets the free-running runs witness the other side.

`aurora_witness.zig`:

```zig
// aurora_witness.zig -- one hart wakes on QEMU riscv64 virt, does bounded work,
// prints the CLINT mtime it reached, and asks the machine to rest.
// Built freestanding with Zig 0.16.0; run with -bios none.
const uart: *volatile u8 = @ptrFromInt(0x1000_0000);
const test_dev: *volatile u32 = @ptrFromInt(0x0010_0000);
const mtime: *volatile u64 = @ptrFromInt(0x0200_BFF8);
const work_bound: u64 = 100_000;

export fn _start() linksection(".text._start") callconv(.naked) noreturn {
    asm volatile (
        \\ la sp, stack_top
        \\ call aurora_main
    );
}

fn put(s: []const u8) void {
    for (s) |c| uart.* = c;
}

fn hex(v: u64) void {
    const digits = "0123456789abcdef";
    var shift: u7 = 64;
    while (shift > 0) {
        shift -= 4;
        uart.* = digits[@as(usize, @intCast((v >> @as(u6, @intCast(shift))) & 0xf))];
    }
}

export fn aurora_main() noreturn {
    put("aurora: one hart wakes\n");
    var acc: u64 = 0;
    var i: u64 = 0;
    while (i < work_bound) : (i += 1) {
        acc +%= i *% 2654435761;
        asm volatile ("" ::: .{ .memory = true });
    }
    const t = mtime.*;
    put("mtime=0x");
    hex(t);
    put(" acc=0x");
    hex(acc);
    put("\n");
    test_dev.* = 0x5555;
    while (true) {}
}
```

`linker.ld`:

```
ENTRY(_start)
SECTIONS {
  . = 0x80000000;
  .text : { KEEP(*(.text._start)) *(.text*) }
  .rodata : { *(.rodata*) *(.srodata*) }
  .data : { *(.data*) *(.sdata*) }
  .bss : { *(.bss*) *(.sbss*) *(COMMON) }
  . = ALIGN(16);
  . += 0x4000;
  stack_top = .;
}
```

Build and run:

```sh
zig build-exe aurora_witness.zig -target riscv64-freestanding -mcmodel=medium \
  -O ReleaseSafe -T linker.ld -fno-entry -femit-bin=aurora_witness.elf
for n in 1 2; do
  qemu-system-riscv64 -machine virt -bios none -kernel aurora_witness.elf \
    -display none -serial stdio -monitor none -icount shift=0,sleep=off > icount_$n.txt
done
qemu-system-riscv64 -machine virt -bios none -kernel aurora_witness.elf \
  -display none -serial stdio -monitor none > free_1.txt
sha256sum icount_*.txt free_1.txt
```

Measured `20261015`, QEMU 8.2.2, Zig 0.16.0:

```
aurora: one hart wakes
mtime=0x00000000000007d0 acc=0xb82fc798287677b0
```

| File | sha256 |
|---|---|
| `aurora_witness.zig` | `deeca0f53fa88c6023b365892a9d0ffa3e141bd6ec9d1a65a025baec5e48908b` |
| `linker.ld` | `c4f6e80a47767f88919a3f23b2f2b94b12286bf8db65b40e817537524d5c081d` |
| `aurora_witness.elf` | `50825304252c33ec28181bbf1413e97e015eacd08d1329d8658b80e71e99c50d` |
| icount serial output | `464009168d59b969a1165552785427f6272c65149b9ef24076b7ba8691f19323` |

An `mtime` of `0x7d0` is 2,000 ticks of the 10 MHz CLINT, which is 200 microseconds of virtual time at one nanosecond per instruction, close to two instructions per loop step. The ELF hash holds for this exact toolchain and command line. A later Zig is welcome to produce different bytes, and the serial hash is the reading that carries across.

## Bibliography

1. hiillos -- operating system and its own microkernel in pure Zig. https://github.com/xor-bits/hiillos
2. innigkeit -- capability-based microkernel written in Zig. https://github.com/depressionlab/innigkeit
3. seL4 Foundation, *Licensing Model*. https://sel4.systems/Legal/license.html -- and *Licensing* (documentation under CC-BY-SA). https://docs.sel4.systems/processes/licenses -- and OpenSSF Best Practices entry stating kernel GPL-2.0-only. https://www.bestpractices.dev/projects/5003
4. seL4 Microkit, `LICENSE.md` (BSD-2-Clause code, CC-BY-SA-4.0 documentation). https://github.com/seL4/microkit/blob/main/LICENSE.md
5. Fuchsia Zircon, `LICENSE` notice (kernel MIT-style, remainder BSD-style). https://fuchsia.googlesource.com/zircon/+/refs/heads/milestone-1011/LICENSE
6. Redox OS (MIT License, microkernel). https://en.wikipedia.org/wiki/RedoxOS
7. Tock (MIT and Apache-2.0, Rust microkernel). https://en.wikipedia.org/wiki/Tock_(operating_system)
8. sdfgen -- Microkit, sDDF, and LionsOS system tooling written in Zig. https://pypi.org/project/sdfgen/ -- repository https://github.com/au-ts/microkit_sdf_gen
9. Free Software Foundation, *Various Licenses and Comments about Them* (GPLv2 and GPLv3 compatibility; Apache-2.0, EUPL-1.2, AGPLv3 entries), read through a mirror. https://www.southampton.ac.uk/~qs2g22/mirror/www.gnu.org/licenses/license-list.html
10. Apache Software Foundation, *GPL Compatibility*. https://www.apache.org/licenses/GPL-compatibility
11. Jones Day, *U.S. Supreme Court Ends Decade-Long Software Copyright Battle: Google Wins* (2021). https://jonesday.com/de/insights/2021/04/supreme-court-google-wins-copyright-battle
12. seL4 (Wikipedia; functional-correctness proof from specification to C). https://en.wikipedia.org/wiki/SeL4
13. .OS, described on a public professional profile. https://fr.linkedin.com/in/marcpicornell
14. Trustworthy Systems, *Lions Operating System*. https://www.trustworthy.systems/projects/LionsOS
15. TigerBeetle, *A Database Without Dynamic Memory Allocation*. https://tigerbeetle.com/blog/2022-10-12-a-database-without-dynamic-memory/
16. setonix-os, RFC-0004 inter-process communication (a prior-art review that caught its own long-IPC echo). https://github.com/setonix-os/kernel/pull/9
17. nixos-infect, README (GPL-3.0; tested providers and Ubuntu versions; `doNetConf`). https://github.com/elitak/nixos-infect
18. nixos-anywhere, README (MIT; kexec plus disko over SSH). https://github.com/nix-community/nixos-anywhere
19. Claude Code docs, *Use Claude Code in the cloud*. https://code.claude.com/docs/en/claude-code-on-the-web
20. Claude Code docs, *Configure cloud environments* (access levels, Trusted allowlist, setup scripts, resource limits, time limits). https://code.claude.com/docs/en/cloud-environments
21. Claude Code docs, *Self-hosted environments* (public beta, Team and Enterprise; Remote Control on Pro and Max). https://code.claude.com/docs/en/self-hosted-environments
22. The frozen prior prototype, `grain-ww/20260618-grain`: `nixos-guide/`, `SOURCE.md`, `aurora/README.md`, `external-research/date/20260817/20260817-185851_microkernel-target-and-the-os-parity-question.md`. https://github.com/grain-ww/20260618-grain

## Gratitude

Thanks to the seL4 Foundation and the Trustworthy Systems group for a kernel, a proof, and a licensing model clear enough to reason from; to the TigerBeetle team, whose static-allocation discipline rhymes with seL4's heapless kernel and became TAME; to the authors of hiillos and innigkeit for building in Zig in the open; and to the Zircon, Redox, Tock, and Microkit communities for teaching under permissive terms.

---

*May every lane carry the license its code truly asks for, may the proof stay with the kernel that earned it, and may Grain open its doors on the day its own word chooses.*
