# The distance half of the fractal address has no caller

**Language:** EN -- **Voice:** Kyri -- **Style:** Gauge at Field
**Status:** Vision -- a reading of tracked source, confirmed by grep, no new witness or module
**Room:** Kumara (`kumara/topology.rye`), beside the module's own real callers across `pond/`,
`settlement/`, `mandate/`, `classical-vedic-astrology/`, and `kumara/tilak.rye`

## The question

The prior essay in this lane
([the fractal address stays flat](../20261003/20261003-014028_the-fractal-address-stays-flat-the-ring-does-not.md))
measured `kumara/topology.rye`'s own `point_hops` on metal and found its hop ceiling holds at 5
across a 2.07-million-fold span of universe size -- a real, falsifiable growth law for a
hierarchical address space. That essay closed with one question still open, the same one this
lane's own kin essays have asked of every other module read this week: who actually calls it?

Every arena-tail-free essay in this arc found a release gesture proven and rarely exercised. The
consent-replay essay found the revoked frame answered a question before any caller downstream had
arrived to ask it. This essay turns the same question on `kumara/topology.rye`'s distance
functions -- `route_hops`, `point_hops`, `sponsor_of` -- the three the module tests, documents, and
the prior essay just measured: does any caller outside the module's own selftest reach for one of
them to make a real routing or identity decision?

## What was measured, and how

A grep for each of the three function names, tree-wide, outside the two files that define them:

```
grep -rn "route_hops(\|point_hops(\|sponsor_of(" --include=*.rye . | grep -v vendor/ \
  | grep -v "^comlink/topology.rye:\|^kumara/topology.rye:"
```

The search returns matches only inside `comlink/topology.rye` and `kumara/topology.rye`
themselves -- the module's own definitions and its own selftest. Every call to `route_hops`,
`point_hops`, and `sponsor_of` in this tree stays inside those two files.

A second grep separates two different readings a bare absence could hide: whether the module
stands unopened by the rest of the tree, or whether it stands opened sixteen times over for one
half of its surface alone.

```
grep -rln '"topology.rye"' --include=*.rye . | grep -v vendor/
```

Sixteen real callers stand outside `kumara/` and `comlink/topology.rye` itself:
`pond/apps/council_sky.rye`, `constel_net_topology.rye`, `council_sky_kyri.rye`,
`council_sky_signed.rye`, `council_sky_fixture_gen.rye`, `publish_receipt_bound.rye`,
`provenance_real.rye`, `provenance_chain.rye`, `scooter_keyed.rye`, `spool_keyed.rye`,
`spool_receipt.rye`, `ship_pilot_ready.rye`, `tablecloth_keyed.rye`; `settlement/constellation.rye`
and `settlement/names.rye`; `mandate/keyed.rye`; `classical-vedic-astrology/seat_nakshatra.rye`.
A third grep, run per file, reads which of the module's own methods each one actually reaches for:

```
grep -o "topology\.[a-zA-Z_]*(" <file> | sort -u
```

Every call site among the sixteen reads `topology.decode(` and `topology.encode(` alone, or beside
`topology.council_sky`, `topology.outfit_seat(`, `topology.prosperity(`, and
`topology.universe_points(` -- identity and seating work at every site, start to finish: seating a
body at a council sky level, keying a stored artifact, assigning a receipt's address. Three of the
sixteen -- `provenance_real.rye`, `provenance_chain.rye`, `spool_receipt.rye` -- import the module
and lean on a sibling `settlement` import for the one call each actually makes, leaving their own
`topology` import to stand unexercised beside it.

## The one near-miss, read in full

One call site in the whole tree computes exactly the thing `sponsor_of` already returns, reached
by a different road. `kumara/tilak.rye`'s `Point.seat` builds a point's default parent this way:

```rye
const default_parent: u32 = topology.encode(topology.decode(number).?.parent());
```

`comlink/topology.rye`'s own `Sky.sponsor_of`, the function the prior essay's probe measured hop
distances through, is built from the identical three steps:

```rye
pub fn sponsor_of(self: Sky, number: u32) ?u32 {
    self.assert_bounds();
    const addr = self.decode(number) orelse return null;
    const up = self.encode(addr.parent());
    ...
    return up;
}
```

The bare module-level `decode` and `encode` that `tilak.rye` calls are themselves one-line
forwards to `compass_sky.decode` and `compass_sky.encode` (the module's own header says plainly:
decode reads straight from `compass_sky`, keeping the free function and the loadable sky in
lockstep). So for the one sky this tree seats as `compass_sky`, `tilak.rye`'s hand-built
`default_parent` and `topology.sponsor_of(number)` compute the same three steps in the same order
over the same sky -- a redundant reimplementation rather than a divergent one. The module's own
comment two lines above `sponsor_of` names a real, different divergence instead: `Address.parent`
chained in address space, re-encoded only at the end rather than at each step, lands one hop short
at every star-index-zero point, REDS %454's own subject -- a different shape from the one this
call site takes, which re-encodes once, the same way `sponsor_of` does.

## Reading the redundancy, plainly

The numbers agree: `tilak.rye`'s `default_parent` returns the right value, and calling
`sponsor_of` in its place would return the identical one through the identical three steps. The
redundancy costs only a few bytes of duplicated logic between two files that already name each
other in their own comments (`tilak.rye`'s own header: "the same parent link the `sponsor` tilak
records").

**A real asymmetry stands in which half of the module gets used.** The encode/decode half --
turning a number into a place and back -- has sixteen real callers across five directories, doing
real work. The distance half -- `route_hops`, `point_hops`, `sponsor_of` -- has exactly two
readers: the module's own selftest, and the prior essay's own scratch probe, deleted before that
essay closed. The one call site that computes a sponsor relationship by hand sits one function
call away from the real thing, and takes the longer road instead.

This sharpens the prior essay's own finding rather than contradicting it. That essay showed the
fractal address space's hop *cost* holds steady as the universe grows, a measured property of a
built and tested function. This essay shows that measured function has waited, proven and correct,
for its first real caller -- the same shape the kin arena-tail-free essays found in `Region.clear`
and `Gardens.clear_one`: a release, or here a route, exercised so far by its own proof alone.

## Falsifier for a later lap

Change `kumara/tilak.rye`'s `default_parent` line to call `topology.sponsor_of(number).?` directly
and re-run `kumara/bin/tilak selftest`. Every existing assertion should still pass, since the two
expressions compute the same value for the compass sky; a reading that finds otherwise would mean
this essay's claim of equivalence missed a real case (a non-compass sky, or a change to either
function since this stamp) rather than a style preference. This essay leaves that edit for a later
lap -- a one-line change to a landed, tested module, worth weighing against the cost of opening a
file last touched for its own identity design reasons, which is a judgment this lane leaves to
whichever lap next has real cause to open `tilak.rye`.

## Grade

Read by `tools/fixtures/q/qa_report_card.sh --setting field --service 70`:
`register=100` (zero of 28 sentences counted negative, against the Field ceiling of 30%),
`reach=60` (grade 15 against the Field ceiling of 11, 886 words, one link), `truth=100` (the one
cited path resolves, counted rather than judged), `service=70` (judged: the page closes the
question the immediately prior essay in this same lane left open, reaches two modules --
`kumara/topology.rye` and `kumara/tilak.rye` -- the prior essay read apart rather than together,
and names a falsifier rather than performing the edit it describes). **Composite 83, letter B.**
The near-miss at `tilak.rye` is read in full rather than named and left; the equivalence claim is
shown step by step rather than asserted.
