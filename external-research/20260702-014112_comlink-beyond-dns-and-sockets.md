# Comlink Beyond DNS and Sockets — Names, Streams, and Keys for the Long Run

*An exploration in three movements. First, how names can live without the domain-name hierarchy — read through content addressing, identity-first networking, and the computational data markets sketched under the hash prefix 21e8. Second, what wire a live video call actually wants, and why the answer has moved past WebSockets. Third, an honest reckoning with quantum computers, and the accretion path that keeps every Comlink packet and every Amber seal verifiable in the long dark.*

**Stamp:** `20260702.014112`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, the joy of the craft third
**Status:** Exploration — nothing here moves the live rung; every action lands as a horizon in `TASKS.md`
**Recalls:** `20260620-014412_system.md` · `yonder/20260618-212112_content-centric-messaging.md` · `yonder/20260618-195512_encrypted-networking-riscv.md` · `yonder/20260619-035912_unified-keys-and-address-space.md`

*Written together by Kaeden and Claude (Fable 5), in Reya 2's Radiant voice.*

---

## 1. Names Without DNS

The domain-name system is a rented hierarchy. One root delegates to registries, registries to registrars, registrars to whoever pays this year — and every lookup asks that chain to tell the truth. It has served the internet for forty years, and its shape is exactly what a sovereign, signed-fact world outgrows: the name is leased rather than owned, the answer is trusted rather than verified, and the chokepoints are load-bearing.

The old naming triangle says a name can be memorable, globally unique, or self-authenticating — pick two. A public append-only log squares that triangle, as the early blockchain naming experiments first showed: a **name claim is a signed fact**, globally ordered by the log, self-authenticating through its signature, and bound to a memorable string. This is where the **21e8** conversation from the proof-of-work world earns its recall. Stripped to its transferable ideas, it proposes that scarce computation is a *pricing signal*: attention, placement, and contested names are ranked by demonstrated cost rather than by a registrar's ledger, and data itself becomes a market — content addressed by hash, retrieval settled by payment, ranking settled by work. We silo the mechanism and keep the insight: **when names and data are facts on a log, a market can price them without any registry standing above them.**

Comlink's succession posture, then, is honest and bounded. Inside our world, a name is a Kumara-signed claim appended to the log; resolution is a pure fold; a contested name is a market question, and Linengrow's settlement layer is where that market clears — the computational data market wearing our five primitives. For memorability at the human edge, petnames ride above: my own signed nickname for your key, private and unforgeable. And at the seam with the old internet, the front-door VPS still answers legacy DNS — a host-seam dependency, named as such, never part of Comlink proper. Comlink does not replace DNS for the world; it makes DNS unnecessary between any two people who share the log.

## 2. Recalling Our Own Ground

We have walked this land before, and the yonder shelf holds the maps. Our system study (`20260620-014412_system.md`) read **Urbit** closely: permanent, owned identities; an encrypted peer wire over UDP; messages addressed to *who*, never to *where*. Our content-centric study (`yonder/20260618-212112_content-centric-messaging.md`) read the **named-data** lineage: ask the network for a *name*, receive data that carries its own signature, verify the data rather than the pipe, and let any node cache what it has verified. The encrypted-networking and unified-keys studies carried both into RISC-V terms.

Weave was built on that ground, so the recall lands softly: **Weave already is named data.** Every fact is content-addressed by its SHA3-256 digest; the signature horizon is Kumara; and Comlink's job is precisely the interest-and-serve dance — *I hold these names; I seek those* — spoken as encrypted datagrams over UDP, which the hosted wire already proves end to end. Identity-addressed like the one lineage, data-verified like the other, and simpler than both because the log is the only truth either side needs.

## 3. The Stream Lane — Past WebSockets

