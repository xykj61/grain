# The Caravan Ladder's Carried Checks -- A Measured Design Call

**Stamp:** `20260820.131713`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Kyri
**Lens:** TAME -- safety first, performance second, the joy of the craft third
**Status:** Landed -- **A ran** on Keaton's word `20260820.142246`, and **B ran** on his word `20260820.162747`; see the two addenda at the foot. The body below stands exactly as it was written, before either word came.
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

---

## Addendum -- A ran (`20260820.142246`)

Keaton's word came, approving every standing recommendation including this one. **A landed.** Every check in the Caravan ladder is `pub` now, and a rung whose check is byte-for-byte the rung below's runs it there rather than keeping a second copy.

**What the fold moved.** 523 check bodies fold, 39,962 lines leave the ladder, and the arc falls from 289,303 lines to 249,341 -- `recount`, the top rung, from 15,664 to 13,113. Measured against today's ladder rather than the 88-module reading in the body above: the carry stood at **779 copied bodies over 54,612 lines** before the fold and stands at **256 over 12,035** after, a little over a fifth of what it was, with the per-rung growth falling from **4,383 lines a rung to 1,637**.

**What the fold refused to move, and why.** The first cut was bolder -- it folded every byte-identical body whose whole call subtree was also carried -- and the cold-start discipline REDS %92 seated caught it within the hour. Two rules came out of that, and both are honest limits rather than shortfalls:

- **A check that reaches the wire is never run in the rung below.** The bodies match byte for byte, yet each rung keeps its notes in its own directory (`caravan/.apprises` beside `caravan/.redresses`), so the rung below would provision *its* wire and leave this rung's cold. The bolder cut passed on a warm tree and went RED the moment the choir cleared the stores -- `NoteUnavailable`, a debt that could not be seated at all, exactly the failure REDS %92 exists to surface.
- **A check whose tail chains into a check this rung invented stays home.** The rung below has never heard of the check it would chain to, so running the body there would silently end the chain early and skip everything this rung added -- which is how the first cut lost `check_apprise_wire` without a single compiler complaint.

Both residues are precisely what **B** would take: a harness that runs a rung's checks against *its own* report and *its own* wire, with the chain expressed as a list rather than a tail call, has no such limit. B is a refactor now rather than a rewrite, which is what A was for.

**What did not change.** Nothing observable. Every rung of the grievance arc from `appraise` to `recount` was built twice -- folded and pristine -- and run against the same wire: **28 rungs, the same output lines, every one of them** -- only the order in which three concurrent dependents print interleaves, run to run, in the pristine build exactly as in the folded one. Every check that ran before still runs, in the same order, printing the same words. The choir sings all 85 rungs GREEN from a cold tree.

**The meter changed jobs.** It began as a ratchet meter over a number nobody was watching; it is now the wall that keeps the fold folded. The ceiling stands at **22,000** against a standing of 12,035 -- about six rungs of headroom at the residue's measured rate, close enough that the number means something, where 60,000 over a folded ladder would have meant nothing for years. The witness also counts the 523 folded checks off the ladder itself, so a tree that quietly carried the bodies again would go RED whatever the prose said.

Session log: [`../session-logs/20260820-143646_caravan-ladder-fold.kyri`](../session-logs/20260820-143646_caravan-ladder-fold.kyri).

---

## Addendum -- B ran (`20260820.162747`)

Keaton's word came at the ladder-copy checkpoint, and it opened **B**. The
harness is [`../caravan/ladder_checks.rye`](../caravan/ladder_checks.rye), and
its whole contract is one word: **`rung`**. A lifted check takes the rung as a
comptime parameter and reaches every helper through it, so one body runs against
whichever rung handed itself in -- that rung's own report, its own helpers, its
own wire. A rung passes `@This()` and keeps a three-line call where a hundred
lines of copy stood.

**Both residues fell.** The wire residue falls because the harness never opens a
store of its own: it calls `rung.seat_note(...)`, so the note lands in the
directory of the rung that called, and the cold-start discipline REDS %92 stays
satisfied by construction rather than by care. The chain residue falls because
every check a lifted body calls re-enters the rung -- `rung.check_reopen_refusals()`,
never a harness-local jump -- so a rung whose variant of a chained check differs
from the lifted one keeps its own, and a rung that folded that link to the rung
below keeps that. The chain is a list of re-entries rather than a tail that ends
somewhere else, which is exactly what the A addendum said B would need.

**What the fold moved.** 57 bodies lift across 30 rungs; 438 harness calls stand.
The carry falls from **17,997 lines to 1,952** -- a ninth of what it was, and what
remains is the calls themselves rather than any check's body. The ladder falls
from 292,417 lines to 276,843, with the harness holding 2,916 of them. Six helper
names became public in the rungs that carry them -- `inherited_debt`,
`inherited_matter`, `seat_note`, `standing_address`, `standing_forum`,
`written_queue` -- 74 declarations in all, the same small act A performed on the
checks themselves.

**What did not change.** Nothing observable. All 30 touched rungs were built
twice -- pristine and folded -- and run from a cold tree against the same board
declaration: **every rung printed the same lines, all thirty**. The only motion
is where three concurrent dependents interleave, and that was proven to be the
run rather than the fold by running the *pristine* build twice and watching the
same lines trade places. The choir sings every rung GREEN.

**A limit named rather than rounded away.** Each harness body is the pre-fold
body verbatim, with `rung.` written before the symbols it reaches through. That
is deliberate: it is what makes the parity claim a measurement rather than a
reading. So the lifted bodies carry no new contract asserts this lap -- the TAME
SLC touch that adds them belongs to a round that can prove them one at a time,
rather than to the round whose whole evidence is that nothing changed.

**The meter moved with the carry.** The ceiling falls from 22,000 to **4,000**
against a standing of 1,952 -- about four rungs of headroom, close enough that
the number still means something on the lap it moves. The witness now counts both
folds off the ladder itself: 640 checks running in the rung that owns them, and
438 running in the harness against the rung that called them. A tree that quietly
carried the bodies again would go RED whatever the prose said.

Session log: [`../session-logs/20260820-162747_caravan-ladder-harness.kyri`](../session-logs/20260820-162747_caravan-ladder-harness.kyri).
