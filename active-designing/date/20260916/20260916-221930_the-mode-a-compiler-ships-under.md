# The mode a compiler ships under

**Stamp:** `20260916.221930`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Design -- **checkable room**: every figure below is measured on this pier by the commands given, and the two readings that settle the question are reproducible in one command each
**Seat:** diffuser -- moonshots and research
**Claim:** `diffuser-rye-optimization-mode`, opened `20260916.221552` on `construction/fleet-claims.kyri`
**Elder:** [`20260916-220753_the-hash-runs-in-debug-rather-than-in-software.md`](20260916-220753_the-hash-runs-in-debug-rather-than-in-software.md) -- this paper settles its falsifiers 1 and 2 and raises its one Moderate sentence to High. The elder keeps every word it wrote.

The elder paper ended on an honest limit. It priced this tree's library hash at Debug speed,
named the bootstrap's absent `-O` flag as the cause, and then said plainly that it had never
rebuilt `rye` to confirm the flag's absence reaches the shipped binary -- because a `rye` build
takes tree-wide room locks and eight ships are sailing. That one link was inference.

It is measurement now, and the measurement needed no lock at all. `rye/src/main.rye` is a single
file importing nothing but `std`, so the same bridge `rye/bootstrap.sh` builds can be built to a
scratch path under `.lap/` while `rye/bin/rye` is left exactly where it stands.

## What the binary's own bytes say

Four builds of the current source, and the binary the fleet has been running since
`20260916 01:10`. Read `20260916.221930` on this pier, an 8-core AMD EPYC-Rome:

| Build | Bytes | SHA-NI opcode hits | Compile wall |
|---|---|---|---|
| **`rye/bin/rye`, live** | **12,512,760** | **168** | -- |
| fresh, no `-O` flag (Debug) | 12,682,680 | **168** | 1.47 s |
| `-O ReleaseSafe` | 3,887,928 | 58 | 28.6 s |
| `-O ReleaseFast` | 4,038,464 | 56 | 25.8 s |
| `-O ReleaseSmall` | 193,760 | 56 | 8.3 s |

The opcode reading counts the three SHA-NI instruction prefixes `0f38cb`, `0f38cc` and `0f38cd`
in the binary's own bytes, the same reading the elder paper took across five fleet binaries.

**The live binary and a fresh Debug build agree exactly: 168 hits against 168.** Every release
mode reads 56 to 58. Size agrees to within 1.4 percent, which is what two Debug builds of a source
that grew by two days of work should differ by. Two readings, one of them exact, and the release
modes sit nowhere near either.

**Inference:** `rye/bin/rye` is a Debug build. The elder paper's Moderate rises to **High**.

**The release modes fold rather than strip.** A binary reading 0 would have meant a target flag
somewhere removes the extension, and the software attribution the elder paper overturned would
have been right after all. Instead the count falls from 168 to 56 -- the same intrinsic sequence
emitted once where Debug emits it three times over, which is an inlining reading. SHA-NI compiles
in at every mode this tree can reach.

## What the program's own clock says

The elder paper timed a probe shaped like `rye`'s hash path. This one times `rye` itself, through
the `rye key` command bakery landed the same day, which runs the computation a build runs and
writes nothing. The workload is the identity of `lib/std` -- **552 files, 16,416,628 bytes**, the
elder paper's own tree, reached through a pen whose `lib` is a symlink to `rye/lib`.

Seven runs per binary, milliseconds, `20260916.221930`:

| | cold -- library record removed each run | warm -- record standing |
|---|---|---|
| Debug | 146 159 162 **172** 179 200 205 | 28 29 **32** 32 34 35 31 |
| ReleaseSafe | 55 55 55 **57** 58 59 59 | 10 10 11 **12** 13 14 18 |
| ReleaseFast | 29 30 31 **32** 33 34 37 | 9 10 11 **11** 12 15 16 |

Medians in bold. **Cold, Debug costs 3.0x ReleaseSafe and 5.4x ReleaseFast.**

**Subtracting the warm floor isolates the walk-and-hash portion**: Debug **140 ms**, ReleaseSafe
**45**, ReleaseFast **21**. The elder paper's probe, over the same bytes through a different
program, read 110, **45** and **20 to 21**. Two of the three land on the same millisecond, which is
the strongest thing either paper says: a probe shaped like the real path and the real path itself
answer the same number.

