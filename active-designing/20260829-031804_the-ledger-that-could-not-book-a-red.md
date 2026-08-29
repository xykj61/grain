# The ledger that could not book a red

**Stamp:** `20260829.031804`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- a reading, with one meter landed and one seat named and left standing
**Kin:** [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) -- [`../foundations/20260816-214652_standfast-the-stopped-line.md`](../foundations/20260816-214652_standfast-the-stopped-line.md) -- [`../foundations/20260729-224828_reds-first-and-the-allocation.md`](../foundations/20260729-224828_reds-first-and-the-allocation.md)
**Meter:** [`../tools/r/reds_pin_capacity_witness.rish`](../tools/r/reds_pin_capacity_witness.rish)
**Ledger row:** [`../construction/archive/REDS-the-ledger-that-could-not-book-a-red-rows-338.md`](../construction/archive/REDS-the-ledger-that-could-not-book-a-red-rows-338.md)

**The short of it.** On `20260829` the ledger this tree books its faults in could not accept another
fault. `construction/REDS.md` stood at **24,571 bytes of the 24,576** its own header declares --
five bytes of headroom -- with **all nine** of its rows marked OPEN, so
`tools/fixtures/r/reds_fold.sh` found every one of its lawful moves already spent.
Four guards read that page every lap and every one of them was green.

## What was measured, and how

All figures were read on `20260829` from the tree at `087bccea25`, by
`tools/fixtures/r/reds_pin_capacity_scan.sh` (landed this lap) and
`tools/fixtures/r/reds_status_consistency_scan.sh` (standing).

| Reading | Value |
|---|---|
| pin bytes / declared bound | **24,571 / 24,576** |
| headroom | **5 bytes** |
| rows in the pin | 9 |
| rows marked OPEN | **9** |
| rows the fold tool would accept | **0** |
| median row | **1,983 bytes** |
| rows that fit in the headroom | **0** |
| live reds sitting on a shelf | **1** (`%337`), and 2 once this lap booked its own |

A median row is 1,983 bytes and the headroom is 5. The ledger's own first law -- *a red enters this
ledger when it is found* -- had become unrunnable, and the card recorded the consequence plainly:
four reds went unbooked on `20260828` for that reason alone.

## Why it deadlocked, structurally rather than by accident

`reds_fold.sh` refuses `row_open`, and its stated reason is right: *"the pin keeps what is open;
folding one would hide live work on a shelf nobody reads for live work."* That rule rests on an
assumption it never states -- **that rows eventually close.**

Read the nine, and the assumption comes apart. All nine stand open on something already repaired:

- **Open on a ratchet:** `%311` (152 answer-blind runs, 7 never-refused files), `%334` (21 unbuilt
  pairs). Reds-first reserves the booking of an allocation for a red, and says of the other kind
  only that *a ratchet turns on touch.*
