# The Recommended Path for the Core Names

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*A clean-room architecture brief for our core modules — TAME, Rye, Brix, Tablecloth, Tally, Caravan, and Aurora — reasoning the recommended design path for each from first principles. The one fixed external is RISC-V, the open instruction set our hardware world rests upon.*

**Language:** EN
**Version:** `20260618.184912` (Rye chronological stamp)
**Last updated:** 2026-06-29
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME priority — safety, performance, then the joy of the craft
**Status:** Active Design

*Reviewed in the yonder sweep on 2026-06-29 and kept active — foundational clean-room architecture brief; third of the trio with single-stranded and growing-a-language.*

---

## Our Own Ground

This is a clean room. Inside it we reason about our own design from first principles, and we name only what is genuinely ours: the core modules that are the subject — TAME, Rye, Brix, Tablecloth, Tally, Caravan, and Aurora — and the one fixed external we build upon, **RISC-V**, the open instruction set we treat as solid ground because the hardware supply chain and the world economy increasingly rest upon it.

Everything else here appears as a concept rather than a citation — a region of memory, a content-addressed store, a supervision tree, a lawful combinator — described plainly and weighed on its own merits, so the architecture we recommend stands on reasoning alone. We keep this space self-contained on purpose. It is where our own design grows, undivided, in our own words.

One value orders every recommendation, and we state it once so it need not be repeated: **safety first, performance second, and the joy of the craft third — never a zero-sum game, since a clean design tends to advance all three at once.** When two paths compete, the safer one leads. When safety is satisfied, the faster one leads. And among the safe and fast, we choose the one a person will most enjoy living inside, because a system loved is a system maintained.

---

## TAME — The Discipline Beneath the Rest

**The idea.** Before any module, a discipline: a set of habits that make safe, fast, legible code the natural thing to write. The choice to evaluate is whether such a discipline is worth its friction, since every rule asks something of the author up front.

**The recommendation.** Adopt it fully, because the friction is the point. We recommend a small body of non-negotiable habits as the ground all six modules stand on. Assert generously — check the positive space a value should occupy and the negative space it must avoid, since the boundary between them is where the interesting faults gather. Put a bound on everything, because in reality everything has a limit, and code that states its limits fails fast and loud rather than hanging in the dark. Allocate what you can before the work begins, so the shape of memory is known and fixed. Use types sized exactly to the machine rather than vague ones. Keep functions short enough to hold in the eye, and prefer a minimum of excellent abstractions over a sprawl of clever ones. And always say why, because the reason behind a choice is the most valuable thing the next reader inherits.

**Why it leads.** This discipline is safety made into habit, and its quiet gift is that safety and joy turn out to be one practice seen from two sides: the same assertions and limits that keep the system correct are what let a person change it later without fear. We recommend TAME as the substrate precisely because it is cheapest to adopt at the start and most expensive to retrofit. Strictness early is a gift to the future.

---

## Rye — The Language at the Bottom

**The idea.** A systems language for the lowest layer — firmware, allocator, kernel — where there is nothing underneath to catch a mistake. The options span a wide field: a managed language with a runtime and a garbage collector, a language that hides allocation behind convenience, or a spare language that exposes the machine and imposes nothing.

**The recommendation.** Choose the spare language, and shape it by the discipline above. We recommend a language with explicit control flow, evaluation that can run at compile time to fold the design's constants and prove its invariants before the program ever executes, no hidden allocation anywhere, and no runtime imposed on the programmer who does not ask for one. Its types should be the machine's types — a word the width of the register, integers sized to the byte — so the language and the hardware speak without translation.

**Why it fits RISC-V.** A language this close to the metal is the right partner for an open instruction set. We recommend that the language compile to RISC-V as a first-class target rather than an afterthought, working with the grain of the ISA: hot paths as plain functions over primitive arguments, the control and status registers and the supervisor interface addressed in the language's own terms. The wager, returned to throughout this brief, is that cohesion with a real instruction set buys native performance with no interpreter's tax — so the language should be designed to be that cohesion, rather than to abstract over it.

---

## Brix — How We Compose What to Build

