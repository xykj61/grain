# Neth's Real Infrastructure — VPS Cost, Cluster Size, and a Roadmap

**Language:** EN
**Version:** `20260714.012125` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Research and cost plan — no infrastructure provisioned; all pricing current as of this research date

---

## For an Acme Corporation Employee Reading This

Keaton asked how much VPS infrastructure the Neth settlement layer (Glow OS's Comlink/Ames + Mantra/Clay + a Glow-native TigerBeetle-shaped VSR replica set, with a Pier for the `~bandun` star and its planet) actually needs and costs — optimized so Glow OS's own CPU compute never competes with the separate local-inference research already planned for the Minisforum/Oculink home server, within a budget of roughly a few hundred dollars a month, and weighing one provider under one bill against multiple providers under CLI-synchronized redundancy. This document answers with real, current numbers.

## What "Pier" Actually Means (confirmed against `docs.urbit.org`)

A **pier** is the directory holding a running ship's entire persistent state — its event log and everything Clay tracks — nothing more exotic. Vere copies itself into the pier on first boot, so a pier is self-contained after that (`[pier]/.run`). Piers are lightweight: **an actively used planet consumes roughly 5–50 GB of storage per year**, and Urbit ships use at most a modest amount of CPU/RAM — this is not a heavy workload by any measure relevant to VPS sizing.

## What TigerBeetle Actually Requires (confirmed against `docs.tigerbeetle.com`)

Per-replica minimums, straight from TigerBeetle's own hardware docs:

| Resource | Minimum | Recommended |
|---|---|---|
| CPU | 1 core (single-threaded; TigerBeetle does not yet use more) | +1 free core for the OS |
| RAM | 6 GiB | 16–32 GiB for caching (ECC required in production) |
| Disk | local NVMe, no RAID required | RAID 10/0 only if more capacity than one disk is needed |
| Network | 1 Gbps | — |

**Two hard constraints, not preferences:** each replica's data file must sit on a **separate disk** (required) and a **separate machine** (required) — you cannot run six replicas as processes sharing one box and call it a real cluster. Rack- and datacenter-level separation are recommended, not required.

**Confirmed directly, since it changes the whole cost picture: "separate machine" does not mean bare metal is required.** TigerBeetle's own hardware doc says explicitly: "In cloud or more complex deployments, remote block storage (e.g., EBS, NVMe-oF) may be used but will be slower and care must be taken to ensure independent fault domains across replicas" — cloud deployment is named and anticipated directly, not merely tolerated. Its own design doc goes further, naming **"VM migration"** as part of the system's stated fault model ("the system may freeze process execution for minutes or hours at a time, for example, during a VM migration") and discussing cloud-environment "gray failure" as an ordinary condition the design already routes around. A real-world reference (Hivebook's TigerBeetle writeup) confirms the recommended 6-replica/3-provider topology is commonly deployed as **"6 replicas, 3 clouds, 2 replicas each"** — cloud VPS instances, not bare metal. **The Plans below, built entirely on VPS pricing, are consistent with TigerBeetle's own documented and commonly-deployed topology, not a shortcut around its requirements.**

**One honest caveat, not a requirement but worth acting on:** "separate machine" still means each replica must be its own distinct instance — never two replicas sharing one VPS. Within a single cloud provider, two of *your own* VPS instances can in principle land on the same underlying physical host unless the provider offers (and you use) an anti-affinity or spread-placement feature; this is a real, if usually small, residual risk that genuine cross-provider separation (Plan C) removes entirely, since no two providers share physical infrastructure. Worth checking each chosen provider's own anti-affinity options before finalizing Plan B specifically.

**Cluster size: the optimal, recommended size is exactly 6 replicas.** TigerBeetle's own "flexible quorums" (Heidi Howard's design) mean only 3/6 replicas need to persist a write for it to be durable, and 4/6 are needed to elect a new primary — so the cluster stays available through real failures without needing a classic `2f+1` majority scheme. **For the highest availability, TigerBeetle's own docs recommend exactly what Keaton described: 6 replicas across 3 different cloud providers, 2 per provider** — this tolerates a complete outage of any one provider and still likely survives one additional replica failure on top of that.

## What This Means for Sizing — and Why It's Good News for the Budget

Since a replica needs only **one core**, cheap small-vCPU-count VPS tiers are exactly right — there is no reason to reach for anything bigger, and doing so would waste budget without buying TigerBeetle anything, since it doesn't use the extra cores. This also directly satisfies Keaton's own "delay local-inference compute onto the Minisforum/Oculink rig" instinct: **there is nothing here that wants GPU or many-core capacity in the first place.** The cloud spend and the local-inference research are naturally separate budgets, not competing ones.

## Real Prices, Checked Fresh (this research date)

Note: **Hetzner raised cloud prices sharply on 2026-06-15** — its dedicated-vCPU (CCX) and high-performance shared (CPX) lines roughly doubled to nearly tripled, but its **cost-optimized CX line only rose ~30–38%** and remains the strongest price-to-performance in this whole comparison.

At the ~8 GB RAM / local-NVMe tier that comfortably clears TigerBeetle's minimums with real caching headroom:

| Provider | Plan | vCPU | RAM | Disk | Monthly | Storage type |
|---|---|---|---|---|---|---|
| **Hetzner** | CX32 | 4 | 8 GB | 80 GB NVMe SSD | **~€8.49 (~$9–10)** | local NVMe |
| **Contabo** | VPS S | 4 | 8 GB | 200 GB SSD | **~$6.99** | SSD (oversubscribed; no DDoS protection, no cloud firewall, no hourly billing) |
| **Vultr** | Cloud Compute (8 GB tier) | 2 | 4 GB* | 80 GB SSD | **~$20** | local NVMe; DDoS protection + cloud firewall included |
| **DigitalOcean** | Droplet (comparable) | 2 | 4 GB* | 80 GB SSD | **~$24** | most polished docs/tooling; priciest per spec |

*Vultr/DigitalOcean's nearest comparable tiers land at 4 GB, not 8 GB, at that price point — their RAM-per-dollar is meaningfully behind Hetzner and Contabo; a true 8 GB tier on either costs closer to $40–48/month.

**A real caveat worth naming plainly:** TigerBeetle's own hardware doc specifically warns that remote block storage (the AWS EBS-style network disk many clouds default to) is slower and needs care to keep fault domains independent. Hetzner's CX line and Vultr's Cloud Compute both use **local NVMe**, which fits TigerBeetle's own stated preference directly; confirm this explicitly for whichever tier is finally chosen, since "SSD" alone doesn't guarantee it's local rather than network-attached.

## Three Concrete Plans, Cheapest to Most Resilient

### Plan A — Prove it first, spend nothing (recommended starting point)

Before any of this is provisioned, run Neth's own minimal first lap — the deterministic-root witness already named in [`20260714-001017_neth-mala-settlement-l1-l2-design.md`](20260714-001017_neth-mala-settlement-l1-l2-design.md) — entirely on this Mac, with zero replicas and zero cloud spend. This is the same discipline this whole project already lives by: prove the small thing works before paying to run six copies of it. **Cost: $0/month.**

### Plan B — One provider, one bill (the "under 1 provider" option Keaton named)

Six Hetzner CX32 replicas (each on its own VPS, satisfying the separate-machine requirement) plus one more CX32-tier box running the `~bandun` star and its planet's pier together (both are lightweight enough to share one small host):

```
6 × Hetzner CX32 (replicas)  ≈ 6 × $9.50  = $57.00/mo
1 × Hetzner CX32 (star + planet pier)      = $9.50/mo
                                    Total  ≈ $66.50/mo
```

One provider, one monthly invoice, real geographic diversity is optional within Hetzner's own regions (Germany/Finland/USA) but not cross-provider. **This comfortably clears TigerBeetle's per-replica minimums with 8 GB of caching headroom on every node, at well under a quarter of the stated budget ceiling.**

### Plan C — Three providers, TigerBeetle's own "highest availability" shape

Two replicas each on Hetzner, Contabo, and Vultr — matching TigerBeetle's own documented recommendation exactly — plus the star+planet host on whichever provider is cheapest (Hetzner):

```
2 × Hetzner CX32   ≈ 2 × $9.50   = $19.00/mo
2 × Contabo VPS S  ≈ 2 × $7.00   = $14.00/mo
2 × Vultr (8 GB tier, true NVMe) ≈ 2 × $40  = $80.00/mo
1 × Hetzner CX32 (star + planet) = $9.50/mo
                                    Total  ≈ $122.50/mo
```

This tolerates the complete outage of any one provider (Hetzner, Contabo, or Vultr) and still likely survives one more replica failure on top — TigerBeetle's own stated "highest availability" bar — while landing at roughly half the stated few-hundred-dollar ceiling, leaving real headroom.

**A cheaper variant of Plan C**, swapping Vultr for a second Contabo pair, drops the total to roughly **$60–65/month** while keeping three-provider diversity — the trade-off is Contabo's own named weaknesses (oversubscription, no DDoS protection, no cloud firewall, monthly-only billing), which matter more for a system meant to hold real settlement state than for a throwaway test box.

### Command-Line-Controlled Multi-Provider Sync

For Plan C, the current best practice (confirmed fresh) is **Terraform with per-provider isolated state** — never combine two providers' resources in one state file, since an API timeout on one provider would lock deployments on the other. The working pattern: one directory per provider, each with its own state backend and its own CI pipeline; a thin shared module layer describes the *logical* replica (Zig binary, data-file path, systemd unit) once, instantiated per provider. `abaasi256/vps-infra-recovery` is a public, current example of exactly this shape (AWS + Hetzner + Contabo, one Terraform command to redeploy any of them) — worth studying directly rather than designing from nothing, per this project's own "grow from what already works" instinct.

## The Roadmap Recommendation

1. **Now:** Build and run Neth's minimal deterministic-root witness locally — $0, proves the core claim, unlocks everything below.
2. **Once that's green and Keaton wants real infrastructure:** Plan B — six Hetzner CX32 replicas plus one star+planet host, ~$66.50/month, one bill, one provider. This is enough to run a real, durable, TigerBeetle-VSR-compliant Neth cluster and the `~bandun` star/planet pier, with room to spare under the budget.
3. **Once real value is at stake and provider-outage risk actually matters:** graduate to Plan C — three providers, two replicas each, Terraform-managed with isolated per-provider state — landing at roughly $60–125/month depending on which second/third provider is chosen, still comfortably inside the stated ceiling.
4. **Throughout:** keep all local-inference and Minisforum/Oculink experimentation entirely separate from this cloud spend — TigerBeetle's own single-core-per-replica design means there is no reason for these budgets to ever compete.

---

*May the cluster earn its providers one proven step at a time, and may every dollar spent buy real fault tolerance rather than idle headroom.*
