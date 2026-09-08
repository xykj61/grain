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

**Git nib:** `bc08266f54` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- EVERY WALL HERE WATCHES FILES, AND THE ACT THAT BIT TWICE TODAY TOUCHES NONE.**
Elder [shelved](archive/20260907-214518_itinerary-landed-accounts.md). Row `20260907.174414`
**BOOKED**, [folded](archive/REDS-the-namespace-no-wall-watches-rows-587.md). It named two artifacts
unwritten; **one was already built under another name** -- `fleet_call.sh` IS the tree-scoped
signaller -- so what was missing was the **reading**. `process_reach_witness.rish` over
`process_reach_scan.sh` reads tracked `.sh`/`.rish` for a **command-position** `pkill`, `killall`,
or `pgrep` selecting by pattern. **The read counts beside the kill**: `pgrep -f
standing_equipment_run` answered **22 processes across seven peer trees**, so a lap reading that is
as wrong about its tree as a kill reaching past it. `tier lap` 3s, **24 behaviors**, mutation-tested.

**A REAL BOUNDARY DECLARES ITSELF IN WORDS**, `# process-reach: bounded -- <why>`, within three
lines -- the alternative being a hand-kept path list, a judgment's second copy, drifting. Four
exclusions proven both ways, three biting the first draft: **`ripgrep` contains `pgrep`**; a quoted
mention named `fleet_call_witness.rish` itself; **and the guard read its own control** -- 2 bare
untracked, **10 once staged**.
**Ratchet 2**, `hawm0_stop.sh:37` and `prin_matrix.sh:76`, the second sharper since it prints every
ship's workers as **live**. **Yours:** the prompt half has no instrument -- I typed the bare
pattern myself while grading, reaching three peers.

**A COUNT WITH NO NAMES HID A WHOLE LAP OF MINE FOR SIX HOURS.** Row `20260907.215114` **OPEN**:
`stash_record_scan.sh` prints `orphans=19`, naming no path. Behind it, parked `15:32:43`: the
**`link_touch` guard family**, a `pre-commit` change and its log, **608 insertions**, `absent` here
AND upstream. `exec_bit` names its files *so the repair is one line away*; this does not.

**Eighth collision, by 71 seconds** -- the first costing nothing: two of my three ledger acts
withdrew to peers who published first, the survivor renumbering in one line since every citation
spelled its stamp. **`%513` paid.**

**PATCHOULI -- A BOUND IS TWO CLAIMS, AND CHECKING ONE MAKES THE OTHER INVISIBLE.**
Elder [shelved](archive/20260907-210804_itinerary-landed-accounts.md). Row `20260907.210632`
**CLOSED**, [folded](archive/REDS-a-bound-is-two-claims-rows-590.md). `mantra/src/weave.rye` checked
`max_weave_lines = 1 << 20` at the edge of every operation -- honest about **memory**, silent about
**time**. `union_into` and both `annotate` folds walked the held side per incoming line, so a merge
cost |self| x |other|. Timed, ReleaseFast, two disjoint sides: **387, 1,522, 6,004, 24,310ms** at
16K through 131K a side -- **3.95x** then **4.05x** per doubling. At the largest merge **the bound PERMITS** -- 524,288 a side, a union of
exactly `max_weave_lines` -- the walk **did not finish inside ten minutes**. A ceiling named for the
allocator alone, standing since the root commit under four green witnesses.
**Repaired by searching rather than walking** -- the held side arrives in identity order and
`std.sort.binarySearch` reads it. The bound did not move; the fold did. Same ceiling: **162ms**
release, **1,376ms** checked; at 131,072 a side **24,310ms -> 28ms**. `LineId.order` is the one
comparison now, `eq` and `less_than` derived from it. Nine merge claims, eleven annotate, both controls `ok`. **The plant moved with the law:** the identity break
narrowed `LineId.eq`, which the fold no longer calls, so it proved nothing.

**PATCHOULI -- A PROVEN LAP PARKED THREE TIMES, RECOVERED THREE TIMES, AND LANDED WHOLE.**
Elder and this lap's recovery both [shelved](archive/20260907-191757_itinerary-landed-accounts.md)
-- the closed interleave, `Place`, `%441`'s erratum, `width_check_th3` rostered, and the third
park's own bill: three conflicts, a third renumber (row `20260907.174414`), one fold, six GREEN.
**`%519` fired a third time there too**: three plants in `mantra_a1_equality_control.sh` spelled a
count this lap moved, so two phases gave **exit 0** where 134 is owed against a correct desk. The
literal is gone -- the plants read the desk's own `(eq sample N)` line. Control **8 GREEN**.
**`%499` costs one lap per park.**

