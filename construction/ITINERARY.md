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

**Git nib:** `d94ef498b1` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- A RECEIPT KEYED ON EVERY FILE STALED ON A THIRD OF COMMITS.**
Elder [shelved](archive/20260909-220903_itinerary-landed-accounts.md).
**AETHER HEARS**, so this lap listened for the refusal nobody learns from: `sow_allow_reach` red at
my cold open, as it reds wherever a tree gains a tracked file in one of the manifest's 107 rooms --
**20 of the last 60 commits**, since `tools/` is allowed and nearly every lap lands a witness there.
My elder block said ANY commit, from memory; logs and `construction/` are withheld. It hashed
`git ls-files` there; the reader branches on a room's CLASS -- `subex`, `barren`, `unshippable`,
`shippable`. Keyed on that, a sibling is quiet and a class change still refuses. Row
`20260909.220903` -- `%675`; `%673` folded.
**PROVEN BOTH WAYS:** control **50 -> 55**, the quiet legs run against the elder helper and shown
failing, class-change legs biting both sides.
**YOURS, FLEET FRICTION:** all **8 ships ran a full roster pass at once** tonight (`fleet_call
--pattern`, no signal). Per-guard time went ~2s to ~600s and the pass had not finished in 2.5h, so I
TERMed it by pid and proved the round on **12 named guards, hot, 0 red, tree_moved=no**. Sixteen
passes a lap-cycle on one machine is the cost; a receipt the ships share, or a lock serializing
them, buys it back. Naming, never imposing.

**PATCHOULI -- A TRUE NUMBER CARRIED A FALSE CONCLUSION.**
Elder [shelved](archive/20260909-225510_itinerary-landed-accounts.md), links re-anchored.
**AETHER HEARS**, so this lap listened under my lane's charter.
`active-designing/20260905-153729_mantra-was-named-for-the-weave.md` argues the weave waits to be
built, citing row six -- `mantra/*.rye` mentioning merge or diff3: **0**. **That glob still answers
0 and is still right.** `mantra/src/*.rye` answers **6 of 12**: `pub fn merge` at
`mantra/src/weave.rye:1029`, `pub fn annotate` at `:1245`, rostered and GREEN on metal here --
the merge proving its join in **all six orders**, the commutativity the page calls absent. Two more
stale the same way: *merge appears exactly once* reads **78**; *rostered entries* reads **30**. Second erratum seated; page **A, 93**. Row `20260909.225510` **could not land** -- see below.
**MY OWN QUESTION, MEASURED AND DECLINED.** Over 387 living pages a loose symbol-beside-path bind
reads **296 lines, 722 of 1,014 missing** -- extraction noise. One-symbol-one-path: **31 checked, 6
missing, all 6 false by hand**. A binding phrase: **3 claims, 0 missing.** The loose rule reds true
prose; the tight one watches three. **Unbuilt, numbers in the erratum.**
**YOURS, AND IT IS BINDING NOW.** I booked the row, repaired the headline, and the rebase onto `xy`
took it back out: upstream closed REDS at **40,951 of 40,960 -- nine bytes** -- and published `%676`
against a different stamp. **Nine rows OPEN, so `reds_fold` refuses `row_open`, and no ship can book
a red at all.** The finding lives in the erratum instead. The pin wants a word: raise it, or rule
which remainders are BOOKED.

**DIFFUSER -- THE LEDGER WENT UNBUILT; THE PROMISES WERE KEPT ANYWAY.**
Elder [shelved](archive/20260909-203002_itinerary-landed-accounts.md).
**FIRE SEES WHAT MUST STOP**, so the lap ran an elder falsifier and **withdrew its own lane's
proposal**. `20260907.215928` proposed a `falsifier-ledger.kyri` needing itself seated to test;
**absent from every commit**, so it reads `unrunnable` and ran against the **27 papers** since.
[Paper](../external-research/20260909-203002_the-declaration-grew-in-the-door.md): **A, 91**.
**26 name a falsifier, 7 ran one -- against the elder 6/19, indistinguishable**, so the kill
condition **held** ledgerless.
**WHAT IT WAS FOR ALREADY GREW IN THE DOOR:** 5 of the 7 declare the adoption in a header field
inside 25 lines, in **4 keys, 5 forms**. One key is proposed, `**Runs the falsifier of:** <name> -- survived | fired | unrunnable`, gating nothing.
**THE THIRD VERDICT CAME FROM USING THE KEY**: this door reads `unrunnable`, which two words
would force into a lie.
**A STALE RED CAME WITH THE LOCK:** a pass at `launch_head 03385be197` read `redleg` 54/53, said
`tree_moved=yes`, then `run_verdict=guard_red`. **Yours:** should `tree_moved` outrank a guard red?
Mine, cold and hot: **216, 214 green, 0 red, 2 gated (%5)**; and a caller's hits.

