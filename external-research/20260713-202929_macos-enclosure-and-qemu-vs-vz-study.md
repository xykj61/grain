# macOS Enclosure and QEMU-vs-Virtualization.framework — A First Study

**Language:** EN
**Version:** `20260713.202929` (Pacific stamp, this local clone's convention)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Research for understanding — study only; no lap opened, no policy seated

---

## What This Answers

Two questions from Kaeden's Pass 2 ask, held together because both are "what does the host give us on a Mac that Linux gave us before":

1. Can `SOURCE.md` Step 6 (ai-jail, becoming Pond) run at all on macOS, and what should stand in for `bwrap` + Landlock + seccomp?
2. Should this project's QEMU-based structural tests (the `comlink/run_*_wire_lab.sh` family, `aurora/run.sh`) still reach for QEMU on macOS, or does Apple's own `Virtualization.framework` (VZ) replace it?

Web research current as of `20260713`, gathered fresh per Kaeden's ask rather than assumed from training.

---

## 1. The macOS Enclosure — There Is No bwrap, and Apple Names No Direct Replacement

**The finding, plainly:** macOS has no user-namespace sandbox the way Linux has `bwrap`. The closest kernel-enforced mechanism is **Seatbelt**, reached through `sandbox-exec` and a Sandbox Profile Language (SBPL) policy. Apple's man page has marked `sandbox-exec` "DEPRECATED" since roughly macOS 10.8 (2012) and points developers at **App Sandbox** instead — but App Sandbox is an entitlement-based model for signed, distributed apps with containers, and it has no form that fits a bare CLI tool spawning a shell. Apple has shipped **no direct CLI-facing replacement** for `sandbox-exec` in the thirteen-plus years since deprecating it, and `sandbox-exec` still works, unmodified, through macOS 15 Sequoia — which is why Bazel, Nix, Homebrew, Docker, Chromium, Anthropic's Claude Code, and OpenAI's Codex CLI all still sit on it today for exactly this problem.

**What a Seatbelt profile can and cannot express**, mapped against what ai-jail gives us on Linux:

| Linux (ai-jail/bwrap) | macOS (Seatbelt/SBPL) | Gap |
|---|---|---|
| Filesystem namespace — only mapped paths exist | `(deny default)` + `(allow file-write* (subpath "..."))` — writes fenced to named paths | Reads are commonly left open (`(allow file-read*)`) because enumerating every toolchain read path is a maintenance trap; **write isolation and network isolation are the real guarantee, not read isolation** |
| Network namespace — no sockets unless granted | `(allow network*)` / `(deny network*)` — coarse, all-or-nothing per process | No native egress *filtering* (no "allow only github.com"); serious setups add an HTTP proxy in front and route `http_proxy`/`https_proxy` through it |
| Landlock (defense in depth on top of namespaces) | No equivalent primitive on macOS | Seatbelt is the whole boundary; there is no second independent layer to stack under it |
| seccomp (syscall filtering) | No user-facing equivalent | Not expressible from `sandbox-exec`; Endpoint Security framework could see syscall-adjacent events but needs a signed daemon and notarization, which is a different order of engineering |
| Private `$HOME` (`--private-home`) | No native primitive; a profile can deny reads/writes to the real `$HOME` while allowing a project directory, or a real substitute home directory can be prepared and pointed at via `HOME=` before exec | Achievable, just not built-in |

**What already exists in the open-source ecosystem for exactly this need** (all confirmed live as of this search):

- **`sandbox-exec` directly** — the primitive itself; every serious tool below is a thin, opinionated skin over it.
- **`agent-jail`** (Rust) — as of v0.3.0 gained a macOS `sandbox-exec` backend: it renders an SBPL profile from `--rw`/`--ro`/`--hide` flags and execs `sandbox-exec(1)`, with a stated dispatch-table philosophy — "the caller states the guarantee they want; agent-jail picks what the host can deliver, errors clearly, or warns under `--best-effort`" — which is close in spirit to how `ai-jail` itself is described in `SOURCE.md`.
- **Alcoholless** (Go, nttlabs) — a different, lighter approach: uses `su`/`sudo`/`rsync` and macOS's user-add equivalent to build a container-*like* boundary through actual macOS user isolation, rather than SBPL. Notably: its own authors say it *could* harden further by adopting `Virtualization.framework`, but chose not to because VZ gives no API to script a macOS VM's first-boot setup (EULA, iCloud, SSH) unattended.
- **`mkke/seatbelt`** (Go library) — a composable, allow-list API "inspired by go-landlock," built specifically to give Seatbelt the ergonomics Landlock has on Linux; re-execs itself under `sandbox-exec -p <profile>` so the sandbox applies before any of the child's own code runs (no race window).
- **Claude Code and Codex CLI** — both documented as using exactly this Seatbelt approach on macOS, `bwrap` on Linux, confirming this is the field's converged answer, not a one-off.

**The honest risk, stated by more than one source independently:** `sandbox-exec` could be removed someday with no announced successor, and the field's fallback plan if that happens is either a signed kernel extension (heavy, needs notarization) or the Endpoint Security framework (needs a background daemon). Nobody treats this as solved forever; everybody treats it as solved *today*.

### What this means for Pond specifically

`SOURCE.md` already names Pond as "a TAME-style reimplementation in our own language, Rye" of ai-jail's enclosure. On macOS, Pond's first host-specific seam is exactly this: a small Rye/Rishi-authored SBPL-profile generator plus an exec of `sandbox-exec`, following the same shape `agent-jail` and `mkke/seatbelt` already proved out — deny-by-default, named writable paths (the project directory and nothing else), network allowed or denied as a single coarse switch (egress filtering, if wanted, is a second and separate seam: an HTTP proxy the launch script points `http_proxy` at). This is a real, boundable, TAME-shaped piece of work — not a research horizon — but it is **not the same code path** as the Linux `bwrap` launcher in `tools/cursor-jail.sh`, and it needs its own witness the way `width-check.rish` witnesses the Rye width rules.

---

## 2. QEMU vs. `Virtualization.framework` — Different Jobs, Not a Straight Swap

**The finding, plainly:** on Apple Silicon, `Virtualization.framework` (VZ) is Apple's own, hardware-accelerated hypervisor API — introduced in Big Sur, actively developed through 2026 — and it is the *officially supported, best-performing* way to run an **ARM64 Linux guest** on an ARM64 Mac. QEMU still exists and still works on macOS, but on Apple Silicon it typically rides on top of `Hypervisor.framework` (`-accel hvf`) for ARM64-on-ARM64 acceleration; it has **no access to Rosetta 2**, so x86_64 code *inside* a QEMU guest falls back to slow user-mode software translation (roughly 20–40% of native), where VZ's `VZLinuxRosettaDirectoryShare` gives a Linux guest direct access to the host's real Rosetta translator (roughly 70–80% of native). Neither framework makes a full x86_64 **guest kernel** practical on Apple Silicon — that path is "excruciatingly slow," independent of which framework drives it; Rosetta translates x86_64 *applications*, not whole guest kernels.

**Where each one actually wins:**

| Need | Best fit | Why |
|---|---|---|
| ARM64 Linux guest, fast boot, low overhead, x86_64 binaries *inside* the guest | **Virtualization.framework** | Native Rosetta bridge via `VZLinuxRosettaDirectoryShare`; this is what Apple's own `container` tool and "Claude Cowork"-style setups build on |
| A guest architecture Rosetta and VZ don't cover at all (RISC-V is this project's own stated horizon) | **QEMU**, full-system emulation | VZ has no RISC-V device model; QEMU's TCG (software) or, later, a RISC-V hardware target is the only path |
| A **custom virtio device model** VZ doesn't expose, or fine device-level control | **QEMU** | VZ is deliberately opinionated and closed; it does not let a caller add or alter virtual devices the way QEMU's own device model does — this is the exact reason `libkrun`'s authors chose `Hypervisor.framework` over VZ for their own project, for the same class of need |
| Two ARM64 Linux guests talking over `virtio-net`, as this project's `comlink/run_*_wire_lab.sh` family already does today on Linux | **QEMU with `-accel hvf`** works as-is on Apple Silicon — same device model, same `-netdev`/`-device virtio-net-pci` invocations, hardware-accelerated CPU, no guest-arch mismatch since the wire labs are ARM64-native structural tests, not Rosetta-dependent |

