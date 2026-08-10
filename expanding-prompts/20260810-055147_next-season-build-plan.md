# The Next-Season Build Plan — six briefs, one sequence

**Language:** EN
**Stamp:** `20260810.060642`
**Status:** Synthesis baton — the consolidated, sequenced plan across six design briefs
**Voice:** Riyo
**Style:** Radiant · a build-plan baton, not code
**Discipline:** TAME · Radiant · comlink-tendency · accrete-never-break · custody first
**Reads-from (the six briefs, each already written):**
`active-designing/undefined_plan-vault-keeper-of-secrets.md` ·
`active-designing/undefined_plan-loom-process-activity-memory-monitor.md` ·
`active-designing/undefined_plan-scribes-dashboard-and-the-bat-fleet.md` ·
`active-designing/undefined_plan-starseeding-star-creation-boot.md` ·
`active-designing/undefined_plan-3x39-kumara-passports-divider-grammar.md` ·
`active-designing/undefined_plan-name-consolidation-debride.md`

---

## The frame

Six briefs arrived together, and they are not six separate seasons — they are one
sequence standing on a spine that already holds GREEN. `scribe/reader.rye`,
`kumara/tilak.rye`, `settlement/constellation.rye`, `settlement/names.rye`,
`comlink/topology.rye`, and `aurora/src/deciding.rye` are all present and proven
today; this whole plan composes them, extends one of them, and invents genuinely
new crypto in exactly one place. That shape decides the order: **compose the sure
things first, extend the shared reader next, invent the risky thing under a witness
after, and let the two gated works — a naming decision and a self-consolidation
cut — run on their own clocks beside the build.**

Every module home is free: `vault/`, `bat/`, `starseeding/` grep clear, and so does
`loom/` — though the *word* Loom does not, which the plan honors below. Custody first
runs through all six: only fake `0x11…` / `0x22…` seeds enter the tree, no real key,
no chain touched, no unconsented name seated. Accrete-never-break holds by tier —
living code and docs move forward, dated testimony stays verbatim, proof-sealed bytes
never shift.

Two of the six are not module builds and want naming up front, so a reader never
mistakes them for ordinary laps:

- **The name-consolidation debride** is the one sanctioned break of accrete-never-break
  — a working-tree cut that turns the living copyright face from the pseudonym
  *Kaeden Reyklah* to the standing name *Keaton Livermore*, leaving git history whole.
  It is gated on the send that opens the cut, drops a cairn first, and is coupled to a
  witness that must flip in the same commit.
- **Loom** is a monitor whose *design* is ready yet whose *name* is honestly encumbered
  — `loom` already lives in the tree as the reds-first "a lantern that fires twice should
  become a loom" guard-metaphor. It waits on Keaton's word before any file lands.

---

## The dependency map

What each build needs, drawn so the order reads itself. An arrow means *stands on*.

```
already GREEN spine (present today, no work):
  kumara/tilak.rye · tally/kumara.rye · tally/copy.rye · tally/seed.rye
  scribe/reader.rye · comlink/topology.rye
  settlement/constellation.rye · settlement/names.rye · aurora/src/deciding.rye
  caravan/ (process ownership)

  Passport        → tilak · topology · settlement/constellation · settlement/names   [pure compose]
  Starseeding     → settlement/constellation · topology · aurora/deciding · tilak    [pure compose]
  Bat + Dashboard → scribe/reader (EXTENDS it: is_inventory · archetype_of · validates_*)
  Vault           → tilak · tally/kumara · tally/seed · scribe/reader        [NEW crypto: Shamir GF(256)]
  Loom            → caravan (across a FILE) · scribe/reader · tally · /proc   [BLOCKED on the name]

  Name-debride    → CAIRNS.md · sunn13 witness · prin_scope · LICENSE-* · MAP · forker template
                    [independent of all module work; gated on the send]
```

Two honest couplings a reader should hold:

- **The shared reader is the one soft coupling.** Vault, Starseeding, and Loom each name
  a "scribe-style reader" to re-read their emitted Bron by its `format` line — but every
  one needs only the reader's *existing* `parse` and format-dispatch, **not** the new
  `is_inventory` / `archetype_of` / `validates_*` predicates the Bat-Fleet lap adds. So the
  reader-extension and the composing modules do not block each other; they touch the same
  file for different reasons and should not land in the same commit.
- **Lexicon-before-code is a hard gate for the new-name builds.** Vault seats six marks
  (`vault` · `shard` · `brainkey` · `glacier` · `relic` · `recover`), and the Bat Fleet seats
  six archetypes plus `dashboard` / `inventory`. Per comlink-tendency, each is re-grepped and
  seated in `context/LEXICON.md` **before** the first file of that module lands — not after.

