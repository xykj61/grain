# The Bound That Names a Joule

**Stamp:** `20260905.232224`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Proposed -- nothing here is checkable until a witness binds it
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Instrument:** [`../tools/fixtures/b/bound_kind_census.sh`](../tools/fixtures/b/bound_kind_census.sh)
**Crossing:** the measurement over this tree is room two,
[`the-fence-with-no-post-on-the-time-side`](../active-designing/20260905-232224_the-fence-with-no-post-on-the-time-side.md)

---

## What this paper claims, before the argument

**A bound on extent answers one question and a bound on cost answers another, and safety
lives in the first.** A program that names a maximum for every buffer, list, and loop stays
protected against running away. Cheapness is a separate property it must earn separately, and
on a device drawing from a battery that separation is the whole engineering problem.

This paper argues the distinction from first principles, states what would refute it, and
hands the buildable half to the modules that would carry it. The companion study measures
this tree against the argument.

**Scope.** The claim covers programs written under a bound-everything discipline, aimed at
targets where energy is scarce. It leaves correctness entirely alone, and it stays silent on
whether any current program in this tree is wasteful -- that is a measurement nobody here has
taken.

---

## The two questions a maximum can answer

Write `const max_frame_bytes: u32 = 4096;` and you have answered a question about **extent**:
how large may one thing get. Check it at the edge, fail with a named error, and a whole class
of fault is gone -- the buffer cannot overflow, the allocation cannot surprise the arena, and
the failure that remains is a refusal you can read.

Write `const max_patience_looks: u32 = 8;` and you have answered a question about **work**:
how many times may this loop go around. Same discipline, one axis over, and the fault it
prevents is the loop that never returns.

Now write the third one. The tree holds two axes rather than three, and the reason deserves
plain naming rather than a shrug: **a bound-everything discipline inherits its axes from the
failures it was drawn against**, and both failures above are failures of *runaway*. A buffer
that overflows corrupts memory. A loop that spins forever hangs the machine. Both are
catastrophic, both are structural, and a named maximum genuinely prevents them.

Cost belongs to a different family. A program that costs twice what it should still returns the
right answer at the right time. It simply drains something, and what it drains stays invisible
from inside the process.

## Why the invisible thing became the binding one

Energy is the integral of power over time, and for a digital device it splits into two terms
that behave differently.

**Dynamic energy** is spent per operation -- each transistor switch charges and discharges a
capacitance. It scales with how many operations you perform, which means it is bounded exactly
when your operation count is bounded.

**Static energy** is spent per unit of time the device is awake -- leakage current flows
whether or not anything is computing. It scales with wall time, which means it is bounded
exactly when your *wakefulness* is bounded.

Here is the asymmetry that matters. **An extent bound leaves both terms free.** A bound on
`max_frame_bytes` speaks to the size of one frame, and stays quiet about how many frames you
draw and how long you stay awake drawing them. A work bound reaches the first term within one
episode, and leaves the count of episodes open. So a program can hold every maximum this
discipline asks for, run its bounded loop a thousand times a second forever, and cost without
limit.

**Read this as an axis the discipline has yet to grow rather than a hole in it**, and the
distinction earns its place: the repair for a hole is a patch, where the repair for a missing
axis is a new kind of bound.

## The physical floor, so the discussion is bounded from below

**Observation, derived rather than recalled.** Landauer's principle gives the minimum energy
to erase one bit irreversibly as `kT ln 2`. With Boltzmann's constant `k = 1.380649e-23 J/K`
(exact, SI 2019 definition) and `T = 300 K`:

```
kT ln 2 = 1.380649e-23 x 300 x 0.693147 = 2.87e-21 J   (2.87 zeptojoules)
```

A reader can check that on a calculator, which is why the arithmetic is shown rather than the
conclusion asserted.

**Illustrative calculation, with its assumptions named.** A CMOS switching event dissipates
roughly `1/2 C V^2`. Taking a node capacitance of `1 fF` and a supply of `0.8 V` -- both
plausible round numbers for a recent process, neither measured here:

```
1/2 x 1e-15 F x (0.8 V)^2 = 3.2e-16 J   (320 femtojoules)
```

which is about `1.1e5` times the Landauer figure above.

**The inference this licenses, and no more:** practical computing sits many orders of magnitude
above the thermodynamic floor, so the constraint everyone actually meets lies far above it.
**The projection:** architectural and scheduling choices -- how often you wake, how much you do
per wake -- will dominate energy on real parts for the foreseeable horizon, because they
operate on the factor of `1e5` rather than on the floor beneath it.

**Falsifier for that projection:** exhibit a target part whose measured energy per useful
operation sits within two orders of magnitude of `kT ln 2` at its operating temperature. Given
such a part, the headroom argument is spent and the interesting work moves to reversible
computing rather than to scheduling. **Confidence: high** for silicon CMOS through the next
decade; the two capacitance and voltage figures above are round numbers rather than datasheet
readings, and the argument rests on the ratio being large rather than on their precision, which
a factor-of-ten error in either leaves intact.

## What a joule-naming bound would actually look like

The honest shape stops short of a bound that names joules. Counting joules from inside a
program takes hardware the program may lack, and a bound checkable at an edge is the only kind
worth writing -- the rest are wishes.

The shape that *is* checkable bounds the two quantities energy is proportional to.

**A wake bound.** How long may this component hold the machine awake in one episode? Checked
against a monotonic clock at the edge, refused with a named error, exactly as a byte bound is
checked against a length. This bounds the static term.

**A rate bound.** How often may this episode repeat? A minimum interval between wakes, or a
maximum count per window, checked the same way. This bounds the repetition the work bound
cannot see.

Both are ordinary bounds, and both work with the clock a program already has rather than a
power meter. Both are the same discipline already written, applied to a quantity carrying a
time denominator rather than a byte count -- and that is the paper's whole proposal, which is
smaller than it first sounds.

## The three ways this argument could be wrong

**The target might be plugged in.** Where the software runs only on a server drawing from a
wall socket, energy becomes a cost line rather than a constraint, and every hour spent on wake
bounds is an hour correctness could have had. *Falsifier: name the deployment. Given a roadmap
holding only mains-powered targets, this paper is enthusiasm.*

**The runtime might already own it.** On a system where the scheduler, the kernel, or the
runtime governs wakeups centrally, a per-component bound duplicates a decision made better one
layer down, and duplicated decisions drift apart. *Falsifier: exhibit the layer that already
bounds wakefulness, and show a component held under it.*

**The numbers might be too small to matter.** Where a radio, a screen, or a sensor dominates
the energy cost, bounding compute wakeups optimizes the wrong term. *Falsifier: a power budget
for the target device, broken down by subsystem, in which compute is a minority share.* This is
the likeliest of the three to fire, and it redirects the argument rather than defeating it --
the same bound shape applies to a radio's wake, and a radio is exactly the kind of resource a
supervisor already governs.

## What this paper does not do

It measures no running program's energy, on any device. Every figure above is either derived
arithmetic with its inputs shown, or an illustrative calculation with its assumptions named.
**Everything here stays in the proposed room**, and the companion study keeps its own
measurement -- which reads names in source files -- separate from any claim about joules.

---

*May every fence in this tree have a post on each side it is asked to hold, and may the
discipline that made the first one grow the second when the ground asks for it.*
