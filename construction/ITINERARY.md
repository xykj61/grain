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
- **Fleet re-arm helper**: `sh tools/f/fleet_rearm.sh` -- status, reason, paste.
- **SEATED -- Pond completes the enclosure** (`20260826`): the quest retiring ai-jail; docs accrete-only until the replacement is audited; switchover and jail debride gated (%5). Plan: `expanding-prompts/20260826-033051_pond-completes-the-enclosure.md`.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `2e68f63bbb` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- THE BOX HELD A DAY'S INSTRUMENTS, AND THE LAP THAT BUILT THEM DIED IN ITS HOT PASS.**
Landed whole from `stash@{0}`, witnesses **56 + 24 behaviors, faults 0**: `scope_rank` --
DIFFUSER's item 1, `saving = cost x (1 - touch_rate)`, both off disk; `scope_match.sh`, the map
matcher written ONCE and sourced by runner and ranking, so a skip and its price cannot disagree;
`index_shelf_repair.sh`; and the map row that grew `session-logs/date/`, without which `--scoped`
skipped the only guard reading the open shelf.
Re-measured today: **220 guards, 163 unmapped, 1,198s = 81.1%** -- your 80.2% by a second method. **Renumbered on the fetch** (`20260907.045528`): `xy` spent the
booked number and the next while the lap sat parked -- the stamp held, the view moved. **The tool's own red
fired on the recovery**: a duplicate row and an inversion; it sorted the inversion and REFUSED the
duplicate, which a hand dropped. **Yours:** a BYTE-IDENTICAL duplicate is decidable, refused
beside the undecidable kind. **The wreckage:** the dead lap left its `--hot` runner orphaned,
parent gone, holding `standing-equipment-run.lock.d`; the cold open refused `run_in_flight` and
printed `kill -TERM <pid>` -- the EXIT trap where SIGKILL leaves the lock. It worked verbatim.
**A THIRD GUARD IN THE FLAKE FAMILY:** `fleet_watch` red in the pass, GREEN alone on the same
tree; `standing_equipment` did it again on `live_group_plant`. All three fork a real service -- a
tmux server, a process group -- on eight cores, and each is GREEN run alone. **Carried:** whether
another rostered guard is clock-shaped is unmeasured.

**YOURS, MEASURED WHOLE AND NOT TAKEN: THE DATED-PATH CENSUS GATES A CLASS IT WAS NEVER BUILT FOR.**
`dated_path_witness` reds at `refs_lost=173` against a ceiling of **165** only a debride may raise.
Classified by two independent readers agreeing exactly: **139 backticked mentions, 15 bare, 15
links** -- and crossed with living-versus-testimony, **all 30 promises sit in dated testimony**, so
the repairable count is **ZERO**. The largest population, **86 rows in two `20260722` shelves, is a
deliberate repair** a hand made on `20260823.184309`, dropping links whose logs never landed
*because a link promises a file a reader can open*; the census reads it as 86 units of damage.
**The shape:** print `lost_mentioned` / `lost_promised` / `lost_promised_living`, subtraction
signed, gate the cell that is both -- zero today, steady where the elder reading rises on ordinary
work. Whether a gate may move to the class it was built
for, when the elder ceiling can only fall, is your word. **Nothing runs that census guard:** only `dated_path_repoint`
is rostered -- `%360`'s family, one over and unheard.

**BAKERY and DIFFUSER accounts, CLOSED and folded** to the [`173444` shelf](archive/20260906-173444_itinerary-landed-accounts.md): `%499`/`%503` (a discriminator that was a tautology), `%501` and its two answers (the Moore bound asked in the direction that decides, then the abelian floor beneath it).

**PATCHOULI -- COVERAGE AND UNIQUENESS ARE TWO PROPERTIES, AND THE SPINE'S OWN GUARD HELD ONE.**
`%536` BOOKED, [folded](archive/REDS-a-number-is-a-view-and-the-stamp-is-the-key-rows-536.md);
account [folded](archive/20260907-084022_itinerary-landed-accounts.md). `reds_ledger_monotone` asked
whether the numbers cover `1..N`, and **a duplicate answers that as well as a unique row does**, so
the ledger held `%530` twice and read `verdict=ok`. Now read as `(number, stamp, file)`, two
readings named apart because they are repaired apart. **Two reds closed beside it:** `shell_dialect`
`sed -i` **1 -> 0**, and `stash_record` **3 -> 0**.

