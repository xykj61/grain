# The declarable ring is twice the livable one

**Status:** Vision -- a reading proven on scratch metal, outside the tracked tree
([`../../../context/TWO_ROOMS.md`](../../../context/TWO_ROOMS.md))
**Setting:** Gauge Field - **Voice:** Kyri
**Stamp:** `20261003.031833`
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Caravan.
**Kin:** [`20261002-103827_a-lap-costs-the-same-whatever-shape-you-fold-it-into.md`](../20261002/20261002-103827_a-lap-costs-the-same-whatever-shape-you-fold-it-into.md) -
[`20261002-150621_the-star-is-not-a-cheaper-ring-flows-of-refuses-it-outright.md`](../20261002/20261002-150621_the-star-is-not-a-cheaper-ring-flows-of-refuses-it-outright.md) -
[`../../../caravan/regions.rye`](../../../caravan/regions.rye) -
[`../../../caravan/capabilities.rye`](../../../caravan/capabilities.rye) -
[`../../../caravan/roster.rye`](../../../caravan/roster.rye) -
[`../../../caravan/cycle.rye`](../../../caravan/cycle.rye)

## What this essay answers

The 2D-layout kin essay named an open half of the ring/chain arc: composing two independently
verified 4-domain sub-rings into one 8-domain whole is unbuilt, "named for whichever lane wants
it." Read as a build question, that is Caravan's own edit. Read as a research question first, it
asks something sharper: whether the single declaration `caravan/roster.rye` already seats today
can reach the 8-domain whole this essay names, or whether the composition exists to work around a
ceiling this tree has tested so far only at the one domain past it. This essay reads the three
modules that set the bound -- `regions.rye`, `capabilities.rye`, `roster.rye` -- then builds a
scratch declaration at the data model's own declared maximum to find out on metal, rather than from
the comment that states it.

## Observation -- two different numbers answering two different questions

`caravan/regions.rye:35` declares `max_domains: u32 = 8` -- the ceiling on how many domains one
declaration may *name*. `caravan/capabilities.rye:20` declares `max_dependents: u32 = 4` -- the
ceiling on how many dependents one supervisor's capability table may *seat*. `caravan/roster.rye`'s
own `from_system` (line 158) gates on the second number alone: `if (sys.map.domain_count >
capabilities.max_dependents) return error.TooManyDomains;`. A comptime assertion two lines above it
(`roster.rye:59`) already states the relationship in words -- `capabilities.max_dependents <=
regions.max_domains` -- and names it "the shortfall below." The measured shortfall is exactly half:
4 against 8.

A census of every declaration this tree actually carries in `caravan/systems/` turns the stated gap
into a measured one. Eleven live declarations top out at domain_count=4 (four files:
`serial_cycle_wide*`, `serial_three_clients*`). Exactly one declaration, `wide_roster.kyri`, carries
domain_count=5, built for exactly one job -- `tools/ca/caravan_roster_witness.rish:34` asserts its
own output names `TooManyDomains` by name. Every tracked declaration this tree holds stops at 4 or
5; the widest one built runs one domain past the live ceiling, and the declarable ceiling of 8 sits
three domains past even that.

A scratch declaration, `caravan/systems/_scratch_wide8.kyri`, was built to close that gap: eight
domains (`alder` through `hazel`), eight channels, eight regions, sixteen grants -- the identical
one-writer-one-reader ring shape `serial_cycle_wide.kyri` already proves at four domains, doubled.
It fits every structural bound regions.rye states (8 domains, 8 of 12 regions, 16 of 24 grants) and
was run two ways.

**Through the live seating path**, `caravan/roster.rye` built fresh and pointed at the file:

```
$ ./caravan/bin/_scratch_roster8 caravan/systems/_scratch_wide8.kyri
refused: caravan/systems/_scratch_wide8.kyri -- TooManyDomains
```

Against the same binary, `serial_cycle_wide.kyri` (domain_count=4) seats cleanly (`the roster
enforces exactly what the document permits`), while `wide_roster.kyri` (domain_count=5) and the
scratch file (domain_count=8) both answer `TooManyDomains` -- the same error, at the same
threshold, regardless of how far past it a declaration reaches.

