# The duplicate-content census overstates its own case

**Stamp:** `20260918.072000` -- **Status:** Landed -- checkable, every reading below run on this
tree's own tracked bytes on this pier.
**Language:** EN -- **Style:** Gauge, Field setting -- **Voice:** Kyri
**Kin:** [`../../../foundations/20260825-211056_what-mantra-is.md`](../../../foundations/20260825-211056_what-mantra-is.md)
(name-to-bytes binding) -- [`../../../.claude/rules/stamp-and-name.md`](../../../.claude/rules/stamp-and-name.md)
(the 1,084 hand-filed-symlink import sites) -- [`20260918-064820_row-alignment-for-large-tally-gardens-an-energy-first-principles-check.md`](20260918-064820_row-alignment-for-large-tally-gardens-an-energy-first-principles-check.md)
(this lap's own prior energy paper)
**Aimed at:** Mantra (the name-to-bytes promise this proposal would spend), Bakery (who owns the
scoped follow-on named below)

## The question

Mantra's whole promise is that a name binds to bytes once and the binding never has to be earned
twice. That is usually read as a storage guarantee. It is also, in principle, a **compute**
guarantee: if two files hold the same bytes, a build system that keys its cache on content rather
than on path never has to recompile the second one. This note asks whether this tree's own
duplicate-content mass is large enough, and load-bearing enough, for that second reading to be
worth building toward.

## What was measured

Every tracked file was hashed with SHA-256 and grouped by digest, on this pier, `20260918.071525`:

```
git ls-files -z | xargs -0 -I{} sh -c 'test -f "{}" && sha256sum "{}"'
```

| Reading | Value |
|---|---|
| Tracked regular files | **19,082** |
| Files sharing their content with at least one other tracked file | **468** |
| Distinct duplicate-content groups | **175** |
| Extra bytes beyond one copy per group (sum of `(count-1) x size`) | **1,272,252** (~1.24 MiB) |

**Every one of these four numbers is FREE** -- the tree grows daily and both the numerator and the
denominator move. Run the command above rather than trusting the table.

## The obvious reading, and why it does not survive one file

The obvious reading: 1.24 MiB of duplicate source, much of it substantial (six groups run
20 KiB to 70 KiB per copy), is source Zig compiles twice for no reason a content-addressed build
would tolerate. `stamp-and-name.md` already names the mechanism producing it -- Zig's `@import`
refuses to escape the root file's own directory, so a room that wants another room's module keeps
a **hand-filed copy** rather than a symlink, and that page already counts **1,084** such import
sites across **75** directed room pairs.

The largest duplicate pair by size is exactly that shape:

```
69971 image/text_paint.rye
69971 pond/apps/text_paint.rye
```

Byte-identical by SHA-256, and the `pond/` copy's own header comment still names the file
`image/text_paint.rye` -- confirmed by direct inspection rather than inferred from the hash.

**And the falsifier fires on this exact pair.** `image/text_paint.rye` is imported live by five
sibling modules inside `image/` (`scrubber.rye`, `player_hud.rye`, `text_caption.rye`,
`text_grid.rye`, `text_panel.rye`, each via `@import("text_paint.rye")`). `pond/apps/text_paint.rye`
is imported by **zero** tracked sources:

```
grep -rln '@import("text_paint.rye")' pond/    # (no result)
```

So the single largest duplicate this census surfaced is not a file Zig recompiles twice. It is a
file Zig compiles **once**, sitting beside a copy nothing ever reaches. The census counts it as
1.24 MiB of "duplicate mass," and the honest number for a compute-avoidance argument is closer to
zero for this pair, since there is no second compilation to avoid.

## The number that would actually matter, and why this pass could not produce it

**Duplicate bytes are not the same claim as duplicate compute.** The claim a content-addressed
build cache would help is narrower: *bytes that are BOTH duplicated AND independently reached by a
live `@import`.* That number needs, for every one of the 175 groups, an exact-path resolution of
every `@import(...)` string in the tree against that group's members -- not a basename grep, which
over-collects. `color.rye` alone matches 73 files by basename across unrelated rooms (most of them
distinct modules that happen to share a name, not copies of one file), so a basename count cannot
stand in for an import-graph count.

This pass did not build that resolver. Doing it honestly needs the same directory-relative
`@import` resolution Zig itself performs, which is more machinery than one lap owes an unproven
hypothesis. Naming the gap here is the deliverable this pass can responsibly leave.

## What is buildable now, sized to one round

A witness, scoped narrowly:

1. Hash every tracked file (the command above already does this in under two minutes on this
   pier's 19,082 files).
2. Group by digest, keep only groups of size >= 2.
3. For each group, resolve every tracked source's `@import("...")` strings against the room-relative
   rule Zig applies (root file's own directory only, per `stamp-and-name.md`), and mark a group
   member **live** if some resolved import target is that exact path.
4. Report **live duplicate bytes** (both copies live, both independently compiled) separately from
   **inert duplicate bytes** (one or both copies unreached) -- the two numbers this note could not
   tell apart.

Only the first number is Mantra's business. If it comes back small, the compute-avoidance case
closes the way this pair already closed it, and Mantra's promise stays a storage guarantee alone.
If it comes back large, the buildable next step is a compilation cache keyed on content hash rather
than path for the hand-filed-symlink family specifically -- a much narrower target than "cache all
Rye compilation," and one Zig's own build cache (already seated at
[`../../../tools/p/parity_zig_cache_seat.sh`](../../../tools/p/parity_zig_cache_seat.sh)) may or may not
already provide, depending on whether its cache key is keyed by content across separate top-level
compilation units or only within one. That is a second, separate empirical question this note
also leaves open rather than guesses at.

## Assumptions, falsifier, confidence

**Assumptions.** Two files with identical SHA-256 digests compile to identical object code given
identical compiler flags -- true by construction for Zig, which is deterministic on unchanged
input. `@import` resolution follows the directory-local rule this tree's own law already states.

**Falsifier, stated for the live/inert split named above.** If a future exact-import-path scan
finds the live duplicate byte count is a small fraction of the 1,272,252-byte raw figure -- as the
one pair checked by hand here suggests -- the compute-avoidance argument is weak and Mantra's
content-addressing stays a storage promise rather than a compilation one. If it finds the opposite,
the case strengthens and names its own next witness.

**Confidence: low that meaningful compute is being wasted today.** The one large pair inspected by
hand pointed the wrong way for the hypothesis this note opened with, and the honest report is that
finding, not a rescued version of the original claim.

Every other figure in this note is HELD to the stamp above; the four census numbers are FREE and
should be re-read rather than quoted.
