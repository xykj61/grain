# 972 · Who — Executor, Sealer, Opener, and Router

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*In conversation we said a hart names **who executes** and a datagram names **what moves** — and a fair question followed: what do we mean by *who*? This brief silos that word on our own ground. **Who** is not a person in prose; it is whichever part of the system holds **agency** at a boundary: the thread that runs, the key that seals, the secret that opens, the supervisor that routes. Keeping those *whos* distinct is how hart and datagram pair without melting into one confused noun.*

**Language:** EN
**Version:** `20260620.042612` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety first; `977` flow of values; `973` datagrams; `974` harts; `994` identity
**Status:** Active Design (siloed)

---

## Our Own Ground

This is a clean room. We name only what is ours — **Rye**, **Aurora**, **Caravan**, **Comlink**, **Mantra**, **Pond**, **Rishi**, **Tally**, **Brix** — together with **RISC-V** and **x86_64** where execution ground matters. *Who* enters as a design pronoun: **the bearer of a role at a seam**, not a literary character. Gratitude for how other systems spoke of ships, peers, and agents lives in `external-research/`; here we state only our four roles.

---

## Why the Word Appeared

When we pair a **hart** with a **datagram**, we are not blending hardware with bytes. We are naming two questions the system must always answer separately:

| Question | Short name | Example in the running seeds |
|----------|------------|------------------------------|
| **Who runs this code right now?** | *Executor* | Hart 0 vs hart 1 (`mhartid`); later a process or supervised child |
| **What value crosses the seam?** | *Payload* | The sealed datagram layout (`973`) |
| **Who vouched for the payload?** | *Sealer* | Ed25519 sender field on the wire |
| **Who may read it open?** | *Opener* | Bob — holder of the matching secret; not broadcast on the wire |

*Who* in daily speech often collapses these. Our design **un-collapses** them so each layer stays single-stranded (`995`).

---

## Four Whos (and One What)

### 1 · Executor — who runs

The **executor** is the runnable unit on a given ground:

| Ground | Executor | How we tell them apart |
|--------|----------|------------------------|
| Bare metal | **Hart** | `mhartid`; separate stacks (`974`) |
| Hosted OS | **Process** | PID; separate address spaces |
| Supervised tree | **Child service** | Caravan parent; restart on fall |

In `posted.rye`, hart 0 **executes** the seal-and-post path; hart 1 **executes** the receive-and-open path. The datagram does not run. It is data the executors touch.

Executor is **mechanical** — silicon or kernel scheduling — and says nothing yet about cryptographic identity.

### 2 · Sealer — who signed the name

The **sealer** is the identity that attests the content-name on a datagram:

- Carried as the 32-byte **sender** public key (`973`)
- Signs SHA3-512 over the ciphertext, not the plaintext directly
- Today deterministic test seeds (`0xA1` / `0xB0`); tomorrow the **owner key** tree (`994`)

The sealer answers: *who claimed this name for these bytes?* It does not have to be the same as the executor. Hart 0 runs the code; Alice's key is the sealer — in the seed they coincide by convention; in a full system they might not.

### 3 · Opener — who may decrypt

The **opener** is whoever holds the **recipient secret** needed for X25519 + AEAD open:

- **Not** serialized as a private key on the wire
- Implied by the seal — only Bob's side can derive the shared secret
- Proves the datagram was **for** someone, not merely **from** someone

Opener is the mirror of sealer across cryptography: sealer is public on the wire; opener is private in one garden.

### 4 · Router — who chooses the next hop

The **router** chooses where a value goes without transforming its meaning:

- Caravan supervisor picking which child restarts (`977` **route**)
- Pond policy allowing which path or port (`route`)
- Future Comlink relay forwarding by content-name (`993`)

Routers should be dumb about plaintext — they may see names and hashes, not opened content.

### What — the datagram (not a who)

The **datagram** is the **what**: a bounded value layout moving across a seam. It carries evidence about sealer; it does not execute. Confusing *what* with *who* is how designs smuggle trust into the payload — we refuse that (`993`: secure content, untrusted channel).

---

## Hart + Datagram Restated

Combining hart and datagram is pairing **executor(s)** with **what**:

```
Hart 0 (executor)  —transform→  sealed datagram (what)
       —move→      shared mailbox / UDP / virtio frame
Hart 1 (executor)  —transform→  opened plaintext (new value)
```

Alice-as-sealer and Bob-as-opener live **inside** the transform steps on each hart. The wire carries **what**; each hart is **who runs** the step.

This is `977` kept honest: **transform** (seal, open) on executors; **move** (datagram bytes); **remember** (content-name in Mantra); **route** (later relays) — four operations, not one blob.

---

## Who Is Not a Person Here

We use *who* for legibility, not anthropology:

- No implied human in the loop at runtime — only keys, harts, processes, supervisors
- Rishi is the **hand** (`989`) — a person types; Rishi **executes** scripts; the person is outside the machine model
- "Alice" and "Bob" in crypto prose are **roles**, placeholders for sealer and opener

When silo prose says *who*, read **which role holds agency at this seam**.

---

## How Identity Grows In

| Stage | Sealer / opener | Executor |
|-------|-----------------|----------|
| **Seeds today** | Deterministic Ed25519 from fixed seeds | Hart 0 / 1 by `mhartid` |
| **Hosted wire** | Same keys; executors are processes | `send` / `recv` binaries |
| **Horizon** | Owner root → derived keys (`994`) | Caravan-supervised Comlink services |
| **Messenger** | Unified presence on the wire | Pond-enclosed peers |

Identity (**who vouches / who may read**) matures faster than **who runs** widens from two harts to many supervised services — Gall's Law again.

---

## Caveats

- **Do not overload *who*.** If a sentence mixes executor and sealer without saying so, rewrite it.
- **Executor ≠ sealer** in the general case — only in our minimal seeds do hart id and Alice coincide.
- **Shape-cast is not a who** (`992`). It validates *what* arrived; it does not grant permission to run.
- **Borrow checker horizon** (`990`, `983`) governs *references inside one executor* — complementary to *who* across executors.

---

## Conclusion

*Who* means **which role holds agency**: the hart or process that **runs**, the key that **seals**, the secret that **opens**, the supervisor that **routes**. A datagram is **what** moves between them. Hart plus datagram is therefore not a fusion — it is the smallest pairing of **executor** and **payload** that Comlink already proved in `posted.rye`. The question was right; the answer is to keep the whos separate so the what stays one shape on every wire.

---

*May every seam name its who plainly — runner, sealer, opener, router — and may the datagram between them stay a what, whole and sealed.*
