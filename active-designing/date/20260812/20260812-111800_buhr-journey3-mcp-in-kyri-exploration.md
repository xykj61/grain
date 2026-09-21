# BUHR Journey 3 — MCP-in-Kyri, an exploration

**Stamp:** `20260812.111800`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Mixed -- Exploration — a design in motion for BUHR's third journey; nothing built by it
**Waymark:** **BUHR** — Compass Chapter Equinox 3 ([`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Order:** [Lindy-first, crux-first](../.claude/rules/lindy-first-crux.md)

---

## Where the journey stands

BUHR's first journey composed Quin's four voices under one bounded host, each rung green. Its second journey rendered Mantra's append-only log as a readable revision graph and painted that same graph onto WADE1's styled Skate surface — editor and view proven to share one graph. Both journeys composed over ground the season already made real. The third journey opens a genuinely new door: **the Model Context Protocol, spoken in Kyri rather than JSON.**

## What MCP-in-Kyri is, and is not

The Model Context Protocol is how a host and a tool describe themselves to each other — a tool announces its name, its inputs, its output shape; a caller sends a request naming a tool and its arguments; the tool returns a result or an error. The world speaks this in JSON. Grain already owns a plainer notation for exactly this kind of structured description: **Kyri** (`format …`, one key-value field per line, no braces, parsed rather than evaluated — [`yonder/20260621-063912_kyri-notation.md`](yonder/20260621-063912_kyri-notation.md)). MCP-in-Kyri makes Kyri the lingua franca for Grain's tools, with Kyri↔JSON tiles in the elder-translation spirit so the two worlds still meet.

This is **not** a new transport and not a new abstraction. Mantra already carries a bounded request/response protocol over a store (`mandate/serve.rye` — a `QueryRequest`/`QueryResponse` pair serialized to bounded bytes a Comlink transport carries). MCP-in-Kyri reuses that discipline: a request and a response are Kyri records with named, bounded fields, and the tool that answers them is an ordinary bounded Rye function. What is new is only the *shape of the description* — a tool manifest and a call envelope, written in the notation the tree already owns.

## The three rooms

Told honestly by which of the two rooms each part stands in ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)):

- **Checkable already** — Kyri parsing (the Rishi interpreter reads Kyri fields), the bounded request/response pattern (`mandate/serve.rye`), and the per-key override cascade (`brix/infuse.rye`) that a tool manifest can inherit defaults through.
- **Designed here** — the MCP-in-Kyri *descriptors*: a `format mcp-tool-v1` manifest (tool name, one line per named argument with its value model, a result shape) and a `format mcp-call-v1` envelope (tool name, argument values, a request id) with its paired `format mcp-result-v1` (id, result record or a named error).
- **Named horizon** — the Kyri↔JSON tiles that let a Grain tool present itself to a JSON-speaking MCP host and read a JSON call back, so the owned notation meets the world without either side bending to the other.

## The crux — the descriptor before the tile

Ordered Lindy-first, crux-first. The most durable artifact is the **descriptor shape itself** — the `.kyri` formats a thousand future tools will be written in; a manifest is read far more often than any one tile runs. The hardest tractable move is not the JSON bridge (which is a mechanical translation once the shapes are fixed); it is defining a tool manifest and call envelope in Kyri that are **bounded, value-model-honest, and round-trippable** — every field a string, integer, bool, list, or record, every collection named with a maximum, an unknown field refused rather than ignored. Fix that shape first and the tile has something true to translate.

## The first door

**BUHR Journey 3, Rung 1: author the MCP-in-Kyri descriptors and a round-trip on witnessed ground.** It touches only owned notation and the bounded-protocol pattern already proven:

- a pinned `format mcp-tool-v1` manifest and a `format mcp-call-v1` / `format mcp-result-v1` pair, in Kyri, for one real example tool (the Mantra browser of Journey 2 is a natural first tool to describe — it takes a catalog and returns a rendered graph);
- a small Rye reader that parses a call envelope into a bounded request record and renders a result record back to Kyri, refusing an unknown tool or a malformed field with a named error;
- a witness proving the round trip green on metal — a Kyri call parses, routes to the tool, and the tool's result renders back to Kyri byte-for-byte deterministic.

That one rung fixes the shape. The Kyri↔JSON tiles then have a settled target, and every later Grain tool — the voices' host, Mandate's store, the browser — presents itself through the same manifest rather than a bespoke envelope each.

## Boundary

This is an exploration and a design; nothing is built by it. The first door is agent-doable on witnessed ground — no provisioning, no custody, no new transport. A tool described in MCP-in-Kyri stays as bounded and refusable as every other request the tree answers; opening any of those tools to a remote caller is a separate concern that keeps its own custody gate.

---

*ty every1 — to Kyri for being plain enough to describe a protocol without ceremony, and to whoever writes the first manifest that a hundred later tools inherit.*

*May the owned notation carry the world's protocol without bending to it, and may every tool it names keep faith with its bounds.*
