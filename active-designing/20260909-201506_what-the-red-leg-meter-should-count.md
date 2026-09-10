# What the red-leg meter should count

**Stamp:** `20260909.201506`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Proposed -- awaiting Keaton's word; **Room:** mixed -- the measurement is checkable, the choice between the two readings is a ruling
**Kin:** [`../construction/REDS.md`](../construction/REDS.md) row `20260909.183200` -- [`../construction/standing-equipment.kyri`](../construction/standing-equipment.kyri) -- [`../tools/fixtures/s/standing_equipment_redleg_scan.sh`](../tools/fixtures/s/standing_equipment_redleg_scan.sh)

REDS row `20260909.183200` closed a fleet-wide refusal and left one sentence standing for Keaton:
*whether the ceiling should follow a delegation one hop and count a guard proven by its child's
control.* This page brings that question the measurement it wants, and the shape of the two answers.

## What the meter counts today

`tools/fixtures/s/standing_equipment_redleg_scan.sh` reads every rostered guard, gates
`guards_no_assert` at zero, and holds `guards_no_refusal_marker` under a ceiling that only falls.
A guard leaves that count by carrying one of four refusal markers in its own body: a `prove-red`
call, a `_control.sh` invocation, a planted case, or an `== false` assertion.

## The measurement

Read `20260909.201506` at `4684216ce1`, over all 290 rostered guards:

| Reading | Count |
|---|---|
| rostered guards | 290 |
| carrying no refusal marker | 53 |
| of those, holding a `run [` in command position | **53** |
| of those, holding none | **0** |

Every guard in the counted population delegates. Each asserts on the result of a real child run, so
each reds the moment its child reds, which is what the scan's own header and the roster's seating
note both call a choir.

## Why the reading matters more than the number

The counted population grows with correct work. Rostering a delegating guard is ordinary, wanted
work, and every such guard lands in this count, so a ceiling over it refuses the fleet on the next
correct lap -- which is what happened on the second day, when `glow_rune_alphabet` took the count
53 to 54 and every ship's cold pass refused. The row repaired that instance by giving the new guard
a control of its own, which is a real repair and leaves the class where it stood.

## The two readings, and what each costs

**Keep the ceiling, repair each instance.** Every new delegating guard earns a control fixture of its
own before it is rostered. The count stays a proxy for direction, and the tree gains a control per
guard, which is worth having on its own merits. The cost is that a lap rostering a choir member
meets a red its own work caused honestly, and pays for it with a fixture rather than with a fact
about the guard.

**Move the wall to the silent guards.** Count the same 53 and report them; gate a narrower reading:
a guard that carries a marker in neither its body nor a child run beneath it, which is the guard the
tree can make speak in no way at all. It stands at zero today, so it walls hard with no slack, and
it rises exactly when such a guard arrives. The cost is that a guard delegating to a silent child
passes free -- the reading follows one hop and stops there.

An implementation of the second reading was written and proven on this pier at `20260909.191500` --
the scan splitting its count into `guards_delegating` and `guards_silent`, the witness asserting
`guards_silent=0`, and the control at 24 checks with a silent stand-in planted and lifted and a
second delegating guard proven to refuse nothing. It is **held rather than landed**: the row above parked
exactly this choice for Keaton, and a lap that answers a parked question has answered its own
question instead of his.

## What neither reading reaches

Whether a demonstrated refusal covers the class its guard claims. That stays a reading a person
does, against the standard the roster already sets: a plant the toothed form bites and the vacuous
form would have waved through.
