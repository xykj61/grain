# Where a seed publish spends its minutes

**Language:** EN - **Style:** [Gauge](../context/GAUGE_STYLE.md) at Field - **Voice:** Kyri
**Stamp:** `20260916.121517` - **Status:** Landed measurement - **Room:** mixed -- the seconds and
counts are checkable on metal, the ordering it recommends is a proposal
**Lane:** bakery -- core infrastructure - **Answers:** [`the scrub that remembers`](../expanding-prompts/20260908-155715_the-scrub-that-remembers.md), REDS `%642`
**Instrument:** [`tools/fixtures/s/sow_phase_scan.sh`](../tools/fixtures/s/sow_phase_scan.sh) under [`tools/s/sow_phase_witness.rish`](../tools/s/sow_phase_witness.rish)

The design that books the scrub cache names what to measure before anyone builds one, and it
names a falsifier. This page is that reading, taken on metal on `20260916` in this pier's own
checkout. Every second below is **free** -- nothing holds it still and the tree grows daily -- so
run `sh tools/fixtures/s/sow_phase_scan.sh --time` rather than trusting a figure here.

## The two phases, measured

| Phase | Seconds |
|---|---|
| `tools/fixtures/s/sow_project.sh` -- the projection | **364.68** |
| `tools/s/sow_witness.rish` -- the proof | **354.09** |
| a publish, both together | **718.77** |

That reads as a fifty-fifty split between doing the work and proving it, and the split is an
illusion. Timed one at a time, the four things the witness actually proves cost **2.39 seconds
together**: the leak control 0.36, the manifest cover 1.28, the leak scan 0.44, the personal-path
scan 0.31. The remaining **99.3 percent of the witness is a second full projection**, run as its
own duty 2.

**The witness has a sound reason for that duty**, written in its own header: it reads `seed/`, an
absent `seed/` reads clean, and moving duty 3 ahead of duty 2 would turn the whole witness green
over nothing at all. The reason holds. What was missing was the price, and the price is one
projection -- roughly six minutes -- discarded the moment it is proven.

## Inside the projection

The candidate set is **9,046 tracked files** under the manifest's 107 `allow` rooms. The last
run copied 8,516, scrubbed 1,412, and withheld 135.

| Step | Files it touches | Seconds |
|---|---|---|
| enumerate the candidates | 9,046 | 1.43 |
| the armor grep | 9,046 | 56.69 |
| the identity grep, 76 alternatives | 9,046 | 103.10 |
| the `sed` scrub itself | 1,412 | 15.92 |
| the public-key grep on each copy | 8,516 | 55.79 |
| copy, make directories, loop | 9,046 | about 131 |

**So 363 of the projection's 365 seconds are per-file work**, and every one of those seconds is a
pure function of a file's bytes and its manifest verdict -- which is exactly the design's own
claim about what a build system may remember. The fixed cost is 1.43 seconds.

One number inside that table is worth reading twice. **The scrub the cache is named for costs
15.92 seconds**, four percent of the projection. The expensive part is the *classification*: two
greps every file pays, name-bearing or plain.

## How much changes between publishes

The seed is one force-pushed root commit, so the churn is read from the field's own history over
the same `allow` rooms.

| Two publishes apart by | Candidates changed | A content cache would hit |
|---|---|---|
| 1 hour | 16 (0.18%) | 99.8% |
| 6 hours | 118 (1.30%) | 98.7% |
| 12 hours | 170 (1.88%) | 98.1% |
| 1 day | 1,813 (20.04%) | 79.96% |
| 7 days | 2,512 (27.77%) | 72.23% |

The thirty-day span reads 10,385 changed against 9,046 candidates, which is above a hundred
percent and honest: a span wider than the set's own churn counts paths that have since left it,
so the denominator moved. Read it as *most of the room turned over inside a month*.

The design's founding case was two publishes twenty minutes apart differing by one file. At that
spacing the cache hits essentially everything.

**One zero in that table wears two facts, and the instrument now says which.** A churn span holding
no commit at all resolves to `HEAD` itself, so the diff can only read zero -- which prints exactly
like a busy span where the allow rooms genuinely stood still. The scan reads `churn_quiet=yes` for
the first and `no` for the second, and `unread` when the span reaches past all history. Read at
`20260916.183000` on this pier, with the fleet six hours quiet: the 1-hour and 6-hour spans both
answer `churn_quiet=yes`, so their hundred-percent hit rate says *nobody published anything* rather
than *the cache would hit everything*. The pen plants the pair, because either leg alone passes
under a scan that always answers the same word.

**The figures above were read at `20260916.121517`; this page landed on a later lap** after its
first send was lost, and the churn half was re-read on arrival: 12 hours reads 115 rather than 170,
1 day 1,788 rather than 1,813, 7 days 2,505 rather than 2,512, against 9,050 candidates rather than
9,046. Every one of those is free by the page's own first paragraph, and they moved by less than a
percent over six hours -- which is itself a small reading in the cache's favor. The seconds were
measured once and stand as testimony of that run.

## The falsifier, answered exactly

The design wrote: *if a measured publish spends most of its minutes in the witness rather than the
scrub, then caching the scrub buys little.*

**The letter of it fires, and the spirit of it points the other way.** A publish does spend half its minutes
in the witness -- and those minutes are scrub minutes wearing the witness's name. Under the
falsifier's own intent, which was to catch a publish dominated by *proving*, the proving costs
2.39 seconds and the cache is worth building.

## What follows, and the order

**The cache reaches both projections and weakens no proof.** Removing the witness's duty 2 was
the obvious cheaper repair, and it is the worse one: it buys back six minutes by taking away the
guarantee that the bytes being proven are the bytes the tree currently holds. A cache leaves that
duty exactly where it stands and makes it cheap, because between a publish's two projections
**nothing changes at all** -- the second run hits every entry. So one build closes both findings,
and the duplicate stays honest rather than being argued away.

Projected, with assumptions named: at a day's spacing a publish falls from about 719 seconds to
roughly 80 -- the first projection paying for its 20 percent of changed files, the second paying
almost nothing, and the proofs paying their 2.39 seconds unchanged. **Horizon:** the next
publish. **Assumption:** per-file cost stays roughly linear in candidate count. **Falsifier:** a
cache lookup costing more per file than the two greps it replaces.

**The key is already in the index, which is what makes this cheap.** A blob hash for all 9,046
candidates reads in **1.24 seconds** from `git ls-files -s`, and proving the working tree clean
costs **0.11**. So the design's three-part key -- content, manifest verdict, scrub version --
needs no hashing pass of its own on a clean tree. The one careful point is a *dirty* tree, where
the index hash and the bytes on disk part company: the honest answer there is to refuse the cache
and project in full, since a publish reading stale keys would ship bytes nobody proved.

## What this reading does not reach

**Whether the cache is worth its own complexity** past the arithmetic above -- that is a judgment,
and it belongs with the maintainer whose hand runs the publish.

**Custody.** Every step here stayed clear of gate `%1`. The scan reads scripts and git history; the
timings ran the projection and the witness, both of which an agent may run, and both of which stop
short of the push.

**One figure moved quietly between readings.** `construction/standing-equipment.kyri` records the
`sow` guard at **230 seconds** on `20260904`, which is why it sits on the cadence clock. It reads
**354.09** twelve days later -- half again as much -- and the roster's note still carries the elder
number. The guard's own cost is free too, and it grows with the tree it projects.
