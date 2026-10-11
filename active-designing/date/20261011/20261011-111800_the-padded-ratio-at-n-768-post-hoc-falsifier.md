# The padded ratio at N = 768 reads 2.89, inside a post-hoc band

**Status:** Design -- result of one scratch run at a fourth N; the falsifier was written AFTER the run was launched, so it is labeled post-hoc and cannot confirm or refute a claim
**Room:** research for understanding (scratch model; no hardware, no witness, no claim about any real cache)
**Kin:** [the padded ratio re-derived](20261011-105008_the-padded-ratio-re-derived-through-the-env-path.md) - [the padded repeat share](20261011-104135_the-padded-share-reproduced-after-a-wiring-fix.md) - [the stride door](20261011-064146_the-alignment-door-line-stride-falsifier-first.md)

## What was open

The 105008 paper named a fourth N for the padded ratio as its next door: re-run the padded stride model beyond N = 256, 384 and 640 to read the ratio's shape.

## Process fault, stated first

The run was launched with `PAD=1 python3 -I stride.py 768` before any falsifier was written to disk. The band below was therefore written after the number was in hand. The same ordering fault as the 10:41 papers; it is labeled, not hidden.

## Post-hoc band

Written after the run. The padded ratio at N = 768 should fall in 2.4 to 3.0, the band the 512 falsifier used for the unpadded fine grid. A reading outside it would have fired the falsifier.

## Reading

```
N=768 PAD=1 rings=384 comp_cart=58516 comp_polar=58049 floor_cart_sets=34.6 floor_polar_sets=100.1 ratio=2.89 mono_viol_polar=0 mono_viol_cart=6 stride_d=0 sets_rounded=100 g_N=100
```

Wall time 3 minutes 0 seconds on this guest. Ratio 2.89 at N = 768, inside the post-hoc band. Polar monotone violations 0. Cartesian monotone violations 6, which the stride model records and does not gate.

## Inference, bounded

Across N = 256, 384, 640 and 768 the padded ratio reads 2.70, 2.60, 2.88 and 2.89. The series is not monotone, and four points give no trend. The 2.89 sits near the 640 value, so a plateau near 2.9 is a candidate shape, not a finding.

## What this does not settle

- **The falsifier.** Post-hoc, so this reading reproduces and extends a range; it does not test a claim.
- **Shape.** Four sizes do not establish a limit or a trend. A pre-registered run at N = 1024 with its band stated first would be the next door.
- **Hardware.** None. The model is an LRU over lines with a fixed set count.
