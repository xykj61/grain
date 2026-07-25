# 985 · Encrypted Networking, From the Boot Upward

*How does a machine come to speak to another machine — from the firmware that wakes it, through the boot, up into a running network — and where in that climb does it simply **assume** trust rather than prove it? This study follows that ascent, asks how Aurora, Caravan, Tally, Tablecloth, Mantra, and Rye would make it encrypted from the first packet on RISC-V, and learns — gratefully and critically — from three living systems: Urbit's Ames and Jael, Sui's Mysticeti and Move, and (in its sibling, `984`) Nostr.*

**Language:** EN
**Version:** `20260618.195512` (Rye chronological stamp)
**Last updated:** 2026-06-18
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME Style (`TAME_STYLE.md`); active-designing principles (Gall's Law, one value model, simplicity, the gates)
**Reads alongside:** `yonder/20260617-195612_ownerboot-riscv-caravan.md`, `yonder/20260617-195712_caravan-tally-networking.md`, `yonder/20260617-195812_aurora-boot-riscv.md`; sources honored in `../gratitude/urbit`, `../gratitude/sui`
**Structure:** mission · problem · opportunity · architecture · caveats · longer horizon · conclusion

---

## Mission

To carry a value from one machine to another with safety first, on open hardware, encrypted from the first byte and named by what it is rather than where it sits — and to do so by growing the smallest network that works, never by bolting a stack onto a system that cannot yet vouch for itself.

## Problem

Today a packet is born into assumed trust. Walk the climb: firmware wakes the machine; a boot stage (ownerboot's territory on RISC-V — owner-controlled, key-rooted) may fetch a kernel over the network by DHCP and TFTP, protocols with no notion of who is answering; the kernel raises an interface, builds an IP stack of deeply mutable state, and hands programs a socket. Encryption, when it comes, arrives *late* — a TLS library far up the stack, wrapping a channel whose lower layers already trusted whoever replied. Identity and address are different things (IP says *where*, a certificate says *who*), stitched together by DNS and a sprawling certificate authority system that the machine must simply believe.

So the problem is not that we cannot encrypt. It is that trust is assumed low and proven high, location is confused with identity, and the network's state is a tangle no one can hold in their head — the opposite of everything our active-designing settled on.

## Opportunity

Three systems show that the order can be inverted — trust proven *low*, identity at the core, state held as a flow of named values — and each pays a price we can learn to avoid.

**Urbit's Ames** makes identity and address the *same thing*. An Ames address *is* an identity bound to a public key; there is no separate addressing and naming layer. Every packet is end-to-end encrypted by default — AES-256-SIV under a symmetric key derived from an elliptic-curve Diffie–Hellman exchange (Curve25519) between the two ships' networking keys — with only a comet's one-time self-attestation sent in the clear. **Jael** is the local PKI: it holds your private keys and tracks each peer's public key, *life* (key revision), and *rift* (continuity), sourced from the Azimuth registry. And on a continuity breach, Ames simply *clears all state* for that peer — a clean failure rather than a corrupt one. The essence to keep: **encryption belongs at identity, not at the address, and the default is encrypted.** The weight to leave: a galaxy/star/planet sponsorship hierarchy for routing and discovery, a dependency on an Ethereum-based registry, and Hoon beneath it all.

**Sui's Mysticeti** reaches agreement on an *uncertified* DAG of blocks, committing in the theoretical floor of three message delays by reading implicit certificates from the graph's own shape rather than gathering explicit signatures — and offers a fast path for owned-object transactions that need no consensus at all. The essence to keep: **a DAG of values can be ordered and trusted by its structure, and not everything needs a global vote** — the local and the consented are different speeds. The weight to leave: a staked validator set and the economics of a blockchain, which a person's own machines do not need among themselves.

**Sui's Move** makes every asset an object with a unique id and explicit ownership (owned, shared, or immutable), requires a transaction to *declare its inputs up front* so honest work runs in parallel, and *verifies bytecode before it runs*. The essence to keep: **declared effects, resource safety, and verify-before-run** — which, read plainly, is TAME wearing other words: state your boundaries, assert your invariants, prove before you trust.

## Architecture

The reimagining is one sentence: **a packet is a value, encrypted to an identity, named by its content, carried over a flow our own modules already speak.** Here is how the parts we are building would each hold a piece of it, smallest first.

- **The owner key is the root of network identity.** Aurora already trusts an owner key to wake the machine (the ownerboot lineage). That same key — not an address, not a certificate authority — is what a peer is known by. This is Ames's lesson without Ames's registry: identity is a key the owner holds, and Jael's role becomes a small, owned key-book rather than a chain.
- **Caravan owns the interface.** The network device is a thing that runs and can fail; Caravan supervises it the way it supervises any service, bringing it up, watching it, and clearing it cleanly on fault — Ames's continuity-breach discipline generalized.
- **Tally bounds the buffers.** Every queue, every reassembly window, every peer's state lives in a bounded garden with a stated limit, so a flood meets an edge rather than eating memory — the TAME habit of putting a limit on everything, exactly where networking most needs it.
- **Rye types the packet.** A datagram is a value with a shape — sender identity, receiver identity, a nonce, a content hash, a payload — rather than a smear of bytes. The encryption (a Diffie–Hellman key between owner keys, an authenticated cipher over the payload) is a function on that value, asserted — key present, nonce never repeated, length within bounds — in the strengthened `std` we are already tending.
- **Mantra names what crossed.** Each message is content-addressed by SHA3-512 — the hash we strengthened first, precisely because it would give Mantra's lines and now the network's messages their enduring names. A conversation becomes a small DAG of named values (Mysticeti's lesson at human scale): each message references those it answers, so order lives in the structure and a gap is visible rather than silent.
- **Tablecloth describes the interface.** Which device, which peers, which bounds — declared as a value, not configured by mutable command, so the network a machine will speak is something you can read before it runs (Move's declared-inputs lesson, brought to configuration).

**The smallest network that works.** By Gall's Law we do not build a stack; we build one encrypted datagram. Two harts in two emulators, each with an owner key; one computes the shared key to the other, sends a single authenticated, content-named datagram; the other verifies it — key present, hash matches, nonce fresh, all asserted — and answers. That is the seed. TCP, routing, discovery, the whole IP edifice: each is a later stage grown from a datagram that already proved itself, never assumed beneath it.

## Caveats

- **We are not building a blockchain.** Mysticeti and Move are beautiful, and most of their machinery answers a question — agreement among mutually distrustful stakers — that a person's own machines, and a small devotional community, may never need to ask. We take the DAG-of-values and verify-before-run; we leave the validator economics. Naming this keeps us honest.
- **Owning a PKI is owning a hard problem.** Key rotation, revocation, recovery, the loss of a key — Jael leans on Azimuth precisely because this is hard. Our owner-key root must answer "what happens when a key is lost or stolen" before it carries anything that matters. The QR key-cards and the master-key rotation we already practice (`SOURCE.md`) are the first thread of that answer, not the whole of it.
- **Encryption is not anonymity, and not safety.** Ames encrypts every packet and still reveals who talks to whom; a content hash proves integrity, not truth. We should promise exactly what the cryptography gives and no more — the discipline Nostr's own writers keep about their signatures.
- **Bare-metal networking is far from the seed.** Aurora today is a hart that wakes, speaks one line, and rests. A real network device (even an emulated virtio-net) is several honest stages away. The opportunity is real; the distance is too, and pretending otherwise would betray Gall's Law.

## Longer Horizon

Further out, the same value travels the whole way without a seam: a thought written in Rishi, shaped as a Rye value, named by Mantra, encrypted to a friend's owner key by a function in our own `std`, carried over an interface Caravan owns and Tablecloth described, and read on the far side as the *same value* — no marshaling, no serialization boundary, no late TLS wrapper. The network stops being a layer the program reaches down into and becomes simply the means by which our one value model crosses between machines. That is the through-line from this study to the social layer in `984`: relays and feeds and curation are only this — named, signed values, flowing — seen from far enough away.

## Conclusion

The Internet we have proves trust late and confuses where with who; the systems we honored prove trust early and make identity the root. We need not adopt their weight to keep their wisdom. Encryption at the owner key, packets as typed and content-named values, buffers bounded by Tally, the device owned by Caravan, the interface declared by Tablecloth, the history named by Mantra — and all of it grown from a single datagram that already vouches for itself. We begin, as always, with the smallest thing that works, and let the network rise from a packet we can trust rather than one we must believe.

---

*May the first packet be honest, and every one after it. May we prove low what others assume, name what we send rather than where we sent it, and carry our friends' words encrypted, bounded, and true — across machines we own, on hardware that is open.*
