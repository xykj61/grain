# The Ratchet and the Property It Stands For

**Language:** EN
**Stamp:** `20260825.162410`
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- the argument behind REDS %224 and the reach meter's third band
**Kin:** [`20260825-132121_a-choir-for-the-largest-unheard-family.md`](20260825-132121_a-choir-for-the-largest-unheard-family.md) - [`20260824-080208_the-roster-that-decides-what-gets-measured.md`](20260824-080208_the-roster-that-decides-what-gets-measured.md) - [`../construction/REDS.md`](../construction/REDS.md)
**Meter:** [`../tools/w/witness_reach_witness.rish`](../tools/w/witness_reach_witness.rish) over [`../tools/fixtures/witness_reach_scan.sh`](../tools/fixtures/witness_reach_scan.sh)

---

## The question

A ratchet is a number held under a ceiling that only falls. It is the tree's favorite shape for
work too large to finish in one round, and it works because the number stands for something real.

So the question this note opens on: **what happens when the number can fall while the real thing
stands still?**

## What the meter promised, and what it gated

[`witness_reach_scan.sh`](../tools/fixtures/witness_reach_scan.sh) was written on `20260825` to
answer one question the roster had been left with until then: of the 1,692 tracked
`*_witness.rish` files in this tree, which ones does a runner actually run? It came back with four
readings -- `total`,
`standing`, `sung`, `unheard` -- and put its ceiling on the last of them.

Each reading is defined honestly in the scan's own header, and `sung` is the one to read closely:
*named in an invocation position by any runner on disk, roster or choir.* A file names it. Whether
anything runs **that** file is a separate question, which `sung` leaves open on purpose.

The ceiling went on `unheard`, the complement of `sung`. So the ratchet asks: **how many witnesses
sit outside every file's reach?** Measured `20260825.152119`, that number is **937**.

## The gap, measured

Run the meter's own reachability walk from the roster and compare it with `sung`, and a third band
appears between them:

| Band | Count | What it means |
|---|---|---|
| `standing` | 168 | a roster row on the every-lap tier reaches it |
| `cadence` | 322 | a roster row on the fifth-round tier reaches it |
| **`unclocked`** | **265** | a runner names it, and no roster row reaches that runner |
| `unheard` | 937 | no runner names it at all |

Measured on this pier at `20260825.162410` by the walk the scan already runs. The four bands partition
the 1,692, and `reached` -- the two tiers together -- is **490**. So **1,202 witnesses are carried
by no clock**, against a gated number reading 937.

The 265 are real rather than an artifact of the walk, and the reason is arithmetic: a file lands in
that band exactly when the closure from every roster root stops short of it. One example reads
plainly. `tools/b/buhr_mantra_browser_view_witness.rish` is named by two files,
`buhr_mantra_browser_heads_witness.rish` and `buhr_mantra_browser_view_theme_witness.rish`, and the
roster reaches both by no path. Three witnesses, one promise, and an empty seat where the keeper
would sit.

## Why this is a red rather than a preference

A ratchet earns its authority from standing for something. The sentence
`construction/standing-equipment.kyri` opens with names the property here: *a guard that is never
run guards nothing either.* The ceiling on `unheard` stands for that property, and one file is
enough to lower it while the property holds exactly where it stood.

The move takes a single edit. Write a choir listing a hundred witnesses, leave it off the roster,
and `unheard` falls by a hundred while precisely the same set of guards runs as before. The number
improves, the ledger records a lap, and every witness that was silent yesterday stays silent.

This is the shape REDS %219 already named -- *an unheard choir is a refusal nobody receives* -- and
the meter written to close it carries the same blind spot one level up. Its own control even proves
the distinction, in the case it plants as `choir_only`: sung yes, standing no. The reading was
there all along, and the gate stood one room over.

## The repair

The ceiling moves to **`unreached`**: `total` minus `standing` minus `cadence`, which is the two
silent bands together, seated at **1202** with no slack. Three properties follow, and each is worth
saying plainly.

**It is strictly stronger than what it replaces.** Every unheard witness is also unreached, so a new
witness named by nothing raises both numbers and refuses under either gate. Nothing that used to be
caught now passes.

**It closes the move that motivated it.** Writing a choir and leaving it off the roster moves its
members from `unheard` to `unclocked` and leaves `unreached` exactly where it stood. The number
falls when a roster row lands, which is when the guards genuinely start running.

**It keeps the older reading visible.** `unheard` and `unclocked` are both printed. They answer
different questions -- *has anyone written the choir yet* and *has anyone put it on a clock* -- and
a family census wants the first when planning the work and the second when counting the promise.

## What it costs, and what it does not reach

The walk was already running twice for `standing` and `cadence`. The third band is two `comm` calls
over sets already on disk, so the scan's wall time is unchanged within measurement noise.

**It does not prove a rostered guard is a good guard**, and it never could. Reachability says a
clock carries the file. Whether the assertions inside it are worth making is the reading beside it,
taken by a person.

**It does not decide which tier a family belongs on.** That stays a cost decision, made with a
stopwatch, and the roster header holds the reasoning for each row that has one.

**The ceiling starts where the tree stands**, at 1202 rather than at zero, for the reason every
ratchet in this tree starts there: a wall that refuses ordinary work is a wall somebody turns off.
It falls when a choir lands and takes a roster row with it.

## What this changes about the next choir

The equinox family is the next door, and this reading changes what landing it looks like. **123 of
its witnesses are named by nothing and 21 more are named by a runner nothing runs**, so the family
carries **144** unreached rather than 123. Eighty of the 123 are themselves choirs -- files written
to sing a ceremony's rungs, standing off every clock the tree keeps.

Writing one more choir over them would move a large number and change what runs by nothing at all.
Landing that family means a stopwatch first -- do these witnesses still pass, and what does a sing
cost -- and then a roster row carrying whichever tier the stopwatch justifies. The gate now agrees
with that order rather than rewarding the shortcut.

## The transferable rule

**Gate the property, rather than a proxy that can improve while the property stands still.**

The test takes one question, and it is worth asking of every ratchet in the tree: *what is the
cheapest edit that lowers this number, and does that edit deliver what the number stands for?* Where
those two part, the gate is standing on the wrong reading, however honest its definition.
