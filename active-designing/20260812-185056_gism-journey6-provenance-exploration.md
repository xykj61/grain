# GISM Journey 6 — Provenance (Season 2, Yield): exploration

**Stamp:** `20260812.185056` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **GISM** (`harvest-season-equinox-1-yield`, already seated — `.claude/rules/waymark-ladders.md`)
**Itinerary journey:** Season 2 — Yield · **Journey 6 — Provenance**
**Status:** Mixed -- Self-approved design round — opens Journey 6 of the 1,024-round itinerary
**Kin:** [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`20260812-181015_gism-journey5-real-corpora-exploration.md`](20260812-181015_gism-journey5-real-corpora-exploration.md) · [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) · [`../work-in-progress/REDS.md`](../work-in-progress/REDS.md)

---

## Where the road stands

Journey 5 stood every reading voice on real bytes — Scribble, Ember, and the graph reader now read the tree's own writing, not a demo literal, and the first real corpus surfaced Yield red #72 the moment it was read. The reading half of the tree has met real data.

The **owning** half has not. BUHR Journey 7 built Tablecloth's owner-signed catalog — a settled Kumara identity presents its Deed, signs the exact publication (point · name · length · a SHA-256 of the content), and only then may the store bead and name the bytes, so a publication resolves to *whose* it is. Every one of those proofs, though, ran over a **hand-written demo literal** (`doc_planet`, `doc_star`) — a sentence tuned to sit inside the store's bounds. A chain of custody proven only over a literal written to respect the store has never met a document a person actually wrote.

## The crux

**A real tree document carries a Kumara-signed, content-addressed chain of custody end to end — a settled identity vouches for exactly these real bytes, fetch returns exactly them, and every tamper along the chain refuses.**

Provenance is the honest question the artifact store was built to answer: *who says these exact bytes are what they claim to be?* The demo answered it for a made-up sentence; Yield answers it for the tree's own landed-edge testimony — a real waymark green-claim, a record of what actually landed at an edge, now carried under a settled identity's signature.

## The honest substrate — no network, no custody crosses

A real artifact does **not** mean a real key or a real network. Both are held gates (gate #4, the maintainer's own Kumara instance; the Comlink-served serve rung). This journey binds a real tree file at **compile time** with `@embedFile` through a symlink — the idiom Journey 5 lived with — and signs it under **demo keeper seeds only**, exactly as `tablecloth_keyed.rye`'s selftest already does. The bytes are real; the identity is a demo seat; no custody moves.

## The red the real bytes will surface

Journey 5 taught that a bound exercised only by a literal has never truly been proven. The measurements already name the collision, before a line of new code:

| Bound | Demo `doc_planet` | A real tree document |
|---|---|---|
| `tablecloth.max_content_bytes` = 512 (a resin) | ~70 B — trivially inside | `SECURITY.md` is **2689 B**, `context/TWO_ROOMS.md` **6079 B** — far past one resin |

A real front-door document does not fit one resin, and — unlike red #72's block bound — the fix is **not** a one-line raise: `max_resin_bytes` cannot rise past `max_beads × max_bead_bytes` without breaking beading's own invariant that a bead-index is itself a valid resin. So this red books an honest **design horizon**, not a bound-bump: large artifacts want **chunking across ordered resins**, a real storage layer that is its own later rung. Naming it truthfully — and proving the refusal on metal (`ContentTooLarge`) — is the round's Yield work; a small real document that *does* fit carries the chain of custody GREEN in the same round.

## The four rounds (filled, not invented)

- **GISM-J6r1 — a real artifact, owner-signed and content-addressed.** Carry a real tree document that fits one resin (a waymark green-claim — genuine landed-edge testimony) through `tablecloth_keyed`'s owner-signed store: a settled planet identity signs the exact real bytes, stores them, and `fetch_owned` returns exactly those bytes; `owner_of` → the point, `place_of` → the planet. A tampered store refuses `DigestMismatch`, a forged signature `BadSignature`, a content-mismatched signature `BadSignature` (the real digest is bound in). **Book Yield red #73** — prove a real front-door document (`SECURITY.md`) refuses `ContentTooLarge`, and name the chunking horizon. The keystone: *the chain of custody stands on a document a person actually wrote.*
- **GISM-J6r2 — the receipt travels.** Carry the real publication's **offline receipt** (`verify_receipt` — point · name · length · digest · signature, no store or content needed) as a portable proof a recipient checks without the store, then confirms held content against the bound digest — provenance that outlives the store it was born in.
- **GISM-J6r3 — the chain lengthens.** A real artifact re-published or handed under a second settled identity, each step signed, so custody is a verifiable *chain* — who held it, who signs it now — not a single stamp.
- **GISM-J6r4 — provenance true to the bytes.** Close the journey by binding the chain to the real document it claims: an independent measurement confirms the signed length and digest match the real file a keeper can open and hash, so a signature can never vouch for bytes the corpus does not contain.

Each round is one keystone, witnessed on metal, sent as its own signed increment. Demo seeds only; the real key, the real network, and any funds stay the maintainer's hand.

## What this round retires — nothing

`tablecloth_keyed.rye` and its demo `doc_planet`/`doc_star` selftest stay their own GREEN binary; the real-artifact provenance app stands **beside** it, additive, double-seated exactly as every BUHR and GISM rung stood beside the last. The demo keeps proving the wiring in isolation; the real artifact proves the chain of custody survives real bytes. Accrete, never break.

---

*May the tree's own testimony carry its author's signature honestly, may every tamper along the chain refuse the moment it shows, and may the bytes a keeper can open be exactly the bytes the signature vouches for.*
