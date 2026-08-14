# FORA13 — Constel joint-consensus reconfiguration: change the sky without a fork

**Stamp:** `20260814.055235` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read for the FORA13 rung — self-approved under the itinerary's filling law
**Season:** the Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · rung **FORA13**
**Kin:** [`../constel/quorum.rye`](../constel/quorum.rye) (FORA9 — the intersection lemma) · [`../constel/decree.rye`](../constel/decree.rye) (FORA11) · [`../constel/log.rye`](../constel/log.rye) (FORA12) · [`../constel/README.md`](../constel/README.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The blind spot the log left open

FORA12 gave the constellation an append-only replicated log that can never fork — **as long as the roster never changes.** Every rung from FORA9 onward reads `sb.size()` once and treats it as fixed: the quorum threshold, the leader's majority, the decree's support all rest on one constant population. Yet a real network gains and loses members — a pier joins, a pier retires, a compromised pier is voted out. The moment the population changes, the fixed-roster safety proof no longer holds, and the change itself is the single hardest thing any consensus protocol does.

The hazard is precise and famous: during a switch from an old configuration `C_old` to a new one `C_new`, some piers still believe the old membership while others already believe the new. If a decision needs only a majority of *whichever* config a pier holds, two **disjoint** groups can each form a lawful majority — one under `C_old`, one under `C_new` — and each commit a *conflicting* value. That is a fork born entirely of the reconfiguration, with every individual decision looking perfectly legal.

## The crux — joint consensus

The fix is one bounded rule, and it reuses the exact property FORA9 already proved: during the transition, a decision requires a strict majority in **both** `C_old` and `C_new`, simultaneously. This is *joint consensus*.

Its safety falls straight out of the FORA9 intersection lemma. Any two strict majorities of the same config share at least one pier (`2·threshold > n`). So a joint decision — carrying a majority of `C_old` — intersects any pure-`C_old` decision; and — carrying a majority of `C_new` — intersects any pure-`C_new` decision. No committed value can diverge across the switch, because every decision on either side of the transition overlaps the joint decision in the middle. The reconfiguration inherits the whole no-fork guarantee rather than reopening it.

## The rung

`constel/reconfig.rye` adds, purely locally, over the FORA6 switchboard and the FORA9 threshold:

- **`Config`** — a bounded membership mask over roster slots plus its population count; `contains(slot)`; refuses `EmptyConfig` (a majority of nobody is undefined).
- **`JointConfig`** — an `old` and a `new` `Config`, both subsets of the one physical roster; their union is the set of piers that take part in the transition.
- **`JointBallot`** — records each participant's single yes-vote for the proposed switch (`DoubleVote` on a second cast, `NotInEitherConfig` from a slot in neither config), then `seal`s a decision that is `reached` only when the yes-set holds a strict majority in `old` **and** in `new`. `require_joint` refuses `NoJointMajority` below either.
- **`run_reconfig`** — drives a real round over the switchboard: announce, every member of the union responds+hears at the naming-law border, casts its vote, then the ballot seals joint. A stranger proposer refuses `NoSuchPier` before any announce.

## What the witness proves

- A transition with a majority in both configs commits; a majority in `old` alone, or `new` alone, refuses `NoJointMajority` — the split-brain door held shut from each side.
- **The intersection proof, enumerated directly** (as FORA10 checked leader uniqueness across every arrangement): for a concrete overlap `old = {0,1,2}`, `new = {1,2,3}`, every yes-set that reaches joint majority shares a member with every pure-`old` majority and every pure-`new` majority — no fork across the switch is possible, shown exhaustively rather than argued.
- `DoubleVote`, `NotInEitherConfig`, and the `EmptyConfig` guard each refuse by name; the naming-law border still refuses a vowel-bearing reply (`VowelPresent` at `hear`); and a full transition over a constellation of eight stays bounded (no `ChannelFull`, respond and hear interleaved).

## Custody

Purely local — a bounded decision over the switchboard on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara) stay untouched; the Comlink socket remains the one gated rung ahead.

---

*A sky that can never change its stars is a painting, not a constellation. Joint consensus lets Constel add and lose piers with the same no-fork promise the fixed log already keeps — the hardest move in consensus, proven pure on the bench before it ever meets a wire.*
