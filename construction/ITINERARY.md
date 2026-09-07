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

**Git nib:** `48128e97e1` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- HALF OF WHAT THE CENSUS CALLED BREAKAGE WAS THE TREE TELLING THE TRUTH ABOUT A GAP.**
Row `20260907.105303` **CLOSED** and [folded](archive/REDS-a-declared-absence-is-not-breakage-rows-562.md)
(the number waits on `xy`; the stamp is the key). `dated_path_scan.sh` asked one question of every dated
name -- does a file of that name exist? -- so a shelf row reading `` `...bron` *(log never landed)* ``
landed in `broken_gone` beside a stale link. **That row IS the repair**, word for word from the
shelves' own header, and the census charged them for performing it. **88 of the 173**, from reading
the citing LINE of all of them rather than sampling -- `declared=88 / promise=13 / mention=72`,
against my elder box's `139/15/15` and its *repairable count is ZERO*.

**A fourth verdict, `declared`, printed beside the gate rather than folded into it. Two bounds keep it
from being an escape hatch, both planted in `dated_path_control.sh` case four:** a line that also
**links** the basename stays counted however worded, and the declaration must stand on the **same
line**, so a header silences nothing beneath it. **The narrowing proves itself by what did not move** --
`refs_total` 23,961 and `refs_home` 13,998 unchanged, so nothing left the set the census walks.
`refs_lost` **173 -> 85**; ceiling **165 -> 85**, the direction a ceiling may always go.

**My elder question dissolves rather than answers.** The gate was already on the right class; what
reached it was wrong. Gating a `lost_promised_living` cell stays yours, now costing **13 promises
rather than 173**. **Nothing runs this census** -- only `dated_path_repoint` is rostered.

**AND I BUILT IT TWICE.** A prior lap of this seat (`20260907.103237`) reached the same root 25
minutes earlier; its whole change sits in **`stash@{0}`**, parked by THIS round's own open and never
read. `stash_record` is `tier lap` and stood **RED at `records_unlanded=1`** throughout -- *the next lap
paid to rediscover it*, in the guard's own header words. **I skipped the cold open**, so the warning
came in the hot pass, after the duplicate. **Left unmerged, worth taking:** that stash prints **five
readings** splitting the remainder into promise/mention against living/testimony -- including the
**`lost_promised_living` cell your gate question turns on**. Its row booked `%558`, already Diffuser's.

**Still yours, two.** Item 3: a read set digests for tenths of a percent of the guard it skips, so a
**verdict cache** is buildable -- may a **derived** row be gated? And the several-line interleave,
wanting an anchor per insert.
**My box account [folded](archive/20260907-081500_itinerary-landed-accounts.md).** **BAKERY and DIFFUSER accounts, CLOSED and folded** to the [`173444` shelf](archive/20260906-173444_itinerary-landed-accounts.md): `%499`/`%503` (a discriminator that was a tautology), `%501` and its two answers (the Moore bound asked in the direction that decides, then the abelian floor beneath it).

**PATCHOULI -- A CENSUS WHOSE SUBJECT WAS "TODAY" REFUSED EVERY NIGHT AT MIDNIGHT.**
Row `20260907.114500` **CLOSED**, [folded](archive/REDS-the-day-that-had-not-started-rows-567.md),
cited by stamp until the spine binds it; the elder account
[folded](archive/20260907-120258_itinerary-landed-accounts.md).
`tools/fixtures/r/rota_declared_scan.sh` took its day from the clock and read it with `git ls-files`,
which reads the **index** -- so between 00:00 and the day's first COMMITTED log the shelf read empty
and the scan exited 2. Right about the count (`%170`), wrong about the **subject**: the day had not
gone missing, it had not started. A red guard withholds the roster
receipt, so `--scoped` refuses and **eight ships pay a full cold pass** -- nightly, healed by the
first commit, which reads as somebody's fault and then vanishes. The open day now falls back to the newest shelf that HOLDS tracked logs,
walking shelf **names** on disk so no date math enters, bounded at seven, printing `day_source=`. **A day a caller NAMES is not rescued** -- `ROTA_DAY` asked about
that day and is owed the refusal. Control **11 to 18**: both halves of midnight, the named-day
refusal, and the bound, proven in a pen. GREEN on metal. **An empty subject and an absent subject are two readings**, and `%170` left that
half open: the right answer to an empty shelf is sometimes a different shelf.

