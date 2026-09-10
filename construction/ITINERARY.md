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
- **INCENSE -- WORK IN PROGRESS, `20260910.070937`.** Landed: eight Bhakta lessons in `docs-geode/lessons/` (95-97); two vortex press pages carrying the **Buckmaster and Alpoge** priority record at the door; twelve single-stranded moonshots; the tally-infuse spell; and the first two moonshot witnesses, `wrap_ring` and `cyclic_witness`. **OPEN:** (1) equinox choir census **70 green, 12 red** against a ceiling of **10**, deliberately not raised; (2) the REDS pin holds ~8 bytes with every row OPEN, so **no new red can be booked** until the bound rises on your word; (3) five dated equinox guards pin counts of a growing surface; (4) ten moonshots remain, ranked on their own page. **Corrected:** `glow_desk_run` is NOT hung -- 455s, exit 0 -- and the verdict word is `over_bound`, since a timeout is a claim about the bound as much as the run.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `29bc7dd16b` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- A CONTAINED FAULT BELONGS AT THE COMMIT.**
Elder [shelved](archive/20260910-084659_itinerary-landed-accounts.md).
**AIR FEELS FOR THE BOUNDARY**: a guard's boundary is the MOMENT it bites. **CENSUS:** 237
tier-lap guards read 380 scans; **113 read the whole tree, 6 narrow to a commit**.
**CONTAINMENT DECIDES IT:** a fault in one artifact's own bytes narrows to a
staged set; a broken link cannot.
**PRICED:** `conflict_marker`, seated for a card published with markers, kept that placement --
**three commits, 26 minutes** live.
**BUILT:** a `staged` mode narrowing that rule to the commit's paths, reading the INDEX alone since
worktree bytes after a clean `git add` never land; `pre-commit` **rule nine** asks it at **19ms** narrowed, where a wide read costs 918.
**REPLAYED:** run against `adf682ac3404` as it shipped, rule nine **refuses it,
both lines named**.
**THE WIRING EARNED LEGS:** the first draft passed every scan leg and NEVER RAN -- the hook's gate
wants `rishi`. **50 legs, 19 pens.**
**A COUNT-PIN OFF BY ONE:** `unheard_guard` reads **461** against a **460** pinned in its witness
while its scan reads ok. `tame_reach` reddened the same way; a peer UNGATED it mid-lap
rather than raising it -- the answer this class wants.
**YOURS:** REDS holds **189 bytes**, no foldable row -- cited by stamp under rule 4.
**PATCHOULI -- THE LEG THAT PROVES A BOUND REFUSES WAS THE ONE LEG NOBODY COULD HEAR.**
Elder [shelved](archive/20260910-081408_itinerary-landed-accounts.md).
**AETHER LISTENS FOR THE PAGE NOBODY ANSWERED**, and the grain's own ear strand -- *a guard that
cannot red guards nothing* -- reaches one level below the guard, into a single **leg**.
`tools/g/glow_run_worker.sh` runs a Glow desk and then echoes a trailer of its own, `EXIT:$?`. A
witness reads the desk's answer out of that same stream, so `assert over.out contains "0"` reads
true off `EXIT:0` **however the desk answered**.
**ALMOST EVERY ONE IS A GATE'S REFUSING SIDE.** All eleven in my lane read *did not speak 0* --
the lawful side (`contains "1"`, `contains "15"`) can red, and the side proving the bound still
refuses cannot. A Glow gate could stop refusing outright and the roster would sing.
**PROVEN ON METAL BEFORE A LINE CHANGED:** a pen copy of `gate-mantra-gen-floor-u32.glow`
answering **7** where its invariant says 0 printed `7` then `EXIT:0`; the elder leg passed and the
list read refused. No tracked byte moved -- the plant sat in ignored `.lap/`, outside the digest.
**THE REPAIR IS ONE WORD:** `(lines x.out) contains "0"`. Rishi list membership is **exact**, so
`EXIT:0` can no longer supply the answer. Eleven legs in nine files, **all nine witnesses re-run
GREEN**.
**THE SIBLING COULD NOT SEE THIS, AND SAYS SO NOW:** `self_matching_assert` reads a needle the
COMMAND OPERAND handed the tool; its `min_needle=3` passes over the one-character needle here.
`silent_leg` **tier lap**, lane gated at **zero**, tree ratchet **28** in seven rooms under a
ceiling that only falls; **24 control legs**, every refusal planted and then lifted, both ceilings
proven from both sides, and the witness asserts `legs_fail=0` beside them.
**MY FIRST CENSUS READ 17 AND THE TRUTH WAS 39** -- `head -40` sent SIGPIPE up the pipeline and
killed the producer, so **a truncating reader reported its own truncation as the finding**.
**YOURS:** the 28 in six other rooms are each their own hand's lap. `construction/REDS.md` reads
**40,957 of 40,960**, so this is named here rather than booked -- the third lap running.

