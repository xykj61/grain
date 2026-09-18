# REDS -- one assert rather than an if

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a ledger row, its reading proven by a control on real git repositories
**Folded:** `20260917.205200` from [`../REDS.md`](../REDS.md)

One row, folded to make room on a pin already at its bound the moment this row's own fix landed
unreported.

It teaches that a witness's own comment describing a fix in past tense is a claim, not a closure --
the ledger row stayed OPEN for two hours after the repair (`e4c6f40b7`) and its wider meter both
landed and read GREEN, because nothing told the pin. A row closes when a hand reads the witness and
says so, not when a nearby comment implies it.

**REDS %806 (`20260917.030908`) -- OPEN -- a witness turned its control's honest machine-fact skip into a red, because `else` binds to the `if` rather than to the `assert`.** *What went wrong:* `tools/r/ryekey_witness.rish:55` reads `if (control.out contains "ryekey_verdict=green") then assert control.out contains "legs=44" else "..."`. Rishi binds that trailing `else` to the **`if`**, so the false branch's statement is a bare string literal and the run refuses with `rishi: line 55: UnknownStatement`. The refusal fires **only when the condition is false** -- proven both ways in a pen: the same line with `control` bound to a run emitting `ryekey_verdict=green` walks free, and with one emitting `ryekey_verdict=machine_fact` refuses. So the guard is green on any pier whose `rye` binary stands with its source and red on every pier where it does not, which is exactly the case its own control declares is **not a fault**: *SKIPPED: machine fact -- the binary declares `20260914.031449` and its source declares `20260916.231500` ... nothing in the tree is wrong.* *What caught it:* the diffuser seat's hot roster pass on `20260917`, which read `ryekey red 0s 83ms` beside 170 green and pointed at an evidence file, `construction/standing-equipment-reds/ryekey.txt`, that the refusal was too early to write. *What it taught:* **a conditional gate is proven in the branch its author ran and unread in the other, and a grammar with a dangling `else` decides which.** The form is not itself banned -- 41 `then assert` statements stand across `tools/`, 13 of them carrying `contains`, and each is correct wherever its condition holds. What no guard reads is the pairing: an `if` whose false branch swallows an `assert`'s message. *What is owed:* the repair belongs to the lane owning `ryekey`, where it landed in `ace5bca93` raising the leg count to 44. Two doors -- express the leg with no dangling `else`, or teach Rishi to bind `else` to the nearer `assert` and prove the 41 standing sites unmoved. A **meter over the pairing** is the wider lap, since this fires only on a pier in the unlucky state and every other ship reads green. **CLOSED** -- `e4c6f40b7` took the first door, splitting the leg into `?|` over two conditions so both branches keep their message, and built the wider meter as `tools/fixtures/r/rish_dangling_else_scan.sh` under `tools/r/rish_dangling_else_witness.rish`, rostered at `tier cadence`. Both witnesses read GREEN on metal: the dangling-else guard proves 37 legs including this exact site's mutation, and `ryekey` itself last ran green at `20260917.165150`.

