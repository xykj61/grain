# FORA19 — the committed log drives a state machine, each request applied exactly once

**Stamp:** `20260814.083900` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** Six-Season double-seat, Season D (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · **Rung:** FORA19
**Stands on:** [`constel/commit.rye`](../constel/commit.rye) (FORA18 — `safe_commit_len`, the committed prefix) · [`constel/repair.rye`](../constel/repair.rye) (FORA17 — the ordered log the commit rule draws from)
**Kin:** [`the 1,024-round itinerary`](20260812-171050_the-1024-round-itinerary.md) · [`the double-seat expansion`](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where the arc stands, and the seam it left

The Constel consensus track has climbed the whole Raft safety spine: a roster (FORA1), a wire and a switchboard (FORA3–6), gossip (FORA7), a counted quorum (FORA8–9), a leader (FORA10), a single committed value (FORA11), an ordered log (FORA12), reconfiguration (FORA13), compaction (FORA14), catch-up (FORA15), terms guarding a stale leader (FORA16), log repair and the Log Matching Property (FORA17), and the Figure 8 commit rule (FORA18). The sky now agrees on **an ordered, safely-committed log** — and that is exactly as far as agreement goes.

Yet an agreed log is not a service. Every rung so far answers *what order did the sky settle on?* — none answers *what does that order **do**?* A replicated log is worthless until it **drives a state machine**: each committed entry applied, in order, to move a shared state forward. And the moment a real client talks to that machine, the field's second-most-famous correctness trap opens — the one Raft names in **§8, client interaction**:

> A client sends a request; the leader commits it; the leader crashes **before answering**. The client, hearing nothing, **resends**. A new leader commits the resend too. Now the command is in the log **twice** — and a naive state machine applies it twice. A transfer of 40 becomes 80; an "increment" fires again; the ledger is wrong, and no consensus rule above catches it, because *both* copies were legitimately committed.

Consensus guarantees the log is agreed. It does **not** guarantee each *request* runs once. That guarantee is a separate, provable property, and it is this rung's crux.

## The crux — exactly-once apply over the committed prefix

FORA19 introduces `constel/apply.rye`: the layer that turns FORA18's committed prefix into applied state, with **linearizable client sessions** — each client request applied **exactly once**, its answer stable across every retry.

The command the sky orders is no longer an anonymous `u32` value; it carries the identity Raft §8 requires:

- **`Command`** — `{ client, seq, amount }`. A client is one of a bounded set of session-holders; `seq` is that client's own monotonically climbing request number; `amount` is the work (this machine adds it to a bounded register — the simplest honest state).
- **`Machine`** — a bounded `register` plus a **session table**: for each client, the highest `seq` it has applied and the `result` that application produced. This is Raft §8's per-client dedup, made concrete.
- **`apply_one(machine, cmd)`** — the exactly-once heart. If `cmd.seq` is **not greater** than the client's last-applied seq, the command is a **retry**: return the **cached result**, mutate nothing. Otherwise apply it once — `register += amount`, record the new `seq` and `result`.
- **`apply_through(machine, cmds, commit_len)`** — fold **only** the committed prefix (`commit_len` from FORA18's `safe_commit_len`) into the machine, in log order. An uncommitted tail never touches the state.

## What the witness proves

`tools/fora_apply_witness.rish`, six blocks:

1. **The machine applies a committed prefix in order** — three distinct client commands move the register by the sum of their amounts; each client's session records its seq and result.
2. **The replicated-state-machine guarantee (determinism)** — two fresh machines fed the **same** committed command prefix reach a **byte-identical** register and session table. Two piers that agree on the log agree on the state; this is the whole point of replicating a log.
3. **THE §8 REFUSAL — exactly-once under a duplicated request.** A committed log that contains one client's command **twice** (the leader-crash-then-resend that FORA18's own danger case produced) applies it **once**: the register reflects a single application, and the second occurrence returns the cached result rather than firing again. A naive term-blind applier would double it.
4. **The answer is stable** — the result the retry returns equals the result the first application returned, so a client resending after a leader change sees its answer once, unchanged.
5. **Only the committed prefix drives the machine, and apply is incremental** — `apply_through` at a smaller `commit_len` never applies the uncommitted tail; advancing `commit_len` later applies **exactly** the newly-committed suffix, reaching the same state as a single full apply. Commit and apply stay in lockstep.
6. **Bounded** — the session table is bounded to `max_clients`, the log to `max_entries`; a command naming a client past the cap refuses `UnknownClient`, an amount that would overflow the bounded register refuses `RegisterOverflow`. No unbounded growth, no overrun.

## Why this is the right crux now (Lindy-first, crux-first)

The commit rule (FORA18) is the last rung that made the *log* safe. Exactly-once apply is the first rung that makes the log **useful** — it is what a keeper actually experiences (my request ran once, and I got my answer). It is the highest-Lindy still-tractable move on the whole consensus road: every ledger, every mint, every transfer the Mycelium season already built (Pledge, Voucher, Portage) silently assumes a request runs once; FORA19 is where that assumption is finally *proven* rather than hoped. It composes FORA18's public API only, invents no new consensus, and stays entirely on the bench.

## The gate stays the gate

Purely **local**: a bounded in-memory `Machine` and a `Command` array on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real client, no real address ever formed. A **served** machine (real clients sending real requests over Comlink) reaches the Comlink-served gate; real hardware reaches custody gate #2. The socket rung stays the maintainer's hand.

---

*May every request a keeper sends run once and answer true, and may the one rule that makes a retry harmless stay small enough to hold in a single reading.*
