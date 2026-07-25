# 981 · One Identity, Many Keys — and a Fractal Address Space

*A person today carries a fistful of keys — an SSH key to reach their machines, a GPG key to sign their work, a Sui key to hold their coins, a Nostr key to speak in the commons — each made apart, backed up apart, and lost apart. This study asks how Rye OS could give them instead **one identity** from which every key is grown, kept once and recovered once; and how that identity could live in a space with shape and meaning — a fractal of galaxies, stars, and planets evolved from Urbit's address space, yet shaped by the Vedic vargas, where a galaxy's circle of five and its inheritance of twelve together lead a sixty.*

**Language:** EN
**Version:** `20260619.035912` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME Style (`TAME_STYLE.md`); active-designing principles (one value model, simplicity, self-sovereignty)
**Reads alongside:** `yonder/20260618-195512_encrypted-networking-riscv.md`, `yonder/20260618-212112_content-centric-messaging.md`, `yonder/20260618-195612_devotional-social-layer.md`; `../SOURCE.md`; honored in `../gratitude/urbit`, `../gratitude/sui`, `../gratitude/nips`
**Structure:** mission · problem · opportunity · architecture · metaphor and mechanism · caveats · longer horizon · conclusion

---

## Mission

To give a person one identity they truly own, from which every key they need is grown — so one root, well kept, unlocks SSH, GPG, Sui, and Nostr alike, and one loss is the only loss to fear. And to set that identity in a space with shape and meaning: a fractal that mirrors how a life actually branches — the circle one solves problems with, and the people and works one carries forward.

## Problem

Our own `SOURCE.md` is the honest evidence. To work here, a person generates an SSH key for the forges, a GPG key to sign commits, and — for the wider vision — would add a Sui key for the chain and a Nostr key for the commons. Four keys, four key-files, four backups, four ways to be locked out. They share no root, so a person is four disconnected identities wearing one name, and the loss of any one is its own small catastrophe. This is key sprawl, and it is the ordinary condition of a careful digital life.

Urbit answered the identity half beautifully: there, your identity, your address, and your key are one thing — a single `@p` that is who you are, where you are reached, and how you are verified. Yet it bound that identity to a fixed, scarce hierarchy on one Ethereum contract. We want Urbit's unity without Urbit's scarcity, and we want it to embrace the keys a person already holds rather than replacing them.

## Opportunity

Three moves, together, dissolve the sprawl.

**One seed, many keys.** The keys differ by *curve*: SSH, GPG, and Sui all speak **ed25519**; Nostr speaks **secp256k1** (the Schnorr signatures of `984`). No single key can be both curves at once — the mathematics forbid it. Yet a single **seed** can deterministically derive both: an ed25519 key for SSH, GPG, and Sui, and a secp256k1 key for Nostr, each a separate key bound to its purpose, all grown from one root. So unity comes from *deriving* every key from one seed, rather than from *reusing* one key everywhere — which would be unsafe, and would link what should stay separate. One backup, one recovery, many keys, cleanly separated. Separation is the safety; the shared root is the unity.

**The address space is the key tree.** If a person's primary identity is a *galaxy*, and their stars and planets are sub-identities, then the address space need not be a registry bolted beside the keys — it can simply *be* the derivation tree. A galaxy key derives its stars; a star key derives its planets; each node derives the per-system keys it needs. Identity, address, and key become three names for one thing, exactly as Urbit taught — and the whole tree recovers from the one galaxy seed.

**The Vedic shape gives the tree meaning.** A bare hierarchy is just numbers. The vargas make it a picture of a life.

## Architecture

The design is one sentence: **one seed grows a tree of identities; each identity is an address and derives the keys it needs; the tree's shape is a fractal of meaning.**

### One seed, separated keys

