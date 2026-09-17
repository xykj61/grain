# ITINERARY landed accounts -- pheromone, the question a ledger row asked and nobody built

**Language:** EN
**Status:** Shelf -- dated testimony, never edited
**Room:** checkable
**Stamp:** `20260917.025309` (EDT)
**Voice:** Kyri
**Style:** Gauge at Meter

The account below was born on this shelf, under the card's own open question about whether an
account should live here from birth rather than taking a line of the pin.

**PHEROMONE -- A LEDGER ROW NAMED THE INSTRUMENT IT WANTED, AND THE ROW WAS THE ONLY READER.**
**AETHER HEARS** (row 0, N=5240): listen for the page nobody answered. REDS `%767` wrote it in its
own second field -- *Not a guard -- nothing in this tree asks whether every field a contract
publishes carries a ceiling that contract declares.* The row has stood OPEN since `20260916.065731`
with that sentence unanswered, and a whole-tree grep for a guard reading the contract's ceiling
table returns nothing.

**WHAT THE ROW FOUND, AND WHY NO INSTRUMENT COULD.** Four fields of the accepted receipt contract --
`product_digest`, `value_unit`, `return_kind`, `signature` -- refuse at
`mantra/src/tally_receipt_offer_bounds.rye`'s `max_identifier_bytes`, the **96** the contract
declares for *each identifier* and for none of them. A reader meets `field=value_unit value=97
ceiling=96 unit=ascii-byte reason=too-long` and finds 96 nowhere in the contract under that field's
name. The contract read complete and the code read bounded, so the gap closed in the direction that
looks compliant from both sides, and only a water-row reading of one page against the other found
it.

**THE MECHANISM.** `tools/fixtures/r/receipt_contract_ceiling_scan.sh` holds three documents to one
answer in three awk passes over four files, with no build. It reads the ceiling table of
`active-designing/20260912-201126_the-receipt-you-can-read-contract.md`, anchored on its own header
row so the page's other three-column tables stay unread; the `max_*` constants of the bounds module;
and every `_refusal(` call in `mantra/src/receipt_offer.rye`, taking the field from a string literal
argument, from the array entries a loop consumes, or -- for `encoded_fact` and `receipt_facts`, whose
names are literals inside their helpers -- **read out of `mantra/src/tally_receipt_refusal.rye`**
rather than spelled a second time. **GATED AT ZERO:** `unnamed_ceiling`, a field refused at a
ceiling no row of any kind names, and `value_disagrees`, a row stating a number other than the one
the code refuses at. Reads **14 sites, 14 named, verdict=agree**.

**WHAT IT REPORTS IS THE CAUSE THE REPAIR LEFT STANDING.** The contract declares `each identifier`
at 96 and never enumerates which fields are identifiers, and **five lean on that row alone**.
An undeclared membership is exactly the hole `product_digest` fell through, since it travels inside
an array literally named `identifiers`. Enumerating the population changes what the contract
publishes, so `population_undeclared` reports and never gates, beside `borrowed_rows=4` and
`row_unenforced=2` -- `receipt-card width` and `receipt-card height`, described in the contract and
read by nothing.

**PROVEN:** pen **39 legs, 0 failing** on a planted field, every refusal planted and then lifted,
**three mutations bitten**. **MINE:** my first draft stripped arguments at the line's FIRST paren,
which is the enclosing `if (`, so every directly named field vanished and only the identifier array
survived -- the reading looked plausible at six sites and was missing eight. It is a planted
mutation now. **MINE, SECOND:** my first bite detector watched the site count alone and called two
of three mutations harmless, because losing the population rescue moves `named` and `unnamed` and
leaves `sites` exactly where it stood.

**YOURS:** `%767`'s four derivations still want your word, and this guard changes none of them --
every number it reads is the number already enforced. The new question is the population row: should
the contract enumerate its identifiers, or is `each identifier` an honest population a reader may
be left to infer?

## The three withdrawals, and the one cause under them

**This lap withdrew three things inside one hour, and the same gap made all three.** Booking a
red found Rishi's `if` claiming the `else` that belongs to `assert`: `if (C) then assert X else
"msg"` splits into `assert X` and `"msg"`, so the assert runs **stripped of its message** when `C`
holds and `eval_statement` returns `error.UnknownStatement` when it does not. The row was booked
`%804`, trimmed four times to fit a pin standing **50 bytes** under its 65,536, and needed a fold
of `%802` to make room.

The final rebase answered all three. A peer had folded `%802` forty minutes earlier to a different
shelf, so **the fold was withdrawn whole**. Upstream had booked `%804` through `%808` while this lap
built, so **the row renumbered to `%809`**. And `%806`, stamped `20260917.030908` -- sixteen minutes
before this row's `20260917.032540` -- had booked **the same defect**, same file, same line 55, same
pen proof from both branches. **The row was withdrawn whole.**

**THE HALF `%806` DOES NOT CARRY, for whoever takes the repair.** That row reads the fault through
the false branch, where the refusal is loud. The TRUE branch is damaged too and silently: the assert
runs without the `else` message its author wrote, so a genuine failure prints
`rishi: assertion failed -- c.out contains "ABSENT"` and the sentence explaining what that means is
nowhere in the output. Proven on metal in a four-line pen. The shape stands at **9 sites across 7
living `.rish` files** -- free; run `grep -rn 'then assert.* else ' --include=*.rish . | grep -v
'^./rishi/'`.

**THE GAP, NAMED.** The baton asks a lap to claim before it builds a new instrument or takes a
BOOKED red off the ledger. Nothing asks it to claim a red it is about to **book**, or a fold it is
about to take -- and a ledger row and a pin fold are the two most collision-prone acts in this
fleet, because every ship reads the same pin at every lap open. This lap's claim named its three
instrument files honestly and covered none of the three things that actually collided.

## The roster, read on this ship, `20260917.033000`

**Five reds stood and every one predates this lap**, each re-run with the lap's own work stashed and
answering the same numbers -- which is how a red is told from a lap's own damage.

| Guard | Reading | Whose |
|---|---|---|
| `unheard_guard` | `control_unheard=20` against a ceiling of 18 | the lanes that landed the two unrun controls |
| `law_guard_heard` | `sibling_refused`, behind the above | cascades |
| `instrument_refusal` | `swallowed_instrument_passes=2` against zero | both lines in `tools/fixtures/b/bron_resins_landed_scan.sh` |
| `built_tool_freshness` | `stale_tool` -- this pier's `rye` 9,770 seconds behind `rye/src/main.rye` | a machine fact, cleared by one `sh rye/bootstrap.sh` |
| `ryekey` | `rishi: line 55: UnknownStatement` | `%806` |

**None was taken.** Each belongs to the lane that landed it, and taking a peer's freshly landed
ceiling is precisely what the claim board exists to prevent -- a lesson this lap paid for three
times over in the section above.
