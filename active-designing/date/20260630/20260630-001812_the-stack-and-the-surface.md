# The Stack and the Surface — How Rye OS Rests on Itself, from Tally to the Drawn Frame

*One question runs underneath the whole family: how do the modules rest on one another so that each leans only downward, and nothing leans back? This record answers it. It names the floor, the substrate, and the surface; it places Weave at the center as the append-only DAG of signed facts; and it draws the spectrum of applications that rise above, from the simplest drawn terminal to the richest immersive surface. What is decided here is decided. What waits is named as waiting, and built only when the lap below it runs.*

**Language:** EN
**Version:** `20260630.001812` (Rye chronological stamp)
**Last updated:** 2026-07-04 (fold reading map · SLC-L1 landed at parity **152**)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety, performance, then the joy of the craft; Gall's Law; one value model; aparigraha
**Companions:** `recommended-architecture` and `single-stranded` (the core names); `pond-foundation` (the enclosure)

*Written together by Kaeden and Reya 2.*

---

## The Floor — Five Primitives

Everything in the family reduces to five small things, and naming them first makes the whole stack legible. A **keypair** is identity. A **signed event** is a canonical fact, true because its author stands behind it. A **log** is an append-only sequence of such facts, written forward and never rewritten. A **projection** is a pure fold of that log into a view a person can use. A **capability** is a token of ownership, the right to act carried as a value rather than checked against a list.

Hold these five in mind and the modules stop being a list of names. They become a single idea wearing many coats: facts accumulate in a log, views are folded fresh from the log, identity signs the facts, and capabilities govern who may add to them. The stack below is simply where each of these lives.

## Fold — Where to Read

