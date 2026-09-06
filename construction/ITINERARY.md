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

**Git nib:** `5f9da33021` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- THE DISCRIMINATOR I BOOKED FOR THE FLEET'S ROUND-OPEN WAS A TEST THAT CANNOT FAIL.**
`%499` and `%503` CLOSED, folded to one [shelf](archive/REDS-the-test-that-cannot-fail-rows-499-503.md);
the elder account rests on the [`152240` shelf](archive/20260906-152240_itinerary-landed-accounts.md).
`%499` read the collapse right -- one classifier for two states, **ten commits parked
`20260828`-`20260906` that never reached main** -- then booked a **tautology**: merge-base IS the
parent of the oldest commit in `xy/main..HEAD` in **both** states, since everything in that range is
by construction unreachable from upstream. In a pen, a lost race and an upstream amend both answer
*lost race*. **Checked only where it answers correctly.** *Landed:* the re-derivation IS the
discriminator, and it is **git's** -- reading patch-ids, it drops a local commit whose rewritten twin
already stands upstream, which no shell test sees. The park is cut **before** the attempt, released
only on a clean replay that dropped nothing, **kept** on one that dropped. Control **17 -> 34**, the
elder failing 8 of the new 17. **And of seventeen legs not one planted the diverged state** -- the
branch running `git branch`, `git push xy` and `reset --hard` on eight trees every twenty minutes.
**A leg count says nothing about which branches its legs reach.**
**Sized, yours:** eight ships ran rosters at once on the 4-core pier -- mine **1,019s / 150 guards**
against 789s unloaded. `tier lap` on every seat, so guard cost scales ships x guards, unstaggered.
**Still sized:** a lap teeing to `session-output/<seat>.txt` is a second writer on its own transcript
(`fleet-loop.sh:213`), read from `/proc`.

**PATCHOULI -- FOUR GUARDS SAID "EXACTLY N FIELDS" AND CHECKED THAT N FIELDS WERE PRESENT.**
`%500` BOOKED, [folded](archive/REDS-a-lock-with-no-bolt-in-it-rows-500.md). `limb1`-`limb4` stand
over placards reading `exactly N fields`, each proved by N greps for N field lines. **A fourth
field passed all four, a reorder passed all four, and all four refused "missing or reordered"** -- which a
fixed-string grep reads neither way; `limb4` never read `root` at all. **This is the pin two of my
own movements were written down as waiting on:** the identity gap wants a fourth field on `Line`,
the diff anchor one on `Diff`, and the card and commit `14ab16d19` both name this guard as
the lock. No bolt was in it. *Landed:* `rye_struct_fields_scan.sh` reads a struct's fields **in
order**, each limb reads its **own placard's** number. Proven from the failing side on the real tree
-- a fourth field on `Line` reds `limb1` with *declares 4 where the placard says 3*, green under that
plant this morning. Control **19 behaviors**, its two sharpest both PASSES: the elder predicate
waves both breaks through. **The class is seven** -- Aurora's `limb2`/`limb4` prove a 32- and a 64-byte length by
grepping an `Ed25519` alias, so no guard reads either; `limb3` proves *six stages* with six
`test -f`. That lane's ruling. **Yours:** the identity gap is now unblocked by measurement rather
than by a word.

**DIFFUSER -- A BOUND HAS A DIRECTION, AND I ASKED THE ONE THAT DECIDES NOTHING.** `%501` CLOSED.
The ring-and-ladder paper asked the Moore bound *how many nodes fit at this degree and diameter* --
**9,155,273,437** against our **720** -- read a diameter argument as deciding nothing, and the
erratum **re-affirmed** it. Every figure was right. **A sky fixes its points and a shape its degree,
so the DIAMETER is the free variable.** Solved that way the ladder reaches **5** on a floor
of **3** (**1.67x**), the torus **14** on **4** (**3.50x**). **It decides, against the ring**, strengthening the paper rather than reversing it. **The torus needs no partner**, being 6-regular
where the ladder's max degree 26 is 13x its own mean: **three and a half times above the smallest
diameter any shape of its degree could hold** -- re-balancing recovers **one hop of ten**: the gap is the family's. Bound to **four attainers**, one sitting ON the ceiling; control
**23 behaviors**; the legs-removed copy reads GREEN at **2.80** -- *a fifth of the finding,
silently flattering.* `tier cadence` 151s.
**GATE -- `sow_allow_reach` still reds**, `tier lap`, `no projection at seed/`: **a guard that
cannot run its instrument** (`%460`), gate **%1**. Its seat's.
**Fixed here, COPAL's:** `%494`'s shelf link said `rows-492`; the shelf is `494`.
**Yours:** the card sat at **40,959 of 40,960** -- one byte -- and the live front is still not why
(**13,698** of 16,384; spine plus standing **27,806**). **Thirteenth firing:** should an OPEN row
carry a claim, seat and stamp, at START?

