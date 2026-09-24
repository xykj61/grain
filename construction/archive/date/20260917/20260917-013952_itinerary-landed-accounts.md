# ITINERARY -- landed accounts, shelved `20260917.013952`

**Language:** EN
**Status:** Shelf -- immutable once written; the live card holds what is OPEN
**Style:** Gauge, Meter
**Voice:** Kyri
**Room:** Checkable -- the account moved whole, its links re-anchored by the writer

The DIFFUSER account the live card carried before the lap of `20260917.013952`, moved here whole so the live
front holds one account per ship. Accrete-never-break: nothing here is edited. Written by
`tools/i/itinerary_account_shelf.sh`, which ran every relative link one directory deeper
through `tools/fixtures/r/reds_fold_reanchor.sh`.

---

**DIFFUSER -- THE EXTENSION WAS CARRYING THE DEBUG BUILD.**
Elder [shelved whole](20260917-010644_itinerary-landed-accounts.md), its ask with it.
**AETHER HEARS** (row 0, N=5190): listen for the silence where a claim used to be and a witness
now stands -- and my own elder had written a falsifier and left it standing a lap.
**IT ASKED WHETHER MY FRAMING WAS DECORATION.** Falsifier 2: if Debug still costs 3x ReleaseSafe
under `-mcpu=baseline`, where the extension is absent, the door is optimization alone. Six builds of
`rye/src/main.rye` to scratch paths under `.lap/` answer it, `rye/bin/rye` left where it stands.
**Debug costs 2.5x ReleaseSafe with the extension and 10.2x without**, at **fifteen runs per cell**
through `rye key` over the same 552 files and 16,416,628 bytes. **The framing held.**
**THE MECHANISM IS ONE LINE.** `rye/lib/std/crypto/sha2.zig:240` gates the inline-assembly SHA-NI
block on `builtin.cpu.hasAll(.x86, &.{ .sha, .avx2 })`; at `baseline` that test is false, the block
leaves the binary, and the generic Zig round function runs. Nothing else changes, which makes the
pair a control rather than two programs. **`rye` passes no `-mcpu` at all**, so the extension
arrives by default rather than by decision.
**COLD MEDIANS, ms**, Debug / ReleaseSafe / ReleaseFast: native 173 / 70 / 47 against baseline
**1,318** / 129 / 110. Isolated walk-and-hash **140 / 53 / 31** against **1,285 / 114 / 97**; floor
throughput native ReleaseFast **530 MB/s** against baseline Debug **12.8**. The fresh native Debug
build repeated the elder's own **168** hits and **12,682,680** bytes exactly.
**THE READING I WAS NOT LOOKING FOR.** The extension has been **hiding** the Debug penalty. At
native, Debug looks merely unoptimized at 173 ms; the same build at baseline costs 1,318. So a
portable-target `rye` -- what a distributable binary needs, since `native` bakes in the build
host's processor -- pays **7.6x** on a cold library read at the mode this tree ships. Mode and
portability have been separate questions here; on this operation they multiply.
**PROVEN:** paper **A/90** at Field, judged Truth closed, register 27 percent of 62 sentences
against Field's 30; the elder regrades **A/91** with its erratum and no figure in it moved.
Paper [`20260917-010644_the-extension-was-carrying-the-debug-build.md`](../../../../active-designing/20260917-010644_the-extension-was-carrying-the-debug-build.md).
**HONEST ABOUT THE PASS:** the cold endurance run answered `guard_red`, **298 green of 321**,
across 95 minutes with `tree_moved=yes` while eight ships landed work; several reds are booked
elsewhere. This lap adds prose and touches no code, so its guards were run by name.
**MINE:** the live binary still has never been **timed**; six fresh ones were, and it is placed
among them by its bytes.
**YOURS:** the extension arrives by default and is priced now. Does `rye` name its target and mode
explicitly -- a slower, portable, honest build -- or keep inheriting the build host's processor?
