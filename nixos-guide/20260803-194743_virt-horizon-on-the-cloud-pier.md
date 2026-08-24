# Virt Horizon on the Cloud Pier

**Language:** EN
**Stamp:** `20260803.194743`
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Voice:** Riyo
**Status:** Living note -- measured on hostname `pier` (NixOS 26.05 - Vultr SEA - 2 vCPU / 4 GB)
**Follows:** guide 0 - flake home at `/etc/nixos` - templates under `templates/`

*Written together by Keaton and Riyo.*

---

This pier is already a KVM guest. Nested virtualization is off: `/dev/kvm` is absent, and no `kvm` host modules load. QEMU guests here run **TCG only** -- slow, and tight beside mosh and Cursor CLI on four gigabytes. Framework keeps the KVM lane for proven-seat Genode work.

## What this host can hold now

| Ask | Answer |
|-----|--------|
| **s6 / s6-rc packages** | Yes -- declare in `/etc/nixos` `systemPackages` for supervision study. Does not replace systemd as PID 1. Inherit the discipline; do not swap the host init this season. |
| **SixOS as QEMU guest** | Possible later under TCG only. Heavy next to the agent; not a standing goal until swap and a budgeted sitting. SixOS as *replacement host* is a different install. |
| **Genode / Sculpt as QEMU guest** | Same TCG-only limit. Toolchain and image thrash on 4 GB. Framework owns `lane_kvm` and jailed TCG proven-seat (`docs/PROVEN_SEAT.md`). |
| **Genode ⊂ SixOS ⊂ NixOS** | **Refuse.** Research already ordered succession: NixOS now - SixOS later as host composition - Genode as QEMU guest, never merger (`external-research/20260712-054342_proven-seat-guest-genode-sel4.md`). Triple nesting earns no ladder rung. |

## Measured facts (`20260803`)

- `Hypervisor detected: KVM` - `/dev/kvm` absent - no `/sys/module/kvm*`
- ~3.8 GiB RAM - no swap - ~90 GiB free disk
- OS horizon in REMEMBER: Genode - SixOS - Nix remains **PARK** (proven-seat parallel on Framework)

Revisit TCG guests only with swap seated and an explicit word that accepts the slow serial path.

---

*May the pier stay a sentence. May nested virt wait for metal that can hold it. May Framework keep the proven seat's KVM door.*
