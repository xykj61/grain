# The Floor You Can Stand On

**Stamp:** `20260906.152821`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- external research. The numbers are measured and bound by a witness; the design recommendation is proposed (`context/TWO_ROOMS.md`).
**Instrument:** `tools/fixtures/t/topology_attained_scan.sh` -- witness `tools/t/topology_attained_witness.rish` -- control `tools/fixtures/t/topology_attained_control.sh`
**Elder:** [`the-ring-and-the-ladder`](20260906-010402_the-ring-and-the-ladder.md), whose third erratum asked the question this paper answers

*A lower bound tells you how much room could exist. Whether a hand can reach into that room is a separate question. This paper builds the graphs and walks them.*

---

## What this paper bounds

Every figure here concerns **720 points**, the size of the seated sky, and **degree 5 or 6**, the wire budgets already on the table. Every diameter and mean hop count was measured on `20260906.152821` by breadth-first search from all 720 vertices of a graph this tree builds, over all 517,680 ordered distinct pairs. Every shape here is arithmetic over coordinates; `comlink/topology.rye` implements the seated three-ring reading alone.

The elder paper closed its third erratum with a number it could not supply -- how much of the diameter gap any real construction recovers -- and named its own confidence as **low** on exactly that. This is that number.

## The question a floor cannot answer

The Moore bound is the largest number of points a graph of a given degree and diameter can hold. Solved for the diameter, it gives a floor: at 720 points and degree 6 the floor is **4**, since a ball of radius 3 holds at most 187 points and a ball of radius 4 holds 937.

The seated torus walks at diameter **14**, so it sits **3.50x** above that floor. The elder paper reported this and said plainly that a floor bounds the room from above rather than promising a shape at the bottom of it.

That caution was right, and it turns out to be an understatement. **Very few graphs attain the Moore bound** -- the known attainers are the cycles, the complete graphs, Petersen, Hoffman-Singleton, and one open case at degree 57. A designer holding a 3.50x figure learns that up to 3.50x might be available, and still has to ask how much of it is theirs.

## A second floor, which the same shapes actually meet

There is a tighter bound for the family both tori belong to, and it takes four lines to derive.

A **Cayley graph over an abelian group** puts each point within `k` hops at the end of a word of length at most `k` in the generators. The generators commute, so the word is known entirely by how many times each generator was used and in which direction. Every point within `k` hops therefore has a name as an exponent vector, and the number of points within reach is at most the number of exponent vectors of total weight `k` or less.

For degree 6 spent as three generators and their inverses, that count is the number of integer points within L1 distance `k` of the origin in three dimensions. At `k = 7` it is **575**; at `k = 8` it is **833**. So 720 points overflow a seven-hop ball, and **the abelian floor at degree 6 is 8** -- twice the Moore floor.

Degree can also be spent on involutions, which contribute one neighbour rather than two, and the scan reports every split rather than assuming one. At degree 6 the three-inverse-pair split is widest at every radius: at `k = 8` it reaches 833 where two pairs and two involutions reach 456 and six involutions reach 64. At degree 5 the widest split shifts to **one involution and two pairs**, and the floor there is **14**.

Both tori are abelian Cayley graphs -- a three-ring torus is a Cayley graph on a product of three cyclic groups -- so this floor is one they are genuinely measured against. The seated torus sits **1.75x** above it rather than 3.50x, and the honest reading of the elder figure is that half of the gap it named lies outside the family entirely.

## What is actually reachable, measured

| Shape | Degree | Diameter | Mean hops | Over Moore | Over abelian |
|---|---|---|---|---|---|
| bubble-sort `B_6` (Cayley, `S_6`, adjacent swaps) | 5 | 15 | 7.5104 | 3.00 | 1.07 |
| **torus 12x5x12 -- the seated shape** | 6 | **14** | 7.2100 | 3.50 | 1.75 |
| torus 8x9x10 -- the best three-ring | 6 | 13 | 6.7316 | 3.25 | 1.62 |
| circulant `C_720(1, 8, 75)` | 6 | **9** | 6.3004 | 2.25 | 1.12 |
| pancake `P_6` (Cayley, `S_6`, prefix reversals) | 5 | **7** | 4.5828 | 1.40 | 0.50 |
| star `S_6` (Cayley, `S_6`, swaps with the first) | 5 | **7** | 4.7900 | 1.40 | 0.50 |

Three readings follow, and they answer different questions.

**Five hops are available inside the family, at one wire budget.** A circulant on the integers modulo 720 with jumps of 1, 8, and 75 spends exactly six edges per point, exactly as the torus does, and walks at diameter 9 against 14. That is **36 percent off the longest walk**, for the same degree and the same point count, staying commutative.

**The typical hop barely moves.** Mean distance goes from 7.2100 to 6.3004 -- **12.6 percent**, against 36 percent on the diameter. So the torus's cost lives in its tail rather than in its middle, and a design that prices its p99 has most to gain here while one that prices its mean has least. Two numbers about one graph, moving a factor of three apart, is what a single headline figure conceals.

**The median decides this, rather than the optimum.** Over all **63,903** circulants of this form, the best diameter is 9 and **1,240** triples reach it -- 1.94 percent, which is a needle. Yet the median is **12**, and **75.75 percent beat the seated shape outright** with another 6.2 percent tying it. Three generator triples drawn at random in four already walk shorter than the torus. The seated shape sits below the median of its own family, and improving on it costs a search of about four draws rather than a sweep of sixty thousand.

## The lever is the generating set, and it is worth saying twice

The obvious next thought is that commutativity is the whole cost, so a non-abelian shape wins. Two of the three Cayley graphs on the symmetric group here support that, and the third says otherwise.

