# Correctness by Construction — the Design of Rye

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*Rye is the language the whole family is written in, so this brief designs what Rye is meant to be: what it grows toward. The way we grew it is `996`'s method. One promise orders the rest: the dangerous states should be the ones a person cannot write. From that promise the value model, the bounded gardens, the lifetimes, the accretion, and the cohesion with the open machine all follow.*

**Language:** EN
**Version:** `20260619.051212` (Rye chronological stamp)
**Last updated:** 2026-06-30
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety, performance, then the joy of the craft
**Status:** Active Design — **Reviewed and kept** (`2026-06-30`).

---

## What Rye Is For

Rye carries the family. Brix, Tablecloth, Tally, Caravan, Aurora, Pond, and Rishi are all written in it or grown from it, so the safety Rye offers is the safety they inherit. That makes Rye's first duty plain: to be a language in which correctness is *built in* rather than bolted on. We would rather spend our care once, in the shape of the language, than spend it forever in the catching of faults the shape allowed.

The promise takes a single form, said many ways through this brief: **make the dangerous states the ones a person cannot write.** A check the compiler performs is a class of fault that never reaches a running machine. A bound the type carries is a bound no one can forget. Correctness by construction is not a feature we add; it is the grain we cut the language along.

## One Value Model

A value in Rye is a simple thing: a string, an integer, a truth, a list of values, a record of named values — and the larger shapes built plainly from these. Values are composed, never tangled: each stands on its own and is set beside the others, so any one can be read, named, or replaced without unweaving the rest (`995`).

This one model is what lets the family cohere. The value a program computes is the value a shell carries (`989`), the value the network seals and names (`993`), the value a store keeps by its content. Because the shape is the same everywhere, a value crosses from one module to the next without being flattened to text and reparsed — the seam never opens. The simplicity here is not a frill; it is the load-bearing decision the whole system rests on.

## Bounded Gardens

Memory in Rye lives in **gardens** — named regions with stated edges, the bounded ground Tally tends. A garden is given its size when it is made, and it meets a request past that size with a clear edge rather than open-ended growth. This is the opposite of memory that sprawls until it fails: the limit is part of the design, visible and asserted, so a flood meets a wall we chose rather than one we discover.

Bounding memory this way costs less than it seems and gives more. It makes a program's appetite knowable before it runs, which is what lets the same program wake on a small machine as readily as a large one. And it turns a whole family of late, mysterious faults — exhaustion, fragmentation, the slow leak — into something stated up front and checked at the edge.

## Lifetimes Over Gardens

Here Rye reaches for a guarantee the foundation it grew from did not offer. We want the compiler to know, for every value, **who may touch it and for how long** — so that a value is never read after its garden is cleared, never changed by two hands at once, never released while another name still holds it. Tracked at compile time, these become whole classes of fault that simply cannot be written.

The usual way to win such guarantees leans on a free, ever-growing pool of memory, which sits uneasily beside bounded gardens. Rye looks for the sweet spot between the two: ownership and lifetime checked at compile time, yet *over the gardens* rather than over an unbounded pool. A value belongs to a garden; a borrow of it may not outlive that garden; a changing hold on it is the only hold while it lasts. The bound and the check reinforce each other — the garden says how much, the lifetime says how long and by whom — and together they close a door that neither closes alone. This is a real divergence we mean to grow into, by degrees and behind the gates, never by a rewrite.

## Assertions Are Part of the Design

Where a type cannot carry a fact, an assertion states it. An assertion in Rye is not an afterthought sprinkled to catch a bug; it is the design written down where the machine can check it — a precondition the caller must meet, an invariant the data must keep, a postcondition the result must honor. We mark the space that genuinely varies, and we assert the rest. And we always say *why*, so the next reader meets the reason, not only the rule.

This is the stance we hold across the whole project: we prepare for what must be true rather than chase what went wrong (`998`). The assertion is how that preparation becomes part of the code.

## What We Give, We Keep

Rye accretes. Versions are stamped on one honest clock, later simply larger, and a name once given is a promise: we add beside it, we do not break it. When a better shape is found, the old name keeps working while the new one grows, and a caller written today still runs tomorrow. Breakage is the one luxury we refuse, because a family this interdependent cannot afford a foundation that shifts beneath it.

So Rye changes the way a living thing changes — by adding, by strengthening, by deepening — and not the way a fashion changes, by discarding what came before.

## On the Open Grain

Rye is cut to the grain of an open machine. It speaks in explicitly sized values, so what the program means and what the hardware holds are the same thing seen twice. It treats RISC-V as solid ground rather than as one target among many — a clean, open instruction set we can read all the way down and aim at as a first-class destination. A language that means to be owned wholly by the one who runs it cannot rest on a machine no one is allowed to read; cohering with the open grain is part of what correctness, here, even means.

## How Rye Becomes Itself

Rye did not begin from nothing, and it does not become itself by rewrite. It grew from a mature foundation we then made our own, and it diverges by *strengthening*: changes that add and preserve, each proven behavior-identical by a gate, each stamped on our clock (`996`, `998`). The destination this brief describes — the value model, the gardens, the lifetimes, the grain — is reached one proven pass at a time. We always reach for the smallest version that works and let it become the larger one.

---

*May Rye make the right thing the easy thing, and the dangerous thing the unwritable one. May its values stay simple enough to carry everywhere, its gardens bounded, its promises kept. And may it cohere so cleanly with the open machine that to read the program is to understand the hardware, all the way down.*
