# Three Writers, One Order -- what the parallel loops prove about our own consensus

**Language:** EN
**Version:** `20260826.171809`
**Style:** New Gauge, Field setting -- Civic (name what it rewards) and TAME (bound every claim, say
why) carried through (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Design -- reasons about a running arrangement and the repair it recommends. Every module and every name stays
exactly where it stands.
**Silo:** our own modules and RISC-V only.
**Grounds in:** [`../foundations/20260825-211055_mycelium-the-consensus-protocol.md`](../foundations/20260825-211055_mycelium-the-consensus-protocol.md)
-- [`20260826-151528_the-three-stars-of-the-aether-row.md`](20260826-151528_the-three-stars-of-the-aether-row.md)
-- [`20260825-210819_the-round-that-pulls-twice.md`](20260825-210819_the-round-that-pulls-twice.md)

---

## What this answers

Three recursion loops now run against one tree -- **Mind** (cardinal), **Sound** (fixed), and
**Dream** (dual). Each is an agent taking laps on its own bench, and all three write to the same
history. That is a distributed-consensus arrangement wearing working clothes, and this document asks
what it costs, what makes the conflicts resolve cleanly, and why the arrangement is worth keeping
rather than collapsing back to one writer.

The short answer: **the three loops are what exercises our own consensus law on real traffic**, and
a law stays untested until something exercises it.

## The law the loops are reading

Mycelium states one idea beneath its ninety-eight modules:

> **The order is decided once, by everyone, and read by everyone the same way.**

A node reads its balance as a pure function of the agreed order over signed facts, where a simpler
system would let it write a balance directly. The tree's own foundation names git as Mycelium's **interim carriage**
until Comlink crosses a real network, and the fit is closer than a stopgap: a commit hashes its
parents, so the shared history already attests to every vertex beneath it.

Three loops make three writers against that carriage. **Every round each loop takes is one full
cycle of the protocol** -- read the agreed order, propose an extension, discover whether it was
accepted:

| Round step | What it is in the protocol |
| --- | --- |
| pull `xy` with `--rebase` at round open, before reading context | **read the agreed order** -- the card you read is the tree you stand on |
| package the round locally, witnesses green | **propose an extension** |
| fetch `xy` again before pushing | **re-read**, because the order may have moved |
| the push's fast-forward refusal | **the compare-and-set** -- the whole allocation, answered by re-integration rather than by force |
| park on `refs/heads/pier/<name>` after the third refusal | **bounded retry**, then yield |

That rota is seated. What the three loops add is **traffic**: a compare-and-set stays untested until
somebody loses one.

## What Mantra and Mycelium each contribute

The two are often said in one breath, and they do separate jobs.

**Mycelium supplies the law and the refusals.** Its discipline is why a collision is survivable at
all: everything bounded, **every refusal carrying a name** -- `Overdraw`, `Equivocation`,
`AlreadyLanded`, `BelowQuorum` -- and every claim proving on metal across 80 witnesses. A named refusal
lets a losing writer learn *which* rule it met and retry correctly, where a bare failure leaves it
guessing. Three loops racing is exactly the traffic that turns those names from
documentation into a diagnostic.

**Mantra supplies the referential namespace**, projecting version control over Weave and growing
**recall** and **bolt** (seated `20260706.032700`). This is what makes a conflict *resolvable* as well as
detectable: when two loops describe the same artifact, resolution needs a name that means the same
thing on both benches. A path resolves, a stamp orders, a basename stays
globally unique. The tree's whole filing law -- one shape, whole stamp in every basename, the fold
as a pure function of the basename -- exists so that a reference survives being carried between
writers.

**Together they give the property this arrangement runs on: a conflict between two loops is almost
always a conflict between two texts rather than between two meanings.** That is what "resolve
cleanly" actually means here, and it is engineered rather than lucky.

## Measured: what actually collided

Two piers merged on `20260826`. The reconciliation is the evidence this document is built on, and
the numbers are counted from that round rather than estimated.

| Reading | Count |
| --- | --- |
| Conflicted files, first merge | 21 |
| Of those, both piers repairing the **same red two different ways** | 11 |
| Conflicted files, second merge (one upstream commit, minutes later) | 4 |
| Reds that arrived **on** the merge, belonging to the pair rather than to either pier | 4 |
| Row numbers allocated twice, independently | 5 (`%233`-`%237`) |

Two shapes, each wanting its own answer.

**The eleven are the happy case, and they are the majority.** Both piers found one dialect fault and
fixed it -- one by factoring a helper module, one by inlining the same spelling at each call site.
Two correct answers to one question. Resolution was a judgement about which generalises, taken once,
and the merge kept the factored form because it subsumes the other one. **This is what a well-siloed lane
arrangement produces: collisions where both sides are right, rather than collisions where both are
wrong.**

**The five are the structural case**, and the foundation predicted them in words before they
happened: *a number allocated by reading a tree is allocated per tree.* Both piers read the ledger,
both saw `%232` as the last row, both took `%233`. Both were correct to. This is the one collision class
that survives reading harder, and it cost a hand-renumber to `%271`-`%275` under Keaton's word.

## The repair the evidence recommends

The foundation already names it: **a row's immutable key is its one-clock stamp**, with the count-up
number becoming a derived reading where it had been an allocated one.

Two writers reading the same tree at the same moment produce **different stamps** and identical
count-ups, because a stamp is drawn from a clock the writer holds and a count-up is drawn from a
shared page. Stamps are already this tree's mark law everywhere else
([`../.claude/rules/stamp-and-name.md`](../.claude/rules/stamp-and-name.md)); the ledger is the room
that kept counting.

**The census exemption stands and is the reason this is delicate.** `%NNN` rows are a *census* rather
than a *forecast* -- they name work already done, a gapless spine proves the record is whole, and
2,519 citations reach into commit messages and dated testimony beyond any migration. So the repair is
**an added derived key, leaving every existing name in place**: rows keep every number they wear, and
allocation moves to the stamp for rows written from here forward. Bound: this changes what a *new*
row is keyed by, and touches no landed row.

**Falsifier, stated plainly:** if a fourth loop joins and row collisions keep arriving after the
derived key seats, the diagnosis was wrong and the contention lives somewhere past allocation.

## What the arrangement rewards

Civic asks what a design rewards, and whether that matches what anyone wants.

**It rewards lanes.** Each star owns a surface -- Mind the Brushstroke and Surf work, Sound the
Caravan-Tally-Scribe seams, Dream the higher rune ports lowered to Rye. A find in a sibling's lane
becomes a line on the living card rather than a lap. Lanes are why two piers running a full day in
parallel produced 21 conflicts where an unlaned arrangement would produce hundreds.

**It rewards small, frequent rounds.** Every push is a compare-and-set, so a small round loses
little on a refusal and re-integrates fast. A large round is a large bet on the order holding still,
and today the order moved *between* the merge and the send.

**It rewards writing the reason down.** A merge resolving eleven same-red conflicts needs to know
*why* each side chose what it chose, and the side carrying its argument in its comments won every
time.

**And it rewards a living pin that stays small.** Every pin the loops share is a contention point,
and `construction/ITINERARY.md` hit its 24,576-byte bound three times in one reconciliation. A pin
near its ceiling makes every writer's round more expensive, so the bound is a concurrency property
rather than tidiness.

**What it punishes, and this is the honest limit:** anything allocated by reading shared state. Row
numbers today; any future counter tomorrow. The arrangement makes that class *visible* quickly,
which is worth something, and *frequent*, which is the cost.

## Why three loops rather than one

One loop would meet none of these conflicts, and would prove correspondingly little.

The tree's consensus season carries 80 witnesses and 17 fixtures, all of them exercising the protocol
against planted inputs. **Planted inputs prove the code; concurrent writers prove the arrangement.**
Every property Mycelium claims -- the order read the same way by everyone, the named refusal, the
bounded retry -- describes a world holding more than one writer. Three loops are the
smallest arrangement that produces that world on real traffic, at a cost measured today at 25
conflicts across two merges, 20 of which resolved by reading.

That is the trade, stated as a trade: **frequent small collisions bought early, in exchange for the
one structural collision class becoming visible before value ever moves across it.** The Byzantine
arithmetic stays where value moves; this is the ergonomics rehearsal, and rehearsing is what it is
for.

## What waits for a word

The derived-spine key is **proposed, awaiting a seat**. It changes how a shared ledger allocates,
which is the kind of decision this tree seats by name. Every row, module, and sibling lane stands
exactly as this document found it.

---

*Addendum, accreted `20260827.181605` -- the word came.* The derived-spine key is **seated**. The
collision class fired twice more in the day after this document was written (`%294`-`%296`, and
`%297` on adoption), which is five and six. The law is
[`../.claude/rules/derived-spine.md`](../.claude/rules/derived-spine.md), the meter is
[`../tools/r/reds_spine_derive_witness.rish`](../tools/r/reds_spine_derive_witness.rish), and the
paragraph above stands exactly as it was written -- what moved is the allocator, not this record.
