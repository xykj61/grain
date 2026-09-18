# Comlink already carries a torus index -- `topology.rye`'s mixed-radix address, read

**Stamp:** `20260918.022104`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- a checked reading of one module, opening a question the prior synthesis left named
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260917-233424_the-torus-thread-closes-five-checks-one-buildable-seam.md`](../20260917/20260917-233424_the-torus-thread-closes-five-checks-one-buildable-seam.md)
(names Comlink as one of four modules this thread had yet to open) -
[`20260917-222220_a-torus-index-for-tally-gardens-linear-underneath.md`](../20260917/20260917-222220_a-torus-index-for-tally-gardens-linear-underneath.md)
(the sibling that names `tally/torus_index.rye` buildable) -
[`20260910-060204_the-bounded-torus-moonshots.md`](../20260910/20260910-060204_the-bounded-torus-moonshots.md)
(the master ranking, row 7 on Aurora's core mesh)

## The one sentence this piece is for

Opening `comlink/topology.rye` turns up a structure the five prior torus-thread reads left
uncounted: a working, witnessed **mixed-radix multi-axis coordinate space**. Three nested moduli
-- galaxy, star, planet -- compose one linear point number into a fractal address. A round-trip and
a bijection are both proven on metal already. This is close kin to the shape `tally/torus_index.rye`
proposes to build fresh, standing in the tree already.

## What was read, and what it found

| File | Lines | What it is | Periodic structure |
|---|---|---|---|
| `comlink/topology.rye` | 702 | the d12-d60 fractal address space and routing by it | mixed-radix decode and encode, three nested moduli |
| `comlink/turn_route.rye` | 130 | peer key rotation routing (`key_counter`, `reset_counter`) | both counters climb only, by the tilak's own law |
| `comlink/discovery/gossip.rye`, `discovery/region.rye` | -- | peer discovery and region bookkeeping | absent from the two greps this piece ran (see *What remains unchecked*) |
| `comlink/device_wire.rye`, `virtio_net.rye` | -- | the virtio-net device driver -- avail and used descriptor rings | present, and inherited rather than composable: the VIRTIO spec's own `vring`, `slot = used_tail % queue_depth`, `queue_depth = 4` |

The read used the same method the prior five did: a whole-file grep for `%`, `wrap`, `ring`,
`cycle`, and every `max_`/`_count`/`_depth` constant, across every tracked `.rye` file directly
under `comlink/` and `comlink/discovery/`. The command is one line and reproducible:

```
grep -rnE '%[a-zA-Z_ ]|\bwrap\b|\bring\b|\bcycle\b|max_[a-z_]+ *=' comlink --include="*.rye"
```

## Two rings turned up, and one of them is old news

**`virtio_net.rye`'s vring is a genuine ring, and it is old news rather than a find.**
`used_tail % queue_depth` (`comlink/virtio_net.rye:434,502`) is a real wraparound modulo, exactly
the shape the torus thread already names a "genuine ring" in `queue.rye` and `cycle.rye`. It comes
from the VIRTIO 1.x specification's own descriptor layout -- a driver speaking to real hardware
copies the wire shape the standard fixes, rather than choosing one. So it answers the thread's
structural question (does a ring sit here) plainly yes, and its actual question (is there an
uncomposed seam worth a torus) plainly no: the ring holds one axis, `queue_depth = 4`, spoken for in
full by the protocol it serves.

**`topology.rye`'s decomposition earns its own name, because it sits between a wraparound ring and
an empty file -- a third shape the prior five reads left uncategorized.** Read closely:

```rye
pub fn decode(self: Sky, number: u32) ?Address {
    ...
    return .{
        .galaxy = @intCast(number % self.galaxies),
        .star = @intCast((number % self.star_count()) / self.galaxies),
        .planet = @intCast(number / self.star_count()),
        .tier = tier,
    };
}
```

Three moduli -- `galaxies`, `star_count()`, and the implicit `planet_count()` ceiling -- nest to turn
one `u32` into a three-coordinate address. `encode` proves the inverse holds
(`comlink/topology.rye:256-263`). `outfit_seat` carries the proof one step further: inside one
galaxy's `prosperity()` circle (stars times planets), every point wears exactly one seat, `0`
through `prosperity() - 1` -- a bijection onto a bounded circular range, held up by the witness's
own `sponsor_never_rises` and `depth_reads_the_outfit` phases. `tools/co/comlink_topology_witness.rish`
runs GREEN on metal, re-run this lap (`faults=0`, `verdict=proven`) -- a proof this piece inherits
rather than a claim it makes fresh.

## What stays the same, and what moves

The prior synthesis's falsifier asked one narrow question: does a wraparound-over-time seam sit
uncomposed somewhere unopened. `topology.rye` keeps that verdict exactly where the five prior reads
left it: `decode`, `encode`, and `outfit_seat` compute a pure function of one number, called once,
held still through time rather than advanced or reused. So this finding leaves the five checked
verdicts standing, and it leaves the falsifier untripped -- `topology.rye`'s shape is a mixed-radix
decomposition, a different animal from the wraparound rings the falsifier names.

**What this DOES move is the buildable-item's price tag.** The sibling piece's
`tally/torus_index.rye` proposal already reads "a pure bijection over an already-linear store...
provable today." `topology.rye` is that exact shape, three axes deep rather than two, working
already, proven already, one module over. Anyone sizing the Tally proposal now has a worked example
to copy from rather than a blank page to fill: the nested-modulo technique, the bounded-`u8`
coordinate discipline (`tier_ceiling: u32 = 256`, `assert_bounds` on every entry), and the
round-trip proof shape all stand in this tree already. Its header names Urbit's own address space
as ancestor and Grain's own d12-d60 fractal as the redesign built on top of it.

## Falsifier for this reading

**A caller invoking `decode` or `encode` inside a loop that advances the input across calls, rather
than once per lookup, would change the picture.** That would mean the address space serves as a
traversal ring after all, and this piece's "pure function, held still" reading would need
withdrawing. This reading covers the module's own definitions and its witness's own assertions;
it stops short of every call site.

## What remains unchecked, plainly

This reading opened two files under `comlink/discovery/` by grep alone, and the narrow pattern
searched turned up empty there. It stopped short of reading `gossip.rye` or `region.rye` whole, the
way the prior synthesis's Caravan and Tally reads went whole-file. `comlink/` holds 98 tracked
`.rye` files under this one directory, counting its `discovery/` and `guest_*` wire-protocol
siblings; this piece opened 4 of them in full or by targeted grep (`topology.rye`, `turn_route.rye`,
`virtio_net.rye`, `device_wire.rye`) and two more (`gossip.rye`, `region.rye`) by grep alone.
**The honest confidence that Comlink's remaining 94 files hide another composable seam stays low**
-- sharper than the prior synthesis's "medium, at best" for the whole remaining four-module set,
since this reading covers a thinner slice of one of those four modules than the prior reads covered
of Caravan or Tally.

## What this means for the master page's ranking

Row 7 (Aurora on a core torus) holds exactly where it stood -- this reading opened Comlink rather
than Aurora, and the prior synthesis already checked Aurora's boot and handshake path with a plain
negative verdict. The master ranking names Comlink by number in no row today; this piece opens it
first under the thread's method, and adds one line worth carrying forward: the nested-modulo,
bounded-coordinate, round-trip-proven technique `tally/torus_index.rye` would otherwise invent from
scratch already stands, landed and witnessed, in `comlink/topology.rye` -- available to copy rather
than design anew.

## What Bakery could pick up, and what stays here

**Buildable now, cheaper than the prior sizing:** `tally/torus_index.rye`, still the item the
sibling piece names, now with a worked precedent to build from. The nested-modulo decompose and
recompose pattern, the `u8`-bounded coordinate struct, the `assert_bounds` habit, and the witness
shape (`sponsor_never_rises`-style planted-and-caught legs) all transfer directly.

**Stays here, named as vision:** whether Comlink's remaining 94 files, `discovery/gossip.rye` and
`discovery/region.rye` read whole, or Tablecloth's real store, Amphora, and Brix (still unopened by
this thread) carry a wraparound ring the way `virtio_net.rye`'s vring does -- and whether such a
ring, once found, composes freely the way `queue.rye`'s and `cycle.rye`'s do, or arrives fixed and
inherited the way `virtio_net.rye`'s does.

## Related

No tracked issue. This note adds zero dependency to any ship's Now line and leaves
`construction/ITINERARY.md` exactly as it stands.

May the next reader who opens `discovery/gossip.rye` or Tablecloth's real store add another row to
this table, and may the day `torus_index.rye` is actually built cite the file that already proved
its shape works.
