# Two Development Environments, and Emulating the Glow Mobile Platform

**Language:** EN
**Stamp:** living ledger (born `20260715.193000`) · refreshed `20260715.230000` (M0-riscv rung added; frozen dated original now a pointer stub, per [`living-vs-dated.md`](living-vs-dated.md)) · refreshed `20260715.163500` (a third, interim macOS environment named; the Pixel/GrapheneOS ladder, G0–G3, opened separately from the Fairphone/postmarketOS M-ladder)
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Voice:** Riyo
**Status:** Living — distinguishes the dev environments (cloud, NixOS, and now this interim macOS host) and names both mobile-emulation ladders (M-ladder for the Fairphone/postmarketOS Glowphone body, G-ladder for the Pixel/GrapheneOS SLC line). Register: mixed — M0 and M0-riscv are checkable (green); G0 is checked-and-honestly-blocked on a real host issue; everything else is horizon (design).

---

## Why This Spec Exists

Preparing for the Glowphone means developing against a mobile target long before a physical Fairphone is in hand. Keaton named the distinction plainly: there is the **isolated Cursor development environment** (this cloud sandbox, where the agent works) and the **NixOS environment on a fresh-wiped Framework laptop** he intends to buy (the sovereign dev host). This spec keeps the two honestly apart — what each is for, what each can and cannot do — and names the ladder for emulating the mobile platform across both. The first two rungs are already green.

## The Two Environments, Kept Apart

| | **Cloud dev env (here)** | **NixOS Framework host (to buy)** |
|---|---|---|
| **What it is** | The isolated Cursor sandbox the agent runs in — ephemeral, x86_64 Linux, `sudo` available, no `/dev/kvm`, no persistence across sessions | A fresh-wiped Framework laptop running declarative NixOS — the sovereign, persistent dev machine |
| **Toolchain** | Zig 0.16.0 raised per `manual/guides/cloud-agent-toolchain-setup.md`; `rye`/`rishi` bootstrapped each session | NixOS declares Zig, qemu, pmbootstrap, adb/fastboot, and the Glow toolchain as packages — reproducible, pinned in `configuration.nix` |
| **What it is for** | Authoring and *witnessing*: build Glow, run witnesses, **cross-build for aarch64/riscv64 and run under qemu-user** (mobile and open-ISA targets, emulated) | Running and *flashing*: full-system emulation (postmarketOS `qemu-aarch64` image with a display), then a physical **/e/OS Fairphone** flashed over USB |
| **Emulation reach** | qemu **user-mode** only — runs a Linux binary for a target arch, no kernel, no devices, no GPU (proves compute and the fold, not the whole OS) | qemu **system-mode** with KVM off/on, a booting mobile OS, a screen — the whole phone emulated, then the real device |
| **Persistence & trust** | Disposable; the sandbox *is* the enclosure (per the cloud-toolchain guide, ai-jail adds nothing here) | Persistent and sovereign; the host holds keys, the pier remote, the flashing cable |

The clean rule: **the cloud env authors and proves; the NixOS host runs and flashes.** The cloud env can prove Glow's own verified code behaves identically on a target architecture; only the NixOS host can boot a whole mobile OS and put it on real silicon.

## The Mobile-Emulation Ladder

Each rung provable before the next; M0 and M0-riscv are green today, the rest are horizon.

| Rung | Name | Where | State |
|---|---|---|---|
| **M0** | **aarch64 cross-build + user-mode emulation** | Cloud dev env | **GREEN** `20260715.193000` — a Glow witness cross-builds for `aarch64-linux` (Zig cross-compiles with zero fuss) and runs under `qemu-aarch64-static`, reproducing the same GREEN it prints natively; witnessed by `tools/glow_mobile_target_witness.rish` on Sala B0 |
| **M0-riscv** | **riscv64 cross-build + user-mode emulation, three keystone vanes** | Cloud dev env | **GREEN** `20260715.221500` — Sala B0, Neth's minimal witness, and Pool P0 each cross-build for `riscv64-linux-musl` and run under `qemu-riscv64-static`; each run's entire stdout matches its native x86_64 run byte-for-byte, witnessed by `tools/glow_riscv_target_witness.rish`. This is the parity proof for the RISC-V-substrate decision (`../../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md`): Glow's primary backend targets RISC-V directly, and the fold runs true there, across more than one vane family |
| **M1** | **postmarketOS `qemu-aarch64` full-system boot** | NixOS host | horizon — boot a mainline-Linux mobile OS image with a display in qemu-system, run the Glow userland (Rishi, Sala) against it; gate: the NixOS host exists with its qemu package |
| **M2** | **Glow userland on the emulated whole** | NixOS host | horizon — Rishi shell + Sala surface + Comlink over the emulated OS, the phone's software fully exercised without the device; gate: M1 · Pool P0 |
| **M3** | **/e/OS Fairphone, flashed and live** | NixOS host + device | horizon — the phase-one device from the Glowphone refinement; Glow surfaces as userland on a real de-Googled phone; gate: M2 · the device acquired |

## What M0 and M0-riscv Actually Prove (and Do Not)

**Prove:** Glow's own authored, verified code — the fold, the signing, the bounds — compiles for a target CPU architecture and runs byte-for-byte identically there. The Sala B0 session root is the same hash on x86_64 and emulated aarch64; the same holds (extended to Neth and Pool P0 too) on emulated riscv64. Determinism holds across the architecture boundary, on the Glowphone's own CPU family and on the open RISC-V substrate. That is real mobile- and RISC-V-readiness for *our* code, today, in the isolated cloud env.

