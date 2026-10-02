# Two sub-rings refuse the single-lap check; a wider ring passes it whole

**Status:** Vision -- a reading proven on scratch metal, outside the tracked tree
([`../../../context/TWO_ROOMS.md`](../../../context/TWO_ROOMS.md))
**Setting:** Gauge Field - **Voice:** Kyri
**Stamp:** `20261002.145044`
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Caravan.
**Kin:** [`20261002-103827_a-lap-costs-the-same-whatever-shape-you-fold-it-into.md`](20261002-103827_a-lap-costs-the-same-whatever-shape-you-fold-it-into.md)
(named the composition gap this piece tests) -
[`20261002-143117_the-n-equals-4-ring-already-ran-inside-a-concurrency-test.md`](20261002-143117_the-n-equals-4-ring-already-ran-inside-a-concurrency-test.md)
(found a wider ring already running, without a new declaration) -
[`../../../caravan/cycle.rye`](../../../caravan/cycle.rye) - [`../../../caravan/regions.rye`](../../../caravan/regions.rye) -
[`../../../caravan/channels.rye`](../../../caravan/channels.rye)

## What this essay answers

The kin essay above named a gap in Caravan's ring. An eight-domain ring could be built from two
four-domain sub-rings, each kept separately verified, then composed into one. The composing
function stays unwritten. That leaves two live questions, and this essay runs both on scratch
metal rather than reasoning from the header comments alone:

1. Does Caravan's own bound table (`max_domains`, `max_channels`, `max_regions`, `max_grants`)
   actually require a split to reach eight domains, or does one ring of eight already fit?
2. What does `caravan/cycle.rye`'s landed `ring_order` function do when handed a declaration
   shaped like two disjoint four-domain rings?

## Method -- two scratch declarations, read by already-landed functions, never landed themselves

Two throwaway `.kyri` files held the test declarations, written outside `caravan/systems/`'s
tracked roster (`_scratch_ring8.kyri` and `_scratch_disjoint_rings.kyri`). Both were removed once
this essay was drafted. Neither was ever staged or committed. Two small driver programs, equally
scratch and equally removed, called three functions already public and already landed: `read.load`
parses and checks a declaration's static shape. `relay.flows_of` derives the directed flow graph
from the grants. `cycle.ring_order` searches that graph for the one lap that visits every domain
once and comes home -- the same function `check_shape` already calls on every landed ring in this
tree. `caravan/cycle.rye`, `caravan/regions.rye`, and `caravan/channels.rye` stayed exactly as
landed throughout. The build used `vendor/zig-toolchain/zig` via `tools/fixtures/r/rye_build.sh`,
emitted to the gitignored `caravan/bin/`, the same path the kin essays used.

**Declaration A -- a single connected eight-domain ring.** `alder -> birch -> cedar -> dogwood ->
elm -> fir -> gum -> holly -> alder`, in the exact shape `serial_cycle_wide.kyri` already uses for
four domains. One region carries each directed hop, granted `rw` to its writer and `r` to its
single reader. Every domain keeps the two roles `serial_cycle_wide.kyri` already proves -- writer
of one region, reader of its predecessor's -- carried out to eight.

**Declaration B -- two disjoint four-domain rings in one system.** The same eight domain names
split into two groups, `alder-birch-cedar-dogwood` and `elm-fir-gum-holly`. Each group closes its
own four-ring in `serial_cycle_wide.kyri`'s own shape. Zero channels and zero regions join the two
groups together.

## Observation -- the bound table, read against both shapes

| Bound (declared in `regions.rye` / `channels.rye`) | Ceiling | Declaration A uses | Declaration B uses |
|---|---|---|---|
| `max_domains` | 8 | 8 | 8 |
| `max_channels` | 16 | 8 | 8 |
| `max_regions` | 12 | 8 | 8 |
| `max_grants` | 24 | 16 | 16 |

Both declarations use identical counts of every bound. Both name eight domains joined by eight
directed hops, and every ceiling here counts domains and hops alone. It reads the same total
whether those hops close into one ring or two. `max_domains` is the single bound either shape
reaches exactly; the other three sit at 50 to 67 percent of their own ceiling in both cases. **Read
plainly: a single ring of eight already fits every bound Caravan declares.** It presses against
exactly one ceiling, and any eight-domain declaration meets that same ceiling, whichever shape its
hops take.

Run on metal, `20261002.145044`:

```
$ ./caravan/bin/_scratch_ring8_probe
verify=whole
domain_count=8 channel_count=8 region_count=8 grant_count=16
ends=0
ring_order=found count=8

$ ./caravan/bin/_scratch_ring_probe
verify=whole
domain_count=8
flow_count=8
ring_order=null -- no single lap closes
```

Declaration A reads `.whole`: the static architecture holds together, every roster agrees, every
grant reads, and write stays apart from execute on every grant. Every domain spans exactly two
peers (`ends=0`), and `ring_order` finds the full eight-domain lap. This is a second, independent
point confirming the kin essays' own corrected rule on metal. An eight-domain ring closes in a
single lap. It carries the same `N-1` relay-touch cost the four-domain reading already proved,
extended here rather than re-derived -- this essay's own addition is the bound-table reading,
standing beside that rule.

