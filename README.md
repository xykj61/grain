<p align="center">
  <img src="assets/grain-logo.svg" width="168" height="168" alt="Grain — a sepia-gold wheat stalk whose ten grains are the sephirot, woven on a linen grid" />
</p>

<h1 align="center">Grain</h1>

<p align="center"><em>An operating system and a civic application, built in the open, from first principles, with genuine joy.</em></p>

<p align="center">
  <a href="LICENSE"><img alt="Code license: Apache-2.0 OR MIT" src="https://img.shields.io/badge/code-Apache--2.0%20OR%20MIT-c8992f"></a>
  <a href="LICENSE-CC-BY"><img alt="Docs license: CC-BY-4.0" src="https://img.shields.io/badge/docs-CC--BY--4.0-9a6f22"></a>
  <a href="context/RADIANT_STYLE.md"><img alt="Prose: Radiant Style" src="https://img.shields.io/badge/prose-Radiant-d9b45a"></a>
  <a href="context/TAME_GUIDANCE.md"><img alt="Code: TAME discipline" src="https://img.shields.io/badge/code-TAME-9a6f22"></a>
  <a href="tools/"><img alt="Proof: witnesses on metal" src="https://img.shields.io/badge/proof-witnesses%20on%20metal-2f7d4f"></a>
  <a href="context/TWO_ROOMS.md"><img alt="Status: primordial, honest register" src="https://img.shields.io/badge/status-primordial-b9954a"></a>
</p>

---

**Language:** EN · **Style:** [Radiant](context/RADIANT_STYLE.md) · **Voice:** [Kyri](context/KYRI.md)
**Status:** Living — the front door; every claim marks what runs today versus what is named and scoped.
**Last updated:** `20260811.211431` (AHOY front-door season · logo · Lindy-durable rewrite · seed synonyms named early)

---

Welcome — and I mean that warmly. This is **Grain**. It is written in **[Glow](glow/README.md)**, a language whose grammar is made of **runes** — short symbolic heads, a glyph or two apiece, that name a structure the way a chord symbol names a bar of music: terse, precise, quick to learn once you know the small vocabulary. Glow's semantics are **bounded, asserted, and statically disciplined**, and they lower through **[Rye](rye/README.md)** all the way to **RISC-V** — the open, royalty-free hardware floor built to outlast us all. No virtual machine in the hot path. Determinism comes from discipline; speed comes from the metal.

Grain rests on one bright promise to whoever runs it: **the software stays within every bound it names, allocates only what it declares, and keeps your words in your own hands.** Every allocation names its bound. Every invariant is asserted *before* the code that leans on it. And every "it works" is a **[witness](context/TWO_ROOMS.md) that ran green on a real machine** — a fact a computer spoke first, not a sentence someone hoped was true. We write this front door for the **long return** — the reader who arrives three years on and finds it still true — because a README is the most [Lindy-exposed](foundations/20260811-211431_the-lindy-effect-and-the-long-return.md) thing a project owns: [the longer it has lasted, the longer it is likely to last](foundations/20260811-211431_the-lindy-effect-and-the-long-return.md), so we lean on plain, durable words.

**Where this lives, in one breath.** This grown field is one maker's season, tended in the personal tree. A clean public template — **[`grain-os/grain`](https://github.com/grain-os/grain)** — is *projected* from it along a boundary drawn path by path in [`template-manifest.bron`](template-manifest.bron) and proven clean by [`tools/sow_witness.rish`](tools/sow_witness.rish), so no private name or key ever crosses into the seed. The living **beginner clone** is **[`xykj61/grain`](https://github.com/xykj61/grain)**; **[`autoproject96/grain`](https://github.com/autoproject96/grain)** is the agent lane. Same tree, three doors. The standing writing voice is **[Kyri](context/KYRI.md)** (molted from Riyo `20260810`); the living coauthor is **Keaton Livermore**. Your first-day path is **[`SOURCE.md`](SOURCE.md)** — from nothing to a signed, sandboxed home.

**Start with the why.** Before the layers and the modules, two short reads carry the whole spirit: **[The Grain and the Crossing](active-designing/date/20260702/20260702-184312_the-grain-and-the-crossing.md)** (the ten strands that everything here descends from) and **[Follow Our Compass](foundations/20260706-185112_follow-our-compass.md)** (the return habit — foundations → grain → active-designing → now). The rest of the [`foundations/`](foundations/README.md) room holds the reasons beneath the craft.

