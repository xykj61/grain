# Loadable Topologies, and Pond the Application Module

**Language:** EN
**Stamp:** `20260809.232015`
**Voice:** Riyo
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Research for understanding -- Study and horizon -- a design exploration seated as research. Nothing here renames a module, seats a breach, or cuts a doc; every such move waits for a maintainer's word. Accrete-never-break: this paper adds, and takes nothing away.
**Ground:** The Compass Season, JARL settlement complete at five transitions (`settlement/constellation.rye`). This paper opens the two horizons that follow -- a constellation whose *shape* is chosen rather than fixed, and the Pond that loads it.

---

## The Insight, Said Once

A constellation is a **topology** -- a rule for how identities nest, sponsor one another, and route. The season just built one such rule: twelve galaxies, five stars each, twelve planets each, a galaxy leading a d60 of sixty. It is a good shape, and it was **one choice**. The deeper move is to notice that the shape is *data*, not law -- and to let a community **load the topology it wants** the way a console loads a game.

This is already almost true in the code. `comlink/topology.rye` holds the geometry -- the tier constants, the encode/decode, the sponsor climb, the route count. `settlement/constellation.rye` holds the ledger -- mint under a sponsor, transfer, rotate, escape to a sibling. The ledger never names the number twelve; it asks topology where a point's parent is and settles it. **Change the constants, and the same ledger settles a different world.** Generalization is not a rewrite; it is lifting a handful of constants into a loadable profile.

Two horizons follow from that, and this paper takes them in turn: the **shapes** worth loading, and the **vessel** -- Pond -- that loads them.

## Room One -- The Shape We Built Was One Choice

The d12-d60 constellation drew its numbers from the Vedic divisional charts: the fifth division (the circle a thing solves its problems with) times the twelfth (what it carries forward) giving the sixtieth (a life read as address). The mapping is beautiful, and it is not the only beauty available. A civic network, a project team, a social graph -- each has a native shape, and forcing all of them into 12-5-12 would be the same cage the vane grid already taught us to release.

So the question this paper answers is not "what is the right topology" but "what does a topology **profile** need to name, so that any healthy shape can be one." Three axes fall out: the **quorum** (how a group decides), the **fractal** (how the shape repeats across scale), and the **theme** (what the places are called, and what roles they carry).

*Room one source, named with thanks: the classical Vedic divisional-chart tradition (varga), studied for structure only, as the season's own `classical-vedic-astrology/` notes already record.*

## Room Two -- The Odd Quorum and the Base Case of Three

Begin at the smallest group that can decide without a tie: **three**. An odd group always clears a vote -- a strict majority exists for every question, and no chair is ever forced to break a deadlock. This is the whole reason a supreme bench seats nine and never eight, why a standing committee prefers odd membership, and why a triad is, in the sociology of small groups, the smallest arrangement that can hold a disagreement and still act. A dyad can only agree or split; a triad can **govern**.

From the base case, the shape composes. A single healthy team is three who lead and the circle they coordinate. Five such teams make a league. The numbers that fall out are the ones cultures already trust:

| Rung | Composition | Where the world already uses it |
|---|---|---|
| **3** | the base quorum | a lead triad; the smallest group that votes clear |
| **9** | 3 leaders + 3x2 | a full bench; a three-by-three of decision |
| **15** | 3 leaders + 3x4 | five elements, three to an element; a league of teams |
| **27** | 3 + 3x4x2 | the nakshatras -- a role for every station of the sky |

The ladder is **self-similar** -- "as above, so below." A league of fifteen is governed the way a team of fifteen is, which is governed the way a triad is: the same odd-quorum rule at every scale, so a member learns one habit of decision and carries it up and down the whole structure. This is the lesson of a tournament bracket and of a well-run company at once -- the shape of the final is the shape of the first round, and the shape of the board is the shape of the pod.

Two themes want naming into the profile. The **five elements** -- space, air, fire, water, earth -- give fifteen galaxies a natural, memorable partition, three galaxies to an element, so a place's element says something true about its temperament before any number is read. And the **twenty-seven nakshatras** give a role to every leaf: in a fully grown fractal, each member can *be* a nakshatra, a named station rather than an index. A number that is also a role is easier to love and easier to route to.

