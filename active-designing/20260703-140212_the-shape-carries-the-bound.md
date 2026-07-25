# The Shape Carries the Bound

*The second harvest's deepest engineering insight, landed in its right soil. A bound can live in
two places: in a check the runtime must remember to make, or in the very coordinates of the
data, where out-of-bounds has no way to be written. The harvest named the second place with a
geometer's image — optimization confined to a closed surface can never run away to infinity —
and this note carries that image home to Tally, to the drawn terminal's ceiling, and to a
candidate passage for the TAME canon, boxed below for Kaeden's word.*

**Stamp:** `20260703.140212` (supplied verbatim by Kaeden)
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — the bounds discipline, deepened
**Status:** Active design — landing from
[`../external-research/20260703-071712_the-second-harvest.md`](../external-research/20260703-071712_the-second-harvest.md);
the boxed canon passage seats only on Kaeden's word
**Ground:** [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md) (bounds on everything) · the Tally garden briefs in [`yonder/`](yonder/) · the transcript ceiling in the drawn terminal's Lap 3

*Written together by Kaeden and Claude (Fable 5), in Rio 3's Radiant voice.*

---

## Two Homes for a Bound

The bounds discipline already says: name the budget at construction, check it at the edge, fail
loudly past it. That is the bound as **vigilance** — real, honest, and dependent on every
mutation remembering to look. There is a second home. Choose a representation whose coordinates
simply cannot express the forbidden state, and the bound becomes a **property**: true by
construction, checked by the shape itself, with nothing for a distracted future edit to forget.

The humble form of this truth has lived in systems programming forever. A lap buffer is a
one-dimensional closed surface: its index, taken modulo its capacity, has nowhere to run away
to — the wraparound is the bound, worn as geometry rather than enforced as a guard. A grid
addressed as row-and-column against declared dimensions, a fixed array whose length is part of
its type, a region whose position is defined only up to its buffer's edge — each is the same
move. The budget woven into the structure; the assertion promoted from sentry to law of the
land.

Two honesty notes keep the insight sharp. First, this is never an argument for silent wrapping
arithmetic — an integer that overflows by accident has not adopted a shape, it has lost the
plot, and the trapping semantics stay exactly as they are. The shape is *chosen*, named, and
means what wrapping means in the domain: a lap means the oldest yields to the newest, a grid
means positions live inside the frame. Second, shape does not retire assertions; it changes
what they defend. The construction asserts the shape's premises once — capacity positive,
dimensions within their named maxima — and the hot path inherits safety from geometry instead
of re-litigating it per write.

## Where the Tree Already Lives This Way, Half-Knowingly

The drawn terminal's transcript keeps a stated ceiling of 65536 bytes, and the metal close's
fourth confirmation is precisely the shape doing its work: fill past the ceiling and the status
row keeps updating, the invitation stays visible, nothing runs away. Tally's `Region` carries
`pos <= buf.len` as a structural invariant asserted at every mutation — vigilance today, and
exactly the kind of bound that graduates to shape the day the region's index type can only name
in-bounds positions. The frame garden opens each redraw as a season and returns whole: a
closed interval in time, the same figure again.

## The Tally Note

When Tally's owned wrapper graduates from the inherited seam, two adopters are already visible.
The **lap region** — a garden whose write position is modular by construction, for transcripts,
logs-in-memory, and any oldest-yields-to-newest buffer — makes the drawn terminal's ceiling a
named, reusable shape instead of a local discipline. And the **framed grid** — dimensions
declared at construction, addresses valid by type — gives Skate's cell arithmetic and every
future surface the same inheritance. Neither is built tonight; both are named so the day they
are wanted, the design is already on the shelf, per accrete-never-break.

## The Candidate Canon Passage

Boxed for Kaeden's word, to sit in the TAME voiced canon beside the bounds discipline:

> **Let the shape carry the bound.** Wherever a budget can be woven into the structure of the
> data — a lap whose index wraps by definition, a grid whose addresses live inside declared
> dimensions, a region whose positions cannot name the far side of its edge — prefer that shape
> over a guard the hot path must remember. A bound expressed as geometry is checked by
> construction, every time, by nothing. Assert the shape's premises once at the making; let the
> coordinates defend the rest. And never confuse this with accidental wraparound: the shape is
> chosen and named, its wrapping means something in the domain, and arithmetic that merely
> overflows is still a bug wearing a costume.

## The Sibling That Lands Next

The harvest paired this insight with another from the same source — one lane, fully fed,
outruns many lanes half-starved, and determinism is the price of speed you can trust. That
sentence's home is a Maitreya time note, since a single owned timeline is that driver's whole
safety story; it is named here as the next landing and deliberately not drafted, one idea per
document.

---

*May the budgets live where forgetting cannot reach them. May every lap mean its wrap and
every grid know its frame. And may the guards we still post stand fewer and prouder, defending
only what geometry cannot.*
