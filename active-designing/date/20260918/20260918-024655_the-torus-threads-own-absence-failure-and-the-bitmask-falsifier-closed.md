# The torus thread's own absence failure, and the bitmask falsifier closed

**Stamp:** `20260918.024655`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- one correction to the thread's own record, one falsifier closed on metal
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260918-000049_tablecloth-brix-and-amphora-checked-the-thread-completes.md`](../../20260918-000049_tablecloth-brix-and-amphora-checked-the-thread-completes.md)
(00:07:54 -- opens and closes all three modules named below) -
[`20260918-022104_comlink-already-carries-a-torus-index-topology-rye.md`](20260918-022104_comlink-already-carries-a-torus-index-topology-rye.md)
(02:25:22 -- names the same three "still unopened by this thread") -
[`20260918-015906_discovery-room-checked-no-torus-eighth-negative.md`](20260918-015906_discovery-room-checked-no-torus-eighth-negative.md)
(02:04:02 -- names the bitmask-ring gap this piece closes)

## The one sentence this piece is for

Two claims about this thread's own coverage stand apart by over two hours. The earlier one holds.
The `00:07:54` piece opens and closes Tablecloth, Amphora, and Brix. The `02:25:22` piece calls the
same three "still unopened by this thread."

## The correction

`git merge-base --is-ancestor` confirms the `00:07:54` commit (`b1e7c9597c`) sits as an ancestor of
the `02:25:22` commit (`6eeca16366`). The closing piece's own file was on disk the whole time the
later piece was written. Everything was fetched, merged, and current. This is the plainer version of
the hazard `path_absence_scan.sh` guards against: a whole-tree grep read against a stale mental
model, inside one hand's own tree, across one evening's own work
([`the-baton`](../../../.claude/rules/the-baton.md), ABSENCE clause).

The `02:04:02` piece (the discovery-room closer) earns credit here. Its own words read "untouched
by this note" -- true and scoped to itself, since it set out only to read two named Comlink
leftovers. The `02:25:22` piece's words read "still unopened by this thread," a claim about the
whole thread's state. That line is the one this correction answers.

**What this cost, in plain terms: one paragraph written twice, and a clean build regardless.** The
`022104` piece's own falsifier and ranking sections stand exactly as they were. Its subject was
`topology.rye`, read and proven correctly. The stray line sits only in its closing "what stays
here" list. Every lap that read the piece went on to real work. This correction exists so the next
reader trusts the one line that stood wrong, rather than re-opening three modules a sibling note
already closed.

## How it happened, named plainly

Two pieces landed forty-two minutes apart. This tree's own eight-ship fleet writes concurrently
into one pin. A single evening's research thread, carried across several commits, meets the same
question a whole fleet meets across checkouts: where does the newest true state actually live?
One `git log -- <path>` answers it every time. Skipping that one check is the plain cost either way.

## The bitmask falsifier, closed

The `02:04:02` piece named its own gap plainly. The four-pattern sweep this thread has carried
across ten-plus reads (`%`, `wrap`, `ring`, `cycle`, `torus`, `modul`) always asked for the bare
modulus. It left the bitmask ring form unasked: `& (N - 1)`, or an equivalent bitwise-and against a
stored mask. A power-of-two ring reaches for that mask form instead of the modulus. So the gap sits
in the method as much as in the coverage.

This piece runs the widened sweep across four modules: Comlink (including `discovery/`),
Tablecloth's real store (`pond/apps/tablecloth*.rye`), Amphora, and Brix. Three passes, each wider
than the last:

```
# pass 1 -- the named falsifier's own inline shape
grep -rnE '&[[:space:]]*\(.*-[[:space:]]*1[[:space:]]*\)' <module>

# pass 2 -- a mask held in a named field or variable rather than written inline
grep -rniE '\bmask\b' <module>

