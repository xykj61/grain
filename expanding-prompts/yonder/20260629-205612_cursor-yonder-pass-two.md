# Cursor Pass — Yonder, Second Pass: Two Moved, Two Kept

*The convention is written; this is it widening — and widening carefully. Four more of the oldest files come up for the horizon, and the reading matters: two are consumed and forward-pointing and belong in `yonder/`, two are foundational or living-and-cited and stay exactly where they are. The pass also sharpens the test itself, so age never outvotes relevance.*

**Stamp:** `20260629.205612`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Tip:** pull `eccc25d` first.

*Written together by Kaeden and Reya 2.*

---

## Edit 1 — Sharpen the `yonder/` Test in ORGANIZING.md

Add a line to the `yonder/` section, learned from this pass:

> **Age is a hint, not the test.** What sends a file to `yonder/` is that it has become future, dormant, consumed, or realized-as-code — never its stamp alone. A document that is foundational to the design, or that is actively cited by other living files, stays where it is however old it reads. Relevance and inbound references outrank the date.

---

## Kept — Assessed and Left in Place (record why)

These two came up by age and stay by relevance. Note the decision in the session log; do not move them.

- **`active-designing/yonder/20260618-182412_single-stranded.md`** — a standing architectural brief (status: Active Design) naming the one-value-model, *no-seam-is-no-braid* principle, cited by seven-plus living documents. Foundational and current. (A possible future promotion to `foundations/`; not a `yonder/` move.)
- **`work-in-progress/20260620-212126_usize-width-baseline.md`** (`992`) — a *living inventory* updated today, stating the width law still in force, cited by `TAME_GUIDANCE`, `TASKS`, the README, the crosswalk, and several strengthening docs. A finished migration makes its inventory all-green, not stale. (If it ever moves, it is an `archive/` candidate — backward-pointing — only after its law is confirmed fully held in `TAME_GUIDANCE` and its references repointed. Not this pass.)

---

## Lift the Live Threads First (before moving anything)

- **The content-centric messenger** — from the messaging prompt: capture, as a horizon note (in `TASKS.md` or a `foundations/` line, wherever it best lives), the Rishi command-line messenger and the RISC-V-bytecode "shape-casting" idea, so the live horizon survives the prompt's retirement.
- **Ownerboot sovereignty** — from the ownerboot research: capture the owner-key-sealed boot-chain vision (the inversion that roots trust in the owner's key, tied to the project's larger why) as a horizon note if it is not already held elsewhere.

Record in the session log where each thread now lives.

---

## Move — Two Files to `yonder/`, With Care for References

`git mv` each, creating `yonder/` as needed:

| File | To | Why |
|------|----|-----|
| `expanding-prompts/20260618-212012_content-centric-messaging.md` | `expanding-prompts/yonder/` | consumed prompt; networking realized in Aurora's `named`/`posted`/`sealed`, messenger + shape-casting are horizon |
| `external-research/20260617-195612_ownerboot-riscv-caravan.md` | `external-research/yonder/` | realized-origin (Caravan is a live module); ownerboot sovereignty is horizon |

**The reference work is the real work here — both are cited widely, including by active source.**

- Before each move, grep the whole tree for the filename (and for short forms if any). Update every inbound reference to the new `yonder/` path.
- `content-centric-messaging` is cited by **Aurora source files** — `aurora/src/named.rye`, `posted.rye`, `sealed.rye`, and `aurora/README.md` — as their design origin, plus `strengthening-compiler/9995`, the unified-keys research, and the external-research README. These are doc-comment provenance links: repoint the paths, do not remove them. Source comments count as references.
- `ownerboot-riscv-caravan` is cited by `external-research/README.md`, the gratitude README, and sibling research including its **companion** `20260617-195712_caravan-tally-networking.md` (which stays one level deep — repoint its link rather than break the pair) and `20260617-195812_aurora-boot-riscv.md`.

A move is not done while a dangling path remains.

---

## Verify

- `git log --follow` shows preserved history for both moved files.
- Grep the tree: no reference to either moved file points at the old one-level path.
- `rye build` and `tools/parity.rish` stay green on metal — the moves touch writings and doc-comments, not behavior, yet confirm nothing referenced a moved path in a way that matters to the build.

---

## Record and Push

Commit as one honest unit — the ORGANIZING.md refinement, the two lifted threads, the two moves with every reference repointed, and the session log. Log at `session-logs/<stamp>_yonder-pass-two.md`: the sharpened test, the two kept (with reasons), the two threads lifted and where they now live, and the two moved with their reference fixes. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

---

## Before You Move On — Recommend the Next Step

End with an explicit recommendation, and say why:

- **Recommend keep going** when the next item is mechanical and follows written policy — further `yonder/` candidates that are plainly consumed or realized, with their references light.
- **Recommend checking in with Claude** when a candidate is foundational or heavily cited (assess, don't assume), when it crosses a seam, changes Rishi or the value model, opens a new domain (Skate), needs an unmade ruling, or reaches for horizon facts.

One line — *"Recommend: keep going to …"* or *"Recommend: check in with Claude before …"* — so the next move is always Kaeden's to confirm.

---

## Definition of Done

- [ ] ORGANIZING.md's `yonder/` test now says relevance and citation outrank age
- [ ] `single-stranded` and `usize-width-baseline` are left in place, the decision recorded
- [ ] The messenger and ownerboot-sovereignty horizon threads are captured before the moves
- [ ] `content-centric-messaging` and `ownerboot-riscv-caravan` are `git mv`'d into `yonder/`, with every reference — including Aurora source doc-comments and the ownerboot companion — repointed, no dangling path
- [ ] History preserved; `rye build` and parity green on metal
- [ ] Session log shipped; four remotes pushed; next step recommended

---

*May the horizon hold what points ahead, and the present keep what still holds it up. May we read each file for what it is rather than how old it reads, and move only what is truly ready to rest. And may the references stay whole through every move, so nothing true is ever lost in the tidying.*
