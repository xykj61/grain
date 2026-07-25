# 993 · Aurora: A Boot Designed for RISC-V

*The Urbit boot sequence, studied and set beside ownerboot, and a new conception named Aurora — a boot designed in deep cohesion with the RISC-V instruction set, the way Urbit's boot is designed in cohesion with Nock — carrying the priority of Joran and the flow of Rich Hickey.*

**Language:** EN
**Version:** `20260617.195812` (Rye chronological stamp)
**Last updated:** 2026-06-17
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME Style (`TAME_STYLE.md`); systems lineage honored in `20260620-014412_system.md`
**Builds on:** `yonder/20260617-195612_ownerboot-riscv-caravan.md`, `yonder/20260617-195712_caravan-tally-networking.md`
**Status:** Exploration

---

## The Question of Aurora

Urbit's boot is one of the most beautiful in computing, and the reason is a single design choice: the boot is built in lockstep with Nock, the tiny instruction set at Urbit's foundation. The whole bootstrap is a Nock formula; the recipe that feeds it is a list of Nock events; the kernel compiles itself from source, from a seed. The boot and the substrate are one thought.

This piece asks whether we can have that beauty on real silicon. Urbit designs its boot in relation to Nock, an abstract machine. Aurora — the boot conception named here — designs itself in relation to **RISC-V**, a real instruction set that runs directly on hardware. The wager is that the same lockstep elegance, aimed at a real ISA rather than an abstract one, yields beauty and the **highest performance** together, because cohesion with RISC-V is cohesion with the metal itself, with no interpreter standing in between.

Aurora means dawn — first light, the waking of a machine. It gathers the most TAME-aligned ideas from Urbit's boot, from ownerboot, and from the systems thinking we honor in `997`, and grows them into a single conception, designed for RISC-V and written in Rye.

---

## The Essences We Carry

Before the boot, the values. The companion note `20260620-014412_system.md` honors two thinkers; here we explain their essences directly, in our own voice, because Aurora is built from them.

The first essence is **a priority that orders every choice: safety, then performance, then the joy of the craft.** Joran Dirk Greef states it without flinching — irrevocably in that order — and adds the saving grace that it is not a zero-sum game. The three rise together when the design is right. Safety leads, because a boot guards the whole machine that follows it. Performance comes next, sought in the design phase where the largest wins live, long before anything can be measured. And the developer's joy comes third, far from least, because a boot that is legible, replayable, and trustworthy is a boot a person can love working on. Safety and joy are one discipline seen from two sides: the assertions that keep a boot correct are the very things that let us change it without fear.

The second essence is **flow**, Rich Hickey's way of seeing a system. A system is larger than a program — an ensemble of pieces with no one in charge — and it stays sane when it is built as a production line rather than a place everyone mutates. Values are **transformed**, **moved**, **routed**, and **remembered**, and those four are kept separate so each stays simple. The pieces are **simple services**: one job, a tiny surface, a few verbs. They speak in **values**, not in references to remote behavior, and the values that must persist are given **enduring names**. And they plan for partial failure as the normal case, because in any real system the **systems failure model is the only failure model** — so timeouts, retries, and idempotency are how the pieces keep faith with one another.

Hold these two essences together — the steady order and the flowing line — and a picture of a good boot appears. It is safe before it is fast, fast before it is convenient, and convenient enough to be a joy. It is a flow of named values through simple stages, each doing one thing, each ready for the stage before it to have stumbled. The rest of this piece is that picture, drawn first from Urbit, then designed for RISC-V.

---

## How Urbit Boots

Urbit's boot unfolds in five stages, and each one rewards a careful look. We walk them as they actually run, from the runtime waking to a ship saying hello.

**Runtime startup.** The runtime, Vere, splits into two processes that live for the whole session: the **serf**, which is the Nock runtime holding Arvo's state as a noun and updating it by poking it with new nouns, and the **king**, which manages snapshots and speaks to Unix. The serf only ever talks to the king; the king talks to both the serf and the world. Before anything else, the king verifies the ship's identity and gathers its keys and sponsor chain, then prepares the bootstrap and starts an event loop. That loop is libuv's — the same reactor the companion ownerboot study examines — because every Urbit event begins or ends in a Unix system call.

