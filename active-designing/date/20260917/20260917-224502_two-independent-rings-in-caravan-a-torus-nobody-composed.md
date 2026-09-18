# Two independent rings in Caravan -- a torus nobody has composed

**Stamp:** `20260917.224502`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- vision names one honest structural claim (two orthogonal periodic axes
already exist, uncomposed) and one honest refusal (no electricity or latency saving lives here
either); nothing in this piece is checkable yet
**Room:** vision
**Kin:** [`20260826-021136_caravan-rearchitected-the-optimization-spine.md`](20260826-021136_caravan-rearchitected-the-optimization-spine.md)
(Move one, "wrap where the quantity is genuinely periodic") -
[`20260917-222220_a-torus-index-for-tally-gardens-linear-underneath.md`](20260917-222220_a-torus-index-for-tally-gardens-linear-underneath.md)
(the sibling piece; cites `caravan/queue.rye`'s ring as a one-axis precedent) -
[`../caravan/queue.rye`](../caravan/queue.rye) - [`../caravan/cycle.rye`](../caravan/cycle.rye) -
[`../counsel/date/20260912/20260912-144152_the-runner-the-torus-and-the-reverse-reading.md`](../counsel/date/20260912/20260912-144152_the-runner-the-torus-and-the-reverse-reading.md)
(names the restraint this piece tries to honor)

## The one sentence this piece is for

Caravan already carries two genuinely periodic axes, built for two unrelated reasons, and each
stays entirely inside its own module: `queue.rye`'s buffer slot (`seq % max_outstanding`, one
channel's own ring) and `cycle.rye`'s domain position (`laps`, a message's count of full trips
around a ring of domains). Naming that pair a torus and asking whether joint addressing is worth
building is a narrower, checkable question than "should Caravan's scheduler be toroidal" -- and it
answers with a buildable sketch rather than a hope.

## What is measured, not guessed

Read in full on this tree, `20260917.224502`:

- [`caravan/queue.rye:219-228`](../caravan/queue.rye) computes `slot_offset(seq)` as
  `seq % max_outstanding`, with its own comment naming the arithmetic on purpose: *"wrap-as-periodic
  -- the queue is a ring, so a linear sequence number landing back on an early slot is the meaning
  of the modulo rather than an overflow."* `max_outstanding = 4`. This axis answers *which slot, of
  four, in this one channel's shared-memory buffer*.
- [`caravan/cycle.rye:82`](../caravan/cycle.rye) declares `max_hops: u32 = 4` and tracks `laps` as a
  message circulates a ring of domains (`alder`, `birch`, `cedar` in the module's own worked
  example) -- *"tail owned by the domain that counts its own laps."* This axis answers *how many
  full circuits, of a ring of domains, has this one ask made*.

Both are real, both are bounded, both wrap by construction rather than by accident, and both are
proven independently: `queue.rye`'s own comptime asserts hold `max_outstanding >= 2` and the whole
ring inside 4096 bytes; `cycle.rye`'s own search finds the one directed walk that visits every
domain once and closes, and its header states the honest finding plainly -- *"a ring has no
vantage point,"* since every domain inside it spans only its own two neighbors.

**Each module stands alone, and the tree treats them as two separate findings.** Grepped
`20260917.224502`, every source file that imports `queue.rye` or `cycle.rye` imports exactly one of
the two, and every comment describing a ring describes only its own module's ring.

## Why two rings, composed, are a torus in the sense this thread already uses the word

The sibling piece on Tally's gardens already sets the rule this piece inherits: a torus here names
**a claim about which arithmetic is honest**, standing apart from any claim about physical shape. A
single modulo is a ring; two independent moduli, each wrapping on its own bound, addressing one
item together, is a torus -- the same distinction a doughnut's own two independent angles make over
a single circle's one. `queue.rye`'s slot and `cycle.rye`'s lap are independent in exactly the
needed sense: a message's slot is decided by which channel and which sequence number it holds,
bounded by `max_outstanding`; its lap count is decided by how many times the ring of domains has
carried it all the way around, bounded by whatever hop budget a caller declares. Each bound stands
on its own, so a `(lap, slot)` pair covers a genuine two-dimensional bounded space rather than a
single axis wearing two names.

## The moonshot, stated narrowly

**Propose `caravan/torus_ask.rye`: a pure function that reports one ask's position as `(lap: u32,
slot: u32)`, built entirely from data both `queue.rye` and `cycle.rye` already compute.**

```
const Position = struct { lap: u32, slot: u32 };

