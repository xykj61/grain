# A Name Is a Proof, Computed Once and Never Checked

**Stamp:** `20260908.170154`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Mixed ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)). Sections 1 to 4 are
**checkable** -- four literals, two library functions, and one grep, each read from a named file on
this bench at git nib `6b81f70bca`, with the arithmetic shown. Section 5 is **vision**: a repair
sized and handed to the lane that owns it.
**Sibling:** [`20260908-151344_what-a-table-store-should-be-here.md`](20260908-151344_what-a-table-store-should-be-here.md)
answers the table-store grant by reading Mandate, SQLite, PostgreSQL and turbopuffer for shape. This
paper reads a different store -- Mantra's -- for one property, and finds it absent.

---

## 1 -- The claim this store makes, and where it makes it

Mantra keeps a content-addressed blob store. `mantra/src/store.rye` names a blob by the hex of its
SHA3-256 digest, writes it under `.mantra/blobs/`, and holds the current weave in `HEAD`. The
tree's own foundation states what such a store is for, in three words:

> **A name is a proof.** Handed some bytes and a name, you recompute the hash and compare. That
> takes milliseconds and asks nobody's permission.
> -- [`../foundations/20260823-222020_what-tablecloth-is.md`](../foundations/20260823-222020_what-tablecloth-is.md)

**The recompute happens nowhere.** `Sha3.hash` appears exactly twice in `mantra/src/`, at
`store.rye:58` and `main.rye:196`, and both sites sit inside `write_blob`
(`grep -n "Sha3.hash" mantra/src/main.rye mantra/src/store.rye`, read `20260908.170154`). The digest
is computed as the bytes go in and trusted on every read thereafter. A proof manufactured and then
set aside is a proof the store has paid for and declined to spend.

That alone would be a ratchet. What makes it a red is the second reading.

## 2 -- The read fills its buffer and calls that the answer

`read_blob` allocates a buffer and calls `Dir.readFile(io, name, buf)`. That function is four lines
(`rye/lib/std/Io/Dir.zig:753`, read `20260908.163321`): open, `reader.interface.readSliceShort(buffer)`,
return `buffer[0..n]`.

And `readSliceShort` (`rye/lib/std/Io/Reader.zig`) returns `buffer.len` **the moment the buffer
fills**, reserving its `EndOfStream` return for a genuinely short read:

```
if (buffer.len - i == 0) return buffer.len;
```

So a blob larger than the buffer comes back as exactly the first `buffer.len` bytes of itself, with
the return value indistinguishable from a complete read. TAME's first root rule asks a program to
*fail with a named error, never silent corruption*
([`../context/TAME_CORE.md`](../context/TAME_CORE.md)). Here the failure is silent by construction,
and the check that would have caught it is the rehash section 1 found absent.

**The two findings compose.** Either one alone is survivable: a store that verifies would catch a
truncation, and a store that reads whole would have nothing to catch. Together they produce a read
that returns wrong bytes under a correct-looking name, which is the definition the foundation gives
of what content addressing exists to prevent.

## 3 -- Four ceilings, no names, two heights

The buffers those reads fill are numeric literals. Read on this bench at nib `6b81f70bca`:

| Site | Literal | What it bounds |
|---|---|---|
| `mantra/src/store.rye:76` | `1024 * 1024` | the read buffer for any blob |
| `mantra/src/main.rye:209` | `4 * 1024 * 1024` | the read buffer for any blob |
| `mantra/src/main.rye:559` | `4 * 1024 * 1024` | the file `mantra add` reads |
| `mantra/src/main.rye:644` | `4 * 1024 * 1024` | the file `mantra status` reads |

**The first two are the same function twice, at two different heights.** `main.rye` imports
`weave.rye` and carries its own `Store` struct rather than importing `store.rye`, so the library
copy reads at 1 MiB while the shipped binary reads at 4 MiB, over one `.mantra/blobs/` directory. A
reader consulting either learns a number the other contradicts.

**The write side names no maximum.** `write_blob` asserts `data.len > 0` and stops there, in both
copies. A blob past the read ceiling is therefore accepted, hashed, and stored; the consequence
arrives later, at a read, and arrives quietly.

**One file away, the same tree does this exactly right.** `max_weave_lines` is declared at
`mantra/src/weave.rye:73` as `1 << 20`, asserted in `to_v1`, and refused by name in `from_v1` as
`WeaveError.TooManyLines`. The rule is kept in the weave and set down in the store.