**The idea.** A language for describing a whole system as data — what to build, from which bricks, composed in what arrangement — so a build is reproducible and auditable. Two failure modes bound the design space. One is a single giant description that collapses under its own weight. The other is a tower of nested overrides, each wrapping the last in ceremony until no one can read it. A third failure, subtler, is describing composition by weaving: tangling separate concerns together until no one can pull them apart. Brix refuses all three.

**The recommendation.** Build on two ideas, each chosen over its rivals. First, a **content-addressed, immutable build store** within Brix itself (the way Nix has `/nix/store`), where every output is named by a hash of all its inputs and nothing is ever mutated in place — an accreting collection of immutable things, so a name is a precise promise about exactly which bytes will result. This beats a mutable store the way a ledger beats an eraser. Second, a **single lawful composition combinator** as the native way to combine brick descriptions, in place of a large special-purpose module framework. We recommend the combinator obey the laws a careful reader expects — combining with nothing changes nothing, and a combined change equals the composition of its parts — so configurations merge by a stated difference rather than by hand-maintained duplication. Brix composes; its own store holds.

**Why it leads.** Reproducibility is a safety property: a system you can rebuild from source, byte for byte, is a system you can trust without trusting whoever shipped it a binary. We recommend building every component from source, refusing opaque artifacts, so trust runs unbroken all the way down — even to the compiler that compiles the compiler. And the language that does the describing should itself stay small and lawful, because a course of bricks is read far more often than it is laid.

## Tablecloth — How We Hold Application Data

**The idea.** A general-purpose database and object storage module for Pond applications — our answer to what MySQL, Postgres, SQLite, and Turbopuffer provide. Tablecloth is NOT Brix's build store; Brix has its own content-addressed artifact cache (grown from Mantra's `.mantra/blobs/`). Tablecloth serves applications; Brix serves the system composition.

**The recommendation.** Design Tablecloth with the TAME-aligned principles from our datastore research (`975`): write-once content-addressed identity for immutable records, hard stated bounds, single-writer ACID, MVCC reads, and a narrow query surface. Grow it when Pond applications need persistent structured data — not before. The build store is Brix's own; the application database is Tablecloth's.

---

## Tally — How We Hold Memory

**The idea.** A strategy for memory. The options are well worn: hand out and reclaim each object on its own schedule, or group objects that share a lifetime into one region released all at once. The first offers fine-grained control at the cost of tracking every object's life and death. The second trades that control for a single, legible lifetime per region.

**The recommendation.** Choose the region, and frame it gently as a garden. We recommend an allocator that hands out space by advancing a pointer through a bounded region and releases the whole region in one gesture when its season ends, rather than freeing each object alone. The evidence is strong that this is the one custom strategy that reliably outperforms a finely-tuned general allocator, through fast allocation and the cache locality of objects that live side by side. A program receives a family of named gardens, each with an explicit, bounded lifetime — one for a request, one for a connection, one for a stage of work — and anything that must outlive its garden is copied out deliberately rather than left to blur the boundary.

**Why it fits RISC-V, and the priority.** Bounded regions map cleanly onto a machine's flat physical memory, with no indirection between the allocator and the address space — so the strategy is fast for the same reason it is simple. It is safe because few, legible lifetimes banish whole classes of memory fault, and it is a joy because the gentle vocabulary of tending and clearing a bed keeps faith with how we mean to build. We recommend allocating each garden's ceiling up front, in keeping with the discipline, so the machine can prove it has room before it begins.

---

## Caravan — How We Supervise the Running System

**The idea.** A kernel — the thing that shepherds running programs through the long journey of uptime. The design space runs from a monolith that absorbs every concern into one vast trusted core, to a tree of small supervised pieces that each do one thing and compose.

**The recommendation.** Choose the tree. We recommend a supervision tree rooted in a process that never dies, ideally the first process, which watches its children and restarts any that fall. Each leaf is a small program, parented directly by its own supervisor, so its identity is always known without a fragile record on the side. Services compose by chain-loading — each step sets one piece of state and hands off to the next — so a running service reads as a clear sentence rather than a tangle. A telling piece of evidence guides this: a well-layered supervisor needs only **one** kind of dependency where a monolith accumulates a dozen, because most of those dozen exist only to paper over failures that proper layering hands back to the caller. Push the concern of a failed start up to whoever asked, and a great deal of complexity simply evaporates.

