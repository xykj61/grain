# Mantra's `revision` counter is a fourth live case, and it is the one still
# waiting for its own comment

**Stamp:** `20260918.060850`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- vision. Nothing here runs today.
**Room:** vision -- one proposal, waiting for its own first witness.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`../20260917/20260917-205920_the-age-that-must-not-wrap.md`](../20260917/20260917-205920_the-age-that-must-not-wrap.md)
(names the three counters and their three rules), [`caravan/dwell.rye`](../../../caravan/dwell.rye),
[`mantra/recall_lap1.rye`](../../../mantra/recall_lap1.rye)

## Where this picks up

The kin paper read three live counters in this tree and found each one already keeping to a named
rule: a position that wraps (`wrap_ring`), a history that climbs and holds
(`caravan/dwell.rye`'s `stood_longer`), and an exhaustible resource that refuses. Caravan and Tally
each declare their counter's rule in a comment placed right beside the code that keeps it. **This
proposal names a fourth live counter, in a fourth module, that already follows the second rule --
climbs and holds -- and would gain the same comment `dwell.rye` already carries.**

## The counter

`mantra/recall_lap1.rye:308` -- `sync_revision(dest, src, peer, bolt, revision: u32) RecallError!SyncReport`.
Every catalog leaf carries a `revision: u32` that a peer crossing compares and appends by
(`recall_lap1.rye:194-196`, `max_revision_for_path`). Reading across the four call sites that
advance it (`recall_catch_up.rye`, `recall_subscribe_poll.rye`, `recall_sync_wire.rye`,
`recall_two_way_sync.rye`) shows one consistent shape: a catch-up loop starts at
`max_revision_for_path(...) + 1` and climbs one step at a time toward the source's latest, always
forward, exactly the rule `caravan/dwell.rye`'s own header already states: *an age only ever
climbs.*

**What `caravan/dwell.rye` carries that `recall_lap1.rye` is still missing.** `dwell.rye:1464`
names `max_dwell_runs: u32 = 255`, and `stood_longer` asserts the incoming value against it before
returning `before + 1`, holding at the ceiling rather than letting the addition run past it
(`dwell.rye:1495-1497`). `recall_lap1.rye`'s `revision` field is a bare `u32`, carrying its own
climbing rule in behavior alone rather than in a companion constant and assert -- the one piece
`dwell.rye` already wrote down.

## Claim

**A counter that only ever climbs earns a named ceiling the day it is written.** `sync_revision`'s
`revision: u32` gains the same two things `stood_longer` already proves out: a named constant
(`max_bolt_revision` or similar) and an `assert` at the point the value is about to advance,
stating the invariant positively -- *a revision handed in already stands within the bound before
this crossing advances it* -- the shape TAME already asks for and `dwell.rye` already demonstrates.

**Why the comment earns its place.** Zig's default build traps an unsigned-integer overflow as a
runtime panic. So a peer crossing that pushes `revision` past `4,294,967,295` today meets that trap
directly at the `+=` site, a panic naming a source line. The change this proposal asks for turns
that trap into something a caller can hold: `sync_revision` returns a named `RecallError` at the
bound, the same discipline [`reds-first`](../../../.claude/rules/reds-first.md) already asks for
everywhere else -- a named error the caller catches, in place of a panic the caller can only
receive.

## First witness

A fixture hand-constructs a `BoltCatalog` leaf carrying `revision = max_bolt_revision` (rather than
looping four billion times to reach it) and calls `sync_revision` with
`revision = max_bolt_revision + 1`. The fixture asserts the new named `RecallError` fires before
any addition runs, proving the bound holds on metal rather than resting on the proposal's own
words.

## Horizon, assumptions, falsifier, confidence

**Horizon.** One lap -- the constant, the assert, and the one fixture above, on the same shape
`dwell.rye` already proves in this tree.

**Assumptions.** `revision: u32` stays append-only across every live call site, confirmed by
reading the four call sites named above, each treating a higher `revision` as strictly later.

**Falsifier.** A call site this reading missed that treats `revision` cyclically -- comparing it
modulo some period, or resetting it to zero on a new bolt -- would place this counter closer to
`wrap_ring`'s rule than to `dwell.rye`'s, and the proposed ceiling would take the wrong shape
entirely. **Now run.** The second reading (`20260918`, this lap) grepped `revision` across the
twelve `recall_*.rye` files the first reading left closed --
`recall_batch_delivery.rye`, `recall_batch_wire.rye`, `recall_beaded.rye`, `recall_by_mark.rye`,
`recall_catch_up_delivery.rye`, `recall_subscribe_poll_delivery.rye`, `recall_sync_delivery.rye`,
`recall_tablecloth_hit_census.rye`, `recall_tablecloth_query_delivery.rye`,
`recall_tablecloth_query.rye`, `recall_tablecloth_query_wire.rye`,
`recall_two_way_sync_delivery.rye` -- for a modulo, a reset to zero, or a wraparound comparison.
Every hit is one of three shapes: a field carried straight through from a `ns.Name` struct
literal or a decoded wire payload, a fixture's own literal `1`/`2`/`3` used as an ordering probe in
an assert, or `mask & field_revision` in `recall_tablecloth_hit_census.rye:123,137,185` -- a
bitfield **selector** constant (`field_revision`) gating whether the `revision` field is copied at
all, never a test on `revision`'s own value. None compares `revision` against a period, resets it,
or wraps it. **All seventeen of Mantra's `recall_*.rye` files are now read, and the falsifier did
not fire.**

**Confidence.** Raised to high that the counter climbs and holds rather than wraps: all seventeen
call sites read, all agreeing, with the second reading's twelve files adding no exception to the
first reading's five. Medium on the ceiling value itself: `max_bolt_revision` wants a real number
from whoever owns Mantra's replay horizon, since `255` was `dwell.rye`'s own choice for a
different quantity entirely -- this reading narrows the falsifier, not the missing constant.

## What this leaves standing

This is a comment and a bound, one companion to code that already keeps the rule it names. It
leaves every comparison, ordering, and replay path exactly as it stands today, and reaches only the
one edge case `dwell.rye` already teaches how to name. Mantra's real replay horizon, and how close
it ever comes to four billion revisions in practice, stays its own question, sized for a much
larger round.

---

*May this small bound find its way home the way the last one did -- named once, in one comment,
and kept.*
