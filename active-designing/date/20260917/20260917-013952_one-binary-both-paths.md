# One Binary, Both Paths -- the portable build keeps the extension

**Language:** EN
**Stamp:** `20260917.013952`
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Living -- **mixed room**: every timing below is on metal in this tree, and the
proposal that `rye` adopt runtime dispatch is vision until a witness binds it
**Room:** mixed
**Lens:** TAME priority -- safety, then performance, then the joy of the craft
**Elder:** [`20260917-010644_the-extension-was-carrying-the-debug-build.md`](20260917-010644_the-extension-was-carrying-the-debug-build.md), which priced the gate and left the question below standing

---

## The boundary this presses

My own elder paper measured what `-mcpu` costs on one operation and closed on an either-or: a
portable `rye` pays for portability, or a fast `rye` inherits the build host's processor. The card
carries that as my open ask.

**An either-or is a claimed boundary, and this lap presses it on metal.** The claim under the
question is that a binary holds one code path per feature, chosen when it is compiled. Every figure
below says otherwise.

**The falsifiable form, written before the numbers.** If a `-mcpu=baseline` binary cannot hold the
SHA-NI code at all, or holds it and runs it materially slower than a `-mcpu=native` binary, or pays
a measurable per-block price for choosing between the two, then the either-or is real and my elder's
framing stands. Any one of those three kills the proposal.

## What was measured, and where

**Host:** AMD EPYC-Rome, 8 cores, Linux, `vendor/zig-toolchain/zig` 0.16.0, read `20260917`. The
chip carries `sha_ni` and `avx2` and no AVX-512, read from `/proc/cpuinfo`.

**Everything built for this paper lives under `.lap/dispatch/`, which is gitignored and dies with
the lap.** No tracked file moved. The scratch copies are `rye/lib/std/crypto/sha2.zig` with one
expression changed and its two imports repointed, so the algorithm under test is this tree's own.

The one expression is the gate at `rye/lib/std/crypto/sha2.zig:240`, inside the `round` function of
`Sha2x32`:

```
.x86_64 => if (builtin.zig_backend != .stage2_c and comptime builtin.cpu.hasAll(.x86, &.{ .sha, .avx2 })) {
```

Three copies were made. **Forced** replaces that test with `true`. **Generic** replaces it with
`false`. **Dispatch** replaces it with a read of a `pub var` in a small `cpu_flags.zig` module, set
once at startup from a `cpuid` leaf 7 inline-asm probe reading EBX bits 29 and 5.

## Reading one -- the assembler admits the instruction at baseline

The first question is whether the code can be in the binary at all, and it is the cheapest to
answer. A four-line object file carrying one `sha256rnds2` inline-asm statement compiles at
`-mcpu=baseline -OReleaseFast`, and the SHA-NI opcode prefix `0f38cb` stands once in the emitted
object, read with `xxd`.

The full `Sha2x32` round block compiles the same way, `vpalignr` included. **The four benchmark
binaries carry 56 SHA-NI opcode occurrences each at baseline, and zero in the generic build.**

**So LLVM's integrated assembler gates inline assembly on nothing.** The `-mcpu` value governs what
the compiler will *generate*; a mnemonic a programmer writes by hand passes through. That is the
hand through the boundary, and everything below rests on it.

## Reading two -- the four builds agree on the answer

Correctness comes before speed, so all four builds hashed the same 256 MiB and printed the digest:

```
b_forced_baseline    486cc817b95d853d3c357ff283b204c0144bd255e73fe2deb1389493b257e3c0
b_forced_native      486cc817b95d853d3c357ff283b204c0144bd255e73fe2deb1389493b257e3c0
b_generic_baseline   486cc817b95d853d3c357ff283b204c0144bd255e73fe2deb1389493b257e3c0
b_generic_native     486cc817b95d853d3c357ff283b204c0144bd255e73fe2deb1389493b257e3c0
```

## Reading three -- the timing

**Design, stated because it decides the number.** A 1 MiB buffer hashed 64 times, so the working
set is cache-resident and the 64 MiB of hashing dominates the one fill. An earlier design hashed a
256 MiB buffer once, and the page-fault cost of filling it moved between targets by 142 ms -- larger
than the effect under test -- so that design was dropped rather than reported. The five binaries ran
**interleaved**, one after another, eleven rounds, so every path met the same machine load.

Wall clock from outside the process, `date +%s%N` either side, medians and minima over 11 runs,
`20260917.013000`:

| Binary | median ms | min ms | MB/s at min |
|---|---|---|---|
| `dispatch` at baseline, extension found | **73** | **57** | 1,122 |
| `forced` at baseline | 84 | 63 | 1,015 |
| `forced` at native | 71 | 64 | 1,000 |
| `generic` at baseline | 402 | 350 | 182 |
| `dispatch` at baseline, detection skipped | 378 | 364 | 175 |

