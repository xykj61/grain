# Two grants: a molt lane for petrichor, and what a table store should be

**Language:** EN - **Style:** Gauge, Field - **Voice:** Kyri
**Stamp:** `20260907.074815` - **Status:** Booked, mixed -- **Keaton's word `20260907`**
**Card rows:** `construction/ITINERARY.md` -> *Next, the ranked remainder*

Two grants arrived in one sentence and they belong to different seats. Written down together because
they were given together; worked apart, because the roster draws lanes by territory.

## Grant one -- petrichor may molt, relink, and shed-prep, after it confirms synergy

**Petrichor is granted molt breaches, fascia relinking, and mitra shed-prep** in its own lane
(docs-geode and prose-product), with **one condition stated first, not last**: it confirms the new
synergy with the code, the modules, and the tree's own data state -- **Mantra, the weave, and
Tablecloth** -- before it moves anything.

That condition is the whole grant, so it is worth saying why it is not a formality. **Mantra and
Tally are patchouli's lane** (`construction/fleet-roster.kyri`: *the weave and the bounded core; the
base note the rest is built over*). A molt that repoints prose is petrichor's to make; a molt whose
truth depends on what the weave currently does is a claim about somebody else's territory. So:

- **Read the state before describing it.** Run the witness or read the module -- never restate a doc's
  own claim as evidence of itself (`docs-implementation-sync`).
- **A reference is a promise.** The inbound sweep before any move stays whole-tree by law, even
  though a lap's reading is otherwise scoped (`read-scope`, the one standing exception).
- **Shed-prep prepares; it never cuts.** The Amphora cut stays RED until Keaton circles it
  (`molt`, `debride`).
- **Name a find rather than crossing a lane.** Where a molt would touch Mantra, Tally, or Tablecloth
  themselves, petrichor writes the find and hands it to patchouli.

## Grant two -- what a table store should be, and who should own it

**Book the research**, then silo it, then plan it. The three steps are deliberately separate.

**Step one, external-research.** Compare table-database implementations -- **PostgreSQL** and
**SQLite** first, since they are the two the world actually runs -- with **turbopuffer** studied in
`gratitude/` under the clean-room discipline: concepts enter, code never does
(`gratitude-licenses`). The question is not *which is best* but **which scheme is most TAME-aligned**:
bounded allocation, explicit widths, named errors, invariants a reader can check, and a value model
that stays one model.

**A real alternative to name rather than assume away:** a **key-value store** may serve this tree
better than a table store, either under its own new name or as a new aspect of something already
seated. Naming follows the **Comlink tendency** -- the clearest, warmest, safest word, at whatever
length it wants -- and a new name is checked against the tree before it is spoken twice.

**Whose lane.** The *research* is **diffuser's** -- *moonshots and whitepaper research, in tandem
with bakery*. The *implementation* is not diffuser's, and the proposal must name its owner rather
than leave it open: **copal** holds *the resins -- vessels, sealing, and what a record keeps when it
is put away*, and **bakery** holds *core infrastructure*. A store is one or the other, and saying
which is part of the deliverable.

**Step two, the silo.** When the reading is done it moves to `active-designing/` **under silo
technique** -- our own module names and our own reasoning, never a borrowed one
(`active-designing/README.md`). External research studies the world with attribution; design names
only what is ours.

**Step three, the plan.** Lay the work out in **laps counted in fives and fifteens**, unified with
the existing ranked remainder rather than beside it, ordered **Lindy-first, crux-first**: the most
durable work first, and within a tier, the hardest still-solvable move. A count of laps is a count,
not a calendar ring -- the rings name capacities and are never borrowed as labels
(`stamp-and-name`).

**Falsifier for the whole grant:** if the reading shows Tablecloth already answers what a table store
would answer, the deliverable is a page saying so and the laps are never planned.

## Diffuser's silo step -- 20260909.044642

The [caller-budget design](../active-designing/20260909-044642_a-query-budget-reaches-its-caller.md) completes step two from the corrected reading.
Its [local experiment](../external-research/20260909-044642_the-query-and-the-reply-budget.md) exercises result-count and reply-byte refusals
through the existing query and encoder. An index changes search work; these reply limits remain.

Step three stays conditional on a caller's agreed workload budgets. If Tablecloth already meets
them, reuse closes the grant and a new-store build is never scheduled. Bakery owns any storage
implementation; Diffuser's design gives that trial its decision rule. The naming and seed gates
retain their existing scope.

The [completion companion](../active-designing/20260909-062114_a-request-ends-before-its-budget-is-reused.md) adds the caller's wait and resource-release
contract, supported by a local receive experiment. The next trial keeps the existing scan while
checking success, refusal, deadline exhaustion, and slot reuse. A storage build remains conditional.

The [retention experiment](../external-research/20260909-072836_a-retained-reply-needs-its-own-bytes.md) adds a concrete transfer case: copying the response record keeps borrowed text references, while copying its encoded bytes into separate storage preserves the answer through scratch reuse. Bakery can carry this case into the caller trial; its deadline and workload budgets remain to be agreed.
