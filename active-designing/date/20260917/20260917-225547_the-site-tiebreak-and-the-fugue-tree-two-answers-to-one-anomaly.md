# The site tiebreak and the Fugue tree -- two answers to one anomaly

**Stamp:** `20260917.225547` -- **Status:** Design, proposed, vision -- awaiting its own witness --
**Room:** vision -- **Setting:** Gauge, Field -- **Voice:** Kyri
**Kin:** [`mantra was named for the weave`](20260905-153729_mantra-was-named-for-the-weave.md) -
[`what mantra is`](../foundations/20260825-211056_what-mantra-is.md) -
[`the pen, the gossip, and the derived spine`](20260825-205011_the-pen-the-gossip-and-the-derived-spine.md)
**Provenance:** reads `mantra/src/weave.rye` as it stands today; cites two published papers by name
and link rather than by code, per the clean-room discipline (`gratitude-licenses.md`).

## The question, bounded before the argument

`mantra/src/weave.rye`'s own header carries a finding in plain prose: two sides that each appended
three lines once came back alternating, line for line, the first time the module ordered concurrent
inserts by identity alone. The header speaks from its own run of the code, ahead of any citation.
This piece names the published source for that same finding, and poses one question the source
raises that Mantra's own comments leave open.

**The falsifier, stated first so the rest of the piece earns it.** A witness could plant three or
more concurrent edits, each anchored on one shared line, and read whether Mantra's ordering keeps
every side's block whole. Such a witness finding an interleaved case would falsify the claim below
-- that Mantra's site tiebreak already reaches the guarantee two published algorithms name outright
-- and would do so at the exact line this piece names as the open question.

## The anomaly has a name, and Mantra met it independently

Kleppmann, Gomes, Mulligan and Beresford's 2019 paper, *Interleaving anomalies in collaborative text
editors*, names the exact shape Mantra's own header describes. Several published algorithms for replicated lists order concurrent insertions by a scheme that
reads soundly at one line. At a whole paragraph the same scheme can produce a jumble, where two
authors' sentences interleave word by word. This piece reads the paper rather than quoting it, in
this tree's own clean-room habit ([`gauge-style`](../.claude/rules/gauge-style.md) carries the same
habit for every source cited here) -- the finding stands public, and the words stay the paper's own.

Weidner and Kleppmann's 2023 follow-on, *The Art of the Fugue: Minimizing Interleaving in
Collaborative Text Editing*, names a correctness property for a replicated list -- **maximal
non-interleaving**. The paper proves two results worth carrying into this tree's own thinking.
Perfect non-interleaving stands beyond reach in general; some concurrent edits genuinely earn a
split. An algorithm the paper names **Fugue** reaches the *maximal* property anyway. It attaches
each new character to a tree of prior insertions, by a left-or-right rule read from what each side
already knew when it wrote.

Mantra's header already carries the same encounter, in its own voice:

> two sides that each appended three lines from a shared counter came back alternating left, right,
> left, right, their positions coinciding one for one

Running the code taught this tree the anomaly the 2019 paper names, and the repair landed before
either paper entered this tree's own citations.

## What Mantra actually does, read from the source

`Place.less_than` (`mantra/src/weave.rye:341`) orders four fields in sequence: `run`, then `site`,
then `ord`, then `pos`. Its own comment states the reason plainly. Two branches taken from one base
draw the *same* positions off a shared counter. An order reading position or the order key ahead of
site would then alternate their paragraphs line for line -- the anomaly named above, caught by this
tree's own merge witness ([`derived-spine`](../.claude/rules/derived-spine.md) names a kindred
merge-time repair, one file over) inside the hour a first draft tried the other order.

The finer mechanism sits in `apply` (`mantra/src/weave.rye:1516-1571`). A genuinely new paragraph,
opening the document, takes a fresh run and an order key equal to its own position -- the counter
alone decides it. An insert naming the kept line it follows (`Diff.after`) instead **inherits that
anchor's own run and order key**, keeping only its own fresh position as a name of its own. Two
sides anchoring on one shared line therefore meet the comparison with equal run and equal ord, and
`site` -- one fixed number per hand -- settles it ahead of position. One side's whole block sorts
before the other's, entire, rather than the two trading places line by line.

