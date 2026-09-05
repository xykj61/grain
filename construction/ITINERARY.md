# ITINERARY -- living operator card

**Language:** EN
**Status:** Living pin -- operator carry card
**Bound:** under `living_pin_max_bytes[construction/ITINERARY.md]` (32768, derived and seated `20260904.204611` on Keaton's word -- 16 standing directives x 512, plus 8,192 for the live front, plus 16,384 for the durable spine; the general bound stays 24,576)
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

**Git nib:** `e831f252cb` -- HEAD's parent, resolvable everywhere (%401).

**Now.** **A control that names a machine cannot be run on the fleet it guards.**

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

**Sibling finds:** Mystery's module-label guard fails open on BSD grep; portable, it finds elder
labels in `tools/gen/chapter/fascia_metric_v0.rish`. **Tablecloth, two, cross-lane:** its name desk
reads one of `max_name`'s two call sites (`parse_manifest` reads it too, over the same fixed
`[max_name]u8`), and four `*_example_missing` verdicts carry no control case -- deleting the
`example` line lands on `placard_wrong` one reading earlier. **Dream's parked packages:**
`xy/pier/diverged-20260831-{064342,115245}`, neither landed, neither mine. **CION:** `drey`'s rung marks are the retired form (%329). **Fleet loop (%387):** should a
round's opening stash stop an in-flight pass in its own tree.

