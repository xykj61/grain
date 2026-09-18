# Three real MOX, and what the outer loop would actually do with them

**Stamp:** `20260825.133156`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- proposal, horizon; no custody gate crossed, no code written
**Kin:** [`../mycelium/README.md`](../mycelium/README.md) -- [`../external-research/20260825-132951_alpenglow-mysticeti-vsr-read-against-mycelium.md`](../external-research/20260825-132951_alpenglow-mysticeti-vsr-read-against-mycelium.md) -- [`../recursion-prompts/seed/autonomous-loop.seed.md`](../recursion-prompts/seed/autonomous-loop.seed.md) -- [`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)

## The idea, plainly

Three real machines exist today. A Vultr SEA VPS. A Framework laptop. The macOS host this document
was written on -- the first genuine second host this tree has ever had, arriving the same day as
[the open question](../external-research/20260825-000640_proving-a-host-you-do-not-have.md) about
proving claims on a host you do not have.

The want: each machine runs its own **MOX** -- already-seated vocabulary, a Mycelium instantiation,
one running instance (`context/LEXICON.md`, `20260823.122619`). The three MOX form one live
**Constel** -- also already-seated, a named reproducible constellation, `mycelium/constel.rye`. The
outer/inner recursion loop on each machine both feeds and reads that Constel in near-real-time,
instead of each machine running its own disconnected loop against its own disconnected
`ITINERARY.md`.

Nothing below invents a new module. Constel, Muster, Cord, Tenure, Testament -- all already exist,
already witnessed, already running over demo seeds. This document proposes one wiring: which
primitive answers which part of the want, and which named custody gate the wiring would cross to
become real.

## What three real ships already buy, and what they do not

The research note beside this one worked the arithmetic already built into `mycelium/muster.rye`.
At `n=3`, the Byzantine threshold `f = (n-1)/3` is exactly zero. A three-ship Constel refuses
`BelowQuorum` the moment even one ship goes quiet. A closed laptop lid stalls the whole
constellation, not one-third of it.

**Read as a feature, for a team of three.** A quorum needing all three voices matches what "team of
three, synchronizing" actually asks for. Three people staying in step, not a swarm tolerating
arbitrary absence. `testament.rye` already carries the fallback for the moments that arithmetic
misses: a **Testament** is an offline certificate a Constel seals with fewer than the full roster
up. A round two of three actually finished can still be proven true later, to the machine that was
asleep. That machine never needed to be online to believe it. The design already built for
`constel_depart.rye`'s r2 rung reads as "catch the sleeper up," not "route around the sleeper."

**If same-round fault tolerance is genuinely wanted** -- so Framework going offline for an update
does not stall macOS and Vultr from finishing a round together -- the cheapest lever is not a
fourth *machine*. A `Muster` entry is a public key, not a compute host
(`mycelium/muster.rye:59-61`). A fourth enrolled voice can be a passive Kumara identity with no
workload of its own -- a phone, a small always-on add-on, or a second key one of the three
operators already holds. At `n=4`, `f=(4-1)/3=1`. One ship, real or passive, may be down and the
constellation still reaches quorum. This choice belongs to whoever runs the constellation. It is
named here so it gets made on purpose, not discovered the first time Framework reboots mid-round.

## Reading Alpenglow's split, and VSR's gentler quorum, into the wiring

The research note names two lenses worth carrying in, neither needing new code to understand.

**Votor/Rotor's split of ordering from propagation** maps onto one seam Mycelium already has and
one it does not. `cord.rye` already orders -- a mesh of signed blocks, walked deterministically, no
leader. Nothing in the tree today propagates those blocks between real, physically separate hosts.
That is exactly the "Comlink-served" line `mycelium/README.md` already names as an uncrossed
custody gate: a node fetching a live roster, a moving world's freight, or another shard's out-fact,
over the real network. Read plainly: **Rotor's job, here, is Comlink's job.** Three machines
exchanging signed Cord blocks over a real connection is the one genuinely new wire this proposal
needs. It is the gate already named, not a new one invented here.

**VSR's gentler `n=2f+1` crash-only quorum** is worth keeping as an explicit alternative, not a
replacement, for one layer only: the outer loop's own turn-taking, described below. There, the
threat model really is "my own laptop slept," never "one of my own three machines is lying to the
other two." Byzantine arithmetic is right for anything touching real value -- `till.rye`,
`purse.rye`, `pledge.rye`, already gated behind the funds custody gate. It may be more caution than
three machines one person owns and trusts need for deciding whose turn it is to run the next lap.
Both options are named here, not chosen. The choice belongs to whoever crosses the gate.

## What the outer loop would actually do differently

Today, per `recursion-prompts/seed/autonomous-loop.seed.md`, the outer loop is one shell `while`
wrapper around one fixed prompt. It reads one `construction/ITINERARY.md` as the single live card,
on one checkout. Running it on three machines at once today would mean three checkouts, three
cards, and a manual, human scheme to keep the three from proposing the same next step. A prior
exploratory answer in this same conversation already named that exact gap.

**The proposal.** At the top of a round, each machine's outer loop writes its *proposed* next lap
as a small signed fact into the live Cord -- not into `ITINERARY.md` directly. The Cord's one law
already resolves the contest: the order is decided once, by everyone, and read by everyone the same
way. This is not a new mechanism. It is `tenure.rye`, read at a new altitude. `tenure.rye` already
resolves a contested name -- two claimants, one name, first claim in the agreed order holds it, the
later claimant lawfully loses. A round's "which crux does this lap belong to" is the same shape: a
contested claim on a shared slot, a round's lap, decided by whichever proposal lands first in the
one order every honest MOX computes alike. The losing machine's proposal becomes a lawful no-op,
exactly as `tenure.rye` already names it. Its outer loop moves to the next round's slot instead of
stalling.

`ITINERARY.md` itself stays single-stranded, exactly as its own foundation names it -- one live
card, one writer. This wiring does not give it three writers. It gives the whole constellation one
agreed answer, each round, to "whose proposal is this round's real next step." Only the machine
that won that round's Tenure actually executes and writes the card. The single-stranded design
this tree already chose stays intact. Three machines now share a fair, provable way to decide who
holds the pen for the next paragraph.

## What is agent-doable now, and what waits for a hand

Following the same two-room discipline `mycelium/README.md` already states for itself:

**Agent-doable today, over demo seeds, no custody gate:**
- A `constel.rye` fixture naming three ships -- `sea`, `framework`, `macos`, placeholder dev-net
  role names, not real network addresses -- and a `Muster` enrolling their three demo keys.
- A design and a witness for "round-tenure": `tenure.rye`'s existing claim rule, applied to a
  `round_id` slot instead of an account name, proven with fake keys and a fake Cord, the same way
  every other Mycelium family proves itself before touching anything real.
- A witness proving the `n=3, f=0` / `n=4, f=1` table above directly against
  `mycelium_muster_witness.rish`, so the arithmetic is checked on metal, not trusted from this prose.

**Waits for Keaton's hand -- named gates, none invented here:**
- Any real Comlink fetch between the three physical machines -- the "Comlink-served" gate
  `mycelium/README.md` already names.
- Provisioning anything new on Vultr SEA to carry this -- gate 2, `construction/ITINERARY.md` line
  145. Agents author IaC; Keaton provisions and pays.
- Generating any real, non-demo Kumara identity for the macOS or Framework MOX from a real seed --
  gate 4, his hand alone.
- Anything the already-booked **MOX constellation on SUI** door also touches
  (`ITINERARY.md` line 172, booked `20260823.184309`). That door already names "anything touching a
  real chain is a gate." This proposal's three-ship Constel is a design sibling of that booked
  door, not a second, uncoordinated answer to the same question.

## What this document does not do

It does not cross the Comlink-served gate. It does not provision anything, generate a real key, or
claim the three-machine Constel runs today. It names one wiring, existing primitives applied to
three real machines and the outer loop that already runs on at least two of them, so that when the
named gates are crossed, the crossing has a design behind it. Not one improvised under a laptop's
low-battery warning.

## Related

`mycelium/muster.rye`, `mycelium/constel.rye`, `mycelium/constel_depart.rye`, `mycelium/tenure.rye`,
`mycelium/testament.rye` -- existing primitives this proposal reuses, none edited.
`recursion-prompts/seed/autonomous-loop.seed.md` -- the outer/inner loop this proposal extends.
`construction/ITINERARY.md` line 172 -- the booked MOX-on-SUI door this proposal sits beside, not
replaces. The `constels/` room named at `ITINERARY.md` lines 227-231 -- a related, separately-scoped
direction, Kumara live implementations feeding Growthcircle, not read in full for this pass and not
assumed to already answer this document's question.
