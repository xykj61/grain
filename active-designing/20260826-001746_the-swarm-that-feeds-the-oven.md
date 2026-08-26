# The Swarm That Feeds the Kiln

**Stamp:** `20260826.001746`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design; the cohort-training pattern read as a Mycelium cousin, its poisoning gap repaired with the tree's own spine; proposals only
**Kin:** [`../foundations/20260728-232511_lantern-lattice-kiln.md`](../foundations/20260728-232511_lantern-lattice-kiln.md) -- [`../foundations/20260825-211055_mycelium-the-consensus-protocol.md`](../foundations/20260825-211055_mycelium-the-consensus-protocol.md)

The tree's open model layer has three seated names: Ember bakes the model, Lattice serves
it, Lantern meters what the asking cost. The foundation says the bake happens on shared
green compute and the weights land in the commons. One question stands open between those
sentences: how do many small hands actually feed the bake? The April 2026 essay carried a
concrete answer worth siloing, together with a flaw it left unexamined.

## The pattern, plainly

A training cohort with no permission desk. Nodes of wildly different sizes join a run,
train locally for a fixed number of steps, compress their weight updates to a sparse
fraction of full size, share them over a gossip layer, and aggregate by a deterministic
rule. Rounds advance on time rather than on leader election, so any node joins or leaves
mid-run and the run continues. The essay's reported proof: thirty-two anonymous nodes,
from a small laptop to a large workstation, fine-tuned a half-billion-parameter model in
twenty-four hours with no parameter server and no validator set, loss falling from above
2.0 to 0.326 across fifty rounds and 846 contributions (the essay's own April 2026
report of a late-March 2026 run; unverified here, kept as its claim).

Read against the tree, the pattern is close kin to work already done. Mycelium's whole
season proved that leaderless, deterministic order over a mesh of signed blocks is this
tree's own craft: no leader, no certificate round, a pure walk over signed facts yielding
one order every honest node computes alike. A training round is a softer version of the
same shape -- bounded contributions, a deterministic fold, an order all parties can
replay. The swarm is not a foreign organism; it is a Mycelium cousin that happens to
carry gradients instead of transfers.

## The loop the old essay drew, and the tree has yet to draw

The essay's best sentence was economic. A participant who contributes bake-hours earns
serve-credit -- inference the contributor then holds first-class rights to use,
denominated in a unit no vendor can rescind, rate-limit, or deprecate. Carried onto the
tree's own names: **the hours a node gives Ember become tokens Lantern meters back**, on
the same shared ledger, in the same local currency the rest of the work settles in. The
foundations already hold both ends -- the wafer funded as public infrastructure on one
side, the honest meter on the other. The loop between them is the new line: training and
inference become two sides of one account, so the commons model is fed by the same
community it serves, and the funding story gains a second leg beside public investment.
The economics reverse the extractive default: instead of paying a distant company for
answers, a community earns answers by lending its idle machines to the bake.

## The flaw the essay skipped, and the tree's own repair

Permissionless aggregation of unsigned gradients is an open door. A hostile node can
poison a run with crafted updates, and an anonymous cohort cannot even say afterward
which contribution bent the model. The essay praised the openness and never priced it.

The repair is the spine this tree already keeps. **Every delta is a signed fact** --
keypair, signed event, append-only log -- so every contribution has an author that
cryptography remembers. **Aggregation is a pure fold** over those facts, deterministic
and replayable, so any observer recomputes the round and gets the same weights.
**Exclusion is by evidence:** a contribution that fails a stated statistical gate is set
aside by a rule written before the run, and the fold without it is still one answer
everyone computes alike. And the round is bounded the way everything here is bounded --
a named maximum of nodes, a named maximum of delta bytes, a timeout per round with a
named error. None of this makes poisoning impossible; it makes every contribution
attributable, every round replayable, and every exclusion a fact rather than a mood.
That is the difference between a swarm and a commons.

## Sources and standing

**Drawn from:** `2026-04-18-023802-pdt-two-boxes-one-ring-v5.md` (the distributed
training section) with a touch of `2026-04-18-031102-pdt-the-open-spine-v4.md`.

**The living tree already covers:** the model layer's three names and the honest meter in
`foundations/20260728-232511_lantern-lattice-kiln.md`; the shared compute and its public
funding in `foundations/20260728-225239_the-wafer-and-the-sovereign-coin.md`; leaderless
deterministic order in `foundations/20260825-211055_mycelium-the-consensus-protocol.md`;
the five primitives in `foundations/20260702-184312_the-grain-and-the-crossing.md`.

**Genuinely new here:** the permissionless cohort-training pattern read as a Mycelium
cousin; the bake-for-serve credit loop connecting Ember's intake to Lantern's meter on
one ledger; and the poisoning critique with its signed-fact, pure-fold, bounded-round
repair -- the piece the old essay needed and never wrote.
