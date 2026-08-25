# ITINERARY -- living operator card

**Language:** EN
**Status:** Living pin -- operator carry card
**Bound:** under `living_pin_max_bytes` (24576)
**Voice:** Kyri

## INNER LOOP -- live directives the running loop applies each lap (seated `20260816.214652`, condensed `20260824.060012`)

*The outer shell loop reads this card first every lap, so a directive here takes effect on the NEXT lap without a restart. The agent MAY edit this block -- it is the inner loop the outer loop points at.*

**Directives only.** A landed round belongs in *Prior laps* below, one line pointing at its session log. This block held 50,477 bytes on `20260824.060012` and the whole card 47,213 on `20260824.130807`, against the 24,576 it now declares in its own header. The settled decisions it released are held word for word at [`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md). Walk-back checkpoints `7754ccf272` and `d6c02f92cc`.

### Standing, every lap

- **ASCII-first.** Write every new document, comment, and commit message in plain ASCII -- `--`, `-`, `'`, `"`, `->`, `<=`, `gamma_2` rather than em-dashes, middots, curly quotes, arrows, or non-ASCII math. The one exception is an explicitly-named set of work rounds (a Unicode-handling module's own fixtures). This card was corrupted to mojibake once (REDS %83). Rule: `.claude/rules/ascii-first.md`.
- **Stamp and name, never an ascending mark.** Mark a lap by its one-clock stamp and a plain name -- `the standing movement (20260821-142939)` -- rather than `Fold AI`, `f0-f63`, or `X0/X1` for planned work. Count a total with `git log --grep ... | wc -l`. Waymarks stay (they are names, not counts); `rung` stays where a real ladder exists in code. A room that outgrows a reader folds to `<room>/date/YYYYMMDD/` keeping the WHOLE stamp in the filename, and a stale reference is resolved rather than rewritten -- `rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference> [<citing-file>]`. No fold ships without `tools/d/dated_path_witness.rish` GREEN. Rule: `.claude/rules/stamp-and-name.md`.
- **Spelling: American.** Use `color`, not `colour`; normalize `colour -> color` on touch. This is a USA project.
- **Style sweep before every send** -- Radiant pass over the round's prose (Twilight for a night piece), register only never a claim. Seed section 6.
- **Rota of the canon.** Each lap, deep-read ONE ROW of the 5 x 3 council grid in `recursion-prompts/seed/autonomous-loop.seed.md` section 1 -- element by modality, three documents per lap, **lap N reads row N mod 5**, so the whole canon returns to awareness roughly once a working day.
- **Roster cold, then hot.** Open the lap with `sh tools/fixtures/standing_equipment_run.sh` before touching anything, and run it again after `git add` so the green measures the tree the commit ships (REDS %174). **54 guards** stand; the roster is `construction/standing-equipment.kyri`.
- **A lap ends at the commit, never at `git add`.** `tools/hooks/pre-commit` regenerates `README.md`'s metrics block and `docs-geode/libraries/README.md` when a round adds a witness, and it fires at `git commit`. A round that stops after staging leaves both pages stale and any newly cited file untracked, and the next lap's cold roster finds all of it (REDS %188). No guard can enforce this one, since it would have to run after the lap ends.
- **Grade what you touch.** Every document, comment block, or design the lap opens gets one reading: `sh tools/fixtures/qa_report_card.sh <path> --setting door|field|meter --service N`. Four readings meaned to one grade -- Register, Reach, Truth (a gate: under 60 reads F), Service (judged against this card, in four questions: named, reached, current, and which side it carries -- public `grain-os/grain`, working `xy`, or both). **B or better stands.** Below B pushes **one** molt frame onto the round's stack, worked down before the sweep resumes; the stack is **bounded at depth 2**, and anything deeper becomes a line here. A dated writing leaves a mutant plus a bannered fossil and a Class M row; a living path molts in place under a checkpoint. **A low grade is not a red** -- Standfast owns what is wrong, this owns what could be better. Rule: `.claude/rules/quality-assurance.md`.
- **Reds first.** Close the open agent-closable rows in `construction/REDS.md` before new work; a red you cannot close is surfaced like a gate rather than routed around.

