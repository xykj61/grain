# ITINERARY -- landed accounts, shelved `20260917.020034`

**Language:** EN
**Status:** Shelf -- immutable once written; the live card holds what is OPEN
**Style:** Gauge, Meter
**Voice:** Kyri
**Room:** Checkable -- the account moved whole, its links re-anchored by the writer

The DIFFUSER account the live card carried before the lap of `20260917.020034`, moved here whole so the live
front holds one account per ship. Accrete-never-break: nothing here is edited. Written by
`tools/i/itinerary_account_shelf.sh`, which ran every relative link one directory deeper
through `tools/fixtures/r/reds_fold_reanchor.sh`.

---

**DIFFUSER -- ONE BINARY CAN CARRY BOTH PATHS.**
Elder [shelved whole](20260917-013952_itinerary-landed-accounts.md); its ask is answered
below by a third door it did not name.
**AIR FEELS** (row 1, N=5216): press a claimed boundary and feel whether the hand passes through.
**THE BOUNDARY.** My own elder closed on an either-or -- a portable `rye` pays for portability, or a
fast `rye` inherits the build host's processor. Beneath it sits a claim: a binary holds one code path
per feature, chosen when it compiles.
**THE HAND PASSES THROUGH, IN ONE EXPRESSION.** `rye/lib/std/crypto/sha2.zig:240` gates the SHA-NI
block inside `Sha2x32.round` on a comptime call to `builtin.cpu.hasAll`. Three scratch copies under
`.lap/dispatch/`, gitignored and never committed, replace that test with `true`, with `false`, and
with a `pub var` in a `cpu_flags.zig` module set once at startup from a `cpuid` leaf 7 inline-asm
probe reading EBX bits 29 and 5.
**THE ASSEMBLER GATES INLINE ASSEMBLY ON NOTHING.** At `-mcpu=baseline` the mnemonics compile,
`vpalignr` included, and fifty-six SHA-NI opcodes stand in each accelerated binary against zero in
the generic one, read with `xxd`. Four builds print one digest over 256 MiB.
**MEASURED** with 1 MiB hashed sixty-four times so the fill is noise, five binaries interleaved,
eleven rounds, medians in ms: dispatch at baseline **73**, forced at baseline 84, forced at
**native 71**, generic at baseline 402, and that same dispatch binary with detection skipped 378.
**The accelerated path runs the same speed whichever target built it**, the generic path costs
**5.5x**, and the per-block branch over 1,048,576 blocks reads below the noise floor. Carrying both
paths costs **3,992 bytes**.
**HONEST ABOUT THE PASS:** load average 38 throughout, so minima sit far below medians and the
argument leans on interleaving and ratios rather than absolute throughput. An earlier design hashing
256 MiB once was dropped rather than reported -- its page-fault fill moved 142 ms between targets,
larger than the effect under test.
**SCOPE:** `builtin.cpu.has` stands 37 times across 15 files of `rye/lib/std`, nine of them crypto,
each one a place where `-mcpu` decides which code exists. FREE; run the grep.
Paper [`20260917-013952_one-binary-both-paths.md`](../../active-designing/20260917-013952_one-binary-both-paths.md), **A/93** at Field, register 16 percent of 73 sentences.
**MINE:** the transfer to `rye key` is projected rather than measured -- 50 to 60 ms at baseline with
dispatch against the elder's 110 -- and the falsifier is a reading above 70.
**YOURS:** the third door. Should `rye` build at `-mcpu=baseline` and dispatch at runtime, one binary
that runs on a pre-2017 machine and keeps the extension on a new one -- and is patching a vendored
`rye/lib/std` a fork decision you want opened?
