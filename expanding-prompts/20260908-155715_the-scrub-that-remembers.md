# The scrub that remembers -- an incremental seed publish

**Language:** EN - **Style:** [Gauge](../context/GAUGE_STYLE.md) with [Radiant](../context/RADIANT_STYLE.md) - **Voice:** Kyri
**Stamp:** `20260908.155715` - **Status:** Proposed, booked as the scrub red (`20260908.155715`) - **Room:** checkable
**Lane:** bakery (core infrastructure and the fleet's own friction), with the seed's own custody gate intact

## What happened, and why it is worth a lap

Two seed publishes ran twenty minutes apart in one sitting. They differed by one rewritten README.
**Each projected and proved all 8,187 files through a 251-rule manifest**, and each exceeded the
ten-minute foreground bound and finished in the background. The second run rediscovered, file by
file, everything the first run had already established.

## The insight, in one line

**The scrub is a pure function of a file's content and its manifest verdict**, so its answer is
cacheable by content.

Given the same bytes and the same verdict, the scrub produces the same output every time. That is
the definition of a thing a build system may remember -- and Rishi *is* the build system this tree
already has. **A build system that reruns unchanged work is a build system with its cache switched
off.**

## The shape

**A key that names the answer.** For each tracked path: the blob hash of its content, the manifest
verdict it resolves to, and the version of the scrub itself. When all three match a previous run,
the previous output stands.

**Content addressing is the tree's own answer here**, which is what Tablecloth holds. A scrub result
keyed by content is exactly a thing held by what it is rather than where it sits.

**The scrub version belongs in the key**, so improving a scrub rule invalidates every entry it could
have touched. A cache keyed only on content would keep serving the elder rule's answers forever.

## What stays whole, and this is the load-bearing clause

**The sow witness reads the entire projection before any push.** What caches is the *per-file scrub*;
the proof stays whole. A cache that also skipped the proof would publish on faith, and the whole
value of this gate is that it publishes on evidence.

So the saving lands where the cost actually is -- transforming thousands of unchanged files -- while
the guarantee stays exactly where it is today.

## What to measure first, before building

**How much of a publish is the scrub?** Time the phases separately: projection, per-file scrub, the
witness, and the commit. If the witness dominates, this cache saves little and the lap should stop
there and say so.

**How many files actually change between publishes?** Two publishes in one sitting differed by one
file. A week apart they might differ by hundreds. The ratio decides whether this is a large win or a
small one, and it is one command against the git history.

## The falsifier

If a measured publish spends most of its minutes in the witness rather than the scrub, then caching
the scrub buys little, and the honest outcome is a page recording that with its numbers.

## Where it must stay careful

The publish force-updates two public repositories, which is **custody gate `%1`**. Any change here
keeps the gate exactly where it stands: the bare form proves, and the maintainer's own word pushes.
A faster publish that is easier to run by accident would be a worse tool than a slow one.
