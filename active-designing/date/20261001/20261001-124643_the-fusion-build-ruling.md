# The fusion build ruling -- three decisions that unblock the cheap pass

**Stamp:** `20261001.124643` (EDT)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Ruled -- checkable room: each decision names the exact file and line it governs
**Room:** checkable
**Git nib:** `d2f5975a6e`
**Kin:** [`../../20260825-173153_reprove-only-what-moved.md`](../../20260825-173153_reprove-only-what-moved.md) (the fusion build's own design) - [`../../../external-research/date/20260908/20260908-065034_the-receipt-that-was-earned-and-the-map-that-cannot-spend-it.md`](../../../external-research/date/20260908/20260908-065034_the-receipt-that-was-earned-and-the-map-that-cannot-spend-it.md) (the stale diagnosis this page corrects) - `construction/REDS.md` `%756` `%785` `%827`

Keaton's word, `20261001`, seating the ruling below after it was drafted in conversation and checked
against the tree rather than against memory.

## What this corrects first

A conversation earlier the same day proposed a ruling about custody gates blocking the fusion
build's receipt. Reading `tools/fixtures/s/standing_equipment_run.sh` directly showed that ruling
had already been made and landed -- REDS `%756`'s neighbor `%374`, Keaton's word `20260904`: a
guard parked at a permanent custody gate (`rule_twin` at gate %7, the two `pond_enclosure` rows at
gate %5) no longer withholds the receipt. That repair is real and it stands.

**The actual, current block is different.** `standing-equipment-receipt.kyri` is still dated
`20260914.210448` because a full pass only writes a fresh receipt when every guard reads green or
gated -- never red (`standing_equipment_run.sh` lines 1761-1778). Eight guards have read genuinely
red, unchanged, for at least sixteen consecutive laps, measured against
`construction/standing-equipment-runs.kyri`'s own rows at `20261001.102053`:

```
standing_equipment_redleg   red
shim_reason                  red
query_wire_retention         red
ceiling_teeth                 red
ignored_walk                  red
rye_compiled_reach            red
falsifier_form_outcome        red
standing_equipment            red
```

As long as one of these eight reads red, no full pass closes clean, no fresh receipt writes, and
`--scoped` can never earn a basis -- so every one of the eight checkouts keeps paying the full
~370-guard cost on every lap. Checking `construction/REDS.md`: only three of the eight carry a
named row at all (`%827`, `%756`, `%785`); the other five have stood red for over two weeks with no
row ever booked, which the tree's own `reds-first` law says should not happen.

## Ruling one -- `%756`, the wire ceiling

`comlink/query_wire_retention_cost.rye` cannot hold an eight-hit answer in `max_wire_payload`'s
declared room; the derived ceiling reads 2 against a floor of 3. Three doors stood named and
unchosen: grow `max_wire_payload`, shrink `max_peer`/`max_bolt`/`max_path` to fit the existing
payload, or retire the measurement.

**Ruled: grow `max_wire_payload`.** The other two doors each cost a working capability (a smaller
peer/bolt/path ceiling, or a retired measurement) to repair a number; growing one wire ceiling costs
only the number itself. Comlink's owning lane sizes the exact new constant against
`response_head_bytes` and `max_hit_bytes` so `max_wire_hits >= 3` holds with room to spare, re-derives
`query_wire_retention_cost.rye`'s assertion, and reruns `query_wire_retention_witness.rish` to green.

**This sub-choice is the one place in this ruling built from a recommendation rather than a
reading Keaton confirmed word-for-word.** If a different door is wanted, say so and this line
alone reverses; nothing else in this document depends on which door `%756` takes.

## Ruling two -- `%785`, the ignored_walk count

`tools/fixtures/i/ignored_walk_scan.sh` counts its own control's planted sites inside its own
population: 13 of 48 `walks_tree` sites are the guard's own proof, which can never be repaired
without breaking the control that proves the guard works.

**Ruled: this is not a defect, and the ceiling is wrong rather than the count.** The guard's owning
lane either lowers the ceiling to match the population with the control excluded by name (35, not
48), or teaches the scan to exclude its own control's family the way the sibling census in
`tools/fixtures/c/control_in_population_scan.sh` already does for 32 of 39 comparable pairs. Either
repair clears the red; the row folds **CLOSED** once `ignored_walk_witness.rish` reads green on
metal.

## Ruling three -- a standing rule, so this does not happen again

**Any guard that answers red, unchanged, for more than three consecutive laps gets a named row in
`construction/REDS.md` that same lap, with all three fields.** Five of the eight guards blocking
this receipt went unbooked for over two weeks because a standing red that never changes stops
reading as news. The rule closes that gap structurally: a lap reading the cold run's output checks
each red against the ledger before moving on, and books whatever it finds missing.

This rule is **named here rather than seated in `.claude/rules/reds-first.md` or on the baton
itself**, because `construction/REDS.md` carries 184 bytes of headroom against its 65,536-byte
bound and `construction/ITINERARY.md` carries 207 against 40,960 -- neither can absorb a rule body
today. The next lap with ledger room folds this ruling's third clause into `reds-first.md` or the
baton proper; until then, this page is the ruling's record and a lap may act on it directly by
citation.

## What this unlocks, and what it does not yet reach

Once `%756` and `%785` close and the five unbooked reds are either fixed or booked-then-fixed, the
next full cold endurance run that reads zero red (gated is fine) writes a fresh
`standing-equipment-receipt.kyri`, and `--scoped` starts working on its very next invocation --
fleet-wide, on all eight checkouts, with no new code beyond the five guards' own repairs. No change
to the fusion build's own mechanism is needed; it has been correctly built and waiting since
`20260904`.

**This does not reach the REDS ledger's own capacity.** Booking the five unbooked reds needs room
this ledger does not currently have -- 184 bytes against rows that run 2,000 to 3,900 bytes apiece,
the same arithmetic `the-writer-sheds` already names for the ITINERARY card one room over. The
ledger's own fold is deadlocked (`pin_deadlocked=1` on zero foldable rows, since every open row
reads OPEN). **Closing `%756` or `%785` by the rulings above is itself the fold's way out**: a
BOOKED row closed to CLOSED on metal is foldable under the ledger's own law, which frees the room
the other five bookings need. The order matters: fix `%756` and `%785` first, fold them, then book
the remaining five into the room that frees.

## Discipline this ruling keeps

Nothing here crosses a custody gate. Growing a wire ceiling, re-deriving an assertion, adjusting a
scan's own ceiling, and booking a ledger row are each ordinary agent-doable repairs under the
already-accepted receipt contract and TAME guidance. No real data, money, key, or identity is
touched. The ruling is recorded here, in a checkable room, rather than only spoken, so a future lap
reads it rather than re-deriving it.

May the cheap pass run the moment it has earned the right to, and may every lap after this one spend
its cycles on what moved rather than on proving again what already held.

## Erratum -- ruling one took the shrink door

Ruling one chose to grow `max_wire_payload`. Reading the code showed that growth needs a larger
sealed datagram too, since `wire_capacity - off_cipher` already equals the 340-byte payload. Keaton
re-ruled the same day: shrink the wire's `max_path` from 64 to 57 and measure a two-hit answer.
REDS `%756` is repaired on metal and folded to its shelf as BOOKED. The ledger pin then stood at
63,095 of 65,536 bytes, so the five unbooked reds can take their rows. Rulings two and three stand.