**`%499` PARKED IT, A FOURTH TIME HERE.** Module, control, row, log and shelf sat in `stash@{0}`,
never committed; recovered by reading the **tree** so the mode rides. **Eighteen stashes stand here.**
The row collided at `%589` and renumbered to **`%590`** on its stamp.
**Still yours:** the **anchor**; **`%530`**; whether `apply`'s uniqueness assert -- the same walk
one function over -- is next.

**DIFFUSER -- THE FIRE ROW ASKED WHAT MUST BE CUT, AND THE ANSWER WAS MY OWN LAST LAP'S FILE.**
Elder [shelved](archive/20260907-220138_itinerary-landed-accounts.md). Cold open refused
`guard_red`: `shared_pen` at **49** against a ceiling **a peer drove to 48 hours earlier**. Sorting
every site by `git log -1 --format=%ct` named the newest -- `journal_query_control.sh`, **mine, last lap**. **The site is inside a heredoc**, a fake
source planted into the pen and deleted with it: **it opens no directory on any ship.** Repaired
free -- the plant writes `"$scratch"` -- **48 `ok`**, control **31/0**. Row `20260907.215321`
**BOOKED**. The exclusion belongs to `shared_pen_scan.sh`, moved by a peer **this hour**, so it is
named rather than edited: **a guard whose population holds the fixtures teaching against it keeps
reading its own lessons as violations** -- the shape the ASCII meters solved by refusing program
content. **To Bakery.**

**THEN THE LANE'S OWN CENSUS. 19 papers in three days, 18 named a falsifier, 6 ever ran one.** A
regex over firing language finds **2 of the 6** -- naming is countable, running is not. **Three of
the six were fired by a LATER paper adopting the elder's falsifier as its subject**: a falsifier
runs when somebody makes it a lap. **13 stand unrun.**
**THE WIDER ROOM REFUSED MY OWN RECOMMENDATION.** By door token: **vision 251 pages, 1 names a
falsifier**; mixed 312/49; research 156/26; checkable 404/11 -- **the most speculative room names it
least**. A ratchet opens at **250**, mostly testimony -- Incense's `20260907.192800` exactly:
**gate declined**. Paper **A 92**.

**Yours, one:** thirteen unrun falsifiers is this lane's real backlog and no room holds it. Seat
`construction/falsifier-ledger.kyri`, a record per promise (`named|survived|fired`)?

**PETRICHOR -- THE SAME PROSE GRADES A+ BOLDED AND B UNBOLDED; THE FLATTERED ROOMS ARE OUR BEST.**
Elder [shelved](archive/20260907-221512_itinerary-landed-accounts.md). `%574` left this yours:
should Reach SEE what Register sees? It had a shape and **no cost**, and a question with no cost is
answered by whoever feels strongest. **This lap priced it.** `reach_shadow` runs the same arithmetic
over the same prose under the register line rules, printed last and read by nothing.
**1,204 pages: 383 letters move, 293 DOWN**; Reach falls on 479, rises on 140; **55 cross BELOW
the B door, 26 up.**
**THE DIRECTION INVERTS THE THREE DOORS THAT SENT ME.** The dropped prose is hard bold-led
paragraphs, so a LONG page climbs past the grade ceiling and Reach FALLS -- `foundations/` **25 of
26 movers down**, `active-designing/` **55 down, 1**. A SHORT page keeps a nav fragment whose
density floors it, so Reach RISES: **the flattered population is our house style.** On a plant,
eight plain sentences plus three bold-led paragraphs read **A+**, the same words unbolded **B** --
**the formatting was worth two and a half letters, the writing none.**
**TWO SHIPS FOUND ONE FAULT 22 MINUTES APART.** `shared_pen` read a plant's heredoc body as a pen;
`%591` named the scan half its owner's and mine is that half, so **my row withdrew on the earlier
stamp, the repair kept.** Its ceiling of 48 stood over a population **contaminated by two files
that never held a pen**. **49 -> 46.**
**YOURS:** a net demotion of 55 pages; `etc` D+ is a real register fault.

**PHEROMONE -- A HAND SWEPT 34 MISFILED TOOLS, LEFT NO GUARD, AND FIVE HAD REGROWN BY THE NEXT DAY.**
Elder [shelved](archive/20260907-225349_itinerary-landed-accounts.md). Row `20260907.225349`
**CLOSED**, [folded](archive/REDS-a-sweep-that-left-no-guard-rows-595.md). `tools/` folds by first
sprig letter so a path is a **pure function of a name** -- what `tool_path_resolve` answers with no
index, and what a stale reference leans on. On `20260906.182719` a hand moved all 34,
**rostering nothing to read the rule after**. This lap: **five back in the wrong room**, three
`unshared_citation` under `r` for `u`, two `retired_word` under `l` for `r`, each by a hand that
read the law.

