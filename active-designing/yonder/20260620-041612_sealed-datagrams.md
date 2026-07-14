# 973 · Sealed Datagrams — A Value With a Wire Shape

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*Comlink does not begin with sockets. It begins with a **datagram**: a bounded byte layout that carries who sealed a message, what name the ciphertext bears, and the sealed payload itself — the same octets whether two harts share RAM, two processes speak UDP, or two guests meet on virtio. A datagram is not a protocol stack; it is a **value made portable**, shape-cast at every edge, opened only by the one who holds the right secret. This brief silos what that shape means so every wire rung shares one letter.*

**Language:** EN
**Version:** `20260620.041612` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety first; `992` shape-casting; `993` bounded network; `994` identity
**Status:** Active Design (siloed)

---

## Our Own Ground

This is a clean room. We name only what is ours — **Rye**, **Comlink**, **Aurora**, **Mantra**, **Caravan**, **Tally**, **Brix**, **Pond**, **Rishi** — together with **RISC-V** and **x86_64** where execution ground matters. A **datagram** enters here as our name for one self-contained network message: fixed header fields, variable ciphertext within a stated capacity, validated as a whole before trust. The cryptography is ours in Rye's strengthened `std`; the layout is ours in `posted.rye` and every carrier that followed.

---

## Datagram and Value

In ordinary speech a datagram is one packet — a bounded burst of bytes that arrives whole or not at all. In our family it means more: the datagram **is** the wire form of a value.

| Layer | What it holds |
|-------|----------------|
| **Plaintext** | The message someone meant to say — bounded by `max_message` |
| **Ciphertext** | The plaintext after AEAD seal — same bytes, unreadable without the key |
| **Content-name** | SHA3-512 over the ciphertext alone — the message's enduring hash |
| **Attestation** | Ed25519 signature over the content-name — who vouched for this name |
| **Sender address** | Ed25519 public key on the wire — who claims to have sealed it |
| **Datagram** | All of the above, laid out at fixed offsets in ≤ 512 bytes |

The channel beneath — shared memory, localhost UDP, virtio frame — carries **octets**. Comlink carries **meaning**. Shape-casting (`992`) is the door: bytes shorter than the header, longer than capacity, or failing crypto checks are refused before a single field is trusted.

---

## The Wire Layout

Every running seed uses the same offsets. Forking the format is a deliberate act, not an accident of transport.

| Offset | Field | Size | Role |
|--------|-------|------|------|
| `0` | **sender** | 32 B | Sealer's Ed25519 public key |
| `32` | **nonce** | 12 B | AEAD nonce (ChaCha20-Poly1305) |
| `44` | **name** | 64 B | SHA3-512 digest of ciphertext |
| `108` | **sig** | 64 B | Ed25519 signature over `name` |
| `172` | **tag** | 16 B | Poly1305 authentication tag |
| `188` | **cipher** | rest | Ciphertext (plaintext length) |

**Capacity:** `wire_capacity = 512` bytes total. **Header end:** `off_cipher = 188`. **Max plaintext:** `512 − 188 = 324` bytes today.

A typical proof message — `Meet me where the rye grows.` — seals to **216 bytes** on the wire (188 + 28). That number is a regression sentinel: hosted tests, freestanding harts, and `comlink/hosted_wire.rye` all agree.

---

## Seal — Alice to Bob

**Seal** is transform (`977`): plaintext becomes a datagram Bob can open.

1. **Agree on keys.** Alice holds her Ed25519 identity; Bob's public key is known (today deterministic seeds; tomorrow unified keys from `994`).
2. **Derive shared secret.** X25519 from Alice's secret and Bob's public key; SHA3-512 truncates to the AEAD key.
3. **Encrypt.** ChaCha20-Poly1305 produces ciphertext and tag.
4. **Name.** SHA3-512 hashes the ciphertext — the **content-name** Mantra will remember.
5. **Attest.** Alice signs the content-name with Ed25519.
6. **Serialize.** Fields copy into the buffer at fixed offsets; length is `off_cipher + ciphertext.len`.

Alice never needs Bob's secret. The datagram carries only public material and sealed bytes.

---

## Open — Bob at the Edge

**Open** is the mirror at the receiver — shape-cast, verify, decrypt.

1. **Shape-cast.** `len >= off_cipher` and `len <= wire_capacity`, or refuse at the edge.
2. **Parse fields.** Reconstruct public key, nonce, name, signature, tag, ciphertext slice from offsets.
3. **Verify attestation.** Signature over `name` must verify under `sender`.
4. **Confirm name.** Re-hash ciphertext; must equal `name` on the wire.
5. **Derive shared secret.** X25519 from Bob's secret and sender's public key — same key Alice used.
6. **Decrypt.** AEAD open; failure means tamper or wrong recipient.

