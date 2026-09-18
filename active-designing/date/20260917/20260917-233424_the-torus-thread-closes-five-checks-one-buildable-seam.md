# The torus-thread checks close -- five reads, one buildable seam, three negatives

**Stamp:** `20260917.233424`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- synthesis of five prior readings; one buildable item is named and handed on, nothing new is claimed as checkable here
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
(rows 2, 5, 7 -- the three moonshots this synthesis speaks to) -
[`20260917-222220_a-torus-index-for-tally-gardens-linear-underneath.md`](20260917-222220_a-torus-index-for-tally-gardens-linear-underneath.md) -
[`20260917-224502_two-independent-rings-in-caravan-a-torus-nobody-composed.md`](20260917-224502_two-independent-rings-in-caravan-a-torus-nobody-composed.md) -
[`20260917-230710_mantras-weave-and-store-hold-no-torus-seam.md`](20260917-230710_mantras-weave-and-store-hold-no-torus-seam.md) -
[`20260917-232140_the-supervised-process-trio-carries-no-torus-seam.md`](20260917-232140_the-supervised-process-trio-carries-no-torus-seam.md) -
[`../session-logs/date/20260917/20260917-224056_aurora-deciding-and-sealed-hold-no-torus-seam.kyri`](../session-logs/date/20260917/20260917-224056_aurora-deciding-and-sealed-hold-no-torus-seam.kyri)

## The one sentence this piece is for

Five separate reads, across four modules, asked the same narrow question -- **does a composable
periodic seam already sit in this code, waiting for a torus to be laid over it** -- and the answer
came back the same way five times: the only seam sitting uncomposed anywhere stays in the two places
the first reading already knew about, `caravan/queue.rye`'s buffer slot and `caravan/cycle.rye`'s
domain lap. This piece states that finding once, in one place, so a sixth reader can read it here
rather than re-deriving it from five separate files.

## What was read, and what it found

| Module read | Files | Verdict | Genuine ring found |
|---|---|---|---|
| Aurora | boot/handshake path | checked negative | none |
| Mantra | `weave.rye`, `store.rye` | checked negative | none |
| Caravan | `unhand.rye`, `confer.rye`, `revoke.rye` (4,000 lines) | checked negative | none (both import `cycle.rye`'s bounded depth check, never a modulo) |
| Caravan | `queue.rye`, `cycle.rye` (whole-module reads) | structural, mixed | **two**, uncomposed -- `queue.rye:224`'s `seq % max_outstanding`, `cycle.rye`'s domain-lap traversal |
| Tally | `gardens.rye` (three named gardens) | structural, mixed, one buildable item named | a two-axis relabeling is provable today, over an already-linear store |

Every read was a whole-file grep for `%`, `wrap`, `ring`, `cycle`, and every `max_` constant, not a
sample -- each source piece names its own command line, and each is reproducible in one line. **The
reading is bound to the files actually opened**, which the table's own second column states rather
than implies.

## The pattern the five reads describe

**Observation.** Genuine periodicity in this tree lives inside small, purpose-built rings --
`queue.rye`'s buffer slot, `cycle.rye`'s domain lap, `gardens.rye`'s three named gardens -- while the
five surrounding modules stay without it. Every module checked either bounds a count with an assert
(the TAME reflex) or borrows depth-checking from `cycle.rye`, and both shapes stop short of a
wraparound.

**Inference.** A torus proposal aimed at one of these five modules is new architecture rather than a
discovery of hidden structure, exactly as rows 2, 5, and 7 of the master moonshots page always said
they were. What the five reads change is the *cost estimate* for building it: a torus over
Caravan's process graph (row 2), Tablecloth's store (row 5), or an Aurora core mesh (row 7) starts
from zero, since composing an existing seam -- the cheaper path -- turned up absent in every module
this thread opened.

**The one place this differs.** Tally's three gardens (`blob`, `diff`, `frame`) mapped onto two
tiers (`per-dependent`, `shared`) already form the two independent axes a torus index needs -- the
sibling piece names `tally/torus_index.rye` as a one-round build, a pure bijection over an
already-linear store, provable today on hardware already in hand. This is the ONE buildable item
this whole thread has produced, and it is sized, cited, and ready for Bakery to pick up.

**What that buildable item leaves untouched.** `torus_index.rye` is a relabeling; a physical torus
is a separate claim. It answers "can two axes be composed over this store" and leaves cache
locality, NUMA distance, and power draw exactly as they stood, because the store underneath stays
linear. Rows 5 and 7's actual claims -- that a real two-dimensional fold changes lookup adjacency,
or that a real core mesh changes routing hops -- stay exactly as speculative as the master page
already rated them.

## Falsifier for this synthesis

**A future round composing `cycle.rye`'s domain ring with `queue.rye`-style buffered channels
between neighbors** would give Caravan a real second axis and promote the "two rings, uncomposed"
note from vision to a sized design -- reopening row 2 at a materially lower cost than this synthesis
assumes. Similarly, a module this thread has yet to open (Comlink, the real Tablecloth store,
Amphora, Brix) carrying a genuine second ring would mean the pattern above describes five files
rather than the tree. **This synthesis is falsified by either.**

## What remains unchecked, said plainly

`caravan/` alone carries 114 tracked `.rye` files; this thread has read 6 of them whole
(`queue.rye`, `cycle.rye`, `unhand.rye`, `confer.rye`, `revoke.rye`, plus `address_space.rye` cited
by the Tally piece). Comlink, the real Tablecloth store (as opposed to the toy cloth row 5
proposes), Amphora, and Brix carry zero reads from this thread. **Five checked-negative readings
describe a pattern; they sample a tree this large rather than exhaust it**, and the honest
confidence that every other composable seam stays uncomposed sits at medium, at best.

## What this means for the master page's ranking

Rows 2 (Caravan as pole), 5 (Tablecloth on a torus), and 7 (Aurora on a core torus) keep their
stated confidence -- Medium, Medium-low, Low -- because that confidence was already about *building
new structure*, and this synthesis confirms rather than changes the premise. What moves is the
ranking's own reasoning for row 2: "a table first, a Caravan change much later" now has five reads
behind it saying the Caravan change really would be a fresh design rather than a composition, which
is worth knowing before a lane spends a round on the table.

## What Bakery could pick up, and what stays here

**Buildable now:** `tally/torus_index.rye`, named and sized in the sibling piece -- the one item
this whole thread has produced that is provable on this hosted machine today.

**Stays here, named as vision:** the aggregate pattern itself, and the standing question of whether
Comlink, Tablecloth's real store, Amphora, or Brix carry the tree's second genuine composable ring.
A future round opening any of those four either extends this synthesis or overturns it, and either
outcome is worth a dated note the way this one is.

## Related

No tracked issue. This note adds zero dependency to any ship's Now line and leaves
`construction/ITINERARY.md` exactly as it stands.

May the next reader who opens Comlink, Amphora, or Brix find this table worth extending by one row,
and may the day a real second ring turns up be as clearly written down as the day none did.
