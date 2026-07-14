# Claude Counsel — Two-Way Sync and Subscribe-to-Changes (Horizon Item 3)

**Stamp:** `20260707.000112 UDT` (Kaeden's clock, read past midnight into the 7th)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`) · **Lens:** TAME · the grain
**Register:** Counsel only — the seam and witness shape, asked for before any mechanical build
**Status:** Research for understanding — two-way sync vs subscribe split; in-process build recommended; subscribe waits its own word.
**Ground:** `mantra/recall_lap1.rye` (`syncRevision`) · `mantra/recall_sync_wire.rye` · `mantra/recall_sync_delivery.rye` · `mantra/recall_by_mark.rye` (the composition pattern this counsel follows) · `foundations/20260706-022912_the-wire-serves-the-fold.md`

*Written by Kaeden and Rio 3.*

---

## The One Finding That Settles Most of This

`syncRevision` carries no asymmetry. It takes a destination catalog, a source catalog, and a peer whose revision to cross; it appends whatever the destination lacks and nothing more. Nothing in its shape says the destination must be empty, or that a peer's own catalog cannot already hold its own leaves before another peer's revision joins them. Calling it once carries one direction. **Calling it twice, with source and destination swapped and the peer name swapped to match, carries both** — and the function needing to change for that to be true is exactly zero. The wire lap wears the same shape one level up: "fetcher" and "source" are role names for a single exchange, not fixed identities, so the same hosted or device exchange run twice, roles reversed, is two-way sync at the wire.

This one finding is why two-way sync and subscribe-to-changes, named together on the horizon line, are worth splitting apart rather than building as one lap.

## Split the Lap: Two-Way Sync First, Subscribe Its Own Later Ring

**Two-way sync crosses no seam.** It is a composition, in exactly the shape `recall_beaded.rye` and `recall_by_mark.rye` already proved for this arc: a small file that imports `recall_lap1.rye` and scripts the existing primitive symmetrically, editing nothing underneath it. The witness bolt needs only one small change from what NS-L3's own sync witness already runs — instead of one peer holding everything and the other holding nothing, give each peer one leaf the other lacks. Call `syncRevision` from A into B for peer A's revision; call it again from B into A for peer B's revision; assert both catalogs now recall both names identically, and that the have-already lane still reports correctly in each direction on a second call. The unwelcome paths already proven — tampered resin, duplicate revision — need no new proof; they already hold per direction, because each call is the same function under the same guarantees. This is buildable now, in-process first and the wire lap second, the same order NS-L3's own sync climbed the first time.

**Subscribe-to-changes is a different kind of thing, and it does cross a seam.** Today's wire is `hosted_wire.rye`'s own shape stated plainly: one process sends, one receives, and the exchange is done. Subscribing — a fact arriving because it changed, rather than because someone asked — needs a source that knows who is listening and a fetcher that stays reachable between requests, neither of which exists in Comlink today. That is a real addition to the wire's behavior, not a composition over what already stands, and the foundation brief already names the right posture toward it: *"reliable carriage is transactional, and it waits its lap... taken only when a flow genuinely needs delivery it can count on. The sealed shape does not fork to gain reliability; reliability is a layer above the shape, added when its season comes."* Ongoing delivery is exactly that later layer.

## If Subscribe's Season Is Judged to Have Come, Smallest First

Should Kaeden's word open this ring regardless, the smallest lovable step is **poll, not push**: the fetcher re-runs the very same one-shot exchange on a schedule it owns, asking again rather than being told. This needs nothing new from Comlink at all — no listener, no subscriber registry, no change to the sealed shape — and it already delivers the visible behavior "changes arrive without a person typing a new request." Genuine push, where a source addresses a listener unprompted, is the heavier lift honestly named: it wants a registry of who is listening, a decision about what happens when a listener goes quiet, and a reconnection story, none of which this bench would want to invent inside a counsel sitting. That stays its own gate, opened only once polling is proven insufficient for something real.

**Witness shape for polling, sketched:** a script bounded and deterministic, in the happy zone the same way every other lap here has stayed — no sleeps, no timers inside the test itself. Append a revision after an initial sync has already run; call the same one-shot exchange a small, fixed number of times (two or three calls is plenty to prove the shape); assert the new revision arrives on one of those calls and that a call with nothing new to report costs no payload bytes, the same have-already dividend the batch frame already proved. This keeps "subscribe" witnessable on this bench rather than dependent on a live clock, exactly the discipline that let every prior lap here prove itself on metal without a hand at a machine.

## What This Bench Recommends, Plainly

Build two-way sync now, in-process first, as its own small composed file mirroring `recall_by_mark.rye`'s pattern; carry it to the wire second, the same climb order NS-L3 already used once. Hold subscribe-to-changes apart as its own later word — it is wanted, yet naming it as one lap with two-way sync would ask a zero-seam composition and a real wire addition to share one witness, one parity line, and one moment of Kaeden's word, when they earn different amounts of scrutiny. Splitting them costs nothing and lets the smaller, safer ring land while the larger one waits for its own clear ask.

## Optional — a Small Spec Phrase, Not Applied

`active-designing/20260706-023912_the-referential-namespace.md`, line 83, reads today: *"The later laps arrive each in season. Two-way sync and subscribe-to-changes are the next horizon. Tablecloth query and host mirror each keep their season."*

**Proposed, for Cursor to apply on Kaeden's word:** *"The later laps arrive each in season. Two-way sync is the next horizon, crossing no seam — a symmetric second call to syncRevision, proven in-process then over wire. Subscribe-to-changes waits behind it as its own later word, since it is the first lap here to ask something genuinely new of the wire rather than a further composition. Tablecloth query and host mirror each keep their season."*

---

*May the second direction cost no new name, and the first change that truly needs one wait for its own clear word. May every ring stay provable on this bench before a live clock is ever asked to keep it honest. And may the fold stay sovereign, however many ways the wire learns to carry it.*
