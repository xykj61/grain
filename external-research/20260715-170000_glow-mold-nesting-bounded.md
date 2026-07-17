# Glow Mold Nesting — Bounded Normalizers, Decidable Nest, Bounded Recursion

**Language:** EN
**Version:** `20260715.170000` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Research for understanding — scoping; proposes a sixth Glow-supplement surface; writes no grammar or code yet. Register: design (Two Rooms — proposal, not bound claim). Addressed to a generic Acme Corporation employee.
**Companion:** `../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md` (the five surfaces this doc extends to six)

---

## What This Answers

How Glow's design resolves against Hoon's **molds** and their **nesting** — the sixth design surface for a future Glow supplement, beside the five already scoped (runes, auras, cold/warm atoms, jet correctness, structs-and-nouns, line/comment discipline). The resolution lands at the language substrate, over Bron's value model, governed by the supplement — never inside a vane, since types sit below the vanes exactly as the non-vane-strata study describes.

## The Terms, Plainly

A **mold** in Hoon is a normalizing function that coerces a raw noun into a validated shape — it *is* a type, written as code. **Nesting** (`nest`) is Hoon's subtype relation: type A nests in type B when every value of A is a valid B, checked at cast sites, with `nest-fail` the classic rejection. A cold atom nests into its warm aura and not the reverse; a narrower record nests into a wider one.

## The Tension With TAME

The tension is specific, and the Nock/Hoon fusion scoping already flagged it: **Hoon molds can be recursive.** `list`, `tree`, and their kin reference themselves, producing *unbounded* structures — and unbounded recursion is exactly what TAME's "limit everything" discipline refuses. Hoon also asks the compiler to *trust* a mold to define a type; TAME asks every claim to be bounded and, where it matters, witnessed. The resolution keeps what is good about molds and nesting while replacing trust with a stated bound.

## The Resolution — Three Moves

### One — molds stay normalizers, yet each names its bound

In Hoon the compiler trusts a mold to define a type. In Glow, a mold stays a coercing function *and declares the maximum shape it will ever produce* — mold paired with bound, the same discipline the aura proposal already requires (every aura states its bit-width and tier). A mold that cannot state its bound is not a Glow mold. This mirrors the Rye Supplement's own root move: a value names its width; now a shape names its size.

### Two — nesting stays structural subtyping, yet stays decidable in bounded time

Glow keeps `nest` as the subtype relation; it is genuinely good design, and Bron's flat one-value model (never "tangled") is already a more decidable shape than Hoon's arbitrary nouns, so the nest check is cheaper here than in Hoon. The rule Glow adds: no nesting relation whose decision requires unbounded recursion. The check itself is bounded, always — a property a witness can assert.

### Three — recursive molds carry an explicit bound

This is the crux, and where Glow diverges on purpose. Hoon's unbounded `list` is a convenience Glow declines; Glow's form is a **bounded** `list:N` (or a tree mold carrying a stated max depth), the structural analog of "`u32`, never bare `usize`." A recursive mold names its depth or size bound the way a Glow integer names its width. The expressiveness of recursive shapes stays; only the unbounded-ness TAME was never going to permit is given up.

## The One-Line Resolution

Glow keeps Hoon's mold **readability** and nest **relation**, and replaces Hoon's mold **trust** with a stated, witnessed **bound** at every level — atom (aura width), value (Bron's flat model), and structure (bounded recursion). Molds and nesting are resolved at the language substrate over Bron, seated in the Glow supplement beside the aura and cold/warm-atom rules.

## The Sixth Supplement Surface

Following `../context/TAME_GUIDANCE.md`'s established pattern, the eventual Glow Supplement gains one more line beside the five already scoped:

- **Molds and nesting** — a mold names its output bound; `nest` stays structural yet decidable in bounded time; recursive molds carry an explicit depth/size bound (`list:N`, never unbounded `list`), with a paired witness where a bound is load-bearing.

**None of this is written as an actual supplement section yet** — this doc scopes the sixth surface and proposes its shape; seating it inside `TAME_GUIDANCE.md` stays gated the same way the collaboration rule gates any change to a heavily-cited file.

## What This Doc Does Not Claim

- No grammar, no compiler, no mold implementation is written; this is scoping, matching the research-before-code pattern the earlier Glow-supplement doc set.
- It does not seat the surface into the canonical guidance; that is a gated follow-up.
- It does not claim bounded recursion covers every Hoon mold pattern; patterns that genuinely need unbounded depth are named as out of scope for Glow, a deliberate narrowing rather than an oversight.

## Related

- `../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md` — the five surfaces this extends.
- `../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md` — where the recursion-vs-bounds tension was first named.
- `../external-research/20260715-165000_glow-non-vane-strata-and-pond.md` — why types live at the substrate, below the vanes.

---

Glow keeps the mold's clarity and the nest's relation, and asks only that every shape say how large it may grow.
