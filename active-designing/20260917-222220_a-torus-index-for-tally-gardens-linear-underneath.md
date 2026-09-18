# A torus index for Tally gardens -- linear underneath, radial at the door

**Stamp:** `20260917.222220`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- vision names one honest claim (a two-axis index over an already-linear store) and one honest refusal (no electricity saving lives in this layer); nothing here is checkable yet
**Room:** vision
**Kin:** [`20260826-021136_caravan-rearchitected-the-optimization-spine.md`](20260826-021136_caravan-rearchitected-the-optimization-spine.md) (Move one, "wrap where the quantity is genuinely periodic") - [`../caravan/address_space.rye`](../caravan/address_space.rye) - [`../tally/gardens.rye`](../tally/gardens.rye) - [`../counsel/date/20260912/20260912-144152_the-runner-the-torus-and-the-reverse-reading.md`](../counsel/date/20260912/20260912-144152_the-runner-the-torus-and-the-reverse-reading.md) (names the restraint this piece tries to honor)

## The one sentence this piece is for

Caravan's address space is linear today, measured on metal, and Move one of the rearchitecture
essay already names the right rule: **wrap where the quantity is genuinely periodic, assert where
it is linear.** This piece asks a narrower question than "should Caravan's scheduler be toroidal" --
it asks whether one bounded, already-periodic structure (Tally's named gardens) can be *addressed*
by two small numbers instead of one, with the linear layout underneath completely unchanged. It
answers yes, names exactly what would need to be built to prove it, and keeps the electricity and
latency claim outside its scope -- that claim belongs to the hardware this tree runs on today, and
is treated separately below.

## What is measured, not guessed

Building and running `caravan/address_space.rye` on this tree, `20260917.222220`:

```
address-space: the join holds -- 16777216 bytes declarable, rounded to 16777216,
  plans to 8 pages at best and 519 at worst, inside 2556.
address-space: a region's base derives from its index -- 12 windows of 16777216 bytes,
  exactly abutting, ending at 218103808 inside 549755813888.
```

Twelve regions, each 16,777,216 bytes (16 MiB), placed by one formula: `base(i) = i * stride`,
`stride = 16,777,216`. That is Cartesian in the plainest sense -- one axis, one origin, one stride.
It is also exactly right for what it does: seL4 Microkit's own `SysMap.vaddr` (read from
`tool/microkit/src/sdf/memory_region.rs` on `20260825.080306`, per `address_space.rye`'s own
header) wants a byte offset, and a byte offset is a one-dimensional fact about a one-dimensional
resource. **This piece leaves that formula exactly as it stands.** The physical and virtual
address spaces DRAM presents to a RISC-V core stay linear, and any addressing scheme layered above
them leaves the bus underneath exactly as linear as it already is. This is stated first and
plainly because the moonshot below could be misread as a hardware claim, where it is actually a
software naming layer alone.

## Where periodicity is already real, and where a name would help

[`tally/gardens.rye`](../tally/gardens.rye) holds a **fixed set of named Regions**, each a bump-allocated ring in the sense
that matters here: a region fills, is cleared, and fills again -- "the season ends and a new one may
begin over the same backing store," in the module's own words. Three gardens exist today: `blob`,
`diff`, `frame`. Each is reached **by name**, a linear scan over a small fixed array (`gardens.rye`'s
own `add`/`get` walk the array and compare strings).

That serves well at three gardens and keeps serving for a while -- a linear scan over a
`u32`-bounded array is exactly the kind of thing TAME asks for: bounded, checked at the edge, its
cost visible at the call site. The question this piece asks is what happens when a caller wants to
address a garden by **two small, structurally meaningful numbers** instead of a string it must
already hold: which *tier* of capability a garden belongs to (a dependent's own scratch space,
versus a shared inter-dependent channel, versus a boot-time region that outlives every dependent),
and which *slot* within that tier it occupies. That is a two-axis address, and a two-axis address
over a bounded, wrapping set is a torus in exactly the sense the rearchitecture essay already uses
the word: a claim about which arithmetic is honest, rather than a claim about physical shape.

## The moonshot, stated narrowly

**Propose `tally/torus_index.rye`: a pure function from `(tier: u32, slot: u32)` to the same linear
`u32` offset `gardens.rye` already uses, plus its exact inverse.**

