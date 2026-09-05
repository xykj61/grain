# The Clock and the Mark

**Stamp:** `20260905.154954` -- **Setting:** Gauge, Door -- **Voice:** Kyri
**Register:** foundations -- siloed; names only our own shapes.
**Seat:** the council rota's Earth-Cardinal reading, where the concrete opens.

Two habits carry every piece of work this tree makes, and they answer two different questions.
**The clock says when.** **The mark says what, and promises only what the work can keep.**

## The clock

One clock orders everything. A stamp reads `YYYYMMDD.HHMMSS` from the pier's own zone, and a later
stamp is a later thing -- in a filename, in a ledger row, in a commit, in a log. That single
property is what lets a reader sort by hand, a tool sort by string, and a folded room stay findable
years later.

A filename carries the whole stamp: `YYYYMMDD-HHMMSS_sprig.ext`. When a room grows past its
bound, it folds to `date/YYYYMMDD/` and keeps the whole stamp in the basename anyway. The repeated
day looks redundant and earns its place three times over -- the move becomes a function anyone can
compute from the basename alone, the basename stays unique across every day, and the name still
says when and what after it leaves its folder.

## The mark

A mark is a **stamp and a name**. The stamp orders it; the name means it. Write

> the standing movement (20260821-142939)

rather than a rung number, and the mark says everything a reader needs while promising nothing it
might fail to keep.

**A counted rung asks a price, and the price is a forecast.** Announce a ladder as running from
zero to sixty-three and you have written a prediction in a place people cite. This tree has now
measured nine such announcements against what their ladders actually reached:

| Ladder | Rungs announced | Rungs reached |
|---|---|---|
| the fascia equinox | 64 | 3 |
| the MUR chapter | 128 | 91 |
| the inner scope | 16 | 6 |
| a sixteen-round chapter | 16 | two rooms of twelve |
| SOON | 64 | 0 |
| JARL | 64 | 0 |
| BUHR | 64 | 6 |
| TACT | 64 | 0 |
| DISC | 64 | 4 |

The four at the top were found by hand and written into the law. The five below stood in one living
page the whole time, where four equinoxes announced 256 rungs between them and had reached six.
Nobody was careless. A forecast written into a name is simply invisible once it is written, because
it reads like a fact.

**Count, rather than number.** A ladder's length is measured when someone asks --
`git log --oneline --grep="caravan: fold" | wc -l` -- so the answer stays true as the work grows.
A total carried inside a name stays at whatever it was the day somebody typed it.

## What keeps its number

**A waymark is a name**, drawn once for a ladder, and it keeps its draw. HAWM, STOA, and BUHR are
names rather than counts.

**A census keeps its place.** A number that counts work already done forecasts nothing, so the
ledger's `%N` rows stand exactly as written -- and a gap in them would mean a record had gone
missing, which is worth being able to see.

**Rungs already written keep every number they wrote.** Dated logs, commit messages, and witnesses
that carry a waymark and a number are testimony. The retirement reaches the *announcement* of a length, and reaches it
only in pages that speak as now.

## The test

Before writing a number into a name, ask one question.

> **Could this number turn out to be wrong?**

Work already done: no, and the number is a census. Write it.

Work still planned: yes, and the number is a forecast. Mark it by stamp and name, and count the
rungs when someone asks.

## How this is held

A meter reads every living page for an announced range and prints what its ladder actually reached,
reporting the ladders that met their announcement as loudly as the ones that fell short -- because a
reading that only accuses is one nobody believes. It stands on the roster, so the next forecast is
caught on the lap it arrives rather than months later by a hand.

## Where to read next

The full law for both halves lives in [`stamp-and-name`](../.claude/rules/stamp-and-name.md), and
the clock's own canon is [the one-clock naming law](../context/specs/20260627-102012_one-clock-naming-law.md).
The front door that leads here is the [root README](../README.md), and the room this reading opens
is [the Earth row, which breathes in](20260826-021735_earth-the-row-that-breathes-in.md).

*May every name we write promise only what the work can keep, and may the clock behind it stay
honest enough to prove it.*