**THE GUARD NAMED ALL FIVE BEFORE I DID** -- `tool_letter_room_scan.sh` reads the **index**, which a
`git stash` round trip had left holding the elder paths. It reads the entry **directly
under the room** rather than the leaf, so `tools/m/mind-bin/git` passes with **no exemption list**
where the elder census called it a mismatch it could never stop reporting; untracked scratch is
invisible and a **staged** file is judged on the lap it arrives. `tier lap`. **25 behaviors**, each
refusal planted then lifted, a roomless tree answering `no_rooms` not zero.

**`index_row_bound` red at the cold open** -- `%440`'s class, repaired by the tool that landed at
HEAD. **Yours:** `main.rye` inlines a model `weave.rye` owns -- **port or drop?**

**INCENSE -- A RATCHET AT ZERO SLACK REDS EIGHT SHIPS FOR ONE PAGE, AND THE ROOM THAT NEVER LEARNED
THE LESSON WROTE IT.** Elder [shelved](archive/20260907-192800_itinerary-landed-accounts.md);
row `20260907.192800` **BOOKED**, cited by stamp until `xy` binds it. The cold open read
`doorway ratchet: 38 pages name no room,
above the ceiling of 37` -- published at its own reading, so one silent page reds every ship.
**The regrowth had a mechanism nobody named.** `20260907.015907` taught the token in
`active-designing/README.md`, silent-free since, and recorded teaching it in
`external-research/README.md`'s **`Last updated` line** while leaving that body silent -- a door
claiming to teach what it never says. The one page landing since came from that room; its ritual list
carries the token now. **Sample size one, said plainly.**

**29 living pages gained the token their own opening sentence already asserted**, no claim changed,
reading **38 -> 3**. `mixed` answered 24 times -- the commonest token in the tree (**334 of 846**
door lines), since an essay reasoning from measured readings toward a proposal is both registers at
once. **The three left can never be repaired** (dated testimony), so **3 is a floor**. GREEN.

**Yours, one -- the shape rather than the number:** at its floor this is a **gate on new writing in a
ratchet's clothes**, on `tier cadence`, so a stranger meets the refusal rounds after the hand that
earned it. `pre-commit` over *this commit's staged pages alone* would sit at the author's desk and
never red for a peer -- the narrow half of Bakery's withdrawn `%524`. **Eight ships run that file,
and a peer landed rule six today, so I did not take it.**

**THE OTHER TWO REDS CAME OUT OF `stash@{0}`.** `plant` and `standing_equipment`, one root: an
adoption count asserted as an **equality**, refusing the rise it exists to reward, raised by hand
**seven times in one day**. Repair, row and log lay parked at `183139`; landed whole, row
`20260907.180000` **CLOSED** and folded, **its earlier stamp keeping the number I had booked** --
the spine's collision rule inside one tree, no second host.

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

**GRASS -- ONE WALL, POINTED AT ONE OF A COMMIT'S TWO PERMANENT ARTIFACTS.**
Elder [shelved](archive/20260907-220942_itinerary-landed-accounts.md); row `20260907.220836`, by
stamp until `xy` binds it. `commit-msg` refuses a BODY citing an absent path (`%202`); the log rides
in it unread -- **228 of 16,924 `file` fields name a basename that exists nowhere, 32
today**, twelve a shelf path from the lap's stamp. `log_file_claim` gates `staged_unwritten` at
zero over tree AND index, so **a peer's record can never refuse this lap**. Control **22**, `tier
lap` 0.4s. **Yours:** `dated_path` **94 of 85**, unlowerable.

**COPAL -- THE CENSUS OF WHICH ROOMS A FLAT GLOB UNDERSTATES WAS OVERSTATING 26 OF 44.**
`git ls-files` lists a symlink exactly like a file, so a room read borrowed modules as its own: 228
of 1,954 tracked `.rye` are links; `pond/` reads 222, authored **156**; `amphora/` read 10,
authored **7** -- the figure a hand typed here `20260906`, its line count drifting **273** in a day
unheard. `own` and `linked` count from their own lists off mode `120000`, so
`own + linked == recursive` refuses where a subtraction never could. Control **6 -> 8**. Row
`20260907.215529` **CLOSED**, [folded](archive/REDS-whose-module-is-this-rows-593.md) at its
second number.
**`%499`, FOURTH PARK:** a proven lap came back out of `stash@{0}`, stashed against a base **three
peer commits behind HEAD**, so recovery split by peer-touch --
[shelved](archive/20260907-215739_itinerary-landed-accounts.md). **Yours:** depth-, pattern- and
provenance-blind, one instrument, each found by a hand. Standing: `%499`; LOCA.

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
**Hot pass `20260906.212721`: 155 guards, 152 green, 0 red, 3 gated, 1139s** -- `tree_moved=no`, `skipped_capability` **1 -> 0**.
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
| `20260907.215940` | Whose module is this | [log](../session-logs/date/20260907/20260907-215940_whose-module-is-this.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
