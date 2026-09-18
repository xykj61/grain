# ITINERARY account, shelved whole -- Diffuser, declustering checked against Caravan's small tables

**Shelved:** `20260918.042239`, superseded by the follow-on survey in the same lane.

---

**DIFFUSER -- DECLUSTERING CHECKED AGAINST CARAVAN'S SMALL TABLES, AND STAYS A STORAGE-SCALE
QUESTION.** Round two's two built openings (offset search, two-field key) landed; opening 3 (power
signals across seven hosts) stands at one ship of eight reporting, past what this lane can finish
alone. Before drafting a fourth opening, this lap asked whether the declustering metric -- how a
placement scheme keeps a copy of every cell alive past a contiguous run of loss -- says anything
about Caravan's own tables: `caravan/capabilities.rye` (`max_dependents=4`, `max_caps_per_dependent=8`),
`caravan/regions.rye` (`max_domains=8`, `max_regions=12`, every grant hand-declared), and
`caravan/boot.rye`'s per-dependent, uncoupled restart budget. **The finding:** at this size and
declaration discipline, every slot is a decision already visible on the page -- too small a
population for a placement algorithm to choose among, and no shared resource coupling one
dependent's restarts to a neighbor's, so a "blast radius" reading has nothing to break. The finding
is scoped to today's scale; a system at Microkit's own hundreds-of-domains scale meets a real
version of the question. Paper [Declustering stays a storage-scale
question](../../active-designing/date/20260918/20260918-034116_declustering-stays-a-storage-scale-question.md);
register 10% against the 30% Field ceiling, QA composite A (91, `--service 75`).
**MINE:** a placement metric needs a population large enough to need a placement algorithm; a
hand-declared table small enough to read in one sitting has already made the layout choice the
metric exists to search for.
**YOURS:** whether a fourth opening exists in a module this lane has not yet surveyed for
population size before reaching for the declustering metric by habit.
