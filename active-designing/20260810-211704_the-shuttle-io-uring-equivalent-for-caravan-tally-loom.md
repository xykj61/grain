# The Shuttle — Grain's io_uring Equivalent, If Needed

**Language:** EN
**Stamp:** `20260810.211704` (2026-08-10 EDT)
**Voice:** Kyri (Qkri register) · **Style:** Radiant
**Status:** Vision -- Design assessment · **horizon, not now** — answers a paused design question, builds nothing
**Kin:** Caravan (supervision) · Tally (bounded allocation) · Basin (bounded circular buffer) · Loom (reds-first)

---

## The question

What is Grain's equivalent, *if needed*, of Linux **io_uring** — for **Caravan**, **Tally**, and **Loom**?

io_uring's essence, stripped of Linux: two shared **bounded ring buffers** between a producer and a consumer — a **submission** ring and a **completion** ring — so work is **batched** (no syscall per op), **pre-registered** (fixed buffers named up front, no hot-path allocation), and **decoupled** (submit now, complete later). Determinism and speed come from bounded rings and registered resources, not from magic.

## Is it needed?

**Not yet.** Grain's I/O today is synchronous and bounded, mostly at the Rishi/host seam (`run` returns `{status, out, err}`) — no completion model is missing. The equivalent earns its keep only when Grain does **high-throughput async I/O**: Mandate's future **object-storage backing** (serverless like turbopuffer), **Comlink** serving many peers, or a batched persistence path in Mantra. Until one of those lands, this stays a named horizon. Naming it now means it is ready the day it is wanted, not invented under pressure.

## The shape, when it is wanted — "the Shuttle"

A loom's **shuttle** carries the weft thread across the warp and back. The submit→complete round trip is exactly that motion, so the whole abstraction takes the name **shuttle** — loom-kin, clear, and warm.

- **Two bounded rings, as Basins.** Grain already has **Basin**, a bounded circular buffer. The shuttle is a **submission Basin** and a **completion Basin** — no new primitive, just two Basins with a named `max_in_flight` depth, asserted at every push and pop. SPSC by construction: one producer, one consumer per ring, stated as an invariant rather than hoped.
- **Tally registers the buffers.** io_uring's registered fixed buffers map onto **Tally's** bounded-allocation discipline: the shuttle's I/O buffers are seated from the season allocator up front, so the hot path never allocates. Every buffer names its bound; the ring never grows.
- **Caravan supervises the worker.** The consumer that drains submissions and posts completions is a **Caravan**-supervised service (s6-discipline): it is the supervised boundary between the app and the I/O below, restarted on fault, never a raw thread nobody owns.
- **Loom weaves the recurrences.** *A lantern that fires twice becomes a loom.* When the same submission shape recurs each round, **Loom** holds it as a standing template and feeds the submission Basin **deterministically** — io_uring's batching, but pattern-woven, so a repeated request costs no re-description.

## The disciplines it must keep

- **No syscall-per-op, no hot-path allocation** — the whole point; both asserted, not assumed.
- **Every ring depth is a named bound** (`max_in_flight`, buffer count), enforced at the edge (TAME).
- **A portable synchronous floor.** Where a platform has no io_uring-like facility, the shuttle degrades to plain bounded synchronous calls — the same result, slower — so Grain stays portable and the async path is an optimization, never a requirement. Seam-only, like every inherited-std boundary.
- **Determinism from discipline** — a completion is a fact posted to a Basin and verified, never a callback into unowned code.

## What this note is not

It seats no code and opens no lap. It answers the question with a shape and a name, and marks the trigger (Mandate object-storage · Comlink serving · Mantra batched persistence) that would turn the horizon into a real journey.

---

*The shuttle waits on the loom until there is weft to carry — two bounded Basins, buffers registered, worker supervised, recurrences woven — and not one ring before the throughput asks for it.*
