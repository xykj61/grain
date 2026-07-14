# Silo — Bounded Optimization on a Ring, Stated Plainly

**Language:** EN
**Version:** `20260713.232506` (Pacific)
**Style:** Radiant · secular silo
**Original (held whole):** [`../../gratitude/grain-lineage/toroidal_ml_synthesis_whitepaper.md`](../../gratitude/grain-lineage/toroidal_ml_synthesis_whitepaper.md)

---

## The One-Sentence Claim

When the thing you are tuning has values that wrap around (like angles) or that must stay inside fixed limits, model the parameter space as a torus (a product of circles) and descend it with the natural gradient, which respects the space's curvature — and this fits single-threaded, bounded-allocation machines well.

## What Is Load-Bearing (real, established math)

- **Natural gradient descent** is standard, well-founded optimization (Amari's information geometry). It corrects the ordinary gradient by the Fisher information metric, so it accounts for the shape of the parameter space and typically converges in far fewer steps (the original cites 10–50 iterations versus 100–1,000), at higher cost per step.
- **A torus is compact and periodic.** Parameters that genuinely wrap (angles, phases) or that live inside hard bounds map naturally onto it, and periodic wrap-around replaces awkward boundary handling.
- **This fits TAME's discipline exactly.** Compact parameter space means bounded allocation; deterministic natural-gradient steps mean reproducible runs; the diagonal Fisher approximation (O(n) instead of O(n³)) is the practical, single-threaded-friendly choice the original itself recommends for larger problems.

## What to Read With Care

- The **performance projections** (1.7x–2.9x over a Cerebras CS-3 baseline) are the original's own estimates, and they are entangled with the speculative torus *hardware*, not just the math. Stated plainly: the optimization method is real and usable on ordinary hardware today; the multiplier claims depend on hardware that does not yet exist and should not be quoted as established.
- The **topos/sheaf and Langlands framing** around the math is genuine category theory but is used here as inspiration and organizing metaphor, not as a step in any proof. The optimizer works without it.
- The **aether/fractal sections** (Dollard counterspace, Gardi fractal paradigm) are labeled by the original itself as "partial synthesis... requiring further investigation" — honestly, they are association, not result.

## What This Actually Gives This Fork

- A ready, TAME-shaped optimizer for any bounded tuning problem this fork meets — the original names JIT/interpreter parameter tuning specifically, which maps onto tuning the Nock interpreter or the Lantern inference stack's sampling parameters.
- A concrete worked example of "compact domain + deterministic step + diagonal approximation" as a single-threaded pattern, directly citable when the Inference Track next needs an optimizer that obeys `width-check` and the bounded-allocation rule.
- Confirmation that natural-gradient-on-a-torus is a real technique this fork could implement in Glow without any of the surrounding speculation.

## Galaxy Pitch

For: anyone weighing bounded, reproducible optimization for constrained/embedded settings.
Ask: none; informational silo.
Scope: reading only — a technique noted, not a lap opened.
