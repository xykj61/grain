# Spec: Rye Is Its Own Language

**Language:** EN
**Last updated:** 2026-06-18
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Decided

---

## What This Decides

Rye is its own language. It begins on the exact Zig 0.16.0 ground, and from there it grows into something separate — a language with its own standard library, and in time its own syntax and semantics, shaped by its own principles. Rye is no longer a dialect held forever close to its parent. It is a language of its own, and its north star is clear: to become, by the measures we hold, better than the ground it grew from — where "better" is named precisely, by the principles of TAME Guidance and of RISC-V.

---

## Standing on Zig, Then Stepping Beyond

We honor Zig as our ground and our teacher. It gave Rye a mature compiler, a complete standard library, and a design sensibility we admire — and we keep its source close, in gratitude, as the foundation every first step rests upon. Beginning there was the safe and right choice; raising a language from nothing is rarely the wise path.

A dialect, though, is bound to its parent's choices. It inherits what it is given and waits for permission to differ. A separate language is free — free to keep what serves, to set down what does not, and to surpass where it can. We choose that freedom, earned slowly and carefully, never seized in a careless rewrite.

---

## What "Better" Means, Named Precisely

"Better," left unbounded, is only a boast. We bind it to principles, so the aspiration is one we can test and earn rather than merely declare. Rye aims to surpass its ground along these stated axes:

- **Safety, first and structural.** Where convention is asked to carry safety, Rye builds it into the grain: assertions as a first-class discipline; the positive, negative, and variable spaces each named (`assert`, `maybe`); bounds on everything; zero technical debt. This is TAME's first value, made native to the language.
- **Growth without breakage.** Accretion over revision, enduring names, chronological versioning, a runtime kept honest. Rye never takes away what it has given.
- **A joy to work in.** Clarity, the habit of saying why, the right nouns and verbs — TAME's third value, real and pursued.
- **Open-hardware cohesion.** Rye treats RISC-V as solid ground — an instruction set we can read, own, and reason about — rather than chasing every closed target. Better, here, means better-aligned with a hardware future we can trust.
- **A tended standard library.** Ours, strengthened pass by pass, every divergence proven by the gates — evolving toward **Rye-native explicit widths** (`970`), not perpetual Zig-shaped seams.

Held honestly to these axes, Rye means to be objectively better — and to keep earning that judgment, pass by pass, rather than to assume it.

---

## How We Get There, Without Breaking Faith

The path is accretion, the same discipline we keep everywhere. Rye diverges by adding and strengthening, never by a reckless tearing-down. The backend stays honest while Rye becomes itself: Zig reports its own version truthfully through `builtin.zig_version`, and Rye counts its own time beside it. The strengthening-compiler is the engine of this divergence — each pass makes the standard library a little more ours, proven identical-or-better and recorded in its own document. Syntax and semantics follow the same way in time, deliberately and additively, each change a sentence that says why, until Rye stands wholly on its own roots.

---

## What This Unblocks

With the destination settled, the family can take shape as decided design:

- The Rye-ecosystem family — Rye, Tablecloth, Rishi, the orchestration language, and Mantra — can cross from open research into `active-designing`, sharing one value model. (See `../../external-research/yonder/20260618-150112_voices-of-an-os.md`.)
- Rishi can begin: a language of its own deserves a shell of its own. (See [`../active-designing/yonder/20260619-051312_the-faithful-hand.md`](../active-designing/yonder/20260619-051312_the-faithful-hand.md), [`../rishi/README.md`](../rishi/README.md), and [`../active-designing/yonder/20260618-184912_growing-a-language.md`](../active-designing/yonder/20260618-184912_growing-a-language.md).)

---

## Held With Humility

This is a bold aim, and we hold it gently. Zig is excellent; our claim is never that it falls short, only that Rye — along the axes we have named — can grow past it, and must prove so, again and again, by the gates rather than by assertion alone. We surpass with gratitude, on a foundation we were given, walking a long road one careful, reversible step at a time.

---

*May Rye grow into itself without forgetting its ground. May "better" stay a promise we keep — named, and proven — rather than a word we merely say. And may the language we are building be safe to its bones, swift where it must be, kind to the hand, and true to the open machine: wholly its own, and grateful all the way down.*