**PETRICHOR -- TWO SHIPS BUILT ONE GUARD IN THREE MINUTES, AND IT COULD READ 19 OF 274.** `%505`
CLOSED. Two trees found `%495`'s remainder eight minutes apart and each built one; mine committed at
14:56:19, the peer's at 14:59:07, and **theirs published first**, so mine is withdrawn whole --
`%484`'s rule, one defect to one record -- parked at `pier/petrichor-20260906-145718`. **A full scan, a twenty-case pen and a witness, written twice
in one hour.** *Your thrice-asked question now carries a price rather than a hypothesis.*
**And the finding that outlived the withdrawal:** comparing the two readings measured the landed
one. **274 links into a fold shelf stand in living files; it could read 19.** The largest
population, **47** in the fold recital, wears a third shape -- `Row 172 folded to` ahead of a
path-anchored link -- that neither elder form can see, and the census said nothing about them:
`shelf_unnumbered=0` reads as *all agree*, meaning *of the 19 I can see* -- **`%451`'s class inside
a guard one hour old.** Repaired INSIDE it rather than beside it: the FOLD form anchored like its
SHELF sibling, `all_links` and `unread_links` printed, the subtraction kept **signed** so an overlap
refuses rather than clamps (`%498`). Reach **19 -> 66 of 274**; the 208 still unreadable are named each pass. Pen 23 -> **33**
**Yours -- my standing question, now carrying its number.** A ceiling with no floor scores a page
that leads nowhere at **100**, and of **607** living pages a newcomer reaches from the front door
**82 lead nowhere** -- 76 with no link at all, one of them a tutorial on my own shelf. Measuring it
moved no grade; a floor would re-grade the room, so it waits on your word.
**PHEROMONE -- A PROOF TWO LIVING PAGES CITE, AND NOTHING EVER COMPILED IT.** `%504` BOOKED, `%463`
CLOSED.
**63 Glow witnesses took the comptime declaration walker in one pass** -- `walked` **2 -> 65**,
`unwalked` **119 -> 56** with no slack -- and **all 63 built**, so this lane hid no body-level type
error. A planted `u32`-as-`[]const u8` builds **exit 0** and prints GREEN without the walker,
**exit 1** with it. The `unreached` leg then named `glow/nock/nock_glow_mirror_witness.rye` --
*"the seam's first witness-backed pin"* in two living pages -- **built by no runner**.
`rye_compile_reach_scan` held it in `never` and read `asserted=0` **correctly**: `asserted` is
`never` intersected with **runner** mentions, and a Markdown page claims just as loudly. Runner
written, GREEN. **Yours, sized not taken:** widening that predicate to living Markdown re-grades the
whole `never` set at once (17 files, 4 doc-named) -- `%496`'s own reason for holding a numerator.

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


**Landed recitals folded** to the [`20260906.145647` shelf](archive/20260906-134234_itinerary-landed-accounts.md) -- `%467`/`%468`, `%459`/`%446`, `%450`/`%461`, `%445`/`%439`, the `040933` four, `%451` with `%469`, and the Petrichor and Pheromone pointers.


**Yours, one question; law, so INCENSE may own it.** The five negatives `mycelium` keeps are its
**subject**: two Meter claims, a *no real key, no funds, no network, no custody* disclaimer, and the
benediction [`radiant-wishes-ending`](../.claude/rules/radiant-wishes-ending.md) asks for. **A Door
page obeying both floors at four: 16% of a 20% ceiling.**

**Measured rather than argued: should an OPEN row carry a claim, a seat and a stamp, at START?**
**PHEROMONE -- my own `41 orphans` is WITHDRAWN**, `harness_roster` landed gating both halves at zero, and the three-firing lantern's spec stands -- whole on the [`20260906.090312` shelf](archive/20260906-090312_itinerary-landed-accounts.md).

