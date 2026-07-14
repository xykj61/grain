# Toward a Glow Supplement — Runes, Auras, Cold/Warm Atoms, and Hoon-Grade Linting

**Language:** EN
**Version:** `20260714.060412` (corrected — see the note below)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Scoping — proposes a future TAME_GUIDANCE.md supplement, writes no grammar or code yet

---

## What This Answers

Kaeden asked for Glow's fusion design to have a real answer for Hoon's rune syntax, its aura system, cold and warm atoms, structs and nouns, and comment/line-width conventions that match Hoon's own linting patterns — with a **new TAME Guidance supplement for Glow, stricter than the existing Rye supplement**, governing all of this. This document scopes that supplement's shape; it does not write the supplement itself yet, matching this session's own established research-before-code pattern.

## A Correction to This Document's Own Earlier Mistake

The first version of this document "corrected" Kaeden's own term — wrongly. Kaeden was right: **cold atoms and warm atoms are real, specific Hoon terms**, confirmed directly against `docs.urbit.org/hoon/rune/constants`, and they have nothing to do with the jet dashboard's cold/warm/hot *state* this document mistakenly reached for instead. The two concepts share two adjectives and nothing else. Corrected here in full:

- **Warm atom** (AST node `[%sand p=term q=*]`) — a constant typed by its **aura**: the *general* type for that aura, not narrowed to the one literal value. `` `@`12 `` is warm — typed "an atom," and any atom nests into it.
- **Cold atom** (AST node `[%rock p=term q=*]`) — a constant typed as a **singleton**: exactly that one value, and nothing else. Written as any warm-atom literal prefixed with `%` — `%12`, `%hi`. `` `%12`12 `` fails with `nest-fail` for a plain `12`, because a cold type of `%12` accepts only the value `12` typed as `%12`, not a general atom that happens to equal it.

This distinction is Hoon's own answer to a real type-theory question — when should a constant's type be "this specific value" versus "any value shaped like this" — and it belongs directly beside the aura discussion below, not beside jet-acceleration correctness. The jet-state material this document originally substituted in its place has been moved out entirely; it answered a question Kaeden did not ask.

## Five Real Design Surfaces, Named Plainly

### 1. Runes

Hoon's rune system (`|=`, `^-`, `=/`, and roughly 200 more) is "unusually large but unusually regular" by its own documentation's own words — each rune's first glyph names a category (`|` for cores, `^` for casts, `=` for bindings), and the second glyph specializes within it. A Glow rune system inherits this *readability* discipline directly: **Glow keeps rune-shaped syntax, but every rune's expansion is checked against TAME's bounds at the point of expansion**, not left to trust the way Hoon's own compiler does. This is the same resolution the earlier Nock/Hoon fusion scoping doc already proposed as its lead option (runes as surface syntax, bounded semantics underneath) — this document confirms that direction specifically for the rune question and extends it to the four remaining surfaces below.

### 2. Auras, and Cold vs. Warm Atoms Together

Hoon's auras (`@ud` unsigned decimal, `@p` ship name, `@t` text/cord, `@da` absolute date, and dozens more) are bit-tag refinements of the one real Hoon type — the atom. Auras are Hoon's answer to "a number is not just a number; it means something," without needing a separate type for each meaning. **Glow's own answer should be stricter, not looser**: Rye's own Rye Supplement already names fixed-width discipline (`u32`, `u64`, never bare `usize` in authored code) as a root safety property. A Glow aura system should require every aura to *name its own bound* the way Rye already requires named constants to name their bound — an aura is not just "this atom means a ship name," it is "this atom means a ship name, and a ship name's `@p` encoding has a stated, checked bit-width for its tier (galaxy 8 bits, star 16, planet 32, moon 64, comet 128)."