---

## The ordered build sequence

Ordered by *readiness times leverage*: the surest compositions first (they teach the
witnessed-lap rhythm on zero new risk), the shared reader next (it unblocks the richest
surface), the new crypto after (highest stakes, most mitigation), and the two gated works
threaded beside the build on their own consent clocks.

### 1 · Passport — the divider grammar, one new tilak

**Home:** `kumara/passport.rye` (or extend `kumara/tilak.rye`) · **Witness:** `tools/passport_witness.rish`
**Stands on:** `tilak.rye` · `tally/kumara.rye` · `settlement/constellation.rye` · `settlement/names.rye` · `comlink/topology.rye` (all GREEN)
**New seam:** none — a sixth tilak in the grammar proven five times over.

First lap: a settled world's keeper signs a passport binding token `hqkvez`, position
`prefix`, realm `sol`, and a fixed example attestation digest; `verify_passport` holds when
the Deed verifies against the Constellation *and* the keeper's signature over the canonical
message checks; every tamper refuses (flipped sig, changed position/realm/attestation, swapped
token); a ghost point refuses with `NotOwner`; a duplicate `(point, realm)` refuses with
`AlreadyPassported`. No chain, no key — only a 32-byte attestation digest produced off-tree.

**Why first:** lowest risk in the set. `passport` greps clean in code (zero hits in
`.rye`/`.rish`/`.brix`/`.bron`, one `.md` hit in the vision baton), the shape is a known tilak,
and it lands the exact `settlement/names.rye` witness pattern the plan reuses twice more.

### 2 · Starseeding — the boot that raises a star

**Home:** `starseeding/` (`starseed.rye` · `descriptor.rye`) · **Witness:** `tools/starseeding_witness.rish`
**Stands on:** `settlement/constellation.rye` · `comlink/topology.rye` · `aurora/src/deciding.rye` · `tilak.rye` · `tally/copy.rye` (all GREEN)
**New seam:** the star-tier-chosen-settled-and-born seam only; composes `open` → `mint` → descriptor.

First lap: `open` a galaxy, grant its keeper a `sow` cap signed for a star number whose
`topology.decode(n).tier == .star`, `mint` the star, assert `tier == .star` and
`settlement.verify == true`, emit a `starseed-descriptor-v1` Bron binding point · sponsor ·
constellation digest · SHA3-256 image digest, round-trip it byte-for-byte, and refuse three
ways — `WrongTier` (a pure planet), `WrongSponsor`, and a tampered descriptor.

**Why second:** also a pure composition of GREEN modules with `starseeding/` grep-clear and the
born-name already blessed. It carries one genuine sharp edge — the inclusive-topology
outfit-vs-primary-role distinction — that the first lap must pin (`decode(n).tier`, never
`plays(n, .star)`; never hardcode the `[12,60)` range, read it from the active sky). Landing it
second, right after Passport's settlement-witness rhythm, keeps that edge in fresh view.

### 3 · Bat Fleet + Scribe Dashboard — extend the shared reader

**Home:** `bat/` (six archetype exemplars) · `scribe/dashboard.rye` · **Witnesses:** `tools/bat_galleon_witness.rish` · `tools/scribe_dashboard_witness.rish`
**Stands on:** `scribe/reader.rye` (GREEN `20260810.041230`) — and **extends** it.
**New seam:** `is_inventory` · `archetype_of` · `validates_<name>` predicates in `reader.rye`; one new format tag `inventory-v1`; zero new format tags for the fleet (all `baton-v1` + an `archetype` field).

First lap, one keystone each: seat `archetype_of` + `validates_galleon`, prove `bat/galleon.kyri`
is a baton (not a log), reads archetype `"galleon"`, validates true with all required fields,
**refuses a short shape** when `manifest` is removed, reports three `gap` lines, and slices
zero-copy into its source. In parallel, the dashboard reads a three-document drawer (log · baton ·
inventory) onto the right three shelves with Unread empty, and a nonsense-format doc landing in
Unread.

**Why third:** this is the shared spine. Landing the reader-extension here — after two pure
compositions have exercised the existing reader unchanged — means the richest downstream surface
(labeled batons, a settings dashboard, the audit-record Corsair archetype the next-season auditing
work will want) opens on proven ground. The five remaining archetypes (Cutter · Barque · Holdfast ·
Corsair · Ledgerworks) accrete one witnessed lap at a time after Galleon. Copyright discipline is
structural: every archetype is a plain nautical/mercantile common noun, greps to zero, and carries
a `note original coinage` line; the style check turns away any exemplar naming a real vessel or firm.

### 4 · Vault — the keeper of secrets, custody first

