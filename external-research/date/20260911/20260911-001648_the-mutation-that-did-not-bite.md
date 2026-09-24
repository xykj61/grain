# The mutation that did not bite -- what a control leg proves, and what it only claims

**Stamp:** `20260911.001648`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- **Room:** mixed. The mechanism is checkable and named below by witness and
control; the reading about what a control leg earns is research for understanding.
**Kin:** [`20260910-230908_identical-output-is-not-a-proof.md`](20260910-230908_identical-output-is-not-a-proof.md)
-- [`../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md`](../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md)
-- [`../.claude/rules/derived-spine.md`](../.claude/rules/derived-spine.md)
**Instruments:** [`../tools/fixtures/r/reds_spine_derive_scan.sh`](../tools/fixtures/r/reds_spine_derive_scan.sh)
-- [`../tools/fixtures/r/reds_spine_derive_control.sh`](../tools/fixtures/r/reds_spine_derive_control.sh)
-- [`../tools/r/reds_spine_derive_witness.rish`](../tools/r/reds_spine_derive_witness.rish)

## What this lap changed

`reds_spine_derive_scan.sh` reads the REDS ledger's spine -- 440 files on this tree as of
`20260911.001648` -- and extracts one `(number, stamp)` pair per row. The elder form piped each
file into its own `sed`, which is 440 processes asking one question of 440 files already on disk.

`sed` accepts many file operands and concatenates them, so the walk is now two invocations: the
shell accumulates paths with `set -- "$@" "$f"` and flushes at `MAX_SED_OPERANDS=256`.

**Measured `20260911.001000` on this pier** (Vultr Dallas, AMD 8-core guest, NixOS), by
`strace -f -e trace=execve`:

| Reading | Before | After |
|---|---|---|
| `execve` total | 483 | **45** |
| `sed` | 442 | **4** |
| `awk` | 10 | 10 |
| `git` | 4 | 4 |

**Wall clock, five runs of each form alternating in one minute**, at a 1-minute load average of
9.4 to 10.3 on 8 cores: the elder read 2,721 / 3,063 / 3,040 / 2,942 / 3,021 ms; the new form read
909 / 861 / 846 / 896 / 1,021 ms. That is **3.4x by median**. Alternating rather than batching is
what makes the comparison fair on a loaded host, since a drifting load lands on both forms equally.

Across this lap and the one before it, the same guard has gone from **14,157 ms and 1,745
processes** to **896 ms and 45**.

**Output is byte-identical**, 63 lines, elder against new, checked by `diff`. Five readers of this
scan run GREEN: `reds_spine_derive`, `reds_ledger_monotone`, `unshared_citation`, `reds_citation`,
`pre_push_spine`.

## The interesting part -- a leg that passed its own mutation

Three control legs were written for the chunk seam, and each carries a comment naming the fault it
bites. The legs were then proven the only way a leg can be proven: **remove the mechanism and watch
the leg refuse.**

| Mutation | What it removes | Legs that bit |
|---|---|---|
| Drop the final short-chunk flush | the last 184 files of the spine | **11 of 24** |
| `set -- $@ $f` rather than `set -- "$@" "$f"` | one operand per spaced path | **1** |
| `[ "$pending" -gt 0 ] && pairs_of ...` rather than `if` | the flush's insulation from `set -e` | **0** |

The third mutation passed every case. Its comment claimed that a trailing `&&` reading false would
end the script under `set -e`, handing a caller exit 1 -- a gated refusal -- for a perfectly clean
spine. **Measured directly rather than reasoned about:** a false AND-list mid-script returns 1 and
execution continues; `set -e` is exempt there by POSIX, because the failing command sits in an
AND-OR list other than the last position. The script then exits on its own final line.

So the `if` form is worth one line as insurance against the flush ever moving to the end of the
file, and it is **not** what the leg proves. Both comments now say so.

## What a control leg earns

A leg earns its comment when removing the mechanism makes it refuse. Until that check runs, a
leg's comment is a hypothesis about the leg, written by the hand least able to doubt it -- the one
that just wrote the mechanism and already believes in it.

This is the same shape the previous lap met from the other side. There, a defect survived because
the live tree could never present the input that exposes it, and a pen could. Here, a leg survived
its own mutation because the hazard it named was real in general and absent in this file. Both are
the gap between *the check passed* and *the check would have caught it*, and only one experiment
closes that gap in either direction.

## Bounds, and what this does not reach

**The chunk bound applies per call, and the file count itself stays free to grow.** 256 paths is roughly 16 KB of argument list. The
smallest `ARG_MAX` a POSIX host may declare is 4,096 bytes, and this host declares 2,097,152; the
bound is chosen against the floor rather than against this machine. A spine that grows past any
multiple of 256 flushes and starts again, so the file count itself stays unbounded and the
collection in hand stays bounded -- which is what TAME asks of a loop.

**The remaining 45 processes stand.** Ten `sort`, ten `awk`, six `grep` and four `git` each ask
their own question, where the 440 `sed` calls asked one question 440 times. The cheap
order-of-magnitude cut in this file is spent.

**It does not reach the other scans.** The one-process-per-row habit was read in three joins of
this file and repaired in two laps; whether it stands elsewhere is a census nobody has run, and
naming a number here without running it would be the thing this page was written against.

## The falsifiers, and their verdicts

**Horizon:** these hold for this guard on this pier until the ledger's file count or the host's
argument limit changes.

| Falsifier | Verdict |
|---|---|
| Output differs from the elder form on this tree | **passed** -- byte-identical, 63 lines |
| `execve` fails to fall below 100 | **passed** -- 45 |
| Wall clock fails to fall at all | **passed** -- 3.4x by median, alternating at equal load |
| A row is lost or repeated at a chunk seam | **passed** -- 259 rows across a 256 seam, and again at a forced bound of two |
| A new control leg passes when its mechanism is removed | **fired** -- one of three; named and corrected above |

**Confidence:** high for the first four, which are measurements on metal with both sides run in one
minute. The fifth is a statement about three mutations rather than about every mutation, so it
bounds what these legs catch and claims nothing about what they miss.

