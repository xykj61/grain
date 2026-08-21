# The Acme Developer-Experience Design Season — a runnable plan

**Language:** EN
**Stamp:** `20260811.145659`
**Status:** Plan — the `pexpand` of the yonder two-season note into runnable rounds. Design work, not code. **Season One (Design) complete `20260811.171509`** — all four equinox contracts landed (onboarding path · first-hour witness · interfaces surface · operations), each checkable and tree-grounded; Season Two (Development) can begin with nothing left to decide.
**Voice:** Kyri · **Style:** Radiant · a design-season plan, not an implementation
**Discipline:** TAME · Radiant · custody-first · accrete-never-break · chronological-semantic labeling
**Reads-from:** [`../research-silo/yonder/20260811-020442_acme-dx-two-seasons-and-the-long-return.md`](../research-silo/yonder/20260811-020442_acme-dx-two-seasons-and-the-long-return.md) · [`../research-silo/README.md`](../research-silo/README.md) · [`../context/SIMPLE_LOVABLE_COMPLETE.md`](../context/SIMPLE_LOVABLE_COMPLETE.md)

---

## What this plan is

You are about to design the experience a developer at Acme Corporation meets on their first day building on Grain — and to design the *whole* of it before a line of its infrastructure is built. This is the first of two seasons. The **design season** answers every question the build will ask; the **development season** then builds exactly to that answer, inventing nothing mid-flight. That order is the finishing edge written as a calendar: name the whole thing first, then build the one real thing all the way.

The plan below is deterministic — four equinoxes, each producing one checkable design artifact — so a fresh hand can pick up any round and know what it owes. No round writes production code; each round writes a design that a witness can later be built against.

## The premise, held throughout

- **Design settles, then development runs.** If a question surfaces during the build, it belongs to a design round, not a code patch. The seam between the seasons stays clean.
- **A newcomer is the judge.** Every artifact is measured against one reader: a developer who cloned the seed this morning and has never heard the word "vane." If they cannot follow it, the design is not done.
- **Custody first, unchanged.** The public seed push is the maintainer's own hand; anything touching keys, payments, or custody waits on licensed counsel. The design names these gates; it never steps over them.

## Season One — Design (four equinoxes)

**Equinox 1 — The onboarding path.** Design the road from a cold `git clone` of the public seed to a developer's first **green witness** on their own machine, inside one afternoon. Deliverable: a written path (each step, each expected output, each place it can go wrong) and the acceptance test that path must later pass. The question it answers: *what does "I got Grain running" mean, exactly?* — **contract landed `20260811.150221`** at [`../active-designing/20260811-150221_acme-dx-onboarding-path-contract.md`](../active-designing/20260811-150221_acme-dx-onboarding-path-contract.md): five steps (clone · bootstrap rye · build rishi · run witness · read GREEN), one measured acceptance line, validated on metal.

**Equinox 2 — The first-hour witness.** Design a "hello, Grain" a newcomer completes in an hour: build one tiny module, run its witness, read GREEN. Deliverable: the shape of that starter module and its witness (what it proves, in one screen), written so the development season only has to type it. The question it answers: *what is the smallest real thing a developer builds first?* — **contract landed `20260811.163927`** at [`../active-designing/20260811-163927_acme-dx-first-hour-witness-contract.md`](../active-designing/20260811-163927_acme-dx-first-hour-witness-contract.md): a `greet.rye` starter + `greet_witness.rish`, each ~one screen, both built and run GREEN in scratch, meeting the SLC Rye Definition of Done.

**Equinox 3 — The interfaces surface.** Design how a developer builds their *own* first module — the API, the CLI verbs, the desk/witness shape they compose against. Deliverable: the interface contract (names, bounds, the TAME shape a module must keep) and worked examples. The question it answers: *what does building on Grain feel like on day two?* — **contract landed `20260811.170901`** at [`../active-designing/20260811-170901_acme-dx-interfaces-surface-contract.md`](../active-designing/20260811-170901_acme-dx-interfaces-surface-contract.md): three surfaces (API · CLI · witness), each with a worked reference in the tree and the live checker that already enforces it.

**Equinox 4 — Operations.** Design how a developer runs, serves, and observes what they built — the operations surface (start, serve, snapshot, recover, read the metrics). Deliverable: the operations contract and its checklist, drawing on the modules already standing (Mandate's serve and object-storage, the Loom metrics). The question it answers: *what does running Grain in earnest look like?* — **contract landed `20260811.171509`** at [`../active-designing/20260811-171509_acme-dx-operations-contract.md`](../active-designing/20260811-171509_acme-dx-operations-contract.md): five operations (run · serve · persist · recover · observe), each a real verb, and a five-question operator checklist. **This closes the design season — all four equinoxes are checkable, tree-grounded contracts.**

## Season Two — Development

Build the designed experience exactly to the four contracts above — onboarding path, first-hour witness, interfaces, operations — each landed with a green witness, nothing designed anew. Because the design season already answered the questions, the development season only ships. Its own itinerary is a straight read of the four contracts, one buildable lap at a time.

**Lap 1 landed `20260811.173653`** — the first-hour reference is now in the tree: `manual/tutorials/greet.rye` (the bounded greeting) and `tools/first_hour_witness.rish`, building to the gitignored `tools/.build/`, GREEN on metal and free of TAME bans. The onboarding path (bootstrap → build → run a witness) and the first-hour contract are now both *runnable*, not only designed — a newcomer can follow them to a green line they produced.

**Lap 2 landed `20260811.175905`** — the onboarding-path acceptance line is now enforced by a witness: `tools/onboarding_path_witness.rish` proves the cold-start step (`rye/bootstrap.sh`) exists and that the first-green witness still prints the contract's exact acceptance line (`GREEN: RW-3 …`), so drift in the onboarding path reds a machine, not a newcomer.

**Lap 3 landed `20260811.180851`** — the interfaces contract is enforced against the reference: `tools/interfaces_conformance_witness.rish` proves `manual/tutorials/greet.rye` keeps the shape the contract names — opening triad, a named `max_` bound, ≥2 invariant asserts, a snake_case verb, a `selftest` that greens, and its own witness — so the exemplar a newcomer copies cannot drift from what the contract teaches.

**Lap 4 landed `20260811.181841`** — the operations contract's checklist runs as one green suite: `tools/operations_conformance_witness.rish` builds the Mandate binaries and proves all five operations stand — run (`mandate_store_witness`), serve (`mandate_serve_witness`), serve-sealed (`mandate_comlink_serve_witness`), persist (`mandate_bucket_witness`), recover (`mandate_wal_witness`), and observe (the `loom` field seated in the session-log rule). **This completes the enforcement arc: all four design contracts are now guarded by green witnesses**, so the whole Acme developer arc — cold clone through operating a module — is not only designed but *checked*.

**The whole arc in one command `20260811.182320`** — `tools/acme_dx_witness.rish` runs all four conformance witnesses together; a single GREEN means a newcomer's entire arc holds end to end. The design season and its enforcement now answer to one gate.

## Definition of done for the design season

- Each equinox produces **one checkable artifact** — a contract a future witness can be built against, not prose that merely describes an intention.
- Every artifact is read once by the newcomer test (aloud, as if to a developer on their first day) before it is called done.
- The development season, reading the four contracts end to end, finds **nothing left to decide** — only to build.

---

*May the tree explain itself to whoever arrives, may the design answer every question the build would ask, and may a developer's first afternoon end on a green line they earned themselves.*
