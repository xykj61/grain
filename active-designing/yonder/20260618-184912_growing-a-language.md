# How We Grow a Language — Rishi on Rye, and One Style for the Family

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*We have grown one language already, Rye, and the way we did it is a method we can reuse. This brief draws that method out plainly, applies it to Rishi — our shell, which stands on Rye the way Rye stands on its foundation — and settles how TAME Guidance is organized across a family of languages: one shared root, and a small supplement for each, created only when earned.*

**Language:** EN
**Version:** `20260618.184912` (Rye chronological stamp)
**Last updated:** 2026-06-29
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME priority — safety, performance, then the joy of the craft
**Status:** Active Design

*Reviewed in the yonder sweep on 2026-06-29 and kept active — canonical TAME Guidance organization brief.*

---

## Our Own Ground

This is a clean room. We name only what is ours — TAME, Rye, Brix, Tablecloth, Tally, Caravan, Mantra, Aurora, Pond, and now **Rishi**, our shell — together with **RISC-V**, the open instruction set we treat as solid ground. Everything borrowed enters as a concept, weighed on its own merit. One value orders every recommendation: **safety first, performance second, the joy of the craft third** — and a clean design tends to serve all three at once.

---

## The Method, Proven Once

Growing Rye taught us a method, and the method is worth more than any single step of it. Five moves, in order:

1. **Stand on proven ground.** We did not begin a language from nothing. We rested on a mature foundation we trust, and earned ownership from there. Starting from zero is rarely the safe path; starting from something solid and *making it ours* is.
2. **Wear a thin costume first.** The first version did almost nothing of its own — it passed work through to the foundation and proved it ran end to end. Only once it ran did we begin to diverge. A thing that runs, however humble, teaches more than a grand design that does not.
3. **Own the core by path.** We load our own standard library explicitly, by location, so we always know whose code is in force. Ownership you cannot point to is ownership you cannot trust.
4. **Diverge by strengthening, not rewriting.** Our changes are additive and behavior-preserving, each proven against the foundation by a gate, each stamped on our own clock. We change what the code *says* far more often than what it *does*, and we never break what we have given.
5. **Dogfood, and gate.** We test against growing witnesses, and a parity gate proves our divergences keep their promises. Safety lives in the process, not only in the person.

Underneath all five lies one principle we hold as near to law as design offers: **a complex system that works is invariably found to have grown from a simpler system that worked.** A complex system designed whole, from scratch, rarely comes to life and cannot be patched into life; the honest path is to begin with something simple that runs and let it become the larger thing by degrees. So we never reach first for the finished, intricate whole — we reach for the smallest version that works, and grow it.

This method is not about any one language. It is how we mean to grow every language — and every system — we make.

---

## Rishi Stands on Rye

Now we apply the method to Rishi, with one honest adaptation.

Rye rested on a foundation that already existed — a whole language and library, inherited and then owned. Rishi has no such ready-made shell worth inheriting, so it rests instead on **us**: Rishi stands on Rye the way Rye stands on its foundation. It is implemented in Rye, and — this is the deep part — **its values are Rye's values.** A list, a record, a string, an assertion in Rishi are the very same things as in Rye, because they share one value model. So when a value passes from a Rye program into a Rishi pipeline and back, nothing is flattened to text and reparsed; the seam never opens. Rishi is, in truth, Rye's value model wearing a shell's clothes.

The five moves carry over, lightly adapted:

- **Stand on proven ground** — Rishi rests on Rye (proven, owned), not on a borrowed shell. Its process-spawning, its types, its safety all come from the foundation we are already strengthening.
- **Wear a thin costume first** — the first `rishi` is a small Rye program that reads a `.rish` file and runs it, doing only what the first real script needs. Humble, yet running.
- **Own the core by path** — Rishi's builtins are our own, loaded explicitly, so we always know whose `run`, whose `map`, whose `assert` is in force.
- **Diverge by accretion** — Rishi grows one feature at a time, each proven, each stamped, nothing taken away once given.
- **Dogfood and gate** — the first program Rishi runs is the gate itself.

---

## The Parity Gate Is the Specification

Here is the gift hiding in the question. We do not have to guess how large the first Rishi should be — the parity gate tells us. To run the gate, Rishi must be able to name a small list (the witnesses), run a process and capture its result as a *structured value* (output and exit status together), compare two such results, keep a running tally, and assert a final verdict. That handful of abilities **is** the first Rishi. The gate is the specification; we build exactly enough language to express it, and no more.

And a quiet circle closes. Rye is strengthened, pass by pass; the parity gate guards each pass; the gate is written in Rishi; and Rishi is grown on Rye. So the language we grow from Rye becomes the tool that protects Rye's own becoming. The child keeps watch over the parent. There is no finer dogfooding than that, and no safer place to begin Rishi than the one program we most need it to run correctly.

---

## One Style, Many Specializations

Which brings us to the broader question: how should TAME Guidance be organized across a family of languages — Rye, Brix, Rishi, the orchestration language still to be named, and Mantra — without splintering into many styles that drift apart?

The answer follows from the same truth that lets the languages share values: **one root, and a small supplement for each.**

- **The root holds what is universal** — the priority order of safety, performance, and joy; the discipline of assertions, of marking the space that varies, of always saying why; growth by accretion and naming that endures; bounds on everything; and the shared value model itself. This is the TAME Guidance every member inherits, unchanged.
- **Each language adds only its own idioms**, in a supplement that begins, in effect, "everything in the root holds; here is what is specific to me":
  - **Rye** — explicitly sized types, compile-time assertions, the economy of where an expensive check earns its keep, functions kept short. The systems specifics.
  - **Brix** — declarative purity, the discipline of what may be deferred, composing by courses of simple bricks. *Describe, do not command.*
  - **Rishi** — typed pipelines, process results as structured values, assertions used as gates, terseness that never costs safety, honesty about effects and their order.
  - **The orchestration language** — surprise-free sequencing, no lingering interpreter, bounds on every chain.
  - **Mantra** — a data language rather than a syntax: the laws its weave must keep, the merge that always completes, the honest annotation of a conflict. Its supplement is about invariants rather than grammar.
- **The modules written in Rye** — Tally, Caravan, Aurora, Pond — do not need supplements of their own. They are Rye programs, so they live by Rye's supplement and the root above it.

Two disciplines keep this from becoming bureaucracy. A supplement is **born only when its language is mature enough to have earned distinct idioms** — we do not raise empty scaffolding ahead of the work (that would be debt, and we keep none). And a supplement **travels with its language**, kept close to the code it governs, so the rule and the ruled are never far apart. Because the family shares one value model and one ethos, the root carries the weight, and each supplement stays small — exactly as a healthy family resembles itself while each member keeps a face of their own.

---

## Caveats and the First Step

We name the hazards plainly. Rishi does not exist yet; the temptation will be to design its every comma before a line of it runs, and we refuse that — the parity gate keeps the first Rishi small, and the strengthening work it serves comes first. The syntax we imagine is a sketch to argue over, not a specification; its only firm vows are typed values, structured process results, and assertions as gates.

The first concrete step is correspondingly modest: a minimal Rishi, written in Rye, that can run exactly one program — the parity gate — and nothing more. When `parity.rish` turns green by the same reasoning its earlier forms did, Rishi will have been born the right way: small, proven, resting on proven ground, and already earning its keep.

---

*May each language we grow stand on something solid and become wholly its own. May they share one heart and keep their own faces. And may the first thing our shell ever says be the truth a gate speaks — that what we changed, we changed safely.*