### Seated, and still live

- **Seated names (`20260816`):** **Scooter** = the CLI chat app (Talk reimplementation on Pond); **Dexter** = the terminal module (our Dill parallel, affirmed); **Lumen** = the inference vane (renames Quin's Q-vane, gathering Lattice, Lantern, Ember, Scribble). Plan: `expanding-prompts/date/20260816/20260816-222322_dexter-terminal-and-scooter-cli-chat.md`.
- **Seated breaches (checkpoint-first when executed):** **Quin's Q-vane -> Lumen** (rename its references); **Bron -> Kyri** and **Quin voice -> Kyri** (docs-compression season). Each is its own signed round, checkpoint first; none cut yet.
- **Deep debride approved and banked, deliberately unspent.** Keaton granted a deep molt, breach, and debride `20260823.045448` -- renames, reference repointing, commit-message rewriting, force push, reclone accepted. Spent once at the **close** of the sweep it costs one reclone rather than two; re-signing is proven (2,901 commits, `20260817`). Calls it in early: a filename that misleads, or a commit message now known to be untrue.
- **Caravan -- semi-standfast, raised priority.** Caravan work continues, and each module touched gets its opening comment as **Door** prose (*what is this for*) while comments beside a bound stay **Meter** (*why this number*). Keaton's *"kind of an obscure assembly"* is %163 one layer down. State-of-the-art code, explained in common English abstractions, made readable on the lap that touches it.

### The crypto spine, seated `20260815` -- the pointer

Four decisions stand and are proven: **Rye first, Glow on green-witnessed Rye**; **Season G
Cryptography** double-seated, Monocypher-parity in Rye; **SHA-3/SHAKE preferred** over SHA-2 for new
designs; and **Kumara signs post-quantum with SLH-DSA-SHAKE-256s**, both legs kept after
`vendor/pqclean` was vendored and `tools/cr/crypto_slhdsa_oracle_witness.rish` went GREEN on metal.
Signing with the maintainer's identity key stays the custody gate; the library is agent-doable. The
four paragraphs that seated them are held whole at
[`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md).

**Host:** Framework - EDT (`America/New_York`) - Vultr SEA VPS (**AMD 4vCPU/8GB shared - 180GB
NVMe** - never EWR) - this session in ai-jail. *Measured on metal `20260821.034037`: 7,937 MB total,
`nproc` 4, `vda` 193,273,528,320 bytes -- the card had carried a stale `2vCPU/4GB` and a counsel
essay reasoned from it ([`../external-research/20260821-034037_the-bench-measured-and-the-standing-gauge-protocol.md`](../external-research/20260821-034037_the-bench-measured-and-the-standing-gauge-protocol.md)).*

*One-page carry card for outer terminal - phone - waymarks. Refreshed when Keaton says **remember**. Debrided to the Compass Season `20260809.024320` -- the old season marks are gone; their greens live in the code and in the dated counsel.*

**Git nib:** `2a9ccea972` -- the `Region` body lifted into `caravan/region.rye` where five copies stood, and `rye` given a second reading for its std so a host with no `/proc` can build. Suite 109 green.

**Now.** **Quality assurance has a grade, and the grade has a stack.** The negative-share ceiling read
upward is a school grade -- 20% becomes **80, a B**.
[`../tools/fixtures/qa_report_card.sh`](../tools/fixtures/qa_report_card.sh) reads any document,
comment block, or design four ways. **B stands; below B pushes one molt frame**, depth 2.

**%207-%213 -- the invariant arc, corrected ten times.** The **13,235** this card carried fell to
**4,242**, **1,385** on **reachability**, **853** on the label pattern, **400** once reachability
crossed files. crypto was never 57.5% -- **483 lines carry a qualified label** the meter read as absent (**%212**).
**The unlabelled-456 sweep was refused** -- 361 of 377 were test narration inside `pub fn` proof
functions (**%213**). **Cross-file reachability then landed:** the spread reaches a `pub fn` only
when no other module qualified-calls it **and** it returns `void`; **24 behaviors** prove it. **`caravan` swept to 37**, and **20 stay uncovered on
purpose** -- `bounded`, `chain` and `twin` hold a **byte-identical** region body, so a comment costs
triple and the zero-slack carry ratchet reds. **The fold is the answer and wants its own round.**
Carry falls **58,544 -> 58,540**; the suite sings **GREEN across 109 rungs**. **Every room but one now reads 100%** -- 197 blocks across
`image`, `lotus`, `brushstroke` and the tail. **Tree 99%, gap 37, all of it caravan:** 20
fold-blocked and 17 proof. The bin also learned that a file under `fixtures/` is a planted artifact
(a drift copy, an intentional ban violation) and an `assert(` inside a string is prose.

**Landed, and the detail is in the logs**, one line each in *Prior laps* below.

---
## Landed arcs

Mandate, the Acme DX season, the CION ratchet, the **AHOY** front-door season beside **WADE**'s
Bit-Design surface, the Singularity foundation and the Twilight palette, **BUHR**'s MCP surface,
the 1,024-round itinerary, **TACT** Journeys 1, 2 and 4, the recursion-prompts cellar, Season A's
open image module, and the Constel dev-net quorum -- each proven on metal, recorded in
`session-logs/`, rostered on the shelf. Walk-back `221ebba12a`.

## The Compass Season -- OPEN `20260809.021829` (Keaton's word)

**256 rounds - four equinoxes = four compass directions.** Coords **Compass Season - SOON - j1 - q1 - r1**. Nesting: **Round - Quest 4 - Journey 16 - Equinox 64 - Season 256**.

| Order | Equinox | Waymark | Holds |
|---|---|---|---|
| **1 -- OPEN, the finishing edge** | The Language | **SOON** [x] | Rishi language spine complete; Brix-infuse, PLEAC, the cookbook in the interpreter, TAME core/shelf; all eight Aurora boot stages cross-building freestanding `riscv64`. Open: Aurora |
| **2 -- word-gated** | Identity & Network | **JARL** | Kumara (5 tilaks) - Comlink turn-route and live handshake - d12-d60 topology - the settlement constellation - Vault, Mandate, Scribe |
| **3 -- word-gated** | Surface & Intelligence | **BUHR** | Realidream DAG surface - the four voices - MCP-in-Bron - Tablecloth |
| **4 -- word-gated** | The World | **TACT** | Ship-Pilot - publishing - Grainphone - commerce - CONTRIBUTING four-doors - Grain Energy PBC |

**Now at JARL.** Four seats stand, each witnessed GREEN -- identity, network, topology, settlement --
with all five constellation transitions holding every refusal. The **next-season breach is OPEN
`20260810`**: Pond seated as the application module with Pool retired into it, and Bron -> Kyri,
Kyri as the one voice, and the loadable skies still to run, each its own signed round. Full account
on the shelf; charter at
[`../expanding-prompts/date/20260810/20260810-000032_the-next-season-breach-charter.md`](../expanding-prompts/date/20260810/20260810-000032_the-next-season-breach-charter.md).

---

## Waymarks

Seated ladders: **HAWM - TUBE - ZETA - JABS - LULU - STOA - SETU - SUNN - POLE** (elder) - **SOON - JARL - BUHR - TACT** (Compass Season). Draw before you number: `.claude/rules/waymark-ladders.md` - `tools/w/waymark_derive.rish`. Claims: `waymarks/`.

---

## Pier & hands

- **Pier path** -- `~/grain` (persists across jail resets) - agent `home-xy-grain` - Cloud on `xykj61/grain`.
- **Lane** -- every **send** pushes both `origin` (groupproject405) and `xykj61`. ls-remote guard first; `origin` may 403 from the cloud (home pier closes the gap). Map: [`../PUBKEYS.md`](../PUBKEYS.md) - [`../context/REMOTE_ROSTER.md`](../context/REMOTE_ROSTER.md).
- **Jail authors; host installs** -- agents write inside the project / enclosure; USB `adb` installs and key ops stay Keaton's hand.
- **Live state** -- `gh` as `xykj61`, **agent-jail GREEN** (`./tools/ag/agent-jail.sh` for claude and cursor-agent), tmux `pier` standing.
- **Cursor launch** -- `rishi/bin/rishi run tools/l/launch-cursor.rish --cursor ./Cursor-*.AppImage --gpu`.
- **Outer terminal / phone** -- USB/`adb` and phone look stay on the operator desk; prefer git nib + `prin scope` for season state.

---

## Two grains

The private field is `~/grain`; the public template **grain-os/grain** is *projected* by
`tools/s/sow.rish` along the boundary in `template-manifest.bron`, proven clean by
`tools/s/sow_witness.rish` -- no name or key crosses into the seed. The scrub reaches every family
name, prior name, handle, and contact form, case-insensitively, and a leaking file is withheld
whole: privacy over completeness, found and closed `20260810`. Raw PII is **not persisted in-tree**
-- it is held for the **Vault**, custody-first. The publish push is Keaton's hand.

## Shred-prep

[`SHRED_PREP.md`](SHRED_PREP.md) -- Class H fossils - Class O rooms (propose-never-seat) - **Python->Rishi molt seated** (`20260809`, prep only) - shred stays **RED** until circled. **debride** is the stronger word (removes dead history, deep on Keaton's word).

---

## Custody gates -- an autonomous agent STOPS here and surfaces (never crosses)

For any self-paced or outer-jail loop: recur through all agent-doable work, yet **stop and surface -- never cross -- these custody/irreversible/provisioning acts.** They are Keaton's hand by design (custody-first):

1. **The AHOY3 final seed force-push** -- **DONE `20260812`** on Keaton's word; the seed is kept a single force-push commit, author *Grain OS*, unsigned by design. Future seed refreshes stay Keaton's word. Full row: [`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md).
2. **Provisioning or paying** for any cloud/VPS/Pond/subscription (Vultr SEA IaC, WADE2/3) -- agents author IaC; Keaton provisions and pays.
3. **Moving funds, holding keys, or opening any custody/wallet/payment rail** -- Dimeroll records facts only; disbursement waits on licensed counsel.
4. **Generating Keaton's own Kumara instance** from his real seed/keeper -- his hand alone.
5. **Deep debride / history rewrite + force-push** of the living tree -- named target, Keaton's explicit word.
6. **Seating a new module in a collaborator's domain** (e.g. DJINN's surface lead) beyond authored implementation-floor code -- the invitation and lead are the collaborator's to accept.

7. **Reconciling the 36 drifted `.claude`/`.cursor` rule pairs** (REDS %194) -- 40 pairs stand, 4 agree, and the drift runs **both ways**, so a bulk merge in either direction silently deletes a live safety rule and each pair is a reading. `sh tools/fixtures/rule_twin_scan.sh diff <name>` shows any one of them; `rule_twin` holds the count under a ceiling that only falls.

Everything else -- design, code, witnesses, docs, weaves, seed *projection* (not push), reds -- is agent-doable and does not wait.

**Seed cadence, standing at the gate `20260824.112806`.** The projection is current and its four
gates hold on metal, each read alone rather than beside a running roster: `sow_project.sh` copied
**6,961** files, scrubbed **1,066**, withheld **122**; `sow_leak_scan.sh` reads **IDENT_CLEAN**;
`tools/s/sow_witness.rish` reads **NO_PERSONAL**; `tools/s/seed_link_witness.rish` is GREEN. *Read
alone* is enforced rather than remembered -- `sow_project.sh` takes a lock and a second projection
exits 3 (REDS %193). Last published projection `fdaf8e3`. **The force-push to `grain-os/grain` waits
on Keaton's word** -- one line, `bash ~/grain/publish-seed.sh`, and it ships.

---

## Open doors (awaiting Keaton's word)

| Door | Kind |
|------|------|
| **Next JARL step** -- **escape** (a child re-parenting, from the sponsor tilak) - shrink the shared surface to a membership commitment - or the scarcity design call | live |
| **Breach OPEN `20260810`** -- Pond = application module (Pool retired) - **skies lap 1** - **topology inclusive** (galaxy is star is planet, 720/universe, sponsor by mod, **outfit** roles; 6 witnesses GREEN) - **Kyri** the notation (was Bron) - **Skate** = the social network | breach - live |
| **Session-log fold** -- 192 flat logs across four days hold `session-logs/README.md` at 282,139 bytes against the 24,576 it declares. `rishi/bin/rishi run tools/s/session_logs_archive.rish` folds the closed days and repoints the index in one pass; the rule says run it on Keaton's word | live |
| **MOX constellation on SUI** -- `xykj61` as the maintainer's planet; which instantiation answers for which point, and how a planet resolves to a Mycelium store. Design agent-doable; anything touching a real chain is a gate | booked `20260823.184309` |
| **Kumara seed-key derivation** -- one high-entropy seed in Vault from which the Comlink X25519/Ed25519 and post-quantum SLH-DSA-SHAKE-256s keys derive by domain-separated SHAKE-256, the path carrying a scheme tag and a version. An agent writes and witnesses the derivation against test vectors and fake constel identities and stops there | booked - custody-gated |
| **Keaton's own Kumara instance** -- generate from his real seed + keeper, by his hand alone | JARL - when ready |
| **TAME core/shelf** -- lossless-compressed living law over a preserved shelf | proposed |
| **Identity Remake / Kumara** -- the first identity template + Keaton's instance | JARL |
| **Geode / Genode-on-NixOS** -- proven-seat parallel | GATED |
| **Grainphone - Realidream - Pond seven - data-dignity - succession - Mand ring-3 - O3 gen-home** | awaiting Keaton |

*Four resolved rows -- the two batons, the `mold->shape` debride, Brix-infuse, and the waymark debride -- read whole on the shelf.*
---

## Card habits

- **kg** -- keep going, next mechanical lap. **check-in** -- pause for Keaton's word / design. **send** -- commit - push both remotes - merge. **remember** -- reprint this card. **align** -- walk the compass, reconcile plan with green witnesses. **molt** -- prep a fossil for shed. **debride** -- remove dead history (Keaton's word). **shred** stays RED until circled. remember != send != kg != align.
- **Vocabulary** -- the tree seats **shape**, not Hoon's *mold*. Prefer **git nib**. One clock: `TZ=America/New_York`.

