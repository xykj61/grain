# BUHR Journey 7 — Tablecloth, the named artifact store

**Stamp:** `20260812.142132`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Mixed -- Exploration — a self-approved design round opened from a plan-exhausted blind spot; a design in motion, not yet a build
**Waymark:** **BUHR** — Compass Season Equinox 3 ([`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Order:** [Lindy-first, crux-first](../.claude/rules/lindy-first-crux.md)

---

## The blind spot the itinerary left open

BUHR is **Surface & Intelligence**, and the equinox names four things it holds: Realidream's DAG surface, Quin's four voices, MCP-in-Bron, and **Tablecloth** ([`../context/LEXICON.md`](../context/LEXICON.md), the BUHR row). Six journeys have now built the first three — the Q-vane voices (Journey 1), the Realidream Mantra graph browsed, edited, and fused (Journeys 2–5), the MCP descriptor shape and its JSON tiles (Journey 3), and the intelligence reading the living surface (Journey 6). Each runs green.

One name in that row has never been built: **Tablecloth** — the Lexicon's *"Brix-facing application database and artifact store"* (line 189), held apart on purpose from the already-witnessed namespace *query* of the same name. It is the last unbuilt module the equinox itself promised, and so it is exactly where the itinerary's finger has been pointing all along.

## The crux — a name over a content address

Ordered Lindy-first, crux-first. The durable artifact is not a fetch loop or a wire format; it is the **shape of the store**: a human name bound to a *content address*, so that asking for an artifact by name returns exactly the bytes whose digest that name pins — and a tamper anywhere, in a stored byte or in the recipe that reassembles it, refuses before a single byte is trusted. Content-addressing makes accrete-never-break the store's own data model: the same bytes are stored once, named many times, and never rewritten in place — the same discipline the Realidream editor already earned as *an edit is an append*.

This is the hardest *tractable* move Tablecloth offers, and the one every later rung leans on: a bounded, verified, dedup-earning artifact store standing on witnessed ground.

## The ground it stands on

Tablecloth invents no storage. The tree already carries a content-addressed store, proven to the byte: `mantra/beading.rye`'s **`BeadStore`** — it beads content into content-defined chunks, deposits each once (a bead held twice is stored once, the dedup dividend), records the recipe as a bead-index, and reassembles the whole with every bead proving itself against its digest and the reassembled whole proving itself against the resin's own digest ([`../mantra/beading.rye`](../mantra/beading.rye), selftest green). Tablecloth adds only the **naming layer** the artifact store wants: a bounded catalog mapping a human name to a stored content address, and a **Brix-facing manifest** — a `format tablecloth-v1` flat-Bron listing (`artifact <name> <digest> <len>`) that publishes the catalog as the Bron a Brix descriptor evaluates to.

## The first door

**BUHR Journey 7, Rung 1: the named artifact store.** A new Pond app, `pond/apps/tablecloth.rye`, composes the catalog over `BeadStore`:

- `store_artifact(catalog, store, name, content)` beads the content into the shared store (dedup earned across artifacts that share bytes), records the name, whole digest, whole length, and bead-index recipe in the catalog; refuses an empty or overlong name, a name already taken, a full catalog, and content past the resin bound;
- `fetch_artifact(catalog, store, name, out)` reassembles the artifact by name and returns exactly the stored bytes — every bead proven by digest, the whole proven against the recorded address, so a tampered bead or a tampered recipe refuses (`DigestMismatch`) and an unknown name refuses (`UnknownArtifact`);
- `render_manifest` / `parse_manifest` round-trip the **Brix-facing** `format tablecloth-v1` catalog, name and address and length recovered field for field, an unknown header refused (`BadManifest`).

It touches only witnessed ground — `BeadStore`'s public deposit/get/reassemble/verify, over its own public API only. No new storage, no new transport, no network, no custody.

## The journey, ordered onward

- **Rung 1 (this door):** name → content address, round-tripped by name and by manifest; tamper and unknown-name refused; dedup earned across shared content.
- **Rung 2:** the manifest as the true index — list every artifact in held order, and prove a parsed manifest verifies against the live store (each named address is actually held).
- **Rung 3:** a Brix descriptor *declares* a set of artifacts, evaluates to a `tablecloth-v1` manifest, and the store proves it can satisfy the declaration — the "Brix-facing" half made literal.
- **Horizon:** an owner-signed catalog (Kumara-keyed, as `mandate/keyed.rye` already keys the vector store), and the artifact store served over Comlink — each its own later, gated concern.

## Boundary

This is an exploration and a design; nothing is built by it. The first door is agent-doable on witnessed ground — no provisioning, no custody, no network. Any signing, serving, or real remote storage remains the separate, gated concern it already is.

---

*ty every1 — to the store that learned to hold a resin by its content, and now learns to answer to a name.*

*May every artifact be found by its true name, and every name pin the bytes it promised.*