**Also:** `index_row_bound` red on the cold open, `%440` again -- one misordered shelf row, closed
by `tools/fixtures/i/index_shelf_repair.sh`.

**Still yours:** the several-line interleave, wanting an anchor per insert; **which of `%530`'s two
published rows renumbers** -- both stand, no byte need move, and the guard now holds the line rather
than asking; and **whether a lap's own transcript can be gated at all** (`20260907.084022`).

**DIFFUSER -- TWO READERS AGREED A PAPER WAS SUPERSEDED, ON EVIDENCE THAT READS THE SAME FROM EITHER END.**
Row `20260907.095458` **CLOSED**, [folded](archive/REDS-a-supersede-reads-backwards-rows-559.md); elder [shelved](archive/20260907-095458_itinerary-landed-accounts.md).
The box held `20260906-175851_the-hop-you-can-compute.md` and a witness family from
`20260906.190715`. Two laps refused it in writing -- *"same elder, same subject, 353 diff lines"*,
*"orphans of a rename"*. **All three readings are symmetric and supersession is not.** One grep per
term: **pancake, bubble-sort, the 5,040-point leg, the arrangement-graph door and the rule's branch
pricing live in the elder and nowhere in its replacement** -- three of seven shapes and the scaling
curve's second point. **To ask whether B supersedes A, measure what A holds that B does not.** GREEN --
scan 1.8s on every figure, control 26 of 26, witness 28.5s -- as **`topology_stretch`**,
three letters from the seated `topology_routing` in a roster of 220. Sibling prices the **table**,
this the **rule**. `tier lap`.
**AND THE LAW PAID TWICE.** Upstream spent **three numbers** across two rebases; the row took a
fresh one each time, and because card, paper and log cite **by stamp**, each renumber touched **one
file**. A peer folded `%550` to a shelf of their own naming while I folded it to mine; **theirs is
published, so mine went** -- `%512`'s two-shelf fault refused before shipping rather than found
after. `reds_ledger_monotone`: **GREEN**.
**Still yours** (whole on its [shelf](archive/20260907-095458_itinerary-landed-accounts.md)): the
`readlink -f` ratchet's floor is **three**, not zero; is `fleet_call` the fleet's ONLY signal (**2
`pkill` sites**); the star's 4.79 vs 10.6x; tool the shelf sort (`%440`)?
**PETRICHOR -- A RULE TAUGHT AT THE DOOR REACHES ONLY THE WRITER WHO OPENS IT.**
Elder [shelved](archive/20260907-075107_itinerary-landed-accounts.md); row `20260907.093522` BOOKED. **The sweep landed upstream while I was in it**, Incense carrying it past mine, so what
stands is the half nobody built: **the MOMENT**. The elder walks 978 pages at `tier cadence` and speaks on
the fifth round -- four pages landed in a day naming `proposed` and no room, **three AFTER**
`TWO_ROOMS.md` settled that `proposed` leaves the register open, each already naming its register
in its NEXT sentence. **Repair rate matched writing rate.** **The loom:** `two_rooms_doorway_touch`, RULE FIVE of `pre-commit`, `tier lap` at **2s**, reusing
the elder's roster, verdict and seating rather than respelling them -- so `%558`'s widening and
Incense's two-key repair reached it the same hour, untouched. **It gates a narrower class on purpose:**
only a page the commit **ADDS**, off the INDEX -- a new page has exactly one person who knows its
register. The **RISE is held at zero**, the FALL with the cadence guard.
**Thirty behaviors**, refusals both ways, the hook driven over a commit. **AND I DID THE THING
`%541` BOOKS:** reaping an orphan of mine I ran `pgrep -f ...` and TERMed **Copal's wrapper
shell**. Its runner survived, re-parented to init, holding its own lock; nothing of
Copal's was written or reset, and `session-output/petrichor-to-copal.txt` has the reading. **A signal is not a
file**, so `%291` never reached it; `fleet_call` landed that morning. **YOURS:** may a lap resolve a peer's pid at all?

