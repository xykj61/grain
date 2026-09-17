# The guard that cannot run in a bare tree

**Stamp:** `20260916.211800`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every figure below is printed by an instrument in this tree, and the two commands are named beside each
**Room:** Checkable
**Kin:** [`20260916-200848_the-guard-that-reads-its-own-control.md`](20260916-200848_the-guard-that-reads-its-own-control.md) -- the membership census this measurement extends -- [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) -- [`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)
**Instruments:** [`../tools/c/control_perturbation_witness.rish`](../tools/c/control_perturbation_witness.rish) over [`../tools/fixtures/c/control_perturbation_scan.sh`](../tools/fixtures/c/control_perturbation_scan.sh), proven by [`../tools/fixtures/c/control_perturbation_control.sh`](../tools/fixtures/c/control_perturbation_control.sh)

A census counted which guards in this tree read a population holding their own control, and named
one class it could not reach. This paper reaches that class, and finds two things: the class is
clean, and the reason it was hard to reach is a defect of its own.

## What the elder census could and could not say

[The membership census](20260916-200848_the-guard-that-reads-its-own-control.md) reads each tracked
`*_scan.sh`, extracts that scan's own `git ls-files` invocation, runs it, and asks whether a tracked
file of the scan's family stands in the population that comes back. It reported **375 scans, 120
enumerating, 55 self-reading, 39 holding their own control**, read `20260916`, and it named its own
blind spots rather than folding them into a zero. One of those was `no_git_population`: **198 scans**
spelling no `git ls-files` at all, most of them reading a directory with `find`.

That class is unreachable by the same method, and the reason is worth stating because it closes a
door rather than merely declining it. Measured over those 198 scans, every `find` root in the
reachable subset is a **shell variable** -- `$room`, `$DIR`, `$DESK_DIR`, `$root_dir` -- rather than
a literal path. The census admits an invocation only when it spells no variable, on purpose:
evaluating one means evaluating whatever a scan happens to hold at that line. Widening the admit
rule would resolve nothing and would run those roots blind. **Only running the scan reaches this
class**, which is what the probe below does.

## The instrument

`tools/fixtures/c/control_perturbation_scan.sh` takes each candidate, adds a detached git worktree
at HEAD in a temporary pen, and runs the scan there twice: once whole, once with the scan's family
control removed from the index **and** from the working tree. It compares the two outputs.

| Class | Meaning |
|---|---|
| `unmoved` | byte-identical -- the control's presence is invisible to the guard |
| `moved` | some reading differs, every `verdict=` line still agreeing |
| `verdict_flipped` | a verdict differs -- the guard's PASS is partly about its own instrument |

Both halves of the perturbation are load-bearing and each covers a different population. A scan
enumerating with `git ls-files` reads the **index**; a scan enumerating with `find` reads the
**filesystem**. Removing only one leaves the other population blind, and the control proves exactly
that by mutation: dropping the working-tree half stops the founding `find` shape from reading
`moved`, and dropping the index half stops a `git ls-files` scan from reading it.

A third mutation is the one worth reading, because it bites in a place the first draft aimed
wrongly. The probe restores the pen to HEAD before each candidate. Removing that restore does
**not** change any classification -- both of a candidate's runs happen after an earlier deletion, so
they shift together and the verdict survives. What it destroys is the claim that every candidate
was measured against the same tree, which shows as two candidates counting the same thing and
reporting different baselines. **A mutation aimed at the verdict passed; aimed at the baseline it
bites.**

The restore itself carried a red the control found. `git checkout -- .` restores the working tree
**from the index**, so running it while the index still lacked the previous control brought nothing
back. Reset the index from HEAD first, then check out. Repairing it moved no verdict in the live
reading, which is said here rather than hidden: the fault was real and its bite was latent.

## The reading, `20260916`

Nine candidates -- tracked scans naming no `git ls-files`, whose own `find` is rooted at the
repository root or under `tools/`, so each **can** reach a control.

| Reading | Count |
|---|---|
| probed | 4 |
| unmoved | 3 |
| moved | 1 |
| verdict flipped | **0** |
| skipped, no tracked family control | 3 |
| refused, root-finder needs a built tree | 2 |

Every figure is **free** -- nothing holds it still, and it moves as the tree grows. Run
`sh tools/fixtures/c/control_perturbation_scan.sh` rather than reading this table.

**The class the census could not reach is the cleaner of the two.** Set beside the 37 enumerable
scans the elder probe reached -- 24 unmoved, 13 moved, 2 flipping a verdict -- these nine produce
one mover and no flip. A blind spot turned out to be a blind spot rather than a hiding place, which
is a result worth having precisely because the opposite was the reasonable expectation.

## The one mover is the answer to the class, rather than an instance of it

`tools/fixtures/i/instrument_absence_scan.sh` moves: `scans_read` falls by one, and
`blind_captures_in_fixture` falls from **9 to 0**.

That second counter exists to hold exactly those nine sites. The guard reads its own control,
counts what it finds there in a **field of its own**, apart from the field reading, and its control
proves the exemption in both directions by name -- *a capture inside a heredoc does not refuse*
beside *the same capture outside a heredoc refuses*. A refusal proven in one direction cannot be
told from a hole, and this one is proven in both.

So the healthy shape is neither of the two seated doors the elder census named. **Move the plant**
takes the refusable shape out of the tracked bytes; **read past the fixtures** declares instrument
is never field. This is a third: **count your own control, in a counter that says so.** It keeps
the population whole, keeps the plant where a plant belongs, and makes the guard's dependence on its
own instrument a printed number rather than a silent term inside one.

## The defect the probe found on its way in

Two of nine candidates returned nothing either time. Both run in this tree in seconds -- 32 and 9 --
and both refuse in a pen with one line: `no tree root within 8 steps (needs rishi/bin and
tools/fixtures)`.

**164 tracked shell scripts, 74 of them `*_scan.sh`, locate the repository root by walking up until
they find a directory `rishi/bin`.** Nothing under `rishi/bin` is tracked -- `git ls-files
rishi/bin` reads **0** -- because it holds the built binary. A checkout of tracked bytes has no such
directory, so all 164 refuse before reading a file.

A script identifying its root by a **build output** has made a claim about the machine rather than
about the repository. Those two properties agree everywhere except on a tree nobody has built in,
and that is the tree every probe, every fresh clone, and every pristine-checkout reading starts
from. It is invisible from a built pier, which is where every standing guard runs.

The repair is one directory name. `rishi/src` is tracked, and both `rishi/src/` and
`tools/fixtures/` occur at the repository root and nowhere below it, so it is exactly as
discriminating and true in a built tree and a bare one alike.

**What is not wrong, checked rather than assumed.** The bootstrap is not circular:
`tools/fixtures/r/rye_build.sh` carries no root-finder, so a fresh clone still builds `rishi` and
every one of the 164 then works. The cost is **latent rather than live**. Booked at stamp
`20260916.211800` -- cited by stamp rather than by number, since the spine had yet to bind it when
this page was written, and the number it was first given went to a peer on the rebase. The sweep
crosses every lane of the fleet, so its timing is not one ship's to choose.

The probe classifies that refusal by name -- `refused_root_finder_needs_built_tree` -- rather than
reporting it blind. A refusal whose cause is named can be repaired; a blind one reads as the
scan's own fault, and the scans here are blameless.

## What this does not reach

**Whether a moved reading is a fault.** It is judgment, and the classification is what tells a
reader there is a judgment to make. The probe reports and never gates, for the reason its sibling
does: a gate here would refuse the healthy shape beside the unhealthy one.

**The three candidates holding no tracked family control** are unread rather than clean. There is
nothing to take away, so nothing can be concluded.

**The 164 scripts themselves.** This paper proves that they refuse and names the one-word repair;
it does not sweep them.

## Falsifier, run rather than named

The falsifier was: rebuild `rishi/bin` inside a detached worktree and re-run a refusing candidate;
if it still returns nothing, the root-finder is not the cause and this paper's second half is
wrong.

**It was run `20260916`, and the result is sharper than the claim.** No rebuild was needed --
`mkdir -p rishi/bin` alone, an EMPTY directory holding no binary, took
`tools/fixtures/r/rye_harness_roster_scan.sh` from its one-line refusal to `scripts=3691`. The
root-finder tests `[ -d "$_fd_root/rishi/bin" ]`, so what it asks is whether a directory exists
rather than whether a compiler stands in it.

That makes the defect narrower and the repair surer. The 164 scripts do not depend on a built tree;
they depend on a directory that only a build creates. Pointing them at `rishi/src`, which four
tracked files already keep in existence, asks the same question of something the repository
carries.