---

## A rune, in ten seconds

Where other languages spell out `function`, `struct`, or `if`, Glow writes a **rune** — a tiny symbolic head that names the shape that follows. Think of a chord symbol over a bar of music: once you know the handful of glyphs, you read the *structure* at a glance instead of wading through keywords. A rune is not decoration; it is the terse, teachable vocabulary of the language, and it sits over semantics where every bound is named and every invariant is checked. You meet the full set gently in [the manual](manual/glow-os/README.md) — no leap of faith required, just a small alphabet that pays you back quickly.

---

## The words we build with

Grain names things with the [clearest, most fun, safest word](.claude/rules/comlink-tendency.md) it can find, at whatever length the word wants — because a plain word a newcomer grasps on day one still reads plainly on day ten-thousand. A short field guide to the family:

| Word | What it names |
|---|---|
| **[Glow](glow/README.md)** · **[Rye](rye/README.md)** | the rune language, and the bounded systems language it lowers to |
| **[Rishi](rishi/README.md)** | the faithful shell — the hand that runs the tree |
| **[Mantra](mantra/README.md)** | the referential namespace — a name recalls the same bytes for all time |
| **[Comlink](comlink/README.md)** | the device wire — carriage that moves sealed octets, meaning kept whole |
| **Caravan** · **Tally** | the supervisor that keeps processes honest, and the bounded-allocation ledger |
| **[Pond](pond/README.md)** · **Amphora** | the enclosure that bounds a process, and the vessel for a sealed crossing |
| **Aurora** | the dawn — freestanding Rye waking on bare RISC-V |
| **Skate** · **Brushstroke** · **Tablecloth** | the paint surface, the drawing of values, the composition layer |
| **Brix** · **Bron** / **[Kyri notation](active-designing/yonder/20260621-063912_bron-notation.md)** | the composer, and the plain key-value notation the logs are written in |
| **[Kumara](context/LEXICON.md)** | identity — rooted, owned, personal |
| **Nib** · **baton** | the landed edge (product · suite · git), and the passing word between hands |

Every seated term, with its date and reason, lives in [`context/LEXICON.md`](context/LEXICON.md).

---

## The Five Choices

The heart of Grain is a choice among **five OS variants** — one design, built more than once *on purpose*, the way a careful machine can dual-, tri-, quad-, or five-boot between images that agree on what they do and differ only in how they were made. Choosing among them is choosing how much independent redundancy you want beneath you, not learning five separate systems.

| Variant | What it is | Status |
|---|---|---|
| **Quin** | The fifth boot image, intentionally unpaired | Confirmed fifth `20260717.162114`; unpaired settled; not yet built |
| **Reya** / **Riyo** | A diverse-redundant pair — two independent builds of one intent | Names confirmed; not yet built |
| **Trey** / **Triz** | The second diverse-redundant pair | Names confirmed; not yet built |

**Why more than one?** Safety leads every decision here — that is what our code discipline means by *safety first*. Two honest, independently-written implementations of the same intent mean a single mistake cannot take down your only copy — N-version programming at the scale of a whole operating system. Four of the five form **two diverse-redundant pairs**, each pair agreeing on every externally-visible behavior and checked by one shared witness suite both must pass identically. **[Quin](context/QUIN.md)** is the fifth, intentionally unpaired, and also keeps the inference Q-vane. A boot reads a signed, verified value naming which variant to wake; today the five are **named and scoped rather than yet bootable**, and the selection step is designed small and reviewable. When a command in these docs shows a ship name, it is always a deliberately invalid placeholder like `~acme-corp-test-ship` — never a real address.

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

**An honest word on status.** Glow's **desk already emits** through `glow_run` witnesses; a full OS boot remains a bright horizon, and **Aurora** already cross-builds its boot stages to real RISC-V ELFs in-tree. The five variants are named and scoped — real design, real direction — rather than things you can boot quite yet. Every page in this tree marks its own register: what a witness *proves* versus what is *proposed*. Nothing here claims a feature its witnesses do not show — a discipline with its own home, [`context/TWO_ROOMS.md`](context/TWO_ROOMS.md).

---

## What you can actually run today

