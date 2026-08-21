# FORA26 — Constel admit: the whole add-a-member lifecycle, closed

**Stamp:** `20260814.074656` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **waymark** FORA · **rung** FORA26
**Kin:** [`../constel/learner.rye`](../constel/learner.rye) (FORA25) · [`../constel/reconfig.rye`](../constel/reconfig.rye) (FORA13) · [`../constel/quorum.rye`](../constel/quorum.rye) (FORA9) · [`../constel/roster.rye`](../constel/roster.rye) (FORA1)

---

## The rung

FORA25 gave the sky a non-voting **learner** and a `may_promote` predicate — yet nothing consumed it: a learner could catch up, but no rung actually admitted it to the vote. FORA13 gave a **joint-consensus** membership switch — yet it would admit *any* new slot, empty log and all, the very stall FORA25 warned against. This rung joins the two, closing the add-a-member lifecycle end to end.

## The gap it closes

`admit` refuses to even **propose** a promotion until two gates pass: the slot is genuinely a non-voter (`AlreadyVoter` otherwise), and the learner is caught up (`learner.require_caught_up`, refusing `NotCaughtUp`). Only then does it build the joint config **old → old ∪ {learner}** that a reconfig ballot commits with a strict majority in *both* configs. So a member is added exactly the safe way: never as an empty voter, and never without the no-fork joint switch.

## Where it sits in the family

- **FORA15 (catchup)** carries a lagging log forward.
- **FORA25 (learner)** is the role a member lives in while it catches up — present, replicating, counting toward nothing — and the gate `require_caught_up`.
- **FORA13 (reconfig)** is the no-fork joint switch.
- **FORA26 (admit)** is the join: catch-up gate, then joint switch, so the whole lifecycle is one proven arc.

## The shape

`admit(old_mask, learner_slot, learner_match, leader_commit, lag_bound)` returns a `reconfig.JointConfig` or refuses `PromoteError` (`AlreadyVoter` ‖ `learner.NotCaughtUp` ‖ `reconfig.EmptyConfig` …). It composes over public APIs only — `learner.require_caught_up` for the gate, `reconfig.config_of` / `JointConfig` / `JointBallot` / `require_joint` for the switch — adding no new transport and no new quorum math. Its one invariant of its own: promotion grows the voting set by exactly one, the caught-up learner and no other change.

## The crux, proven

- **Not caught up** → `admit` refuses `NotCaughtUp`; no joint config is ever built, so the voter set cannot change.
- **Already a voter** → refused `AlreadyVoter`; a voter is not a learner.
- **Caught up** → `admit` yields `old {0,1,2} → new {0,1,2,3}`; a joint ballot where the whole union votes commits (a strict majority in both — 3 of 3 old, 4 of 4 new), and the promoted member then counts toward the new majority (four voters, majority three).
- **The old config's majority alone cannot smuggle the switch** → a ballot of just the two old voters carries an old majority (2 of 3) yet not a new majority (2 of 4), so `require_joint` refuses `NoJointMajority`: the pre-promotion set cannot force a new member in over the new config's own head. The FORA9 intersection lemma carries across the switch unchanged.

## What it does not touch

Purely local — bounded membership masks and index scalars on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed (custody gate #2 — real hardware / any real wire — and gate #4 — real Kumara — both untouched).
