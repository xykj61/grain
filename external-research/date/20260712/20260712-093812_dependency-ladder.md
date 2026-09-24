# The Dependency Ladder -- Ordered Forward Path

**Language:** EN
**Stamp:** 20260712.093812 (Kaeden's clock, verbatim)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Proposed ordering -- research for understanding / counsel. Rung sequence is a recommendation; Kaeden words which open.

Radiant pass `20260728.050430` -- living rename-forward: **MUR** / **Murr** (was MALA / Mala)
---

The rungs are grouped by what they wait on. Within a group, order is by smallest-first. Each rung names its blocker plainly, so the tree can see what unlocks what. Nothing here is seated; this is the map, not the march.

## Group A -- Accomplishable now (no new dependency)

These need only a session and, where marked, Kaeden's word. They are the ground everything else stands on.

- **A1 - Finish full metal parity.** The first and oldest open debt. The suite was interrupted mid-run on the Framework; individual greens are not a suite green. Foreground, pin the number seen. **Blocker: none -- do this first.**
- **A2 - File the enclosure ruling** (A-narrow then Pond-supersede) as counsel; mark the RTAC row answered. **Blocker: none.**
- **A3 - Seat `lane_kvm`** in our enclosure config, off by default, `/dev/kvm` only, no sessions; move the G0-complete witness inside the jail with its paired refusal; retire the D-Bus path. **Seated `113900`:** refuse GREEN; D-Bus retired; on-path scripts ready (host one-shot when kvm granted). **Blocker was: A2 filed.**
- **A4 - Silo IronBeetle Episode 001** into `gratitude/tigerbeetle/`; let it earn the next episode. **Blocker: none -- runs in its own Sonnet session.**
- **A5 - Seat the parked names** on Kaeden's word: Flax/Bark/Oat/Walnut (Brushstroke palette); release Loam and Ember from park or keep parked; the three verdict RTAC rows (Kumara rotation, Comlink fade-from-birth, genode seams). **Blocker: Kaeden's word only.**

## Group B -- Gated on the seL4 seat booting

The Framework has native KVM now, so the seat can finally boot past GRUB. These rungs need that environment working for the first time.

- **B1 - G0-complete on metal** -- interactive Sculpt / Leitzentrale under host KVM, witnessed by serial banner plus Kaeden's eyes on the glass. **Blocker: A3 (the KVM lane) -- or the existing outside-jail path for one more lap.**
- **B2 - G1 -- the receipt guest under Genode's POSIX runtime.** `receipt_core` already runs freestanding; this is a file for the log and a POSIX runtime. Smallest real seL4 rung. **Blocker: B1 green.**
- **B3 - `genode_seed`** -- the freestanding startup shim (entry, stack, parent-capability handshake, no libc). Third verse after `wayland_seed` and Aurora's kernels. **Blocker: B2 proved the runtime.**
- **B4 - Tally over a fixed Genode dataspace** -- garden budgets become kernel-enforced RAM quotas. **Blocker: B3.**
- **B5 - Storage seam for Mantra** (`write_fact`/`read_range` behind one interface: POSIX file now, file-system session at G2). **Blocker: B3.**
- **B6 - `genode_witness.rish`** -- boot a component under `lane_kvm`, assert GREEN off serial, same shape as the Wasmtime witness. **Blocker: B2.**

## Group C -- Gated on named module horizons

These wait on modules already named but not yet grown to the needed rung.

- **C1 - Comlink transport seam** (key-addressed, `%fade` from birth, content-address dedupe) -- the prerequisite for both the Genode transport seam and any mesh work. **Blocker: Comlink maturing past its current rung.**
- **C2 - Kumara rotation facts** -- old-key-signs-new, monotonic counter, PUBKEYS prose history made checkable law. **Blocker: none technical; wants Kaeden's word (touches keys).**
- **C3 - Mycelium (M4)** -- Comlink's ordering aspect; the prerequisite for split-pipeline activation streams. **Blocker: Comlink at M4 gate.**
- **C4 - Brushstroke token sheet + generator** -- `tokens.rye`, the contrast witness, the CSS custom-properties emitter; the web glass and the Genode framebuffer glass both weave from it. **Blocker: A5 (palette names seated).**

## Group D -- Horizon, simmering (multiple dependencies)

Named destinations that orient the near work, built only when their whole ground holds.

- **D1 - Mesh inference (TAME-guided)** -- pooled compute admitted by Kumara pass, metered by MUR (was MALA), priced by Mandi, booked by Dimeroll. **Blockers: C1 (Comlink), C3 (Mycelium/M4), the seL4 seat, and a model-runtime gratitude seam not yet begun.** Simmer.
- **D2 - Caravan microkernel horizon** -- Rye as a Genode parent, the seat fully our own. **Blockers: the full B and C groups.**
- **D3 - Puddle** -- sandboxed Rye guests with their own Pond and Kumara, KVM through the `lane_kvm` gate. **Blockers: A3, B-group, Pond superseding ai-jail.**
- **D4 - OCapN consumer edge** -- pass-shaped reads at the boundary, the Spritely study's conclusion. **Blocker: the OCapN study landing; Comlink at C1.**

## The critical path, in one breath

**A1 -> A2 -> A3 -> B1 -> B2** is the spine: clear the parity debt, file and seat the enclosure so KVM is honest, boot the seat to completion, prove the smallest guest. Everything in C and D hangs off that spine plus its own named module rung. A4, A5, and C2 run beside the spine on Kaeden's word without blocking it.

---

*May each rung name the machine and the word it needs. May the spine hold straight from the parity debt to the first proven guest. May the horizon stay bright enough to steer by, and far enough to earn.*
