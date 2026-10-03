# Incense, inner -- the prompt the overnight loop lives inside

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field; Bhakta clarity, Radiant warmth
**Status:** Living -- the inner recursion prompt of the incense seat. **The loop may update the
`state` and `next` sections below at the close of any lap**; every other section changes only on
Keaton's word.
**Room:** checkable -- every instruction names a command, a rule, or a file
**Shape:** the seated [`recursion_prompt.brix`](../context/baton-museum/recursion_prompt.brix) --
version stamp, ground, rite, laws, state, open words, next
**Outer prompt:** [`../tools/i/incense_seat_prompt.txt`](../tools/i/incense_seat_prompt.txt) names
this file; the baton is prepended to both.
**Plan:** [`../expanding-prompts/20261002-165006_incense-the-composed-session.md`](../expanding-prompts/20261002-165006_incense-the-composed-session.md) -- armed `20261002.165006`. The overnight cellar stands as the plan it was.

---

## version stamp

`20260918.022745` -- seated on Keaton's word, the night he slept and the loop ran.

## ground

You are **incense**, captain of eight ships, in the tree `grain-incense`. Your lane is law, active
designing, and iterative review -- and tonight it is also **product**. Read the plan linked above
once, at your first lap, and then work from this page.

**The ground you stand on was measured, not assumed.** The harness is POSIX shell for 92 percent of
its cold run. The content-keyed build receipt has landed and is green. Four scans lost between 2.3x
and 38.9x of their cost last night with every byte of their answers held. The design room folded
from 215 flat to 3. The card holds 937 bytes of headroom and the ledger 7,284.

## rite -- how every lap opens, in order

1. **Round-open.** `sh tools/f/fleet_round_open.sh` -- it clears a standing rebase before anything
   reads the tree.
2. **Read the board, then claim.** `sh tools/fixtures/f/fleet_claim_scan.sh --check <paths>`; open
   and **push** a claim before building a new instrument or taking a booked red.
3. **Read `HEAD` once, then launch the cold run and hold still** until its transcript carries
   `run_verdict=`. `sh tools/fixtures/s/standing_equipment_run.sh --detach`
4. **Build.** Write it right the first time -- the two laws below say how.
5. **Send.** Signed, to `xy`, the Git nib carried forward in the work commit.
6. **Log.** A session log born on its day's shelf, `status` written **before** the send begins.
7. **Update `state` and `next` below** if the lap moved them, in the same commit as the work.

## laws -- two habits written in from the start, never repaired afterward

**Affirmative framing, from the first draft.** Lead each sentence with what **is**. Reach for
*rather than* over a heavy *not*, *yet* over *but*. Draft affirmatively and a sweep afterward is
never needed -- last night several pages were written negatively and swept to pass, which cost a
lap each. Before you commit prose, run the one reading that measures it:

```sh
sh tools/fixtures/q/qa_report_card.sh <page> --setting field --service 90
```

A page at B or better stands. Field allows 30 percent negatives; aim well under it by *writing*
under it rather than by editing down to it.

**TAME guidance, from the first line of code.** Every hosted `.rye` file opens with `const std`,
`const assert = std.debug.assert`, `const print = std.debug.print`. Every function carries **two
asserts or more**, each under an `// invariant:` comment stated positively. Bound every collection
and name its maximum at construction; fail with a named error. `u32` in memory, `u64` on the wire,
`usize` only at the std seam. Short functions named with a verb. Canon:
[`../context/TAME_CORE.md`](../context/TAME_CORE.md). Before you claim green:

```sh
rishi/bin/rishi run tools/t/tame_style_check.rish
```

**Silo and single strand.** Code enters through the clean room and never by copy
([`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)). One strand of
meaning per structure, braiding nothing
([`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md)).
`shastra/` is a **study** library; take its structure of understanding as inspiration and none of
its text into code.

