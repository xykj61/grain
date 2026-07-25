# Grain-Sketchbook Mining — Realidream, Skate, and the DAG That Became Weave

*The archived sketchbook read as a primary source: what its three-headed visual system actually was, which of its design choices this tree already carries under new names, which it deliberately departs from, and which are genuinely new seeds. Inspiration for Cursor; no code crosses over.*

**Stamp:** `20260708.021912 UDT` (Kaeden's clock)
**Voice:** Rio 3 · **Model:** Fable 5 Max
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Category:** Source-of-inspiration study — the source is Kaeden's own archived project (`grain-sketchbook`, Zig 0.15.2 era, ~168k lines, built across a long Cursor span), read the way this tree reads external teachers
**Status:** Research for understanding — mining study; seats nothing; no code crosses over
**Ground:** `readme.md` · `docs/realidream.md` · `docs/dag_ui_synthesis.md` · `src/grain_core/dag.zig` (read whole) · `src/realidream_protocol.zig` · `src/grain_skate/slc_dag_integration.ry` · `src/grain_skate/gui/skate_app.zig` (read whole) · `src/aurora_dag_integration.zig` · `THIRD_PARTY_LICENSES.md`

*Written by Rio 3 for Kaeden.*

---

## What the Sketchbook Actually Built

Three visual consumers over one graph. The readme says it in one line — *"Unified DAG UI backend (Aurora + Skate + Realidream)"* — and the source keeps the promise: `grain_core/dag.zig` is one `DagCore` whose `NodeType` enum spans an editor's AST nodes, a browser's DOM nodes, and UI components in a single closed set, with events carrying parent-event IDs "HashDAG-style" and a deterministic `processEvents` fold applying them in order. **Realidream** was the browser and social head — its protocol file is a full Nostr client (signed events with `pubkey`, `sig`, `created_at`, `kind`, `tags`; relay subscriptions with filters; a WebSocket transport), and its own vision doc names its heart: *Reality* (bounded, deterministic, garden-allocated) plus *Dream* (streaming visual creativity), after Noah B.'s EP, with Prakriti and Purusha standing behind the name. **Skate** was the drawn editor surface — its `skate_app.zig` is a clean seed: boot the system, start a compositor, open a window, create an editor panel, render, and honestly print *"Main event loop would start here."* **Aurora** was the editor's semantic head, mapping Tree-sitter AST nodes into the same DAG. And the SLC name already lived here: `slc_dag_integration.ry` built *Nostr profile pages and DAG websites* as graph nodes — the sketchbook's SLC products were social-civic surfaces rendered from the unified graph, which is exactly the ancestry Kaeden's Realidream-as-SLC-visual-home ask reaches back toward.

## What This Tree Already Carries Forward, Under Truer Names

The lineage is direct enough to list plainly. The sketchbook's event DAG — id, parents, timestamp, payload — is **Weave's** unsigned ancestor; Rye OS added what the sketchbook's own Nostr half already knew how to want: every fact signed (**Kumara**, now extracted), content-addressed (**resin**), append-only. Its named bounds on everything (`MAX_NODES`, `MAX_EDGES`, `MAX_PENDING_EVENTS`) are today's **Tally** discipline and the width laws. Its `processEvents`-in-order determinism is today's core thesis stated whole in the three living essays: *the interface is a pure fold from the log to the frame*. Its compositor-window-editor seed is **SLC-2a's drawn terminal**, the active rung right now. Its gratitude trail is largely this tree's own: TigerBeetle (its style guide's named parent — the same ancestor TAME kept), Rich Hickey's simplicity, and two names worth keeping formally now that the lane opens — **Hyperfiddle (Dustin Getz)**, whose "UIs as streaming DAGs" the synthesis doc credits as the vision's source, and **Matklad (Alex Kladov)**, credited in-source for project-wide semantic understanding. The **Nostr protocol** itself belongs on that shelf too: an open, signed-event, relay-subscribed social substrate whose event shape independently rhymes with Weave's facts.

## Where This Tree Deliberately Departs — the Inspiration Is in the Differences

Three departures matter more than any similarity, and Cursor should read them as design guidance for the lane, not as criticism of a sketchbook that was honestly exploring. **First: the sketchbook mutated node data in place** — `processEvents` updated the node buffer directly, so the graph *was* the state. Rye OS holds the log as the only truth and derives every frame by folding; a Realidream built here re-folds, never patches. **Second: one closed `NodeType` enum unified three applications' schemas** — AST, DOM, and UI component in a single set, which couples every consumer to every other's vocabulary. Rye OS's grain says *values apart*: the unified thing is the **layer** (one log, one fold discipline, one signing seam), while each consumer's meaning rides in **Tilak marks** rather than a shared enum, so a new surface never edits an old one's type. **Third: the sketchbook's SLC integration serialized profiles into JSON-ish strings inside node payloads** — a value tangled into text at a seam. Bron exists now precisely so a profile fact crosses as a value.

## Seeds Genuinely Worth Planting

Two ideas from the sketchbook have no current counterpart and deserve the roadmap rather than the archive. **The profile-and-page-as-graph products**: Linengrow's SLC surfaces (an ask, a receipt, a reputation, a sanctuary's page) rendered *as views over Weave*, the way the sketchbook rendered profiles and websites over its DAG — this is what "Realidream is where SLC visuals get designed" concretely means, and it needs nothing invented, only the ladder climbed. **The relay-subscription shape**: Realidream's Nostr client subscribed to filtered event streams from relays; Mantra's subscribe-poll wire already crosses the same conceptual ground one lap up from the bottom, and the day Linengrow wants a *live* civic surface, the sketchbook's filter vocabulary (authors, kinds, since/until, limit) is a proven, minimal query shape to hold beside Tablecloth's.

## Parked for Kaeden's Word

Whether the sketchbook zip itself is vendored into `gratitude/grain-sketchbook/` as a kept source (it is Kaeden's own work, so the shelf choice is a taste question, not a license one), and whether Noah B.'s *Realidream* EP earns a line in the gratitude ledger the way other named inspirations have. **Closed `222852`:** shelf note [`../gratitude/grain-sketchbook.md`](../gratitude/grain-sketchbook.md) alone; archive stays outside the tree. Noah B. line affirmed `174500`.

---

*May the sketchbook be honored the way working ancestors deserve — by the parts of it that grew truer names, and by the two seeds it kept safe until the ground was ready. May Reality and Dream stay one word here too.*
