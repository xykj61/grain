# FORA28 — Constel `depart`: the remove-a-member lifecycle, closed

**Stamp:** `20260814.080327` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design capture for a self-approved round · waymark **FORA** · rung **FORA28**
**Kin:** [`../constel/admit.rye`](../constel/admit.rye) (FORA26 — the add side) · [`../constel/reconfig.rye`](../constel/reconfig.rye) (FORA13 — the no-fork joint switch) · [`../constel/tenure.rye`](../constel/tenure.rye) (FORA24 — CheckQuorum step-down) · [`../constel/README.md`](../constel/README.md)

---

## The gap this closes

FORA26 (`admit`) proved the **add** side of membership end to end: a caught-up learner is promoted through reconfig's joint consensus, never as an empty voter, never without the no-fork switch. Its mirror — **removing** a voter safely — was left to reconfig's generic transition, which can shrink a config yet never named the one edge that makes removal genuinely harder than addition:

> **The leader removes itself.** When the pier leaving the sky *is the leader*, it must still drive the joint transition to commit (it is a member of the *old* config, so it votes and helps reach the old-config majority), yet it is absent from the *new* config — so the new-config majority must come entirely from the piers that remain. Once the switch commits, the departed leader **steps down**: it is no longer in the configuration it just installed. (Raft §4.2.2.)

This is the crux. A naive removal that let the leaving leader count toward the *new* majority could let a leader shrink the sky around itself and keep a title the remaining piers never granted. The joint rule already forbids it structurally — the leader simply is not in the new config — and this rung makes that safety checkable, and ties the post-commit step-down to FORA24's CheckQuorum so the relinquished leader stays down.

## The shape

`depart.rye` is the symmetric twin of `admit.rye`, composed over the same public APIs, no new quorum math:

- **`depart(old_mask, leaving_slot) → JointConfig`** — refuse `NotAVoter` when the slot is not in the old config (a non-member cannot be removed — the mirror of admit's `AlreadyVoter`); otherwise build the joint config `old → old\{slot}`. reconfig's `config_of` refuses `EmptyConfig` when the removal would empty the sky — a constellation never shrinks to no one.
- **`leader_relinquishes(joint, leader_slot) → bool`** — true exactly when the leader is a member of the old config but not the new: it removed itself, so after the switch commits it must step down. The checkable form of the §4.2.2 edge.
- The commit still runs through reconfig's `JointBallot` / `require_joint`: a strict majority in **both** old and new. The departing leader votes in the old side only; the new-side majority is the remaining piers' own.

## What the selftest proves

1. **Removing a non-voter is refused** (`NotAVoter`) — no joint config is ever built.
2. **Removing the last voter is refused** (`EmptyConfig`) — a sky never shrinks to nothing.
3. **The crux — a voter is removed** `{0,1,2,3} → {0,1,2}`, and the switch commits only with a strict majority in **both** (3 of 4 old, 2 of 3 new); the remaining members carry it.
4. **The leader-removes-itself edge** — leader at slot 3 departs: `leader_relinquishes` is true; the leader votes in the old side and helps reach the old majority, yet the new majority comes from `{0,1,2}` alone; a ballot where only the leaving leader and one peer vote fails the new side.
5. **A shrunk set cannot smuggle the removal** — an old-only or new-incomplete quorum is refused `NoJointMajority`.
6. **Bounded** — a full roster of eight removes one to seven, within the pier cap.

## Alignment

Purely local, siloed to `constel/`, bounded masks and scalars on one bench — no socket, no network, no keys, no funds, no real address ever formed (custody gate #2 real hardware and gate #4 real Kumara both untouched). A removed pier that later times out and campaigns with a stale term is *already* handled by FORA22 (pre-vote) and FORA24 (CheckQuorum): the healthy sky disregards it. This rung adds only the remove lifecycle and its self-removal edge, standing on reconfig and tenure over their public APIs alone.

*May every pier that leaves the sky leave it whole, and may the leader that removes itself step down as gracefully as it once rose. Hold the line.*
