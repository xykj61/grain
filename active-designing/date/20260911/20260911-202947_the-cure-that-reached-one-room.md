# The cure that reached one room

**Stamp:** `20260911.202947`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room** ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)):
every count below is read by `tools/fixtures/p/precondition_dependent_scan.sh` and gated by
[`../tools/p/precondition_dependent_witness.rish`](../tools/p/precondition_dependent_witness.rish)
**Room:** checkable
**Kin:** [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) -
[`../tools/g/gitlink_dependent_witness.rish`](../tools/g/gitlink_dependent_witness.rish) -
[`../tools/p/pond_display_gate_witness.rish`](../tools/p/pond_display_gate_witness.rish) -
`construction/REDS.md` rows `%646` and `%173`

## The mechanism, before anything else

`tools/fixtures/p/precondition_dependent_scan.sh` reads every tracked `*_witness.rish` and
`*_suite.rish` under `tools/`, `rye/` and `glow/`, masks comment lines, and extracts each `run
["test" "-x" ...]` or `run ["test" "-f" ...]` probe -- resolving a probe whose subject is a `let
NAME = "literal"` binding through that binding. A probed path standing outside git's own listing,
which the same runner leaves to another hand to build, is an **artifact precondition**. A test of
`WAYLAND_DISPLAY` for presence is a **display precondition**. Two gates follow:
`rostered_undeclared`, a guard the standing roster names that wants either and carries no
`capability` line in its own roster record, held at zero; and `probe_red`, the count that actually
refuse when the scan RUNS them, under a ceiling that only falls.
`tools/p/precondition_dependent_witness.rish` asserts both and is rostered `tier lap`.

## What the row left as a sample

REDS `%646` sampled 40 of this tree's unreached witnesses and ran them: 35 green, 5 red. Reading the
five, they were three different things wearing one colour -- a genuine finding, a choir whose member
fails, and **preconditions**. Two preconditions stood in that sample. One was
`gratitude/tigerbeetle/src ABSENT`, an optional submodule, and `gitlink_dependent` counted and
walled that family three days later. The other read `build wayland_seed first`, which is no
submodule at all, and nothing had counted it since.

The row's own lesson says why the count matters: **a hard assert on a precondition buys a red nobody
hears**, because the refusal makes the witness unrostable and an unrostered witness runs nowhere.
Rostering is what gives a guard its clock, so this population is a list of proofs the tree believes
it holds and leaves unrun.

## Measured, and then run

Read `20260911.190817` over **2,033** tracked runners:

| Reading | Count |
|---|---|
| dependents -- runners wanting a precondition they cannot satisfy | **10** |
| of those, wanting a built artifact | 10 |
| of those, wanting a screen | 4 |
| wanting both, counted in each | 4 |
| `builds_own` -- runners probing an untracked path they BUILD | **1** |
| `required_dependents` -- probing `vendor/`, which every clone initialises | 2 |
| `rostered_undeclared` -- the gate | **0** |
| `probe_red` -- refuse when actually RUN | **10 of 10** |

Every figure here is **walled**: the witness above reds the lap one of them rises.

## The finding the sample could not reach

**This tree has seated the cure for this class three separate times, and it reached one room.**

REDS `%173` seated `pond_display_gate` for exactly the screenless case, and its opening sentence is
*a machine with no screen is a machine, never a red*. Its build fixture exits 3 naming the absent
seam, so a headless pier reads a gate rather than a build failure. Four of the ten dependents
hard-assert on `WAYLAND_DISPLAY` anyway.

The roster's `capability` field, built `20260829`, carries six probes and is the tier for what a
host CAN DO -- `ipv6` and `qemu_riscv` are two absences already spoken in exactly this grammar.
Every one of these ten stands outside the roster, since an unrostable witness has nowhere to sit.

And `tools/equinox/witness/equinox_season_e0_witness.rish` **builds** its own `glow/bin/mod-clock`
before probing for it, saying so in its own comment: *the rung builds its own binary the same way
and keeps the reading it always wanted*. It is the ONE runner of the eleven this census looked at
that exits clean on this bench, and it is a dated equinox rung in a room a lap reaches only by name.

So the repair is settled design rather than an open question. It is a habit three rooms learned and
seven files in one family have yet to meet, and **the one piece missing was a guard asking which
witnesses still refuse.**

## The accusation the pen stopped me making

The scan's first draft read each probe and asked whether git tracks the path. Under that reading
`equinox_season_e0` is a dependent: `glow/bin/mod-clock` is untracked, and the probe is right there.
It is the worked example of the cure, and my instrument was about to charge it with the fault.

The repair is the **e0 rule**: a probed path whose own runner names it in a build invocation reads
`builds_own` and leaves the population. Proving it took two pen cases rather than one: the real file
builds `-femit-bin=${bin}` and spells the literal path on its binding line alone, so a search for
the literal lands on the binding and stops there. The variable spelling is the one the tree actually
writes, and the one the first draft passed over.

## The fault the pen found that the tree could not

The draft read bindings into one file and bodies into a second `awk` over `NR == FNR`. With an empty
first file -- a runner probing a literal path and binding nothing -- `FNR` and `NR` both count the
second file, so `NR == FNR` holds for every line of it and the entire body is swallowed as bindings.

**The real tree read 10 dependents under that draft and reads 10 under the repair**, because every
one of its ten happens to carry a binding. A population can confirm a faulty reader; a pen holding
the shape the tree has yet to write is what catches one.

## The sibling answered the opposite way

`gitlink_dependent` probed its 38 members on `20260911` and found **38 of 38 exit clean**, each
printing an honest SKIP -- so the shape reading it had carried for two days described a behavior
nothing in the tree held. This family probed 10 and found **all 10 refuse**.

Two sibling censuses, two precondition families, opposite answers, and neither could be guessed from
the other. That is the whole argument for running a population rather than reading it, and it is why
`probe` is a mode of this scan rather than a paragraph in its header.

## Why the ratchet is a ceiling and the gate is a wall

The gate is satisfiable today: no rostered guard wants a precondition it does not declare, so
`rostered_undeclared` holds at zero and the next roster row that breaks it reds on the lap it lands.
That row is the one with a real blast radius -- it would red every machine in the fleet lacking the
artifact or the screen, which is the cost `%646` names.

`probe_red` reads 10 of 10 on the day it landed, so a wall at zero would refuse ordinary work
immediately, and a wall that refuses ordinary work is a wall somebody turns off. It is a ceiling
that only falls, and it falls each time a dependent learns to build what it needs or to skip and say
so.

## What this does not reach

**Which repair each of the ten wants.** Three doors stand open, each fitting a different case. A
witness can **build** what it probes, as `e0` does, which keeps the proof and costs a build. It can
**skip honestly** -- exit 0 printing a SKIP line, as all 38 gitlink dependents do -- which makes it
rostable and gives up the proof on a bench lacking the precondition. Or it can stay unrostered and
say plainly that it proves only what it ran. Which door fits depends on whether the artifact can be
built headless, and that is seven separate readings in a room outside this lane.

**Whether the proofs are worth keeping at all.** Eight of the ten are Surface Chapter rungs from
`20260729`, and a rung whose proof has sat unrun for six weeks may want a fossil rather than a
repair. That is a testimony decision.

**The probe's own hazard**, named rather than hidden: it RUNS ten runners, and a runner may write.
Each of the ten refuses at its precondition before reaching anything expensive, and the standing
runner digests the tree at open and close, so a probe that writes surfaces as `tree_moved` rather
than in silence. A net, rather than a wall.