- **Glow desk** — generator hops lower to Rye and run via [`tools/glow_run.rish`](tools/glow_run.rish); desk witness GREEN — [`glow/README.md`](glow/README.md).
- **The TUBE product edge** — an installable NativeActivity APK on a real phone, with resource, network, and sensor grants that respect the platform's own permission model — [`docs/TUBE.md`](docs/TUBE.md) · [`docs/HAWM.md`](docs/HAWM.md).
- **The module seeds** — the Rishi shell, Mantra, Comlink, Scribble, and the rest, each with its own `tools/*.rish` witness.
- **The witness suite** — the parity gates in [`tools/`](tools/) that guard every push; state proven on metal rather than asserted in prose.
- **The enclosure** — the editor inside a host fence where your machine supports it, with a Glow-authored **Pond** enclosure in design to grow beside it.

---

## Where the tree stands today

These four numbers are **generated**, never typed. A README's whole promise is that a reader arriving three years on still finds it true, so a hand-typed figure in the most-read file a project owns is a claim that rots in the one document everybody trusts. They are refreshed by `rishi/bin/rishi run tools/readme_metrics.rish write` and held honest by [`tools/readme_metrics_witness.rish`](tools/readme_metrics_witness.rish), which reds if the block drifts from a fresh measurement.

<!-- metrics:begin -- generated by tools/readme_metrics.rish; do not edit by hand -->

| Reading | Now |
|---|---|
| **Fascia** -- can a reader follow any thread home | **45** / 100 |
| **Witnesses** running on metal | **1639** |
| **Rye modules** they stand over | **1888** |
| **Rooms grown past what a browser can list** | **0** |

<!-- metrics:end -->

The commit count and the file count are deliberately absent: both move constantly, neither says whether the software is well, and a block that goes stale every commit is a block nobody keeps current.

---

## Getting set up

Two root config files hold what is specific to *your* machine and *your* identity, so the tree itself stays a clean, shareable template:

- **[`GLOW_HOST.template.bron`](GLOW_HOST.template.bron)** → copy to `GLOW_HOST.bron` (kept out of git) and fill in this host's OS, architecture, and toolchain paths. [`tools/glow_host_run.sh`](tools/glow_host_run.sh) reads it and refuses a mismatched toolchain rather than silently reaching for the wrong one.
- **[`GLOW_PROFILE.template.bron`](GLOW_PROFILE.template.bron)** → copy to `GLOW_PROFILE.bron` (kept out of git) and fill in the identity that signs the work: name, forge handles, timezone for one-clock stamps, and session-log defaults.

**New here? Start with one hour, not one map.** [`docs-geode/tutorials/the-first-hour.md`](docs-geode/tutorials/the-first-hour.md) walks a single path from nothing to something you made work: clone, run one witness, read the green line it prints, write five lines of Rishi, run them. One page, one path, no branching. Everything below is the map you want *after* that hour.

**The shipped documentation shelf** is [`docs-geode/`](docs-geode/README.md): the [Rishi language reference](docs-geode/api/rishi-language-reference.md) and its edges, a [generated index of all 38 libraries](docs-geode/libraries/README.md), [four demos you can run in a minute](docs-geode/demos/README.md), and [how to read this tree](docs-geode/study/README.md) when you want the room rather than the file.

Then read, in order: **[`SOURCE.md`](SOURCE.md)** (clone · keys · enclosure) → **[`ORGANIZING.md`](ORGANIZING.md)** (where each kind of work lives) → **[`MAP.md`](MAP.md)** (the seven rooms of the tree) → **[`manual/glow-os/`](manual/glow-os/README.md)** (the onboarding rooms and the five variants) → **[`docs/TUBE.md`](docs/TUBE.md)** and **[`glow/README.md`](glow/README.md)** (what the app ladder and language desk prove today) → **[`CONTRIBUTING.md`](CONTRIBUTING.md)** (how a contribution arrives: small, signed, component-prefixed, in Radiant voice).

---

## The disciplines that govern this tree