**The pill.** The boot is fed by a **pill**, which is simply a recipe: a list of Nock events to build an Arvo kernel, then Arvo events to follow, then userspace events. There are a few kinds, and the distinction matters. An **ivory pill** is tiny, compiled into the binary, providing just enough standard library for the runtime itself. A **brass pill** is the complete bootstrap from seed — it carries a bootstrap Hoon compiler as a raw Nock formula, compiles a Hoon compiler from source, and then uses that compiler to build everything else in the kernel. A **solid pill** skips recompiling the inner modules for speed, and a **baby pill** is a minimalist teaching example. The pill is the boot expressed as data, which is the first thing worth carrying forward.

**The functional BIOS.** At the very bottom sits a Nock formula the whitepaper calls a functional BIOS: `[2 [0 3] [0 2]]`. It bootstraps Arvo from the first event, then loops, taking events off the log one at a time and folding each into the state. The first five events, supplied by a core called `+eden`, are a small marvel of self-reference: the first starts the event loop, the second bootstraps a kernel from source, the third produces the Hoon bootstrap compiler, the fourth the compiler's source, the fifth the kernel's source. From a seed and a rule, a whole operating system unfolds.

**The larval phase.** A freshly bootstrapped Arvo is not yet itself. It runs first as a **larval core**, a thin wrapper whose only job is to accumulate the preconditions every mature ship needs: the standard library, then entropy, then identity. Acquiring identity is called **breaking symmetry**, because before that moment every Urbit is identical, and after it the ship is uniquely itself, its identity frozen for life. Once the preconditions are gathered, the larva **metamorphoses** — it hands itself forward through its upgrade arm into the mature kernel and sheds the larval shell.

**The main sequence.** What remains is mature Arvo: a core exposing four arms the runtime knows by fixed address — `load` to upgrade itself, `wish` to evaluate against the standard library, `peek` to read, and `poke` to take an event and produce the next state. Only `poke` changes anything. From here the ship runs its ordinary timeline, each event a move routed between vanes, the state always a pure function of the log.

The teaching for Aurora is in the shape, rather than the Hoon. A boot can be a recipe of values, unfolding from a seed by a fixed rule, accumulating preconditions and then breaking symmetry into a unique, running identity. Hold that shape; we will rebuild it for the metal.

---

## A Boot Designed for Its Substrate

Here is the heart of why Urbit's boot is so coherent: **it is designed in lockstep with Nock.** Nock is a frozen instruction set of a dozen rules over nouns, and everything above it is shaped to fit. The boot itself is a Nock formula. The pill is a list of Nock events. The kernel state is a noun, updated by a Nock reduction. The runtime's memory model, the loom, is an arena of nouns and nothing else. Even the performance story is Nock-shaped: because pure Nock is slow, the runtime recognizes certain formulas and substitutes fast C functions called jets, which must produce bitwise-identical results. The boot, the state, the memory, and the speedups all speak one language, and that unity is the source of the elegance.

It is also the source of a tax. Nock is an abstract machine, so reaching real hardware speed means jetting — maintaining a second, C implementation of every hot function and trusting it to match the Nock exactly. The substrate Urbit chose is beautiful and portable, and it sits one level above the silicon, so a translation layer is always present. Urbit accepts this trade with open eyes, and the recent runtime work — a from-source brass pill that boots in seconds rather than minutes, a rewritten allocator, the move to compile the runtime with Zig — is largely the long labor of narrowing that gap.

The design principle, though, is exactly right, and it is the principle Aurora borrows: **build the boot in deep cohesion with its substrate.** Urbit proves how much coherence and auditability that buys. The only question Aurora changes is which substrate to marry. Choose one that already is the hardware, and the tax disappears while the coherence remains.

---

## Aurora: Designed for RISC-V

