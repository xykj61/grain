# HotStuff and Hashgraph, read for a two-pier tree

**Stamp:** `20260825.205011`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- research for understanding; the siloed design is [`../active-designing/20260825-205011_the-pen-the-gossip-and-the-derived-spine.md`](../active-designing/20260825-205011_the-pen-the-gossip-and-the-derived-spine.md)
**Kin:** [`20260825-132951_alpenglow-mysticeti-vsr-read-against-mycelium.md`](20260825-132951_alpenglow-mysticeti-vsr-read-against-mycelium.md) -- REDS %230 (`../construction/REDS.md`)

## The occasion

Two clones of this tree booked the same ledger row number within five minutes of each other today,
each reading a spine that was internally perfect (REDS %230). The pier repaired it by hand: keep
the earlier stamp, shift the later rows, sweep the citations. The open gate asks how the next
number is allocated when two piers run at once. Two more protocols were read for that question,
clean-room per [`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md):
HotStuff, the leader-rotation family, and Hedera's hashgraph, the leaderless derived-order family.
Both readings are dated 2026-08-25.

## HotStuff -- the pen handed on cheaply

HotStuff (Yin, Malkhi, Reiter, Gueta, Abraham; PODC 2019) runs one leader per view. Each phase
is one broadcast plus votes, aggregated into a **quorum certificate**. The QC is a
constant-size, self-verifying artifact. It says: *n-f distinct signers endorsed exactly this.*
Chaining collapses three phases into one message shape, and the leader rotates every block.

Four lessons carry, and each is about artifacts rather than asymptotics:

1. **A handoff is an artifact, never a conversation.** A new leader collects the highest QC and
   extends it. The QC is portable and verifies offline. Rotation costs the same as a normal round,
   so it happens every round -- the recovery path becomes the happy path, and gets its exercise.
2. **The pacemaker separates.** Safety (no two conflicting commits) holds under any timeout or
   election behavior; only progress depends on the pacemaker. Descendants swapped pacemakers
   freely without re-arguing safety.
3. **Silence is never evidence.** DiemBFT, the production descendant, skips a stalled leader only
   on a **timeout certificate** -- a signed artifact recording the stall -- never on quiet.
4. **Never tax the happy path to armor the sad one.** HotStuff-2 (Malkhi and Nayak, ePrint
   2023/397) dropped back to two phases by paying a synchrony wait only on the path that had
   already lost responsiveness. Jolteon made the same bet in production and cut steady-state
   latency roughly 30%.

The lineage's verdict on scale is plain: below large n, *one pen, cheaply handed on* is the
simpler and faster shape, because the output is one serial log and every height has one
accountable proposer.

## Hashgraph -- the order derived, never claimed

Baird's hashgraph has one deep move, stated two ways. (The source: Swirlds tech report
SWIRLDS-TR-2016-01, 2016; open-sourced into Hiero under the Linux Foundation, Apache 2.0,
2024.)

- **Gossip-about-gossip**: every event carries the hashes of two parent events, so the
  communication history *is* the data structure. A git commit DAG is already this shape -- every
  commit hashes its parents.
- **Virtual voting**: no vote message is ever sent. Every node computes every other node's votes
  deterministically from its local copy of the graph. Agreement travels as structure, never as
  traffic.

Ordering falls out the same way: rounds and famous witnesses are derived by every node
identically, and the consensus timestamp is the median of receipt times. **Order is never claimed
at write time; it is a pure function of the merged record.** That sentence is the %230 repair,
performed by hand today, stated as an algorithm.

One piece was read and declined: median-of-receipt-times as a multi-pier clock. The median's
manipulation resistance wants a meaningfully large honest supermajority; over two or three
machines it is one clock with extra steps, and this tree's one-clock law is constitutional -- a
second stamp source would reintroduce the exact ambiguity the naming law exists to kill.

## Governance -- thresholds by decision type, and passing unless vetoed

The Hedera Governing Council (accessed 2026-08-25) seats up to 39 named organizations, one
equal vote each. A public LLC agreement sets **different thresholds for different decision
types**. Routine matters take a simple majority, network parameters a supermajority, and the
money supply unanimity. Small-federation practice adds two shapes worth keeping: **M-of-N multisig**
for the degenerate quorums (2-of-3 reads as one-may-sleep), and **optimistic governance** --
proposals pass unless vetoed within a window, with timelocks holding the irreversible.

This tree already governs this way without naming it. Custody gates are standing vetoes. The
maintainer's word is the constitution. Agent laps proceed autonomously on the reversible. What
the outside patterns supply is the one hole the tree has yet to write: an **absence policy** --
which standing words persist unattended, and the rule that no irreversible door ever un-gates by
timeout.

## What the two families agree on

Read together against a two-pier git tree, the families converge on three sentences:

1. **Contention dissolves when the contended thing is derived.** Hashgraph derives votes and
   order; HotStuff derives the new leader's safety from one carried QC. Both replace conversation
   with computation over shared structure.
2. **Every coordination event deserves an artifact.** A QC, a timeout certificate, an event with
   two parent hashes -- never a phone call, never silence.
3. **The happy path is sacred.** Both lineages' matured forms (HotStuff-2, Jolteon, virtual
   voting itself) exist to keep the common case at network speed and push every cost onto the
   rare case.

## Sources

- Yin, Malkhi, Reiter, Gueta, Abraham, "HotStuff: BFT Consensus with Linearity and
  Responsiveness," PODC 2019 (arXiv:1803.05069); accessed 2026-08-25
- Malkhi, Nayak, "HotStuff-2: Optimal Two-Phase Responsive BFT," ePrint 2023/397; accessed 2026-08-25
- DiemBFT / LibraBFT technical reports (pacemaker, timeout certificates, leader reputation);
  Aptos Jolteon/Ditto paper (arXiv:2106.10362); Espresso HotShot docs; accessed 2026-08-25
- Baird, "The Swirlds Hashgraph Consensus Algorithm," SWIRLDS-TR-2016-01 and the worked-examples
  companion TR-2016-02; hedera.com algorithm pages; the Hiero (Linux Foundation) open-sourcing
  announcements, 2024; accessed 2026-08-25
- Hedera Governing Council pages and LLC-agreement summaries; Gnosis Safe M-of-N docs; optimistic
  governance write-ups (timelock + veto-window pattern); accessed 2026-08-25
- In-tree, read this round: `mantra/` (the binding, the weave, two-way sync), `amphora/README.md`
  and `vessel_seal.rye`, `comlink/` (wire format, handshake, discovery, recall sync),
  `foundations/20260823-212603_the-lattice-voice.md` and the Q-vane notes, REDS %230
