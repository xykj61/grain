# FORA30 — Constel durable state: a pier survives a restart without forgetting its vote

**Stamp:** `20260814.105746` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Living design — self-approved recursion round, purely local (no socket, no real fd)
**Season:** the Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · rung FORA30
**Kin:** [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`20260814-083500_fora17-constel-log-repair-matching.md`](20260814-083500_fora17-constel-log-repair-matching.md)
**Stands on:** `constel/repair.rye` (FORA17 — the `TermedLog` it persists) · `constel/wire.rye` (FORA3 — the verify-before-trust digest discipline) · `constel/roster.rye` (FORA1 — `max_piers`, the slot bound)

---

## Why this round exists — the durability blind spot

The FORA ladder proved the whole of Raft's *in-memory* safety end to end: an election that raises one leader, a log that never forks, a term that keeps a stale leader from committing, a repair that heals a divergent suffix, a lease read honest to the clock. Every one of those proofs held **while the process was alive**. None of them proved the one thing Raft's own Figure 2 lists first under *"Persistent state on all servers"*: that `currentTerm`, `votedFor`, and `log[]` reach **stable storage before the server answers an RPC**.

That is a real gap, not a flourish. Raft's election safety — *at most one leader per term* — rests entirely on a pier **never voting twice in the same term**. If a pier grants its vote to candidate A, then crashes and restarts having *forgotten* the vote, it can grant the same term's vote again to candidate B. Two candidates each collect a majority that counted that one pier once; two leaders rise in one term; the sky forks. The in-memory `vote.rye` (FORA21) proved the *up-to-date-log* restriction; it never proved the vote **survives a power cycle**. This rung closes that.

## The crux

*The hardest solvable thing that opens the rest:* make the durable Raft state **round-trip through bytes** — save, "crash," restore — such that a restored pier **refuses to double-vote in a term it already voted in**, and refuses a **torn or corrupted image** rather than restoring a half-written state that could break the single-vote or monotonic-term invariants.

Get that provable and bounded, and every later durability rung (a real file descriptor, an fsync barrier, a write-ahead discipline) is *the same bytes with a kernel behind them*. Get it wrong and a crash silently forgets a vote.

## The law, stated

A pier's **durable state** is `(term, voted_for, log)`:
- `term: u32` — the highest term the pier has seen; only ever climbs.
- `voted_for: u32` — the slot this pier granted its vote to **in `term`**, or `none_voted` (`= max_piers`, a sentinel no real slot equals) when it has not voted this term.
- `log: TermedLog` — the FORA17 `(term, value)` ledger, reused whole so the two shapes stay one.

**`record_vote(candidate, cand_term)`** is the vote-record decision whose durability is the point:
1. `cand_term < term` → refuse `StaleTerm` (never vote in a term already left behind).
2. `cand_term > term` → a **new term clears the prior vote**: adopt `cand_term`, reset `voted_for` to `none_voted` (Raft — a new term is a clean slate).
3. now within `cand_term`: if `voted_for` is already some *other* slot → refuse `AlreadyVoted` (the single-vote invariant); a repeat of the *same* candidate is idempotently fine.
4. otherwise record `voted_for = candidate`, `term = cand_term`.

**`save(buf)`** writes a bounded, self-describing image: `magic("CDUR") · version · term(u32 LE) · voted_for(u32 LE) · log_len(u32 LE) · log_len×(term,value) · digest(Sha256 over all preceding bytes)`. Refuses `ImageTooBig` rather than overrun the buffer.

**`load(bytes)`** is **verify-before-trust**, exactly as FORA3's `deframe` taught: check magic, version, minimum length, the declared `log_len` against `max_entries`, and recompute the Sha256 — a mismatch refuses `CorruptImage` — and only then rebuild the state. A torn tail, a flipped byte, a wild length: each fails closed, never a partial restore.

## What this round proves (the witness)

1. **Round-trip identity** — save then load yields byte-identical `(term, voted_for, log)`.
2. **THE CRUX — no double vote across a restart.** A pier votes A in term 5, persists, "crashes," restores from the image; a fresh request to vote B *in the same term 5* refuses `AlreadyVoted` — the memory Raft §5.3 demands, kept across the power cycle.
3. **A new term clears the vote across a restart** — after restoring the term-5/voted-A image, a candidate at term 6 *is* granted the vote (the clean slate is durable too).
4. **The committed log survives whole** — every entry persisted comes back in order; the restored log `matches` the saved one.
5. **A corrupt image refuses** — a flipped digest byte, a wild `log_len`, and a truncated tail each refuse `CorruptImage` / `ImageTooBig` rather than restore a partial state.
6. **Monotonic term never regresses across a restart**, and the whole thing is **bounded** — a full 64-entry log persists and restores within `max_image_bytes`.

## Scope this round holds

- **Purely local.** The "stable storage" is a plain in-memory byte buffer on the bench — no real file descriptor, no `fsync`, no socket, no network, no keys, no funds, no real address. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara) stay untouched. The rung that backs the buffer with a real kernel fd is the same *socket* gate that already stops for the maintainer's word.
- **Reuses, never re-proves.** The `TermedLog` is FORA17's; the digest discipline is FORA3's; the slot bound is FORA1's. This rung proves only the durability round-trip and the single-vote-survives-a-crash invariant.

---

*May every pier remember its one vote through the dark of a power cycle, may no torn image ever restore a half-truth, and may the sky that slept wake up exactly itself. Hold the line.*