**DIFFUSER -- THE FALSIFIER I NAMED YESTERDAY, RUN TODAY.**
Elder [shelved](archive/20260910-083451_itinerary-landed-accounts.md).
**FIRE SEES WHAT MUST STOP**, and what had to stop was my own unproven projection: *a resident
reader removes the KERNEL half, since the user half is real reading* -- falsifier stated, untested.
**RUN.** `ascii_document_scan` rebuilt as ONE process, the population rule and named table
transcribed unchanged. **25.99 CPU s over 7,741 processes -> 1.49 over 6:** **17.4x** whole, **466x**
kernel, **8.8x** USER. The reason was wrong -- real reading is **1.5 s of 26**; the rest was
interpreter startup in both columns.
**THE PEN CAUGHT WHAT THE TREE COULD NOT.** Both readers agreed here, then **parted the moment a
planted page broke the wall** -- `enforce=broken` for `failed`, no `detail=` lines, exit 0 for 1.
Ten legs, one mutation that must part. `ascii_resident_agree` **tier lap**, holding the AGREEMENT
rather than the figure, since seconds move with the pier's load.
**BOUNDED:** `prose_register` spawns 217, `exec_bit` 267 -- a thirtieth. **One guard of 230 proves no
pier-scale saving**; the falsifier for THAT is named. **HOT 236 run, 232 green, `tree_moved=no`**;
`tame_reach` is the one red and a peer's. **Two cold passes went void by my own mid-run writes.**
**YOURS:** whether a resident reader is worth adopting -- it trades a shell program many hands read
for a 200-line `awk` fewer do, which is a fleet ruling. `tame_reach` went green on the rebase.

**PETRICHOR -- TWO LAPS OF MY OWN STOOD IN A STASH AND ON NO REF.**
Elder [shelved](archive/20260910-092425_itinerary-landed-accounts.md).
**FIRE SEES WHAT MUST STOP**, and it saw this seat's own record: the cold pass read `stash_record`
**red, `unlanded=2`** -- two finished laps of mine, `07:46` and `08:23`, GREEN by their own
witnesses, whose only copy was a stash, which is neither tree nor ref.
**LANDED WHOLE RATHER THAN REBUILT.** No peer had touched a file either lap holds, so
`git checkout <stash> -- <path>` restored the tree object and its mode, and both witnesses
re-prove on today's head. **`unlanded` 2 -> 0.**
**CARRIED:** `truth_mode=counted|judged` beside `truth=`, so a card closing at `truth=100` with no
claim read names which half; `docs-geode/README.md`'s **10 of 1,004** doorway figure replaced by
the scan's name (**18 of 1,261**); `mikrophone/README.md` **D 55 -> B+ 87**,
`glow/nock/README.md` **D 60 -> Door 76 / Field 84**, molted in place.
**YOURS:** module reference README -- **Door** or **Field**? **Eight points** on `glow/nock`.

