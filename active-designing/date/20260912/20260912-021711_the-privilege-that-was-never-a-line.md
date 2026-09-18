# The Privilege That Was Never a Line

**Stamp:** `20260912.021711`
**Room:** mixed -- a measurement over seated code, and a design recommendation that follows from it.
**Status:** Landed measurement, proposed re-rank. The figures are bound by
[`tools/c/capability_lattice_witness.rish`](../tools/c/capability_lattice_witness.rish); the re-rank waits on the lane.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Serves:** row 2 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)

---

## What row 2 proposed, and the one line it rested on

Row 2 of the bounded-torus page reads the process graph in polar coordinates. Radius stands for
privilege -- 0 supervisor, 1 Pond, 2 desk, 3 wire -- angle stands for capability class, a message
names a hop as a pair `(dr, dtheta)`, and the supervisor refuses any hop past the declared maximum.
It asks for a hop table of 16 rings by 8 sectors as its first witness, and it names its own
assumption in five words: **privilege in Caravan is already ordered.**

Its falsifier reads: a real supervised process needs a privilege that sits between two rings, which
would show privilege is a lattice rather than a line.

That falsifier fires. It fires on the seated module rather than on a future process, and the
measurement below is what fires it.

## Where the answer already lived

Caravan declares privilege as bits. [`caravan/capabilities.rye`](../caravan/capabilities.rye) holds
five constants -- `right_read`, `right_write`, `right_exec`, `right_net`, `right_device` -- each a
single bit of a `u8` mask, and one function that compares two masks:

```zig
pub const Rights = struct {
    pub fn contains(have: u8, need: u8) bool {
        return (have & need) == need;
    }
};
```

That is subset containment. A mask is a **set** of rights, and `contains` answers whether one set
holds another, so the order on privilege is the subset order on a five-element set -- the Boolean
lattice `B_5`, whose diagram is a five-dimensional cube.

The conferral path agrees. [`caravan/confer.rye`](../caravan/confer.rye) reads a ceiling from the
parent's table, refuses a write the ceiling withholds through that same `Rights.contains`, and then
computes what the dependent receives as `granted &= ~capabilities.right_write` -- a mask AND, which
is the lattice **meet**. A conferral moves downward through the cube by clearing bits. It travels no
line, because the code never had one to travel.

## The measurement

[`tools/fixtures/c/capability_lattice_scan.sh`](../tools/fixtures/c/capability_lattice_scan.sh)
derives the rights from their own declarations, reads the composite masks the `caravan/` room
actually constructs, and prices the polar model against the seated one. Read `20260912.021711` at
commit `c6cd49afd7`, over `caravan/capabilities.rye` and the 114 `.rye` sources beside it.

| Reading | Full lattice `B_5` | Masks the tree seats |
|---|---|---|
| Distinct masks | 32 | **10** |
| Ordered pairs, `a != b` | 992 | 90 |
| Conferrals the lattice admits | 211 | **13** |
| Conferrals a radius model admits | 606 | **61** |
| **Admitted by radius, refused by the lattice** | **395** | **48** |
| **Refused by radius, admitted by the lattice** | **0** | **0** |
| Incomparable unordered pairs | 285 of 496 (57 pct) | **32 of 45 (71 pct)** |
| Widest antichain | 10 | -- |

The ten seated masks are `read`, `write`, `exec`, `net`, `device`, `read|write`, `read|exec`,
`read|net`, `read|device`, and `read|write|exec`. Run the scan with `--list` and it names all 32
incomparable pairs; `read|write` beside `read|device` is the plainest of them. Neither holds the
other, so neither sits inside the other's ring, and no ordering of four rings places both.

