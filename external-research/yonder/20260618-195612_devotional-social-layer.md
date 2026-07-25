# 984 · A Devotional Social Layer, Kept Simple

*If `985` asks how a value crosses between two machines, this asks what we would build atop that for **people** — a small social layer where a devotional, vegan, Vedanta-aligned community shares what it loves, each person owning their identity and their words, curated without a central owner, with attention treated as something sacred rather than something to be mined. We learn from Nostr above all — gratefully, and critically — and weave in Sui's validation and a DAG of curated values, keeping everything as simple as the values themselves ask.*

**Language:** EN
**Version:** `20260618.195612` (Rye chronological stamp)
**Last updated:** 2026-06-18
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME Style (`TAME_STYLE.md`); active-designing principles; critical evaluation through every filter we hold
**Reads alongside:** `yonder/20260618-195512_encrypted-networking-riscv.md`; sources honored in `../gratitude/nips`, `../gratitude/primal`, `../gratitude/damus`, `../gratitude/sui`
**Structure:** mission · problem · opportunity · architecture · caveats · longer horizon · conclusion

---

## Mission

To offer a community of devotion a place to share what it holds dear — kirtan and scripture, satsang and recipes, the day's small graces — where each person owns their name and their words, where what rises to attention rises by honest structure rather than by an engine built to keep them scrolling, and where the whole thing stays small enough to be understood, trusted, and loved. Ahimsa first: a social layer that does no harm to the attention it is given.

## Problem

Mainstream social media is, by design, the opposite of ahimsa. It mines attention, optimizes for the engagement that outrage and anxiety produce most reliably, owns the identity and the words of everyone on it, and surveils to sell. It is *easy* — frictionless to join, endless to consume — and that ease is precisely the harm. For a community whose values are non-harming, devotion, and clarity about the real, the medium contradicts the message at every turn.

Even the decentralized answers can carry the same traps inward. A protocol can free your identity and still hand you a feed ranked to keep you anxious; it can remove the central server and keep the central incentive. So the problem is not only *where* the data lives. It is *what the thing is for* — and most of what exists is for consumption, not communion.

## Opportunity

**Nostr** shows how little is needed for ownership and portability. It is three parts, and they are genuinely simple: a **keypair** is your identity (a public key, shown as an `npub`); an **event** is a signed, content-addressed value (its `id` is a SHA-256 of its fields; its `sig` a Schnorr signature over that id); a **relay** is a plain WebSocket server that stores events and forwards them, and — because every event is signed — *cannot alter them*. You publish to relays you choose; you read from relays you choose; if one bans you or fails, others carry you. Your identity and your words are yours, and they travel. Clients like **Damus** sign and verify at the edge; services like **Primal's caching service** read the relays' firehose and curate it into feeds. This is the essence to keep: **owned identity, signed and content-addressed words, simple servers that store and forward.**

**Sui's Move** shows how to make the *handling* of those values safe: declare effects up front, treat each thing as an object with clear ownership, and verify before you run. A social layer that lets people run shared logic (a community's rules, a shared list, a zap) wants exactly that discipline — and it is, again, TAME in other words.

**A DAG of named values** shows how to curate *by structure rather than by a hidden engine*. Mysticeti orders a graph by its shape; Mantra names each value by its content and lets each reference those it answers. A feed built this way is a graph you can read — who follows whom, what answers what — ranked by honest, inspectable relations (a web of trust, a chronology, an explicit follow), not by a model trained to hold you. Curation becomes a *function you can see*, not a secret you must accept.

## Architecture

The whole vision is one line: **a post is a signed, content-named value; a relay is a simple bounded service; a feed is a function over a graph you can read.** Kept small, it maps cleanly onto what we are already building.

