# Gossip Convergence — two Constel nodes reach one agreed order over the Cord

**Stamp:** `20260813.040613` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living (design capture, self-approved round) · **Season:** double-seat expansion D — Kresfa & Mycelium
**Kin:** [the Mycelium Cord](20260813-032851_mycelium-consensus-cord-exploration.md) · [the constel dev-net ledger](20260813-030005_constel-devnet-ledger-exploration.md) · [the dev-net harness](20260813-022908_constel-devnet-harness-exploration.md) · [the six-season expansion](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)
**Gratitude (clean-room, concepts only):** TigerBeetle (`gratitude/tigerbeetle`, `gratitude/TIGER_STYLE.md`) · Mysticeti / Bullshark / Narwhal (Mysten Labs, studied under Sui's permissive license per `gratitude-licenses.md`)

---

## Where this sits on the road

The Cord closed its four-round arc: a deterministic commit that reads one total order out of a mesh of
Kumara-signed blocks (r1), an equivocator quarantined (r2), a committed Dag that travels as a
`format cord-dag-v1` record (r3), and a real on-disk fixture read true (r4). Every one of those rounds
proved a property of **one node's Dag** — one keeper building or holding one graph.

Yet the Cord exploration named the open question plainly: *"the moment a second honest node holds its own
copy of the log, a new question opens that no single signer can answer."* r1 proved arrival-order
independence by adding the **same** blocks in several permutations into one Dag. It never proved the thing
a network actually promises: **two nodes that each began from their own local view, each minting their own
signed blocks, converge on the identical history once they gossip.** That is the crux this round fixes, and
it is the higher-Lindy one — a consensus primitive is worth exactly as much as its convergence guarantee.

This document seats no code; it fixes the shape, the name, and the crux, so the round that follows opens a
spine already known correct.

## The crux, in one line

**Two Constel nodes, each holding its own Dag of self-minted and received blocks, gossip their block sets
to each other in any delivery order; once each has heard the other, both `commit` to the byte-identical
order and both `fold` to the identical supply — convergence with no leader, no round of certificates, and
every buffer bounded.**

## The one genuinely new piece — `gossip_merge`

The Cord's `add` is deliberately strict: it refuses a block whose parents it does not yet hold
(`DanglingParent`), so the graph stays closed under "references" and acyclic by construction. That strictness
is right for admitting one block, yet gossip does not arrive in topological order — a node may receive a
child before the parent that legitimizes it. So the network layer needs one new bounded routine:

- **`gossip_merge(dst, src)`** — admit every block of `src` into `dst`, tolerant of delivery order. A
  **bounded fixpoint**: scan `src`; admit any block now admissible (parents already in `dst`); a block whose
  parents are not yet held is *deferred, not refused*, and retried on the next scan; a block `dst` already
  holds is skipped silently (gossip is idempotent — hearing the same block twice is normal, not a fault);
  a block whose signature does not verify is a **real fault** and refuses. Loop until a full scan admits
  nothing new. Because the source Dag is itself acyclic and closed, the fixpoint always drains it in at most
  `src.len` passes — a named, bounded ceiling, never unbounded retry.

This is the honest, TAME-bounded way to accept an out-of-order gossip stream: never a busy-wait, never an
unbounded queue — a fixed number of passes over a statically-sized set, each pass strictly monotone in blocks
admitted.

## The four rounds (Lindy-first, crux-first)

- **r1 — convergence (this round's crux).** `pond/apps/constel_consensus.rye`: two `Node`s, each with its own
  keeper and its own Dag. Node A mints a genesis issue; Node B mints its own genesis issue; each then mints a
  round-1 fact referencing **both** genesis blocks (so the merged graph has genuine cross-node fan-in). Gossip
  A→B and B→A via `gossip_merge`. Prove the crux: **both nodes' Dags commit to the byte-identical order and
  fold to the identical supply**, and that this holds independent of the order gossip delivers the source
  blocks (shuffle the source iteration; converge the same). A block a node minted stands unchanged; a forged
  block in the gossip stream refuses without disturbing what already converged.
- **r2 — partition heals.** Three nodes; one is partitioned away while the other two advance, then rejoins and
  gossips both directions. Prove the late joiner catches up to the identical order — convergence is not
  timing-dependent, only content-dependent.
- **r3 — the network travels.** A converged Node renders its Dag to the r3 `format cord-dag-v1` record and a
  second node reconstructs from those bytes alone and commits to the identical order — gossip carried as
  readable text over the (still-gated) wire.
- **r4 — read a real two-node fixture true.** Cross-check a genuine on-disk two-node converged Dag's commit
  against an independent `awk`/`rish` reading — two tools, one answer — so network convergence can never drift
  from the bytes a keeper can walk by hand.

## Boundaries

Siloed and dev-only on the Constel bench. Demo keeper seeds only — no real key, no funds, no live network,
no custody. Gossip here is **in-process block exchange**, not a wire protocol; a Cord actually gossiped over
Comlink reaches the serve gate (Keaton's hand), the maintainer's own Kumara instance stays gate #4. Composes
`mycelium/cord.rye` and `mycelium/fold.rye` public API only — inventing no storage, weakening no bound,
adding one bounded merge routine. Clean-room throughout: TigerBeetle and Mysticeti are studied, never copied.

---

*Two nodes reach through the dark from their own beginnings and, hearing each other, agree on one past. May
the Cord let every honest node arrive at the same history no matter which thread it heard first, may no node
need a leader's leave to know the truth, and may convergence cost nothing but the telling.*
