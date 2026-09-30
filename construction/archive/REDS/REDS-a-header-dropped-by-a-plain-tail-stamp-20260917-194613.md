# REDS shelf -- a header dropped by a plain tail

**Language:** EN
**Status:** Archive -- one closed, stamp-cited REDS row shed from `construction/REDS.md` under the
writer-sheds rule, to clear headroom for a fresh row while the pin's numbered rows sat all **OPEN**
and unfoldable by the automated tool (`tools/fixtures/r/reds_fold.sh` matches only `**REDS %<N> `).
The row carries no shared `%N` -- it stayed local, cited by stamp per
[`derived-spine`](../../../.claude/rules/derived-spine.md) rule 4 -- so this shelf was written by
hand, following the same shape the tool writes.

---

*Row `20260917.194613` folded here on `20260929.234000`, **CLOSED** -- a bare `tail -n 200` dropped a guard's own header, and the ceiling read stale for want of it.*

**REDS (`20260917.194613`) -- a bare `tail -n 200` dropped a guard's own header, and the ceiling read stale for want of it.** *What went wrong:* [`tools/fixtures/s/standing_equipment_run.sh`](../../../tools/fixtures/s/standing_equipment_run.sh) captured every red guard's evidence with `tail -n 200 "$pen/out.$$" > evidence.txt`, and `rye_compiled_reach`'s own 812-line answer opens with three header lines -- `paths=1994 bodies=1761 ceiling=18` -- then 791 lines of `uncompiled ...`, then `verdict=over_ceiling`. A plain tail keeps the last 200 lines: the tail of the list and the verdict, never the header that gives the list its scale, so the roster's stored evidence for this guard carried no ceiling, no bodies count, and no paths count at all. *What caught it:* a lap reading `construction/standing-equipment-reds/rye_compiled_reach.txt` on disk and finding a bare list with nothing above it, then running the guard directly and counting 812 lines against the 200 kept. *What it taught:* most guards' full answers already fit inside 200 lines, so a bare tail is silently correct on nearly every roster row and silently wrong on the rare long one -- which is why the fault stood unnoticed since the evidence room was built. *Repaired:* `capture_evidence` in [`tools/fixtures/s/shell_portable.sh`](../../../tools/fixtures/s/shell_portable.sh) keeps a 40-line head, an explicit `... N lines omitted ...` count, and a 159-line tail inside the same ~200-line bound; the runner's one call site now reaches it. Proven on the real guard's own 812-line answer (header and verdict both kept, 200 lines total) and by six planted legs in [`tools/fixtures/s/shell_portable_control.sh`](../../../tools/fixtures/s/shell_portable_control.sh), including the elder bare tail run against the same fixture to show it drops the header the new helper keeps. **CLOSED** -- both witnesses GREEN on metal.