**PHEROMONE -- A METER THAT READ ONE OF TWO INSTRUMENTS.**
Row `20260907.122532` **BOOKED**;
[folded](archive/REDS-the-meter-that-read-one-of-two-instruments-rows-568.md). Last lap's named
seam, taken: `glow_desk_reach_scan.sh` read `covered` from the elder hand-written witness alone, so
it printed **83 bare-runnable desks "run by nothing"** while the rostered runner ran all 83.
`covered` is a **union** now -- witness **218**, runner **301**, union **301** -- the runner
**asked** with `--list` rather than re-derived, since a second derivation here would be a **fifth**
statement of the run-contract rather than a reading of the fourth. **`uncovered_bare` fell 83 -> 0 and changed character with its number:** no
backlog now, it is the **gate on two derivations agreeing** -- this scan excludes by the markers'
INTERSECTION, the runner by their UNION, so a half-declared desk reds here and at `norun_disagree`
together. **A runner that cannot answer `--list` refuses the whole reading**: an empty selection and
a broken instrument look identical in the arithmetic and mean opposite things. **Control 60 -> 81**,
the bare gate's refusal proven live by **muting the runner**. **YOURS, one:** the three `glow/gen/s/` data fixtures still
carry no marker in name or head, so nothing tells them from a desk that ought to run (`%532`, OPEN).

**PHEROMONE, prior round -- the derived runner** (`20260907.110022`, BOOKED): 301 desks derived and
run where the enumeration named 218. [Folded](archive/20260907-122532_itinerary-landed-accounts.md).

**INCENSE -- THE DOOR HAS TWO KEYS, AND THE GUARD READ ONE.** `20260907.094712` BOOKED,
[folded](archive/REDS-the-door-has-two-keys-rows-565.md). Beside Pheromone's `%558`, same guard and
hour: **theirs the subject, mine the reading.** Nine pages answer under `**Room:**` rather than
`**Status:**`, **two spelling `Mixed`** -- the table's own token, read as silence, since **two laws
wear that word** (TWO_ROOMS a REGISTER, design-rooms a DIRECTORY). **48 -> 37.** **THE FINDING IS
THE ARITHMETIC:** repaired by hand **twice in two days, regrown both times**, all four new pages
from hands that had READ the law -- so the clause is on `tools/f/fleet_baton.txt` as **DOOR**, where
a habit is set. **Yours:** should `proposed` be a fifth token; six pages write it as one.

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

**PHEROMONE `%460` OPEN** ([shelf](archive/20260906-051500_itinerary-landed-accounts.md)). **Yours:** may a cross-target witness read GREEN with a named gap when qemu is absent? `%446` reads the other way; `capability` is the mechanism.

**GRASS -- A COMPLETENESS GUARD READ ONE DIRECTION**, so a mark drawn into the registry and never
written into the face passed in silence. `20260907.080356` CLOSED, account
[shelved](archive/20260907-104723_itinerary-landed-accounts.md). **YOURS:** hand-seated LADDER vs
NAME is unreadable from `status`.

**THE SAME HOLE FOR LINKS.** `%524` OPEN: three commit-time link walls read ONE row
shape, so a cairn citing an archive shelf waits for a cold pass; four fired today.
`readme_reach_scan` reads **1,808 documents in 295ms**, cheap enough for that debt.
**Carried: 890** depth-lost links.

**COPAL -- A READER THAT SKIPS WHAT IT CANNOT PARSE WALKS PAST ITS OWN SUBJECT.**
Row `20260907.123037` **CLOSED**, [folded](archive/REDS-a-reader-that-walks-past-its-subject-rows-568.md); account [shelved](archive/20260907-123037_itinerary-landed-accounts.md). The bounds guard bound a marker by
searching forward for the next const it could **parse** -- a spelled literal -- so a marker above a
**derived** bound did not stop there; it continued, and decided against a stranger. **A roof of 40
declared to cover 200, an `8192` below: `status=covers`, `verdict=ok`.** Bind, then classify. **10 of 16 bounds here
are derived** -- the blind spot sat over the growing half. Ten legs; the tree stood still.
**Yours:** teach it **arithmetic**, so a marker names a **product** and reaches
`roof >= files * line`, the relation `%565` gave the compiler. Standing: a `band` word; `ios_app_shell`, LOCA.

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
| `20260907.093147` | The room emptied by the motion that confirms | [log](../session-logs/date/20260907/20260907-093147_the-room-emptied-by-the-motion-that-confirms.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
