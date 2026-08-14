# DREY12 — the desk sync pull loop: the git-fetch as one bounded primitive

**Stamp:** `20260814.071500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Explored and self-approved — Season A · waymark **DREY** · Mikrophone firmware journey · rung **DREY12**
**Kin:** [`../mikrophone/README.md`](../mikrophone/README.md) · [`../mikrophone/serve.rye`](../mikrophone/serve.rye) · [`../mikrophone/manifest.rye`](../mikrophone/manifest.rye) · [`../mikrophone/catalog.rye`](../mikrophone/catalog.rye) · [`20260814-065650_drey9-desk-serves-a-wanted-recording-exploration.md`](20260814-065650_drey9-desk-serves-a-wanted-recording-exploration.md)

---

## The crux

DREY7–DREY9 gave the desk the three git-style **primitives** of content-addressed sync: `catalog` addresses a recording by the Sha256 the wire already carries, `manifest` advertises *what* a desk holds without shipping a payload, and `serve` answers a *want* by re-framing exactly the recording asked for. Each is proven pure, and DREY9's own selftest already walks the whole loop **inline** — write a manifest, compute wanted, serve each, deposit each — ending with two hands holding the same set.

That inline walk is the capstone hiding in a test. The crux of DREY12 is to lift it into a **named, reusable, bounded operation** — one `pull` that a keeper (or a future Comlink transport) calls once, rather than a loop every caller must re-assemble correctly. A primitive read for years earns its own invariants; a copy-pasted test loop does not. This is Lindy-first (the sync algorithm is a durable invariant of the desk) and crux-first (the hardest still-tractable move is composing the negotiation *once*, with the convergence and the bound both asserted).

## The shape

One function, standing entirely on the public APIs already proven — inventing no new transport, buffer, or error of its own beyond a small honest report:

```
pub fn pull(local: *catalog.Catalog, remote: *const catalog.Catalog) !PullReport
```

It reads `remote`'s holdings through `manifest.write_manifest`, **verifies the manifest whole** before trusting a record (verify-before-trust, even for a locally generated manifest — the discipline is the point), then for each advertised address the local desk lacks, calls `serve` and `deposit`. It returns a `PullReport`:

- `advertised` — how many recordings the remote desk holds.
- `wanted` — how many the local desk lacked before the pull.
- `served` — how many frames actually crossed (equals `wanted` on success).

## The invariants that make it a primitive

- **Verify before trust.** The manifest is verified before a single record is read; a corrupt advertisement refuses by name and nothing crosses.
- **Only the wanted crosses.** `served == wanted` — no byte crosses that the local desk did not lack, exactly the have/want economy DREY8 named.
- **Convergence.** On success, the local desk holds *every* address the remote advertised — the two hands meet on a superset. This is the postcondition that earns the word *sync*.
- **Bounded.** The loop is bounded by the manifest count, itself bounded by `catalog.max_entries`. A pull that would pass the local desk's own entry or byte budget refuses `CatalogFull` (catalog's own named bound) — a bounded partial, honest, never an unbounded grow.
- **Local count accounting.** On success, `count_of(local)` afterward equals its count before plus `served` — each served frame is a new distinct address, so the arithmetic is exact.

## What it proves and what it does not

`pull` moves bytes between two **in-memory** catalogs over their public APIs — purely local, no transport. It is the git fetch/pull *algorithm* proven pure before any wire is strung. Running it between two real desks over a real network reaches the **Comlink-served custody gate** (Season 1, Journey 2) and waits for the maintainer's word. No disk, no network, no key signs, no funds — custody gate #2 (real hardware) stays untouched; the content address stays an integrity identity, not a signature.

## The selftest

1. **Full convergence from empty** — a fresh local desk pulls from a remote holding three; `advertised == 3`, `wanted == 3`, `served == 3`, and the local desk ends holding all three.
2. **Partial convergence** — a local desk already holding one of three pulls the other two; `wanted == 2`, `served == 2`, converged.
3. **Idempotent second pull** — pulling again serves nothing; `wanted == 0`, `served == 0`, the desk unchanged.
4. **A tampered manifest refuses** — a flipped record byte refuses `DigestMismatch` before any frame crosses; the local desk lands nothing.
5. **Bounded refusal** — a local desk filled to `max_entries` pulling one more distinct recording refuses `CatalogFull`, the bound holding by name.

Witness `tools/drey_sync_witness.rish`; the aggregate `tools/drey_witness.rish` grows to run DREY12 in rung order.

---

*The desk learns to fetch the whole of what a far hand holds, asking only for what it lacks and proving every byte before it lands — the git pull, proven pure on the bench, waiting only for a wire that stays the keeper's own hand to string.*
