# Autonomous loop -- filled `20260821.034037`, after the bench was measured

**Stamp:** `20260821.034037` - **Voice:** Kyri - **Style:** Radiant - **Seed:** [`../seed/autonomous-loop.seed.md`](../seed/autonomous-loop.seed.md)
**Measurement it rests on:** [`../../external-research/20260821-034037_the-bench-measured-and-the-standing-gauge-protocol.md`](../../external-research/20260821-034037_the-bench-measured-and-the-standing-gauge-protocol.md)

---

## What changed in this filling, and what deliberately did not

**The route did not move, and that is the finding.** An earlier pass this session called the loop's route stale for leading with the Microkernel Target rather than the newly-opened DISC arc. That was wrong and is booked as **REDS %104**: the Microkernel Target double-seat *takes precedence over Seasons A-H* on Keaton's seated `20260817` word, and Cryptography is Season G, inside A-H. The loops were carrying the seated ordering faithfully. **Both prompts keep their route exactly as written.**

Two things did change, both preconditions rather than direction:

1. **Submodules are a precondition, not a red.** The vendored parity rungs need `vendor/monocypher` and `vendor/pqclean` checked out. A fresh pier runs `git submodule update --init --recursive` before the first lap. A RED from an empty `vendor/` is an environment fact, fixed by initialising it, never booked under Standfast -- a red against an uninitialised checkout would stop the line for nothing. Seated in the seed's lens list and printed as step `0a` of the outer recipe.
2. **The crypto guards are named in *prove before GREEN*.** A round touching `crypto/` runs the count guard; one touching a vendored rung runs the vendored-parity roster. Added after **REDS %105**, where the suite recited a file count seven stale while citing the count guard as confirming it.

## The bench this run wakes on, measured rather than assumed

`AMD 4vCPU/8GB, 180 GB NVMe, no swap.` The operator card had said `2vCPU/4GB` and was corrected in the same round; `GLOW_PROFILE.bron` had it right all along.

Under the two heaviest suites in the tree -- Caravan's 99 rungs at 372 s, Crypto's 81 at 535 s -- peak memory reached **1,735 MB against 7,937 MB installed**, never dropping below **6.2 GB available**, with zero OOM kills ever recorded. Peak one-minute load touched **2.67 on four vCPU**, so the suites run serially and more cores would barely move the wall clock. The one gauge that showed colour was **CPU steal at 12 %** -- the shared-tenancy tax, noticeable and not an emergency.

**A run started today is not compute-limited.** The loop may climb without watching its footing, and the gauge protocol in the measurement doc names exactly which readings would change that answer.

## The open leg, named rather than omitted

No wire lab was measured, so QEMU-guest memory is still unknown. `tools/comlink_*_wire_lab.rish` is the standing network load, and closing that leg is the protocol's next lap.

---

*May the loop wake on a bench whose limits are known, and spend its hours on the work rather than on doubting the floor.*
