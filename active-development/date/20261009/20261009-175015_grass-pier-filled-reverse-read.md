# Grass reverse-read -- the pier that filled, traced to its oldest premise

**Stamp:** `20261009.175015` -- **Lane:** Grass (reverse-reading steward) -- **Room:** checkable
**Starts from:** `construction/ITINERARY.md` -> "THE PIER THAT FILLED" (`20260915.220053`, REDS %745)
**Measured at:** git nib `1e10934e01` (HEAD when read), clock `America/New_York`

This is one reverse-reading packet, as the Grass account asks: trace one present priority to its
oldest deciding premise, then name one disposition with its evidence. It rewrites no dated testimony.

## 1. The present priority

The card's top block asks one question: **whether the fleet reads its own free space at all.**
Its own words name the open part: the reclaim of 82G was a hand's word, and "nothing in the tree
reads free space."

## 2. The oldest deciding premise

Session log `session-logs/date/20260915/20260915-220053_the-pier-that-filled-while-nobody-read-it.kyri`
carries the premise in its own `obs` lines:

- **Nothing read the pier's free space.** The first reader was a `pwd` inside a send that answered
  `No space left on device`.
- **A pen never removed is a leak its maker never feels.** `tools/am/amphora_mark_wreck_witness.rish`
  made a 24MB `mktemp -d` pen per run and never removed it. 1,312 pens, 32G, from nine days.
- **The cost lands on the wrong hand.** The ship that needed space was an unrelated lane, mid-send.

So the premise under the priority is: *a shared pier with no instrument for its own free space
cannot tell a leak from a full disk.*

## 3. The evidence since then (read at this lap)

| Reading | Value | Held by |
|---|---|---|
| `df -h /` | 176G size, 147G used, **21G free, 88%** | run `df -h /` (free: moves every lap) |
| `/tmp` entries | **14,114** at this read (was 41,063 on `20260915`) | run `ls /tmp \| wc -l` (free) |
| Reclaim scan | `candidates=33 excluded=2 rebuildable=31 bytes_total=13258899456` (**13.2G** rebuildable), `verdict=reported`, removes nothing | `sh tools/fixtures/d/disk_reclaim_scan.sh` |
| Reclaim witness | rostered in `construction/standing-equipment.kyri`; witness `tools/d/disk_reclaim_witness.rish`, control `tools/fixtures/d/disk_reclaim_control.sh` | the roster, guarded |

The premise's first half, *nothing reads free space*, is **no longer true**: a rostered tool now
measures the rebuildable bytes a ship can give back, and it refuses to remove anything without
`--apply`. The `/tmp` leaker no longer makes its own `mktemp -d` pen: `tools/am/amphora_mark_wreck_witness.rish`
takes the runtime's pen (line 37), which a refusal releases too.

## 4. What is still open

Two halves of the premise are **not** closed by the tool above:

1. **A free-space gate.** The scan reports and gates nothing, so a pier can still reach 100% before
   any lap notices. Whether that gate exists is a seat question, not a Grass one.
2. **The unread remainder of `/tmp`.** `20260915` named 41,063 entries against 1,312 pens from one
   witness, and asked for a count of the rest. That count was never opened. At 14,114 entries now,
   the remainder is still unattributed.

## 5. Disposition: **revived** (the reclaim tool), with one standfast left

- **Revived** -- the reading the premise lacked now exists, is rostered, and is witnessed. Nothing
  further is built here.
- **Standfast (not built)** -- a free-space *gate*, and the attribution of the `/tmp` remainder.
  Both wait for Keaton's word: a gate changes what a lap is allowed to do, and the remainder needs
  a lap that may remove bytes it does not own.

The card's "Yours" question is therefore narrower than it was. The first half of "does the fleet read
its own free space at all" is answered yes, by measurement. The second half, whether a lap may refuse
to start on low space, is Keaton's.

## 6. What this does not reach

- Whether any particular `/tmp` entry is safe to remove. The packet read counts and attributes
  nothing beyond the pens already named.
- The remote pier's disk. Only this checkout's host was read.
