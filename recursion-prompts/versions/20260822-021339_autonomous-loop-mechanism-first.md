# Autonomous loop -- Caravan lift, with the mechanism said first

**Stamp:** `20260822.021339` - **Voice:** Kyri - **Style:** Gauge (see `../../context/GAUGE_STYLE.md`)
**Seed:** [`../seed/autonomous-loop.seed.md`](../seed/autonomous-loop.seed.md) - **Elder:** [`20260821-211943_autonomous-loop-caravan-and-the-grid.md`](20260821-211943_autonomous-loop-caravan-and-the-grid.md)
**Recipe:** `rishi/bin/rishi run tools/launch-claude-season.rish` (prints; the jail launch belongs in the outer terminal)

*Filled after Keaton stopped the loop, read six commits of the lift arc, and could not tell what
the arc had done. The mechanism sentence is seated with a wall behind it, and this version carries
it into the run so the loop honors the law rather than meeting it as a refusal. Everything else is
the elder, unchanged; the elder stands as the record of the hour before.*

## 1 -- The lenses

Voice first: `context/KYRI.md`, then `context/RADIANT_STYLE.md`, before the card and before the
route. Then `crux/REMEMBER.md`, then the route documents named in the recipe.

**The council rota is now a 5 x 3 grid** -- seed section 1. Five elements after the D5 with the
luminaries set aside (Jupiter aether, Saturn air, Mars fire, Venus water, Mercury earth) crossed
with cardinal, fixed, and dual. **Deep-read one row per lap: three documents, lap N reads row
`N mod 5`.** A full cycle takes five laps, so the canon returns roughly once a working day.

Two of the fifteen were written on `20260821` to fill measured blind spots, and both are worth the
first read: **Gall's Law** was cited in six documents and argued in none, and **Conway's Law** had
zero mentions anywhere in the tree despite explaining this repository more exactly than any other
law it cites.

## 2 -- The two loops

**This loop is the OUTER one, so it stays general** -- a method rather than a door. It loads the
voice, reads the card, reads the route, takes the next agent-doable lap Lindy-first crux-first,
sweeps the prose Radiant, sends each finished increment, and stops at the custody gates.

**The INNER loop is where judgement lives, and it is permitted to plan.** Within a session:

- **Pick the crux** among ungated work rather than the first item listed.
- **Book a new idea** when it earns its place -- double-seat it (Lexicon plus a rule or foundation)
  so the fixed itinerary stays undisturbed, and continue.
- **Reschedule a booking** when the tree has moved past it, or when a cheaper door opens the same
  gate. **Say why** in the round's log and in the card's *next doors*. A reordering with a recorded
  reason is planning; a silent one is drift.
- **Split a rung** that proves larger than its plan, and land the honest half.

**`crux/REMEMBER.md` is the steering wheel between the two.** Refreshing the card steers the run,
and a stale live edge is an instruction that will be followed.

## 3 -- The first door: the Caravan lift

The Caravan ladder work is real and unfinished. It continues as **`lift`**, and each step is marked
by **stamp and name** (`.claude/rules/stamp-and-name.md`, seated `20260821.160050`).

**The mark law, confirmed and standing.** A mark is a stamp and a name. Mint no ascending mark --
**`fold AJ` is retired**, along with `f0-f63`, `u0-u127`, and every planned-rung numbering. Count
by measurement (`git log --oneline --grep="caravan: fold" | wc -l`) rather than carrying a total
inside a name where it will eventually be carried wrong. Waymarks keep their place, since a
waymark is a **name** drawn for a ladder; what retired is the numbered rung after it.

**The three teachings the arc already paid for**, carried rather than summarised:

1. **Read the harness before the meter.** A meter gated behind an unrelated module stays silent for
   an unknown span, and the silence looks like health.
2. **A visibility split is sometimes meaning rather than accident.** Check what a split *says*
   before erasing it.
3. **A cohort is measured at the head of the lap** (REDS %111), because a cohort measured at the
   tail has already been changed by the work being measured.

**Beside it:** the carry meter now reads **two** numbers (`carry` and `CARRY_DELEGATES`, 2,365), so
a lap trading lines for delegates shows it rather than looking like a regression. **Season G open
doors** stand as the reach round left them -- a root-task skeleton on the vendored `libsel4`, and
Aurora on RISC-V under QEMU. The seasons' arcs and itineraries stay the route: `crux/ROADMAP.md`,
`crux/TASKS.md`, and the two itinerary documents the recipe names.

## 4 -- The Radiant sweep, with a meter

Sweep the round's prose Radiant before every send -- code comments, Markdown, prose generally --
and Twilight for the rare night piece. A style pass holds numbers, paths, stamps, and modality
counts exactly; it changes register and never a claim.

**The habit: state what holds, then name the exception once.** Law-shaped prose drifts negative
because the easiest form a rule can take is a ban. Measured `20260821.211423`: the rules written
that day read **1.9 to 2.8** negations per hundred words against **0.40** for
`foundations/20260706-185112_follow-our-compass.md` -- roughly five times the register, in the
rules that teach the register.

