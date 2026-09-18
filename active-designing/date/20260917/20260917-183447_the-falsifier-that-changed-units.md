# The falsifier that changed units

**Stamp:** `20260917.183447`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every number below is read off the module and the page by [`../tools/fixtures/m/mantra_head_door_cost_scan.sh`](../tools/fixtures/m/mantra_head_door_cost_scan.sh), gated by [`../tools/m/mantra_head_door_cost_witness.rish`](../tools/m/mantra_head_door_cost_witness.rish)
**Room:** checkable
**Elder:** [`20260916-105110_no-anchor-names-the-head.md`](20260916-105110_no-anchor-names-the-head.md) -- dated testimony, unchanged
**Module:** [`../mantra/src/weave.rye`](../mantra/src/weave.rye) -- **Red:** `%807`

## What was asked

The elder page names three doors out of REDS `%807` -- a line inserted at the head of a stored
document leaves the document -- and recommends **Door C**, a document-start sentinel. It then
writes its own falsifier, which is the part worth admiring:

> **Falsifier:** a count of the places that would have to learn about the sentinel. If that count
> exceeds the 12 place constructions Door B touches, Door B is the cheaper accretion and this
> recommendation is wrong. **Confidence:** moderate -- the two costs were reasoned about rather
> than both counted, and only one of them has a number beside it on this page.

A page that names the measurement which would refute it has done the hard half. This lap ran it.

## The answer is two answers

**Read literally, the falsifier fires.** Twenty-eight places in the module would have to learn
about the sentinel, against a stated twelve. By the page's own test, Door C is refused.

**Counted in one unit, Door C still stands.** Twenty-eight sites must change for Door C; **thirty-
two** must change for Door B. Door C is cheaper by four sites, about twelve percent.

Both readings are true, and they disagree because **the falsifier compares two different units.**
A *place construction* is a four-field literal. A *place that must learn* is any site whose
arithmetic moves when the line list carries one more entry than the document holds. Counting Door
C in the second unit and Door B in the first is what makes the comparison answerable only by
whoever picks the unit.

The page's stated confidence was right, and for a reason it did not name. It said the weakness was
that only one side had a number. The sharper weakness is that the two sides had no shared **unit**,
so a second number would not have settled it either.

## The stated twelve does not reproduce

| Reading | Count |
|---|---|
| Place constructions the page states | 12 |
| Place constructions the module holds | **6** |

Six: four `place()` accessors on `V2Row`, `OrderRow`, `Line` and `Note`, each returning a
four-field literal, and two sentinel initializers -- `previous` in `from_order_record` and in
`from_v2`. Nothing else in `mantra/src/` builds a `Place`.

So the falsifier fires against the stated twelve **and** against the measured six. The first of
the two answers holds whichever number a reader trusts, which is the one place this reading is
robust rather than delicate.

## How each door is counted

**Door B -- a fourth place field.** A sibling flag goes exactly where `ord` goes, so its cost is
every site naming the order key: the six place constructions, the four structs storing one, and
every other `.ord` in code. **Comment text is read past**, because a doc comment describing the
field needs no edit to keep compiling. Thirty-one `.ord` sites stand in the two sources, twenty-
eight of them in code, plus four field declarations: **32**.

**Door C -- a document-start sentinel.** The sentinel is an extra entry in `lines`, so every site
reading `lines.items.len` is a candidate. The thirty-three are classified rather than totalled:

| Class | Count | What it is |
|---|---|---|
| free | 5 | an adjacency walk, or an insertion index seeded from the length -- the list compared against itself, so the sentinel rides on both sides |
| external | 16 | the length against a ceiling, a record's row count, or a diff's insert count -- the sentinel is in one and in none of the others |
| alloc | 12 | the length cast into an allocation size, or asserted equal to a result's length -- a row array sized to include the sentinel writes a row the record must not carry |
| unclassified | 0 | -- |

**Free is tested first, and the order is load-bearing.** `var at: u32 =
@intCast(self.lines.items.len)` matches the free rule and the alloc rule both, and it is an
insertion index rather than an allocation. The control swaps the two rules and watches exactly
that one site cross the gate, so the ordering is priced rather than asserted in a comment.

**One subject is excluded by name.** `mantra/src/diff.rye` carries two `lines.items.len` sites
whose `lines` is the diff's own output list rather than a weave's -- a different subject wearing
the same spelling. It is counted and reported apart, so the exclusion is visible. The forty
witness sites are reported and gated by nothing: a witness learning about the sentinel is a real
lap, and it is not the cost either door's argument is about.

## What holds these numbers still

Every figure here is **walled**: [`../tools/m/mantra_head_door_cost_witness.rish`](../tools/m/mantra_head_door_cost_witness.rish)
asserts each one, so the lap that moves a count reds the guard rather than leaving this page
quietly wrong. The threshold is **read off the elder page** rather than spelled in the scan, and
the control proves it by handing the scan a page reading forty and watching the falsifier stop
firing.

Twenty-seven control legs on a dereferenced copy of the module room: one site of each class
planted and counted, an order key planted inside a comment and proven **not** charged to Door B, a
count site matching no rule proven to red rather than be absorbed, a page with its threshold
removed refused, a page this tree does not carry refused, and two rules struck out and shown to
bite.

## What this does not decide

**Which door the weave walks through.** That is a ruling about how places are **assigned**, and
`%807` returns it to Keaton exactly as `%680` did. This lap puts a number beside each door and
stops.

**Whether either count is the right cost model.** Sites-that-must-change treats a one-line assert
and a record format as one unit each. It is the same unit on both sides, which is the whole of
what it claims.

## What it teaches past this module

**A falsifier is only as good as its unit.** This one was written carefully, named exactly what
would refute it, and still could not settle the question -- because the quantity on the left and
the quantity on the right were counted differently. The cure is cheap and belongs in the habit
rather than in this page: **when a design note names a falsifier, name the unit both sides are
counted in**, and the test either fires or it does not.

*May a page that names its own refutation keep doing so, and may the next one name its unit too.*
