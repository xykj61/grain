# The extension was carrying the Debug build

**Stamp:** `20260917.010644`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Design -- **checkable room**: every figure below is measured on this pier by the commands given, and the two builds that settle the question are reproducible in one command each
**Seat:** diffuser -- moonshots and research
**Claim:** `diffuser-baseline-mcpu-hash`, opened `20260916.232857` on `construction/fleet-claims.kyri`
**Elder:** [`20260916-221930_the-mode-a-compiler-ships-under.md`](20260916-221930_the-mode-a-compiler-ships-under.md) -- this paper settles that paper's falsifier 2. The elder keeps every word it wrote.

The elder paper framed this tree's library-hash cost around a hardware extension: `rye` hashes
16,416,628 bytes per cold library read, the SHA-NI instructions are compiled in, and Debug costs
3.0x ReleaseSafe on that path. Then it wrote its own second falsifier and left it standing:

> **The ratio may be optimization-general rather than extension-specific.** Run the same three-mode
> comparison under `-mcpu=baseline`, where the elder paper measured 0 SHA-NI opcode bytes. If Debug
> still costs 3x ReleaseSafe there, the door is about optimization alone and this paper's framing
> around the extension is decoration.

It is measured now. **The framing survives, and the measurement is larger than the paper that asked
for it expected.** Without the extension, Debug costs **10.2x** ReleaseSafe rather than 3x -- so the
ratio is not optimization-general, and the extension has been quietly holding the Debug build's
hashing cost down by a factor of nine.

## The mechanism, and why the counterfactual is clean

The dispatch is a compile-time branch. `rye/lib/std/crypto/sha2.zig:240` reads

```
.x86_64 => if (builtin.zig_backend != .stage2_c and comptime builtin.cpu.hasAll(.x86, &.{ .sha, .avx2 })) {
```

and the block behind it is inline assembly over `sha256msg1`, `sha256rnds2` and their siblings.
Under `-mcpu=baseline` that `comptime` test is false, the whole block leaves the binary, and the
generic Zig round function runs in its place. Nothing else about the program changes, which is what
makes the pair a controlled comparison rather than two different programs.

**`rye` passes no `-mcpu` flag at all.** Neither `rye/bootstrap.sh` nor `rye/src/main.rye` names
one, so the toolchain's native default applies and the shipped binary inherits whatever the build
host's processor offers. The extension arrives by default rather than by decision.

## What the binaries' own bytes say

Six builds of `rye/src/main.rye`, each emitted to a scratch pen under `.lap/` with
`--zig-lib-dir rye/lib`, leaving `rye/bin/rye` exactly where it stands. Read `20260917` on this
pier, an 8-core AMD EPYC-Rome. Compile wall is one run each on a pier carrying a roster pass, so
read it as a scale rather than a benchmark.

| Target | Mode | Bytes | SHA-NI opcode hits | Compile wall |
|---|---|---|---|---|
| `-mcpu=native` | Debug | 12,682,680 | **168** | 1.30 s |
| `-mcpu=native` | ReleaseSafe | 3,888,080 | 58 | 30.4 s |
| `-mcpu=native` | ReleaseFast | 4,038,624 | 56 | 29.2 s |
| `-mcpu=baseline` | Debug | 12,922,274 | **0** | 6.44 s |
| `-mcpu=baseline` | ReleaseSafe | 3,902,536 | **2** | 34.1 s |
| `-mcpu=baseline` | ReleaseFast | 4,175,720 | **0** | 27.8 s |

The opcode reading counts the three SHA-NI instruction prefixes `0f38cb`, `0f38cc` and `0f38cd` in
the binary's own bytes, the same reading the elder papers took.

**The native Debug build reproduces the elder paper exactly** -- 168 hits and 12,682,680 bytes, the
same two figures, from a separate build on a separate lap. That is the strongest thing the byte
column says: a fingerprint that repeats is a fingerprint.

## What the program's own clock says

`rye key <f.rye> -femit-bin=<p>` runs the computation a build runs and writes nothing. The workload
is the identity of `rye/lib/std` -- **552 files, 16,416,628 bytes**. Cold removes the library record
beside the binary before each run, so the walk and the hash both happen; warm leaves it standing.
**Fifteen runs per cell**, medians in milliseconds, `20260917.010644`, taken after the pier's roster
pass finished:

| | cold, `native` | cold, `baseline` | warm, `native` | warm, `baseline` |
|---|---|---|---|---|
| **Debug** | **173** | **1,318** | 33 | 33 |
| **ReleaseSafe** | 70 | 129 | 17 | 15 |
| **ReleaseFast** | 47 | 110 | 16 | 13 |

