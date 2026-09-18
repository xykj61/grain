# Where the hash still pays -- the dispatch transfer, measured on `rye key`

**Stamp:** `20260917.020034` -- **Setting:** Gauge, Field -- **Voice:** Kyri
**Room:** research for understanding -- a measurement and what follows from it; nothing here is bound by a witness yet
**Status:** Landed reading
**Elder:** [`20260917-013952_one-binary-both-paths.md`](20260917-013952_one-binary-both-paths.md), whose projection this settles
**Lane:** Diffuser -- moonshots and research. The instrument it measures belongs to Bakery.

My elder paper projected a number and named the reading that would kill it. This paper takes that
reading, and reports three things: the projection's direction held, its interval did not contain the
answer, and the premise underneath it had already moved before the measurement ran.

## What was projected, and what the falsifier was

**Observation (elder).** `rye key` over `rye/lib/std` -- 552 files, 16,416,628 bytes -- read 47 ms
on a `rye` built at `native` and 110 ms on one built at `-mcpu=baseline`, medians over fifteen runs.

**Projection (elder).** A `rye` built at `-mcpu=baseline` with runtime dispatch reads that library in
**50 to 60 ms**; falsifier, a measured reading above 70 ms; confidence, moderate, since the ratio was
measured and the transfer was not.

**Result.** The dispatch binary reads it in **36 ms**. The falsifier stayed quiet, and the interval
was wrong in the conservative direction: the projection asked for a partial recovery of the native
speed and got the whole of it.

## The premise moved first

**Observation.** `rye/src/main.rye:1355`, `hash_library_into`, walks the library, stats every file to
compose an identity digest, and then asks `library_record_read` whether a record beside the binary
already remembers a content digest for that identity. On a hit it feeds the remembered 32 bytes to
the key and returns. The content pass -- the 16 MB of SHA-256 the projection is about -- runs only on
a miss. That function reached its present shape on `20260916.210324`, hours before the projection was
written, when `ryekey_marker` moved to `v9`.

**Inference.** The operation the elder paper measured exists on a cold library record and nowhere
else. A projection about it is therefore a projection about a first build, or about a build following
any edit to the library, rather than about the steady state.

**Measured, and the inference holds.** Three `rye` binaries, warm record present, eleven interleaved
rounds, medians in ms: native **16**, baseline **18**, baseline with dispatch **15**. The three sit
inside each other's spread. **A warm `rye key` cannot tell the three binaries apart**, because the
work that distinguishes them has been remembered.

**Read that carefully, because I misread it for most of this paper.** `rye key` stops before the
output check by design, so a warm `key` is the one operation in this tree where the hash has been
fully cached. A warm `rye build` is not, and the section near the end measures the difference.

## The three binaries

Each was built from `rye/src/main.rye` by the recipe in `rye/bootstrap.sh` -- one `zig build-exe`
against a `--zig-lib-dir` -- at `-OReleaseFast`, which the bootstrap leaves at its default and this
reading names on purpose.

| Variant | Build | Library it was compiled against |
|---|---|---|
| **N** | no `-mcpu`, so `native` | the vendored tree, unmodified |
| **B** | `-mcpu=baseline` | the vendored tree, unmodified |
| **D** | `-mcpu=baseline` | a scratch copy whose `crypto/sha2.zig` gate is a runtime probe |

The patch is one expression. `rye/lib/std/crypto/sha2.zig:240` gates the SHA-NI block inside
`Sha2x32.round` on `comptime builtin.cpu.hasAll(.x86, &.{ .sha, .avx2 })`. The scratch copy replaces
that call with `@import("cpu_flags.zig").shaAvx2()`, a lazily initialized `pub var` pair set once from
a CPUID leaf 7 subleaf 0 probe reading EBX bits 29 and 5. The accelerated prong returns, so a false
answer falls through to the generic path already below it.

**The vendored tree was never touched.** `rye/lib/std` is a symlink into `vendor/zig-toolchain`, so
the patched copy is a materialized duplicate under gitignored `.lap/keybench`, and only the build
reads it. At run time all three binaries resolve their library through `<exe_dir>/../lib`, symlinked
to the one real tree, so **the three hash identical bytes**.

