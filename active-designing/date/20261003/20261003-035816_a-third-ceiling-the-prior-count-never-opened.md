# A third ceiling the prior count never opened

**Status:** Vision -- a falsifier run on this host, reverted clean
([`../../../context/TWO_ROOMS.md`](../../../context/TWO_ROOMS.md))
**Setting:** Gauge Field - **Voice:** Kyri
**Stamp:** `20261003.035816`
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Caravan.
**Kin:** [`20261003-034214_only-one-other-ceiling-stands-between-four-and-eight.md`](20261003-034214_only-one-other-ceiling-stands-between-four-and-eight.md) -
[`20261003-033159_raising-the-ceiling-crashes-its-own-control.md`](20261003-033159_raising-the-ceiling-crashes-its-own-control.md) -
[`../../../caravan/capabilities.rye`](../../../caravan/capabilities.rye) -
[`../../../tools/ca/caravan_glow_tend_limb1_witness.rish`](../../../tools/ca/caravan_glow_tend_limb1_witness.rish) -
[`../../../src/gate/shape-caravan-max-dependents.glow`](../../../src/gate/shape-caravan-max-dependents.glow)

## What this essay answers

The prior essay named "only one other ceiling" between `capabilities.max_dependents=4` and
`regions.max_domains=8`, found by reading four Caravan constants and the single comptime assert
tying them together in `caravan/roster.rye:59`. Its own grep scoped to
`roster.rye`, `regions.rye`, `channels.rye`, and `capabilities.rye` -- the four files holding the
constants under discussion. This essay asks whether a ceiling lives **outside** those four
files, in a room only a tree-wide search reaches, and finds one: `tools/ca/caravan_glow_tend_limb1_witness.rish`
asserts the exact literal `pub const max_dependents: u32 = 4;` against `caravan/capabilities.rye`,
by name, as its own stated purpose.

## Observation -- a witness that names the constant to lock it, not to use it

Reading the witness's own header: *"Proves max_dependents=4 pedestal locks to
caravan/capabilities.rye, lowers cleanly."* Its body runs four checks in order -- a six-line
placard scan, an `example    4` grep against the Glow pedestal file
`src/gate/shape-caravan-max-dependents.glow`, a `max_dependents` name grep against the same file,
and a direct line-match against `caravan/capabilities.rye` for the string
`pub const max_dependents: u32 = 4;`. The fourth check reads the constant's *declaration text*
rather than its *value through code*, which sets it apart from the roster.rye assert -- that
assert reads `capabilities.max_dependents` as a live symbol and would recompile against any
value. This witness's fourth check is a string match against a specific digit.

Confirmed on metal: with the tree clean, `rishi/bin/rishi run
tools/ca/caravan_glow_tend_limb1_witness.rish` reads GREEN. Editing
`caravan/capabilities.rye:20` from `4` to `8` -- the same single-line edit the prior two essays
made and reverted -- and re-running the same witness stops at the fourth check, short of
the Glow lowering step:

```
caravan-tend-1: example locks to rye max_dependents...
rishi: assertion failed -- caravan-tend-1: rye max_dependents must remain 4
  at line 29: assert rye.ok else "caravan-tend-1: rye max_dependents must remain 4"
```

The edit was reverted immediately; `git status --porcelain` read clean before and after, and the
witness re-ran GREEN against the reverted source.

## Inference

**The prior essay's grep was scoped correctly for the question it asked and too narrow for the
question this one asks.** It searched the four files that *declare* Caravan's graph-bounding
constants for asserts *tying them to each other*. `caravan_glow_tend_limb1_witness.rish` answers a
different question -- it lives in `tools/ca/`, and it checks `max_dependents` against a literal
digit alone, apart from the other Caravan constants. It compares the source text of one constant's
declaration against a literal digit, for a reason the header states outright: this is the first
limb of a Glow Tend ladder whose whole point is proving a Glow pedestal shape stays locked to one
named Rye value. The witness stands as a ceiling on the *number* rather than on the *graph*,
planted on purpose so a future edit to `max_dependents` stays caught in step with the pedestal
that names it.

**This is a different fault class from the fixture the prior essay found.** `wide_roster.kyri`
assumes its own `domain_count=5` sits *one past* the old ceiling, a relational fixture whose
assumption holds exactly as long as the ceiling stays where it was. `caravan_glow_tend_limb1_witness.rish`
answers a different design again -- built to assert the ceiling's *exact current value*, a
pedestal witness made to notice a change, by design, every time one arrives. Repairing it is the
witness doing its named job, the moment the number it watches actually moves. The repair stays
one line -- `example    4` to `example    8` in the Glow pedestal, and the literal digit in the
witness's own grep -- and it is a **third** file beyond the prior essay's "whole cost" count,
because a grep scoped to the four constant-declaring files reaches what imports the constant by
name, and misses a watcher that lives elsewhere and checks by string match instead.

## Falsifier

Run directly, on a clean tree:

```
rishi/bin/rishi run tools/ca/caravan_glow_tend_limb1_witness.rish   # GREEN, baseline
sed -i 's/pub const max_dependents: u32 = 4;/pub const max_dependents: u32 = 8;/' caravan/capabilities.rye
rishi/bin/rishi run tools/ca/caravan_glow_tend_limb1_witness.rish   # stops at the fourth check
git checkout -- caravan/capabilities.rye
rishi/bin/rishi run tools/ca/caravan_glow_tend_limb1_witness.rish   # GREEN again
```

A sharper falsifier for a later lap: whether any other `tools/*/` witness, across the whole tree
rather than only the `tools/ca/` room this essay opened, carries a literal-digit lock against one
of Caravan's other three slack constants (`max_channels`, `max_regions`, `max_grants`). This essay
checked only `max_dependents`, because that is the constant the prior two essays already had open.
A tree-wide `grep -rln "pub const max_channels\|pub const max_regions\|pub const max_grants"
tools/` against every literal match would answer it; that grep stays for a later lap to run.

## What this leaves for Caravan's own lane

The repair the prior essay named -- `wide_roster.kyri` plus `roster.zig:393` -- still stands and is
still real. This essay adds a third file to the same future commit: `caravan_glow_tend_limb1_witness.rish`'s
own literal-4 grep and `shape-caravan-max-dependents.glow`'s `example    4` line, both moved to
whatever `max_dependents` becomes, in the same breath as the constant itself. Each of the three
repairs prices the cost of the day the constant rises, rather than arguing that it should; the sum
grows by exactly one file every time a fresh room earns an actual check.

Graded composite 89, letter B+, per `tools/fixtures/q/qa_report_card.sh --setting field --service
85` (register 100, reach 70, truth 100, service 85 judged).
