# Comlink checked -- one classic ring, one nested tree, no torus

**Stamp:** `20260917.235220`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- one module read, checked negative for a torus seam; extends the torus-thread synthesis
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260917-233424_the-torus-thread-closes-five-checks-one-buildable-seam.md`](20260917-233424_the-torus-thread-closes-five-checks-one-buildable-seam.md) --
this piece answers that synthesis's own open question for one of its four named modules

## The one sentence this piece is for

The prior synthesis named Comlink, Tablecloth's real store, Amphora, and Brix as unread, and rated
its own confidence "medium, at best" until they were. This piece reads Comlink -- 98 tracked `.rye`
files, 14,977 lines -- by the same method the five prior reads used. The pattern repeats a sixth
time: a genuine periodic ring exists, it is the small purpose-built kind already catalogued, and it
stands alone.

## What was read, and how

A whole-tree grep across `comlink/*.rye` and its `comlink/discovery/` subdirectory, matching `%` on
non-comment lines, `wrap`, `ring`, `cycle`, and every `max_` / `queue_depth`-shaped constant -- the
same four-pattern sweep the Caravan and Tally readings used, and reproducible in one command:

```
grep -rn '[a-zA-Z0-9_)] % [a-zA-Z0-9_(]' comlink --include='*.rye'
grep -rln 'wrap\|ring\|cycle' comlink --include='*.rye'
```

Most hits were unit conversions (`ms % 1000`) or alignment asserts (`offset % width == 0`). Two
resolved into real structure.

## What was found

**`comlink/virtio_net.rye`'s TX/RX descriptor rings.** `queue_depth: u32 = 4`; both
`TxQueue.send` and `RxQueue.wait_frame` index the used ring with `self.used_tail % queue_depth` and
count a `u16` tail forever upward. This matches `caravan/queue.rye:224`'s own shape exactly -- a
single bounded index wrapping over one fixed-size array, the classic ring buffer a virtio device's
own spec asks for. Two unrelated modules land on one ring shape for one shared reason: each talks
to a fixed-size hardware or hypervisor queue.

**`comlink/topology.rye`'s d12-d60 address space.** `number % self.galaxies` and
`number % self.star_count()` decode a flat point number into galaxy, star, and planet tier by
modular arithmetic. Read alone, this looks like Tally's two-axis garden finding: a real,
load-bearing modular decomposition, sitting in shipped code today. **The file's own doc comment
rules it out as a torus candidate.** Its tiers are **inclusive and nested** -- "every galaxy is
also a star and a planet" -- walked by a **sponsor chain** that only rises. `sponsor_of` bounds a
maximum *tier depth*, never a maximum *cycle length*. A torus needs two axes whose far edges meet
each other. A sponsor tree has one axis and a root; meeting your own sponsor twice would be the
loop the file's comment names as the one failure it guards against. Nested and periodic wear the
same operator and answer to two different shapes.

## Inference

The seventh module this thread has opened yields a seventh purpose-built, single-axis ring,
composed with nothing else. One of the two candidates read here even carries the surface look of
a torus seam -- a modular decomposition sitting in real, shipped code -- and resolves to a tree on
a closer read. The pattern the prior synthesis described holds: genuine rings live small and
local here, and the surrounding modules leave the tree's own topology exactly as flat as it stood.
The near-miss earns its keep on its own: `topology.rye` proves a real, useful, already-shipped
modular address scheme can exist in this tree and still answer to a tree's own shape rather than a
torus's.

## Falsifier for this finding

A future round finding a second independent modulus inside `virtio_net.rye`'s ring family -- a
multi-queue configuration where `queue_depth` varies per queue, and queues themselves wrap over a
queue-select register -- would give this module the two-axis shape Tally's gardens already have,
and this finding would then want correction rather than extension. A sponsor-chain read that turns
up a genuine cycle (two points sponsoring each other) would mean `topology.rye`'s own invariant has
already broken, ahead of its own bounded-depth assert catching it first.

## What remains unchecked, said plainly

Tablecloth's real store, Amphora, and Brix stand unread by this thread still. Comlink's own
`discovery/` room (six files) and its `guest_pattern_rx.rye` - `guest_open_asks_consent_rx.rye`
pair matched `ring` or `cycle` in the grep above and earned a name here rather than a line-by-line
read -- the four-pattern sweep points at where to look closely; it answers for nothing past the two
files whose hits actually resolved into rings. The confidence this piece adds rests where the
prior piece left it, "medium, at best," now standing on six modules read rather than five.

## Related

No tracked issue. This note adds zero dependency to any ship's Now line and leaves
`construction/ITINERARY.md` exactly as it stands.

May the next reader who opens Tablecloth's real store, Amphora, or Brix find one more row for this
table, and may a genuine second axis, the day it turns up, read as plainly as its absence has read
six times running.