```
fn torus_offset(tier: u32, slot: u32) u32 {
    // invariant: tier is one of a small, named, comptime-bounded set
    assert(tier < max_tiers);
    // invariant: slot is bounded by this tier's own declared width
    assert(slot < tier_width[tier]);
    return tier_base[tier] + slot;
}

fn torus_locate(offset: u32) struct { tier: u32, slot: u32 } {
    // invariant: offset names a region this torus actually declares
    assert(offset < total_width);
    // ... derived, never stored, exactly the way address_space.rye
    // already derives a region's base from its index rather than
    // tabling it
}
```

The address lives once, as the linear offset alone. `tier_base` and `tier_width` are small constant
arrays, exactly the shape `address_space.rye`'s own comment already praises: "a region's base
derives from its index... derived, so no table can drift." The two-axis address is a **view**, in
the same sense the derived-spine rule uses that word for a REDS row's number: the linear offset is
the identity, `(tier, slot)` is a coordinate a caller may prefer to reason in, and the linear
offset stays the one source of truth throughout.

## What this actually buys, named honestly

- **A caller expresses intent instead of an offset.** "The channel garden, third dependent" is
  `torus_offset(TIER_CHANNEL, 2)` rather than a raw `u32` a reviewer must trust was computed
  correctly somewhere else. This is a readability and review-cost claim, and it stops there.
- **A wrap becomes a bounds check the type system can see.** `slot < tier_width[tier]` is the same
  discipline [`caravan/queue.rye`](../caravan/queue.rye)'s own `// invariant: wrap-as-periodic` comment already names for its ring;
  this generalizes it to two axes instead of one, which is what "torus" adds over "ring" -- a ring
  wraps one number, a torus wraps two independently.
- **It composes with the existing linear layout with zero migration.** Every caller that already
  holds a `u32` offset keeps working; `torus_locate` is available where the coordinate view helps
  and ignorable everywhere else. This is the same accretion the rearchitecture essay's five moves
  already practice, standing beside the linear layout rather than replacing it.

## What this leaves outside, named just as honestly

**Any electricity or latency saving stays outside this layer entirely, and honesty asks that this
stand named plainly.** The real-world precedent for "radial/toroidal addressing saves power" is a
hardware fact about wire length and nearest-neighbor traffic in multi-dimensional interconnect
fabrics built for that purpose -- a genuinely different layer than a Rye function computing an
offset into a `u32` array on a general-purpose CPU. This tree runs on ordinary hosted hardware
today, per [`declared-host-config.md`](../.claude/rules/declared-host-config.md), and the
seL4/Microkit road this piece cites is itself named a **proven-seat boundary** rather than a
shipped kernel target (per the `20260912` counsel note this piece takes its restraint from). A
two-axis index over a `u32` array costs the same handful of instructions as a one-axis index; the
honest claim stops at readability and a sharper bound, well short of joules.

## The falsifier

**A witness proving `torus_index.rye` is a bijection is buildable in one bounded round, and the
exact test is nameable now:** for every `(tier, slot)` pair the comptime tier table declares,
`torus_locate(torus_offset(tier, slot))` returns `(tier, slot)` exactly, and the set of offsets
produced covers `0..total_width` completely, each offset reached exactly once. Keeping the tier
boundaries fixed at comptime is what keeps the pure-function approach honest -- the day a caller
genuinely needs them to overlap or shrink at runtime, a stored table earns its keep instead of
costing redundancy, exactly the branch `address_space.rye`'s own header already opens for its own
derived bases ("derived, so no table can drift... unless the day someone wants a wider turn").

## What Bakery could pick up, and what stays here

**Buildable now, sized to one round:** `tally/torus_index.rye` as sketched above, plus its GREEN
witness proving the bijection over the three existing gardens (`blob`, `diff`, `frame`) mapped onto
two tiers (`per-dependent`, `shared`). This asks only for ordinary bounded Rye, provable on this
hosted machine today, well ahead of any seL4, Microkit, or capability claim, and it stands as a
strict narrowing of Bakery's own item 4, "derived region addresses," rather than a new direction.

**Stays here, named as vision:** any claim that a two-axis or torus-shaped index changes anything
about power draw, cache locality, or NUMA distance on real silicon. That claim belongs to a
hardware-topology research thread (the aether-field-lens and toroidal-archive pieces already filed
in `external-research/` carry it further), and it earns its own falsifier, its own measurement rig,
and its own round, standing as its own piece of work apart from a Tally design note.

## Related

No tracked issue. Companion pieces stand named above in Kin; this note stands alone, adding zero
dependency to any ship's Now line.