**Petrichor's `%424`** (library index credited a room for the interpreter) and the `grep`-shim
finding are on the [landed-accounts shelf](archive/20260905-131102_itinerary-landed-accounts.md).
**The stash is restored.** Its row took four numbers and its stamp took none, and `%435` below
made it five laps running -- **the standing evidence for your open question**: should an OPEN row
carry a claim, a seat and a stamp, at start rather than at landing. Take the number from `--next`,
never from the one written in the row.
**`%435` CLOSED -- two foundations were rewritten into their own ancestors and three instruments
read it as correct.** A molt leaves a provenance line naming the elder; `0877e2b5a`'s repoint read
it as a citation and aimed it at the mutant's own name, so `single-stranded` (the rota's Air-fixed
seat) called itself its own reimagining, and `f758efdb2` shed the elder hours later. **Nothing saw
it because a self-link resolves:** the link scans test `[ -e ]` and the card scores Truth by
counting paths that FAIL to resolve, so the page read **A+/98**, `truth=100`, on a false first
sentence -- **`%430`'s shape one day apart, a Truth measuring the wrong thing where a Register
measured nothing.** All three repaired pages grade exactly as before; that is the evidence. Loom
`provenance_self_reference`, rostered at birth, gated at zero, replayed against HEAD; 35 of 5,455
self-link, two were claims. **`--next` read mid-rebase answers from a contaminated tree** -- 436
over my own unshared row where the spine's highest is 434, `%428` in the ledger's instrument.
**Pheromone's:** `shell_dialect` reds on two `sed -i` in `fleet_key_locality_control.sh`:61,65.
**`%427`-`%429` folded** to the
[instrument-room shelf](archive/REDS-the-room-the-instrument-stood-in-rows-427-429.md), whose own
header carries what runs through them.
**`%430` OPEN -- a floor that refuses to score must also refuse to vote.** The report card frees
Register under 8 sentences, prints `reported, not scored`, and divides by four anyway: **560 of
870** pages carry a blank voting **100**, **206** above Door's ceiling, **176** at B or better.
`libraries/README.md` reads **A/94** on one 100%-negative sentence of 13 words. In lane:
`tutorials/README.md` is **scored** now, B/84-on-a-silence to an earned **B+/89**. The general fix
is **derivable** -- free only where one sentence could cross the ceiling, `|share-20| < 100/n`; 88
become scored, 472 stay freed -- yet it edits a seated assertion: **your word.** Restored from
`stash@{0}` exactly as this card derived it; the stamp `122517` never moved.
**`%431` OPEN -- `commit_message_guard` is RED here, and the gate that explained it is gone.**
`%423` reconstructed `publish-seed.sh` on Incense and lifted `gate %1` in the same lap, on exactly
the right reasoning. Only one of the two could travel: the publisher is **untracked at the root by
design** (`.gitignore` `/*`), the roster is tracked. Here `20260905.135216`: **25 planted cases
pass, 0 fail**, `GUARD_OK`, **ten of eleven readings green** -- `SEED_PUBLISHER_ARMS 0` alone reds
it. So two of three trees pay a **full cold pass every lap**. **A repair proven on one tree and a
claim published to all of them must not ride in one commit; the tell is that the repair is
untracked.** The durable shape is `birth_a_clone` reconstructing it -- **yours, gate %1.**
**Still open:** `glow/rune_shape.rye` width custody; `%281`/`%291`. **(%347):**
`pond/enclosure_policy.kyri` 8,120/8,192; yours.
**Landed this chapter** -- `%374`'s gate build, six utility fetches with their thanks, the naming
study, the seed publisher, and rows `%408`, `%414`-`%424`: whole on the
[landed-accounts shelf](archive/20260905-131102_itinerary-landed-accounts.md). **BOOKED FOR PETRICHOR -- docs-geode carries the mark law.** Earth-Cardinal on the council rota
now reads `foundations/20260905-154954_the-clock-and-the-mark.md` (the clock that orders, the mark that promises only what
the work can keep). The compressors and the library index are petrichor's lane: weave the new
foundation into `docs-geode/` where the naming and marking pages already teach, and grade what you
touch. Gated by `announced_length` on the roster, GREEN at zero.
**Mantra now has standing guards** -- 20 witnesses seated (`tier_lap` 113->121, `tier_cadence`
25->37, +39s), after measuring that the tree's most-depended-upon module (120 inbound Rye files)
had zero. The unbuilt half is charted in
[Mantra was named for the weave](../active-designing/20260905-153729_mantra-was-named-for-the-weave.md).
**ripgrep FETCHED `20260905.130819` closes the order** -- **Unlicense OR MIT**, the freest of the six
([thanks](../gratitude/burntsushi-ripgrep.md)). **The measurement is about us:** rg stands at
**1,376 sites**, more than any borrowed tool, and **1,286 are `-q`/`-qi` -- exit code only**. So
**93% of our use is a predicate**, and a re-grow owes not a grep but a bounded existence test over
the tracked set, which `git grep -q` already is. **Met the same day:** `grep` here is **ugrep
7.8.4** and refused a regex GNU grep accepts -- **a familiar name is not a familiar behaviour.**
**`%423`-`%426` CLOSED**, whole on the
[what-a-script-assumes shelf](archive/REDS-what-a-script-assumes-rows-423-426.md): **a script is
quiet about the one thing that changes when it moves.**
**THE LIVE FRONT NOW FOLDS** (`20260905.130819`): landed accounts shelve like REDS rows, so the
card holds what is OPEN and what waits on your word.
**All three ships sail** (`20260905`). **Gate 3 stands:** `.gnupg-rye/` holds
`private-keys-v1.d/`, and **per-tree GNUPGHOME is the only shape that works jailed** -- yours.
**52 external utilities across 2,969 tool scripts. `rg`: 992 sites, ONE probe. `mktemp`: 353
sites, none -- and not POSIX since 2008.** The tree already wrote the cure,
`tools/fixtures/s/shell_portable.sh`, and **38 files source it, 1.3%.** The design names three
tiers -- **granted** (POSIX), **carried** (we ship it), **borrowed** (probe, fall back, announce) --
seated in Tally as a bounded grant, carried by Caravan as a capability, declared through Mantra.
**The reflex that should not wait for the design: a guard that cannot run its instrument refuses,
and says which instrument.**
**`%413`/`%412` CLOSED** -- the roster's clock went to forking, not reading: **1,510s -> 856s**
across five guards. Whole in the ledger, with the two lines worth carrying: **an empty answer from
a failed instrument is byte-identical to one from a clean collection**, and **before you make an
expensive thing rare, find out whether it is expensive on purpose**.
**`%420`'s named-not-built assert** -- a cardinality reading over the census headline, still owed on the lap that next opens `reds_ledger_monotone`.
**Six ships, one baton** (`tools/l/fleet_baton.txt`, prepended; a seat prompt is its lane stanza).
**berthed** `20260904`: **bakery** (core infra, Lindy/crux), **diffuser** (moonshots, each with its
falsifier), **grass** (four audits). Birth plus `claude login` -- both a hand.
**`%411` and `%410` CLOSED** -- four behaviors every ship performed with no rule behind them (**a gap nothing misbehaves over is a gap no meter finds**), and a bound exception no guard had ever been asked to honor (**a conditional only one input reaches has been tested by nothing**); both whole on the [408-410](archive/REDS-what-nothing-misbehaved-over-rows-408-410.md) and [411-413](archive/REDS-what-a-wrapper-inherits-rows-411-413.md) shelves.
**The aroma breach (`20260904.214754`, Keaton's word).** *Smell* retires from living instruction, twice: the
earth row **breathes in** (aroma, scent), and a code *smell* is a **tell**. The threshold page is
`foundations/20260826-021735_earth-the-row-that-breathes-in.md`, its elder basename LISTED as a
deliberate absence so the census reads intent. **Working-tree depth, not deep** -- history keeps
what history is for. **New Gauge, Radiant and Twilight are G-friendly by default**; a higher rating
is opt-in for one named round and buys precision, never coarseness. Rule:
[`vocabulary-aroma`](../.claude/rules/vocabulary-aroma.md).
**The card's bound is raised to 32,768 on Keaton's word** (`20260904.204812`), derived rather than granted:
16 standing directives x 512, plus 8,192 for the live front, plus 16,384 for the durable spine --
measured at 7,008 / 5,161 / 12,406 on the day. **The general bound stays 24,576.** The card is read
WHOLE every lap, so this costs ~2k tokens per lap per body and the law names that cost; the
measured alternative was seventeen condensations in one session to fit three rows and a launcher.
`SHRED_PREP` is NOT raised -- it folded a completed shed instead, because a finished section
belongs on a shelf and only a page whose living parts outgrew the number earns a new one.

**Worth your word, still unanswered** (condensed out under the old ceiling `20260904`, carried
back now that there is room): nothing in the ledger shows a red is *being worked*, so two hands
spent one morning on the same line. **Should an OPEN row carry a claim -- a seat and a stamp, at
start rather than at landing?**
**`%409` CLOSED** -- one seat table, six copies, two drifted; whole on the
[rows 408-410 shelf](archive/REDS-what-nothing-misbehaved-over-rows-408-410.md).
**`%408` CLOSED** -- `agent-jail.sh` bound `~/.claude.json` only when a file **only the jailed
Claude could write** already existed, into a tmpfs the exit discards, so onboarding ran on every
launch and its picker previewed a light scheme reading as invisible text. Seeded and bound.
**NixOS was not at fault**, measured.
**Fleet:** three Earth trees, six aether seats **parked**. Charter
[`seat-table-written-once`](../active-designing/20260904-175200_the-seat-table-written-once.md)
**steps 1-4 LANDED**. **The molt breach is enforced** -- a living launcher filename carrying a
modality word without the elder banner reds at zero, so the guard catches the NEXT one. Captain
prompt molted `20260904-193221`: the pier's tree is `~/grain-incense`, no `~/grain` on Dallas.
**Yours, two (%417).** A **guided map** fits neither shape offered: `MAP.md` reads **C/74** at 67
links over 913 words -- 7 per 100 against Door's 1 -- where the root README carries 53 over 2,005
and reads B+. The index door frees the rate only under 100 words, a link list rather than a walk.
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

The logs keep the account. Earlier rows are shelved at
[`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md)
and [`archive/20260825-003210_itinerary-landed-laps.md`](archive/20260825-003210_itinerary-landed-laps.md).

| Landed | Round | Log |
|---|---|---|
| `20260905.134026` | The floor that voted on a silence | [log](../session-logs/date/20260905/20260905-134026_the-floor-that-voted.kyri) |

**One row, on purpose.** A landed lap keeps one line until the next replaces it, its detail left in the log that recorded it, so this card stays single-stranded. (`TASKS.md` and `ROADMAP.md` fused in here `20260823.103804` and are pointers now.)