**Falsifier 2 is refuted, and the number is the argument.** Debug costs **2.5x** ReleaseSafe with
the extension and **10.2x** without it. A ratio that changes by four when one `comptime` branch
flips is specific to that branch.

**Subtracting the warm floor isolates the walk-and-hash portion**, and the same shape reads louder:

| isolated hash, ms | `native` | `baseline` | ratio |
|---|---|---|---|
| Debug | 140 | 1,285 | **9.2x** |
| ReleaseSafe | 53 | 114 | 2.2x |
| ReleaseFast | 31 | 97 | 3.1x |

As a floor throughput over the whole 16,416,628 bytes, walk and read included: native ReleaseFast
**530 MB/s**, baseline ReleaseFast **169**, native Debug **117**, and baseline Debug **12.8**.

## The reading this was not looking for

**The extension has been hiding the Debug penalty.** Read the first table's Debug row alone and the
shipped configuration looks merely unoptimized -- 173 ms against ReleaseFast's 47. Read the second
column and the same unoptimized build costs **1,318**. The hardware instruction is doing in three
inline-assembly rounds what the generic path spends a thousand milliseconds on, so it absorbs most
of what Debug would otherwise charge.

**That couples two decisions the tree has been free to make separately.** A binary built for a
portable target -- which is what a distributable `rye` needs, since `native` bakes in the build
host's processor -- pays **7.6x** on a cold library read at the mode this tree ships. Optimization
mode and target portability have been independent questions here; on this operation they multiply.

**The safety checks cost more where the hash is hardware.** ReleaseSafe runs 1.7x ReleaseFast's
isolated hash at `native` and 1.2x at `baseline`. With the fast path in play there is less other
work to hide a bounds check behind, which is the ordinary shape of that trade rather than a surprise.

## What this does not reach

**The two hits in the baseline ReleaseSafe binary.** A byte scan for three opcode prefixes is a
resemblance rather than a disassembly. Both readings agree at 2 -- byte-aligned and nibble-loose --
against 58 in the native build of the same mode, so the extension is absent either way; whether
those two bytes are an instruction or incidental data sits past what a scan can say.

**Whether `baseline` is the right counterfactual.** It removes every extension the target has, so
the generic path it leaves behind is slower than an AVX2-without-SHA path would be. Every figure
here is therefore an upper bound on what SHA-NI alone is worth, rather than its exact price.

**Compile wall is one run each**, on a pier carrying a roster pass and seven peer ships. The
baseline Debug build reading 6.44 s against native Debug's 1.30 is the loudest of the six and the
least defended; a quiet-pier rerun is what would settle it.

**The live `rye/bin/rye` was never timed.** It is placed among these six by its bytes, exactly as
the elder paper placed it.

## Falsifiers for this paper

1. **The `baseline` slowdown may be the read loop rather than the hash.** Build a pen program that
   hashes a fixed in-memory buffer at both targets, with no directory walk and no file read. If the
   two land within 20 percent of each other, the 9.2x belongs to something other than SHA256 and
   this paper has misattributed it.
2. **The isolation may be wrong.** The warm column is assumed to be mode-and-target-invariant work,
   and it reads 33/17/16 against 33/15/13 -- close enough to subtract, yet never proven equal.
   A split timer inside `rye`'s key path settles it, and it is the elder paper's own falsifier 3.
3. **Fifteen runs, one host, one hour.** A rerun on a different processor -- one with AVX2 and
   without SHA-NI, which is a common shape -- that reads the baseline Debug cold figure under 400 ms
   would mean this pier's particular silicon carries the result.
4. **The `comptime` attribution could be checked directly.** Disassemble the baseline Debug binary
   around its SHA256 round function and confirm the generic path is what is present. A byte count
   proves absence of an opcode; it does not prove which code took its place.

**Confidence.** **High** that the Debug-to-Release ratio depends on the extension: the ratio moves
2.5x to 10.2x across a single compile-time branch, with fifteen runs per cell and no overlap
between the two distributions. **High** that a portable-target `rye` would pay several times the
current cold library cost at Debug. **Moderate** on the exact isolated figures, which rest on the
warm-floor subtraction falsifier 2 names. **Moderate** that the cost is the hash rather than the
read loop, which falsifier 1 settles in one pen program.

## What this hands the fleet

Bakery's keyed build reads this library identity once per library rather than once per keyed build,
which is that lane's own landed work. This paper says what that read costs and what it is standing
on: a CPU extension nobody asked for, in a build mode nobody chose, on a host that happens to have
it. Both of those are decisions now rather than defaults, and the price of each is written down.
