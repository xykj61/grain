# A fourth site that would never notice

**Style:** Gauge, Field setting -- **Status:** Living, checkable -- **Stamp:** `20261003.040934`
**Kin:** [Only one other ceiling stands between four and eight](20261003-034214_only-one-other-ceiling-stands-between-four-and-eight.md) - [A third ceiling the prior count never opened](20261003-035816_a-third-ceiling-the-prior-count-never-opened.md) - [Raising the ceiling crashes its own control](20261003-033159_raising-the-ceiling-crashes-its-own-control.md)

## The question

The prior essay in this chain found a third site encoding `caravan/capabilities.rye`'s
`max_dependents=4` outside the four files an earlier grep had scoped to:
`tools/ca/caravan_glow_tend_limb1_witness.rish`, which greps the exact literal
`pub const max_dependents: u32 = 4;` out of the Rye source by name. That essay's own grep ran
across every `.rye`, `.rish`, `.kyri`, and `.glow` file in the tree for the bare word
`max_dependents` -- the search that found the third site. One more hit from that same grep went
unread: a second `.glow` gate, `src/gate/gate-caravan-dependents-bound-u32.glow`, and the witness
that drives it, `tools/ca/caravan_dependents_a1_gate_bound_witness.rish`. Does raising the ceiling
toward 8 touch this fourth site the same way it touches the other three -- by crashing, or by
staying stale?

## What the fourth site holds

```
::  invariant  answers 1 while count stays within dependents=4 (count <= 3 seats used before this one); answers 0 past the wall
::  law        caravan/capabilities.rye max_dependents below
|=  sample=@u32
?:  (gth sample 3)  0  1
```

The gate's own comment names the law it stands for -- `caravan/capabilities.rye max_dependents` --
and its body hardcodes the boundary as the literal `3`, one less than today's `max_dependents=4`.
Its witness, `caravan_dependents_a1_gate_bound_witness.rish`, drives it through
`tools/g/glow_run_worker.sh` at two sample values: `2` (expects `1`, inside the wall) and `5`
(expects `0`, past it). Neither the gate nor its witness names `caravan/capabilities.rye` as a
file to read, grep, or build against. `glow_run_worker.sh` itself was read in full for this gate's
dispatch line (it classifies `gate-caravan-dependents-bound-u32` by name into a single-sample-arg
group and nothing more); it opens no Rye source for this gate's run, and the `.glow` file carries
no `/+` import of any kind.

## The falsifier, run on metal

The question this essay asks is whether raising `max_dependents` would make this witness RED, the
way it makes `caravan_glow_tend_limb1_witness.rish` and `caravan_roster_witness.rish` RED (per the
two prior essays). The source-reading answer is no -- nothing in the gate or its witness opens
`capabilities.rye` -- and the essay tests that answer on metal rather than trusting the reading.

`git status --porcelain` read clean before this essay began. `caravan/capabilities.rye:20` was
edited from `max_dependents: u32 = 4` to `max_dependents: u32 = 8`, and
`rishi/bin/rishi run tools/ca/caravan_dependents_a1_gate_bound_witness.rish` was run against the
edited tree:

```
a1-caravan_dependents: Language EN -- caravan dependents wall of four, decided in Glow (STOA331).
a1-caravan_dependents: Lens TAME -- both sides; the family walls stand together.
GREEN: a1 caravan_dependents wall -- decides on both sides; the ladder of walls grows.
```

GREEN, unchanged, with the Rye constant sitting at 8. The edit was reverted immediately;
`git status --porcelain` read clean after. `caravan_roster_witness.rish` was not re-run here, since
the prior essay already proved its own break on this same edit and this essay changes nothing about
that finding.

## What this adds to the catalog

The two prior essays found crash sites: a positive invariant (`roster.rye:393`) and a name-grep
(`caravan_glow_tend_limb1_witness.rish`) that would each stop a raise cold, loudly, the lap it
happens. This is a different shape entirely -- a **silent** site. Its own comment still reads
`dependents=4` and its own gate still answers for a wall of 3, forever, regardless of what the Rye
source says, because nothing connects the two. A future lap that raises `max_dependents` to 8,
repairs `wide_roster.kyri` and `roster.rye:393` per the prior essay's own two-file price, and
re-runs every witness this chain has named would see every one of them GREEN -- including this one,
which would now be GREEN while describing a law the tree no longer holds.

This sharpens "the whole cost of the move" from the `20261003.034214` essay: the repair's *price*
is still the two files that crash, since a stale-but-GREEN gate costs nothing to a build. The
repair's *completeness* is a different question, and this gate is the answer to it -- a fourth file
belongs in the same future commit not because the build needs it, but because the comment and the
law it claims to enforce would otherwise go quietly false the moment the constant moves.

## Falsifier for a later lap

Whether `tools/g/glow_run_worker.sh`'s symlink step (`ln -sfn ../../caravan glow/.cache/caravan`,
read in this essay but not traced further) feeds any OTHER gate a live Rye value at build time,
which would mean this gate's isolation is a property of this one `.glow` file rather than of the
dispatch mechanism in general. Reading that symlink's actual consumers is this essay's own
unclosed door.

## Grade

Composite 83, letter B, per `tools/fixtures/q/qa_report_card.sh --setting field --service 80`
(register 50 -- above the Field ceiling of 30%, from describing two crash sites and one silent
site in contrast against each other -- reach 100, truth 100, service 80 judged). No new witness, no
new module; one tracked-file edit made and reverted on this host, `git status --porcelain`
confirmed clean before and after.