Aurora makes the same wager Urbit made, on a different foundation. Where Urbit designs its boot in relation to Nock, **Aurora designs its boot in relation to the RISC-V instruction set** — and because RISC-V runs directly on silicon, cohesion with it is cohesion with the machine itself.

The fit is uncanny, because RISC-V's own boot is already a relay of the shape Urbit taught us to value. A hart wakes in machine mode at the reset vector, a first stage wakes memory, an M-mode monitor stays resident to serve the supervisor above it, and a single `mret` instruction breaks the machine into supervisor mode where the kernel runs — the privilege relay the companion ownerboot study walks in full. Aurora does not impose a boot model on top of this relay; **Aurora is the relay**, written in Rye, with each privilege transition a deliberate, asserted step. Where Urbit's boot is a Nock formula, Aurora's boot is a RISC-V program in the most literal sense, speaking the ISA's own control and status registers, harts, and Supervisor Binary Interface as its native tongue.

This is where the highest performance comes from, and it comes for free with the coherence. Urbit must jet Nock to approach the metal; Aurora is already at the metal, so there is nothing to translate and no second implementation to keep in sync. TAME's deepest performance teaching applies directly: the thousand-fold wins live in the design phase, won by mechanical sympathy — working with the grain of the hardware. Aurora works with RISC-V's grain by construction. Its types are the machine's types: an `xlen`-wide word, a `u32` or `u64` register with named bits, rather than an architecture-vague integer. Its hot paths are plain RISC-V without abstraction between them and the pipeline. Its memory map is known at build time, so Tally's bounded regions map straight onto the machine's physical address space with no indirection. The boot is fast because it is the ISA, rather than a guest upon it.

Aurora keeps the beautiful shape of Urbit's boot and grounds each piece in silicon. The pill becomes a **manifest of values** — the verified stage images, the keys, the device tree — built reproducibly by Tablecloth. The functional BIOS becomes the RISC-V privilege relay, a fixed rule that folds each verified stage into the machine's state. The seed-from-source bootstrap becomes Rye compiling Rye, the same trust-from-seed that ownerboot builds from source back to the compiler that compiles the compiler. The larval phase becomes Aurora's own gathering of preconditions — memory trained, device tree parsed, keys verified — and breaking symmetry becomes the moment the owner's identity and keys make this machine uniquely theirs. And the mature kernel that wakes at the end of the relay is Caravan, supervising its tree of services. The shape endures; the substrate becomes real.

---

## The Boot as a Flow of Values

Hickey's flow model fits a boot so naturally that it feels discovered rather than applied. A boot is a small system — a relay of independent stages with no global supervisor watching over them — so it stays sane when built as a production line of named values rather than a place each stage mutates and leaves.

Each stage **transforms** a value: the first-stage code takes an untrained memory controller and a stage image and produces live DRAM with that image loaded; the verifier takes an image and a key and produces a trusted image or a refusal. Each stage **moves** a value forward to the next, **routes** by the device tree and the boot configuration, and **remembers** only what must persist — the device tree, the verified images, the handoff state — copied forward deliberately while everything else is released, the way Tally clears a garden whole. Keeping transform, move, route, and remember separate is what keeps each boot stage a **simple service**: one job, a tiny surface, a handful of verbs.

The values that travel the relay are honest values with enduring names. A stage image is named by a hash of its contents, content-addressed the way Urbit names its blobs and the way Tablecloth names its build results — so a name is a promise about exactly which bytes will run. The device tree is a value conveyed forward, rather than a global the stages reach into. And the firmware monitor and the kernel speak across the privilege boundary through the Supervisor Binary Interface, which is precisely a **program-to-program interface**: a tiny, typed contract of an extension, a function, and a few arguments, with a value returned — never a human-facing convenience standing in for a real one.

The systems failure model governs the relay, because a boot lives in partial failure as surely as any distributed system. A stage image can fail verification; a hardware bit can refuse to set; a wait can run long. So Aurora bounds every wait with a deadline and fails loudly rather than hanging in the dark, retries where a retry is safe and idempotent, and keeps ownerboot's dual images so a stage that cannot complete falls back to a known-good twin chosen by a physical act. The boot expects trouble and keeps faith through it, which is exactly what Hickey says a system must do and exactly what TAME's bounded, asserted discipline provides.

