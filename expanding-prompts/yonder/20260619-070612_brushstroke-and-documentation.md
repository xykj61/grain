# 10004 · Documentation, and a Drawn Surface for Rye

*Expanded from a seed with two strands woven together: a question about documentation, and a vision for the surface that could carry it. The seed asks whether to begin Rishi's API documentation and the project's documentation in general. It carries, alongside, an idea — a TAME Rye interface framework in the spirit of Zig's DVUI, an immediate-mode GUI toolkit, compiled to WebAssembly so it can run as a web app, beginning with a documentation website. The framework wants a name in our own voice; the seed offers **Brushstroke**. This prompt reads that seed closely and lays out the research to run.*

**Language:** EN
**Version:** `20260619.070612` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, then the joy of the craft; Gall's Law; one value model

---

## The Seed (a faithful echo)

Should we begin Rishi's API documentation, and documentation for the project in general? And, carried alongside: I am drawn to a TAME Rye version of Zig's **DVUI** framework — an immediate-mode GUI toolkit — that can be compiled to **WebAssembly** (the seed names **Wasmtime**) so it runs as a web app, for example a documentation website. DVUI, to my knowledge, has not yet been ported to Zig 0.16.0. If we clone it into `gratitude/` for study, we can begin our own module in its spirit: a drawn interface in our own voice, named **Brushstroke**, rather than DVUI in Zig. Let this become the next external-research writing.

## The Mission

To decide, plainly, how Rye OS documents itself — and to open the design of the surface that will one day show it. The two strands are one rope: documentation is the first thing worth drawing, and a drawn surface is the most living way to show documentation. The mission is to answer the near question (do we document now, and how) while sketching the far one (a UI framework of our own, **Brushstroke**, that renders our docs as a web app), and to make sure each serves the other rather than waiting on it.

## Research Questions

1. **The documentation, honestly weighed.** What documentation already exists — the per-module READMEs, the numbered prose stacks, the ALMANAC, the specs — and what is genuinely missing? Is the gap a *reference* (Rishi's builtins and grammar, Rye's strengthenings named one place), a *map* (a single front door to the whole repository), or a *surface* (somewhere a reader can move through it all)? Name the smallest documentation that would help a newcomer most.
2. **Why a drawn surface, and why immediate-mode.** What does an immediate-mode UI — one that redraws from values every frame, holding no retained widget tree that can drift from the truth — offer that fits TAME and our one value model? Where is the cost (redraw work) and where is it worth paying?
3. **The Wasm target, named precisely.** A documentation *website* runs in a browser, which means `wasm32-freestanding` with a small bridge to the canvas (DVUI's own web path). **Wasmtime** is a WASI runtime that runs Wasm *outside* the browser — a server, a CLI, a portable tool. Which target serves the docs site, and where does the other belong (portable Rye/Rishi, server-side rendering)? Draw the line so the seed's intent is honored and the mechanism is exact.
4. **DVUI's essence, and what crosses into Brushstroke.** What of DVUI is worth carrying — immediate mode, the backend abstraction that decouples drawing from platform, the widget vocabulary — and what stays behind (its retained pieces, its breadth of backends, anything that fits Zig more than our own ground)? What would **Brushstroke** be, stated in our own voice, on Rye's 0.16-derived `std`?
5. **The first slice that draws something real.** Following Gall's Law, what is the smallest Brushstroke that runs — a single window that draws one true line of text to a canvas in the browser? And the smallest docs slice — one page of our own documentation, rendered by it?
6. **Documentation as values.** If a doc is a named, content-addressed value (Mantra's domain), and Brushstroke draws values, then the docs site is values flowing to a surface. Does framing documentation this way — rather than as files to be templated — make it simpler and more honest?

## Deliverables

- **Clone `dvui` into `gratitude/`** (shallow), with a README entry recording its lineage, its web/WebAssembly backend, and its license — honored as a source, studied, never vendored into our own code.
- **An external-research writing (`980`)** in Radiant Style, citing DVUI plainly, that weighs the documentation question and opens the Brushstroke design — the drawn surface, the Wasm target made precise, and the first slice.
- **A clear answer to the documentation question**, with a concrete near-term first step a person could take tomorrow.

---

*May the seed be heard in full — both the near question and the far vision. May we document what we have built so others can enter it, and may the surface we draw to show it grow, like everything here, from the smallest thing that runs.*