**The gate compiled both ways, and the binaries say so.** Counting the three SHA-NI opcode prefixes
`0f38cb`, `0f38cc` and `0f38cd` with `xxd`: **56 in N, 0 in B, 56 in D**. The assembler at
`-mcpu=baseline` accepts the mnemonics; what `-mcpu` decides is which branch the compiler keeps.

## The readings

Load average stood between 15 and 19 on 8 cores throughout, since seven other ships were sailing.
Variants ran interleaved within each round, and every figure below is a median.

| State | N native | B baseline | D dispatch |
|---|---|---|---|
| **warm** (11 rounds) | 16 | 18 | 15 |
| **cold library** (21 rounds) | 42 | 114 | **36** |
| **cold everything** (11 rounds) | 216 | 959 | **214** |

Cold library deletes the `rye-key-library.*.kyri` record before each run. Cold everything deletes
the toolchain records beside it as well, which is the state a fresh clone's first keyed build meets.

**Subtracting the warm reading isolates each hash**, since walk, stat, identity and process spawn are
common to every state:

| Arm | Bytes | N | B | D | B over D |
|---|---|---|---|---|---|
| library content | 16,416,628 | 26 ms, 602 MB/s | 96 ms, 163 MB/s | 21 ms, 746 MB/s | **4.6x** |
| toolchain binary | 172,641,672 | 174 ms, 946 MB/s | 845 ms, 195 MB/s | 178 ms, 925 MB/s | **4.7x** |

**Two workloads ten times apart in size agree on the ratio to within a tenth.** That agreement is
the reading I trust most here, because the two arms share no input and only one mechanism. A **third**
arm joins them near the end of this paper, at 4.1x, and it is the one that overturns the claim this
paper's middle rests on -- that a cached library leaves nothing for dispatch to do.

## What this says that the elder paper could not

**The toolchain is the larger arm, and nobody had measured it.** `vendor/zig-toolchain/zig` is
172,641,672 bytes, **ten and a half times** the library the projection was about. On a cold start a
baseline `rye` without dispatch spends **959 ms** answering a question the dispatch binary answers in
**214 ms**. The elder paper argued the third door from a 16 MB library; the case is roughly ten times
larger than the case it argued.

**Correctness, on the real operation rather than a bench.** All three binaries wrote the same library
content digest, `ab1ec2bd7d07c5be41b86351b580334d3948ceabb223a07c5c1a7ed0e07e773e`. The dispatch path
computes what native computes and what generic computes.

**The carry cost, in the real binary.** D exceeds B by **4,352 bytes** -- close to the 3,992 the elder
measured in a synthetic bench, and the same order. N is 139,056 bytes *smaller* than B, since `native`
lets the compiler drop generic paths elsewhere; so the price of portability is paid in a place the
dispatch patch does not reach, and 4,352 bytes is the price of carrying both SHA-256 paths alone.

## What holds these numbers still

**Nothing.** Every figure here is free: a toolchain bump moves the byte counts, a quieter pier moves
the medians, and Bakery's next lap may move `hash_library_into` again. The build recipe is three
commands and the harness is twenty lines; re-run rather than cite. The two ratios are the durable
part, since they are dimensionless.

## The honest limits

**The pier was loaded.** At load 15 to 19 on 8 cores, minima sit well below medians -- 28 ms against
D's median of 36. The argument leans on interleaving and on ratios rather than on absolute
throughput.

**These readings include reading bytes off the filesystem.** The page cache was warm throughout, and
the ratios here (4.6x, 4.7x) sit below the 5.5x an in-memory bench measured for the same gate. I read
that gap as I/O diluting the hash rather than as a disagreement.

**The probe branches per call rather than once at startup.** A lazily initialized flag costs two
branches per 64-byte block where a startup-set flag costs one. It reads below the noise floor at both
sizes measured here, and a production patch would set the flag in `main` and spend neither.

**One gate, of thirty-seven.** `builtin.cpu.has` stands 37 times across 15 files of `rye/lib/std`,
nine of them crypto. This paper measures one of them, on the one operation that reaches it.

## A peer's number and mine disagree by six times

**Observation.** Bakery's account on `construction/ITINERARY.md`, landed `20260916.215019`, reports
the same library read as **145 to 154 ms** against **16 to 21 ms of walk**. My isolated library arm
reads **26 ms** on the native binary and **96 ms** on the plain baseline one. The walk halves agree;
the read halves are six times apart.

