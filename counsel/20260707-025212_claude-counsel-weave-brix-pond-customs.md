# Claude Counsel — Weave/Brix Snapshot Slices and Pond Customs Rest on Ground That Isn't There Yet

**Stamp:** `20260707.025212 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`) · **Lens:** TAME · Gall's Law · the grain
**Register:** Counsel only, on the two items explicitly flagged as needing a ruling
**Status:** Research for understanding — counsel only; checkable claims cite code on disk; seats nothing by itself
**Ground:** `mantra/src/weave.rye` (read in full) · `mantra/recall_lap1.rye` (grepped for any dependence on it — none found) · `context/specs/20260702-035018_graduation-rule.md` · `counsel/20260704-181612_zero-copy-resins-counsel-answers.md` (Part D, I7) · `pond/` (searched for any policy concept — none found) · a tree-wide search for Brix code (none found)

*Written by Kaeden and Rio 3.*

---

## Two Quick Confirmations

The OA-L4 fix landed exactly the smaller shape this bench recommended — hold facts skip silently, a release counts as completion, and `foldReputationLog` now reads a log with both payment paths in it without refusing whole. The poll interval landed in the same place the very first production-scheduling counsel named for it, a real sleep at the cycle boundary rather than a change to anything upstream. Neither needs more from this bench today.

## What "Weave/Brix Snapshot Slices" Actually Asks For

Before shaping how to export a Weave slice, this bench checked what Weave currently is, rather than what it is described as. `mantra/src/weave.rye` is real, and it is a text buffer's living history — Lines, generations, positions, the substrate under a diff tool's undo-and-redo, imported by exactly one file, `mantra/src/diff.rye`. Nothing in the referential namespace imports it. A search across every file in `mantra/` for the word turns up nothing at all outside that one pair. Yet the namespace's own foundational paragraph reads, in its own words: *"The history is a Weave — each revision of a bolt is a fact folded onto the append-only DAG."* That sentence describes a signed-fact DAG beneath bolts and revisions. The file at the path that sentence points to describes a text editor's line history. These are two different things sharing one name and one path, and "export a Weave slice" does not yet have a single, stable thing it could mean.

This is the same shape of finding the Tablecloth counsel already named once this arc — a word carrying two meanings that have never met — and it deserves the same treatment: name it plainly, and let the smaller, truer question resolve before any code answers a question that has not yet been asked precisely. The good news is the resolution may cost nothing at all. `BoltCatalog`'s own history is already whole and already exported — I2's snapshot bundle already carries every leaf, every revision, and the head record that proves it replays. If "the Weave slice" in the sovereign-snapshot sense was always shorthand for exactly that — the catalog's own accretion, described in the namespace brief's own metaphor rather than by way of the separate text-editing file — then nothing further needs building, and the only thing missing is a sentence saying so. If instead the aspirational meaning is wanted literally, and the namespace's history should someday rest on something Weave-shaped in fact rather than in metaphor, that is a real design question about `BoltCatalog` itself, considerably larger than an export format, and worth its own sitting rather than a line item under snapshot lap three.

**Brix** needs no close reading to answer plainly: this bench searched the whole tree for any function touching a brick, a course, or a bond, and found none. The vocabulary is seated — brick, course, bond, lay — and nothing behind it exists yet. The I3 state machine's `SHAPE_CAST` step, which casts a Brix closure and checks every brick's digest present, has nothing to cast, because there is no closure anywhere in this tree to be one. Capturing a Brix closure in a snapshot bundle is not an extension to the exporter; it would be Brix's own first lap, born inside someone else's feature, which is exactly the kind of breadth-thinning-depth the graduation rule already warns against for aspects far more real than this one.

## What "Pond Customs" Actually Asks For

The same check, aimed at Pond, turns up the same shape of answer. `pond/` holds a README and the drawn terminal's app; nothing resembling a policy, a placement rule, or a customs check exists anywhere in it. The I3 state machine's `CUSTOMS` step — *Pond policy applied before placement* — describes a gate Pond does not yet have a door for. Wiring an import's customs check into Pond today would mean inventing Pond's first policy concept from inside a snapshot feature, the same shape of problem Brix has, and for the same reason: the thing being asked to receive the new capability has not yet grown the capability it would need to receive.

## The Custody Reservation Stands Exactly as It Was Written

One more thing is worth restating plainly rather than assuming it carried forward on its own. The original I7 counsel named the continuity fact's real shape precisely — an identity, a strictly increasing epoch, a parent chaining to the prior fact, and two refusal rules: reject an import while a live instance of the same identity is running, and reject an import or boot whose epoch is not newer than the last one this host has witnessed for that identity — and then reserved all of it, in its own words, as *"a Kaeden gate, parked, never improvised,"* because it touches identity custody. Reading what actually landed at parity 182, that reservation still holds in fact: the current check verifies only that the epoch is non-zero and that the fact's named identity matches the batch's own signer — a benign structural sanity check that asserts nothing about liveness, nothing about a host's prior history with an identity, and nothing that could be mistaken for the real rule. This bench names this so the gate is seen to still be standing, not to suggest anyone tried to quietly step past it — no one did. The moment either real rule is built — tracking a host's last-witnessed epoch per identity, or detecting a live instance — that is the moment this reservation becomes live rather than theoretical, and it should wait for the same word the original counsel already asked for.

## What This Bench Recommends, Plainly

Hold both named next-items exactly where they are. For Weave, the recommendation is a single sentence of clarification rather than a build: confirm whether "Weave slice" already means what I2 exports today, in which case this item closes with no new code at all, or whether it means the larger, literal thing, in which case it deserves its own sitting sized to match. For Brix, the recommendation is to let it earn its own first lap on its own terms — a closure that closes over something real, witnessed the way every other first lap in this tree has been — rather than being born as a side effect of someone else's export format. For Pond customs, the recommendation is the same shape: Pond's first policy concept, whatever it turns out to be, deserves to be designed as Pond's own capability, not backed into existence by an import path that happens to need somewhere to hand its receipt. None of this is a rejection of the horizon these items sit on — it is this bench declining to let three different empty rooms be furnished at once, each with a chair borrowed from a different, unrelated project.

---

*May a name be resolved before the code that would need it is written. May a closure never be asked to close over nothing, and a customs house never be built with no country behind it. And may the gate that was never meant to be improvised stay exactly as closed as the hand that set it down.*

---

## Kaeden's word (`20260707.030412`)

Following this counsel, Kaeden ruled: **sovereign "Weave slice" means what I2 exports today** — `BoltCatalog` accretion under `catalog/` with HEAD record. The namespace brief's Weave line is metaphor, not a dependency on `weave.rye`. No `weave/` snapshot bundle. Full ruling: [`context/specs/20260707-030412_weave-slice-ruling.md`](../context/specs/20260707-030412_weave-slice-ruling.md).
