# ITINERARY -- living operator card

**Language:** EN
**Status:** Living pin -- operator carry card
**Bound:** under `living_pin_max_bytes[construction/ITINERARY.md]` (40960, raised `20260906.001901` on Keaton's word -- 16 standing directives x 512, plus **8 ships x 2,048** for the live front, plus 16,384 for the durable spine. Only the live front moved: 5,161 -> 12,814 as the fleet went three -> eight, and per ship it is steady at ~1,602. Six checkpoints record a sweep forced by the elder ceiling. The general bound stays 24,576.)
**Voice:** Kyri

## INNER LOOP -- live directives the running loop applies each lap (seated `20260816.214652`, condensed `20260824.060012`)

*The outer shell loop reads this card first every lap, so a directive here takes effect on the NEXT lap without a restart. The agent MAY edit this block -- it is the inner loop the outer loop points at.*

**Directives only.** A landed round belongs in *Prior laps* below, one line pointing at its session log. The settled decisions this block released are held word for word at [`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md), which is the record; the two walk-back nibs those rows named were rewritten by the `20260826` deep debride and are kept as testimony in [`CHECKPOINTS.md`](CHECKPOINTS.md) rather than advertised here (REDS %280).

### Standing, every lap

- **ASCII-first.** Write every new document, comment, and commit message in plain ASCII -- `--`, `-`, `'`, `"`, `->`, `<=`, `gamma_2` rather than em-dashes, middots, curly quotes, arrows, or non-ASCII math. The one exception is a named set of work rounds (a Unicode module's own fixtures). This card was corrupted to mojibake once (REDS %83). Rule: `.claude/rules/ascii-first.md`.
- **Stamp and name, never an ascending mark.** Mark a lap by its one-clock stamp and a plain name -- `the standing movement (20260821-142939)` -- rather than `Fold AI`, `f0-f63`, or `X0/X1` for planned work. Count a total with `git log --grep ... | wc -l`. Waymarks stay (names, not counts); `rung` stays where a real ladder exists in code. A room that outgrows a reader folds to `<room>/date/YYYYMMDD/` keeping the WHOLE stamp in the filename, and a stale reference is resolved rather than rewritten -- `tools/d/dated_path_resolve.rish`. No fold ships without `tools/d/dated_path_witness.rish` GREEN, and a REDS fold runs through `tools/fixtures/r/reds_fold.sh`. **Waymark rungs are the retired form too** (%329): mark a rung by waymark, module or plain name, and stamp -- `FORA<N>`-shaped counters red `tools/w/waymark_rung_drift_witness.rish`, whose ceiling only falls. New `equinox_eNNN` guards take stamp-and-name (%330 books the family rename). Rule: `.claude/rules/stamp-and-name.md`.
- **The amend behind the empty-index check and its own target** (%255; %331): between commit and amend, `test -z "$(git diff --cached --stat)"` AND HEAD still equal to the hash read at the commit -- an amend resolves HEAD when it RUNS, and a peer landing between the calls puts your line into their commit.
- **Fetch-before-book** (`20260827`, %230/%252 closed): read a REDS row number only after `git fetch xy`; a collision renumbers to the fetched head.
- **Spelling: American.** `color` never `colour`; normalize on touch.
- **Style sweep before every send** -- Radiant pass over the round's prose (Twilight for a night piece), register only never a claim. Seed section 6.
- **Rota of the canon.** Each lap, deep-read ONE ROW of the 5 x 3 council grid in `recursion-prompts/seed/autonomous-loop.seed.md` section 1 -- lap N reads row N mod 5, three documents, so the canon returns roughly daily.
- **Roster cold, then hot -- and hold still while it runs.** Open the lap with `sh tools/fixtures/s/standing_equipment_run.sh`, let it finish; run again after `git add` as `... --hot` so the green measures the tree the commit ships (%174). A cold open over a dirty index refuses under `run_verdict=lap_unclosed`; `--hot` claims a round's own staged paths, and the flags compose (%223). The runner digests the tree at open and close, refusing `tree_moved` when they differ; editing it mid-run kills the shell (%221). **`--scoped`** (the fusion, granted `20260828`, landed `20260829`): a cold open or rebase re-verify with a FULL green receipt reproves only what moved since its head; skips named per guard, unmapped always runs, hot close and cadence stay full (receipts chain from full greens alone). **Counts come from the scan, never here.** Roster `construction/standing-equipment.kyri`. A `tier` names its clock: absent or `lap` every run, `cadence` the fifth round, when `--all` sings the choirs. A tier is a cadence, never an exemption; an unknown word refuses at zero.
- **A lap ends at the commit, never at `git add`.** `tools/hooks/pre-commit` regenerates `README.md`'s metrics block and `docs-geode/libraries/README.md` when a round adds a witness, and it fires at `git commit` and `--amend` **only** -- cherry-pick and rebase skip it, so `tools/hooks/post-commit` records the debt in `.git/` and rule one pays it next commit (%339). A round that stops after staging leaves both pages stale and any newly cited file untracked -- three times now (REDS %188, %220, %223). No guard can enforce the close, since one would have to run after the lap ends; what a guard can do is refuse to open the next lap over the wreckage, which is `staged_uncommitted` on line one and `run_verdict=lap_unclosed` when a full-roster pass meets a dirty index without `--hot`. **A dead lap leaves no dirty index** -- its leavings are stashed, and a stash is neither tree nor index; open with `git stash list` (%321).
- **Grade what you touch.** Every document, comment block, or design the lap opens gets one reading: `sh tools/fixtures/q/qa_report_card.sh <path> --setting door|field|meter --service N`. Four readings meaned to one grade -- Register, Reach, Truth (a gate: under 60 reads F), Service (judged against this card, in four questions worth 25 each: named, reached, current, and which side it carries -- public `grain-os/grain`, working `xy`, or both). **B or better stands.** Below B pushes **one** molt frame onto the round's stack, worked down before the sweep resumes; the stack is **bounded at depth 2**, and anything deeper becomes a line here. A dated writing leaves a mutant plus a bannered fossil and a Class M row; a living path molts in place under a checkpoint. **A low grade is not a red** -- Standfast owns what is wrong, this owns what could be better. **Match the setting to the class:** a pointer card reads `meter`, and a program is graded on its comments rather than its code (%276). Rule: `.claude/rules/quality-assurance.md`.
- **Reds first.** Close open agent-closable rows in `construction/REDS.md` before new work; one you cannot close surfaces like a gate.
- **Raw transcripts land in `session-output/`** (gitignored, `20260828`): each loop tees its outer transcript to one per-seat file, overwritten in place -- `mkdir -p session-output && <loop> 2>&1 | tee session-output/<seat>.txt` -- so agents read a peer's full output by path, not by paste.
- **Read scope -- open shelves and closed stacks** (`20260827.155213`): walk the open shelves; fetch a closed stack only by a named path -- every `date/`, `archive/`, and `yonder/` shelf, plus the rule's named roster. Never `ls` the root (`MAP.md` is the walk), never walk `tools/` whole (resolve by name), scope greps to the lane's rooms -- the whole-tree reference sweep before a move stays whole-tree by law. **A jailed inner lap (Mind's Codex) proves scoped witnesses only; the cold/hot roster rides with the pier and the unjailed benches.** Rule: `.claude/rules/read-scope.md`.
- **A fresh clone inits its submodules first, and a global `insteadOf` will stop it.** The vendored rungs need `vendor/{microkit,monocypher,pqclean,sel4}` checked out, and a RED from an empty `vendor/` is an environment fact rather than a tree red. A host that rewrites `https://github.com/` to ssh (this bench does) cannot clone the public third-party submodules at all, since the key has no rights there -- `GIT_CONFIG_GLOBAL=/dev/null git submodule update --init <path>` clones each one over plain https without touching the host's config. `--init --recursive` aborts on the first unreachable repository and leaves the rest untouched, so name the paths.

### Seated, and still live

*The panchanga, the fusion build, and the landed arcs rest on the [fourth shelf](archive/20260831-090000_itinerary-settled-decisions.md).*

- **The counsel campaign, Phase 1 standing** (`20260828`, Keaton's word): a lap may lift counsel insights into their right rooms as fresh-stamped mutants (B-door QA), banner the elders, Class M the rows -- `tools/fixtures/c/counsel_census_scan.sh` orders by citer count (941 pieces, 325 cited, 616 orphans at seating); the fourth shed circles on the word; **deep debride declined**.
- **An operational shell script molts to Rishi on substantial touch** (`20260828`): launchers, loops, tools a hand runs -- the `.sh -> .rish` family the MIND adaptation mapped, generalized; scan and control fixtures STAY sh by the witness convention.

- **The three Earth ships** (`20260904` names): unattended Claude Code; field GUI `~/grain` Cursor. **Incense** law/review/captain, `grain-incense`; **Pheromone** molecular, `grain-pheromone`; **Petrichor** docs-geode and prose-product, `grain-petrichor`. Machines are doors. Captain prompt (two doors, Mac or Dallas pier): `expanding-prompts/20260904-171306_incense-the-field-captain-two-doors.md`. Loop `fleet-loop.sh incense|pheromone|petrichor` from that tree (`tools/l/launch-earth-ships-chapter.rish`). One writer per tree (%291). Parked: `~/grain-mystery`, `~/grain-silence`. Elder charter `20260829.203718` stays testimony.
- **Fleet re-arm**: `sh tools/f/fleet_rearm.sh`.
- **SEATED -- Pond completes the enclosure** (`20260826`): the quest retiring ai-jail; docs accrete-only until the replacement is audited; switchover and jail debride gated (%5). Plan: `expanding-prompts/20260826-033051_pond-completes-the-enclosure.md`.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `bfafcce7d4` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- NINETEEN ORPHANS WERE THREE KINDS, AND ONLY SIX WERE A LAP.**
Elder [shelved](archive/20260908-025257_itinerary-landed-accounts.md).
**`%592` ASKED FOR A FLAG THAT ALREADY EXISTED.** It booked
`tools/fixtures/s/stash_record_scan.sh` for printing `orphans=19` and no path -- yet `... list` has
named every orphan since `%510`, and the open printed that command beside it. **What a hand GOT was
nineteen paths wanting three actions with nothing telling them apart**, read past by every ship
for a day: **10 fold shelves** whose rows come off the living pin (checking one out
is a rollback), **3 copies of this guard's elder self** at `tools/fixtures/f/` from before the room
fold, and **6 files of parked work** -- only those six a lap. The scan classifies each
`moved:<path>` / `shelf` / `work`, asserts they partition the count, and the open names it.
**TWO SHAPES WERE MEASURED AND REJECTED FIRST.** A blob lookup is exact where a basename guesses, and
matched **zero of nineteen**: a file that moves rooms here is edited on the way. On cost, one
`awk` per orphan took the open **1.4s -> 3.0s**, a doubling every ship pays every lap; a fixed
`grep` was **worse, 4.4s**; the walk defers and ONE `awk` does all: **1.5s**. **26 new legs, 51
elder unchanged, 77 GREEN.** `%592` **CLOSED**.
**Taught:** *a count with names is one nobody acts on, if they cannot be triaged.*
**5 RED ACROSS BOTH PASSES, ALL CLOSED -- AND ONE REPAIR WITHDREW.** `shell_dialect`: two bare
`sed -i` in `amphora_mark_wreck_witness.rish`, GNU-only. I rewrote them redirect-then-cat; the
rebase brought **a peer's cure, published first and better** -- the tree's own `sed_inplace`, and
the plant split from its reading, which mine left in one `&&` chain (`%519`). **Theirs stands, mine
withdrew.** `index_row_bound`, a duplicate row and two misordered, repaired by
`index_shelf_repair.sh`.
Hot: `fold_shelf_link` -- **my own shelf, the depth loss DIFFUSER booked** -- an `archive/` link
copied a directory down; `fold_shelf_link_repoint --apply`. `standing_equipment` reds while any do. **My draft reached for the same trap:** `sed 's/^/T\t/'` inserts a literal `t` on the Mac door -- a wrong answer a partition check cannot see, since it still
sums. `awk` tags now.
**Next:** land the six; `standing_equipment_yield` in `stash@{2}` is the largest.

**PATCHOULI -- A REPAIR MOVED THREE FOLDS AND ONE HEADER; THE OTHER HEADER KEPT A SPENT REASON.**
Elder [shelved](archive/20260908-031547_itinerary-landed-accounts.md). Row `20260908.031547`
**CLOSED**. `%590` moved `union_into` and **both** of `annotate`'s folds to a binary search and
rewrote **`merge`'s** cost paragraph. `annotate`'s stood at *|self| x |other| text comparisons* --
and kept its elder REASON three lines above two sorted copies: *a weave carries no index, and a map
earns its place when a measurement asks for one*. **The measurement had asked and been answered in
that same commit.** A stale number is a small wrong; a stale reason **teaches the next reader not to
look**. Caught by its own helper contradicting it eleven lines below. **Lantern, not loom:** `Cost
is` reads **16 sites in 15 files**, one stale. Measured, two disjoint sides, best of 3, fast/checked:
**3/37, 6/76, 13/154, 28/322, 132/1,464 ms** at 16,384 -> 524,288 a side -- **2.1x** a doubling,
**4.7x** on the fourfold step. Linearithmic, and 524,288 a side IS `max_weave_lines`.
**A RED I CLOSED, AND MY CURE WITHDREW WHOLE.** `shell_dialect` red at **zero slack**: two GNU-only
`sed -i` plants landed in `amphora_mark_wreck_witness` at **01:59**, first heard at **my 02:42 cold
open** -- **43 minutes and one ship later**, because the family is checked by a 25-minute roster
pass and the lap that breaks it is **never** the lap that hears it. I rewrote both inline and proved
each still BITES by disarming its pattern in a copy; the rebase then brought **a peer's cure,
published first, calling `shell_portable.sh`'s shared `sed_inplace`** rather than spelling the
temporary twice. **Theirs reads better and stands; mine withdrew.** **Twelfth collision, fourth where
two ships found one FAULT rather than one number.** `index_row_bound` stands mine: one duplicate,
four misordered rows on the shared shelf, closed by `index_shelf_repair.sh`. Hot pass **178 of 183**;
the two are `stash_record` and the roster reading it.
**Yours:** a **pre-commit** dialect read over staged shell would close that 43 minutes to zero.
The **anchor** stays the lane's crux -- and it is `diff.rye`'s own named seam, **Keaton's word
rather than a lap's**. `stash_record` stays another seat's (`%592`).


**DIFFUSER -- ALL THREE FALSIFIERS ARE RUN, AND A LEG PROVED ITSELF BY A BROKEN COMMAND.**
Elder [shelved](archive/20260908-031940_itinerary-landed-accounts.md), holding falsifier one whole.
**`%499`, SEVENTH PARK:** that lap -- paper, log, shelf, GREEN -- sat in `stash@{0}` on the SAME
base as HEAD, and `stash_record` read `unlanded=1` for it. One `git stash pop`, no conflict, now
**`unlanded=0`**. Recovery is cheap; the park is not.
**THE PARENT'S THESIS MOVES, SMALLER.** [Addendum](../external-research/20260905-232224_the-bound-that-names-a-joule.md)
**A 95**: novelty gone -- `harvest.rye:134` already carries the wake-and-rate shape -- and the joule
is a direction rather than a checkable quantity, since compute's share belongs to the schedule.
What strengthened is what it never argued: **6 of 47** time constants bounded (**12.8 pct**) against
**40 of 44** on the extent control, and **16 `std.Io.sleep` sites** choosing a clock in silence.
**AND THE `sed -i` LESSON HAS A THIRD FACE -- FOUND TWICE, PUBLISHED ONCE.** `shell_dialect` read
**2 of 0**, both an hour old in `amphora_mark_wreck_witness.rish`. One is worse than dialect: plant
and reading shared one `&&` chain under `assert elder.code != 0`, so **any** editor failure passed
it -- and BSD `sed -i` without an extension always fails, so on the Mac door that refusal proved
itself by erroring. I split it and made both sites portable, GREEN. **The rebase brought COPAL's
identical cure, published first**, reaching the tree's own `sed_inplace` where mine hand-rolled a
temporary, and citing `%519` for the shape. **Theirs stands; mine withdrew whole.** Twelfth
collision, and the **second** where two ships found one FAULT rather than one number -- I named the
risk in this block before the rebase, and naming it did not avoid it.

**PETRICHOR -- A PAGE ABOUT ABSENCE, SAID IN WORDS THAT ARE PRESENT.**
Elder [shelved](archive/20260908-030301_itinerary-landed-accounts.md). `docs-geode/etc/README.md`
read **D+ 69** on **71% of 7 sentences**, under the **8-sentence floor**, so
`prose_register_scan` read it **unreadable** -- a door outside its own meter.
**EVERY CLAIM HELD; ONLY THE FRAMING TURNED.** *belongs on none of its shelves* became *fits
outside all of its shelves*; eleven genres became **eleven rooms standing beside this one**,
checked with `ls`. Splitting the closing beat out of its bold paragraph moved **Reach 50 ->
80**. **D+ 69 -> B+ 89**, register **29 -> 100**, shadow **A**, re-measured before landing.
**IT LANDED ON THE THIRD ATTEMPT -- WHAT `%499` COSTS.** Repaired **twice and parked twice**:
`stash@{1}` at `030459` reached **B+ 89** with the room token, then `stash@{0}` at `031332` **redid
it from scratch** and reached only **B 84** -- worse, because a parked lap is invisible to the next. `fleet_round_open.sh` writes to the box and `stash_record` reports
it; **no step reads one back**.
Recovery: one `git checkout stash@{1} -- <three paths>` -- the price is rediscovery, never repair. **Yours: should the open OFFER the newest stash standing on this base?**
**MY OWN ROOM IS SILENT:** of **37 living `docs-geode` pages, 1 names its room**, and the doorway
guard reads only `external-research/`, `active-designing/` and `docs/`. Token given to the page
I touched; the gate left alone. **Yours:** the door law's reach into `docs-geode/`, and the 55-page
net demotion.
**PHEROMONE -- A LANTERN THAT FIRED FOUR TIMES WAS UNDERSTOOD ONCE.**
Elder [shelved](archive/20260908-021504_itinerary-landed-accounts.md). Row `20260908.021504`
**CLOSED**, [folded](archive/REDS-a-lantern-that-fired-four-times-rows-609.md); booked `%602`,
renumbered twice on two rebases; the number is a view and the stamp is the key.
**MY FIRST LAP WITHDREW WHOLE** -- both halves published by peers first, their fix for the second
beating mine: a bare `say scan.out` opens no `StrBuf`, where my bound truncated a diagnosis.
**WHAT SURVIVED IS THE QUESTION IT LEFT.** Rishi composes an interpolated string into a fixed buffer
(`rishi/src/main.rye:3101`), so `say "x -- ${scan.out}"` promises a scan's output stays under 4,096
forever while it grows; `reds_spine_derive` passed every assert and died reporting. **Four hands met
it four times** -- one class read as four accidents.
**502 SITES MAKE THAT PROMISE, 1,744 A WORSE ONE** -- an `assert ... else` composes only on FAILURE,
so the message that cannot be built is the one describing a disagreement. Ten named a pass; the
width is **read**.
**THE CEILINGS ARE SHARES, LEARNED WATCHING MY OWN DRAFT REFUSE:** raw ceilings at the measured
counts, and this round's own rebase brought two peers' guards in and reddened over the most ordinary
act here. A per-mille share asks the habit -- a pen quadrupled without changing how it writes reads
the same number. Control **33**, `tier lap` 5.7s.
**Yours:** `main.rye` inlines a model `weave.rye` owns -- port or drop?

**INCENSE -- A SEAT SEATED LAST NIGHT ON A NUMBER ITS OWN INSTRUMENT REFUTED BEFORE MORNING.**
Water's cardinal seat, taken on your word `20260908.001350`, cites *30 tools write to the tracked
tree and 3 prove they converge* (`20260907.234808`). Water's instruction is to run the actual thing,
so I ran it: `tools/c/convergence_census.sh` answers **7 candidates, 3 proven**, and three of the
seven are libraries or a remote-reading scan -- **one real document writer**, proven `converges` on a
sample that triggers it rather than the `inert` a dead sample would earn. The denominator was wrong
**four** times in three laps, not the two its roster note claimed.
**THE SEAT STANDS; ONLY THE FIGURE MOVED.** What justified it is that this tree states an
idempotence claim in a foundation and proves it in almost nothing -- one writer says that as loudly
as three of thirty. Corrected in the three living places that teach it, each now telling a lap to
**run** the census rather than read the sentence about it.
**The lesson is the stamp.** `Measured <stamp>` reads as a fact with provenance, and is one; what it
cannot say is that the reading still stands -- so here a stamp made a superseded number look **more**
checked than a bare one would have. **Yours:** sixteen such claims stand across twelve living law
pages, every one a command away from being current. Worth an instrument, or worth reading by hand?
**Elder INCENSE accounts condensed** (cairn `20260908.030324`): the doorway ratchet `20260907.192800`
**BOOKED** and the two `stash@{0}` reds `20260907.180000` **CLOSED**, both
[shelved](archive/20260907-192800_itinerary-landed-accounts.md). Their open question stands: at its
floor of 3 the doorway ratchet is **a gate on new writing in a ratchet's clothes**, on `tier cadence`,
so a stranger meets the refusal rounds after the hand that earned it.

**`%499` OPEN, having parked one lap of mine twice, COPAL's once, and both laps recovered here** --
discriminator on [the shelf](archive/20260907-154440_itinerary-landed-accounts.md); COPAL asks it in
full below.
**Yours, and shelved to hold this bound:** the `mycelium` Door-negatives reading, whole on the
[shelf](archive/20260907-192800_itinerary-landed-accounts.md).


**`%481` CLOSED, both accounts folded** ([shelf](archive/20260906-133957_itinerary-landed-accounts.md)) -- **a marker makes a pin longer, so the one meter aimed here read the damage as growth**, three firings, the last caught before its push.
**AND THE EQUALITY ARC HAD NO RUNNER FOR 7 OF 8** -- `%482` **BOOKED**
([shelf](archive/REDS-a-proof-nobody-runs-rows-482.md)). The four Mantra gates build GREEN,
**unheard rather than rotted**, now `tier cadence` 92s; Aurora's three and Caravan's one stay
unheard. **Yours:** `src/gate/README.md` graded Truth **100 on twelve resolving paths** over seven
unrun proofs.
**The identity gap** -- two branches inserting collide at one small integer and merge refuses them
`PositionTextDisagrees`, since `pos` counts inside one weave. Closing it wants a wider `Line`; the
guard said to lock that is `%500` above, and it now reds honestly.
**`%440` fired ELEVEN times across four laps** -- a peer's row low at the cold open, then every rebase auto-merging the shelf; one dedupe-and-sort each time, by hand. **Yours.**

**`%460` OPEN, yours:** may a cross-target witness read GREEN with a named gap when qemu is absent? `%446` reads the other way; `capability` is the mechanism ([shelf](archive/20260906-051500_itinerary-landed-accounts.md)).

**GRASS -- THE FLOOR PRINTED A REFUSAL IT NEVER PERFORMED.**
Elder [shelved](archive/20260908-035300_itinerary-landed-accounts.md). Row `20260908.035300`
**CLOSED**. `mandi_core.rye` signs with `listing_seed = .{0x67} ** 32`, a **source constant**,
so any reader signs a listing `verify_listing` takes. Its case flipped a `stamp_sig` character
and printed `lying listing refused`. **A flipped byte is corruption: that proved integrity** --
and **no meter reads it**: a true sentence about a real case reads green. Fixed by
**showing**: a second listing at another price verifies. **7 MALA swept, 27 left. Mine:**
shelf links a directory deep; a regex taking COPAL's.

**COPAL -- A RATCHET COUNTED THE POPULATION IT WAS MEASURING, SO WRITING A NEW RULE REFUSED THE
TREE.** Elder [shelved](archive/20260908-041510_itinerary-landed-accounts.md). Row
(`20260908.034712`) **CLOSED**, [folded](archive/REDS-a-ratchet-that-counted-its-own-growth-rows-610.md);
booked `%608`, renumbered TWICE in one send -- **the earlier stamp yields to the published
number** (`derived-spine` 3). Cold: `rule_twin gated`, **38 of 51 against 36** -- **its own 40
elder pairs IMPROVED 36 -> 35.** One figure answered two questions, *did a pair drift further* and
*how many are there*; only the second moved.
**THE REPAIR IS NOT A LARGER NUMBER.** `rule_twin_cohort.txt` names the seating day's 40 pairs -- a
closed day's census that never grows, CONTENT rather than a git query since history gets rewritten. **`cohort_drifted` gated at 35, both sides; `arrival_drifted` reported by name,
never gated** -- reconciling decides which of two LIVE sentences is law, gate `%7`, so gating
growth refuses writing a rule. **8 of 11 born since arrived AGREEING, 5 of 40 elders.**
**Yours:** all three drifted arrivals are a CONDENSED Cursor twin -- transform, or drift? **`%569`;
`%499`; LOCA.**

**MANY HANDS** (`20260828`): custody MANUAL, one writer per checkout; every clone seats `ww`
(gate %1) and `.git/ssh_config_jail`.

**Sibling finds:** Mystery's module-label guard fails open on BSD grep; portable, it names elder labels in `fascia_metric_v0.rish`. **Tablecloth, one, cross-lane:** its name desk
reads one of `max_name`'s two call sites (`parse_manifest` reads it too, over the same fixed
`[max_name]u8`). *The four uncontrolled `*_example_missing` verdicts are no longer a find: the work
stands written at `cc1da84f7`, parked by a round-open and unlanded since `20260905` (`%499`).* **Dream's parked packages:**
`xy/pier/diverged-20260831-{064342,115245}`, neither landed, neither mine. **CION:** `drey`'s rung marks are the retired form (%329). **Fleet loop (%387):** should a
round's opening stash stop an in-flight pass in its own tree.

**Bounds raised `20260906`, both derived, both yours:** card and REDS pin to 40,960 (8 ships x 2,048 live front; 8 x 4,096 OPEN set + 8,192 header). **Each is sized per ship, so both re-open at twelve** -- and the pin's is also sized by how fast reds close (`%360`, 8,213 bytes, open since `20260830`).
**`%456` OPEN -- eight ships share ONE login, so one credential is a fleet-wide outage** (read from `agent-jail.sh` source, so `%458` leaves it standing; the pier half is unmeasured from inside the enclosure). Seven died 3 laps each in ten seconds on `OAuth session expired and could not be refreshed`. The refresh token had **27 days** left, so expiry is excluded -- the leading read is **rotation**: first refresher strands the rest and the pier's own copy. **Falsifier is cheap:** watch whether the pier's refresh value changes after a ship refreshes. Landed: `claude_refresh_dead()` names a dead credential instead of seeding it, proven 3 ways, and `sh tools/fixtures/f/fleet_login_scan.sh` answers it in one command. **Yours, gate 3:** one login per ship is the fix. **A resource shared by every ship has no blast radius smaller than the fleet.**
**`shell_dialect` re-diagnosed:** the `sed -i` repair stands; it reds on ONE case of 47 -- *a guard
without its instrument names rg rather than a file*. `shell_portable_control.sh` takes `rg` off PATH
by dropping every entry holding an executable `rg`, and this NixOS pier keeps `rg` and `sh` in one
directory, so the scan under test cannot start. A pen of symlinks to every tool but `rg` is the fix.
**Cold pass `20260908.005417`: 182 guards, 1361s, 3 gated** -- the roster grew 155 -> 182 in two days and its wall time held.
**`%439`-`%441` FOLDED** to one [shelf](archive/REDS-what-no-meter-was-reading-rows-439-441.md): three claims where no instrument reads.
**`%360` advanced twice more** (`compass_rose`, `standing_equipment`): `unheard` **674** of ceiling
**1,093** -- 419 of slack; the elder *14 under* is superseded. **Yours.**
**Still open:** `glow/rune_shape.rye` width custody; `%281`/`%291`. **(%347):**
`pond/enclosure_policy.kyri` 8,120/8,192; yours.
**THE LIVE FRONT NOW FOLDS** (`20260905.130819`): landed accounts shelve like REDS rows, so the
card holds what is OPEN and what waits on your word.
**Gate 3 stands:** `.gnupg-rye/` holds
`private-keys-v1.d/`, and **per-tree GNUPGHOME is the only shape that works jailed** -- yours.
**52 external utilities across 2,969 tool scripts. `rg`: 992 sites, ONE probe. `mktemp`: 353
sites, none -- not POSIX since 2008.** The cure, `tools/fixtures/s/shell_portable.sh`, is sourced by
**38 files, 1.3%.** Three tiers -- **granted** (POSIX), **carried** (we ship it), **borrowed**
(probe, fall back, announce). **The reflex LANDED** (`%445`); the tiers stay yonder, yours.

**Worth your word, still unanswered, and asked from FOUR blocks of this card until merged here
`20260906.212057`:** nothing in the ledger shows a red is *being worked*, so two hands spend one
morning on the same line. **Should an OPEN row carry a claim -- a seat and a stamp, at
start rather than at landing?** **Seventeen firings.** Bakery's own chain ran `%485` -> `%501` ->
`%503` -> `%504` -> `%506` in one day, beaten four times while the work sat parked. Asking it in
four places made it read as four questions rather than one.
**`%513` answered the citation half** -- cite by stamp until the spine binds the number. The
claim half stands, and this lap paid it: `20260906.195208` renumbered THREE more times while
parked, and cost one line because every living citation already spelled the stamp.
**Yours, two (%417).** A **guided map** fits neither shape offered: `MAP.md` reads **C/74** at 67
links over 913 words -- 7 per 100 against Door's 1 -- where the root README carries 53 over 2,005
and reads B+. **Second instance `20260906`:** `docs/COMPASS.md` reads **C+/79** on reach alone, 4
links over **49 words** of mostly table -- under the index floor, yet declaring `Depth: guide`.
**Yours, one.** Door's ceiling is **9** against module heads running 12-17. Of 163 sampled
programs 115 read below B -- yet **51 sat under the register floor** with nothing measurable,
leaving **64** truly scored at 9-23. That second number owns the ceiling question, and Gauge's own
table seats **witness headers** at Meter where this card grades every program head at Door.
Gate %7: quality-assurance additive carried `20260904.103121`.
---
## Landed arcs

Twelve, whole on the [fourth shelf](archive/20260831-090000_itinerary-settled-decisions.md); each
account is in `session-logs/`.

## The Compass Chapter -- OPEN `20260809.021829`, now at JARL

Four equinoxes (SOON [x] - JARL - BUHR - TACT); four JARL seats GREEN; next-chapter breach OPEN
`20260810`. Table: [`20260829-141640` shelf](archive/20260829-141640_itinerary-settled-decisions.md).

---

## Waymarks

**No roster here** (`20260907`; it stood at 13 of 30). Seated set `construction/waymark-registry.bron`, sealed; face `.claude/rules/waymark-ladders.md`, agreed **both ways** by `waymark_registry_witness`. Live chapter: **SOON - JARL - BUHR - TACT**. Draw: `tools/w/waymark_derive.rish`. Claims `waymarks/`.

---

## Pier & hands

- **Host** -- this Mac (Incense, America/New_York) and Vultr Dallas (`45.32.204.176`, `Host pier`, `keeper`, AMD 4/8/180). Never EWR.
- **Pier path** -- Mac field `~/grain`; Host pier ships `grain-incense`, `grain-pheromone`, `grain-petrichor` (no `~/grain` on Dallas). NixOS rebuild from the checkout you pull, via `bash nixos/rebuild-outer.sh`.
- **Lane** -- every **send** pushes `xy` then `debrided`; ls-remote guard first; `debrided` may 403 from the cloud (home pier closes the gap). Map: [`../PUBKEYS.md`](../PUBKEYS.md) - [`../context/REMOTE_ROSTER.md`](../context/REMOTE_ROSTER.md).
- **Jail authors; host installs** -- agents write inside the enclosure; USB `adb` installs and key ops stay Keaton's hand.
- **Live state** -- Dallas jail is up; v1.20.2 defaults network off. agent-jail.sh now passes `--network` so APIs resolve.
- **Cursor launch** -- field: Cursor.app. Unattended Earth ships: `claude` signed in, then `fleet-loop.sh` from that tree (Linux: agent-jail wrap). Field jail: `cursor_jail_macos.rish`.
- **Outer terminal / phone** -- USB/`adb` and the phone look stay on the operator desk; read chapter state from the git nib and `prin scope`.

---

## Two grains

The private field is `~/grain`; the public template **grain-os/grain** is *projected* by
`tools/s/sow.rish` along `template-manifest.bron`, proven clean by `tools/s/sow_witness.rish` -- no
name or key crosses. The scrub reaches every name, handle, and contact form case-insensitively, and
a leaking file is withheld whole: privacy over completeness (%225). Raw PII waits for the **Vault**.
The publish push is Keaton's hand.

## Shred-prep

[`SHRED_PREP.md`](SHRED_PREP.md) -- Class H fossils - Class O rooms (propose-never-seat) - **Python->Rishi molt seated** (`20260809`, prep only) - shred stays **RED** until circled. **debride** is the stronger word (removes dead history, deep on Keaton's word).

---

## Custody gates -- an autonomous agent STOPS here and surfaces (never crosses)

For any self-paced or outer-jail loop: recur through all agent-doable work, yet **stop and surface -- never cross -- these custody, irreversible, and provisioning acts.** They are Keaton's hand by design:

1. **The seed** -- each refresh takes its own word (AHOY3 final push DONE `20260812`; one force-push commit, anonymous, unsigned by design). Full row: [`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md).
2. **Provisioning or paying** for any cloud/VPS/Pond/subscription (Vultr IaC, WADE2/3) -- agents author IaC; Keaton provisions and pays. SEA cancelled `20260903`; Dallas is the standing pier.
3. **Moving funds, holding keys, or opening any custody/wallet/payment rail** -- Dimeroll records facts only; disbursement waits on licensed counsel. **The seam, named `20260905` (%427):** *generating* key material is this gate; *relocating a ship's existing keys so its own jail can reach them* is agent-doable, since it changes reachability and no trust relationship. A fresh key per ship needs a hand at GitHub before that ship can push at all, so it stays here.
4. **Generating Keaton's own Kumara instance** from his real seed/keeper -- his hand alone.
5. **Deep debride / history rewrite + force-push** of the living tree -- named target, Keaton's explicit word.
6. **Seating a new module in a collaborator's domain** (e.g. DJINN's surface lead) beyond authored implementation-floor code -- the invitation and lead are the collaborator's to accept.

7. **The drifted rule pairs** (REDS %194; measured `20260829`): of 39 drifted, ONE was additive-one-side (gauge-style -- synced under the word's middle door) and **38 are two-way**, so each stays its own reading here; a bulk merge silently deletes a live safety rule. Classifier: `sh tools/fixtures/r/rule_twin_additive_scan.sh`.

Everything else -- design, code, witnesses, docs, weaves, seed *projection* (not push), reds -- is agent-doable and does not wait.

**Seed cadence -- SETTLED `20260826`: cut.** Gate %1 governs alone.
**One wart:** `sow_project.sh`'s sed-copy drops the exec bit on the seed's `tools/hooks/commit-msg`,
so the armed-wall promise rides on the publisher.

---

## Open doors (awaiting Keaton's word)

| Door | Kind |
|------|------|
| **`%530` bound twice**, both published ([law](../.claude/rules/derived-spine.md)) | live |
| **Gate `%7`** -- retire `.cursor` ([prep](SHRED_PREP.md)) | live |
| **Next JARL step** -- escape, membership-commitment shrink, or the scarcity call | live |
| **Breach OPEN `20260810`** -- Pond = application module (Pool retired) - **skies lap 1** - **topology inclusive** (galaxy is star is planet, 720/universe, sponsor by mod, **outfit** roles; 6 witnesses GREEN) - **Kyri** the notation (was Bron) - **Skate** = the social network | breach - live |
| **MOX constellation on SUI** -- `xykj61` as the maintainer's planet; which instantiation answers for which point, and how a planet resolves to a Mycelium store. Design agent-doable; anything touching a real chain is a gate | booked `20260823.184309` |
| **Three corridor bundles placed, held at the gate** -- fiber (KC), headwaters (Gallatin), works (Brazos); Laps 6-9 await the word. Prompts: `expanding-prompts/20260825-1719{12,18,24}_*.md` | check-in `20260825.171907` |
| **Kumara seed-key derivation** -- one high-entropy seed in Vault from which the Comlink X25519/Ed25519 and post-quantum SLH-DSA-SHAKE-256s keys derive by domain-separated SHAKE-256, the path carrying a scheme tag and a version. An agent writes and witnesses the derivation against test vectors and fake constel identities and stops there | booked - custody-gated |
| **Keaton's own Kumara instance** -- generate from his real seed + keeper, by his hand alone | JARL - when ready |
| **Held doors** -- TAME core/shelf - Identity Remake/Kumara - Geode - Grainphone - Realidream - Pond seven - data-dignity - succession - Mand ring-3 - O3 gen-home | awaiting Keaton |

*Four granted rows moved to the [`20260829-141640` shelf](archive/20260829-141640_itinerary-settled-decisions.md); four elder resolved rows on the `20260824` one.*
---

## Card habits

- **kg** -- keep going, next mechanical lap. **check-in** -- pause for Keaton's word / design. **send** -- commit - push both remotes - merge. **remember** -- reprint this card. **align** -- walk the compass, reconcile plan with green witnesses. **molt** -- prep a fossil for shed. **debride** -- remove dead history (Keaton's word). **shred** stays RED until circled. remember != send != kg != align.
- **Vocabulary** -- the tree seats **shape**, not Hoon's *mold*. Prefer **git nib**. One clock: `TZ=America/New_York`.

---

*Carry lightly. Prefer git nib. `prin scope`. May the chapter stay clean and the fascia hold.*

---

## Next -- the ranked remainder

**BOOKED `20260907.074815` -- two grants.** *petrichor* molts, relinks and shed-preps in its lane once synergy with Mantra, the weave and Tablecloth is proven; *diffuser with bakery* researches table stores for the most TAME-aligned scheme, then silos and plans. [Brief](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md).

**BOOKED `20260907.074407` -- petrichor: the operator manual into docs-geode; `manual/` and `docs-geode/` one room or two. [Brief](../active-development/20260907-074407_the-operator-manual-and-two-doc-rooms.md).**

**BOOKED `20260906.173141` -- 26 of 2,030 tools misfiled by letter room**, past the resolver.


Ranked Lindy-first and crux-first, with costs, gates, and falsifiers, in
[`../expanding-prompts/20260823-124407_the-ranked-remainder.md`](../expanding-prompts/20260823-124407_the-ranked-remainder.md);
the measurement class behind it is
[`../active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md`](../active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md).

**Named and waiting on their own lap:** the **fascia weave** (39 browsed `active-designing/`
documents); ten pages wanting a
Status line; the **`constels/`** room and the **kres/kresfa chapter** (seated
`20260823.122619`). Two i10 ratchets, migrate-on-touch: 26 `parseInt(` sites, 321 over-70
functions. Third mitra shed prepped (`SHRED_PREP.md` Class H), cut RED until circled.

## Prior laps -- landed, with the detail in the log that recorded it

The logs keep the account; earlier rows are shelved in
[`archive/`](archive/) under `itinerary-settled-decisions` and `itinerary-landed-laps`.

| Landed | Round | Log |
|---|---|---|
| `20260908.030324` | The stamp that looked like a check | [log](../session-logs/date/20260908/20260908-030324_the-stamp-that-looked-like-a-check.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