**AND THEN I MADE THE FAULT THIS TREE HAS A GUARD FAMILY FOR.** (`20260907.084022`) OPEN: my hot pass redirected
to `/tmp/hot.txt`, a constant name on a pier **eight ships share**, and for twenty minutes I read a
peer's checkout as mine, nearly claiming a green on their evidence. The stash subjects broke the
tie; `staged_uncommitted=15` **agreed with my index exactly**. **`%512` reaches TRACKED sources**,
so a constant `/tmp` name typed into a session is outside every instrument here -- `%541`'s shape
one artifact over: **a lap's own commands obey no law the tree can read.** It was survivable because
the runner writes its verdict to `standing-equipment-runs.kyri` rather than to a stream. **Hot pass
green**, its one red the `live_group_plant` flake, GREEN alone -- **fifth firing, three guards**.

**Still yours:** the several-line interleave, wanting an anchor per insert; **which of `%530`'s two
published rows renumbers** -- both stand, no byte need move, and the guard now holds the line rather
than asking; **whether a lap's own transcript can be gated at all** (`20260907.084022`); and **`rota_declared`
reds every midnight**. **Seventeenth firing**, START-claim.

**DIFFUSER -- A PORTABILITY GUARD IS THE ONE GUARD WHOSE SUBJECT NO AUTHOR CAN RUN.**
Row `20260907.081135` **BOOKED**, cited by stamp until the spine binds it. `shell_dialect` refused the cold open at
`gated_sed_i_sites=1` against a ceiling of **0**: a bare `sed -i` in a peer's
`seat_prompt_figure_control.sh`, where BSD reads the script as a **backup suffix**, so the planted
figure stands and the check reads 1 where it wants 0. Repairing it uncovered a second, **mine** --
`readlink -f` at `fleet_call.sh:84`, GNU-only, inside the file whose subject is refusing to
measure its host. **A ceiling-per-family scan reports the first over and stops**,
so one repair is one reading. Both hands ran their own witness here and both read GREEN, because
both spellings are correct on this pier; the fault lives on a bench neither had open.
Repaired by a subshell `cd` + `pwd -P`, which reads **better** on a deleted directory, where
`readlink -f` glues `(deleted)` to a path `under_root` then compares as a plain string. The `sed`
half **withdrew to a peer** who landed `sed_inplace` there first. `shell_dialect` GREEN. **Yours:** three of the seven remaining `readlink -f`
sites are `shell_portable_control.sh` calling it **deliberately** to prove `resolve_path` matches
it, so that ratchet's honest floor is **three**, not zero -- a distinction the scan cannot draw.
**The helper landed too**, recovered whole from a stash and
[folded](archive/20260907-081259_itinerary-landed-accounts.md) with the third-stash account.
**Yours, three:** whether `fleet_call` is the fleet's ONLY signal -- the remainder is **2 `pkill`
sites in 2 files**, measured after I first wrote 156 here from an unrelated line and the grep
corrected me; the star's 4.79 vs 10.6x; may I tool the shelf sort (`%440`)?

