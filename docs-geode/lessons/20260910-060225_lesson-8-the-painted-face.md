# Lesson 8 -- The painted face

**Language:** EN - **Style:** [Bhakta](../../context/BHAKTA_STYLE.md) with [Kyri](../../context/KYRI.md) and [Radiant](../../context/RADIANT_STYLE.md) - **Voice:** Kyri
**Stamp:** `20260910.060225` - **Status:** Living - **Room:** mixed -- Brushstroke's modules are written; the platform above them is **design**
**Index:** [`README.md`](README.md) - **Back:** [Lesson 7](20260910-060225_lesson-7-dawn-and-kernels.md)

Foundations say why a surface should exist. Active-designing says how this one wants to be drawn.
Gratitude names the teachers.

---

## Show it, then name it

You already know a **shell**: Rishi, where you type and the machine answers in letters.

A **surface** is the same conversation in light. Pixels. A grid of cells. A window you can see.

The stack of seeing has names, one per layer, on purpose:

| Name | Job | Room |
|---|---|---|
| **Brushstroke** | The drawn surface underneath -- pixels, a grid, a window on the glass | Module `brushstroke/`, much of it already in Rye |
| **Skate** | The platform that *paints the graph* so a person can see and steer | Design |
| **Realidream** | One branded face: editor and browser over a single graph | Vision |
| **Surf** | A small social application *for* Skate, rather than the platform | Design |

The pipeline reads:

> State lives in the graph. Skate draws it. Brushstroke is the drawn surface underneath.

A **DAG** here is a directed acyclic graph: pieces of fact pointing at what they depend on, never
looping back.

**Surf and Skate are peers over one referent**, seated in `.claude/rules/alias-sameness.md`: several
lawful names, one thing, no wrapper and no second implementation. Keeping the *platform* and the
*application* named apart is the other half of that discipline.

---

## Brushstroke: the cloth

Open `brushstroke/` and you meet dozens of Rye modules: crop, filmstrip, photo edits, image decode,
a parse for the brush, a display seed.

A window essay in this tree counts **72 Rye modules driving Wayland natively** -- their own pixel
buffers, a surface, shared memory. That belongs in the running room as *work already written here*.

A second probe on macOS reused the same grid module, rasterised a grid, and counted lit glyph
pixels. **Same grid logic, different glass.** The design is language-independent: a bounded grid,
refusal before mutation, whole-state kept when a change is refused.

You met a cousin in Lesson 4: a bounded proof frame with palette seats and walls you can see.

**Wayland**, said once: a way a program talks to the screen on many Linux desks. Grain speaks it
from Rye rather than borrowing a giant toolkit as the *model*. Toolkits remain elders. The cloth is
this tree's own.

---

## Why a face at all

One surface for two loves: reading the living web and writing the living program, over **one graph**.
Reality: bounded, deterministic execution. Dream: open making.

Beneath it is a graph of immutable signed facts, appended rather than overwritten. Nodes are pieces
-- a value, a computation, a fragment of screen. Edges are dependencies. Change flows along edges,
and downstream nodes recompute only.

**The face is a view of that flow, rather than a second universe of state.** This is custody for
seeing: what you look at is what the graph holds, and what you steer writes a new fact.

---

## How this tree *designs*

`active-designing/` holds **proposals** until a gate and a witness say otherwise. They still teach,
because they show the questions asked before code accretes.

**One name per layer, and both names are loved.** Mixing the platform and the application would make
the graph harder to see.

**See the change in the same breath.** The essay thanks Bret Victor's *Inventing on Principle*: a
creator needs to see the effect the moment the change is made. Live reload under TAME -- edit a
page, the surface repaints, **a witness strip repaints beside it.** Joy third, after the strip stays
honest.

**Profiles as data.** A parsed record rather than evaluated code. Safety first. Palette, timing and
density live there, and a header declared once stays the same across pages -- *sameness as the
macro*, arriving on the face.

**Animation with a zero.** A one-second motion on load, configurable, falling to still for a reader
who wants quiet. **Falsifiable:** if it reads as delay on a named day, the number goes back. Design
that can lose is design that can learn.

**First constructive step, SLC-small:** one page, one walking skeleton, one profile, hot reload
proven with one witness beside it.

---

## Gratitude: teachers, rather than cargo

**DVUI**, an immediate-mode GUI in Zig, MIT-licensed, is studied. *Immediate-mode* means the program
describes the face each frame from state, rather than keeping a long-lived tree of widgets in sync.
The licence allows reading and porting with attribution; the discipline here still writes its own.
**Concept study, fresh cloth.**

**DJINN** lends two *ideas*: character-grid drawing with density ramps, and a tune-and-export loop
that writes the numbers back into a file.

**Bret Victor** for the breath between edit and sight. **Wayland and AppKit** as the world's glass:
seams, rather than the model.

Foundations asked for grace as the ground. This is that grace on the design bench: **name the
teacher, silo the idea in our voice, keep their files whole.**

---

## The method, stealable for any next page

1. **Ask what the work is for** (`foundations/`).
2. **Name the layers** so two loves stop crushing each other.
3. **Bound the surface** -- a grid with a width, a profile that is data, a refusal that preserves the last good whole.
4. **Show the change beside a witness.** Sight without a check is theatre; a check without sight is a chore.
5. **Ship a walking skeleton.**
6. **Leave the rest at the gate.**

---

## Two Rooms on the easel

**Closer to running:** `brushstroke/` as a large Rye body with a native display path and grid tests;
a window probe painting Grain's own buffer; a bounded frame; the graph modules underneath.

**Still designing:** the full platform with hot reload and a witness strip on every page; the daily
face over it; the social application on top; profiles as the ordinary way a person publishes.

You can love the design pages as compass, and trust the probes and modules as metal. **Mixing those
without a label is how a face starts lying about what it can already show.**

---

## A picture

The graph is a loom in the next room. Skate is the window cut in the wall. Brushstroke is the glass.
Realidream is the name painted on the frame when the house is ready for guests. Surf is a single
vase on the sill -- complete, small, wanted.

**You do not start with the vase city.** You start with one pane that holds, and a witness that says
the pane held.

---

## Reading for tonight

1. The Realidream foundation -- why one surface.
2. The graph-beneath-the-surface foundation -- what the surface is *of*.
3. The Skate design essay in `active-designing/` -- the layers, and the first small step.
4. The window essay -- a window as a lap.
5. A walk through filenames in `brushstroke/`. **Show, then name.**

If a sixth page wants you, open `context/SIMPLE_LOVABLE_COMPLETE.md` again and ask the three
questions of *one page* of the surface.

---

## Where the lessons leave you

Eight walks: the house from above, the front door, the why, joy's rank, the order itself, two
pockets honestly priced, dawn and kernels, and the painted face.

**What carries forward is one habit.** Show the thing, then name it. Say whether it runs or is
drawn. Name the bound before you pick the apples. Name the teacher whose year you stood on.

The hands come next, in [`../tutorials/the-first-hour.md`](../tutorials/the-first-hour.md).

*May the door stay open, and may your first green be gladder for the map.*
