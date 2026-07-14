# Glow, Accepted — and the Four Kernel Variants Amended

**Language:** EN
**Version:** `20260713.225658`
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Amendment to `20260713-224212_glow-and-four-kernel-variants-naming-research.md` and `20260713-214400_urbit-parallel-naming-mapping-proposal.md` — still no rename committed

---

## Glow Is Accepted, With Its Reasoning Named Plainly

Kaeden's ruling: keep **Glow** as the fused Rye-Hoon language's name, and frame this fork's relationship to the existing Glow Language project as **fulfilling its vision, not competing with or overwriting it**. The reasoning, as researched:

- **Glow-Lang/glow** was created 2021-08-26; no recent commit activity is visible as of this research, and its own whitepaper dates to 2020 — consistent with Kaeden's read that the project is dormant, though this document has not independently confirmed an exact "11 months" figure down to the day, only that no recent activity signal was found.
- **Glow's own implementation leans on Scheme** (Gerbil Scheme, per the Glow-Lang organization's related `glow2-haskell` and `sexpr-parser` sub-repositories, which point at an S-expression-rooted toolchain) — a dynamically-typed, unbounded-recursion-friendly Lisp family member, structurally incompatible with TAME's bounded, asserted, statically-disciplined root rules in the same way this project's own Nock/Hoon fusion scoping doc already named for Hoon itself.
- **The frame that resolves the naming tension**: Glow's own stated mission — a safe, portable, auditable language for building trustworthy decentralized systems — is exactly what this fork's TAME-disciplined fusion of Rye and Hoon is *for*. Continuing the name under a TAME-strict, actively-maintained implementation carries that mission forward rather than abandoning it to Scheme's looser guarantees. This is a real act of gratitude-in-naming, in the same spirit this project already extends to `gratitude/`'s held-whole sources — except here, the gratitude is expressed by finishing the work, not merely crediting it.

## The Architecture, Clarified

Kaeden's ruling resolves the open architecture question from the prior research doc: **there is one language, Glow — governed by one TAME Guidance document, since TAME itself is deliberately a single document, not four.** The four names are not four languages; they are **four kernel/system variants, all written in Glow**, switchable the way a machine can dual/tri/quad-boot between them.

- **Riyo** and **Reya** are one design, implemented twice, independently, as **diverse redundancy** — the same engineering principle behind N-version programming: two honest, separate implementations of the same intent reduce the chance that a single implementation mistake takes down the only copy. Kaeden named this directly as aligned with TAME's own safety-first ordering. This fork should treat Riyo and Reya as siblings that *may* drift in internal detail but must agree on external behavior — a natural fit for a shared witness suite that both must pass identically.
- **Trey** and, replacing the collision-risking **Tera**, **Triz** — the second pair. This document proposes, but does not yet confirm on Kaeden's behalf, that Trey/Triz follow the same diverse-redundancy pairing as Riyo/Reya, for symmetry; Kaeden's own words named the Riyo/Reya relationship explicitly and did not yet say the same of Trey/Triz.

**`Triz`, checked fresh in this pass:** no operating-system or kernel collision, but a real, recognizable soft collision — **TRIZ** (Theory of Inventive Problem Solving), a well-established engineering-innovation methodology with active current tooling (`triz-ai`, `pytriz`, both seeing releases as recently as this year). This is a lower-stakes collision than Glow's — no one will mistake a kernel variant for a patent-analysis methodology — but it is real enough to name plainly rather than let Kaeden discover it later. Lower risk than `Tera`'s near-miss with `Terra`, and this document leans toward accepting `Triz` on that basis, without deciding for Kaeden.

## What Remains Open

- Confirm whether Trey/Triz mirror Riyo/Reya's diverse-redundancy relationship, or serve some other purpose entirely.
- Decide whether "diverse redundancy" here means two independently-written codebases from one shared spec, or one codebase with two independently-verified compilation/execution paths — a real engineering choice with different costs, not yet made.
- No file, module, or language has been renamed by this document. Glow, Riyo, Reya, Trey, and Triz remain proposals.

---

*May the name we finish carry the vision further than the name we might have let rest, and may every redundant pair we build stay honestly independent, never secretly the same thing twice.*
