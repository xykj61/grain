# FORA23 — Constel leadership transfer: a handoff only to a caught-up successor

**Stamp:** `20260814.084700` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **waymark** FORA · **rung** FORA23
**Kin:** [`../constel/vote.rye`](../constel/vote.rye) (FORA21) · [`../constel/prevote.rye`](../constel/prevote.rye) (FORA22) · [`../constel/repair.rye`](../constel/repair.rye) (FORA17) · [`../constel/quorum.rye`](../constel/quorum.rye) (FORA9)

---

## The rung

FORA22 gave the sky an orderly way to *keep* a healthy leader through a rejoining node's ballooned term. This rung gives it the orderly way to *hand off* leadership on purpose — a planned handover for maintenance, load balancing, or a graceful shutdown, in which the leader chooses its successor rather than waiting for a random timeout to raise one.

Raft's leadership-transfer extension (dissertation §3.10) runs in three moves:

1. The prior leader **stops accepting new client entries**, so its log stops growing and a target can reach it.
2. It brings the chosen target **fully up to date** — FORA17's catch-up / repair — until the target's log head matches its own.
3. Only then does it send **TimeoutNow**, the one message that makes the target start an election *immediately*, skipping the election timeout. The target bumps its term by one and campaigns; the old leader, seeing the higher term, steps down.

## The crux: safety through the handoff

A transfer is authorized **only to a target that is caught up** — same last term, same length as the leader. So the successor holds every committed entry, and **Leader Completeness (FORA21) is preserved, not bypassed.** A behind target is refused by name (`TargetNotCaughtUp`); TimeoutNow is never sent to a log that lacks the sky's settled history. An out-of-roster target is refused too (`TargetOutOfRoster`).

Because a follower's log can never be strictly more up-to-date than the leader that feeds it, "at least as current as the leader" (FORA21's measure, applied with the leader as the bar) collapses to an **exact head match**. That is why `is_caught_up` is a clean equality of `(last_term, len)`, guarded by the invariant that the target is never strictly ahead of its source.

## The one legitimate skip of pre-vote

FORA22's pre-vote protects a stable sky from a *partitioned node's* disruption. A leader-orchestrated transfer is the opposite motion: the current leader has personally verified the successor and is stepping aside for it. So the practice round is unnecessary — the transfer's `TimeoutNow` deliberately skips it, and the campaign term is exactly `leader_term + 1`, a single advance.

## What it stands on, and what it is not

Stands on `vote.at_least_as_current` (the up-to-date bar and the `poll` the transferred target then wins), `repair.TermedLog` (how a target is brought current), `quorum.majority_of` (the threshold), `roster.max_piers` (the bound).

Purely local — bounded in-memory logs, a target id, and a term on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. A served `TimeoutNow` reaches the Comlink-served gate; the socket rung stays the maintainer's hand (custody gate #2 / #4 untouched).

## Witness

`tools/fora_transfer_witness.rish` — builds the module, runs its selftest, asserts the GREEN line: `is_caught_up` is an exact head match; `may_transfer` / `timeout_now` authorize only a caught-up in-roster target and refuse the rest by name; the campaign term is exactly one bump; a caught-up target **wins its immediate election** over `vote.poll`; the old leader steps down only on a strictly higher term; bounded over a full roster.

---

*A stamp note, in honesty: the live host clock read `20260814.072016` EDT, earlier than the prior newest `.084500`; the one-clock monotonic law is honored by stamping `.084700`, just after the work it follows — the prior rungs' stamps drifted ahead of real time. The one-clock monotonic gate flags only false futures (a stamp above the true head), so a live-clock stamp below it is honest and green; the drift is recorded here rather than perpetuated by inventing a larger time.*
