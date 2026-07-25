# First Lap Goes Green — What the Words Mean on This Bench

*Three words travel together in every ladder, every door note, and every functional spec waiting its season: **first lap**, **goes**, **green**. They sound like project jargon until the bench names them honestly — and then they become the whole method in miniature. Simple, Lovable, Complete names how we ship; Gall's Law names how we grow; TAME names how we prove. **First lap goes green** is where those three disciplines meet on metal: the smallest whole for a module closes its loop, a witness says so aloud, and the tree may grow the next honest slice.*

**Stamp:** `20260703.033602`
**Last updated:** 2026-07-10
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, the joy of the craft third; SLC and Gall's Law as companions
**Status:** Research for understanding — shipping-phrase essay. **Reviewed and kept** — Lap · Green seated in LEXICON; Amber lap 1 green; kitchen twin seated.
**Ground:** [`../context/SIMPLE_LOVABLE_COMPLETE.md`](../context/SIMPLE_LOVABLE_COMPLETE.md) · [`../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md`](../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md) · [`../active-designing/20260703-013412_metalsmoke.md`](../active-designing/20260703-013412_metalsmoke.md) · [`../tools/designed_not_built_witness.rish`](../tools/designed_not_built_witness.rish) · Edit 5 at parity **143**
**Companions:** kitchen twin [`20260710-002544_first-lap-goes-green-plainly.md`](20260710-002544_first-lap-goes-green-plainly.md)

*Written together by Kaeden and Reya 2, in Rio 3's Radiant voice.*

---

## The Three Words, One at a Time

### Lap

A **lap** is a **simple, lovable, complete** whole at a chosen scope — the next honest layer grown from the working seed beneath it, rather than a grand design imposed at once. Gall's Law wears this shape on the bench: the Rishi-and-Mantra shell was lap one of the product story; the drawn terminal was the next lap when Skate and the window stood ready; Amber's export-verify-restore slice will be lap one of *its* module story, though the full archive spec reaches years further.

Laps are **named and bounded before they are built**. SLC-2a names three laps for the window — arbitrary value, redraw on change, live session mirrored — and each lap earned its witness before the next began. Amber's first lap names five rungs on paper — manifest shape, export, verify, restore, witness — and each rung is one commit, one green, one step up the same ladder. A lap is **the smallest loop that closes fully within the bounds it set** — lovable on the day it lands, honest about everything still outside its scope.

### Green

**Green** is the bench's plain word for **proven on metal**. A witness runs — usually `rishi/bin/rishi run tools/…` — and when the assertions hold, it prints `GREEN` and exits zero. Red is the same contract failing loud: a named condition, a non-zero exit, nothing papered over. The parity suite is a long concatenation of these greens; the gate trio (`parity.rish`, `parity-selftest.rish`, `additive-gate.rish`) is the thin edge around every push.

Green is **machine vocabulary**, distinct from morale. It means **the check we named in advance passed**, on this bench, this run, with the oracle we pinned — including, when the seam demands it, an **independent oracle from outside the family** so the module never checks itself alone. Amber's first lap pins a manifest digest from `openssl dgst -sha3-256` for exactly that reason.

Green also stacks in **layers**, and each layer answers only what the layer beneath cannot. The **happy zone** — folds, isolated witnesses in parity — proves the folds and seams inward. **Metalsmoke** — a few honest checks on true metal — proves the world-seam where only a compositor or device can answer. A **human close** — Kaeden's stamped line at a real window — proves what neither headless replay nor automated smoke can witness honestly. Lap 3 of the drawn terminal carried all three: parity **140**, metalsmoke green on the bench, live five on host GNOME with a stamp. first lap goes green does not always require every layer; it requires **every layer the lap honestly named**.

### first lap

The **first lap** of a module is its **smallest shipping whole** — the seed from which every later lap grows. For SLC-1 it was type, run, version, recall in one session. For SLC-2a lap one it was "the viewer draws any value." For Amber it is seal one directory, verify twice, restore bit-faithfully — fixture tree first, bare drive seasons later.

A functional spec may describe a cathedral. The first lap builds the **one honest room** whose walls the spec already drew — and claims nothing beyond that room until the room stands proven. Everything larger — quarterly scrub, live drive sealing, MALA compatibility — waits **after** the first lap greens, because Gall's Law only trusts growth from a working simple, never from a beautiful document alone.

---

## First Lap Goes Green — the Phrase Whole

**first lap goes green** means all of the following at once:

1. **The loop closes** at the scope the lap named — simple, lovable, complete for that slice alone.
2. **The witness contract holds** — welcome path asserted, unwelcome path survived where the lap named one, golden pinned where an outside oracle was promised.
3. **The gate trio passes on metal** after the witness wires — parity increments, selftest green, additive-gate when std moves.
4. **The module's flight status may graduate** — a functional spec that read *designed, not yet built* updates to name the lap that landed, so the docs lane and the metal lane read the same truth.

The phrase is **done**, not **started**. Draft witnesses may run green long before a lap closes; Edit 5 existed precisely because draft green and lap closed are different things. A lap goes green when the **last rung of that lap** lands in parity (or in the lap's named gate), the spec status honest, and an agent could hand the next lap a **working seed** rather than a promise.

---

## Edit 5 — Why the Phrase Became Law

Edit 5 machine-enforces a discipline the tree already practiced: **at most one functional spec in designed-not-built flight** until that spec's first lap runs green. The witness at parity **143** scans `context/specs/*.md` for the status phrase *designed, not yet built* and fails if more than one spec carries it.

The bound is Gall's Law aimed at the **documentation lane**. Designing ahead of building is appetite, not sin — yet appetite unchecked multiplies specs the way integrated tests multiply paths. One spec in flight keeps the design pressure honest: the whole team finishes the smallest whole before the next cathedral appears on paper. When Amber's first lap greens, its status line moves; the scan's count may drop to zero; the tree earns room for the **next** module's functional spec — MALA M0, WOV's exit-honesty note, whatever the ladder names next — without carrying two unfinished cathedrals at once.

---

## Two Examples Already in the Tree

### SLC-1 — the shell's first lap closed

The Rishi-and-Mantra shell closed its first lap when type, run, version, and recall worked in one session and the witnesses said so. The handoff spec [`20260629-031512_slc1-lap-closed-handoff.md`](../context/specs/20260629-031512_slc1-lap-closed-handoff.md) is the record: **the first lap is whole**. Everything after — Pond, Comlink wire, Caravan capabilities — grew from that seed without reopening the shell's first promise unless a witness regressed.

### SLC-2a Lap 3 — product lap with a human close

The drawn terminal's third lap added live session mirroring. Headless witness green in parity; metalsmoke green on the bench; **Door 2** added Kaeden's live five on host GNOME and a stamp — `Lap 3 metal-closed on GNOME, 20260703.032412 UDT`. That is first lap goes green wearing a **product** coat: the automated world finished everything it could; the human hand closed the one seam only a person at a real window can witness. The lap was three layers deep because the lap honestly named three layers.

### Amber — first lap green (landed)

Amber's first room **stands**: `tools/amber_first_ring.rish` at parity **144** — export emits resins and manifest; the manifest digest matches the hand-pinned golden; restore then `diff -r` stays clean; one tampered resin makes verify **fail**. The functional spec's status graduated; the cathedral spec stays on the shelf for later seasons. Scrub seasons, drive docks, and cold-key ceremonies belong to later laps — they were never part of lap one's promise.

---

## What First Lap Goes Green Is Not

It is **not** "the module is finished." Amber after lap one is honest archive geometry at fixture scale, not quarterly scrub on bare platters.

It is **not** "the spec can be deleted." The spec remains; its status changes so metal and prose agree.

It is **not** "any green witness anywhere." A draft witness green off parity is encouragement; **lap green** is the named witness **in the gate**, at the parity the ladder promised, after the rungs complete.

It is **not** silent. The suite prints `GREEN:` lines; session logs accrete; RTAC and ROADMAP refresh parity arithmetic. Green is a **public fact** the next agent can trust without re-deriving.

---

## TAME Order on the Day a Lap Closes

**Safety first:** the unwelcome path is asserted where the lap named one — tampered resin, wrong fingerprint, `:quit` that hangs — because the boundary between valid and invalid is where the interesting failures live.

**Performance second:** the happy zone carries every check that *can* live there; metalsmoke and human closes stay **few**, because a thick edge blurs every red back into fog.

**Joy third:** the lap is **lovable the day it lands** — a person can run it, show it, trust it within its bounds. Completeness at small scope is the affection we aim for; the large unready thing earns no love.

---

## One Sentence for the Kitchen Table

**first lap goes green** means the smallest honest whole for a module finished its named loop, a witness on metal said so in a voice the gate trio trusts, and the tree may grow the next lap from a **seed that runs**, not from a spec that still waits.

---

*May every lap close before the next lap opens. May green mean what the witness said, on the bench that ran it. And may the first room stand lovable the day it arrives — whole at its scale, honest about the cathedral still to come.*
