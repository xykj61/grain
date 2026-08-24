# Mesh Inference -- A Study, Recomputed for Our Ecosystem

**Language:** EN
**Stamp:** 20260712.093812 (Kaeden's clock, verbatim)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Honors:** the iroh / n0 team (the pooled-inference pattern read in the wild, July 2026)
**Status:** Proposed study -- research for understanding; a shape to understand, not a seat to take. Every module role here is a sketch awaiting Kaeden's word and, for most rungs, a working seL4 seat first.

Radiant pass `20260728.050004` -- living rename-forward: **MUR** (was MALA)
---

## What the pattern is, in our own words

A group of machines you already own -- a laptop, a mini-PC, a workstation -- each run a small node that announces what it can do. A request arrives at any one of them and is served one of three ways: run it here, hand it to a peer that already holds the model, or split a model too large for any single machine into layer-ranges and pipe the work stage to stage. To whoever asked, it all looks like talking to the machine in front of them. Underneath, every node is addressed by a public key rather than an address, and the network's job -- traversal, fallback, an authenticated channel between any two -- is handled by a transport library so the application stops thinking about it. Honesty about cost, from the field: split inference over ordinary home networking runs at single-to-low-double-digit tokens per second, respectable for shared private compute, short of datacenter interactivity.

Our own **Anvil** already names this horizon -- a local forge with a LoRA horizon, studied against mini-PC inference. This study asks what the *networked* version becomes when every piece routes through TAME and the fold.

## The one boundary that must not be crossed

The wild version admits any peer its gossip layer accepts, and the top comment on the public thread reached immediately for the darkest use -- a self-improving botnet riding the same primitive. That is the warning our whole architecture exists to answer. So the first design fact, before any module: **a mesh node admits only peers holding a Kumara-issued pass, and every unit of work is a signed fact.** Capabilities gate who may enter; signatures gate what is true; the fold refuses anything unsigned. Membership is not open gossip -- it is customs, place-hold-refuse. This is not a feature added later; it is the seat the rest stands on, and it is the reason we can build this where the wild version cannot be trusted to.

## What we already own that maps onto it

The pleasing part is how little is new. Read left to right, the pattern is mostly our existing seams wearing one new hat.

- **Comlink** is the transport. The wild pattern's key-addressed, traversal-handling channel is exactly the seam we already decided Comlink should be -- permanent-key addressing with lanes as discardable hints, `%fade` behavior from birth. A mesh peer is a Kumara key; reaching it is Comlink's job; the wire format stays ours.

- **Kumara** is admission. Pass-gated entry is Door 3's shape, already green: keeper-issued pass admits, signature proves. A node without a valid pass is refused at the door, the same witness we already wrote.

- **Weave and Mantra** are the record. Every request, every routing decision, every completed unit is a signed fact folded into the log. Replay is safe because content-addressed facts dedupe on their own hash -- the "exactly-once effect" the mesh needs falls out of the fold for free, rather than needing a delivery protocol.

- **Tally** bounds the work. Every queue of pending requests, every activation buffer in a split pipeline, carries a named budget -- and under Genode that budget is a kernel-enforced quota. No unbounded fan-out, no queue that grows until the box dies.

- **MUR, Mandi, Dimeroll** are the economics (was MALA), and this is where our version has something the wild one lacks. Shared compute is a harvest that changes hands: a node that serves inference for a peer has done real work a community can confirm, and MUR can meter it (was MALA), Mandi can price it, Dimeroll can book it. This is the civic-style discipline turned onto compute itself -- name the outcome (useful inference actually served), name the measure (signed completion facts), keep them aligned. A giving lane and a market lane both fit: serve freely as seva, or serve priced as livelihood, the same fact shape underneath.

- **Brushstroke** is the local glass -- a node's own status and books drawn on the drawn surface, the same tokens as Linengrow.

- **Aurora / Caravan** is where a node could one day run as a sealed guest, its model-serving cell holding no capability it was not granted -- the microkernel making "this node cannot exfiltrate what it serves" a topological fact rather than a promise.

## What genuinely must be built (not owned yet)

Three things are real new work, and each is small enough to grow smallest-first:

1. **A gossip-of-capabilities seam** -- how a node announces "I hold model X, my Tally budget is Y, my recent latency is Z," as signed facts other nodes fold. This is a new Comlink aspect; it wants a name (parked).

2. **A split-pipeline ordering** -- activations flowing stage to stage is a latency-sensitive ordered stream, which is exactly Mycelium's job (Comlink's ordering aspect, gated at M4). The mesh split is a strong concrete motivation for Mycelium, rather than an abstract one.

3. **A model-runtime seam** -- the actual inference engine is a host artifact (like codecs for Maitreya), kept behind a clean seam and named in gratitude, never linked into what we ship. We orchestrate; we do not reimplement the tensor math.

## The honest verdict

This is a genuinely aligned horizon -- it turns the compass's "run on your own metal, share with your community" directly onto AI compute, and it uses almost entirely modules we have already grown. It is also far out: it depends on Comlink maturing, on Mycelium (M4), on the seL4 seat, and on a model-runtime seam we have not begun. So it belongs on the horizon in ROADMAP as a named destination that gives Comlink, Mycelium, and Anvil a shared reason to grow -- not as a lap to open now. The parity debt, the enclosure ruling, and G1 all come first. Simmer this one; it is nowhere near roughly-right yet, and that is fine.

**Teacher-keeps:** the iroh/n0 team keep their own vocabulary (endpoints, ALPN, relays, the split "Skippy" naming) in this gratitude study; our seats -- Comlink, Mycelium, Kumara -- name what we own.

---

*May the mesh we imagine admit only what it can trust. May shared compute be a harvest a community can confirm. May we simmer this until its shape is honest, and build it only on ground that already holds.*
