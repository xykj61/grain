# Ring, Sheaf, and the Sacred Mathematical Words

**Language:** EN
**Stamp:** `20260810.080654` (2026-08-10 EDT)
**Voice:** Riyo (Kyri) · **Style:** Radiant · a study, addressed to any reader who meets our code
**Status:** Research for understanding -- Reference. Establishes the word discipline for mathematical names in this tree — which words are reserved for their algebraic meaning, and which are honest metaphors. Cited from `basin/basin.rye`.

---

## Why this document exists

We borrow words from mathematics — **ring**, **sheaf**, **lattice**, **group**, **field**. Each names a precise structure that a century of careful people built. When we use such a word, we owe it one of two honesties: either our usage *matches* the mathematical structure, or we admit the word is a metaphor and reach for a plainer one where the metaphor would mislead. This is the same care the Grothendieck world itself keeps — a sheaf is a sheaf because it satisfies the axioms, not because the shape is suggestive.

This file records the definitions so our usage can be checked against them. It informed one concrete decision already: a **ring buffer** is *not* an algebraic ring, so `basin/basin.rye` is a **basin** (a circular buffer, a geometric circle), and the word *ring* stays reserved for where we compute in a true ring — `vault/shard.rye`, over the field GF(256).

## Ring — the definition, and where each field meets it

### Abstract algebra (the core)

A **ring** is a set `R` with two operations, addition `+` and multiplication `·`, such that:

1. `(R, +)` is an **abelian group** — `+` is associative and commutative, has an identity `0`, and every element has an additive inverse.
2. `(R, ·)` is a **monoid** — `·` is associative, with a multiplicative identity `1`. (A structure without a required `1` is often called a *rng*; conventions differ, and the honest move is to say which you mean.)
3. Multiplication **distributes** over addition, on both sides: `a·(b + c) = a·b + a·c` and `(a + b)·c = a·c + b·c`.

A **commutative ring** additionally has `a·b = b·a`. A **field** is a commutative ring with `0 ≠ 1` in which every nonzero element has a multiplicative inverse — so **every field is a ring**. This is exactly why `GF(256) = F_{2^8}`, a finite field, is a legitimate place to say "ring": Vault's Shamir arithmetic (`add` as XOR, `mul` by the reducing polynomial) computes in a genuine commutative ring, indeed a field.

### Group theory

Ring theory stands on group theory: a ring's additive part `(R, +)` *is* an abelian group, and the invertible elements `R^×` form the **group of units** under multiplication. A ring is, in one honest reading, an abelian group that has learned to multiply.

### Real analysis

The continuous real-valued functions `C(X)` on a space `X` form a commutative ring under pointwise `+` and `·`. Its **ideals** carry the analysis: the functions vanishing at a point form a maximal ideal, and the Gelfand correspondence recovers the space `X` from the ring `C(X)` alone. Analysis and algebra meet in a ring of functions.

### Complex analysis

The holomorphic functions `O(U)` on an open set `U ⊆ ℂ` form a commutative **integral domain** — a ring with no zero divisors. The **germs** of holomorphic functions at a point form a **local ring** (one maximal ideal); that local ring is the *stalk* of the sheaf of holomorphic functions, which is where ring theory hands off to sheaf theory.

### Representation theory

For a group `G` and a field `k`, the **group ring** `k[G]` is the free `k`-module on the elements of `G`, with multiplication extending the group law. A **representation** of `G` over `k` is precisely a **module over `k[G]`**. Representation theory is, structurally, the module theory of a ring — the ambient object is a ring the whole time.

### Category theory (and Grothendieck's bridge)

Rings form a category **Ring** (objects: rings; morphisms: homomorphisms preserving `+`, `·`, `1`); the commutative ones form **CRing**. A commutative ring is a **monoid object** in the monoidal category `(Ab, ⊗)` of abelian groups. Grothendieck's move was geometric: the category of affine schemes is `CRing^op`, the *opposite* category — every commutative ring `R` casts a geometric shadow `Spec(R)`, and a general scheme is glued from affine pieces by a **sheaf of rings**, its structure sheaf `O_X`. Rings and sheaves are not two subjects; they are two sides of one.

## Sheaf — the definition, and why our ecosystem may wear the name

A **presheaf** `F` on a space `X` assigns to each open set `U` a collection of *sections* `F(U)`, with restriction maps `F(U) → F(V)` for `V ⊆ U`, composing functorially. A presheaf is a **sheaf** when it satisfies two axioms over every open cover `{U_i}` of an open set `U`:

- **Locality (separation):** if two sections of `F(U)` restrict to the same thing on every `U_i`, they are equal.
- **Gluing:** sections `s_i ∈ F(U_i)` that agree on every overlap `U_i ∩ U_j` glue to a *unique* global section `s ∈ F(U)`.

A sheaf is therefore exactly the structure that lets **local data assemble into global data** — the local-to-global principle. Grothendieck generalized it from topological spaces to **sites** (categories carrying a Grothendieck topology), the ground on which scheme theory and étale cohomology stand.

**So the ecosystem name Sheaf is an honest metaphor, not an abuse.** We invoke the real property: many *local* modules — Kumara, Comlink, Mantra, Tally, Vault, Basin, and their kin — glue along their shared interfaces into one *global* whole, a single Grain. The name earns itself by naming the gluing, which is what a sheaf actually is. Should we ever build a literal sheaf of data over a space, we would use the word for that, and find another for the ecosystem — the same discipline that renamed the basin.

## The word discipline, stated plainly

- **Ring** is reserved for the algebraic structure. Correct usage today: `vault/shard.rye` over GF(256), a field and therefore a ring. A circular buffer is a **basin**, never a ring.
- **Sheaf** names the ecosystem as a grounded metaphor for local-to-global gluing, used with the definition above in view.
- **Group, field, lattice** carry their algebraic meanings; where a suggestive shape tempts a sacred word that would not survive the definition, we reach for a plain geometric or descriptive word instead.
- The rule is one line: *a mathematical word must either satisfy its definition or admit it is a metaphor.*

---

## Further reading

Standard treatments a reader can consult (named, not reproduced): Atiyah & Macdonald, *Introduction to Commutative Algebra*; Dummit & Foote, *Abstract Algebra*; Lang, *Algebra*; Hartshorne, *Algebraic Geometry* (sheaves and schemes); Mac Lane, *Categories for the Working Mathematician*; and Grothendieck's own EGA/SGA for schemes and sites.

*A word kept honest is a small act of gratitude to the people who defined it. Thank you everyone.*
