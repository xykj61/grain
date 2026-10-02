# The star is not a cheaper ring -- flows_of answers before the question is asked

**Status:** Vision -- a reading proven on scratch metal, outside the tracked tree
([`../../../context/TWO_ROOMS.md`](../../../context/TWO_ROOMS.md))
**Setting:** Gauge Field - **Voice:** Kyri
**Stamp:** `20261002.150621`
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Caravan.
**Kin:** [`20261002-141234_the-chains-own-middle-is-also-one-instance.md`](20261002-141234_the-chains-own-middle-is-also-one-instance.md) -
[`20261002-145044_two-sub-rings-refuse-the-single-lap-a-wider-ring-does-not.md`](20261002-145044_two-sub-rings-refuse-the-single-lap-a-wider-ring-does-not.md) -
[`../../../caravan/systems/wide_roster.kyri`](../../../caravan/systems/wide_roster.kyri) -
[`../../../caravan/roster.rye`](../../../caravan/roster.rye) -
[`../../../caravan/relay.rye`](../../../caravan/relay.rye) - [`../../../caravan/channels.rye`](../../../caravan/channels.rye)

## What this essay answers

The kin essays measured touch cost for a ring and a chain. A ring holds N domains. Each domain
holds its own region. Each domain reads every other's at N-1 relay touches, and every read carries
a derived flow as its proof. A chain holds 3 domains at a fixed cost of 2, carrying a claim through
an unverified middle. A star sits in the tracked tree too -- `caravan/systems/wide_roster.kyri`,
five domains, read by `caravan/roster.rye`. Its zero relay touches reads, at a glance, like the next
point on that same curve: one hub, four clients, broadcast rather than relayed. This essay asks
whether that zero is a genuine point on the ring/chain curve, or a different problem wearing the
same "touches per read" metric. It answers by reading the declaration first, then by building three
scratch declarations and running them through the already-landed functions that derive ring and
chain shapes -- rather than by analogy alone.

## Method -- reading the declaration, then three scratch probes

`wide_roster.kyri` was read directly. It names five domains (`hub`, `client_a..d`), four channels
(each `hub <-> client_x`, each client paired with the hub alone), one region (`shared`, 4096
bytes), and five grants (`hub` holds `rw`, each client holds `r`). The file names one region in
total. `caravan/roster.rye`'s own header comment already states the one bound this declaration
meets: `capabilities.max_dependents = 4`, one below the five domains this star declares. So
`roster.from_system` names the mismatch by `TooManyDomains` -- proven by the tracked witness,
`tools/ca/caravan_roster_witness.rish`.

Three scratch `.kyri` declarations and one scratch Rye driver answer what the header comment leaves
open. The driver, `caravan/_scratch_star_probe.rye`, was built to `caravan/bin/_scratch_star_probe`
via `tools/fixtures/r/rye_build.sh`, the gitignored path the kin essays used. It asks one question
of two functions already landed: what do `caravan/relay.rye`'s `flows_of` and
`caravan/cycle.rye`'s `ring_order` -- the functions that derive a ring or a chain from grants --
make of a star?
All three `.kyri` files and the driver were removed once the transcript below was captured; none
was ever staged. `caravan/cycle.rye`, `caravan/relay.rye`, `caravan/channels.rye`, and
`caravan/roster.rye` stood exactly as landed throughout.

## Observation -- four readings, each one sharper than the last

**Reading 1 -- the tracked `wide_roster.kyri`, unaltered, run through `relay.flows_of`.**

```
$ ./caravan/bin/_scratch_star_probe caravan/systems/wide_roster.kyri
verify=whole
domain_count=5 channel_count=4 region_count=1 grant_count=5
roster_fits=no -- more domains than max_dependents
flows_of=null -- not every region has exactly one writer and one reader
```

`flows_of`'s own comment states its rule in full: a flow exists where a region is "granted
read-write to exactly one domain and read-only to exactly one other." `shared` is read-write to
`hub` and read-only to all four clients together. The very shape that makes the star a star -- one
writer, many readers -- is the shape `flows_of` was written to answer `null` on. This is the landed,
GREEN-witnessed declaration as it stands today, read before any scratch edit and before any return
channel is even drawn.

**Reading 2 -- declaring the literal "return channel" the falsifier named, `channel client_a hub`,
alongside the standing `channel hub client_a`.**

```
$ ./caravan/bin/_scratch_star_probe caravan/systems/_scratch_star_return.kyri
load refused: AlreadyLinked
```

`caravan/channels.rye`'s `Channel.joins` canonicalizes every pair by `(low, high)` domain index
before comparing, and `declare_channel` answers `AlreadyLinked` for a second line naming a pair
already wired (proven at `channels.rye:377-378` for both orderings of one pair). A channel in this
grammar carries no direction of its own; direction lives entirely in the grants laid over it. A
"return channel" names a line the parser already has standing under the other spelling, which this
reading surfaces by name rather than by argument.

