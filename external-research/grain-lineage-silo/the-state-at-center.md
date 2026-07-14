# Silo — The State at the Center (from "The Grain Point")

**Language:** EN
**Version:** `20260713.232506` (Pacific)
**Style:** Radiant · secular silo
**Original (held whole):** [`../../gratitude/grain-lineage/the-grain-point-whitepaper.md`](../../gratitude/grain-lineage/the-grain-point-whitepaper.md)

---

## The One-Sentence Claim

Build the operating system as a single pure function — `new_state = transition(old_state, event)` — over memory that is allocated once at startup and never grown or freed, so the whole system is one value that changes only at clean epoch boundaries.

## What Is Load-Bearing (and directly relevant to this fork)

This is the most immediately useful of the six documents, because it restates ideas this fork already builds on, and connects four traditions this fork already keeps:

- **The kernel as one transition function.** This is Arvo's own model (state as a pure fold over an event log; every event an ACID transaction). In this fork's terms, that is exactly the spine the ROADMAP already names: "state as a pure fold over an append-only log of immutable signed facts." The Glow kernel variants (Riyo / Reya / Trey / Triz) are, in this framing, four implementations of one transition function over one log.
- **State at the center, effects at the edge.** One place holds the current state (the original calls it "the grain point"); an event arrives, a single-threaded sweep computes the new state and the effects, the state is written back, the effects go out. In this fork's vocabulary, that center is Mantra's fold head, and the supervised loop around it is Caravan (the Gall-parallel).
- **Allocate once; never grow or free.** This is TigerBeetle's static-allocation discipline — already the heart of TAME Guidance. The original's insight worth keeping: if memory is never dynamically allocated, there is no allocator state to persist or recover, so the only state that matters is the data itself. That is a clean argument, independent of any hardware.
- **The allocator as nested arenas.** Urbit's "Loom" (inner/outer roads, discard-on-failure) is the same shape as Tally's named gardens — the parallel this fork's own Vere study already drew. The original's radial-shell version is a geometric retelling of the same idea.
- **Flow, not objects (Rich Hickey).** Keep transform / move / route / remember separate rather than bundling them into stateful objects. This is sound systems advice this fork already honors and `gratitude/LanguageSystem.md` already keeps.

## What to Set Aside

- The **torus geometry** as the *physical* substrate is the speculative hardware from the silicon-torus silo; the transition-function and static-allocation ideas above stand fully without it.
- The **counterspace / Brouwer / aether** section is a mathematical-metaphor flourish (a torus has a hole, so certain fixed-point theorems do not apply). It is a real theorem stated colorfully; it is not load-bearing for the kernel design and should be left in the original for a general reader.
- The **Gospel-of-Thomas epigraphs** and devotional close are the author's register; the silo keeps the engineering and leaves the scripture where it was written.

## What This Actually Gives This Fork

- The clearest existing statement of why the four Glow kernel variants can share one design: they are four transition functions over one log, differing in implementation for diverse redundancy (per the accepted Riyo/Reya pairing), agreeing on external behavior.
- A direct, citable bridge from Arvo's proven kernel shape to this fork's Mantra + Caravan + Tally seam — useful when the Vere/TAME fusion work resumes.
- A reminder that static allocation removes an entire class of persisted state (the allocator's own), which strengthens the case for TAME's bounded-allocation rule in the Glow supplement.

## Galaxy Pitch

For: galaxy holders interested in pure-functional, event-sourced kernel design in the Arvo lineage.
Ask: none; informational silo — though this is the document most likely to inform a future real Glow-kernel proposal.
Scope: reading now; a kernel proposal citing it would be its own future, properly-sized PR.
