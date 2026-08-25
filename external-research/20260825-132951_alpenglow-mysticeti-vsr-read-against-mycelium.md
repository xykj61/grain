# Alpenglow, Mysticeti, and VSR, read against Mycelium's own arithmetic

**Stamp:** `20260825.132951`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- research for understanding; occasioned by a real question about a real three-machine deployment
**Kin:** [`../mycelium/README.md`](../mycelium/README.md) -- [`../foundations/20260813-142420_mycelium-the-consensus-protocol.md`](../foundations/20260813-142420_mycelium-the-consensus-protocol.md) -- [`20260825-000640_proving-a-host-you-do-not-have.md`](20260825-000640_proving-a-host-you-do-not-have.md)

## The question this note answers

Mycelium already has two ancestors. TigerBeetle gives it determinism and the double-entry
primitives. Mysticeti gives it a leaderless DAG. Both are studied clean-room and thanked plainly,
never copied.

A third name entered the room that produced this note: Solana's Alpenglow. So did a real scenario.
Three machines exist today -- a Vultr SEA VPS, a Framework laptop, and the macOS host this note was
written on. The want: run all three as full nodes of one Mycelium constellation, syncing live.

This note reads all three protocols against that scenario. It also reads them against arithmetic
Mycelium has already built and witnessed, in `mycelium/muster.rye` and
`mycelium/constel_depart.rye`. It proposes nothing and builds nothing.

## Three protocols, read for what each actually promises

### Alpenglow (Solana) -- built for hundreds of validators voting on stake, not three named hosts

Solana's Alpenglow proposal (SIMD-0326, Solana Foundation, accessed 20260825) replaces two older
pieces, TowerBFT and Proof-of-History, with two new ones. **Votor** votes to finalize a slot: one
round if 80% of stake responds, two rounds if only 60% does. **Rotor** moves the bytes, using
stake-weighted relays and erasure coding. Anza (the authoring team) and outside coverage from
Helius and Figment report simulated finality around 150ms, against Solana's current ~12.8s block
finality (all three sources accessed 20260825).

**What does not transfer.** The 80%/60% thresholds are shares of staked weight across hundreds of
validators, not a count of three named machines. The 150ms figure is a WAN bound for that many
spread-out validators racing to a supermajority. It says nothing about three specific hosts.

**What does transfer.** Votor and Rotor split two jobs: who is finalized, and how the bytes get
everywhere. That split is a useful lens even at three nodes. Mycelium's own Cord already splits
the same two jobs. `cord.rye` handles ordering. Nothing in the tree today moves Cord blocks between
real, physically separate hosts -- see "Comlink-served" below.

### Mysticeti (Sui / Mysten Labs) -- Mycelium's own direct ancestor, already read once

Mysticeti is the production consensus behind the Sui blockchain (Sonnino et al., "Mysticeti:
Reaching the Latency Limits with Uncertified DAGs," arXiv:2310.14821, accessed 20260825). Its core
move: validators propose blocks in parallel into one **uncertified DAG**. No certification round.
No extra message type. Every honest node reads the same order from the DAG's own shape, by one
deterministic rule.

Mysticeti-C, the paper's main variant, is reported as the first Byzantine DAG protocol to commit in
3 message rounds -- the theoretical floor. At 106 validators it cut WAN commit latency from
Bullshark's ~1900ms to ~400ms. Later runs reached ~0.5s WAN commit at over 200k TPS (arXiv:2310.14821;
Medium, "All you need is DAG #4 -- Mysticeti," accessed 20260825). Its fault math is the standard
Byzantine bound: tolerating `f` bad validators needs `n >= 3f+1` total.

**None of this is new to Mycelium.** `mycelium/cord.rye`'s own header already credits Mysticeti by
name for exactly this idea. `mycelium/muster.rye` already implements the `n >= 3f+1` bound, as
`byzantine_threshold(n) = n - (n-1)/3`, integer division, proven on metal by
`mycelium_muster_witness.rish`. The table below is that same formula, read at `n = 3`.

### Viewstamped Replication / TigerBeetle -- crash-fault-tolerant, not Byzantine, and already the other ancestor