**PETRICHOR -- THE ASCII LAW NAMES THREE SUBJECTS, AND THIS TREE'S GUARDS SPEAK IN A FOURTH.**
Elder [shelved](archive/20260907-075107_itinerary-landed-accounts.md); new row (`20260907.075107`)
BOOKED, by stamp. Both comment meters refuse *program content*, since converting a
string changes what a program prints. **One exclusion, two questions:** a
heredoc is fed ONWARD and converting it changes behavior; a `say` line is said TO A PERSON, and
converting it changes **register** -- the thing the law governs. **The card's own 5,511 counted every
non-comment line, grep patterns included.** Over **2,387** `.rish` sources, **6,847 of 6,923** non-comment
lines are two shapes (`say`, `assert ... else`), carrying **11,154 characters in 1,516 files**
against the **505** the comment meter holds in those same files under that same law. **10,789
(96.7%) are the six forms the rule spells**, **365** notation a reader chooses a word for -- printed
apart, one work and one taste. Rostered `tier cadence`. **NOT MINE:** a spoken line is
none of the law's three subjects, so **extending that list is your word**. **Three reds closed, all mine** -- `index_row_bound`,
`reds_spine_derive`, and `stash_record`: **two of my own laps stood unlanded**, one holding an
unlanded repair -- `foundations_link_scan.sh` wrote a **constant `/tmp` path every ship here owns at
once**; `shared_pen` 54 to 53.
**YOURS, THE ONE I COULD NOT CLOSE:** `two_rooms_doorway` reads **46 pages naming no room against a
ceiling of 44**, `tier cadence` -- **unseen by any lap-tier pass**; the source repair lands
here, the 46 stay its own declined judgment. **Still yours:** `%530`, three citations in `construction/archive/`.
**PHEROMONE -- A GREP WAS READ AS A BUILD, AND THE LAP FINDING IT DIED TWICE.**
(`20260907.083054`) BOOKED, [folded](archive/REDS-a-grep-that-was-read-as-a-build-rows-554.md).
`mantra/src/store.rye` did not compile -- `trimRight` retired to `trimEnd`, `read_head` returning
`allocator.dupe` without its `try` from a `!?[]u8` -- while `rye_compile_reach_scan` read
`asserted=0` and counted it a build root; four instruments stood green over it. **The census
classes a runner as compiling on its whole TEXT, then credits every `.rye` literal it names**, so a
witness building a desk on line 44 launders its grep of `store.rye` into a build. **Re-measured,
reproducing exactly: 130 of 1,892 named paths are credited off any compile line** (an upper bound).
Repaired: both errors, plus `mantra/src/declaration_walk_witness.rye` under
`tools/m/mantra_declaration_walk_witness.rish` `tier lap`, taking the ADDRESS of every public
declaration and descending into containers -- `room=31`, its control proving a one-level walk BLIND
to a fault in a `Store` method. Twice lost with a dead lap and landed off `stash@{0}`, which
`stash_record` named both times -- **the box works; what it cannot do is commit.** **`%440`'s
twelfth firing: both duplicates BYTE-IDENTICAL**, BAKERY's decidable class, measured. **YOURS:** may
`index_shelf_repair.sh` drop that kind? **AND THE ROW RENUMBERED TWICE IN ONE SEND**, 549 to 551 to
554 -- upstream spent five numbers in the forty minutes the lap took to close, and the stamp held
all three times. Elder
[folded](archive/20260907-083054_itinerary-landed-accounts.md).

**YOURS, AND IT COSTS THE FLEET A LAP A DAY: THE ROUND-OPEN PARKS AN ORDINARY LOST RACE.** `%499`
OPEN. `fleet_round_open.sh` classifies by two `is-ancestor` tests and **two states fail both** -- a
real upstream rewrite, where parking is right, and the fleet's own ordinary outcome, where a peer
pushed on the base you built on and `git rebase` re-derives you whole. Its own header prescribes
re-derivation for the push refusal and parking for that same state one step earlier. Measured on
`xy`: **11 `pier/diverged-*` branches, 33 distinct subjects since `20260828`; 23 later reached main
by a hand, TEN never did** -- one of them the tablecloth find this card carried below as open, and
two more parked within twenty minutes of the reading. **The discriminator is local:** the merge-base
equals the parent of the oldest commit in `xy/main..HEAD` exactly when the local line's base still
stands upstream. **Not taken** -- six ships run that file. **A park keeps every byte and still costs
the lap.** *My third row of this lap was **withdrawn rather than renumbered**: it booked
`sow_allow_reach`, and a peer had booked exactly that at `20260906.133724`, which stands published
as `%493` above -- the fourth time in one day that a finding and its peer met in the same hour.*

**Yours, one question; law, so INCENSE may own it.** The five negatives `mycelium` keeps are its
**subject**: two Meter claims, a *no real key, no funds, no network, no custody* disclaimer, and the
benediction [`radiant-wishes-ending`](../.claude/rules/radiant-wishes-ending.md) asks for. **A Door
page obeying both floors at four: 16% of a 20% ceiling.**


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

**PHEROMONE `%460` OPEN** ([shelf](archive/20260906-051500_itinerary-landed-accounts.md)). **Yours:** may a cross-target witness read GREEN with a named gap when qemu is absent? Its head promises that limit, `%446` reads the other way; `capability` is the mechanism.

**GRASS -- A COMPLETENESS GUARD READ ONE DIRECTION.**
[Elder](archive/20260907-080356_itinerary-landed-accounts.md). `20260907.080356` CLOSED.
`waymark_table_registry_completeness` read table -> registry and never back, so a `status living`
mark drawn into the registry and never written into the face passed in silence: **the registry
re-seals on a draw; the face waits on a hand.** Both ways now, zero over **28** vs **30**.
**YOURS:** hand-seated LADDER vs NAME is unreadable from `status`.

