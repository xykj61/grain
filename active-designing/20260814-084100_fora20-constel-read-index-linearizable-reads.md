# FORA20 — a linearizable read without a log append (the read-index)

**Stamp:** `20260814.084100` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** Six-Season double-seat, Season D (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · **Rung:** FORA20
**Stands on:** [`constel/apply.rye`](../constel/apply.rye) (FORA19 — the state machine a read observes) · [`constel/commit.rye`](../constel/commit.rye) (FORA18 — the commit index a read captures) · [`constel/term.rye`](../constel/term.rye) (FORA16 — the term a leader confirms)
**Kin:** [`the double-seat expansion`](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The seam FORA19 left

FORA19 gave the ledger a **write** that runs exactly once — a client's request applied a single time however many leaders it crossed. Yet a service is read far more than it is written, and a read has its own correctness trap, the other half of Raft's **§8**:

> A client asks a **deposed** leader for the current value. That old leader still believes it leads; it answers from its own state machine — a value the true sky has already moved past. The read is **stale**, and no write rule catches it, because the read never went through the log at all.

The naive fix is to route every read through the log as a no-op entry, so it commits behind all prior writes. That is correct and needlessly slow: reads would pay a full round of replication. Raft's real answer is the **read-index** — a way to serve a linearizable read **without appending anything**, resting on two facts a leader can check cheaply:

1. **Confirm leadership.** Before answering, the leader confirms a **majority still holds its term** — no newer leader has superseded it. This spends FORA16's exact lemma: once a majority has advanced past term `T`, a leader in `T` is out-voted by construction, so a majority *still at* `T` proves the leader current.
2. **Capture the read-index.** The leader records the current **commit index** (FORA18's `safe_commit_len`) as the read's floor, applies its state machine **through** that index (FORA19's `apply_through`), and only then answers. The value it returns therefore reflects **every write committed before the read began**.

## The crux — a read reflects all prior writes, and a stale leader serves none

FORA20 introduces `constel/read.rye`: a linearizable read that appends nothing.

- **`leadership_confirmed(terms, current_term, threshold)`** — `terms.at_least(current_term) >= threshold`: a majority still stands at the leader's term. The whole liveness-vs-safety hinge in one line, borrowed from FORA16.
- **`linearizable_read(machine, cmds, read_index, terms, current_term, threshold)`** — the protocol: refuse `NotLeader` if leadership is not confirmed (mutating nothing); otherwise apply the committed prefix through `read_index` into the machine and return its register. Because `apply_one` is exactly-once, applying through a read-index the machine has already reached is a no-op — a read never double-applies, and never writes.

## What the witness proves

`tools/fora_read_witness.rish`, six blocks:

1. **A read reflects every write committed before it** — a read-index captured over a committed prefix, applied and read, returns the register reflecting exactly those writes (their summed amounts).
2. **The read-index is the commit index (composes FORA18)** — `read_index` is derived by `commit.safe_commit_len` over a real `TermedLog` + `MatchView`, then fed to the read: an old-term entry not yet safely committed is **not** reflected in the value served, exactly as the write path refuses to commit it.
3. **A stale leader serves nothing** — when a majority has advanced past `current_term` (a newer leader exists), `leadership_confirmed` is false and `linearizable_read` refuses `NotLeader`, returning no value and leaving the machine untouched. The deposed-leader stale read is refused at its root.
4. **Monotonic reads (read-your-writes)** — a second read after more writes commit returns a value **at least** the first; the register only ever climbs, so a linearizable read never goes backward.
5. **A read appends nothing and is idempotent** — two reads at the same read-index return the identical value and leave the committed command stream unchanged; the read is side-effect-free on the log (the whole point of the read-index over a log no-op).
6. **Bounded** — the read runs over a committed prefix within the entry cap; a read-index past the committed commands refuses by name.

## Why this is the right crux now

FORA19 proved the write half of a linearizable service; FORA20 proves the read half. Together they are a **complete linearizable key-value service** on the bench — the thing every ledger the Mycelium season built (Pledge, Voucher, Portage) is, underneath. It is the highest-Lindy still-tractable move: a correct read is what a keeper experiences on every single interaction that is not a write, which is most of them. It composes FORA16 · FORA18 · FORA19 public API only and invents no new consensus.

## The gate stays the gate

Purely **local**: a bounded in-memory `Machine`, a committed `Command` array, and a `TermTable` on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real client, no real address. A **served** read (a real client asking over Comlink) reaches the Comlink-served gate; the socket rung stays the maintainer's hand (custody gate #2).

---

*May every read a keeper takes be true as of the moment they asked, and may a leader the sky has left behind answer for nothing at all.*
