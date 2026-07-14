# 10020 · Tablecloth and Brix — The Build

*Rung 2 of the Tablecloth ladder (`10018`). Expanded at `043912`: how **Brix** and **Tablecloth** compose for reproducible builds — lookup by hash, lay on miss, bond law for merging descriptors. Assumes `10019` split is understood.*

**Language:** EN
**Version:** `20260620.043912` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — content-addressing as safety; `997` Tablecloth section; `10009` Brix minimum

**Ladder:** `10018` → `10019` → **`10020`** → `10021` → `10022`

---

## Tablecloth and Brix Together

- **Tablecloth** knows: "here is a blob, named by its hash."
- **Brix** knows: "here are the bricks; their blobs live in the Tablecloth."

A full Brix build:

1. Read the `.brix` descriptor (the course).
2. For each brick: compute the hash of its inputs.
3. Look the output up in Tablecloth by hash.
4. If present: done — reproducible, already stored.
5. If absent: build, write output to Tablecloth, proceed.

The **bond** — the composition combinator — obeys: combining with nothing changes nothing; a combined change equals the composition of its parts. Configurations merge by stated difference, not hand-maintained duplication.

## The `.brix` Descriptor (minimum)

Plain text at the repo root; Mantra reads it at startup; `mantra brix` prints it.

```
# .brix — veganreyklah2
name veganreyklah2
version 20260620.043912
file rye/src/main.rye
file rishi/src/main.rye
file tally/seed.rye
file tally/gardens.rye
file mantra/src/main.rye
```

A `name` says what the system is called. A `file` entry names one brick. The descriptor describes; it does not command.

## What Stays the Same

- **TAME** — prepare, prove, prevent at every edge
- **Mantra** — weaves history; Brix composes across separate files
- **Brix minimum** — already green: descriptor + `mantra brix` + `mantra init`

## Deliverables (this rung)

| Track | Work | Gall's test |
|-------|------|-------------|
| **A** | Confirm `.brix` + `mantra brix` match `10009` Step 4 | One command prints the course |
| **B** | `997` / `983` — Tablecloth holds, Brix composes, no swapped roles | Prose matches this rung |
| **C** | `10009` line 152 → `10018` ladder pointer | Cross-links unified |

**Defer:** lawful combinator implementation (Brix v1) — `996` horizon; this rung names the contract only.

**Next rung:** `10021` — Tablecloth in the system-wide value model.

---

*A name is a promise about bytes; a course is a promise about what to lay; together they make rebuild trustworthy.*