**`%481` CLOSED, both accounts folded** to the [`20260906.133957` shelf](archive/20260906-133957_itinerary-landed-accounts.md) -- **a marker makes a pin longer, so the one meter aimed here read the damage as growth**; `conflict_marker` reads 15,681 tracked files and the INDEX beside the worktree, since that is what a commit ships. Patchouli's call on the three excluded teaching files stands.
**AND THE EQUALITY ARC HAD NO RUNNER FOR 7 OF 8** -- `%482` **BOOKED**
([shelf](archive/REDS-a-proof-nobody-runs-rows-482.md)). `src/gate/README.md` called it closed 8/8;
the four Mantra gates build GREEN, **unheard rather than rotted**, now `tier cadence` 92s, while
Aurora's three and Caravan's one stay unheard in their lanes. **Yours:** that page graded Truth
**100 on twelve resolving paths** over seven unrun proofs.
**TWO RECORDS CAME BACK OUT OF THE BOX**, whole in `%479`'s shelf. **The instrument built to report
a duplicated lap was itself one of the duplicates**, its number moving five times: *a number booked
from a parked stash is invisible to `--next` twice over.*
**The identity gap** -- two branches inserting collide at one small integer and merge refuses them
`PositionTextDisagrees`, since `pos` counts inside one weave. Closing it wants a wider `Line`; the
guard said to lock that is `%500` above, and it now reds honestly.
**`%479` and `%464` CLOSED**, the account whole on the [`20260906.140206` shelf](archive/20260906-140206_itinerary-landed-accounts.md). **An OPEN row wants a claim, a seat and a stamp, at START.**
**`%440` fired eight times across two laps** -- a peer's row low at the cold open, then every rebase auto-merging the shelf; one dedupe-and-sort each time, run by hand. **Yours.**



**Five Pheromone accounts closed on metal, all shelved** -- `%454`/`%464`/`%488` on the [`132007`](archive/20260906-132007_itinerary-landed-accounts.md) and [`488`](archive/REDS-the-doubt-published-in-the-wrong-frame-rows-488.md) shelves, `%497`/`%498` on [their own](archive/REDS-reach-and-claim-are-two-boundaries-rows-497-498.md).

**PHEROMONE -- `%460` STILL OPEN at the emulator**, its landed half on the
[`20260906.051500` shelf](archive/20260906-051500_itinerary-landed-accounts.md). **Yours, one
sentence:** may a cross-target witness read GREEN with a named gap when qemu is absent? Its head
promises that limit, `%446` reads the other way, and the roster's `capability` field is the
mechanism.

**GRASS -- three findings, all CLOSED**, whole on the
[`133344` shelf](archive/20260906-133344_itinerary-landed-accounts.md). **A guard's precondition
belongs in its roster row** (`%493`): `sow_allow_reach` needs a `seed/` no clone carries, so at
`tier lap` with no `capability` it red every tree and each ship paid a full cold pass a lap. **A law
is not kept by the room that writes it:** 63 of 104 rule pages held 859 non-ASCII characters, every
one on the rule's own table; `ascii_document` enforces both rooms at zero and ratchets **347** pages
at **3,956**. **A link quoted in backticks cites nothing** -- 30 shapes over 12 pages, all
teaching the fold rule. **Carried:** **890** depth-lost links, a refusal nothing tracked can read.

**COPAL -- EXISTENCE AND AGREEMENT ARE TWO QUESTIONS, AND ONLY ONE HAD AN INSTRUMENT.** `%502`
CLOSED ([shelf](archive/REDS-a-number-and-a-path-name-two-rows-rows-502.md)). A `%N` is a number a
reader knows and a path a reader clicks; the halves move on different laps and nothing read them
together. **Four shipped in one day, all mine**, and `readme_reach` named **one** -- the absent
file. **The other three OPEN a real shelf holding another row**, so they resolve and never red. `reds_citation` reads promises only: the
anchor that IS the number, a shelf word one line back. **At `b441f97b2`: `disagree=3`.**
**`%494` CLOSED** ([shelf](archive/REDS-the-verdict-travelled-and-the-reason-did-not-rows-494.md)),
ratchet 43 of 52. **`%493` still OPEN, not mine** -- `standing_equipment` reads broken here.
**Yours from `%485`:** `source_port` is still the machine's and the lock stands.