fn locate(seq: u32, laps_seen: u32) Position {
    // invariant: the slot axis is queue.rye's own wrap, unchanged
    const slot = seq % max_outstanding;
    // invariant: the lap axis is cycle.rye's own count, unchanged
    return .{ .lap = laps_seen, .slot = slot };
}
```

The function reuses rather than stores: `seq` and `laps_seen` already exist as `queue.rye`'s
sequence number and `cycle.rye`'s lap counter, each owned exactly where it is owned today. `locate`
is a read-only view over two facts a caller may already hold separately, in the same sense the
Tally piece's `torus_locate` is a view over `gardens.rye`'s existing linear offset -- **the two
source modules keep their own storage and their own wrap arithmetic exactly as they stand.**

## What this actually buys, named honestly

- **A debugging and audit vocabulary for a ring-of-rings shape**, should Caravan ever compose a
  `cycle.rye`-style domain ring where each domain also runs a `queue.rye`-style buffered channel to
  its neighbors -- a shape that stays purely hypothetical here. What this piece proposes is naming
  the coordinate, so that day's design has a word ready rather than inventing one under pressure.
- **A concrete instance of Move one's rule holding at two different periods in one lane.** The
  rearchitecture essay states the rule once, abstractly; `queue.rye` and `cycle.rye` are two
  separately-arrived-at, separately-reasoned proofs that the rule was followed correctly, each
  written in ignorance of the other. Naming them together is evidence the rule generalizes,
  standing on more than a metaphor reaching for company.
- **`locate` reports and stops there.** Scheduling, admission, and performance stay exactly as
  they are, since the function decides nothing. This is a strictly smaller claim than the sibling
  Tally piece's own `torus_index`, since that piece at least proposed a new lookup function callers
  might reach for. This one proposes a name for a coordinate that today waits for its first caller.

## What this leaves outside, named just as honestly

**Electricity, latency, and cache-locality claims stay entirely outside this piece, for the same
reason the sibling piece names.** This tree runs on ordinary hosted hardware today
(per [`declared-host-config.md`](../.claude/rules/declared-host-config.md)); a `(lap, slot)` struct
costs the same handful of instructions as reading two `u32` fields separately, and a real power or
wire-length saving from toroidal addressing is a fact about physical interconnect fabrics, a
different layer entirely. **A second refusal, sharper than the sibling piece's:** this proposal
waits for a caller. `torus_index.rye` at least served an existing lookup Tally's gardens already
perform by name; `torus_ask.rye` as sketched here answers a question -- *where is this ask, on both
axes at once* -- that today's modules have yet to ask. Building it ahead of that caller would be
exactly the over-smart move Gauge's first rule warns against: a coined structure standing in for a
real one, and naming it vision here is what keeps it from being mistaken for a checkable claim.

## The falsifier

**This piece is falsified by finding a caller.** If a future round composes `cycle.rye`'s domain
ring with `queue.rye`-style buffered channels between neighbors -- the shape named above and left
purely hypothetical here -- then `(lap, slot)` gains a real address a witness can be written
against, exactly the way the sibling piece's `torus_locate` already has one (`gardens.rye`'s three
named gardens). Until that composition is proposed on its own merits, this piece's correct status
is a naming note, and it waits for a caller to size it against before it earns a place in
`active-development/`.

## What Bakery could pick up, and what stays here

**This piece sizes no build round.** Unlike the sibling Tally piece, which named a
one-round-buildable witness, this piece's own falsifier points at watching rather than building --
the honest next step is waiting for the day a real caller needs both axes at once, and reaching for
this note when that day arrives rather than re-deriving the naming from scratch.

**Stays here, named as vision:** the observation itself, and the discipline of writing down a
structural finding ahead of its first caller rather than either building unwanted code or letting
the observation evaporate. A tree that only records buildable claims forgets the shape of its own
modules faster than it should.

## Related

No tracked issue. Companion pieces stand named above in Kin; this note stands alone, adding zero
dependency to any ship's Now line, and leaves `construction/ITINERARY.md` exactly as it stands.
