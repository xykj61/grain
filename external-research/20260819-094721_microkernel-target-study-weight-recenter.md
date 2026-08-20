# Microkernel Target -- Study-Weight Recenter

**Stamp:** `20260819.094721` -- **Status:** Mixed -- Living (research capture) -- **Voice:** Kyri
**Register:** Radiant -- **Clean room:** studies the world with attribution; names only our own modules where we build. No copyleft source enters our tree.
**Double-seats beside:**
- [`../active-designing/20260816-205859_double-seat-expansion-eight-seasons.md`](../active-designing/20260816-205859_double-seat-expansion-eight-seasons.md) -- the eight-season itinerary and its Lindy-priority Microkernel Target arc.
- [`20260817-185851_microkernel-target-and-the-os-parity-question.md`](20260817-185851_microkernel-target-and-the-os-parity-question.md) -- the original direction and the three blind spots.
**Clean-room briefs this note commissions:**
- [`../active-designing/20260819-094721_clean-room-sel4-capability-ipc-resource-model.md`](../active-designing/20260819-094721_clean-room-sel4-capability-ipc-resource-model.md)
- [`../active-designing/20260819-094721_clean-room-microkit-protection-domains-channels.md`](../active-designing/20260819-094721_clean-room-microkit-protection-domains-channels.md)
- [`../active-designing/20260819-094721_clean-room-lionsos-modularity-thesis.md`](../active-designing/20260819-094721_clean-room-lionsos-modularity-thesis.md)
**Rule kin:** [`gratitude-licenses`](../.claude/rules/gratitude-licenses.md) -- [`TAME Core`](../context/TAME_CORE.md) -- [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md)

---

## What this note changes, and what it leaves untouched

The Microkernel Target stays the Lindy-priority arc double-seated ahead of Seasons A-H. Its four equinoxes, its Caravan-before-Tally ordering, its RISC-V-under-QEMU-first pragmatism, its clean-room boundary, and its parity-witness close all stand exactly as seated on `20260817`. The fixed 1,024-round road does not move. Every Caravan ring already accreted -- seed, bounded, twin, chain, service, capabilities, exit vocabulary, and the rings past them -- stays the accretion spine; nothing is rewritten to make room.

What shifts is the **weight of study and inspiration** brought to the design table while Caravan (and later Tally) grow a microkernel home. The prior capture leaned on **Genode** (AGPLv3) and experimental **Sculpt-on-seL4** as the primary living models of supervision and component composition. Those remain valuable for *dynamic* ideas, yet they are not the center of gravity of the high-assurance seL4 ecosystem that Trustworthy Systems builds and that governments deploy. That ecosystem favors static architecture known at build time, extreme simplicity and modularity, closeness to the formally verified kernel, and shapes that keep further verification tractable. **Microkit** and **LionsOS** (with **sDDF**) embody that posture, and it aligns more tightly with TAME's own ranking -- Safety over Performance over Joy -- than a large dynamic Genode userland does.

So this note reorders the reading weight. The road holds; the intellectual center of gravity moves toward the static, verification-minded, simplicity-first part of the ecosystem.

## What does not change (the gates, restated so none is lost)

- The Microkernel Target stays Lindy-priority, double-seated ahead of Seasons A-H.
- Equinox order is unchanged: (1) Caravan on the microkernel, crux, Caravan before Tally; (2) Tally on s6 / skalibs plus musl/Alpine utilities, license-checked; (3) the Rye compiler's Tally/Caravan target, research question first; (4) Aurora on RISC-V under QEMU with the parity-witness suite GREEN as the close.
- Clean-room only. seL4 (GPLv2), Genode (AGPLv3), and every copyleft source are studied for concepts and docs; no source enters the tree. Microkit and LionsOS docs and papers are read the same clean-room way, source left out regardless of their friendlier licenses.
- s6 / skalibs (ISC) stay the permissive practical supervision and bounded-allocation reference.
- RISC-V under QEMU first; no firmware-blob purchase decision yet.
- The target is not "done" until the existing GREEN parity-witness happy-zone suite (and kin) runs GREEN on the new target.
- The three original blind spots stay named and visible: license (copyleft is study only), compiler target (lives past the deferred Rye fork or leans on Zig freestanding), hardware freedom versus speed (RISC-V/QEMU first).

## The new reading order (weight, not exclusivity)

Read and write design notes in this priority. Secondary sources remain welcome; they simply no longer lead.