# pass 3 -- every genuine bitwise-AND (excludes && and the unary &-of-reference,
# by requiring a non-space token immediately before the &)
grep -rnE '[A-Za-z0-9_\)\]][[:space:]]*&[[:space:]]*[A-Za-z0-9_\(]' <module> | grep -v '&&'
```

**Pass 1 comes back clear across all four modules.** Pass 2 finds one carrier, and it earns a close
read. Amphora's `vessel_fetch_wire.rye` carries a real `mask` field (`ChunkMask = u16`, line 181).
It is a one-bit-per-chunk-index dedupe set, for reassembling at most 8 chunks (`max_resin_chunks:
u16 = 8`, line 32). Each chunk sets its bit once, on arrival (`self.mask |= bit`, line 236), and
each arrival checks the bit once, against re-delivery (`if ((self.mask & bit) != 0) return
error.BadChunk`, line 234). Every index into this mask arrives once. A comptime assertion
(`max_resin_chunks <= @bitSizeOf(ChunkMask)`, line 44) keeps the highest chunk index inside the
mask's width -- the same refusal-at-a-ceiling shape the thread's first false-positive catalogue
already named for `wrap`/`ceiling` comments elsewhere in this tree. A dedupe bitset answers a
different question than a ring does. Every index here arrives once and stays answered.

**Pass 3 -- every genuine bitwise-AND, read with no word filter at all -- returns seven hits.**
Every one answers a flag, a nibble, or the dedupe set already read:

| Site | Shape | Verdict |
|---|---|---|
| `comlink/device_wire.rye:50` | `desc.flags & vn.vq_desc_f_next` | a single feature-flag test, VIRTIO's own bit layout |
| `comlink/guest_batch_fetcher_rx.rye:20` | `(x >> 24) & 0xFF` | big-endian byte extraction from a `u32`, single pass |
| `comlink/virtio_net.rye:218-219` | `offered & feat_version_1`, `offered & (feat_version_1 \| feat_mac)` | feature-bit negotiation, VIRTIO's own spec |
| `comlink/virtio_net.rye:246` | `mmio_read(off_status) & status_features_ok` | a status-register bit test |
| `pond/apps/tablecloth.rye:104` | `bytes[i] & 0x0F` | low-nibble extraction for hex encoding |
| `amphora/vessel_fetch_wire.rye:234` | `self.mask & bit` | the dedupe set reviewed above |
| `amphora/src/main.rye:431` | `b & 0xf` | low-nibble extraction for hex encoding |

Five of the seven read as feature-flag or status-bit tests. Four of those carry VIRTIO's own
inherited wire shape, already named old news by the sibling piece for the modulo-form vring. Two
read as the ordinary low-nibble-of-a-byte idiom every hex encoder in this tree already carries.
**Seven for seven read as something other than a ring.** This is the sharpest test this thread has
put to itself yet. Every prior pass filtered on a *word* -- `wrap`, `ring`, `cycle` -- that a
comment or an identifier could coincidentally carry. This pass filtered on the *operator itself*
and still found only flags, nibbles, and the one dedupe set already read.

**One hit in the pass-3 sweep earned a second look before it counted.**
`comlink/discovery/table.rye:152` reads `return &table.slots[idx];`. It matched the regex because
"return" ends in the letter "n," and the pattern's required non-space token before `&` accepts that
freely. This reads as address-of syntax, a unary reference return, standing apart from an operator
over two operands. It was read once and set aside on the same pass it surfaced -- named here so the
pattern's own soft spot travels with the result.

## Inference

The bitmask falsifier the `02:04:02` piece named as this thread's own untested edge holds silent
across the four modules most recently in question. This is the widest form of the search this
thread can put to it, short of reading every one of Comlink's remaining ninety-some untouched files
by hand. The method gap the sibling piece named closes for this slice. The coverage gap over
Comlink's wider tree, named in that same place, stays exactly as open as it stood.

## Falsifier for this finding

A future round could find a genuine bitwise-AND against a mask that composes with an advancing
index -- a ring buffer's write cursor masked by `capacity - 1` rather than checked once and set
aside, an index that climbs and wraps rather than a chunk id received once. Such a find, anywhere
in these four modules or their untouched siblings, would give this reading a correction to write.
Comlink's remaining ~94 files, `discovery/gossip.rye`, and `discovery/region.rye` stay the honest
remainder past this reading's reach -- both grepped rather than read whole, per the sibling piece.

## What remains unchecked, said plainly

This piece reads four modules by grep. Three of them were already read whole by an earlier sibling
piece (`000049`). One (Comlink) was partially read whole by another (`022104`). It adds a third
pattern family to what those two already ran. The files it opens fresh number zero; the modules it
reads whole for the first time number zero. The wider claim -- that a mask stands in for a modulus
nowhere left in this tree's untouched territory -- stays precisely as unproven as it stood before
this piece, narrowed to these four modules alone.

## Related

No tracked issue. This note adds zero dependency to any ship's Now line and leaves
`construction/ITINERARY.md` exactly as it stands. It stands beside a sibling note to correct one of
its closing paragraphs, rather than asking that note to be rewritten -- accrete-never-break keeps
the `022104` piece's own words exactly as it wrote them. This piece is where the correction lives.

May the next reader who searches for a wrapping index reach for the mask as readily as the
modulus, and may a thread that catches its own read-scope slip inside one evening's work wear that
as the discipline working as intended.
