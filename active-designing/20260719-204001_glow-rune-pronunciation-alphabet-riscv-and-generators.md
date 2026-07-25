# Glow Rune Pronunciation, Alphabet, RISC-V Significance, and Generators

*Keaton asked whether Glow should adopt Urbit's Hoon rune pronunciation alphabet for ASCII digraphs and rune families; document Glow's choices in TAME-guided Radiant Style; name RISC-V compilation significance versus Hoon→Nock; roadmap that major step; and word `glow/gen` desks as general implementations with samples like Hoon generators. This brief answers yes where the tree is ready, names honest horizons, and seats the plan.*

**Language:** EN  
**Version:** `20260719.204001` (Eastern)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Design — roadmap seated; alphabet table and parameterized generators are horizon laps  
**Register:** Mixed (Two Rooms) — adoption decisions and wording are **design**; RISC-V primary path and bounded `|-` are already **checkable** elsewhere  
**Grounds in:** [Hoon School — Pronouncing Hoon](https://docs.urbit.org/build-on-urbit/hoon-school) · [Hoon School — Syntax](https://docs.urbit.org/build-on-urbit/hoon-school/b-syntax) · [Hoon rune index](https://docs.urbit.org/hoon/rune) · [`20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`](20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md) · [`../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md`](../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md) · [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md) Glow assert pin · [`../glow/README.md`](../glow/README.md)

---

## Verdicts (plain)

| Question | Verdict |
|----------|---------|
| Adopt Hoon's one-syllable glyph alphabet and digraph pronunciation? | **Yes** — Glow canon. Study Urbit docs; restate in our voice; never invent a second alphabet. |
| Document every seated Glow rune with spoken name + family + TAME note? | **Yes** — grow a closed table for runes we actually lower; new rune costs a page (sameness). |
| Name RISC-V vs Hoon→Nock significance beside each family where it matters? | **Yes** — consolidate teaching tables; do not re-argue the revival decision. |
| Are today's `glow/gen/*.glow` files general CLI generators? | **Not yet.** They are **fixture desks** (baked sample for witnesses). Horizon: **parameterized generators** with sample from Rishi argv. |
| Token-driven lower this lap? | **Hold** — this documentation roadmap is the approved next major step after STOA88 asserts. |

---

## Adopt the Alphabet — How Digraphs Are Said

Urbit named each ASCII glyph with one syllable so digraphs are speakable. Glow adopts the same table (study attribution: Hoon School). Speak a rune by concatenating the two glyph names, stressing the first syllable and softening the second (e.g. `|=` **bartis**, `?:` **wutcol**, `?>` **wutgar**, `?<` **wutgal**, `|-` **barhep**).

| Name | Glyph | Name | Glyph |
|------|-------|------|-------|
| ace | single space | gap | two+ spaces or newline |
| pat | `@` | bar | `\|` |
| gar | `>` | gal | `<` |
| sel | `[` | ser | `]` |
| bas | `\` | hax | `#` |
| buc | `$` | hep | `-` |
| sig | `~` | cab | `_` |
| kel | `{` | ker | `}` |
| soq | `'` | cen | `%` |
| tar | `*` | col | `:` |
| ket | `^` | tic | `` ` `` |
| com | `,` | lus | `+` |
| tis | `=` | doq | `"` |
| mic | `;` | wut | `?` |
| dot | `.` | pal | `(` |
| zap | `!` | fas | `/` |
| pam | `&` | par | `)` |

**Glow keeps:** first glyph = **family** (bar cores, wut conditionals, col cells, ket casts, tis bindings, cen calls, buc molds, sig hints, fas imports). Second glyph specializes. Learning ~15 family glyphs teaches the shape of the curated set.

**Glow does not:** invent private digraph names; grow runes outside the TAME Glow supplement page; treat itinerary **Gate** (Lexicon) as a Hoon **gate** (one-arm core) — those stay distinct words.

---

## Families Already in Glow's Curated Set

From the sameness brief — carried forward with spoken names filled as the alphabet table lands per rune:

| Family (glyph) | Role | Seated Glow heads (nib-side) | Spoken examples |
|----------------|------|------------------------------|-----------------|
| **bar** `\|` | Cores | `\|=` · `\|-` (bounded) · `\|%` · `\|^` | bartis · **barhep** · barcen |
| **ket** `^` | Casts | `^-` | kethep |
| **tis** `=` | Bindings | `=/` · `=.` · `=*` | tisfas · tisdot · tistar |
| **wut** `?` | Conditionals · asserts | `?:` · `?-` · `?~` · `?>` · `?<` | wutcol · wuthep · wutsig · **wutgar** · **wutgal** |
| **cen** `%` | Calls | `%-` · `%+` · `%^` · `%*` | cenhep · cenlus · cenket · centar |
| **col** `:` | Cells | `:-` · `:+` · `:^` · `:~` | colhep · collus · colket · colsig |
| **buc** `$` | Molds | `+$` · `$:` · `$%` | lusbuc · buccol · buccen |
| **fas** `/` | Imports | `/+` | faslus |
| **sig** `~` | Hints | horizon (`~%` · `~/`) | — |

Horizon families (Hoon has them; Glow has not seated lowers): **dot** Nock ops, **pam** multi-arm cores, **sem** macros, **zap** specials — adopt names when a rune earns its supplement page.

---

## RISC-V Significance vs Hoon → Nock

These differences are already decided; this roadmap requires every teaching table to show them beside the rune where behavior diverges.

| Topic | Hoon / Nock | Glow / RISC-V (primary) |
|-------|-------------|-------------------------|
| Compile target | Hoon → Nock VM | Glow → Rye → Zig 0.16 → **RISC-V** (aarch64/x86_64 too) |
| Determinism | Free at the VM | Re-earned by **TAME** (bounds, no unbounded recursion, witnesses) |
| `\|-` trap | Unbounded loop shape | **Bounded** — bound checked at expansion; RISC-V disasm already quoted in sameness brief |
| Ambient truth | Loobean (0 = yes) | **Zig `bool` / POSIX exit 0** — loobean only at Nock seam |
| `?>` / `?<` | Crash into Nock failure | Lower to Rye `assert` — TAME opening triad |
| Second backend | — | **Nock** for Urbit interop only — never RISC-V→Nock |

When a new rune lands, its TAME page answers: *What does expansion assert? What RISC-V-visible structure replaces Nock's free guarantee?*

---

## Desks Today, Generators Tomorrow — Wording for TAME Glow Docs

### Recommended vocabulary

| Term | Meaning in Glow docs |
|------|----------------------|
| **Fixture desk** | A `.glow` file under `glow/gen/` with a **baked sample** — fixed faces and literals — used to pin a lower and run a witness. Today's suite. |
| **Generator** | Horizon: a Glow program (often a **bartis** gate) whose **sample** arrives from outside — Rishi argv / Dojo-shaped call — the Urbit `/gen` parallel. |
| **Sample** | Hoon/Glow: the typed argument face of a gate (`\|=`). Not the itinerary word *sample*. |
| **Glow gate** | Hoon parallel: one-arm core with sample. Always say **Glow gate** or **bartis gate** in language docs. |
| **Gate** (bare) | Lexicon itinerary precondition — **never** a Hoon gate in living Glow language prose. |

### How to speak of `glow/gen` now

> Fixture desks under `glow/gen/` are short, witnessed spellings of one Glow shape. Each desk carries its sample inside the file so Rishi can lower, build, and exit 0 without argv. They are the happy-zone fixtures for the language hop — not yet parameterized generators.

### How to speak of the horizon

> A parameterized Glow generator is a bartis (or library arm) whose sample is supplied at the shell — `rishi … run glow/gen/foo.glow -- from=5 amount=3` or an equivalent typed hand-off. Fixture desks remain; generators grow beside them. Witnesses keep fixed samples so green stays deterministic.

### What not to claim yet

- That every `.glow` today is a CLI function (it is a fixture).
- That `glow_run` already parses argv into faces (it does not).
- That swapping samples requires no new parse/lower lap (it does — STOA horizon).

Acme teaching hand: [`../expanding-prompts/20260719-204001_glow-fixture-desks-and-parameterized-generators.md`](../expanding-prompts/20260719-204001_glow-fixture-desks-and-parameterized-generators.md).

---

## Roadmap — Major Step (ordered laps)

| Lap | Claim | Room | Depends |
|-----|-------|------|---------|
| **G0** | This brief + Lexicon wording + README desks section | Design seated | — |
| **G1** | Closed pronunciation table for every **GREEN** Glow rune head (glyph · spoken · family · one-line meaning · RISC-V/TAME note) | Checkable when a witness or living-docs assert lists the set | G0 |
| **G2** | Grow TAME_GUIDANCE Glow pin: alphabet + family index (not full 200-rune Hoon dump) | Docs synced to G1 table | G1 |
| **G3** | Thin parameterized generator: one desk reads one `@u32` sample from Rishi argv; fixture desk kept | Checkable | G0 wording |
| **G4** | Token-driven lower slice on tidy ground | Checkable language | STOA86–88 |
| **G5** | Optional: Nock second-backend note beside each family that touches truth/jets | Design → checkable when Nock emit opens | Revival |

**STOA89** seats **G0**. Later STOA rungs may carry G1–G4, or a parallel **Glow docs** compressor if the table outgrows STOA's ≤80 line law.

---

## What This Brief Does Not Do

- Rewrite Hoon docs into the tree (study + attribution only; clean-room restatement).
- Rename itinerary **Gate**.
- Implement argv sample parsing this lap.
- Force every historical desk comment to say "fixture" overnight — migrate on touch.

---

*May every digraph stay speakable, every expansion stay checked, and every desk name what kind of sample it carries.*
