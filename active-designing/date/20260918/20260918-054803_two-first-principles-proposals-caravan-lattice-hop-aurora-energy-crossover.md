# Two first-principles proposals -- a lattice-height hop bound for Caravan, an
# energy-crossover rule for Aurora's torus

**Stamp:** `20260918.054803`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- vision. Nothing here runs today.
**Room:** vision -- two design proposals, each waiting for its own first witness.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260918-052643_branch-cursor-ring-checked-third-idiom-also-negative.md`](20260918-052643_branch-cursor-ring-checked-third-idiom-also-negative.md)
(closes the search thread this piece answers), [`../../date/20260910/20260910-060204_the-bounded-torus-moonshots.md`](../20260910/20260910-060204_the-bounded-torus-moonshots.md)
row 2 (`caravan/capabilities.rye` reads as a lattice, not a line) and row 7 (Aurora's small-torus
placement), [`../../date/20260912/20260912-021711_the-privilege-that-was-never-a-line.md`](../20260912/20260912-021711_the-privilege-that-was-never-a-line.md).

## Why this piece is design rather than another search

Ten accounts across this lane's last week asked one question -- does a torus, a ring, or a radial
scheme already sit hidden in this tree's own code -- and each answer landed the same honest way,
most recently against the third wraparound idiom, a branch-and-reset cursor
([here](20260918-052643_branch-cursor-ring-checked-third-idiom-also-negative.md)). A search bounded
by the shapes it names earns its keep by getting checked, and this one is checked out. **What is
still open is design work: whether a toroidal or radial scheme is worth PROPOSING to Caravan or
Aurora, argued from first principles rather than from a grep.** This piece proposes two, each small
enough to state as one claim, and each grounded in a measurement this lane already holds rather than
in a fresh one.

**One sentence of honesty before either proposal.** This page proposes; witnesses decide. A claim
here enters the checkable room the day a witness on metal binds it, and stays here until then.

---

## Proposal 1 -- Caravan bounds a confer chain by the lattice's own height

### Where this picks up

Row 2 of the round-one page proposed reading Caravan's privilege as a radius on a line: supervisor
at 0, then rising rings outward. `tools/fixtures/c/capability_lattice_scan.sh` read the seated
module against that proposal and answered with a wider structure -- privilege is the subset order
on a bitmask of named rights, a Boolean lattice, and a radius-only checker admits **48 of 90**
seated pairs the lattice itself would decline
([`the-privilege-that-was-never-a-line.md`](../20260912/20260912-021711_the-privilege-that-was-never-a-line.md)).
That erratum named one thing the radius proposal got right by accident: *"What survives is the hop
bound, supplied by the lattice height."* This proposal is the first to say what that bound would
actually do.

### The mechanism a chain already exists to bound

`caravan/confer.rye` moves reach into a running dependent: a supervisor hands down a capability
word for one arc, masked to no more than the letter the dependent's own ceiling already grants. A
dependent that itself holds `confer` rights (the tree's own module reads a supervisor conferring
downward, and the code leaves the door open for a conferred dependent to confer onward to a third,
narrower still) can chain that grant onward. **Each hop in such a chain can only narrow the rights
bitmask, widening stays outside its reach** -- `confer.rye`'s own refusal `ConferOverreaching` is
exactly this rule, checked at one hop alone rather than across the whole chain. A chain of confers
from an original grant down to a final holder is therefore a descending chain in the subset lattice,
and a descending chain in a lattice of height H runs at most H strict steps before it settles at the
bottom (the empty rights set, which has nowhere further to confer).

**Measured today**, `tools/fixtures/c/capability_lattice_scan.sh` reads `rights_declared=5` and
`lattice_size=32` (`20260918.054803`, this pier). The lattice height -- the number of rights, since
each covering step in a Boolean lattice flips exactly one bit -- is **5**. So any confer chain
starting from the widest seated mask and narrowing at every hop runs **at most 5 hops** before it
reaches a dependent whose rights are exhausted for onward conferral. That is a real, checkable
ceiling `confer.rye`, `revoke.rye`, and their witnesses have yet to name.

### The claim

**A confer chain's maximum length is the lattice height, `rights_declared`, and Caravan should
assert it rather than leave it implicit.** Today the code enforces the one-hop rule (`have &subset;
need` at each confer) and counts only that single hop, so a chain longer than the lattice permits
could only arise from a fault in the one-hop check -- yet the mechanism leaves its own bound
unstated beside the rule that produces it, which is exactly the gap TAME's own "bound everything,
name the maximum at construction" rule exists to close.

### First witness

A depth counter carried alongside a conferred word -- one `u8` field, `hops_remaining`, set to
`rights_declared` at the original grant and decremented at each onward confer -- with a new
declined-state, `ConferChainExhausted`, when a confer is attempted at `hops_remaining == 0`. The
witness plants a chain of exactly `rights_declared + 1` confers over strictly narrowing masks and
shows the last one declined; a chain of `rights_declared` confers over the same masks succeeds.

### Horizon

One to two weeks. The mechanism (`confer.rye`) and the measurement it leans on
(`capability_lattice_scan.sh`) both exist; what is new is one field, one declined-state, and one
control proving the boundary from both sides.

### Assumptions

`rights_declared` stays derived from `caravan/capabilities.rye`'s own bit declarations rather than
hand-copied, so a sixth right raises the bound the day it lands -- exactly as the scan already does
for its own reading. A confer chain narrows strictly at every hop; a confer that grants the SAME
mask onward (a lateral hop, rather than a narrowing one) needs its own rule, named as an open
question below rather than presumed settled.

### Falsifier

A real supervised system needs a confer chain longer than `rights_declared` hops to reach its
intended dependent, which would mean the bound is real yet too tight for a legitimate topology --
distinct from row 2's own falsifier, which asked whether privilege sits BETWEEN two lattice points
(a question about the ORDER) rather than whether a chain along the order can be too short (a
question about its LENGTH).

### Confidence

High for the bound's existence -- it follows from the lattice height by construction, and the
lattice height is a number this tree already measures. Medium for whether a lateral (same-mask)
confer belongs inside the same counter or needs a separate one; today's ten seated masks form one
antichain of width 10 (`widest_antichain=10`, the same reading), so the lateral case stays
untested for want of a real example.

### The open question this proposal leaves

Today's `widest_antichain=10` reading means every seated capability set the tree actually
constructs stands independent of the others -- each domain's mask sits beside its neighbours in
the lattice rather than above or below them. So every confer chain in this tree today runs exactly
one hop, and this proposal bounds a mechanism ahead of its first real use rather than repairing an
observed fault. That is the honest reading of "vision": the ceiling is cheap to state today, before
a second or third hop is ever built, rather than reconstructed later from a chain already running
past it.

---

## Proposal 2 -- a crossover rule for when Aurora's wrap-around link earns its energy back

### Where this picks up

Row 7 of the round-one page measured Aurora's torus-versus-mesh placement in arithmetic at two
grids: at 4 cores (2x2) the wrap duplicates a link the mesh already has and the two topologies are
one graph; at 16 cores the torus reaches diameter 4 against the mesh's 6 and mean hop **2.1333**
against **2.6667** -- a fifth less average distance -- for **8** additional links
([`the-grid-that-was-already-flat.md`](../20260916/20260916-042700_the-grid-that-was-already-flat.md)).
That reading closed at hop count, since hop count is the reading a static import-weighted
arithmetic model can give ahead of a board. Row 6's own two errata separately found that **every
door this pier holds for reading a joule stays shut** -- RAPL, MSR, perf, hwmon, and a GPU tool all
closed, and cpufreq and thermal proxies closed behind them too, all seven doors held shut by one
hypervisor's passthrough choice
([`the-pier-that-cannot-hear-its-own-joules.md`](../20260917/20260917-203312_the-pier-that-cannot-hear-its-own-joules.md),
[`the-two-proxies-that-were-also-absent.md`](../../20260918-001715_the-two-proxies-that-were-also-absent.md)).
So a joule-denominated version of row 7's own hop-count finding stays unmeasured here, on this
host, today. **What this piece states instead is the DECISION RULE energy would answer, in symbols
standing in for the joules this pier holds shut** -- a rule that becomes checkable the day any pier
in this fleet answers `verdict=facility_available`.

### The first-principles model, named as a model rather than a measurement

On-chip interconnect energy for a network built of routers and point-to-point links is
conventionally modeled as **a per-hop cost**: each hop a message travels spends roughly one router's
switching energy plus one link's transmission energy, so a message's communication energy is close
to proportional to the number of hops it crosses. This is a standard simplification in network-on-chip
design (a message crossing more routers spends energy at each one) rather than a finding of this
tree's own measurement, and it is named as a model on purpose -- the crossover rule below inherits
its accuracy from this assumption and is only as good as the assumption holds.

Call the mesh's mean hop count `Hm` and the torus's `Ht`, both already measured for a given grid
(2.6667 and 2.1333 at 16 cores). Call `e` the energy spent per hop under the model above, and `M`
the number of messages crossing the network per unit time (the traffic volume). Communication energy
per unit time is then `M * H * e` for either topology. The torus adds `L` extra links over the mesh
(8 at 16 cores) at some fixed energy cost `s` per link per unit time, whether or not a message ever
uses it -- the static and leakage cost of the wire and its router port existing at all.

**The torus is worth its wrap when the communication energy it saves exceeds the static cost of the
links it added:**

```
M * (Hm - Ht) * e  >  L * s
```

Rearranged, the torus earns its keep once traffic crosses a threshold:

```
M  >  L * s / ((Hm - Ht) * e)
```

### The claim

**Whether Aurora's torus is worth building is a traffic-volume question with a computable
threshold, standing ahead of a topology question hop count alone would decide.** Row 7's own
hop-count numbers supply `Hm` and `Ht`, and `L` is countable from the same placement map. `e` and
`s` are the two terms still waiting on a source, which is exactly the reading Row 6's two errata
found closed on this pier and open on the other seven.

### First witness

A **calculator**, ahead of any measurement: a small Rye or Rishi tool that takes `Hm`, `Ht`, `L`,
`e`, and `s` as named inputs (the first three already computable from `aurora_placement_scan.sh`'s
own output; the last two left as parameters for whichever pier can eventually fill them) and prints
the crossover traffic volume `M*`. Run today, it prints a formula carrying placeholder units; run on
the day any pier answers `verdict=facility_available` for `energy_readout_scan.sh`, the same tool
takes real `e` and prints a real `M*` in messages per second.

### Horizon

One to two weeks for the calculator itself, which is arithmetic over numbers this tree already
produces. The real crossover answer waits on `e` and `s`, which waits on a pier this fleet has yet
to find -- named as open in row 6's own second erratum, and left standing exactly as that erratum
left it.

### Assumptions

The per-hop energy model holds well enough to compare two topologies on the same board, even where
its absolute joule count drifts from the truth; hop count and message volume stand as the dominant
terms, ahead of per-link distance or routing-table overhead, a balance a board built from mismatched
trace lengths could upset. `L`, `Hm`, and `Ht` come from the same placement map at the same grid, so
they describe one board rather than two.

### Falsifier

A board where the wrap-around links are physically far longer than the mesh's own links -- common in
a torus laid out on a flat chip, where the wrap must route across the whole die -- would make `e`
itself topology-dependent, `e_wrap > e_mesh`, which the model above holds constant and which would
call for a second term rather than a single crossover point. This is the honest reason the model is
named a model: it stays silent about *why* the two topologies might spend a different `e` per hop,
and a real board could show that silence costs the model its accuracy.

### Confidence

Medium for the rule's shape -- a static-cost-versus-traffic-savings crossover is a standard argument
in interconnect design, and the arithmetic composes cleanly with what row 7 already measured. Low
for any number it would print today, since `e` and `s` are placeholders on every pier in this fleet
until row 6's second erratum is answered somewhere.

---

## What both proposals share

Both proposals wait for their measurement before asking the tree to build past it. The Caravan
proposal is buildable this week because its inputs (`rights_declared`, the lattice height) are
already derived and already correct; the Aurora proposal is buildable this week as a formula and
pauses at its last two inputs for the same reason row 6 paused -- a joule this pier's doors hold
shut. That difference is the honest state of the two modules: Caravan is checkable ground today,
and Aurora stays a paper until a board exists, exactly as row 7's own confidence line already said.
A first-principles design proposal leaves the two exactly as close to metal as they stood; it names
what each one is actually waiting for.

---

*May the lattice's own height be the only ceiling a chain ever needs, and may the day a pier answers
back about its joules find this formula already waiting for it.*