**The boundary, and RISC-V.** We recommend drawing one deliberate line: an **outer promise pinned in place forever** — the calls programs depend on, which accrete and never break — and an **interior kept small enough that every caller is known**, so the rare interior change can fix all its callers at once. Smallness is the strategy that lets the inside stay honest. On RISC-V, the kernel runs in supervisor mode with a small machine-mode monitor resident beneath it, reached through the supervisor interface — a tiny, typed, program-to-program contract rather than a sprawling surface. Allocate up front, bound everything, and let the tree, not a central manager, hold the system together.

---

## Aurora — How We Wake the Machine

**The idea.** A boot — the relay of trust that carries a cold machine to a running system. The deepest design question is what the boot is built in cohesion *with*. One path designs the boot around an abstract machine and then translates down to real hardware. The other designs the boot in lockstep with the real instruction set itself.

**The recommendation.** Design the boot in cohesion with RISC-V directly, and gain both coherence and the highest performance at once. The lesson we draw from the most elegant boots is that designing a boot in lockstep with its substrate makes it coherent, auditable, and beautiful — yet when that substrate is an abstract machine, a translation tax is always present, paid by maintaining a second implementation to reach hardware speed. We recommend marrying the boot to a substrate that already *is* the hardware. Then the cohesion remains and the tax disappears, because there is nothing to translate.

**The shape.** RISC-V's own startup is already the relay we want: a hart wakes in machine mode at the reset vector, an early stage wakes memory, a resident monitor serves the supervisor above it, and a single privileged return breaks the machine into the mode where the kernel runs. We recommend that the boot *be* this relay, written in our language, each privilege transition a deliberate, asserted step. Treat the boot as a **flow of named values**: each stage transforms a value, moves it forward, routes by the machine's own description of itself, and remembers only what must persist, copied forward while the rest is released. Name every stage image by the hash of its contents, so a name is a promise about exactly which bytes will run. Hold the systems failure model as the normal case — bound every wait, retry only what is safe to retry, and keep a known-good fallback chosen by a physical act, so a boot that stumbles falls back rather than bricks. And let the owner hold the key that seals the chain, verified from an immutable root, reproducible from source, so the machine that wakes is genuinely theirs.

---

## How the Core Names Compose

Read together, the core names are one architecture seen at multiple scales, and the recommended path is to build them as one.

The discipline (**TAME**) is the ground; it governs how every other module is written. The language (**Rye**) is the discipline made into a tool, designed to cohere with RISC-V rather than abstract over it. The composing language (**Brix**) describes whole systems as courses of lawful, composable bricks, with its own content-addressed build store. The database (**Tablecloth**) holds application data — structured, queryable, persistent. The allocator (**Tally**) holds memory in bounded gardens that map straight onto the machine. The kernel (**Caravan**) supervises a tree of small services behind a pinned outer promise. And the boot (**Aurora**) wakes the machine as a flow of verified, named values along RISC-V's own privilege relay, into the kernel that the allocator serves and the courses Brix describes and the language writes and the discipline keeps honest.

The single thread, stated once for all six: bound the lifetime, grow by accretion, release whole regions cleanly, speak in values with enduring names, and never take from a holder what they were given — all in cohesion with the one substrate we treat as fixed, the open instruction set the world is coming to rest upon.

Since this brief was first written, the family has grown around these core names. A shell for the human's hand, **Rishi**; a memory that keeps every history, **Mantra**; and a bounded enclosure for an agent at work, **Pond** — each reasoned in the later writings, and each composing onto the core by this same single thread. The core names here remain the load-bearing foundation; the fuller family grows from them, exactly as a working complex system grows from a working simple one.

---

*May we judge each idea on its merit rather than its pedigree, and keep the ones that serve. May the core names grow together — discipline, language, composer, store, memory, kernel, and dawn — safe before fast, fast before convenient, and a joy through and through. May the machine they compose belong wholly to the one who runs it, laid brick by brick in the grain of an open instruction set, and built to last.*
