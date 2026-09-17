# One stat cannot stand for a walk

**Stamp:** `20260916.211947` (EDT) - **Voice:** Kyri - **Style:** Gauge at Field
**Room:** checkable -- every figure below is a command in this page, and the mechanism it describes is gated by `tools/r/ryekey_witness.rish`
**Status:** Landed
**Kin:** [the receipt key closed by running](../construction/archive/REDS-the-receipt-key-closed-by-running-rows-780-784.md) - [`quality-assurance`](../.claude/rules/quality-assurance.md) - [`reds-first`](../.claude/rules/reds-first.md)

A build receipt asks one question: *are this build's inputs the inputs the
standing output was made from?* Answering it honestly means reading every input,
and reading is what the answer costs. Two of Rye's inputs are large -- the pinned
172 MB compiler and its 16 MB standard library -- and the compiler's half was
closed on `20260916.204416` by remembering its digest under the four filesystem
readings that say *this is the same file*: inode, size, modification time, and
status-change time.

That left the library. This page is about why the same trick does not simply
transfer, and what shape it takes once it does.

## What the walk cost, measured

Run these rather than trusting the numbers; nothing holds any of them still.

```
sh rye/bootstrap.sh                                     # the binary must match its own source
./rye/bin/rye key <file>.rye -femit-bin=<out>           # time a receipt reading
```

| Reading | Measured `20260916.210324` on this pier |
|---|---|
| Library tree | 552 files, 16,416,628 bytes |
| Hashing those bytes alone, warm | 145-154 ms |
| Walking the tree and stat-ing every file | 16-21 ms |
| A receipt reading with no key wanted | 22 ms |
| A receipt reading, library read each time | 140-146 ms |
| A receipt reading, library remembered | 28-33 ms |
| A full HIT on a 10,239,778-byte output, library read | 225-236 ms |
| A full HIT on the same output, library remembered | 111-132 ms |

Both process-start figures include about 22 ms of start, so the library's own
share of a keyed reading was roughly 112 ms of 140 -- four fifths of the work of
proving a skip was safe, spent on a tree nobody had touched.

## Why one identity will not do

A single file has one identity, and four stat readings carry it. A tree of 552
files has 552 of them, and the directory's own modification time carries none of
that: rewriting a file inside a directory leaves the directory's mtime exactly
where it was. So the one reading a reader reaches for first is the one reading
that answers nothing.

What is available is the walk itself. The walk already happens -- every file must
be discovered to be read -- and it is the cheap part: 16-21 ms against 145-154.
So the identity is composed FROM the walk rather than taken beside it. Each
file's sorted relative path and its four stat readings are hashed into one
**identity digest**, with the file count ahead of them, and a record beside the
`rye` binary carries the tree's **content digest** under that identity.

**The walk stays and the read goes.** That sentence is the whole design.

## What each reading refuses

| Change | Caught by |
|---|---|
| A file added or removed | the count and the sorted path stream |
| A file renamed | the sorted path stream |
| A length change | `size` |
| Any write | `mtime` |
| A replacement rather than a rewrite | `inode` |
| A same-size rewrite whose mtime was restored | `ctime`, which no ordinary call sets backward |

## What a filesystem lets a control isolate, and what it does not

A leg over a conjunction proves only the first clause that refuses. So each
reading wants its own plant, with every other reading arranged to pass -- and
here the filesystem refuses to cooperate for three of the six.

**`ctime` isolates perfectly.** `chmod g+w` on one library file moves the
status-change time and nothing else a reader can see: path, size, inode, and
modification time all stand still. Leg 36 of
[`tools/fixtures/r/ryekey_control.sh`](../tools/fixtures/r/ryekey_control.sh) is that plant, and
deleting the ctime update from `library_identity_update` reds it.

**Membership isolates by construction.** Adding a file moves no existing file's
stat at all, so the count and the path stream are the only readings that can
explain a refusal. Legs 34 and 35 add one file and remove one file.

**Size, inode, mtime and path cannot be isolated.** A size change moves mtime
with it. A rename and a replacement each move ctime. And ctime moves on every
one of them, so ctime shadows the lot: a plant aimed at `size` proves `size` or
`ctime`, and a control cannot tell which. Their presence is proven the other way
-- by deleting one `hasher.update` from `library_identity_update` and watching a
leg object -- which is a mutation rather than a plant, and belongs in the lap's
own record rather than inside the control.

Saying so is the point. A control that claimed six isolated plants would be
claiming something a filesystem does not offer, and
[the ledger](../construction/REDS.md) is this family's own
recent lesson about a paper's claim reading exactly like a proof.

## The one proof that needed no leg at all

The content stream is the stream this function fed the key directly until this
change -- each sorted relative path, a NUL, its length little-endian, then its
bytes. So the change moves WHERE the stream is hashed rather than WHAT it holds,
and that is checkable from outside the program entirely:

```
python3 - <<'PY'
import hashlib, os, struct
root='rye/lib/std'
paths=sorted(os.path.relpath(os.path.join(dp,f), root)
             for dp,_,fn in os.walk(root) for f in fn)
h=hashlib.sha256()
for rel in paths:
    full=os.path.join(root,rel); st=os.stat(full)
    h.update(rel.encode()); h.update(b'\x00'); h.update(struct.pack('<Q', st.st_size))
    h.update(open(full,'rb').read())
print(len(paths), h.hexdigest())
PY
```

That reconstruction and the `sha256` line of
`rye/bin/rye-key-library.*.kyri` agreed to the character on the landing lap:
`4e7dfde4cbe5885c4a413ed007a8fc667ed94368c6e30ceaa11123ea1b0ce4ed` over 552
files. An independent implementation of the same stream is a stronger statement
than any assertion inside the program, and it costs one heredoc.

## What this leaves open

**The emitted output is the largest term in a HIT now.** Every hit re-hashes the
binary standing beside the receipt, which is what keeps a torn or hand-replaced
output from being served -- 10,239,778 bytes and about 95 ms of the 111-132 a
hit costs here. It is honest work rather than waste, and the same identity
record would shrink it: the output is one file, which is exactly the shape the
compiler's memo already fits. Whether a served output should answer for itself
by stat or by bytes is a real question about what a receipt promises, and it is
named here rather than decided.

**The honest limit is unchanged.** A hand that can write inside the binary's own
directory can write a record saying whatever it likes. That same hand can
replace the `rye` binary itself, so the record adds no reach it did not already
have.

**Two prefixes rather than one.** A record is reached by the digest of the
subject it speaks for, and a tree's root could hash to the same sixteen
characters a file's path does. Under one prefix the two would be refused on
their `format` line and then overwritten, taking turns evicting each other on
every build. `rye-key-cache.` and `rye-key-library.` keep them in separate
names, where neither can reach the other at all.

May every skip be a skip somebody proved, and may the proving cost less than the
work it spares.