**Falsifier 1 passes, and wider than it was written.** The elder paper asked whether the hashing
portion falls by roughly a factor of two under ReleaseSafe. Measured, it falls by **3.1**. Door one
stands.

## The reading nobody asked for

**The mode lever reaches past hashing.** The warm column hashes no library at all -- it reads a
standing record, stats a toolchain, and compares two keys. Debug costs **32 ms** there against
ReleaseSafe's **12**, a factor of **2.7** on a path with no hash in it. So the elder paper's door
one is not a hashing door; it is a whole-program door that hashing happens to show most clearly.

## The card's open question, answered

The elder paper left one line for Keaton: a `rye` rebuilt at ReleaseSafe costs compile time and
binary size nobody here has measured. Both are measured above, and they move in opposite
directions.

**Binary size falls 3.26x** -- 12,682,680 bytes to 3,887,928. **Compile time rises 19.5x** -- 1.47
seconds to 28.6. For a compiler that rebuilds itself, that is the whole trade in two numbers: one
cold build a day against every hash, walk and parse the 371 rostered guards run.

**This paper recommends nothing.** Which mode a compiler ships under is a decision about what the
fleet's time is worth, and that is Keaton's word rather than a measurement's.

## Falsifiers for this paper

1. **The fingerprint is a resemblance rather than a receipt.** Rebuild `rye` from the exact commit
   that produced the live binary and compare byte for byte. A fresh Debug build of that source
   reading anything other than 168 hits would make the match coincidence, and the attribution
   would go back to inference.
2. **The ratio may be optimization-general rather than extension-specific.** Run the same three-mode
   comparison under `-mcpu=baseline`, where the elder paper measured 0 SHA-NI opcode bytes. If
   Debug still costs 3x ReleaseSafe there, the door is about optimization alone and this paper's
   framing around the extension is decoration.
3. **The subtraction assumes the warm floor is mode-invariant work.** Instrument `rye`'s key path
   with a split timer. If the halves fail to sum to the cold figure, the 140-45-21 isolation is
   wrong and only the cold column stands.
4. **Seven runs, one host, one hour, under a sailing fleet.** A quiet-pier rerun that moves the
   Debug median below 100 ms would mean peer load, rather than mode, carries the spread.

**Confidence.** **High** that the live binary is Debug -- two readings, one exact, and no release
mode within a factor of three on either. **High** that Debug costs roughly 3x ReleaseSafe on this
operation, measured in the real program and agreeing with an independent probe to the millisecond
on two of three modes. **Moderate** on the subtraction that isolates the hash portion, which
falsifier 3 settles.

## What this does not reach

**The live binary was never timed.** `rye key` landed after it was built, so the binary carrying
the 168 hits cannot answer for its own speed. The three timed binaries are all fresh, and the live
one is placed among them by its bytes rather than by its clock.

**Whether the pen's symlink distorts anything.** The hashed root resolves through a symlinked
`lib`, and the walk reads the same 552 files at the same 16,416,628 bytes with the same inodes.
A reading that depended on the path's own characters would differ; none here does.

**Whether ReleaseSafe is the right mode.** It keeps every runtime safety check, which is TAME's
order choosing for us, and it is 2.2x slower than ReleaseFast on the cold path. That gap lives in
the read loop rather than in the hash, exactly where the elder paper left it.

---

## Erratum `20260917.010644` -- falsifier 2 is settled, and it held

**No figure above moves.** This note records what a later lap measured, as testimony beside the
page rather than a rewrite of it.

Falsifier 2 asked whether the Debug-to-Release ratio is optimization-general, in which case this
page's framing around the SHA-NI extension would be decoration. Six builds of `rye/src/main.rye`
at `-mcpu=native` and `-mcpu=baseline` answer it: Debug costs **2.5x** ReleaseSafe with the
extension and **10.2x** without, over fifteen runs per cell. The ratio is specific to the
compile-time branch at `rye/lib/std/crypto/sha2.zig:240`, so the framing holds.

The native Debug build reproduced this page's own two readings exactly -- **168** SHA-NI opcode
hits and **12,682,680** bytes -- from a separate build on a separate lap.

Settled at [`20260917-010644_the-extension-was-carrying-the-debug-build.md`](20260917-010644_the-extension-was-carrying-the-debug-build.md),
which carries the full measurement and its own four falsifiers. Falsifiers 1, 3 and 4 above stand
as written.
