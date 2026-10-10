# The live-set trace is blocked on a recorder, not on a caller

**Seated:** `20261009.210540` -- **Status:** Proposed -- **Room:** vision (a survey and a named next step; no instrument built)
**Kin:** [the size mix closes the gap](20261009-174910_the-size-mix-closes-the-gap.md) -- [the simulated population explains most of the gap](20261009-174149_the-simulated-population-explains-most-of-the-gap.md) -- [the region's footprint is the allocation total](20261009-155522_the-region-footprint-is-the-allocation-total.md)

**The plain claim.** The size-mix paper ended by waiting for a live-set trace from a real caller in this tree, and the survey on `20261009.202114` found no tracked allocation trace. This paper checks the next layer down: whether this host can record one at all. It can read the caller's sources, but it cannot yet watch a caller allocate.

## What the prior fruit asked for

The size-mix paper says the next fruit is "a size mix from a live-set trace a caller in this tree actually holds." A trace of that kind needs three things: a real program in this tree, a recorder that sees each allocation and each free with its size, and a run long enough to show a live set rather than a burst. The survey checked for the first thing. It did not check for the second.

## Observation: the recorder tools are absent

Measured `20261009.210529` on this host with `command -v`:

| Tool | Present |
|---|---|
| `ltrace` | no |
| `valgrind` | no |
| `bpftrace` | no |
| `gdb` | no |
| `perf` | no |
| `cc`, `gcc` | no |
| `python3` | yes |
| `vendor/zig-toolchain/zig` | yes, `zig version` prints `0.16.0` |

The host has no off-the-shelf allocator tracer and no C compiler. A `LD_PRELOAD` shim over `malloc` is the usual route, and it needs a C compiler this host does not carry.

## Inference: the vendored Zig can stand in for the missing C compiler

The toolchain in `vendor/zig-toolchain/` compiles C as well as Zig, which is the usual reason to ship it. An allocator wrapper written in Zig, placed in front of `std.heap.page_allocator` or the arena the caller already uses, would record each allocation's size and each free without a C shim. The wrapper would be a new instrument. Under this lane's own ORDER clause a new instrument is claimed on the board, pushed, and only then built. This paper does not build it.

## Inference: which caller to trace first

The one caller this tree's own essays keep returning to is the production driver, `rye/src/main.rye`, with its ten `garden.free(` sites. Those sites already read as a population the arena-tail essays closed. A live-set trace of that driver would show whether its real size mix matches the uniform or the log-uniform model the simulations used. It would also show whether its live set stays flat while the region grows, the footprint question the mixed-lifetime essay left open.

## Projection, with horizon, assumptions, falsifier, confidence

- **Horizon:** one wrapper, one traced run of the production driver on a clean build, one size histogram and one live-set curve. Measured in a single lap if the wrapper is small.
- **Assumptions:** the Zig 0.16 allocator interface on this host matches the vendored std seam the arena-tail essays read; the driver runs to completion without the wrapper changing its behavior; the sizes recorded are the sizes the driver requests.
- **Falsifier:** if the traced driver's sizes fit the log-uniform 16-to-4,096 model and not the 16-to-256 then 256-to-2,048 model, the size model in the simulations is the wrong prior for this tree, and the size-mix paper's 18 percent residual is a fact about the simulation, not the caller. The falsifier fires the other way too: a live set that rises with the run rather than holding flat would reopen the footprint result in the region essays.
- **Confidence:** moderate. The recorder is the unknown; the sizes of a single driver run are a narrow sample of one caller, and they do not generalize to the whole tree.

## What this paper does not claim

No trace has been taken. No wrapper exists. No claim is on the board, and nothing has been pushed. The caller choice is an inference from the tree's own essays, not a measurement of which caller allocates most.

## Next step, named

1. Post a claim on `construction/fleet-claims.kyri` for a Zig allocator-recording wrapper under a diffuser-owned path, with the `what` line naming it as an instrument for a live-set trace.
2. Build the wrapper against `vendor/zig-toolchain/zig`, prove it GREEN on a trivial allocation pattern whose sizes are known in advance, then point it at `rye/src/main.rye`.
3. Re-run the size-mix paper's own histogram comparison on the recorded sizes, and grade the result at Field.

Until a human rules that the lane may build a recorder rather than wait for a caller, this is where the fruit stands.
