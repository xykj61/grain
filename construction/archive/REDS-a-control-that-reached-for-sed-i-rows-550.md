# REDS -- row %550, folded from the living pin

**Folded:** `20260907.100235` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*A control reached for `sed -i`, the one in-place spelling no two hosts run alike, and it reddened
a fleet-wide guard for six hours -- because a red guard withholds the roster receipt, so every
ship pays a full cold pass while the one-line fault stands.*

The row stands here exactly as it was written. A closed row leaves the living pin so the pin stays
the length a reader will actually read; the lesson travels forward in the portable `sed_inplace`
helper the repair reached for -- `tools/fixtures/s/shell_portable.sh` -- and the row itself stays
one click away.

**REDS %550 (`20260907.075500`) -- a control I wrote reached for `sed -i`, the one in-place spelling no two hosts run alike, and it reddened a fleet-wide guard for six hours.** *What went wrong:* `tools/fixtures/s/seat_prompt_figure_control.sh` landed at `01:43` (`ffc82f50d`) with `sed -i 's/It holds 10 Rye modules\.//' "$(prompt_of "$p" alpha)"` at line 91. GNU `sed -i` takes no argument; BSD `sed -i` REQUIRES a backup suffix and reads the next word as one, so the two spellings have no overlap and `tools/fixtures/s/shell_dialect_scan.sh` holds `sed_in_place_flag` at a ceiling of **zero**. The tree already keeps the portable form -- `sed_inplace` in `tools/fixtures/s/shell_portable.sh`, which writes a temporary and copies back through the original inode, keeping the mode the repository tracks -- and the control reached past it. *What caught it:* this pier's cold roster pass at `20260907.073459`, `verdict=over_sed_i_ceiling`, `gated_sed_i_sites=1` against a ceiling of 0, **905 seconds** after the pass opened -- and `shell_dialect` itself runs in **0s**. *And the cost is not one guard's red:* a red guard withholds the roster receipt, so `--scoped` refuses and every ship pays a FULL cold pass; the red stood **five hours and fifty-one minutes** across a fleet of eight. *What it taught:* **a guard that reads every file in the tree is a guard the lap writing a new file never thinks to run.** My own witness was GREEN and stayed GREEN -- `seat_prompt_figure` proves what its scan reads, and portability is a property no single-host run can see, so a witness passing says nothing about the dialect its own fixture speaks. The cheap gates that read EVERY file -- dialect, ASCII, exec bit, shared pen -- are the ones a file-adding lap owes a run before the send, and the dialect scan costs zero seconds against the 905 it takes to learn the same fact from a full pass. *Repaired (`20260907.075500`):* the control sources `shell_portable.sh` and calls `sed_inplace`, with the reason written where the line is; `shell_dialect` GREEN, `seat_prompt_figure` GREEN at 30 behaviors, `gated_sed_i_sites=0`. **CLOSED.**
