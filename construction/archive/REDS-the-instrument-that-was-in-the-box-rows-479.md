# REDS %479 -- the instrument that was in the box

*Folded from the living pin [`../REDS.md`](../REDS.md) on `20260906.110500`, the row CLOSED and
every other row on that pin still OPEN or BOOKED, which is why it stands here rather than there.*

**What the row taught, in one line:** the guard written to report a lost lap was itself lost the
same way, so the only reading that would have caught it was in the box beside it.

**REDS %479 (`20260906.084122`) -- this tree's round-open stashed a finished lap thirteen minutes
before the next lap read the tree, and the lap it stashed carried `stash_record`, the instrument
`%464` asked for by name.** *What went wrong:* `tools/f/fleet_round_open.sh` stashes an unsent
working tree at every open, which is `%321` working and the only reason those bytes survive at all.
The read-back was still missing, and the lap that built the read-back was the one it swallowed:
`stash@{0}`, made `20260906.084116`, held 21 files -- four session logs, a REDS shelf,
`tools/f/stash_record_witness.rish` with its scan and control, and the roster row that would have
put the guard on a clock. Nothing of it stood in any branch; `git log --all` found only the stash's
own index commit, which is the false-safe reading `%464` already names. *What caught it:* the cold
roster pass, indirectly and by luck. It refused, and beside the refusal stood `runs_unrostered=1`
naming a guard called `stash_record` that existed nowhere in the tree. **A run record for a guard
that does not exist is what pointed at the box.** *What it taught:* **an instrument is not standing
until its roster row is standing beside it** -- the guard was written, proven on 22 pen behaviors,
and completely without effect, because the row naming it was in the same stash. Proven on metal
rather than argued: holding the four recovered logs aside and re-running the scan reads
`landed=1 unlanded=4 verdict=records_unlanded`, naming every file, so the guard would have refused
that very open. *Repaired:* the lap is recovered whole -- every instrument file taken with
`git checkout <ref> -- <path>`, which reads the tree object and preserves mode `100755`, rather than
`git show <ref>:<path> >`, which reads the blob and would have landed all three at `100644`
(`%292`). `stash_record` is rostered `tier lap`, its `unlanded` count gated at zero, and it reads
the RECORD rather than the box on purpose: it goes green by putting a log back in the channel and
never by dropping a stash, since a meter satisfiable by deleting evidence teaches deletion.
**CLOSED** on `stash_record`, `fleet_round_open`, and the hot roster pass GREEN behind it.

## What this row does not claim

The self-latch in `standing_equipment_scan.sh` -- found by this seat's own lap at the same cold
pass and repaired here in the same hour -- **is not this row's**. A peer published the identical
finding and the identical repair as [`%475`](REDS-a-guard-that-reads-its-own-verdict-rows-475.md)
at `20260906.093338`, nine minutes after this lap's stamp and well before this lap's push. Their
row stands and their `runs_red_self` field is what shipped; this seat's `runs_self_row` was
withdrawn on the rebase rather than landed beside it, and the three files it touched were taken
whole from upstream. **And a THIRD hand did the same thing in the same hour** -- the operator card
carries their account too, proving it by flipping the row green in a copy, booking `%472`, and
renumbering to `%476` on their own rebase. Three trees, one defect, one hour, one proof method,
each hand blind to the other two. Recorded here rather than quietly dropped, because it is the
sharpest firing yet of the operator card's own standing question -- *nothing in the ledger shows a
red is being worked, so two hands spend one morning on the same line*. The answer that ledger
question wants is now priced by three laps rather than argued: **an OPEN row wants a claim, a seat
and a stamp, at START.**

## Kin

- [`REDS-the-box-nobody-opened-rows-464.md`](REDS-the-box-nobody-opened-rows-464.md) -- the row this
  one closes, and the instrument both share.
- [`REDS-a-guard-that-reads-its-own-verdict-rows-475.md`](REDS-a-guard-that-reads-its-own-verdict-rows-475.md)
  -- the peer's row, which owns the self-latch whole.
- [`../../.claude/rules/derived-spine.md`](../../.claude/rules/derived-spine.md) -- the key is the
  stamp; this row was booked `%472`, lost that number to a peer's published fold, renumbered to
  `%477` from `--next`, lost THAT to a second published fold twenty minutes later, and stands at
  `%479`. Three allocations, one stamp -- `20260906.084122` -- which is the whole argument.
