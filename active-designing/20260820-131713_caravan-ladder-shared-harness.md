# The Caravan Ladder's Carried Checks -- A Measured Design Call

**Stamp:** `20260820.131713`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Kyri
**Lens:** TAME -- safety first, performance second, the joy of the craft third
**Status:** Vision -- a design call surfaced with its measurement, awaiting Keaton's word. Nothing is cut by this document.
**Witness:** [`../tools/caravan_ladder_copy_witness.rish`](../tools/caravan_ladder_copy_witness.rish) over [`../tools/fixtures/caravan_ladder_copy_scan.sh`](../tools/fixtures/caravan_ladder_copy_scan.sh) -- GREEN on metal `20260820.131713`

---

## What Stands Today

The Caravan arc climbs beautifully. Eighty-two rungs sing GREEN in one voice, each rung importing the implementation of the rung beneath it and proving one new thing about a supervised run: a quarrel inherited, a debt met, a finding carried home, a reader's word read back. The imports are real reuse, and the arc's discipline -- prove every RED path on metal before any GREEN claim -- has held for the whole climb.

Beneath that climb, one number grows every lap.

## The Number, Measured

A rung's check functions are private. `fn check_heed()` in `suffice.rye` is the same bytes as `fn check_heed()` in `apprise.rye` and in `reopen.rye`, because a later rung has no way to *call* the check of the rung below it -- only to carry it forward. So each rung arrives holding a fresh copy of every check beneath it.

Measured on metal rather than recalled:

| Reading | Value |
|---|---|
| Rung modules on disk | **88** |
| Check functions across the ladder | **914** |
| Distinct check bodies | **277** |
| Bodies that are a byte-identical copy of one below | **637** |
| Lines those copies occupy | **46,014** |
| Lines in the whole ladder | **258,525** |

**Eighteen percent of the Caravan ladder is a byte-identical copy of a check that already stands in a rung below it**, and the share climbs with every rung: heed at 7,890 lines, suffice at 14,095, reopen at 14,609 -- about five hundred lines a lap, of which nearly all is carried rather than written.

The scan names its own failure shapes too. A corpus with no modules refuses; a corpus whose modules hold no checks refuses by name, since a zero nobody questions is a guess wearing a measurement's clothes (REDS %97); and growth past a named ceiling refuses, so the number can never quietly double while nobody is looking.

## Why This Is Worth a Design Call

The teaching in [`../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md`](../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md) names the shape exactly: the whole art is turning a multiplication into an **addition** -- a few checks here, a few there, and the earned right to trust the sum. The Caravan ladder already earns that right; what it has yet to do is stop paying for it twice. Eighty-two rungs times seventy-odd checks is the multiplication, written out longhand.

The cost is real and compounding in three honest ways. Each rung's module takes longer to build and longer to read. Each new check written into a rung is invisible to every rung below it, so an improvement lands once and is copied forward rather than shared. And a reader arriving at `reopen.rye` meets fourteen thousand lines where perhaps six hundred are about reopening.

The cost is also **bounded and non-urgent**. The imports are real, so this is accumulated self-test rather than duplicated logic; the suite sings every rung; nothing is wrong. This is a ratchet, in the tree's own sense -- something not yet uniform, which turns on touch and books nothing.

## Three Ways Forward

**A -- Make the checks public and call them.** The smallest move with the largest reach. A rung's checks become `pub fn`, and the rung above calls `below.check_heed()` rather than carrying its bytes. The measurement says the bodies are already byte-identical, so the fold is mechanical wherever they match. Roughly 46,000 lines leave the ladder, and each check thereafter lives in exactly one place, improving for every rung above it at once. The cost is a touch across eighty-two modules, which is why it wants Keaton's word rather than an autonomous sweep.

**B -- One shared harness module.** Lift every check into a `caravan/ladder_checks.rye` that each rung imports and runs against its own report. Cleaner as a destination, larger as a move, and it asks a design question A does not: what exactly is the contract between a harness and a rung's report? The forwarding accessors (`heed_of`, `endure_of`, and their forty-odd siblings) suggest that contract already exists in draft.

**C -- Carry on, watched.** Keep climbing and let the meter hold the line. The witness stands at a ceiling of 60,000 carried lines, which is roughly thirty more rungs of headroom at the current rate. The arc reaches its natural close, and the fold happens once, over a finished ladder, rather than mid-climb.

## The Recommendation

**A, then C's meter kept.** Making the checks public is the crux move here -- the hardest *solvable* problem whose answer opens the rest, and the one whose correctness the measurement has already established, since bodies that are byte-identical today cannot disagree tomorrow. It needs no new contract, no new module, and no new concept; it removes a copy the language was always willing to share. B remains the better destination and becomes easy once A has run, because a harness over public checks is a refactor rather than a rewrite. And the meter stays either way, since the class of drift it catches -- a growth surfaced once, remembered wrongly later -- is exactly what a loom is for.

Whichever way it goes, the arc keeps climbing. This document changes nothing on its own; it hands Keaton a number where a recollection stood.

## Related

Surfaced as a ratchet in the `20260820.130722` session log, [`../session-logs/20260820-130722_caravan-reopen-a-short-word-opens-the-matter.kyri`](../session-logs/20260820-130722_caravan-reopen-a-short-word-opens-the-matter.kyri). Read under the council rota beside [`../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md`](../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md). The arc itself is the Lindy-priority Microkernel Target double-seat, [`20260816-205859_double-seat-expansion-eight-seasons.md`](20260816-205859_double-seat-expansion-eight-seasons.md).
