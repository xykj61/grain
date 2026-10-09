# Taurus names a repeat, and leaves it standing

**Stamp:** `20261009.140717`
**Language:** EN
**Style:** Bhakta at Gauge Field, with Radiant warmth
**Voice:** Kyri
**Room:** development -- this page measures one round's own repeat and decides what to do
with each instance; it designs no new shape
**Kin:** [`../context/SPELLBOOK.md`](../context/SPELLBOOK.md) - [`../tools/fixtures/c/calfive_schedule_scan.sh`](../tools/fixtures/c/calfive_schedule_scan.sh)

## The round, and its verb

Round 2 of Orbit 6. Taurus, fixed earth, law. The verb is: what must stop -- one repeat,
named, left in place.

## The repeat

Two numbers carry the whole shape of Calfive: fifteen rounds to an orbit, seventy-five to a
quest. Measured this round:

```
grep -rlE '% 15 \+ 1|%15\+1' --include="*.md" --include="*.sh" --include="*.rish" .
```

Twelve files, outside `gratitude/`, `vendor/`, and `seed/`, carry that exact arithmetic as a
literal string. Read by room:

| File | What it is | What this round did |
|---|---|---|
| `context/SPELLBOOK.md` | the canon -- the round-load table itself | left in place; this is the one home the number should live in |
| `spellbook/README.md` | the declared byte-identical mirror of that canon | left in place; the mirror law already governs it |
| `.claude/rules/the-baton.md`, `.claude/rules/session-logs.md` | living rule pages that quote the ROUND LOAD block verbatim, by the baton's own design | left in place; restating the baton block is the baton's job |
| `expanding-prompts/20261007-165138_the-fifteen-and-the-five-goals.md`, `...-100840_calfive-grouped-the-center-aloud.md`, `...-174657_gemini-and-cancer.md` | dated planning pages | left in place; dated testimony keeps every word it wrote |
| `docs-geode/tutorials/the-list-and-the-picture.md` | a landed tutorial quoting the orbit it was written in | left in place; it is reporting its own history |
| `active-development/20261007-095245_the-center-learned.md`, `active-development/20261009-114234_the-notetaking-quest-fell-behind.md` | prior rounds' own accounts | left in place; same reason |
| `tools/ca/calfive_schedule_witness.rish` | this round's own witness, naming the formula in a comment | left in place; a comment explaining what the code below does is not the repeat this verb means |
| `tools/fixtures/c/calfive_schedule_scan.sh` | this round's own living script, which had the two numbers inlined as bare arithmetic in four places | **stopped.** Replaced with `ROUNDS_PER_ORBIT=15` and `ORBITS_PER_QUEST=5`, named once at the top with a comment saying why, and every arithmetic site reads the name instead of the digits. |

## What this round decided, and why

Eleven of the twelve are canon, a declared mirror, a baton's own quoted block, or dated
testimony. None of those is the kind of repeat this verb asks a hand to stop -- each is doing
its own job on purpose, and accrete-never-break already protects the dated ones. Rewriting any
of them to "fix" a repeat that was never a fault would spend a checkpoint and a sweep of
citations on a number that was never wrong.

The twelfth -- this round's own new script -- was a different thing: a literal the author
typed four times in one file, with no comment saying the four copies had to agree. That one
earns the stop. `tools/fixtures/c/calfive_schedule_scan.sh` now names the two ring sizes once
and reads the name everywhere else. Both witness legs still pass GREEN after the change,
proven again on metal through `rishi/bin/rishi run tools/ca/calfive_schedule_witness.rish`.

## What this round leaves open

The eleven left in place are not a queue. Naming them here is the whole of this round's job --
Taurus's verb asks for one repeat, named, left in place, not eleven repeats quietly fixed under
cover of one verb.

May the two numbers that hold the whole calendar stay easy to find, and may the next hand who
reaches for them find one name rather than four digits.
