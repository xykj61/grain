---
name: TAME Guidance — Operational Supplement
description: Checkable coding rules for Rye, Brix, and Rishi — root plus one supplement per language. Glow keeps the root until its own supplement earns a seat. Pairs with the voiced canon in external-research/TAME_GUIDANCE.md.
type: reference
---

# TAME Guidance — Operational Supplement

**Language:** EN
**Last updated:** 2026-07-20 (Glow G0–G5 · bartis STOA100–109 · barket STOA102/111–115 · nest/type STOA106–110)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** Active — grow by supplement, earned when the language is ready

---

## Document Stack

Three layers, one discipline — filenames follow TigerBeetle's `docs/TIGER_STYLE.md` pattern (landmark guides at `context/TAME_GUIDANCE.md`, beside `RADIANT_STYLE.md`):

| Layer | Path | Role |
|-------|------|------|
| **Source** | `gratitude/TIGER_STYLE.md` | TigerBeetle team's guide, kept whole and unaltered |
| **Voiced canon** | `external-research/TAME_GUIDANCE.md` | Our radiant adaptation; Safety, Performance, DX, and the full why |
| **Operational supplement** | this document | Checkable root + Rye / Brix / Rishi rules for authors and agents |
| **Glow working pin** | [`../glow/README.md`](../glow/README.md) · alphabet · argv · token · G5 Nock · bartis · barket · nest/type | Fixture desks + asserts · G0–G5 · **bartis** STOA100–109 · **barket** tokenize→named-mold STOA111–118 · **nest/type** STOA106–110/119 |
| **Glow supplement (horizon)** | [`../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md`](../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md) | Scoping for a future Glow supplement; root still binds Glow authors now |

Read the voiced canon (`external-research/TAME_GUIDANCE.md`) for philosophy and expert Tiger discipline. Read **this file** at the keyboard for what to assert, name, and bound. Organization prose lives in `active-designing/yonder/20260618-184912_growing-a-language.md`.

### Glow — assertion conditional runes (working pin, STOA88)

Hoon's positive and negative assertion runes — [`?>` wutgar](https://docs.urbit.org/hoon/rune/wut.md) and [`?<` wutgal](https://docs.urbit.org/hoon/rune/wut.md) — are Glow's TAME assert surface in the language itself. They are not a separate dialect from Rye's bare `assert`; they lower into it.

| Glow | Hoon name | Meaning | Lowers to |
|------|-----------|---------|-----------|
| `?>  p  q` | wutgar | *p* must hold; then *q* | `assert(p);` then body *q* |
| `?<  p  q` | wutgal | *p* must not hold; then *q* | `assert(!p);` then body *q* |

**Thin shape today:** test child `(gth tick 32)` only; body a decimal. Desks `glow/gen/assert-true.glow` · `assert-false.glow`. Witness: `tools/glow_lower_assert_witness.rish`.

**Authoring law for Glow that emits Rye:** the lowered file keeps the TAME opening triad (`const assert = std.debug.assert`) and uses unqualified `assert(...)` with a `//` why — the same density rule as hosted Rye. Glow authors reach for `?>` / `?<` in `.glow` desks when the check belongs in the Glow spelling; they do not invent a third assert keyword.

