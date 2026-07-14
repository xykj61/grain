# Cursor Pass — Adopt the Horizon Stack (Four Visions)

*Four finished Radiant visions that compose one layered horizon — the surface, the graph beneath it, the wafer it reaches for at scale, and the open model forged upon it. This pass files them where the visions live, frames them honestly as the far horizon, and links them into the stack they form. The documents are whole as authored; one framing choice and a few honesty edits wait on Kaeden's word.*

**Stamp:** `20260629.074712`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Guidance:** TAME (`context/TAME_GUIDANCE.md`) · SLC · Gall · the silo principle
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Bridge:** Kaeden bridges the source files in, rules the open questions, and pushes from the host.

*Written together by Kaeden and Reya 2.*

---

## Before Anything — Bridge the Source Files In

These four are **not in the tree yet** (verified). They exist as Kaeden's uploads and must be bridged into the repo before this pass can file them — the same step the currency vision needed. If a body fails to arrive, stop and tell Kaeden rather than reconstructing it; adoption means filing what he authored.

The four, all stamped `20260629.063512`:

- `the-wafer-and-the-sovereign-coin.md`
- `lantern-lattice-anvil.md`
- `the-graph-beneath-the-surface.md`
- `realidream.md`

---

## What This Adopts — One Layered Horizon

They cohere as a stack, top to bottom:

- **Realidream** — the unified editor-and-browser surface.
- **The Graph Beneath the Surface** — the streaming DAG under it, on Tally (bounds), Mantra (history), Tablecloth (fold).
- **The Wafer and the Sovereign Coin** — the wafer-scale hardware the graph reaches for at scale.
- **Lantern, Lattice, and Anvil** — the open model forged and served on that wafer, flowing back into the surface.

Filed in `foundations/`, under **Vision documents**, as a set:

```
foundations/20260629-063512_realidream.md
foundations/20260629-063512_the-graph-beneath-the-surface.md
foundations/20260629-063512_the-wafer-and-the-sovereign-coin.md
foundations/20260629-063512_lantern-lattice-anvil.md
```

Place each as authored — header, epigraph, stamp, and coauthor credit preserved.

---

## Frame Them as the Far Horizon — a Real Choice

These describe frontier work: wafer-scale silicon, a foundation model, a unified graph runtime, a browser surface — each among the hardest, most capital- and expertise-intensive undertakings in computing. The project's Gall's Law, which deferred the compiler fork, holds that complex systems grow from working simple ones and are never designed whole from scratch. So the honest and protective move is to mark these as the **far horizon**, plainly distinct from the rings that run today (SLC-1 done; TAME hardening now).

**Recommended:** in the `foundations/README.md` index, group the four under a clear note — *the far horizon: the surface, the graph, the hardware, and the model the project grows toward, distinct from the active rings* — so a reader meets them as aspiration rather than near-term plan. *Kaeden rules how explicit the framing should be.*

---

## Optional Honesty Edits — Kaeden's Call (file-as-is is the default)

Adoption does not depend on these. **The Graph** and **Lantern, Lattice, and Anvil** are well-grounded — file as authored. Two pieces carry claims a technical or economics reader will probe; the edits keep the vision and close the exposure.

### The Wafer and the Sovereign Coin — two softenings

**1. The supply-chain claim is backwards.** Leading-edge wafer silicon depends on the most concentrated, most exotic supply chain on earth — the opposite of common-and-nearby.

> *In §"Why Close Is Greener and Faster," find:* "It leans on common materials drawn from nearby supply chains rather than scarce ones carried from troubled places."
> *Replace with:* "The silicon beneath it comes from the most concentrated supply chain on earth — a real dependency we name plainly rather than wish away, and one an open, shared design works patiently to widen rather than to deepen."

**2. Right-size the funding, and keep sovereign and local distinct.** Only a monetary sovereign could attempt fab-scale funding, and even then it is a national undertaking; a local complementary currency cannot.

