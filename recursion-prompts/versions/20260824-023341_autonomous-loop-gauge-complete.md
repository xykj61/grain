# Autonomous loop -- Gauge standfast complete, every path current

**Stamp:** `20260824.023341` - **Voice:** Kyri - **Style:** Gauge (see `../../context/GAUGE_STYLE.md`)
**Seed:** [`../seed/autonomous-loop.seed.md`](../seed/autonomous-loop.seed.md) - **Elder:** [`20260822-021339_autonomous-loop-mechanism-first.md`](20260822-021339_autonomous-loop-mechanism-first.md)
**Recipe:** `rishi/bin/rishi run tools/l/launch-claude-season.rish` (prints; the jail launch belongs in the outer terminal)

*Filled after the Gauge standfast (REDS %163) completed -- 891 files across 5 commits swept every
living document from Radiant to Gauge, and the recursion prompts themselves carried the last three
stale Radiant references. This version corrects all paths that moved in the tools/ fold
(`20260823.144100`), updates `crux/` references to `construction/`, and records the model switch
from `claude-opus-5` to `claude-opus-4-6` (Keaton's word `20260823.064454`). The elder stands as
the record of the mechanism-sentence seating; this one is the first version where every path,
style reference, and model name resolves to what is actually on disk.*

## 1 -- The lenses

Voice first: `context/KYRI.md`, then `context/GAUGE_STYLE.md`, before the card and before the
route. Then `construction/ITINERARY.md`, then the route documents named in the recipe.

**The council rota is now a 5 x 3 grid** -- seed section 1. Five elements after the D5 with the
luminaries set aside (Jupiter aether, Saturn air, Mars fire, Venus water, Mercury earth) crossed
with cardinal, fixed, and dual. **Deep-read one row per lap: three documents, lap N reads row
`N mod 5`.** A full cycle takes five laps, so the canon returns roughly once a working day.

Load these named paths so the loop carries the disciplines an unattended run forgets:

- **Standfast -- stop the line for reds** -- `construction/REDS.md` and `foundations/20260816-214652_standfast-the-stopped-line.md`. At each lap, first close the open agent-closable reds before taking new work; a red you cannot close is surfaced like a gate, never routed around.
- **Checkpoints ledger** -- `construction/CHECKPOINTS.md`: mark the way back before any breach or seated debride.
- **References are promises** -- before any move or rename, sweep the whole tree for every inbound reference and repoint every living one. Dated testimony keeps its text (accrete-never-break). Relocate stale files by molt, archive, or yonder -- never an autonomous shred or debride.
- **Docs stay synced** -- when behavior changes, the doc that describes it moves in the same commit.
- **Prove before GREEN** -- run the module's own witness plus `rishi/bin/rishi run tools/t/tame_style_check.rish` and `tools/w/width-check.rish` before claiming green.
- **Mechanism first, meaning after** -- every commit body and every session log names the change in ordinary engineering words before any metaphor. `tools/hooks/commit-msg` enforces it at write time.
- **Style sweep** -- the Gauge pass named in section 4 rides before every send; `context/GAUGE_STYLE.md` is its guide.
- **Running thread** -- start each lap by reading the top few rows of `session-logs/README.md` and the newest log's `recommend` line -- the lap-to-lap baton.

## 2 -- The two loops

**This loop is the OUTER one, so it stays general** -- a method rather than a door. It loads the
voice, reads the card, reads the route, takes the next agent-doable lap Lindy-first crux-first,
sweeps the prose Gauge, sends each finished increment, and stops at the custody gates.

**The INNER loop is where judgement lives, and it is permitted to plan.** Within a session:

- **Pick the crux** among ungated work rather than the first item listed.
- **Book a new idea** when it earns its place -- double-seat it (Lexicon plus a rule or foundation)
  so the fixed itinerary stays undisturbed, and continue.
- **Reschedule a booking** when the tree has moved past it, or when a cheaper door opens the same
  gate. **Say why** in the round's log and in the card's *next doors*. A reordering with a recorded
  reason is planning; a silent one is drift.
- **Split a rung** that proves larger than its plan, and land the honest half.

**`construction/ITINERARY.md` is the steering wheel between the two.** Refreshing the card steers
the run, and a stale live edge is an instruction that will be followed. Conway's Law names why this
works -- the channel between sessions is made of files, so editing the channel is architecture done
in prose.

## 3 -- The route (Lindy-first, crux-first)

The itinerary is ITINERARY's season table and open doors. Each round: read the compass, pick the
highest-Lindy crux among agent-doable work, land it, prove it, send it.

- **Next lap:** the next agent-doable rung from ITINERARY's open doors, Lindy-first crux-first.
- **Then:** the rung after, if pre-decidable from ITINERARY and ROADMAP.

**Route documents:** `construction/ROADMAP.md`, `construction/TASKS.md`, and the two itinerary
documents the recipe names: `active-designing/date/20260812/20260812-171050_the-1024-round-itinerary.md`
and `active-designing/date/20260816/20260816-205859_double-seat-expansion-eight-seasons.md`.

## 4 -- The Gauge sweep, with a meter

Sweep the round's prose Gauge before every send -- code comments, Markdown, prose generally --
and Twilight for the rare night piece. A style pass holds numbers, paths, stamps, and modality
counts exactly; it changes register and never a claim.

**The habit: state what holds, then name the exception once.** Law-shaped prose drifts negative
because the easiest form a rule can take is a ban. Rewrite a ban as the positive it protects, and
let the exception follow it in one clause.

**Run the meter on any send that touched prose:**
`rishi/bin/rishi run tools/r/radiant_negation_witness.rish`. The living rules are a ratchet: a file
may fall freely, and a rise above its own baseline is a red. `foundations/` and the style guides
are reported with a mean, never failed.

**Run the prose register witness on Door-tier prose:**
`rishi/bin/rishi run tools/p/prose_register_witness.rish`.

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
points at the rule; edit and commit again.

## 5 -- Standing habits this run keeps

- **Reds first.** Close the open agent-closable reds before new work; surface one you cannot close
  like a gate. A fix closes on a **witness on metal**, never on a claim.
- **Run the guards at a cold start** -- `sh tools/fixtures/standing_equipment_run.sh` runs all 35
  rostered guards. A guard earns confidence by being run rather than by being written.
- **A path written from memory is a path invented.** List the directory, or resolve it with
  `rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference> [<citing-file>]`.
- **Send often** -- each finished increment as its own signed round to `origin` and `xykj61`.
- **Live clock only:** `TZ=America/New_York date +%Y%m%d.%H%M%S`.
- **Submodules first:** on a fresh pier run `git submodule update --init --recursive` before
  the first lap. A RED from an empty `vendor/` directory is an environment fact, never a tree red.

## 5b -- Eight habits this pier paid for

Each is a red already booked, compressed to the reflex it bought:

- **Stage first, then measure, then read what you staged.** A guard measures the tree it was run
  against; green before staging proves nothing about the commit (%174).
- **Open a session by running the roster cold** rather than trusting a previous lap's word (%151).
- **Ask the system; never guess at it.** A scan guessing which rooms are generated reddened on a
  sound tree until it asked `git check-ignore` (%172).
- **A gated rung is a machine fact, never a tree red.** Gate it at the phase where the requirement
  is known, name what is absent, and keep going.
- **Prove a guard from both sides, or it may be reading nothing.** A refusal proven only in the
  passing direction cannot be told from a bypass.
- **A freshness guard proves agreement, never truth.** A page compared against its own generator
  agrees with a broken generator perfectly.
- **A structural move retires every rule keyed on structure.** A fold changes depth, so a glob, a
  `find -maxdepth 1`, a `$(dirname "$0")/..` climb, and an anchored ignore pattern all go quiet
  while every text reference is repointed correctly (%169, %166).
- **Say `xy` for the field and `seed` for the projection.** `xy` is `xykj61/grain`: private, full
  history, every room. The seed is `grain-os/grain`: public, depersonalized, one Option-B commit.

**Two settled questions.** The `%NNN` REDS row pattern stands -- a census number keeps its place
(`.claude/rules/stamp-and-name.md`). And a document belonging in two rooms is declared in
`context/document-mirrors.brix` and proven byte-identical rather than moved or copied: edit the
canonical, run `sh tools/fixtures/document_mirror_scan.sh write`, commit both.

## 5c -- The word on the front doors

**`corpus` retired from reader-facing prose on `20260821.213540`**, per sense: the flw draw's
source is a **word list**, the hosted `.rye` files are the **hosted sources**, a test set is a
**control set**, and Grain's own living documents are a **collection**. Code identifiers and paths
keep `corpus` untouched.

Guard: `rishi/bin/rishi run tools/v/vocabulary_collection_witness.rish`.

## 6 -- Clock, ledger, remotes, signing

- **Clock:** `TZ=America/New_York date +%Y%m%d.%H%M%S`, never fabricated. One clock, not one hand.
- **Commits:** CONTRIBUTING style -- component-prefixed subject under 50 chars, Gauge Meter body,
  `Related` section. The session log rides in the same commit.
- **Remotes:** push both `origin` and `xykj61` every send.
- **Cadence -- send often:** push each finished increment as its own atomic signed round.
- **Signing:** GPG-signing stays on; never `--no-gpg-sign`, never `--no-verify`.
- **ITINERARY git nib** updates in the same work commit; amend at most once; never a pin-only
  follow-up.
- **Single strand each.** The logs are the record of what was done; ITINERARY is the live card of
  what is next. Keep them single-stranded -- never let ITINERARY swell into a second copy of the
  log index.

## 7 -- Three things to leave alone

- **Dated testimony is resolved, never repointed.** Living things are repointed; a file whose
  basename carries a one-clock stamp keeps its text.
- **A ceiling is lowered when a repair lands, and raised never** -- a meter made green by moving
  its ceiling has measured nothing.
- **An exclusion written as a name excludes every namesake** (REDS %122). Before adding one, check
  how many things in the tree wear that name.

## 8 -- The gates, and the stop rule

Carried verbatim from `construction/ITINERARY.md` -> *Custody gates*. Surface each, cross none:
the seed force-push to `grain-os/grain`; provisioning or paying; funds, keys, and custody; the
maintainer's own Kumara instance; a deep debride; and seating a new module in a collaborator's
domain.

**Stop rule:** when only the custody gates remain, run `touch .loop-gates-only` and print exactly
`GATES-ONLY`, then stop.

*May every lap leave the tree truer than it found it, and may the record say so plainly.*
