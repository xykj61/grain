# Two Development Environments, and Emulating the Glow Mobile Platform

**Language:** EN
**Version:** `20260715.193000` (Pacific)
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** Living spec — distinguishes the two dev environments and names the mobile-emulation ladder. Register: mixed — the M0 lap below is checkable (green), the rest is horizon (design).

---

## Why This Spec Exists

Preparing for the Glowphone means developing against a mobile target long before a physical Fairphone is in hand. Keaton named the distinction plainly: there is the **isolated Cursor development environment** (this cloud sandbox, where the agent works) and the **NixOS environment on a fresh-wiped Framework laptop** he intends to buy (the sovereign dev host). This spec keeps the two honestly apart — what each is for, what each can and cannot do — and names the ladder for emulating the mobile platform across both. The first rung is already green.

## The Two Environments, Kept Apart

| | **Cloud dev env (here)** | **NixOS Framework host (to buy)** |
|---|---|---|
| **What it is** | The isolated Cursor sandbox the agent runs in — ephemeral, x86_64 Linux, `sudo` available, no `/dev/kvm`, no persistence across sessions | A fresh-wiped Framework laptop running declarative NixOS — the sovereign, persistent dev machine |
| **Toolchain** | Zig 0.16.0 raised per `manual/guides/cloud-agent-toolchain-setup.md`; `rye`/`rishi` bootstrapped each session | NixOS declares Zig, qemu, pmbootstrap, adb/fastboot, and the Glow toolchain as packages — reproducible, pinned in `configuration.nix` |
| **What it is for** | Authoring and *witnessing*: build Glow, run witnesses, **cross-build for aarch64 and run under qemu-user** (the mobile target's CPU, emulated) | Running and *flashing*: full-system emulation (postmarketOS `qemu-aarch64` image with a display), then a physical **/e/OS Fairphone** flashed over USB |
| **Emulation reach** | qemu **user-mode** only — runs an aarch64 Linux binary, no kernel, no devices, no GPU (proves compute and the fold, not the whole OS) | qemu **system-mode** with KVM off/on, a booting mobile OS, a screen — the whole phone emulated, then the real device |
| **Persistence & trust** | Disposable; the sandbox *is* the enclosure (per the cloud-toolchain guide, ai-jail adds nothing here) | Persistent and sovereign; the host holds keys, the pier remote, the flashing cable |

The clean rule: **the cloud env authors and proves; the NixOS host runs and flashes.** The cloud env can prove Glow's own verified code behaves identically on the phone's architecture; only the NixOS host can boot a whole mobile OS and put it on real silicon.

## The Mobile-Emulation Ladder

Each rung provable before the next; M0 is green today, the rest are horizon.

| Rung | Name | Where | State |
|---|---|---|---|
| **M0** | **aarch64 cross-build + user-mode emulation** | Cloud dev env | **GREEN** `20260715.193000` — a Glow witness cross-builds for `aarch64-linux` (Zig cross-compiles with zero fuss) and runs under `qemu-aarch64-static`, reproducing the same GREEN it prints natively; witnessed by `tools/glow_mobile_target_witness.rish` on Sala B0 |
| **M0-riscv** | **riscv64 cross-build + user-mode emulation, three keystone vanes** | Cloud dev env | **GREEN** `20260715.221500` — Sala B0, Neth's minimal witness, and Pool P0 each cross-build for `riscv64-linux-musl` and run under `qemu-riscv64-static`; each run's entire stdout matches its native x86_64 run byte-for-byte, witnessed by `tools/glow_riscv_target_witness.rish`. This is the parity proof for the RISC-V-substrate decision (`../../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md`): Glow's primary backend targets RISC-V directly, and the fold runs true there, across more than one vane family |
| **M1** | **postmarketOS `qemu-aarch64` full-system boot** | NixOS host | horizon — boot a mainline-Linux mobile OS image with a display in qemu-system, run the Glow userland (Rishi, Sala) against it; gate: the NixOS host exists with its qemu package |
| **M2** | **Glow userland on the emulated whole** | NixOS host | horizon — Rishi shell + Sala surface + Comlink over the emulated OS, the phone's software fully exercised without the device; gate: M1 · Pool P0 |
| **M3** | **/e/OS Fairphone, flashed and live** | NixOS host + device | horizon — the phase-one device from the Glowphone refinement; Glow surfaces as userland on a real de-Googled phone; gate: M2 · the device acquired |

## What M0 Actually Proves (and Does Not)

**Proves:** Glow's own authored, verified code — the fold, the signing, the bounds — compiles for the Glowphone's CPU architecture and runs byte-for-byte identically there. The Sala B0 session root is the same hash on x86_64 and emulated aarch64, so determinism holds across the architecture boundary. That is real mobile-readiness for *our* code, today, in the isolated cloud env.

**Does not prove:** that a whole mobile OS boots, that devices/GPU/radios work, or that the physical phone behaves — all of which are system-mode and real-device concerns that belong to the NixOS host and M1–M3. qemu-user runs a static binary against the host kernel; it is the compute proof, not the platform proof. Named plainly so M0's green is not mistaken for more than it is.

## Related

- `../../manual/guides/cloud-agent-toolchain-setup.md` — how the cloud dev env raises its toolchain.
- `../../external-research/20260715-182500_glowphone-firmware-freedom-two-body-strategy.md` — the Glowphone (Fairphone-class, /e/OS-then-postmarketOS) this emulates toward.
- `enclosure-editors.md` — the persistent-host editor/enclosure spec the NixOS host extends.
- `../../tools/glow_mobile_target_witness.rish` — the M0 witness (aarch64).
- `../../tools/glow_riscv_target_witness.rish` — the M0-riscv witness (riscv64), the RISC-V-substrate parity proof.
- `../../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md` — the decision this parity witness makes green.

---

Two environments, one clean rule: the cloud sandbox authors and proves on the phone's architecture; the NixOS Framework host boots the whole phone and flashes the real one — and M0 already shows Glow's own fold running true on emulated aarch64.