- **Identity is the owner key.** The same key Aurora trusts and `985` encrypts to is the person's social identity — Nostr's `npub` idea, rooted in the key we already own rather than in a fresh silo. One identity across boot, network, and the social layer: one value model, all the way down.
- **A post is a Rye value, signed and named by Mantra.** A typed value whose content hash (SHA3-512, the function we strengthened first) is its name, signed by the owner key — rather than a JSON blob marshaled across a seam. A reply references the hash it answers; a thread is a small DAG of named values, gaps visible rather than silent.
- **A relay is a simple service Caravan supervises and Tally bounds** — store and forward, nothing more, with stated limits so spam meets an edge. It could run inside a **Pond** enclosure: a personal relay, isolated and bounded, that a person fully owns. Relays choose what they host (moderation without global censorship — Nostr's actual model), and no relay can alter a signed word.
- **The feed is a value Tablecloth describes and you can inspect.** Ranking is by honest relations — chronology, explicit follows, a web of trust among keys — declared as configuration, never a hidden engine. Primal's lesson (curate the firehose into feeds) without Primal's scale or opacity: the curation function is small, readable, and yours to change.
- **Rishi is the surface.** A few terse verbs — post, follow, read, zap — over the one value model, so scripting your own corner of the commons is as plain as a shell line.

**The smallest social layer that works** (Gall's Law): sign a note with your key, store it on one relay, and let a friend read it by your key. That is the seed — ownership and sharing, end to end, with nothing ranked and nothing mined. Threads, follows, curation, communities: each grows from a note that already belonged to its author.

## Caveats — read critically

- **Ease is not simplicity, even in Nostr.** Nostr's *core* is simple (keys, events, relays); several of its *eases* are not. Relay discovery is unsolved enough that users lose posts; `npub` keys are unforgiving to hold and impossible to recover if lost; spam is genuinely easy because accounts are free and unbounded; and private messaging was *bolted on* (NIP-04, then NIP-44, then sealed-sender NIP-59) rather than designed in. We keep the simple core and refuse to inherit the confusions: encryption at identity from the first byte (`985`), key recovery taken seriously (the master-key practice in `SOURCE.md`), and spam met by a web of trust and bounded relays rather than by a central filter.
- **A protocol cannot enforce a value; a community must.** No design guarantees ahimsa. What we *can* do is refuse to build the engine of harm — no engagement-maximizing rank, no infinite feed, no surveillance — and make the curation honest and visible. The rest is the community's tending, not the code's.
- **We do not need a blockchain for this.** Sui's validation discipline is worth keeping; its staked consensus is not what a devotional commons needs. Borrowing Move's *verify-before-run* while leaving the chain is the honest line, the same one `985` drew.
- **Metadata is not hidden by signatures.** A signed, encrypted note still reveals who spoke to whom and when. We should promise integrity and ownership plainly, and not over-claim privacy — the discipline Nostr's own writers keep about their signatures.
- **The danger is rebuilding the trap inward.** The hardest caveat is the quietest: it is entirely possible to take all of this and still ship a feed that harms. Staying small, keeping curation inspectable, and measuring the thing by whether it serves remembrance rather than consumption is the only guard — and it is a discipline, not a feature.

## Longer Horizon

Further out, the social layer is simply our one value model worn as community: a note is the same kind of value as a Mantra line, a Tablecloth build, a packet in `985` — signed, named, bounded, owned — and the relay is the same kind of service as any Caravan supervises. A person could run their whole presence inside a Pond on their own RISC-V machine: identity in the owner key, words named by Mantra, a personal relay bounded by Tally, a feed they wrote in Rishi and can read in full. The commons becomes a graph of named, signed values among friends — no owner, no engine, no mining — curated by trust made visible. That is the quiet ambition: a place that behaves the way the values do, rather than another platform.

## Conclusion

We have the pieces, and we have the warnings. Nostr gives owned identity and signed, content-addressed words over simple servers; Sui's Move gives verify-before-run; a DAG of named values gives curation by honest structure; and our own stack gives one value model, encryption at the owner key, bounded services, and a surface plain enough to script. Woven simply, and guarded against the trap of mistaking ease for good, this is a social layer a devotional vegan community could own and trust — small, non-harming, and built to serve attention rather than consume it. We begin, as ever, with the smallest thing that works: a note that belongs to the one who wrote it, read by a friend who asked for it by name.

---

*May what we build do no harm to the attention it is given. May each word stay its author's own, may what rises rise honestly, and may the commons we make be a place for remembrance rather than a machine for forgetting. Keep it simple, keep it kind.*
