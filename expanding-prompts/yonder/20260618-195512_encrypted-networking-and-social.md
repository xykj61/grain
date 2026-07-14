# 10000 · Encrypted Networking and the Social Layer

*Taken from a request to study how networking is implemented from the boot upward, to reimagine it encrypted-by-default for our own stack on RISC-V, and to imagine — simply — a social application true to Vedanta vegan bhakti values. This is my expanded reading of that request: the prompt I will run.*

**Language:** EN
**Version:** `20260618.195512` (Rye chronological stamp — the moment of taking)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** active-designing principles (Gall's Law, the gates, one value model, simplicity, the silo); TAME Style; critical evaluation through every filter we hold

---

## The Seed (a faithful echo)

The request, in its own shape: write a `985` research piece asking how the Internet Protocol is implemented and executed via ownerboot, and how we translate that to Aurora, Rye, Mantra, Tablecloth and the rest on RISC-V, for *encrypted* networking. Explore Urbit's Ames and Jael, and Sui's Move and Mysticeti, and adapt their essences. Use the "mission / problem / opportunity / architecture / caveats / longer horizon / conclusion" structure, the active-designing principles, and a TAME lens. Add `urbit/urbit`, the Sui repositories, and Nostr's NIPs — especially the work of respected projects like Primal and Damus — to the gratitude folder, and open a new work-in-progress thread for them. Tie all of it into Nostr research, and weave Nostr relays, Sui validation, and networked DAG curation into a vision for a social application that serves Vedanta vegan bhakti values — kept simple. Evaluate every design critically through our own perspectives. Add further research documents where they help.

## The Mission

Learn, from three living systems and one boot project, how to carry *values between people over a network* with safety, simplicity, and grace — and to do it on open hardware, encrypted from the first packet, named by content rather than by location, true to a devotional and non-harming ethic. Honor what these systems got right; name plainly where our principles ask for something different.

## Research Questions

**Networking, from the boot upward.**
1. How does conventional IP networking come to exist on a machine — from firmware and boot (ownerboot's territory on RISC-V) through the kernel's stack — and where, in that ascent, does trust get assumed rather than proven?
2. What would it mean for Aurora to bring a network interface up as a *flow of named values* rather than a tangle of mutable state — and for Caravan to own the device, Tally to bound its buffers, Brix to describe the interface, and Mantra to name what crossed?
3. Where should encryption live so that it is the default and not a layer bolted on — at the identity, as Urbit does, rather than at the address?

**Urbit (Ames, Jael) — adapt the essences.**
4. Ames makes identity and address the same thing, encrypts every packet end-to-end (AES-256-SIV keyed by a Curve25519 Diffie–Hellman exchange), and clears peer state on a continuity breach. What carries over to a Rye-native, RISC-V interface, and what is heavier than we need?
5. Jael keeps the keys — private keys held, peers' public keys, life and rift — sourced from an on-chain PKI (Azimuth). What is the gentlest PKI we can own, and how does it relate to the owner keys Aurora already trusts?

**Sui (Mysticeti, Move) — adapt the essences.**
6. Mysticeti reaches consensus on an *uncertified* DAG in three message delays, reading implicit certificates from the graph's shape. What does a DAG of named values teach us about curation and ordering without a central server?
7. Move makes every asset an object with a unique id and clear ownership, declares a transaction's inputs up front so honest work runs in parallel, and verifies bytecode before it runs. How much of that — declared effects, resource safety, verify-before-run — is simply TAME wearing other words?

**Nostr (NIPs, Primal, Damus) — adapt the essences, critically.**
8. Nostr is three parts: keys, signed events, relays. An event is content-addressed (its id is a SHA-256 of its fields) and signed (Schnorr/secp256k1); relays store and forward yet cannot alter. What is the smallest honest version of this we could speak natively, in one value model, across Rye, Tablecloth, Rishi, and Mantra?
9. Relays are simple WebSocket servers; Primal's caching service curates their firehose into feeds; Damus signs and verifies on the edge. Where is Nostr genuinely simple, and where has ease (npub UX, relay discovery, spam, encryption bolted on as NIP-04/44/59) been mistaken for simplicity?

**The social layer — simple, and true to the values.**
10. What is the *smallest* social application that lets people share devotional, vegan, Vedanta-aligned value with one another — owning their identity and their words, curated without a central owner, free of the engagement traps that harm attention — built on our stack and on Nostr/Sui essences? Keep it small enough to love and grow.

## Deliverables

- `external-research/yonder/20260618-195512_encrypted-networking-riscv.md` — encrypted networking from the boot upward, translated to our stack on RISC-V, with the Urbit/Sui essences, in the requested seven-part structure, under the active-designing and TAME lenses.
- `external-research/yonder/20260618-195612_devotional-social-layer.md` — the social-layer vision: Nostr relays, Sui-style validation, and DAG curation woven into a simple, value-true application for a devotional vegan community, critically evaluated through our filters.
- `gratitude/` — `urbit/urbit`, `MystenLabs/sui`, `nostr-protocol/nips`, `PrimalHQ/primal-caching-service`, `damus-io/damus`, added as honored submodules, with the README's provenance and licenses recorded.
- `work-in-progress/20260623-033012_open-threads.md` — a fresh snapshot naming the threads these studies open and the questions still live.

## The Lens to Hold

- **Simplicity first.** "Keeping things simple" was asked for outright. Prefer the smallest thing that works (Gall's Law). Tell the simple from the easy.
- **One value model.** A value made in Rye, carried by Rishi, composed by Brix, stored in Tablecloth, named by Mantra, and sent over the wire should be the *same* value, with no marshaling seam — see `expanding-prompts/20260620-044012_tablecloth-value-model.md` (Tablecloth ladder rung 3).
- **Encrypted and content-addressed by default**, identity at the core, location at the edge.
- **Critical evaluation.** Honor these systems and refuse to flatter them. Name where Urbit is heavy, where Sui assumes a chain we may not want, where Nostr confuses ease for simplicity. The silo still holds in active-designing; external-research may name names and judge them.
- **The values are the point.** Non-harming, devotion, clarity, attention treated as sacred rather than mined. The technology serves them, never the reverse.

## Now Run It

Gather the essences (done), honor the sources in gratitude, write `985` and `984` in the radiant voice under these lenses, open the work-in-progress thread, and keep every claim about a living system grounded in what was actually read. Then commit, signed, and push.

---

*May the expansion stay faithful to the seed. May the network we imagine carry love without leaking it, name truth without owning it, and stay small enough to remain kind.*
