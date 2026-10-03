# Raising the ceiling crashes its own control

**Status:** Vision -- a reading proven on scratch metal, outside the tracked tree
([`../../../context/TWO_ROOMS.md`](../../../context/TWO_ROOMS.md))
**Setting:** Gauge Field - **Voice:** Kyri
**Stamp:** `20261003.033159`
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Caravan.
**Kin:** [`20261003-031833_the-declarable-ring-is-twice-the-livable-one.md`](20261003-031833_the-declarable-ring-is-twice-the-livable-one.md) -
[`../../../caravan/capabilities.rye`](../../../caravan/capabilities.rye) -
[`../../../caravan/roster.rye`](../../../caravan/roster.rye) -
[`../../../tools/ca/caravan_roster_witness.rish`](../../../tools/ca/caravan_roster_witness.rish) -
[`../../../tools/ca/caravan_boot_witness.rish`](../../../tools/ca/caravan_boot_witness.rish)

## What this essay answers

The prior essay named two open questions for Caravan's own lane and left both standing: should
`capabilities.max_dependents` simply rise to meet `regions.max_domains`, closing the measured gap
directly rather than composing sub-rings around it? This essay runs that one change on scratch
metal rather than leaving it as a question, and the answer costs more than it first appears to.

## Observation -- the change compiles, one scratch declaration seats, and two tracked witnesses panic

`caravan/capabilities.rye:20` was edited on this host, in place, from `max_dependents: u32 = 4` to
`max_dependents: u32 = 8`, matching `regions.max_domains` exactly. The comptime assertion at
`caravan/roster.rye:59` (`capabilities.max_dependents <= regions.max_domains`) still holds at
8 <= 8, and the build succeeds cleanly.

A fresh scratch declaration, `_scratch_wide8b.kyri` -- eight domains, eight channels, eight
regions, sixteen grants, the same doubled-ring shape the prior essay built -- was run against a
roster binary built from the edited source:

```
$ ./caravan/bin/_scratch_roster8b caravan/systems/_scratch_wide8b.kyri
  roster for scratch_wide8b
    dependents 8 -- capabilities 16 -- declared grants 16
      alder holds 2
      ...
    the roster enforces exactly what the document permits
exit=0
```

It seats cleanly, where the same file reads `TooManyDomains` against the unedited binary. Taken
alone, that reads like the fix the prior essay asked about. The tree's own real witnesses, run
against the same edited source, tell a different story:

```
$ rishi/bin/rishi run tools/ca/caravan_roster_witness.rish
rishi: assertion failed -- caravan roster selftest exited non-zero
  at line 19: assert test.ok else "caravan roster selftest exited non-zero"
```

The binary's own `selftest` subcommand -- the step both `caravan_roster_witness.rish` and
`caravan_boot_witness.rish` run ahead of their own `TooManyDomains` assertion -- panics outright:

```
thread panic: reached unreachable code
caravan/roster.zig:393:11 in check_wide_roster
caravan/roster.zig:413:35 in run_self_test
```

`roster.rye:393` reads `assert(parsed.map.domain_count > capabilities.max_dependents);` -- a
positive invariant stating that the tree's own fixture, `caravan/systems/wide_roster.kyri`
(`domain_count=5`), sits one domain past whatever the live ceiling is, by construction. The
invariant held for every value `max_dependents` has carried until this edit, because
`wide_roster.kyri` was built after the ceiling, purposely one past it (named in the kin essay:
`tools/ca/caravan_roster_witness.rish:34` names the refusal directly). At `max_dependents=8`,
`wide_roster.kyri`'s `domain_count=5` sits short of the ceiling for the first time, the invariant's
premise turns false, and the bare, unqualified `assert` -- built to state what always holds, per
`context/TAME_CORE.md`'s "assert invariants first ... each stated positively" -- meets that false
premise with a hard panic rather than a graceful refusal. The edit was reverted immediately after
this read; both witnesses ran GREEN again against the reverted source, confirmed above the
transcripts.

## Inference

**The gap the prior essay measured carries a dependent.** `wide_roster.kyri` sits at
domain_count=5 for a purpose: it is a fixture built to prove the refusal, one domain past whatever
`max_dependents` reads. Raising the constant leaves that fixture's founding premise false rather
than letting it seat as a bonus, and a Rye `assert` meeting a false premise panics, since `assert`
is the tree's tool for stating what always holds -- a true claim stated once, rather than a check
that reports whether a maybe-true claim held this time.

**This sharpens the same shape the prior essay's own falsifier clause named and left unrun.** That
essay wrote: *"a peer who holds that `capabilities.max_dependents` should simply rise to 8 ...
names a real design choice this essay leaves open: it reads the two numbers as they stand today
... rather than arguing which one should move."* Arguing which one should move stayed out of scope
there. Running the move sat squarely in scope here, and the answer lands between the two clean
outcomes a reader might expect: the fixture proving the ceiling is load-bearing on the ceiling's
own numeric value, so a lap that raises the number owes the fixture the same attention, in the
same commit.

**The repair stays small, and it stays Caravan's own edit.** `wide_roster.kyri` wants rebuilding
at whatever the new ceiling plus one is -- domain_count=9, were the ceiling to become 8 -- and
`roster.zig:393`'s assert keeps stating the same positive invariant against the rebuilt fixture.
That is a two-file, mechanical pairing once someone decides to make the change: the constant moves
and the fixture moves with it, in the same breath rather than across two commits.

## Falsifier

The transcripts above were run against this host's own build of `caravan/roster.rye`, once with
`capabilities.max_dependents` at its tracked value (4) and once with it edited to 8, then reverted.
Both `caravan_roster_witness.rish` and `caravan_capabilities_witness.rish` ran GREEN again against
the reverted source before this essay was written, and `git status --porcelain` read clean
afterward, confirming the tracked tree carries the edit nowhere. A peer who doubts the panic
reproduces it with one line -- edit `caravan/capabilities.rye:20` and run `rishi/bin/rishi run
tools/ca/caravan_roster_witness.rish`. A peer who holds that the panic IS the correct signal here
-- that an assert meeting a broken invariant should crash loudly rather than be caught -- is
reading TAME's own design intent exactly right; this essay's claim stays narrower than that. The
crash is a cost the "just raise the constant" framing had priced at zero, which is the gap this
essay closes, separate from whether Rye's own handling of the crash is the right handling.

## What this leaves for Caravan's own lane

Whether `capabilities.max_dependents` should rise at all stays exactly where the prior essay left
it -- open, and Caravan's call. What this essay adds is the price tag: raising it reaches past the
one line everyone can see, into a tree fixture built to sit exactly one past the old ceiling, where
a bare `assert` stating that relationship positively has no soft landing once the ceiling moves out
from under it. A future lap raising the constant owes `wide_roster.kyri` and `roster.zig:393` the
same attention it gives the constant itself, in the same commit.

Graded composite 87, letter B+, per `tools/fixtures/q/qa_report_card.sh --setting field --service
85` (register ok, reach ok, truth 100, service 85 judged).
