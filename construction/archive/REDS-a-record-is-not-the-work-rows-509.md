# A record is not the work -- parked draft

**Language:** EN
**Status:** Recovered historical record -- checkable
**Style:** Gauge, Meter
**Voice:** Kyri
**Recovered:** `20260909.120503`
**Source stash:** `ce363e5093bad6d9024d25ffd859a69faab68c8a`
**Source blob:** `1eece792453c4174773e6c3869acb2aef4cc02d5`

This draft records the stash reader before the later
[published work-path repair](REDS-a-guard-that-reads-a-proxy-rows-510.md).
That row is the current repair record; the quoted draft keeps its earlier findings.

## Saved draft -- historical claims

The quotation preserves the parked page. Its row numbers were draft allocations,
and its claims of completion describe that parked lap, not the current tree.

> # REDS shelf -- a record is not the work
>
> **Language:** EN
> **Style:** Gauge, Meter setting (see [`../../context/GAUGE_STYLE.md`](../../context/GAUGE_STYLE.md))
> **Voice:** Kyri
> **Status:** Shelf -- immutable once written; the living pin is [`../REDS.md`](../REDS.md)
>
> One row, and it is the third reading of one box. `%464` built a guard because the round open filled
> a dead-letter box nobody opened. `%507` widened it because the round open fills **two** drawers and
> one was certifying the other empty. This row is the third: the guard reads a **session log**, since
> every lap writes one, and a lap whose log lands while its code does not reads `verdict=ok` over a
> box that still holds the work.
>
> The lesson keeps past all three: **a proxy is a claim about a correlation, and the day it parts from
> the thing it stands for is the day it reports most confidently.**
>
> ---
>
> **REDS %509 (`20260906.180419`) -- the guard built to open the dead-letter box reads the reasoning drawer, so a lap whose log landed and whose code did not turns it green over the work.** *What went wrong:* `tools/fixtures/f/stash_record_scan.sh` counts one thing -- a path under `session-logs/` carrying a one-clock stamp -- and asks whether the worktree or a reader-reachable ref carries it. The session log is the right proxy for *did this lap's reasoning get out*, because every lap writes one and no other file is that reliable. It is the wrong proxy for *did this lap's work get out*, and the two part exactly when a lap's log ships without its code: then `unlanded=0 parked=0 verdict=ok` stands over a box holding files nothing else has. *What caught it:* a fire-row lap reading its own stopped line. This tree's `stash@{0}` was correctly named `unlanded`, so the guard worked; the question that followed it was what the reading would say once that one record landed. It says `ok`. *The measurement, `20260906.180000`:* **four files in three round-open stashes, 258 lines together, and not one of them raises `records` by one** -- three stashes whose every record reads `landed`, so the reading said nothing about them at all. `stash@{6}` holds `tools/fixtures/a/agent_jail_control.sh` (141 lines) and `tools/fixtures/m/mount_namespace_probe.sh` (44) -- the pen and the probe that authorize `%446`'s skip on a positively read absence -- while `tools/ag/agent_jail_witness.sh`, the guard those two were written for, **had already landed without them**. That stash's own session log reads `landed:worktree`, so the scan said nothing about the stash at all. `stash@{1}` and `stash@{5}` each hold a construction shelf on no ref. *The live reading is `orphans=5` rather than 4*, and the fifth is the honest false positive the design names: this hand's own shelf, parked as `...rows-506.md` and landed as `...rows-508.md`, which is a file landed under a different NAME. *What it taught:* **a proxy reports most confidently on the day it parts from its subject.** The record reading was not wrong and is not narrowed; what it lacked was any statement of what it does not reach, which is `%505`'s own lesson (*a guard's reach is a claim, and an unprinted reach is claimed by implication*) arriving one guard later. *Repaired inside the landed guard rather than beside it,* since a second meter over one box is how two meters come to disagree: the scan walks every **non-record** path a stash holds and asks it the same question by the same probe. `orphans` is what nothing outside the box carries; `unread` is what something does carry, whose stashed **edit** no path probe can judge, printed rather than left silent; `paths` is their sum, and the two sets are disjoint so no file is counted twice under two names. `tools/f/fleet_round_open.sh` reads both drawers out of **one** scan run, so naming the second costs the open nothing. *Reported rather than gated, for three reasons named in the scan's own head:* a COUNT does not travel between checkouts the way `unlanded=0` does, so a ceiling measured here would red a ship for merely parking more work; a file landed under a different **name** reads as an orphan, and so does an experiment a hand abandoned on purpose; and clearing the standing four is a lap rather than a flag flip. *Proven:* the pen grew **35 legs to 51**, the new ones in their own repository so every number is absolute -- one stash holding all three shapes at once (a new file, an edit to a tracked file, a record), the partition asserted on real numbers, the record landed **alone** to show `verdict=ok` standing over `orphans=1`, then the file landed to show the orphan fall to zero with the stash still standing. Run against the elder scan the same control reads **41 pass, 10 fail**, so the widening is proven by what it can tell apart rather than asserted in prose. **BOOKED** *(the blind spot is repaired and the reading is wired; landing the four standing orphans -- `%446`'s pen first -- is a booked lap).*