**Cold and warm atoms are the companion question, one level up from the aura itself**: not "what does this atom mean," but "how narrowly does the compiler know its value." Hoon's warm atom (typed by aura alone, general) and cold atom (typed as one exact literal, singleton) are both real, useful, and already TAME-compatible in spirit — a cold atom is, in effect, a compile-time-checked constant, close to `comptime assert` territory in TAME's own Rye Supplement ("assert at compile time... to check the relationships of compile-time constants"). **Proposal for the supplement:** Glow keeps both, named plainly rather than inheriting Hoon's terse `%`-prefix-means-cold convention unexplained — a Glow cold-atom declaration states, at the declaration site, that it is intentionally narrowed to one value (mirroring TAME's "explicit options at the call site" root rule), so a reader never has to infer cold-vs-warm from a single `%` glyph the way Hoon itself asks them to.

### 3. Jet Correctness (a Related but Separate Question)

Distinct from cold/warm atoms, but worth naming while it is fresh: a Glow-native acceleration system (jets, in Hoon's own terms) still needs an answer to a real correctness question this fork's Vere study already raised — a jet is a proof obligation, not only a performance trick. **Proposal for the supplement:** every jet in Glow ships with a paired witness — a fixture proving the accelerated path and the pure Glow path produce identical output on the same input — mirroring TAME's own "pair your assertions" rule applied to acceleration correctness specifically. This is a real design surface Kaeden did not ask about directly this round, kept here only because the earlier draft's mistake surfaced it usefully; it is not part of "cold and warm atoms" and should not be read as though it were.

### 4. Structs and Nouns

Hoon's "everything is a noun" (atom or cell) is close to Rye OS's own Bron one-value model, already named as the cleanest existing parallel in the naming-mapping proposal. A Glow struct is proposed here as **a named mold over a noun**, in the TAME spirit of "structs carry their invariant": every struct declaration in Glow states, in a comment block immediately above it, what must hold at all times — the same discipline Rye's own root rules already require of Zig structs, extended to Glow's noun-backed values.

### 5. Comment and Line-Width Patterns, Hoon-Grade

Hoon's own community style conventions favor dense, right-aligned inline comments (`::`) describing what a line does, and a strong preference for short, single-purpose arms. TAME's Rye Supplement already sets a 100-column line limit and a 70-line function ceiling; **a Glow-specific tightening, proposed here, matches Hoon's own tighter idiom**: authored Glow keeps the 100-column ceiling but tightens the function-length ceiling to something nearer Hoon's own arm-sized idiom (a single arm rarely exceeds a screenful), and requires every rune-headed block to carry a same-line or immediately-following comment naming its purpose — stricter than Rye's current "comment when the reason is not obvious," because rune-dense code reads less obviously to an unfamiliar eye than Rye's own more verbose syntax does.

## The Shape of the Eventual Supplement

Following `TAME_GUIDANCE.md`'s own established pattern (Root, then one supplement per language, "added when that language has earned distinct idioms of its own"), a future `Glow Supplement` section would sit beside the existing Rye, Brix, and Rishi supplements, inheriting the Root rules in full and adding:

- Rune-expansion bounds checking (surface syntax stays rune-shaped; semantics stay TAME-bounded)
- Aura bound-naming requirement (every aura states its bit-width and tier)
- Explicit cold-vs-warm atom declaration (named at the site, never inferred from a bare `%` glyph alone)
- Paired jet witnesses (accelerated path and pure path proven identical, every time) — a related, separate surface
- Struct-as-named-mold-over-noun, with the same invariant-comment discipline Rye already requires
- A tightened, Hoon-grade line/function-length ceiling and denser same-line comment requirement

**None of this is written as an actual supplement section yet** — this document scopes the five surfaces and proposes a shape; seating it inside `TAME_GUIDANCE.md` itself is a follow-up step, appropriately gated the same way this project's own collaboration rule gates any change to a "heavily-cited file."

---

*May Glow keep Hoon's readability without inheriting its trust, and may every aura, every jet, and every rune say plainly what it promises to hold.*
