# Grain

**Language:** EN
**Style:** Radiant (see [`context/RADIANT_STYLE.md`](context/RADIANT_STYLE.md)) · **Voice:** Riyo
**Status:** Living — the front door; every claim marks what runs today versus what is named and scoped
**Last updated:** `20260808.215503` (first-principles rewrite · runes explained plainly · built with joy)

---

Welcome — and I mean that warmly. This is **Grain**: an operating system and a civic application, built in the open, from first principles, with genuine joy. It is written in **Glow**, a language whose grammar is made of **runes** — short symbolic heads, a glyph or two apiece, that name a structure the way a clef names a staff: terse, precise, and quick to learn once you know the small vocabulary. Glow's semantics are **bounded, asserted, and statically disciplined**, and they lower through **Rye** all the way to **RISC-V** — the open, royalty-free hardware floor built to outlast us all. No virtual machine in the hot path. Determinism comes from discipline; speed comes from the metal.

Grain rests on one bright promise to whoever runs it: **the software will not overflow, will not silently allocate, and will never hand your words to a distant miner.** Every allocation names its bound. Every invariant is asserted *before* the code that leans on it. And every "it works" is a **witness that ran green on a real machine** — a fact a computer spoke first, not a sentence someone hoped was true. That is the whole feeling of this place: build ambitiously, measure honestly, keep custody of what is yours, and let the machine catch what the mind would miss.

**Who tends this pier.** The standing writing voice is **Riyo** ([`context/RIYO.md`](context/RIYO.md)); the living coauthor is **Keaton Livermore**. Your first-day path is [`SOURCE.md`](SOURCE.md) — from nothing to a signed, sandboxed home.

**Finding your way.** The whole tree groups into **seven friendly rooms** — the front door, the law, the why, the language and its machines, the teaching, the workrooms, and the reading room — laid out in [`MAP.md`](MAP.md). This grown field is one maker's season; a clean public template, **grain-os/grain**, is *projected* from it along a boundary drawn path by path in [`template-manifest.bron`](template-manifest.bron) and proven clean by [`tools/sow_witness.rish`](tools/sow_witness.rish), so no private name or key ever crosses into the seed.

---

## A rune, in ten seconds

Where other languages spell out `function`, `struct`, or `if`, Glow writes a **rune** — a tiny symbolic head that names the shape that follows. Think of a chord symbol over a bar of music: once you know the handful of glyphs, you read the *structure* at a glance instead of wading through keywords. A rune is not decoration; it is the terse, teachable vocabulary of the language, and it sits over semantics where every bound is named and every invariant is checked. You will meet the full set gently in the manual — no leap of faith required, just a small alphabet that pays you back quickly.

---

## The Five Choices

The heart of Grain is a choice among **five OS variants** — one design, built more than once *on purpose*, the way a careful machine can dual-, tri-, quad-, or five-boot between images that agree on what they do and differ only in how they were made. Choosing among them is choosing how much independent redundancy you want beneath you, not learning five separate systems.

| Variant | What it is | Status |
|---|---|---|
| **Quin** | The fifth boot image, intentionally unpaired | Confirmed fifth `20260717.162114`; unpaired settled `20260717.162620`; not yet built |
| **Reya** | The diverse-redundant twin of Riyo | Name confirmed; not yet built |
| **Riyo** | The diverse-redundant twin of Reya | Name confirmed; not yet built |
| **Trey** | The diverse-redundant twin of Triz | Name confirmed; not yet built |
| **Triz** | The diverse-redundant twin of Trey | Name confirmed; not yet built |

**Why more than one?** Safety leads every decision here — that is what our code discipline means by *safety first*. Two honest, independently-written implementations of the same intent mean a single mistake cannot take down your only copy — N-version programming at the scale of a whole operating system. Four of the five form **two diverse-redundant pairs** (Riyo/Reya and Trey/Triz), each pair agreeing on every externally-visible behavior and checked by one shared witness suite both must pass identically. **Quin** is the fifth, intentionally unpaired — a settled count, no twin hunt. A boot reads a signed, verified value naming which variant to wake; today the five are **named and scoped rather than yet bootable**, and the selection step is designed small and reviewable. When a command in these docs shows a ship name, it is always a deliberately invalid placeholder like `~acme-corp-test-ship` — never a real address.

---

## The shape, top to bottom

