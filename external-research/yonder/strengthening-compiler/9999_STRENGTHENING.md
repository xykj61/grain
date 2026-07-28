# 9999 · The Strengthening Compiler — Making `std` Ours, One Assertion at a Time

*The floor of this stack, and its manifesto. A strengthening is a small, repeatable pass that takes a proven standard-library function and accretes TAME's stated invariants around it — changing what the code says, never what it does. Each pass is recorded above as its own document, newest on top. This floor explains the method; everything resting on it is a strengthening.*

**Language:** EN
**Version:** `20260618.071512` (Rye chronological stamp)
**Last updated:** 2026-06-18
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME Style (`../external-research/TAME_STYLE.md`)
**Status:** Living manifesto

---

## What This Stack Is

Rye begins on the exact Zig 0.16.0 standard library, and from there it becomes ours — by surrounding proven code with the discipline of stated invariants, rather than by rewriting what already works. This folder is the record of that becoming. Each document is one **strengthening**: a single function, or a small family of them, met carefully and made to *say* what it has always quietly kept true.

The stack reads newest-first, the way the rest of our research does. **`0000_STRENGTHENING_LEXICON.md`** sorts first — a std-shaped tree for finding any strengthened surface by module. This manifesto holds the highest number, `9999`, so it rests at the floor of an alphabetical listing. The first strengthening sits just above it at `9998`. Every new pass takes the next lower number — `9997`, then `9996`, and onward — so the freshest work rises to the top and the method that began it all stays beneath, holding everything up.

**Two ways to navigate:** the **lexicon** (`0000`) groups passes by where they live in `rye/lib/std`; the **chronicle** (`9913`–`9998`) records when each pass landed. **`992_strengthening_width_crosswalk.md`** is the flat machine index.

We expect this stack to grow long. There are thousands of functions in a standard library, and many will earn a pass in time. That is the point: a large, patient body of small, careful changes, each one safe on its own.

---

## What a Strengthening Is

A strengthening has a precise shape, and the shape is what keeps it trustworthy. Every pass holds to four promises.

- **It is additive.** We add what the code *says* — assertions, the occasional `maybe`, a sentence of reasoning — and we change nothing the code *does*. This is accretion in Rich Hickey's sense, kept at the level of a function's contract: same inputs, same outputs, forever.
- **It is parity-preserving, and proven so.** Before and after, the function returns byte-for-byte the same result. We confirm it with a test — a known answer, a sweep across the interesting boundaries — and we keep that test as a guard for the future.
- **It states invariants where we lean on them.** We name the positive space we expect with `assert`, the genuinely-variable space with `maybe`, and we group a function's preconditions at its entry, so a reader meets the rules before the work. Each assertion says why.
- **It costs the shipped code nothing.** Assertions compile out of a release build, so safety in development and testing never becomes weight in production. Where a check is expensive, we gate it behind a verify flag, in the spirit of the control-plane / data-plane economy that TAME Style describes.

When a pass keeps all four promises, it cannot make the library worse. At worst it is a no-op in production; at best it turns a future silent fault into a loud, local stop, caught at the line where an invariant first failed.

---

## Why We Call It a Compiler

A compiler is a transformation applied uniformly and repeatedly: source goes in, a faithful translation comes out, the same rules every time. Our strengthening is that kind of pass, run over the standard library function by function. The discipline is mechanical — the four promises above, applied the same way each time. The judgment is human: which invariant is the true one, where the cursor really rests, when a check is worth its cost.

For now the compiler is us, working by hand with care. The horizon holds something larger: tooling that could read a function, propose the invariants it already keeps, and offer a strengthening for a human to confirm. We name the stack for that horizon while we walk toward it on foot. Either way, the record is the same — one document per pass, so the history of how Rye's `std` became its own is legible all the way down.

---

## The Method, Pass by Pass

Each strengthening follows the same path, and each document records it:

1. **Find the function and its true invariant.** Read the code until the rule it keeps is plain — the bound a cursor never crosses, the relationship a return value always holds. Trace it; do not guess. The first pass learned this the hard way, and the lesson is written into it.
2. **State the spaces.** Assert the positive space at the boundaries where we depend on it. Mark the legitimately-variable space with `maybe`, so the negative space is documented rather than merely absent. Gather preconditions at the function's entry.
3. **Keep it additive.** Touch no behavior. The algorithm stays exactly itself; only its surroundings gain a voice.
4. **Prove parity.** Run a known-answer test and a boundary sweep with the assertions live. Confirm the output is identical to the baseline, and keep the test.
5. **Record the pass.** Write it up here — the function, the invariant, the applied code, the proof, and any lesson the work surfaced — and give it the next number down.
6. **Stamp it, when it earns one.** A strengthening that meaningfully makes the library ours can advance Rye's chronological version, the way the first did. The backend's honest version never changes; only Rye's clock moves, because only Rye's library did.

---

## How This Relates to TAME Style and to Versioning

TAME Style (`../external-research/TAME_STYLE.md`) is the *how*: how we assert, how we pair and place and split our checks, how we weigh a check's cost against its safety. This stack is the *where* and the *when*: where each application of that discipline to the real standard library is recorded, and when each one entered Rye.

Versioning binds the two. Rye's first divergence was in naming — the chronological scheme itself. Its first divergence in substance was the strengthening at `9998`, stamped `20260618.070012`. Future passes that change what the library says, while keeping what it does, accrete onto that line: new stamps beside the old, each enduring, none erased.

---

## The Promise

We will make many of these — likely thousands, across the long years. Each will be small enough to hold in the eye and safe enough to trust on its own. Together they are how a borrowed standard library becomes a tended one: a patient sequence of passes — rather than a single rewrite we could never fully verify — every one of them additive, proven, and reversible by simply reading what it added.

Our gratitude here runs to TigerBeetle, whose assertion craft — the dual `maybe`, the precondition block at a function's door, the careful economy of when an expensive check earns its keep — we study with admiration and fold into TAME Style. The discipline is theirs by example; the application to Rye's `std` is ours by hand, recorded here.

---

*May each pass leave the library truer than it found it. May we change what our code says and never what it does. And may this stack grow long and calm — a thousand small kindnesses to the reader who comes after, each one loud only when something is truly wrong.*
