# 976 · What We Mean by Seed

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*A siloed vocabulary brief: the word **seed** names the smallest living version of a module — the thing that runs, proves one honest claim, and grows by accretion toward the full design. The Seed Law made a noun. The first concrete seeds are named in `987`; the whole-system map carries them in `983`. This brief states what the word means on our own ground so every new seed reads true beside the ones already green.*

**Language:** EN
**Version:** `20260622.235012` (Rye chronological stamp)
**Last updated:** 2026-06-22
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — the Seed Law; correctness by construction (`990`); single-stranded composition (`995`)
**Status:** Active Design (siloed)

---

## Our Own Ground

This is a clean room. We name only our modules — **Rye**, **Rishi**, **Brix**, **Mantra**, **Tally**, **Caravan**, **Aurora**, **Pond**, **Comlink**, **Brushstroke**, **Skate**, **Tablecloth** — together with **RISC-V** and **x86_64** where hardware matters.

---

## The Seed Law

**A complex system that works is grown from a simpler system that worked.**

We call this the **Seed Law** — the principle that orders how every module in the family begins and grows. The gratitude for the insight lives in `../external-research/20260620-014412_system.md`; here we speak only the principle itself, in our own name.

## One Word, One Law

A **seed** is the smallest version of a module that **runs** and **proves** the one claim the larger module rests on.

It is not a sketch. It is not a design doc awaiting code. It is not the finished module wearing a modest name. It is a program — usually `seed.rye` or a clearly named sibling — that a person can build, run, and watch succeed behind assertions or the parity gate.

The law it embodies: **a complex system that works is grown from a simpler system that worked — the Seed Law.** We do not open the whole Pond GUI, the whole microkernel, or the whole compositor in one pass. We open the seed, prove it green, and grow the next lap only from what already runs.

---

## What a Seed Must Do

Every seed in the family shares a shape, even when the domains differ (boot, memory, supervision, display, version control).

| Property | Meaning |
|----------|---------|
| **Runs** | Build + execute on the stated target (hosted Linux, QEMU RISC-V, stdout, …). |
| **Proves** | `debug.assert`, explicit exit codes, or gate witnesses — the claim is checkable, not hoped for. |
| **Names one thing** | One primary responsibility; composition comes in the *next* file, not inside the seed. |
| **Bounded** | Budgets, restart limits, line counts, garden sizes — stated at construction. |
| **Version-stamped** | A chronological constant (`20260620.021912`) ties the running artifact to the brief that authorized it. |
| **Hosted-first when wise** | Caravan and Tally seeds run on the host so Rishi's gates reach them; Aurora's seed runs freestanding because boot *is* the claim. |

A seed **says** what the module is for. The v1 beside it **composes** what the seed proved into the next lap.

---

## What a Seed Is Not

| Term | Distinction |
|------|-------------|
| **Bootstrap** | `rye/bootstrap.sh` cold-starts the compiler before a `rye` binary exists — infrastructure, not a module seed. |
| **Owner key seed** | Cryptographic material from which keys derive (`10002`) — a *seed phrase*, not a Gall seed. |
| **Random seed** | PRNG or ML reproducibility — unrelated vocabulary. |
| **Expanding prompt** | A prompt is a seed of *intent* (`9999`); the code seed is the running proof of a *module*. |
| **siloed brief** | Design on clean-room ground — essential, yet not a seed until a program runs the claim. |
| **Full module** | Caravan v1, Tally v1, Pond GUI — compositions of seeds and simpler systems beneath them. |

When prose says "the forge seed" or "Comlink seed," it means **the smallest running slice** of that module still to be written — not the whole forge or the whole network.

---

## Anatomy — Files and Growth Rings

**File naming.** The canonical name is `seed.rye` inside the module directory (`tally/seed.rye`, `caravan/seed.rye`, `brushstroke/seed.rye`, `aurora/src/seed.rye`). Growth passes add siblings that **compose** without erasing the seed:

```
caravan/seed.rye      →  one parent, one child, restart on fall
caravan/bounded.rye   →  seed + Tally garden in the child
caravan/twin.rye      →  two children, separate gardens
caravan/chain.rye     →  wake → prove, ordered chain-loading
caravan/capabilities.rye → bounded table naming what each child may do
```

```
tally/seed.rye        →  one Region, asserted edges
tally/gardens.rye     →  named gardens (blob, diff, frame)
```