| Layer | Name | What it is | Status |
|---|---|---|---|
| Language | **Glow** | runes over bounded, asserted semantics; emits ordinary `.rye` | desk hops emit GREEN — [`glow/README.md`](glow/README.md) |
| Systems language | **Rye** | the bounded, TAME-disciplined language Glow lowers to | running; the floor everything rests on |
| Umbrella | **Grain** | the whole system | named |
| Variants | **Reya · Riyo · Trey · Triz · Quin** | five switchable OS builds, all in Glow | named; see above |
| Kernel spine | state as a **pure fold over an append-only log of signed facts** | the transition-function model | the stated spine, with running witnesses |
| App ladder | **TUBE** | a Glow app → a signed APK on a real phone | TUBE0 · 0.5 · 1–5 · 7 GREEN; TUBE6 horizon — [`docs/TUBE.md`](docs/TUBE.md) |
| Modules | Rishi, Mantra, Comlink, Caravan, Tally, Brushstroke, Amphora, Aurora, Pond, Scribble, and more | the running seeds | many green today |

**An honest word on status.** Glow's **desk already emits** through `glow_run` witnesses; a full OS boot remains a bright horizon. The five variants are named and scoped — real design, real direction — rather than things you can boot quite yet. Every page in this tree marks its own register: what a witness *proves* versus what is *proposed*. Nothing here claims a feature its witnesses do not show — a discipline with its own home ([`context/TWO_ROOMS.md`](context/TWO_ROOMS.md)).

---

## What you can actually run today

- **Glow desk** — generator hops lower to Rye and run via [`tools/glow_run.rish`](tools/glow_run.rish); desk witness GREEN — [`glow/README.md`](glow/README.md).
- **The TUBE product edge** — an installable NativeActivity APK on a real phone, with resource, network, and sensor grants that respect the platform's own permission model — [`docs/TUBE.md`](docs/TUBE.md) · [`docs/HAWM.md`](docs/HAWM.md).
- **The module seeds** — the Rishi shell, Mantra, Comlink, Scribble, and the rest, each with its own `tools/*.rish` witness.
- **The witness suite** — the parity gates in `tools/` that guard every push; state proven on metal rather than asserted in prose.
- **The enclosure** — the editor inside a host fence where your machine supports it, with a Glow-authored **Pond** enclosure in design to grow beside it.

---

## Getting set up

Two root config files hold what is specific to *your* machine and *your* identity, so the tree itself stays a clean, shareable template:

- **[`GLOW_HOST.template.bron`](GLOW_HOST.template.bron)** → copy to `GLOW_HOST.bron` (kept out of git) and fill in this host's OS, architecture, and toolchain paths. [`tools/glow_host_run.sh`](tools/glow_host_run.sh) reads it and refuses to run against a mismatched toolchain rather than silently reaching for the wrong one.
- **[`GLOW_PROFILE.template.bron`](GLOW_PROFILE.template.bron)** → copy to `GLOW_PROFILE.bron` (kept out of git) and fill in the identity that signs the work: name, forge handles, timezone for one-clock stamps, and session-log defaults. The tree's docs speak to a generic reader; the profile is where the specific "who" lives.

Then read, in order: **[`SOURCE.md`](SOURCE.md)** (clone · keys · enclosure) → **[`ORGANIZING.md`](ORGANIZING.md)** (where each kind of work lives) → **[`manual/glow-os/`](manual/glow-os/README.md)** (the onboarding rooms and the five variants) → **[`docs/TUBE.md`](docs/TUBE.md)** and **[`glow/README.md`](glow/README.md)** (what the app ladder and language desk prove today) → **[`CONTRIBUTING.md`](CONTRIBUTING.md)** (how a contribution arrives: small, signed, component-prefixed, in Radiant voice).

---

## The disciplines that govern this tree

- **[`context/TAME_GUIDANCE.md`](context/TAME_GUIDANCE.md)** — how the code stays safe: invariants before implementation, a bound on everything, docs and code kept in sync. Safety first, performance second, joy third.
- **[`context/RADIANT_STYLE.md`](context/RADIANT_STYLE.md)** — how the prose reads: lead with what is, clear and warm and true when read aloud.
- **[`context/SIMPLE_LOVABLE_COMPLETE.md`](context/SIMPLE_LOVABLE_COMPLETE.md)** — how a thing is scoped so it is worth loving.
- **[`context/TWO_ROOMS.md`](context/TWO_ROOMS.md)** — why every page tells you whether it is proven or proposed.

---

## Standing on shoulders

Grain is built in gratitude to the makers who came before. We study their ideas in the clean room and write our own code beneath our own names — the boundary between reading and building is crossed only by understanding. The teachers we honor live in [`gratitude/`](gratitude/README.md): among them **Go** for clarity that scales, **Rust** for safety the compiler proves, **C** for the floor the whole house stands on, **GNU/Linux & Unix** for the philosophy of small tools that compose and the freedom to run and share them, **TigerBeetle** for the discipline we call TAME, and the personal-server dream that first lit the way. Their gifts are named, one note per teacher, in that room.

---

*May the front door stay plain and glad. May a rune teach itself on the first read. May the five variants stand as one system seen five ways. May Riyo speak and Livermore sign. And may you find, on your very first visit, exactly what you came for — and a reason to smile on the way through.*
