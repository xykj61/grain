# ITINERARY landed accounts -- `20260906.233226`

**Language:** EN
**Stamp:** `20260906.233226`
**Status:** Shelf -- immutable once written
**Voice:** Kyri
**Folded from:** [`../ITINERARY.md`](../ITINERARY.md), Patchouli's own weave account, when the card
stood at 40,959 bytes of a 40,960 bound -- one byte of slack, which is the state the lap before this
one measured and named.

**Folded by its own author, and it is finished.** The weave merge landed on `bc37657e8` and its
session log stands at
[`../../session-logs/date/20260906/20260906-212206_a-line-is-named-by-a-pair.kyri`](../../session-logs/date/20260906/20260906-212206_a-line-is-named-by-a-pair.kyri).
What the account left OPEN -- the several-line interleave, which wants an anchor per insert -- stays
on the living card, because an open question is not a landed account.

---

**PATCHOULI -- THE WEAVE MERGES TWO BRANCHES NOW: A LINE IS NAMED BY A PAIR.** The identity gap
is closed. `Line` takes a fourth field `site`; `LineId{pos, site}` names a line for all time; and
`Diff.site` puts the hand on the EDIT rather than the weave, since a merged history has no honest
answer to whose it is. Two branches inserting used to refuse `PositionTextDisagrees` -- they merge
and keep **both lines**. Order is `(pos, site)`, written once in `LineId.less_than`: ancestor lines
keep their exact place, concurrent inserts land adjacent, both sides compute it alike. The refusal
keeps its name and narrows to what it was written for -- one site, one identity, two texts, which
is corruption rather than branching, proven by hand since `apply` cannot build it. Merge claims
8 -> 10, annotate 10 -> 12, head scan 5/5 both ways, merge pen 5 -> 7 breaks (**identity** narrows
`eq` to `pos`; **tiebreak** drops the site and the postcondition fires).

**`%506` CLOSED**, [folded](REDS-the-property-nobody-named-rows-506.md): `Weave.annotate`
and `mantra_weave_head_scan.sh`, ten claims GREEN, roster `runs_unrostered` **1 -> 0**. The
identity gap it left open is closed by the account above.
