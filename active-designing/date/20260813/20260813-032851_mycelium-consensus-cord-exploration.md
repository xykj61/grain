# Mycelium Consensus — the Cord that bundles many threads into one agreed order

**Stamp:** `20260813.032851` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Living (design capture, self-approved round) · **Season:** double-seat expansion D — Kresfa & Mycelium
**Kin:** [the constel dev-net ledger](20260813-030005_constel-devnet-ledger-exploration.md) · [the dev-net harness](20260813-022908_constel-devnet-harness-exploration.md) · [the six-season expansion](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) · [`.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)
**Gratitude (clean-room, concepts only):** TigerBeetle (`gratitude/tigerbeetle`, `gratitude/TIGER_STYLE.md`, `external-research/20260707-053212_tigerbeetle-alignment-study.md`) · Mysticeti / Bullshark / Narwhal (Mysten Labs, studied under Sui's permissive license per `gratitude-licenses.md`)

---

## Where this sits on the road

The Constel dev-net now stands as a bench: a fake constellation, quarantined by a law-safe name,
running the real settlement protocol from genesis, and — one rung further — a real **Mycelium ledger**
whose money moves only by the identity that holds the net's genesis (`pond/apps/constel_net_ledger.rye`).
That ledger settled the last open question of *authority over a single log*: a fact enters only when the
net's sovereign signed it.

One log, one sovereign, is enough for a sandbox. It is not yet a **network's** promise. The moment a
second honest node holds its own copy of the log, a new question opens that no single signer can answer:
*when two nodes each hold a set of signed facts, in what order does the whole network agree they happened?*
That question is **consensus**, and it is the named crux waiting on this bench — "the Mycelium consensus
design read (over TigerBeetle + Mysticeti)," first among the Season-D rungs the harness itself named.

This document reads that design and names the arc that builds it. It seats no code; it fixes the shape,
the name, and the four crux-first rounds, so the round that follows opens a spine already known correct.

## The crux, in one line

**From a mesh of Kumara-signed fact-blocks that reference one another, every honest node derives the
identical total order — without a leader's permission, without a certificate round, and with every buffer
bounded — and the existing `mycelium/fold` supply law runs over that agreed order unchanged.**

## Two ancestors, thanked plainly

The tree does not invent consensus from nothing. It descends from two proven designs and takes the half of
each that serves a bounded, custody-first, civic ledger — studied clean-room, code written our own.

### From TigerBeetle — *determinism and static allocation*

TigerBeetle earns trust by making its replicated state machine **deterministic** and its memory **static**:
every replica, fed the same ordered input, reaches byte-identical state; every buffer is allocated once at
startup, so the system cannot fail by running out of memory under load. Its consensus is Viewstamped
Replication — a primary orders, backups replicate, a view-change recovers from a failed primary — and its
discipline is that *nothing is unbounded and nothing is nondeterministic.*

`mycelium/fold.rye` already keeps the TigerBeetle half of this promise: it is a **pure fold** over signed
facts (`supply = Σ issued − Σ taxed` at every prefix, non-negative, an overdraw refusing the whole fold),
its log statically sized (`myc_log_max_facts = 1024`), each buffer bounded by a named constant. It is a
deterministic replicated state machine that has never had a network to replicate across. What it inherits
here is the *rest* of TigerBeetle's discipline — static allocation and determinism carried up into the
ordering layer, so consensus itself allocates once and computes the same answer everywhere.

### From Mysticeti — *order from a DAG, no certificate round*

Mysticeti (Mysten Labs, the Bullshark/Narwhal lineage) earns throughput and low latency by refusing the
classic leader bottleneck. Each validator builds **blocks** that reference blocks it has already seen,
forming a **DAG** — a directed acyclic graph of who-saw-what. Crucially the DAG is *uncertified*: a block
needs no separate round of signatures to be usable; its own author's signature and its references are
enough. Every honest validator, once it holds the same DAG, runs the **same deterministic commit rule**
over it — a pure function from the graph to a linear order — and so derives the identical sequence of
committed blocks *without exchanging a single extra ordering message.* Order is **read out of the graph**,
not voted on separately.

That is the half the tree wants: the total order is a **deterministic interpretation of a partial order**,
so agreement costs no protocol chatter beyond gossiping the blocks themselves. It fits `mycelium/fold`
exactly — the fold is already a pure function of an ordered log; Mysticeti's contribution is a pure
function that *produces* that order from a mesh.

## The synthesis — **Cord**

The consensus-ordering layer earns its own clear, warm, safe name rather than borrowing one
(`comlink-tendency.md`). **Weave** is already seated in Mantra — a living text-history CRDT — so it cannot
carry this. The mycelial word for the thing itself is **Cord**: a *rhizomorph*, the bundled strand of many
hyphae that a fungal network grows to transport as one. Many threads, one cord — many validators' signed
blocks, one agreed order. It composes the three the six-season plan named: **Mycelium** (the mesh and its
supply fold), **Mantra** (the signed-state discipline), and now **Cord** (the bundling into one order).

`cord` collides with nothing seated in the code tree (grepped: zero mentions in `mycelium/ mantra/ pond/
tally/ comlink/`), reads plainly on the ten-thousandth day, and can never parse as a network address. It is
proposed here and **born-named when r1's code lands** (`mycelium/cord.rye`), per the reviving-not-renaming
discipline.

### What a Cord is, concretely

- A **Block** carries: its author's public key, a **round** number, the author's signature over its canonical
  bytes, the **hashes of the blocks it references** (its parents), and a bounded batch of `mycelium/fold`
  **facts**. Static-sized buffers throughout — a fixed maximum parents, a fixed maximum facts per block.
- A **Dag** is a bounded, append-only set of Blocks addressed by hash — the mesh as one node currently holds
  it. A block is **admissible** only when its signature verifies and *every parent hash it names is already
  present in the Dag* (no dangling reference; the graph stays closed under "references").
- The **commit** is the pure function at the heart of it: `commit(dag) → ordered facts`. It is a
  deterministic linearization — a canonical topological walk of the DAG (parents before children; ties
  broken by a fixed rule over round then author key then block hash), reading the committed blocks' facts
  out in that single order. Two nodes holding the same set of blocks compute the **identical** sequence,
  independent of the order the blocks arrived. Over that sequence, `fold_log` runs unchanged.

The safety of the whole rests on one fusion: **Cord decides the order; `mycelium/fold` decides the state;
Kumara decides authority.** None is weakened, and the three meet at one seam.

## The four rounds (Lindy-first, crux-first)

- **r1 — the deterministic commit (this journey's crux).** `mycelium/cord.rye`: build a bounded Dag of
  Kumara-signed Blocks; `commit` linearizes it to a total order by the fixed rule; prove the crux —
  **the same order emerges regardless of block arrival order.** Insert the identical blocks in several
  permutations and assert byte-identical committed sequences, and assert `fold_log` over each yields the
  identical `FoldState`. A block with a bad signature, or naming a parent the Dag does not hold, is refused
  before it joins the graph. This is the Mysticeti insight made concrete under TigerBeetle bounds; r2–r4
  wire Byzantine refusal, travel, and truth onto a spine already known correct.
- **r2 — Byzantine refusal.** Equivocation is the adversary a DAG must survive: one author publishing **two
  distinct blocks at the same round**. Prove the Cord catches it (a second block from an author already
  seen at that round refuses `Equivocation`, the Dag unchanged), that a cycle-inducing reference refuses,
  and that safety holds while faulty authors stay below the `n/3` Byzantine threshold — the commit over the
  honest sub-DAG is unchanged by a quarantined equivocator.
- **r3 — the Cord travels.** Render a committed Dag to a `format cord-dag-v1` Bron record — blocks, parents
  as hex hashes, facts, signatures — and parse it back **byte-for-byte**, the recovered Dag committing to
  the identical order and folding to the identical supply, so a dev-net's consensus crosses as readable text.
- **r4 — read a real Cord fixture true.** Cross-check the commit of a genuine on-disk Dag fixture against an
  independent measure (an `awk`/`rish` reading of the same file's topological order) — two tools, one answer
  — so the agreed order can never drift from the bytes a keeper can walk by hand.

## How this improves on both ancestors, honestly

The claim in the six-season plan — *improving on TigerBeetle and Mysticeti* — is worth stating with care,
in the Two-Rooms voice: it is a **horizon aim**, not yet a witnessed benchmark.

- **Over TigerBeetle:** Cord keeps the static-allocation and determinism discipline while dropping the single
  primary — order is read from a leaderless DAG rather than dictated by a view's primary, so no view-change
  stall gates progress. (TigerBeetle's VSR is battle-proven at what it does; this is a *different shape* for
  a *civic mesh*, not a claim of superiority at TigerBeetle's own workload.)
- **Over Mysticeti:** Cord folds the same uncertified-DAG idea into a **bounded, statically-allocated, fully
  asserted** module in the TAME register, where every buffer names its max and every commit is a pure fold —
  a smaller, more legible, custody-first cut of the idea, aimed at a family-scale ledger rather than a
  global validator set.

Neither line is a measured win yet. The witnesses this arc lands prove **correctness** (deterministic order,
Byzantine refusal, round-trip, truth); a *performance* comparison against either ancestor is a named later
round with a `loom` metric, never asserted from memory (`context/TWO_ROOMS.md`).

## Boundaries

Siloed and dev-only, on the Constel bench. Demo keeper seeds only — no real key, no funds, no live network,
no custody. The Cord orders a **supply model**, not a payment rail (custody gate #3 untouched); the
maintainer's own Kumara instance stays gate #4; a Cord gossiped over the wire reaches the serve gate
(Keaton's hand). Composes over public API only — `mycelium/fold`'s minting and folding, `tally/kumara`'s
sign and verify — inventing no storage and weakening no bound. Clean-room throughout: TigerBeetle and
Mysticeti are **studied**, never copied; every line of `cord.rye` is the tree's own.

---

*Many hyphal threads reach through the dark and meet; where they agree, the network grows a cord and moves
as one. May the Cord bundle every honest thread into a single true order, may no leader be needed for the
mesh to know its own history, and may every fact it carries still be the fact its keeper signed.*