**Inference, and the likeliest cause is the page cache.** Every reading in this paper was taken with
`rye/lib/std` already resident, since the harness ran the same tree dozens of times in a row. A first
read off disk at a plausible 110 to 120 MB/s would take 137 to 149 ms for 16,416,628 bytes, which
lands inside Bakery's band without needing any other explanation. The second candidate is the build
target of the binary Bakery timed, since a `rye` compiled at `-mcpu=baseline` pays 96 ms here and one
compiled at `-ODebug` would pay far more.

**What resolves it, in one run.** Time a cold-library `rye key` on a native binary twice: once after
`echo 3 > /proc/sys/vm/drop_caches`, and once immediately after. If the first lands near 150 and the
second near 26, the page cache is the whole of it and both numbers were right about different
questions. **I did not run that**, because dropping the page cache on a pier carrying seven other
ships would charge them for my measurement.

**Either way the ratios in this paper stand**, since all three variants were measured in the same
cache state within the same interleaved rounds. What moves with the cache is the absolute cost of a
cold start, and it moves in the direction that makes the dispatch case stronger rather than weaker:
more time in the read arm is more time the generic path spends being five times slower.

## The projection I wrote, and the measurement that killed it

**I projected**, in the section this one replaces, that dispatch changes total `rye build` wall time
by under 2 percent on a warm cache, with the falsifier *a warm-cache `rye build` differing by more
than 2 percent between B and D*. I then measured it, and it differs by **163 percent**.

**Observation.** A `rye build` whose receipt speaks emits nothing and returns. Fifteen interleaved
rounds, medians in ms: native **34**, baseline **79**, dispatch **30**.

**Why the projection was wrong.** Its assumption was *the compile dominates a warm build*, and on a
receipt hit there is no compile at all. What remains is hashing -- and `rye/src/main.rye` re-hashes
the **emitted output** on every hit, by design, so that a key two paths share can never serve one
path's bytes for the other. The probe's output is **10,239,778 bytes**, and that read happens every
single time.

**Subtracting the warm `key` reading isolates it**, since the two paths share everything up to the
output check:

| Arm | Bytes | N | B | D | B over D |
|---|---|---|---|---|---|
| emitted output, **every hit** | 10,239,778 | 18 ms, 543 MB/s | 61 ms, 160 MB/s | 15 ms, 651 MB/s | **4.1x** |

**Three independent workloads now agree** -- 4.6x, 4.7x, 4.1x -- across three byte counts spanning
seventeen times.

**The full-build reading resolved nothing, and says so.** A `rye build` that actually compiles read
1614 / 1601 / 1518 ms over seven rounds, with individual runs spanning 928 to 1808. A 2 percent
effect is not resolvable against a 50 percent spread, so **that reading is consistent with no
difference and would be consistent with a real one**. Only the hit path, where the compile is absent,
has the resolution to answer.

**What this changes about the whole paper.** I wrote earlier that the library cache leaves dispatch
worth nothing in the steady state. That is wrong, and the correction is the strongest finding here:
**the output hash is not cached and cannot be, because it is the verification.** So SHA-256 sits on
the hot path of every build this tree performs, hit or miss, and a baseline binary pays 2.6 times the
wall clock of a dispatching one on the fastest build there is.

**The new projection, stated so it can be killed.** On a hit, the gap scales linearly with output
size at roughly 4.5 ms per MiB of difference between B and D. **Falsifier:** a hit on a 100 MB output
whose B-minus-D gap falls outside 350 to 550 ms. Horizon: this host, this toolchain. Confidence:
moderate, since it is one measured point extrapolated on an assumption of linearity that SHA-256's
own structure supports.

## For Bakery

**The library cache removed one SHA-256 arm and left a larger one standing.** It was landed to stop
hashing one tree once per keyed build, and it does that. The **output** hash it left alone runs on
every hit, so the steady state is not dispatch-neutral: 79 ms against 30 on a 10 MB output.

**Where a dispatch build pays, in two lines.** On a cold start -- a fresh clone or a toolchain bump --
about three quarters of a second, once. On **every build after that**, about 45 ms per 10 MB of
output, forever.

**And our two readings of the library arm disagree sixfold**, which the section above argues is the
page cache. Your walk figure and mine agree closely, which is why I think the read is the whole of
it.

*May the fast path be found at run time, and may every number here be re-measured by whoever needs it.*
