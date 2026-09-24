# The Count in Front of the Byte Ceiling

**Language:** EN
**Stamp:** `20260910.001454`
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Proposed -- **mixed room**: the census and the arithmetic are checkable on this tree at the stamp above, the two proposed repairs are design
**Lane:** Diffuser -- moonshots and research, aimed at Mantra
**Kin:** [`../foundations/20260826-021732_air-the-row-that-feels.md`](../foundations/20260826-021732_air-the-row-that-feels.md) -- [`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md) -- [`../.claude/rules/derived-spine.md`](../.claude/rules/derived-spine.md) -- [`20260909-213140_the-answers-size-belongs-to-the-store.md`](20260909-213140_the-answers-size-belongs-to-the-store.md)

---

A module that writes items into a fixed buffer can name two ceilings: how many items it will
carry, and how many bytes it has. Only one of those two is the real one, and which one is real is
decided by the encoder rather than by the declaration. This paper walks every place in Mantra,
Caravan, Tally, and Aurora where both ceilings are declared as bare literals in one file, computes
the arithmetic between them, and reports what the hand finds when it presses on each.

The air row's own test is the method: press on a claimed boundary, and if the hand passes through,
the boundary was a wish.

## How the population was bounded

The census asks one question of every tracked Rye source in the four modules: does this file
declare **both** a byte-shaped maximum and a count-shaped maximum as decimal literals? Byte-shaped
means a name ending in `bytes`, `payload`, `len`, `size`, or `message`; count-shaped means one
ending in `hits`, `count`, `entries`, `items`, `rows`, `slots`, `bindings`, `leaves`, `records`, or
`frames`. Both patterns require a literal on the right-hand side, so a maximum derived from another
maximum never enters the population -- which is the whole point, since a derived maximum is the
shape this paper argues for.

Run on `20260910` against 177 tracked sources:

| Module | Tracked `.rye` | Files declaring both, as literals |
|---|---|---|
| `mantra/` | 41 | **4** |
| `caravan/` | 114 | **0** |
| `tally/` | 14 | 0 |
| `aurora/` | 8 | 0 |

Four candidates out of 177 files is a population small enough to walk whole rather than sample,
which is the same move `recall_tablecloth_hit_census.rye` made one lap earlier over 31 query
shapes. Each of the four is read below in full.

**Caravan's zero is a result rather than an absence.** Its bounds are chained: `max_finding_bytes
= max_referral_bytes + 1`, `max_met_bytes = max_debt_bytes`, `max_redress_bytes = max_met_bytes +
1`, and so on down each rung. Every one of those is an expression rather than a literal, so moving
one moves the rest, and the census pattern skips them by construction. Caravan already writes its
ceilings the way this paper's repair proposes.

## Two real instances

### The query wire: a declared count of 8, an attainable count of 2

`mantra/recall_tablecloth_query_wire.rye` declares both ceilings six lines apart:

```
pub const max_wire_hits: u32 = 8;
pub const max_wire_payload: u32 = 340;
comptime {
    assert(max_wire_payload <= wf.max_message);
}
```

The byte ceiling carries a comptime tie to the sealed datagram's own `max_message`, with a comment
saying why: a wider Kumara signature moves every offset behind it, and the tie keeps this file
honest when that happens. The count ceiling directly above it carries no tie at all.

Arithmetic. `encode_response` writes a 2-byte header, then per hit a length-prefixed peer, a
length-prefixed bolt, a 4-byte revision, and a length-prefixed path. The name ceilings are 16, 32,
and 64, so one hit at maximum lengths encodes to `(1+16) + (1+32) + 4 + (1+64)` = **119 bytes**.

- Largest count that always fits: `floor((340 - 2) / 119)` = **2**.
- Smallest count that can overflow: **3**.
- Declared: **8**.

The failure mode is orderly rather than unsafe: `build_response` fills up to eight hits, and
`encode_response` refuses them on the next call with `error.Overflow`. Nothing is corrupted. What
is wrong is that a caller reading `max_wire_hits` is told eight and gets between two and eight
depending on how long the names happen to be, with the store rather than the caller deciding.
This pair is already booked as a red (`20260909.213236`).

### The sync wire: a declared count of 8, unattainable under every input

`mantra/recall_sync_wire.rye` is the sibling file, and it carries the same shape one degree
further. It declares `max_held_digests: u32 = 8`, `max_wire_entries: u32 = 8`, and the same
`max_wire_payload: u32 = 340` under the same comptime tie -- the identical five-line comment, word
for word. Two counts, untied; one byte ceiling, tied.

`encode_response` writes a header of `1 + (1 + |peer|) + (1 + |bolt|) + 4 + 1` = **8 + |peer| +
|bolt|** bytes, so between 8 and 56. Each entry then costs `(1 + |path|) + 64 + (1 + |tilak|) + 2 +
bytes_len`, where the ceilings are `max_path` 64, `max_tilak` 32, and `max_resin_bytes` 512.

- One entry at maximum lengths: `65 + 64 + 33 + 2 + 512` = **676 bytes**, which alone exceeds the
  340-byte payload. At the ceilings, the attainable entry count is **zero**.
- One entry at minimum lengths -- empty path, empty tilak, no inlined resin bytes -- costs `1 + 64 +
  1 + 2` = **68 bytes**. With the smallest possible header of 8, `floor((340 - 8) / 68)` = **4**.
- Declared: **8**.

So the sync wire's attainable entry count ranges from **0 to 4**, and the declaration stands at
twice the best case that any input can reach. This instance is new, and it is the second firing of
one shape -- which is what turns a lantern into a loom.

**An inference, stated as one.** In both files the tie between the encoder and the wire is
`assert(off <= max_wire_payload)` on the way out, and `std.debug.assert` compiles away in a release
build. The input-side checks guard the caller's buffer (`out.len`) rather than the format's
ceiling, so a caller handing in a buffer larger than 340 bytes would, with asserts stripped, get a
payload the sealed datagram cannot carry. I have not run that build; the falsifier is named below.

## Two false pairs, each false in its own way

The census pattern over-collects on purpose, since a pattern tight enough to admit only real
instances would be a pattern that had already decided the answer. Both false positives teach
something.

`mantra/recall_lap1.rye` declares `max_bindings: u32 = 16` and `max_resin_bytes: u32 = 512`. These
are two axes that never meet: the first bounds how many leaves a catalog holds, the second bounds
one resin's own bytes. No arithmetic connects them because none should.

`mantra/resin_batch.rye` declares `max_batch_entries: u32 = 16` and `max_batch_bytes: u32 = 4096`,
and this one is more interesting. Every use of `max_batch_bytes` sits inside `run_batch_selftest`,
where it sizes a stack scratch buffer. The frame builder `build_batch` takes the caller's `out:
[]u8` and declares no ceiling of its own. So `max_batch_bytes` is a **published name that reads as
a format bound and bounds only a test**. A reader running a hand along this fence feels a post that
holds nothing up.

## The line where two ceilings are named and two are literals

The sharpest reading of the census sits in a single expression, which stands word for word in
`mantra/bolt_apply_step.rye` and `mantra/recall_lap1.rye`:

```
if (peer.len > 16 or bolt.len > 32 or path.len > ns.max_path or tilak.len > ns.max_tilak)
    return error.Overflow;
```

Four ceilings, one sentence. Two of them carry names that live in `recall_lap1.rye` and can be
moved in one place. Two of them are decimal literals, respelled at **five sites across four files**
-- the two above, both `encode_request` and `encode_response` in `recall_sync_wire.rye`, and
`encode_request` in `recall_tablecloth_query_wire.rye`. The hand runs along the fence and meets two
posts and two gaps without leaving the line.

This matters beyond tidiness, because the repair below needs those two numbers to be
**expressible**. A derived hit ceiling reads `1 + max_peer + 1 + max_bolt + 4 + 1 + max_path`, and
today `max_peer` and `max_bolt` are names that do not exist.

## Why the derived ceiling holds and the declared one does not

The tree already has the general form of this law written down for its ledger. The derived spine
says that a REDS row's identity is its stamp and the `%N` beside it is a **view** -- a number
computed from the record rather than declared beside it, so the two can never disagree.

A byte ceiling and a count ceiling stand in exactly that relation. The bytes are the record: the
wire's capacity is a physical fact that the encoder meets on every call. The count is a view of
that fact, computed through the per-item worst case. Declared separately, the two disagree the
first time a name ceiling moves, and they disagree silently -- because a count is a plausible
number that no compiler and no witness has any reason to question.

That is what makes this class quiet. A bound that is too small refuses honest work and gets found
within a day. A count that is too large refuses nothing, passes every test built from short names,
and reports its wrong number to every reader who asks.

## Two lawful repairs, and the trade between them

**Derive the count.** Name `max_peer` and `max_bolt`, add `max_hit_bytes` as their sum with the
fixed fields, and let `max_wire_hits` be `(max_wire_payload - header) / max_hit_bytes`. The
declaration then moves whenever a name ceiling or the envelope moves, and the comptime tie already
in the file extends to cover it. The cost is honest and steep: the query wire's ceiling falls from
8 to **2**, and the sync wire's falls from 8 to **0**, because a worst-case sync entry cannot fit
at all. A derived ceiling reports the worst case, and the worst case here is genuinely poor.

**Budget as you go, and return what fit.** Drop the count ceiling. Encode entries until the byte
budget is spent, return how many were written, and carry a continuation cursor so the caller asks
for the rest. The ceiling then stops being a promise about counts and becomes what it always was
underneath -- a promise about bytes. Typical names are far shorter than their ceilings, so this
recovers the throughput the derived ceiling gives up, at the cost of a cursor in the format and a
second round trip when an answer is large.

**The trade, plainly.** Deriving is small, local, and provable today, and it will under-report on
almost every real call. Budgeting is a format change that needs its own round, and it is the only
one of the two that lets a sync entry carrying 512 bytes of resin cross at all. The prior paper
measured that 29 of 31 query shapes can bind 16 hits against a wire that carries 8, so the pressure
here is real rather than theoretical: the store can produce more answer than the wire can hold, and
that gap wants a cursor rather than a smaller number.

My recommendation is to derive first and budget second. Deriving costs one lap, closes the booked
red, and makes the sync wire's zero visible -- and a visible zero is the argument for the cursor
that a plausible eight was hiding.

## What would falsify this

- **The arithmetic.** Build the two encoders and feed them maximum-length names. If
  `encode_response` accepts eight hits into a 340-byte buffer, the per-item figures above are
  wrong and the paper falls.
- **The release-build inference.** Compile in `ReleaseFast`, hand `encode_response` a 4096-byte
  buffer and eight maximum-length hits, and read the returned length. A value at or under 340
  refutes the inference in the sync-wire section; a value above 340 confirms it and books its own
  red.
- **The census.** Re-run the two patterns after any lap that adds a bound to these modules. A fifth
  candidate appearing means the class grows rather than closes, and the loom argument strengthens.
  A candidate leaving means a repair landed.
- **The claim that Caravan is clean.** The census skips derived expressions by construction, so it
  cannot see a Caravan chain whose arithmetic is wrong. A hand-check of one rung's chain against
  its own encoder would test that, and this paper has not done it.

**Confidence.** High on the arithmetic and the census, both computed on this tree at the stamp
above and reproducible from the commands in the session log. Medium on the release-build inference,
which is read from the source rather than run. The recommendation between the two repairs is a
judgment, offered as one.

## What this does not reach

**Whether either count was ever attained in practice.** Nothing in this tree records the name
lengths real callers send, and the prior paper's finding was that the answer's size belongs to the
store rather than the caller. Both repairs are correct without that number.

**Every other module.** The census covers the four modules this lane serves. Glow, Skate, Kumara,
and the crypto rungs each declare their own ceilings, and the same two patterns would read them in
one command.

**The general question underneath**, which is worth naming and leaving open: how many of this
tree's other named maxima are views of a fact that is measured somewhere else? A count in front of
a byte ceiling is the case where the arithmetic is easy. A timeout in front of a retry budget, a
depth in front of a stack size, and a cadence in front of a wall-clock deadline are the same shape
with harder sums.

*May every ceiling this tree names be one the encoder agrees with, and may the number a reader
trusts be the number the metal keeps.*
