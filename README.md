# Glow OS

**Language:** EN
**Style:** Radiant (see [`context/RADIANT_STYLE.md`](context/RADIANT_STYLE.md))
**Status:** Living — the front door to the repository; each claim below marks what runs today versus what is named and scoped

---

Welcome. This repository is **Glow OS** — a body of work developed in the open as a **proposal to [Urbit](https://urbit.org)**, exploring what Urbit could become when its ideas are rebuilt in **Glow**, a language that keeps Hoon's runes over bounded, asserted, statically-disciplined semantics. It descends from `urbit/urbit` as a downstream research repository, and its intent is collaborative: to grow ideas here, prove them with witnesses, and offer the ones that earn their place back upstream as contributions — an infinite game played *with* Urbit, not against it. If you are an Acme Corporation employee opening this tree for the first time, this page is the one calm read that orients you: what Glow OS is, the five variants you can choose between, what actually boots today, and where to go next.

Glow OS is one body of work with **one language, one value model, and one law** ([`context/TAME_GUIDANCE.md`](context/TAME_GUIDANCE.md)) — offered to you as a template in which you pick a variant and build. Its stance is a **collaborative, ethical accelerationism**: build ambitiously and in the open, measure honestly, and offer the work upstream as a gift rather than hold it apart (see [`gratitude/TechnoOptimistManifesto.md`](gratitude/TechnoOptimistManifesto.md)).

---

## The Five Choices

The heart of the template is a choice among **five OS variants**. They are not five different systems — they are **one design, built more than once, on purpose**, the way a careful machine can dual-, tri-, quad-, or five-boot between images that agree on what they do and differ only in how they were made. Choosing among them is choosing how much independent redundancy you want beneath you, not learning five separate systems.

| Variant | What it is | Status |
|---|---|---|
| **Reya** | An OS variant; the diverse-redundant twin of Riyo | Name confirmed; not yet built |
| **Riyo** | An OS variant; the diverse-redundant twin of Reya | Name confirmed; not yet built |
| **Trey** | An OS variant; the diverse-redundant twin of Triz | Name confirmed; not yet built |
| **Triz** | An OS variant; the diverse-redundant twin of Trey | Name confirmed; not yet built |
| **Quin** | An OS variant; the fifth boot image, intentionally unpaired | Confirmed fifth `20260717.162114`; unpaired settled `20260717.162620`; not yet built |

**Why more than one?** Safety leads every decision in this tree (that is what TAME Guidance means by "safety first"). Two honest, independently-written implementations of the same intent mean a single implementation mistake cannot take down the only copy you have — the same principle as N-version programming, applied at the scale of a whole operating system. Four of the five form **two diverse-redundant pairs** — Riyo/Reya and Trey/Triz — where each pair must agree on every externally-visible behavior, checked by one shared witness suite both must pass identically, and may differ only in internal detail. **Quin** is the fifth bootable image, **intentionally unpaired** — five total, a settled count, no twin hunt. Recorded in [`context/specs/20260713-235600_names-awaiting-confirmation.md`](context/specs/20260713-235600_names-awaiting-confirmation.md).

**How you would choose one.** A boot reads a signed, verified value naming which variant to wake — the design is in [`external-research/20260714-013700_aurora-vere-arvo-boot-fusion-and-kelvin-strategy.md`](external-research/20260714-013700_aurora-vere-arvo-boot-fusion-and-kelvin-strategy.md). Today the five variants are **named and scoped, not yet bootable**; the selection mechanism is designed as a small, reviewable step, not yet built. When you copy a command from these docs, the ship name in it is always a deliberately invalid placeholder such as `~acme-corp-test-ship` — never a real point on the live network.

**Quin carries more than one hat on purpose.** The same name is the standing writing companion ([`context/QUIN.md`](context/QUIN.md)), the inference **Q-vane** horizon, and now the fifth OS variant — answer to "Quin," "Quin voice," and "Quin, five." Reya 2, Rio 3, and the short writing-voice season under Riyo's name rest in [`context/archive/`](context/archive/).

The full onboarding surface for the variants lives in the manual: [`manual/glow-os/`](manual/glow-os/README.md) — an overview, a getting-started path, and one shared template filled once per variant so all five stay in lockstep.

---

## The Shape, Top to Bottom

| Layer | Name | What it is | Status |
|---|---|---|---|
| Language | **Glow** | Hoon's runes over TAME-bounded semantics; emits ordinary `.rye` | desk hops emit GREEN — see [`glow/README.md`](glow/README.md) |
| Interpreter | **Nock interpreter** | runs Glow's compiled forms | scoped (Nock 4K), not built |
| Umbrella | **Glow OS** | the whole system | named (formerly "Rye OS") |
| Variants | **Reya · Riyo · Trey · Triz · Quin** | five switchable OS builds, all in Glow | named; see the table above |
| Kernel spine | state as a pure fold over an append-only log of signed facts | the transition-function model | the stated spine, with running witnesses |
| App ladder | **TUBE** | Glow app = Pool agent → signed APK on GrapheneOS (HAWM) | TUBE0–5 · TUBE7 GREEN; TUBE6 horizon — [`docs/TUBE.md`](docs/TUBE.md) |
| Modules | Rishi, Mantra, Comlink, Caravan, Tally, Brix, Bron, Aurora, Pond, Scribble, and more | the running seeds | many green today |

**An honest word on status.** Most of what runs today still lives under the project's prior module names and is being carried into Glow OS by decision, not yet by a mass rename. Glow's **desk already emits** through `glow_run` witnesses; a full OS boot and the Nock interpreter remain horizon. The five variants are named and scoped — real design, real direction — yet not things you can boot quite yet. Every page in this tree marks its own register: what a witness proves, versus what is proposed. Nothing here claims a feature its witnesses do not show. That discipline has a name and a home ([`context/TWO_ROOMS.md`](context/TWO_ROOMS.md)).

---

## What You Can Actually Run Today

- **Glow desk** — eight generator hops lower to Rye and run via [`tools/glow_run.rish`](tools/glow_run.rish); desk witness GREEN — [`glow/README.md`](glow/README.md).
- **TUBE / HAWM product edge** — installable NativeActivity APK (Sala fold), Pool admit, GrapheneOS-parallel Resource Scope (Storage · Contact), Network Grant, and Sensors Grant (including `OTHER_SENSORS` emission) — [`docs/TUBE.md`](docs/TUBE.md) · [`docs/HAWM.md`](docs/HAWM.md).
- **The module seeds** — the Rishi shell, Mantra, Comlink, Scribble, and the rest, each with its own `tools/*.rish` witness.
- **The witness suite** — the parity gates in `tools/` that guard every push; state is proven on metal, not asserted in prose.
- **The enclosure** — editor inside a host fence where your machine supports it (macOS `sandbox-exec` guide: [`manual/guides/macos-ai-jail-setup.md`](manual/guides/macos-ai-jail-setup.md); this Framework host runs under ai-jail).

---

## Getting Set Up

Two root configuration files hold what is specific to *your* machine and *your* identity, so the tree itself stays a clean, shareable template:

- **[`GLOW_HOST.template.bron`](GLOW_HOST.template.bron)** — copy to `GLOW_HOST.bron` (kept out of git) and fill in this host's OS, architecture, and toolchain paths (`linux`/`x86_64` and `macos`/`aarch64` are both first-class). [`tools/glow_host_run.sh`](tools/glow_host_run.sh) reads it and refuses to run against a mismatched toolchain rather than silently reaching for the wrong one.
- **[`GLOW_PROFILE.template.bron`](GLOW_PROFILE.template.bron)** — copy to `GLOW_PROFILE.bron` (kept out of git) and fill in the professional identity that signs the work: name, forge handles, contact, timezone for one-clock stamps, and session-log editor/model/voice defaults (standing voice **Quin**). The tree's own docs speak to a generic reader; the profile is where the specific "who" lives.

Then read, in order:

1. **[`ORGANIZING.md`](ORGANIZING.md)** — where every kind of work lives in this tree.
2. **[`manual/glow-os/`](manual/glow-os/README.md)** — the Glow OS onboarding rooms and the five variants.
3. **[`docs/TUBE.md`](docs/TUBE.md)** · **[`glow/README.md`](glow/README.md)** — what the app ladder and language desk prove today.
4. **[`CONTRIBUTING.md`](CONTRIBUTING.md)** — how a contribution arrives: small, signed, component-prefixed, in Radiant voice.

---

## The Disciplines That Govern This Tree

- **[`context/TAME_GUIDANCE.md`](context/TAME_GUIDANCE.md)** — how the code stays safe: invariants before implementation, bounds on everything, docs and implementation kept in sync.
- **[`context/RADIANT_STYLE.md`](context/RADIANT_STYLE.md)** — how the prose reads: clear, warm, and true when read aloud.
- **[`CONTRIBUTING.md`](CONTRIBUTING.md)** — the inherited Urbit strictness this proposal keeps, plus the voice it adds.

---

*May the front door stay plain. May the five variants read as one system seen five ways. And may you find, on your first read, exactly what you came for.*
