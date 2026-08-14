# FORA17 — Constel log repair: the leader heals a follower's divergent suffix

**Stamp:** `20260814.083500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (the itinerary filling law — a quest names its own rounds, then climbs them)
**Season:** the Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · **Rung:** FORA17
**Kin:** [`../constel/README.md`](../constel/README.md) · [`../constel/term.rye`](../constel/term.rye) (FORA16) · [`../constel/log.rye`](../constel/log.rye) (FORA12) · [`../constel/catchup.rye`](../constel/catchup.rye) (FORA15) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The one concern this rung takes

The ladder now elects a leader (FORA10), commits one value (FORA11), orders values into an append-only log (FORA12), reconfigures without a fork (FORA13), compacts (FORA14), heals a *lagging* follower (FORA15), and survives re-election so an old leader can't commit (FORA16). Two gaps sit exactly at the seam between FORA15 and FORA16:

1. **FORA15's catch-up heals only a follower that is *behind* with a *matching* prefix.** When a follower's overlap *disagrees* — it holds a different value at a shared index — catch-up rightly refuses `Diverged` and changes nothing. It has no way to *heal* the disagreement, because a `CompactLog` stores only values, with no record of *which term* wrote each one.

2. **FORA16 proved an old leader can never *commit*.** Yet before it is out-voted, an old leader can still have *appended to its own local log* — entries in a stale term that never reached a quorum. When that pier rejoins under a newer leader, its log carries an **uncommitted divergent suffix**. Someone must repair it.

This rung takes that one concern: **the leader forces a follower's log to match its own, truncating the follower's conflicting (uncommitted, stale-term) suffix and appending the leader's true entries** — Raft's AppendEntries consistency check and its **Log Matching Property**, named in Constel's terms.

## Why terms are the missing ingredient

FORA12's `Log` stores `[max_entries]u32` — values only. You cannot tell a *conflict* (same index, different history) from a mere *lag* with values alone. Raft's whole repair machinery rests on one field the value-log lacks: **each entry carries the term of the leader that created it.** So this rung introduces a **`TermedLog`** — an append-only log of `(term, value)` entries, terms non-decreasing along the log (a leader only ever appends in its own term, and terms climb by FORA16). This is the structure Raft actually replicates; FORA12's value-log was the honest simplification that let the ordering law be proven first.

## The Log Matching Property (the crux to prove)

> **If two logs contain an entry at the same index with the same term, then the logs are identical in every entry up through that index.**

It holds because a leader creates at most one entry per (index) in its term, and appends its entries in one term-non-decreasing sequence; so a matching `(index, term)` pins the entire prefix. The repair spends this directly: to heal a follower, find the **highest index where follower and leader agree on term** — by the property, everything at or below that index is already identical — then replace only the strictly-newer suffix. The common prefix is *never rewritten* (append-only holds for it); only the divergent tail, which by FORA16 could never have committed, is discarded.

## Shape

`constel/repair.rye` (FORA17), purely local, standing on FORA16 (terms) · FORA12 (append order) · FORA6 (the medium, for the real-sky scenario):

- **`TermedEntry`** — `{ term: u32, value: u32 }`.
- **`TermedLog`** — `entry: [max_entries]TermedEntry`, `len: u32`. API: `append_entry(term, value)` (refuse `LogFull` at the cap, `TermRegressed` if `term < last_term` — terms never travel backward), `last_index` / `last_term` / `term_at` / `value_at`, `matches(other)`, and `truncate_to(len)` (drop the uncommitted suffix — the *only* mutation that removes an entry, and only ever a stale-term tail).
- **`consistent_at(prev_index, prev_term)`** — Raft's AppendEntries gate: a follower may accept entries after `prev_index` only if its own entry there carries `prev_term` (or `prev_index` names the empty start). The bounded primitive the repair and any real socket both call.
- **`agree_upto(follower, leader)`** — the highest index where both logs agree on `(term, value)`; the divergence point.
- **`repair(follower, leader)`** — the whole heal: truncate the follower after `agree_upto`, append the leader's true suffix, return the count of entries changed. Postcondition asserted: `follower.matches(leader)`, and the agreed prefix bytes are unchanged.

## What the witness proves

`tools/fora_repair_witness.rish`:

1. `append_entry` grows in order and reads back; `TermRegressed` refuses a backward term; `LogFull` at the cap.
2. **Log Matching Property** — enumerated directly: for logs that share a `(index, term)`, their whole prefix is identical; a differing term at an index is the honest divergence point.
3. `consistent_at` — accepts a matching prev, refuses a stale-term or absent prev.
4. **The heal** — a follower with a divergent stale-term suffix is repaired to match the leader exactly; the common prefix is byte-unchanged; the divergent suffix is gone.
5. **Only the uncommitted tail moves** — the agreed prefix is never rewritten (append-only preserved for it); a follower already matching is repaired with zero changes.
6. **No fork across repair** — two followers with *different* divergent suffixes both repair to the *same* leader log and thus to each other.
7. **Over a real sky** — a leader log built by FORA16 termed decrees in term 2; a follower carrying a term-1 stale leader's uncommitted appends; repair heals it, dramatizing FORA16 → FORA17 (the out-voted old leader's local scribbles are the exact tissue repair removes).

## The gate stays the gate

Purely local: bounded in-memory `TermedLog` values over the switchboard on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. The socket rung — this same repair spoken over a real file descriptor — stays the maintainer's hand (custody gate #2).

---

*May every honest pier find its way back to the one true history, and may the only tissue a repair ever removes be the tissue the sky already agreed to forget.*
