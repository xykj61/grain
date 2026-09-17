# The compiler read once, rather than once per build

**Stamp:** `20260916.202830`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every figure below is a reading taken on this pier, and the repair stands under [`../tools/r/ryekey_witness.rish`](../tools/r/ryekey_witness.rish) at 30 legs
**Kin:** [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md) -- `rye/src/main.rye` -- [`../tools/fixtures/r/ryekey_control.sh`](../tools/fixtures/r/ryekey_control.sh) -- [`../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md`](../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md)

Rye's build receipt skips a compile when every input is byte-identical. It earns that skip by
hashing the inputs, and one of them is the pinned Zig toolchain: **172,641,672 bytes, read and
hashed on every keyed build.** The first half of that bill was settled on `20260916` by asking
whether a receipt is possible at all before paying for one, which spared every `rye run`. This lap
settles the second half, which is the bill a build that genuinely wants a receipt still pays.

## The reading, before

Taken on this pier `20260916.202000`, warm page cache, the standing roster running beside it. These
are **free** figures -- nothing holds them still -- so run the commands rather than trusting the
column.

| What | Reading |
|---|---|
| Receipt HIT, one-file program, three runs | **2,055 / 2,396 / 2,420 ms** |
| Hashing the toolchain through Rye's own read loop | about 1,420 ms |
| Reading those same bytes without hashing | about 124 ms |

The gap between 1,420 and 124 says where the time goes: SHA-256 running in software at roughly
120 MB/s, where the read itself is eleven times faster. A hit spent nearly all of the saving it
bought proving that a file nobody had touched still held the bytes it held last time.

## The mechanism

`file_digest_remembered` in `rye/src/main.rye` takes a file's SHA-256 from a record beside the `rye`
binary while the filesystem still gives that file the same identity, and from its bytes otherwise.
The record is one file per path, in Kyri notation, inside the gitignored `rye/bin/`:

```
format rye-key-cache-v1
path /home/keeper/grain-bakery/vendor/zig-toolchain/zig
inode 3690870
size 172641672
mtime 1788645952157316943
ctime 1788645952157316943
sha256 2317bbb91798556d9d0f38aabdac23db83f0979b25f767259ae474546724087c
```

Two call sites reach it. The **compiler** joined the key as a byte stream and now joins as the
32-byte digest of those bytes, which is what moved `ryekey_marker` from v7 to **v8**: the digest
changes shape even where no input byte moved, so every standing receipt takes one rebuild on the lap
this lands and hits again afterward. The **`rye` binary itself** already joined as a digest, so its
key is unchanged; what changes is that its 12 MB are read once per binary rather than once per
build. The record's name is derived from the digest of the path it speaks for, so a path holding
spaces or slashes still names one file and two files never share a record.

The bytes still decide the key. They are read once per compiler now.

## The identity, and what each of its five readings refuses

- **path** -- the record names the file it speaks for, so a record can never answer for a file it
  never read.
- **inode** moves when a file is replaced rather than rewritten, which is what `mv`, `cp` over a
  fresh name, and a fetched archive all do.
- **size** moves on any length change.
- **mtime** moves on any write.
- **ctime** moves on any write *or* metadata change, and no ordinary call sets it backward.

The fifth reading is the one that earns the design. Without it, a same-size rewrite in place whose
modification time was restored afterward would serve a digest for bytes that had changed underneath
it. Leg 29 of the control plants exactly that -- `dd conv=notrunc` for the bytes, `touch -r` for the
time -- and proves the key still moves.

**The honest limit, named rather than hidden.** A hand that can write inside `rye/bin/` can write a
record saying whatever it likes, and the key will believe it. That same hand can replace the `rye`
binary itself, so the record adds no reach it did not already have. Every reading inside the record
must agree before a byte of it is used, and a record that cannot be read, written, or trusted costs
one wasted `stat` while the read happens exactly as it did before.

## The reading, after

| What | Before | After |
|---|---|---|
| Receipt HIT, one-file program | 2,055-2,420 ms | **285-321 ms**, five runs |
| Compiler bytes read per keyed build | 172 MB | 172 MB once per compiler, then one `stat` |
| `rye run` of that program, warm | 51 ms | 51 ms, untouched |