**The live front** (condensed `20260831.023122`; the day shelves hold every landed lap):
- **Tri-OS:** LOCA pins pass and reject tampering. Pier proof awaits `libwayland-client` and
  `libxkbcommon`; installs and Apple gates stay Keaton's.
- **CION Tier C** RULED quality-first (`20260830.004431`,
  [campaign](../expanding-prompts/20260829-221841_cion-resumes-the-rung-mark-molt-campaign.md)).
- **DirtySet** RULED `20260830.183102`: shares the nine (seat 0 = whole-surface
  invalidation); duplicate marks idempotent; refusal only out-of-range.
- **Pond live:** `duties_undeclared` **1**; `env` seated at `env_disagreements` zero, enforced.
  Only `entry` is left, and it IS the switchover: a gate, not a lap.
- **Language custody:** growth law
  [a-rune-is-earned-by-a-law](../foundations/20260830-011530_a-rune-is-earned-by-a-law.md); the
  first core LANDED `20260830.224500` -- `|%`, GREEN; nesting OPENED `20260830.221500`.

**MANY HANDS** (`20260828`): custody MANUAL, one writer per checkout. Root `SKILL.md`; every
clone seats `ww` (gate %1) and `.git/ssh_config_jail`.

**`%481` recurred on `CHECKPOINTS.md`, repaired there too** -- same shelf; the seam is the hook, not the scan.

**Sibling find, measured both sides:** `dated_path_witness.rish` reds at `refs_lost=166` against a
ceiling of **165** -- and it reads **166 on the pre-lap tree too** (`d9a10c18c`, measured in a
throwaway worktree), so no lap added it. Only `dated_path_repoint` is rostered, so nothing has
run the census guard; `%360`'s family, one over and unheard. The scan prints no list, which is
why nobody can name the reference -- a listing leg is the cheap next move.

**Sibling finds:** `tame_style_long_fn_one.sh` resets its awk on any indented `fn `, so a long function holding an inline comparator reads clean. Mystery's module-label guard fails open on BSD grep; portable, it finds elder
labels in `tools/gen/chapter/fascia_metric_v0.rish`. **Tablecloth, one, cross-lane:** its name desk
reads one of `max_name`'s two call sites (`parse_manifest` reads it too, over the same fixed
`[max_name]u8`). *The four uncontrolled `*_example_missing` verdicts are no longer a find: the work
stands written at `cc1da84f7`, parked by a round-open and unlanded since `20260905` (`%499`).* **Dream's parked packages:**
`xy/pier/diverged-20260831-{064342,115245}`, neither landed, neither mine. **CION:** `drey`'s rung marks are the retired form (%329). **Fleet loop (%387):** should a
round's opening stash stop an in-flight pass in its own tree.

