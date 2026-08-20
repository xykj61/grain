# Puddle — Fleet Placement Without a Scheduler (Exploration)

**Stamp:** `20260813.114651` · **Status:** Vision -- Living (self-approved design read) · **Voice:** Kyri
**Register:** Radiant · **Season:** D (Kresfa & Mycelium) — the double-seat expansion
**Kin:** [`the double-seat expansion`](20260813-020035_double-seat-expansion-six-seasons.md) (Season D names Puddle) · [`Puddle research`](../external-research/20260702-035018_puddle-sandboxed-rye-containers.md) · Lexicon **Puddle** · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md)

---

## What Puddle is

**Puddle** is the layer that hosts many sovereign **worlds** — a *world* is one bounded Rye whole with its own Pond and its own Kumara identity, the way a machine runs many guests while each guest believes it owns the machine (named `2026-07-02`, [`external-research/20260702-035018`](../external-research/20260702-035018_puddle-sandboxed-rye-containers.md)). Where the Mycelium season built how nodes **agree** — the Cord orders an uncertified DAG, the fold sums a supply, the Muster names a validator roll, the Warrant rotates it — Puddle builds the layer beneath all of that: **which host runs which world.** A fleet is a set of hosts, each with a capacity, and a set of worlds that must each land somewhere.

## The blind spot, and the trap it hides

Every long-lived fleet must place N worlds across M hosts, and every fleet faces the same trap the Warrant faced with authority: **who decides?** A central scheduler — one node that assigns placements and hands them down — is a single point of failure and a single point of trust. If that node falls, the fleet cannot grow; if it lies, it can strand a world or crowd a host, and a stranger cannot tell an honest placement from a hostile one. Kubernetes and Nomad answer with a scheduler and accept that cost. The leaderless grain the Mycelium season already keeps answers differently: **placement is not decided by anyone — it is derived by everyone, to the same answer.**

## The crux (r1) — a world berths at exactly one host, by a rule every node computes alike

The decisive, hard-but-tractable move is a placement that is a **pure function of the fleet** — the set of hosts (with capacities) and the set of worlds — and nothing else. Name a world's assigned host its **berth** (a place a vessel is given, in the pier lineage this tree already keeps: pier · ship · Amber · Constel). The berth law holds exactly when:

- **Every node computes the same berth.** Placement is invariant under the order hosts and worlds were added to the fleet — no arrival order, no scheduler's private state, changes where a world lands. Two nodes that hold the same fleet reach byte-identical placement without ever speaking.
- **Capacity is honored.** No host berths more worlds than its declared capacity.
- **No world is double-berthed or orphaned.** Each world lands on exactly one host; a fleet whose worlds outnumber its total capacity refuses **whole** (`Oversubscribed`) rather than strand one silently, and a fleet with worlds but no hosts refuses `NoHosts`.

The berth is **derived, never written** — there is no `set_berth`; a world's host is read out of the fleet the way the Cord's order is read out of its DAG, so a steward cannot hand-place a world past the rule.

## The method — highest weave-score, not modulo

Placement draws on **rendezvous hashing** (Highest Random Weight; Thaler & Ravishankar, studied clean-room as a concept only): each (world, host) pair earns a **weave-score** — `SHA-256(domain · world-id · host-pk)` — and a world berths at the highest-scoring host with room. This is chosen over the obvious `hash(world) mod host_count` for one Lindy reason that becomes the next round: when the roster changes, a modulo rule reshuffles nearly every world, while highest-weave-score moves **only the worlds on the host that changed**. That minimal-disruption property is exactly what a fleet needs to heal without a mass migration — so the method that makes r1 correct also makes r2 possible.

Ties in a 256-bit score are astronomically unlikely, yet the rule stays **total and arrival-independent** by breaking any tie on the host public key (never on insertion index), so determinism holds even in the impossible case.

## The four rounds

- **r1 — the berth crux.** `mycelium/puddle.rye`: a bounded `Fleet` of identity-bearing hosts and named worlds; `berth` derives the placement; arrival-order independence, capacity, exactly-one-berth, and the `Oversubscribed` / `NoHosts` refusals proven on metal.
- **r2 — the fleet heals (convergence).** A host departs; only its worlds re-berth, every world on a surviving host staying exactly where it was — the mesh self-heals with minimal disruption, the highest-weave-score property made visible.
- **r3 — the fleet travels.** A `format puddle-fleet-v1` Bron record renders and parses byte-for-byte; the recovered fleet berths to the identical placement offline (two nodes agree by exchanging the roster alone).
- **r4 — reads true.** A real on-disk fixture, produced reproducibly, cross-checked against an independent `awk` reading — two tools, one answer — so a fleet's placement can never drift from a roster a keeper reads by hand.

## Custody, held plainly

Demo host and world seeds only — no key held, no funds, no network, no real world provisioned. A real Aurora host (Puddle's horizon substrate) and any provisioning reach custody gates #2/#4; a **served** fleet (a node fetching the live roster over Comlink) reaches the Comlink-served gate. This journey builds the placement law on the bench, exactly as the Constel dev-net runs the real settlement protocol under a quarantined name.

## Gratitude to silo

**Rendezvous hashing / HRW** (David Thaler, Chinya Ravishankar) — the concept of scoring every (key, node) pair and taking the maximum, for its minimal-disruption property — studied clean-room, our own SHA-256 weave-score and our own bounded Rye. **Urbit Fleet** — the idea of spinning many isolated worlds for test — carried as concept, not code.

---

*A fleet that trusts no scheduler trusts arithmetic instead — and arithmetic is the same in every hand. May each world find the one berth every node already agrees is its own.*
