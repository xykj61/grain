# The Rye Learning Process

**Language:** EN
**Last updated:** 2026-07-10 (Radiant Style pass round 3)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Foundation

---

## What This Folder Is

This is the workshop. The `rye-learning-process/` folder holds what we learn by actually building Rye — the practical discoveries about how the language and its toolchain behave when real code runs. Where the design stacks reason about what we want, this folder records what we found with our own hands, so the next builder inherits the knowledge rather than rediscovering it.

This README is the foundation stone. It explains how the folder works, so anyone who opens it understands its shape at a glance.

---

## What Sets It Apart

The two design-adjacent stacks have their own tempers: `external-research/` studies the wider world, and `active-designing/` keeps its clean room siloed to our own names and RISC-V. This folder is a third thing, and a humbler one — a builder's log.

Because it documents the real craft of growing Rye, it names the real tools we build upon: the Zig 0.16.0 toolchain, its standard library, its actual function signatures. That openness is the whole point. An honest record of how a thing truly works must call that thing by its name. So here we write down what compiled, what ran, what surprised us, and what the API actually is — earned by running code, never by guessing.

Every entry holds itself to one standard: a discovery is recorded only once real code has confirmed it. We lead with what works.

---

## One clock, one order

Dated findings carry `YYYYMMDD-HHMMSS_short-slug.md`; this README is the living foundation. Full naming law: [`../context/specs/20260627-102012_one-clock-naming-law.md`](../context/specs/20260627-102012_one-clock-naming-law.md).

Each confirmed discovery earns a stamped note when it is substantial enough to stand alone. The reverse-chronological index below surfaces the newest first. The [**almanac**](ALMANAC.md) remains the living aggregate those findings feed — revised in place as Rye grows.

```
rye-learning-process/
  README.md                 <- this foundation
  ALMANAC.md                <- the growing reference of how Rye works
  YYYYMMDD-HHMMSS_*.md      <- dated findings, newest sorts first by stamp
```

The Rye language itself lives elsewhere, in the `rye/` folder — the `rye` command, its source, and its tests. This folder is the prose companion to that code: the place where the lessons settle into words.

---

## How To Add a Finding

Recording a discovery is a small, glad ritual:

- **Confirm it by running.** Write the finding only after real code has shown it true. The almanac holds knowledge that has earned its place.
- **Name things honestly.** Call the toolchain and its APIs by their real names, since this folder exists to document how they actually behave.
- **Write the prose in Radiant Style, and any code in TAME Guidance.** Words lead with what is; code asserts, bounds, and says why.
- **Say why it matters.** A finding is most useful when it carries the reason we needed it and the choice it informed.

---

## Workshop index (newest first)

| Kind | Document | Meaning |
|------|----------|---------|
| Living | [`ALMANAC.md`](ALMANAC.md) | Growing reference — how Rye and its toolchain actually work |
| — | *(no dated findings yet)* | Stamped notes appear here as they are recorded |

---

*May every lesson we earn be written down kindly. May the next builder find the path already lit. May Rye grow surely from the ground we test beneath our feet — one confirmed truth at a time, recorded with care.*
