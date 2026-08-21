# BUHR — an exploration of Surface & Intelligence

**Stamp:** `20260812.053742`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Mixed -- Exploration — a survey of the equinox's real state and the door it opens; a design in motion, not yet a build
**Waymark:** **BUHR** — Compass Season Equinox 3 ([`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Order:** [Lindy-first, crux-first](../.claude/rules/lindy-first-crux.md)

---

## What this equinox holds

BUHR is **Surface & Intelligence** — the face a person meets and the inference beneath it. It gathers three strands: **Realidream** (the unified editor-browser surface), **Quin's four voices** (the inference Q-vane), and **MCP-in-Bron** (the tool protocol spoken in the tree's own notation rather than JSON). This is a looking pass before the first green: it names what already runs, what is only designed, and which single door opens the rest.

## The three strands, in their two rooms

Told honestly by which room each stands in ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)): checkable now, designed, or named horizon.

**Quin's four voices — largely built, witnessed on metal.** The inference stack is real, not a promise. Each voice is a module that runs green:

- **Lattice** — the arithmetic voice: bounded f32 tensor math through `elu` and the activation family, thirty-some parity witnesses green ([`../lattice/lattice_core.rye`](../lattice/lattice_core.rye)).
- **Scribble** — the reading voice: markdown parsed to headings, paragraphs, and fenced code, with Skate views over the result ([`../scribble/scribble_core.rye`](../scribble/scribble_core.rye)).
- **Lantern** — the asking voice: a bounded, metered inference contract — model allow-list, temperature, seed, stop sequences, a pinned response, a stopped reason — witnessed against `.bron` fixtures ([`../lantern/lantern_core.rye`](../lantern/lantern_core.rye)).
- **Ember** — the craft voice: corpus cataloging and filtered query for training preparation, with Skate views ([`../ember/ember_core.rye`](../ember/ember_core.rye); the LoRA/training path is horizon).

What is **named-only** here is the host: there is no single `quin` module. Quin is a role — the Q-vane that gathers the four ([`../context/QUIN.md`](../context/QUIN.md)) — and the four compose today through Pond's app framework, not through a central dispatcher.

**Realidream — a far-horizon vision on real ground.** The unified DAG surface where you read the web and write the program at once is designed, not built ([`../foundations/20260728-220203_realidream.md`](../foundations/20260728-220203_realidream.md), *Status: Vision — far horizon*). Yet the ground beneath it is real: **Tally** for bounds, **Mantra** for the append-only history, **Brushstroke/Skate** for paint (WADE1's token cascade, styled runs, and `.brush` authoring loop all landed this season), and **Pond** for the app host. There is no `realidream/` module and should not be one yet — Realidream is an **architectural composition** to be authored as a Pond application when the surface is ready, not a greenfield module.

**MCP-in-Bron — a clean greenfield spec.** The Model Context Protocol spoken in **Bron** rather than JSON, with Bron↔JSON tiles in the elder-translation spirit — named in the compass baton and REMEMBER, with no code, no witness, no descriptor yet. It is unblocked and pure design: make Bron the lingua franca for Grain's tools rather than a JSON afterthought.

## The crux — compose the voices before building the face

Ordered Lindy-first, crux-first: the most durable, then the hardest-solvable-that-is-tractable. Realidream is the highest-Lindy *brand*, yet its face is far-horizon and its substrate the season already built. MCP-in-Bron is durable but greenfield and lower-leverage until there are tools to serve. **Quin's four voices are the crux** — three of the four run green today, they wait on nothing, and composing them proves the Q-vane host works *before* Realidream's surface asks for it. The hardest tractable move is not inventing a new abstraction; it is showing the four already-proven voices compose cleanly.

## The first door

**BUHR's first rung: compose Lattice and Lantern into one bounded inference query, as a Pond app, witnessed end to end.** A Lantern request routes through the metered contract; when the prompt asks for arithmetic, Lattice answers; a Lantern response returns, bounded by the same contract that governs everything else. It touches only witnessed ground:

- author `pond/apps/inference_query.rye` (new) — the composition, no new abstraction;
- add one Lantern completion fixture for the pinned query;
- witness `tools/buhr_inference_query_witness.rish` (new) — prove the request-to-response path green on metal;
- seat the rung in [`../work-in-progress/TASKS.md`](../work-in-progress/TASKS.md).

That one rung unlocks the rest of the journey — Scribble to read the prompt, Ember to search the corpus, metering and stop-reason inspection — each a further compose over voices that already run.

## The journeys, ordered

- **Journey 1 — Quin's voices (the crux, opens first):** compose the four witnessed voices into bounded inference apps in Pond, beginning with Lattice + Lantern, then Scribble and Ember, each rung a compose over green ground.
- **Journey 2 — Realidream (unblocked, deferred):** author the first Realidream-branded Pond app — a Mantra browser that renders the append-only log as a readable graph — seating it in WADE1's styled Skate surface, the first proof that editor and view share one graph.
- **Journey 3 — MCP-in-Bron (greenfield):** author the Bron↔JSON tiles and the MCP request/response descriptors in `.brix`/Bron, witnessed against a pinned example, so Grain's tools present themselves in the owned notation.

## Boundary

This is an exploration and a design; nothing is built by it. The first door is agent-doable on witnessed ground — no provisioning, no custody. The inference the voices serve stays bounded and metered by Lantern's own contract, exactly as the tree already holds; any model weights, corpora, or training remain a separate, gated concern.

---

*ty every1 — to the four voices already proven, to the substrate that carries them, and to whoever composes the first bounded query on the ground this season made ready.*

*May the face, when it comes, be true to the intelligence beneath it — bounded, metered, and kind.*