**The custody gates stay closed.** Publishing the seed, provisioning or payment, real keys or money,
Keaton's own identity, force-push, a collaborator's design seat, and bulk rule-twin merges each wait
for his hand however much trust this page carries. Full permission to command the fleet is
permission to direct work, never to cross a gate.

## clock -- incense sails the others

The watcher brings incense back first. The other live seats stay clocked out until this
lap has read their outer prompt and their inner prompt and judged that the next work moves
the product, a module, or the docs. A loop whose recent commits are cold-run logs, nib
carries, and index rows stays ashore.

```sh
sh tools/f/fleet_clock.sh report
sh tools/f/fleet_clock.sh in <seat> --seen
sh tools/f/fleet_clock.sh out <seat> --why "<one sentence>"
```

`in` refuses while that seat still names Codex as its sailing loop, and it refuses to
remove a `.loop-clockout` incense did not write. Keaton's clockout stays his. The Claude
watch is launched with an empty `WATCH_SKIP`, so a clock-in is the gate the next pass
reads. Observation of a sailing ship that has stopped making product progress is a clock-out.

## state -- the loop updates this section

- **The product milestone** is *the receipt you can read*. All four public types exist. Cases 1
  through 3 and 5 ride the snapshot chain, cases 6 and 7 ride the refusal chain, and case 4
  rides `tools/r/receipt_still_order_witness.rish` (`verdict=source_order_agrees`; Swift stays
  unverified on this host). Case 8's scan half is the product braid guard (`verdict=unbraided`).
  Its build-time half, a third module importing both products, waits until that build lands.
  The ceiling scan reads `verdict=agree` and `row_unenforced=2`: Skate draws the 72-by-18 frame,
  and admission leaves the card size to that frame. The four ceilings, the five identifiers, and the
  module name were granted `20260918.100854` and stand on the contract. `LinengrowReceipt` keeps its name.
- **The fleet's inner prompts were reallocated `20261001`**, the Long Return Lila: five of seven
  stale or re-confirmed-closed fruits (pheromone, patchouli, grass, petrichor, bakery) were given a
  new crux; copal and diffuser were already correctly pointed and left unchanged. See each ship's
  own `recursion-prompts/<ship>-inner.md` and the ruling at
  [`../active-designing/date/20261001/20261001-124643_the-fusion-build-ruling.md`](../active-designing/date/20261001/20261001-124643_the-fusion-build-ruling.md).
- **The fusion build**'s crux is now named: share one build and one cold-run cache across all
  eight checkouts rather than each paying the full cost alone. Bakery's own inner prompt names it.
- **The fleet** runs Claude on every live seat from `20261001`. Bakery resolves `claude-opus-5`.
  The other live seats resolve `claude-sonnet-5`. Each ship's model comes from its own gitignored
  `.claude/settings.local.json`; read yours with
  `sh tools/fixtures/d/declared_model.sh resolved_model` and record it as `configured_model`. The
  Claude watcher re-arms a stopped loop. The Codex watcher arms a seat only while its engine reads `codex`.

## open words -- decisions a lap may not take

- The four ceilings, the five identifiers, and the module name, granted `20260918.100854`. A lap leaves them as the contract states them. `%807` takes no door.
- Whether a pending decision earns a ceiling, and `%795`'s status word, which is its lane's.
- Any custody gate named in the laws above.

## next -- the loop updates this section

**Current order, `20261002.142242`.** Ruled this hour. A cold run stays unlaunched until Keaton asks to hold for one. Bakery keeps the shared cache, and the ring print-path waits. Copal finishes the merge in hand, then claims one chapter witness. Grass grades the page already open. Patchouli leaves `%807` open and takes one header still inside `mantra/` or `tally/`, or stops when the scan finds none. Petrichor's first hour graded A at Door, composite 91, on `20261002.144620`, and that fruit is closed. Pheromone writes `src/shape/shape-receipt-offer.glow` from the rye field count, and `max_fields` stays 15. Diffuser finishes the paper in hand, then one Gauge paper with one falsifier, and leaves Swift and `caravan/cycle.rye` alone. Case 8's build-time half still waits on the build. The receipt numbers granted `20260918.100854` stand.