**Bounds raised `20260906`, both derived, both yours:** the operator card to 40,960 (8 ships x 2,048 live front) and the REDS pin to 40,960 (8 x 4,096 OPEN set + 8,192 header). **Each is sized per ship, so both re-open at twelve** -- and the pin's is also sized by how fast reds close (`%360`, 8,213 bytes, open since `20260830`).
**`%456` OPEN -- eight ships share ONE login, so one credential is a fleet-wide outage** (mechanism read from `agent-jail.sh` source, so `%458` leaves it standing). **Its pier half is unmeasured from inside the enclosure.** Seven died 3 laps each in ten seconds on `OAuth session expired and could not be refreshed`; `agent-jail.sh` seeds every tree from the pier's single credential (*one login per pier*). Refresh token had **27 days** left, so expiry is excluded -- the leading read is **rotation**: one shared token, first refresher strands the rest and the pier's own copy. **Falsifier is cheap:** watch whether the pier's refresh value changes after a ship refreshes. Landed: `claude_refresh_dead()` names a dead credential instead of seeding it (proven 3 ways -- dead trips, expired ACCESS does not, missing field fails open), and `sh tools/fixtures/f/fleet_login_scan.sh` answers it in one command. **Yours, gate 3:** one login per ship is the fix. **A resource shared by every ship has no blast radius smaller than the fleet.**
**`20260905`'s landed rows** rest on their three shelves, recited on the [`092312` shelf](archive/20260906-092312_itinerary-landed-accounts.md).
**`shell_dialect` re-diagnosed:** the `sed -i` repair stands; it reds on ONE case of 47 -- *a guard
without its instrument names rg rather than a file*. `shell_portable_control.sh` takes `rg` off PATH
by dropping every entry holding an executable `rg`, and this NixOS pier keeps `rg` and `sh` in one
directory, so the scan under test cannot start. A pen of symlinks to every tool but `rg` is the fix.
**Hot pass `20260906.102004`: 138 guards, 135 green, 0 red, 3 gated, 789s** -- `tree_moved=no`; the cold open's one red was `standing_equipment`, closed as `%475`.
**`%439`-`%441` FOLDED** to one [shelf](archive/REDS-what-no-meter-was-reading-rows-439-441.md): three claims where no instrument reads.
**`%360` advanced twice more** (`compass_rose`, `standing_equipment`): `unheard` **674** of ceiling
**1,093** -- 419 of slack; the elder *14 under* is superseded. **Yours.**
**Still open:** `glow/rune_shape.rye` width custody; `%281`/`%291`. **(%347):**
`pond/enclosure_policy.kyri` 8,120/8,192; yours.
**THE LIVE FRONT NOW FOLDS** (`20260905.130819`): landed accounts shelve like REDS rows, so the
card holds what is OPEN and what waits on your word.
**All three ships sail** (`20260905`). **Gate 3 stands:** `.gnupg-rye/` holds
`private-keys-v1.d/`, and **per-tree GNUPGHOME is the only shape that works jailed** -- yours.
**52 external utilities across 2,969 tool scripts. `rg`: 992 sites, ONE probe. `mktemp`: 353
sites, none -- and not POSIX since 2008.** The tree already wrote the cure,
`tools/fixtures/s/shell_portable.sh`, and **38 files source it, 1.3%.** The design names three
tiers -- **granted** (POSIX), **carried** (we ship it), **borrowed** (probe, fall back, announce) --
seated in Tally as a bounded grant, carried by Caravan as a capability, declared through Mantra.
**The reflex itself LANDED** (`%445`, folded above); the three tiers and the roster stay yonder, yours.

**Worth your word, still unanswered** (condensed out under the old ceiling `20260904`, carried
back now that there is room): nothing in the ledger shows a red is *being worked*, so two hands
spent one morning on the same line. **Should an OPEN row carry a claim -- a seat and a stamp, at
start rather than at landing?**
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

Seated ladders: **HAWM - TUBE - ZETA - JABS - LULU - STOA - SETU - SUNN - POLE** (elder) - **SOON - JARL - BUHR - TACT** (Compass Chapter). Draw before you number: `.claude/rules/waymark-ladders.md` - `tools/w/waymark_derive.rish`. Claims: `waymarks/`.

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

**BOOKED `20260906` -- vendor+seed laps C-H, then gate `%1`:** [shapes and traps](../active-development/20260906-125757_the-remaining-laps-of-the-vendor-and-seed-program.md). Claimable.

Ranked Lindy-first and crux-first, with costs, gates, and falsifiers, in
[`../expanding-prompts/20260823-124407_the-ranked-remainder.md`](../expanding-prompts/20260823-124407_the-ranked-remainder.md);
the measurement class behind it is
[`../active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md`](../active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md).

**Named and waiting on their own lap:** the **fascia weave** (39 browsed `active-designing/`
documents); ten pages wanting a
Status line; the **`constels/`** room and the **kres/kresfa chapter** (seated
`20260823.122619`). Two i10 ratchets, migrate-on-touch: 26 `parseInt(` sites, 14 over-70
functions. Third mitra shed prepped (`SHRED_PREP.md` Class H), cut RED until circled.

## Prior laps -- landed, with the detail in the log that recorded it

The logs keep the account; earlier rows are shelved in
[`archive/`](archive/) under `itinerary-settled-decisions` and `itinerary-landed-laps`.

| Landed | Round | Log |
|---|---|---|
| `20260906.153324` | Two ships, one guard, and a reach of 19 in 274 | [log](../session-logs/date/20260906/20260906-153324_two-ships-one-guard.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
