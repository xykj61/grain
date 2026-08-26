# The Rota Meets the Debride -- the fourth residual

**Language:** EN
**Stamp:** `20260826.010645`
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Living -- proven where it says proven, proposed where it says proposed
**Kin:** [`20260825-210819_the-round-that-pulls-twice.md`](20260825-210819_the-round-that-pulls-twice.md) (the rota this extends) - [`../.claude/rules/debride.md`](../.claude/rules/debride.md) - [`../construction/REDS.md`](../construction/REDS.md) row %243

---

## The question

The sync rota opens every round the same way: pull the anointed ordering remote, then read the
card, so the card you read is the tree you stand on. Fifteen sentences describe that rota and every
one of them holds. They also share one assumption, stated nowhere: **that the two piers descend from
a common ancestor.**

One act in this tree is licensed to set that assumption aside, and it is licensed deliberately. A
deep debride rewrites every commit and force-pushes, and the debride rule already names the bill it
comes with -- *every downstream clone must re-clone or hard-reset*. So the question is narrow and
practical: **what should a pier's round-open do when the ordering remote it is about to rebase onto
has become a different history?**

## The assumptions this rests on

- The debride itself stays a custody gate, taken by hand on an explicit word. Everything here
  assumes a human already said it.
- One ordering remote holds the spine, and the fast-forward refusal is the compare-and-set. A
  debride is the named exception where that remote is force-pushed, and it remains an exception.
- A pier may carry unpushed local commits when the rewrite lands. This is the ordinary case, since
  a pier works between sends.

## What happened, observed

On `20260825` the banked deep debride was spent from the macOS bench: a collaborator's name left
the tree, the session logs, two filenames, and the whole git history, every rewritten commit
re-signed, and the result force-pushed to the ordering remote. The record is that bench's own
session log and the checkpoint row beside it.

This pier opened its next round on `20260826` holding two commits of its own. The fetch reported a
forced update. Measured at that moment: upstream 3,469 commits, local 3,467, **merge base empty**.
The two trees agreed on content almost entirely -- 243 files differed, 457 lines inserted and 457
deleted, a pure substitution -- and agreed on every commit hash in exactly zero places.

## What a plain rebase does with that, measured

This is the part worth having numbers for, because the answer is two behaviors rather than one, and
which one you get turns on something outside the tree.

`git pull --rebase` computes its starting point with `--fork-point`, which consults the
**remote-tracking reflog** -- the local record of where `origin/main` used to point. Against a
rewritten upstream that reflog is the surviving evidence of the shared past.

Measured on metal in a throwaway pen, same repositories, same rewrite, same command:

| Reflog | Fork point | Commits replayed | Debrided name back in the tree |
|---|---|---|---:|
| present | found | **7** -- exactly what the pier owns | 0 files |
| expired | none | **15** -- the entire local history | **1 file** |

The second row is the fault. Once the fork point has expired, the rebase replays every local commit
onto a history that held them under different hashes, and each conflict invites a hand to resolve in
favour of the side carrying the name the debride removed. Scaled to this tree on the day it
happened, that is **3,467 replays**.

A reflog is a thin thing to rest on. Git expires it at ninety days by default, and a fresh clone
starts with an empty one -- so the quiet path is precisely the one a pier can count on least.

**What actually carried this round was unrelated.** The index was dirty from a lap that ended at
`git add`, so `git pull --rebase` declined to start (REDS %223's third rung, working as designed for
a different reason). The right outcome arrived by luck.

## The alternatives, each at its best

**Re-clone every time, as the debride rule already says.** Simple, certain, and it discards
unpushed work -- which is the one thing a pier most wants to keep. Honest for a pier with nothing
in flight; expensive for one mid-round.

**Trust `--fork-point`.** It is right when it works, and it works often. It rests on a reflog that
expires on a calendar rather than on a fact about the tree, and it slips quietly into the expensive
case rather than saying so.

**Read the shape first, then choose.** Costs one command at the round's open. It tells the pier
which of the two worlds it is in before anything acts on the other one, and it names the repair in
the same breath.

The third is what this proposes, and the reason is the failure mode rather than the success rate:
the first two are both fine when they are fine, and only the third one speaks up when they are not.

## What is seated, and proven

`tools/fixtures/upstream_shape_scan.sh` reads HEAD against the ordering remote and names the shape:
`up_to_date`, `fast_forward`, `ahead`, `diverged`, `no_remote_ref`, or `rewritten`. The last one
refuses; the rest report and pass. It prints the merge base, the fork point or its absence, and the
count a plain rebase would replay -- so the reading carries the number a decision needs rather than
a category alone.

`tools/u/upstream_shape_witness.rish` proves it six ways, and two of those are the table above built
for real: two repositories, a real `filter-branch` rewrite, the reflog aged out the way ninety days
ages it. The refusal is proven from both sides, since a refusal proven only in the passing direction
reads exactly like a bypass -- an ordinary divergence must pass as hard as a rewrite must refuse.

**One false positive turned up while proving that, and it is worth the paragraph.** A shallow clone
also has an empty merge base, so it would read as a rewrite. The first attempt to reproduce that
came back clean: a `--depth 1` clone with a local commit still finds its base, because the shallow
boundary sits inside its own history. The state that actually empties the base is a shallow clone
whose upstream has advanced **past** its depth and which then re-fetches at the same depth. So the
guard asks `git rev-parse --is-shallow-repository` rather than inferring from the empty base, and the
pen builds the outrun state rather than the easy one. A pier that has yet to fetch reports a machine
fact too. Both pass, because a guard that refuses ordinary work is a guard somebody turns off.

## The trade-off accepted, and its cost

The guard refuses on `rewritten` **every lap until the pier rebases**, rather than warning once.
That is deliberate: a pier standing on a disjoint history has exactly one safe move, and a warning
a round may walk past is a warning an unattended loop will walk past.

The cost is real. A pier that would rather work while diverged is stopped, and the way out is to
rebase, which is the thing it was going to have to do. A flag to turn this off stays absent, for the
reason the exec-bit wall gives: a wall with a door beside it has become a habit again.

## Proposed, and waiting on a word

**The rota's opening sentence grows a clause.** Sentence 1 becomes: read the shape, then pull. The
fourth residual joins the three already kept sharp in the elder essay -- *the rota assumes a shared
history, and one sanctioned act sets that assumption aside.*

**A debride announces itself in the tree, rather than only in a log.** The cheapest form is a line
in `construction/CHECKPOINTS.md` that a pier's round-open reads, naming the rewrite's stamp and the
last pre-rewrite commit subject. That turns *find the shared commit by subject* from a hand's search
into a lookup. It touches how both piers record a custody act, so it waits.

## The falsifier

Should a pier meet a rewritten upstream, run the shape scan, and find the printed `--onto` line
produces a wrong tree -- a dropped local commit, or debrided content carried back -- then the
reading is too thin, and the repair belongs one layer down, in a recorded rewrite map rather than in
a fork point.

---

*May each pier know which tree it stands on before it moves, and may the name a debride takes away stay away.*