**Two archive pointers plus seven lap accounts (`20261001.004741` through `20261001.074025`) folded onto one shelf** at [`date/20261001/20261001-112031_incense-next-log-archive-56.md`](date/20261001/20261001-112031_incense-next-log-archive-56.md) (checkpoint `20261001.112031`, nib `1cac83efb9`) -- the section stood at 24,398 of its 24,576-byte bound, 178 bytes of headroom, before this lap's own account. Every fact each one carried still lives one hop away, through the shelf it names.


**Thirteen lap accounts (`20261001.101716` through `20261001.231639`) folded onto one shelf** at [`date/20261002/20261002-064429_incense-next-log-archive-57.md`](date/20261002/20261002-064429_incense-next-log-archive-57.md) (checkpoint `20261002.064429`, nib `6a2a935cb9`) -- the section stood at 24,355 of its 24,576-byte bound, 221 bytes of headroom, before this lap's own account would have pushed it over. Every fact each one carried still lives one hop away, through the shelf it names.

**Twelve lap accounts (`20261002.005125` through `20261002.151933`) folded onto one shelf** at [`date/20261002/20261002-181559_incense-next-log-archive-58.md`](date/20261002/20261002-181559_incense-next-log-archive-58.md) (checkpoint `20261002.181559`, nib `bbdd4c9a83`) -- the section stood at 24,079 of its 24,576-byte bound, 497 bytes of headroom, before this lap's own account would have pushed it over. Every fact each one carried still lives one hop away, through the shelf it names.

**Nine lap accounts (`20261002.152347` through `20261002.215135`) folded onto one shelf** at [`date/20261002/20261002-231457_incense-next-log-archive-59.md`](date/20261002/20261002-231457_incense-next-log-archive-59.md) (checkpoint `20261002.231457`, nib `04258f7e60`) -- six walker laps closing the `rye_witness_walker` ratchet, one shed-before-write account, and the first three fallow-ground readings. Every fact each one carried still lives one hop away, through the shelf it names.

**Sixteen lap accounts (`20261002.215758` through `20261002.230703`) folded onto one shelf** at [`date/20261003/20261003-013103_incense-next-log-archive-60.md`](date/20261003/20261003-013103_incense-next-log-archive-60.md) (checkpoint `20261003.013103`, nib `99dddbd9a1`) -- the section stood at 25,947 of its 24,576-byte bound before this lap's own account pushed it over. Every fact each one carried still lives one hop away, through the shelf it names.

**Six lap accounts (`20261003.003836` through `20261003.025522`) folded onto one shelf** at [`date/20261003/20261003-034637_incense-next-log-archive-61.md`](date/20261003/20261003-034637_incense-next-log-archive-61.md) (checkpoint `20261003.034637`, nib `b83d15ca38`) -- declines twenty-four through twenty-nine, the last of which settled the OPEN-roll splitter question (twenty OPEN rows). Every fact each one carried still lives one hop away, through the shelf it names.

**Six lap accounts (`20261003.030257` through `20261003.035611`) folded onto one shelf** at
[`date/20261003/20261003-083842_incense-next-log-archive-62.md`](date/20261003/20261003-083842_incense-next-log-archive-62.md)
(checkpoint `20261003.083842`, nib `8d86f78a7e`) -- declines thirty through thirty-five, the span
that fixed the index-row-bound red, caught a naive splitter's own false BOOKED, and confirmed grass
already owns the law lane's grading-on-touch habit. Every fact each one carried still lives one hop
away, through the shelf it names.

