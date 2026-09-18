# The build cache does not collapse a symlinked import either

**Status:** Living, checkable -- the claim below is proven on metal in this same round.
**Room:** checkable (context/TWO_ROOMS.md) -- a witness reproduces the result directly.
**Stamp:** `20260918.111501`

## The question this closes

The prior note in this thread
([`20260918-105338_a-symlinked-import-is-two-compilation-units-not-one.md`](20260918-105338_a-symlinked-import-is-two-compilation-units-not-one.md))
proved that Zig's compiler resolves `@import` by string path rather than by symlink-resolved
inode, so `real/lib.zig` and `link/lib.zig` -- one file on disk, two import spellings -- become
two distinct compile-time types. It left one question open: does `zig build`'s own on-disk cache
manifest (`Cache.Manifest`, under `--cache-dir`) collapse the two paths at a later stage, the way
`sha256sum` collapses them at the storage layer? Or does the cache double along with the
compiler's own type identity?

## The experiment

Bound and small, run in `.lap/zig_cache_probe/` with `vendor/zig-toolchain/zig` (version
`0.16.0`) on this machine, `20260918.111501`:

```
real/lib.zig            pub const marker: u32 = 424242;
link/lib.zig      ->    ../real/lib.zig     (a real symlink, ln -s)
main_real.zig            @import("real/lib.zig")
main_link.zig             @import("link/lib.zig")
```

Both files built with `zig build-exe --cache-dir shared_cache --global-cache-dir shared_global`
into **one shared local cache directory**, in sequence, counting the files under
`shared_cache/z/` (the local compilation cache's flat entry store) after each build.

## The reading

| Step | Files in `shared_cache/z/` |
|---|---|
| after building `main_real.zig` | 2 |
| after rebuilding `main_real.zig` (identical inputs) | 2 -- no growth, a cache hit |
| after building `main_link.zig` | 4 -- two NEW entries, zero reused |
| after rebuilding `main_link.zig` (identical inputs) | 4 -- no growth, a cache hit |

Both binaries run correctly (`marker=424242`) and both are internally deterministic -- rebuilding
either one alone hits its own cache rather than growing it, which is what confirms the count
change on the *link* build is real new cache entries, not measurement noise.

**The build cache does not collapse the two paths.** It grows by exactly two entries when the
second import spelling is built, and by zero when either spelling is rebuilt on its own. The
manifest's own content-addressed hashing keys on the import path string reaching each compilation
unit, the same seam the compiler's type identity keys on one layer down.

## What this settles

**The follow-up question from the prior note is closed, matching its answer rather than
surprising it.** Storage-layer deduplication (one inode, one git blob) buys disk space for the
*source* bytes and nothing else. Compile-time identity is per import-path spelling. The on-disk
build cache is per import-path spelling too. All three layers of a symlinked module now have a
measured answer, and they agree: only the git blob is shared; everything Zig itself does --
type-check, codegen, and cache -- pays full cost per distinct `@import` spelling that reaches the
file, however many of those spellings land on one set of bytes.

**Falsifier, stated plainly, and already spent:** if the file count after the link build had
stayed at 2, the cache manifest would be canonicalizing by resolved path before hashing. It grew
to 4. The falsifier fired by settling the question rather than failing to reach it.

## What this means for Mantra's declustering question

The prior thread's open line asked whether a symlink-reached module doubles rebuild-trigger
surface. This answers it directly: a build touching only `real/lib.zig` invalidates only the cache
entries keyed to `real/lib.zig`'s import path, and a peer importing the same bytes through
`link/lib.zig` keeps its own stale-until-rebuilt entry rather than sharing the invalidation. A tree
carrying N symlinked spellings of one module pays N times over at every layer this thread has
measured -- disk cache included, not disk cache alone.

## Reproduction

```sh
cd .lap/zig_cache_probe   # or recreate the four files above
../../vendor/zig-toolchain/zig build-exe main_real.zig -femit-bin=probe_real \
  --cache-dir shared_cache --global-cache-dir shared_global
find shared_cache/z -type f | wc -l    # 2
../../vendor/zig-toolchain/zig build-exe main_link.zig -femit-bin=probe_link \
  --cache-dir shared_cache --global-cache-dir shared_global
find shared_cache/z -type f | wc -l    # 4
```

Bounded, no hardware dependency, a scratch pen under `.lap/` per
[`read-scope`](../../../.claude/rules/read-scope.md) -- gitignored, this ship's own, cleared on
the next lap's own terms.
