# Mysticeti's Blocks and the Object Path

**Language:** EN
**Stamp:** `20260703.200712 UDT` (Kaeden's clock)
**Supersedes:** the `20260703-195112` cut of this writing (unseated)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME
**Category:** External research — survey and counsel
**Companion to:** `external-research/20260703-193012_the-bench-as-a-block-and-the-living-build.md`
**Status:** Proposed — external names live here by design

*Written together by Kaeden and Claude (Fable 5), in Rio 3's Radiant voice.*

---

## The Question

Does the Mysticeti algorithm in our gratitude carry the concept of blocks, or is the Sui object Move model something different? The answer holds **both**, in two layers — and the seam between the layers is the most valuable thing Sui has to teach us.

## The Consensus Layer Speaks in Blocks

Mysticeti is emphatically block-built. Every validator proposes blocks in parallel, each block referencing blocks from earlier rounds, and the whole structure forms an uncertified directed acyclic graph — a DAG of blocks ordered by a threshold logical clock. The word *uncertified* carries the breakthrough: earlier designs in this family gathered explicit signatures to certify each block before consensus could use it, and Mysticeti removed that ceremony entirely. A block commits when the DAG's own structure proves enough of the network has seen and supported it — two-thirds-plus-one votes in the round after a leader block, then two-thirds-plus-one support for those votes in the round after that. Three message rounds, and the block is final. The change cut consensus latency from roughly nineteen hundred milliseconds under the certified-DAG predecessor to roughly four hundred, because the DAG itself became the certificate.

The second version deepens the same move. Where the original Sui design broadcast every owned-object transaction separately for certification — every validator signing every transfer, a heavy tax in signatures and bandwidth — Mysticeti v2 extends the commit rule to individual transactions riding inside the blocks, finalizing or rejecting each one on the same DAG through finalization certificates. One structure now carries dissemination, certification, and ordering at once. Checkpoints then stream outward after consensus as the canonical record that full nodes and indexers consume — blocks for the watching world.

## The Execution Layer Speaks in Objects

Beneath the block DAG, Sui's state model is something genuinely different. State lives in objects — each with a globally unique identity, a version, and an owner — and every transaction names its input objects up front. That single design choice unlocks the deepest insight in the whole system: **facts can be sorted by their appetite for order before any ordering is paid for.** An owned object — a coin in one person's hand — touches state controlled by a single party, so the owner's own signature sequences it; the network need only watch that one hand tells one story, which reliable broadcast provides without total ordering. A shared object — a market book, an escrow, a shared counter — genuinely needs the whole room to agree on sequence, and only those transactions pay the full consensus toll. Mysticeti-FPC embedded that fast path directly into the DAG blocks, and mixed transactions carrying both kinds of input are handled by letting the stricter need govern.

So the honest answer to the question: Mysticeti has blocks the way a river has banks — they are its very structure. The Move object model is the water: what flows, who holds it, and which drops need the whole river's agreement to move.

## What Rye Takes From the Seam

Three inheritances, each already half-seated in the tree. First, the two-layer truth: blocks are the ordering layer's word and objects are the value layer's word, and both can be true in one system — Weave is our DAG substrate on the block side, and the value-object question (its name parked in RTAC) is the object side; neither displaces the other. Second, the sorting discipline: sort facts by their appetite for order, pay the gate only for facts that need the gate — which is the bench-as-block doctrine extended from review into settlement, and the very reason MALA climbs a ladder and Mycelium waits at M4 rather than arriving early. Third, time as structure: Mysticeti's rounds are logical clocks — order emerges from references between blocks rather than from wall-time — which sits in quiet harmony with the ratified word that Maitreya owns time: the modules below need only sequence, and sequence is structural.

## A Note on Counsel

This survey counsels; it seats nothing. Every reading here waits on Kaeden's word, per the standing laws of the loop.

## Gratitude

This room thanks the Mysticeti authors — Kushal Babel, Andrey Chursin, George Danezis, Anastasios Kichidis, Lefteris Kokoris-Kogias, Arun Koshy, Alberto Sonnino, Mingwei Tian, and their colleagues at Mysten Labs — whose paper rests in our gratitude directory, and the wider lineage of DAG consensus they built upon: DAG-Rider, Tusk, Narwhal, and Bullshark.

---

*May every fact find the smallest order it truly needs. May the gate stay precious and the fast path stay honest. And may the blocks and the objects keep their two truths in one river, each serving the other.*