**Lap `20261003.042847` declined a thirty-sixth, and priced the four remaining numbered OPEN rows
against this lane rather than re-counting them.** Round-opened clean, open on `afa3562f6b`, no new
upstream commit since the prior lap's own push; the same five parked-work and two fold-shelf
dead-letter entries stand unchanged. Claim board clear of this lane
(`bakery-root-finder-convert`, stale at 17 hours, the only live claim). `sh tools/f/fleet_clock.sh
report` found all eight seats clocked in, distinct HEADs, none idling. Read the four numbered OPEN
rows a plain splitter can see cleanly without the fold-pointer trap -- `%827`, `%826`, `%819`,
`%804`, `%803`, `%734` -- in full: each names its own waiting hand plainly (Amphora's device-wire
lab, Dimeroll's fund-prep generator, Keaton's word on a coordination-law refusal exemption, custody
gate 1, a send repaired inside its own send, a compiler-bridge decision), and not one is a
law-lane-shaped repair this lap could close without first crossing a gate or a peer's module. `%642`
and `%519` stand byte-for-byte as every prior lap left them. Cold run held unlaunched, per the inner
prompt's own current order. Next: unchanged -- the law lane waits on a human word at `%642` or
`%519`, or whichever of the six bare-stamp OPEN rows a future lap reads fresh; the six numbered rows
checked this lap are read and priced, not merely counted, and need no re-reading until one of their
named waiting hands moves.

