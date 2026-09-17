# Landed account -- COPAL, the seed spent its minutes starting grep

**Stamp:** `20260917.010818` (EDT)
**Language:** EN
**Style:** Gauge at Meter
**Voice:** Kyri
**Status:** Landed account, shelved at birth -- historical continuity outside Mitra and shred-prep
**Room:** checkable -- every reading below is held by a named guard or a named command
**Card:** [`../ITINERARY.md`](../ITINERARY.md)

## EARTH BREATHES IN -- take in the fact at the door

**Rota lap 5209, row 4.** Earth's sense is aroma, and its move is to take in the concrete fact
standing at the door before any argument about it. The fact at the door here was a stopwatch, and it
pointed the other way from the cure this red had booked for nine days.

## What was booked, and what the stopwatch said

REDS `%642` books a **content cache** for the seed projection, designed in
[`the scrub that remembers`](../../expanding-prompts/20260908-155715_the-scrub-that-remembers.md)
and measured in [`where a seed publish spends its minutes`](../../active-designing/20260916-121517_where-a-seed-publish-spends-its-minutes.md).
That measurement prices the projection at 364.68 seconds and names where they go: **56.69** in the
armor grep, **103.10** in the identity grep, **55.79** in the public-key grep on each copy, about
**131** in the copy loop, and **15.92** in the scrub the cache is named for.

The design's own falsifier asks whether the minutes are the scrub's. The reading this lap took asks
a question one layer down: **are they reading, or are they starting?** Over a 500-path sample of the
same candidate set, a shell loop calling `grep` once per file runs **6,624 ms**; one `grep` handed
the same 500 files runs **186 ms**. A factor of **35**, and the bytes read are identical.

## The mechanism

`tools/fixtures/s/sow_project.sh` walks every tracked file under the manifest's 107 `allow` rooms.
For each one it used to start a `grep` for the armor blocks, a second `grep` for the identity list,
a `basename`, a `mkdir -p`, a `cp`, and -- on the copy -- a third `grep` for an ssh key.

It now classifies in **three batched passes**. The candidate list is built once and written to a work
file outside `seed/`; the two path-only refusals -- the manifest's `sub_exclude` and the key-material
name guard -- are decided by the shell's own `case` and `${f##*/}` rather than by a `basename`
process; the armor and identity passes each run as one `grep` over the whole list, chunked by
`xargs`; the scrub runs its `sed` per file, which is the one per-file process this projection genuinely
owes; the post-scrub identity re-read and the ssh-key read each run once over the destinations; and
the three logs are written at the end by a single `awk` that walks the candidate list, so they keep
the candidate order the elder's own appends produced.

**A batch may not decide one file's verdict from another file's bytes**, and none of these do: every
list is a membership set keyed by path.

## What the batched classification reads, on the same corpus

| Pass | Per file (`sow_phase`, `20260916`) | Batched (`20260917`) |
|---|---|---|
| identity, 9,096 candidates | 103.10 s | **0.74 s** |
| armor, 9,096 candidates | 56.69 s | **0.24 s** |

Both figures are **free** -- they move with the tree and with the machine's load. Run them rather
than reading them.

## The parity, proven three ways on the real field

The elder script was run out of `git show HEAD:` into a kept tree, the new one run after it, and the
two compared:

| Reading | Entries | Differences |
|---|---|---|
| file content, SHA-256 | 8,569 | **0** |
| tree entries with type and mode | 9,239 | **0** |
| symlink targets | 239 | **0** |

The receipt line agrees to the digit: `SOW_OK copied=8566 scrubbed=1415 withheld=135` from both.
A plain `diff -r` prints 26 lines and **not one of them is a difference** -- each is `diff` refusing
to follow a dangling symlink into `linengrow`, a room the manifest withholds, and both trees carry
the same 239 links to it. That is why the parity above is read from digests, types, modes and link
targets rather than from a `diff` exit code.

## The whole-projection seconds, and their honest caveat

