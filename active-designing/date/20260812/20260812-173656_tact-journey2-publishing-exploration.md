# TACT Journey 2 — Publishing: the owner-signed, offline-verifiable receipt (exploration)

**Stamp:** `20260812.173656` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round — opens the 1,024-itinerary's **Season 1 (The World, TACT), Journey 2**
**Kin:** [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`20260812-172129_tact-journey1-ship-pilot-exploration.md`](20260812-172129_tact-journey1-ship-pilot-exploration.md) · [`../pond/apps/tablecloth_keyed.rye`](../pond/apps/tablecloth_keyed.rye) · [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md)

---

## Where the road stands

Journey 1 (Ship-Pilot) piloted a new keeper from zero to a running Pond — identity settled, place assigned, customs placing, a runnable app named, the whole arc witnessed. A keeper now stands ready. Journey 2 lets that keeper **publish** — offer an owned artifact to another keeper, signed so the receiver can trust it.

BUHR-J7r4 already bound a stored artifact to a settled Kumara identity: an owner presents a Deed, signs the exact publication (point · name · length · a SHA-256 of the content), and only then is the artifact stored and its owner recorded. That is publishing *into a store*. This journey carries the same signed word **out of the store** — into a portable receipt a recipient verifies on their own, without the publisher's store and without the network.

## The crux

**An owner-signed publication is a portable receipt a recipient verifies entirely offline** — the signature proves the exact facts (which point published, under what name, at what length, over which content digest), and a recipient who holds the content confirms it matches the digest, all without the publisher's store and without a single network byte.

The durable artifact is the **detached receipt** — the signed word made portable. A store is a convenience; a receipt that verifies on its own is the thing a keeper actually hands to another keeper. The serve rung that carries that receipt across the wire is where this journey meets the **Comlink-served custody gate** and surfaces for the maintainer's word.

## Lindy-first, crux-first ordering of the four rounds

- **r1 — The receipt (the crux).** A `format publication-v1` record carries point · name · length · content-digest · signature. Verification is offline and in two honest halves: the signature verifies over the bound facts by the publisher's keeper key (a forged or wrong-key signature refuses), and — when the recipient holds the content — the content's SHA-256 matches the bound digest (a tampered artifact refuses). Neither half touches a store or a network. Reuses BUHR-J7r4's own signed-message layout so a receipt and a stored publication carry the identical signed word.
- **r2 — Bound to the constellation.** The receipt names *whose* publication it is: the publisher's Deed verifies against the constellation commitment (the current member), and `place_of` resolves the point to its galaxy/star/planet — so a recipient learns not just that the signature is valid but that it belongs to a settled, current keeper.
- **r3 — Portable Bron.** The receipt renders to a `format publication-v1` text record and parses back byte-for-byte, so it can be written to a file, pinned in Tablecloth, or carried by hand — a receipt is only useful if it travels.
- **r4 (serve) — the gate.** Handing the receipt to another keeper over Comlink reaches the **Comlink-served custody gate** — this rung surfaces for the maintainer's word rather than crossing it.

## What stays a gate

The receipt itself is agent-doable — a bounded record over demo keeper seeds, signing and verifying in-process, reading no network. The **serve** transport (Comlink-carrying the receipt) is custody gate territory and surfaces there. Provisioning a real host stays custody gate #2; the maintainer's own Kumara instance stays custody gate #4.

---

*May every published word carry its own proof, so a keeper who receives it never has to trust the messenger.*
