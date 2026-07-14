# 10019 · Tablecloth and Brix — The Split

*Rung 1 of the Tablecloth ladder (`10018`). Expanded at `043812`: **Tablecloth** holds and **Brix** composes — two single-stranded modules where one overloaded name once braided store and compose. This rung states the split and the brick vocabulary; build execution is `10020`.*

**Language:** EN
**Version:** `20260620.043812` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — single-stranded; `995` one thing per module; `10018` vocabulary

**Ladder:** `10018` → **`10019`** → `10020` → `10021` → `10022`

---

## The Distinction

Two ideas once shared one module name, and they pulled in different directions.

**Tablecloth** is the general-purpose content-addressed store: an accreting collection of immutable blobs, each named by the hash of its content, never mutated, written once and kept. Mantra's `.mantra/blobs/` is a small Tablecloth. The name is apt: a tablecloth lays artifacts out, named and ready, without hiding what lies beneath.

**Brix** is the composing language: the thing that says *what a system is made of* — how to declare, arrange, and compose pieces into a whole, rather than how to store them. Like bricks — individually simple, shaped to fit together, placed side by side without weaving.

The name honors two teachers (concepts only in active-designing; citations in external-research):

- **Composable derivations** — each brick isolated and reproducible; composition explicit, not implicit.
- **Simple made easy** — simple means single-stranded, not braided. Brix stacks; Mantra weaves within one file's history.

## Brix Vocabulary

| Word | Meaning |
|------|---------|
| **brick** | one composable unit — a file, a program, a derivation, a described system |
| **course** | one row of bricks: the declared parts of a level of composition |
| **bond** | the lawful composition rule: how two bricks connect to form a larger one |
| **lay** | to place a brick in a course, respecting the bond |

## Module Roles (today)

| Module | One job |
|--------|---------|
| **Tablecloth** | Hold artifacts by hash — ledger, not eraser |
| **Brix** | Declare what the system is made of — course of bricks |
| **Mantra** | Weave each file's history — braiding is honest here |
| **silo / siloed** | Design discipline in `active-designing/` — not a store |

In `997`, the composing-language role belongs to Brix; Tablecloth remains the content-addressing substrate.

## Deliverables (this rung)

- Reader can name Tablecloth vs Brix vs silo discipline without conflating them
- Cross-links point at `10018` ladder only
- Active-designing module lists carry **Tablecloth**

**Next rung:** `10020` — how a full build uses both together.

---

*Tablecloth holds what was built; Brix names what to build; siloed prose keeps the room clean.*
