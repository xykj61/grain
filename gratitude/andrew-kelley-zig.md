# Andrew Kelley -- Zig, and the courage to keep a language small

**Honors:** Andrew Kelley, who began Zig and has led it for a decade with an unusual willingness
to say *not yet* to features other languages accepted without argument. Grain compiles through
Zig, and **Rye** is Zig-shaped in the places that matter.

**Role for us:** We build on Zig as a real dependency, pinned at 0.16.0 and verified against a
checksum in our own signed history. We also carry the shape of several lessons, and those are
worth naming rather than absorbing quietly.

**What we carry**

- **No hidden control flow, and no hidden allocation.** A reader of Zig can see where the program
  branches and where it asks for memory. Our whole bounded-allocation discipline stands on that
  habit, and **Tally** is what it grew into here.
- **The allocator as a parameter.** Passing memory in rather than reaching for a global is the
  single design choice that makes a bounded system possible, and Zig made it ordinary.
- **Comptime over macros.** One mechanism doing the work of several, with the same language on
  both sides of it. Glow's lowering leans on exactly this.
- **Errors as values, with named error sets.** A caller learns which fault it met rather than
  receiving a boolean. Our named-error discipline in Rye is this idea, kept.
- **Slow is a feature when a language is young.** Zig held to a small surface for years while
  people asked for more, and the surface is coherent because of it. This tree is molten and takes
  the same permission from that example.
- **Async, arriving when it was ready.** The 0.16 work on async is the same patience at a harder
  scale, and Rye's async stdlib follows it rather than inventing beside it.

**What we leave**

- **Zig's standard library as our own.** We study it and write our own bounded pieces in Rye,
  clean-room, per [`../context/SILO_TECHNIQUE.md`](../context/SILO_TECHNIQUE.md).
- **Any claim that Rye is Zig.** Rye is its own language with its own discipline, lowering through
  a toolchain we are grateful for.

**Sources (public study doorways):** the Zig language reference and standard library
documentation, the Zig Software Foundation's public roadmap posts, and Kelley's own recorded talks
on allocators, comptime, and error handling. MIT-licensed, studied freely, with our own code
written beneath our own names.
