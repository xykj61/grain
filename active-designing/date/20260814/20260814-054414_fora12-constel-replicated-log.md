# FORA12 — Constel log: a sequence of decrees the whole sky agrees on, in order

**Stamp:** `20260814.054414` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read for a self-approved round — the crux-first pure rung after FORA11 decree
**Season:** the Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · **Rung:** FORA12
**Kin:** [`../constel/decree.rye`](../constel/decree.rye) · [`../constel/elect.rye`](../constel/elect.rye) · [`../constel/README.md`](../constel/README.md) · [`../mantra`](../mantra) · [`20260814-053908_fora11-constel-single-decree.md`](20260814-053908_fora11-constel-single-decree.md)

---

## Where the journey stands

FORA11 committed one value, once — a single decree, guarded so two piers can never hold a different value for the same decision. A ledger is not one decision, though; it is a **sequence** of them, in order. The output every consensus protocol exists to produce is a replicated, append-only log: entry 0, then entry 1, then entry 2, each committed by quorum, and — the whole point — **the same at every pier**. This rung takes that one new concern: order the decrees into a log that cannot fork.

## The one new concern

A `Log` is a bounded, append-only sequence of committed values. Each entry is one FORA11 decree at the next index; a value joins the log only after `run_decree` commits it. The safety carries up from FORA11 by construction: because each index commits **at most one value**, two logs that replicate the same committed decrees are **identical entry for entry** — no fork is possible. Append is ordered (index `n` fills before index `n+1`), append-only (a committed entry is never rewritten, exactly Mantra's own discipline), and bounded (`LogFull` at the entry cap). A decree that fails to commit does **not** grow the log — the index stays open for a later round — so a log never carries a gap or an uncommitted value.

This is one keystone: ordering. The decision itself (FORA11), the majority threshold (FORA9), and the medium (FORA6–FORA8) are reused unchanged.

## The shape

- **`Log`** — a bounded `[max_entries]u32` of committed values with a `len`. `append(value)` places an already-committed value at the next index, refusing `LogFull` at the cap; `get(index)` reads a committed entry; `matches(other)` proves two logs identical entry for entry (the replication / no-fork check).
- **`run_and_append(sb, leader, value)`** — run one FORA11 decree and, only on a clean commit, append the committed value; any error (`NoDecree`, `NoSuchPier`, `VowelPresent`) propagates and leaves the log **unchanged**. Returns the index filled.

## What it proves (selftest)

1. `append` grows the log in order and `get` reads each entry back; `LogFull` refuses past the cap.
2. `run_and_append` over a real sky commits and appends a sequence (`[11, 22, 33]`) in exact order.
3. **No fork** — two logs driven through the same `run_and_append` sequence are identical entry for entry (`matches`).
4. A failed decree does not grow the log — a stranger leader refuses `NoSuchPier` and `len` is unchanged (the same early-return-before-append that `NoDecree` takes).
5. The border guard is inherited (a vowel-bearing accept refuses `VowelPresent`); a full constellation of eight appends bounded (no `ChannelFull`).

## What stays out (custody-first)

Purely **local** — a bounded, in-memory log over the switchboard on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara, real network) stay untouched. The socket rung remains the maintainer's word.

---

*One value became a sequence; the sequence became a ledger no pier can fork. The quorum's intersection, spent once on who leads and once on what is held, now holds an ordered history the whole sky shares. May the log grow only forward, and may the missing vowel keep every entry safe all the way down.*