```
brushstroke/seed.rye  →  Frame value → stdout redraw
(wayland_seed.rye)    →  same Frame → one native window (next lap)
```

The seed file stays. Later rings import its discipline or inline its types honestly; they do not replace the proof the seed established.

**Mantra** seeds inside `mantra/src/main.rye` rather than `mantra/seed.rye` — historical path, same law: weave + diff + store + three commands before multi-file repo tracking.

**Brix** seeds as `.brix` — a descriptor value, not a supervisor loop. The claim is *declaration*: name, version, bricks listed. Mantra reads it; Caravan will realize it.

---

## The Running Seeds (catalog)

| Module | Seed artifact | Primary claim | Status |
|--------|---------------|---------------|--------|
| **Aurora** | `aurora/src/seed.rye` | A hart wakes, speaks one asserted line, halts | Running (RISC-V) |
| **Tally** | `tally/seed.rye` | One Region; allocate within edges; clear whole | Running; v1 in `gardens.rye` |
| **Caravan** | `seed.rye` → `bounded` → `twin` → `chain` | Supervision + chain-loading | Running |
| **Mantra** | `mantra/src/main.rye` (seed commands) | Weave, LCS diff, SHA3-256 store, init/add/status | Running; repo chain wove 9 bricks |
| **Brushstroke** | `brushstroke/seed.rye` (hosted); `wayland_seed.rye` (native window) | Frame drawn from values | Running |
| **Brix** | `.brix` | Project descriptor Mantra can read | Running |
| **Comlink** | `posted.rye` (shared memory); `comlink/hosted_wire.rye` (localhost UDP) | Sealed datagram moves between harts or processes | Running |
| **Rye** | `rye/src/main.rye` | Self-hosting compiler + strengthened std | Running (16 witnesses) |
| **Rishi** | `rishi/src/main.rye` + tests | Typed shell; gate trio in `.rish` | Running |
| **Pond** | `rishi/examples/pond.rish` | Policy as a value | Designed; awaits Caravan + Tally enforcement |
| **Skate** | `skate_grid.rye` + `font8x8_data.rye` on `wayland_seed.rye` | Monospace text grid on Wayland seed | Running (`10023` Track A) |
| **Scribble / Lantern / Lattice** | — | Horizon modules (`978`) | Siloed design only |

Horizon seeds still to plant: **virtio-net device wire**, **Forge HTTP seed** (`982`). **Caravan capability table** landed (`caravan/capabilities.rye`, `2026-06-30`).

---

## Seeds and the Gates

A seed earns trust when the **gate trio** can reach it:

- **`parity.rish`** — behavior identical across baseline and strengthened std (witness programs).
- **`parity-selftest.rish`** — the gate turns RED on a real divergence.
- **`additive-gate.rish`** — std changes are assertions and words only.

Seeds that touch `rye/lib/std` grow the witnesses. Seeds that are pure module code (Caravan, Tally, Brushstroke) prove with their own assertions first; they join the witnesses when they strengthen shared surfaces.

---

## Seeds and Composition (`977`, `983`)

Each seed is one **simple service** doing one job (`977`). Mantra **transforms** and **remembers**; Comlink **moves**; Caravan **routes** supervision; Brushstroke **transforms** values into a frame. A seed proves one operation honest before the flow braids them.

`983` maps every module to a seed row. When the map drifts from the repo, update the map — the seeds on disk are ground truth.

---

## How to Plant a New Seed

1. **Name the one claim** the full module cannot live without.
2. **Write the smallest program** that proves it — one file, one success line, assertions counted.
3. **Stamp the version** chronologically.
4. **Run it** on the honest target (hosted vs freestanding).
5. **Record it** in `995` What Just Landed, `.brix` if it is a brick, and this catalog.
6. **Grow the next lap** only after the seed is green — never skip to v1 in the same breath.

---

## Relation to `987`

`20260619-084412_the-first-seeds.md` was counsel from a moment in time: plant Caravan, Tally, and close-reading in parallel with the device wire. **`976` is the vocabulary; `987` is the instance.** When someone says "plant a seed," they mean the law in this brief. When someone says "the Caravan seed," they mean `caravan/seed.rye`.

---

*May every module find its smallest honest proof. May the word seed mean one thing in every brief, every filename, and every roadmap row. May we grow the whole from what already runs — one seed at a time, each green before the next lap.*