A hit costs roughly a seventh of what it did. `rye run` is the same number on both sides, which is
the point: the first half of this work already spared it, and this half reaches only builds that
genuinely want a receipt. Re-read `20260916.204153` against the binary carrying the path repair
below, roster running beside it: **240 / 280 ms** over two hits, which is the same figure inside the
noise of a busy pier.

## Proof, and the half that is harder than green

Five legs join the control, at **30 legs** total. Four of them come straight from the design the
dead lap of `20260915` wrote and never landed; the fifth is new, and it exists because of what
`%780` taught one lap earlier.

**A leg over a conjunction proves only the first clause that refuses.** Five readings must all agree
before a remembered digest is used, and one plant that trips several of them at once says nothing
about the rest. So **leg 28 corrupts each field alone**, and beside it the digest, which is what
makes the assertion sharp: a compared field refuses the record, the bytes answer, and the key
returns to its baseline. A field that is never compared would carry the planted digest into the key
and move it.

Beside that stand the four recovered legs: the record exists and names the compiler; the record is
**consulted**, shown by planting a wrong digest under a true identity and watching the key move; a
same-size rewrite with its modification time restored still misses; and a build that can earn no
receipt writes no record at all.

**And one of those five comparisons did not exist, which the run is what found.** This section said,
until `20260916.204153`, that six deletions had been made one at a time and the control run whole
against each mutated binary. That account was written from the design rather than from a transcript,
and it cannot have been true: `digest_record_read` computed `seen_path` and never read it, so a
record whose `path` line named another file was trusted outright. Leg 28 answered `RED: a record
whose path disagreed with the file was trusted` on the first honest run against a binary built from
this source. The repair is one line with its reason beside it, and the plant that proves the line
bites is the history above -- the comparison was absent, and the leg reddened.

**A second door had to open before the control could speak at all.** The `rye` binary on this pier
was built from an elder source carrying the **same** `rye_version`, so the control's own staleness
check read `stands at or past its source` and waved through a binary that behaved differently. That
stamp is the one reading telling a binary from its source, so it moves whenever this file's behavior
does, and the comment beside it now says so where a hand edits. A leg proven only in the passing
direction cannot be told from a bypass -- and a proof written rather than run cannot be told from
either. Both are booked as the ledger's row for this lap.

**A key READING writes a record too.** `rye key` asks whether a binary is current without building
it, and answering that question opens the compiler exactly as a build does -- so it remembers what it
read. The write is a pure function of the path, the identity, and the digest, landed through a
temporary name and one rename, so two builds remembering one compiler write identical bytes and
cannot disagree. A predicate with a side effect deserves saying out loud; this one leaves the answer
unchanged and makes the next build cheap.

## What this does not reach

**The library tree's 61 ms and the closure's own sources.** Both are small, and the library is a
walk rather than a file, so one identity cannot stand for it. That walk is now the largest remaining
term in a hit, which makes it the honest next question rather than this lap's.

**Whether a receipt should exist at all for programs this small.** With the key at its full price a
hit saved little against the compiler's own work; the question becomes interesting once the key is
cheap, and now it is.

**The compile itself.** This lap changes how much a skip costs to earn, and nothing about what the
toolchain does when it runs.

**How many records a directory accumulates.** One per distinct path remembered, at about 200 bytes
each, inside a gitignored directory -- and a pen that reaches a throwaway compiler leaves one behind.
Thirty-two such records stood in `rye/bin/` on the lap this landed, every one of them written by an
earlier pen. That is small and it is unbounded, so whether the room wants a ceiling and a sweep is a
question this lap names rather than answers.

## What it cost to recover

The implementation was written once, on `20260915`, by a lap that died before its send. It sat in
the round-open stash box for a day while its first half was re-derived and landed separately. A
stash replay is a merge against a tree that moved: the dead lap's spelling of the cheap predicate
had since landed under another name, the toolchain and library paths had left the key, the output
path had followed them, the build lock had grown a parameter, and one readability flag had changed
its meaning from `false` to `true` when skipped. So the memo was **re-derived into HEAD's shape by
hand** rather than applied, and its proof was rewritten to HEAD's leg numbering with one leg added.

The lesson is worth more than the hours: work parked in a stash is work whose design has to be
re-read against the tree it lands in, and the conflicts that bite leave no marker in the diff.
