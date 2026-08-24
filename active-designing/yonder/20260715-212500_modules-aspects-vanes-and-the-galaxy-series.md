# Modules, Aspects, and Vanes -- a Revived Design Sitting for the Glow OS Galaxy Series

*The 2026-07-02 sitting named two words -- **module** and **aspect** -- and the graduation rule between them. This revival keeps both whole and adds the third layer the Glow work has since made real: the **vane**, the kernel-concern host; the **runtime substrate** beneath the vanes; and the **enclosure** layer between. It re-frames the whole for the Glow OS series of small, reviewable pull-request contributions aimed at real Azimuth galaxy holders.*

**Version:** `20260715.212500` (Pacific)
**Style:** Gauge (see `../../context/GAUGE_STYLE.md`)
**Voice:** Quin
**Status:** Design -- revives `20260702-031312_modules-aspects-and-mailable-money.md` (the elder stays whole; this is born beside it, per accrete-never-break). Register: mixed -- the layering and the green laps it names are checkable; the runtime-unification proposal is design (Two Rooms).
**Revives:** `20260702-031312_modules-aspects-and-mailable-money.md`

---

## The Three Layers, Said Once

The elder defined **module** and **aspect**. The Glow work adds the **vane**, and the enclosure and runtime layers around it. Four words now, each defined plainly:

- A **module** is a named home: its own directory, invariants, budgets, witnesses, and a one-line meaning. It could stand alone if its family fell away.
- An **aspect** is a named capability *inside* a module's boundary -- sharing its host's budget and witnesses, owning no directory. Skate is an aspect of Brushstroke; Mycelium is an aspect of Comlink.
- A **vane** is a **system-concern host** -- Glow's kernel layer, a four-letter name in the family (**Neth**-settlement, **Ojjo**-benchmarking, **Pool**-applications, **Quin**-inference, **Rhyz**-identity, **Sala**-the viewer). A vane hosts modules-as-agents and owns one system-wide concern, the way Arvo's own ten vanes each own one (networking, timers, filesystem, and the rest).
- The **runtime substrate** and the **enclosure** are the layers *beneath and around* the vanes, named in `../external-research/20260715-165000_glow-non-vane-strata-and-pond.md`: Rye - Bron - Aurora - Tally (substrate); Pool's host, Caravan's capability table, Pond's customs, Puddle's ephemeral isolation (enclosure).

The **graduation rule** is unchanged and still follows Gall's Law: *an aspect becomes a module on the day its second consumer arrives from outside its host.* The Glow work added one worked instance -- **Dexter graduated `20260715.205500`** when Sala R2, the unified viewer, arrived as the second thin-view consumer the rule had been waiting for.

## Where the Vanes Sit Relative to Modules and Aspects

The layers compose top to bottom, and naming which is which keeps the tree legible:

- **Aspects** live inside **modules** (Skate in Brushstroke).
- **Modules** run as **agents** hosted by a **vane** (Linengrow, Open Asks, Dimeroll -- Gall-shaped modules -- run under **Pool**; the four inference voices under **Quin**).
- **Vanes** are hosted and bounded by the **enclosure** (Pool hosts agents, Caravan tables their capabilities, Pond keeps customs and the host fence) and stand on the **runtime substrate** (Aurora boots, Tally allocates, the fold routes).
- The **runtime substrate** is not a vane and never was -- the non-vane-strata study settled this. It is the ground the vanes stand on.

This is the honest microkernel shape, and the Pool build proved its lowest rung green: an agent *hosted by Pool*, *isolated by Caravan's capabilities*, running *inside Pond's customs*, its state a *fold* over Tally-bounded memory (P0/P1 landed `20260715.201500`-`202500`).

## The Runtime Unification -- a Named Proposal, Not a Now-Build

The Glow revival of Vere gathers three substrate modules -- **Aurora** (boot/host), **Caravan** (supervise events and processes), **Tally** (allocate memory) -- into one runtime layer. Urbit deliberately *separates* the pure Arvo kernel (the central event-fold, in Nock) from the impure Vere runtime (I/O and memory, in C); a real Glow question is whether to **unify** them into one named runtime that is both the central fold and the host.

**The honest verdict:** this unification is a legitimate divergence worth naming as a proposal, and it stays a **scoped horizon, not a build**, for three reasons:

