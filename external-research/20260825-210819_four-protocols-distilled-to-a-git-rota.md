# Four protocols, distilled to a git rota

**Stamp:** `20260825.210819`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- research for understanding; the seated design is [`../active-designing/20260825-210819_the-round-that-pulls-twice.md`](../active-designing/20260825-210819_the-round-that-pulls-twice.md)
**Kin:** [`20260825-132951_alpenglow-mysticeti-vsr-read-against-mycelium.md`](20260825-132951_alpenglow-mysticeti-vsr-read-against-mycelium.md) -- [`20260825-205011_hotstuff-and-hashgraph-read-for-the-piers.md`](20260825-205011_hotstuff-and-hashgraph-read-for-the-piers.md)

## The question

Four consensus families were studied this season, each in its own note: Alpenglow and Mysticeti
with VSR beside them (`20260825.132951`), then HotStuff and the hashgraph (`20260825.205011`).
This note asks one narrower question of all four at once: **while git is the constellation's
carriage -- before the Comlink wire, before DJINN's Bit Design System reaches Brushstroke and
Realidream -- what does each family lend a two-pier round that pulls, works, and pushes?** One
lesson per family, each already proven against this tree's own collisions of `20260825`.

## One lesson per family

**From HotStuff: the push is the vote, and its refusal is the protocol working.** A quorum
certificate is a portable artifact any node verifies alone; the ordering remote's ref lock plays
the same part for two piers. A plain push either fast-forwards -- the round is allocated -- or
refuses, and the refusal carries exactly the information a view change needs: someone else landed.
Rotation stays cheap because taking the pen is one fetch and one read. The rota's sentences 4 and
15 are this lesson verbatim.

**From the hashgraph: pull often, and let structure carry agreement.** Gossip-about-gossip says
the record itself is the conversation -- a commit hashes its parents, so every pull is a gossip
round and every merge is virtual voting over what both piers already hold. The more often the
piers pull, the smaller every divergence; the rota's twice-pulled shape is gossip at round
cadence. Derived surfaces (the index folds, the stamp-keyed spine) are virtual voting's second
face: the contended value is computed from the merged record rather than claimed at write time.

**From Mysticeti and the Cord: concurrent proposals are normal, never an error.** A DAG protocol
treats two blocks in one round as the expected shape and orders them deterministically after the
fact. The rota inherits the posture: a refused push is a lawful outcome, the re-integration is
the commit rule running, and the parked pier branch is a block waiting for the walk to order it.

**From Alpenglow and VSR: split ordering from carriage, and match arithmetic to the threat.**
Votor decides while Rotor moves bytes; here the ordering remote decides while the mirror and the
seed carry copies -- which is why mirror-first is the one forbidden order. And VSR's gentler
crash-only arithmetic, chosen over Byzantine thresholds for the pen, is what lets one sleeping
laptop defer a round instead of stalling a constellation.

## What the distillation declines

A second clock (the median), quorum machinery on the happy path, and any force-push recovery --
each declined in its own note, and each declined again here by the same three sentences the two
studies converged on: contention dissolves when the contended thing is derived; every
coordination event deserves an artifact; the happy path is sacred.

## Sources

The two in-tree studies named in the header, their own sources carried there (PODC 2019;
ePrint 2023/397; SWIRLDS-TR-2016-01; SIMD-0326; arXiv:2310.14821; Liskov-Cowling 2012), all
accessed 2026-08-25; git's own receive-pack ref-locking behavior (git-scm docs, accessed
2026-08-25); and the adversarial review of the rota recorded in the design beside this note.
