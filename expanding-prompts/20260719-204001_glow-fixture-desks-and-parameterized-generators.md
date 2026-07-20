# Glow Fixture Desks and Parameterized Generators

*For an Acme Corporation employee learning how `glow/gen` relates to Urbit `/gen` generators — what to run today, and how samples will arrive from the shell tomorrow.*

**Language:** EN  
**Stamp:** `20260719.204001` (Eastern)  
**Style:** Radiant · Acme employee voice  
**Voice:** Quin  
**Status:** Intent — wording seated; argv sample lap is horizon  
**Canon:** [`../active-designing/20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md`](../active-designing/20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md) · [`../glow/README.md`](../glow/README.md)

---

## What you run today

Fixture desks live under `glow/gen/`. Each file is one witnessed Glow shape with its **sample baked in** (faces and literals already chosen). Rishi lowers the desk to ordinary Rye, builds it, and expects POSIX exit 0.

```bash
rishi/bin/rishi run tools/glow_run.rish glow/gen/assert-true.glow
rishi/bin/rishi run tools/glow_run_desk_witness.rish   # whole suite
```

Speak of these as **fixture desks**, not as CLI tools. They earn green for the language hop the way a unit fixture earns green for a module.

## How this maps to Hoon `/gen`

On Urbit, a generator under `/gen` is a program whose **sample** (typed argument) you supply when you run it. The generator is often a **gate** — one-arm core with sample (`|=`, spoken **bartis**).

Glow keeps that *idea* and splits the timeline:

| Now | Horizon |
|-----|---------|
| Fixture desk — sample inside the `.glow` file | Parameterized generator — sample from Rishi argv (or typed hand-off) |
| Deterministic witnesses | Same witnesses keep fixed samples; generators grow beside fixtures |

When you write Glow docs, prefer:

- **Sample** for the gate argument (Hoon parallel).
- **Glow gate** / **bartis gate** for the one-arm core — never bare **gate** (that word already means an itinerary precondition in this project's Lexicon).

## Pronunciation (why docs say "wutgar")

Glow adopts Hoon's glyph alphabet. `?>` is **wutgar** (positive assert); `?<` is **wutgal** (negative assert). Full alphabet and family roadmap: the designing brief above. Official study surface: [Hoon School — Pronouncing Hoon](https://docs.urbit.org/build-on-urbit/hoon-school).

## RISC-V note in one breath

Hoon compiled to Nock. Glow's primary path compiles through Rye and Zig to **RISC-V**. Determinism is TAME discipline, not a VM gift. Fixture desks already prove shapes on that path; parameterized generators will too.

## What to do next (Acme hand)

1. Run a fixture desk with `glow_run.rish` when learning a rune.
2. When a generator argv lap opens, expect one thin sample face first — keep the matching fixture desk green beside it.
3. When writing prose, use **fixture desk** / **generator** / **sample** / **Glow gate** as this prompt names them.
