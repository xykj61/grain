# 982 · A Content-Centric Messenger, From the Network In

*A message is a meaning meant for someone. This study designs the smallest honest way to carry one — content-named, encrypted to its reader, typed and validated in place, delivered exactly once — as a TAME Rye distillation of Urbit's Ames running on our own IP (`985`), with a Rishi command-line messenger in the spirit of IRC and the Dojo. It begins where Curtis Yarvin began his own stack, "from the network in," where he found that Van Jacobson had already had the network half of the idea: name the content, secure the content, and the pipe stops mattering.*

**Language:** EN
**Version:** `20260618.212112` (Rye chronological stamp)
**Last updated:** 2026-06-18
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME Style (`TAME_STYLE.md`); active-designing principles (one value model, simplicity, Gall's Law)
**Reads alongside:** `yonder/20260618-195512_encrypted-networking-riscv.md`, `yonder/20260618-195612_devotional-social-layer.md`, `yonder/20260618-204012_borrow-checking-and-correctness.md`, `yonder/20260617-195712_caravan-tally-networking.md`; honored in `../gratitude/urbit`, `../gratitude/nips`
**Sources distilled:** Curtis Yarvin, ["Urbit: functional programming from scratch"](https://moronlab.blogspot.com/2010/01/urbit-functional-programming-from.html) (2010); [Named data networking (CCN lineage)](https://grokipedia.com/page/Named_data_networking) (Van Jacobson / PARC); [Clay marks](https://docs.urbit.org/urbit-os/kernel/clay/marks)
**Structure:** mission · problem · opportunity · architecture · shape-casting and the RISC-V question · Landscape or relays · caveats · longer horizon · conclusion

---

## Mission

To carry a meaning between two people — a message, named by what it says and sealed to the one it is for — across a network that secures the content rather than the pipe, on hardware we own, in a system small and coherent enough to hold in the head. And to let the same value run unbroken from the keystroke in Rishi to the bytes on the wire: shaped once, validated in place, trusted only once its shape is proven.

## Problem

Today a message is wrapped, not carried. A chat travels as bytes marshaled into a frame, sent down a secured *pipe* (TLS) to a *server*, stored, and re-marshaled out to a reader — the meaning serialized and deserialized at every hop, the security attached to the channel rather than to the words, the words themselves living wherever the server keeps them. Lose the server and you lose the conversation; trust the pipe and you trust whoever holds its end.

Curtis named the deeper version of this — the "big ball of mud" that grows until no one can hold it — and answered it with a clean, coherent stack built from a tiny core. Van Jacobson named the network version: we built a network to let *two machines have a conversation*, addressing endpoints by location, and then spent decades using it to move *named content* to whoever wanted it — fighting the architecture the whole way. Both saw the same thing from different sides: we are securing and addressing the wrong noun. Not the pipe — the content. Not the place — the name.

## Opportunity

Four threads point one direction, and a fifth — Curtis's — ties them.

**Van Jacobson's content-centric networking** makes content "directly addressable and routable," with endpoints communicating by *named data* rather than IP addresses. Its security model "explicitly secures individual pieces of content rather than securing the connection," and a Content Object's name carries a cryptographic binding to its publisher, with an implicit final name equal to the *hash of the object* ([CCN](https://grokipedia.com/page/Named_data_networking)). That is content-addressing as a networking principle — and it is exactly what Mantra already does for our history with SHA3-512.

**Ames** gives the working shape of it among people: encrypted by default, identity and address one and the same, messages typed and authenticated and delivered in order, exactly once, over plain UDP (`985`). The essence to keep is the discipline; the weight to leave is the galaxy hierarchy and the chain.

**Arvo's marks** give the typing. Clay is "a typed filesystem," and a mark "specifies such a type for its files" while also defining conversions and a way to *validate data sent between agents or over the network* ([Clay marks](https://docs.urbit.org/urbit-os/kernel/clay/marks)). A mark can `vale` — "clam" — a raw noun into its declared type, asserting validity before the value is trusted. This is type-safe deserialization as a first-class idea.

**TigerBeetle's zero-copy** goal closes the loop: if a payload's bytes already *are* the typed value, validated in place, then there is nothing to marshal — the message is read where it lands. TigerBeetle hones this for its own financial, debit-and-credit ledger; we keep the discipline and free it from that one domain, so it serves *any* typed value — general-purpose, in the way Nock is a substrate for any computation rather than one purpose's.

And **Curtis's essay** is the thread that binds them, distilled to its essences and freed of its Martian costume:

- *Coherence from a tiny core.* A stack should be small and clear enough to understand whole — "tiny and diamond-perfect" — rather than a ball of mud. This is our whole aim with Rye, Caravan, Tally, Aurora.
- *A generic data model with types at a higher layer.* He praised Unix for keeping the data generic — a bytestream — and putting type in a higher, predicate layer (a type is, in effect, a function that tells you whether these bytes are a GIF). The mark is that predicate made first-class. Our **shape-cast** is the same idea inside Rye's type system.
- *Secure and address the content.* "From the network in," he reached Van Jacobson's conclusion independently: name and sign the content, and the pipe stops mattering.
- *Determinism.* A frozen, functional core gives reproducibility — the same discipline our parity gates keep.

One difference we keep on purpose: Curtis pursued permanence by *freezing* (Kelvin versioning, counting down to absolute zero, after which nothing may change). We pursue the same permanence-of-meaning by *accreting* — chronological versions that never break a name (`rye-versioning-style.md`, `inherited-names.md`). Same destination, gentler road.

## Architecture

The design is one sentence: **a message is a typed Rye value, named by its content, sealed to an owner key, validated in place, and delivered once.** Here is how the parts hold it.

- **A message is a value, not a frame.** In Rye it has a shape — sender identity, reader identity, a content hash, a sequence, a payload — and that shape is the wire format. No marshaling: the bytes that arrive *are* the value, once their shape is proven.
- **Named by content (Mantra + CCN).** The message's name is the SHA3-512 of its content — the hash we strengthened first. Naming by content gives provenance (the name binds to the bytes) and gives **exactly-once almost for free**: a message *is* its hash, so a duplicate is simply a name already seen, dropped without ceremony.
- **Sealed to an owner key (`985`).** Encryption lives at identity, not at the address — a key agreement between two owner keys, the payload sealed and authenticated. The pipe is untrusted by design; the content needs no trusted pipe.
- **Validated in place by a shape-cast (the mark, in Rye).** Before a received message is trusted, a shape-cast proves its bytes are the declared Rye type — Arvo's `vale`/"clam" reborn as a typed, asserted read. Once proven, it is read with zero copy. A fault stops loudly, at the door, the instant a malformed message arrives — the correctness stance of `983`.
- **Carried by what we already have.** Caravan owns the network service and clears its garden cleanly on fault; Tally bounds every buffer and peer's state in a garden; our IP (`985`) carries the datagrams; Tablecloth declares the peers and channels as values. Each piece is one we are already growing.

**The Rishi messenger** is the human surface — an IRC-meets-Dojo, terse for the hand. The smallest version speaks three verbs over content-named, encrypted messages:

```
# talk.rish — a first content-centric conversation, illustratively.
let me = owner_key()

# Join a channel: a shared name, not a server. Messages are named by content
# and sealed to those who hold the channel's key.
talk join "#satsang"

# Send a meaning. It is shaped as a value, named by its SHA3-512, sealed, and
# carried over our IP. Exactly-once falls out of the name.
talk say "#satsang" "the kirtan begins at dusk"

# Read: each message arrives as a typed value, shape-cast before it is trusted,
# its author proven by the key that sealed it.
talk read "#satsang"
```

Like `pond.rish`, this is a sketch of where Rishi is headed, not what v1 runs today. It shows the shape: the same value model from the prompt to the wire, named by content, sealed to a key.

## Shape-Casting and the RISC-V Question

The most interesting question deserves the most careful answer, and the answer turns on one line that must be drawn plainly.

A **shape-cast** proves that a run of raw bytes truly has a declared Rye type — that this blob *is* a `Message`, or *is* well-formed RISC-V bytecode. This is the mark's `vale`, generalized: cast the bytes to the type, assert the invariants the type requires, and only then read it. As pure validation it is wholly safe and strictly *good*: it eliminates a whole class of faults — type confusion, malformed input, the trusting of bytes that were never the thing they claimed. It is Move's verify-before-run (`985`) and TigerBeetle's validate-in-place, in Rye's own type system. So far, no security cost — only a class of error designed away.

Now the line. Proving a thing's **shape** is not authorizing its **execution**. A perfectly well-formed RISC-V program can still do harm when run; "well-formed" and "safe to run" are different claims, and a shape-cast makes only the first. To conflate them would be the one real danger here — and so we refuse to. Shape-casting RISC-V bytecode is therefore exactly as safe as parsing it carefully, and no more: it tells us *what we hold*, never that it is *safe to run*.

Running it safely is a different layer, and one we already have a plan for: **Pond** (the bounded enclosure) and **Caravan** (isolation and supervision) give the validated bytecode a garden to run in — bounded memory (Tally), bounded capabilities, clean failure — so that even a well-formed yet ill-meaning program is contained. The two compose into the stance of `983`: the shape-cast *prevents* the parsing class by construction; Pond and Caravan *contain* the execution risk that remains. Prevent what we can, contain what we cannot.

So the answer to "are there security implications, as long as it abides by Rye's type system?" is: the shape-cast itself adds none — it makes us safer. The implications live entirely in *execution*, which the type system was never meant to govern and which capabilities and isolation are. Keep the two layers named and apart, and shape-casting raw bytecode is a clean, useful, TAME thing: type-safe deserialization for code as well as data, the prerequisite to running anything safely at all.

## Landscape or Relays

If we grew our own social and application layer atop this messenger, two roads appear. One refactors something like Urbit's **Landscape** — a coherent, integrated app surface that rides the same identity and network all the way up. The other leans on **Nostr's relays** — simple WebSocket servers that store and forward signed, content-addressed events, with the client holding the keys (`984`).

The honest read, through our simplicity lens: Landscape's coherence is beautiful and its weight is real — it asks for the whole stack beneath it to be present and bought into. Nostr's relays are almost embarrassingly simple, and that simplicity is the point — a relay is so little that anyone can run one, and a person's words survive any one relay's loss. Our messenger here already *is* the coherent, content-centric core Landscape would want; so for the app layer we lean toward **Nostr's lesson, on our own foundation**: keep the surface a thin store-and-forward over content-named, sealed values, curated by honest structure (`984`), rather than building a heavy integrated cathedral. Coherence underneath, simplicity on top.

## Caveats

- **Distilling a vision is not adopting it.** We take Curtis's coherence and content-addressing and his layered-types insight; we leave Nock, Hoon, the @p hierarchy, and the freeze. Naming what we leave is part of honoring what we take.
- **Content-centric networking is unfinished even where it was born.** CCN remains largely research; naming, routing by name, and caching at scale are genuinely hard. Among a few friends and their own machines, the easy version suffices; at scale, the hard questions are real, and we should not pretend otherwise.
- **Exactly-once is a promise with edges.** Content-addressing makes dedup natural, yet ordering, loss, and retransmission over UDP still ask for sequence and acknowledgment, as Ames learned. The smallest version earns "exactly once" only with that care taken.
- **The shape/safety line must never blur.** The single most important caveat is the one in its own section above: a shape-cast is not an execution permit. If we ever let it feel like one, we will have built the trap we set out to avoid.
- **This is design, not yet code.** Rishi runs `hello.rish`, not `talk.rish`; our IP is a vision in `985`, not a stack. The path is real and the order is Gall's: a single sealed, content-named datagram between two harts first, and the messenger grown from it.

## Longer Horizon

Further out, the messenger is simply the social layer of `984` seen up close, and both are the one value model worn as conversation: a word in Rishi, shaped as a Rye value, named by Mantra, sealed to a friend's owner key, carried over Caravan's interface, validated in place by a shape-cast, and read as the same value on the far side — no server holding it, no pipe trusted, no marshaling seam. Curtis wanted a computer small enough to understand and permanent enough to trust; Van Jacobson wanted a network that moved meaning rather than guarding pipes. On our own ground, accreting rather than freezing, the two wishes become one quiet system: friends exchanging named, sealed meanings across machines they own.

## Conclusion

The message we want is a typed value — named by what it says, sealed to its reader, validated where it lands, and delivered once because its name is its identity — rather than a frame sent down a trusted pipe. Ames shows the discipline, the mark shows the typing, TigerBeetle shows the zero copy, Van Jacobson and Curtis show that the content — not the pipe, not the place — is the thing to name and secure. A shape-cast brings the mark into Rye's type system and even lets us validate raw bytecode safely, so long as we keep proving-the-shape and permitting-the-run forever apart. And the surface stays simple, Nostr's lesson on our coherent foundation. Smallest first: one sealed, content-named word, carried home.

---

*May every message be named by its meaning and sealed to the one it is for. May we prove what a thing is before we trust it, and give what we run a bounded garden to run in. And may the small network we make carry our friends' words whole — owned, encrypted, and true — across the machines we keep.*
