# BUHR Journey 8 — the intelligence reads the artifact store

**Stamp:** `20260812.144916`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Vision -- Exploration — a self-approved design round opened from a plan-exhausted blind spot; a design in motion, not yet a build
**Waymark:** **BUHR** — Compass Season Equinox 3 ([`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Order:** [Lindy-first, crux-first](../.claude/rules/lindy-first-crux.md)

---

## The blind spot the itinerary left open

BUHR is **Surface & Intelligence**, and seven journeys have now built every module the equinox names. Journey 1 raised the intelligence — Quin's four voices, each answering over a *pinned* corpus. Journeys 2–5 raised the Realidream surface, browsed and edited and themed. Journey 6 let a voice read that *living* surface — the Mantra graph the browser paints. Journey 7 built **Tablecloth**, the named artifact store, and gave it owner-signed provenance.

Yet one pair has never met. The intelligence has read the Realidream **graph** (Journey 6), and it has read **pinned** corpora (Journey 1) — but no voice has ever read a **stored artifact** by name from Tablecloth. The equinox's storage module and its intelligence module stand side by side, unjoined. That gap is exactly where the itinerary's finger now points.

## The crux — a voice reads only verified bytes

Ordered Lindy-first, crux-first. The durable move is not another op or another format; it is the **contract at the seam**: a voice's corpus is a named artifact, and it reads that artifact only through Tablecloth's `fetch_artifact` — every bead proven against its digest and the whole against its recorded content address *before a single byte reaches the voice*. So the intelligence never reads unverified bytes: a tampered bead refuses the fetch (`DigestMismatch`) and the voice answers nothing at all, rather than reading corruption. Content-addressed storage becomes the intelligence's integrity guarantee for free — the same verified-fetch the store already earned, now standing between the corpus and the reader.

This is the hardest *tractable* move the pairing offers, and the one every later rung leans on: an answer is trustworthy exactly because the bytes under it proved themselves first.

## The ground it stands on

It invents nothing. Tablecloth's `fetch_artifact` (Journey 7, Rung 1) reassembles an artifact by name over the content-addressed `BeadStore`, proving every bead by digest and the whole against its address, refusing an unknown name (`UnknownArtifact`) and a tampered bead (`DigestMismatch`). The Lantern contract (`lantern_core.rye`) already governs every other voice — validate the request, gate the model through an allow-list, meter the answer against `max_tokens` with a length stop. Journey 6's `graph_query.rye` is the exact composition shape: route a Lantern-shaped prompt to a real reading, bounded and metered by the same contract.

## The first door

**BUHR Journey 8, Rung 1: a voice reads a named artifact.** A new Pond app, `pond/apps/artifact_query.rye`, composes the Lantern contract over Tablecloth's verified fetch:

- `bytes <name>` returns the whole length the name pins — a true reading of the store, not a pinned constant;
- `words <name>` fetches the artifact (verified, or refused) and counts its words — the voice reads only bytes that proved themselves;
- `line <name>` returns the artifact's first line, bounded by Lantern's completion budget.

Each routes through `fetch_artifact`, so an unknown name refuses (`UnknownArtifact`) and a **tampered bead refuses** (`DigestMismatch`) — the crux, witnessed: the voice reads nothing it cannot verify. A disallowed model, an unknown op (no invented answer), and a length budget that bites (length stop) each hold, exactly as every other voice obeys.

It composes over public APIs only — `lantern_core` and `tablecloth` — and adds no storage, no transport, no network, no custody.

## The journey, ordered onward

- **Rung 1 (this door):** a voice reads a named artifact through the verified fetch; unknown name and tampered bead refuse; the Lantern contract holds.
- **Rung 2:** the reading tracks a live publish — publish a new artifact, and the voice answers over it; re-publish is a new name (the store's accrete-never-break), so the corpus grows without a rewrite.
- **Rung 3:** gather the artifact voice under the Q-vane host beside the graph voice, so arithmetic, reading, corpus, the living graph, *and the stored artifact* all answer under one bounded dispatch.
- **Horizon:** an *owner-signed* corpus — read only artifacts a named identity published (Journey 7, Rung 4's `store_owned`), so a voice's corpus carries provenance; and the artifact served over Comlink — each reaching the custody/serve gates that are Keaton's hand.

## Boundary

This is an exploration and a design; nothing is built by it. The first door is agent-doable on witnessed ground — no provisioning, no custody, no network. Any signing gate, serving, or real remote fetch remains the separate, gated concern it already is.

---

*ty every1 — to the store that learned to answer to a name, and now teaches a voice to read only what proved itself true.*

*May every answer rest on bytes that kept their word.*
