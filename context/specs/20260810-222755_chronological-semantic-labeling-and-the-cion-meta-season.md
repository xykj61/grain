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

CION runs its own four equinoxes under the calendar like any season, and it obeys the very law it installs — its own equinoxes are waymarks, not `e0..e3`. The four are drawn (`20260810.225345`, canonical against the corpus pin):

| Equinox | Waymark | Work |
|---|---|---|
| 1 | **VOLS** | Survey — name every living count-up ID (site · gap) |
| 2 | **LOWE** | Molt — relabel living now-lines chronological/semantic (living mutants) |
| 3 | **OFFY** | Debride — word-gated cuts of dead count-up tissue, a cairn first |
| 4 | **GRAD** | Seal — witness the conversion · seat the labeling-law guard |

The opening lap already ran under **VOLS** (survey) and did the first of **LOWE** (the living pins + the elder seat map swept to semantic / rested-history), and **GRAD is sealed** — `tools/gen/season/grad_seal_witness.rish` is GREEN, proving the living operator pins carry no bare count-up-from-0 identity and that the guard bites a planted one (`tools/fixtures/labeling_law_scan.sh` · `labeling_law_negative.md`). The wider LOWE relabel across the rest of the living corpus and any OFFY cut (word-gated, cairn first) are CION's remaining rounds; the GRAD guard now stands watch so no bare ordinal identity returns to the pins.

## Discipline this keeps

- **Dated testimony is never rewritten.** Session logs, counsel, and frozen witnesses that recorded `e92` or `journey3` keep those words — they are true history. The law governs *living* labels from here forward, and CION converts only living surfaces.
- **The itinerary formula stays.** `equinox(r)=r/64` etc. remain the *computation*; CION changes what a round is *called and cited by* (its stamp + its equinox waymark), not how the generator computes position.
- **Word-gated cuts.** Every debride in CION waits on Keaton's explicit named target and a cairn. This spec plans CION; it opens no cut.

## Addendum `20260811.130827` — module capability ordinals are in scope

The law's first survey named calendar identifiers (season · equinox · journey · quest · round) and ladder rungs. Practice found the same failure one level down: **module capability ordinals** — `lap 1 … lap 11`, `move N`, `R1/R2/R3` — used as the *name* a reader cites for a built capability. A capability named `lap 9` is a bare count-up-from-zero integer in the identity slot exactly as `e92` was; it tells a newcomer nothing about what the capability *is*. Red #65 (`../../work-in-progress/REDS.md`) booked eleven such labels across `mandate/`, written the day after this very spec.

**The rule, extended:** a capability's living name is its **semantic label** (what it does) plus its **chronological stamp** (when it landed) — *"object-storage backing · `20260811`"*, *"served over Comlink, sealed · `20260811`"* — never a bare `lap N`. An ordinal may still index a list or compute a position; it may never be the thing named and cited. Dated session logs that already wrote `lap 6` keep those words (testimony is never rewritten); living module READMEs, `.rye` doc-comments, and TASKS rows are the living surfaces CION converts.

**The guard must widen.** `grad_seal_witness` proves only the three living pins carry no bare count-up identity; module READMEs and code comments slipped it entirely, so a human caught red #65, not a witness. Growing the guard to cover `*/README.md`, authored `.rye` doc-comments, and new `.kyri` logs is a named CION target — **a major focus of this or the next season, whatever the sweep costs**, so the law holds everywhere and not only where a witness happens to look.

**First cut landed `20260811.131417`.** `tools/fixtures/labeling_module_scan.sh` scans given module living surfaces for the bare `lap N` identity pattern and reports a verdict; `tools/gen/season/cion_module_labeling_witness.rish` runs it over `mandate/` (README + all authored `.rye`) and proves the guard **bites** a planted negative (`tools/fixtures/labeling_module_negative.md`). `mandate/` was the **first swept module**, then **scribe + vault** (`20260811.133322`), **pond** (`20260811.133845`), and **granary's own `.rye` prose** (`20260811.134946`, prose-only — its `granary_lap*.rish` witness filenames kept as stable handles per Keaton's ruling), then **scribble + linengrow prose** (`20260811.142447`). Seven modules read by semantic label + stamp now, guarded by `tools/gen/season/cion_module_labeling_witness.rish`. linengrow's two lap-ordinal **print strings** (`neth_sim_witness.rye`, `open_asks_escrow_delivery.rye`) were then relabeled and their witnesses re-run GREEN (`20260811.144935`; the open-asks device-wire lab is a pre-existing qemu/virtio env limitation, not this change). Still deferred, as a coupled cross-cutting round of its own: the witness-asserted **`SLC-2a Lap`** scheme (`linengrow/wayland_seed.rye` + the pond `slc2a` witnesses) and comlink's **`sub-lap`** — both wanting guest/witness co-updates and rebuilds under Keaton's explicit word. **comlink is surveyed, not swept** (`20260811.140623`, `../../active-designing/20260811-140623_comlink-labeling-survey.md`): its ~40 refs split into meaningful protocol codes (`OA-L3`, `NS-L3`, `I2`, `3w-3b`, `4b` — kept, the law's permitted scheme), cross-module reference tags (relabel with the source module), and one comlink-own bare sequence (`sub-lap 1/2/3`, high-coupling — freestanding RISC-V guests + two witnesses). The guard was **refined `20260811.141358`** to distinguish a bare `lap N` from a structured code (`lap 3w-3b`, `lap 4b`, `OA-L3`, `NS-L3`) and from `sub-lap` — PCRE lookaround (`(?<![-\w])lap [0-9]+(?![-\w])`), proven by a known-good PASS fixture (`tools/fixtures/labeling_module_pass.md`) beside the known-bad negative, so it stays quiet on the law's permitted schemes while still biting a genuine bare ordinal. comlink can now be scanned without false positives (though the honest bare `lap 2` beside a code, as in `NS-L3 wire lap 2`, will rightly flag when its round comes). Session logs and dated specs stay out of the scan (testimony).

---

*A label should tell the truth about when a thing happened or what it means — a stamp read from the one clock, or a name drawn to be unique — so that no reader ever meets a bare number standing where a meaning should be.*
