# mold→shape Debride — Survey and Plan (before any cut)

**Language:** EN
**Stamp:** `20260811.184002`
**Status:** Survey — the looking pass a debride owes before the knife. No cut taken; this classifies the 3058 `mold` occurrences and names the true, small target so the sweep, when it runs, damages nothing it should keep.
**Voice:** Kyri · **Style:** Radiant
**Law:** the seated **Shape** decision (`context/LEXICON.md` → Shape · Mold entries; `active-designing/20260720-223226_glow-os-shape-not-mold.md`) · **debride** (`.claude/rules/debride.md`) · **cairn** (`.claude/rules/cairn.md`)

---

## The finding that reframes the debride

`mold→shape` sounds like a mechanical sweep of 3058 occurrences. It is not — the seated Shape decision (`20260720`) **already did the primary rename** (`ShapeSpec` · `rune_shape` · `lower_shape` · `AmountShape` · the living `*-shape` aliases). What remains is **overwhelmingly correct to keep**, and a blind sweep would damage all of it. Measured (`git grep -InE '\bmold'`, 3058 total):

**KEEP — never swept:**
- **Dated testimony (~314 session-log files, plus counsel and dated `active-designing`/`external-research`).** Accrete-never-break and the one-clock law: dated artifacts keep the words they recorded. This is the bulk of the 3058.
- **The retirement's own explanation.** `LEXICON.md`'s **Mold (Hoon study)** entry and the **Shape** entry ("Hoon study twins keep `-mold`") *teach* the distinction by naming both words; `TAME_GUIDANCE.md` likewise. Relabeling these would erase the very explanation of the change.
- **The deliberately-kept study twins.** `glow/nest_type.rye`'s `bartis_named_study_amount = "amount-mold"` (and `count`/`kind`/`xact`/`xfer`/`pair`-mold) are the Hoon-study names the seated decision **keeps on purpose** — STOA148–160 seat *living `*-shape` beside study `*-mold`*. The parser accepts both; the study string stays.
- **The 14 Hoon-study twin files** under `glow/gen/hoon-study/`.

**RELABEL — the true target, and it is small and interlocked:**
- **Grain-sense identifiers inside the Glow compiler still named `mold`** — `expr.rye`'s `mold_slice()`, `zig_type_for_mold()`, the `Expr.mold` buffer field and `mold_len`, and the `mold`/`mold_end` locals in the cast parser. These name *Grain's own* parse of a cast's type-word, so by the Shape decision they should read `shape` (`shape_slice`, `zig_type_for_shape`, `Expr.shape`/`shape_len`). The functions still *accept* the study `*-mold` strings — the identifier renames, the study vocabulary it handles does not.

## Why the target is one atomic refactor, not a per-file lap

The Grain-sense identifiers interlock across the lowering suite: `mold_slice` is called from **23 `.rye`**, `zig_type_for_mold` from **7**, `Expr.mold`/`.mold_len` read in **9** (`expr.rye`, `expr_witness.rye`, every `lower_*`, `rune_cast`, `rune_face`, `tokens`, `glow_run`). Renaming any one means repointing every caller and rebuilding + re-witnessing the **whole Glow lowering suite** in one pass — a partial rename leaves the compiler uncompilable. So this is a single atomic refactor, gated on:

1. **Loaded Glow context** — the shape-vs-study judgment is per-symbol (an identifier that names Grain's concept renames; one that names the Hoon parallel a study twin reads stays), and it is a language-design call in Keaton's own language, not a mechanical substitution.
2. **A bench that runs the full Glow witness suite** — every `glow/*_witness.rye` GREEN before and after, so the refactor is proven, not hoped. (This sandbox builds single glow files; the whole-suite rewitness wants the language bench.)
3. **A cairn at the cut** — planted the moment the refactor commits (nib + stamp), per the debride discipline. Not planted here, because nothing departs in a survey.

## The plan, in order

1. **This survey** — done; the keep-zones and the true target are named.
2. **The atomic identifier refactor** (word-gated, loaded context, full-suite rewitness): `Expr.mold`→`shape`, `mold_len`→`shape_len`, `mold_slice`→`shape_slice`, `zig_type_for_mold`→`zig_type_for_shape`, and the cast-parser locals; repoint all ~23 callers; keep every `*-mold` study string and every study-twin file untouched; a cairn at the commit; the whole `glow/*_witness` suite GREEN.
3. **Leave the testimony, the retirement-explanation, and the study twins exactly as they are** — they are not drift; they are the record and the teaching.

## Why no cut this round

A debride is destructive by design and runs on a named target with the fascia healed afterward. Here the honest survey shows the target is a delicate, interlocked compiler refactor whose correctness rests on a per-symbol language judgment and a full-suite rewitness. Taking it blind would break the compiler and corrupt the shape/study distinction — the opposite of a healed fascia. The survey is the debride's first true lap; the cut waits for the bench and the word that let it land proven.

---

*A debride heals the fascia; it never tears it. The looking pass that finds most of the tissue healthy is the first act of care, not a delay of it.*
