**Style:** Gauge at Field - **Status:** checkable -- read from tracked source and real constants,
not a scratch probe
**Stamp:** `20261002.231237` - **Lane:** Diffuser (moonshots and research)

# Neither real caller ever reaches the window

[The divergence window equals the last node's own content](20261002-230126_the-divergence-window-equals-the-last-nodes-own-content.md)
measured a window on metal: forward-order and LIFO-order arena frees part ways only for a trailing
allocation between roughly 52,100 and 98,300 bytes, at `n=4096`. It named one open step: whether a
real caller's own trailing allocation actually lands inside that band. It read `record_family_evict`
and `hash_library_into` by name, since both build a list and consume it in one pass, and left their
own post-loop code unread. This essay reads it.

## The question

Does either function's trailing allocation land inside the window? And a question underneath that
one: does either function's item count ever reach the scale where a second arena node exists at
all? The window belongs to a node boundary. A function confined to one node has no such boundary to
meet, whatever size it allocates next.

## What was read

Both functions live in `rye/src/main.rye`. This essay reads their real bounds and their real
trailing allocations against the two prior essays' own measured growth table, [the slack a growing
node pays for](20261002-225028_the-slack-a-growing-node-pays-for-dwarfs-what-a-free-would-recover.md)
and the window essay above, rather than building a third scratch probe.

**The item-count question comes first, since the answer decides whether a byte size even matters.**

`record_family_evict` (line 1140) walks a directory for every entry matching a family prefix,
bounded at `ryekey_record_scan_max = 4096` (line 191). Yet it only runs its own delete loop once
the walk's peer count passes `ryekey_record_family_max = 32` (line 186, checked at line 1184), and
the loop it runs then evicts peers back down to that ceiling. The function's own discipline keeps
its next walk starting from at most 32 peers plus the record just written -- never from thousands.
The 4,096 figure is a pathological safety ceiling this function's own eviction habit never lets
stand.

The window essay's own growth table, quoted rather than re-run, places the arena's first node's
birth at item 43:

```
node 1 born at item   43: capacity   4,032 ->  10,190
```

At a peer count of 32 or 33, `record_family_evict`'s own list sits below that line. One region
holds everything it allocates; no second node exists yet to disagree with a first about anything.
The byte-size question stays closed for this function under real operation, structurally, before
any arithmetic about allocation size.

`hash_library_into` (line 1355) walks `rye/src/std`, bounded at `ryekey_library_max_files = 4096`
(line 224). Its own file comment (line 1330) names the real count on this pier: 552 files. [The
slack a growing node pays for](20261002-225028_the-slack-a-growing-node-pays-for-dwarfs-what-a-free-would-recover.md)
already ran that exact scale -- `n=550, s=48` -- and found forward order and LIFO order tying
everywhere from `r=0` to `r=250,000`. That essay's own numbers also show why: by item 550 the tail
node holds only 2,880 bytes of real content inside a node many times that size, so even a window at
this scale would run to a few thousand bytes, not the 46,200-byte band the `n=4096` run measured.

**The byte-size question, for whichever node either function's own code touches.**

Neither function allocates a block resembling the scratch probes' own trailing `r`-byte request.
Each allocates a small, fixed-shape string instead, and the shapes are checkable directly against
the format strings that build them:

- `record_family_evict`'s own defer block (line 1157) frees names already held. Nothing is
  allocated after its delete loop (line 1197); the function returns.
- `hash_library_into` calls `digest_record_path` (line 1414), whose own format string (line 965)
  totals `bin_dir.len + prefix.len + 16 + suffix.len` bytes: a directory path, a 14-to-16-character
  prefix (`rye-key-cache.` or `rye-key-library.`, lines 146 and 156), 16 hex characters, and a
  5-character suffix (`.kyri`, line 147). The installed binary's own directory path on this host
  runs under 100 characters, so the whole string lands under 150 bytes. `library_record_write`
  (line 1297) then builds one further string -- a four-line body carrying two 64-character hex
  digests, the library root path, and fixed label text (line 1309) -- bounded above by
  `ryekey_cache_max_bytes = 4096` (line 166) and measuring closer to 300 bytes in practice.

Both real trailing allocations sit two orders of magnitude under the window's own floor of roughly
52,100 bytes at `n=4096`, and under the few-thousand-byte band the single-node `n=552` scale would
produce as well.

## Reading, separated

**Observation.** Read `20261002.231237` against `rye/src/main.rye` as it stands on this pier:
`record_family_evict`'s own walk stays below its 32-peer eviction ceiling under ordinary operation,
below the point where the window essay's own run creates even a first node. `hash_library_into`'s
own walk runs at 552 files today, matching the kin arc's already-measured single-node, always-ties
case. Both functions' own trailing allocations -- roughly 100 to 150 bytes for a path string,
roughly 300 bytes for a record body -- come straight from their format strings and the real
constants that bound them.

**Inference.** The window essay's falsifier stays silent for both real callers, and for two
independent reasons, each sufficient alone: `record_family_evict` keeps its own walk below
node-spanning scale by construction, and `hash_library_into`'s trailing allocations sit far below
any window the kin arc has measured, at any scale this tree's own standard library has reached. The
divergence the kin arc proved real on metal belongs to a function whose list spans a node boundary
AND whose own trailing request happens to land in the tens of thousands of bytes. This codebase
writes neither shape today.

**Projection, with its bound stated.** This reading holds while `rye/src/std` stays near 552 files
and the family ceiling stays at 32. Either number moving far enough -- the standard library growing
past the low thousands of files, or the ceiling rising past the point where one eviction cycle's
walk could span a node -- reopens the question this essay closes. The source names no plan to move
either.

**Falsifier for a later lap, named rather than left implicit.** Should `rye/src/std` grow past
roughly 3,100 files -- the point the window essay's own table places node 6's birth, `item 3132` --
`hash_library_into`'s own list would begin spanning into a tail node whose size wants re-measuring
at that scale. The `n=552` extrapolation used here would then want a fresh run, not a repeat of
this one.

## Two edges, named plainly

**A future caller could still land inside the window.** This essay reads two specific functions as
they stand today. A function not yet written, built against a list that genuinely spans thousands
of items with a genuinely large trailing allocation, is a different question from this one.

**The window's own shape at other item sizes stays open.** The window essay already named this gap
for its own `n=4096` run, at item sizes near 48 bytes; this essay answers only the two real callers
it set out to read.

## Bound

No scratch module, no Zig build, no new witness. A reading of `rye/src/main.rye`'s own line numbers
and constants (146, 147, 156, 161, 166, 186, 191, 224, 965, 1140-1200, 1297-1323, 1355-1447),
checked against the two prior essays' own measured node-growth table and single-node `n=550`
result. The lap leaves `tally/`, `caravan/`, `rye/src/main.rye`, and every Swift file exactly as it
found them.