*Room two sources, named with thanks: the sociology of the triad (Georg Simmel's studies of the dyad and triad as the base forms of association); the odd-quorum practice of standing courts and deliberative bodies (majority rule needs no casting vote when membership is odd); phyllotaxis and the Fibonacci counts of petals and florets in nature; single-elimination bracket design in sport. The five great elements (pancha mahabhuta) and the twenty-seven nakshatras are studied here for structure and naming only.*

## Room Three -- Pond, the Vessel That Loads Them

A shape needs somewhere to run. That is the second horizon, and it renames nothing that has not already been quietly renamed by the season's own reframe.

The tree once named an applications host **Pool** -- headlined as a content-and-compute market, framed as the "P-vane" in the old Urbit vane grid. Two things have changed since. The vane grid itself is **released** -- the seated reframe says plainly that no module must claim a letter or coin a vane word, and that a clear, warm, safe name is the default. And the enclosure floor named **Pond** has grown up in the meantime: it already holds `apps/`, a `customs.rye` policy seam, and a first drawn-terminal application. Pond is the better name by every test the naming law sets -- it is a plain word, a pleasure to say, safe against every address, and it already carries a playful lineage: the *pond* where small living things run, kin in spirit to a Play store and an App store, and to the sandbox that first held these agents.

So the horizon is to let **Pond be the full application module of Grain** -- the role the elder network gave to its application host -- and to retire the Pool framing into it. Pond inherits three teachers at once, each named with thanks:

- From the elder **Gall**, the *shape of an application host*: agents that hold state, answer requests, and subscribe to one another, all above one kernel. Design concepts only; our own code.
- From the classic hypervisors **KVM** and **Qemu**, the *discipline of isolation* -- a guest runs a whole world while the host holds the boundary. These are GPL; the tree studies their public design and documentation in the clean room and never links their code.
- From the modern Rust virtual-machine monitors -- **Firecracker**, **cloud-hypervisor**, **crosvm** -- the *lightweight, fast-boot, least-privilege* posture that a per-application sandbox wants. These are permissive (Apache-2.0, BSD); safe to study freely, still written in our own hand.

Pond keeps the Glow way throughout: Rishi scripts, Rye modules, Brix composition, TAME's asserted bounds and explicit widths, Radiant prose. It is not a port of any of its teachers; it is the enclosure-and-applications floor the season already began, grown to carry the whole application role.

And here the two horizons meet. **Pond loads a topology profile the way a console loads a game.** One community loads the d12-d60 shape and runs a civic identity network; another loads the five-element, odd-triad, twenty-seven-nakshatra shape and runs a project-management constellation or a social graph. The settlement ledger beneath is the same code, because it only ever asked the loaded topology where a sponsor sits. Different worlds, one vessel, one ledger.

*Room three sources, named with thanks: Urbit's Gall application host (docs.urbit.org), studied for role and shape; the Linux KVM subsystem and the Qemu machine emulator (GPL -- public design and documentation only, clean room, never linked); Firecracker (Apache-2.0), Cloud Hypervisor (Apache-2.0), and crosvm (BSD-3-Clause), studied as the modern least-privilege VMM posture; and the enclosure lineage the tree already thanks in its gratitude notes.*

## Room Four -- Roles as Identity: Nakshatra Outfits and Cross-Pollination

When a place is also a role, identity gains a wardrobe. A person is not one station but many -- a mentor in one circle, a builder in another, a steward in a third -- and a network that names roles can let a member wear the one that fits the context, the way a profile might wear an **outfit**. A nakshatra worn for learning connects you to everyone wearing that same station elsewhere, across constellations, so a lesson found in one team's context cross-pollinates into another's. The social graph is no longer only "who sponsors whom" but "who stands in the same station as I do, in a different sky."

This is where the identity work already built pays forward. A Kumara point can carry more than a keeper and a sponsor; it can carry the role it plays in a given constellation, signed like any other tilak. Comlink already routes by the turn a point carries; it can as easily gather the peers who share a role. Realidream, the single-surface face, can render a constellation as a place you move through and a wardrobe you dress from. None of this needs a new cryptographic primitive -- it needs the topology to be loadable and the role to be nameable, which is exactly what this paper proposes.

## The Design Room -- What We Would Build, in Our Own Names

Named plainly, and held for a maintainer's word:

1. **A topology profile** -- a Bron descriptor (composed by Brix) that names the quorum size, the tiers and their fan-outs, the theme (element and role names), and the routing rule. The d12-d60 shape becomes *one profile file*, not a set of hardcoded constants.
2. **`topology.rye`, parameterized** -- the tier constants lifted to read from a loaded profile, with the same asserts and bounds, so encode/decode/parent/route work for any well-formed shape. The witness grows a second profile and proves both round-trip.
3. **`settlement/constellation.rye`, unchanged in spirit** -- it already settles by asking topology; it keeps its five transitions and its refusals across any loaded shape. Its bound (`constellation_max`) becomes a function of the profile rather than a fixed sixty-six.
4. **Pond loads the profile** -- the application module reads a topology profile at startup, the way it already reads a customs policy, and hosts a constellation on that shape. Retiring the Pool framing is a molt: a living Pond mutant supersedes the dated Pool P-vane study, which stays a readable fossil.
5. **The breach** -- a next season, seated after the current Compass Season's rounds, whose spine is Pond-as-application-module and the loadable topologies it serves.

## What This Paper Does Not Do

It renames nothing, cuts nothing, and seats no breach. The **scarcity numbers** -- how many of each tier a profile allows, and whether any profile keeps the elder Azimuth ranks -- stay a maintainer's decision. The **molt sweep** of superseded studies (the Pool P-vane paper foremost, and whatever in the archives and yonder folders the sweep would touch) is *prep, never a cut*, and waits for the word that scopes it. The **breach** into the next season is a seated boundary, taken deliberately and once. This paper is the map that those moves would follow -- offered so the shape is ready the day the word comes.

---

*A network's shape should be a thing a community chooses and a vessel loads, not a law it inherits. May the base group stay odd so every vote clears; may the shape repeat kindly from the triad to the league, above as below; may each place be a role a person is glad to wear; and may Pond hold them all -- many worlds, one honest ledger beneath.*
