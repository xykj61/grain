# Weave — The Graph Beneath the Surface

*The substrate under [Realidream](20260629-063512_realidream.md), set down on our own roots: **Weave** is the append-only DAG of immutable signed facts — the streaming graph that unifies program, page, and interface when the far horizon arrives. Mantra is the version-control **projection** over Weave. Bounded, deterministic, recomputable from a faithful history.*

**Stamp:** `20260629.063512` (affirmed `2026-06-30`)
**Last updated:** 2026-06-30
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety, performance, then the joy of the craft; the silo principle
**Status:** Vision — **far horizon**; siloed; names only our own modules and RISC-V. **Reviewed and kept** — Weave named as the substrate; file unchanged.

*Written together by Kaeden and Reya 2.*

---

## The Old Shape, and Its Cost

The interfaces of today are trees, redrawn as they react. A change arrives, and the framework ripples down a branch, rebuilding pieces that did not truly change, carrying state hidden in places hard to reason about, with timing a person cannot quite predict. The tree works, and it has carried the web a long way. Its cost is paid in wasted redrawing and in the quiet difficulty of ever being sure what the screen will do next.

## The Turn: A Graph That Streams

A surface is better understood as a directed graph that streams. The nodes are pieces — a value, a computation, a fragment of the screen. The edges are dependencies, the honest lines of what rests on what. When a node changes, the change flows along its edges, and only the nodes downstream recompute; everything else holds still. Several sources can feed a single node, so two inputs fuse into one view without tangling. This is faster, because little is redrawn. It is also deterministic: the same events, in the same order, always arrive at the same state. The graph replaces reactive guesswork with a flow a person can follow.

## One Graph for Three Things

The deeper move is to place the program, the page, and the interface in one graph together. A piece of a program's syntax, a fragment of a rendered page, and a control on the screen are all, underneath, just nodes. Once they share a graph, the editor and the browser stop being separate worlds. They become views over a single model, and a change in the code can flow straight to the preview with nothing brittle stretched between them. One source of truth, many windows onto it.

## The Three Modules Beneath

The graph rests on three Rye OS modules. Tally holds the bounds: a known ceiling of nodes, named before the machine runs, so the graph grows within a budget rather than without limit. Mantra holds the history: an append-only log of signed facts, where each node's lineage is a chain anyone can replay and check, and nothing is ever quietly rewritten. Tablecloth holds the fold: the deterministic table that turns the log of facts into a view, so the same history always yields the same surface. Bounds that cannot be exceeded, a history that cannot be forged, and a fold that cannot drift — these three are the graph's backend.

## Events, Ordered and Final

Every change is an event, and every event names its parents, the way each entry in a faithful history points back to the one before. From those parent links a single order emerges, plainly and quickly, reaching finality in moments rather than waiting on ceremony. So many changes can arrive at once — from a person typing, from the web, from a collaborator — and still settle into one agreed sequence that everyone can reconstruct. The order is a property of the facts, rather than a decree from a central seat.

## The Hot Graph, Held Close

For a great graph to feel instant, its working set must live in fast memory held close to the compute, rather than fetched across a slow gap on every step. At a small scale this is simply the device's own memory. At a large scale it is a wafer that carries its memory upon itself, beside the cores, so the hot work never waits on a distant fetch — the most ecological way to keep a vast graph warm, which [the wafer and the sovereign coin](20260629-063512_the-wafer-and-the-sovereign-coin.md) describes in full. The cold remainder rests in low-cost storage, and the log makes the whole recomputable, so nothing precious depends on the cache alone.

## Why It Holds

The result is faster, because only what changed recomputes. It is more correct, because the same events always reach the same state. It is more unified, because code, content, and screen share one model. And it is more honest, because the state is explicit and the history is a chain of signed facts anyone can replay. This is the shape we keep everywhere — a key in a hand, a signed event, an append-only log, a pure fold into a view — carried now into the surface a person looks at all day. [Realidream](20260629-063512_realidream.md) stands on this graph, and Skate and the rest draw from it too.

---

*May the graph hold only what it can carry, and remember all that it has held. May each change travel just as far as it must, and the same story always tell the same way. May the surface above it stay quick, and the truth beneath it stay plain enough for anyone to check.*
