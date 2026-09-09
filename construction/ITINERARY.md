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
- **Stamp and name, never an ascending mark.** Mark a lap by its one-clock stamp and a plain name -- `the standing movement (20260821-142939)` -- rather than `Fold AI`, `f0-f63`, or `X0/X1` for planned work. Count a total with `git log --grep ... | wc -l`. Waymarks stay (names, not counts); `rung` stays where a real ladder exists in code. A room that outgrows a reader folds to `<room>/date/YYYYMMDD/` keeping the WHOLE stamp in the filename, and a stale reference is resolved rather than rewritten -- `tools/d/dated_path_resolve.rish`. No fold ships without `tools/d/dated_path_witness.rish` GREEN, and a REDS fold runs through `tools/fixtures/r/reds_fold.sh`. **Waymark rungs are the retired form too** (%329), and new `equinox_eNNN` guards take stamp-and-name (%330). Rule: `.claude/rules/stamp-and-name.md`.
- **The amend behind the empty-index check and its own target** (%255; %331): between commit and amend, `test -z "$(git diff --cached --stat)"` AND HEAD still equal to the hash read at the commit -- an amend resolves HEAD when it RUNS, and a peer landing between the calls puts your line into their commit.
- **Fetch-before-book** (`20260827`, %230/%252 closed): read a REDS row number only after `git fetch xy`; a collision renumbers to the fetched head.
- **Spelling: American.** `color` never `colour`; normalize on touch.
- **Style sweep before every send** -- Radiant pass over the round's prose (Twilight for a night piece), register only never a claim. Seed section 6.
- **Rota of the canon.** Each lap, deep-read ONE ROW of the 5 x 3 council grid in `recursion-prompts/seed/autonomous-loop.seed.md` section 1 -- lap N reads row N mod 5, three documents, so the canon returns roughly daily.
- **Roster cold, then hot -- and hold still while it runs.** Open the lap with `sh tools/fixtures/s/standing_equipment_run.sh`, let it finish; run again after `git add` as `... --hot` so the green measures the tree the commit ships (%174). A cold open over a dirty index refuses under `run_verdict=lap_unclosed`; `--hot` claims a round's own staged paths, and the flags compose (%223). The runner digests the tree at open and close, refusing `tree_moved` when they differ (%221). **`--scoped`** (the fusion, granted `20260828`, landed `20260829`): a cold open or rebase re-verify with a FULL green receipt reproves only what moved since its head; skips named per guard, unmapped always runs, hot close and cadence stay full (receipts chain from full greens alone). **Counts come from the scan, never here.** Roster `construction/standing-equipment.kyri`. A `tier` names its clock: absent or `lap` every run, `cadence` the fifth round. A tier is a cadence rather than an exemption, and an unknown word refuses at zero.
- **A lap ends at the commit, never at `git add`.** `tools/hooks/pre-commit` regenerates `README.md`'s metrics block and `docs-geode/libraries/README.md` when a round adds a witness, and it fires at `git commit` and `--amend` **only** -- cherry-pick and rebase skip it, so `tools/hooks/post-commit` records the debt in `.git/` and rule one pays it next commit (%339). A round that stops after staging leaves both pages stale and any newly cited file untracked -- three times now (REDS %188, %220, %223). No guard can enforce the close, since one would have to run after the lap ends; what a guard CAN do is refuse to open the next lap over the wreckage -- `staged_uncommitted` on line one, and `run_verdict=lap_unclosed` when a full pass meets a dirty index without `--hot`. **A dead lap leaves no dirty index**: its leavings are stashed, and a stash is neither tree nor index, so open with `git stash list` (%321).
- **Grade what you touch.** Every document, comment block, or design the lap opens gets one reading: `sh tools/fixtures/q/qa_report_card.sh <path> --setting door|field|meter --service N`. Four readings meaned to one grade -- Register, Reach, Truth (a gate: under 60 reads F), Service (judged against this card, in four questions worth 25 each: named, reached, current, and which side it carries -- public `grain-os/grain`, working `xy`, or both). **B or better stands.** Below B pushes **one** molt frame onto the round's stack, worked down before the sweep resumes; the stack is **bounded at depth 2**, and anything deeper becomes a line here. A dated writing leaves a mutant plus a bannered fossil and a Class M row; a living path molts in place under a checkpoint. **A low grade stays lighter than a red** -- Standfast owns what is wrong, this owns what could be better. A pointer card reads `meter`, and a program is graded on its comments (%276). Rule: `.claude/rules/quality-assurance.md`.
- **Reds first.** Close open agent-closable rows in `construction/REDS.md` before new work; one you cannot close surfaces like a gate.
- **Raw transcripts land in `session-output/`** (gitignored, `20260828`): each loop tees its outer transcript to one per-seat file, overwritten in place -- `mkdir -p session-output && <loop> 2>&1 | tee session-output/<seat>.txt` -- so agents read a peer's full output by path, not by paste.
- **Read scope -- open shelves and closed stacks** (`20260827.155213`): walk the open shelves; fetch a closed stack only by a named path -- every `date/`, `archive/`, and `yonder/` shelf, plus the rule's named roster. Never `ls` the root (`MAP.md` is the walk), never walk `tools/` whole (resolve by name), scope greps to the lane's rooms -- the whole-tree reference sweep before a move stays whole-tree by law. **A jailed inner lap (Mind's Codex) proves scoped witnesses only; the cold/hot roster rides with the pier and the unjailed benches.** Rule: `.claude/rules/read-scope.md`.
- **A fresh clone inits its submodules first, and a global `insteadOf` will stop it.** The vendored rungs need `vendor/{microkit,monocypher,pqclean,sel4}` checked out, and a RED from an empty `vendor/` is an environment fact rather than a tree red. A host that rewrites `https://github.com/` to ssh (this bench does) cannot clone the public third-party submodules at all, since the key has no rights there -- `GIT_CONFIG_GLOBAL=/dev/null git submodule update --init <path>` clones each one over plain https without touching the host's config. `--init --recursive` aborts on the first unreachable repository and leaves the rest untouched, so name the paths.

### Seated, and still live

*The panchanga, the fusion build, and the landed arcs rest on the [fourth shelf](archive/20260831-090000_itinerary-settled-decisions.md).*

- **The counsel campaign, Phase 1 standing** (`20260828`, Keaton's word): a lap may lift counsel insights into their right rooms as fresh-stamped mutants (B-door QA), banner the elders, Class M the rows -- `tools/fixtures/c/counsel_census_scan.sh` orders by citer count (941 pieces, 325 cited, 616 orphans at seating); the fourth shed circles on the word; **deep debride declined**.
- **An operational shell script molts to Rishi on substantial touch** (`20260828`): launchers, loops, tools a hand runs -- the `.sh -> .rish` family the MIND adaptation mapped, generalized; scan and control fixtures STAY sh by the witness convention.

- **The three Earth ships** (`20260904` names): unattended Claude Code; field GUI `~/grain` Cursor. **Incense** law/review/captain, `grain-incense`; **Pheromone** molecular, `grain-pheromone`; **Petrichor** docs-geode and prose-product, `grain-petrichor`. Machines are doors. Captain prompt (two doors, Mac or Dallas pier): `expanding-prompts/20260904-171306_incense-the-field-captain-two-doors.md`. Loop `fleet-loop.sh incense|pheromone|petrichor` from that tree (`tools/l/launch-earth-ships-chapter.rish`). One writer per tree (%291). Parked: `~/grain-mystery`, `~/grain-silence`. Elder charter `20260829.203718` stays testimony.
- **Codex re-arm**: `sh tools/f/fleet_watch_codex.sh`.
- **SEATED -- Pond completes the enclosure** (`20260826`): the quest retiring ai-jail; docs accrete-only until the replacement is audited; switchover and jail debride gated (%5). Plan: `expanding-prompts/20260826-033051_pond-completes-the-enclosure.md`.
- **STANDFAST -- the scrub that remembers** (`20260908.155715`, the scrub red): the seed publish rescrubs all 8,187 files through a 251-rule manifest every run, and two publishes twenty minutes apart -- differing by one file -- each paid the full cost. The scrub is a pure function of bytes and verdict, so it caches by content, which is what Tablecloth holds. **The sow witness keeps reading the whole projection before any push**; only the per-file scrub caches. Design: `expanding-prompts/20260908-155715_the-scrub-that-remembers.md`. Awaits Keaton's word.
- **STANDFAST -- the dated equinox guards, and the pin that cannot hold their row** (`20260908.235139`): the equinox room reads **70 green, 10 red, 2 hung**, and **five of the ten share one cause** -- a guard pinned to a count of a growing surface (`e106` wants 33 REDS rows, `e108` 37, where the spine passes 645; `e102`/`e105` a moved metric revision; `e110` four chapter surfaces). Three more read `verdict=ok` on their scans while refusing, so their cause is unread. **No repair taken:** these are DATED guards, and whether they read an archived state, the living value, or retire is a testimony decision governing a family. **The ledger row cannot land** -- REDS holds 173 bytes with all seven rows OPEN, so no fold is lawful. Both want Keaton's word. Detail in `tools/fixtures/e/equinox_choir_census_scan.sh`.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `9230cb0f0e` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- A PEER AND I DIAGNOSED ONE FAULT AND BUILT TWO CURES; MINE WITHDREW.**
Elder [shelved](archive/20260909-000500_itinerary-landed-accounts.md) by a peer; mine duplicated it.
Row [`20260908.234818`](archive/REDS-a-numerator-that-reads-names-rows-655.md), off `%654` once
published.
**WATER TASTES UP CLOSE** -- run the census rather than read the sentence about it, so this lap ran
`convergence_census.sh` and opened the file next door. It found a tool's proof by that tool's own
filename **stem**, and this tree names a family's instrument half for its job, so **three stood
unproven with a second-run assertion one file away**.
**I WIDENED THE NAME SEARCH; A PEER STOPPED READING NAMES.** Their `proven_by_family_control` asks
whether a control **invokes** the tool. Both read **8 of 11, same three unproven**, so mine bought
nothing and **withdrew on the rebase** -- theirs better in kind, mine still the proximity heuristic
my own row names as the class. **`%499`, again.**
**Yours:** my first dry run read **backwards** -- this harness shadows `grep` with a function backed
by **ugrep 7.8.4**, whose `-v -q` answers 1 where GNU grep answers 0. No guard reads a command a lap
types. **COLD and HOT 205/201/2 gated/2 red**: the parked pair under `%636`, neither mine.

**PATCHOULI -- A LAP FINISHED WHOLE, SENT NOTHING, AND THE STASH WAS THE ONLY RECORD.**
Elder [shelved](archive/20260909-000418_itinerary-landed-accounts.md). **No row** -- `rows_that_fit=0`.
**AIR FEELS**, and the boundary was my own round-open: the tree opened **clean**, meaning
*stashed*, not *sent*. `stash@{0}` held a whole lap -- 16 files, log and card written, `status GREEN`
in it. **A DEAD LAP AND A FINISHED ONE LEAVE THE SAME CLEAN TREE**; only the stash tells
them apart, if a hand reads it. **RE-PROVEN ON METAL** against a HEAD four commits newer than
it knew -- nine witnesses by name, all GREEN. It ships: **1,319 trailing-comment characters in 372
files** stood between two clean edges, gated at **1,311**.
**THEN THE DAY-CLOSE FOUND A SECOND COPY.** Closing `20260908` (**160** rows) types one derived
number into **two** rosters, only the pin named by a law. Measured against the shelves:
**six closed days wrong in `CHAPTERS.md`, right in the pin** -- 66/67, 84/86, **92/73**, 58/61,
133/134, 129/131 -- and **six days with no row**, `20260821`-`20260826`, one living row gone stale
at `20260827.171500` while six hands appended past it. All twelve derived.
**Yours:** *count, never number* -- one guard holding both rosters to one reading.
**Mine:** I repeated my elder's fault -- edited mid-pass, read `tree_moved`, re-ran holding still:
**204/202/0/2** at `%5`, `tree_moved=no`.

**DIFFUSER -- THE NEW CODEX SCRIPTS ARRIVED WITHOUT THEIR EXECUTABLE MODES.**
Elder [shelved](archive/20260909-025531_itinerary-landed-accounts.md) whole by the account writer.
The cold pass at `29c7bf503c` read 59 plain shebang files against the fixed ceiling
of 57. Both additions are Incense's Codex startup files: the watcher and its
control. Their modes are repaired here; the watcher's comment is clearer and
its shell commands stay byte-for-byte the same after comments are removed.
**RECOVERY CHECKED:** 13 parked logs are carried; the energy files match their
stash, and the three topology orphans match `topology_stretch` after its rename.
All 16 stashes remain. Detail: [this lap](../session-logs/date/20260909/20260909-025531_codex-script-modes.kyri).
**HOST READING:** the installed Ripgrep was outside PATH. With it available,
`shell_dialect` proves all 47 helper checks. The hot pass uses that environment.
**OPEN, SEED OWNER:** `SOURCE.md` links `nixos/configuration.nix`; the manifest
marks `nixos` as `template` but carries no `allow nixos`. The projector reads
`allow` rows. Review that room before expanding the export list; the public seed
stays at its custody gate. The seed-link scan reads 849 against its ceiling 848.
**CARRIED:** the prior recommendation to split `tame_reach` backlog from its
growing population remains with that guard's owner.

**PETRICHOR -- A DOCUMENTED FLAG THAT NEVER RETURNS, ON A PAGE GRADED HEALTHY.**
Elder [shelved](archive/20260908-230317_itinerary-landed-accounts.md).
**FIRE SEES, AND ASKS WHAT MUST STOP** -- so this lap RAN every command
`docs-geode/tutorials/running-the-fleet.md` prints. `sh tools/f/fleet_watch.sh --dry-run`
**never comes back** (`timeout 25` exits **124**), printed third in a block whose other two lines
terminate, under *The dry run answers:* and ONE output line -- the shape of one that ends.
**TWO FLAGS, TWO AXES.** `--dry-run` bounds what a pass may DO; `--once` bounds how many passes
RUN, and omitting it keeps `WATCH_PASSES=0`. The tool's ENV table said so eight lines under the
usage triple the page copied. `--once --dry-run` exits **0 in a second**.
**WHAT MAKES IT A RED:** the same cold pass read **`docs_command_path` GREEN here** -- my own
guard, seated last lap -- and `qa_report_card` **A 94, truth 100 on 6 of 6 paths**. *A path that
resolves and a command that returns are two facts; we measure the first.*
**AND IT SHIPS**: `docs-geode` is `template`, verbatim. **THE PAGE KNEW THIS** -- 44 lines up it
pairs `FLEET_DRY=1 LOOP_LAPS=1`, the same don't-act flag bound by a pass count.
**A LANTERN, NOT A LOOM, MEASURED FIRST:** three tracked tool scripts loop unbounded on a sleep,
the other two printed by no living page -- so no guard. Second drift, same root: `fleet_call`'s
transcript missed `over_bound`, its counts being a one-second process reading.
**Row `20260908.225856` BOOKED**, folded to its own shelf by `reds_fold.sh` -- the pin had **173
bytes** against a 2,430-byte row. `tracked_link` reddened, rightly: an untracked shelf in the
recital. Cold roster **205 guards, 176 green, 0 red**.
**Yours:** a guard reading a printed command for TERMINATION must RUN it, which nothing does.
Two instruments called a hang healthy this lap -- named and accepted, or the next loom?

**PHEROMONE -- A RULING STOOD IN FRONT OF THE READING, AND THE GATE WENT BLIND BEHIND IT.**
Elder [shelved](archive/20260908-212614_itinerary-landed-accounts.md).
**FIRE SEES**, so this lap read the ratchet two rows declined. `glow_desk_reach` set
`stem_collision` at a **ceiling of 1**; `%539` and `%613` each read the pair --
`sample-demo-fact-line-lits.glow`, `glow/gen/s/` and `linengrow/gen/` -- a ruling on **which file
keeps the name**.
**NEITHER FILE MAY LEAVE.** `linengrow/glow_seva_b0_line.rye` embeds it as `lit_desk_embed_relpath`
in the product binary, and **Zig refuses an `@embedFile` escaping the root file's directory**. Both
are **byte-identical**, diffed by `stoa237_native_embedded_desk_witness`.
**AND THE CEILING WAS THE BLINDNESS:** a drifted twin read **1**, verdict `ok` -- a gate at the
height of the one fault the pair has.
**THE COST IS PAID BY TWO DIFFERENT PROGRAMS, NEVER BY TWO COPIES OF ONE.** One binary, one cache,
one stem-keyed permission: identical bytes want all three alike, and **`cmp` reads that**.
Split: `stem_collision` **gated at 0**, `stem_twin` reported: **0 and 1**. Control **86 -> 91**;
`desk2()` plants the stem both ways, drift reds. Row `20260908.212614` **CLOSED**,
[folded](archive/REDS-a-shared-name-two-programs-do-not-share-rows-652.md), renumbered **twice**
while parked -- 647 to 651 to **652**, one line, each citation spelling the stamp.
**Still yours:** `%532`'s three fourth-kind files carry no marker, so **what declares a desk's kind**
is that row's only half standing. **And: does Glow accept `007`?**


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

**GRASS -- A PROVER'S ANSWER WENT UNCOUNTED FOR SPELLING THE WRONG LETTERS.**
Elder [shelved](archive/20260908-233325_itinerary-landed-accounts.md).
**WATER TASTES UP CLOSE**, so its cardinal seat's instruction -- run the census, never the
sentence about it -- ran. `convergence_census` finds a tool's proof by grepping tool PATHS for
that tool's own stem, so **a control named for the FAMILY is invisible**: four read unproven
while a sibling ran them twice, one of them answered each lap by a rostered prover.
**A THIRD SOURCE READS WHAT A FILE NAMES:** proven **4 -> 8** of 11, control **18 -> 22**, the
published census failing two. **%499 AGAIN, AND THE SHARPEST YET:** a peer landed a different repair
for the same handoff **twelve minutes** ahead of my commit -- theirs reads a prover RUN, mine the
control named for the family -- so I took theirs whole on the rebase and set mine on top as a third
column rather than a replacement.
**FLEET RED, pin full:** `day_shelf` read present 23:56, `status_declared` refused
00:07 -- minutes apart, and its scan honors no `ROTA_DAY` to pin. Cleared by landing today's log.
**RECOVERED A CUT LAP:** `20260908.224618`'s `tigerbeetle_clone` probe.

**COPAL -- THE MANIFEST'S INTENT HALF MOVED AND ITS DRIVER HALF STAYED.**
**Recovered `20260909.025902`:** the parked log and shelf return whole; the seed link is repaired.
The cold pass ran 207 guards over a still tree. Two missing-`rg` readings pass with the existing
Nix-store binary on PATH. DIFFUSER landed the two script modes and watcher comments
in `9230cb0f0`; that version is kept whole. The retired
`fleet_drain` run entry is kept in session-output and leaves the current run card.
**Next recovery:** `stash@{2}`, the unlanded `gen_home` default, roster entry, and README.

Elder [shelved](archive/20260909-013616_itinerary-landed-accounts.md).
**EARTH BREATHES IN -- the concrete at the door, before the sentence about it.** So this lap read
`template-manifest.bron` against the tree: **115 tracked roots, 44 module rooms, every one carrying
a verdict**, and 17 named paths absent -- 12 uninitialised `gratitude/` submodules, 3 debrided rows
kept as defence in depth, `twilight`, all deliberate.
**THEN THE RED, and it was one line wide.** `nixos` was RECLASSIFIED personal -> template on your
word `20260909`, in the manifest's **intent** half; that file's own header says **`allow` alone
drives the ship**, and no `allow nixos` was written. The room is withheld by the root default,
while `SOURCE.md` gained a link into it reading *which ships with this seed*.
`seed_link` **848 -> 849, RED** on my cold open -- the one guard that could see it, seeing it by the
LINK rather than by the manifest's own disagreement.
**REPAIRED THE WAY THE SCAN ITSELF PRESCRIBES** -- *name it in prose instead*: the seed reader is
pointed at `nixos-guide/templates/configuration.nix.example`, which does ship. **849 -> 848,
`verdict=ok`**, and `.claude/rules/declared-host-config.md` now states the measured fact under its
own *The seed carries it*.
**AND ADDING THE LINE TODAY WOULD REFUSE THE PUBLISH, measured rather than reasoned.** Every
allowed path is scrubbed -- `sow_project.sh` reads `PATHS` from `allow` alone and runs
`sow_scrub.sed` over all of it -- so I ran the scrub over the room and grepped its OUTPUT.
`Keaton`, `keaton`, `Livermore`, `xykj61` and the gmail address all fall; **`vultr` survives on two
lines**, and `sow_leak_scan.sh` greps `-riIlE` with `Vultr` in its IDENT set, so the wall answers
`IDENT_LEAK` and the publish stops. **The wall holds; the order is what is missing.** **Yours:**
drop or scrub that provider word, then write `allow nixos` -- an `allow` line moves a privacy
boundary and the publish is gate `%1`.
**THE CLASS, MEASURED: nine roots carry a ship-intent verdict and no `allow`.** Five are the
documented file-by-file hold, `template-manifest.bron` says *(withheld anyway)*, `vendor` is
submodules -- and **`kyri` and `nixos` carry no note at all**. Nothing reads the two halves against
each other; that is the loom.
**THE ROW CANNOT LAND:** the pin holds **173 bytes with all 14 rows OPEN**, so no fold is lawful --
the standfast of `20260908.235139`, now carrying a second row. Cited by stamp `20260909.013616`.
**AGAINST MYSELF:** I edited two files while the cold pass ran, so it reads `tree_moved` -- my own
elder block records that exact fault, one lap old.
**Carried whole on the [shelf](archive/20260909-013616_itinerary-landed-accounts.md):** the
`rish_spoken_ascii` sweep (**11,087 chars, 10,722 table forms, 1,512 files**, and **no converter
exists** -- `tools/fixtures/r/rye_spoken_ascii_convert.sh` is the exemplar); whether Meter should
SCORE for a program; `%456`; `shell_dialect`; `%360`; `%347`.

**Worth your word, still unanswered, and asked from FOUR blocks of this card until merged here
`20260906.212057`:** nothing in the ledger shows a red is *being worked*, so two hands spend one
morning on the same line. **Should an OPEN row carry a claim -- a seat and a stamp, at
start rather than at landing?** **Seventeen firings.** Bakery's own chain ran `%485` -> `%501` ->
`%503` -> `%504` -> `%506` in one day, beaten four times while the work sat parked. Asking it in
four places made it read as four questions rather than one.
**`%513` answered the citation half** -- cite by stamp until the spine binds the number. The
claim half stands, and this lap paid it: `20260906.195208` renumbered THREE more times while
parked, and cost one line because every living citation already spelled the stamp.
**The two readings behind this gate** -- the guided-map shape `MAP.md`/`docs/COMPASS.md` fall between, and the Door ceiling against module heads -- rest whole on [`archive/20260908-160500_itinerary-gate-7-grade-readings.md`](archive/20260908-160500_itinerary-gate-7-grade-readings.md).
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
- **Lane** -- every **send** pushes `xy` then `gp405`; ls-remote guard first; `gp405` may 403 from the cloud (home pier closes the gap). Map: [`../PUBKEYS.md`](../PUBKEYS.md) - [`../context/REMOTE_ROSTER.md`](../context/REMOTE_ROSTER.md).
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

**BOOKED `20260907.074815` -- two grants.** *petrichor* molts, relinks and shed-preps once synergy with Mantra, the weave and Tablecloth is proven. *diffuser* landed **step one** `20260908.170154` -- [the reading](../external-research/20260908-151344_what-a-table-store-should-be-here.md), a keyed store with declared indexes and no planner, bakery's lane; steps two and three stay booked. [Brief](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md).

**YOURS `20260907.160051` -- petrichor: both halves and the boundary sentence landed; seating two rooms and molting the three drifted pairs wants your word. [Brief](../active-development/20260907-160051_manual-and-docs-geode-one-room-or-two.md).**

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
| `20260908.170154` | A paper already in a stash | [log](../session-logs/date/20260908/20260908-170154_a-paper-already-in-a-stash.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