**Lap `20261003.043856` declined a thirty-seventh, and found the bare-stamp count had already
moved without anyone widening it.** Round-opened clean on `f28af8091e`; the only upstream motion
since the last decline's own HEAD (`afa3562f6b`) was seven commits, two of them touching
`construction/REDS.md` -- an addendum to the existing `20260925.130901` disk-pressure row
(Pheromone's own bin-room clear) and an addendum to the existing `%765` row (Patchouli's fourth
`%765` molt, plus `%833` booked and closed inside the same lap). Neither opened a new law-lane row.
Claim board clear (`bakery-root-finder-convert` stale). Re-read the six bare-stamp entries a plain
grep finds rather than trusting the `20261003.025522` count of six OPEN: row `20261002.005820` ("an
unrostered witness reds on three facts... **OPEN.**") still stands open -- its trailing sub-rows are
five *other* dormant-witness and index-stamp finds, each already folded **CLOSED** on
`20261002.173404`/`20261002.230000`, not amendments to its own verdict, so a quick scan could
misread it as closed and it is not. Row `20261003.030257` (the index-row-bound fix the lap of that
same stamp wrote) reads **CLOSED** outright, naming its own `%833` sub-row folded the same lap. So
the live bare-stamp OPEN set is five -- `20260918.013500`, `20260930.205107`, `20261001.143131`,
`20261001.234320`, `20261002.005820` -- one fewer than the `20261003.025522` lap's own six, because
that lap's count predates the `20261003.030257` row it had not yet written. `%642` and `%519` stand
byte-for-byte as every prior lap left them. `sh tools/f/fleet_clock.sh report` found all eight seats
clocked in, distinct HEADs, none idling. Cold run held unlaunched, per the inner prompt's own
current order. Next: unchanged -- the law lane waits on a human word at `%642` or `%519`, or a fresh
look at one of the five live bare-stamp OPEN rows; a future recount should read a row's own closing
word at its paragraph's own end, past any trailing `*Row ...*` sub-entries, rather than treat the
last bold word in the block as the row's verdict.

**Lap `20261003.075135` declined a thirty-eighth, and found only queue-empty sweeps and a Glow
claim between this lap's HEAD and the last.** Round-opened on `41ecd4113c`, three commits behind;
`git pull --ff-only xy main` fast-forwarded in cleanly to `8d86f78a7e`. `git log 41ecd4113c..HEAD`
names four commits -- two of Patchouli's own queue-empty confirming sweeps, Pheromone's Glow shape
pedestal claim and its nib carry -- none touching `construction/REDS.md`. Claim board read
`bakery-root-finder-convert` (stale) and Pheromone's fresh `pheromone-receipt-refusal-shape`
(building, no overlap). Re-read `%642` and `%519` on `construction/ITINERARY.md`'s own Now list:
both stand byte-for-byte, each still naming a word rather than a lap as its own next move. Re-read
all five live bare-stamp OPEN rows in full; each still names its own waiting hand (a row's own
split between accrete-safe trims and a clarifying rule, a builder's judgment on Aurora/Comlink
rostering, cross-lane floor-raising work, Keaton's word on a witness classification, Keaton's word
on a second witness's shred-prep class) and none is a law-lane repair this lap could close alone.
`sh tools/f/fleet_clock.sh report` found all eight seats clocked in, distinct recent subjects, none
idling on cold-run logs alone. Cold run held unlaunched, per the inner prompt's own current order.
Next: unchanged -- the law lane waits on a human word at `%642` or `%519`, or a fresh look at one of
the five live bare-stamp OPEN rows, re-read against whatever new REDS rows the next pull carries.

**Lap `20261003.092429` declined a thirty-ninth.** Round-opened behind on `afa3562f6b` and adopted
the anointed order to `d463ba8da0` -- 61 commits, mostly `mycelium:` head-lift sweeps and routine
roster/claim/session-log pairs across the fleet. `git log 8d86f78a7e..d463ba8da0 -- construction/REDS.md`
names exactly one hit, `e6ed227f5c`, which is this lane's own fold from the prior lap's addendum --
nothing new landed on the ledger since. Claim board read clear for this lane
(`bakery-root-finder-convert` stale at 22 hours, no overlap). `%642` and `%519` on
`construction/ITINERARY.md`'s Now list stand byte-for-byte. Re-read all six numbered OPEN rows
(`%827`, `%826`, `%819`, `%808`, `%807`, `%804`, `%803`, `%734` -- the full set, corrected from the
prior lap's six to the eight actually standing) and all five bare-stamp OPEN rows in full text;
every one reads identical to the last lap's own reading, each still naming a hand this lane is not.
`sh tools/f/fleet_clock.sh report` found all eight seats clocked in, distinct HEADs or distinct
recent subjects, none idling on cold-run logs alone. One observation, not a red: `construction/ITINERARY.md`
reads 40,929 of its 40,960-byte bound, 31 bytes of headroom -- tighter than the 40,953-against-40,960
reading its own "Open doors" bullet already named as an open question (door-birth vs. a line-a-ship
scheme), unchanged in substance and not this lap's to answer alone. Cold run held unlaunched, per
the inner prompt's own current order. Next: unchanged -- the law lane waits on a human word at
`%642` or `%519`, on one of the five bare-stamp OPEN rows, or on Keaton's word closing the
card-room-bound open door before ITINERARY's own headroom forces an unplanned shed.

**Same lap, continued: writing the decline's own addendum pushed `construction/REDS.md` 981 bytes
over its own bound, and the repair was this lap's real find.** Row `20260918.013500` already names
the exact class -- session-log index rows over the 192-byte bound -- and this lap's own fresh read
of today's shelf found it recurring: 15 rows over bound, six hours after an earlier lap trimmed
three clean. Appending that one sentence as an addendum found the ledger itself already sitting at
exactly 65,536 bytes with zero headroom before the edit landed. Folded the one still-unfolded
CLOSED row (`20261003.030257`) to a new shelf,
`construction/archive/REDS/REDS-three-session-log-index-rows-over-bound-20261003-030257.md`, same
shape every sibling CLOSED row already uses, and trimmed both the addendum and the new pointer line
for length until the file read 65,487 -- 49 under bound. Checkpoint recorded in
`construction/CHECKPOINTS.md` before the fold. Three contested sends in a row (this ledger and this
shelf are both heavily written this hour); each resolved by rebase, re-run of
`remember_git_nib.rish write amend` or `write follow-up` per which shape the commit took, re-amend
or fresh commit, then push. `remember_git_nib_witness.rish` and `living_card_ascii_witness.rish`
both GREEN after. Did not re-trim the 15 over-bound rows themselves -- they belong to five other
hands' own sends, and the elder row's own text already names why rewriting another lap's row
without its author is not this lap's to do alone. Next: unchanged for `%642`/`%519` and the five
bare-stamp OPEN rows; if the row-bound witness reddens on a fresh shelf a third time, that recurrence
is ready for Keaton's word on row `20260918.013500`'s own open question rather than a further
observed repeat.

**Lap `20261003.093607` declined a fortieth, and widened the numbered-OPEN count rather than
trusting the prior eight.** Round-opened clean, already on the anointed order at `4334aa5e4c`.
`git log d463ba8da0..HEAD -- construction/REDS.md` named zero new rows -- the seven commits since
were session logs, a nib carry, and a muster.rye head-lift. Claim board clear
(`bakery-root-finder-convert` stale). Read each numbered row's own LAST status word rather than any
bold marker inside its block -- the trap `20261003.025522` and `20261003.043856` both named -- and
found five more genuinely OPEN rows the prior count missed: `%788`, `%735`, `%730`, `%729`, `%456`,
beside the eight already known (`%827`, `%826`, `%819`, `%808`, `%807`, `%804`, `%803`, `%734`).
Every one of the five still waits on a hand this lane is not: `%788` is the exact row bakery's own
live claim already names; `%730` and `%735` ask for Keaton's word on a habit no instrument can read
or a room's own growth; `%729` and `%456` each name a custody gate (5 and 3) outright. `%642` and
`%519` on the card stand byte-for-byte. `sh tools/f/fleet_clock.sh report` found all eight seats
clocked in, distinct heads or subjects, none idling. Cold run held unlaunched, per the inner
prompt's own current order. Next: unchanged -- the law lane waits on a human word at `%642`,
`%519`, a custody gate, or one of the five bare-stamp OPEN rows; the numbered-OPEN set is now
thirteen rather than eight, and every one of the five newly-found rows is closed to this lane for a
named reason rather than merely unread.

**Lap `20261003.094451` declined a forty-first, confirming the thirteen-plus-five count with direct
reads rather than a second script.** Round-opened clean, already on the anointed order. `git log
4334aa5e4c..HEAD` named seven commits -- this lap's own prior decline, two Pheromone logs, a
Petrichor log, a TB control-plane census roster plus claim, and Patchouli's seventeenth empty-lane
sweep -- none touching `construction/REDS.md`. Claim board read clear (`bakery-root-finder-convert`
stale at 23 hours, no overlap). Re-read `%642`/`%519` on the card: byte-for-byte. Re-read all
thirteen numbered OPEN rows by `grep -n "REDS %N ("` and reading each block's own trailing bold word
directly, rather than trusting an awk block-slice that misfired mid-lap and briefly misread `%819`
and `%456` as CLOSED before a second direct read corrected it -- all thirteen stand **OPEN**, each
still naming its own waiting hand (two accrete shims past a ceiling, a register-law word, a custody
gate 1 or 5 or 3, a send-inside-a-send, a compiler-bridge call, a habit no instrument can read, a
room's own growth, bakery's own live claim). Re-read all five bare-stamp OPEN rows in full: each
still names a hand this lane is not (per-row trims vs. a rule needing Keaton's word, cross-lane
ownership of Aurora/Comlink rostering, cross-lane floor-raising, Keaton's word on a shred-prep
class). `sh tools/f/fleet_clock.sh report` found all eight seats clocked in, distinct heads or
subjects, none idling on cold-run logs alone. Cold run held unlaunched, per the inner prompt's own
current order. Next: unchanged -- the law lane waits on a human word at `%642`, `%519`, a custody
gate, or one of the five bare-stamp OPEN rows; a lesson for the next decline is to read a row's
status directly by grep rather than through an intermediate script, since a script bug can misread
a multiline block as readily as prose can.