---

*Carry lightly. Prefer git nib. `prin scope`. May the season stay clean and the fascia hold.*

---

## Next -- the ranked remainder

Ranked Lindy-first and crux-first, with costs, gates, and falsifiers, in
[`../expanding-prompts/20260823-124407_the-ranked-remainder.md`](../expanding-prompts/20260823-124407_the-ranked-remainder.md).

**Open, named, and waiting on its own lap.** The **fascia weave** over the
thirty-nine browsed `active-designing/` documents, shaped as a living index page per cluster.
**`docs/STOA.md`** at **166 lines against the `<=80` its own title declares**. The ten pages duty 4
names as wanting a Status line. The doc-comment ASCII sweep at **21 `.rye` files in `image/` and all
240 in `lotus/`** (13,456 characters). And **a split moves bulk rather than removing it**:
`caravan/LADDER.md` stands at 366,216 bytes and `image/PHOTOS.md` at 261,894, correct for a
reference page a reader reaches on purpose. The class is named in
[`../active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md`](../active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md).

**Measured `20260824.170904` -- the comment dial answered.**
[`../tools/fixtures/comment_dial_scan.sh`](../tools/fixtures/comment_dial_scan.sh) read all **1,891**
authored modules. **Door coverage is closed** at 99.6%. **The setting histogram lives** once `///`
declaration docs leave the denominator -- median 14 becomes 53. **The `// invariant:` law read 59.6%
there and reads 99% now (`20260825`)**, gap 17, all `pub fn check_*` proof functions -- the figure
moved because the meter got honest, ten corrections deep (REDS %207-%213). **A ceiling is Keaton's
number to set**, so no ratchet is seated. Verdict:
[`../active-development/20260824-170904_the-denominator-was-the-whole-question.md`](../active-development/20260824-170904_the-denominator-was-the-whole-question.md).
Beside it, **half of Service may be countable** -- named and reached from the citation graph,
current and carried left judged -- argued with its own trap named at
[`../active-designing/20260824-165106_what-part-of-service-can-be-counted.md`](../active-designing/20260824-165106_what-part-of-service-can-be-counted.md).