**Home:** `vault/` (`shard.rye` first) · **Witness:** `tools/vault_shard_witness.rish`
**Stands on:** `tilak.rye` · `tally/kumara.rye` · `tally/seed.rye` · `scribe/reader.rye` · `comlink/topology.rye` · `aurora/` (offline posture)
**New seam:** a bounded Shamir-style GF(256) split/join — **the one genuinely new cryptographic surface in the whole plan.**

First lap: `vault/shard.rye` splits a fake `0x11…` seed into `n=5` shares at `t=3` (each a signed
`shard` tilak carrying a location-class), recombines three distinct `t`-subsets and asserts each
reproduces the seed byte-for-byte, refuses `t-1` shares, refuses a tampered share (flip a byte, the
signature fails), survives a lost location (drop one class, `t` shares remain), and round-trips the
shards through `format vault-shard-v1` Bron.

**Why fourth:** highest stakes, so it lands after the witnessed-lap rhythm is well-grooved and after
the reader it re-reads through is stable. The mitigation is structural and must be in place *before*
the first file: seat the six marks in the Lexicon (comlink-tendency), and **never write the word
master** — the module names the root of a keeping the **main key**, enforced by grep in every mark,
Bron fact, and witness line. Only fake seeds in-tree; the style check turns away any file hard-coding
32 bytes of anything but the blessed fake pattern. The `brainkey` · `glacier` · `relic` · `recover`
marks follow as their own later laps, each accreting beside the one before.

### 5 · Loom — the monitor — *design ready, name gated*

**Home (provisional):** `loom/` (`ring.rye` first) · **Witness:** `tools/loom_ring_witness.rish`
**Stands on:** `caravan/` (across a FILE, imports none of it) · `scribe/reader.rye` · `tally/` · the `/proc` seam
**New seam:** a bounded sample ring proven to hold constant memory under unbounded time; the file-boundary composition with Caravan.

First lap (whenever the name clears): construct an empty ring, push past `ring_capacity` to overflow,
prove `filled` saturates, `head` wrapped, `seq` stayed monotonic past the wrap, the oldest samples fell
off the tail, then render as `format loom-ring-v1` and read it back through Scribe with
`count_key("sample") == filled`. Lap 1 reads **no** live `/proc` — it proves the ring math on synthetic
samples first (reds-first: prove the line that stops itself before pointing it at the firehose).

