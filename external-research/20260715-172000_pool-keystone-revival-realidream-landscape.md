# Pool as the Keystone Revival -- the Userspace Host, with Realidream as Its Landscape

**Language:** EN
**Version:** `20260715.172000` (Pacific)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Vision register -- design -> decision brief, siloed. Register: design (Two Rooms -- a prioritization proposal, not built code). Addressed to a generic Acme Corporation employee.
**Companion:** `../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md` (which already maps Gall -> Pool and Realidream -> the Landscape parallel -- this brief prioritizes that mapping and names the first laps)

---

## The Decision, Stated First

Of Arvo's ten vanes, the one most worth reviving into Glow next is **Gall -- the userspace application host -- revived as Pool.** Ames and Clay are already alive and green as Comlink and Mantra; identity is half-alive through Kumara. What Glow lacks is the host that turns that green infrastructure into a system a person can inhabit. Pool is that keystone, and **Realidream** is its Landscape -- the unified viewer through which a person actually sees and uses what Pool hosts. This brief prioritizes both on the roadmap and names the first laps; nothing here is built yet.

## Why Pool Is the Keystone, Not Another Brick

The reasoning turns on leverage per unit of remaining work.

- **The spine already breathes.** Comlink (Ames's role) carries -- its real sealed hop is proven. Mantra (Clay's role) remembers. Neth settles. Kumara names. Each is green. The gap is not more infrastructure; it is a place for a person to live above it.
- **Everything at the product layer is Gall-shaped.** Linengrow's civic commerce, Open Asks, the sanctuary care log, the content market, Dimeroll's books -- every one is a stateful, event-sourced userspace agent, which is precisely what Gall hosts. Pool is the single revival that unlocks the most downstream work at once.
- **It composes what exists rather than starting cold.** Caravan already carries part of Gall's job -- a supervision tree plus an explicit capability table -- and the vane-mapping notes Caravan's capability model is arguably *ahead* of Gall's current direct-kernel-interaction design. Reviving Gall means composing Caravan (supervision) + Pool (the named application vane) + capability security, not inventing a host from nothing.
- **It is where Glow contributes back.** The Urbit Foundation is actively rethinking Gall ("the Future of Userspace"). Reviving it now as a capability-secured, witness-first host -- at the exact moment Urbit redesigns its own -- is where this fork's collaborative-proposal posture becomes a real offering rather than a stance.
- **It is the rhizome-monopoly move made buildable.** The market-position study argues for owning one function nothing can route around: verified correctness. A witnessed, capability-secured userland host *is* that function, concretely (`../external-research/20260715-135200_zero-to-one-rhizome-market-position.md`).

## Realidream as the Landscape -- the Face of the Host

Urbit's **Landscape** is the web desktop through which a person sees and uses the Gall agents their ship runs. Glow's parallel is **Realidream**, already named as the unified viewer in the mapping and already carrying a lane on the roadmap (the Visual Track). Positioning Realidream *within* the Pool revival makes both sharper:

- **Pool hosts; Realidream shows.** Pool is the application host (Gall); Realidream is the viewer over what it hosts (Landscape) -- the same clean split Urbit keeps between the two. An Open Ask, a receipt, a reputation, a sanctuary page, a content-market listing: each is a Pool-hosted agent's state, rendered by Realidream as a pure fold from Weave to the frame.
- **It revives the grain-sketchbook's unified DAG head, honestly.** The sketchbook's "Unified DAG UI backend (Aurora + Skate + Realidream)" is this lane's direct ancestor, and its three studied departures become Glow's discipline: immutable facts re-folded rather than nodes patched; meaning per-entry via Tilak rather than one shared enum across consumers; values crossing seams as Bron rather than JSON-in-a-payload (`../external-research/20260708-021912_grain-sketchbook-realidream-mining.md`).
- **It is the alternative to Landscape, in posture as well as parallel.** Where Landscape renders over Gall's current model, Realidream renders over a capability-secured Pool and a witnessed Weave fold -- the same view surface, grown on a spine where every claim it shows is either proven or plainly marked unproven.

## The First Laps -- Smallest Lovable Complete

Named as a ladder, each rung provable before the next, none built yet:

| Rung | Name | What it is | Gate |
|---|---|---|---|
| **P0** | **Pool host seam** | A minimal Pool that hosts *one* agent over Caravan's supervision + capability table -- an agent is admitted, runs bounded, and its state is a fold; witnessed on one real agent (the closed Open Ask loop is the natural first tenant) | Caravan capability table green (it is); Keaton's word to open Pool |
| **P1** | **Two agents, one capability boundary** | Pool hosts two agents that cannot touch each other's state except through a named, granted capability -- the isolation guarantee witnessed, not assumed | P0 |
| **R1** | **Realidream first view over Pool** | Realidream renders one Pool-hosted agent's state (the Open Ask) as a pure fold to the frame -- the thin-view exception already scoped, now sourced from Pool rather than a local fixture | P0 - Visual Track rung 1 (drawn terminal, active) |
| **R2** | **Realidream as the unified viewer** | ask - receipt - reputation - sanctuary page, each a Pool agent rendered on one Realidream surface -- the Landscape-parallel proper | R1 - P1 - Dexter graduation (Realidream is the second consumer that rule waits for) |

The Dexter graduation rule already names "a Realidream viewer is the natural second consumer" -- so R2 is also the event that graduates Dexter, tying this ladder into a rule already written.

## What This Brief Does Not Claim

- No Pool code, no Realidream view, no capability host is built; this prioritizes and scopes, gated behind Keaton's word to open P0.
- It does not claim Pool must adopt Gall's literal name or internals -- it revives Gall's *role* in Glow's own capability-secured shape, per the reviving discipline (the elder keeps its witnesses until the revival earns them).
- It does not settle the diverse-redundancy build shape or Pool's market scope; those remain open Glow questions named elsewhere.

## Related

- `../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md` -- Gall -> Pool, Realidream -> Landscape.
- `../external-research/20260708-021912_grain-sketchbook-realidream-mining.md` -- the unified DAG head Realidream revives, and its three departures.
- `../external-research/20260714-035600_pool-p-vane-content-data-market.md` -- Pool's own vane design (the market as flagship, not whole scope).
- `../external-research/20260715-135200_zero-to-one-rhizome-market-position.md` -- why a witnessed userland host is the function worth owning.

---

Pool is where Glow's green spine becomes a place to live, and Realidream is the window through which a person sees it -- the userspace keystone and its Landscape, prioritized together.