**Booked `20260825.000640` -- proving a host we do not have.** All 54 guards run on this Linux
pier, so a claim true only elsewhere is unprovable here; REDS %214 cost a first macOS
build. Four answers, and the measurement that decides:
[`../external-research/20260825-000640_proving-a-host-you-do-not-have.md`](../external-research/20260825-000640_proving-a-host-you-do-not-have.md).

**Two directions seated by name `20260823.122619`**, each wanting its own design round: the
**`constels/` room** -- Kumara live implementations from **kres** and **brix** templates, in Kyri
and Bron, at `constels.com` and `constel.net` ([`domain-registry.bron`](domain-registry.bron)),
feeding the **Growthcircle** integration -- and the **kres / kresfa contract language season**, the
`.{extension}` macro languages fusing Glow runes with Lisp macros.

## Prior laps -- landed, with the detail in the log that recorded it

Each line names a round and where its numbers live. This card keeps the live edge; the logs keep the
account. Earlier rows are shelved at
[`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md).

| Landed | Round | Log |
|---|---|---|
| `20260824.193815` | Five index rooms carried across and the log fold on Keaton's word; rows bounded at 192 bytes; no living page over its declared bound | [log](../session-logs/20260824-180216_the-room-folds-and-two-numbers-meet.kyri) |
| `20260824.183000` | Shorter rows -- a row points, bounded 192 bytes; the two seated bounds found incompatible (%205) | [log](../session-logs/20260824-180216_the-room-folds-and-two-numbers-meet.kyri) |
| `20260824.162940` | Model back to Opus 5, one reading over three sites (%201); commit-msg gains a fourth wall (%202); census 191 -> 186 (%203) | [log](../session-logs/20260824-162940_one-model-named-once.kyri) |
| `20260824.154722` | Counsel's index across -- 112 rows onto ten shelves; ratchet 231 -> 119 | index_fold |
| `20260824.145109` | A tool proven on one shape -- the fold keeps rows in place; active-designing's 86 across | REDS %200 |
| `20260824.140523` | The number with six homes -- one script reads the law, five meters stop spelling it | REDS %199 |
| `20260824.130807` | A bound with two meters and no wall -- the card 47,213 -> 22,647 and moved to enforce | REDS %197, %198 |
| `20260824.121445` | A declared bound becomes a measured one -- 13 pages, none both readable and honoured | REDS %195, %196 |

Walk back to any of them with `git log --oneline` and the session log of the same stamp.

## The cadence -- the seed ships every fifth round

Seated `20260823.111029`. On the lap the council rota closes its cycle (`N mod 5 == 0`), project
and force-push the public seed with `bash ~/grain/publish-seed.sh`.

**Where it stands.** The projection is current and its four gates hold; the live reading is in
*Custody gates* above, held once rather than twice. **The force-push waits for Keaton's word**,
since the same instruction that grants the cadence names the seed force-push among the custody
gates, and an autonomous lap surfaces that rather than reading it in its own favour. Say **ship the
seed** and the script carries it. Reds come first: a stopped line stays stopped, and the seed ships
on the next lap that qualifies. Foundation:
[`../foundations/20260823-111029_the-seed-that-ships-every-fifth-round.md`](../foundations/20260823-111029_the-seed-that-ships-every-fifth-round.md).

## The laps

*Fused in from `TASKS.md` and `ROADMAP.md` on `20260823.103804`; both cards are pointers now, and
their landed rows stay in their own history at the checkpoint nib.*

The live work-front is the **Now** block above. A lap that lands folds into a *Prior lap* line with
its detail left in the session log that recorded it, so this card stays single-stranded.

---