**Do not prove:** that a whole mobile OS boots, that devices/GPU/radios work, or that the physical phone behaves — all of which are system-mode and real-device concerns that belong to the NixOS host and M1–M3. qemu-user runs a static binary against the host kernel; it is the compute proof, not the platform proof. Named plainly so M0/M0-riscv's green is not mistaken for more than it is.

## A Third Environment, Interim — This macOS Host, and the GrapheneOS/Pixel Ladder (`20260715.163500`)

Keaton is on a macOS Tahoe Beta 26.6 host right now, ahead of the NixOS Framework purchase, and asked to adapt the plan rather than wait — and to settle plainly which OS base the Pixel-line SLC product (`../../active-designing/20260715-194500_the-slc-product-glow-on-capable-hardware.md`) actually targets. Both answered honestly, together, since they turn out to be the same question.

**The OS choice for Pixel phones is GrapheneOS, never postmarketOS.** The two OS bases already named in this tree serve two entirely different hardware bodies, not competing choices for one device: **postmarketOS** is the phase-two target for the Fairphone-class **Glowphone** (`../../external-research/20260715-182500_glowphone-firmware-freedom-two-body-strategy.md`) — genuine mainline Linux, grown toward as that hardware family's mainline support matures. **GrapheneOS** is Pixel-exclusive — it depends on hardware memory tagging only Titan-class Pixel silicon has — and is the base for the separate Pixel-line SLC product named in the go-to-market brief above (Pixel 10 Pro XL flagship-first, used Pixel 7a/8a value tier). Neither substitutes for the other; a Fairphone cannot run GrapheneOS, and Pixel is not this tree's target for postmarketOS.

**This macOS host is a real, usable interim environment for compute-and-fold proofs (M0/M0-riscv's own shape), checked directly rather than assumed:** Homebrew already carries `qemu` 10.2.2 with HVF acceleration available (`qemu-system-aarch64 -accel help` lists `hvf`) — the same hardware-accelerated system-mode emulation the NixOS host's own qemu package would provide. This closes M0/M0-riscv's own gate on this Mac without waiting for the Framework purchase; it does not, on its own, unblock M1's postmarketOS-on-Fairphone rung, which still wants pmbootstrap tooling this host does not carry yet.

**The GrapheneOS/Pixel line needs its own ladder, not a reuse of M0–M3** (those name the Fairphone/postmarketOS body specifically). Named here, checked against the current state of the world (dated, cited, re-checkable as GrapheneOS's own build process changes):

| Rung | Name | Where | State |
|---|---|---|---|
| **G0** | **Stock AOSP/Android Emulator, HVF-accelerated** | This macOS host | **Blocked, not gated on missing tooling** — `20260715.163500`: a real, unrelated Homebrew ownership issue (`/opt/homebrew` owned by a different user than the current account, likely from an earlier `sudo brew install`) blocks installing `android-commandlinetools` via Homebrew. Fix is a one-time, interactive `sudo chown -R $(whoami) /opt/homebrew`, run by Keaton in a real terminal (an agent session cannot supply an interactive sudo password). Once installed: an AVD with a Google/AOSP arm64 or x86_64 system image, HVF-accelerated on Apple Silicon, hosts and exercises Glow's Android-side userland (the Sala broadcaster client) at the app layer |
| **G1** | **Glow userland (Sala broadcaster) inside the AVD** | This macOS host | horizon — gate: G0 · Sala B0/B1 (both already GREEN) |
| **G2** | **Real GrapheneOS build, emulator target** | A Linux host (KVM) | horizon, and genuinely out of reach on macOS — GrapheneOS ships **no prebuilt emulator image** (checked directly, `20260715.163500`: `grapheneos.org/build`). Their own `sdk_phone64_x86_64` development-build target exists only by building the full GrapheneOS/AOSP source tree, and its own docs name **KVM** for hardware acceleration — Linux-only, unavailable on macOS's HVF. This rung needs a Linux host (the NixOS Framework, once acquired) regardless of anything achievable on this Mac |
| **G3** | **Physical Pixel, GrapheneOS flashed** | Device | horizon — the real target device (Pixel 10 Pro XL flagship-first, per the go-to-market brief), gate: G1 |

**The honest register, named plainly rather than blurred:** G0/G1 exercise real AOSP/Android, the same userland surface GrapheneOS presents to an app, HVF-accelerated on this exact Mac — genuinely useful for developing and testing Glow's Android-side code today. They are **not** GrapheneOS itself, and no claim here says otherwise; GrapheneOS's own hardening (Titan M2, MTE, verified boot) lives beneath the userland surface G0/G1 can reach, and only G2's real build (on a Linux/KVM host) or G3's physical device ever actually exercises it. This is the same "prove the compute, not the platform" honesty M0/M0-riscv already carry for the Fairphone/postmarketOS side.

## Related

- `../../manual/guides/cloud-agent-toolchain-setup.md` — how the cloud dev env raises its toolchain.
- `../../external-research/20260715-182500_glowphone-firmware-freedom-two-body-strategy.md` — the Glowphone (Fairphone-class, /e/OS-then-postmarketOS) this emulates toward.
- `enclosure-editors.md` — the persistent-host editor/enclosure spec the NixOS host extends.
- `../../tools/glow_mobile_target_witness.rish` — the M0 witness (aarch64).
- `../../tools/glow_riscv_target_witness.rish` — the M0-riscv witness (riscv64), the RISC-V-substrate parity proof.
- `../../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md` — the decision this parity witness makes green.
- `20260715-193000_two-dev-environments-and-mobile-emulation.md` — the frozen dated original this twin now carries forward from.

---

Two environments, one clean rule: the cloud sandbox authors and proves on a target architecture; the NixOS Framework host boots the whole phone and flashes the real one — and M0/M0-riscv already show Glow's own fold running true on emulated aarch64 and RISC-V alike.
