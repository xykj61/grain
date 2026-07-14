# Toward a Glow Supplement — Runes, Auras, Jet State, and Hoon-Grade Linting

**Language:** EN
**Version:** `20260713.225841`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Scoping — proposes a future TAME_GUIDANCE.md supplement, writes no grammar or code yet

---

## What This Answers

Kaeden asked for Glow's fusion design to have a real answer for Hoon's rune syntax, its aura system, "cold and warm atoms," structs and nouns, and comment/line-width conventions that match Hoon's own linting patterns — with a **new TAME Guidance supplement for Glow, stricter than the existing Rye supplement**, governing all of this. This document scopes that supplement's shape; it does not write the supplement itself yet, matching this session's own established research-before-code pattern.

## A Correction, Made Gently

Hoon does not have "cold and warm atoms" as such — the precise Urbit term, confirmed against `docs.urbit.org`'s own jetting documentation, is **cold, warm, and hot *state*** in the jet dashboard: `cold` state is the persistent registry of core hierarchies found during execution (survives restart, made of pure nouns); `hot` state is the ephemeral, runtime-specific map from core labels to actual jet drivers (cleared on restart); `warm` state is the cache joining the two, regenerated whenever either changes. This is not a detail to smooth over — it is directly the same machinery this fork's own Vere/TAME fusion study already read in `vere/old/pkg/noun/jets.c` and `hashtable.c`, and it is exactly the seam where a Glow-native jet system would need its own TAME-disciplined correctness story.

## Five Real Design Surfaces, Named Plainly

### 1. Runes

Hoon's rune system (`|=`, `^-`, `=/`, and roughly 200 more) is "unusually large but unusually regular" by its own documentation's own words — each rune's first glyph names a category (`|` for cores, `^` for casts, `=` for bindings), and the second glyph specializes within it. A Glow rune system inherits this *readability* discipline directly: **Glow keeps rune-shaped syntax, but every rune's expansion is checked against TAME's bounds at the point of expansion**, not left to trust the way Hoon's own compiler does. This is the same resolution the earlier Nock/Hoon fusion scoping doc already proposed as its lead option (runes as surface syntax, bounded semantics underneath) — this document confirms that direction specifically for the rune question and extends it to the four remaining surfaces below.

### 2. Auras

Hoon's auras (`@ud` unsigned decimal, `@p` ship name, `@t` text/cord, `@da` absolute date, and dozens more) are bit-tag refinements of the one real Hoon type — the atom. Auras are Hoon's answer to "a number is not just a number; it means something," without needing a separate type for each meaning. **Glow's own answer should be stricter, not looser**: Rye's own Rye Supplement already names fixed-width discipline (`u32`, `u64`, never bare `usize` in authored code) as a root safety property. A Glow aura system should require every aura to *name its own bound* the way Rye already requires named constants to name their bound — an aura is not just "this atom means a ship name," it is "this atom means a ship name, and a ship name's `@p` encoding has a stated, checked bit-width for its tier (galaxy 8 bits, star 16, planet 32, moon 64, comet 128)."

### 3. Cold/Warm/Hot Jet State

A Glow-native jet system needs its own answer to the exact correctness question this fork's Vere study already named: a jet is a proof obligation, not only a performance trick. **Proposal for the supplement:** every jet in Glow ships with a paired witness — a fixture proving the jetted (fast) path and the un-jetted (pure Glow) path produce identical output on the same input — mirroring TAME's own "pair your assertions" rule (assert on both paths) applied to acceleration correctness specifically, rather than Vere's own more informal jet-registration convention.

### 4. Structs and Nouns

Hoon's "everything is a noun" (atom or cell) is close to Rye OS's own Bron one-value model, already named as the cleanest existing parallel in the naming-mapping proposal. A Glow struct is proposed here as **a named mold over a noun**, in the TAME spirit of "structs carry their invariant": every struct declaration in Glow states, in a comment block immediately above it, what must hold at all times — the same discipline Rye's own root rules already require of Zig structs, extended to Glow's noun-backed values.

### 5. Comment and Line-Width Patterns, Hoon-Grade

Hoon's own community style conventions favor dense, right-aligned inline comments (`::`) describing what a line does, and a strong preference for short, single-purpose arms. TAME's Rye Supplement already sets a 100-column line limit and a 70-line function ceiling; **a Glow-specific tightening, proposed here, matches Hoon's own tighter idiom**: authored Glow keeps the 100-column ceiling but tightens the function-length ceiling to something nearer Hoon's own arm-sized idiom (a single arm rarely exceeds a screenful), and requires every rune-headed block to carry a same-line or immediately-following comment naming its purpose — stricter than Rye's current "comment when the reason is not obvious," because rune-dense code reads less obviously to an unfamiliar eye than Rye's own more verbose syntax does.

## The Shape of the Eventual Supplement

Following `TAME_GUIDANCE.md`'s own established pattern (Root, then one supplement per language, "added when that language has earned distinct idioms of its own"), a future `Glow Supplement` section would sit beside the existing Rye, Brix, and Rishi supplements, inheriting the Root rules in full and adding:

- Rune-expansion bounds checking (surface syntax stays rune-shaped; semantics stay TAME-bounded)
- Aura bound-naming requirement (every aura states its bit-width and tier)
- Paired jet witnesses (fast path and pure path proven identical, every time)
- Struct-as-named-mold-over-noun, with the same invariant-comment discipline Rye already requires
- A tightened, Hoon-grade line/function-length ceiling and denser same-line comment requirement

**None of this is written as an actual supplement section yet** — this document scopes the five surfaces and proposes a shape; seating it inside `TAME_GUIDANCE.md` itself is a follow-up step, appropriately gated the same way this project's own collaboration rule gates any change to a "heavily-cited file."

---

*May Glow keep Hoon's readability without inheriting its trust, and may every aura, every jet, and every rune say plainly what it promises to hold.*