720 is exactly `6!`, so the permutations of six symbols sit at precisely our point count -- a coincidence of size that makes these shapes directly comparable rather than analogous. The **star graph** connects each permutation to the five reachable by swapping the first entry with another, and walks at diameter **7** on degree 5. The **pancake graph** reverses a prefix instead, and also reaches 7. Both are half the seated torus's diameter on one sixth less wire, and both sit at **0.50x** the abelian floor for their own degree -- a shape reaching half of what any commutative arrangement of the same budget could.

The **bubble-sort graph** is a Cayley graph on the same group, at the same degree, generated by adjacent swaps rather than swaps with the first entry. It walks at **15** -- worse than the seated torus, on less wire.

So the finding is narrower and more useful than "go non-abelian": **the group is not the lever, and neither is the degree. The generating set is.** Three graphs on one group at one degree read 7, 7, and 15. A design that adopts a permutation address space and picks its generators carelessly can land behind where it started.

## What the five hops cost, named plainly

A torus's coordinates mean something. Three rings of twelve, five, and twelve are three facts about a point that a person can hold, and the sky is already organized by them. A circulant's jumps of 8 and 75 are arithmetic that happens to work, and a star graph's addresses are permutations of six symbols with no ring reading at all.

So the honest trade is **the longest walk against legibility**, and this paper measures one side of it. `C_720(1, 8, 75)` is the most legible witness the sweep offers -- it reads as a mixed-radix odometer, which is the same thing a three-ring torus is trying to be -- yet it still asks a reader to accept generators chosen by search rather than by meaning. Whether that trade is worth five hops stays a design question, and the number is here so the question can be asked with one.

## What is measured, what is derived, and what is neither

**Measured.** Every diameter and mean in the table, by all-pairs breadth-first search on a graph the scan builds. The sweep's 63,903 diameters, its median, and its share.

**Derived, and checked.** The abelian floor. Its closed form is compared against a direct enumeration of the lattice ball at every radius from 0 to 10 rather than at the one radius the floor needs -- a draft of the scan divided before it multiplied and read 574 at `k = 7` where the truth is 575, correct at ten radii of eleven and wrong at the one nobody would have checked alone.

**Outside both.** Whether a shape on this list is a good idea. Diameter and mean hop count are two properties among several that matter -- resilience, address legibility, and how a routing table is computed each sit outside this measurement, and the elder paper prices the first of them.

## The coverage gap, named rather than glossed

The sweep covers circulants with a **unit generator**. A circulant is isomorphic to any unit multiple of its connection set, so fixing one generator at 1 keeps every graph whenever some generator is coprime to 720 -- and it makes every graph in the sweep connected, so connectivity comes free. Yet three non-units can still generate: `{16, 9, 5}` share only the factor one while each shares a factor with 720, and such triples stay outside this sweep.

This bounds exactly one sentence. The exhibited diameter of 9 is an **achievability** result and stands whatever lives outside the sweep. The claim that **no circulant reaches the abelian floor of 8** is bounded by the sweep's own reach, and is written that way in the instrument: `sweep_reaches_abelian_floor floor=8 reached=no` reports what 63,903 graphs did rather than what all circulants can do.

## How the numbers are held

`tools/t/topology_attained_witness.rish` binds every figure above by name, at `tier cadence` -- 192 seconds, and its answer moves only when the scan moves. `tools/fixtures/t/topology_attained_control.sh` proves **19 behaviors** on real pen copies: eight plants, each shown from the failing side and then lifted, and the pen proven innocent first so each plant reads as the break speaking.

Two of the nineteen are worth naming here, because both are refusals of a flattering answer.

The **legless copy** breaks the floor search to return one too high and removes the bracketing check that catches it. It reads **green** with the degree-6 floor at 9 rather than 8, which lowers every ratio in the table at once and makes the seated torus look 1.56x above the floor where it is 1.75x. That is the shape of every number a reader has to take on trust.

The second is a refusal of a claim this paper could have made and did not. The float slip at `k = 7` is a real defect, and it **does not move this floor**: 574 and 575 both sit below 720, so the answer is 8 either way. The control proves that, so the enumeration leg is credited with exactly what it defends here. At a sky of exactly 575 points the same slip would flip the floor from 7 to 8, and that is the honest scope of what the leg defends.

## The falsifier

*Horizon: this holds while the sky carries 720 points at degree 5 or 6. Assumptions: distance is hop count on an undirected graph; the abelian floor counts exponent vectors, which bounds the ball whether or not the generators are independent; the sweep fixes one generator at 1 and therefore reaches circulants with a unit generator. Falsifier, in three parts, each cheap: exhibit an abelian Cayley graph on 720 points of degree 6 with diameter 7 or less, and the derivation above is wrong; exhibit any degree-6 circulant on 720 points at diameter 8, and the sweep's reach was the binding limit rather than the family; exhibit a degree-5 graph on 720 points at diameter 6, and the star graph's 7 stops being the number to beat. Confidence: high on every measured diameter and mean, which are all-pairs walks on graphs built here and cross-checked against a one-walk reading; high on the abelian floor, whose closed form is checked against enumeration at every radius; medium on the claim that no circulant reaches 8, which is bounded by the sweep's coverage gap above; low on whether the legibility a ring buys is worth the five hops it costs, which is a judgment rather than a measurement.*

## Gratitude

The degree-diameter problem and the Moore bound come from the graph-theory literature, studied rather than borrowed; the star and pancake graphs are standard constructions with a long interconnect history behind them. Every graph here was built and walked in this tree, and every number was measured on this bench rather than recalled from a table.