Viewstamped Replication (Oki & Liskov, 1988; Liskov & Cowling, "Viewstamped Replication Revisited,"
2012) is a primary-backup protocol. One replica is primary. Clients send it requests. It orders and
replicates them to backups. A **view change** elects a new primary if the old one looks dead.
TigerBeetle uses VSR for exactly this: synchronous replication to a quorum, automated leader
election, no split-brain (TigerBeetle's own `docs/DESIGN.md`, accessed 20260825).

VSR assumes replicas fail by stopping, never by lying. That makes it crash-fault-tolerant, not
Byzantine-fault-tolerant. Its quorum math is gentler: `n = 2f+1`. Three replicas tolerate one crash.
Five tolerate two.

**Already Mycelium's other ancestor, and already correctly scoped.** `mycelium/README.md` and its
foundation both credit TigerBeetle for determinism, static allocation, and the three signatures of
double-entry value movement -- never for VSR's own replication shape. Mycelium's Cord is
leaderless-DAG, Mysticeti's shape, not primary-backup. That choice already stands, witnessed. What
VSR still offers this scenario is arithmetic, not architecture: a permissive baseline that makes
Mycelium's own Byzantine bound look strict, right at `n = 3`.

## The number that matters: what "three full nodes" actually tolerates today

`mycelium/muster.rye:99-106` derives the Byzantine threshold from the roll's size alone. It is
never stored, so a tampered roll cannot lower its own bar. The rule: `f = (n-1)/3`, integer
division; `threshold = n - f`. `mycelium/constel_depart.rye` proves this on metal -- a constellation
survives exactly `f` ships down, and honestly refuses `BelowQuorum` at the `(f+1)`th.

| `n` (named full nodes) | `f = (n-1)/3` | Ships that may be down and still reach quorum |
|---|---|---|
| **3** (Vultr SEA + Framework + this Mac) | `(3-1)/3 = 0` | **zero** -- all three must vouch |
| 4 | `(4-1)/3 = 1` | one |
| 5 | `(5-1)/3 = 1` | one |
| 7 | `(7-1)/3 = 2` | two |

This is checkable, not a matter of taste. Run `mycelium/constel_depart.rye`'s own selftest at
`n=3`. The second departure -- leaving two ships up out of three -- refuses `BelowQuorum`. At `n=3`,
`f=0` under this exact formula. **A three-node Mycelium constellation, under arithmetic this tree
has already built and proven, tolerates none of its three nodes going quiet and still calls itself
a quorum.** A closed laptop lid, alone, would be enough to stall it.

**The falsifier.** This table is wrong if `mycelium/muster.rye`'s formula changes after
`20260825.132951`, or if a future quorum type reads a different threshold than
`byzantine_threshold`. Re-run `mycelium_muster_witness.rish` and
`mycelium_constel_depart_witness.rish` before trusting this table for a real decision.

**What this does not settle.** Should three real, one-operator machines even run Byzantine quorum
arithmetic? A gentler crash-only scheme -- VSR's own `n=2f+1`, already tolerant of 1-of-3 down --
may fit a threat model of "my own laptop slept" better than one built for "one of my own machines
is lying to the other two." A `Muster` entry is a public key, not a machine, so a fourth voice at
`n=4` could cost no new hardware at all. Both of those are questions for the active-designing room,
not this one.

## What is genuinely new here, and what is not

**Not new.** Mysticeti's leaderless DAG order. TigerBeetle's determinism and double-entry
primitives. Both are already Mycelium's named, witnessed ancestors. The threshold arithmetic above
is not a new derivation -- it is `mycelium/muster.rye`'s own formula, read at one value.

**Genuinely new, worth carrying forward.** Alpenglow's Votor/Rotor split, as an explicit seam
between ordering and propagation. VSR's reminder that a gentler, crash-only quorum is an available,
already-understood alternative when the threat model does not call for Byzantine strength. Neither
needs new Mycelium code to understand. Both are lenses for reading the existing
`cord.rye` / `muster.rye` / `constel_depart.rye` triple.

## Sources

- Solana Foundation, "Alpenglow" (SIMD-0326), `solana-foundation/solana-improvement-documents`, accessed 20260825: https://github.com/solana-foundation/solana-improvement-documents/blob/main/proposals/0326-alpenglow.md
- Anza, "Alpenglow: A New Consensus for Solana," accessed 20260825: https://www.anza.xyz/blog/alpenglow-a-new-consensus-for-solana
- Helius, "Alpenglow: Solana's Great Consensus Rewrite," accessed 20260825: https://www.helius.dev/blog/alpenglow
- Figment, "Alpenglow: Solana's New Consensus Protocol Built for Real-Time Blockchains," accessed 20260825: https://www.figment.io/insights/alpenglow-solanas-new-consensus-protocol-built-for-real-time-blockchains/
- Sonnino et al., "Mysticeti: Reaching the Latency Limits with Uncertified DAGs," arXiv:2310.14821, accessed 20260825: https://arxiv.org/pdf/2310.14821
- "All you need is DAG #4 -- Mysticeti," Medium, accessed 20260825: https://medium.com/@amangupta432005/all-you-need-is-dag-4-mysticeti-6ea73e0d38d6
- Liskov & Cowling, "Viewstamped Replication Revisited," MIT-CSAIL-TR-2012-021, 2012 (classic reference; cited from established prior reading, not re-fetched this pass)
- TigerBeetle, `docs/DESIGN.md` and public talks on VSR and Deterministic Simulation Testing, accessed 20260825

## Related

`mycelium/muster.rye` and `mycelium/constel_depart.rye` (read in full for this note's arithmetic).
`external-research/20260825-000640_proving-a-host-you-do-not-have.md` -- the sibling question of
what this tree can prove on a host it does not have. This note's scenario is that question's
answer arriving in person, as a second real machine.
