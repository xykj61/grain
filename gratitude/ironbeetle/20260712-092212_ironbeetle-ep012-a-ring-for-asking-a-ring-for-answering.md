# IronBeetle Episode 012 — A Ring for Asking, A Ring for Answering

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, third ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, finally facing down a function he admits he once found frightening enough to skip, and TigerBeetle's team, whose main loop gives this courage its occasion.

## Source

Episode 012, "Run to the IO_urings!," the twelfth installment of the IronBeetle series. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/w-0uRhGrl4M`.

## The Loop That Refuses to Wait Twice

matklad opens by making good on a debt: two episodes ago he waved away `run_for_ns`, the function driving the entire event loop, calling it too scary to read line by line. This episode pays that debt in full. The loop's job is to process whatever asynchronous work has already completed, without ever running so long that scheduled timers fall behind, and matklad traces exactly how that balance is struck. A timeout is converted to a deadline the moment it is received, before any other work happens, because a deadline anchored to an absolute point in time cannot drift the way a timeout re-measured after intervening computation would. The loop then submits its pending operations, optionally blocking until at least one completes, drains whatever completions are ready without blocking further, invokes every callback those completions represent, and repeats until the deadline itself arrives. A fresh timeout request is resubmitted on every single pass, and the reason is subtle: any other completion firing first implicitly cancels the outstanding timeout, so the loop can never simply trust one timeout to survive an entire run.

Along the way, a smaller discovery lands with real weight for how error handling is designed elsewhere in the project. Reading the current time turns out not to be a system call at all. The kernel periodically writes the current time into a small region of the process's own memory, and userspace simply reads it back, no privilege boundary crossed. This is the exact same shared-memory idea behind `io_uring` itself, just applied to a single number instead of a queue of operations.

## Why the Read Callback Has No Room for an Error

matklad revisits, and this time fully explains, something noticed earlier without comment: the callback that fires when a disk read completes carries no error code whatsoever. Once a system accepts that disks fail, and once every read is already checked against a checksum known in advance, there is no remaining difference worth representing between "the read failed outright" and "the read succeeded but returned garbage." Both cases become the same call with the same next step, retry, and a boundary with one shape instead of two is a boundary exercised more thoroughly by the very same amount of testing. This single design choice, once fully seen, explains a detail matklad had puzzled over on an earlier stream: a storage error is masked by zeroing the destination buffer rather than leaving it untouched, purely as defense in depth beneath a checksum that would have caught the problem regardless.

The two-ring structure underneath all of this, one ring for submissions moving from userspace to kernel, a separate ring for completions moving the other way, is drawn out concretely here for the first time. Each ring is governed by nothing more than two atomic pointers, one marking where new data has been written, one marking where it has been consumed, letting kernel and userspace fill and drain the same memory concurrently without a single explicit handshake unless one side chooses to nudge the other awake. At low load the two sides barely touch the same cache line at all, since the pointer being advanced by the kernel and the pointer being advanced by userspace point at different, quiet places in memory most of the time.

## Where It Rhymes With Our Own Work

The whole shape rhymes with Weave's own fold: a log filled at one pace and drained into a frame at another, neither side ever blocking the other just to stay in step.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The main-loop mechanics matklad walks through here shaped how we now picture our own event loops, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every deadline we set hold its ground against whatever computation happens first. May the ring that fills and the ring that drains never need to ask each other's permission. And may the function we once found frightening always turn out, on the far side of reading it, to be simple.*

*Written together by Kaeden and Reya 2.*