Declaration B also reads `.whole`. The static check reads each grant and roster for its own
soundness, and says nothing about whether the declared channels thread every domain into one walk.
`flows_of` derives all eight directed flows cleanly, one per region, reading Declaration B exactly
as it would read any other eight-region document. `ring_order` is where the two shapes part
company. It answers `null`, the same "no single lap closes" reading `check_shape` already prints as
`RED: the grants close on no single lap` for a reversed edge or any other graph holding no
Hamiltonian cycle. The two disjoint four-rings share no edge between their groups. A walk threading
all eight domains has nowhere to cross from one group into the other, and the backtracking search
`ring_order` already runs comes back empty.

## Inference -- the gap is a working refusal, and a narrower one than it first looked

The kin essay named an absence: the function to compose two sub-rings into one verified whole
stays unwritten. This essay adds what that absence does when code meets it, a question the absence
alone leaves open. Three readings follow, each narrower than the last.

**The refusal already works correctly today.** A caller handing Declaration B's shape to
`check_shape` meets the same plain, named `RED` any other non-Hamiltonian declaration already
meets -- the message `serial_cycle.kyri`'s own sibling declarations earn when a reversed edge
breaks their lap. `verify()` and `ring_order` already compose to catch this shape. The first proves
the architecture sound; the second proves it closes in one lap. Together they leave a disjoint
declaration nowhere to hide. What stays unwritten is a *second* success path, one that would read a
disjoint declaration as two valid sub-systems rather than one invalid ring. That is a smaller,
better-named gap than "composition machinery." It is a capability sitting beside a safety check
that already holds.

**A single wider ring answers the touch-cost question more cheaply than composing two would.** The
kin essay reached for composition to buy back the concurrency a single eight-ring gives up --
`n * (n-3) / 2` non-adjacent pairs, two for a single eight-ring against three plus three for two
separate four-rings, doubling `serial_cycle_wide.kyri`'s own header arithmetic. That concurrency
case stands exactly as the kin essay left it. The touch-cost question this essay's kin line keeps
chasing -- what the origin ends up trusting, and at what price -- already has a cheaper answer
sitting in Declaration A. It earns every check a landed ring earns today, on the verification path
Caravan already carries. A working composition of two sub-rings would first need the unwritten
second success path above.

**The bound table and the shape question measure two separate things, worth keeping apart.**
`max_domains: u32 = 8` reads, at a glance, like the point past which a single ring grows hard. It
measures something else: how many domains one declaration may name, full stop. That count stands
apart from whether those domains close into one ring, two rings, or an open chain. A ninth domain
meets `add_dependent`'s own ceiling before `ring_order` is ever called. An eighth domain arranged
as two disjoint rings sails past every bound, then meets its own ceiling three function calls
later, inside `ring_order` alone. Two different ceilings meet two different moments of refusal.
Naming them apart is the same distinction the dedup-ratio essays earned, in a different module, two
days earlier -- a synthetic finding and a measured one, each true of its own question.

## Falsifier

This reading rests on three scratch declarations exercising three already-landed, already-public
functions (`read.load`, `relay.flows_of`, `cycle.ring_order`), with inputs built by hand to match
`serial_cycle_wide.kyri`'s own declared shape, doubled. A reader checking this transcript rebuilds
it from this essay's two tables alone -- the exact domain names, channel pairs, region names, and
grants stand printed above in full. **This essay carries one honest gap its kin pieces did not
carry.** The kin essays built their binaries from declarations already landed in
`caravan/systems/`, so a peer could re-run them straight from the tracked tree. This essay's
scratch files were removed once the transcript above was captured, since landing either would be
the Caravan module edit this lane keeps declining to make. A peer confirms this reading by
retyping the two tables verbatim -- a five-minute cost, rather than a dispute over the result.

A second, sharper falsifier: this essay reads the `ring_order` refusal on Declaration B as serving
Caravan's present safety goal well, catching a malformed single-lap claim, rather than blocking a
future goal of recognizing a valid two-sub-ring system. Whether Caravan should ever grow that
second success path stays an open design question, left exactly where this essay found it. It
turns on whether a future caller wants to declare two independent rings under one system name
rather than as two separate declarations. That want is itself unmeasured, and may resolve to a
non-question: the `caravan/systems/` roster declares every ring it holds today as its own separate
file. The gap this essay confirms may describe a case the tree has simply never asked for yet.

## What this leaves for Caravan's own lane

A print-path adaptation for `check_shape` past three domains, a four-domain chain declaration, and
now a third item worth weighing: whether a disjoint-ring recognizer earns its keep at all. A single
wider ring already does the one thing these essays have measured, touch cost, more cheaply, on the
verification path Caravan already carries. All three stay Caravan's own module edits. This lane's
contribution across the whole arc stays the same: read what already runs, and run small, disposable
probes against it, leaving every new shape for the lane that owns the module.
