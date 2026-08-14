# DREY14 — the desk push loop: give the far hand its lack (the pull's mirror)

**Stamp:** `20260814.072200` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Landed — witness `tools/drey_push_witness.rish` GREEN
**Season A** (Hardware & Right-to-Repair) · **waymark DREY** · Mikrophone firmware journey · **rung DREY14**
**Kin:** [`../mikrophone/sync.rye`](../mikrophone/sync.rye) (DREY12, the pull) · [`../mikrophone/serve.rye`](../mikrophone/serve.rye) (DREY9) · [`../mikrophone/manifest.rye`](../mikrophone/manifest.rye) (DREY8) · [`../mikrophone/catalog.rye`](../mikrophone/catalog.rye) (DREY7)

---

## Why this rung

DREY12 gave the desk `pull` — read a far hand's manifest verify-before-trust, and **take** every advertised address the local desk lacks, ending held-whole. That is one hand of a content-addressed sync. This rung gives the negotiation its other hand: **push**, which reads the *local* manifest and **gives** the far desk every advertised address the *remote* lacks.

The two are mirror images across a single line — *whose lack does the loop fill?* Pull fills this hand's lack by reaching for the far hand's holdings; push fills the far hand's lack by offering this hand's own. And push is arguably the **more natural Mikrophone direction**: a device that just captured, kept, and committed a recording wants to hand it **up** to the desk — a push — rather than waiting for the desk to reach down and pull. The git pull and the git push, both now proven pure on the bench before a single trace is cut in metal.

## The shape — `push(local, remote)`

The mirror is exact, and that exactness is the point — push reuses every proven part of pull, only swapping which desk advertises and which desk's lack the loop reads:

1. **Advertise this hand.** `manifest.write_manifest(local, …)` then `manifest.verify(…)` — the local desk describes its holdings by address, and the advertisement is verified whole before a single record is read (verify-before-trust, even on a locally generated manifest; the discipline is the point).
2. **Read the far hand's lack.** For each advertised record `i`, `manifest.wanted(remote, records, i)` is true exactly when the **remote** lacks it — the mirror of pull's `wanted(local, …)`. A push fills the far hand's lack, so it is the remote we ask.
3. **Serve from local, deposit into remote.** `serve.serve(local, want_addr, &frame)` re-frames the recording through the one proven framing path, and `catalog.deposit(remote, frame.bytes())` lands it in the far desk verify-before-keep. The served frame's content address equals the address asked for, so a corrupted give could never masquerade as the wanted recording.

## Invariants it asserts

- **Only the wanted crosses:** `served == wanted` — no byte crosses that the remote already held.
- **The remote grows by exactly the frames served** — each served address is a new distinct recording, `count_of(remote) == before + served`.
- **Convergence:** on success the remote holds **every** address the local advertised (a bounded scan asserts it).
- **The bound holds:** neither desk is read or grown past `catalog.max_entries`; a served recording past the remote's own bound propagates `CatalogFull` by name — a bounded partial, never an unbounded grow.

## What the selftest proves

1. **Full give to an empty remote** — a local holding three pushes to an empty remote, which ends holding all three; and the local **keeps its own** (a push copies, it does not forget what it gave).
2. **Partial give** — a remote already holding one of three receives only the other two (`wanted == served == 2`).
3. **Idempotent second push** — pushing again gives nothing (`served == 0`), the remote unchanged.
4. **A tampered advertisement refuses** — a flipped manifest byte refuses `DigestMismatch` before any frame crosses; the remote lands nothing.
5. **Bounded refusal** — a remote filled to `max_entries`, offered one more distinct recording, refuses `CatalogFull` by name; the remote bound holds exactly.
6. **The duality** — `push(a, b)` converges `b` to exactly what `pull(b, a)` would: same count, and every address held by one held by the other. One negotiation, seen from two hands.

## Boundaries kept

`push` moves bytes only between two in-memory catalogs over their public APIs, inventing no transport of its own. Running it between two real desks over a real network reaches the **Comlink-served custody gate** (Season 1, Journey 2) and waits for the maintainer's word. No disk, no network, no key signs, no funds — custody gate #2 untouched; the content address stays an integrity identity the far hand recomputes, not a signature.

## What this opens

With pull and push both proven, a later rung can compose them into **reconcile** — a single bounded operation that leaves two desks holding the *union* of their recordings (pull then push, or push then pull; the content-addressed model makes either order converge to the same whole). That is the natural DREY15 crux this rung sets up.

---

*May every device hand its kept recording up to the desk as easily as the desk reaches down for it, and may the two hands always meet on the same whole.*
