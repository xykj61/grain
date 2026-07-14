# Host Enclosure → VPS, and Which Providers Let the Genode Seam Run a Hypervisor

**Language:** EN
**Version:** `20260714.015200` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Research and strategy — no VPS provisioned, no script run against a real box from here. Register: findings are current as of this research date and **must be re-verified against each provider's own live docs before any commitment**, since virtualization policies change. Addressed to a generic Acme Corporation employee.
**Builds on:** `docs/PROVEN_SEAT.md` (the Genode/Sculpt ladder), `20260714-012125_neth-vps-cost-and-cluster-plan.md`, `../manual/guides/macos-ai-jail-setup.md`, `../manual/guides/self-hosted-vpn-setup.md`, `20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md`

---

## The Two Machines, and the One Question This Answers

Glow OS work happens across **two kinds of machine**, and this document makes their relationship explicit so the hosting strategy stops being implicit:

- **The host machine** — your Mac or Linux laptop, where you edit, build, and run witnesses *inside an enclosure*. It never needs to expose a hypervisor to the outside world; it reaches out.
- **The VPS machines** — the boxes you rent, where two very different workloads may live: the Neth settlement replicas (ordinary processes) and, separately, the **Genode microkernel seam** (the proven-seat ladder), which wants to run a *hypervisor inside the VPS*.

The one question this document answers, which the Neth cost plan deliberately did not: **which VPS providers actually let you run a hypervisor runtime inside a rented VPS** — the "nested virtualization" the Genode seam needs to run KVM-accelerated rather than crawling under pure emulation.

---

## The Distinction That Organizes Everything: Two Opposite Virtualization Needs

These two VPS workloads have **opposite** requirements, and naming that plainly prevents a costly mistake:

| Workload | Needs nested virtualization? | Why |
|---|---|---|
| **Neth settlement replicas** (TigerBeetle-shaped VSR) | **No** | A replica is an ordinary single-core process on an ordinary VPS. The Neth cost plan already confirmed bare metal is *not* required — a plain cloud VPS is the documented, common shape. |
| **Genode microkernel seam** (proven-seat ladder, KVM-accelerated) | **Yes** — or bare metal | To run the Sculpt/Genode image with `KERNEL=nova` under KVM (not slow TCG emulation), the VPS must expose `/dev/kvm` to its own guest — i.e., the provider must permit nested virtualization. |