**PETRICHOR -- A PATH RESOLVED WHILE THE EDIT STAYED PARKED.**
Elder [shelved](archive/20260909-173000_itinerary-landed-accounts.md).
From `stash@{0}`, byte for byte: `announced_length_scan.sh` stops reading its own quoted output as a
fresh announcement, its control gains four checks, and the demos page returns as five dated checks. On metal the recovered control reads **19/0** against the recovered scan and **16/3** against
HEAD's -- exactly the quotation checks. `stash_record` closes. Row `20260909.072646`, whose number
moved **four times** on one stamp.
**A SECOND ROW**, `20260909.174000`: two ships wrote a log at one second; a shelf row is keyed by its
stamp alone. Both stand at their true stamps under **one row carrying both links**; moving one
instead reds `stash_record`. **OPEN.**

**PHEROMONE -- ONE SHIM CARRIED A SIX-GUARD CHOIR TWO HOPS DOWN.**
Elder [shelved](archive/20260909-220705_itinerary-landed-accounts.md) whole.
**WATER TASTES UP CLOSE**, so this lap ran each candidate alone before gathering any.
`witness_reach_scan.sh --list` -- the `unheard` band, a witness no runner names in command position
-- answered **eight Glow files**, none among the 26 `glow_choir` gathered on `20260828`. The
population **refilled in twelve days**. All eight GREEN run singly; **six joined**, members 26 ->
32, cost 2m01s -> **4m47s** measured, still cadence. `unreached` **643 -> 636**, ceiling with it.
**TWO HELD BACK, AND THE HOLD IS THE POINT:** `glow_mobile_target` and `glow_riscv_target` read
GREEN in **0s** by SKIPPING an absent qemu. Whether that green means anything is `%460`, **yours**.
**THE FALL REACHED FURTHER THAN THE SIX.** `unheard_guard` then reddened at a number it SPELLS,
with its reading moved the right way: `unnamed_choirs` **12 -> 11**. `glow_connector_seam_witness`
is an accrete shim whose body runs the `gen/chapter` twin, which names `glow_hygiene_pin.rish`, a
choir singing six -- so one gathered shim carried six more guards into the heard set. Both pins
lowered, delta checked from both sides by stashing this lap and re-running.
**THIS IS GRASS'S QUESTION OF THE SAME EVENING, ONE ROOM OVER**, and here it is a WITNESS rather
than a control spelling the value. **Yours, and the two now agree on the shape:** may a guard ever
spell a ratchet's value, or is the form the law?
**AGAINST MYSELF:** I edited while the cold pass ran, so it closed `tree_moved=yes` honestly; the
hot pass is what I claim on.
**FOUND, NOT TAKEN:** **57** further Glow witnesses read `unclocked` -- `tools/p/parity_ch01.rish`
names every one and no row reaches it. A second choir there is a second loom; the tier costs build
time and `witness_reach_scan`'s own header already calls it **yours**.
**Still yours:** `?&` and `?|` in the closed pronunciation table; leading-zero syntax; decimal and
aura length bounds; what declares a desk's kind.


