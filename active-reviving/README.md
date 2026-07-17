# Active Reviving — Re-Growing the Elders into Glow

**Language:** EN
**Version:** `20260717.172832` (Eastern — Dexter / Dill / glass input revival indexed)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** Living — the home for revivals in motion, sibling to `active-designing/`

---

## What Reviving Is

Reviving is how Glow OS grows: not by renaming what exists, but by **re-growing an existing working thing into the Glow direction as a new artifact beside the elder.** A revival takes something real — an Urbit vane resting in `old/`, a Rye OS module already running, a retired seam like the WOV-TigerBeetle pin — and rewrites its proven essence in Glow, under TAME, born with its Glow-direction name. The elder keeps its name and its green witnesses and keeps running. The revival supersedes it only once it is proven, and never before.

This resolves the rename tension at its root. We were weighing whether to rename our modules to Urbit's vane names (huge reference churn, un-reviewable diffs) or keep our own (less legible to Urbit). Reviving dissolves the choice: **we never rename.** A revived module is a new thing, so it is simply *born* with whichever name fits the Glow direction — while the elder it grew from stays exactly as it was until the revival earns the right to replace it.

## Reviving vs. Designing — the Sibling Distinction

`active-designing/` and `active-reviving/` are siblings, and the line between them is clean:

- **`active-designing/`** plans something **new** — a module, a lap, a surface that did not exist. Forward-looking; no required ancestor.
- **`active-reviving/`** re-grows something that **already exists** — it always names its elder (the `old/` vane, the running module, the retired seam) and carries that elder's working essence forward into Glow. Backward-rooted, forward-growing.

If a brief has no ancestor it is reviving from, it belongs in `active-designing/`. If it is rewriting a real, working thing into Glow, it belongs here.

## The Discipline of a Revival

Every revival keeps five rules, each drawn from a law this project already lives by:

1. **Name the elder.** A revival states exactly what it re-grows — a path in `old/`, a module, a retired seam. No named source means it is designing, not reviving.
2. **Grow beside; never break** (accrete-never-break). The elder keeps its name, its home, and its green witnesses, and keeps running throughout. The revival grows here as design, then lands as a new artifact in its own home when ready.
3. **Born with its Glow name.** Because a revival is a new artifact, it carries its Glow-direction name from birth. This is the whole point: renaming is replaced by naming-at-birth, so no reference ever churns.
4. **Supersede only when proven** (the Pond-supersedes-ai-jail pattern). The revival replaces the elder only after passing the elder's own witnesses, with an explicit supersede word. Until then, both coexist honestly.
5. **May shelter in Maze.** A revival still earning its shape may live in the Maze nursery until it graduates to a canonical name and home.

## The Clock a Revival Keeps

A revival is born with its Glow name **and** its own warm-aura date-atom stamp (`YYYYMMDD.HHMMSS` in headers, `YYYYMMDD-HHMMSS_slug` in filenames), exactly as every dated artifact does — see [`../context/specs/20260714-024800_warm-aura-date-atom-naming.md`](../context/specs/20260714-024800_warm-aura-date-atom-naming.md). Reviving and archiving speak the same clock: the elder keeps its name and stamp, the revival is stamped fresh at its own birth, and later is always larger. Nothing about reviving invents a different dated shape.

## Revivals in Motion (the index)

These are already underway, now recognized as revivals rather than one-off designs:

| Revival | Elder(s) it re-grows | Design home | Status |
|---|---|---|---|
| **Neth** | the retired WOV-TigerBeetle pin + TigerBeetle's replicated-state-machine shape | design [`../external-research/20260714-001017_neth-mala-settlement-l1-l2-design.md`](../external-research/20260714-001017_neth-mala-settlement-l1-l2-design.md); cost/cluster [`../external-research/20260714-012125_neth-vps-cost-and-cluster-plan.md`](../external-research/20260714-012125_neth-vps-cost-and-cluster-plan.md); **build ladder** [`../external-research/20260714-041542_ironbeetle-patterns-for-the-neth-ladder.md`](../external-research/20260714-041542_ironbeetle-patterns-for-the-neth-ladder.md) | name confirmed; deterministic-root witness **green** (Plan A, $0, local); IronBeetle-siloed ladder now names the next laps — small serial core · two-posture root install · apply-step crash safety · seeded simulation horizon |
| **The doc pipeline** | Scribble, Brix, and Mantra toward their Clay/Ford roles in Glow | [`../external-research/20260713-235700_glow-doc-fusion-scribble-brix-mantra.md`](../external-research/20260713-235700_glow-doc-fusion-scribble-brix-mantra.md) | design; round-trip witness proposed |
| **Glow itself** | Rye + **Hoon** | study [`../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md`](../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md); **owned decision** [`20260715-213500_glow-revives-hoon-runes-targets-riscv.md`](20260715-213500_glow-revives-hoon-runes-targets-riscv.md) | decision seated `20260715.213500` — Glow carries Hoon's **runes** and referential transparency, changes the **target**: primary Glow→Zig→**RISC-V** (M0-proven arch-portable), Nock a **second backend** for Urbit interop only; determinism moves from the VM to the discipline |
| **Rhyz** | **Kumara** (the Ed25519 identity seam — `tally/kumara.rye` + 72 code files + green witnesses) | [`../external-research/20260714-044428_rhyz-r-vane-identity-reviving-kumara.md`](../external-research/20260714-044428_rhyz-r-vane-identity-reviving-kumara.md) | name confirmed (R-vane, rhizome); Azimuth-tier shape adopted; elder keeps its home + witnesses; living docs migrate on-touch, code migration deferred to proven-supersede |
| **Sala** | **Realidream** (the unified viewer — its ~18 code/doc references + the roadmap Visual-Track lane) | [`../external-research/20260715-172000_pool-keystone-revival-realidream-landscape.md`](../external-research/20260715-172000_pool-keystone-revival-realidream-landscape.md) | name **confirmed** `20260715.175500` (Sanskrit *śālā*, "hall/abode"; Landscape parallel, runs under Pool); elder keeps its name, references, and lane; code migration deferred to proven-supersede |
| **Pond** (precedent, already landed) | ai-jail | (the supersede pattern this whole concept generalizes) | superseded on word |
| **Dexter-on-glass** | Dexter line editor (`pond/apps/window_input.rye`) + NativeActivity glass; **Dill stays an honest gap** (not nested, not renamed) | study [`../external-research/20260717-172832_dexter-dill-glow-grapheneos-input.md`](../external-research/20260717-172832_dexter-dill-glow-grapheneos-input.md); **owned decision** [`20260717-172832_dexter-beside-brushstroke-dill-stays-gap.md`](20260717-172832_dexter-beside-brushstroke-dill-stays-gap.md) | D0+D1 **GREEN** `20260717.173133`; D2 Pixel look open; Dill-parallel stays a separate future revival |

## Why This Is the Right Shape

- It is Gall's Law made into a folder: a complex Glow OS grows from the simpler elders that already worked, one revival at a time, each proven before it supersedes.
- It keeps every review small and human-checkable — the elder never churns, the revival is a fresh, self-contained artifact.
- It keeps every pitch legible — a revival can be pitched as "our Glow-native Clay," born with that name, without ever having renamed Mantra.
- It is honest — the elder stays visible and running until the revival truly earns its place.

---

*May we revive rather than rename, grow rather than break, and let each new thing earn the place of the old before it takes it.*
