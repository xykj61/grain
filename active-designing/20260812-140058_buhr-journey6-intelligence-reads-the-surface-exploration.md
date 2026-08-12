# BUHR Journey 6 — the intelligence reads the surface

**Stamp:** `20260812.140058`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Exploration — a self-approved design round opened from a plan-exhausted blind spot; a design in motion, not yet a build
**Waymark:** **BUHR** — Compass Season Equinox 3 ([`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Order:** [Lindy-first, crux-first](../.claude/rules/lindy-first-crux.md)

---

## The blind spot the itinerary left open

BUHR is **Surface & Intelligence** — and five journeys have now built each half on its own. Journey 1 raised the **intelligence**: the Q-vane host gathers Lattice, Scribble, and Ember under one bounded Lantern-shaped entry, each voice answering a real query over its own pinned corpus ([`../pond/apps/quin_host.rye`](../pond/apps/quin_host.rye)). Journeys 2 through 5 raised the **surface**: the Realidream Mantra graph — browsed, styled, edited, undone, re-read, fused, themed — the append-only truth made legible on a real Skate canvas ([`../pond/apps/mantra_browser.rye`](../pond/apps/mantra_browser.rye), [`realidream_view.rye`](../pond/apps/realidream_view.rye)).

Each half runs green. Yet the equinox's own name fuses them, and no rung yet does: **the intelligence has never read the surface.** Every voice so far answers over a *pinned* corpus — Ember's four-chunk catalog, Scribble's fixed markdown. None answers over the **living Mantra graph** the Realidream journeys built. That is the itinerary's blind spot, and it is exactly where the two strands were always meant to meet.

## The crux — a voice whose corpus is the living graph

Ordered Lindy-first, crux-first. The most durable move is the one the equinox is named for: prove that Grain's bounded inference reads Grain's own append-only surface, over public APIs only, with no new abstraction. It is the hardest *tractable* move left — not a sixth theme rung on an already-complete arc, and not the far-horizon face — the decisive compose that turns two proven halves into the thing BUHR promised.

The crux property: **a Lantern-shaped request answers a true question about the live Mantra graph, bounded and metered by the same contract that governs every other voice.** Not a pinned answer — a reading of the actual `BoltCatalog` the browser renders, so the number the voice returns is the number the painted view shows. The intelligence and the surface share one graph, exactly as editor and view already do.

## The first door

**BUHR Journey 6, Rung 1: a Q-vane query whose corpus is the Realidream Mantra graph.** A new Pond app, `pond/apps/graph_query.rye`, composes Lantern's contract with the Mantra browser's own public readers:

- a Lantern request routes by prompt to a real graph reading — `lane_count` → `mantra_browser.lane_count`, `bolt_count` → `mantra_browser.bolt_count`, `head` → `mantra_browser.head_revision` of a named lane;
- each answer is the true count over the browser's own `demo_catalog` — the graph the reading journeys already render — never a pinned guess;
- the same Lantern gate governs it: `validate_request`, the model allow-list, token/stop metering, a length stop when the budget bites;
- an unknown op is refused (no fake answer), a disallowed model and a zero budget surface at once.

It touches only witnessed ground — Lantern's contract (Journey 1) and the Mantra browser's public catalog readers (Journey 2), each already green. No new module, no new transport, no new parser: a compose, in the tree's established voice-app shape.

## The journey, ordered onward

- **Rung 1 (this door):** count-shaped readings of the live graph through the Lantern contract — lanes, bolts, a lane's head revision.
- **Rung 2:** a reading voice (Scribble) that folds the *rendered* graph text — outline the bolts, name the lanes — so the voice reads the same bytes the browser paints.
- **Rung 3:** the query answered over an **edited** graph — commit through Journey 4's editor, then ask the voice, and watch the head revision the intelligence reports advance with the surface.
- **Horizon:** the query served through the Q-vane host's `dispatch`, so a graph question routes beside arithmetic, reading, and corpus craft — a fifth voice-of-place gathered under Quin.

## Boundary

This is an exploration and a design; nothing is built by it. The first door is agent-doable on witnessed ground — no provisioning, no custody, no network. The inference stays bounded and metered by Lantern's own contract; the graph read is the in-process demo catalog the browser already carries. Any model weights, corpora, or a real network read remain the separate, gated concerns they already are.

---

*ty every1 — to the voices that learned to answer and the surface that learned to hold history, meeting now over one graph.*

*May the intelligence read the surface true — bounded, metered, and honest about what the graph actually says.*