**INCENSE -- THE WALL WAS A GLOB, AND THE LAW IS A GRAPH.**
Elder [shelved](archive/20260909-221428_itinerary-landed-accounts.md).
**AIR FEELS FOR THE BOUNDARY UNDER THE HAND**, so this lap pressed fences rather than opening work.
First press held: all **30 witnesses the rule rooms name** exist and are rostered, 24 lap, 6 cadence.
**THE SECOND PRESS WENT THROUGH.** `ascii_document` walls `.claude/rules/*.md` by directory glob
while the law is a graph, so a page a rule tells a reader to **read first** was walled by nothing --
its own header named this open and left it. A hand swept five such pages `20260908`; what held them
after was **7 characters of ratchet slack**, so one em dash in `RADIANT_STYLE.md` reddened nothing
and eight reddened a total naming no page.
**WIDENED TO THE LAW'S OWN CITATIONS**, links and backticks both, filtered to living tracked pages:
**110 globbed + 33 derived = 143 at zero.** Derived rather than typed, for the reason the globs are
globs. Derivation can drop a page by an edit made elsewhere, so both memberships **print**.
**AGAINST MYSELF, TWICE IN ONE LAP.** My roster parse read `reds_citation` UNFOUND -- it flushes on a
blank line and that record is followed by comments. Then a hand grep called all 33 clean; the widened
scan refused two living pins, `session-logs/CHAPTERS.md` 50 and `SHRED_PREP.md` 49. The grep spelled
`[\300-\377]` inside single quotes, where it is digits and a backslash -- **this meter's own subject,
turned back on the hand measuring it.** Both swept, proven by re-derivation. Ratchet 3,324 -> 3,225;
ceiling 3,331 -> **3,232**, keeping the 7 it stood on and taking none of the 99. Control 44 -> **63**.
**YOURS:** `.cursor/rules/ascii-first.mdc` carries different text for this passage -- one of the 38
two-way drifted pairs at gate %194, so I left it. **The sibling meters carry the same shape:**
`rye_spoken_ascii` and `spoken_ascii` each wall a room and name canon they do not reach.
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

**GRASS -- A CAPABILITY ASKING LESS THAN ITS GUARD IS AN EXEMPTION.**
Elder [shelved](archive/20260909-215853_itinerary-landed-accounts.md) whole.
**WATER TASTES UP CLOSE.** The lap opened its cold red -- `217 run, 212 green, 3 red`,
`sow_allow_reach` refusing on *projection coverage is stale*. The roster gates it behind `capability
seed_projection`; that arm was `[ -d seed ]`, one of the **four** questions its scan asks. The
receipt hashed the manifest plus `git ls-files` over every `allow` room, `tools` among them, so one
tool file staled the fleet -- **12 of the last 40 commits** did, on a gitignored `seed/` where
nothing was wrong. Cost: `receipt_write=withheld_guard_red`.
**TWO HANDS, TWO HALVES.** A peer rekeyed `sow_reach_inputs.sh` on each room's coverage CLASS while
I measured, closing the **frequency** half. Mine is **classification**: an absent, empty, or
truly-changed receipt is still a checkout fact, and the probe said `present` to each. Repaired by
**sourcing** their function rather than restating it, so their rewrite landed here unedited. Row
`20260909.215853`.
**FOUND, NOT TAKEN:** `convergence_census.sh` prints `candidates_unproven=2`, naming them only under
a `list` word absent from its output. Both read `inert` -- **two facts in one word**: *changes
nothing handed it*, *your sample hit nothing*.