**Not yet:** `?=` type-match asserts, general boolean tests, or inference that refines subject type across the assertion (Hoon's full power). Those wait on richer nest/type surface.

### Glow — rune alphabet and fixture desks (working pin, STOA89–91; G5 STOA98)

**STOA91** seats the compact glyph alphabet and family index below (G2). Glow adopts Hoon's one-syllable glyph alphabet so digraphs stay speakable. Primary compile path is Glow→Rye→Zig→**RISC-V**; Nock is a second backend at a seam. Most `glow/gen/` files are **fixture desks** (baked sample). **G3** seats one thin parameterized **generator**: `glow/gen/sample-u32.glow` reads one `@u32` from Rishi argv. **G4** closes the lexer→lower mold seam: cross-desk parts · same-desk mold-body · mold-only peek · TAME tidy `lower_mold` · token→`MoldSpec` in `rune_mold.parse_source` (STOA93–97). **STOA100–101** seat thin `|=` bartis identity (baked 5) and argv generator `gate-sample-u32.glow`. **STOA102** seats `|^` **barket** horizon wording — wet-gate digraph stays untokenized. Canon: [`../active-designing/20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md`](../active-designing/20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md) · G3 plan [`../active-designing/20260720-022956_stoa92-thin-argv-sample-g3-plan.md`](../active-designing/20260720-022956_stoa92-thin-argv-sample-g3-plan.md) · G4 plans [`../active-designing/20260720-023513_stoa93-token-driven-lower-slice-g4-plan.md`](../active-designing/20260720-023513_stoa93-token-driven-lower-slice-g4-plan.md) · [`../active-designing/20260720-024223_stoa94-same-desk-mold-body-tokens-g4-plan.md`](../active-designing/20260720-024223_stoa94-same-desk-mold-body-tokens-g4-plan.md). **G1 closed table**: [`../active-designing/20260719-220814_glow-rune-pronunciation-closed-table.md`](../active-designing/20260719-220814_glow-rune-pronunciation-closed-table.md).

#### Glyph alphabet (compact)

Speak a digraph by concatenating the two glyph names (stress the first). Study attribution: [Hoon School — Pronouncing Hoon](https://docs.urbit.org/build-on-urbit/hoon-school). Glow does not invent a second alphabet.

| Name | Glyph | Name | Glyph | Name | Glyph | Name | Glyph |
|------|-------|------|-------|------|-------|------|-------|
| bar | `\|` | wut | `?` | tis | `=` | ket | `^` |
| col | `:` | cen | `%` | buc | `$` | fas | `/` |
| lus | `+` | hep | `-` | gar | `>` | gal | `<` |
| sig | `~` | tar | `*` | dot | `.` | mic | `;` |

#### Family index (GREEN heads only)

Full per-rune rows (meaning · RISC-V/TAME note) live in the G1 closed table. This index names the family and its tokenized heads — not Hoon's full ~200-rune dump.

| Family | Glyph | GREEN heads | Spoken examples |
|--------|-------|-------------|-----------------|
| **bar** | `\|` | `\|-` · `\|%` · `\|=` · `\|^` | barhep · barcen · **bartis** · **barket** |
| **lus** / **hep** | `+` / `-` | `++` · `--` (core delimiters) | luslus · hephep |
| **ket** | `^` | `^-` | kethep |
| **tis** | `=` | `=/` · `=.` · `=*` | tisfas · tisdot · tistar |
| **wut** | `?` | `?:` · `?-` · `?~` · `?>` · `?<` | wutcol · wuthep · wutsig · **wutgar** · **wutgal** |
| **col** | `:` | `:-` · `:+` · `:^` · `:~` | colhep · collus · colket · colsig |
| **cen** | `%` | `%-` · `%+` · `%^` · `%*` | cenhep · cenlus · cenket · centar |
| **buc** | `$` | `+$` · `$:` · `$%` | lusbuc · buccol · buccen |
| **fas** | `/` | `/+` | faslus |

**Horizon (not in `tokens.rye`):** sig hints `~%` · `~/`. (`\|^` barket tokenizes · parses · lowers identity+argv+double as of STOA111–115; nesting path seated STOA119–121 · STOA130 vocabulary; ambient gold held.)

**Authoring law:** when you seat a new Glow rune, add its digraph to `glow/tokens.rye` `match_rune2`, a row to the G1 closed table, and a spoken example here in the matching family — same lap, or the alphabet witness goes red.

### Glow — Nock second-backend notes beside truth families (G5, STOA98)

Primary path stays Glow→Rye→Zig→**RISC-V**. **Nock** is the second backend for Urbit interop and verification only ([`../nock/README.md`](../nock/README.md)) — never RISC-V→Nock. Ambient truth ruling: [`specs/20260717-154943_glow-truth-zig-ambient-nock-loobean-seam.md`](specs/20260717-154943_glow-truth-zig-ambient-nock-loobean-seam.md) · seam module [`../glow/truth_semantics.rye`](../glow/truth_semantics.rye).

| Family | Touches | Nock second-backend note |
|--------|---------|---------------------------|
| **wut** | truth (`?:` · `?-` · `?~` · `?>` · `?<`) | Zig `bool` / Rye `assert` / POSIX exits ambient; loobean 0=yes only inside `nock/` and at `truth_semantics` conversion. Future Nock emit of wut heads converts at that seam. |
| *(none yet)* | jets | No GREEN Glow family is jet-touching until a Glow→Nock emit or jet table seats; add the family row here that lap. |

G5 brief: [`../active-designing/20260720-033200_stoa98-g5-nock-second-backend-family-notes.md`](../active-designing/20260720-033200_stoa98-g5-nock-second-backend-family-notes.md). Witness: `tools/glow_g5_nock_family_notes_witness.rish`.

### Glow — bartis (STOA100–109) · barket (STOA102 wording · STOA111–118 tokenize/parse/lower/argv/call/tidy/named-mold) · nest/type (STOA106–110 GREEN)

`|=` spoken **bartis** is the Hoon/Glow **stated** one-arm core with a typed **sample**. Language docs say **Glow gate** or **bartis gate** — never bare itinerary **Gate** ([`LEXICON.md`](LEXICON.md)). **STOA100–101** seat identity + argv. **STOA103–104** deepen the body to closed one-arg calls: `double` · `inc` · `dec`. **STOA105** TAME-tidies `rune_bartis` / `lower_bartis`. `|^` spoken **barket** was named at horizon (**STOA102**), **tokenizes** as of **STOA111** (27th digraph), **parses** stated header/identity as of **STOA112**, **lowers** identity to `barket_gate` as of **STOA113**, seats **argv sample** as of **STOA114**, seats call-body **`%-  double`** as of **STOA115**, widens the closed call-body trio to **`inc` / `dec`** as of **STOA116**, **TAME-tidies** `rune_barket` / `lower_barket` as of **STOA117**, and seats named-mold **`amount-mold`** as of **STOA118**. **STOA106–110** seat nest/type through nesting refuse (`assert_sample_not_nesting`); **STOA119** seats mold-bounded nesting accept (`assert_sample_nesting_nests` for `@u32` and `amount-mold`); **STOA120** wires that API into barket/bartis expansion; **STOA121** seats barket as nesting through `assert_sample_nesting_nests(true, …)` under stated molds; **STOA122** widens the closed named-mold allowlist with `count-mold` beside `amount-mold`; **STOA123** seats unit `$%` `kind-mold` gate samples as `KindMold` identity; **STOA124** seats payload `$%` `xact-mold` gate samples as `XactMold` identity; **STOA125** seats multi-face payload `$%` `xfer-mold` gate samples as `XferMold` identity; **STOA126** seats multi-field `$:` `pair-mold` gate samples as `PairMold` identity. Ambient gold still held; bartis stays stated.

| Status | Item |
|--------|------|
| **STOA100 GREEN** | Thin `|=  sample=@u32` identity gate — token parse · Rye emit · baked 5 · fixture desk |
| **STOA101 GREEN** | Bartis argv sample — generator desk · `--sample-argv` · fixture stays baked |
| **STOA102 GREEN** | Barket horizon wording — `\|^` named · nesting/gold held (tokenize follows at STOA111) |
| **STOA103 GREEN** | Bartis call body — `%-  double  sample` · fixture + argv · expect `sample *% 2` |
| **STOA104 GREEN** | Bartis call body — `%-  inc` / `%-  dec` · fixture + argv · `+% 1` / `-% 1` |
| **STOA105 GREEN** | TAME tidy bartis — `append_print` · `copy_disjoint` · overflow seat · width list |
| **STOA106 GREEN** | Nest/type surface wording — nesting-sample precondition named |
| **STOA107 GREEN** | Nest/type thin implement — stated aura equality · `SampleDoesNotNest` · bartis wire |
| **STOA108 GREEN** | Nest/type `$%` tag nest — `assert_tag_nests` · mold-kind accept · `%burn` refuse |
| **STOA109 GREEN** | Named-mold bartis — `sample=amount-mold` · `gate-amount` · `kind-mold` refuse |
| **STOA110 GREEN** | Nesting-refuse nest — `assert_sample_not_nesting` · nesting flag refuses · stated accept |
| **STOA111 GREEN** | Barket tokenize — `\|^` in `match_rune2` · G1 **27** · lower held |
| **STOA112 GREEN** | Barket header parse — stated `\|^  sample=@u32` · identity body · call-body `BodyNotYetLowered` |
| **STOA113 GREEN** | Barket identity lower — `barket_gate` · fixture `gate-barket-sample` · `glow_run` arm |
| **STOA114 GREEN** | Barket argv sample — `lower_source_argv_sample` · generator `gate-barket-sample-u32` |
| **STOA115 GREEN** | Barket call-body double — `%-  double` · `*% 2` · fixture + argv generator |
| **STOA116 GREEN** | Barket call-body inc/dec — `%-  inc` / `%-  dec` · `+% 1` / `-% 1` · fixture + argv |
| **STOA117 GREEN** | TAME tidy barket — `append_print` · `parse_body` · overflow seat · width list |
| **STOA118 GREEN** | Named-mold barket — `sample=amount-mold` · `gate-barket-amount` · `kind-mold` refuse |
| **STOA119 GREEN** | Nesting-sample nest accept under stated mold — `assert_sample_nesting_nests` · `@u32` + `amount-mold` |
| **STOA120 GREEN** | Nesting-nests expansion wire — barket/bartis call `assert_sample_nesting_nests` |
| **STOA121 GREEN** | Barket nesting-through-nests — `assert_sample_nesting_nests(true, …)` under stated molds |
| **STOA122 GREEN** | Closed named-mold allowlist — `amount-mold` · `count-mold` (one-field `$:` ≡ `@u32`) |
| **STOA123 GREEN** | Kind-mold gate sample — unit `$%` identity · `KindMold` enum · baked `.mint` |
| **STOA124 GREEN** | Xact-mold gate sample — payload `$%` identity · `XactMold` union · baked `.mint` amount 5 |
| **STOA125 GREEN** | Xfer-mold gate sample — multi-face payload `$%` · `XferMold` · baked `.mint` from 5 amount 3 |
| **STOA126 GREEN** | Pair-mold gate sample — multi-field `$:` · `PairMold` struct · baked from 5 amount 3 |
| **STOA127 GREEN** | Kind-mold call body — closed unit `$%` flip · KindMold switch · baked `.mint` → `.send` |
| **STOA128 GREEN** | Xact-mold call body — closed payload `$%` flip · XactMold switch · baked mint/5 → `.send` |
| **STOA129 GREEN** | Xfer-mold call body — closed multi-face payload `$%` flip · XferMold switch · baked mint/5/3 → `.send` |
| **STOA130 GREEN** | Stated · nesting · gold vocabulary — nest APIs `assert_sample_not_nesting` · `assert_sample_nesting_nests` · `is_nesting` |
| **STOA131 GREEN** | Pair-mold call body — closed multi-field `$:` flip · PairMold swap · baked 5/3 → 3/5 |
| **STOA132 GREEN** | Amount-mold argv sample — generator desks beside fixtures · `glow_run` stem · pair argv refuse |
| **STOA133 GREEN** | Count-mold argv sample — twin generator desks beside fixtures · `glow_run` stem |
| **STOA134 GREEN** | Triple-mold gate sample — three-field `$:` · `TripleMold` struct · baked from 5 amount 3 fee 1 |
| **STOA135 GREEN** | Quad-mold gate sample — four-field `$:` · `QuadMold` struct · baked from 5 amount 3 fee 1 nonce 2 |
| **STOA136 GREEN** | Triple-mold call body — closed three-field `$:` flip · TripleMold swap · baked 5/3/1 → 3/5/1 |
| **STOA137 GREEN** | Quad-mold call body — closed four-field `$:` flip · QuadMold swap · baked 5/3/1/2 → 3/5/1/2 |
| **STOA138 GREEN** | Penta-mold gate sample — five-field `$:` · `PentaMold` struct · baked from 5 amount 3 fee 1 nonce 2 memo 7 |
| **STOA139 GREEN** | Penta-mold call body — closed five-field `$:` flip · PentaMold swap · baked 5/3/1/2/7 → 3/5/1/2/7 |
| **STOA140 GREEN** | Hexa-mold gate sample — six-field `$:` · `HexaMold` struct · baked from 5 amount 3 fee 1 nonce 2 memo 7 tag 4 |
| **STOA141 GREEN** | Hexa-mold call body — closed six-field `$:` flip · HexaMold swap · baked 5/3/1/2/7/4 → 3/5/1/2/7/4 |
| **STOA142 GREEN** | Hepta-mold gate sample — seven-field `$:` · `HeptaMold` struct · baked from 5 amount 3 fee 1 nonce 2 memo 7 tag 4 to 6 |
| **STOA143 GREEN** | Hepta-mold call body — closed seven-field `$:` flip · HeptaMold swap · baked 5/3/1/2/7/4/6 → 3/5/1/2/7/4/6 |
| **STOA144 GREEN** | Octa-mold gate sample — eight-field `$:` · `OctaMold` struct · baked from 5 amount 3 fee 1 nonce 2 memo 7 tag 4 to 6 via 8 |
| **STOA145 GREEN** | Octa-mold call body — closed eight-field `$:` flip · OctaMold swap · baked 5/3/1/2/7/4/6/8 → 3/5/1/2/7/4/6/8 |
| **STOA146 GREEN** | Nona-mold gate sample — nine-field `$:` · `NonaMold` struct · baked from 5 amount 3 fee 1 nonce 2 memo 7 tag 4 to 6 via 8 ref 9 |
| **Capacity freeze** | Closed `$:` allowlist stops at nine faces (`nona-mold` · `max_fields == 9`) — brief `20260720.231857` |
| **STOA147 GREEN** | Nona-mold call body — closed nine-field `$:` flip · NonaMold swap · baked 5/3/1/2/7/4/6/8/9 → 3/5/1/2/7/4/6/8/9 |
| **STOA148 GREEN** | `amount-shape` — first Glow OS shape allowlist alias ≡ `amount-mold` (one-field `$:` / `@u32`) |
| **STOA149 GREEN** | `count-shape` — twin Glow OS shape allowlist alias ≡ `count-mold` (one-field `$:` / `@u32`) |
| **STOA150 GREEN** | `pair-shape` — first multi-field Glow OS shape allowlist alias ≡ `pair-mold` (PairMold) |
| **STOA151 GREEN** | `kind-shape` — first unit `$%` Glow OS shape allowlist alias ≡ `kind-mold` (KindMold) |
| **STOA152 GREEN** | `xact-shape` — first payload `$%` Glow OS shape allowlist alias ≡ `xact-mold` (XactMold) |
| **STOA153 GREEN** | `xfer-shape` — first multi-face payload `$%` Glow OS shape allowlist alias ≡ `xfer-mold` (XferMold) |
| **STOA154 GREEN** | `triple-shape` — three-field `$:` Glow OS shape allowlist alias ≡ `triple-mold` (TripleMold) |
| **STOA155 GREEN** | `quad-shape` — four-field `$:` Glow OS shape allowlist alias ≡ `quad-mold` (QuadMold) |
| **STOA156 GREEN** | `penta-shape` — five-field `$:` Glow OS shape allowlist alias ≡ `penta-mold` (PentaMold) |
| **STOA157 GREEN** | `hexa-shape` — six-field `$:` Glow OS shape allowlist alias ≡ `hexa-mold` (HexaMold) |
| **STOA158 GREEN** | `hepta-shape` — seven-field `$:` Glow OS shape allowlist alias ≡ `hepta-mold` (HeptaMold) |
| **STOA159 GREEN** | `octa-shape` — eight-field `$:` Glow OS shape allowlist alias ≡ `octa-mold` (OctaMold) |
| **STOA160 GREEN** | `nona-shape` — nine-field `$:` Glow OS shape allowlist alias ≡ `nona-mold` (NonaMold); closes multi-field shape ladder at capacity freeze |
| **STOA161 GREEN** | inventary of `mold-*` desks · first dual `shape-amount` / cast twins; mold twins kept; rename itinerary open |
| Still held | Ambient gold / free nesting polymorphism · bartis stays stated |
| Still held | Open bartis/barket call-body gate set beyond `double` · `inc` · `dec` · `flip` |
| Still held | Open named-mold set beyond nona (capacity freeze) · argv under tagged/multi-field shapes · further field widens horizon |
| Still held | Sala B0 in Glow — framework / product season |

G1 row brief (STOA100): [`../active-designing/20260720-033852_glow-bartis-g1-row.md`](../active-designing/20260720-033852_glow-bartis-g1-row.md). Argv brief (STOA101): [`../active-designing/20260720-040200_glow-bartis-argv-sample.md`](../active-designing/20260720-040200_glow-bartis-argv-sample.md). Barket horizon (STOA102): [`../active-designing/20260720-040700_stoa102-barket-horizon-wording.md`](../active-designing/20260720-040700_stoa102-barket-horizon-wording.md). Barket G1 tokenize (STOA111): [`../active-designing/20260720-151119_glow-barket-g1-row.md`](../active-designing/20260720-151119_glow-barket-g1-row.md) · [`../active-designing/20260720-151119_stoa111-barket-tokenize.md`](../active-designing/20260720-151119_stoa111-barket-tokenize.md). Barket parse (STOA112): [`../active-designing/20260720-174115_stoa112-barket-parse.md`](../active-designing/20260720-174115_stoa112-barket-parse.md). Barket lower (STOA113): [`../active-designing/20260720-175115_stoa113-barket-lower.md`](../active-designing/20260720-175115_stoa113-barket-lower.md). Barket argv (STOA114): [`../active-designing/20260720-175643_stoa114-barket-argv.md`](../active-designing/20260720-175643_stoa114-barket-argv.md). Barket call-body (STOA115): [`../active-designing/20260720-180047_stoa115-barket-call-body.md`](../active-designing/20260720-180047_stoa115-barket-call-body.md). Barket call-body inc/dec (STOA116): [`../active-designing/20260720-180445_stoa116-barket-call-body-inc-dec.md`](../active-designing/20260720-180445_stoa116-barket-call-body-inc-dec.md). Barket TAME tidy (STOA117): [`../active-designing/20260720-180900_stoa117-barket-tame-tidy.md`](../active-designing/20260720-180900_stoa117-barket-tame-tidy.md). Named-mold barket (STOA118): [`../active-designing/20260720-181347_stoa118-named-mold-barket.md`](../active-designing/20260720-181347_stoa118-named-mold-barket.md). Call body (STOA103): [`../active-designing/20260720-040800_glow-bartis-call-body.md`](../active-designing/20260720-040800_glow-bartis-call-body.md). Inc/dec (STOA104): [`../active-designing/20260720-041800_glow-bartis-call-body-inc-dec.md`](../active-designing/20260720-041800_glow-bartis-call-body-inc-dec.md). Tidy (STOA105): [`../active-designing/20260720-042300_glow-bartis-tame-tidy.md`](../active-designing/20260720-042300_glow-bartis-tame-tidy.md). Nest/type wording (STOA106): [`../active-designing/20260720-042931_stoa106-nest-type-surface-wording.md`](../active-designing/20260720-042931_stoa106-nest-type-surface-wording.md). Nest/type thin implement (STOA107): [`../active-designing/20260720-043251_stoa107-nest-type-thin-implement.md`](../active-designing/20260720-043251_stoa107-nest-type-thin-implement.md). Nest/type tag nest (STOA108): [`../active-designing/20260720-145814_stoa108-nest-type-tag-nest.md`](../active-designing/20260720-145814_stoa108-nest-type-tag-nest.md). Named-mold bartis (STOA109): [`../active-designing/20260720-150155_stoa109-named-mold-bartis.md`](../active-designing/20260720-150155_stoa109-named-mold-bartis.md). Wet-refuse nest (STOA110): [`../active-designing/20260720-150635_stoa110-wet-refuse-nest.md`](../active-designing/20260720-150635_stoa110-wet-refuse-nest.md). Wet-nests accept (STOA119): [`../active-designing/20260720-181950_stoa119-wet-accept-under-stated-mold.md`](../active-designing/20260720-181950_stoa119-wet-accept-under-stated-mold.md). Wet-nests barket wire (STOA120): [`../active-designing/20260720-182450_stoa120-wet-nests-barket-wire.md`](../active-designing/20260720-182450_stoa120-wet-nests-barket-wire.md). Barket wet-through-nests (STOA121): [`../active-designing/20260720-182915_stoa121-barket-wet-through-nests.md`](../active-designing/20260720-182915_stoa121-barket-wet-through-nests.md). Count-mold named (STOA122): [`../active-designing/20260720-183259_stoa122-count-mold-named.md`](../active-designing/20260720-183259_stoa122-count-mold-named.md). Kind-mold gate (STOA123): [`../active-designing/20260720-183837_stoa123-kind-mold-gate.md`](../active-designing/20260720-183837_stoa123-kind-mold-gate.md). Xact-mold gate (STOA124): [`../active-designing/20260720-184304_stoa124-xact-mold-gate.md`](../active-designing/20260720-184304_stoa124-xact-mold-gate.md). Xfer-mold gate (STOA125): [`../active-designing/20260720-184953_stoa125-xfer-mold-gate.md`](../active-designing/20260720-184953_stoa125-xfer-mold-gate.md). Pair-mold gate (STOA126): [`../active-designing/20260720-185502_stoa126-pair-mold-gate.md`](../active-designing/20260720-185502_stoa126-pair-mold-gate.md). Kind-mold flip call-body (STOA127): [`../active-designing/20260720-190544_stoa127-kind-call-body.md`](../active-designing/20260720-190544_stoa127-kind-call-body.md). Xact-mold flip call-body (STOA128): [`../active-designing/20260720-191033_stoa128-xact-call-body.md`](../active-designing/20260720-191033_stoa128-xact-call-body.md). Xfer-mold flip call-body (STOA129): [`../active-designing/20260720-192038_stoa129-xfer-call-body.md`](../active-designing/20260720-192038_stoa129-xfer-call-body.md). Stated/nesting/gold vocabulary (STOA130): [`../active-designing/20260720-192738_stoa130-stated-nesting-gold.md`](../active-designing/20260720-192738_stoa130-stated-nesting-gold.md). Pair-mold flip call-body (STOA131): [`../active-designing/20260720-193357_stoa131-pair-call-body.md`](../active-designing/20260720-193357_stoa131-pair-call-body.md). Amount-mold argv (STOA132): [`../active-designing/20260720-193805_stoa132-amount-argv.md`](../active-designing/20260720-193805_stoa132-amount-argv.md). Count-mold argv (STOA133): [`../active-designing/20260720-194143_stoa133-count-argv.md`](../active-designing/20260720-194143_stoa133-count-argv.md). Triple-mold gate (STOA134): [`../active-designing/20260720-194437_stoa134-triple-mold-gate.md`](../active-designing/20260720-194437_stoa134-triple-mold-gate.md). Quad-mold gate (STOA135): [`../active-designing/20260720-195131_stoa135-quad-mold-gate.md`](../active-designing/20260720-195131_stoa135-quad-mold-gate.md). Triple-mold flip call-body (STOA136): [`../active-designing/20260720-195742_stoa136-triple-flip.md`](../active-designing/20260720-195742_stoa136-triple-flip.md). Quad-mold flip call-body (STOA137): [`../active-designing/20260720-200022_stoa137-quad-flip.md`](../active-designing/20260720-200022_stoa137-quad-flip.md). Penta-mold gate (STOA138): [`../active-designing/20260720-200416_stoa138-penta-mold-gate.md`](../active-designing/20260720-200416_stoa138-penta-mold-gate.md). Penta-mold flip call-body (STOA139): [`../active-designing/20260720-215636_stoa139-penta-flip.md`](../active-designing/20260720-215636_stoa139-penta-flip.md). Hexa-mold gate (STOA140): [`../active-designing/20260720-221703_stoa140-hexa-mold-gate.md`](../active-designing/20260720-221703_stoa140-hexa-mold-gate.md). Hexa-mold flip call-body (STOA141): [`../active-designing/20260720-222406_stoa141-hexa-flip.md`](../active-designing/20260720-222406_stoa141-hexa-flip.md). Hepta-mold gate (STOA142): [`../active-designing/20260720-222827_stoa142-hepta-mold-gate.md`](../active-designing/20260720-222827_stoa142-hepta-mold-gate.md). Hepta-mold flip call-body (STOA143): [`../active-designing/20260720-224200_stoa143-hepta-flip.md`](../active-designing/20260720-224200_stoa143-hepta-flip.md). Octa-mold gate (STOA144): [`../active-designing/20260720-224907_stoa144-octa-mold-gate.md`](../active-designing/20260720-224907_stoa144-octa-mold-gate.md). Octa-mold flip call-body (STOA145): [`../active-designing/20260720-225659_stoa145-octa-flip.md`](../active-designing/20260720-225659_stoa145-octa-flip.md). Nona-mold gate (STOA146): [`../active-designing/20260720-230350_stoa146-nona-mold-gate.md`](../active-designing/20260720-230350_stoa146-nona-mold-gate.md). Nona-mold flip call-body (STOA147): [`../active-designing/20260720-231128_stoa147-nona-flip.md`](../active-designing/20260720-231128_stoa147-nona-flip.md). Capacity freeze (nine faces): [`../active-designing/20260720-231857_closed-field-capacity-freeze-and-framework-next.md`](../active-designing/20260720-231857_closed-field-capacity-freeze-and-framework-next.md). Amount-shape alias (STOA148): [`../active-designing/20260720-234340_stoa148-amount-shape-alias.md`](../active-designing/20260720-234340_stoa148-amount-shape-alias.md). Shape-amount dual (STOA161): [`../active-designing/20260721-010211_stoa161-shape-amount-dual-desk.md`](../active-designing/20260721-010211_stoa161-shape-amount-dual-desk.md). Witnesses: `tools/glow_bartis_argv_witness.rish` · `tools/glow_barket_tokenize_witness.rish` · `tools/glow_barket_parse_witness.rish` · `tools/glow_barket_lower_witness.rish` · `tools/glow_lower_bartis_witness.rish` · `tools/glow_nest_type_surface_witness.rish` · `tools/glow_nest_type_witness.rish` · `tools/glow_rune_alphabet_witness.rish`.

Cursor and Claude rules (`.cursor/rules/tame-guidance.mdc`, `.claude/rules/tame-guidance.md`) point here. Root rule **9** (docs and implementation stay synced) has its own always-on agent rule pair: `.cursor/rules/docs-implementation-sync.mdc`, `.claude/rules/docs-implementation-sync.md`.

---

## What This Is

TAME names the order of values that governs every line we write: **safety first, performance second, the joy of the craft third.** That order is a priority — when they pull against each other, safety wins; when safety and performance are equal, joy earns the vote.

This guide makes those values concrete for code. It is organized as **one root** — rules that hold across the whole family — and **a supplement for each language**, added when that language has earned distinct idioms of its own. A supplement that does not exist yet is not overdue: it waits for the language to be real enough to need it. **Glow** already emits eight rune heads under [`../glow/`](../glow/); it keeps this root until a Glow supplement earns its own section here.

The rules here that a machine can check are gathered near the end, in **What We Check, and When** — each one matched to the tool that catches it today, or named as a horizon when it waits for a Zig parser. The checkable rules and the idioms behind them are drawn faithfully from TigerBeetle's own enforcement, `src/tidy.zig`, kept in our gratitude for the team that wrote it.

---

## Root — Universal Across the Family

These disciplines hold for Rye, Brix, Rishi, and every module written in them. A language that has no supplement of its own still keeps the root. Where the root is silent, **996** and `gratitude/TIGER_STYLE.md` are authoritative.

### 1. State invariants before implementing

Write the assertions before you write the algorithm. An invariant written before the loop is an invariant the loop was built to preserve. An invariant written after the loop is a hope wearing a check's clothes.

A structural invariant lives in a comment block immediately before the type it governs:

```zig
// Invariant: pos <= buf.len; all bytes in buf[0..pos] are committed.
const Region = struct { ... };
```

A behavioral invariant lives immediately before the function that enforces it:

```zig
// Precondition: name.len == Sha3.digest_length * 2 (64 hex chars).
fn read_blob(...) ...
```

### 2. Bounds on everything, and simple control flow

Every allocation, every collection, every pipeline names its maximum size. Name the budget at construction; check it at the edge; fail with a named error, rather than a silent corruption.

A bound is the honest answer to "how large can this grow?" stated up front, before the machine runs. Everything has a limit, so every loop and every queue carries a fixed upper bound. Where a loop genuinely cannot terminate — an event loop — that fact is asserted, so the reader meets the intent. Control flow stays simple and explicit; recursion stays out, so that everything which should be bounded stays bounded.

### 3. Say why

Every assertion earns a comment: `// invariant: ...`. Every named constant earns a comment if the name alone does not make the reason obvious. Every design choice that will surprise a reader earns a sentence that names the reason.

The next reader meets the reason, not only the rule. Always motivate, always say why — a stated rationale shares with the reader the very criteria by which to weigh the decision.

### 4. Accrete, never break

A name once given is a promise. Add beside it; do not replace it silently. When a better shape is found, the old name keeps working while the new one grows. Rename only with a migration path; deprecate before removing.

A version once published does not change.

### 5. One value model

A value is: a string, an integer, a boolean, a list of values, a record of named values — or a composite of these. Values are composed (placed side by side); they are never tangled (woven together so that reading one requires holding the others).

A value crosses module boundaries without being serialized to text and reparsed on the other side. When that seam would open, close it.

POSIX interop at the process boundary is a seam, not the model — see [`active-designing/20260629-203012_posix-a-seam-not-a-model.md`](../active-designing/20260629-203012_posix-a-seam-not-a-model.md).

### 6. State invariants positively

Lead with what holds. The affirmative form is easier to get right and easier to read aloud, and it is the same instinct Radiant Style keeps for prose:

```zig
if (index < length) {
    // The invariant holds.
} else {
    // The invariant does not hold.
}
```

Split compound conditions into simple ones with nested `if/else`, rather than a wall of booleans joined by `and`. A single `if` often wants a matching `else`, so the positive and the negative space are both handled or both asserted.

### 7. Smallest scope, fewest variables

Declare each variable at the smallest scope that serves it, and keep the number of variables in scope small. Fewer names in flight means fewer ways to reach for the wrong one.

### 8. Explicit options at the call site

Pass options to library functions explicitly, rather than leaning on their defaults. `@prefetch(a, .{ .cache = .data, .rw = .read, .locality = 3 })` reads more clearly than `@prefetch(a, .{})`, and it stays correct even if the library changes a default tomorrow.

### 9. Docs and implementation stay synced — assert it, don't assume it

A doc that describes behavior the code no longer has is not documentation; it is a stale claim wearing documentation's clothes. This rule extends **3. Say why** and **6. State invariants positively** to the boundary between prose and code, where the same discipline applies: state what currently holds, check it, and never let a claim outlive the thing it once described.

- **A doc's claim about behavior is itself an assertable invariant.** When a README, manual page, or module doc states "X does Y," that sentence carries the same weight as `// invariant:` above a struct — it should be checkable, and it should be checked, not merely believed because it was true when written.
- **The same change that alters behavior updates the doc that describes it, in the same commit.** Accrete-never-break (**4**) applies to docs exactly as it applies to code: when a doc's claim needs to change, change it beside the code change that caused the need, rather than leaving the doc to drift and hoping a later pass catches it.
- **Before citing a doc's claim as still true, check it — read the file, run the witness, or grep the code path it names — rather than trust the doc's own age as evidence.** A doc from three days ago is not automatically current; only a fresh check is.
- **File paths, function names, and witness names a doc cites are load-bearing, not decorative.** A doc that names `tools/foo.rish` as proof of a claim is making that path part of the claim itself — if the path moves or the witness changes shape, the doc's claim moves or changes shape with it, in the same commit.
- **This is a ratchet, not a rewrite.** We do not sweep the whole tree for drift in one pass (per **4**, accretion beats a breaking sweep); we tighten it wherever a doc is already open for other reasons, and we let `living_docs_lint`'s roster (broken links, orphan pages, retired words, Status rooms, pin-string byte-match) keep catching the mechanical half of this while the discipline above catches the half no lint can see — whether the doc's *claim* is still honestly true.
- **Two Rooms applies here too:** a doc's claim belongs in the checkable room only once a witness actually binds it (`../TWO_ROOMS.md`). A claim that has not yet earned a witness stays named as intent or horizon, not stated as settled fact.

---

## Rye Supplement

Rye carries the family. The safety Rye offers is the safety every module written in it inherits. These rules are specific to Rye code (`.rye` source files). Naming, performance habits, and assertion density defer to **996** unless this supplement states a Rye-specific seam.

### Typed and sized

Use explicitly sized integer types: `u8`, `u16`, `u32`, `u64`, `i8`, `i16`, `i32`, `i64`. Use `f32` or `f64` for floating-point. Never use `c_int`, `c_uint`, or `anyopaque` without a stated, commented reason.

**Prefer fixed widths; avoid `usize` in authored Rye.** Tiger Style: use explicitly-sized types like `u32` for everything; avoid architecture-specific `usize`. In authored `.rye`, `tools/width-check.rish` flags authored `usize` while blessing sanctioned seam casts (`@intCast`, `@as(usize`). At the **inherited-std seam** (calling Zig's `std` through pristine symlinks), assert the bound and cast — that is correct Tiger code, rather than debt awaiting a compiler fork.

| Width | Role in authored Rye |
|-------|----------------------|
| **`u32`** | All in-memory counts, indices, and lengths **bounded by a named constant** (garden capacity, grid dimension, stack depth, frame size). Default width for "how many in this region." |
| **`u64`** | Wire-persistent sizes, timestamps, content offsets, and any quantity that must mean the same thing on every target. |
| **`usize`** | **Only at the cast site, never as an authored field or flowing variable.** At the inherited-std boundary: assert `len <= maxInt(u32)` (or named bound), do arithmetic in `u32`, `@intCast` to `usize` for the Zig API call. |

**Three widths, one boundary rule.** Authored Rye holds counts and indices in fixed widths; `usize` appears only where Zig's slice and allocator APIs require it — at the cast, not in a variable that flows through the module.

Two seam moves cover nearly everything:

1. **Index a slice with an authored `u32`:** cast at the index — `buf[@intCast(pos)]` or `buf[@as(usize, pos)]`. Assert the value is in range first when the bound is not already guaranteed.
2. **Take a std-provided length into authored arithmetic:** assert `len <= std.math.maxInt(u32)`, then `@intCast` down to `u32` — reuse Tally's `bufLenU32` shape rather than re-rolling the assert-and-cast at every call site.

**Worked example:** Mantra's SLC-1 path (`mantra/src/diff.rye`, `main.rye`) — seven in-memory indices migrated to `u32` with seam casts at slice indices; `store.rye` and `weave.rye` were already clean. Comlink wire formats lean on **`u64`** at persistence boundaries; Rishi REPL buffers follow the same **`u32` + seam cast** pattern as Mantra in TH-5.

**Freestanding width (Aurora).** On bare metal, `usize` is the machine word, and it is the correct, honest type for addresses, for control-and-status register values, for register-width hardware bit masks, and for local indices at the slice-access site. These are not debt; they are the kernel naming the hardware in the hardware's own width. What stays disciplined even here: a long-lived stored *count* still earns a named `u32` bound, so its ceiling is documented rather than left to the word size. The hosted authored-`usize` witness, `width-check`, governs the hosted corpus; `aurora/*` is freestanding and keeps this policy instead.

Name the bound when you pick `u32`:

```zig
const max_frame_bytes: u32 = 4096;
pos: u32, // invariant: pos <= max_frame_bytes
```

Width audit: [`work-in-progress/20260620-212126_usize-width-baseline.md`](../work-in-progress/20260620-212126_usize-width-baseline.md). **Mantra**, **Rishi**, and **Comlink** are green under the hosted policy (TH-3 through TH-6). **`width-check.rish`** is a blocking parity witness for the hosted corpus; **`aurora/*`** is scoped out and governed by the freestanding policy above.

**Seam pattern at inherited `std` (correct, not debt):**

```zig
const assert = std.debug.assert;

assert(buf.len <= std.math.maxInt(u32));
const cap: u32 = @intCast(buf.len);
// ... arithmetic in u32 ...
const start: usize = @intCast(self.pos);
assert(start <= buf.len);
return buf[start .. start + @as(usize, @intCast(n))];
```

**Compiler fork (F1–F5):** deferred **horizon** — deliberated only from a mature whole. See [`active-designing/20260628-043542_thin-frontend-slc-direction.md`](../active-designing/20260628-043542_thin-frontend-slc-direction.md). Prior fork-plan notes remain in [`active-designing/yonder/20260621-070712_the-compiler-fork.md`](../active-designing/yonder/20260621-070712_the-compiler-fork.md) as research, rather than the active primary track.

### Naming (Tiger Style)

**`snake_case`** for functions, variables, and file names — per `gratitude/TIGER_STYLE.md` and `external-research/TAME_GUIDANCE.md`. The underscore is the closest thing we have to a space; descriptive names read aloud well.

- Name functions with a verb: `compute_diff`, `serialize_weave`, `load_weave`, `read_brix`.
- Name constants in `snake_case` with units and qualifiers last when helpful: `max_depth`, `digest_hex_len`.
- Early seeds may still carry `camelCase` from before this rule landed; migrate names opportunistically when you touch a file — rather than renaming silently across the tree in one sweep.

**Types and receivers.** A function that returns a `type` carries a `CamelCase` name ending in `Type` — `StackType`, `BitSetType` — so the reader sees a type constructor at a glance. When a method aliases its own type, give the alias the **real type name**, `const Stack = @This();`, rather than the bare `Self`. For the receiver itself, name it after the type in non-generic structs — `file: SourceFile`, `counter: *IdentifierCounter` — which reads more clearly than a generic `self`; the plain `self` stays welcome inside generic wrappers where the type name is a parameter.

For everything else, follow the Zig style guide as filtered through **996** (line length, braces, `zig fmt`, and the rest).

### The opening lines

Every hosted `.rye` file that speaks or checks begins with the same three lines — the canonical head, tutorial one's first breath:

```zig
const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;
```

A one-line prelude was weighed and set aside: Rye removed the namespace-splat long ago, so a single import would force qualified calls and collide with bare `assert` (checked by tidy) and bare `print` (ruled this week). A prelude file would spend the same three lines plus an indirection. **Canonize these three** until the shared head outgrows four names — the day indirection starts paying rent. A gentle textual check for the canonical head waits on the horizon beside `tame-check`.

### Assertions as first-class design

`assert(cond)` is not a debugging tool; it is the design written down where the machine can check it. Import it unqualified once per file — `const assert = std.debug.assert;` — and call it bare, the way TigerBeetle does throughout. Assertions detect programmer errors, which are unexpected; the correct response to corrupt code is to crash, and so an assertion downgrades a catastrophic correctness bug into a loud, findable liveness bug.

- **Density.** Assert all function arguments and return values, preconditions, postconditions, and invariants. Aim for an average of at least **two assertions per function** — a function that checks nothing operates blindly on data it has not verified.
- **Preconditions** — at the top of a function, before any work: the conditions the caller must have arranged.
- **Invariants** — after every mutation of a data structure: the conditions the structure must always keep.
- **Postconditions** — after a computation: the conditions the result must honor.
- **Pair your assertions.** For each property worth enforcing, find two different code paths to assert it on — validity right before a write and again right after the matching read, a count checked on both `push` and `pop`. The boundary between valid and invalid is where the interesting bugs live, so guard both sides of it.
- **Assert positive space and negative space.** Assert what you expect to be true, and also assert what you expect to be false. Tests follow the same rule: exercise valid data, invalid data, and data crossing from one to the other.
- **Split compound assertions.** Prefer `assert(a); assert(b);` over `assert(a and b)` — the split form reads more simply and names exactly which half failed.
- **Assert implications on one line.** `if (a) assert(b)` states "a implies b" plainly.
- **Assert at compile time.** Use `comptime assert(...)` to check the relationships of compile-time constants and the sizes of types, so a design flaw is caught before the program ever runs.
- **Gate the expensive check.** When a thorough assertion costs too much for the hot path, place it behind a verify flag rather than dropping it: `if (constants.verify and verify_push) assert(!contains(link));`. This mirrors our verify-flag hot-path thread.

A small, complete example — a bounded stack, asserting its invariant on two paths and naming its bound:

```zig
const assert = std.debug.assert;

fn push(stack: *StackAny, link: *Link) void {
    assert((stack.count == 0) == (stack.head == null)); // structural invariant
    assert(link.next == null);
    assert(stack.count < stack.capacity);              // the bound

    link.next = stack.head;
    stack.head = link;
    stack.count += 1;
}

fn pop(stack: *StackAny) ?*Link {
    assert((stack.count == 0) == (stack.head == null)); // same invariant, second path
    const link = stack.head orelse return null;
    stack.head = link.next;
    stack.count -= 1;
    return link;
}
```

In tests, reach for `std.testing.expect` and `std.testing.expectEqual` rather than `assert`.

### Diagnostic output (`print`)

For hosted seeds and modules, mirror the assert import: bind once per file — `const print = std.debug.print;` — and call bare `print(...)`. TigerBeetle's `tidy.zig` bans qualified `debug.assert(` and expects unqualified `assert`; it does **not** ban qualified `debug.print(`, yet the same once-per-file binding keeps diagnostic lines short and consistent across the hosted corpus.

- **As-you-touch.** Migrate when a file is already open for other work — the same discipline as assertion-density hygiene, rather than a tree-wide sweep.
- **No witness yet.** `tools/tame-check.rish` does not flag `std.debug.print(`; add that rule only if the need is proven, the way we defer AST-tier lints.
- **Separate layers.** Rishi `.rish` pipelines speak through `say`; freestanding Aurora may grow its own logging seam when the boot path matures; `rye/tests/*` witnesses may keep the qualified form until touched.

### Disjoint copies — never bare `@memcpy` in new code

`@memcpy` trusts its caller twice: that the lengths agree, and that the regions never
overlap. New code carries that trust to `tally/copy.rye` instead — `copy_disjoint(T,
target, source)` asserts both preconditions and then performs the copy it guards. Elder
`@memcpy` sites migrate as their files are touched; `tools/tame_style_check.rish` prints
the remaining count on every parity run, so the ratchet only ever turns one way. As of
parity **191**, every authored application site routes through `copy_disjoint`; the lone
remaining `@memcpy` is intentional inside `tally/copy.rye`.
`copyForwards` and `copyBackwards` are banned outright — where a genuinely overlapping
move is one day needed, it earns its own asserting form beside this one.

### Integer parsing — prefer `tally/parse_int.rye` over bare `std.fmt.parseInt`

`std.fmt.parseInt` accepts a leading zero silently; TigerBeetle's `parse_int` refuses one
by default — a leading zero on parsed input is far more often truncation, injected data, or
a copy-paste seam than a number anyone meant to write that way. New code calls
`tally/parse_int.rye` with explicit options at the call site; hex byte-pair decoders state
`allow_leading_zero = true` in the open. Elder `parseInt(` sites migrate on touch;
`tools/tame_style_check.rish` prints the remaining count every parity run. Seated at counsel
`20260707.203612`; ratchet closed at **`0`** application sites (`20260707.213000`) — every
scan-dir site routes through `tally/parse_int.rye`; the lone intentional `parseInt(` remains
inside `parse_int` itself.

### Identity at the seam — prefer `tally/kumara.rye` over bare `std.crypto.sign.Ed25519`

Every signed fact in this tree reaches identity through Ed25519. Scattering `Ed25519` imports
across modules hides the seam where a Kumara keypair signs before a fact enters a log.
New code calls `tally/kumara.rye` for deterministic keypair, sign, and verify; elder
`Ed25519` sites migrate on touch. `tools/tame_style_check.rish` prints the remaining count
every parity run. Seated at counsel `222812`; first lap `20260707.224101` (receipt cluster);
ratchet closed at **0** application sites (`20260708.030200`) — virtio guest cluster complete;
scan excludes X25519 `fromEd25519` / `publicKeyFromEd25519` conversion seams (Zig spells both).
Arc: **326** opened → **276** hosted + Aurora → **91** product → virtio guests → **0**.
The sole intentional `Ed25519` block remains inside `tally/kumara.rye`.

### Named errors

Error types are named for the **fault**, rather than the operation that discovered it: `error.OutOfBounds`, `error.InvalidFormat`, `error.NotFound`.

Propagate errors with `try`. Catch only at the boundary where the program can act: a command entry point, a test body. When you must compare an error, **switch on it** rather than writing `err == error.Foo` or `err != error.Foo` — the equality form silently widens to `anyerror` and lets a new error slip through unhandled, while a `switch` makes every case visible. Never swallow an error silently with a discard pattern. Handle every error: most catastrophic failures trace back to mishandled non-fatal errors.

### Short functions

One function, one idea. We keep a **hard limit of 70 lines per function** — the point where a function stops fitting on a screen and starts asking the reader to scroll. Art is born of constraints, and most walls of code have a natural seam at this length.

We bring the rule in by **ratcheting from the bottom up**, rather than sweeping the whole tree at once: the greatest value is in keeping a small function from quietly growing into a large one, so a function newly crossing the line is the one to split. This is accrete-never-break applied to length.

When you split, **push the `if`s up and the `for`s down**: keep the branching in one parent function, and move the non-branchy work into leaf helpers that stay pure. Centralize control flow and state in the parent; let the helpers compute what changes rather than applying it. A function that needs a `// ---` section divider is doing more than one thing and wants splitting.

Parameters: declare the tightest type you can. Prefer slices over pointers when ownership stays put.

### Named constants

No magic numbers inline. Name constants with their type:

```zig
const max_depth: u32 = 1024; // chain length above which we stop and warn
const digest_hex_len: u32 = 64; // SHA3-256 digest rendered as hex
```

The comment names why the bound exists, rather than only what it is.

### Structs carry their invariant

The comment block immediately before a struct declaration states what must hold at all times:

```zig
// Invariant: pos <= buf.len.
// Invariant: every byte in buf[0..pos] was written by this Region's put call.
const Region = struct {
    buf: []u8,
    pos: u32,
};
```

A mutation function on the struct asserts the invariant holds on entry and on exit.

### Season memory — never `ArenaAllocator` directly

In **authored** Rye programs (`.rye` seeds, tools, witness tests, Skate, Rishi source), reach for the process season allocator through **`init.arena`** at the pristine std seam, rather than through `std.heap.ArenaAllocator`:

```zig
const garden = init.arena.allocator();
```

Name the local `garden` (warm vocabulary — Tally's future owned concept) or `allocator` when the role is generic. Do not construct `ArenaAllocator` in our code, do not name the type in our APIs, and do not add `std.heap.GardenAllocator` as a rename of the inherited type.

**Why:** `ArenaAllocator` is Zig's inherited name — we keep it in `std` untouched (`context/specs/inherited-names.md`). At the thin-frontend seam, Zig names the field `arena`; we honor that name in code. `garden` lives as a local binding and as Tally's future owned vocabulary (`rye.garden` or `tally/heap-garden.rye` when the wrapper graduates). Inherited `std` internals may still use `ArenaAllocator`; that is out of scope for authored programs.

**Freestanding / no `Init`:** use `std.heap.FixedBufferAllocator`, Tally `Region`, or an explicit child allocator passed in — still not `ArenaAllocator` in authored code unless you are strengthening inherited `std` itself.

**On static allocation.** TigerBeetle allocates all memory at startup and frees nothing after, a discipline its database domain rewards with zero latency spikes and no use-after-free. We adopt the spirit fully — bound everything, name every budget — and we adopt the letter where the domain matches: freestanding Aurora paths favor `FixedBufferAllocator` and Tally regions sized up front. For hosted seeds and tools, the bounded `init.arena` season is our deliberate, honest choice: a single arena, released at the end of its season, rather than per-call churn. We name this difference plainly rather than claim a rule we do not yet keep.

**Release-after-one-checkpoint, where a rewind could still need it.** In a crash-recoverable, append-only, checkpointed subsystem — Neth's root storage, Amber's cellar, Mantra's history — a resource finished with is **not freed immediately**. It is released only after one checkpoint has passed, because a crash that rewinds the system to before the replacement was durably written could still need the thing that looked done. The deferral is cheap and closes a whole class of use-after-rewind faults. This is the crash-safety companion to the *written-is-not-acknowledged* rule (a thing becomes true for the system only when the one authoritative record admits it). Siloed from the IronBeetle build stream — study [`../external-research/20260714-041542_ironbeetle-patterns-for-the-neth-ladder.md`](../external-research/20260714-041542_ironbeetle-patterns-for-the-neth-ladder.md). It applies only where a checkpoint/rewind model exists; ordinary bounded season memory keeps its plain end-of-season release.

---

## Brix Supplement

Brix is the composing language: it describes what a system is made of. A `.brix` file is a declaration, rather than a program. These rules govern `.brix` descriptors.

### Declarative only

A `.brix` file describes what exists. It contains no commands, no conditions, no loops, no expressions. The format is plain key-value: one field per line, a single space separating key from value, `#` for comments.

### Each brick is individually simple

A `file` entry names one source file. A brick makes no claim about other bricks. Simplicity here is structural: a brick that depends on knowing about its neighbors is not yet a brick.

### Comments name what the brick is

A comment above a `file` entry says what that source file *is* — its role in the system — rather than what it does or how it works:

```
# Rishi — the shell that speaks commands
file rishi/src/main.rye
```

### The descriptor is a value

Any tool that reads a `.brix` file should be able to do so with `splitLines` and the first-space split. No grammar, no parser, no special characters. A descriptor readable by hand is readable by any tool.

---

## Rishi Supplement

Rishi is the shell: typed pipelines, process results as structured values, assertions as the smallest witnesses. These rules govern `.rish` scripts.

### Run returns a structured value

`run` produces a structured result: `{ status, out, err }`. Never treat `out` as reliable until `status` has been checked. A pipeline that discards `status` silently is a pipeline that has decided faults do not matter.

```
let result = run "zig" ["build"]
assert result.status == 0  // invariant: build succeeded before we run tests
```

### Assertions, the smallest witnesses

An `assert` in a Rishi pipeline stops the pipeline loudly when the condition fails. Place assertions at stage boundaries: after a `run`, before a write, before a conditional branch. The assert is the cheapest correctness check available; use it freely.

### Effects are visible and ordered

A pipeline stage that has side effects — writing a file, sending a message, modifying state — comes last in its group and is named or commented to say so. A reader moving left to right through a pipeline should encounter effects after the computations that justify them.

### Terseness that never costs safety

Short pipelines are good. A pipeline longer than roughly ten stages earns a name and a comment block explaining its purpose. A pipeline whose stages are individually unclear earns intermediate `let` bindings with named values.

### Bindings are named

`let` binds a named value. Name bindings for what they *are*, rather than for how they were computed: `let commit_hash = ...` rather than `let result_of_sha3_over_blob = ...`.

---

## What We Check, and When

These are the machine-checkable rules — the lint surface. The discipline is the distinctiveness we chose when we made Rye a thin frontend, so we grow these checks the way we grow everything: as small, demand-driven increments beside the work, rather than one large sweep. Each line names the rule, and the tool that catches it today or the horizon it waits for.

**Enforced now — textual checks in Rishi** (grow these first, each with a witness, alongside SLC-1 and the width migration):

| Rule | Check |
|------|-------|
| **No authored `usize` in published `.rye`** (seam casts blessed) | `tools/width-check.rish` (live, TH-1) |
| **Dated artifacts on main stay immutable** (unless living ledger header or freeze pointer) | `tools/dated_guard.rish` (live, beside width-check; spec [`living-vs-dated.md`](specs/living-vs-dated.md)) |
| **Unqualified assert** | `tools/tame-check.rish` (live witness, TH-2c) |
| **Opening lines** (`const assert` + `const print`, no qualified debug calls) | `tools/opening_lines_witness.rish` (live witness, parity **140** — hosted corpus + `pond/apps/drawn_terminal.rye`) |
| **At most one designed-not-built functional spec** (`context/specs/*.md` Status) | `tools/designed_not_built_witness.rish` (live witness, parity **143**, Edit 5 ruling `20260703.032812`) |
| **Amber first lap** (export / verify / restore on fixture tree) | `tools/amber_first_ring.rish` (live witness, parity **144**, `20260703.051812`) |
| **No `Self = @This()`** | `tools/tame-check.rish` (witness) |
| **No tabs, no trailing whitespace** | `tools/tame-check.rish` (witness) |
| **Line length ≤ 100 columns** | flag lines past 100, allowing a URL or a multiline-string result that itself fits |
| **One `# Title` per markdown** | flag any `.md` with zero or more than one top-level `#`, fenced code ignored — directly serving our doc-heavy tree |
| **Living docs lint (roster advisory)** | `tools/living_docs_lint.rish` — five duties; ratchet advisory; prints in parity ch.1 beside `tame_style`; roster in `tools/fixtures/living_docs_lint_roster.sh` |
| **signed-Kumara parity (proven-seat)** | `tools/proven_seat_signed_kumara_parity.rish` — parity ch.2 tail; fetch gates; build+serial when bench staged; jail-safe ADVISE skip |
| **No leftover `FIXME` or `dbg(`** | flag both before merge; `FIXME` is welcome while iterating, gone before main |
| **Disjoint copies through `tally/copy.rye`** | `copyForwards`/`copyBackwards` banned; `@memcpy` counted down as a ratchet; new code calls `copy_disjoint` — `tools/tame_style_check.rish` (live) |
| **Qualified `debug.assert(` anywhere** | banned; import once, call bare — the import line carries no parenthesis, so the string alone convicts |
| **Compound `assert(a and b)`** | banned; split so the failing half is named |
| **Call-result compared to an error** | `) == error.` and `) != error.` banned at the call seam (silent `anyerror` upcast); a captured `\|err\|` compared inside an assert stays welcome — the refined seam, reasoned in the alignment study |
| **`usingnamespace` · `!comptime` · `Self = @This()`** | banned verbatim, as upstream — `tools/tame_style_check.rish` (live) |

**Ratchet advisories — print every parity run, never fail** (`tools/tame_style_check.rish` second half; hand-run `rishi/bin/rishi run tools/tame_style_scan_advise.rish` or `sh tools/fixtures/tame_style_scan.sh advise`):

| Ratchet | Law on touch |
|---------|----------------|
| **`@memcpy(` sites** | route through `tally/copy.rye` `copy_disjoint`; sole intentional `@memcpy` may remain inside `copy_disjoint` itself |
| **`parseInt(` application sites** | route through `tally/parse_int.rye`; state `allow_leading_zero` explicitly for hex byte pairs; sole intentional `parseInt(` may remain inside `parse_int` itself |
| **`Ed25519` application sites** | route through `tally/kumara.rye`; sole intentional `Ed25519` block may remain inside `kumara` itself |
| **camelCase `fn` declarations** | rename to `snake_case` in every function you touch in that file; repoint inbound references before commit |
| **functions past 70 lines** | split at the natural seam (welcome/unwelcome, per-kind arms, wire hops, loop bodies); one idea per function |
| **zero `assert(` in core modules** | import `const assert = std.debug.assert` and name contract postconditions; honest exempt list in `tame_style_scan.sh` (guests, aurora freestanding, signal handler, font table, line editor, exit constants) |

**Scan roster** (`tools/fixtures/tame_style_scan.sh`): `mantra`, `caravan`, `linengrow`, `comlink`, `rishi/src`, `tally`, `aurora`, `pond`, `brushstroke`, `rye/src`. **`tools/`** snake_case season closed at **0** (`20260707.203612`); **`parseInt(` ratchet** closed at **0** (`20260707.213000`).

**POSIX seams — keep `.sh` entry points, orchestration in `.rish`:** witness-support scans migrated (`tame_style_scan` mode router + bans + advise; `rs1_args_max`, `rw1_exact_probe`, `opening_lines_scan`, `tame_check_mantra`, `tame_check_scan`, `chrono_version_scan`, `identity_shape`, `designed_not_built_scan`, `two_rooms_doorway_scan`, `tame_style_long_fn` — counsel `042112`, extended `155500`–`161200`); migrated `.sh` elders thin-delegate to native (`160200`); legacy parity scripts `tame_style_scan_*_legacy.sh` stay for selftest diff only; glob/per-file seams (`chrono_version_roster.sh`, `two_rooms_doorway_*`, `tame_style_long_fn_one.sh`) documented above. **Map-transform ceiling (`160700`, narrowed `160800`):** inner `map` over `lines (read-file f)` fails with `ListTooLong` when `f` exceeds **256 lines**; chained `where` over the same lines works. **Structural QEMU orchestration** — all eleven `comlink/run_*_wire_lab.sh` and `aurora/run.sh` thin-delegate to `tools/*_wire_lab.rish` / `tools/aurora_run.rish` using `spawn` / `wait-for` (wire labs) or blocking `run` (aurora single-process wake); counsel `20260708.035600`. **Permanent `.sh`:** `rye/bootstrap.sh` (cold start before `rye` exists); external interpreters (`cast_a_chart_host.sh`, `tools/cursor-jail.sh`, `tools/fetch_gratitude_web.sh`); interactive REPL-over-stdin scripts (`slc1_accept.sh`, `slc1_version_step2.sh` — `run` sets `.stdin = .ignore`; shell redirect stays). **Where-input wall (`042112`, narrowed `155500`, worked `160500`):** nested `where (where list as x: …) as x: …` fails — chain sequential `let passN = where passN-1 …` instead; `map` + record fields still cover most multi-check scans. **List indexing is real:** `expr[n]` and `.len` work generally on any list, not only the specially-bound `args` — a correction to this file's own earlier silence on the point. **Stream discipline:** `say` always writes to stdout via `std.Io.File.stdout()`; the runtime's own `print`-based messages (argument-count rejection, file-not-found, and similar) use `std.debug.print`, hardcoded to stderr regardless of context — a script capturing another Rishi process's result needs to know which field carries which. **Count idiom:** `for-each` cannot accumulate — use `map` → `join` with `" + "` → `sh -c "echo $((${expr}))"` (`tools/rish_count_selftest.rish`).

**Standing exempt — intentional-violation fixtures:** files built to *hold* a violation the lint must catch (e.g. `tools/fixtures/width_check_authored_usize.rye` for TH-1 width) stay as wrong as their purpose requires. Migrating them toward compliance would disable the proof they supply — same logic as elder Amber goldens. No ratchet reaches for them.

At parity **196** the >70-line ledger cleared for authored `.rye` in scan dirs; camelCase **0** through `rye/src` (`20260707.175312`); zero-assert non-exempt **0** after sync-wire and snapshot-delivery contract asserts (`20260707.183412`); **`maybe`** seated in `tally/maybe.rye` with first real caller in `no_padding` (`20260707.185612`); tools enrich safety net complete (`20260707.193712`); **`parseInt(` ratchet** closed at **0** (`20260707.213000`). **TigerBeetle alignment arc closed** (`counsel/20260707-213212`) — no further TAME season lap until AST-grade rules earn a parser. Full machine canon and Claude brief: [`active-designing/20260707-164612_tame-tidy-rules-brief.md`](../active-designing/20260707-164612_tame-tidy-rules-brief.md) · study [`external-research/20260707-053212_tigerbeetle-alignment-study.md`](../external-research/20260707-053212_tigerbeetle-alignment-study.md).

**Horizon — witness pairing (gated on Kaeden ruling):** as module seams stabilize, each earns mirrored **collaboration** and **contract** witnesses at the boundary — see [`foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md`](../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md) and the first-pass census at [`work-in-progress/20260702-180812_testing-audit-first-pass.md`](../work-in-progress/20260702-180812_testing-audit-first-pass.md). Metalsmoke and parity stay the thin edge today.

**Horizon — wait for a Zig parser** (build when Rye's own tooling can parse, or when the need is proven; do not clone `tidy.zig` ahead of the need):

| Rule | Why it waits |
|------|--------------|
| **70 lines per function, hard gate** | textual advisory today (`tame_style_scan_advise.rish`; `tame_style_long_fn.sh` for `>70` ledger); AST hard gate when a parser lands |
| **Parenthesize bitwise-with-arithmetic mixes** | needs the AST to read operator nodes |
| **`defer` followed by a blank line** | needs token positions |
| **Dead declarations and dead files** | needs identifier and import analysis |
| **Switch on errors, not `== error.`** | a textual flag is a fair first pass; the AST makes it exact |

Vocabulary keeps Radiant's register even where the borrowed lint's own comments do not: the standing swaps — misuse guard for footgun, fall for crash, silent-peer for dead-peer, wait-without-bound for hang — live in [`context/specs/20260707-053212_radiant-vocabulary-pass.md`](specs/20260707-053212_radiant-vocabulary-pass.md). The full enforcement we are learning from lives in TigerBeetle's `src/tidy.zig`. We borrow its rules in our own voice and at our own pace, and we keep its file in gratitude.

---

*May the root hold firm across every language we grow. May each supplement stay small — exactly as small as the language has earned, and no larger. May the rules serve the work, and the work serve what is true.*
