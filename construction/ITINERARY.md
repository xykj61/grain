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
- **Stamp and name, never an ascending mark.** Mark a lap by its one-clock stamp and a plain name -- `the standing movement (20260821-142939)` -- rather than `Fold AI`, `f0-f63`, or `X0/X1` for planned work. Count a total with `git log --grep ... | wc -l`. Waymarks stay (names, not counts); `rung` stays where a real ladder exists in code. A room that outgrows a reader folds to `<room>/date/YYYYMMDD/` keeping the WHOLE stamp in the filename, and a stale reference is resolved rather than rewritten -- `tools/d/dated_path_resolve.rish`. No fold ships without `tools/d/dated_path_witness.rish` GREEN, and a REDS fold runs through `tools/fixtures/reds_fold.sh`. Rule: `.claude/rules/stamp-and-name.md`.
- **The amend behind the empty-index check** (`20260827`, %255 closed): between commit and nib amend run `test -z "$(git diff --cached --stat)"` -- an occupied index refuses the amend.
- **Fetch-before-book** (`20260827`, %230/%252 closed): read a REDS row number only after `git fetch xy`; a collision renumbers to the fetched head.
- **Spelling: American.** Use `color`, not `colour`; normalize `colour -> color` on touch. This is a USA project.
- **Style sweep before every send** -- Radiant pass over the round's prose (Twilight for a night piece), register only never a claim. Seed section 6.
- **Rota of the canon.** Each lap, deep-read ONE ROW of the 5 x 3 council grid in `recursion-prompts/seed/autonomous-loop.seed.md` section 1 -- element by modality, three documents per lap, **lap N reads row N mod 5**, so the whole canon returns to awareness roughly once a working day.
- **Roster cold, then hot -- and hold still while it runs.** Open the lap with `sh tools/fixtures/standing_equipment_run.sh` before touching anything, let it finish, and run it again after `git add` as `... --hot` so the green measures the tree the commit ships (REDS %174). A cold open over a dirty index refuses under `run_verdict=lap_unclosed`; `--hot` is how a round claims its own staged paths, and the flags compose (REDS %223). The runner digests the tree at open and close and refuses under `run_verdict=tree_moved` when they differ, since a run spread across two trees answers nothing -- and editing the runner mid-run kills the shell outright (REDS %221). **Counts come from the scan, never here** -- in prose they drift. Roster `construction/standing-equipment.kyri`. A row's `tier` names its clock: absent or `lap` every run, `cadence` the fifth round, when `--all` sings the choirs too. A tier is a cadence rather than an exemption, and a word the runner does not know is refused at zero.
- **A lap ends at the commit, never at `git add`.** `tools/hooks/pre-commit` regenerates `README.md`'s metrics block and `docs-geode/libraries/README.md` when a round adds a witness, and it fires at `git commit`. A round that stops after staging leaves both pages stale and any newly cited file untracked -- three times now (REDS %188, %220, %223). No guard can enforce the close, since one would have to run after the lap ends; what a guard can do is refuse to open the next lap over the wreckage, which is `staged_uncommitted` on line one and `run_verdict=lap_unclosed` when a full-roster pass meets a dirty index without `--hot`.
- **Grade what you touch.** Every document, comment block, or design the lap opens gets one reading: `sh tools/fixtures/qa_report_card.sh <path> --setting door|field|meter --service N`. Four readings meaned to one grade -- Register, Reach, Truth (a gate: under 60 reads F), Service (judged against this card, in four questions: named, reached, current, and which side it carries -- public `grain-os/grain`, working `xy`, or both). **B or better stands.** Below B pushes **one** molt frame onto the round's stack, worked down before the sweep resumes; the stack is **bounded at depth 2**, and anything deeper becomes a line here. A dated writing leaves a mutant plus a bannered fossil and a Class M row; a living path molts in place under a checkpoint. **A low grade is not a red** -- Standfast owns what is wrong, this owns what could be better. **Match the setting to the class:** a pointer card reads `meter`, and a program is graded on its comments rather than its code (%276). Rule: `.claude/rules/quality-assurance.md`.
- **Reds first.** Close the open agent-closable rows in `construction/REDS.md` before new work; a red you cannot close is surfaced like a gate rather than routed around.
- **Read scope -- open shelves and closed stacks** (`20260827.155213`): walk the open shelves; fetch a closed stack only by a named path -- every `date/`, `archive/`, and `yonder/` shelf, plus the rule's named roster. Never `ls` the root (`MAP.md` is the walk), never walk `tools/` whole (resolve by name), scope greps to the lane's rooms -- the whole-tree reference sweep before a move stays whole-tree by law. **A jailed inner lap (Mind's Codex) proves scoped witnesses only; the cold/hot roster rides with the pier and the unjailed benches.** Rule: `.claude/rules/read-scope.md`.
- **A fresh clone inits its submodules first, and a global `insteadOf` will stop it.** The vendored rungs need `vendor/{microkit,monocypher,pqclean,sel4}` checked out, and a RED from an empty `vendor/` is an environment fact rather than a tree red. A host that rewrites `https://github.com/` to ssh (this bench does) cannot clone the public third-party submodules at all, since the key has no rights there -- `GIT_CONFIG_GLOBAL=/dev/null git submodule update --init <path>` clones each one over plain https without touching the host's config. `--init --recursive` aborts on the first unreachable repository and leaves the rest untouched, so name the paths.

### Seated, and still live

- **The panchanga** (seated `20260826`): rings of five over the rota of fifteen -- orbit 15 - quest 75 - journey 375 - equinox 1,875 - **chapter** 9,375; *chapter* replaces *season*. Charter: `foundations/20260826-014901_the-panchanga.md`.
- **The six bodies, roles swapped** (`20260827.155213`): **Mind** (Codex/ChatGPT macOS, its own clone -- Brushstroke-Surf, SkateCore) + **Mystery** (Framework Desktop -- Android/AppImage); **Sound** (Claude Desktop macOS -- interface Glow, **language custody**) + **Silence** (macOS Terminal -- infrastructure Glow); **Dream** (**Codex in ai-jail on the pier** -- Caravan-Tally-constellation) + **Hush** (Framework terminal -- Pond, adaptations). Charter: the six-bodies page, `20260827.155213`, in `active-designing/`.
- **STANDFAST -- the fusion build** (`20260826`, Keaton's word): build the granted reprove-only-what-moved ruling (`20260825.181028`) before other Sound work -- a derived file-to-witness map, hit-rate and lap-tail gates proven both ways; scoped runs each lap, the full choir on cadence laps. Confidence per minute is the reward.
- **The optimization spine CLOSES, five of five** (`20260826`, Sound): wrap named room-wide, the bound in its own name, the drain a replayable fold, the region base derived from its index (twelve windows abutting), the wafer's first consumer named. Witnesses in `tools/ca/`.
- **SEATED -- Pond completes the enclosure** (`20260826`): the 75-round quest retiring ai-jail -- CLI and callings finishing under Sound; **ai-jail docs stay accrete-only until the replacement is tested and audited**; the switchover and the jail's deep debride stay gated (%5). Plan: `expanding-prompts/20260826-033051_pond-completes-the-enclosure.md`.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds, three fives; sources reborn in `dexter/`, elders stand until successors GREEN. Door: `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** standfast (five rounds, `cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (rounded shape law, tileable brushstroke, five rota encapsulations, gate %6); the **WADE journey** double-seat (5 quests, 25 orbits, 375 rounds; plan in `expanding-prompts/`).
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

**Git nib:** `d75f9fac60` -- this round's parent.

**Now.** **glow/gen folds by letter, and the compiler leads the way.** The two import-path
sites in `glow/glow_run.rye` (the cross-desk named-cast and the compose-lib lower) build
`glow/gen/{c}/{s}.glow` from the stem's own first letter, every desk stands in its letter
room or under `hoon-study/`, the room joined `room_bound_scan.sh`'s ENFORCE_ALL roster, and
`tools/t/tool_path_resolve.rish` already recovers a stale flat reference by its letter rule --
one of `%301`'s five booked folds, closed on metal `20260828`.

**MANY HANDS + the skills door** (granted `20260828`, Keaton's word): every launch card may
spin up and manage multiple CLI agents -- custody gates stay MANUAL, one writer per checkout --
and the root `SKILL.md` opens the Spellbook, the Chemical Formulas, and New Gauge Civic TAME
as one skills door.

**`%306` and `%315` CLOSED** (Pond): the Constel names redrawn **vowel-free**, both proofs now
standing on all five; the **pre-amend** nib names **HEAD's parent**.

**Still open:** the **width ratchet** -- `glow/rune_shape.rye` publishes `usize` in 5 fields and 5
accessors; moving it REMOVES casts at 16 and 17 sites; 59 gate fixtures await his word.
`declared_ceiling` on `chatgpt-mind.sh`'s bound-copy and **MIND's crux**, SkateCore: both Mind's.
`%281`/`%291` -- one tree per star, or a lock -- stay his; the spine closed the ledger half.
**Two seats:** who owns the Constel predicate (`split_digit_absent=6`, where `generate()` draws);
and `reds_fold.sh` refusing any row carrying OPEN, so a closed-by-accretion row never folds and
the pin stands over its bound.

**The next doors.** Dream: Caravan and Tally green, then the constellation table. Kyri: the Glow
tree moves, then FORA31 (`approve all doors`, `20260827`).

---
## Landed arcs

Mandate, the Acme DX chapter, the CION ratchet, **AHOY** beside **WADE**, the Singularity
foundation, **BUHR**'s MCP surface, the 1,024-round itinerary, **TACT** Journeys 1, 2 and 4,
the recursion cellar, the image module, the Constel quorum, the rune naming -- proven on metal,
the account in `session-logs/`.

## The Compass Chapter -- OPEN `20260809.021829` (Keaton's word)

**256 rounds - four equinoxes = four compass directions.** Nesting: **Round - Quest 4 - Journey 16 - Equinox 64 - Chapter 256**.

| Order | Equinox | Waymark | Holds |
|---|---|---|---|
| **1 -- OPEN, the finishing edge** | The Language | **SOON** [x] | Rishi language spine complete; Brix-infuse, PLEAC, the cookbook in the interpreter, TAME core/shelf; all eight Aurora boot stages cross-building freestanding `riscv64`. Open: Aurora |
| **2 -- word-gated** | Identity & Network | **JARL** | Kumara (5 tilaks) - Comlink turn-route and live handshake - d12-d60 topology - the settlement constellation - Vault, Mandate, Scribe |
| **3 -- word-gated** | Surface & Intelligence | **BUHR** | Realidream DAG surface - the four voices - MCP-in-Bron - Tablecloth |
| **4 -- word-gated** | The World | **TACT** | Ship-Pilot - publishing - Grainphone - commerce - CONTRIBUTING four-doors - Grain Energy PBC |

**Now at JARL.** Four seats witnessed GREEN -- identity, network, topology, settlement -- all five
constellation transitions holding every refusal. The **next-chapter breach is OPEN `20260810`**:
Pond seated as the application module with Pool retired into it, Bron -> Kyri, Kyri the one voice,
and the loadable skies still to run, each its own signed round. Charter at
[`../expanding-prompts/date/20260810/20260810-000032_the-next-season-breach-charter.md`](../expanding-prompts/date/20260810/20260810-000032_the-next-season-breach-charter.md).

---

## Waymarks

Seated ladders: **HAWM - TUBE - ZETA - JABS - LULU - STOA - SETU - SUNN - POLE** (elder) - **SOON - JARL - BUHR - TACT** (Compass Chapter). Draw before you number: `.claude/rules/waymark-ladders.md` - `tools/w/waymark_derive.rish`. Claims: `waymarks/`.

---

## Pier & hands

- **Pier path** -- `~/grain`, which persists across jail resets - agent `home-xy-grain`.
- **Lane** -- every **send** pushes both `origin` (groupproject405) and `xykj61`. ls-remote guard first; `origin` may 403 from the cloud (home pier closes the gap). Map: [`../PUBKEYS.md`](../PUBKEYS.md) - [`../context/REMOTE_ROSTER.md`](../context/REMOTE_ROSTER.md).
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

1. **The AHOY3 final seed force-push** -- **DONE `20260812`** on Keaton's word; the seed stays a single force-push commit, author *Grain OS*, unsigned by design. Each refresh takes its own word, and one is granted below. Full row: [`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md).
2. **Provisioning or paying** for any cloud/VPS/Pond/subscription (Vultr SEA IaC, WADE2/3) -- agents author IaC; Keaton provisions and pays.
3. **Moving funds, holding keys, or opening any custody/wallet/payment rail** -- Dimeroll records facts only; disbursement waits on licensed counsel.
4. **Generating Keaton's own Kumara instance** from his real seed/keeper -- his hand alone.
5. **Deep debride / history rewrite + force-push** of the living tree -- named target, Keaton's explicit word.
6. **Seating a new module in a collaborator's domain** (e.g. DJINN's surface lead) beyond authored implementation-floor code -- the invitation and lead are the collaborator's to accept.

7. **Reconciling the 36 drifted `.claude`/`.cursor` rule pairs** (REDS %194) -- the drift runs **both ways**, so a bulk merge in either direction silently deletes a live safety rule and each pair is its own reading. `sh tools/fixtures/rule_twin_scan.sh diff <name>` shows one; `rule_twin` holds the count under a ceiling that only falls.

Everything else -- design, code, witnesses, docs, weaves, seed *projection* (not push), reds -- is agent-doable and does not wait.

**Seed cadence -- SETTLED `20260826`: cut.** Gate %1 governs alone, so each refresh takes its own
word and no count publishes anything; the two-readings disagreement that stood here is closed.
**One wart:** `sow_project.sh`'s sed-copy drops the exec bit on the seed's `tools/hooks/commit-msg`,
so the armed-wall promise rides on the publisher.

---

## Open doors (awaiting Keaton's word)

| Door | Kind |
|------|------|
| **Next JARL step** -- escape, membership-commitment shrink, or the scarcity call | live |
| **The Glow tree, and FORA31** -- GRANTED `20260827` (`approve all doors`): the `src/` room names (205 refs), `loops/<body>/` (54), then the socket, then the **deep debride** on its own precondition. The `glow/gen/` letter fold landed `20260828`. All in `active-designing/20260827-174816` | **GRANTED** |
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

**Named and waiting on their own lap:** the **fascia weave** over thirty-nine browsed
`active-designing/` documents; **`docs/STOA.md`** at 166 lines against the `<=80` its title
declares; ten pages wanting a Status line; the **`constels/` room** (Kumara live implementations
from kres and brix templates, feeding **Growthcircle**); and the **kres / kresfa contract language
chapter** -- the last two seated by name `20260823.122619`, each wanting its own design round.

## Prior laps -- landed, with the detail in the log that recorded it

This card keeps the live edge; the logs keep the account. Earlier rows are shelved at
[`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md)
and [`archive/20260825-003210_itinerary-landed-laps.md`](archive/20260825-003210_itinerary-landed-laps.md).

| Landed | Round | Log |
|---|---|---|
| `20260828.121218` | %306 redrawn vowel-free, %315 closed -- one Constel law, a nib the fleet resolves | [log](../session-logs/date/20260828/20260828-121218_the-name-that-passes-both-proofs.kyri) |

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
