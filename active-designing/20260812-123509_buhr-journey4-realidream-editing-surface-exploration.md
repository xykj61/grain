# BUHR Journey 4 — the Realidream editing surface (an exploration)

**Stamp:** `20260812.123509`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Mixed -- Exploration — a survey of the door beyond the three seated journeys; a design in motion, not yet a build
**Waymark:** **BUHR** — Compass Season Equinox 3 ([`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Order:** [Lindy-first, crux-first](../.claude/rules/lindy-first-crux.md)
**Kin:** [`20260812-053742_buhr-exploration-surface-and-intelligence.md`](20260812-053742_buhr-exploration-surface-and-intelligence.md) — the equinox exploration this one continues

---

## Where the plan stands

The BUHR exploration named three journeys, and all three now run green. Journey 1 composed Quin's four voices into the bounded Q-vane host. Journey 2 built the Realidream Mantra browser — the append-only log rendered as a readable revision graph, painted onto WADE1's styled Skate surface, and made themeable end to end by the `.brush` authoring loop (rungs one through seven, the whole theming arc). Journey 3 spoke MCP in Bron, from the owned descriptor shape through the JSON host bridge. The written itinerary is complete.

That completion is itself the blind spot this exploration names: the Realidream vision promises **reading the web and writing the program at once, on one graph** ([`../foundations/20260728-220203_realidream.md`](../foundations/20260728-220203_realidream.md)), and Journey 2 built only the reading half. The graph is rendered; nothing yet writes to it through the surface. The next journey is the other half of the promise.

## The crux — an edit that appends a revision the graph already knows how to show

Ordered Lindy-first, crux-first: the durable artifact is the proof that **editing and viewing are one append-only history**, not two stores kept in sync. Mantra's catalog already carries the write side — `recall_lap1.rye` appends a new revision for a path and reads the freshest one back, each revision an owned, versioned record. Journey 2's browser already renders whatever the catalog holds, straight from `mantra_browser.render`, so the painted view can never drift from the log.

The crux joins them: **an edit is an append to the Mantra catalog, and the very same render paints the grown graph.** No edit buffer beside the log, no diff to reconcile — the edit *is* a new revision, and the browser shows it because it shows the log. That is referential transparency carried into an editor: the surface holds no state the history does not.

## The first door

**Journey 4's first rung: append a revision through a Pond app and prove the browser graph grows by exactly that node.** It touches only witnessed ground:

- author `pond/apps/mantra_editor.rye` (new) — a bounded `commit` that appends one revision to a `BoltCatalog` for a named lane, refusing an over-long path or a full catalog with a named error;
- render the graph before and after, and prove the after-graph carries exactly one new `r<n>` node on the edited lane, its chain link intact (`r<n-1> -> r<n>`), every other lane byte-unchanged;
- paint the grown graph with the same styled Skate lowering, the new node's head lit as the living edge (rung three's `head` token) — the edit moves the living edge forward, visibly;
- witness `tools/buhr_mantra_editor_witness.rish` (new) — prove the append-to-repaint path green on metal, and re-run Journey 2 so the reader stays its own green binary.

That one rung opens the rest of the journey: an edit that forks a new lane, an undo that is simply reading an earlier revision, and — far horizon — the web-read half composed beside the program-write half on one canvas.

## Boundary

This is an exploration and a design; nothing is built by it. The first rung is agent-doable on witnessed ground — Mantra's append, the browser's render, WADE1's paint — with no provisioning and no custody act. The history stays append-only and bounded exactly as Mantra already holds it; an edit only ever adds a revision, never rewrites one, so the editor inherits the tree's accrete-never-break discipline by construction.

---

*ty every1 — to the append-only history that already carried the write, to the browser that already showed the read, and to whoever joins them into one graph a person can both read and grow.*

*May the editor, when it comes, hold no truth the history does not — every edit a revision, every view the same log.*
