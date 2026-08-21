# Glow Rune Pronunciation — Closed Table (G1)

*Closed pronunciation table for every GREEN Glow rune head tokenized today. Glyph · spoken · family · one-line meaning · RISC-V/TAME note. Roadmap lap **G1** after STOA89 / G0.*

**Language:** EN  
**Version:** `20260719.220814` (Eastern)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — witness `../tools/glow_rune_alphabet_witness.rish`  
**Waymark:** **STOA90**  
**Grounds in:** [`20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md`](20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md) · [`../glow/tokens.rye`](../glow/tokens.rye) `match_rune2` · [Hoon School — Pronouncing Hoon](https://docs.urbit.org/build-on-urbit/hoon-school)

---

## Authority

The closed set is exactly the digraphs in `glow/tokens.rye` → `match_rune2`. A head enters this table when it tokenizes and has a parser/lower path. Horizon digraphs stay out until they earn that seat.

**Horizon (named, not GREEN):** `|=` bartis · `|^` barket · sig hints `~%` · `~/` — study names ready; no token/lower yet. The G0 families brief may still list bartis/`|^` beside bar heads as teaching aspirants; this closed table is the authority for GREEN.

**Count:** **25** GREEN heads.

---

## Closed table

| Glyph | Spoken | Family | Meaning | RISC-V / TAME note |
|-------|--------|--------|---------|-------------------|
| `\|-` | barhep | bar | Bounded trap — loop at most N times | Bound checked at expansion; `BoundExceeded` — not Hoon's free unbounded trap |
| `\|%` | barcen | bar | Named-arm battery core (bare or payload) | Expands to ordinary Rye structs/fns; arms stay named |
| `++` | luslus | lus | Arm define inside `\|%` | Structural delimiter; no separate RISC-V gift |
| `--` | hephep | hep | Core body close for `\|%` | Structural terminator |
| `^-` | kethep | ket | Cast to mold (aura or named) | Type/mold check at lower; Zig types on metal |
| `=/` | tisfas | tis | Face bind — named face, optional mold | Ordinary locals; typed multi-line desks already GREEN |
| `=.` | tisdot | tis | Wing mutate — replace one leg | Explicit mutation; no ambient subject magic |
| `=*` | tistar | tis | Alias — named reference, no copy | Alias face only; optional source wing |
| `?:` | wutcol | wut | If / then / else | Ambient Zig `bool` — not Nock loobean |
| `?-` | wuthep | wut | Exhaustive switch by tag | Missing arm fails at lower — TAME exhaustiveness |
| `?~` | wutsig | wut | Null test — null arm vs else | Null as explicit mold/case, not loobean 0 |
| `?>` | wutgar | wut | Positive assert — then body | Lowers to Rye `assert` — TAME opening triad |
| `?<` | wutgal | wut | Negative assert — then body | Lowers to Rye `assert` (negated condition) |
| `:-` | colhep | col | Pair cell — two faces | Fixed-width cell; Zig struct/tuple shape |
| `:+` | collus | col | Triple cell — three faces | Same — width named in the rune |
| `:^` | colket | col | Quad cell — four faces | Same |
| `:~` | colsig | col | List cell — one to four faces | Bounded length at parse |
| `%-` | cenhep | cen | One-argument call | Closed demo gates; ordinary fn call on metal |
| `%+` | cenlus | cen | Two-argument call | Same |
| `%^` | cenket | cen | Three-argument call | Same |
| `%*` | centar | cen | Named-argument call | Named faces → call args |
| `+$` | lusbuc | buc | Named mold definition | Mold → Zig type / struct |
| `$:` | buccol | buc | Tuple mold — 1–3 `@u32` fields | Field count bounded |
| `$%` | buccen | buc | Tagged-union mold | Cold tags; payload arms optional |
| `/+` | faslus | fas | Library import | Pull named library core into scope |

---

## How the witness binds this

`tools/glow_rune_alphabet_witness.rish` asserts:

1. Each of the 25 glyphs appears in `glow/tokens.rye`.
2. Each spoken name appears in this file.
3. The rune2 pair list still holds exactly these heads (count gate).

When a new rune earns GREEN, add a row here and a matching assert in the same lap.

---

## Glyph alphabet (adopted, for reading)

Speak digraphs by concatenating Hoon's one-syllable glyph names (bar · wut · tis · ket · col · cen · buc · fas · lus · hep · …). Full glyph chart: G0 brief above. Study attribution: Urbit Hoon School — restated here; never a second private alphabet.

---

*May every GREEN head stay speakable, and may the table grow only when the tokenizer does.*
