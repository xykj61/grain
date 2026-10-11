# The alignment door on a structured stagger, falsifiers written before the run

**Status:** Design -- falsifiers stamped `20261011.050016` and committed before any run; result appended below after the run
**Room:** research for understanding (scratch model; no witness binds it yet)
**Kin:** [the per-ring offset](20261011-044643_the-alignment-door-per-ring-offset-falsifier-first.md) - [the label shuffle](20261011-044005_the-alignment-door-label-shuffle-falsifier-first.md) - [the second hash constant](20261011-043036_the-alignment-door-second-hash-constant-falsifier-first.md) - [the hashed-index door](20261011-041450_the-alignment-door-hashed-index-falsifier-first.md)

## What this tests

The per-ring offset door ran a seeded random offset for each polar ring. It did not flatten the
sawtooth. It raised the polar floor by about 15 to 20 percent at each set count and widened the
ratio's spread across N to 0.40, against 0.29 under the modulo index. Its named next door asks a
narrower question: can a **regular** stagger, rather than a random one, lower the floor the random
draw raised?

The construction, chosen here and tested against no other choice:

    set = (line + off[ring]) % sets
    off[r] = (r * K) % sets        with K = 1, fixed before the run

`r` is the ring index in the sorted ring list, which is the index the scratch model already uses for
its ring of each line. `K = 1` is the most regular stagger available: each ring starts one set
further round than the ring inside it. No other `K` is run in this paper. A second `K` would be a
second door, written with its own falsifiers.

Scope: the scratch model only, 8 ways, LRU, line size 8, unpadded, 5 percent tolerance, the same
disk and grid as the offset door. No hardware, no witness, and no claim about any real cache.

Because the stagger is deterministic, there is no seed spread. The one construction is the whole
evidence, which is a narrower reading than the random draw's three seeds.

## Prior readings the falsifiers cite

| N | Arm | Cartesian floor (sets) | Polar floor (sets) | Ratio | Polar monotone violations | Source |
|---|---|---|---|---|---|---|
| 256 | modulo | 12.4 | 33.3 | 2.69 | 0 | `fc256_base_20261011.txt`, label-shuffle paper |
| 384 | modulo | 19.2 | 49.7 | 2.59 | 0 | `fc384_640_nopad_20261011.txt`, label-shuffle paper |
| 640 | modulo | 28.8 | 83.0 | 2.88 | 0 | per-ring offset paper, zero-offset control |
| 256 | random offset, seed 1 | 12.4 | 39.4 | 3.19 | 0 | per-ring offset paper |
| 384 | random offset, seed 1 | 19.2 | 58.7 | 3.06 | 3 | per-ring offset paper |
| 640 | random offset, seed 1 | 28.8 | 99.7 | 3.46 | 0 | per-ring offset paper |

Under the modulo index the ratio spreads 0.29 across N = 256, 384 and 640 (2.59 to 2.88). That
spread is the sawtooth this door tests.

## Falsifiers, written before the run

- **S1 (identity).** With `K = 0`, every `off[ring]` is zero, so the stagger reduces to the modulo
  baseline. The ratio and the floors at N = 256, 384 and 640 must match the modulo table to the
  printed precision. Reason: the same control as the per-ring offset door's R1. If zero offsets
  change a reading, the stagger code path is not the modulo baseline, and no `K = 1` result can be read.
- **S2 (Cartesian fixed).** At every N run, the Cartesian floor under the stagger arm equals its
  modulo value. Reason: the offset touches only the polar arm. A moved Cartesian floor means a bug.
- **S3 (flatten).** Across N = 256, 384 and 640 with `K = 1`, the spread of the ratio (max minus min)
  is at most 0.10. That **supports** the alignment reading in its regular form. The falsifier
  **fires** if the spread is at least 0.29, the modulo spread. Between 0.10 and 0.29 reads as
  inconclusive, and the paper will say so rather than choose a side.
- **S4 (penalty survives).** With `K = 1`, the ratio stays at or above 2.0 at every N run. Reason: the
  headline claim is a polar penalty near three times. A fall below 2.0 means the penalty depends on
  the alignment, which would weaken the earlier claim. The falsifier **fires** on any reading below 2.0.
- **S5 (monotone curve).** The polar curve under `K = 1` has zero monotone violations at every N
  run. The random draw broke this with up to three violations, and a regular stagger is still a
  partition change. The paper reports any count as read, not as noise. Any violation **fires** the
  falsifier.
- **S6 (lowering the floor).** The reading this door exists to test: a regular stagger lowers the
  polar floor that the random draw raised. The lowering reading is **supported** only if the polar
  floor at N = 256 and at N = 384 are both strictly below their modulo values, 33.3 and 49.7. The
  falsifier **fires** if both are at or above their modulo values. A mixed result, lower at one N and
  not the other, reads as inconclusive.

## Ordering

S1 is run first. If S1 fails, the run stops and the paper says so; no stagger result is read. Then S2
to S6 are read from the same run. The falsifiers are not edited after the run; a reading that
contradicts one is reported as a fire, not as a sign the falsifier was mis-set.

The run uses the scratch script `session-output/ring-offset/ring_offset.py` with the offset line
replaced by the stagger rule above, written as a sibling file so the random-draw script stays
byte-identical. The grid, tolerance and smax match `fine_capacity.py`.

## Caveats, stated before the run

- One deterministic construction, `K = 1`. A fire on S3, S4 or S5 says this stagger fails, not that
  every stagger does. A lowering on S6 says this stagger lowers the floor on this model, not that a
  stagger is a good layout.
- The ring-of-line definition inherits the per-ring offset paper's choice: a line's ring is the ring
  of its first polar cell. That is a definition the falsifier S1 checks at zero offset, not a
  measurement of the line's true footprint.
- A regular stagger on rings of different lengths can coincide with the ring's own length modulo
  `sets`. That coincidence is one of the things S3 and S5 can catch, and the paper reports it as read.

---

Appended after the run, below this line. The six falsifiers above are not edited.
