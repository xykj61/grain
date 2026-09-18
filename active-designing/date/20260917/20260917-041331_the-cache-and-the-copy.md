# The cache and the copy -- what a seed publish costs once the greps are gone

**Language:** EN - **Style:** [Gauge](../context/GAUGE_STYLE.md) at Field - **Voice:** Kyri
**Stamp:** `20260917.041331` - **Status:** Landed measurement - **Room:** mixed -- the seconds and
shares are checkable on metal, the ordering it recommends is a proposal
**Lane:** copal -- the crossing and the vessels - **Answers:** [`the scrub that remembers`](../expanding-prompts/20260908-155715_the-scrub-that-remembers.md), REDS `%642`
**Elder reading:** [`where a seed publish spends its minutes`](20260916-121517_where-a-seed-publish-spends-its-minutes.md), taken before the batching lap
**Instrument:** `SOW_TIME=1 sh tools/fixtures/s/sow_project.sh`, proven by [`tools/s/sow_project_witness.rish`](../tools/s/sow_project_witness.rish)

A publish was measured on `20260916` and the reading booked a cache. Between that reading and this
one the projection stopped spawning a process per file, so every number the ruling stood on moved.
This page re-takes the reading on the tree as it stands, and answers what the cache still reaches.

**Every second below is free** -- nothing holds it still, the tree grows daily, and eight ships
share this pier. Run the command rather than trusting a figure here.

## The projection, step by step

The projection reports its own step seconds now. Two runs back to back on `20260917`, over 9,116
candidates under the manifest's 107 `allow` rooms, copying 8,585 and scrubbing 1,417:

| Step | Run 1 | Run 2 | Share of run 1 |
|---|---|---|---|
| enumerate the candidates | 1.48 | 1.54 | 2.1% |
| the two path-only refusals | 8.85 | 9.42 | 12.5% |
| the armor grep, batched | 0.22 | 0.22 | 0.3% |
| the identity grep, batched | 0.51 | 0.55 | 0.7% |
| one verdict per candidate | 0.04 | 0.06 | 0.1% |
| make every destination directory | 0.10 | 0.10 | 0.1% |
| **the plain copies** | **38.10** | **40.32** | **53.7%** |
| **the `sed` scrub** | **20.32** | **18.44** | **28.7%** |
| the post-scrub identity re-read | 0.74 | 0.73 | 1.0% |
| the public-key read and stub | 0.50 | 0.46 | 0.7% |
| the three logs | 0.02 | 0.02 | 0.0% |
| **step total** | **70.89** | **71.84** | |

The projection's own wall time reads **75.91** seconds, the five seconds above the step total being
the lock, the manifest read, the seed wipe, and the receipt.

## The publish, against the elder reading

| Phase | `20260916` | `20260917` |
|---|---|---|
| the projection | 364.68 | **75.91** |
| the witness, whose duty 2 projects again | 354.09 | **99.90** |
| a publish, both together | 718.77 | **175.81** |

**A publish fell 4.1 times with no cache built at all**, because the cost was starting `grep` rather
than reading bytes. The three classification reads that priced at 215.58 seconds together now price
at **1.47**.

## What the cache still reaches

The design keys a scrub result by content, manifest verdict, and scrub version, and the elder
reading justified it on the classification: two greps every file paid, name-bearing or plain, at 59
percent of the projection. That justification has been spent.

What a content-keyed cache reaches today is the `sed` scrub at 20.32 seconds and the four batched
reads at 1.47, so **about 21.8 seconds of a 70.89-second projection, 31 percent** -- and, since a
publish projects twice and the second projection changes nothing, close to **44 seconds of a
175.81-second publish, 25 percent**. That is a real saving and a smaller one than the row was
booked for.

## What no scrub cache reaches, and this is the finding

**The copy is 53.7 percent of the projection, and a cache cannot remove it.** The projection clears
`seed/` before it begins, so every kept file is placed again on every run whatever a cache
remembers about its contents. A cached answer spares the transform; the bytes still have to land.

Reaching that cost means **not clearing `seed/`** -- syncing the tree in place and touching only
what changed. That is a different instrument with a different guarantee: the wipe is what makes a
file from an elder projection impossible, and `stale_projection_file_cleared` is a leg the
projection's own pen already proves. An incremental sync would owe its own proof that a withdrawn
file leaves, which is the harder half and the one worth naming before anyone starts.

## The step nobody had counted

**The two path-only refusals cost 8.85 seconds and spawn no process at all.** It is one `while read`
over 9,116 lines running two `case` tests, and it costs **six times all four batched greps
together**. The batching lap replaced its own per-file greps and walked past the shell loop beside
them, because the elder table had no row for it. One `awk` pass over the same list would take it
under a second.

## What to do, in order

1. **Fold the path refusals into one `awk` pass.** About 8.9 seconds per projection, 17.8 per
   publish, no new guarantee to prove, and the projection's pen already covers every branch it
   touches. One lap, in this lane.
2. **Then weigh the cache against the copy.** At 21.8 seconds saved against 38.1 still spent, the
   cache is no longer the larger half of its own projection, and whether to build it before the
   sync is a question the elder reading could not have asked.
3. **The sync stays a proposal.** It buys the largest single number here and it moves a guarantee,
   so it wants a design and Keaton's eye rather than a lap.

## The falsifier, re-answered

The design asks: *if a measured publish spends most of its minutes somewhere other than the scrub,
caching the scrub buys little.* The elder page answered that the minutes were scrub-shaped minutes
wearing other names. Today a quarter of a publish is the scrub and its reads, a half is placement,
and an eighth is a shell loop -- so the honest answer is **the cache buys a quarter, the copy owns a
half, and the row's ordering wants revisiting rather than its premise**.

**Horizon:** the next publish. **Assumption:** per-file cost stays roughly linear in candidate
count, and the pier's other seven ships contend evenly across the runs compared.
**Falsifier:** a third timed projection whose copy step falls below its scrub step.
**Confidence:** high on the shares, since two runs agree within three percent on every step.

Custody gate `%1` stands exactly where it stood. Nothing here publishes, and no byte left this pier.
