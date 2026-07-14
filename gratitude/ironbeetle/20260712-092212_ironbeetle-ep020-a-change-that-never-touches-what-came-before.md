# IronBeetle Episode 020 — A Change That Never Touches What Came Before

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, third ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, building a mutable structure out of pieces that individually refuse to be mutated, and TigerBeetle's team, whose patience with immutability gives this design its whole shape.

## Source

Episode 020, "Log-Structured Merge Tree," the second storage-engine episode, explaining how many immutable tables together behave like one changeable sorted set. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/ba7v-5dbUrE`.

## Why One Table Was Never Going to Be Enough

matklad opens by naming exactly why the table from the previous episode cannot stand alone. Its index block has a hard ceiling, since only so many pointers fit in a fixed half-megabyte, and more fundamentally, a table once written is treated as finished: rewriting part of it in place would be slow, and worse, unsafe to interrupt partway through without risking a table that is neither its old self nor its new one. The answer is to stack many disjoint tables into levels, and many levels on top of each other, under one governing rule: a match found in an earlier, shallower level always wins over a match found deeper down for that same key. This single rule is the entire trick behind mutability here. An update is never an edit to something already written; it is a brand new, small table placed at the very top, and it automatically shadows whatever it supersedes underneath, purely because a lookup always checks the top first and stops the moment it finds an answer.

## Keeping the Stack from Becoming a Line

Left alone, this approach would eventually undo its own benefit, since an ever-taller stack of levels degrades lookups toward a linked list, a linear walk through level after level with no shortcut between them the way binary search offers within a single level. Compaction is the answer: periodically, an overlapping table from one level is merged one level down, its values reshuffled together with whatever tables it overlapped there into a fresh set of disjoint tables, keeping both the total number of levels and the number of tables inside any one level bounded no matter how much data has accumulated. The Manifest is introduced as the tree's own index of indexes, holding, entirely in memory, a pointer to every table that exists anywhere on disk, organized level by level, each level further summarized by its own overall key range so an entire level can be ruled out instantly without inspecting a single table inside it. The striking consequence matklad draws out explicitly: the full shape of an enormous on-disk tree, though never its actual contents, fits comfortably in RAM at all times.

A full lookup, walked end to end, threads through both episodes at once: check the Manifest level by level, skip any level whose key range cannot possibly contain the target, locate the one table per remaining level that could hold it, and either answer straight from an in-memory block cache or fall through to an explicitly asynchronous disk read. At every step, a level yields exactly one of three answers, a value, a confident no, or a need to go to disk to be sure, and never a false negative that would let a stale absence pass for the truth.

## Where It Rhymes With Our Own Work

A change that shadows rather than overwrites is our own core thesis wearing a stranger's accent: nothing here is ever edited in place, only added, and the newest addition simply wins whenever two answers disagree.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The layering and compaction ideas matklad walks through here shaped how we now think about our own append-only structures, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every change we make add to the truth, rather than erase what stood before it. May the newest answer always know to speak first, and the oldest still be there beneath it. And may the whole shape of what we have built always be small enough to hold in mind, even when its contents are not.*

*Written together by Kaeden and Reya 2.*