**Why last, and set apart:** the design is sound and small, yet the name is honestly encumbered.
A fresh whole-tree grep confirms `loom` lives today in `.claude/rules/reds-first.md` (the "a lantern
that fires twice should become a loom" guard-sense), in `work-in-progress/REMEMBER.md` and `TASKS.md`,
and across several research files. Using it for a watcher risks two meanings for one word — exactly the
blur comlink-tendency exists to prevent. So **no `loom/` file lands until a fresh grep and Keaton's word
clear the name.** Consent-gated alternatives, each owed its own grep and a Lexicon pass: **Tender**,
**Vigil**, **Warden** (avoid **weave** — already a Mantra module). Every path above moves with the final
name.

### Threaded beside the build · The name-consolidation debride — *gated on the send*

**Home:** working-tree cut across ~6 living files · **Coupled witness:** `tools/gen/season/sunn13_root_survey_witness.rish`
**Stands on:** `work-in-progress/CAIRNS.md` (cairn first) · the sunn13 witness · `prin_scope.rish` · `LICENSE-{MIT,APACHE,CC-BY}` · `MAP.md` · `keys/README.md` · `tools/gen/season/personalize.template.brix`
**New seam:** none — a redaction of the living identity face, git history untouched.

This runs independent of every module build and on its own consent clock. The smallest witnessed
increment proves the whole mechanism end-to-end: rewrite the three root LICENSE copyright lines
(confirmed today: `LICENSE-MIT:3`, `LICENSE-APACHE:156`, `LICENSE-CC-BY:3`, each
`Copyright … 2026 Kaeden Reyklah and contributors`) from *Kaeden Reyklah* to *Keaton Livermore*, and in
the **same signed commit** flip the five coupled sunn13 assertions (confirmed at lines 8/25/36/38/40,
with the waiting comment at line 5) to expect the new name — then run the witness to GREEN. The cairn row
lands first. Three occurrence-kinds stay held apart, and only one is a target: living identity references
change; retired-voice tombstones (`.claude/rules/reya2.md`, `rio3.md` and roster lines) stay; dated
authorship testimony (`Voice: Rio 3` banners, `Written together by Kaeden and Reya 2` coauthor lines, each
carrying a `**Stamp:**`) stays verbatim. A **deep** debride (`k3`) that would unsign ~37k commits is a
separate, later, explicitly-worded act — this cut does not open it.

---

## The critical path

The longest chain of genuine dependency runs through the shared reader:

```
scribe/reader.rye (GREEN today)
        │
        ├─► [3] Bat Fleet + Dashboard  — EXTENDS reader (is_inventory · archetype_of · validates_*)
        │
        └─► [4] Vault                  — re-reads vault-shard-v1 Bron through the reader
```

Yet the *true* pacing constraint is not a code dependency at all — it is **risk sequencing and
consent gates**. Passport (1) and Starseeding (2) have no dependency on each other or on the
reader-extension, and could land in either order or in parallel; they lead because they are the surest
compositions and teach the witnessed-lap rhythm on zero new risk. Vault (4) is the single highest-stakes
build and deliberately trails the groove. Loom (5) and the debride are each blocked on a human word — a
naming decision and the send that opens the cut — so neither belongs on the mechanical critical path at
all; they are drawn beside it, ready the moment their gate opens.

**The one hard ordering rule:** seat each new module's Lexicon words *before* its first file
(comlink-tendency), and never let the reader-extension (3) and a reader-consuming compose (2, 4) share a
commit — they touch `scribe/reader.rye` for different reasons.

---

## The first three to build

1. **Passport** (`kumara/passport.rye` + `tools/passport_witness.rish`) — the surest lap: a sixth tilak
   in a proven grammar, pure composition of GREEN modules, `passport` grep-clean in code. Lands the
   `settlement/names.rye` witness pattern the plan reuses.

2. **Starseeding** (`starseeding/starseed.rye` + `descriptor.rye` + `tools/starseeding_witness.rish`) —
   the second pure composition, born-name already blessed, `starseeding/` grep-clear. Pins the inclusive-
   topology outfit-vs-primary-role edge while it is in fresh view.

3. **Bat Fleet + Scribe Dashboard** (`scribe/reader.rye` extension · `bat/galleon.kyri` ·
   `scribe/dashboard.rye` + two witnesses) — extend the shared reader on proven ground, opening the richest
   downstream surface (labeled batons, the settings dashboard, the audit-record Corsair archetype). Seat the
   six archetype names + `dashboard`/`inventory` in the Lexicon before the first file.

---

## Open questions and consent gates

- **Loom's name — Keaton's word (check-in Claude/Keaton).** `loom` is encumbered (reds-first guard-metaphor,
  plus `REMEMBER`/`TASKS`/research hits confirmed today). No `loom/` file lands until a fresh whole-tree grep
  and Keaton's decision. Candidates owed their own grep + Lexicon pass: **Tender · Vigil · Warden** (not
  **weave** — a Mantra module). Which word?
- **The send that opens the debride — Keaton's word.** The name-consolidation cut is proposed and awaiting
  the send. When it opens: the cairn drops first (re-read the live nib and stamp at cut time, since HEAD has
  moved), and the sunn13 assertions flip in the *same* commit as the LICENSE rewrite, or parity goes RED.
- **`keys/README.md` line 11 — assess before editing.** The brief flags this as closer to testimony than to a
  live reference (it describes the retired identity's own key folder — a fact of history). Confirm it reads as
  a closed chapter rather than rewriting it as a live alias.
- **The forker template's internal consistency** (`personalize.template.brix` lines 41/59/61). Folding the
  retired pseudonym from the live find/replace set must keep `replace_count` and the `_to` placeholders
  self-consistent — a broken template is a red.
- **The 3x39 concept's entry — Keaton's own ©2025.** Passport designs the *primitive* only. Whether/how the
  concept becomes a Grain product, a public primitive, or a private exemplar stays Keaton's call, named as a
  gate, not assumed.
- **Every real party is an invitation.** b122m, Siya Fund LLC, Linengrow PBC, Bitscape (DJINN) — and the
  named hardware vendors in Vault (Ledger, Trezor, RISC-V devices) — enter every brief as consent-gated
  invitations, never claims. No exemplar seats a real party's real decision, real token, or real chain
  ownership as settled. All exemplars hold fake data; no real key, no real state placed in the tree.
- **Lexicon seatings owed before code** (mechanical, but gated): Vault's six marks; the Fleet's six archetypes
  plus `dashboard`/`inventory`. Re-grep and seat each in `context/LEXICON.md` before the module's first file —
  and, in Vault, never write the word *master*.

---

*Six briefs, one spine already GREEN. Compose the sure things first, extend the shared reader next, invent the
one risky thing under a witness after — and let the naming decision and the self-consolidation cut run on their
own consent clocks beside the build. Only fake seeds in the tree, no chain touched, no unconsented name seated;
every lap green before it is called done.*
