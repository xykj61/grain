# This Local Host — System and Hardware, Anonymized

**Language:** EN
**Version:** `20260713.211800`
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living — record for this specific machine, refresh when hardware or OS changes

---

## What This Is, and What It Deliberately Leaves Out

A working record of the Mac this `~/urbit` clone lives on, gathered for Kaeden's own security review — treating this laptop as a **work machine** holding real credentials (SSH keys, GPG signing key, `gh` tokens), not a personal device. Every identifier that could single out *this exact unit* or aid an attacker who already has physical or remote access is left out on purpose:

**Withheld, and why:** serial number, hardware UUID, provisioning UDID, MAC addresses, real hostname, local IP address, and the logged-in account's real username. None of these help harden the machine; all of them help an attacker fingerprint or impersonate it. If Kaeden ever needs the real values (for an AppleCare call, an MDM enrollment, or similar), they are one `system_profiler SPHardwareDataType` away and do not belong pasted into a git-tracked document.

---

## Hardware

| Field | Value |
|---|---|
| Model | MacBook Air, `Mac14,2` |
| Chip | Apple M2 — 8 cores (4 performance + 4 efficiency) |
| Memory | 24 GB unified |
| Storage | ~995 GB physical volume; ~139 GB free / 24 GB used on the boot volume at time of writing |
| Architecture | `arm64` (Apple Silicon — relevant to the QEMU/Virtualization.framework study: this host gets hardware-accelerated ARM64 guests via `-accel hvf` or VZ, and Rosetta-bridged x86_64 *inside* an ARM64 guest via VZ only, not via QEMU) |

## Operating System

| Field | Value |
|---|---|
| Product | macOS `26.6` (build `25G5028f`) |
| Kernel | Darwin `25.6.0`, `RELEASE_ARM64_T8112`, built `2026-05-15` |
| Shell | `zsh` (Homebrew paths at `/opt/homebrew`) |

## Security Posture — As Found, `20260713.211800`

| Control | State | Read on a work machine |
|---|---|---|
| **FileVault (disk encryption)** | **On — encryption finished** (confirmed `20260714.053400` via `fdesetup status` and in System Settings) | **Closed.** Was the single highest-priority fix; the disk is now unreadable without the login password or the recovery key. The recovery key is saved to 1Password as a secure note — the right home for it, off this machine, in the one place meant for exactly this. Guide: [`../../manual/guides/filevault-setup.md`](../../manual/guides/filevault-setup.md) |
| **System Integrity Protection (SIP)** | Enabled | Good — leave it on; it is the boundary that keeps a compromised user-level process from rewriting system binaries or code-signing enforcement itself |
| **Gatekeeper** | Enabled (`assessments enabled`) | Good — leave it on; it is what makes unsigned/unnotarized code ask before it runs |
| **Screen lock delay** | Immediate | Good — the screen locks the instant it sleeps or is closed, rather than after a grace window |
| **Automatic macOS updates** | Enabled (`AutomaticallyInstallMacOSUpdates = 1`, `CriticalUpdateInstall = 1`) | Good for a work machine — security patches land without a manual step to forget |
| **Application Firewall** | **Not checked** — reading its state needs `sudo`, and this record was gathered without prompting for or storing a password | Kaeden should check by hand: **System Settings → Network → Firewall** — recommend **On**, with "Block all incoming connections" considered if no inbound services (like a self-hosted VPN test server) are deliberately run from this machine |

## Software Relevant to This Project's Trust Chain

| Tool | Version (from this session) |
|---|---|
| `git` | Homebrew, at `/opt/homebrew/bin/git` |
| `gh` | `2.89.0` |
| `gnupg` | `2.5.18` |
| `pinentry-mac` | `1.3.1.1` |
| `git-lfs` | installed this session (was previously absent — see the `PUBKEYS_new` session log) |
| `cursor` (CLI) | `3.7.15`, native `.app`, not the Linux AppImage `SOURCE.md` Step 5 describes |

---

## Why It Is Shaped This Way

- **Security review, not inventory.** The point of this document is "what should Kaeden fix," not "what does Kaeden own" — hence the anonymization stays firm even though this is a private local clone, since dated docs in this tree are meant to accrete and this one may get cited or shared before Kaeden thinks to scrub it later.
- **FileVault is named first because it is the finding that matters most.** Everything else here (SIP, Gatekeeper, screen lock, updates) was already in a good state; naming them is confirmation, not correction.
- **The firewall line stays honest about what wasn't checked**, rather than guessing or silently skipping it — TAME's own root discipline ("say why," "assert positive space and negative space") applies to plain-English security notes as much as to Rye code.

---

*May this machine hold its secrets well, and may every gap named here close before it is ever tested by someone who wishes it hadn't.*
