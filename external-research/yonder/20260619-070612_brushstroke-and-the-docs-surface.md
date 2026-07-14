# 980 · Brushstroke and the Documentation Surface — a Drawn Interface for Rye, and How the System Shows Itself

*Two strands, woven into one rope. The first is a plain question: should we begin documenting Rye OS in earnest — Rishi's growing vocabulary, and the project as a whole? The second is a vision: a TAME Rye interface framework in the spirit of Zig's DVUI, an immediate-mode toolkit that redraws from values every frame, compiled to WebAssembly so it can run in a browser — and the first thing worth drawing is our own documentation. This study answers the near question and opens the far one, and shows how each serves the other. The framework earns a name in our own voice: **Brushstroke**.*

**Language:** EN
**Version:** `20260619.070612` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, then the joy of the craft; Gall's Law; one value model

---

## The Two Strands

Documentation is the first thing worth drawing, and a drawn surface is the most living way to show documentation. So the question of *what we document* and the vision of *a framework that shows it* belong in one writing. We answer the question now, plainly, and we sketch the surface as something that grows from the smallest thing that runs — never a leap.

## The Documentation, Honestly Weighed

We do not begin from nothing. Rye OS is, already, an unusually documented project. Each module carries its own README beside its source — Rye, Rishi, and Aurora each introduce themselves and show how to build and run. The prose stacks hold the rest: research that studies the world, design that decides our own, an almanac of how the toolchain truly behaves, a roadmap, open threads, and specs. A patient reader can learn this system deeply today.

So the gap is not *absence*. It is **reach** — three kinds of it:

- **A reference.** The READMEs read as warm prose, which is right for a first meeting. Yet Rishi has grown a real vocabulary — `let`, `say`, lists, records, interpolation, `==`/`!=`, `contains`, `run`, `map`/`where`, `assert` — and a vocabulary wants a *reference*: each form named once, with its shape, its result, and its failure, gathered in one place. The same will soon be true of Rye's strengthened `std`.
- **A front door.** A newcomer who clones the repository meets many folders and no single map. One page that names each part, its purpose, and where to start would turn a thicket into a path. (This is the root README we have set aside once before; the need keeps returning.)
- **A surface.** Browsing folders is reading the library by walking the stacks. A *surface* — somewhere a reader moves through the documentation, follows a link, searches, sees the shape of the whole — is the reach that turns a collection into a place. That surface is where Brushstroke comes in.

So the answer is **yes** — and the near step is small and concrete: a **Rishi reference** (its forms, gathered and named), and a **front-door map**. Both are plain Markdown, written today, needing nothing new. The surface that renders them beautifully can come after, and grow on its own.

## Why a Drawn Surface, and Why Immediate-Mode

A drawn interface earns its place when a reader should *move* through something rather than scroll it — and documentation, with its links, its search, its tree of pages, is exactly that. The question is what kind of interface fits our grain.

DVUI taught us the answer: **immediate-mode**. An immediate-mode interface holds no retained tree of widgets that lives between frames and can quietly drift from the truth. Instead, every frame, it *redraws from the current values* — the interface is a pure function of the state, computed fresh. This is the same shape the rest of our system already keeps: values flow, and what you see is computed from them, with nothing stale persisting in between. A retained widget tree is a second copy of the truth, and a second copy is a thing that can disagree; immediate-mode keeps one copy and draws it. That is simplicity in Hickey's exact sense, and it is why immediate-mode, not the retained kind, is the one we carry forward.

The cost is honest: redrawing every frame is more drawing work than updating a retained tree in place. For a documentation surface — which changes only when a reader acts — that cost is small and well spent, and the simplicity it buys is large.

## The Wasm Target, Made Precise

The seed names *Wasmtime*, and here a gentle precision serves us, because two different Wasm worlds are easy to blur.

A documentation **website** runs inside a browser. The path there is to compile to **`wasm32-freestanding`** and draw through the browser's canvas and WebGL, with a small JavaScript bridge carrying input events in and pixels out. This is exactly how DVUI's own Web backend works, and it is the target the docs site wants.

