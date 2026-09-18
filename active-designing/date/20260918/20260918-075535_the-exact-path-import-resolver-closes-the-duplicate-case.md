# The duplicate-content census was mostly counting symlinks

**Stamp:** `20260918.075535` -- **Status:** Landed -- checkable, every reading below run on this
tree's own tracked bytes on this pier.
**Language:** EN -- **Style:** Gauge, Field setting -- **Voice:** Kyri
**Kin:** [`20260918-072000_the-duplicate-content-census-overstates-its-own-case.md`](20260918-072000_the-duplicate-content-census-overstates-its-own-case.md)
(the paper this closes the open question of) -- [`../../../foundations/20260825-211056_what-mantra-is.md`](../../../foundations/20260825-211056_what-mantra-is.md)
(the name-to-bytes promise this settles a reading of)
**Aimed at:** Mantra (the compute-guarantee reading this closes), Bakery (a compilation-cache
target this argues against building)

## The question left open

The prior paper named one buildable next step: resolve every `@import("...")` string in the tree
against its own importing file's directory -- the exact rule Zig applies -- rather than the
basename grep that over-collects, and split the tree's 175 duplicate-content groups into **live**
(both copies independently reached by a real import, so a content-addressed build cache would
avoid a real recompilation) and **inert** (one or both copies unreached, so there is no second
compilation to avoid). That resolver is now built. It found something the prior paper's own
premise had missed.

## The resolver, and what it found first

[`tools/fixtures/d/duplicate_import_liveness_scan.sh`](../../../tools/fixtures/d/duplicate_import_liveness_scan.sh)
hashes every tracked `.rye` file with `sha256sum`, groups by digest, and for each duplicate group
resolves every tracked `@import("....rye")` literal against its importer's own directory to decide
liveness. Its first run priced the hand-checked `text_paint.rye` pair correctly and then reported a
group -- `comlink/topology.rye` and five others -- at **193,055 extra bytes** for one digest. That
number came from `stat -c '%s'` on the first group member, and one member,
`classical-vedic-astrology/topology.rye`, reported a size of **23 bytes** against
`comlink/topology.rye`'s **38,611**.

**Twenty-three bytes is not a truncated file. It is the length of a symlink target string.**
`classical-vedic-astrology/topology.rye` is not a hand-filed copy at all:

```
$ git ls-files -s classical-vedic-astrology/topology.rye
120000 99a751158409c460cce818c1389fbcec43c86e38 0  classical-vedic-astrology/topology.rye
$ readlink classical-vedic-astrology/topology.rye
../comlink/topology.rye
```

Mode `120000` is git's own marker for a tracked symlink. `sha256sum` follows symlinks by default,
so it read `comlink/topology.rye`'s content through the link and reported a matching digest --
correctly, for what `sha256sum` measures. But the file `git` actually stores at that path is a
23-byte blob holding the string `../comlink/topology.rye`, not a 38,611-byte copy. **The original
census's hashing method could not tell a real hand-filed copy from a symlink to the same content,
because both hash identically once the filesystem follows the link.**

## What was measured, corrected

The resolver was rewritten to read git's own index (`git ls-files -s`), which distinguishes mode
`120000` (symlink) from `100644`/`100755` (regular file) directly, and to size regular-file groups
from git's own blob size (`git cat-file -s`) rather than a filesystem `stat` or `wc -c`, both of
which read through a symlink to the target's bytes. A group is excluded from the byte arithmetic
entirely when any member is a symlink, and counted separately, since a symlink stores no duplicate
bytes and the OS resolves it to the one real file on every read -- there was never a second
compilation to avoid.

Run on this pier `20260918.080100`:

```
sh tools/fixtures/d/duplicate_import_liveness_scan.sh [--list]
```

| Reading | Value |
|---|---|
| Tracked `.rye` files | **1,997** |
| Tracked `.rye` symlinks (mode `120000`) | **233** |
| Duplicate-content digests among `.rye` files | **127** |
| **Of those, groups where every member is a symlink** | **121 (95%)** |
| Groups where every member is a regular file (the real compute question) | **6** |
| -- of which live (>= 2 members independently reached by a real import) | **2** |
| -- of which inert (0 or 1 members reached) | **4** |
| Extra bytes in the 6 regular-file groups, live | **613** |
| Extra bytes in the 6 regular-file groups, inert | **867** |