Bob trusts only his secret and what arrived. The channel may lie, drop, or duplicate; cryptography and naming answer each case.

---

## Name, Seal, and Exactly Once

`993` states the network principle; the datagram is its smallest mechanical form.

- **Sealed at identity** — encryption is default, not a bolt-on tunnel.
- **Named by content** — the content-name is the message's identity for remember and dedup.
- **Exactly once, by name** — a duplicate datagram is a name already seen; set aside without re-opening.

The datagram does not yet implement a relay or peer table. It **proves** that a named, sealed value can move and be opened honestly — the seed the bounded network grows from.

---

## Where the Same Datagram Runs

One layout, three grounds proven, one ground framed:

| Ground | Seed | Transport |
|--------|------|-----------|
| **Two harts, shared RAM** | `aurora/src/posted.rye` | Mailbox + fence (`974`) |
| **Two processes, hosted** | `comlink/hosted_wire.rye` | Localhost UDP :38472 |
| **Two guests, emulated** | `10016`, `975` | Virtio-net frame |
| **Hosted witness** | `sealed_message_test` | In-process, parity-gated |

Changing the datagram shape is a **version** event — new offsets, new witness entry, gates re-run. Changing the transport is a **wire** event — same open path, new `read()` beneath.

---

## What Each Module Holds

**Comlink** owns move — post, carry, receive datagrams; grow toward relays and peers.

**Mantra** owns remember — content-names align with SHA3-256/512 store discipline; a captured datagram can be persisted by hash.

**Aurora** proved seal and open on bare metal; **posted** proved the whole layout crosses harts.

**Tally** bounds `wire_capacity`, RX buffers, and queue depth so a oversized datagram meets an edge, not a growable heap.

**Rye** types the crypto and offsets; freestanding and hosted share one strengthened `std`.

**Brix** will declare which peers, ports, and features a deployment expects — the datagram is the payload; Brix is the envelope of policy.

**Pond** will bound which processes may bind a port or touch a virtio queue — shape-cast at the syscall edge matches shape-cast at the crypto edge.

**Rishi** scripts bring-up: `hosted_wire demo`, future gate scripts that assert 216-byte GREEN.

---

## Datagram Versus Frame Versus Message

Words stay precise:

| Word | Meaning |
|------|---------|
| **Message** | What the sender meant — plaintext, a value |
| **Datagram** | Our sealed wire layout — header + ciphertext |
| **Frame** | Whatever the transport wraps around octets (UDP payload, virtio buffer, mailbox slice) |
| **Packet** | Generic; we prefer *datagram* when the Comlink layout is meant |

A Brushstroke **frame** (`988`) is unrelated — values drawn to a surface. Only the network datagram carries the seal.

---

## The Smallest Proof (Gall's Law)

The datagram story grows in order:

1. **Crypto in one process** — `sealed_message_test`, `hosted_wire selftest`: seal and open without I/O.
2. **One hart seals** — `sealed.rye`: primitives on bare metal.
3. **Two harts, one datagram** — `posted.rye`: full layout across the mailbox.
4. **Two processes** — `hosted_wire.rye`: same bytes, UDP.
5. **Two guests** — virtio-net (`975`): same bytes, device wire.

Each step is green before the next. The datagram format is frozen across steps 3–5; only the carriage changes.

---

## Caveats

- **Deterministic seeds** stand in for real identities in test seeds (`0xA1` / `0xB0`). Production uses owner keys (`994`); the layout stays.
- **No chunking yet.** One datagram, one buffer, ≤ 512 bytes. Larger values want a manifest layer — horizon, not today's seed.
- **No relay semantics.** Store-and-forward, subscription, and spam resistance live in `993` and close-reading notes; the datagram is point-to-point proof.
- **Shape is not sanction** (`992`). A well-formed datagram may still be unwanted; Pond and policy decide action after open.

---

## Longer Horizon

Comlink v1 composes many datagrams into a flow: peers in Brix, names in Mantra, relays bounded by Tally, processes supervised by Caravan. The datagram remains the atom — the smallest sealed value that can move. Unified keys (`994`) replace test seeds; relays deduplicate by content-name; virtio and TLS-bearing hosts remain untrusted beneath. The letter stays the same; the post office grows around it.

---

## Conclusion

A **sealed datagram** is Comlink's wire value: fixed offsets, named ciphertext, attested content-name, opened only by the intended recipient. It is the move in `977` made octets — proven on two harts, two processes, and soon two guests — shape-cast at every edge, trusted channel never required. Every wire rung carries this one shape until a deliberate version says otherwise.

---

*May every datagram arrive whole or not at all. May its name be earned by its ciphertext, its seal held only by the one it was for, and its shape refused at the door when the bytes lie.*
