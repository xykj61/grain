# Loadable Topologies and Pond — the Silo Brief

**Language:** EN
**Stamp:** `20260809.234413`
**Voice:** Riyo
**Style:** Radiant · Silo — this brief names only our own modules and one fixed external: the study that grounds it, held in `../external-research/20260809-232015_loadable-topologies-and-pond-the-application-module.md` and `../external-research/20260809-233940_divisional-roles-d3-d5-d9-and-the-three-modes.md`. Every teacher, every classical source, rests named in that study; this room speaks our vocabulary alone.
**Status:** Design — the buildable plan distilled from the study. Proposed names are marked *proposed*; nothing here seats a name, cuts a doc, or opens the breach. Build order is named; the breach waits until JARL closes.

---

## What We Are Actually Building

One insight carries the whole plan: **the shape of a constellation is data, not law.** `comlink/topology.rye` already separates the geometry (the tier constants) from the ledger (`settlement/constellation.rye`, which settles by *asking* topology where a sponsor sits and never names a number). Lift those constants into a loadable descriptor, and the five settlement transitions — genesis, mint, transfer, rotate, escape — settle any well-formed shape, unchanged. Generalization is a small, safe move on ground we already poured.

We build four things, in order, and we retire one name into another.

## 1. The **sky** — a loadable topology profile *(name proposed)*

A **sky** is one community's chosen shape of its own heaven: a Bron descriptor, composed by Brix, that names everything the geometry needs and nothing the ledger shouldn't know. One sky file replaces the hardcoded constants of today's `topology.rye`.

A sky names:

- **the quorum** — the base group size, asserted **odd** so every vote clears without a tie-breaker;
- **the tiers and their fan-outs** — how many of each rank, and how many children each holds (the d12·d60 sky says twelve galaxies, five stars each, twelve planets each; another sky says a five-element fifteen, a triad's fan-out, a leaf count that lands on a meaningful number);
- **the theme** — the names the tiers and places wear (elements, stations, roles), so a place is legible before its number is read;
- **the routing rule** — how two places count the hops between them.

The d12·d60 constellation becomes exactly *one sky file*, seated beside the new ones rather than replaced. (`sky` needs a whole-tree collision grep before it is seated as a real name; it is a proposal here, chosen for being a plain warm word that fits a constellation the way `Pond` fits an enclosure.)

## 2. `topology.rye`, parameterized

The tier constants lift to read from a loaded sky. Every existing assert and bound stays; `encode`, `decode`, `parent`, and `route_hops` keep their contracts and simply read their numbers from the profile. The witness grows a **second sky** and proves both round-trip — a number to a place to a number, on every point of each — so the generalization is witnessed, not merely believed.

## 3. `settlement/constellation.rye`, unchanged in spirit

The ledger already settles by asking topology; it keeps all five transitions and all its refusals across any loaded sky. Only its bound moves: `constellation_max` becomes a function the loaded sky computes (its galaxy's full descendant count) rather than a fixed sixty-six. Nothing about mint, escape, or the version discipline changes — the proof that a number settles once under its rightful sponsor holds for every sky.

## 4. The **role tilak** — a member's worn roles *(names proposed)*

A Kumara point already carries tilaks — signed records of who it is and how it moves. We add one more: a **role** tilak, signed like the rest, carrying a member's station in the sky they inhabit. It holds two things the study grounds:

- **a mode** — one of **initiator · sustainer · adapter**: the function a member serves in their triad. A healthy group of three holds one of each — one to open, one to hold, one to bridge — and the typing recurses up the fractal (three triads become an initiator-triad, a sustainer-triad, an adapter-triad). Odd *and* complete.
- **three role-dimensions** — **contend · solve · calling**: how a member fights, how they think a problem through, and what they are ultimately *for* (their class, in the sense a well-made game gives a character a class deeper than a costume). Orthogonal: two members may share a calling yet contend and solve entirely differently.

The classical grounding for these — which divisions of an old tradition name which role — lives in the one external study this brief points to. Here they are ours: plain words for how a person shows up.

## 5. Pond loads a sky — and Pool retires into it

**Pond becomes the full application module of Grain.** It already holds `apps/` and a `customs.rye` policy seam; it reads a customs policy at receipt, and it will as easily read a **sky** at startup — hosting a constellation on that loaded shape. Pond loads a sky the way a console loads a game: one community runs the civic d12·d60 sky, another runs a five-element project sky, a third a role-woven social sky. The ledger beneath them is one honest thing.

The name **Pool** retires into Pond. The applications-host framing Pool carried was a vane-grid vestige the tree's own reframe already released; Pond is the warmer, safer, already-growing name. This is a **molt**, not a cut: a living Pond mutant supersedes the dated Pool study, which stays a readable fossil.

## 6. The social layer — roles worn, kin across skies

Because a role is signed and legible, it is also findable. Members who share a **calling** form a guild that crosses every local tree; those who share a **contend** style can spar and teach across constellations; the **initiators** find the initiators. Comlink already gathers peers by what they carry; it gathers role-kin the same way. Realidream can render the sky a member moves through and the role they wear within it.

A role worn is an **outfit**, and if we draw the figure, the cloth is honest: hemp, linen, or ramie — the low-water, quick-drying, sustainably grown fibers — never cotton's thirst nor a synthetic's fossil thread. What a thing is imagined in says what it values.

## Sequence, and What Waits

The build order, once opened:

1. Seat `sky` (after its collision grep) — the Bron/Brix descriptor and one hand-written sky beside the d12·d60 one.
2. Parameterize `topology.rye`; grow the witness to two skies.
3. Move `constellation_max` to a sky-computed bound; re-run the settlement witness on both skies.
4. Add the **role** tilak to Kumara; witness the mode and the three role-dimensions signing and refusing.
5. Teach Pond to load a sky; retire Pool into Pond by molt.

**Decisions already made** (a maintainer's word): the **breach opens after JARL closes**, not before (`20260809`); the **molt sweep stays tight** — the Pool study and its direct kin only (`20260809`); and the **base scarcity is the d12·d60 fractal**, the elder Azimuth ranks retired (`20260810`) — the Point tilak now reads its tier straight from the topology. **Held still:** the exact counts a *given* sky names for its own tiers (a per-profile choice), and how small the shared surface can shrink.

---

*A community should choose the shape of its own sky, wear the role that fits the hour, and find its kin by what they share across every constellation — all held in one vessel, over one ledger that settles the same whether the heaven above it holds twelve galaxies or fifteen.*