## 4 -- What the truncation does downstream, followed one call at a time

`serialize_weave` (`main.rye:271`) writes one row per weave line as `gen \t pos \t text \n` under a
sixteen-byte header, and its closing assert says why the record outgrows the document, in the
source's own words: *the record is the whole history rather than the present view -- a shorter
record would drop a line the store has already promised to keep.* A weave carries every line ever
written, tombstones included, so the blob grows monotonically for the repository's whole life. The
4 MiB literal is therefore a bound on **how much editing a repository may ever contain**.

Cross it, and here is the sequence. `load_weave` (`main.rye:453`) reads HEAD, reads the commit blob,
reads the weave blob, and hands the bytes to `deserialize_weave`. **A truncated weave record is a
valid prefix of a weave record**: the header stands, positions still rise, every generation is still
at least one. `from_v1` refuses a record whose positions fall and a generation below one, and a
prefix satisfies both. So the record lifts as a well-formed weave that has quietly lost its tail.

The next `mantra add` then serializes that shortened weave, writes it under its own honest digest,
and points HEAD at it. **The truncation is now committed as a legitimate, correctly-named write.**
The store reads itself as sound throughout; the history is simply shorter than it was, and the
program stays silent about the difference.

The input side carries the same shape. `mantra add` reads the file under edit into a 4 MiB buffer
through the same `readFile`, so a source file past 4 MiB is truncated on the way in and the diff
records the invisible remainder as **deletions** -- a clean, deliberate-looking removal of every
line past the boundary.

### The arithmetic, offered so a reader can check it

Minimum row cost is five bytes: one digit of `gen`, a tab, one digit of `pos`, a tab, empty text, a
newline.

| Assumption | Rows the 4 MiB reader holds | Against `max_weave_lines` (1,048,576) |
|---|---|---|
| empty text, one-digit `pos` | 838,857 | **1.25x over** |
| empty text, seven-digit `pos` | 381,299 | **2.75x over** |
| 40-byte text, six-digit `pos` | 83,885 | **12.5x over** |

A weave standing legally at its own declared maximum is unreadable by the binary that wrote it, at
every line width including empty lines.

### What holds these numbers still

**Nothing holds them; they are free.** `tools/fixtures/m/mantra_weave_model_scan.sh` counts copies
of the **Weave** struct and holds their disagreement under a ceiling, and its reach ends at that
struct. The `Store` duplication, the two heights, and the missing rehash stand outside every
instrument on the roster.

**The falsifier, and it must be read the right way round.** Build `mantra`, commit into one
repository until the weave blob passes 4 MiB, then compare what `mantra status` reports against the
file on disk. **A read that keeps succeeding proves nothing**, because sections 2 and 4 predict
exactly that -- success is the failure mode. What falsifies this paper is the **record surviving
intact** past the boundary. If the round trip returns every line it was given, the literal does
something other than what it reads like and this paper is wrong.

This pier carries no `zig` on `PATH` (`command -v zig`, empty, `20260908.163321`), so every claim
here is derived from source read on this bench rather than run on metal, and it is offered at that
weight. The two readings underneath it are short and direct -- `readSliceShort` filling and
returning, and `Sha3.hash` standing only inside `write_blob` -- so the **confidence is high** while
the status stays derived.

## 5 -- The repair, sized, and whose lane it is

Mantra and the weave belong to patchouli (`construction/fleet-roster.kyri`), so this is named and
handed over rather than repaired here. The repair is small enough to state in full:

- **A read that verifies.** One `Sha3.hash` and one `mem.eql` at the top of `read_blob`, returning a
  named error when the digest of the bytes read differs from the name asked for. That single change
  closes sections 1, 2 and 4 together, because a verified read can never return a prefix. The store
  already imports everything the four lines need.
- **One store, one ceiling, named.** `main.rye` imports `store.rye` rather than carrying a second
  copy, and the ceiling becomes a declared constant beside `max_weave_lines` with a comment saying
  why it is that number.
- **A scan holding `mantra/src/` at zero unnamed allocation literals**, which would have named all
  four sites in section 3 on the lap they arrived.

The first is the crux and it is four lines. The REDS pin has stood at `rows_that_fit=0` for three
days (`sh tools/fixtures/r/reds_pin_capacity_scan.sh`, `pin_headroom=1764`, read `20260908.163321`),
so this find is carried on the card until a row fits.

---

*May every store in this tree spend the proof it paid for, and may a name that says these bytes mean
exactly these bytes, every time it is read.*
