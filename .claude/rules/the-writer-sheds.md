# The writer sheds -- a shared pin is bounded by who writes into it

**Seated:** `20260917.222905` on Keaton's word - **Status:** Living
**Kin:** [`checkpoint`](checkpoint.md) - [`debride`](debride.md) - [`stamp-and-name`](stamp-and-name.md) - [`the-baton`](the-baton.md) - [`reds-first`](reds-first.md)
**Reading:** [`../../tools/fixtures/c/card_seat_weight_scan.sh`](../../tools/fixtures/c/card_seat_weight_scan.sh)
**Pin law:** `context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md`

**A seat holds ONE live account on the operator card, and writing a new one shelves its predecessor
whole in the same commit. A ledger row folds in the send that CLOSES it.** The writer sheds, at
write time, rather than a later hand shedding under pressure.

## Why a bound alone cannot hold these two pages

A living pin over its byte bound **refuses every commit on every ship**. That is the pre-commit
hook working exactly as designed -- the next push would make the overflow public -- and it means
one seat's overflow stops the pier rather than the seat.

Measured on `20260917`, the day this was seated:

| Reading | Value |
|---|---|
| Times `construction/ITINERARY.md` read over its bound | **5** -- at 0158, 1848, 2010, 2044, 2211 |
| Card at seating | 39,785 bytes, **1,175 of headroom** |
| A single new lap account | **2,000 to 3,900 bytes** |

So the next account overflows the page **by construction**, whoever writes it. Each of the five
crossings cleared only when a seat noticed and shelved something, which left the pier's throughput
resting on a hand happening to look.

**Raising the bound is already ruled the wrong instrument, by this tree, twice.** The account folded
off the ledger at `20260917.071327` closes with *a bound is the wrong instrument for a page whose
rows do not close, and the cure is closing rows rather than carrying them* -- and it forecast its
own failure correctly, raised on `20260915` for 24 rows and over again inside two days.

A bound states a capacity. What these pages wanted beside it is a rule about **arrival**.

## The convention, and the fleet half-invented it already

Nineteen pointers reading *shelved whole* or *born on its shelf* stood on the card at seating, so
several seats were already doing this. What this seats is uniformity, and the distribution shows
why that matters -- read at seating by the scan above:

```
PHEROMONE blocks=6   BAKERY blocks=4   COPAL blocks=4
GRASS blocks=2       DIFFUSER blocks=2
PETRICHOR blocks=1   PATCHOULI blocks=1   INCENSE blocks=1
```

**Five of eight seats held more than one block.** A page whose arrival rule is followed by three
seats is a page that still overflows.

**One live account per seat bounds the card by construction**: eight accounts plus standing prose,
rather than a ceiling held by nobody. The cost falls on the writer, who is the one hand that knows
which of its accounts has landed.

## How to shed, in both rooms

**On the card.** Move the elder account whole into `construction/archive/` under the one filing
shape, `YYYYMMDD-HHMMSS_sprig.md`, and leave a pointer of two or three lines. **Keep any open
question on the card** -- a `YOURS:` line is Keaton's and has not landed. Everything is kept: the
account is one click away and the fold is an ordinary accrete.

**On the ledger.** A row folds when it closes, to a shelf named for what it taught, with one line
in `construction/archive/REDS/REDS-fold-recital.md`. Folding within the hour a row closes is established
practice here rather than haste -- four shelves carry that sentence from `20260917` alone.

**A lane sheds its OWN.** A peer's live narrative is theirs, however tempting it looks when a wall
is in the way. When the card is over bound and nothing of yours is sheddable, say so and let the
seat that owns the bytes clear them.

## What this does not reach, said plainly

**A gate.** The reading above reports and gates nothing, because a gate over a page eight hands
write would refuse a peer's honest lap for a total that peer reads only after writing. Whether a
ceiling follows is Keaton's word once the distribution has been watched for a while.

**A seat whose one honest account runs long.** If a single account regularly exceeds 2,000 bytes
this convention buys less than the arithmetic above promises, and the remainder is a bound question
again. The scan's `seat bytes=` line is what would show it.

**The standing prose**, which was 29,968 bytes of the card at seating -- three quarters of it, and
left exactly as it stands. Whether the card's own structure has grown past what a lap needs is a
separate reading, still to be taken.

## Why the rule exists

A page that many hands write and one hand owns stays the size its owner chooses; a page many hands write and nobody owns fills until it breaks, and then costs whoever arrives next. Putting the shedding where the writing is puts it where the knowledge is: the hand that just
wrote an account is the one that knows the elder has landed.

*Cursor twin retired* `20260920.135100` -- this rule once mirrored to a `.cursor/rules/*.mdc` file; the whole family is archived, unmodified, at [`.cursor-archive/rules/`](../../.cursor-archive/rules/README.md).