**Reading 3 -- keeping the one channel already declared, and giving `client_a` the thing a return
channel was meant to buy: a second, independently-owned region (`client_a_state`, granted `rw` to
`client_a` alone).**

```
$ ./caravan/bin/_scratch_star_probe caravan/systems/_scratch_star_return2.kyri
verify=whole
domain_count=5 channel_count=4 region_count=2 grant_count=7
roster_fits=no -- more domains than max_dependents
flows_of=null -- not every region has exactly one writer and one reader
```

Still `null`. `flows_of` walks every declared region and stops at the first one that answers
outside its one-writer-one-reader rule; `shared` answers first, so the whole declaration reads as
flowless, whatever shape `client_a_state` carries on its own.

**Reading 4 -- isolating the mutual-link pattern on its own, away from any broadcast region: two
domains, two regions, each domain writing one and reading the other.**

```
$ ./caravan/bin/_scratch_star_probe caravan/systems/_scratch_two_cycle.kyri
verify=whole
domain_count=2 channel_count=1 region_count=2 grant_count=4
roster_fits=yes
flows_of=found count=2
  flow 0: region=0 from=0 to=1
  flow 1: region=1 from=1 to=0
ring_order=null -- no single lap closes
```

Here `flows_of` reads cleanly -- two directed flows, one each way, the exact two-domain cycle the
falsifier named as the collision to watch for. `ring_order` still answers `null`. `cycle.rye`'s own
text names the reason: `ring_order` opens by testing `domain_count < 3`, and its header states the
premise outright -- "a ring is at least three domains around." The two flows close into a cycle by
the graph's own arithmetic; Caravan's ring reader holds a ring to three domains or more, as a rule
stated once and applied at the top of its own search.

## Inference

**The star meets its answer before the falsifier's own question arrives.** The falsifier asked
whether a return channel would collide with the four-dependents bound, or be answered outright.
Neither happens. `flows_of` is the function both `ring_order` and `relay.rye`'s own chain-shape
check build on, and it already answers `null` on the star's one existing broadcast region -- with
or without any edit at all. The thesis this essay set out to test holds. It holds more fully than
stated: the star is more than a different problem wearing the ring/chain metric. It is a shape the
function behind that metric was never built to read.

**A "return channel" names a line this grammar already carries under another name.** Caravan's
channels are undirected pairs, the same choice the ring essays already found at the grant level.
The architecture is read from what is granted, and a channel states only that two domains may
exchange bytes at all. Asking for a second channel running the other way asks for a line the parser
has already satisfied under the first spelling. The lever that actually gives a star client a voice
back is a region, not a channel. Reading 3 shows that lever alone still answers `null`, while the
broadcast region keeps its four readers.

**`ring_order`'s own floor answers the falsifier's second half directly: outright, plainly, by a
rule stated once.** A two-domain mutual link reads as two clean flows. It still stands outside what
`ring_order` will call a ring, by a bound written in one comment and tested at the top of the
search. It stands apart from a sub-ring, a malformed ring, and the four-dependents cap in
`roster.rye` alike. That cap belongs to a different module, answering a different question -- how
many domains one supervisor seats. Reading 4's two-domain case sits well under it
(`roster_fits=yes`), apart from the question `ring_order` already settled on its own terms.

**Zero touches measures a different quantity than the curve the kin essays built.** That curve
answers one question: N domains, each independently holding state, want each other's reads
verified, at what cost? The star's one region holds one domain's state, broadcast to readers who
hold none of their own. `flows_of`'s own rule states formally why "zero touches" reads as a
different quantity from the ring's N-1. A broadcast of one domain's state to many readers, and N
domains each holding their own, are two different goods. Each earns its own honest price.

## Falsifier

The claim rests on four transcripts above. Each names the exact declaration, command, and printed
output. `flows_of`'s doc comment and `declare_channel`'s refusal table are quoted rather than
paraphrased, and a reader rebuilds all four scratch declarations verbatim from the bodies given
here. The driver called four functions already public and already landed -- `read.load`,
`relay.flows_of`, `cycle.ring_order`, `roster.fits` -- and edited none of them. A peer may hold that
`flows_of` should accept a many-reader region, or that `ring_order` should recognize a two-domain
cycle. That names a real design question this essay leaves standing. What this essay settles is
narrower: neither acceptance happens today, on the code as landed, and the star's present shape
meets its own answer before the falsifier's named collision is ever reached.

## What this leaves for Caravan's own lane

Three questions stand, named rather than answered. Should `flows_of` ever grow a many-reader
reading -- a true broadcast flow, standing beside today's rule? Does a star with genuinely two-way
per-client state belong in `caravan/systems/` as its own declaration, rather than as this essay's
scratch file? Is `ring_order`'s three-domain floor the right place to state that a ring and a
mutual link are different shapes? All three are Caravan's own module edits. This lane's
contribution stays the same across the arc: read what already runs, build small and disposable, and
report the transcript rather than the expectation.

Graded B/84 at Field.
