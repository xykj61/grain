# Only one other ceiling stands between four and eight

**Status:** Vision -- a reading of tracked source, confirmed against an already-run measurement
([`../../../context/TWO_ROOMS.md`](../../../context/TWO_ROOMS.md))
**Setting:** Gauge Field - **Voice:** Kyri
**Stamp:** `20261003.034214`
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Caravan.
**Kin:** [`20261003-033159_raising-the-ceiling-crashes-its-own-control.md`](20261003-033159_raising-the-ceiling-crashes-its-own-control.md) -
[`20261002-145044_two-sub-rings-refuse-the-single-lap-a-wider-ring-does-not.md`](../20261002/20261002-145044_two-sub-rings-refuse-the-single-lap-a-wider-ring-does-not.md) -
[`../../../caravan/capabilities.rye`](../../../caravan/capabilities.rye) -
[`../../../caravan/regions.rye`](../../../caravan/regions.rye) -
[`../../../caravan/channels.rye`](../../../caravan/channels.rye) -
[`../../../caravan/roster.rye`](../../../caravan/roster.rye)

## What this essay answers

The prior essay priced raising `capabilities.max_dependents` from 4 toward `regions.max_domains`'s
8. The edit compiles. A scratch 8-domain ring seats. One tracked fixture
(`caravan/systems/wide_roster.kyri`) panics, because its own `domain_count=5` was built to sit one
domain past the live ceiling. That relationship holds only while the ceiling stays under 5. The
prior essay named the fixture repair and left one question standing: is `max_dependents` the
**only** other ceiling in the way? Or would raising it past 5 run straight into a second, unnoticed
cap on channels, regions, or grants before ever reaching 8? This essay answers from the constants
already in source, standing on the existing composition-gap measurement rather than a fresh build.

## Observation -- four caps, one already exercised at the target width

Caravan's protection-domain graph is bounded by four named constants, read directly from source:

| Constant | File | Value |
|---|---|---|
| `regions.max_domains` / `channels.max_domains` | `caravan/regions.rye:35`, `caravan/channels.rye:29` | 8 |
| `capabilities.max_dependents` | `caravan/capabilities.rye:20` | 4 |
| `channels.max_channels` | `caravan/channels.rye:35` | 16 |
| `regions.max_regions` | `caravan/regions.rye:40` | 12 |
| `regions.max_grants` | `caravan/regions.rye:46` | 24 |

`caravan/roster.rye:59` carries the one comptime assert that ties the dependent count to the domain
count directly. Its own invariant comment names the relationship on purpose: `assert
(capabilities.max_dependents <= regions.max_domains); // invariant: the table seats fewer domains
than a document may declare, which is why the shortfall below is named rather than assumed away`.
`max_dependents` stands alone that way. A tree-wide grep for it beside `max_channels`,
`max_regions`, and `max_grants`, across `roster.rye`, `regions.rye`, `channels.rye`, and
`capabilities.rye`, finds each of the other three guarding only its own structural count.

The composition-gap essay already built and ran the width this question asks about. Its connected
eight-domain scratch ring is the same shape a raised `max_dependents=8` would make livable. Its own
measurement read all four caps at once: "8 of 8 `max_domains`, 8 of 16 `max_channels`, 8 of 12
`max_regions`, 16 of 24 `max_grants`." Three of those four readings sit at half their ceiling or
better. Only `max_domains` itself reads full, because the scratch ring was built to use exactly
eight domains.

## Inference

**The headroom was already measured; this essay only asks the question of it.** An eight-domain
ring consumes 8 channels against a ceiling of 16, 8 regions against 12, and 16 grants against 24.
That reading stands regardless of what `max_dependents` happens to equal. `max_dependents` governs
how many of those eight domains a single supervisor's table may seat, which is a separate question
from how many channels, regions, or grants the graph itself declares. Raising `max_dependents` from
4 toward 8 leaves channel, region, and grant count exactly where a ring of a given domain width
already puts them; it changes only whether `roster.from_system` accepts a wider ring at all. The two
readings compose cleanly: the prior essay found the one real obstacle (a fixture's positive
invariant, repairable in the same commit as the constant), and this reading confirms the three other
caps stay slack at the exact width the raised constant would unlock.

**The asymmetry in the source matches the asymmetry in the measurement.** `max_dependents` is the
one constant wired by assert into the domain-count relationship. The other three are wired only
into the graph's own structural counts: channels per ring, regions per domain, grants per region.
Each of those counts grows with domain count at a rate the eight-domain ring already demonstrated
stays well under its own ceiling. A grep that finds no assert connecting `max_dependents` to the
other three speaks to this one measured width honestly. It leaves a larger width an open question,
and it settles the width this lane has already measured.

## Falsifier

This essay stands entirely on a reread: four constant declarations and one already-published
measurement. A peer who doubts the reading confirms the four values directly:

```
grep -n "pub const max_domains\|pub const max_channels\|pub const max_regions\|pub const max_grants\|pub const max_dependents" \
  caravan/regions.rye caravan/channels.rye caravan/capabilities.rye
```

and confirms the composition-gap essay's own eight-domain counts by rebuilding its scratch
declaration (`caravan/systems/_scratch_wide8.kyri` in that essay, deleted before this one; the
shape is a single connected eight-domain ring) and running it against `caravan/roster.rye`'s
`from_system`. A sharper falsifier stays open for a later lap: whether a **nine-domain or wider**
ring, past `max_domains` itself, would find a channel, region, or grant ceiling binding before
`max_domains` does. That width stays untested here. Every caller and fixture in this tree stops at
eight domains or fewer.

## What this leaves for Caravan's own lane

The prior essay's repair remains the whole cost of raising the constant, as far as this tree's four
named caps can show today: rebuild `wide_roster.kyri` one past whatever `max_dependents` becomes,
and keep `roster.zig:393`'s positive invariant pointed at it. The road from 4 to 8 carries exactly
the one obstacle already named. The composition-gap essay measured the destination before this
essay knew to ask whether the road there was clear.

Graded composite 95, letter A, per `tools/fixtures/q/qa_report_card.sh --setting field --service
80` (register 98, reach 100, truth 100, service 80 judged).
