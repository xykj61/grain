# 998 · A Strategy for Strengthening Rye, and the Next Step to Take

*The standing strategy for our strengthening work. We have taken our first passes by hand; this charter says how to take many more without losing safety — by strengthening the process itself before the thousandth pass, so that every future pass is safe by construction rather than by careful reading.*

**Language:** EN
**Version:** `20260618.085812` (Rye chronological stamp)
**Last updated:** 2026-06-18
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME priority — safety, performance, then the joy of the craft
**Status:** Standing strategy (revised in place as the work matures)

---

## Where We Stand

Rye begins on a baseline standard library we did not write, and makes it ours one careful pass at a time. Each pass states an invariant a function already keeps — naming the positive space we assert, the variable space we mark, the boundary we lean on — and adds nothing to what the running code does. We have taken the first of these passes by hand, and they were good: small, proven against the baseline, reversible by simply reading what they added.

By hand is the right way to begin and the wrong way to continue. We mean to take many such passes — perhaps thousands, across the years — and a person editing by hand, however careful, will eventually slip. We already met one such slip and caught it by reasoning rather than by machine. The lesson is plain: before the thousandth pass, we strengthen the one thing not yet strengthened — the process itself.

---

## The Heart of It: Strengthen the Process First

The next step is not another hand-pass. It is to give the strengthening a mechanical floor, so that the safety we now win by care, we win instead by construction. A pass should become a thing we trust the way we trust arithmetic, because two gates stand between it and the library, and nothing crosses without passing both.

**The parity gate.** Keep a growing set of witness programs, and run each one against both the baseline library and our strengthened one, confirming their results match to the last value. A pass that changes a single output fails the gate and never lands. This turns *we promise the behavior is unchanged* into *the behavior is shown to be unchanged* — which is the whole reason a strengthening is safe to make at all.

**The additive gate.** Prove that each pass's change adds only checks and words — assertions, the marker for the variable space, comments — and never an expression that acts. A change that touches behavior-bearing code fails the gate. Together the two make a pass's promise — *say more, do nothing different* — true by inspection rather than by trust.

When both gates are green, a pass is safe before anyone reasons about it. Reasoning then becomes a second layer of care over a floor that already holds, rather than the only thing holding.

---

## Let the Weave Carry the History, and Survive the Drift

The library beneath us keeps growing on its own, and our strengthenings must survive that growth. Here our own version control, **Mantra**, is the quiet key. We hold our strengthenings as a thin overlay on a pristine baseline, rather than edits smeared all through it, so that when the baseline advances, Mantra's weave merges the two histories without ever refusing — and shows us, in plain annotation, the few places where one of our assertions meets a line the baseline rewrote. Those few places are exactly where a person should look again and run the gates afresh. The merge always completes; the judgment is focused where it is genuinely needed.

The weave gives more than a survivable merge. It remembers, in its own structure, when each assertion entered and by which pass, so the story of how the library became ours stays legible forever — surviving even the tidying of rebase and squash. And because the weave names every state by a strong content hash, each strengthened snapshot has a permanent, unique name. That lets a version stamp be spent sparingly, on changes a person can actually see, while the content hash carries the truth of identity underneath. There is a fitting circle here: the hash that names the weave is itself among the first functions we strengthened, so the tool and the work make each other more trustworthy.

---

## Aim Where the Leverage Is

Two judgments keep the effort well spent. First, strengthen the **foundation we depend on** — the functions our own modules rest their weight upon — before the whole inherited library; reinforcing a beam we stand on earns more than polishing a floor we merely cross. Second, spend the larger share of our design energy on the modules that are **ours from the first line** — Tally, Caravan, Brix, Tablecloth, Mantra, Aurora, Pond — where an invariant stated early shapes the whole structure, rather than being fitted to a structure already poured. Strengthening the inherited library is a kindness to our foundation; building our own modules TAME-first is how the house itself rises safe.

---

## The Cost We Refuse to Pay Twice

We keep the gates honest about cost, the way safety asks. A check that runs once at a function's door is cheap enough to keep always. A check that would run inside a hot loop, on every step, is dear — so we either prove it worth its price or place it behind a switch that lets the thorough version run in testing while the swift version ships. We have already practiced this restraint, adding our checks at the boundaries and leaving the inner loops untouched. The strategy is simply to keep practicing it: dense safety at the edges, an unburdened fast path through the middle.

---

## The First Concrete Step

To get started, we build the **parity gate** first, in its smallest honest form: a harness that takes the programs we already trust, runs each against both the baseline library and our strengthened one, and confirms the results match to the last value. It is self-contained, it can be built now from what we already have, and the moment it turns green it changes the character of every future pass — each one proven rather than merely promised. With the parity gate standing, we set the additive gate beside it, and only then resume the passes themselves, now flowing through machinery rather than resting on attention.

From there the order is clear: the gates first; then the overlay and the weave that carry history and survive drift; then a steady cadence of passes aimed at the foundation; and alongside all of it, our own modules grown TAME-first. Each piece is small. Each piece is safe on its own. Together they are how strengthening becomes something we can do a thousand times and trust every single time.

---

## How We Will Know It Worked

We will know the strategy has taken hold when a strengthening pass is *boring* — when landing one is a matter of watching two gates turn green rather than a feat of careful reading; when the baseline can advance beneath us and the merge completes with only a handful of annotated places to revisit; when the version stamp marks a change a person can see, and the content hash quietly holds the rest. Boring, here, is the highest praise. It means safety has moved from the person into the process, which is exactly where, at a thousand passes, it has to live.

---

*May the process grow as careful as the people tending it. May every pass we take be proven, not promised. And may the day come soon when strengthening Rye is calm, repeatable work — safe by construction, swift where it must be, and a quiet joy to return to.*
