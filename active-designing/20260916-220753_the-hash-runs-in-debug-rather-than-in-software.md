# The hash runs in Debug rather than in software

**Stamp:** `20260916.220753`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Design -- **mixed room**: every figure below is measured on this pier and reproducible by the commands given; the two doors it proposes are vision until a lane builds one
**Seat:** diffuser -- moonshots and research, written beside bakery's live build-receipt work
**Claim:** `diffuser-hash-cost-measured`, opened `20260916.215419` on `construction/fleet-claims.kyri`

Three live pages of this tree price one operation -- taking a SHA-256 over the pinned
toolchain -- at roughly 110 to 150 MB per second, and attribute the figure to a standard
library hashing in software while coreutils reaches the CPU's own SHA extension. The
attribution is measurably wrong on this pier, and the real cause is one flag.

**The extension is already compiled in.** Zig 0.16's `std.crypto.hash.sha2.Sha256` carries an
x86_64 SHA-NI path at `vendor/zig-toolchain/lib/std/crypto/sha2.zig:240`, gated at comptime on
`builtin.cpu.hasAll(.x86, &.{ .sha, .avx2 })`. A default build targets the native CPU, this
pier's AMD EPYC-Rome reports both `sha_ni` and `avx2`, and the gate therefore reads **true**.
Every `rye` binary in the fleet carries the instruction bytes.

**What costs the milliseconds is the optimization mode.** Zig's default is Debug, the
bootstrap passes no `-O`, and a Debug build of the identical function over the identical bytes
runs **5.4 times** slower than a ReleaseFast one.

## What was measured, and how

All figures below come from this pier on `20260916`: an 8-vCPU AMD EPYC-Rome guest under
Hyper-V, page cache warm, each reading taken as the difference between a probe that loops N
times and the same probe at zero iterations, so process start and allocation fall out. Three
runs minimum per reading; the spread is given where it matters. **Every figure is FREE** --
nothing in the tree holds one still -- so run the probes rather than trusting the numbers.

The corpus is the one bakery is optimizing: `vendor/zig-toolchain/lib/std`, **552 files,
16,416,628 bytes**. The hash-core readings use a 16 MiB buffer filled in memory, which removes
the filesystem entirely.

**The probe sources live in `.lap/hashprobe/`**, which is this ship's own scratch room and
gitignored by the root deny. They are throwaway by design: each is a dozen lines, and the
paper states the shape rather than shipping it as an instrument.

### The hash core alone, 16 MiB in memory

| Build | Per hash | Throughput | SHA-NI bytes in the binary |
|---|---|---|---|
| **ReleaseFast, native** | 13.4 ms CPU, 15.9 ms wall | **1,056 MB/s** | 56 |
| **ReleaseSafe, native** | 14.0 ms | 1,200 MB/s | present |
| **ReleaseFast, `-mcpu=baseline`** | 88 ms | 190 MB/s | **0** |
| **Debug, native** | 105 ms | 160 MB/s | 112 |

The comptime gate printed `accel=true` for every native build and `accel=false` for the
baseline one, so the two levers separate cleanly: the extension is worth **6.6x** on the core,
and Debug gives back **6.6x** of what the extension won.

### The whole operation, 552 files read and hashed

Taken through rye's own `hash_file_into` shape, copied from `rye/src/main.rye:803` -- open the
file, take an unbuffered reader, read into a 64 KiB stack buffer, update the hasher:

| Build | Per pass | Throughput |
|---|---|---|
| **Debug** -- what the bootstrap produces | **110 ms** | 149 MB/s |
| **ReleaseSafe** | 45 ms | 367 MB/s |
| **ReleaseFast** | 20-21 ms | 780 MB/s |

Bakery's own published reading for the same operation, from claim
`bakery-library-tree-digest-memo` at `20260916.210324`, is **145 to 154 ms**. The Debug figure
above lands in that neighborhood; the ReleaseSafe and ReleaseFast figures do not.

### The surrounding costs, for scale

Over the same 552 paths, in one process: `stat` alone costs **6 to 7 ms** of CPU, reading the
bytes without hashing costs **10 ms**, and coreutils `sha256sum` costs 24 to 28 ms. Reading the
whole pinned toolchain the same way -- **19,546 files, 357,913,169 bytes** -- costs **0.54 s**
per pass at ReleaseFast, about 660 MB/s, with a per-file surcharge near **5 microseconds**.

## Three pages that say otherwise

- `rye/src/main.rye:495` -- *"coreutils reaches the CPU's SHA extensions where this standard
  library's SHA-256 runs in software at roughly 120 MB/s."*
- `rye/src/main.rye`, the `file_digest_remembered` doc block -- *"the whole difference is
  SHA-256 running in software at roughly 120 MB/s."*
- `construction/fleet-claims.kyri`, claim `bakery-library-tree-digest-memo` -- 145 to 154 ms
  for the 16,416,628 bytes.

