# REDS shelf -- a placard window and a stale figure caught twice

**Language:** EN
**Status:** Archive -- two closed, stamp-cited REDS rows shed from `construction/REDS.md` under the
writer-sheds rule, to clear headroom for a fresh row while the pin's sixteen numbered rows sat all
**OPEN** and unfoldable (`reds_pin_capacity_scan.sh` read `pin_deadlocked=1`, `pin_foldable_rows=0`).
Neither row carries a shared `%N` -- both stayed local, cited by stamp per
[`derived-spine`](../../../.claude/rules/derived-spine.md) rule 4 -- so the automated
`tools/fixtures/r/reds_fold.sh` (which matches only `**REDS %<N> `) could not move them; this shelf
was written by hand, following the same shape the tool writes.

Both rows are self-contained repairs -- a positional field reader's window, and a stale-figure
citation caught for the second time in one sweep -- and neither carries an inbound link to
re-anchor.

---

*Row `20260917.221030` folded here on `20260929.054252`, **CLOSED** -- a second scan's field broke a first scan's fixed placard order, on one shared desk.*

**REDS (`20260917.221030`) -- a second scan's field broke a first scan's fixed placard order, on one shared desk.** *What went wrong:* `ba8747d2d` gave eight shared desks a new `::  law` placard line for `glow_gate_law_agree_scan.sh`, including `src/shape/shape-tablecloth-catalog-capacity.glow`. `tablecloth_glow_tend_scan.sh`'s `placard_of()` reads a fixed first six placard keywords by position; `law` pushed `nib` out of the window, so it read `placard_wrong` with no plant at all. *What caught it:* running the control cold, ahead of an unrelated plant-adoption lap -- `wrong=40` on the unmutated baseline. *What it taught:* a positional first-N reader cannot tell a new field from a lost one; checked for a wider hit (grepped every scan sharing the `expect_order` literal against all 25 `law`-bearing desks) and found none. *Repaired:* `placard_of()` skips an optional `law` line first. Proven: 44 legs, `wrong=0`, witness GREEN. **CLOSED.**

*Row `20260924.215242` folded here on `20260929.054252`, **CLOSED** -- closes %735's remaining half: the same stale counsel figures stood in two law and lexicon pages after the front door itself was repaired.*

**REDS (`20260924.215242`) -- closes %735's remaining half: the same stale counsel figures stood in two law and lexicon pages after the front door itself was repaired.** *What went wrong:* `%735` (`20260915.194421`) repaired `counsel/README.md`'s stale piece and reference counts, and named the identical pair still standing in `.claude/rules/design-rooms.md` and `context/LEXICON.md` as belonging to incense's own lane, since counsel's own front door is not this seat's file to touch. Both pages still read *764 pieces* and *1,977 references* nine days later. *What caught it:* reading this lap's own open-word backlog in `recursion-prompts/incense-inner.md`'s `next` section, which pointed at the prior seat's own dispositioned reds. *What it taught:* a repaired front door does not repair its own citers -- two law pages had copied the room's count inline rather than pointing at the room's own listing, so the same free figure went stale in three places at once and only one of them was fixed. *Repaired:* both pages now point at `counsel/README.md`'s own measured readings rather than spelling a count, following the same pattern the front door's own repair used -- a free figure lives beside its own re-derive command, once, in the room it describes. Measured fresh rather than copied from the elder row: `git ls-files 'counsel/' | grep -cE '(^|/)[0-9]{8}-[0-9]{6}[_.]'` reads **935**, `git grep -ohE 'counsel/[A-Za-z0-9_./-]+' -- . ':!counsel' | wc -l` reads **2,642**. Both pages graded B+ or better at Door setting (`design-rooms.md` A/91, `LEXICON.md` B+/85), truth 100, 0 broken citations. **CLOSED.**
