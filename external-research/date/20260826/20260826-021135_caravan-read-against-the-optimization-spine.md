# Caravan read against the optimization spine

**Stamp:** `20260826.021135`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- research for understanding; the supervisor room read `2026-08-26` against the five silo insights, on Keaton's word
**Kin:** [`../active-designing/20260826-021136_caravan-rearchitected-the-optimization-spine.md`](../active-designing/20260826-021136_caravan-rearchitected-the-optimization-spine.md) -- [`../active-designing/20260826-001744_the-bound-in-the-shape.md`](../active-designing/20260826-001744_the-bound-in-the-shape.md) -- [`../external-research/20260826-002701_the-aether-field-lens.md`](../external-research/20260826-002701_the-aether-field-lens.md)

## What Caravan is, read from its own files

Caravan is the supervisor room: 118 `.rye` sources, each a rung that proves one property of a
supervised run (counted `2026-08-26`, `ls caravan/*.rye`). The mechanisms this reading stands
on, from the sources themselves:

- **`ladder_checks.rye`** lifts every shared check into one harness. A check takes the rung as
  a comptime type parameter and reaches the rung's own report, helpers, and wire through it, so
  one body serves every rung and each rung keeps a three-line call (its own header, the
  `20260820.131713` design call).
- **`queue.rye`** separates the bell from the count. A ring says something happened; how much
  happened is a fact of two indices in shared memory -- the producer's head in producer-owned
  memory, the consumer's tail in consumer-owned -- and a drain reads until empty rather than
  once per ring, because rings coalesce.
- **`mask.rye`** holds a phase's dependency set in one `u32`. `max_queue_len` is sixteen, so
  every sibling set a turn can name fits inside one machine word; the queue closes the whole
  plan once at the door, and every admission after is a single bit test.
- **`roster.rye`** derives the supervisor's capability table from the parsed declaration the
  witness already checks, so the rights enforced and the grants read are one source of truth.
- **`courier.rye`** carries a correction to the reader who never returns, rather than leaving
  it standing on a wire they have already left.

## The five insights, held against those mechanisms

**The bound in the shape -- already native here.** `mask.rye` is the pattern's own proof in the
room: a set that fits one word because the bound (`sixteen`) was chosen to make it fit, closure
paid once at the door, membership one bit forever after. The reading for the rest of the room:
where a queue index wraps, the wrap-is-meaning rule applies -- a ring buffer's wrap is
semantics, a linear count's wrap is aliasing -- and each wrap site owes its one-line invariant
comment saying which it is.

**Coordinate-as-address -- present as derivation, extendable as addressing.** The roster's
derived capability table is the same argument one step removed: what is derived from the
declaration can never disagree with it. The addressing form -- a dependent's index naming its
region offset by arithmetic rather than by a stored table -- is the open extension, and it is a
design move rather than a found fact.

**Pure-fold determinism -- half-held.** Each rung's self-test walks its checks in a fixed
order, which is a fold. What the room lacks is the replay statement across a whole drain: the
same submissions in the same order leaving the same field of dependents in the same state,
proven by running it twice. That witness is buildable with what exists.

**Signed-fact rounds -- the courier's missing half.** `courier.rye` already prices the reader
who never returns. A correction carried as a signed fact -- author, stamp, replayable order --
would let the courier's answer survive the supervisor itself restarting, which is the Mycelium
discipline one room over.

**Three op families plus a fuser -- honestly, no purchase.** A supervisor schedules and
refuses; it does not lower tensor graphs. Named so the mapping stays a reading rather than a
costume.

**The field lens, as a labeled metaphor.** The bell-and-queue split already thinks in fields:
the ring is a ripple, and the truth lives in the medium -- read the memory, never count the
ripples. As engineering this is exactly `queue.rye`'s property today; the lens adds a name for
why it keeps being right. The toroidal wafer rehearsal extends the same picture to a field of
cores swept as a value, and that is Caravan's far scheduler horizon rather than its present.

## What this reading does not claim

The room's 118 sources were sampled by mechanism, and five carry this reading; a rung-by-rung
audit is its own lap. Every quoted property above traces to a named file's own header, read
`2026-08-26`, and the design moves that follow from this reading live in the sibling
active-designing page, where each carries its bound, its witness plan, and its falsifier.