From a single root seed (a galaxy's owner key, in the sense of `985`):

- an **ed25519** key for **SSH** (reaching machines), for **GPG/OpenPGP** (signing work, as our commits already are), and for **Sui** (which accepts ed25519 natively);
- a **secp256k1** key for **Nostr** (Schnorr/BIP-340 events).

Each is a distinct key at a distinct derivation path, so a leak of one never exposes another, and the four identities a person juggles today become four faces of one root. The seed is the only thing to back up; the QR key-cards and master-key practice of `SOURCE.md` become the care of *one* root rather than four.

### The address space as the key tree

The fractal, faithfully:

- A **universe** is a Sui contract, stewarded by an **admin**. It holds **twelve galaxies**.
- A **galaxy** is a person's sovereign primary identity. It produces **five stars** (beyond itself).
- A **star** is a chosen relationship or group. It produces **twelve planets** (beyond galaxy and star).
- So each universe is responsible for **12 × 5 × 12** identities, and each galaxy leads a household of **sixty** (its five stars times their twelve planets).

The tree is the key tree: a star's key derives from its galaxy, a planet's from its star — so a galaxy, kept once, can recover its whole sky, and each identity still derives its own ed25519 and secp256k1 keys for the wider world.

### The shape, by the vargas

The numbers are not arbitrary; they are the Vedic vargas, and they say what each tier is *for*:

- A galaxy's **five stars are its d5** — the *trimsamsa*, the "uneven fifth of signs," which speaks to **how one meets and solves problems**. So the stars are the human beings one creates solutions with: close friends, allies, family, teams, organizations, bands, the groups one faces difficulty beside.
- A star's **twelve planets are its d12** — the *dwadasamsa*, which speaks to **inheritance — inherited traits, talents, and support**. So the planets are what one carries forward and is carried by: customers and employees, children and grandparents, side projects and artist names, nonprofits, public-benefit startups, open-source works.
- Together, a galaxy's **five times twelve is its d60** — the *shastiamsa*, "degree-halves," which speaks to **prosperity and the appeal of one's personal qualities**, the thing that draws fame and fortune. A galaxy's sixty is the full flowering of who they are among others.

And the cosmology names the admins gently: a universe's steward is at once a **Manu** and an **Aditi** — a Manu, as Svayambhuva Manu was made by Brahma to bring forth a lineage; an Aditi, in the way she birthed the **twelve Adityas** — who, in an Aurora-like yet networked way, creates a Sui contract and chooses its twelve galaxies. Where information must cross between universes, it crosses by **bridging and alliance between admins** — signed, content-addressed messages (`982`) passing between namespaces — rather than through any single chain. No universe contains the world; they federate.

### Naming the network

The module that carries identities and messages across this space, and bridges between universes, deserves a name chosen with care. The name is **Comlink**, after the work of [ELDÆON](https://eldaeon.com/) — clear and evocative, a word that says plainly what the module is for. It sits a little outside the devotional, natural family our other names keep (Mantra, Rishi, Pond, Caravan), and three names from that family were weighed beside it before the choice settled:

- **Setu** (सेतु, "bridge") — the bridge Rama's allies built across the ocean; it honors the design's own word, *bridging*, and a network is, at heart, a set of bridges between identities.
- **Doota** (दूत, "envoy, faithful messenger") — Hanuman as Rama's doota, who crossed the sea to carry a message truly and bring an answer home; it pairs with Rishi's faithful speech and the messenger of `982`.
- **Akasha** (आकाश, "ether, space") — the subtle element through which sound and all communication travel; the network as the very *space* identities move through, which rhymes with calling this an address *space*.

Each would have served, and the choice was rightly the keeper's. **Comlink** won it for the clarity it carries, and we speak of Comlink throughout.

## Metaphor and Mechanism

One line must stay bright, in the spirit of how `982` kept shape and safety apart. The Vedic shape is **meaning**: it tells a person *how to choose* who belongs in their sky — the five they solve problems with, the twelve they carry forward — and it gives the structure a soul. The **mechanism** that keeps an identity safe is the cryptography: the seed, the derivation, the signatures. The stars do not secure the key; the key secures the star. So we let the vargas organize the life and let the math guard it, and we never ask the metaphor to do the cryptography's work, nor the cryptography to carry the metaphor's meaning. Held this way, the astrology is a genuine gift — a humane way to give an address space shape — rather than a claim the security leans on.

## Caveats

- **Two curves cannot become one.** ed25519 and secp256k1 are different mathematics; the unification is one seed deriving both, never one key serving both. Pretending otherwise would be a security error. Deriving separate keys is also simply *good practice* — it keeps a person's SSH, signing, chain, and commons identities unlinkable when they should be.
- **One seed is one point of failure.** Unifying recovery means a single root whose loss is total. This raises the stakes on its care: the QR cards, and in time a Shamir-style split or social recovery, are the answer the design owes — the same thread `SOURCE.md` began.
- **Admins must coordinate, never control.** The deepest risk is recreating Urbit's landed hierarchy — galaxies as an aristocracy, the contract as a throne. The keys must be self-sovereign in their holders' hands; a Sui contract should *map* the namespace, not *own* the people in it. If an admin can revoke or seize an identity, we have rebuilt the thing sovereignty exists to refuse. The design must make the admin a registrar and a convener of alliances, and nothing more.
- **Scarcity is a choice, and we choose less of it.** Urbit's fixed 256 made addresses scarce by design. Twelve galaxies per contract with many contracts keeps each universe legible and human-scaled while letting the whole grow without limit, by adding universes rather than rationing seats. We should watch that "twelve galaxies" stays a *shape*, not a *gate* that turns a person away.
- **Metaphor is not mechanism** — restated because it is the easiest line to blur, and the most important to keep.

## Longer Horizon

Further out, a person logs into Rye OS once, as their galaxy, and is — without another step — reachable over SSH, trusted by GPG, present on Sui, and speaking on Nostr, every key grown from the one root they keep. Their five stars and sixty planets are a living picture of their circle and their works, rather than rows in a database, each a sub-identity they can hand out and revoke. And their galaxy federates with others by bridge and alliance, across universes stewarded by Manus and Aditis who convene yet never command. One identity, many keys, a sky with meaning — owned by the person, ruled by no one.

## Conclusion

The sprawl of keys is not a law of nature; it is the absence of a root. Give a person one seed, derive their every key from it — ed25519 for SSH and GPG and Sui, secp256k1 for Nostr — separated for safety and unified for keeping, and the four scattered identities become one. Let the address space *be* the key tree, in Urbit's spirit on our own ground; let the Vedic vargas give it a humane shape — the d5 one solves with, the d12 one carries forward, the d60 they lead together; let the admins be Manus and Aditis who convene rather than rule; and let the network that bridges them carry a name chosen with care — **Comlink**. The metaphor gives the space its meaning; the keys give it its safety; and the person, at last, holds all of it with one hand.

---

*May one well-kept root unlock all a person needs. May the circle they solve beside and the works they carry forward each find a place in their sky. May the space we give them have shape and meaning — owned by them, ruled by none — and may every bridge between us be crossed by a message that is true.*
