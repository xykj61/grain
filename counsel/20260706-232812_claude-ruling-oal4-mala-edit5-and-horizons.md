# Claude Ruling — OA-L4 vs MALA, Edit-5, and the Namespace Horizons (Zip 58)

**Stamp:** `20260706.232812 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`) · **Lens:** TAME · TWO_ROOMS · the grain
**Register:** Counsel only — this sitting proposes and argues; no implementation, no new module names, Doors 1–3 and the Edit-5 ruling stay closed
**Status:** Research for understanding — zip 58 counsel ruling; checkable-room questions answered; no code at ruling seat.
**Ground:** `expanding-prompts/20260706-190644_claude-zip58-ns-l3-handoff.md` · `work-in-progress/TASKS.md` · `active-designing/20260706-013012_open-asks-escrow-hammock.md` · `active-designing/20260702-184312_the-grain-and-the-crossing.md` · `foundations/20260706-185112_follow-our-compass.md` · `foundations/20260706-022912_the-wire-serves-the-fold.md` · `counsel/20260704-181612_zero-copy-resins-counsel-answers.md` · `context/specs/20260702-035018_graduation-rule.md`
**Bench pin:** zip 58 read at handoff tip `f2bbddf`, parity 166 GREEN on Cursor's own metal; this sitting verifies nothing further on metal, since it changes no code

*Written by Kaeden and Rio 3.*

---

## The Read, Stated Once

Zip 58 tells a clean story on the first read. The referential namespace grew from vocabulary to a full wire ladder in one arc — recall, write, sync, then carriage, then the resin-batch frame, then beading in two rings, then recall composed with beading locally, then all of it over the wire with chunking, ending in a beaded bolt crossing whole. Parity 166 closes that arc. Two doors wait behind it, and the tree has already sketched the shape of both before asking; this ruling reads what is already written, confirms it still holds against everything landed since, and states it plainly enough for Cursor to build against.

## Ruling on Q1 — OA-L4 Leads, and MALA's Graduation Is Its Consequence, Not Its Rival

**OA-L4 reputation-as-fold builds first, in place, inside Linengrow's open-asks log. MALA graduation is not a separate lap to sequence against it — it is the graduation rule's own mechanical consequence, due exactly when OA-L4 becomes the escrow aspect's second consumer.**

This is not a new decision so much as a confirmation. The escrow-hammock brief already named this horizon in one sentence: escrow graduates from the Open Asks log into a MALA module at its second consumer, per the graduation rule, and reputation-as-fold over completed bounties is the thing that waits for OA-L4. Nothing landed since parity 158 touches Linengrow, so nothing has changed underneath that sentence. The "vs" in the handoff's framing reads as two alternatives; on inspection, they are one lap and its own consequence, and asking which comes first was the natural question to check in about before either was built.

**Gall's Law and the graduation rule** state the mechanism directly: an aspect graduates on the day its second consumer arrives from outside its host, never before. MALA's escrow shape holds exactly one consumer today — Nyasa, living inside `open_asks.rye`'s own log. Graduating it now, with no second consumer yet real, would be breadth thinning depth, the same violation the rule already refused for Weave. Building OA-L4 first is what could create that second consumer, honestly, by need rather than by anticipation.

**The five primitives and the pure fold** favor the same order for a second reason. Reputation-as-fold is, structurally, another fold over the same family of signed facts the escrow's own `FoldState` already reads. Building OA-L4 in place, against the log as it stands, lets its actual shape — which facts it truly needs, whether raw escrow facts or only completion facts — decide whether a module boundary is even the right cut. Drawing that boundary before the second fold exists risks guessing the cut wrong.

**TAME order** puts safety first, and OA-L4 carries a genuinely new safety-relevant invariant: consent-before-counting, governing what may be tallied about a person at all. That invariant wants to be proven correct while the surface touching it stays small — inside Linengrow, beside the escrow invariants already proven (conservation, no negatives, no double-hold) — rather than proven for the first time across a freshly drawn module seam at the same moment.