**PHEROMONE -- FOURTEEN MODULES SPELL ONE BOUND, AND NOTHING COMPARED THEM.**
Elder [shelved](archive/20260910-073606_itinerary-landed-accounts.md).
**AIR FEELS FOR THE BOUNDARY**, so this lap walked the Glow front end's fence line. Every named
`max_` in `glow/` is compared somewhere. The hand went through one post over: **195 published
bounds across 127 sources, SEVEN NAMES in more than one module** -- `max_name_len` **fourteen**
times, each spelling 64 alone.
**THE ONLY THING HOLDING THEM WAS PROSE:** `tokens.rye` says its ident ceiling *matches
rune_shape.max_name_len*, its cord *matches nest_type.aura_t_max_bytes*, its hex
*aura_ux_max_bytes x 2* -- all true today. A comment is a wish: raise one copy and the lexer
accepts a name the shape parser refuses, both files reading correct alone.
**BUILT:** `glow_shared_bound` gates divergence **at zero rather than under a ceiling**, since
every shared name agrees and a ceiling above zero buys room for the first break. **30 legs**, every
refusal planted and lifted, the counter proven to FALL, its own admission -- written expressions,
so `65536` and `64 * 1024` read apart -- proven by a leg, two scan mutations biting.
**A RED I CLOSED AND THEN DROPPED:** the empty log of `20260910.054448` reddened
`empty_document` fleet-wide; I filled it from its commit body, and the rebase found **Petrichor
had rebuilt it an hour earlier from the round's diff and both press pages**, source by source.
Theirs kept. **Twice in two laps I built beside a better answer: I checked the fleet for my guard
and not for the red.**
**ON TOUCH:** five non-ASCII characters left `glow/tokens.rye`, ceiling **2630 -> 2625**.
**HOT 234 run, 227 green, 5 red, 2 gated (%5), `tree_moved=no`**, mine `green 13s`. All five reds
stood at my cold open: `seed_link` 849/848 and `tame_reach` 553/552, one over each and **neither
naming WHICH site moved**.
**YOURS:** `tokens.rye` imports nothing and `rune_shape.rye` already imports it, so ONE module
could own `max_name_len` and thirteen alias it, no cycle possible -- twelve imports, peer-colliding
rather than this lap's keystone.
**INCENSE -- THE LEDGER DEADLOCKED AGAIN, AND THE METER NAMED NO DOOR.**
Elder [shelved](archive/20260910-082230_itinerary-landed-accounts.md).
**WATER TASTES UP CLOSE**, so this lap ran the instrument rather than reading the sentence about
it. Five ships met the full pin in one morning and each re-derived the same options: three folded a
peer's fresh row, one folded its own, one declined the move by name and called it a workaround.
**ONE RED WENT UNBOOKED** -- `20260910.064044`, the amphora framed-name finding, stands cited in
this card and in `construction/standing-equipment.kyri` and in **no ledger row**, and the block
carrying it shelves.
**THE POPULATION IS WHAT CHANGED.** Door B landed `20260829` as the door reaching the cause, and
the pin fell 24,828 to 5,388 bytes. It reads **40,771 of 40,960, 16 rows, all OPEN, none foldable**
twelve days later -- and **9 of the 16 name Keaton, a custody gate, or a numbered gate**, 7 of them
`Keaton's word` outright. **Door B split a live defect from a booked remainder and never split who
can CLOSE a live one.** Eight ships find reds at fleet rate; a row waiting on one person leaves at
one person's rate. That is a refill mechanism rather than a busy week.
**AND HALF A METER:** the foldable cell has printed the command to type since `%517`; the
deadlocked cell printed the diagnosis and stopped, so five hands re-derived one essay's doors.
**LANDED:** `reds_pin_capacity_rows.awk` gains `held()`, the scan prints **`pin_held_rows`** with
one checkable `detail: pin_held %N` per row, and the deadlocked cell prints
**`detail: pin_deadlock_doors`** -- the three doors, whose word each is, and the born-on-a-shelf
practice with its cost and its recital. **Reported, never gated:** a gate on rows only one person
may close would red hardest on the laps that found them. **Nine legs, 50 cases, 0 failed**, both
mutations biting; `reds_pin_capacity_witness` GREEN.
**REDS FIRST PAID FIRST:** `fold_shelf_link` and `fold_shelf_link_repoint` read red on one link --
a hand-written shelf keeping the card's own `archive/` depth. Repointed; both GREEN.
**MY ROW IS BORN ON A SHELF** (`20260910.082230`, **BOOKED**), as %335-%341 were, since no lawful
fold exists. That birth is recorded PRACTICE and not law: `%338`'s door C was costed and declined.
**YOURS, KEATON -- ONE WORD, NOT FIVE ASKS.** The three doors stand exactly as costed and only one
removes the cause: raise this page's bound, **split OPEN by who holds the row**, or sanction the
single-row shelf birth. Until then every ship pays a lap re-deriving them.
**Still yours:** `%460`; `%456`; Meter SCORE for a program; 25 front doors over the ceiling.
**GRASS -- A GATE THAT REDS ON ORDINARY WORK GETS TURNED OFF.**
Elder [shelved](archive/20260910-080834_itinerary-landed-accounts.md).
**FIRE SEES WHAT MUST BE CUT**, and this had written its own indictment. `tame_reach_scan.sh`
gated `uncovered_authored` under a ceiling that only falls, and its own header
named the braid on `20260909.002917`: one number answering **how much debt stands**, which only
falls, and **how many such files exist**, which rises whenever anyone writes one. It booked the
split by stamp, REDS holding no room -- then fired again next morning, `tools/rye/wrap_ring.rye`
landing at `20260910.061931` in an already-uncovered room, **552 -> 553**: lawful work refused. **A
lantern that fires twice becomes a loom.**
**THE STRANDS READ APART NOW.** A top-level **ROOM** is what a widening moves, so
`uncovered_rooms_unknown` is **gated at zero** against a new `tame_reach_debt_rooms.txt` (**25**
rooms, 553 files), `debt_rooms` ratchets there, the count is **published FREE**.
**IT KEEPS A PROMISE THE COUNT NEVER COULD:** the witness claimed a ceiling bought *a room born
tomorrow joins the roster, or this guard hears it on the lap it arrives* -- yet a new room's first
`.rye` raised that count by one, as a new file in an old room did, so it red on both. Legs 11
and 12 set those two side by side. **PEN 39 -> 60.**
**TWO MORE CLOSED MECHANICALLY:** `fold_shelf_link`'s one depth-lost link -- **BAKERY repaired it
the same hour**, so the rebase kept theirs -- and `geode_libraries`, `crypto` at 121 witnesses
where the tree holds 120. **COLD 234/224/8. HOT 234/227/5,
2 gated, `tree_moved=no`** -- my first hot went void, regenerating that page mid-pass.
**`unheard_guard` IS THE SAME CLASS ONE ROOM OVER:** `unnamed_population=460`, hand-moved **six
times** with a paragraph each -- deliberate rather than wrong. **YOURS:** whether it wants this
split. **NO ROW COULD LAND.**
**COPAL -- THE PROOF STOOD BEHIND THE WRITE, AND THE WRITE WAS THE ONE THING IT DID NOT PROVE.**
Elder [shelved](archive/20260910-074214_itinerary-landed-accounts.md) whole.
**WATER TASTES UP CLOSE**, so this lap built the CLI, poured real seasons, and forged a resin
before a line changed. `restore_write_prove` read each resin, wrote it, then hashed -- and the
hash was taken over **the buffer it had just read**, so the write sat between a read and its own
proof for nothing at all.
**ON METAL `20260910.073234`:** a four-file season, one body overwritten, and `restore` printed
`cargo unproven` with **ALL FOUR files standing in the out-home**, the forged bytes among them at
`nested/leaf.txt` -- that entry sorted last, so every earlier write had already landed. A hand
reading the directory rather than the exit code sees a season that looks whole.
**REPAIRED AT THE SEASON DOOR**, the same door the escaping-name rule refuses at one field over:
`restore_prove_resins` walks the whole catalog while the out-home **does not yet exist**, and
`restore_prove_write` proves each body again as it lands, so a resin tampered with BETWEEN the two
walks still writes no wrong byte. The second reading costs one re-read per file, at most twelve
bodies of 128 KiB. The function's NAME carried the wrong order, so it moved too, with its five
living citers repointed.
**`amphora_prove_before_write` tier lap**, six legs: the honest season whole, a forged resin and an
absent resin each refused with **no out-home at all**, then the pre-pass struck out in a pen --
**three honest files land ahead of the refusal** -- and the wall returned over the same vessel.
**THE WORKAROUND WAS THE EVIDENCE:** `amphora_restore_negative` carried `rm -rf` of a partial
season in a comment saying *the forge plant may have left it mid-write*. That line is an assertion
now, and it passes.
**I VOIDED BOTH MY OWN PASSES BEFORE ONE CAME BACK CLEAN** -- edits during the cold open, a `git
stash` probe during the hot close: my last lap's own booked fault, repeated twice. Each was
**stopped by the bounded call** (one candidate here, **seven peer trees refused by name**) and
relaunched. **HOT 230 green, 4 red, 2 gated (%5), `tree_moved=no`.** No red is mine, each traced
by stashing the round away rather than assumed: `seed_link`, `tame_reach` **553 of 552** authored
`.rye` where I add none, `unheard_guard` pinned **460** against a bare tree reading **461**, and
`standing_equipment` reporting those three. **ONE RED FELL:** `fold_shelf_link_repoint` was red at
both opens on **a peer's shelf** -- BAKERY's `20260910.070937` linking `archive/...` from inside
`construction/archive/` -- repointed by the tree's own tool. The only edit after the clean pass is
this paragraph, which is its account.
**YOURS, KEATON -- THE LEDGER IS STILL FULL.** REDS reads **40,771 of 40,960** at `20260910.074214`
-- **189 bytes**, where a row costs near twelve hundred -- so this row **could not land**; cited by
stamp (`20260910.074214`) under rule 4. `published_doubles=7`, unchanged. A raise, or your word.
**Still yours, whole on the shelf:** `rish_spoken_ascii` **11,113** characters, 10,748 table / 365
judgment, sweep unrun; Meter SCORE for a program; `%456`; `%460`; `%360` **674**/**1,093**;
`glow/rune_shape.rye` width; `%281`/`%291`; `%347`.
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
| `20260910.085903` | A process per file -- the falsifier, run | [log](../session-logs/date/20260910/20260910-085903_a-process-per-file.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
