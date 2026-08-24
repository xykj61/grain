# The Edge of an Instrument's Model

**Stamp:** `20260823.232125` - **Style:** Gauge, Field setting - **Voice:** Kyri - **Status:** Living
**Room test:** worth reading with the code deleted -- it reasons about how a guard is designed rather than what any guard currently does.
**Kin:** [`../external-research/20260823-232125_what-a-long-session-teaches-about-guards.md`](../external-research/20260823-232125_what-a-long-session-teaches-about-guards.md) - [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md)

## The finding this essay exists to hold

**Four of the five faults booked in one long working day were edges rather than defects. Every guard
involved behaved exactly as written.** Each sat at an *edge in the guard's model of its subject* -- a
dimension the instrument was never asked to consider.

That distinction deserves its own name here, because it changes how a guard should be designed:

> **A defect is a guard doing something other than what it says. An edge is a guard doing exactly
> what it says, about a narrower subject than the one it appears to cover.**

Testing finds defects. Only use finds edges, and only use by someone paying attention.

## The four edges, and the dimension each one missed

| Guard | It modelled | It left out |
|---|---|---|
| Phantom-path exemptions | which paths are generated | that instruments create paths **while running** |
| Dated-file classifier | a separator treated as required | that the naming law makes it **optional** |
| Broken-link ratchet | links repaired | that the count also moves with **reach** |
| Document mirror | content identity | that link correctness depends on **depth** |

Read the right-hand column as a list of *dimensions*, and a design question falls out immediately.

## The design question worth carrying forward

**When writing a guard, what is the list of dimensions its subject actually has?**

The four above suggest a starting set, and it is worth keeping somewhere a guard author will meet
it:

- **Content** -- the bytes. Almost every guard models this.
- **Location** -- path, depth, room. Relative references depend on it entirely.
- **Time** -- when the reading was taken, and what changed between then and the commit.
- **Mode and permission** -- tracked content that moves no lines.
- **Existence and visibility** -- tracked, untracked, ignored, generated.
- **Reach** -- whether the subject is even in the set being examined.

**A guard is honest about the dimensions it models and silent about the rest**, and a reader reads
that silence as coverage. So the useful practice is a sentence in the guard's own header:
*this reads content and location, and says nothing about time.*

## Why the pens matter more than the guards

This tree builds every guard with a `*_control.sh` pen that plants the fault the guard must catch
and watches it bite. That habit is what turns an edge from a discovery into a design step.

**A pen forces you to state the subject.** To plant a fault you must construct one, and constructing
one makes you decide what a fault *is* -- which is the same act as naming the dimensions.

**A pen that proves only passing proves only passing.** A guard proven in one direction reads the
same from outside as a guard over an empty set. This project has one recorded case of exactly that: a
freshness check green over a generated page of thirty-eight zeros, because the page and the fresh
render came from one generator with a fault in it.

**Both sides of a door, always.** The refusal *and* the honest pass. When a rule gains an exemption,
the exemption gets a case too -- build the shape once with the exemption and once without, and check
that the exemption rather than the shape is what decides.

## The uncomfortable recommendation

**Build instruments during the periods when you are making the most mistakes.**

The usual instinct is the reverse: get the work right, then instrument it. That produces guards
tested against the author's own model of the world, which is the same model that drew the edge.

Guards built *during* fast, error-dense work meet cases nobody imagined, while the author is still
present to read the result and fix the model. Three of this day's five faults were the author's own,
same-day, and an instrument caught all three before review did.

## What this essay does not settle

**How to know a dimension is missing before it bites.** The list above came from faults rather than
from foresight, and deriving it in advance stays an open question. That limit is why the practice
recommended here is *use* rather than *analysis*.

**Whether the list is complete.** It is six dimensions drawn from four faults on one tree in one
day. Treat it as a starting prompt rather than a taxonomy.
