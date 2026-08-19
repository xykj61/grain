# Clean-Room Brief -- LionsOS Modularity and Separation-of-Concerns Thesis, as it Informs Caravan

**Stamp:** `20260819.094721` -- **Status:** Living (clean-room brief) -- **Voice:** Kyri
**Register:** Radiant -- **Commissioned by:** [`../external-research/20260819-094721_microkernel-target-study-weight-recenter.md`](../external-research/20260819-094721_microkernel-target-study-weight-recenter.md)
**Studies:** LionsOS (Trustworthy Systems' modular, verification-minded OS built on Microkit) and sDDF (the seL4 Device Driver Framework).
**License boundary:** LionsOS and sDDF ship under **BSD-style** permissive terms -- the friendliest of the microkernel-ecosystem sources studied here. Even so, this brief keeps the **clean-room boundary**: **concepts, architecture papers, and design docs only, no source in our tree.** Rule: [`gratitude-licenses`](../.claude/rules/gratitude-licenses.md).

---

## The concepts worth internalizing

LionsOS is the strongest living argument that a system can be **safe first and fast anyway**, built entirely from small, static, single-purpose components on the verified kernel through Microkit. Its thesis is that radical simplicity and strict separation of concerns are not a tax on performance -- done well, they are a path to it.

- **Radical simplicity as a design law.** Each component does one thing. The system is assembled from many small pieces rather than a few large ones, so no single piece is large enough to hide complexity or defeat reasoning.
- **Strict separation of concerns.** Drivers, protocol logic, multiplexing, and policy live in *separate* components connected by explicit channels. A network driver moves bytes; a separate component multiplexes; a separate component runs the protocol. No component both touches hardware and makes policy.
- **sDDF -- thin, encapsulated, fast drivers.** The seL4 Device Driver Framework standardizes a driver as a small component behind a clean queue-based interface, isolated from the rest of the system. The measured claim the ecosystem makes is that this isolation costs little and can even help, because the fast paths are small, cache-friendly, and free of incidental coupling.
- **Static composition, measured performance.** The whole system is wired at build time (via Microkit), and its performance is *measured*, not asserted -- throughput numbers for static modular systems are the evidence, not a hope. This is the exact ordering TAME keeps: safety structural, performance measured.
- **Verification-mindedness as a shaping force.** Components are kept small and interfaces narrow partly so that further verification stays tractable. The shape of the system is chosen to keep proof reachable, even where proof has not yet been done.

## What Caravan can re-express in Rye under TAME

- **One component, one concern -- as a Caravan ring discipline.** LionsOS validates keeping each supervised unit single-purpose. Caravan's rings can hold the rule that a component either touches a resource or makes policy about it, never both -- expressed as small Rye modules with narrow, asserted interfaces.
- **Separation as explicit, bounded interfaces.** The driver / multiplexer / protocol split argues for narrow, named seams between Caravan components -- bounded queues and explicit message records rather than shared mutable sprawl. This is the same "small IPC" lesson seL4 teaches, seen at the OS-composition scale.
- **A queue-based driver shape (from sDDF) for Caravan's device seam.** When Caravan reaches devices, model the seam as a thin component behind a bounded, asserted queue -- fixed capacity, named error on overflow, explicit-width indices -- rather than a fat driver that also carries policy. This keeps the trusted surface small and the fast path measurable.
- **Measured performance as the close, echoing the parity witness.** LionsOS's "prove it fast with numbers" is the tree's own habit: the Microkernel Target's close is the parity-witness happy-zone suite GREEN, and any performance claim about a Caravan ring on the new target rides a `loom` measurement, never a memory. Safety structural, performance measured -- LionsOS is the living example.
- **Shape for future verifiability.** Keep Caravan components small and interfaces narrow not only for clarity but so that a future witness -- or someday a proof -- can reach them. The modularity thesis says the shape that is easy to reason about is also the shape that stays fast.

## What stays out

- **No LionsOS or sDDF source, no its drivers or queue code in our tree.** BSD-permissive though it is, the clean-room boundary holds: concepts and architecture only; Caravan stays our own Rye.
- **No claim that Caravan is LionsOS-compatible or a LionsOS port.** Grain sits *beside* the high-assurance ecosystem honestly; it is not a re-clone of any framework.
- **No importing performance numbers as if they were ours.** LionsOS's measured throughput is *their* evidence for the static-modular thesis; Caravan's numbers must be measured on Caravan, on our target, before we claim them.
- **No large-component shortcut "for speed."** The thesis is that small and separated *is* the fast path; Equinox 1 keeps the components small rather than fusing concerns for a premature optimization.

## Open questions this brief leaves to a later round

- How much of the sDDF queue discipline Caravan adopts now versus when its device seam actually opens.
- Where LionsOS's static-composition shape and Microkit's system description meet Caravan's Brix/Bron-native declaration (see the Microkit brief).
- Which measured LionsOS performance claims are worth reproducing as parity-witness targets once the RISC-V-under-QEMU bring-up (Equinox 4) can run them.
