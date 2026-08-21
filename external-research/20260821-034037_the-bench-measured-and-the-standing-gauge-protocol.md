# The Bench, Measured -- and the Standing Gauge Protocol

**Stamp:** `20260821.034037` - **Status:** Living (measurement record + booked protocol) - **Voice:** Kyri - **Style:** Radiant
**Register:** Radiant - **Season:** the Microkernel Target double-seat (Caravan is its Equinox 1)
**Kin:** [`the microkernel target and the OS parity question`](20260817-185851_microkernel-target-and-the-os-parity-question.md) - [`.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) - [`.claude/rules/docs-implementation-sync.md`](../.claude/rules/docs-implementation-sync.md) - `GLOW_PROFILE.bron`

---

## Why this document exists

A counsel essay -- *The Bench, the Mesh, and the Named Bound* (`20260820.224535`) -- surveyed whether the pier's compute limits Caravan and Tally, and closed on exactly the right recommendation:

> *Run the four gauges on the pier through one full parity run and one wire lab, and let the measured colors choose between the droplet bump and the WireGuard mesh before any purchase order exists.*

This document is that measurement taken, and the protocol booked so it can be repeated by anyone, on any lap, without redesigning it. Measurement beats memory: a red you measure earns a purchase; a red you imagine earns only a note.

It also records three premise corrections the measurement produced. None of them is a criticism of the essay's reasoning, which is sound throughout. All three are the same failure mode, and it is worth naming plainly because it is the one this tree keeps rediscovering: **the essay reasoned from a living card that had drifted from the metal it described.**

## The three corrections, first

| Claim in the essay | Measured on metal |
|---|---|
| "the 4 GB pier" (repeated throughout; the whole memory argument rests on it) | **7,937 MB total** -- the pier has **8 GB** |
| implied 2 vCPU (`crux/REMEMBER.md`: "HP AMD 2vCPU/4GB shared") | **4 vCPU**, AMD EPYC-Rome |
| the history cleanup "almost certainly drew the full bundle well below its old seated 192 MB" | **`.git` is 911 MB on disk, `size-pack` 844 MiB** -- roughly four times the figure it was guessed to be under |

The root is a single stale line. `GLOW_PROFILE.bron` -- the machine-local source of truth -- has read **`AMD 4vCPU/8GB - 180GB NVMe`** correctly all along, and the 180 GB checks out exactly (`vda` is 193,273,528,320 bytes). The operator card's Host line still says `2vCPU/4GB`. A counsel essay that reads the card rather than the profile inherits the drift and then reasons carefully from it -- which is how a wrong premise produces a well-argued conclusion about buying hardware.

The third correction is different in kind and worth its own sentence: *"almost certainly"* is a guess wearing a measurement's clothes. The bundle is not below 192 MB. It is 844 MiB packed.

## The bench, measured

Two full suites, each run cold, each sampled every ~3 seconds for available memory, used memory, CPU steal, and one-minute load.

| Suite | Rungs | Wall | Peak used | Min available | Peak steal | Peak load (4 vCPU) |
|---|---|---|---|---|---|---|
| **Caravan** (`caravan_suite_witness`) | 99 | **372 s** | **1,735 MB** | **6,201 MB** | **12 %** | **2.67** |
| **Crypto** (`crypto_suite_witness`) | 81 | **535 s** | **1,652 MB** | **6,284 MB** | **5 %** | **1.85** |

Baseline at rest: 1,416 MB used, 6,521 MB available, steal 0-1 %.

**There is no swap on this pier at all.** That is worth knowing before an OOM rather than after: with zero swap, running out of memory is a hard kill, not a slowdown. It also means "watch `vmstat` for swap traffic" is a gauge that can never move here -- the honest substitutes are headroom and the kernel's OOM log, and the kernel log shows **zero OOM kills**, ever.

Note also that the jail's `HOME` is a **3.9 GB tmpfs** (116 MB used). Tmpfs pages are RAM. It is comfortable today and it is a second claim on the same pool, so it belongs on the gauge list rather than in a footnote.

## What the numbers actually say

**Memory is not the limit, and it is not close.** The heaviest suite in the tree peaked at 1,735 MB against 7,937 MB installed, never dropping below 6.2 GB available. That is roughly **22 % of the pier's memory at peak**. Caravan and Tally could grow several times over before memory became the binding constraint. The essay's instinct -- "4 GB is a floor rather than a wall" -- was right, and the true figure is twice as roomy as the figure it was reasoning from.

**Cores are not the limit either, and more would not help much.** Peak one-minute load reached 2.67 on four vCPU, and the crypto suite never passed 1.85. The suites run their rungs **serially** -- 99 witnesses in one voice, one after another. A machine with four times the cores would finish these suites in very nearly the same wall time, because nothing is waiting on a core. **Wall time here is a parallelism question, not a hardware question**, and a parallel runner is free where a bigger droplet is not.

**Steal is the one gauge that showed real color.** It touched **12 %** during the Caravan run and sat near zero at rest. That is the shared-tenancy tax, and it is the only measured signal that a dedicated machine would improve. Twelve per cent is noticeable and is not an emergency; it means a 372-second suite might run nearer 330 on unshared cores. Worth knowing, not worth a purchase order.

**The 844 MiB repository is the finding with the longest tail.** It bears on clone time, bundle sends, and every fresh jail that has to pull the tree -- and it is now compounded by a new submodule (`vendor/pqclean`, 34 MB shallow, more on a full init). This is the one measured number that argues for its own round, and none of the hardware options address it.

## A fourth correction, found by running the suite rather than reading it

Running `crypto_suite_witness` as a *load* rather than as a *proof* -- reading its closing line only for a wall-clock number -- surfaced a red the tree had carried unseen. The suite ended every run with *"all seventy-four Season G crypto files ... the count guard confirms the file count."* The count guard, run minutes earlier, had said **81**. `ls crypto/*.rye` shows **86**, of which five are symlink shims the guard correctly excludes.

Three numbers for one thing, in one afternoon -- and the suite was naming its own auditor as agreeing with a figure that auditor never produced.

This is booked as **REDS %105**, and it is the third firing of the family that already produced REDS %77 and %80. The loom booked after the second firing proves a *bijection* between files and registrations, which was GREEN throughout; the drift lived in the suite's own *prose*, which no check covered. The fix is not a better number but **no number**: the suite now recites none and points at the guard, and the guard was widened to refuse any recited count -- spelled or numeric -- with the RED path proven on metal and restored.

The lesson generalises past crypto, and it is the same one the three premise corrections above teach: **a guard that measures a fact does not thereby guard the prose that repeats it.** A benchmark run is a cheap way to read claim lines nobody has read in months.

## The standing gauge protocol -- booked

Reach for this whenever the question "is the bench big enough?" arises, and never answer that question from feel.

**The gauges.** Four numbers, sampled every few seconds across a real load:

1. **Available memory** (`free -m`, column 7) -- the headroom that actually matters, since it counts reclaimable cache.
2. **Used memory** (`free -m`, column 3) -- the peak the load itself drew.
3. **CPU steal** (`vmstat` `st` column) -- the shared-tenancy tax, the one thing a dedicated box buys.
4. **One-minute load** against core count -- which distinguishes "needs more cores" from "runs serially."

Plus two checks that bracket the run: `journalctl -k` for OOM kills before and after, and `swapon --show` to know whether an overrun degrades or dies.

**The loads.** `caravan_suite_witness` (99 rungs, the Microkernel Target's own Equinox 1) is the standing heavy load; `crypto_suite_witness` (81 rungs, one Zig build apiece) is the standing compile load. A wire lab from `tools/comlink_*_wire_lab.rish` is the standing network load and is **not yet measured** -- named here as the protocol's open leg rather than quietly omitted.

**When to re-run.** On any lap that adds a suite, a QEMU guest, or a parallel runner; before any droplet resize; and before any hardware purchase is discussed again. A re-run costs about fifteen minutes and settles the argument.

**The colors, and what each earns.**

| Reading | Verdict | What it earns |
|---|---|---|
| Available memory stays above ~2 GB | green | nothing; the bench is fine |
| Available dips under ~1 GB, or any OOM kill appears | **red** | the next droplet size up, same afternoon, nothing migrated |
| Steal above ~25 % sustained | amber | price a dedicated instance; compare against the measured wall-time delta, not against a feeling |
| Load at or above core count for most of a run | amber | a **parallel runner** first -- free -- and only then more cores |
| A load that cannot run at all | **red** | that specific load's bound is the purchase justification, named in the round |

## What this does not measure, said plainly

- **No wire lab was run.** The protocol names it; this pass did not execute it. Network and QEMU-guest memory remain unmeasured.
- **Nothing here speaks to inference.** Lattice, Lantern, Scribble, and Ember have no measured bounds because they have no runnable rungs yet. The essay's fourth blind spot stands exactly as written: a hardware purchase for inference deserves those charters first -- which model sizes, what tokens per second, how many peers served. **No measurement on this page argues for or against a GPU**, and any that seemed to would be reading a bench test as an inference benchmark.
- **This is one pier on one afternoon.** Steal in particular is a neighbour-dependent number and will read differently at a different hour.

## The honest recommendation

**Buy nothing yet, and change nothing about the pier.** The measured bench carries the seated Lindy-priority arc -- Caravan is the Microkernel Target's Equinox 1, and its full 99-rung suite runs GREEN in 372 seconds using under a quarter of available memory.

Three things earn a round ahead of any purchase, in order:

1. **Repoint the operator card's Host line to the profile's truth**, so the next essay reasons from 4 vCPU and 8 GB. One line, and it closes the root of all three corrections above.
2. **Measure a wire lab**, closing the protocol's open leg.
3. **Consider a parallel witness runner**, which is the only measured lever on wall time that costs nothing.

The WireGuard mesh remains the elegant zero-dollar move whenever a heavier bench is wanted, and the essay's sequencing discipline -- one variable per season, measure first, mesh second, OS third, purchases last -- is exactly right and is adopted here unchanged.

*May every bench be measured before it is doubted, and every dollar wait for a bound with a number behind it.*