**The concrete recommendation for this project's existing QEMU wire labs:** keep QEMU, and simply confirm `-accel hvf` is available and used in the macOS launch path (Apple Silicon ships `Hypervisor.framework` by default; no kext, no extra install beyond `qemu` itself via Homebrew). This is the lowest-disruption path — the existing `.rish` orchestration (`tools/*_wire_lab.rish`, `spawn`/`wait-for`) does not need to change shape, only the accelerator flag and any Linux-specific guest-image assumptions need auditing. A VZ-native rewrite of the wire labs is real, sound engineering — closer to what a shipped Rye OS product might eventually want for its own users on Apple hardware — but it is a **larger, separate lap**, not a Pass 2 quick fix, since VZ's device model and Rosetta bridge are Swift/Objective-C-first APIs with no first-class Zig or Rye binding today.

**A related fact worth flagging on its own:** QEMU as of recent releases ships a `vmapple` machine model that can *drive* a Virtualization.framework-provisioned macOS VM's own boot chain (`AVPBooter.vmapple2.bin`) — this is orthogonal to Linux-guest work and relevant only if this project ever wants a macOS *guest*, which nothing in the current roadmap asks for.

---

## Open Questions for the Next Check-In

- Does Pond's macOS enclosure want the `agent-jail`-style dispatch-table shape (state the guarantee, let the host pick the mechanism) so a future Linux port and this macOS seam share one Rye-authored interface? This reads compatible with TAME's "accrete, never break" and "one value model" rules, but it is a design choice, not yet a ruling.
- Is a VZ-native wire-lab port worth its own lap once the ARM64-macOS-hosted `-accel hvf` path is proven, given the project's stated RISC-V horizon already commits to keeping QEMU around regardless?
- Egress network filtering (the HTTP-proxy pattern) is unaddressed by Seatbelt alone — does Pond need it for the macOS host, or does the coarse allow/deny-network switch suffice for now, matching what `ai-jail` itself gives on Linux without a nested proxy?

---

*May the boundary hold on every host we grow into, and may we say plainly, always, exactly how strong that boundary is today.*