1. It is the **kernel/runtime, not a vane** -- so a "T-vane" framing is a slight category error; if named, it is named as *Glow's unified runtime*, a deliberate divergence from Urbit's kernel/runtime split, kept honest about determinism (the pure fold stays pure; I/O and allocation stay bounded seams).
2. Retiring the **Caravan (169 refs)** and **Tally (206 refs)** names into aspects of a unified runtime is a ~375-reference migration -- a boil-the-ocean move that the reviving discipline defers to proven-supersede anyway (the elder names keep their green witnesses until the revival earns them).
3. It is design piling on design while the flagship is what ships. The finishing edge says build the next real thing, not name the next idea.

**On a name, if one is ever seated:** collision-checked against the kernel this stamp -- **Tusk** collides with a real DAG-consensus protocol (Tusk/Narwhal/Bullshark, in our own gratitude shelf, adjacent to Neth) and **Toon** collides with the real Hoon type `++toon` (a virtualized-Nock result); both are ruled out. **Tilo** and **Toma** are clean (zero kernel and tree hits). No name is seated here -- the concept is named ("the Glow runtime, unifying Arvo's centrality and Vere"), the clean candidates recorded, and the decision held per the three reasons above.

## Is the Runtime More Foundational Than the SLC?

Two different axes, and conflating them is the trap:

- **More foundational: yes.** The runtime is beneath everything; the SLC stands on it.
- **More important to ship now: no.** The SLC (Sala broadcast, green through L1-L2-L3) is what a real person can love today, and it **already rests on the runtime's real pieces** -- Pool's capability admission, the fold, Tally-bounded memory. It is honest, not floating free.

So "to stay truly honest, the SLC must be written in terms of the runtime" is right in spirit and already true in practice; the honest action is to **name that dependency explicitly** (the SLC brief rests on the Glow runtime), not to block shipping on a full runtime revival. That would be *rebuild the world before the app* -- the design-over-build trap the finishing counsel named. Gall's Law: the working whole grows from working simples, and the runtime pieces the SLC needs already run green.

## The Galaxy Series -- Small PRs for Real Galaxy Holders

Everything above is shaped for the Glow OS series of contributions aimed at Urbit's real Azimuth galaxy holders, per `.cursor/rules/azimuth-galaxy-proposal-format.mdc`. The discipline that governs it:

- **Each layer lands as its own small, reviewable PR**, sized by grep-counted inbound references (per the naming-mapping proposal), so a galaxy holder skimming many pitches can tell a ten-minute review from a season-long undertaking at a glance.
- **Green before pitch.** A PR that touches a vane or the runtime carries its witness green (the Pool/Sala laps are the model: P0-P1-B0-B1-R1-R2-B2 each a mergeable green lap).
- **Cheapest-first.** The vane family and the module-aspect layering land ahead of any runtime-unification rename, since the rename is the costliest and least urgent.
- **A Galaxy Pitch block** on any contribution substantial enough to warrant a real galaxy holder's attention -- `For` / `Ask` / `Scope` -- most often `Ask: none; informational only`, never an inflated ask.

The frame this revives -- modules earn their doors, aspects know their hosts, vanes own one concern, the runtime stays beneath -- is precisely what makes the series legible to a reviewer who is not us: each PR names its layer, its size, and its witness.

## What This Doc Does Not Claim

- No rename is made; Caravan and Tally keep their names and green witnesses, and the runtime-unification name is proposed, not seated.
- It does not claim the SLC is complete as a product -- only that it is green through L3 and honestly rests on the runtime.
- It does not resolve the four open Aurora/kelvin questions (`../external-research/20260714-013700_aurora-vere-arvo-boot-fusion-and-kelvin-strategy.md`); the runtime layer this names is where those questions live.

## Related

- `20260702-031312_modules-aspects-and-mailable-money.md` -- the elder this revives.
- `../external-research/20260715-165000_glow-non-vane-strata-and-pond.md` -- the runtime/enclosure/vane strata this builds on.
- `../external-research/20260715-172000_pool-keystone-revival-realidream-landscape.md` -- the Pool/Sala keystone whose green laps prove the microkernel shape.
- `../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md` -- the reference-counted PR-sizing this series uses.

---

*May every aspect know its host, every module earn its door, every vane own its one concern, and the runtime stay the quiet ground beneath them all -- and may each layer reach a galaxy holder as one small, green, legible pull request.*
