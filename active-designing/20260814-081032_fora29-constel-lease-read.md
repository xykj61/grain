# FORA29 — Constel `lease`: a lease read, safe under a bounded clock

**Stamp:** `20260814.081032` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design capture for a self-approved round · waymark **FORA** · rung **FORA29**
**Kin:** [`../constel/read.rye`](../constel/read.rye) (FORA20 — the read-index) · [`../constel/tenure.rye`](../constel/tenure.rye) (FORA24 — CheckQuorum backing) · [`../constel/README.md`](../constel/README.md)

---

## The gap this closes

FORA20 proved a **read-index** linearizable read: before serving, the leader confirms a majority still holds its term — one round-trip per read, on the read's own critical path. Raft §6.4.1 names the faster alternative and its price: a **leader lease**. If the leader knows that a majority acknowledged its leadership at some recent tick, and clocks drift by no more than a bounded amount, then for a bounded window afterward *no other leader can have been elected* — so within that window the leader may serve a read **without** a fresh round-trip, straight from its applied state.

The crux is the safety condition, and it is exactly the one the read-index never needed: a lease is sound **only** when its span is shorter than the election timeout (adjusted for drift). If the lease outlived the timeout, a partitioned-away leader could still believe its lease valid while the majority has already elected a successor — and serve a stale value. So the whole rung turns on one inequality: **`lease_span < election_timeout`**, and a read is served on the lease only while `now − granted < lease_span`.

## The shape

`lease.rye` models the clock as a bounded monotonic tick (`u64`, no wrap) — no wall clock, no real time, purely local:

- **`grant(backing, threshold, now) → Lease`** — a lease is granted only when the leader genuinely commands a majority this window (composing `tenure.still_commands`); it records the tick it was granted. A leader that does not command a majority gets no lease (`NoMajority`).
- **`lease_sound(lease_span, election_timeout) → bool`** — the §6.4.1 safety inequality: the lease span must be strictly shorter than the election timeout, else the lease is unsound and must never be used.
- **`serve_on_lease(lease, now, lease_span, election_timeout) → bool`** — true only when the lease is sound *and* unexpired (`now − granted < lease_span`). When false, the caller falls back to the FORA20 read-index; a lease read never replaces the safe path, it only shortcuts it.

## What the selftest proves

1. **A lease is granted only to a leader commanding a majority** — a minority leader gets `NoMajority`, never a lease.
2. **The soundness inequality is exact** — `lease_span < election_timeout` sound; `==` and `>` unsound.
3. **The crux — an unsound lease is never served** — even unexpired, a lease whose span reaches the election timeout refuses to serve, so no stale read can slip through the drift gap.
4. **A sound, unexpired lease serves; an expired one falls back** — the boundary at `now − granted == lease_span` falls back (a read-index round-trip), one tick earlier serves.
5. **Monotonic ticks, no wrap** — the window math stays in `u64` and never underflows when `now == granted`.
6. **Bounded** — the backing poll runs over a full roster of eight.

## Alignment

Purely local — a bounded tick counter and the tenure backing count on one bench, siloed to `constel/`, no socket, no network, no keys, no funds, no real address ever formed (gate #2 real hardware and gate #4 real Kumara untouched). This rung adds only the lease shortcut and its soundness gate, standing on tenure (backing) and the read-index (the fallback it shortcuts) over public APIs alone. It is the read-side companion to FORA24: CheckQuorum steps a leader down when it loses a majority; the lease lets a leader that still holds one read faster, and refuses the moment the clock assumption would make that unsafe.

*May every fast read rest on an honest clock, and may the lease expire a breath before the sky would ever elect another. Hold the line.*