**The accelerated path runs the same speed whichever target built it**: 73 against 71 at the median,
57 against 64 at the minimum, over a spread where a single run varied by 27 ms. **The generic path
costs 5.5x**, median against median.

**The per-block branch costs less than this machine can measure.** `dispatch` reads a global on every
one of the 1,048,576 blocks and beat `forced`, which reads nothing, by 11 ms at the median. A
predicted branch that never changes direction is what a modern predictor is best at, and the reading
is consistent with free rather than proving it.

**The same binary falls back correctly.** `dispatch` with the detection call removed -- which stands
in for a host lacking the extension -- ran the generic path, printed the same digest, and landed
within 6 percent of the generic-only build.

**The honest limit on every number here.** The machine carried a load average of 38 throughout,
since eight ships and my own roster pass were running. That is why minima sit so far below medians,
and why the argument leans on the interleaving and on ratios rather than on absolute throughput. A
quiet host would read faster everywhere; the comparison is what the design protects.

## What carrying both paths costs

**Bytes:** the dispatch binary is 3,741,800 against the generic-only 3,737,808, a difference of
**3,992 bytes** -- 0.1 percent of these binaries, and roughly one page of code.

**Startup:** one `cpuid`, once per process, before any hashing.

**Per block:** one load and one predicted branch, below the noise floor at this load.

**Source:** one expression. The gate already exists and already branches; the change is what it
reads.

## How far this reaches

`builtin.cpu.has` appears **37 times across 15 files** of `rye/lib/std`, read `20260917` by
`grep -rn`. Nine of the fifteen are crypto -- `ml_kem.zig` alone carries 9, and `aes.zig`,
`chacha20.zig`, `ghash_polyval.zig` and `salsa20.zig` carry 3 apiece. **Every one of those is a
place where `-mcpu` decides which code exists**, and each is the same shape as the one measured
here.

That figure is **free**: it moves whenever the vendored toolchain moves. Run the grep.

## The projection, and the measurement that would kill it

**Observation.** My elder paper measured `rye key` over `rye/lib/std` -- 552 files, 16,416,628
bytes -- at 47 ms native ReleaseFast and 110 ms baseline ReleaseFast, medians over fifteen runs.

**Inference.** The difference between those two builds on that operation is the SHA-256 path, since
the gate above is the one line that changes between them and the walk is identical.

**Projection.** A `rye` built at `-mcpu=baseline` with runtime dispatch reads that library in **50 to
60 ms** -- horizon: this host and this toolchain version; assumptions: hashing dominates the
difference, and the walk itself is target-insensitive; **falsifier: a measured reading above 70 ms**,
which would mean something other than the hash is paying for `baseline`; confidence: moderate, since
the ratio is measured and the transfer is not.

**That measurement belongs to Bakery**, whose lane owns `rye key`, the memo records, and the build
spine. It costs one patched gate and one rebuild.

## Why a portable build is worth wanting

**`rye` passes no `-mcpu` at all**, so it inherits `native` by default. A binary built that way on
this host requires SHA-NI, which AMD has shipped since Zen 1 in 2017 and Intel since Ice Lake in
2019 on the mainstream client line. **A distributable `rye` therefore cannot be built on a modern
machine without either narrowing who can run it or giving up the extension** -- and this paper says
the third door is open.

**The energy arm is the same finding read as joules.** Five and a half times the instructions for
one hash is about five and a half times the energy for that hash, and a build that dispatches spends
the lower figure on every machine that can. A tree aiming at small farms and old hardware wants the
binary that runs fast on the new chip and correctly on the old one.

## What this does not reach

**One host, one microarchitecture, one algorithm.** SHA-256 on Zen 2. The aarch64 gate three lines
above the one measured is the same shape and is untested here.

**The build ergonomics.** Zig 0.16 offers no per-function target attribute, so a library wanting
*compiler-generated* vector code for two feature sets in one binary still needs separate objects.
This paper measured the case where the accelerated code is hand-written assembly, which is what the
crypto gates in `rye/lib/std` actually hold. **The two cases are different problems**, and only the
second is answered.

**Whether a vendored standard library should be patched at all.** `rye/lib/std` tracks upstream Zig,
so a local change is a fork decision rather than a performance one. Naming the cost is this paper's
job; choosing is Keaton's and Bakery's.

**Whether `cpuid` is the right probe.** It is the direct one, and it worked here. A kernel-provided
feature vector would be safer under emulation and inside a sandbox, and nothing here compares them.

## What this hands forward

The either-or on the card can be answered with a third door: **name the target as `baseline` and
dispatch at runtime**, which buys a binary that runs anywhere and keeps the extension where it is
present. The measurement supporting it is above; the work of proving it inside `rye` is one lane
over.

May the fast path stay available to the slow machine, and may the portable binary never have to
apologize for its speed.
