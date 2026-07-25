# 10001 · A Content-Centric Messenger, From the Network In

*Taken from a request to design — as a TAME Rye exploration — a strengthened distillation of Urbit Ames's encrypted peer-to-peer messaging, running on our own IP, content-addressed in the spirit of Van Jacobson and of Curtis Yarvin's original "from the network in" vision, with a Rishi command-line messenger (an IRC-meets-Dojo), typed and authenticated and delivered exactly once, with zero-copy validated payloads in TigerBeetle's spirit, and a "mark"-like shape-casting that validates raw bytes — even RISC-V bytecode — against a Rye type before they are trusted. This is my expanded reading of that request: the prompt I will run.*

**Language:** EN
**Version:** `20260618.212012` (Rye chronological stamp — the moment of taking)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME Style; active-designing principles (one value model, simplicity, Gall's Law, the gates); critical evaluation through every filter we hold

---

## The Seed (a faithful echo)

Write a `982` exploration: a TAME Rye implementation of a strengthened version of the essences of Urbit's Arvo/Ames encrypted peer-to-peer UDP networking, on top of our own Internet Protocol (`985`), referencing our other research and Caravan and Tally and the rest. Give it a Rishi command-line messenger — a cross between IRC and Urbit (which has the Dojo, and once had Talk for the command line). The aim is a content-centric / content-addressed network, which was Curtis Yarvin's original vision (the 2010 "Urbit: functional programming from scratch" essay — radiant-distilled, simplified, and applied to *our* Rye OS), and which Van Jacobson reached independently as content-centric networking. Deliver messages encrypted, typed, authenticated, and exactly once, drawing too on TigerBeetle's zero-copy goal for its networked payloads — yet generalized past TigerBeetle's financial, debit-and-credit purpose to general-purpose computing, in the way Nock is a substrate for any computation rather than one domain's. Consider borrowing Arvo's "mark" model (validating the type-shape of a raw noun) and applying it to serializing, deserializing, and type-validating raw RISC-V bytecode — a kind of shape casting — if it carries no security cost beyond what Rye's type system already governs. Draw a comparison, as well, between refactoring our own version of Urbit's Landscape and drawing instead on Nostr's relays, as our recent research did.

## The Mission

To carry a *meaning* between two people — a message, content-named and encrypted to its reader — across a network that secures the content rather than the pipe, on hardware we own, in a way small and coherent enough to hold in the head. And to do it so the same value model runs from the keystroke in Rishi to the bytes on the wire, validated in place, trusted only once its shape is proven.

## Research Questions

1. **From the network in.** Curtis began his stack "from the network in," and found Van Jacobson had already had the network half of the idea: name the content, secure the content, and the pipe stops mattering. How does that reframe `985`'s encrypted datagram — from "a channel between two addresses" to "a named, signed value anyone may carry"?
2. **Ames, strengthened and distilled.** Ames gives encrypted, typed, authenticated, ordered, exactly-once delivery over UDP. Which essences carry into a Rye-native messenger on our IP, and how does content-addressing make exactly-once almost free — a message *is* its hash, so a repeat is a duplicate to drop?
3. **The mark, as shape-casting.** Arvo's marks validate that a raw noun truly has a declared type-shape (`vale`/"clam") and convert between shapes (`grab`/`grow`). What is the Rye-native form — a *shape-cast* that proves raw bytes are the type they claim — and how does it give us TigerBeetle-style zero-copy: validate the payload in place, then read it as a typed value with no marshaling seam?
4. **The RISC-V bytecode question, examined honestly.** Could a shape-cast validate raw RISC-V bytecode? What does it actually guarantee — and, crucially, what does it *not*? (The line between proving a thing's *shape* and authorizing its *execution* is the whole of the security story, and it must be drawn plainly.)
5. **The Rishi messenger.** What is the smallest IRC-meets-Dojo a person could speak today — `talk`, `send`, `read` over content-named, encrypted messages — and how does it sit on Caravan (the service), Tally (bounded gardens), Mantra (the names), and our IP?
6. **Landscape or relays.** If we grew our own app layer, would we refactor something like Urbit's Landscape, or lean on Nostr's far simpler relays (`984`)? Which serves the values, kept simple?

## Deliverables

- `external-research/yonder/20260618-212112_content-centric-messaging.md` — the exploration, in the seven-part structure, under TAME and active-designing lenses, citing the CCN literature, Curtis's essay (distilled), the Clay mark docs, and our own `983`/`984`/`985`/`994`.

## The Lens to Hold

- **One value model, validated in place.** A message keyed at a Rishi prompt, shaped as a Rye value, named by Mantra's SHA3-512, encrypted to an owner key, and read on the far side is the *same value* — proven by a shape-cast, copied never.
- **Secure the content, not the pipe** (Van Jacobson; Curtis). Identity at the core (`985`), names by content, encryption by default.
- **Tell shape from safety.** A shape-cast proves what a thing *is*; running it safely is Pond and Caravan's work. Name the seam exactly.
- **Accretion over freezing.** Curtis freezes (Kelvin, counting down to absolute zero); we accrete (chronological, never breaking). Honor the coherence he sought; reach it our own way.
- **Simple, and kind.** The smallest messenger that carries a true word between friends.

## Now Run It

Distill Curtis's vision into essences and radiant-frame them; weave the CCN, Ames, mark, and TigerBeetle threads into one Rye design on our own stack; draw the shape-vs-safety line for RISC-V bytecode without flinching; sketch the Rishi messenger and the Landscape-or-relays comparison; keep every claim about a living system true to what was read. Then commit, signed, and push.

---

*May the message arrive whole, named by what it says, sealed to the one it is for. May we prove a thing's shape before we trust it, and contain its running where running belongs. And may the network we make be small enough to understand and warm enough to carry a friend's word home.*
