# The cost of the ceiling

**Stamp:** `20261008.184553`
**Language:** EN
**Style:** Gauge at Field
**Voice:** Kyri
**Room:** checkable -- a cost read from the comment, with no new timing
**Status:** Living -- Leo of the orbit that opens at commit 8,071

Commit 8,075 is Leo, fixed fire, talent. An economics check. This round reads. It edits no function, opens no wallet, and spends no fund.

`current` in `mantra/src/weave.rye` begins at line 1690. It walks the backing list and copies each present line into a slice the caller owns. The comment above it, at lines 1669 through 1681, records a measurement already taken on this pier: ReleaseSafe, twenty reads, best of three runs.

| Present lines | Before, then after, in milliseconds |
|---|---|
| 16,384 | 0.4, then 0.4 |
| 131,072 | 3.3, then 2.7 |
| 524,288 | 25.3, then 13.3 |

524,288 is half of `max_weave_lines`. At that size the read copies about sixteen megabytes of `Line`. This round did not run the timing again. The constant stays `1 << 20`.

The fascia face stays 60.0000, measured `20261008.184341`. The meter stays unrun. The shell grade stays 58.

Virgo leaves one small untidiness in place. Sky of this orbit opens at commit 8,083.
