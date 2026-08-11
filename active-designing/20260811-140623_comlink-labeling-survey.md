# Comlink Labeling Survey — CION, before any sweep

**Language:** EN
**Stamp:** `20260811.140623` (EDT) · **Voice:** Kyri · **Style:** Radiant
**Status:** Survey — a looking pass (name sites and gaps, open one checkable door), no relabel done. Feeds the CION relabel ratchet (`../context/specs/20260810-222755_chronological-semantic-labeling-and-the-cion-meta-season.md`, addendum). Red #65.

---

## Why comlink got a survey, not a sweep

The first four CION modules — mandate, scribe, vault, pond, granary — each carried a clean `lap N` that named a capability by a bare ordinal, and each swept cleanly to *semantic label + stamp*. comlink is different: its ~40 `lap N` references split three ways, and only one of the three is a bare ordinal comlink actually owns. Sweeping it blind would relabel meaning that already exists and rename references that belong to other modules.

## The three buckets

**1. Structured protocol codes — meaningful, keep (~24 refs).** `OA-L3` (Open-Asks Level 3), `NS-L3` (Name-Sync Level 3), `I2` (snapshot revision), `lap 3w-4`, `lap 3w-3a` / `3w-3b` (wire sub-stages), `lap 4b` (device sub-revision). These are exactly the *meaningful scheme* the labeling law permits — the `R2`/`R3` case: a level and revision that tell a reader what the thing is. The embedded word `lap` could later be tidied to a cleaner token (`wire-stage 3b`), yet the identity is not a bare count-up and is **not a violation**.

**2. Cross-module reference tags — relabel with the source module (~13 refs).** `Granary lap 4` / `lap 4b`, `Amphora lap 3`, `I2 snapshot lap 3`, and the README port-table rows. Here comlink is the *wire* naming which other module's build stage it carries; the `lap N` is a reference into Granary, Amphora, or the snapshot module, not comlink's own identity. These should track the source module's relabel (Granary's own prose is already swept) rather than being renamed unilaterally inside comlink.

**3. comlink's own `sub-lap 1/2/3` — the one true bare sequence (~13 refs).** The device-wire bring-up: `sub-lap 1` (hosted selftest — descriptor algebra + seal/open on fixtures), `sub-lap 2` (freestanding pattern TX/RX link), `sub-lap 3` (sealed datagram over the link). A real, meaningful staging — yet named by a bare ordinal, so it is comlink's genuine relabel candidate. It is also the **highest-coupling relabel in the tree so far**: the `sub-lap` strings live in `vn.write_str` output inside **freestanding RISC-V guest binaries** (`guest_pattern_*`, `guest_sealed_*`) and are asserted by `tools/comlink_device_wire.rish` and `comlink_device_wire_lab.rish`. Relabeling means editing guest strings, co-updating both witnesses, and rebuilding the RISC-V guests to prove GREEN on metal.

## The guard is not ready for comlink

The current guard matches `\blap [0-9]+`, which false-positives on this module twice over: it matches `lap 3` inside `lap 3w-3b` (a meaningful code) and `lap 2` inside `sub-lap 2` (via the `-` word boundary). Adding comlink to `cion_module_labeling_witness` today would RED on legitimately-meaningful identifiers. The guard needs a refinement first — recognize structured `L3` / `3w-3b` / `4b` codes and `sub-lap` as distinct from a bare `lap N` — before comlink can be scanned.

## Recommended doors, in order

1. **Refine the guard** to distinguish a bare `lap N` from a structured code (`*-L3`, `3w-3b`, `4b`) and from `sub-lap N`, so it can eventually scan comlink without false positives.
2. **Relabel `sub-lap 1/2/3`** as its own word-gated round — semantic stage names (e.g. *hosted seal/open · freestanding link · sealed datagram*), guest strings and both witnesses co-updated, RISC-V guests rebuilt GREEN.
3. **Let the cross-module tags ride** with each source module's relabel; polish the structured `lap 3w-*` tokens only if a cleaner word is wanted, as low-priority tidy.

No relabel is done here. This survey opens the checkable door (refine the guard) and names the gaps (the sub-lap round, the cross-module coordination) so the next CION rounds are scoped honestly rather than swept blind.
