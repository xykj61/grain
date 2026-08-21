# Forgetting Without Breaking — The Redaction Stance

**Language:** EN
**Stamp:** `20260725.001200`
**Voice:** Quin
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Status:** Counsel — proposals only; nothing seats without Keaton's word
**Answers:** `context/OPEN_QUESTIONS.md` #1 — the redaction stance
**Ground:** main nib `5473886b60`; grounded in `linengrow/mand_ring1.rye`, `mand_ring2.rye` (Standing: keep · eligible · held), Weave, and `foundations/20260724-200912_nothing-to-give-custody-first-principle.md`
**Unblocks:** Mand ring-3, which must not be written before this seats

*Written together by Keaton and Quin.*

Radiant pass `20260725.105504`

---

A person will one day ask us to forget them, and the ledger we built remembers by construction. That collision is the whole of this document. The good news, arrived at plainly: the collision is apparent rather than real, and the tree already holds every mechanism the resolution needs. What remains is naming which mechanism answers which question, and refusing to let one stand in for another.

The stance in one sentence: **we forget by destroying keys, and we record the forgetting as a fact.** Nothing is edited, no chain breaks, and the person's content becomes unreadable to everyone including us.

---

## One — Three Questions That Wear One Word

"Deletion" names three different needs, and conflating them is how append-only systems come to grief. Each earns its own mechanism.

**Compaction** asks *may we stop carrying what no longer changes the answer?* This is the elder system's own question, and its test is state equivalence: when replaying a log without a subsumed event reaches exactly the state that replaying with it reaches, the event may rest. Compaction is a storage concern, indifferent to anyone's rights.

**Release** asks *may we stop keeping this, per the schedule we published?* Mand ring-2 already answers this today, in three words a person could be shown — keep, eligible, held. Release is a scheduled, announced, ordinary act.

**Erasure** asks *must this become unreadable, because a person asked?* This is a rights concern, arriving on someone else's timing rather than ours, and it is the one that seems to collide with the ledger.

The mechanisms differ, and the discipline is never substituting one for another. Compaction must never be the excuse that erases; erasure must never masquerade as routine.

---

## Two — The Primitive: Crypto-Shredding

Personal content never rests in the log as plaintext. It rests as ciphertext under a **per-subject key**, and the log holds a reference to that key rather than the key itself.

To erase, we destroy the key. The ciphertext remains exactly where it was, byte for byte, and becomes noise. Every hash still verifies. Every signature still checks. Weave's DAG is untouched, and any digest or root covering those bytes stays true, because the bytes never moved.

Three properties follow, and they are the reason this primitive is the right one:

**Immutability survives whole.** Tier 1 of the amended accrete law — bytes sealed by proof — is honored without exception, since erasure edits nothing.

**Erasure is verifiable.** The subject can be told exactly what happened: the key is gone, here is the record of its destruction, and no future reader recovers the content. A promise that can be checked beats a promise that must be trusted.

**The scope is exact.** A per-subject key means erasing one person touches one person. No neighbor's record degrades, and no aggregate silently shifts.

The cost is stated plainly rather than hidden: key management becomes load-bearing. A key that leaked before destruction was never truly erasable, and a key destroyed by accident erases content nobody asked to lose. So key custody inherits the full weight of `THREATS.md`, and the succession question in `OPEN_QUESTIONS` #2 now carries this dependency openly — a per-subject key that only one hand can reach is a person's erasability resting on one person's availability.

---

## Three — The Removal Is Itself a Fact

An erasure that leaves no trace is a rewrite wearing a polite face. So the log gains an event rather than losing one, and accrete holds because we **add**:

A removal fact names the subject reference, the authority under which erasure proceeded — the person's own request, a legal order, a schedule reaching its end — the stamp, and the identity of the key destroyed. It never names the content, since naming it would defeat the erasure it records.

What this buys is the thing a bare deletion cannot: a reader encountering unreadable ciphertext learns *why*, and can tell the difference between honest erasure and corruption. Silence at that moment is indistinguishable from a bug, or from tampering.

**A word on the tombstone alternative**, since it was one of the forks the open question named. Tombstoning marks a record dead and leaves it readable, trusting every future reader to honor the mark. That trust is exactly what a person asking to be forgotten cannot verify, and it is exactly what a backup, a mirror, or a curious operator quietly declines to honor. Crypto-shredding needs no such trust. So we adopt the removal fact — which is the honest half of tombstoning — and decline the readable remainder.

