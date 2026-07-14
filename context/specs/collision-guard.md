# Collision Guard — Every Hit, Classified

*A name is free only when every hit is printed, classified, and recorded. The mudra catch of `20260712.061012` is the lesson this guard keeps.*

**Stamp:** living ledger (born `20260712.065146` bench-clock) · refreshed `20260712.065146` (post–Season-B hygiene)
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living practice + tool
**Voice:** Rio 3
**Ground:** mudra soft-collision owned in `79a79ba` · seating [`20260712-061012_bud-and-mudra-names-seated.md`](20260712-061012_bud-and-mudra-names-seated.md) · RTAC [`../../work-in-progress/ready-to-ask-claude.md`](../../work-in-progress/ready-to-ask-claude.md)

---

## Lesson — the mudra catch

Claude’s `061012` collision guard truncated its output and classified mudra’s two hits as benediction prose without printing both. One hit was the Pottery-alternate park sitting in RTAC. The bench’s untruncated re-run caught it; commit `79a79ba` literally says *own mudra collision*. The two-gate relay worked: counselor miss → bench catch → red owned before seat.

**Law from that red:** no head/tail truncation ever. Print **every** hit with **two lines of context**. Classify each hit before declaring a name free.

## Practice

1. Search owned surfaces with `rg -n -C 2` (or `tools/collision_guard.rish NAME`) — never pipe through `head` / `tail` / a capped pager that drops hits.
2. **Always** sweep these three surfaces explicitly, even when the tree-wide search looks clean:
   - `work-in-progress/ready-to-ask-claude.md` (parks and alternates)
   - `context/specs/reserved-vocabulary.md`
   - `context/LEXICON.md`
3. Outside the named sweep, search the owned tree while excluding `gratitude/`, `external-research/`, `yonder/`, `vendor/`, and `archive/` unless the naming lap says otherwise.
4. Classify **each** hit as exactly one of:
   - **teacher-quote** — inherited name kept in gratitude / ER voice
   - **prose-verb** — ordinary language, not a seating claim
   - **park** — alternate, reserved, or RTAC park that must be released or renamed before seat
5. A name is **free** only when every hit is classified and the classified list is recorded in the seating spec (or the proposed provenance note that will become the seating spec).
6. Soft reds (parks) are owned in the record before any seat word; hard reds (live module collisions) stop the lap.

## Tool

```
rishi/bin/rishi run tools/collision_guard.rish NAME
```

Prints every match with two lines of context, then reprints the three required surfaces. Classification remains a human step recorded in the seating spec — the tool proves the print is whole.

## Mudra classification (the catch, recorded)

| Hit surface | Class | Note |
|-------------|-------|------|
| RTAC Pottery value-object alternates (`200712`) | **park** | Released on seat `062656`; Mudra assigned to fixed-tier proof |
| Seating / LEXICON prose after propose | **prose-verb** / seating claim | Expected once proposed |

---

*May every red keep finding a second gate. May every hit keep its two lines of context. May a free name mean a classified list, not a quiet search.*