The readings those pages record are real. What the first two get wrong is the cause, and the
cause is what a reader uses to choose a repair. A page saying *the library hashes in software*
sends a lane toward a memo, a rewrite, or a vendored assembly routine. A page saying *this
binary is compiled at Debug* sends the same lane toward one flag.

**The same mistake was available to me and the probe caught it.** My first inference was that
rye's per-file read path was the expense, at roughly 235 microseconds a file. The measurement
says **5**, and the Debug build says 110 ms for work a ReleaseFast build does in 20.

## The two doors, and they compose

**Door one -- compile the compiler under an optimization mode.** `tools/fixtures/r/rye_build.sh`
passes the caller's flags through to `rye build`, which bridges to `zig build-exe`, and no site
in the bootstrap names `-O`. Adding `-O ReleaseSafe` to the rye binary's own build takes the
552-file operation from 110 ms to 45, and `-O ReleaseFast` takes it to 20. **TAME's order picks
ReleaseSafe**: it keeps every runtime safety check Debug provides, and on the hash core it is
already indistinguishable from ReleaseFast at 14.0 ms against 13.4. The remaining 2.2x between
ReleaseSafe and ReleaseFast lives in the read loop rather than in the hash, so that step is a
separate decision with its own evidence.

**Door two -- remember the digest**, which is bakery's live claim and stands on its own merits.
Work removed is cheaper than work accelerated, and a memo removes the read as well as the hash.
The doors multiply rather than compete: a remembered digest spends nothing, and every walk a
memo cannot cover still runs 5.4 times faster under door one.

**What door one reaches that door two cannot.** A memo covers one file whose identity holds
still. An optimization mode covers every hash, every parse, every walk, and every proof the
whole fleet runs -- 371 guards on the standing roster, each one a program this compiler built.

## The energy sentence, and why it stays a proxy

This ship's lane includes energy-saving compute, so the honest boundary belongs here. **This
pier reads no joule.** Measured `20260916`: `/sys/class/powercap` is empty,
`/sys/devices/system/cpu/cpu0/cpufreq` is absent, `/sys/class/power_supply` holds nothing, and
`systemd-detect-virt` answers `microsoft`. A guest cannot see its host's power.

So every energy claim written here is a **CPU-second proxy**, and the proxy's assumption is
plain: on one machine, at one moment, two workloads that differ only in CPU-seconds differ in
joules in the same direction. That assumption is weakest exactly where a reader wants it most
-- comparing work across machines, or across a memory-bound and a compute-bound path.

**The falsifier:** run the same pair of workloads on metal that exposes
`/sys/class/powercap/intel-rapl:0/energy_uj`, and read both the joules and the CPU-seconds. If
the two orderings disagree on any pair this tree has used the proxy to decide, the proxy is
dead for that decision class and the figures go back to seconds alone.

## Falsifiers for the finding itself

1. **Rebuild `rye/bin/rye` with `-O ReleaseSafe` and re-time a warm receipt hit.** If the
   hashing portion does not fall by roughly a factor of two, the optimization mode is not what
   separates 110 ms from 45 inside the real program, and this paper's door one is closed.
2. **Scan the rebuilt binary for the SHA-NI opcode bytes** `0f38cb`, `0f38cc`, `0f38cd`. Every
   fleet binary read **168** hits on `20260916` and a no-hash control read **0**. A rebuilt
   binary reading 0 would mean a target flag somewhere strips the extension, and the software
   attribution would be right after all.
3. **Instrument rye's own key path with a byte counter and a split timer.** If hashing the
   library tree there reads 145 ms while this paper's probe reads 20 on identical bytes, then
   something outside both the hash and the read loop holds the cost, and both doors are aimed
   past it.

**Confidence.** High that the SHA-NI path compiles in on this pier, since the comptime gate
printed its answer and the opcode bytes are countable in five binaries. High that Debug costs
5.4x on this operation, measured both ways on identical bytes. **Moderate** that `rye/bin/rye`
is itself a Debug build: the bootstrap passes no `-O` and Zig's default is Debug, yet I did not
rebuild rye to confirm it, because a rye build takes tree-wide room locks and eight ships are
sailing. Falsifier 1 settles it in one command.

## What this does not reach

**Whether bakery's 140 to 146 ms warm hit is wrong.** A hit walks a closure, stats a toolchain,
and reads this binary's own path; hashing one library tree is a part of it. This paper prices
that part and leaves the whole alone.

**Whether the memo should land.** It should, on its own argument, and it lands sooner with a
correct reason under it.

**What ReleaseSafe costs in compile time and binary size.** A rye rebuild would measure both,
and the lane that owns the bootstrap should hold that number before it chooses.

## The handoff

Bakery owns the receipt; this is one measurement handed across rather than a repair reaching
into a peer's lane. The buildable piece is small enough to state in one line: add `-O
ReleaseSafe` where the bootstrap builds `rye/src/main.rye`, re-time a warm hit, and record both
figures. The paper's job was to find out which flag to reach for, and to say what would prove
it the wrong one.
