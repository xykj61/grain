# The handoff from the eight-core round

**Setting:** Gauge, Field -- **Voice:** Kyri -- **Status:** Living, for the next incense session
**Read this first, then `construction/ITINERARY.md` whole, then the newest day shelf.**

## What you are walking into

Eight ships now, on a pier that grew to 8 vCPU and 16 GB mid-round. Every Earth seat reads `live`
and every tree exists. Everything is landed and the doors are even.

| Reading | Value |
|---|---|
| HEAD, `xy`, `gp405` | all even |
| Trees on the pier | **8** -- incense, pheromone, petrichor, bakery, diffuser, grass, copal, patchouli |
| `fleet_key_locality` | 8 trees, 36 paths, **0 foreign** |
| Roster | `tier_lap` 114, `tier_cadence` 47, lap pass **705s** (was 901s) |
| Guards with no declared tier | **62**, ratcheted, falls when a hand decides one on touch |
| Public seed | published, both doors at `5a54c2f` |

## The doors that are Keaton's

Surface these and stop; each one is his hand by design.

1. **Root partition** -- `vda` is 350 GB and root is 179.5 GB, so ~170 GB is unallocated. The
   commands were handed over; `growpart` and `gptfdisk` are pre-fetched into the nix store. Needs
   root, which no agent has here.
2. **Fresh keys per ship** -- copal and patchouli were born copying the field's keyring, so they
   sign as the keeper rather than as themselves. Rotating is `rishi/bin/rishi run
   tools/g/generate_jail_local_keys_linux.rish rotate` **from a plain host shell**, by that script's
   own standing instruction: a revocable key is a weaker promise if the agent that will use it also
   made it.
3. **`%430` and `%431`** still wait on his word.
4. **Three gated guards** -- `rule_twin` (%7), `pond_enclosure_policy` and
   `pond_enclosure_ephemeral` (%5).
5. **petrichor holds 11 uncommitted files** and pheromone holds a stash. Their lanes, their hands.

## What this round learned, in the order it hurt

**Repair the factory, not only its output.**
Three copies of a `gpg.sh` wrapper were fixed in the morning while the generator that stamps them
kept writing the elder shape. Ask what makes the thing you just fixed.

**A skip must say it skipped.** The key generator printed *a signing key already
exists ... leaving its material alone* and a hand asking for fresh keys would have read three
cheerful reports and held the same keys. It says `NO NEW KEY WAS MADE` now. When a tool declines to act, the words carry that.

**A peer's finding is testimony, and testimony is checked.** The Petrichor seat reported that
`--next` had answered it one too high. That was written into a live comment and a commit body
without verification, and it was false -- `%435` was on the anointed spine all along. Petrichor
corrected it on its own next lap. **A finding that explains itself well is the easiest kind to
publish unverified.**

**A guard proves behaviour; a pen holds the case.** Three roster-control legs named
`bakery` as their berthed example and asserted against the real roster, so a lawful promotion
reddened them. Plant the case in a pen; assert behaviour, never the fleet's current state.

**Prove a refusal from both sides.** Every control this round plants
the fault, sees the bite, removes the plant, and sees green. Twice a test of mine nearly passed for
the wrong reason -- `head -2` swallowing an exit code, and a `loops` denial reading as *No such
file* because the newborn had no such directory. Ask of every green test: could this have failed?

**Cost is context times turns.** Measured from the transcript: **123,823 cache-read tokens per API
call against 564 output**, a 220:1 ratio. `read-scope` is worth more than any billing choice --
`MAP.md` rather than an `ls`, a witness resolved by name rather than a walk of `tools/`.

**An agent waits on the model rather than on a core.** Three live agent processes sampled over ten
seconds used 0.17, 0.02, and 0.00 cores. Cores serve the roster and the builds; fleet size follows
from how often those run, rather than from cores per ship.

## The two laps standing ready

**Mantra's weave.** `mantra/` holds 32 Rye modules and 9,175 lines with 120 files reaching into it,
and it was named for a structure it has yet to grow -- one weave holding every line a file ever
held, whose merges succeed by construction and whose conflicts are shown rather than thrown. The
design is charted at `active-designing/20260905-153729_mantra-was-named-for-the-weave.md`, sized to
one orbit in six movements. Patchouli owns that lane now.

**Amphora's proofs.** `amphora/` holds 10 modules and 3,861 lines and 16 witnesses, and today its sixteen joined the roster for the first time. Copal owns it.

## The habits that carried this round

- **Measure before you answer.** Every number above was read off the machine, and three of this
  round's findings exist only because a measurement contradicted a plausible story.
- **Book the red before the fix.** `construction/REDS.md`, three fields, and the number comes from
  `sh tools/fixtures/r/reds_spine_derive_scan.sh --next` -- which refuses mid-rebase now, and prints
  exactly one line.
- **Hold still while the roster runs.** A pass whose tree moved under it reports about a tree that
  no longer exists.
- **Name what you did not do.** Every commit body this round says which half is proven and which is
  precaution.

## The wall you will meet

The commit-message hook refuses a body carrying fewer than three mechanism words -- *file, script,
function, field, directory, call, constant, type*. It refused eleven times this round and earned each one: a body that
describes a change beautifully while naming no file leaves a reader with an image where a diff
should be. Name the file, name the field, then say why it matters.