**Through the pure graph derivation**, a second scratch driver called `relay.flows_of` and
`cycle.ring_order` directly -- the two functions `cycle.rye`'s own `check_shape` runs before any
supervisor is involved -- bypassing `roster.rye` entirely:

```
$ ./caravan/bin/_scratch_wide8_probe caravan/systems/_scratch_wide8.kyri
verify=whole
domain_count=8 region_count=8 grant_count=16
flows_of=found count=8
ring_order=found count=8
lap: alder birch cedar dogwood elm fir gum hazel home
```

The ring math holds at the full declared width: eight directed flows derived cleanly, one single
lap found, visiting every domain once and closing home -- byte for byte the same shape `check_shape`
already proves at N=3 and N=4. A planted mutation (flipping one edge's grant direction, `dogwood
<-> elm`) breaks it: `ring_order=null`, confirming the comparison is load-bearing rather than
trivially true for any eight-line input.

## Inference

**The gap this essay measures is a width this tree has held open and left untested, rather than a
missing feature.** `regions.rye`'s own ceiling, read today, stands as a number declared and never
exercised. The ring's graph arithmetic -- the part `ring_order`'s bounded backtracking search
performs -- depends on `capabilities.max_dependents` for nothing and holds cleanly at the full
declared width. The ceiling that governs where a live Caravan ring actually stops growing lives in
a single comptime-asserted constant in a different module, one that guards process supervision
rather than graph correctness.

**The "two sub-rings" proposal the kin essay named earns a sharper job than efficiency: it becomes
the one path past four.** Read beside this finding, composing two 4-domain sub-rings stops being a
cheaper alternative to an 8-domain ring this tree could otherwise run directly, and becomes the
*sole* structural route to any ring wider than four domains, since `roster.from_system` seats a
domain_count of 4 or fewer alone. The number this tree advertises as its ring's ceiling
(`max_domains = 8`, the number `regions.rye` states and this tree's own declarations hold well
under) and the number that actually governs what runs (`max_dependents = 4`) sit a clean factor of
two apart, a gap the tree's own file census leaves standing rather than built into.

**This gives `regions.max_domains` its honest job description.** It names the data model's ceiling
-- the most domains a declaration may *name* -- where Caravan's live ring ceiling is a separate
number, `capabilities.max_dependents`, stated in its own module and absent from `regions.rye`
entirely. A reader who learns the ring's bound from `regions.rye` alone learns a number worth
double what a live ring can seat.

## Falsifier

The claim rests on two transcripts above, both run against this lap's own scratch files and two
tracked controls (`serial_cycle_wide.kyri` at N=4, `wide_roster.kyri` at N=5), plus one planted
mutation shown to bite. The scratch declaration and both drivers are printed in full above or reconstructable from the
commands given, and each tracked module they called -- `regions.rye`, `capabilities.rye`,
`roster.rye`, `relay.rye`, `cycle.rye` -- stood exactly as landed throughout, read rather than
edited. A peer
who holds that `capabilities.max_dependents` should simply rise to 8 -- closing the gap this essay
names rather than routing around it with composed sub-rings -- names a real design choice this essay
leaves open: it reads the two numbers as they stand today and reports the distance between them,
rather than arguing which one should move.

## What this leaves for Caravan's own lane

Two questions, named rather than answered. Should `capabilities.max_dependents` simply rise to meet
`regions.max_domains`, closing the gap directly, rather than composing sub-rings to route around
it? And if the gap is intentional -- a declaration space built wider than any one supervisor need
ever seat, so a future multi-supervisor composition has room to grow into -- does `regions.rye`'s
own header say so, or does it read, as it reads today, like a ring's whole ceiling? Both are
Caravan's own module edits. This lane's contribution stays the same across the arc: read what
already runs, build small and disposable, and report the transcript rather than the expectation.

Graded composite 81, letter B, per `tools/fixtures/q/qa_report_card.sh --setting field --service
80` (register 83, reach 60, truth 100, service 80 judged).