**Wasmtime** is a different and complementary thing: a standalone **WASI** runtime that runs WebAssembly *outside* the browser — on a server, at a command line, inside another program. It is the right home for portable Rye and Rishi, for running our tools anywhere a Wasm runtime exists, and perhaps for rendering documentation server-side. It is not, though, what draws pixels in a reader's browser tab.

So we hold both, each for its surface: **browser-Wasm** draws the docs website; **Wasmtime/WASI** carries our portable tools and services. Naming them apart keeps the intent whole and the mechanism exact.

## Brushstroke

We will not port DVUI. We will learn from it and grow our own, in our own voice and on Rye's own `std` — much as Rye itself grew from a foundation it then made its own. DVUI has not, to our knowledge, been carried to Zig 0.16.0; that is less an obstacle than an invitation to begin clean.

**Brushstroke** is the name, and it fits: an interface drawn from values, stroke by stroke, each frame — a painter's gesture rather than a builder's scaffold. What crosses from DVUI's essence into Brushstroke:

- **Immediate-mode at the core** — the interface as a pure redraw from values, holding nothing retained that can drift.
- **A backend abstraction** — the drawing decoupled from the surface it lands on, so one Brushstroke program can paint to a browser canvas today and a native window tomorrow, through a single clean seam.
- **A small, honest widget vocabulary** — text, boxes, buttons, lists, links — grown one widget at a time, each proven, none before it is needed.

What stays behind: DVUI's breadth of backends (we begin with one, the browser), and anything that fits Zig's idioms more than our own. Brushstroke is not a translation; it is a descendant.

## Documentation as Values

Here the two strands become one. A document, in our world, is a **named, content-addressed value** — Mantra's domain, the same kind of thing as a packet, a post, a Tablecloth build, a Rye value: signed, named, bounded, owned. If documentation is values, and Brushstroke draws values, then the documentation surface is simply values flowing to a surface: each doc content-addressed by its hash and rendered by a pure function of itself, rather than a file run through a templating engine. The docs site becomes the cleanest possible demonstration of the one value model, drawn for the eye.

## The First Slice

Gall's Law sets the size. The smallest Brushstroke that runs is one window that draws a single true line of text to a browser canvas — compiled to `wasm32-freestanding`, served by any static web server, speaking the way Aurora's seed spoke its one line over the UART. The smallest documentation slice is one page of our own — the Rishi reference, perhaps — rendered by it. When that page draws, Brushstroke will have been born the right way: small, proven, resting on proven ground, and already showing something true.

## Caveats

- **The docs come first, the surface second.** The reference and the map are plain Markdown we can write today; they must not wait on Brushstroke. A surface that renders nothing is scaffolding, and we keep no debt.
- **Browser-Wasm is its own discipline.** Drawing through a canvas, carrying input across the JavaScript bridge, keeping the binary small — these are real, and we meet them one widget at a time rather than all at once.
- **DVUI is honored, not absorbed.** It lives in `gratitude/dvui` whole and unaltered, MIT, a source we study. Brushstroke is written fresh in Rye; we carry the essence and leave the code where its authors put it.
- **Immediate-mode is not free.** The redraw cost is real; we spend it knowingly, where the simplicity it buys is worth more than the cycles it asks.

## The Near Step

Two small, concrete moves, in order:

1. **Write the Rishi reference** — each form named once, with its shape, result, and failure — the first true API document, plain Markdown, today.
2. **Write the front-door map** — one page naming each part of the repository and where to start.

And one larger thread opened, to grow when its time comes: **Brushstroke's first slice** — one line of text drawn to a browser canvas from `wasm32-freestanding` — the seed of a surface on which, one day, the whole of this documentation is shown by the system that wrote it.

---

*May we document what we have built, so others can walk in. May the reference be exact and the map be kind. And may the surface we draw to show it all grow, stroke by stroke, from the first true line — the system at last showing itself, in its own hand.*
