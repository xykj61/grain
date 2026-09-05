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

**Git nib:** `fafdfa9664` -- HEAD's parent, resolvable everywhere (%401).

**Now.** **A rule written six times is a rule six files may quietly come to disagree about.**

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
**MAP QA:** C+/75 this sitting; 0 of 70 unresolved; index door wants under 100 prose words.

**Still open:** `glow/rune_shape.rye` keeps width custody; `%281`/`%291`. **Named (%347):**
`pond/enclosure_policy.kyri` 8,120/8,192; the wall is yours.
**`%374` GRANTED and BUILT.** The roster grows **`gate %N`** beside `tier`/`host`/`capability`,
for **what a maintainer has parked**. A gated red books apart, so `red` means *this guard broke*
again, and a pass whose reds are all gated writes its receipt disclosing what it chained past.
**The gate vocabulary is this card's own custody list, read at scan time**; an unreadable card
refuses every gate. Live: **106 green, 1 red, 4 gated**.
**Shelved:** eleven rows -- [`the recital`](archive/REDS-fold-recital.md).
**`%414`-`%416` CLOSED** -- three launcher and guard faults of one family, each row carrying its
own account. **`%414`:** ai-jail and claude both own `--verbose`; the flags moved inside
`tools/l/fleet_lap.sh` and the loop now stops after three laps dying under ten seconds.
**A wrapper inherits its wrapper's namespace.** **`%415`:** `claude login` writes to the HOST's
home and `--private-home` replaces it, so a pier login reached no tree; the launcher seeds and
refreshes per tree -- **one login per pier**. **`%416`:** `unheard_guard` swallowed both awk passes,
one reading `choirs=0` against a ceiling of 37 -- **a gate at zero fails safe when its instrument
dies; a ceiling fails UNSAFE**, and this tree holds far more ceilings. `instrument_refusal` gates
that shape at **zero from birth** over 676 scans; a deliberate toleration says so at the site.
**The difference between a decision and a swallow is whether anyone wrote it down.**
**The utility yonder, filed `20260905.064341`, AMENDED `20260905.073903` on Keaton's word.**
**POSIX is not this project's floor -- it is the dependency the project exists to leave.** Caravan
is a root task on **seL4's userlevel side**: a syscall interface and **no shell, no awk, no grep**.
The first draft wrote *granted = POSIX* and quietly made POSIX bedrock; it is the BENCH's floor,
not the target's. That makes the count a **re-grow estimate** -- 1,958 `grep`, 645 `sed`, 434
`awk` are Rye somebody must write -- and joins it to the elder
[`useful-utilities`](../external-research/yonder/20260617-201612_useful-utilities.md), which
ordered the same list from the far end. **Permissive generations added:** uutils/coreutils (Rust,
MIT), ripgrep (MIT), **zig-coreutils / zig-utils / dawk (Zig, MIT)** -- the Zig row changes the
order, since Rye compiles through Zig and a Zig awk is readable without a second toolchain.
**Fetch itinerary proposed, nothing fetched:** dawk (crux) - uutils - toybox - sbase/ubase -
ripgrep, each landing in `gratitude/` with a written thanks, `gratitude/utilities/` once there is
more than one. A clone is a hand's act; the word is yours. Study:
[`what-a-harness-promises`](../external-research/yonder/20260905-064341_what-a-harness-promises-about-its-tools.md).
Design: [`the-tools-a-guard-may-assume`](../active-designing/yonder/20260905-064341_the-tools-a-guard-may-assume.md).
**52 external utilities across 2,969 tool scripts. `rg`: 992 sites, ONE probe. `mktemp`: 353
sites, none -- and not POSIX since 2008.** The tree already wrote the cure,
`tools/fixtures/s/shell_portable.sh`, and **38 files source it, 1.3%.** The design names three
tiers -- **granted** (POSIX), **carried** (we ship it), **borrowed** (probe, fall back, announce) --
seated in Tally as a bounded grant, carried by Caravan as a capability, declared through Mantra.
**The reflex that should not wait for the design: a guard that cannot run its instrument refuses,
and says which instrument.**
**`%413` CLOSED (pass now **856s**, from 1,510 this morning) -- three more guards forking per item, and one repair that twice taught a guard to
report a tree it never read.** `tracked_link` forked an awk AND a grep **per link** (~47,700
processes) -> **5s**; `phantom_path` an awk per source and a grep per literal (8,793) -> **6s**;
`declared_model` walked all 14,709 files to find the 1,127 naming a model id -> **5s**. Each output
byte-identical to its elder, every control leg unchanged. **The costly half:** the first rewrite
found its awk helper from `$(pwd)` and sent awk's complaint to `/dev/null`, so in the control's pen
it read **zero unresolved links and passed** -- and the SAME two mistakes sat in `%412`'s
`living_card_ascii` repair from an hour earlier, where no control pens the scan. **An empty answer
from a failed instrument is byte-identical to one from a clean collection**, and the second is the
reading everyone wants to hear. All four now resolve from `$(dirname "$0")` and refuse loudly.
**`%412` CLOSED -- a third of the roster's clock went to forking, not reading.** 111 guards, 1,510s,
**median 2s against a mean of 13** -- five guards held 46%. Two were slow by ACCIDENT:
`living_card_ascii` forked `mktemp`+`iconv`+`rm` per file across **14,709 files** (~44,000
processes, 137s -> **25s** via one awk pass, NUL-delimited); `reds_row_present` asked its script for
row 1, then row 2, to the end -- **411 invocations** each re-reading the whole spine (177s ->
**12s** via `--all`, same sed, same file set, so the authority is unchanged). `sow` at 230s is
expensive ON PURPOSE and moved to `tier cadence`, honest because its act is gate %1, manual.
**1,510s -> 990s, measured** (1,003 projected). **Before you make an expensive thing rare, find out
whether it is expensive on purpose** -- a cadence tier on those two would have hidden 277s of pure
waste behind a slower clock and left the waste.
**Six ships, one baton.** `tools/l/fleet_baton.txt` holds the shared opening ONCE and
`fleet-loop.sh` prepends it; a seat prompt is its **lane stanza** alone. **berthed** (`20260904`):
**bakery** (core infrastructure, Lindy/crux, fleet friction), **diffuser** (moonshots and
whitepapers, every projection with its falsifier), **grass** (four auditing passes). Birth is
`birth_a_clone.rish` plus a `claude login` -- both a hand.
**`%411` CLOSED -- four behaviors every ship performed, and not one was a rule.** Measured across
the 49 rules: `%291` appeared once in passing, **claim-as-override, the council rota, and
GATES-ONLY appeared zero times**. All four are seated in
[`the-baton`](../.claude/rules/the-baton.md), which maps every baton section to its governing rule.
**A gap nothing misbehaves over is a gap no meter finds** -- every ship behaved correctly the whole
time, because every ship was handed the behavior at launch.
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
**`%410` CLOSED -- an exception no guard had ever been asked to honor.** `equinox_e123`'s scan read
the bound fixture **bare**, once, and measured every pin against that one answer. It stood eleven
days because the only excepted page, `session-logs/README.md`, is 7,817 bytes and passed under the
general bound anyway. **A conditional only one input reaches has been tested by nothing.**
**Worth your word, still unanswered** (condensed out under the old ceiling `20260904`, carried
back now that there is room): nothing in the ledger shows a red is *being worked*, so two hands
spent one morning on the same line. **Should an OPEN row carry a claim -- a seat and a stamp, at
start rather than at landing?**
**`%409` CLOSED -- the fleet's only real datum, written six times, two already drifted.**
`seat -> tree -> engine` stood in six places across two files: the loop admitted **six** seat names
where the re-arm reported **nine**, and the elder remap seated that morning lived in one and never
reached the other. `construction/fleet-roster.kyri` holds it once, read by
`tools/fixtures/f/fleet_roster_scan.sh`; all six are lookups. `status parked` keeps the aether
seats readable without pretending they run; `engine field` refuses an unattended lap by name. 28
legs, both sides -- including that a seat name in a loop case arm is a **seventh** copy.
**`%408` CLOSED -- the mount that could only happen once it had already happened.**
`agent-jail.sh` bound `~/.claude.json` only when `loops/claude/dot-claude.json` existed, and the
one process that writes it is the jailed Claude, into the tmpfs `--private-home` discards. So
onboarding ran on **every** jailed launch, its picker previewing a light scheme that reads as
invisible text. Seeded and bound. **NixOS is not at fault** -- the jail drops `TERMINFO_DIRS` and
`LOCALE_ARCHIVE`, both harmless, measured. `agent_jail` was red and unrostered; now rostered.
**Fleet:** three Earth trees, six aether seats **parked**. Charter
[`seat-table-written-once`](../active-designing/20260904-175200_the-seat-table-written-once.md)
**steps 1-4 LANDED**: one table, one reader, one launcher. **The molt breach is enforced** -- a
living launcher filename carrying `planet`/`fixed`/`cardinal`/`dual` without the elder banner reds
at zero, so the guard catches the NEXT one. Elders keep every byte, Class H, cut RED; ship names
untouched. Captain prompt molted to
[`20260904-193221`](../expanding-prompts/20260904-193221_incense-the-field-captain-two-doors.md):
the pier's tree is `~/grain-incense`, and there is no `~/grain` on Dallas.
**Next doors.** Caravan keeps a 5-second seam. Hush: `spool_cloth` eight `ClothError` paths.
**Yours, one.** Door's ceiling is **9** against module heads that run 12-17. Of 163 sampled
programs 115 read below B -- yet **51 sat under the register floor** with nothing measurable,
leaving **64** truly scored at grades 9-23. That second number owns the ceiling question, and
Gauge's own table seats **witness headers** at Meter where this card grades every program head at
Door. Gate %7: quality-assurance additive carried `20260904.103121`.
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
3. **Moving funds, holding keys, or opening any custody/wallet/payment rail** -- Dimeroll records facts only; disbursement waits on licensed counsel.
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

Ranked the Long Return and Lila, with costs, gates, and falsifiers, in
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
| `20260905.073903` | POSIX is the floor we are leaving | [log](../session-logs/date/20260905/20260905-073903_posix-is-the-floor-we-are-leaving.kyri) |

**One row, on purpose.** A landed lap keeps one line until the next replaces it, its detail left in the log that recorded it, so this card stays single-stranded. (`TASKS.md` and `ROADMAP.md` fused in here `20260823.103804` and are pointers now.)
