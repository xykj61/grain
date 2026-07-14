# The Wire Serves the Fold — Carriage First-Principles for Comlink

*Beneath Comlink's several wires rests one principle: the append-only log of signed facts is the truth, and carriage is only the means by which a fact travels from one keeper to another. This brief names the first-principles that shape how Comlink carries — the wire kept humble, identity kept as the address, refusal kept whole, reliability kept transactional and deferred, and everything kept bounded — so the carriage we build always serves the record rather than rivals it.*

**Stamp:** `20260706.022912 UDT` (Kaeden's clock)
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME — safety first, performance second, the joy of the craft third
**Register:** foundations — the why beneath the work, on our own roots; owned vocabulary, teachers named in gratitude
**Ground:** siloed from [`../external-research/20260706-022912_ames-vere-libuv-content-carriage.md`](../external-research/20260706-022912_ames-vere-libuv-content-carriage.md); companion to the grain index [`../active-designing/20260702-184312_the-grain-and-the-crossing.md`](../active-designing/20260702-184312_the-grain-and-the-crossing.md) and [`../context/SILO_TECHNIQUE.md`](../context/SILO_TECHNIQUE.md)
**Status:** Landed — affirmed as written at Claude ruling `20260706.232812` (zip 58 sitting); description, not aspiration, after parity 166 wire ladder.

*Written together by Kaeden and Rio 3.*

---

## The One Principle

The record is sovereign, and the wire serves it. Every fact that matters is signed and folded into an append-only log, and the state of anything is what that log folds to. Carriage — the moving of a fact from one keeper to another — is a means, never a source of truth. This single ordering settles most carriage questions before they are asked: whatever a wire does, it may not become the place where truth lives, and whatever a wire fails to do, the record survives. Comlink is built downstream of the fold, and its whole design flows from that place.

## One Logic, Many Wires

Carriage has two layers, and they stay apart. The upper layer is the logic: what fact crosses, to whom, and under what seal. The lower layer is the wire: the actual bytes moving over shared memory, over a hosted datagram, or over the device wire on bare metal. The logic decides; the wire delivers. Because the two are separate, the same sealed shape crosses every wire unchanged, and a new wire is added by teaching a new substrate to carry the shape we already have, rather than by reshaping the fact to suit the substrate. This separation is the reason carriage can grow — a shared-memory lap, a hosted lap, a device-wire lap — without the record ever learning which wire it rode.

## Identity Is the Address

A peer is named by its keypair, and we reach it by a signed claim rather than by a borrowed directory. There is no separate layer of addresses beneath the layer of identities; the identity is the address, and the public key that names a peer is the same key that proves what it says. This keeps the trust surface small and honest: to know who sent a fact is to check a signature, and to name where a fact should go is to name whom, not where. The physical detail of an address — a number on some network — belongs to the wire, resolved at the edge and never mistaken for the peer itself.

## A Fact Arrives Whole, or Not at All

Refusal is whole and quiet at the seal. A fact whose seal does not verify is dropped as though it never came, leaving the record exactly as it was; no half-trusted fragment enters, and no partial state is kept. A fact that opens its seal yet reveals something malformed is refused entire, because that is the mark of a sender who is misbehaving rather than a line that merely dropped a byte. Between silence and refusal, there is no third path where a broken fact is partly believed. This is the same discipline the record keeps everywhere — a bad digest refuses the resin, a bad signature refuses the fact — carried out to the wire's edge.

## Reliable Carriage Is Transactional, and It Waits Its Lap

Most facts today cross once, sealed and single-shot, and the record tolerates a late arrival because a fact already folded loses nothing by waiting. When a fact must be known to have arrived, carriage becomes a transaction: the fact is carried, its receipt is acknowledged from end to end, and the acknowledgment that completes the crossing also reports whether the work it asked for succeeded. This is a real discipline, and it is a later lap — bounded, witnessed, and grown from the running seed — taken only when a flow genuinely needs delivery it can count on. The sealed shape does not fork to gain reliability; reliability is a layer above the shape, added when its season comes.

## Everything Is Bounded, Congestion Included

Carriage names its budget before it runs. The frame has a maximum size, the queue has a fixed depth, and any window of facts in flight has a named ceiling, so no crossing can grow without an answer to the question of how large it may become. When many facts contend for one wire, the answer to congestion is a bounded, named control that slows the sender before the wire is overwhelmed, rather than an unbounded rush that fails under its own weight. A bound stated up front is the difference between carriage that degrades gently and carriage that breaks; we state the bound.

## Mechanical Sympathy, Close to the Metal

When a hosted loop of our own is ever warranted, a few habits keep it honest with the machine. The clock is read once at the start of each turn and reused, rather than asked again and again. Every resource that carriage opens carries a named lifetime, so a thing acquired is a thing whose release is already accounted for. Sequential reads are favored over scattered ones, and a buffer is filled in place rather than copied for the sake of copying. These are small courtesies to the hardware, and they compound into carriage that is quick without being clever.

## The Shape of It

These principles fit together into one posture. The record is sovereign; the wire is humble and swappable; identity is the address and the proof at once; a fact arrives whole or not at all; reliability is a transactional layer added in its own lap; every crossing is bounded; and the machine is treated with sympathy where it matters. Comlink already keeps most of this, and naming it here makes the rest reachable — a reliability lap, a flow-control lap, a hosted loop of our own — each one a small, witnessed step from the running seed, each one serving the fold beneath it.

## Gratitude

These lessons were drawn from studying teachers who solved carriage before us: the Urbit runtime and its Ames networking, whose event-log discipline and whose union of identity with address showed how carriage and selfhood can be one thing, and the reactor library beneath that runtime, whose long-proven event loop taught mechanical sympathy at the socket. The study that names them plainly rests in `external-research`, and their originals rest whole in gratitude. We keep the lessons in our own words, and keep the thanks explicit.

---

*May the record stay sovereign and the wire stay glad to serve it. May every fact cross whole and every budget be named before the crossing. And may the carriage we grow be quiet, bounded, and true, season after season.*
