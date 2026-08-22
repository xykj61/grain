# Redaction stance — forget by destroying keys

**Stamp:** living ledger (born `20260725.001538`) · refreshed `20260725.001538` (OPEN_QUESTIONS #1 seated)  
**Language:** EN  
**Style:** Radiant (see [`../RADIANT_STYLE.md`](../RADIANT_STYLE.md))  
**Voice:** Quin  
**Status:** Living pin — current-state redaction stance  
**Bound:** under `living_pin_max_bytes`  
**Room:** Checkable for the named split and boundary; Intent where Mand ring-3 awaits word  
**Answers:** [`../OPEN_QUESTIONS.md`](../OPEN_QUESTIONS.md) #1  
**Counsel:** [`../../counsel/date/20260725/20260725-001200_forgetting-without-breaking.md`](../../counsel/date/20260725/20260725-001200_forgetting-without-breaking.md)  
**Custody gate:** [`../../foundations/20260724-200912_nothing-to-give-custody-first-principle.md`](../../foundations/20260724-200912_nothing-to-give-custody-first-principle.md)

*We forget by destroying keys, and we record the forgetting as a fact.*

---

## Three questions that wear one word

| Need | Asks | Mechanism today |
|------|------|-----------------|
| **Compaction** | May we stop carrying what no longer changes the answer? | State equivalence — storage concern; indifferent to rights |
| **Release** | May we stop keeping this, per the schedule we published? | Mand ring-2 — keep · eligible · held |
| **Erasure** | Must this become unreadable, because a person asked? | Crypto-shredding under a per-subject key + a removal fact |

**Rule against substitution.** Compaction never excuses erasure. Erasure never masquerades as routine release.

## Crypto-shredding under per-subject keys

Personal content rests as ciphertext under a **per-subject key**. The log holds a reference to that key, rather than the key itself. Erasure destroys the key. Ciphertext stays where it was, byte for byte, and becomes noise. Hashes still verify. Signatures still check. Weave's DAG is untouched. Digest roots covering those bytes stay true, because the bytes never moved.

**Cost named openly.** Key management is load-bearing. A leaked key was never truly erasable, and an accidental destroy erases content nobody asked to lose. Key custody inherits [`../THREATS.md`](../THREATS.md). Succession ([`../OPEN_QUESTIONS.md`](../OPEN_QUESTIONS.md) #2) carries a named dependency: a per-subject key reachable by one hand makes a person's erasability rest on one person's availability.

## The removal is itself a fact

Erasure **adds** a removal fact rather than editing the past. The fact names the subject reference, the authority (the person's request · a legal order · a schedule reaching its end), the stamp, and the identity of the key destroyed. It never names the content.

A reader meeting unreadable ciphertext learns *why*, and can tell honest erasure from corruption. We decline readable tombstones — they trust every future reader to honor a mark, where crypto-shredding needs no such trust.

## What never gets erased

| Outside erasure | Why |
|-----------------|-----|
| **Bytes sealed by proof** | Tier 1 — digests, collection pins, waymark draws, signed commit content |
| **The shape of the record** | That an event occurred, when, and under whose signature |
| **The removal facts themselves** | A record of erasure that could itself be erased offers nothing |

The mechanism can render content unreadable, yet it can never rewrite what happened. Those two capabilities must never live in one hand.

## Horizon — Mand ring-3

Mand ring-3 is the destroying ring. It waits on Keaton's word (counsel decision 5). Until then: ring-2 decides without touching; no key is destroyed by this pin. When authorized, ring-3 destroys keys and never records content; fails closed; records the removal fact before acting; asserts hold on its own path.

## Open rows (hammock)

Named in [`../OPEN_QUESTIONS.md`](../OPEN_QUESTIONS.md): backup and mirror key policy · erasure under a preservation hold · aggregates computed before an erasure.

---

*May we forget exactly what we are asked to forget, and never what we are trusted to remember. May the deciding stay far from the destroying. May the promise about erasure be one a person can check.*