**Every one of these eight numbers is FREE** -- re-run the scan rather than trusting the table; the
tree grows daily.

## The falsifier, checked against its own prior hand case -- and a correction inside it

The prior paper hand-verified one pair by inspection and called it a "hand-filed symlink" pattern:
`image/text_paint.rye` (five live importers) beside `pond/apps/text_paint.rye` (zero). The
resolver's corrected run shows the second half of that description was also wrong in the same way
as the topology groups:

```
$ git ls-files -s image/text_paint.rye pond/apps/text_paint.rye
100644 b6a4de3c1b29e13333413b317af88f6a06691c9f 0  image/text_paint.rye
120000 82816ee1d11e73d6283e6ddde37a5016003dc40d 0  pond/apps/text_paint.rye
```

`pond/apps/text_paint.rye` is **also** a symlink (`readlink` -> `../../image/text_paint.rye`), not
a hand-filed copy. The prior paper's liveness finding -- one side reached, one side dead weight --
still holds; a symlink target is either imported or it is not, exactly like a regular file. What
does not hold is the paper's naming of the pattern: this was never 69,971 bytes of duplicate
storage. It was 23 bytes of symlink plus one real file, and `sha256sum` alone could not tell the
two apart.

## The reading

**The tree has already mostly solved the compute-avoidance question, and did so before this
research thread existed -- not with a content-addressed build cache, but with ordinary filesystem
symlinks.** Of the census's 127 duplicate-`.rye` digests, **121 (95%) are a single real file
reached through one or more symlinks**, storing at most a target-path string at each linked
location and never a second copy of the source. The genuine hand-filed-copy population -- files
that are honestly separate bytes on disk and in git's own object store -- is **6 digests, 1,480
extra bytes total**, of which **613 bytes (41% of that small remainder)** are independently live.

This settles the question harder than the prior paper's falsifier did. **Mantra's name-to-bytes
binding stays a storage guarantee**, and the reason the compute case looked weak is that almost
none of what the census called "duplicate content" was ever duplicate storage to begin with --
`stamp-and-name.md`'s own description of a "hand-filed-symlink family" turns out to be mostly
literal symlinks already, with the genuine hand-filed-copy remainder measuring in the hundreds of
bytes rather than the megabyte the raw digest count implied.

## What stays open, named rather than guessed

Whether Zig's own build cache
([`../../../tools/p/parity_zig_cache_seat.sh`](../../../tools/p/parity_zig_cache_seat.sh)) treats a
symlinked `@import` target as the same compilation unit as a direct import of the real file --
i.e., whether the 121 symlink groups already save compile time as well as storage -- is untouched
by this reading and stays open. It needs Zig's own cache-key behavior checked directly rather than
inferred from the filesystem, and is a sharper, smaller question than the one this thread opened
with.

**What this resolver does not check:** an `@import` string built at comptime from concatenation
rather than written as a literal (none observed in a spot check); a symlink whose target is itself
a symlink (none found in this tree -- `readlink` was run on every tracked `.rye` symlink and every
target resolved directly); and whether any of the 121 symlink groups are dangling (checked
separately with `test -e` through every tracked `.rye` symlink -- none are).

## Assumptions, falsifier, confidence

**Assumptions.** `git cat-file -s HEAD:<path>` reports the exact byte count git stores for that
path's blob, which is authoritative for a storage-duplication claim in a way filesystem `stat` or
`wc -c` are not once a symlink is involved. `git ls-files -s` mode `120000` is the complete and
correct test for "this path is a tracked symlink."

**Falsifier, already checked twice.** The resolver's liveness verdict on the one hand-verified pair
matched the hand count exactly (`live=1`). The mode-`120000` reading was independently confirmed by
`readlink` returning a real, resolvable relative path for both example symlinks checked by hand.

**Confidence: high.** Both readings -- liveness and symlink-vs-copy -- rest on git's own index and
object store rather than an estimate, and every spot check by hand agreed with the automated
reading.

Every reading above is HELD to the stamp; the underlying counts are FREE and should be re-read with
the script rather than quoted stale.
