# The dec Jet — Fast, Slow, and Dispatched

**Language:** EN
**Last updated:** 2026-07-16 (landed — the first real jet, proven both ways)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — GREEN

---

Per the [runes-scoping study](../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md)'s own proposal — *"every jet in Glow ships with a paired witness — a fixture proving the accelerated path and the pure Glow path produce identical output on the same input"* — this is Glow's first real jet: **`dec`**, decrement. The classic first example, since Nock has a native increment (opcode 4) but no native decrement at all — computing it purely in Nock means counting up from zero until you find the predecessor, an honestly slow, genuinely recursive computation.

## The Three Pieces

| File | Proves |
|---|---|
| [`nock_jet_dec.rye`](nock_jet_dec.rye) | `slow_dec_formula()` — a real, hand-built, self-recursive Nock core (composed from opcodes 6, 7, 9, and 10 — if/then/else, compose, invoke an arm, and edit), taking the bare atom `n` as its subject, exactly the shape Hoon's own `\|-` trap desugars to, built here from raw opcodes rather than through any rune or parser. `fast_dec()` — the native, O(1) counterpart. `eval_with_dec_jet()` — a jet-dispatching evaluator recognizing one hint tag and substituting the fast path, falling through to the ordinary slow path for any other tag. |
| [`nock_jet_dec_witness.rye`](nock_jet_dec_witness.rye) | Seven claims — slow agrees with fast across several inputs; `dec(0)` has no honest answer, refused two ways (the fast path names it directly; the slow path would loop forever, caught cleanly by the depth bound rather than hanging); the jet-tagged formula dispatches to the fast path, proven by comparison, not assumed; an unrecognized hint falls straight through to the slow path, unchanged; and the interpreter's own honest depth limit, measured rather than guessed |

## The Jet's Own Obligation, Kept

A jet is a faster spelling of an already-proven answer, never a second, independently-trusted implementation. Every claim in the witness holds fast and slow to the same standard — the fast path never gets to skip verification just because it's fast.

## The Honest Limit, Named Rather Than Hidden

This interpreter's own `max_depth` (64, tuned for laps 1–3's shallow fixtures) comfortably computes the slow `dec` core through roughly `n=10` before the bound catches it. This is not a defect to quietly work around — it is exactly what a bounded interpreter should do with a real, deeper computation: refuse cleanly rather than trust an unbounded call stack. A production interpreter wanting deeper chains would reach for either a larger bound or genuine tail-call elimination (the slow `dec` core's own recursive step is a true tail call, needing no growing stack at all in principle) — neither built here, and named honestly as future work rather than claimed.

## What This Does Not Claim

- No general jet registry exists; this is one jet, one tag, proving the dispatch mechanism works, not a scalable multi-jet system.
- The jet tag (`0xDEC`) is a clearly-labeled placeholder marker, not a claim to replicate Urbit's own cord-packing convention for jet names.
- No tail-call elimination exists; the depth bound is real and named, not evaded.

---

*May every jet this interpreter ever grows keep the same promise this first one keeps: fast only because it is first proven slow.*
