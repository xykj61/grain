# Recovered parked REDS draft

**Language:** EN
**Style:** Gauge, Meter
**Voice:** Kyri
**Status:** Recovery record -- an unpublished draft
**Room:** checkable -- source text recovered from Bakery's preserved stashes

The quoted draft below retains its original wording and local number. Upstream
had already assigned that number to another stamp. This page preserves the parked
record; its quotation adds no row to the published ledger. The original file name
keeps the older session log's citation reachable.

> # REDS -- one rule, two walks, and the comment that said otherwise
>
> **Language:** EN
> **Style:** Gauge, Meter setting
> **Voice:** Kyri
> **Status:** Shelf -- one folded row, immutable once written
> **Room:** checkable -- a ledger row, its repair proven from both sides on real git repositories
> **Folded:** `20260908.142728` from [`../REDS.md`](../REDS.md)
>
> **Born here rather than folded here**, for the reason its sibling
> [`REDS-ask-before-you-truncate-rows-641.md`](REDS-ask-before-you-truncate-rows-641.md) gives: the pin
> stands at `pin_headroom=24` with `pin_foldable_rows=0` and `pin_deadlocked=1`, so a row has nowhere
> in the ledger to land. Recorded in [`REDS-fold-recital.md`](REDS-fold-recital.md); **CLOSED**, so
> `shelf_open_rows` does not move.
>
> ---
>
> **REDS %642 (`20260908.142728`) -- one rule spelled in two walks, repaired in one, and a comment
> left saying the file now agreed.** *What went wrong:*
> `tools/fixtures/c/crushed_index_scan.sh` enumerates a declared room's members two ways -- a `deep`
> declaration walks every tracked file in the subtree, a `room` declaration takes the first path
> component of each tracked path. This tree's fold law puts testimony and deferred work in `date/`,
> `archive/` and `yonder/`, which are shelves rather than members: a room's index folds WITH its
> shelves rather than naming them. On `20260906` the deep walk learned that rule, and the comment
> placed above it said so in words that were not true -- *this line was the one place in this file that
> disagreed with it*. The `else` branch four lines below kept the elder rule the whole time. *What
> caught it:* `press/` is declared one level, and it folded its first day shelf on `20260907`. From
> that day `crushed_index` answered `index_unlisted=1`, `press/date has no row on
> docs-geode/press/README.md`, and reddened on every ship in the fleet -- and **a red costs the
> receipt**, so `roster_receipt_write=withheld_guard_red` and `--scoped` refuses without a basis on
> every tree at once. It was found by reading the run card after a truncated transcript hid the names
> of that pass's reds (`20260908.140846`), which is the only reason anybody read the guard's own line
> rather than its count. *What it taught:* **a rule spelled twice is a rule two branches may come to
> disagree about, and a comment claiming the disagreement is over is worth exactly what a reader can
> check.** The `else` branch now drops the same three room names, anchored whole rather than
> `(^|/)`-wrapped because a shallow member is a single path component and never holds a slash; the
> deep branch's comment is corrected to name both places. Four legs in
> `tools/fixtures/c/crushed_index_control.sh` plant a day shelf and an ordinary subdirectory in one
> pen room and read both: the shelf is not a member, the ordinary directory beside it still is, listing
> that one clears the count, and the verdict walks free with the shelf unlisted. Run against the elder
> scan from `HEAD` the same legs read `2` where they want `1`, so they bite rather than merely pass.
> `crushed_index` is GREEN on this tree. **CLOSED**
