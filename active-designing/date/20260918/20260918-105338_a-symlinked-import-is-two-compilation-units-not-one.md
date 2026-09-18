# A symlinked `@import` is two compilation units, not one

**Status:** Living, checkable -- the claim below is proven on metal in this same round.
**Room:** checkable (context/TWO_ROOMS.md) -- a witness reproduces the result directly.
**Stamp:** `20260918.105338`

## The question this closes

`construction/ITINERARY.md` carried an open line from an earlier Diffuser account. It asked
whether Zig's own build cache treats a symlinked `@import` as the same compilation unit as its
target. That account had found 121 of 127 duplicate-`.rye` digest groups (95%) reach one real
file through a tracked git symlink, mode `120000`, rather than a hand-filed copy. So the storage
question was answered: `sha256sum` follows the link, and the bytes on disk are one file. What
stayed open sat one layer up. Does the Zig compiler also see one file, or two?

## The experiment

Bound and small, run in `.lap/zig_symlink_probe/` with `vendor/zig-toolchain/zig` (version
`0.16.0`) on this machine, `20260918.105338`:

```
real/lib.zig        pub const marker: u32 = 424242;
link/lib.zig  ->  ../real/lib.zig     (a real symlink, ln -s)
main.zig:
    const A = @import("real/lib.zig");
    const B = @import("link/lib.zig");
    pub fn main() !void {
        std.debug.print("same_type={} A_ptr_eql={}\n",
            .{ A == B, &A.marker == &B.marker });
    }
```

`@import` returns a Zig `type` value naming a file's namespace. Comparing two `type` values with
`==` is a legal comptime operation and answers exactly the question at hand: does the compiler
resolve both import paths to one identity, or build two.

## The reading

```
same_type=false A.marker=424242 B.marker=424242 A_ptr_eql=false
```

**Two distinct types, two distinct addresses for the same constant.** Zig's compiler resolves
`@import` by the string path given at the call site. It never resolves by the file's real,
symlink-resolved identity. `real/lib.zig` and `link/lib.zig` are one inode and one set of bytes on
disk. To the compiler they are two separate compilation units, each parsed, type-checked, and
here, constant-folded on its own. The filesystem's symlink resolution made `sha256sum` read one
file in the storage question. That same resolution plays no part in `@import`, which walks the
string rather than the inode.

## What this settles, and what it opens

**Settled:** the tree's compute question from the duplicate-content account. A module reached
through a symlink compiles independently at every distinct import-path spelling that reaches it,
even when every one of those paths lands on the same bytes. The compiler pays full analysis and
codegen cost per import site, the same as if the file were N hand-filed copies. Storage-layer
deduplication (one inode, one git blob) buys disk space and nothing at build time.

**Falsifier, stated plainly, and already spent:** if `same_type` had read `true`, the claim above
would be wrong. The compiler would then canonicalize import paths before resolving identity. It
read `false`. The falsifier fired the way a falsifier should -- by settling the question, rather
than by failing to reach it.

**What stays open, one step further:** does `zig build`'s own incremental cache (the
`Cache.Manifest` machinery under `zig-cache/` or `--cache-dir`, distinct from the in-process
`@import` identity tested here) also treat the two paths as separate entries? That would double
disk cache usage and rebuild-trigger surface. Or does its content-addressed hashing collapse them
at that later stage instead? This note answers the compiler's type-identity question alone. The
on-disk build-cache question is a smaller follow-up, agent-doable directly: run two
`zig build-exe --cache-dir` invocations against the two import paths and diff the resulting cache
manifest directories.

## Reproduction

```sh
cd .lap/zig_symlink_probe   # or recreate the three files above
zig build-exe main.zig -femit-bin=probe && ./probe
```

Bounded, no hardware dependency, and a scratch pen under `.lap/` per [`read-scope`](../../../.claude/rules/read-scope.md) -- gitignored, this ship's own, cleared on the next lap's own terms.
