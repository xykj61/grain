# Expanded Prompt — Neth's Real Infrastructure Cost and Cluster Plan

**Language:** EN
**Version:** `20260714.012125` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Living — the research-grounded expanded form of the VPS-cost seed, addressed to a generic Acme Corporation employee

---

## The Seed

What VPN — wait, VPS — cost and size do we recommend, optimized for Glow OS's own CPU compute needs (kept separate from local-inference research on the Minisforum/Oculink home server), within a budget of a few hundred dollars or more per month, for a `~bandun`-quality star VPS that also runs the planet, once Glow OS's own Comlink/Ames + Mantra/Clay + Pier + ACID-compliant TigerBeetle-VSR-replicated, TAME-guided Neth cluster exists — sized to TigerBeetle's own recommended minimum consensus-node count, either all under one provider and one monthly bill, or command-line-synchronized across multiple providers for provider-outage redundancy?

## The Seed, Expanded After Research

Three facts, confirmed fresh, turn this into a real plan rather than a guess:

1. **TigerBeetle's own docs recommend exactly 6 replicas**, each needing only 1 CPU core, 6 GiB RAM minimum (16-32 GiB recommended), and its own separate disk and machine (both required, not optional) — and for the highest availability, 3 providers, 2 replicas each.
2. **A Pier is lightweight** — an actively used planet grows only 5-50 GB/year; a star+planet pair can share one small host comfortably.
3. **Real current prices** put a TigerBeetle-adequate 8 GB/local-NVMe replica at $7-10/month on Hetzner or Contabo, making a full 6-replica cluster plus a star+planet host land at roughly **$66.50/month single-provider**, or **$60-125/month three-provider**, both well inside the stated few-hundred-dollar ceiling.

## What Running It Produced

- The full cost/cluster plan, with real prices and a three-stage roadmap: [`../external-research/20260714-012125_neth-vps-cost-and-cluster-plan.md`](../external-research/20260714-012125_neth-vps-cost-and-cluster-plan.md).

## The Honest Shape of My Answer

- **Don't provision anything yet.** The cheapest, most disciplined first step is Neth's own minimal witness, run locally for $0 — exactly the "prove small before scaling spend" instinct this project already lives by.
- **Single-provider (Plan B) is the right first real infrastructure step** once that witness is proven: ~$66.50/month, one bill, comfortably clears TigerBeetle's minimums.
- **Multi-provider (Plan C) is real and matches TigerBeetle's own stated recommendation exactly**, and still lands well under budget — a natural second step once real value is at stake, not a first one.
- **The CPU-compute-separation instinct is already true by construction** — TigerBeetle uses one core per replica, so there was never going to be contention with local-inference work on the Minisforum/Oculink rig.

---

*May the cluster earn its providers one proven step at a time, and may every dollar spent buy real fault tolerance rather than idle headroom.*