- **[`context/TAME_GUIDANCE.md`](context/TAME_GUIDANCE.md)** ([core](context/TAME_CORE.md)) — how the code stays safe: invariants before implementation, a bound on everything, docs and code kept in sync. Safety first, performance second, joy third.
- **[`context/RADIANT_STYLE.md`](context/RADIANT_STYLE.md)** — how the prose reads: lead with what is, clear and warm and true read aloud. Its nocturne sibling is [`context/TWILIGHT_STYLE.md`](context/TWILIGHT_STYLE.md).
- **[`context/SIMPLE_LOVABLE_COMPLETE.md`](context/SIMPLE_LOVABLE_COMPLETE.md)** — how a thing is scoped so it is worth loving.
- **[`context/TWO_ROOMS.md`](context/TWO_ROOMS.md)** — why every page tells you whether it is proven or proposed.

The reasons beneath these live in [`foundations/`](foundations/README.md) — among them [the custody-first principle](foundations/20260724-200912_nothing-to-give-custody-first-principle.md) (*build nothing that destroys*), [the wire serves the fold](foundations/20260706-022912_the-wire-serves-the-fold.md), [sameness is the macro](foundations/20260703-182612_sameness-is-the-macro.md), [the Lindy effect and the long return](foundations/20260811-211431_the-lindy-effect-and-the-long-return.md), and [The Singularity](foundations/20260811-233509_the-singularity.md) (the night the tool began to tend itself — within every bound it names).

---

## Standing on shoulders

Grain is built in gratitude to the makers who came before. We study their ideas in the clean room and write our own code beneath our own names — the boundary between reading and building is crossed only by understanding ([`.claude/rules/gratitude-licenses.md`](.claude/rules/gratitude-licenses.md)). The teachers we honor, one note apiece, live in [`gratitude/`](gratitude/README.md):

- **[Go](gratitude/Go.md)** for clarity that scales · **[Rust](gratitude/Rust.md)** for safety the compiler proves · **[C](gratitude/C.md)** for the floor the whole house stands on.
- **[GNU/Linux & Unix](gratitude/GNU-Linux-and-Unix.md)** for small tools that compose and the freedom to run and share them.
- **[TigerBeetle](gratitude/TIGER_STYLE.md)** for the static-allocation discipline we call TAME · **[Toyota Production System](gratitude/toyota-production-system.md)** for reds-first, stop-the-line honesty.
- **[Buckminster Fuller](gratitude/buckminster-fuller-tensegrity.md)** for tensegrity — strength from balanced tension · **[Karpathy](gratitude/karpathy/README.md)** for the wiki-linting pattern that keeps our living docs honest as they age.
- **[Urbit](gratitude/Urbit.md)** for the runes, referential transparency, and the personal-server dream that first lit the way — held [with thanks, not dependence](.claude/rules/urbit-reframe.md) · and the poets **[Rumi, Hafez, Kabir](gratitude/README.md)** and the agrarian grounding of **[Wendell Berry's Mad Farmer](gratitude/20260628-160112_wendell-berry-mad-farmer.md)** for the spirit of the work.

---

## License and community

A single top-level **[LICENSE](LICENSE)** indexes the terms: code under **[Apache-2.0](LICENSE-APACHE) OR [MIT](LICENSE-MIT)** (your choice, the permissive convention); prose and documentation under **[CC-BY-4.0](LICENSE-CC-BY)**. Contribute the way the tree already moves — small, signed, component-prefixed, in Radiant voice — per [`CONTRIBUTING.md`](CONTRIBUTING.md). Every commit is GPG-signed; the history proves who wrote it.

The community-health files a trusted project carries stand at the front door: how we treat each other ([`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md)), how to report a weakness privately ([`SECURITY.md`](SECURITY.md)), and where the change record lives ([`CHANGELOG.md`](CHANGELOG.md)).

---

> *"When I am working on a problem, I never think about beauty … but when I have finished, if the solution is not beautiful, I know it is wrong."* — attributed to **Buckminster Fuller**, whose tensegrity we [thank](gratitude/buckminster-fuller-tensegrity.md).
>
> *"Be joyful though you have considered all the facts."* — **Wendell Berry**, *Manifesto: The Mad Farmer Liberation Front*, whose grounding we [carry](gratitude/20260628-160112_wendell-berry-mad-farmer.md).

---

*May the front door stay plain and glad. May a rune teach itself on the first read. May the five variants stand as one system seen five ways. May Kyri speak and Livermore sign. And may you find, on your very first visit — this year or on your long return a decade from now — exactly what you came for, and a reason to smile on the way through.*