**COPAL -- THE SIXTH CURE MOVED BOTH STRANDS, AND GIT ANSWERED WHAT NO LIST COULD.**
Elder [shelved](archive/20260909-225010_itinerary-landed-accounts.md).
**FIRE SEES WHAT MUST STOP**, so the lap stopped refining a pattern. Four cures each moved ONE
strand of `convergence_census` and each read worse: the comment fence and the target guess were
cancelling each other's errors. Moving both wants a test admitting `$LEDGER` and `$shelf` while
refusing `$SCRATCH`, and **no list of names can do that**. **Git can:** `resolve_target` walks at
most 3 in-file assignments to a literal, following a `${OVERRIDE:-default}` hook where a tracked
destination usually sits; `git_admits` hands it to `git ls-files`.
**12 -> 13, and membership is the finding.** `dated_path_exclusions.sh` LEAVES -- a list library
whose only match describes the repointer's write. `reds_fold.sh` and `bootstrap_wasmtime.sh`
ARRIVE, real writers of tracked paths, both **unproven**; the first writes `construction/REDS.md`
under this card's own fold rule. The two busiest STAY, now on live writes.
`admitted_on_comment_only` **retires** at a permanent zero; `git_only` **4**, `name_only` **8**,
members printed, one answering to both -- a union, neither subsuming.
**Control 27 -> 34, each leg shown failing twice over:** 3 admissions die with the strand removed,
6 refusals with the refusal removed. **A fifth cure died here unrun:** admit an enumerated `"$f"`
when the tool lists work from `git ls-files` -- **0 of 12 do**, they receive paths.
**YOURS, the one false positive left:** `upstream_shape_scan.sh`, on a `"$f"` inside a
`filter-branch --tree-filter` string in a `mktemp -d` pen. Refusing it wants reading inside a
quoted argument -- `rye_spoken_ascii_scan.sh` already walks that.
**AND THE LAP ABOVE CAME OUT OF THE DEAD-LETTER BOX** (`20260909.230704`). It finished GREEN and
never reached a commit, so the round open stashed it -- nine files, two shelves, a log.
**AETHER HEARS the silence where a claim used to be:** a `status GREEN` naming witnesses no commit
carries. Popped, then **re-proven on metal rather than read off its own log** -- witness 34/0,
control `verdict=ok`, `shell_dialect`, `index_row_bound`, `remember_git_nib` GREEN.
**`stash_record` reads `unlanded=0`** -- because the pop put the log in the worktree, one of its
three channels. **Yours:** the recovery is what makes the gate true, so emptying the box erases the
box's own signal.

The U+2212 sweep and its two rebase reds [shelved](archive/20260909-225106_itinerary-landed-accounts.md) whole, the elder chain inside it.
**Yours, nine times larger:** `rish_spoken_ascii` reads **11,113 characters in what guards SAY to a
person**, its own scan splitting them **10,748 table forms / 365 judgment**. The classification is
done; the sweep is unrun, and lands in ~1,500 files -- a collision surface rather than a difficulty.
**Still yours:** whether Meter should SCORE for a program, now a file can name 98 invariants and grade
exactly as it did at 8. **Carried whole on the shelf:** MANY HANDS custody, the four sibling finds, `%387`.
**Bounds raised `20260906`, both derived, both yours:** card and REDS pin to 40,960 (8 ships x 2,048 live front; 8 x 4,096 OPEN set + 8,192 header). **Each is sized per ship, so both re-open at twelve** -- and the pin's is also sized by how fast reds close (`%360`, 8,213 bytes, open since `20260830`).
**`%456` OPEN -- eight ships share ONE login, so one credential is a fleet-wide outage** (read from `agent-jail.sh` source, so `%458` leaves it standing; the pier half is unmeasured from inside the enclosure). Seven died 3 laps each in ten seconds on `OAuth session expired and could not be refreshed`. The refresh token had **27 days** left, so expiry is excluded -- the leading read is **rotation**: first refresher strands the rest and the pier's own copy. **Falsifier is cheap:** watch whether the pier's refresh value changes after a ship refreshes. Landed: `claude_refresh_dead()` names a dead credential instead of seeding it, proven 3 ways, and `sh tools/fixtures/f/fleet_login_scan.sh` answers it in one command. **Yours, gate 3:** one login per ship is the fix. **A resource shared by every ship has no blast radius smaller than the fleet.**
**`shell_dialect` repaired by Patchouli `20260909.063839`:** the absence probe carries its
five required tools on an isolated PATH. It runs with or without host rg and keeps sh when
both share a directory. The helper control passes 47 checks; the bypass mutation fails two.
**Cold pass `20260909.163358`: 213 guards, 1985s, 2 gated** -- 182 -> 213 in a day, wall time up a third.
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

**BOOKED `20260907.074815` -- two grants.** *petrichor* molts, relinks and shed-preps once synergy with Mantra, the weave and Tablecloth is proven. *diffuser* landed **step one** `20260908.170154` -- [the reading](../external-research/20260909-035800_the-bounds-a-store-promises.md), revised `20260909.035800` against primary sources; a workload test precedes the store choice, bakery's lane. Step two landed in the [caller-budget design](../active-designing/20260909-044642_a-query-budget-reaches-its-caller.md); step three awaits the workload trial. [Brief](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md).

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
| `20260909.151557` | The reply that outlived its frame | [log](../session-logs/date/20260909/20260909-151557_the-reply-that-outlived-its-frame.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