- **Open on a seat awaiting Keaton's word:** `%306` (which room moves), `%326` (binding a
  path-moving commit to a guard), `%327` (this pier's own `enclosure.conf`), `%328` (whether the
  roster's own witness can be rostered).
- **Open on booked future work:** `%291`, `%301` (five folds, one per room), `%330` (a design lap).

Every underlying defect carries a *Repaired* clause with a witness on metal. So the pin's single
OPEN flag is carrying **two meanings at once** -- *the defect is live* and *a remainder is booked* --
and the fold tool can only read the flag.

**The transferable rule:** a status field that answers two questions will eventually be read for
whichever meaning its reader happened to want, and the tool written against the narrower one is the
tool that pays.

## Why no meter saw it

Four meters read this ledger, and every one asks whether what is written is **consistent** --
`reds_ledger_monotone_scan.sh` (the spine runs 1..N with no gap), `reds_status_consistency_scan.sh`
(no closed row still reads OPEN), `reds_spine_derive_scan.sh` (no number rebound against the
anointed remote), `reds_ledger_headline_scan.sh` (the headline measured rather than recited).

**None asks whether anything more can be written.** Consistency and capacity are different
questions, and only one of them had ever been asked -- which is why the ledger filled up in full
view of four green guards. This is REDS %301's own sentence one instrument over: *a meter that
discovers by a property only some things have will never report the thing nobody thought to name.*

## What the fleet did, honestly and on the record

Rows `%335`, `%336`, and `%337` were **born directly onto single-row shelves** under
`construction/archive/`, each saying so in its own header, each recorded in the fold recital. The
spine stayed gapless and the trail stayed readable, so the workaround was disciplined rather than
quiet.

It has one cost, and it is exactly the one `reds_fold.sh` guards against: **`%337` is a live red on
a shelf**, so a lap reading the pin under reds-first sees nine of the ten open reds.
This lap's own row, `%338`, made it ten of eleven.

## What landed this lap

`tools/fixtures/r/reds_pin_capacity_scan.sh` over the shared row reader
`tools/fixtures/r/reds_pin_capacity_rows.awk`, its control, and
`tools/r/reds_pin_capacity_witness.rish` -- the meter that asks the capacity question, GREEN on
metal over 31 control cases.

- **Gated at zero:** `phantom_recital_shelves`, a recital line naming a shelf not on disk. The
  recital is the only trail from a folded row back to the lap that folded it. Measured **0**.
- **Ratcheted under ceilings that only fall:** `unrecorded_shelves` at **62** (shelves older than
  the recital's own `20260825.183336` birth), `shelf_open_rows` at **2**.
- **Reported, never gated:** the capacity table above, and `pin_deadlocked`.

**Capacity is reported rather than gated on purpose.** Raising a page's bound is Keaton's word --
seated that way once already for `session-logs/README.md` -- so a gate here would red on every
ordinary lap until he speaks, and a gate that reds on ordinary work is a gate someone turns off.

**Two readings, proven to agree rather than promised to.** A row's *foldability* is the bare
uppercase word OPEN, because that is literally what `reds_fold.sh` refuses on; a row's *declared
status* is the last bold marker, because that is how `reds_status_consistency_scan.sh` reads it.
They differ by four rows in this tree. A first draft used the fold test for both and reported five
live reds on shelves where one exists, so the witness now proves the count against that standing
scan: `pin=9 shelf=1 spine=10`.

**Two reds inside the repair, kept rather than smoothed.** The control's own harness swallowed every
expected refusal -- `( cmd ); echo $?` under `set -e` aborts the subshell before the echo -- so three
cases read `no` while the scan was correct. And the witness's pen rows were eaten by `printf`
reading `%1` as a conversion specifier, which meant its **deadlock case passed vacuously on zero
rows**. Both are REDS %311's lesson (*the framing a harness prints is not evidence*) reproduced
inside the lap that cites it.

## The seat, with its arithmetic, left standing

Three doors open, and each costs something different. Each stays open for Keaton's word.

**A. Raise the REDS bound as a per-page exception.** The precedent and the mechanism both exist:
`living_pin_max_bytes[session-logs/README.md] = 57344`, read per page by
`tools/fixtures/l/living_pin_max_bytes.sh`, so the new number would keep one home, as today's does. The arithmetic
for *n* open rows is `n x 1,983 + 5,044` bytes of prose: **twelve rows wants 28,840**, sixteen wants
**36,772**, twenty wants **44,704**. *Cost:* the general bound exists because 24,576 is about six
thousand tokens, a pin an agent reads in one breath, and every byte past that is read by every lap
forever. *This buys time; the cause stays where it is.*

**B. Split the OPEN flag into what it is actually saying** -- a live defect, versus a booked
remainder that is a ratchet, a seat, or a future lap -- and let `reds_fold.sh` fold the second kind
while still refusing the first. *Cost:* a change to reds-first's own vocabulary, and one honest
re-reading of every standing row. *Return:* the deadlock ends for good, since what filled the pin was
booked remainder rather than live work. **This is the one door that reaches the cause.**

**C. Sanction the single-row shelf birth in the fold tool's own contract**, so the tool stops
refusing what the hand already does three times a week. *Cost:* the pin stops being the whole answer
to *what is open*, which is the one job the pin has.

Which one, and when, is Keaton's word.

## What this reading does not reach

**Whether any of the nine deserves to still be open.** That is a lap's judgment and a person's word,
and a meter that guessed at it would be closing reds by arithmetic -- which the law forbids in as
many words: *a red closed by a claim is not closed.*

**Whether the ledger's rows should be shorter.** The session-logs index answered its own version of
this with *a row points, it does not summarise*, at 192 bytes. A REDS row cannot take that cure: the
row **is** the record, three fields, and the ledger's first law is that rows are never edited.
