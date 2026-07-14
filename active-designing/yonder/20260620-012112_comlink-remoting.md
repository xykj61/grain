# 979 · Comlink Remoting — Value-Based State Sync Over the Bounded Network

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*A siloed design brief for remote access in the TAME Rye OS: Comlink carries terminal state as values over UDP, authenticated by owner keys, sealed by our own crypto, and enclosed by Pond on the server side. The session roams by key, not by address. The remote shell synchronizes state rather than streaming bytes.*

**Language:** EN
**Version:** `20260620.012112` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy
**Status:** Active Design (siloed)

---

## Our Own Ground

This is a clean room. Remote access names only our own modules: **Comlink** (the bounded network), **Rishi** (the shell), **Skate** (the terminal surface), **Pond** (the enclosure), **Caravan** (supervision), and **Tally** (session memory). The remote-shell tradition enters as a concept — reaching a machine from afar, typing commands, seeing results. Everything else is ours.

---

## The Session as a Shared Value

A remote session is a shared value: the terminal's content, cursor position, and mode, represented as a Rishi record. The server holds the authoritative state; the client holds a prediction. Updates flow as state diffs — small datagrams that name what changed — rather than as a byte stream.

This is the same model Mantra's weave keeps: two sides converging on the same state. A lost datagram does not block the next; the client predicts locally and corrects when the server's state arrives. The protocol carries values, not pipes.

---

## The Protocol — Five Properties

1. **Authenticated by owner keys.** Client and server authenticate via Ed25519 and agree on a shared secret via X25519. The session is sealed with ChaCha20-Poly1305. No borrowed crypto; our own foundation, proven in the strengthening series.

2. **State synchronization over UDP.** Each datagram carries a state diff — what changed since the last acknowledged state. Datagrams are independent; a lost packet does not block the next. The frame rate adapts to network conditions.

3. **Roaming by key.** The session is named by the key pair, not by a network address. The client can reconnect from any IP — WiFi to cellular, VPN reconnect, network change — and the session continues. Identity is the anchor; the address is incidental.

4. **Bounded datagrams.** Every datagram has a stated maximum size. No unbounded buffers. A datagram that exceeds the budget is split or fails with a named error.

5. **Pond enclosure on the server.** The remote shell runs inside a Pond enclosure. The policy names what the session may access — which paths, how much memory, whether it may reach the network. The same isolation that protects local applications protects remote ones.

---

## The Session Lifecycle

```
1. Client presents its public key to the server over a bootstrap channel
2. Server verifies the key against its trust policy
3. Key agreement (X25519) derives a session secret
4. The bootstrap channel closes; the session begins over UDP
5. Server sends initial terminal state as a Rishi record
6. Client renders the state in Skate
7. Client sends keystrokes as sealed datagrams
8. Server applies keystrokes, computes new state, sends diff
9. Client predicts the effect of its own keystrokes locally
10. Client corrects its prediction when the server's diff arrives
11. On network change, client reconnects from new address; key authenticates
12. On disconnect, server holds state; client resumes when it returns
```

The session survives network changes because the key — not the address — names it. The server holds the state in a Tally garden; when the session ends, the garden is cleared whole.

---

## What Comlink Remoting Replaces

| Established | Comlink remoting |
|-------------|-----------------|
| Byte stream over TCP | Value-based state diffs over UDP |
| Session bound to TCP connection | Session bound to key pair |
| Head-of-line blocking on packet loss | Independent datagrams; prediction fills gaps |
| Borrowed crypto library | Our own crypto foundation (Ed25519, X25519, ChaCha20-Poly1305) |
| No enclosure on the server | Pond enclosure with stated policy |
| Interrupt may be blocked by full buffers | Interrupts always reach the server |

---

## The Path — From What Already Runs

The sealed datagram between two harts (`aurora/src/posted.rye`) is the first wire. Comlink remoting grows from it:

1. **Sealed datagram over shared memory** — done (posted.rye)
2. **Sealed datagram over emulated network** — the device wire (open thread)
3. **State diff protocol** — serialize terminal state as a Rishi record, compute diffs
4. **UDP transport** — send sealed diffs as datagrams, handle loss and reordering
5. **Client prediction** — render predicted keystrokes locally, correct on server diff
6. **Roaming** — reconnect from new address, re-authenticate by key
7. **Pond enclosure** — server session runs inside a bounded, isolated enclosure

Each step grows from what already runs.

---

*May the remote shell carry values rather than bytes, synchronize state rather than stream, and roam without losing the thread. May the session be named by the key that holds it, not the address that reached it, and may every remote command run inside a garden as bounded and honest as a local one.*
