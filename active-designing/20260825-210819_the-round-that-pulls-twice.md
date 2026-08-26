# The round that pulls twice

**Stamp:** `20260825.210819`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design, SEATED as the loop's sync rota on Keaton's word `20260825`; walk-back checkpoint `28b1695752`
**Kin:** [`20260825-205011_the-pen-the-gossip-and-the-derived-spine.md`](20260825-205011_the-pen-the-gossip-and-the-derived-spine.md) -- [`../external-research/20260825-210819_four-protocols-distilled-to-a-git-rota.md`](../external-research/20260825-210819_four-protocols-distilled-to-a-git-rota.md) -- [`../recursion-prompts/seed/autonomous-loop.seed.md`](../recursion-prompts/seed/autonomous-loop.seed.md)

## What Keaton asked, and the one correction the review made

The word: every round pulls at its start, packages its send behind green QA and witnesses, pulls
again, re-integrates when the tree moved, and sends the moment it stands still -- push as the last
step of every round, before the baton. The adversarial pass kept the whole shape and moved one
piece: **the opening pull comes before the context read, always.** A card read before the
pull is a stale card held all round while the tree underneath it has already moved.

## The rota, in fifteen sentences

1. The round opens by pulling the **anointed ordering remote** -- `git pull --rebase xykj61 main`
   -- and only then reads its context, so the card read is the tree stood on.
2. The round works and packages locally: commits made, QA and witnesses green, the nib in the
   work commit, and the push waits until the package is whole.
3. Before sending, the round fetches the ordering remote once more. This fetch is an economy
   rather than the safety: it cheapens the common case.
4. **The push itself is the allocation.** A plain push to the one ordering remote, force
   forbidden by the pacemaker invariant;
   the server compares the old ref under its own lock, so the fast-forward refusal is the
   compare-and-set, and the fetch-to-push race is closed by the server rather than by any window.
5. The mirror (`origin`) is pushed only after the ordering remote accepts. A mirror that declines is a
   sync fault to repair. A tool that pushes the mirror first has forked the spine.
6. When the ordering remote moved -- seen at the fetch, or learned from a refused push -- the
   round rebases its package onto the new head and re-verifies by sentences 7 and 8.
7. The minimal honest re-verify: with R the round's touched files and U the upstream's, re-run
   every witness whose watched files intersect R. Upstream greens confined to U still speak,
   licensed by the green-before-send discipline that landed them.
8. Escalate to the full roster when R intersects U, when a rebase conflict lands outside a
   registered fold surface, or when a touched module's witness map is unknown. A verify is
   a measurement, every time.
9. A conflict on a **registered fold surface** (the session-logs index; any table proven a
   byte-identical fold over uniquely-stamped files) resolves by regeneration. Every other
   conflict stays a hand's, since a scripted union on prose is a wrecking engine with a green
   exit code.
10. A ledger row in flight is cited by stamp until it reaches the shared spine; re-integration
    renumbers by the stamp-then-commit-hash rule of the derived-spine design.
11. The re-integrate loop is bounded at **three** attempts, each behind a jittered sleep (uniform
    5-60 s, doubling). Three refusals over minutes is genuine contention, and contention is the
    pen's question rather than the retry loop's.
12. Livelock stays impossible by structure: every refusal proves the other pier landed a round, so the
    system as a whole always progresses. The bound guards one slow pier against starvation.
13. The third refusal resolves by **deferral, never force**: force would break the pacemaker
    invariant. The package parks on the pier's own namespaced branch
    (`refs/heads/pier/<name>/...`), which contends with nobody.
14. Priority to main then follows the one clock: the earlier round-open stamp holds it, the later
    defers, ties break by commit hash -- the same rule the derived spine already seats.
15. The card stays pen-guarded and the resuming pier passes the baton test: one fetch, one read
    -- nib, GREEN line, card -- before it works.

## The three residuals, kept sharp

**File-intersection is a wager.** R-disjoint-from-U proves textual independence, and semantic independence is its own question:
upstream can move a fixture the round's untouched files call at runtime. The falsifier is the
first cross-module breakage two minimal passes both missed; the repair is the witness-manifest
work already ranked in the reprove design.

**The CAS lives on one remote.** Mirror-first pushes, or a partition inside the two-push window,
yield two locally-fast-forward spines a merge nobody ran. The order is procedural until a guard
refuses mirror-first mechanically; procedure under unattended automation sits one bug from a fork.

**The fold registry invites widening.** Every conflict-prone file tempts registration, and a
resolver on a surface that is secretly authored destroys content while exiting green. Byte-identical
regeneration gates every registration, on metal. And the jitter is only real if round starts are
uncorrelated -- staggered crons by construction rather than by hope.

## The horizon sentence

When the constellation's facts travel by wire instead of by git -- the Comlink-served gate, the
three-MOX wiring, a millisecond cadence -- this same rota is the protocol, with the ordering
remote's ref lock replaced by the order the Cord derives. Nothing about the shape changes; only
the carriage does.
