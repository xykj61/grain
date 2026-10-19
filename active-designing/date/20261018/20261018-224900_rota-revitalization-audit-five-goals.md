# Rota Revitalization Audit -- Open Questions by Five Goals

**Stamp:** `20261018.224900`
**Status:** Living
**Room:** vision

This page records the open questions the rota revitalization surfaced, organized by the five
goals of the calfive rota: aether heart, water aesthetics, fire talent, earth law, air fun.
Each question references the clean-slate tree (`grain-ww/20261015-grain`) and names what
petrichor could compose from the shared library that Kyli 7 established.

---

## Aether Heart -- which rules restate a shared-library move?

**Rota question:** Why does the work exist?

The shared library at `context/styles/lib/` now states these moves once:
- Core register moves (7 items in `shared-register.md`)
- Gauge precision moves (8 items in `precision.md`)
- Voice limits (6 items in `voice-limits.md`)
- Devotional register moves (6 items plus sacred-text rules in `devotional-register.md`)

The full guides in `context/` that restate one or more of these moves:

| Guide | Shared moves it restates | What it states alone |
|---|---|---|
| `RADIANT_STYLE.md` | all 7 core moves, the prose checklist | the register lattice, Twilight relationship |
| `GAUGE_STYLE.md` | all 8 precision moves, the 7 core moves | the three settings (Door/Field/Meter), the QA report card, "don't be too smart about it" |
| `TWILIGHT_STYLE.md` | inherits all of Radiant's shared moves | aim-then-dissolve, the fifteen themes, the nocturne register |
| `BHAKTA_STYLE.md` | all core moves, "assume no background" | first principles in order, one new idea at a time, encourage by accuracy |
| `TEACHER_STYLE.md` | inherits Bhakta's shared moves | secular door, plain American English, film and huddle |
| `TAME_CORE.md` | "bound everything" overlaps precision | the Rye reflexes, explicit widths, Rishi discipline |

**Open question:** On a future lap, could each guide point at the library for its shared
moves and keep only what is its own? The composition rule (`context/styles/lib/composition.md`)
now declares this pattern. The guides stay as the full story; the library is the single
source. A guide pointing at the library for its shared core keeps its own words for everything
else.

**Bounded metric to run:**
```
grep -c "Lead with what" context/RADIANT_STYLE.md context/GAUGE_STYLE.md context/BHAKTA_STYLE.md
grep -c "Bound every claim" context/GAUGE_STYLE.md context/TAME_CORE.md
```

---

## Water Aesthetics -- which pages lack a Status or Room line?

**Rota question:** Is the work cared for?

The page-header shape (`context/styles/lib/page-header.md`) now declares what a living
page's header carries: Status, Room, and optionally Composes-from. The clean-slate tree's
pages use this consistently; petrichor's do not yet.

**Open question:** How many living pages in `context/` lack a Status line or a Room line?
The measurement needs a scan:

```
for f in context/*.md; do
  head -12 "$f" | grep -qE '^\*\*Status:\*\*' || echo "no Status: $f"
done
```

The `docs-geode-bhakta` rule already gates `docs-geode/` pages for a style line. This
question asks whether `context/` pages earn the same discipline.

---

## Fire Talent -- which moves are stated more than once?

**Rota question:** What must stop?

The dead tissue is the duplicated move: a sentence in a guide that the shared library now
states once. The library was built in Kyli 7; the guides were written before it. The molt
work is: each guide page points at the library for its shared moves and keeps only what is
its own.

**Open question:** Which guide could molt first? The one with the highest ratio of shared
moves to its own. From the table above, `RADIANT_STYLE.md` restates all 7 core moves and
the prose checklist, and adds the register lattice. It is the clearest candidate: the
library was extracted from it, so pointing back at the library closes the circle.

**This page opens the molt; it cuts nothing.** Each guide stays whole until its own molt
lap, and the molt is a compose-from pointer, which is addition (accrete) rather than deletion.

---

## Earth Law -- should petrichor carry a Brix rota?

**Rota question:** What already stands true?

The ordering rules this tree follows are now stated once at `context/order.md`, each
pointing at the rule page that carries it. The five rules were already in force; the new
page names them in one place.

**Open question on the Brix rota:** The clean-slate tree carries `context/lib/rota-base.brix`
and `rota-of-fifteen.brix` -- the calfive rota encoded as Brix declarations. Petrichor's
rota lives in prose inside `context/SPELLBOOK.md`. Should petrichor carry a Brix rota
beside the prose, so the round-load derivation has a machine-readable source?

Arguments for: the round-load witness (`tools/fixtures/r/round_load_scan.sh`) already
derives the orbit from the commit count and a hardcoded table. A Brix file would be the
source of that table, stated once.

Arguments against: the Spellbook is the living canon, rich with context. A Brix file beside
it is a second statement of the same data, which is what single-stranded composition exists
to prevent.

**This stays open for Keaton's word.**

---

## Air Fun -- should petrichor carry a roles room?

**Rota question:** Where does each thing end?

The clean-slate tree has `context/roles/seva.md` -- the announcement role, composed from
shared pieces. Petrichor has no `context/roles/` room. The behaviors that could be roles
live in seat prompts (`tools/f/fleet_baton.txt`) and in the ITINERARY's standing block.

**Open question:** Which seat-prompt behaviors are roles that could be composed from the
shared library rather than restated? The composition rule now declares a standard for roles
(header from the shared piece, states alone what the job is, its limits, and its outcome).
The candidates are:

- **Seva** (the announcement role, already designed in the clean-slate tree)
- **Scribe** (the session-log writer -- every lap writes one)
- **The rota reader** (the council-rota deep read -- every lap does one)

A roles room opens when one of these candidates earns a page. The composition rule is ready.

**Open question on `composition/`:** The composition journal (`composition/`) now exists and
holds Kyli entries. It earns a row in `MAP.md`'s workspace tree (already done in a prior lap).
Its header shape references the clean-slate tree's pattern.
