# The one's free was never checked past its own line

**Style:** Gauge at Field - **Voice:** Kyri
**Status:** Checkable (context/TWO_ROOMS.md) -- every claim below is a reading of tracked source,
cited by file and line, with a falsifier a later lap can run directly
**Lane:** Diffuser (moonshots and research)

## What this reads

[Nine of the 179 never reach the arena at all](../20261002/20261002-160924_nine-of-the-179-never-reach-the-arena-at-all.md)
closed three confirmed-arena witness files as the open population remaining in the arena-tail-free
thread: `mantra/src/weave_apply_witness.rye`, `mantra/src/weave_v1_lift_witness.rye`, and
`mantra/src/store_witness.rye`. It read `store_witness.rye` far enough to find that one allocation
(`altered`) stays unfreed through the whole function, while a later one (`too_big`) carries a
`defer garden.free` -- the same hand-written, non-loop version of the catalog essay's shape. [One
defer reads identical to
another](../20261002/20261002-162545_one-defer-reads-identical-to-another-and-only-one-reclaims.md)
closed the other two of the three, and found them split: `weave_v1_lift_witness.rye` genuinely
reclaims, `weave_apply_witness.rye` stays inert, both from one call site that looked uniform.

**Both essays left one question standing: whether `store_witness.rye`'s own `too_big` free
reclaims.** The first essay established only that the free exists; the second essay spent its whole
falsifier on the other two files. This essay reads `store_witness.rye`'s `main` past line 138 to
answer it.

## What stands between the allocation and its own defer

`mantra/src/store_witness.rye:137-138`:

```rye
const too_big = try garden.alloc(u8, over);
defer garden.free(too_big);
```

The shape reads exactly like the three clean reclaims `rye/src/main.rye` carried in
[The production driver reclaims three of ten](../20261002/20261002-182541_the-production-driver-reclaims-three-of-ten.md):
an allocation and its own `defer garden.free` standing adjacent, with the stretch between them
still unread. `ArenaAllocator.free` reclaims only when the freed slice is still the arena's own
tail -- `vendor/zig-toolchain/lib/std/heap/ArenaAllocator.zig:617-620` compares the node's current
`end_index` against the freed memory's own end and declines silently the moment anything else has
allocated since. So the real question is what runs between line 138 and the function's actual
return, six claims later, rather than what sits beside the allocation.

Reading forward: claim 6 (line 152) calls `store_two.write_blob` and `expect_store_error`, both
passed `garden`. Claim 7 (lines 161-169) calls `store_three.read_head(garden, io)` three times.
`read_head` is `mantra/src/store.rye:167-177`:

```rye
pub fn read_head(self: *const Store, allocator: std.mem.Allocator, io: std.Io) !?[]u8 {
    var buf: [65]u8 = undefined; // 64 hex chars + optional newline
    const content = self.mantra_dir.readFile(io, "HEAD", &buf) catch |err| {
        if (err == error.FileNotFound) return null;
        return err;
    };
    const name = std.mem.trimEnd(u8, content, "\n");
    if (name.len != Sha3.digest_length * 2) return null; // corrupt HEAD
    return try allocator.dupe(u8, name);
}
```

The read itself lands in a stack buffer (`buf`), bypassing `garden` entirely. The first and third
calls (`absent`, line 161; `corrupt`, line 168) return `null` before reaching the last line: one
reads a file that has yet to exist, the other a deliberately malformed HEAD, and both skip the
allocation. **The second call, `head_back` at line 164, reads a HEAD this test wrote one line
earlier and falls through to `return try allocator.dupe(u8, name)` at `store.rye:176`** -- a real
allocation through `garden`, firing after `too_big`'s own birth at line 137 and well before its
`defer` at line 138 runs at function exit.

## The reading

`too_big`'s free stays inert rather than reclaiming. By the time `defer garden.free(too_big)`
fires, the arena's tail has moved twice past it. The first move is `read_blob`'s own internal
allocation inside claim 6, whose `hex_encode` call runs to completion before the
`StoreError.BlobTooLarge` check (`mantra/src/store.rye:133-152`). The second is `read_head`'s own
`dupe` call inside claim 7. `cur_end_index` in `ArenaAllocator.free` lands past `too_big`'s own
end by the time the function returns, the same outcome standing for every one of the 74
confirmed-inert `drawn_terminal.rye` functions and the one inert site in `rye/src/main.rye`'s own
`record_family_evict`.

**The three confirmed-arena witness files this thread closed now read one reclaim rather than
two.** `weave_v1_lift_witness.rye` still reclaims, by its own prior falsifier: `from_v1` refuses
before allocating, leaving the space between clear. `weave_apply_witness.rye` and
`store_witness.rye` are both inert, for two different reasons -- the first because its one
downstream call allocates on the path that matters, the second because two downstream calls do,
several lines further on than either closing essay read.

## The population, corrected

Across the full 170 arena-bound `garden.free(` call sites this thread has now traced end to end --
157 in `drawn_terminal.rye`, 10 in `rye/src/main.rye`, and 3 in the Mantra witness trio -- the
genuine-reclaim count stands at **4**: the three hand-adjacent sites in `main.rye`
(`build_lock_claim` twice, `bridge_rye_tree`'s embed-file scan) and `weave_v1_lift_witness.rye`'s
one. `drawn_terminal.rye` contributes zero of 157, `weave_apply_witness.rye` and
`store_witness.rye` each contribute zero of one. Every inert free in this tree lands safely -- the
std allocator's own silent decline keeps every one of the 166 such sites harmless -- and the four
genuine reclaims share the one property every essay in this arc has now converged on from a
different direction: only the exact statement that frees a value reaches `garden` between that
value's birth and its own release.

## Falsifier

The claim is that `read_head`'s `head_back` call (`store_witness.rye:164`) reaches the `dupe` line
at `store.rye:176` rather than returning early. That requires `store_three.write_head` (elided
above, at line 162) to have already written a well-formed 64-character HEAD before `head_back`
reads it, and `name` (the blob name computed at line 98) to land at exactly `Sha3.digest_length *
2` characters.
Checked: `write_blob` returns `name` from `hex_encode(allocator, &digest)` at `store.rye:121`,
which always produces `bytes.len * 2` characters (`store.rye:192-193`) for a `Sha3.digest_length`-byte
digest -- so `name.len` is `Sha3.digest_length * 2` by construction, the check at `store.rye:175`
passes, and the function reaches the `dupe` call. Finding `write_head` refusing before this point,
or `name`'s length differing from the digest's own, would retract this essay's claim for
`store_witness.rye` alone and leave the arc's genuine-reclaim count at 3 rather than 4.

**Confidence: high.** The dupe call is read directly from `store.rye:176`, the two early returns
that would have skipped it are read at `store.rye:170-171` and `store.rye:175`, and the three
`read_head` call sites in `store_witness.rye` are read in the order they execute rather than
assumed from the claim numbers labeling them.

## What this leaves for Mantra

This closes clean: `store_witness.rye` proves exactly what it set out to prove, and the arena
resetting whole at process exit is the real reclaim every instance in this arc has relied on
throughout. What this corrects is one number this thread was carrying forward unchecked: the
population this arc has now read in full, 170 arena-bound call sites across four files, reclaims
at four sites rather than five, and every one of those four shares the same single cause the
`drawn_terminal.rye` catalog essay first named three essays back.

No witness, no new module, no Swift file. Graded A-/90 at Field.