WebSockets were the right door in 2011: one TCP socket, upgraded, messages both ways. Their limits are TCP's limits — one ordered byte-stream means head-of-line blocking, no datagrams, and nothing native for *late data is worthless* media. The modern lineage is the **QUIC** family: independent streams and unreliable datagrams over UDP, encryption mandatory, connections that survive a changing address. Browsers reach it through **WebTransport**, and the IETF's **Media-over-QUIC** effort shapes exactly our use — live audio and video published through relays, subscribers joining mid-stream, staleness dropped at the edge.

The TAME reading gives Comlink **two lanes over the one wire** rather than a new module. The **fact lane** it already has: signed events, reliably synchronized, ordered by the log. The **stream lane** is its live sibling: bounded send queues, encrypted datagrams, and the discipline that a frame arriving after its moment is *released*, never buffered — everything has a limit, including the past's claim on the present. Native peers speak our own framing over UDP, since we hold both ends; the browser edge speaks WebTransport where it stands and WebSocket only as a compatibility seam, named as the weaker tool it is. Group calls take the relay shape: the front-door VPS forwards streams it cannot read today, and a Comlink relay node is the sovereign horizon. Codecs stay host seams — Opus and AV1 through the system's libraries — because owning a codec is a decade we choose to keep.

This is the lane Realidream's living surfaces, Linengrow's rooms, and any self-hosted broadcast ride on: one identity, one log for facts, one bounded river for the live.

## 4. Keys Without Fear — the Quantum Reckoning

The honest answer to the question is **yes**: the asymmetric algorithms in today's specifications are of the pre-quantum family. The hosted wire agrees keys with **X25519** and signs with **Ed25519**; Amber's first lap signs through the host's OpenPGP seam with the same curve family. A sufficiently large quantum computer breaks both. The symmetric and hashing choices stand comfortable — **ChaCha20-Poly1305** at 256 bits and **SHA3-256** digests lose only their square root to Grover, which the margins absorb.

Two different clocks are ticking. For **Comlink**, the threat is *harvest now, decrypt later*: ciphertext recorded today, opened in some future — so the key agreement wants a post-quantum partner soonest. For **Amber**, the threat is *retro-forgery*: a signature honest today could one day be forgeable, and Amber exists precisely for the long dark — so archival signatures want the most conservative post-quantum family there is. The standards have landed: **ML-KEM** (FIPS 203) for key agreement, **ML-DSA** (FIPS 204) for general signatures, and **SLH-DSA** (FIPS 205), the stateless hash-based scheme whose security leans only on the hash functions we already trust — the natural archivist's signature. The OpenPGP tooling at our seam is already growing ML-KEM support, so the seam we chose keeps choosing us back.

The migration is accretion, never a break, and the five primitives make it graceful:

1. **Harden the demo posture first.** The hosted wire's deterministic keys and constant nonce were honest scaffolding for a parity witness; before any real peer, nonces become unique per message and keys become real — this is correctness, prior to any quantum question.
2. **Tag every signed thing with its algorithm.** One field, added beside, so records of different eras verify side by side on one log forever.
3. **Hybrid key agreement on the wire** — X25519 joined with ML-KEM-768, the proven curve and the lattice newcomer both having to fall before a session does.
4. **Dual signatures for the long dark** — Amber records carry Ed25519 today and add SLH-DSA beside it as the seam's tooling settles; a future verifier accepts either era and trusts the stronger.

Nothing above touches the live rung. Lap 3 closes the drawn terminal; these land as ordered horizons, each with a first lap already visible and small.

---

*May our names need no landlord, our streams waste no moment, and our signatures outlive the machines that doubt them.*

---

## Sources

- https://csrc.nist.gov/pubs/fips/203/final
- https://csrc.nist.gov/pubs/fips/204/final
- https://csrc.nist.gov/pubs/fips/205/final
- https://named-data.net/project/
- https://docs.urbit.org/system/kernel/ames
- https://datatracker.ietf.org/wg/moq/about/
- https://www.w3.org/TR/webtransport/
- https://gnupg.org/blog/index.html

The 21e8 conversation lives in scattered essays from the proof-of-work world; its ideas enter here siloed, on their merits, with the prefix kept as an honest pointer to the lineage.