So the earlier "is bare metal required?" question has **two different honest answers depending on the workload**: no for Neth (any VPS), but yes-or-nested-virt for a KVM-accelerated Genode seam. Conflating them would either overpay for Neth (buying dedicated boxes it doesn't need) or underprovision the Genode seam (renting a VPS that can only ever emulate, never accelerate).

---

## What Nested Virtualization Is, in One Paragraph

A physical host (**L0**) runs your VPS as a guest (**L1**); nested virtualization is L1's ability to itself act as a hypervisor and run its own guest (**L2**). The Linux kernel has enabled the `nested` KVM parameter by default for Intel and AMD since v4.20 — so the capability is usually a question of whether the *provider* passes the CPU's virtualization extensions (Intel VT-x / AMD-V) through to your VPS, not whether the kernel supports it. You confirm it inside a VPS with two checks: `grep -E 'vmx|svm' /proc/cpuinfo` shows a flag, and `ls /dev/kvm` exists. Known limitations to expect: a 10–30% performance overhead, not every KVM feature is available nested, and you cannot live-migrate or snapshot the L1 parent while an L2 guest is running.

---

## The Provider Matrix (verify before committing)

Confidence varies by how directly each provider documents it; **treat this as a starting map, not a settled fact — re-check each provider's own current docs before you rent**, because these policies change and marketing overstates.

| Provider | Nested virt on standard cloud VPS? | Note |
|---|---|---|
| **Hetzner Cloud** (CX/CPX/CCX) | **No** | The very line the Neth plan uses for replicas cannot run a KVM-accelerated Genode seam. Their **dedicated / root servers** (a different product) give full VT-x/AMD-V. |
| **OVHcloud** Public Cloud | **No (generally)** | Same shape as Hetzner: dedicated servers give full control; public cloud VPS generally does not. |
| **DigitalOcean** standard Droplets | **Reported / disputed** | Grouped with supporters in some surveys, but standard droplets have historically not exposed `/dev/kvm`. **Verify directly** before relying on it. |
| **AWS EC2** | **Yes**, on specific instance types | Documented: non-bare-metal `*7i`/`*8i`-family instances, KVM or Hyper-V as the L1 hypervisor; enable on a stopped instance. Priciest, best-documented. |
| **Cloudzy** | **Yes**, `/dev/kvm` exposed by default on every VPS | Explicitly markets KVM-on-KVM with no ticket/upgrade; from ~$2.48/mo, NVMe. Independent since 2008. |
| **SSD Nodes** | **Yes**, one-click at checkout ("Vippy") | Purpose-built for nested workloads; no BIOS/CLI tweaking. |
| **Bare metal / dedicated** (Hetzner Robot, OVH dedicated, others) | **Always** | Full hardware virtualization extensions; the surest ground for a KVM-accelerated Genode seam, at higher cost. |

**The clean reading:** for the Genode seam specifically, the honest choices are (a) a nested-virt-enabling VPS (Cloudzy or SSD Nodes are the most directly-documented, cheapest entry; AWS the most enterprise-documented), or (b) a dedicated/bare-metal box (Hetzner Robot / OVH dedicated) when you want no nesting overhead and full control. A standard Hetzner/OVH/DO cloud VPS can still run the Genode seam, but only in **TCG pure-emulation mode** — fine for a correctness witness, too slow to be a real seat.

---

## How the Host Reaches the VPS: The Enclosure, Then the Tunnel

The connection strategy is the same shape whether the host is macOS or Linux — only the enclosure mechanism differs:

**On the host (two paths, one role).** You run the editor and its tools inside an enclosure so nothing writes outside the project:

- **macOS host** — `sandbox-exec` (Seatbelt) via [`tools/cursor-jail-macos.sh`](../tools/cursor-jail-macos.sh), witnessed in [`../manual/guides/macos-ai-jail-setup.md`](../manual/guides/macos-ai-jail-setup.md). The write-fence is the real boundary; reads and network stay open (network can be denied with `--no-network`).
- **Linux host** — ai-jail (`bwrap` + namespaces + Landlock) via `tools/cursor-jail.sh`, the path `SOURCE.md` describes directly. This is the original enclosure the macOS path was adapted *from*, so the two are siblings, not rivals.

**The tunnel out (rish on the host, bash on the VPS).** The host reaches the VPS over the self-hosted WireGuard VPN already reified in [`../manual/guides/self-hosted-vpn-setup.md`](../manual/guides/self-hosted-vpn-setup.md): the **client half runs on the host in Rish** ([`tools/vpn_wireguard_client_setup.rish`](../tools/vpn_wireguard_client_setup.rish)), and the **server half is a bash deploy artifact** carried to the VPS ([`tools/vpn_wireguard_server_setup.sh`](../tools/vpn_wireguard_server_setup.sh)). This is the deliberate split: Rish orchestrates on the machine that has Rish; plain bash bootstraps the box that does not yet. Both halves already exist; only the server half awaits its first real run against an actual VPS.

**So the full path is:** host (inside macOS/Linux enclosure) → WireGuard tunnel → VPS. On the VPS, ordinary workloads (Neth replicas) run directly; the Genode seam runs only if that VPS is one of the nested-virt-enabling providers above, or is a dedicated box.

---

## The Rish Setup Scripts, and the One That Should Come Next

Today's real, witnessed rish/bash setup surface:

- [`tools/vpn_wireguard_client_setup.rish`](../tools/vpn_wireguard_client_setup.rish) — host-side, real and witnessed (idempotent key generation, config template, never prints the private key).
- [`tools/vpn_wireguard_server_setup.sh`](../tools/vpn_wireguard_server_setup.sh) — VPS-side, syntax-checked, awaiting its first real run.
- [`tools/glow_host_run.sh`](../tools/glow_host_run.sh) — reads `GLOW_HOST.bron`, refuses a mismatched toolchain; the pattern any future host↔VPS script should follow.

**The natural next script, named but not built here** (the same honesty the VPN server half already keeps — do not pretend a script is witnessed against infrastructure that does not exist yet): a Rish provisioner that, given a VPS reachable over the tunnel, (1) confirms nested virt with the two-line `/proc/cpuinfo` + `/dev/kvm` check, (2) refuses loudly if the provider turned out not to expose it (so you learn before you build, not after), and (3) otherwise fetches the pinned Genode toolchain and runs the proven-seat G0 boot on the remote box. Building it wants a real nested-virt VPS to witness against first — so it is named as the next rung, not stubbed in ahead of the metal.

---

## What Remains Open

- **Which nested-virt provider to actually trust** — Cloudzy and SSD Nodes are the most directly documented and cheapest; AWS the most enterprise-grade; each needs its own live-doc re-verification and ideally a throwaway-VPS `/dev/kvm` probe before any commitment.
- **Whether the Genode seam belongs on a VPS at all yet** — the proven-seat ladder runs fine locally today (Framework host with `/dev/kvm`, or TCG in the jail). Moving it to a rented box is a real step to take only when a remote seat earns its keep, not before.
- **The remote-provisioner Rish script** — designed above, gated on a real nested-virt VPS to witness against.
- **Verification, always** — every provider claim here is a starting map; the two-line in-VPS check is the only truth, exactly as this project treats every other claim (`../context/TWO_ROOMS.md`).

---

*May the host reach out from behind its fence, may each VPS be exactly the kind its workload needs — no hypervisor where none is wanted, real acceleration where one is — and may every provider claim be checked on the metal before a dollar rides on it.*