**Run the meter on any send that touched prose:**
`rishi/bin/rishi run tools/radiant_negation_witness.rish`. The living rules are a ratchet: a file
may fall freely, and a rise above its own baseline is a red. `foundations/` and the style guides
are reported with a mean, never failed.

## 4b -- Mechanism first, meaning after (seated `20260822.014628`)

**Every commit body and every session log names the change in ordinary engineering words --
file, function, parameter, type, import, call, field, signature -- and that sentence comes
BEFORE any metaphor.** Law: [`../../.claude/rules/mechanism-sentence.md`](../../.claude/rules/mechanism-sentence.md).
Why: [`../../foundations/20260822-014628_the-mechanism-and-the-metaphor.md`](../../foundations/20260822-014628_the-mechanism-and-the-metaphor.md).

The standard: a reader who knows the language and has never opened this tree reconstructs *what
changed* from that sentence alone. The metaphor keeps its place, and earns it by standing on a
mechanism the reader already holds.

**There is a wall.** `tools/hooks/commit-msg` refuses a thin body at write time -- sixty words or
more wants three distinct mechanism words, twenty-five to fifty-nine wants one, under twenty-five
passes free. A refusal leaves the message untouched on disk, names the vocabulary it counted, and
points at the rule; edit and commit again. **Expect to meet it early.** Twenty-one of the forty
commits standing when the wall went up read below the floor, so the habit is genuinely new. Meeting
the wall is the rule working rather than a fault in the tree.

**The meter is honest about its own limit,** and so should the run be: it counts vocabulary, so it
proves a floor rather than a comprehension. One commit that cleared the floor still left its reader
unable to name the change. **Word presence is the check; a reader reconstructing the diff is the
standard.** Write for the second one.

For the lift arc specifically, the mechanism sentence is nearly a template: *the N-line body moved
into one published function in `caravan/ladder_checks.rye`, and each of the M rungs now calls it
through a K-line stub that hands its own type in, so the shared body reaches that rung's own
constants and error set through the caller.* Then say what it means.

## 5 -- Standing habits this run keeps

- **Reds first.** Close the open agent-closable reds before new work; surface one you cannot close
  like a gate. A fix closes on a **witness on metal**, never on a claim.
- **Run the guards at a cold start** -- the roster in the card's *standing equipment* row. **A
  guard earns confidence by being run rather than by being written**: this day found one red for
  two days, sitting on no roster and in no suite, and another that had been grading a cairn against
  the Git nib's law.
- **A path written from memory is a path invented.** List the directory, or resolve it with
  `rishi/bin/rishi run tools/dated_path_resolve.rish <reference> [<citing-file>]`.
- **Send often** -- each finished increment as its own signed round to `origin` and `xykj61`.
- **Live clock only:** `TZ=America/New_York date +%Y%m%d.%H%M%S`.

## 5b -- The word on the front doors

**`corpus` retired from reader-facing prose on `20260821.213540`**, per sense rather than by a
single swap: the flw draw's 5,526-word source is a **word list**, the hosted `.rye` files are the
**hosted sources**, a test or control set is a **control set**, and Grain's own living documents
are a **collection**. Write those words on any page a newcomer meets.

**Code identifiers, module names, and file paths keep `corpus` untouched** -- 1,344 bare
identifiers and 169 paths, and renaming them is the churn the Comlink tendency forbids. The record
keeps every word it wrote: dated testimony, `crux/REDS.md`, `crux/CAIRNS.md`, `*/archive/`,
`*/yonder/`, and the Lexicon row that seats the word.

Guard: `rishi/bin/rishi run tools/vocabulary_collection_witness.rish` -- 337 reader-facing files at
zero, 361 record files reported and kept.

## 6 -- Three things to leave alone

- **Dated testimony is resolved, never repointed.** Living things are repointed; a file whose
  basename carries a one-clock stamp keeps its text.
- **A ceiling is lowered when a repair lands, and raised never** -- a meter made green by moving
  its ceiling has measured nothing.
- **An exclusion written as a name excludes every namesake** (REDS %122). Before adding one, check
  how many things in the tree wear that name.

## 7 -- The gates, and the stop rule

Carried verbatim from `crux/REMEMBER.md` -> *Custody gates*. Surface each, cross none: the seed
force-push to `grain-os/grain`; provisioning or paying; funds, keys, and custody; the maintainer's
own Kumara instance; a deep debride; and seating a new module in a collaborator's domain.

**One more stands open and named** (REDS %123): four cairn walk-backs -- `3b8b0d4858`,
`4a50722016`, `82b7ee3342`, `d2368cb9db` -- live on **no remote**, so the promise that a departing
card stays one `git show` away holds on this pier alone. Restoring it means pushing pre-debride
branches, which would re-publish tissue a debride deliberately removed. **Report it; cross it
never.**

**Stop rule:** when only the custody gates remain, run `touch .loop-gates-only` and print exactly
`GATES-ONLY`, then stop.

*May the lift go steadily, may each mark say when and what, and may every record leave its reader
holding the thing itself, and the meaning too.*