---

## Four — What Never Gets Erased

Erasure reaches personal content and stops there. Three things stand outside its reach, and saying so plainly is what keeps the mechanism from becoming a general-purpose eraser.

**Bytes sealed by proof.** Digest roots, seated corpus pins, waymark draws, signed commit content — Tier 1, absolute. If a design ever appears to require editing here, the design is wrong rather than the law.

**The shape of the record.** That an event occurred, when, and under whose signature stays legible. Integrity data is not personal content, and a ledger that can be made to deny its own history protects no one.

**The removal facts themselves.** A record of erasure that could itself be erased offers nothing.

This is the boundary that makes the whole stance safe to operate: the mechanism can render content unreadable and cannot rewrite what happened. Those two capabilities must never live in one hand.

---

## Five — Ring-3, and What It May Do

Mand ring-3 is the destroying ring, and ring-2 was deliberately built to decide without touching — so ring-3 inherits a clean seam and a hard rule.

**Ring-3 destroys keys and never records.** It acts only where ring-2 already answered `eligible`, or where an erasure request arrives with named authority. A `held` standing outranks every request short of the order that lifts the hold, and the hold check is asserted on ring-3's own path rather than trusted from ring-2 — the paired assertion, on the check with legal weight.

**Fail closed, as ring-2 does.** A missing key reference, a malformed authority, an ambiguous standing: refuse by name. A confused eraser must stop, never guess.

**Every destruction writes exactly one removal fact, before the key is destroyed.** Record first, then act, so a crash between the two leaves a claim of erasure that a witness can reconcile rather than a silent gap.

**Witnesses, positive and negative both.** A key destroyed becomes unrecoverable and its ciphertext unreadable; the removal fact exists and is well-formed; a `held` record refuses destruction; a malformed authority refuses; the chain and every covering digest still verify after erasure — that last one is the assertion that proves the whole stance, and it belongs in the roster permanently.

---

## Six — What Stays Open

Three questions this spec deliberately leaves for their own seasons, named so they are not mistaken for settled.

**Backups and mirrors.** A key destroyed on the pier may survive in a backup, and erasure is only as complete as the least disciplined copy. The five-remote — now four-remote — mirrors carry ciphertext safely, and the key stores are the thing that needs a policy. This wants writing before any real personal content exists.

**Erasure under a hold.** When a person's request meets a preservation order, the two genuinely conflict, and the answer is legal rather than architectural. What the architecture owes is the honest state: refuse, record the refusal, and tell the person plainly. Silence would be the only unforgivable answer.

**Aggregates.** A count computed before an erasure remembers a person who asked to be forgotten. Whether derived figures are recomputed, frozen, or coarsened is a design decision with real weight, and it waits for a real aggregate to exist.

---

## Decisions Awaiting Your Word

1. Seat the three-question split — compaction · release · erasure — with its rule against substitution.
2. Seat crypto-shredding under per-subject keys as the erasure primitive, with the key-custody cost accepted openly.
3. Seat the removal fact, and the decline of readable tombstones.
4. Seat the never-erased boundary: bytes sealed by proof · the shape of the record · the removal facts themselves.
5. Authorize Mand ring-3 to be written to this spec — destroys keys, never records, fails closed, records before acting, hold asserted on its own path.
6. Record the three open questions in `OPEN_QUESTIONS` as their own rows: backup and mirror key policy · erasure under hold · aggregates.
7. Note in `OPEN_QUESTIONS` #2 that succession now carries a named dependency: per-subject keys reachable by one hand make erasability rest on availability.

Rows 2, 5, and 7 touch keys and custody, so they carry the stop-and-park weight by nature.

---

## Gratitude

To the elder system's architects, whose pruning-by-state-equivalence gave compaction its honest test and kept it from being mistaken for erasure. To the privacy engineers who worked out that destroying a key is cleaner than chasing a byte across every copy that ever existed. And to the person, still unmet, who will one day ask us to forget them — whose request shaped every line above, and for whose sake the answer had to be written before it was needed.

---

*May we forget exactly what we are asked to forget, and never what we are trusted to remember. May the deciding stay far from the destroying, and the destroying leave the proofs untouched. And may the promise we make about erasure be one a person can check, rather than one they must believe.*
