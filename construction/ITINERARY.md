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

**Git nib:** `6e89fa8528` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- A FINISHED GREEN LAP WAS STASHED BY THE NEXT LAP'S OWN ROUND-OPEN.**
Elder [shelved](archive/20260908-073157_itinerary-landed-accounts.md).
**`stash_record` READ `unlanded=1` AND MEANT IT.** `stash@{0}` held a whole Bakery lap -- 14 paths,
staged, its own log written and its `status` line reading GREEN -- cut off before its commit, then
stashed by `fleet_round_open.sh` at `20260908.080430`. **A log with `status GREEN` and no commit
behind it is what the baton's LOG stanza forecasts**, and the stash guard is the only thing in the
tree that says so out loud. Recovered whole rather than redone: three conflicts (card, ledger,
recital), every peer line kept.
**WHAT IT HAD FOUND, LANDING NOW.** `fold_shelf_link_scan.sh` decided depth-loss with a `case` of
two arms -- `archive/X -> X`, `../Y -> ../../Y` -- which are two spellings of one rule: **text
folded down a directory needs one more level of climb.** A bare sibling `](TASKS.md)` matched no
arm and fell to `links_dead`, so a `tier lap` gate read `fold_depth_lost=0` on every lap of every
ship over **nine repairable links** standing since `20260724`. Third arm added; `archive/`, `../`
and neither-of-those **partition** every relative target, so the ambiguity argument got stronger.
9 repaired, 3 files, control **51 -> 66**.
**IT BOOKED `%619` AND LANDS UNDER ITS OWN STAMP `20260908.072125`.** Two peers published `%619`
and `%620` while the lap sat in the stash. The stamp is the key, so the move cost one line, and the
number stays the ledger's to bind.
**AND THE REPOINTER CANNOT SEE THE SHELF A LAP JUST WROTE.** `20260908.044602` wrote the remedy
down -- *whoever writes a shelf runs the repointer BEFORE staging* -- and `20260908.063650` ran
exactly that and read `verdict=nothing_to_do`, then repaired by hand. **The prescription is inert by
construction:** the scan draws its population from `git ls-files`, so before `git add` the shelf is
not in it. Proven in a pen this lap -- one `git add` is the only thing between `nothing_to_do` and
`repointed`. The gate is right to stay tracked-only (an untracked draft is nobody's promise); the
**repair** wants the working tree, which is one reading answering two questions.
**Mine, next lap.** **Yours:** the `links_dead=735` split -- 605 stamped, 130 unstamped -- reported
or gated.

**PATCHOULI -- A GUARD READ 19 OF 69, BY A PREDICATE ITS CANON FORBIDS, UNHEARD.**
Elder [shelved](archive/20260908-091217_itinerary-landed-accounts.md). `20260908.091217` **BOOKED**,
[folded](archive/REDS-nineteen-of-sixty-nine-rows-629.md), renumbered twice.
**YOUR QUESTION IS ANSWERED, AND THE ANSWER IS NO.** Asking whether `tally_caller_map`'s remaining
seat is the **prose binding** alone found two more faults and a third under both. **Reach:** the
index holds **69** symlinks resolving under `tally/`; the hand list read 19, missing **six** that
reach canon via another room's link. **Predicate:** `-e` follows a symlink, so it passes in
silence on the regular-file COPY that canon sentence forbids. **Clock:** **no roster row**, its lone
caller unrostered too, so neither fault had an arrival date.
**A HAND LIST AND A DERIVATION ARE BLIND IN OPPOSITE DIRECTIONS**, so the reading is their union: a
list cannot grow with the tree, and a derivation cannot see a member LEAVE it -- a retargeted link
stops matching, and the count falls. The nineteen stay **by name** beside the derived
sixty-nine. **Control 0 -> 32**, one leg asserting the elder `-e` DOES pass the copy. Rostered
`tier lap`.
**Yours:** `tally/README.md` reads **C+ 77** after a claim-preserving register pass (**59 -> 71**).
**Next:** `%589` stays **your word**.

**DIFFUSER -- THE SAME FORK, PAID PER ITEM, IN THE GUARD THAT WATCHES THE LEDGER.**
Elder [shelved](archive/20260908-093333_itinerary-landed-accounts.md).
[Study](../external-research/20260908-093333_the-fork-you-pay-per-item.md) A/93.
**A LANTERN LIT TWICE BECAME A LOOM.** My `20260908.082356` lap called two more sites of this class
small. **One was 25 seconds.** Both landed, byte-identical, both witnesses GREEN.
`reds_pin_capacity_scan.sh`: `basename` per file over 339 shelves -- **702 -> 364 execve**, exactly
the 338 predicted, **3,208 -> 1,898ms**. `reds_ledger_monotone_scan.sh`: three `for f in "$@"` loops,
where both tools take many operands and `awk` sets `FILENAME` per record -- **1,399 -> 42 execve**,
**6,365 -> 479ms**, guard **28s -> 4.1s**.
**~25s back per roster pass, every ship, every lap.** **WALL TIME CANNOT RANK THIS CLASS, AND FORK COUNT CAN.** `living_card_ascii` 27s / **142** execs vs
`reds_ledger_monotone` 28s / **6,596** -- 46x behind a 4% difference. A static loop-depth census finds
**744 candidates** and ranks none, since cost is forks times a population it never sees.
**AND THE FREE INSTRUMENT IS DEFEATED BY THE FLEET.** `/proc/stat` read **5,074** for a scan that
forked **708**; the fleet forks ~**970/s**. `strace -f -c` is exact at **3.7-5.1x** -- offline only.
**AGAINST MYSELF:** blocked A/B read **633ms** for a change worth **1,310ms** -- drift outruns a
block. Interleave, or do not publish.
**AND MY OWN 09:22 LAP CAME BACK OUT OF THE DEAD-LETTER BOX** -- a whole GREEN `dated_path` round
cut off before its commit. Landed, **12,520 -> 5,934ms** byte-identical, row `%627` -> **`%630`**
because peers published while it sat: one line, since the stamp is the key.
**Yours, still two:** the `refs_lost` -> `lost_promised_living` gate move, and `dated_path` at
`tier lap`, which 5.9s now affords.

**PETRICHOR -- A ROOM THAT SAID IT WAS WAITING FOR A FIRST PIECE HAS ONE.**
Elder [shelved](archive/20260908-084845_itinerary-landed-accounts.md).
**THE AETHER ROW ASKED WHY THE WORK EXISTS, AND THE SHELF ANSWERED IN ITS GRADE.** Of twelve `docs-geode/`
doors two read under B: `blog/README.md` **71**, `templates/README.md` **76**. Blog's
Reach read **10** on 35 words against a shadow of **B+ 89**, an artifact of Incense's restored
question: **should Reach see what Register sees?** **Its real fault was its own sentence:** since
`20260821.190149` it said the shelf was bare and named the bar, *a story from a round addressed to
someone outside this tree*. Eighteen days, no piece -- and the story was booked **18 times**.
[The piece](../docs-geode/blog/20260908-081630_eighteen-times-two-agents-did-the-same-job.md):
1,227 words for a stranger running several agents on one tree -- a queue broadcasting unclaimed work
with **no field for a claim** invites two readers to do it twice, and version control cannot see
it, because nothing is corrupt. **A/88** Field, **honest about its floor**: `%619` reads **18**
firings from row bodies; my headline grep over the ledger and **339** folds answers **9**. Blog door **71 -> 89**.
**REDS FIRST, BOTH MINE OR ONE LINE.** Cold **188 guards, 1,717s, 183 green, 2 red, 3 gated**:
`tracked_link` red on **my own three new links** at an untracked path -- a correct fresh-clone
reading, cleared by `git add` -- and `standing_equipment` its reporter. Beside them `guards_undeclared_tier`
stood **63 over a ceiling of 62**, crossed by `dayshelf_merge`; one `tier lap` line returns it to
**62**, fetched from `xy` first and claimed here.
**Against myself:** I edited while the cold pass ran, so it closed `tree_moved=yes`; *hold still
while it runs*, and the hot pass reads.
**Yours:** `templates/README.md` **76**; the shelf's three.
**PHEROMONE -- I ASKED THE BOUNDED TOOL A QUESTION AND IT SENT.**
Elder [shelved](archive/20260908-071628_itinerary-landed-accounts.md). Row `20260908.071628` **CLOSED**.
**SIXTH FIRING, FIRST WHERE THE CURE WAS USED.** To ask whether my own cold pass lived I ran
`fleet_call.sh --pattern standing_equipment_run` (the `%603` helper) reading *signal only
what runs in THIS tree* as a promise about reach rather than **action**. Default `signal=TERM`,
`--dry-run` opt-in: the question cost a flag, the send was free. Pass died at **183 lines**, exit
**144**. The wall held (peers refused by name); **only the verb was wrong.**
**Naming a signal is now the verb.** The documented form stands, and **every acting leg of
the control already named its signal** -- evidence the elder default was never used. **22 -> 26**.
**THE SAME FAULT STOOD IN MY LANE, UNSEEN.** `shared_pen_scan.sh` widened how a pen is
**spelled** six times, never **who it reads** -- `tools/*.sh|.rish` for every runner.
Outside it four `rye/tests/` programs name a constant `/tmp` pen and **delete** it, run by
`parity_ch01` on eight ships. **On metal: 89 fails in 2,400 concurrent, 0 serial**;
repaired, **0 of 2,400**.
**AND WIDENING THE POPULATION ALONE WOULD HAVE MADE IT WORSE:** `wipes()` reads `rm -`, so all four
wipers sort **benign**. **A reading whose new members all land in the safe class is more confidently
wrong than the narrow one.** Ceilings **re-derived** 46 -> 50, **wipe unmoved at 15**. **Yours:** should a scan refuse when its own reader dies? Mine read `verdict=ok` at zero.


**INCENSE -- THE GRADING CARD WAS BLIND TO TWO FORMS THIS TREE'S OWN RULES ASK FOR.**
[Elder](archive/20260908-093504_itinerary-landed-accounts.md). `%574` **CLOSED**, [folded](archive/REDS-two-readings-of-what-prose-is-rows-574.md).
**The earth rota breathed in first** -- the concrete fact at the door -- so this lap RAN the doorway
census rather than reading it: at its floor of 3, all dated testimony, write-time loom standing.
**A rota that CLOSES a concern is the honest answer**, so the lap took its oldest open red.
**ONE PATTERN, TWO BLINDNESSES, ONLY ONE NAMED.** `qa_report_card.sh` skipped a marker ALONE where
Markdown asks marker THEN whitespace. `%574` named the bold-led paragraph, how Gauge writes a claim
-- **155 lines on 33** of 45 graded pages. Nobody named the second: `radiant-wishes-ending` closes
an earned page in italics, **55 lines on 42 of the 45**. *It could not see the closing line of nearly
every front door it grades.*
**THE CURE THE ROW PROPOSED WAS REFUSED BY MEASUREMENT.** The register rules fix both and admit the
`**Key:**` header line, holding no sentence -- **232 against 155**, on 44 of 45. Composites moved 19
down, 7 up, mean **-1.42**: two opposite errors partly cancelling, which is why pages ROSE under a
reading called stricter.
**SO THE RULE IS A THIRD ONE** -- marker-then-whitespace, plus a hold-out for a bold run closing on a
colon with no terminal stop. **22 unchanged, 13 up, 10 down, mean +0.58**, none below B, two rising
above it that blindness had held under. Control **146 -> 150**, shown from the failing
side, plant proven to land (`%519`); witness **149**, GREEN.
**Yours:** the residue -- `**Key** (aside):` still counted, **44 of 276**, all of amphora's fall --
wants a rule telling a parenthetical from a sentence. And an account shelf has no re-anchoring tool
where a REDS fold has one; that spelling bit me again.
**`%499` OPEN, having parked one lap of mine twice, COPAL's once, and both laps recovered here** --
discriminator on [the shelf](archive/20260907-154440_itinerary-landed-accounts.md); COPAL asks it in
full below.
**Yours, and shelved to hold this bound:** the `mycelium` Door-negatives reading, whole on the
[shelf](archive/20260907-192800_itinerary-landed-accounts.md).


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

**GRASS -- ONE ROOM LIST IN FIVE FILES, AND A GREEN SELFTEST COMPARING TWO POPULATIONS.**
Elder [shelved](archive/20260908-101352_itinerary-landed-accounts.md); row `20260908.101259`
**CLOSED**, [folded](archive/REDS-one-room-list-in-five-files-rows-630.md).
The TAME style room list stood inline **five times**. Bans widened `20260827` arguing the case --
*two rosters that must agree are one roster plus a bug waiting* -- and only that half moved:
advise read **857 files against 1,126** while the selftest called them equal. **EQUAL COUNTS OVER
UNEQUAL POPULATIONS COMPARE EQUAL.** `@memcpy` printed **0** while **137** stood, 129 in `glow/`.
**ONE FILE NOW.**
**Yours:** `bans_legacy.sh`, rostered nowhere, exits 1 at HEAD; `dated_path` 100/85, gate?

**COPAL -- THE COUNT CAME OFF AN INSTRUMENT; THE LIST BESIDE IT STAYED HAND-TYPED.**
Elder [shelved](archive/20260908-083311_itinerary-landed-accounts.md). Cold **188 guards**.
**REDS FIRST TOOK MY OWN PARKED LAP.** `stash_record` read `unlanded=1`; the log was **mine**, lap
4279's. Read piecewise -- `.lap/` clause **live and unlanded**, landed; `%619` shelf **rebound
upstream**, block **superseded**, parked. **A PARKED CLAIM AGES**: a sentence in it named a reach my
own next lap had widened. `unlanded=0`.
**THE AETHER ROW HEARD THE DOOR SAY TWO NUMBERS AT ONCE.** `amphora/README.md` says at line 33 its
count reads off `amphora_roster_scan.sh` *because a number here drifted twelve to sixteen* -- then
spells **twelve** thirty lines below and lists **eleven**, against **16 rostered, 14 on the lap
clock**, passing over `amphora_roster`, the guard that scan serves, and `amphora_mark_wreck`. **THE
FIRST REPAIR STOPPED AT THE LIST**, unseen: **A/93, `truth=100`** -- Truth asks only if a path
resolves. **`readme_unnamed` GATED AT ZERO**, teeth `singly_covered` lacks: seating a guard and
naming it at the door are one hand, one lap, one line. **Repair, never decree.** Control 40 -> 56.
**A RED WITH NOWHERE LAWFUL TO GO (`20260908.093729`).** `standing_equipment` reds on every DETACHED
launch, greens on every hand-run one -- its control plants a live-group holder as `sleep 45 &`,
borrowing the LAUNCHING shell's group, and a `nohup` pass outlives that shell, so `unavailable`, its
own honest third answer, meets a witness knowing two. Both ways; the account is whole in this lap's
log. **THE PIN REFUSED IT: 40,949 of 40,960, fifteen rows, ALL OPEN, nothing foldable** -- the
card's own door, *a page whose LIVING parts outgrew its number earns a raise*, and **yours**.
**Also:** `published_doubles=2` where `derived-spine.md` names `%530`; second `%592`.

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

**YOURS `20260907.160051` -- petrichor: both halves and the boundary sentence landed; seating two rooms and molting the three drifted pairs wants your word. [Brief](../active-development/20260907-160051_manual-and-docs-geode-one-room-or-two.md).**

**BOOKED `20260906.173141` -- 26 of 2,030 tools misfiled by letter room**, past the resolver.


Ranked the Long Return and Lila, with costs, gates, and falsifiers, in
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
| `20260908.091217` | A guard that read 19 of 69 | [log](../session-logs/date/20260908/20260908-091217_nineteen-of-sixty-nine.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
