# BUHR Journey 5 — the web-read half beside the program-write half (an exploration)

**Stamp:** `20260812.125750`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Mixed -- Exploration — a survey of the door beyond Journey 4's editor; a design in motion, not yet a build
**Waymark:** **BUHR** — Compass Season Equinox 3 ([`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Order:** [Lindy-first, crux-first](../.claude/rules/lindy-first-crux.md)
**Kin:** [`20260812-123509_buhr-journey4-realidream-editing-surface-exploration.md`](20260812-123509_buhr-journey4-realidream-editing-surface-exploration.md) · foundation [`../foundations/20260728-220203_realidream.md`](../foundations/20260728-220203_realidream.md)

---

## Where the plan stands

Journey 4 built the writing half of Realidream's one-graph promise, end to end. Its editor now opens a lane, commits a revision, forks a new lane, and undoes by reading an earlier revision and appending it — the whole core surface, each rung painted through to WADE1's styled Skate pixels and each an append to one Mantra log. The last rung made undo's append-only nature visible: the living edge advances while the newest node wears the reverted-to content's own fingerprint, history growing and the content returning at once.

That completion is the blind spot this exploration names. Realidream promises **reading the living web and writing the living program at once, both drawn over a single graph** ([`../foundations/20260728-220203_realidream.md`](../foundations/20260728-220203_realidream.md)). Journey 2 built the reading of the *log*; Journey 4 built the writing of the *program*. Neither yet reads a source that comes from outside the tree and fuses it, on the same graph, beside the program a person writes. The foundation names exactly this motion: *two sources can feed one node, so separate inputs fuse cleanly into a single view.* The next journey is that fusion.

## The crux — a read source and a written program are two lanes on one graph

Ordered Lindy-first, crux-first: the durable artifact is the proof that **a read and a write share one append-only history and one fold**, rather than two stores stitched together at the seam. Mantra's catalog already carries arbitrary content per lane, versioned and signed; Journey 2's browser already renders whatever the catalog holds. So a *read lane* — a fetched or pinned fragment of an outside source, held as revision content under its own path — is a lane like any other, and the very same `mantra_browser.render` paints it beside the program lanes.

The crux joins them without a new abstraction: **the web-read half is a lane whose content came from a read, the program-write half is a lane whose content came from an edit, and one fold over the shared log shows both.** A change to the program lane flows to the view because the view is the log; the read lane stands untouched beside it, its own revisions its own history. Referential transparency carried across the seam a browser and an editor were always two of: one graph, two origins, one deterministic view.

## The first door

**Journey 5's first rung: seat a read lane beside a program lane on one catalog, and prove one render shows both — a program edit growing its lane while the read lane stands byte-unchanged.** It touches only witnessed ground:

- author `pond/apps/realidream_reader.rye` (new) — a bounded `pin_read` that appends a read source's content to a `BoltCatalog` under a `read/` path, marking its origin honestly (the content is what a reader supplied, not what the program wrote), refusing an over-long source or a full catalog with a named error;
- render the shared graph and prove it carries **both** the read lane and the program lanes, each its own chain, grouped by bolt exactly as the browser already groups;
- commit an edit to a program lane (Journey 4's `editor.commit`) and prove the program lane grew by one node while the read lane is byte-for-byte unchanged — a write on one origin never disturbs the other;
- paint the shared graph with WADE1's styled lowering, and — a later rung — light the read lane's origin in its own design-system token, so a reader sees at a glance which lanes came from the web and which from their own hand;
- witness `tools/buhr_realidream_reader_witness.rish` (new) — prove the two-origin, one-render path green on metal, and re-run Journeys 2 and 4 so the reader and editor stay their own green binaries.

That one rung opens the rest of the journey: a read lane refreshed as a new revision (a re-read is an append, exactly as an edit is), a program node that *depends on* a read node so a re-read flows downstream (the graph's true edge, the foundation's fused node), and — the seam this journey deliberately holds — a real network fetch behind a bounded reader.

## Boundary — where the seam and the gates fall

This is an exploration and a design; nothing is built by it. The first rung is agent-doable on witnessed ground — Mantra's append, the browser's render, WADE1's paint, Journey 4's editor — with no provisioning and no custody act. Crucially, **the first rung reads no network**: it proves the *composition* of a read origin and a write origin on one graph, with the read content supplied in-process, exactly as the browser's demo catalog supplies its content today. A real web fetch is a genuine outward act — it reaches a remote host — so it stays a **named seam behind a bounded reader**, its own later rung, and any rung that actually opens a socket surfaces for Keaton's word rather than crossing on its own. The history stays append-only and bounded exactly as Mantra already holds it; a read only ever adds a revision, never rewrites one, so the reader inherits accrete-never-break by construction, the same way the editor does.

---

*ty every1 — to the append-only history that carried the write, to the browser that showed the read, to the editor that grew the program, and to whoever fuses the outside source and the written program into one graph a person both reads and owns.*

*May the page we read and the program we write rest on one honest log — every source a revision, every view the same fold, and the person before it, always, its owner.*