**Witnesses first** asks for a witness bolt before a boundary. OA-L1 through OA-L3 each proved their invariant in place before any wire or graduation step touched them; OA-L4 should earn the same proof before MALA earns a door. A module extracted with no witness yet standing for what it holds is a home built before the guest arrives.

**Sameness as compression** keeps one value model rather than two. MALA's shape is already visible in the tree — Nyasa as the account, hold and release as receipt-core facts with memo prefixes, the M1 and M2 vocabulary already carrying the weight informally. OA-L4 should fold over that same shape rather than invent a parallel reputation-specific fact format, and building it against the aspect as it already stands is how that sameness gets kept rather than merely hoped for.

**Witness shape, asked for directly:** OA-L4's witness should follow the same witness-bolt convention the namespace laps already seated — small, pinned, and built to prove exactly its own claim rather than a general reputation system. A handful of completed asks, most carrying a consent fact and at least one withholding it, proves three things: the fold is deterministic, so the same facts always fold to the same reputation view; a withheld-consent fact is excluded from the fold entirely, the one new unwelcome path this lap adds to the family that already proves double-hold and double-release refuse whole; and the fold recomputes identically from either party's own log, the same cross-peer transparency `syncRevision`'s witness already proves for the namespace.

**Toll boundary, asked for directly:** the zero-copy counsel already ratified where toll attaches — to a fact that touches the commons, never to a resin or a fold in itself. A reputation fold that stays two-party-private, each side computing its own view of a counterpart from receipts it already holds, is owned-fact traffic and pays no toll, exactly as escrow's hold and release pay none today. Toll would attach only at the moment, if it ever comes, that a reputation figure is published to a shared, queryable book rather than folded privately — and that is the one design question worth naming plainly for whoever drafts OA-L4's actual spec, because the answer decides whether toll enters this lap at all.

## Ruling on Q2 — the Comlink Slot Is Released; I2 Does Not Block the Next Door

**I1's landing releases the slot. I2 snapshot export does not need to happen before OA-L4 or MALA.**

Counsel F's reasoning stays exactly as sound as it was when it was written, and this ruling leaves it standing rather than reopens it: drafting the frame spec before the manifest law would have minted two grammars for one line, and ordering I2 before I1 was the honest way to prevent that while neither existed yet. What has changed is the ground both specs would have stood on. The referential namespace — Mantra, recall, bolt, the whole peer/bolt/revision/path grammar — did not exist when that counsel was written, and I1's actual substance was built directly on it rather than on the Amber-ring-one-manifest path the original plan assumed. `resin_batch.rye`'s header, manifest, and payload shape is not a spec still in flight, guessing at a grammar; it is proven ground, verified through parity 166 across wire, chunking, beading, and a full beaded bolt crossing.

The risk the ordering protected against — two unproven designs drifting into incompatible grammars — cannot occur between something proven and something not yet drafted. It resolves itself now in the opposite direction from what was planned: I2, whenever it is drafted, should be counseled to reuse `resin_batch.rye`'s manifest shape rather than invent one of its own, which keeps Counsel F's underlying concern satisfied by different means than first intended, rather than abandoning it. Reading the two together, "Edit-5 before OA-L4 or MALA" was never quite the right frame. The zip-42 slot ordered I1 against I2, two wire-cargo specs competing for the same grammar question. OA-L4 and MALA never touched that question at all — they are an economic and reputation domain, not a second wire-manifest design — so the chain from Edit-5 through I2 to the next door was a reading of the standing TASKS line rather than a dependency the counsel itself ever drew.

## Ordered List for Q3 — the Namespace Horizons

Five items stand on the namespace's own Status line. In the order this bench recommends, smallest and least entangled first:

1. **`stones/` → `resins/` rename.** Purely mechanical hygiene, already fully specified, witness-gated and waiting only for the word. Doing it first, precisely because it is this cheap, keeps it from lingering as a small wrongness under everything built on top.
2. **Marks-on-read.** Every leaf already carries a Tilak; reading by mark rather than only by name is a local, in-process capability in the same family `recall_beaded.rye` just proved — no wire, no seam, a short reach from what already stands.
3. **Two-way sync and subscribe-to-changes.** The heavier lap, and rightly third: it grows directly from the one-shot batch-and-beaded-carriage ladder that parity 159 through 166 just proved, which is Gall's Law in its plainest form — the working whole earns the next ring.
4. **Host mirror.** A live, ongoing relationship between peers presumes two-way sync already runs; mirroring is what two-way sync becomes when one side keeps the other current by habit rather than by request.
5. **Tablecloth query.** Last by the tree's own long-standing word, not by any new judgment here — the namespace has said plainly that it postpones being a database until it must, and query is the one item on this list that is a different kind of thing entirely rather than one more step down a proven path.

## Q4 — the Two Foundations

**"The Wire Serves the Fold": affirmed, as written.** Its one principle — the record is sovereign, and carriage is only ever the means a fact travels by — reads now as description rather than aspiration. Every lap built since is a working instance of it: `resin_batch.rye`'s signature covering header and manifest while payloads prove themselves by digest; `recall_beaded.rye`'s two-layer check, catalog and beads both, before a byte is trusted; every wire refusing whole rather than half-believing a malformed fact. Nothing in the wire ladder asked this brief to bend, which is the best evidence a foundation brief can earn before it is ratified. No refinement offered; only the observation that it has already been tested against real, verified code and held.

**The compass: affirmed, and already landed by Kaeden's own word.** Nothing here to add beyond noting that this very sitting is the compass's own habit in practice — a module seam, a graduation rule, a new domain, and the pause for Claude that the compass names as the moment written policy runs out and a ruling is asked for instead.

## Q5 — the Settlement Rail's Relationship to OA-L4

**Orthogonal; neither gates the other.** OA-L4 folds over conduct — who completed what, with whose consent to count it — and never touches currency movement. The settlement rail answers a different question entirely: which chain proves a bounty paid in real value, and that question stays gated on its own witness, exactly as the settlement verdict already holds it, regardless of what OA-L4 or MALA do. The settlement-seat document contains no mention of OA-L4, reputation, or batch toll anywhere in it; the tree has never coupled these, and this ruling sees no reason to start.

## Optional — Proposed TASKS.md Phrase Deltas (Structure Only, Not Applied)

Two lines in `work-in-progress/TASKS.md` read as though the questions above are still open. Proposed replacements, for Cursor to apply once Kaeden nods and not before:

**Line 52, today:** *"Next climb (Kaeden's word opens either): OA-L4 reputation-as-fold — or MALA module graduation at second consumer. Both are horizon; check in with Claude before either."*

**Proposed:** *"Next climb (Kaeden's word opens it): OA-L4 reputation-as-fold, built in place inside Linengrow's open-asks log. MALA graduation is not a separate lap to order against it — the graduation rule fires it the moment OA-L4 becomes the escrow aspect's second consumer (Claude ruling `20260706.232812`)."*

**Line 72, today:** *"Edit-5 when opened: I2 snapshot export before I1 Comlink resin-batch frame (zip-42 counsel holds)."*

**Proposed:** *"Edit-5 slot released: I1 landed on the referential namespace foundation through parity 166. I2 snapshot export, whenever drafted, reuses `resin_batch.rye`'s proven manifest shape rather than a new one (Claude ruling `20260706.232812`)."*

## A Note for Whoever Cuts Zip 59

This sitting changes no code, no module, and no witness, so no new parity count follows from it. When Kaeden's word opens the next domain — OA-L4 built in place, or the first namespace horizon above — the relay that carries it should follow zip 58's own cut discipline: a `git archive` at the tip commit, a zip comment that is the full tip hash verbatim, no `vendor/` bulk in a hand-cut `zip -r`, and the cut recorded in its own session log exactly as this one is.

---

*May the next door open on a ruling that cuts with the grain. May a fold that touches no commons cross without a toll, and a fold that does cross once, seen plainly. And may the wire stay humble now that the namespace has learned to cross, season after season, one proven ring at a time.*