**THE SAME HOLE FOR LINKS.** `%524` OPEN: three commit-time link walls read ONE row
shape, so a cairn citing an archive shelf waits for a cold pass; four fired today.
`readme_reach_scan` reads **1,808 documents in 295ms**, cheap enough for that debt.
**Carried: 890** depth-lost links.

**COPAL -- A GUARD DECLINED A REPAIR ON A NUMBER ITS OWN BROKEN READING GAVE IT.** `%544` BOOKED,
[folded](archive/REDS-the-guard-that-declined-its-own-repair-rows-544.md): `shared_pen` read a wipe
off the line holding the path, and the paragraph declining a tracker cited *zero carry that shape
now*, counted by that same reading. Two passes name **exactly the two files** a hand-count had:
wipers **4 -> 6**, control **27 -> 32**, both ways; ceiling **re-seated 4 -> 6**, this ratchet's
only raise. **Yours:** `ios_app_shell` and `macos_app_bundle`, LOCA lane, wanting a simulator. **AND MY
OWN CONTROL REDDENED A FLEET-WIDE GUARD FOR SIX HOURS** -- `%550`: a `sed -i` against a ceiling of
zero, caught **905s** into a pass by a guard costing **0s**, and a red guard withholds the receipt,
so eight ships paid full passes. **The cheap gates reading EVERY file are the ones a lap adding one
never runs.**

**MANY HANDS** (`20260828`): custody MANUAL, one writer per checkout. Root `SKILL.md`; every
clone seats `ww` (gate %1) and `.git/ssh_config_jail`.

**`%481` recurred on `CHECKPOINTS.md`** -- same shelf; the seam is the hook, not the scan.

**Sibling finds:** Mystery's module-label guard fails open on BSD grep; portable, it finds elder
labels in `tools/gen/chapter/fascia_metric_v0.rish`. **Tablecloth, one, cross-lane:** its name desk
reads one of `max_name`'s two call sites (`parse_manifest` reads it too, over the same fixed
`[max_name]u8`). *The four uncontrolled `*_example_missing` verdicts are no longer a find: the work
stands written at `cc1da84f7`, parked by a round-open and unlanded since `20260905` (`%499`).* **Dream's parked packages:**
`xy/pier/diverged-20260831-{064342,115245}`, neither landed, neither mine. **CION:** `drey`'s rung marks are the retired form (%329). **Fleet loop (%387):** should a
round's opening stash stop an in-flight pass in its own tree.

**Bounds raised `20260906`, both derived, both yours:** the operator card to 40,960 (8 ships x 2,048 live front) and the REDS pin to 40,960 (8 x 4,096 OPEN set + 8,192 header). **Each is sized per ship, so both re-open at twelve** -- and the pin's is also sized by how fast reds close (`%360`, 8,213 bytes, open since `20260830`).
**`%456` OPEN -- eight ships share ONE login, so one credential is a fleet-wide outage** (mechanism read from `agent-jail.sh` source, so `%458` leaves it standing; the pier half is unmeasured from inside the enclosure). Seven died 3 laps each in ten seconds on `OAuth session expired and could not be refreshed`; `agent-jail.sh` seeds every tree from the pier's single credential. The refresh token had **27 days** left, so expiry is excluded -- the leading read is **rotation**: first refresher strands the rest and the pier's own copy. **Falsifier is cheap:** watch whether the pier's refresh value changes after a ship refreshes. Landed: `claude_refresh_dead()` names a dead credential instead of seeding it, proven 3 ways, and `sh tools/fixtures/f/fleet_login_scan.sh` answers it in one command. **Yours, gate 3:** one login per ship is the fix. **A resource shared by every ship has no blast radius smaller than the fleet.**
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
sites, none -- and not POSIX since 2008.** The cure is written, `tools/fixtures/s/shell_portable.sh`,
and **38 files source it, 1.3%.** Three tiers -- **granted** (POSIX), **carried** (we ship it),
**borrowed** (probe, fall back, announce). **The reflex LANDED** (`%445`); the tiers stay yonder, yours.

**Worth your word, still unanswered, and asked from FOUR blocks of this card until they were
merged here `20260906.212057`:** nothing in the ledger shows a red is *being worked*, so two hands
spend one morning on the same line. **Should an OPEN row carry a claim -- a seat and a stamp, at
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
| `20260907.062519` | The lap that died inside its own hot pass | [log](../session-logs/date/20260907/20260907-062519_the-lap-that-died-inside-its-own-hot-pass.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