**Every figure above is FREE**, in the sense
[`context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md) asks a figure to name, so RUN
`sh tools/fixtures/c/capability_lattice_scan.sh` rather than reading them here. Nothing holds them
still on purpose: they describe a capability model that is **correct**, and a gate on the
incomparable count would red this tree for holding a good one.
[`tools/c/capability_lattice_witness.rish`](../tools/c/capability_lattice_witness.rish) walls the
**instrument** instead -- a scan answering `lattice` for every input would have produced this same
finding on a module whose privileges genuinely sat on a line. The mask count is the one to watch:
it rises as the room constructs new composites, and the incomparable share rises with it.

## The half that matters: the error runs one way

The over-admission column is large. The under-admission column is **zero**, and that zero is the
finding.

Subset containment implies no greater popcount, so a conferral the lattice allows is one a radius
model allows too. Every disagreement between them therefore has the same sign: the radius model
says yes where the lattice says no. A supervisor built on rings would hand a dependent a right
nobody conferred, and it would do so **silently**, since from inside the ring model the hop is
legal and there is nothing to report.

Name that plainly. A privilege checker whose only failure mode is over-granting is the worst shape
a supervisor can take. A checker that occasionally refuses a legal hop announces itself the first
time somebody hits it; one that occasionally grants an illegal one waits for a breach. Row 2's
model is the second kind, and refining it -- more rings, finer sectors -- moves the count without
changing the sign.

## What dies, and it is the angle

The radius half fails on the order. The angle half fails on arithmetic that is worth stating once,
because it is the reason no amount of tuning rescues the shape.

An angle names one value. A privilege is a **set** of rights. Eight sectors name eight classes, and
the tree already seats `read|write|exec` -- one privilege wearing three classes at once, which no
single bearing can carry. The repair inside the polar frame is to give each subset its own sector,
which needs `2^n` of them: 32 today, 256 at the eight rights a `u8` mask holds. At that point the
sector index **is** the mask, the radius is a function of it, and polar coordinates have added a
second name for a number the mask already carried.

## What survives, and it is worth keeping

Three things from row 2 hold, once the line is set down.

**Popcount is a real rank.** `B_5` is a graded lattice, so "how many rights does this dependent
hold" is meaningful, monotone, and cheap. It makes an honest **report** -- a supervisor may print a
dependent's rank and a reader learns something true. It makes a poor **gate**, for the reason the
table gives.

**The hop has a maximum, and it is the height.** Row 2 wanted a declared ceiling on how far one
message may travel. The lattice supplies one: a conferral is a downward walk on the cube, its length
is the Hamming distance between the two masks, and no walk exceeds the number of rights. The bound
is `n`, read from the mask type rather than chosen -- which is the same move the scan makes for its
own bound, and the same discipline TAME asks of every allocation.

**The shape is still bounded, and still wraps in more than one direction.** A five-cube is not a
torus, and it shares the property the lane was reaching for: distance on it has a maximum by
construction, and the maximum is a number the declaration already states. The lane's instinct was
sound; the coordinate was the guess.

## And the mask has three bits of headroom

The scan derives its own bound from the declared type rather than from a number typed into it: a
right is one bit, the mask is `u8`, so Caravan may hold **at most eight rights** without a type
change, and it holds five. `rights_headroom=3`.

That figure is **free** -- a sixth right lands whenever somebody writes one -- so run the scan
rather than reading this line. What holds still is the ceiling: the eighth right is the last one,
and the ninth is a type change in a published struct. Naming it here means the lap that wants a
`right_time` or a `right_signal` meets the arithmetic before it meets the compiler.

## The projection, with its falsifier

**Claim.** A ring-and-sector privilege checker over Caravan's rights would over-grant and never
under-grant, so its failures would be silent breaches rather than loud refusals.

**Horizon.** For as long as `Rights.contains` returns `(have & need) == need`.

**Assumptions.** Rights stay bits of one mask; conferral stays the meet; radius stays the popcount,
which is the only rank a graded Boolean lattice offers.

**Falsifier.** The scan reads `verdict=line` -- every seated pair comparable -- which would mean the
tree constructs a chain and a radius checker agrees with the lattice pair for pair. That reading is
proven reachable rather than hypothetical: the control builds a chain pen and the scan answers
`line` there, with `seated_over_admitted=0`.

**Confidence.** High for the order, which is read from the type and the function. High for the
asymmetry, which is proven by enumeration at three and five rights. Medium for the recommendation,
since declining a coordinate is a design act and the lane may still want a polar **report** over a
lattice **gate**.

## Recommended re-rank

Row 2 stands at rank 7 of the twelve. Recommend **last**, beside row 4, and for the same underlying
reason: both rows propose a radius over a population that carries no usable distance. Row 4's
population has no coordinate at all; row 2's has one that runs the wrong way. What should be lifted
out of row 2 before it rests is the hop bound, which the lattice height supplies today.

## What this does not reach

Whether a supervisor **should** hold privilege on a line -- that is a design question, and this
prices one answer rather than deciding it. Whether the `u8` mask is the right carrier at all.
Whether the eight-right ceiling will bind before Caravan reaches the microkernel. And what a polar
**report**, as distinct from a gate, would be worth to a reader watching a supervision tree; the
rank is there, cheap and honest, and nobody has asked it for anything yet.