This reading names a **flat, global tiebreak**: a site number, compared the same way for every pair
of concurrent edits, asking no question about who saw what. It costs one comparison already paid for
by the anchor lookup. It also differs from Fugue's own answer in kind: Fugue decides left-or-right
from what each side's edit already knew about the other, a causal reading; Mantra decides from a
site number alone, a name carrying no causal history.

## The open question this piece leaves standing

**Reading the code shows the two-sided case; it does not settle the three-sided one.** The
comparison above shows Mantra's tiebreak resolves the pair the 2019 paper names and this tree's own
header records. Fugue's proof reaches further: it names the exact shape of edit where even the
*best* algorithm must split, among three or more sides anchoring on one shared line. Whether
Mantra's flat site order agrees with Fugue's proof on every such shape, or parts from it on one this
piece has not yet named, is a question a proof answers and a reading only raises.

A site-number tiebreak sorts any number of concurrent blocks in one fixed order -- lowest site
first, entire, every time -- which stays whole for every case this piece checked by reading the
loop. Whether that same fixed order ever forces a split where Fugue's proof calls one unnecessary is
the open question, named here in place of an answer this piece does not yet have.

## What would decide it, named rather than built

A future witness could plant three synthetic sites sharing one base weave and one shared anchor
line, each applying its own multi-line insert after that anchor in its own order of arrival, then
read `current()` after every pairwise merge order and ask whether each site's own lines stay
whole. `mantra/src/weave_apply_witness.rish`'s own claim 9 already proves the two-sided case this
piece names, built by planting a mutation and watching a claim redden; a third claim beside it,
built the same way, would confirm the guarantee reaches three sides or name the first shape where it
does not. This piece states the claim worth writing; the writing waits for its own round.

## What this leaves standing

**The catalogue and the weave both keep exactly what they are.** This piece changes nothing in
`Place.less_than` or in `apply` -- the mechanism reads as sound for the case checked here, and a
proven ordering law earns a change only from a red, never from a research piece alone.

**The kinship is worth naming for its own sake.** A tree that met an anomaly by running its own
code, and a paper that named the same anomaly and bounded how far any algorithm can carry the fix,
arrived at kindred answers from opposite directions -- one from a merge witness reddening inside the
hour, one from a formal proof. Gratitude runs both ways: the paper's name for the failure sharpens
what this tree's own header already held, and this tree's own independent find is a small,
honest confirmation that the anomaly is real enough to meet twice.

## Sources and gratitude

- Martin Kleppmann, Victor B. F. Gomes, Dominic P. Mulligan, Alastair R. Beresford, *Interleaving
  anomalies in collaborative text editors*, PaPoC 2019 --
  [dl.acm.org/doi/10.1145/3301419.3323972](https://dl.acm.org/doi/10.1145/3301419.3323972),
  author copy at
  [martin.kleppmann.com/papers/interleaving-papoc19.pdf](https://martin.kleppmann.com/papers/interleaving-papoc19.pdf).
  Named the anomaly this tree's own weave met on its own.
- Matthew Weidner, Martin Kleppmann, *The Art of the Fugue: Minimizing Interleaving in Collaborative
  Text Editing*, arXiv:2305.00583, published IEEE Transactions on Parallel and Distributed Systems
  36(11):2425-2437 (2025) --
  [arxiv.org/abs/2305.00583](https://arxiv.org/abs/2305.00583). Named maximal non-interleaving and
  the impossibility bound this piece's open question stands beside.
- `mantra/src/weave.rye`, read in full around `Place.less_than` and `apply`'s insert loop, both
  cited by line number above.

May the weave keep every line it has ever held, and may the next hand who asks whether three sides
interleave find a witness already waiting with the answer.
