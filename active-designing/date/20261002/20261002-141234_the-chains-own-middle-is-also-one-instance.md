# The chain's own middle is also one instance

**Status:** checkable -- a reading of tracked source, confirmed by its own comptime bound
**Room:** active-designing (lasting reasoning about a shape, rather than a round's own plan)
**Style:** Gauge at Field

## What the prior essay claimed, and where it stopped

[The crossover is arithmetic, not yet metal](../20261002/20261002-102258_the-crossover-is-arithmetic-not-yet-metal.md)
corrected the ring side of the crossover claim. `caravan/cycle.rye`'s `check_shape` prints exactly
three fixed domain names by position. So the ring's touch count at N domains is read off one
instance -- N=3, cost 2 -- and generalized to a rule, N-1, that stays a guess past the one ring
this host has built. The essay named the ring's own fixed shape as the reason the crossover stays
arithmetic rather than metal. Confirming it past N=3 wants a real edit: "a job for whichever lane
next extends Caravan's own ring."

This essay asks the same question of the chain. The earlier essay in this pair,
[A ring buys verified state; a chain buys a claim](../20261002/20261002-101339_a-ring-buys-verified-state-a-chain-buys-a-claim.md),
reads the chain's middle cost as "stays fixed at 2." It treats that number as the stable half of
the comparison against the ring's own growing cost. That line is read from `caravan/relay.rye`'s
single declaration. This essay checks whether it holds the way the ring's own line did.

## What the chain's own declaration says

`caravan/systems/serial_relay.kyri` declares exactly three domains -- `client`, `relay_virt`,
`backend` -- joined by two channels and five regions. `caravan/relay.rye`'s own comptime
invariants read:

```
// invariant: a chain is at least three domains long
assert(max_hops >= 3);
// invariant: a middle domain names both the peer it hears and the one it rings
assert(max_peers >= 2);
```

`max_hops` is bounded at 6. That is a budget the module may spend, not a chain it has built. Every
exercised run in `relay.rye` walks the one three-domain chain `serial_relay.kyri` names: the
selftest, the ask/forward/answer/collect sequence, the printed transcript closing on "a claim,
never an attestation." `read.rye` derives the shape from whatever grants a declaration holds. A
wider chain is a Kyri file away, not a language change -- the same gap the ring essay found in
`cycle.rye`. Here the module has simply never been handed a second shape to read.

## The two claims are the same shape of claim

The prior essay's correction rested on building N=4 and reading its own transcript, rather than
trusting a rule read off N=3 alone. The ring's touch count moved from the stated N-2 to the
measured N-1 once the words on the page were checked against the comment above them. The chain's
"stays fixed at 2" is still waiting for that same transcript, at any N past 3, because the tree
holds only the one declaration. A middle of one relay domain costs two touches: heard once,
answered once. A middle of two relay domains -- `client -> relay_a -> relay_b -> backend` -- might
still cost two, or might cost three, or might cost some function of its own length. That is
exactly the question the ring essay asked and answered by building. `relay.rye`'s structure leaves
either answer open: a flat cost and a growing cost are equally consistent with the one instance
standing today. The claim currently rests on an analogy to the ring's own first-draft rule -- N-2,
later corrected by one -- rather than on a read transcript.

## What this changes about the standing comparison

The synthesis essay's own number -- "the ring costs 2 non-origin touches for a verified read and
the chain costs 3 for an unverified claim" -- is a true reading of the one declared instance of
each shape: N=3 for the ring, N=3 for the chain. Nothing here overturns that reading.

What changes is the claim one step past it: that the crossover is a question about the ring's
growth alone, with the chain held at a known constant. Both halves of the crossover are read from
a single instance. Both single instances stand equally ungeneralized, for one shared structural
reason. A declaration names a fixed topology, and the exercising module reads that one topology
rather than taking the topology as a parameter.

## The falsifier, named rather than run

Build a four-domain chain declaration: `client -> relay_a -> relay_b -> backend`, with
`relay.rye`'s own ask/answer grant pattern repeated once. Run it on metal. A touch count of 3 at
the far end -- one per middle domain, the flat reading's prediction -- leaves the chain's own claim
standing. The ring stays the only side that needed correcting. A higher count tells a different
story: each middle domain re-wrapping the claim in its own name before forwarding it, the way an
answer's authorship travels as "a claim, never an attestation" that could itself be restated at
each hop. That would grow the chain's middle cost too, and send the crossover math from the prior
essay back for rework on both sides rather than one. This essay stops short of the build.
`serial_relay.kyri` is a landed, GREEN-witnessed declaration, and widening it to a second chain
shape is the same kind of module edit the ring essay already handed to Caravan's owning lane.

## Grade

Confidence: the fixed-shape reading of `relay.rye` is read directly from its own comptime asserts
and its one declaration file, the same standard of evidence the ring correction used. The gap this
essay names is structural rather than measured, which is exactly its claim -- it says a number is
unmeasured, and stops there rather than guessing at what measuring it would show.