1. **seL4 itself (primary).** The kernel's own posture first: the capability model, IPC, resource management, the MCS (mixed-criticality) scheduling extension, minimality, policy freedom, and the "don't pay for what you don't use" discipline. Public docs, the whitepaper, verified configurations, and platform tables. Internalize the kernel before any framework lens.
2. **Microkit (primary framework).** The official, subtractive layer over seL4 for **static** architectures: protection domains, channels, memory regions, the event-driven model, and the system-description format. A deliberately small abstraction set that rules out many complicated patterns. Study the model, the manual, and the design rationale. Map protection-domain and channel ideas onto Caravan's supervision and capability rings in Rye under TAME.
3. **LionsOS plus sDDF (primary OS shape and driver discipline).** Trustworthy Systems' modular, verification-minded OS built on Microkit: radical simplicity, strict separation of concerns, the performance case for static modular systems, and BSD licensing. sDDF (the seL4 Device Driver Framework) for thin, encapsulated, high-performance drivers. The strongest living example of "safe, then fast" modular userland on the verified kernel.
4. **s6 / skalibs (practical supervision reference -- already planned).** Permissive process supervision and bounded allocation; continues to inform Caravan's userland rings and Tally's allocation discipline. License already recorded, boundary freer than the copyleft projects.
5. **Genode (secondary, selective).** Capability-IPC usage, resource-trading concepts, supervision-tree thinking. Its dynamic composition and large component library are inspiration for **later** Caravan rings that deliberately add controlled dynamism -- not the default architecture for Equinox 1. AGPL boundary absolute: concepts and docs only.
6. **Sculpt OS (tertiary).** A living demonstration of an interactive Genode system and of experimental seL4 readiness -- reality-check material, not a primary design target for a TAME-aligned high-assurance stack.
7. **CAmkES (historical context only).** Still present in defence-oriented tooling; Microkit is the forward path, so CAmkES is background rather than a model to emulate.

## How the weight shift lands on the four equinoxes

**Equinox 1 -- Caravan on the microkernel (crux).** Lead the design notes and clean-room briefs from seL4 plus Microkit plus LionsOS modularity. Express supervision, restart policy, capability tables, and the exit vocabulary in Rye under TAME -- bounds named, at least two asserts per function, explicit widths, named errors. Reach for Genode's dynamic ideas only where a later ring deliberately adds controlled dynamism after the static, bounded core is solid and witnessed. Keep the existing ring ladder; attribute every external concept; no copyleft source in-tree.

**Equinox 2 -- Tally on s6 / skalibs plus musl/Alpine utilities.** Unchanged in priority. s6/skalibs stay the primary permissive allocation and supervision reference. Where a wanted behavior has no microkernel analog, the per-package Alpine/musl license read still precedes any fusion into TAME-guided instructions.

**Equinox 3 -- the Rye compiler's Tally/Caravan target.** The external-research question leads and stays open: can Zig target seL4, freestanding-plus-seL4-libs, or Microkit-style environments against today's real toolchain versions? Answer against real versions. Genode's C++ framework remains the harder fit; do not assume it. Prefer paths that keep the surface close to Microkit-style static systems.

**Equinox 4 -- Aurora on RISC-V under QEMU plus the parity close.** Unchanged: emulation first, sidestepping firmware blobs; the close is the parity-witness happy-zone suite GREEN on the new target. Optional later research: how Microkit and LionsOS platform support intersect with open RISC-V boot -- horizon, not today's gate.

## Design-choice preference, when a Caravan ring reaches a fork

Prefer the choice that keeps the trusted surface smaller, names bounds and asserts early, could later sit beside a static Microkit-style system without contradiction, and still allows deliberate later dynamism once Equinox 1's core is already GREEN. Surface any new gate -- license, toolchain, platform -- immediately, rather than silently assuming a fetch or metal.

## What this note does not do

It approves no fetch, vendors no source, and buys no hardware. It records a reading order and its reasons, commissions three clean-room briefs, and links itself into the seated arc. Grain is not becoming Microkit, LionsOS, or Genode; it is a TAME-guided Rye expression of supervision and bounded allocation that can sit honestly beside the high-assurance seL4 ecosystem. By leading with seL4, Microkit, and LionsOS modularity, then s6, then selective Genode, the project keeps Safety structural, Performance measured, and Joy arising from a surface small enough to hold and assert. The road does not move; the reading order and design weight do.

Hold the line. Prefer the smaller correct surface. Prove with witnesses.