> *In §"The Real Constraint," find:* "A community that issues its own currency is held back less by accounting than by what is real"
> *Replace with:* "A monetary sovereign — a nation that issues its own currency, distinct from the local complementary currency that circulates close to home — is held back less by accounting than by what is real"
>
> *In §"Funded Openly," find:* "A modest public investment — modest beside the budgets nations already keep — can fund"
> *Replace with:* "A sovereign-scale public investment — large in itself, yet modest beside the budgets nations already keep for far less — can fund"

### Realidream — one optional clarification

Distinguish a bounded surface from a full browser engine (the latter is among the largest software efforts that exist).

> *In §"Where It Sits Among the Rest," near* "Realidream is an open browser as much as an editor," *add a clause:* "— a bounded, honest surface over its own graph and the open web it chooses to render, rather than a from-scratch engine rivaling the few the world maintains."

*Recommended: apply the two wafer softenings* (the piece is framed as hardware economics, where these will be probed hardest); the Realidream clause is a lighter touch.

---

## Index and Cross-Links

**`foundations/README.md`** — four rows under **Vision documents**, in the same voice, grouped per the horizon framing above:

> - `20260629-063512_realidream.md` — the unified editor-and-browser surface over a single streaming graph: read the living web and write the living program in one place, bounded and deterministic, owned by the person before it.
> - `20260629-063512_the-graph-beneath-the-surface.md` — the streaming DAG under Realidream: program, page, and screen as one graph, on Tally (bounds), Mantra (history), Tablecloth (fold) — fast because little redraws, honest because the history is a chain of signed facts.
> - `20260629-063512_the-wafer-and-the-sovereign-coin.md` — wafer-scale compute that keeps memory beside the cores, greener and faster for it, framed as sovereign-scale public infrastructure built from real resources.
> - `20260629-063512_lantern-lattice-anvil.md` — the open model layer: Anvil the forge, Lattice the serving fabric, Lantern the honest meter — open weights, hosted serving as the product, every token counted in plain sight.

**Wire the stack's internal links.** Each piece names "the companion piece"; turn those prose references into real links among the four, so a reader can walk the stack.

**Link to the visions they extend, few and true:** the Wafer to `money-that-stays-close-to-home.md` (the currency shape it borrows) and `the-device-that-forgets.md` / the Mantrapod (hardware kin); Realidream to `a-home-in-plain-text.md` (Rishi, the calm shell beside it); all four to `anywhere-we-are-found.md` (the unifying vision above the tracks). Skip any link that has no clean home.

---

## Coordination — a Fresh Agent Is Running TH-2

A fresh Cursor agent is on **TH-2** (`tools/tame-check.rish`, Mantra asserts). This pass touches only `foundations/` and its README — different files, low collision — yet sequence it so it does **not** race TH-2's commits. Ideal for Claude Code on the host, or between TH-2 steps. Pull to the current tip first; never edit or commit concurrently with the running agent on the same branch state.

---

## Record and Push

Commit as one honest unit — the four documents, the index, the cross-links, and the session log together. Write the log at `session-logs/<filing-stamp>_horizon-stack-filed.md` per `.cursor/rules/session-logs.mdc` (or the Claude rule on host): what was filed, the horizon framing, which edits landed or were left, the links wired. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

*(Kaeden: supply the filing stamp verbatim; the documents' own `063512` belongs to them.)*

---

## The Rulings

1. **Horizon framing** — group and mark the four as the far horizon, distinct from the active rings. *Recommended.*
2. **The wafer softenings** — the supply-chain correction and the sovereign-scale funding language. *Recommended.*
3. **Realidream's bounded-surface clause** — *optional, lighter.*

Either way, the four land whole and findable, and the stack reads as one.

---

*May the far horizon be drawn truly, named as the horizon it is, and kept honest in every claim. May the surface, the graph, the wafer, and the model rest together among the visions, one stack the reader can walk. And may the running seed keep climbing, patient and real, toward the sky we have drawn above it.*