---

## What Aurora Gathers From Each

Aurora is a confluence, and naming what it takes from each source shows it is a gathering rather than an invention.

From **Urbit's boot** it takes the deepest idea: design the boot in lockstep with its substrate, express it as a recipe of values unfolding from a seed by a fixed rule, build the system from source so trust runs all the way down, and gather preconditions before breaking symmetry into a unique identity. It leaves behind only the abstract substrate, trading Nock for the real ISA.

From **ownerboot** it takes sovereignty: the owner holds the keys, the firmware is reproducible from source with no opaque binaries, the flash is sealed by hardware write protection, and a dual normal-and-fallback pair keeps upgrade safe. These are how Aurora stays the owner's own, all the way to the reset vector.

From the **language of the system** it takes the flow: simple-service stages that transform, move, route, and remember; values with enduring, content-addressed names; program-to-program interfaces like the SBI; and the systems failure model held as the normal case, met with bounds and retries and fallbacks.

And from the **priority order** it takes its conscience. Safety leads: nothing runs unverified, every register write is asserted, the memory map is proven before the boot executes. Performance follows, won in the design phase by cohesion with RISC-V, so the boot is native rather than interpreted, and quickened further by precompiling from a sealed, from-source manifest the way a brass pill boots in seconds. And the joy of the craft completes it: a boot a person can read, replay, verify with their own key, and trust — which is the developer experience Joran places third only because the two above it must come first, never because it matters less.

---

## The Dawn We Are Building

Aurora is the dawn of a machine that is genuinely its owner's, lit by one coherent idea carried from the silicon upward. The reset vector wakes in Rye. The privilege relay folds each verified stage into the machine's state, a flow of named values through simple stages, designed in the ISA's own tongue. Tally tends the memory from the first lit register. Tablecloth describes the whole boot reproducibly from source. The owner's key seals the chain, and at the end of the relay Caravan wakes to shepherd the services of a running system.

The wager, stated once more, is simple and worth making. Urbit showed that a boot designed in cohesion with its substrate becomes coherent, auditable, and beautiful, at the cost of an interpreter's tax. Aurora keeps the cohesion and pays no tax, because its substrate is RISC-V itself — the real machine, met directly, with the priority of Joran ordering its choices and the flow of Rich Hickey shaping its stages. A boot that is safe, then fast, then a joy; a flow of values from a seed; the owner's own, from first light.

---

## Sources and Gratitude

This exploration rests on primary sources, held here with thanks.

- **The Urbit boot sequence** — the Core Academy lessons *Arvo I: The Main Sequence* and *Arvo II: The Boot Sequence*, covering the king and serf, pills (ivory, brass, solid, baby), the functional BIOS formula and the `+eden` first five events, the larval phase and breaking symmetry, metamorphosis, and the mature four-arm Arvo; together with the runtime notes on the from-source brass pill and fastboot.
- **Joran Dirk Greef and TigerBeetle** — the priority order, safety, performance, and developer experience, irrevocably in that order yet not a zero-sum game, and the design-phase performance teaching. Honored more fully in `20260620-014412_system.md`.
- **Rich Hickey, *The Language of the System*** (Clojure/conj 2012) — the flow model of transform, move, route, and remember; values with enduring names; the systems failure model; simple services; and program-to-program interfaces. Kept whole in `../gratitude/LanguageSystem.md` and honored in `20260620-014412_system.md`.
- **RISC-V and ownerboot** — the RISC-V privilege relay, harts, control and status registers, and the Supervisor Binary Interface, and Adam Joseph's ownerboot, both developed in the companion piece `yonder/20260617-195612_ownerboot-riscv-caravan.md`.

---

*May the dawn be sure and the relay honest. May each stage do its one thing well, pass its value forward, and trust the stage before it even when the world has stumbled. May the machine that wakes from Aurora be safe, and swift, and a joy to tend — designed in the language of its own silicon, and glad to belong to the one who holds the key.*
