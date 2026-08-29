# ITINERARY -- living operator card

**Language:** EN
**Status:** Living pin -- operator carry card
**Bound:** under `living_pin_max_bytes` (24576)
**Voice:** Kyri

## INNER LOOP -- live directives the running loop applies each lap (seated `20260816.214652`, condensed `20260824.060012`)

*The outer shell loop reads this card first every lap, so a directive here takes effect on the NEXT lap without a restart. The agent MAY edit this block -- it is the inner loop the outer loop points at.*

**Directives only.** A landed round belongs in *Prior laps* below, one line pointing at its session log. The settled decisions this block released are held word for word at [`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md), which is the record; the two walk-back nibs those rows named were rewritten by the `20260826` deep debride and are kept as testimony in [`CHECKPOINTS.md`](CHECKPOINTS.md) rather than advertised here (REDS %280).

### Standing, every lap

- **ASCII-first.** Write every new document, comment, and commit message in plain ASCII -- `--`, `-`, `'`, `"`, `->`, `<=`, `gamma_2` rather than em-dashes, middots, curly quotes, arrows, or non-ASCII math. The one exception is a named set of work rounds (a Unicode module's own fixtures). This card was corrupted to mojibake once (REDS %83). Rule: `.claude/rules/ascii-first.md`.
- **Stamp and name, never an ascending mark.** Mark a lap by its one-clock stamp and a plain name -- `the standing movement (20260821-142939)` -- rather than `Fold AI`, `f0-f63`, or `X0/X1` for planned work. Count a total with `git log --grep ... | wc -l`. Waymarks stay (names, not counts); `rung` stays where a real ladder exists in code. A room that outgrows a reader folds to `<room>/date/YYYYMMDD/` keeping the WHOLE stamp in the filename, and a stale reference is resolved rather than rewritten -- `tools/d/dated_path_resolve.rish`. No fold ships without `tools/d/dated_path_witness.rish` GREEN, and a REDS fold runs through `tools/fixtures/r/reds_fold.sh`. **Waymark rungs are the retired form too** (%329): mark a rung by waymark, module or plain name, and stamp -- `FORA31`-shaped counters red `tools/w/waymark_rung_drift_witness.rish`, whose ceiling only falls. New `equinox_eNNN` guards take stamp-and-name (%330 books the family rename). Rule: `.claude/rules/stamp-and-name.md`.
- **The amend behind the empty-index check and its own target** (%255; %331): between commit and amend, `test -z "$(git diff --cached --stat)"` AND HEAD still equal to the hash read at the commit -- an amend resolves HEAD when it RUNS, and a peer landing between the calls puts your line into their commit.
- **Fetch-before-book** (`20260827`, %230/%252 closed): read a REDS row number only after `git fetch xy`; a collision renumbers to the fetched head.
- **Spelling: American.** `color` never `colour`; normalize on touch.
- **Style sweep before every send** -- Radiant pass over the round's prose (Twilight for a night piece), register only never a claim. Seed section 6.
- **Rota of the canon.** Each lap, deep-read ONE ROW of the 5 x 3 council grid in `recursion-prompts/seed/autonomous-loop.seed.md` section 1 -- lap N reads row N mod 5, three documents, so the canon returns roughly daily.
- **Roster cold, then hot -- and hold still while it runs.** Open the lap with `sh tools/fixtures/s/standing_equipment_run.sh` before touching anything, let it finish, and run it again after `git add` as `... --hot` so the green measures the tree the commit ships (REDS %174). A cold open over a dirty index refuses under `run_verdict=lap_unclosed`; `--hot` is how a round claims its own staged paths, and the flags compose (REDS %223). The runner digests the tree at open and close and refuses under `run_verdict=tree_moved` when they differ, since a run spread across two trees answers nothing -- and editing the runner mid-run kills the shell outright (REDS %221). **Counts come from the scan, never here** -- in prose they drift. Roster `construction/standing-equipment.kyri`. A row's `tier` names its clock: absent or `lap` every run, `cadence` the fifth round, when `--all` sings the choirs too. A tier is a cadence rather than an exemption, and a word the runner does not know is refused at zero.
- **A lap ends at the commit, never at `git add`.** `tools/hooks/pre-commit` regenerates `README.md`'s metrics block and `docs-geode/libraries/README.md` when a round adds a witness, and it fires at `git commit`. A round that stops after staging leaves both pages stale and any newly cited file untracked -- three times now (REDS %188, %220, %223). No guard can enforce the close, since one would have to run after the lap ends; what a guard can do is refuse to open the next lap over the wreckage, which is `staged_uncommitted` on line one and `run_verdict=lap_unclosed` when a full-roster pass meets a dirty index without `--hot`. **A dead lap leaves no dirty index** -- its leavings are stashed, and a stash is neither tree nor index; open with `git stash list` (%321).
- **Grade what you touch.** Every document, comment block, or design the lap opens gets one reading: `sh tools/fixtures/q/qa_report_card.sh <path> --setting door|field|meter --service N`. Four readings meaned to one grade -- Register, Reach, Truth (a gate: under 60 reads F), Service (judged against this card, in four questions: named, reached, current, and which side it carries -- public `grain-os/grain`, working `xy`, or both). **B or better stands.** Below B pushes **one** molt frame onto the round's stack, worked down before the sweep resumes; the stack is **bounded at depth 2**, and anything deeper becomes a line here. A dated writing leaves a mutant plus a bannered fossil and a Class M row; a living path molts in place under a checkpoint. **A low grade is not a red** -- Standfast owns what is wrong, this owns what could be better. **Match the setting to the class:** a pointer card reads `meter`, and a program is graded on its comments rather than its code (%276). Rule: `.claude/rules/quality-assurance.md`.
- **Reds first.** Close open agent-closable rows in `construction/REDS.md` before new work; one you cannot close surfaces like a gate.
- **Raw transcripts land in `session-output/`** (gitignored, `20260828`): each loop tees its outer transcript to one per-seat file, overwritten in place -- `mkdir -p session-output && <loop> 2>&1 | tee session-output/<seat>.txt` -- so agents read a peer's full output by path, not by paste.
- **Read scope -- open shelves and closed stacks** (`20260827.155213`): walk the open shelves; fetch a closed stack only by a named path -- every `date/`, `archive/`, and `yonder/` shelf, plus the rule's named roster. Never `ls` the root (`MAP.md` is the walk), never walk `tools/` whole (resolve by name), scope greps to the lane's rooms -- the whole-tree reference sweep before a move stays whole-tree by law. **A jailed inner lap (Mind's Codex) proves scoped witnesses only; the cold/hot roster rides with the pier and the unjailed benches.** Rule: `.claude/rules/read-scope.md`.
- **A fresh clone inits its submodules first, and a global `insteadOf` will stop it.** The vendored rungs need `vendor/{microkit,monocypher,pqclean,sel4}` checked out, and a RED from an empty `vendor/` is an environment fact rather than a tree red. A host that rewrites `https://github.com/` to ssh (this bench does) cannot clone the public third-party submodules at all, since the key has no rights there -- `GIT_CONFIG_GLOBAL=/dev/null git submodule update --init <path>` clones each one over plain https without touching the host's config. `--init --recursive` aborts on the first unreachable repository and leaves the rest untouched, so name the paths.

### Seated, and still live

- **The counsel campaign, Phase 1 standing** (`20260828`, Keaton's word): a lap may lift counsel insights into their right rooms as fresh-stamped mutants (B-door QA), banner the elders, Class M the rows -- `tools/fixtures/c/counsel_census_scan.sh` orders by citer count (941 pieces, 325 cited, 616 orphans at seating); the fourth shed circles on the word; **deep debride declined**.
- **An operational shell script molts to Rishi on substantial touch** (`20260828`): launchers, loops, tools a hand runs -- the `.sh -> .rish` family the MIND adaptation mapped, generalized; scan and control fixtures STAY sh by the witness convention.

- **The panchanga** (seated `20260826`): rings of five over the rota of fifteen -- orbit 15 - quest 75 - journey 375 - equinox 1,875 - **chapter** 9,375; *chapter* replaces *season*. Charter: `foundations/20260826-014901_the-panchanga.md`.
- **The six bodies, roles swapped** (`20260827.155213`): **Mind** (Codex/ChatGPT macOS, its own clone -- Brushstroke-Surf, SkateCore) + **Mystery** (Framework Desktop -- Android/AppImage); **Sound** (Claude Desktop macOS -- interface Glow, **language custody**) + **Silence** (macOS Terminal -- infrastructure Glow); **Dream** (**Codex in ai-jail on the pier** -- Caravan-Tally-constellation) + **Hush** (Framework terminal -- Pond, adaptations). Charter: the six-bodies page, `20260827.155213`, in `active-designing/`.
- **The fusion build -- IN FLIGHT** (`20260828`, the skip word given): a derived file-to-witness map and receipt-gated `--scoped` passes, the full choir on cadence; design `20260825.181028`.
- **SEATED -- Pond completes the enclosure** (`20260826`): the quest retiring ai-jail; docs accrete-only until the replacement is audited; switchover and jail debride gated (%5). Plan: `expanding-prompts/20260826-033051_pond-completes-the-enclosure.md`.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names (`20260816`):** **Scooter** = the CLI chat app on Pond; **Dexter** = the terminal module; **Ember** = the inference vane (`20260827`, REDS `%300`; **Lumen** retired, **Q-vane** a readable peer) gathering Lattice, Lantern, Ember, Scribble.
- **Seated breaches (checkpoint first):** **the vane -> Ember** (`%300`; Q-vane a peer); **Bron -> Kyri** and **Quin voice -> Kyri**; **Oven -> Kiln through history** CUT `20260827.043900`: word-bounded rewrite, HEAD tree byte-identical, testimony protected, re-signed, `xy` force-pushed whole; benches reclone (checkpoint `20260827.040024`).
- **Deep debride SPENT twice** (`20260825` DJINN; `20260826` season -> chapter); the standing grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; re-signing proven (`20260817`).
- **Caravan -- semi-standfast, raised priority.** Caravan work continues, and each module touched gets its opening comment as **Door** prose (*what is this for*) while comments beside a bound stay **Meter** (*why this number*). Keaton's *"kind of an obscure assembly"* is %163 one layer down. State-of-the-art code, explained in common English abstractions, made readable on the lap that touches it.

### The crypto spine, seated `20260815` -- the pointer

Four decisions stand, proven, and held whole at
[`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md):
**Rye first, Glow on green-witnessed Rye**; **Chapter G Cryptography** double-seated; **SHA-3/SHAKE
preferred** for new designs; **Kumara signs with SLH-DSA-SHAKE-256s**, oracle GREEN on metal.
Signing with the maintainer's identity key stays the custody gate; the library is agent-doable.

**Host:** Framework - EDT (`America/New_York`) - Vultr SEA VPS (**AMD 4vCPU/8GB shared - 180GB
NVMe** - never EWR) - this session in ai-jail. Measured on metal `20260821.034037` and held at
([`the bench measured`](../external-research/20260821-034037_the-bench-measured-and-the-standing-gauge-protocol.md)).

*One-page carry card for outer terminal - phone - waymarks. Refreshed when Keaton says **remember**. Debrided to the Compass Chapter `20260809.024320`; those greens live in the code and dated counsel.*

**Git nib:** `5368a0a8df` -- this round's own.

**Now.** **A witness named its build in a comment, and a comment builds nothing.**

**`%334`.** `comlink/bin/` is gitignored, so two Comlink witnesses proved nothing on a clone;
both carry the build their sibling already had, GREEN with the binaries deleted first.
`witness_own_build` ratchets `unbuilt_pairs` at **46** over 35 witnesses, 21 pen behaviors both
ways, `absent_now=14` reported. Comlink's four proofs are named by no runner in the tree.

**MANY HANDS + skills** (granted `20260828`): launches may manage multiple CLI agents; custody
stays MANUAL and each checkout keeps one writer. Root `SKILL.md` opens the three skills. Every
clone seats `ww` (`grain-ww/grain`, gate %1) and `.git/ssh_config_jail`.

**Still open, one structural:** REDS stands at **24,571 of 24,576** even after this evening's fold --
`%334` fit only after four trims, and **%335 could not land at all**, so a full row wants the seat `reds_fold.sh` leaves open. **Width ratchet:** `glow/rune_shape.rye`
publishes `usize` in 5 fields and 5 accessors; 59 gate fixtures await his word. **Mind's:**
the reconnect patch in grain-mind's own stash (review recipe in its log). `%281`/`%291` stay his, as does this
pier's `enclosure.conf`, still pinning two. **Seat:** whether the roster's own witness can
be rostered when its scan reads the card its red would land on.

**Sound:** repoint 3 broken links in `tools/fixtures/r/radiant_pool_scope.md` after the fixture fold.

**Next doors.** Dream: Caravan and Tally. Hush: orbit two's grant set.

---
## Landed arcs

Mandate, Acme DX, CION, **AHOY** beside **WADE**, Singularity, **BUHR**'s MCP surface,
**TACT** Journeys 1, 2, 4, the recursion cellar, the image module, the Constel quorum, the
rune naming -- proven on metal, the account in `session-logs/`.

## The Compass Chapter -- OPEN `20260809.021829` (Keaton's word)

**256 rounds - four equinoxes = four compass directions.** Nesting: **Round - Quest 4 - Journey 16 - Equinox 64 - Chapter 256**.

| Order | Equinox | Waymark | Holds |
|---|---|---|---|
| **1 -- OPEN, the finishing edge** | The Language | **SOON** [x] | Rishi language spine complete; Brix-infuse, PLEAC, the cookbook in the interpreter, TAME core/shelf; all eight Aurora boot stages cross-building freestanding `riscv64`. Open: Aurora |
| **2 -- word-gated** | Identity & Network | **JARL** | Kumara (5 tilaks) - Comlink turn-route and live handshake - d12-d60 topology - the settlement constellation - Vault, Mandate, Scribe |
| **3 -- word-gated** | Surface & Intelligence | **BUHR** | Realidream DAG surface - the four voices - MCP-in-Bron - Tablecloth |
| **4 -- word-gated** | The World | **TACT** | Ship-Pilot - publishing - Grainphone - commerce - CONTRIBUTING four-doors - Grain Energy PBC |

**Now at JARL.** Four seats witnessed GREEN; the next-chapter breach is OPEN `20260810`
(Pond seated, Pool retired, Kyri the one voice; loadable skies to run). Charter:
[`../expanding-prompts/date/20260810/20260810-000032_the-next-season-breach-charter.md`](../expanding-prompts/date/20260810/20260810-000032_the-next-season-breach-charter.md).

---

## Waymarks

Seated ladders: **HAWM - TUBE - ZETA - JABS - LULU - STOA - SETU - SUNN - POLE** (elder) - **SOON - JARL - BUHR - TACT** (Compass Chapter). Draw before you number: `.claude/rules/waymark-ladders.md` - `tools/w/waymark_derive.rish`. Claims: `waymarks/`.

---

## Pier & hands

- **Pier path** -- `~/grain`, which persists across jail resets - agent `home-xy-grain`.
- **Lane** -- every **send** pushes `xy` then `gp405`; ls-remote guard first; `gp405` may 403 from the cloud (home pier closes the gap). Map: [`../PUBKEYS.md`](../PUBKEYS.md) - [`../context/REMOTE_ROSTER.md`](../context/REMOTE_ROSTER.md).
- **Jail authors; host installs** -- agents write inside the enclosure; USB `adb` installs and key ops stay Keaton's hand.
- **Live state** -- `gh` as `xykj61`, **agent-jail GREEN** (`./tools/ag/agent-jail.sh`), tmux `pier` standing.
- **Cursor launch** -- `rishi/bin/rishi run tools/l/launch-cursor.rish --cursor ./Cursor-*.AppImage --gpu`.
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
2. **Provisioning or paying** for any cloud/VPS/Pond/subscription (Vultr SEA IaC, WADE2/3) -- agents author IaC; Keaton provisions and pays.
3. **Moving funds, holding keys, or opening any custody/wallet/payment rail** -- Dimeroll records facts only; disbursement waits on licensed counsel.
4. **Generating Keaton's own Kumara instance** from his real seed/keeper -- his hand alone.
5. **Deep debride / history rewrite + force-push** of the living tree -- named target, Keaton's explicit word.
6. **Seating a new module in a collaborator's domain** (e.g. DJINN's surface lead) beyond authored implementation-floor code -- the invitation and lead are the collaborator's to accept.

7. **Reconciling the 36 drifted `.claude`/`.cursor` rule pairs** (REDS %194) -- the drift runs **both ways**, so a bulk merge in either direction silently deletes a live safety rule and each pair is its own reading. `sh tools/fixtures/r/rule_twin_scan.sh diff <name>` shows one; `rule_twin` holds the count under a ceiling that only falls.

Everything else -- design, code, witnesses, docs, weaves, seed *projection* (not push), reds -- is agent-doable and does not wait.

**Seed cadence -- SETTLED `20260826`: cut.** Gate %1 governs alone.
**One wart:** `sow_project.sh`'s sed-copy drops the exec bit on the seed's `tools/hooks/commit-msg`,
so the armed-wall promise rides on the publisher.

---

## Open doors (awaiting Keaton's word)

| Door | Kind |
|------|------|
| **Next JARL step** -- escape, membership-commitment shrink, or the scarcity call | live |
| **The Glow tree, and FORA31** -- GRANTED `20260827` (`approve all doors`): the `src/` room names (205 refs), `loops/<body>/` (54), `glow/gen/` folding by letter (340 vs 256), then the socket, then the **deep debride** on its own precondition. All in `active-designing/20260827-174816` | **GRANTED** |
| **Breach OPEN `20260810`** -- Pond = application module (Pool retired) - **skies lap 1** - **topology inclusive** (galaxy is star is planet, 720/universe, sponsor by mod, **outfit** roles; 6 witnesses GREEN) - **Kyri** the notation (was Bron) - **Skate** = the social network | breach - live |
| **MOX constellation on SUI** -- `xykj61` as the maintainer's planet; which instantiation answers for which point, and how a planet resolves to a Mycelium store. Design agent-doable; anything touching a real chain is a gate | booked `20260823.184309` |
| **The pen, the gossip, and the derived spine** -- the %230 answer proposed (stamp-keyed rows, number derived at merge); design and read at `active-designing/20260825-205011` - `external-research/20260825-205011`. The seat stays Keaton's | booked `20260825.205011` |
| **Three real MOX, one Constel** -- the rehearsal RUNS (`20260825`): in-process and three-process localhost pens both GREEN; the one ungated seam is a real address. Comlink-served gate and Vultr provisioning stay gates; design at `active-designing/20260825-133156` | booked, rehearsal `20260825` |
| **Reprove only what moved** -- FAST/COLD ruling GRANTED (`20260825.181028`); the two engineering gates (hit rate, lap-tail reorder) are the door. Design: `active-designing/20260825-173153` | granted |
| **Three corridor bundles placed, held at the gate** -- fiber (KC), headwaters (Gallatin), works (Brazos); Laps 6-9 await the word. Prompts: `expanding-prompts/20260825-1719{12,18,24}_*.md` | check-in `20260825.171907` |
| **Kumara seed-key derivation** -- one high-entropy seed in Vault from which the Comlink X25519/Ed25519 and post-quantum SLH-DSA-SHAKE-256s keys derive by domain-separated SHAKE-256, the path carrying a scheme tag and a version. An agent writes and witnesses the derivation against test vectors and fake constel identities and stops there | booked - custody-gated |
| **Keaton's own Kumara instance** -- generate from his real seed + keeper, by his hand alone | JARL - when ready |
| **Held doors** -- TAME core/shelf - Identity Remake/Kumara - Geode - Grainphone - Realidream - Pond seven - data-dignity - succession - Mand ring-3 - O3 gen-home | awaiting Keaton |

*Four resolved rows read whole on the shelf.*
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

This card keeps the live edge; the logs keep the account. Earlier rows are shelved at
[`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md)
and [`archive/20260825-003210_itinerary-landed-laps.md`](archive/20260825-003210_itinerary-landed-laps.md).

| Landed | Round | Log |
|---|---|---|
| `20260828.213503` | Two Comlink witnesses build what they run; the own-build meter seats | [log](../session-logs/date/20260828/20260828-213503_the-build-that-lived-in-a-comment.kyri) |

**One row, on purpose.** A landed lap keeps one line here until the next replaces it.

## The cadence -- CUT `20260826`, gate %1 stays his

No lap publishes on a count; gate %1 stays his, and the live reading sits in *Custody gates*.
Testimony:
[`../foundations/20260823-111029_the-seed-that-ships-every-fifth-round.md`](../foundations/20260823-111029_the-seed-that-ships-every-fifth-round.md).

## The laps

*`TASKS.md` and `ROADMAP.md` fused in here on `20260823.103804` and are pointers now.* The live
work-front is the **Now** block; a landed lap folds into a *Prior lap* line with its detail left in
the log that recorded it, so this card stays single-stranded.

---