The batched projection ran **149.29 s** and then **106.78 s** on this pier. The elder run that
produced the compared tree took roughly **23 minutes** beside a standing roster pass, and a second
elder run started for a clean comparison was stopped at **600 s** still unfinished. So the
whole-projection ratio is **not** a clean reading: the two ran under different load, and a fork loop
suffers more under load than a single process does. The clean claim is the classification table
above, measured on one corpus minutes apart.

## Proven

`tools/s/sow_project_witness.rish` over `tools/fixtures/s/sow_project_control.sh` --
**28 legs, 0 failing**, on a throwaway git field carrying one file per branch: plain, name-bearing,
unscrubbable, armored, key-named, sub-excluded, executable, ssh-key-bearing, nested, and outside the
allowlist. Every refusal is planted and then lifted. **Four mutations bite**: dropping the armor
pass ships the armored blob, dropping the post-scrub identity read ships the handle the scrub cannot
remove, dropping the ssh pass ships the raw key, and silencing the batch refusal finishes green over
a field nobody classified. The last one is why `batch_match` refuses rather than returns -- a batched
match that cannot run must never answer *nothing matched*, since that reads exactly like a field with
no maintainer in it.

**Until this lap the projection had no guard over any of its branches.** `sow` proves the projected
tree carries no identity string, which is the right question about the OUTPUT and says nothing about
whether a branch still runs.

`sow_allow_reach`, `sow_lock` and `sow_reach_inputs` are GREEN beside it. The last one **reddened on
the first draft and was right to**: its control plants a `sed` that exits 9 and expects the projection
to exit 9, and the first draft piped the destination list through `sed` to add the seed prefix, so a
broken `sed` failed where a directory would have been made rather than where the scrub is. `awk`
writes the prefix now, and the only `sed` this script runs is the scrub itself.

## The red this found, and why it may not be repaired here

REDS `%804`. The manifest's withholds are read as `awk '{print $2}'`, so the entry
`sub_exclude gratitude/Your customers hate MVPs. Make a SLC instead..html` becomes the rule
`gratitude/Your`. The candidate walk word-splits that same path into six fragments, every one of
which fails `[ -f ]`. **Two faults cancel**: the article stays out, the excluded log never names it,
and every gate reads green. Repairing either half alone publishes a copyrighted article. One
`sub_exclude` entry of 146 carries a space and one candidate path of 9,096 does -- the same file.
The batched classification landing here preserves the elder reading exactly rather than widening it.

## The roster note that was measurably wrong

`construction/standing-equipment.kyri` explains the `sow` row's slower clock by saying its cost is
**inherent** -- *real work rather than a fork loop*. Most of it was a fork loop. The note carries the
correction and the row keeps its cadence tier, which rests on its other reason: the publish is
custody gate `%1` and no lap can take the act it protects.

## MINE

The QA card grades `sow_project.sh` at **B/80**, register 40 on a reading of 20 sentences at 60
percent negative. The subject of those sentences is what must never ship, so the negatives are the
page telling the truth; the reading is left standing rather than bent to clear a ceiling. The control
reads **B+/86** and the witness **B+/87**.

**And I reddened a guard by running a projection beside the roster.** The cold endurance run answered
`sow_allow_reach red 0s` because my elder baseline had cleared `seed/.sow-projection.log` and not yet
rewritten it -- REDS `%193`'s own class, met from the other side. It is green again, and the lesson
costs nothing to state: a projection and a roster pass want different hours.

## YOURS

**The copy loop is the next fall, and it is larger than what fell here.** `sow_phase` prices it at
about 131 seconds of `mkdir` and `cp` per file, against the 160 the three greps carried. `cpio -pdm`
or a `tar` pipe would take it in one process; the reason this lap left it alone is that a copy
mechanism decides modes, symlinks and dangling targets, and those are exactly the four readings the
parity proof reads. One lap, with the same three-way parity, or leave the copy per file?

**And the second projection is still standing.** `sow_witness.rish` runs a whole second projection as
its duty 2, which `sow_phase` prices at 99.3 percent of that witness's 354 seconds. The batching
halves both, and the duplicate itself is a separate question its own paper already named.
