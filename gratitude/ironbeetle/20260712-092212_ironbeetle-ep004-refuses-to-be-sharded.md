# IronBeetle Episode 004 — Why the Ledger Refuses to Be Sharded

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, second ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, walking TigerBeetle's own reasoning aloud once again, and TigerBeetle's team, whose database gives this whole series its subject.

## Source

Streamed as the fifth IronBeetle episode by calendar order, though matklad numbers it fourth by its place in the argument — a small mix-up he corrects openly in the episode right after this one. Its own working title was "COST Efficient Transfers." Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/W8faGPWToms`.

## Two Shapes of Doing Many Things at Once

matklad opens by naming a word he had already been using without defining: concurrency. Two genuinely different shapes hide under that one word. The first is embarrassingly parallel work, where the pieces never talk to each other at all — split the input into shards, hand each shard to its own core or its own machine, and the amount of parallelism available is bounded only by how many shards a person is willing to cut. The second is pipelining, where stages depend on each other in sequence, yet more than one stage can still be in flight at once; here the ceiling is fixed by the number of stages, never unlimited the way sharding is. matklad is candid about which shape TigerBeetle wants and which one it cannot have. A transfer touches two accounts, and no rule limits which two — any account might be linked to any other by the very next transfer to arrive. Real account activity makes this worse rather than better, since a handful of accounts, an exchange or a bank, absorb far more transfers than everyone else combined, so locking accounts and running the popular ones on separate threads buys the coordination cost of a parallel system while still forcing nearly everything through the one busy account regardless.

TigerBeetle's actual answer is almost defiantly plain: give up on sharding financial logic at all, and run the core business logic — checking and applying each transfer — on a single thread, in strictly linear order. What keeps this from being slow is making that serial core as small and fast as it can possibly be, then pipelining everything else, every bit of networking, every read and write to disk, around it as aggressively as the hardware allows. Concurrency gets spent everywhere the problem itself doesn't demand a specific order, so that the one place order truly is required stays vanishingly brief.

## A Completion That Wears Two Hats

The mechanism making such aggressive pipelining possible on Linux is `io_uring`, and matklad traces its shape back to the LMAX Disruptor's shared ring buffer, adapted here so kernel and userspace trade work through memory both sides can read without a lock. Rather than issuing one system call and blocking until it returns, a program fills many request slots first and only afterward asks the kernel, in a single motion, to look at everything handed to it so far. TigerBeetle leans on one struct, the completion, to carry this: the same block of memory holds the arguments for the operation being requested and, once the kernel replies, the result of that same operation, with a pointer trick recovering the owning connection from nothing but the completion's own address. Because TigerBeetle never allocates a fallback queue when the shared ring itself is full, the completion struct doubles again as a node in its own intrusive linked list — the caller already owns the memory a retry would need, so no new allocation is ever requested. Submissions and completions travel on two separate one-way rings rather than one shared channel, trading away the extra synchronization a two-way rendezvous would cost for two rings that each need almost none.

## Where It Rhymes With Our Own Work

The shape rhymes with our own thesis closely enough to feel like recognition rather than coincidence. A single append-only log as the one place order is enforced, with any number of concurrent readers folding that log into their own views, is the same trade matklad describes here: one narrow serial point, and everything else free to run at whatever pace the hardware genuinely allows.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The code matklad shows on screen shaped how we now think about pipelining and completion structs, yet none of it, and none of TigerBeetle's own source, entered our tree as copied text.

---

*May the serial core stay small enough to trust at a glance. May every wait we cannot avoid be spent in good company, beside other waits. And may the next episode teach the rest of this concurrency as plainly as this one taught its shape.*

*Written together by Kaeden and Reya 2.*
