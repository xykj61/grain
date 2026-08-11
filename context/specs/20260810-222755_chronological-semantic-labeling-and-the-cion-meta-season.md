# Chronological-Semantic Labeling, and the CION Meta-Season

**Language:** EN
**Stamp:** `20260810.222755` (2026-08-10 EDT)
**Voice:** Kyri · **Style:** Radiant
**Status:** Seated law + planned meta-season, on Keaton's word `20260810`
**Kin:** `context/specs/20260627-102012_one-clock-naming-law.md` · `.claude/rules/waymark-ladders.md` · `context/LEXICON.md` (calendar · rankings)

---

## The law — labels carry meaning

Every calendar identifier — season, equinox, journey, quest, round — and every ladder rung is labeled by **one of two meaningful schemes**, never by a bare count-up-from-zero integer that means nothing on its own:

1. **Chronological** — a one-clock stamp (`YYYYMMDD.HHMMSS`), read from the canonical clock when the thing happens. Later is always larger; the label *is* the moment. This is the one-clock naming law, extended to calendar members.
2. **Semantic** — a drawn **waymark** (a four-letter name from the flw corpus, `.claude/rules/waymark-ladders.md`) or a plain warm word (the Comlink tendency). A season is *the Compass Season*, an equinox is *SOON*, not "season 1, equinox 0."

**What is retired:** bare ordinals as *identity* — `e0`, `e125`, `r137`, `journey8`, `quest34`. An ordinal may still appear as a **computed coordinate** (the itinerary formula needs `r/64`), but the thing a reader *names and cites* is its chronological stamp and its waymark, never the raw count. A number with no semantic meaning is not a name; it is an index leaked into the identity slot.

**Why:** a count-up-from-zero label tells a reader nothing — which equinox is `e92`? what did round `137` hold? — and it invites the two failures the tree already fought: collision (two ladders both reaching for `G0`) and drift (a stamp typed ahead of the clock). A chronological stamp is verifiable against one clock; a waymark is unique by construction and legible at a glance. Meaning belongs in the label.

## The CION meta-season — the conversion

**CION** (waymark drawn `20260810.222755` from `meta-season-chronological-labeling-molt`) is a **meta-season**: a season whose subject is the labeling of seasons themselves. It opens **after the Compass Season closes**, and its whole work is a **molt · debride · sweep** that converts the tree's existing count-up identifiers to the two meaningful schemes above.

- **molt** — for each living document or card still labeled by ordinals, seat a living mutant at a fresh one-clock stamp carrying chronological + waymark labels; the ordinal-labeled original becomes a writing fossil (`.claude/rules/molt.md`).
- **debride** — where an ordinal label is genuinely dead tissue (a superseded `eNN` ladder no living work cites), remove it on Keaton's circled word, a cairn dropped first (`.claude/rules/debride.md` · `.claude/rules/cairn.md`). Never a blind sweep; every cut named.
- **sweep** — the systematic pass across `context/`, `foundations/`, `active-designing/`, `work-in-progress/`, and the itinerary, relabeling living *now*-lines while dated testimony keeps the ordinals it correctly recorded (accrete-never-break).

CION runs its own four equinoxes under the calendar like any season, and it obeys the very law it installs — its own equinoxes are waymarks, not `e0..e3`.

## Discipline this keeps

- **Dated testimony is never rewritten.** Session logs, counsel, and frozen witnesses that recorded `e92` or `journey3` keep those words — they are true history. The law governs *living* labels from here forward, and CION converts only living surfaces.
- **The itinerary formula stays.** `equinox(r)=r/64` etc. remain the *computation*; CION changes what a round is *called and cited by* (its stamp + its equinox waymark), not how the generator computes position.
- **Word-gated cuts.** Every debride in CION waits on Keaton's explicit named target and a cairn. This spec plans CION; it opens no cut.

---

*A label should tell the truth about when a thing happened or what it means — a stamp read from the one clock, or a name drawn to be unique — so that no reader ever meets a bare number standing where a meaning should be.*