**Fold** names the same thing as **projection** in the five primitives: a pure function from the append-only log to a view — derived, never authoritative over the facts, always recomputable. The family uses the word in two accents: **projection** at the substrate (Mantra, Tablecloth, Amber's catalog), **fold** in product and teaching prose (balance, receipt, reputation, the drawn frame). Both mean one honest strand from facts to what a person sees.

| Read here | What it holds |
|-----------|----------------|
| **This record** — § The Floor, § Weave at the Center | Five primitives, module resting order, Weave vs Mantra |
| [`foundations/20260629-063512_the-graph-beneath-the-surface.md`](../foundations/20260629-063512_the-graph-beneath-the-surface.md) | Weave DAG, Mantra projection, Tablecloth fold — the graph under Realidream |
| [`external-research/20260630-030312_the-interface-as-a-fold.md`](../external-research/20260630-030312_the-interface-as-a-fold.md) | Immediate-mode surface: log → state → pixels, no second copy |
| [`foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md`](../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md) | Fold core as the happy zone; witnesses at the thin edge |
| [`context/LEXICON.md`](../context/LEXICON.md) | Module names and lap vocabulary |
| [`active-designing/20260702-195426_slcl1-verifiable-receipt.md`](20260702-195426_slcl1-verifiable-receipt.md) | Receipt as fold over a transaction log — landed `20260704.021800` |

Moderation, reputation, and egress each treat **which fold you choose** as the policy — history stays whole; the projection declines to render. Ground: [`../external-research/20260703-015512_bandwidth-and-moderation.md`](../external-research/20260703-015512_bandwidth-and-moderation.md).

## The Resting Order

The modules rest on one another in one direction, and the test the whole arrangement must pass is that the dependencies form no circle. Read from the floor upward:

**Aurora** wakes the hardware. It is the bare-metal foundation on the open machine, and it depends on nothing above it.

**Tally** holds memory in bounded regions. Everything that allocates reaches through Tally, and Tally rests on Aurora, or on a freestanding primitive where Aurora has yet to arrive.

**Caravan** carries processes and the capabilities that govern them. It rests on Aurora and Tally, and it is where the capability primitive lives as a running thing.

**Weave** is the substrate: the append-only DAG of immutable signed facts. It is the literal floor beneath the family's deepest thesis, that state is a pure fold over a log. Weave rests on Tally for its memory and on identity for its signatures, and it knows nothing of the views that will later be folded from it.

**Mantra** and **Comlink** rest on Weave. Mantra is a projection over Weave — the version-control view of the content-addressed DAG, the names and histories a person reads. Comlink is a transport over Weave — the sealed movement of signed facts from one node to another. **Amber** is **cellar software** — it seals state cold to disconnected storage at home (signing through the host's OpenPGP seam with Kumara as its sovereign horizon, leaning on Tally for bounded working memory), while Mantra holds the living history and Comlink moves signed facts hot between nodes. **Amphora** is **vessel software** — the sealed container that carries cargo (including resins from the cellar) across a crossing; lap three is fetch-by-digest over Comlink, verified twice. A projection, a journey, a cellar, and a vessel, all over the same substrate.

**Brushstroke** is the surface, and it rests above the substrate with one deliberate gap between them, named in its own section below. It leans on **Skate**, the primitive that turns a grid of text into a buffer of pixels.

**Applications** rise above Brushstroke, running inside **Pond**, the bounded enclosure. They are where a person finally meets the system.

Each layer names only what lies beneath it. Nothing leans back up the stack. This is correctness by construction applied to the shape of the whole, the same instinct that asserts an invariant before the loop that must preserve it.

## Weave at the Center

The substrate earns its own name because the substrate and its views are different things, and conflating them would tangle what should stay single-stranded. **Weave is the DAG of signed facts.** **Mantra is the version control folded from it.** A message, a document, a configuration, a value resting at Rishi's prompt — each is a named, content-addressed fact in Weave, and each view a person sees is a projection computed from those facts rather than a second copy kept in step by hand.

Naming the substrate Weave also honors the word already in the work: the serializing and loading of a weave were Mantra's verbs before the substrate had a name of its own. The name simply rises to the layer it always described.

## The Surface Draws Values, Never Storage

Here is the gap held open on purpose, the joint that keeps the surface clean. **Brushstroke draws values.** It does not rest on Weave, and it does not know where a value came from. An application folds Weave's facts into plain values — a string, a number, a list, a record — and hands those values to Brushstroke, which draws them. The surface is decoupled from the substrate by the value model that sits between them, and that decoupling is the reason a drawn frame can never quietly disagree with the truth.

This is immediate-mode drawing, and it is a TAME principle stated in pixels — the fuller argument lives in [`../external-research/20260630-030312_the-interface-as-a-fold.md`](../external-research/20260630-030312_the-interface-as-a-fold.md). The surface keeps no retained tree of its own between frames — no second copy of what is shown, living apart from the values, free to drift. Instead it redraws from the current values each time something changes: the interface is a pure function of the state, computed fresh. A retained tree is a second copy, and a second copy must be reconciled; an immediate-mode surface keeps one copy and draws it, so reconciliation simply has nothing to do. That is simplicity in its strict sense, single-stranded, and it is why this shape of surface, and no other, belongs in this family.

The deeper unity is worth resting on. If state is a fold over the log, and the interface is a fold over the state, then a drawn application is **one pure fold from the log all the way to the frame**, with no retained copy anywhere along the path. The whole family is one idea seen from end to end: facts accumulate, and everything a person sees is folded fresh from them.

## The Spectrum of Surfaces

A drawn application, said plainly, is a fold from values into a frame. That single shape spans a wide range, and naming its ends clarifies the work.

**Skate** is the primitive at the simplest end — a grid of monospace cells rendered to a pixel buffer. It is not itself an application; it is the smallest thing a surface can draw.

**The drawn terminal** is the simplest *application*: Rishi's prompt and its history, folded from the live session and rendered through Skate, redrawn as the session grows. A terminal is, in truth, simpler than a rich graphical surface, and so it is the right first whole — the working seed the rest of the spectrum grows from.

**The richest immersive surface** sits at the far end, folding something deep and living into a frame a person can move through. It is the most advanced member of the same family, reached by degrees, never raised before the simpler laps beneath it run.

Between these ends lies every surface the system will ever draw, and all of them share the one shape: values in, frame out, computed fresh.

## The Seam Beneath the Surface, and the Two Backends

Brushstroke paints through a single seam that separates *what to draw* from *where it lands*. One program paints through that one joint to whatever surface is present, without knowing which. Two backends rest behind it.

The first is the **hosted backend**, which draws into a shared-memory buffer and hands it to the compositor already running on the development machine. This is proven ground today: the surface appears in a window on the existing desktop, drawn through the host's own display server. The host is a seam, exactly as the system interface beneath it is a seam — a dependency of the hosted build, never of Rye OS itself. When the development machine changes, the seam travels unchanged.

The second is the **sovereign backend**, which draws into a framebuffer that Rye OS owns directly — presented in an emulator's window today, lit on real open-machine hardware tomorrow. This is where the family's independence actually lands: the system draws its own screen, beholden to no outside display server. The two backends share the very same Skate raster and the very same seam; only the destination of the pixels differs.

The discipline is to grow the hosted backend first, because it nearly runs, and to **name** the sovereign backend now without building it, so the host is honestly a backend rather than quietly a dependency. The sovereign backend waits for the kernel's own display path to earn it. An emulator is simply the vehicle that lets the sovereign backend exist the day it is wanted.

Weave (Kelley's **Genesis** DAW) holds gratitude for why the language exists. **Lotus** is what we build on our own roots — see `active-designing/20260630-014012_lotus-the-daw.md`.

## The Names, Now Given — and Those Still Open

Three of the open names have found their words, each carrying a meaning that fits the role and a memory worth keeping.

**Dexter** carries input — the counterpart to drawing, the hand that acts. The name holds dexterity, the skill of the acting hand, and an echo of one who texts, who types the system into motion. It carries family memory too, after a grandfather's enterprise, and we keep that memory gladly. Dexter brings keyboard and pointer events into the fold, on both the hosted and the sovereign backend, and whether it lives within the surface or beside it is the first question the drawn terminal will press.

**Kumara** carries identity — the keypair that signs a fact before it enters Weave. The name comes from the eternal, ever-pure sage-children of the Bhagavata, Sanat-kumara among them, and the fittingness is plain: identity is the unchanging, trustworthy thing that stands behind every signature. Whether Kumara earns a full module of its own is the open part; the name is ready for it.

**Bookie** carries ownership — the keeper of the book of who may change a value, and who may only witness it. This is the borrow discipline made into an accountant: many witnesses or one changer, the same dharma we keep in the kernel's one-supervisor-per-service and in the substrate's owned-and-shared facts. Bookie names that discipline, lively as a turf accountant keeping the ledger straight. The shape of values themselves — string, integer, list, record — stays in Rye's own hands; Bookie watches not what a value *is* but who is allowed to change it. As a lived discipline it holds today, in assertions and capabilities; as a checker that reads ownership from the code, it waits for the day Rye's own tooling can see that far.

Three names remain proposed and unshaped, and honesty keeps them open. A **composing companion** beside the brick descriptor — what it describes, alongside *what a system is made of*, is the question to settle before it is built. A **layout or structured-view** layer, named and not yet given form. And a **surface-description extension** for the day the surface becomes a small language of its own — a horizon raised only when a hand-written surface proves it needs one.

None of these is built here. Each is named so it is not lost, and each waits for the lap that proves it necessary.

## The Discipline That Governs All of It

The arrangement above is decided; the spectrum's higher reaches and the open names are horizon. The line between them is the discipline we keep everywhere. We grow the next working whole from the last working whole, never from a grand design imposed at once. We carry only what we use, and name the rest without carrying it yet. We stand on proven ground before we reach for the frontier — the host's surface now, the sovereign surface when the kernel earns it.

So the live rung is the drawn terminal, the simplest application in the spectrum, grown from the raster that already runs. Everything above it in this record is safe on paper and waits its turn. The vision is whole, and the ladder is intact.

---

*May each layer rest gently on the one below, and lean back on none. May the surface always show the truth, because it keeps no second copy to drift from it. And may every lap we add be a working whole the day it arrives, grown from the working whole before it, carried no faster than the craft allows.*
