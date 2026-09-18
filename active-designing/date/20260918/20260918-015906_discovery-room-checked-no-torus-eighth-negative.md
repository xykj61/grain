# Discovery room checked -- eight for eight, no torus

**Stamp:** `20260918.015906`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- two named leftovers read, both checked negative for a torus seam
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`../20260917/20260917-235220_comlink-checked-one-ring-one-tree-no-torus.md`](../20260917/20260917-235220_comlink-checked-one-ring-one-tree-no-torus.md) --
that piece named these two spots for a line-by-line read rather than the whole grep sweep; this
piece takes it

## The one sentence this piece is for

The prior read of Comlink matched `ring` or `cycle` in `comlink/discovery/` (six files) and in
`guest_pattern_rx.rye` / `guest_open_asks_consent_rx.rye`, then left them for a closer look rather
than resolving them. This piece takes that look.

## What was checked

The same four-pattern sweep the whole thread has used -- `%`, `wrap`, `ring`, `cycle`, `torus`,
`modul` -- run narrowly over the eight named files:

```
grep -nE '%|wrap|ring|cycle|torus|modul' comlink/discovery/*.rye \
  comlink/guest_pattern_rx.rye comlink/guest_open_asks_consent_rx.rye
```

then, because a bare `%` also matches a doc-comment percent sign and a struct-field name, a second
narrower pass asking only for the modulus operator in code position:

```
grep -nE '[A-Za-z0-9_\)\]][[:space:]]*%[[:space:]]*[A-Za-z0-9_(]' <same files>
```

## What was found

**Every hit repeats one of the three shapes the thread already catalogued, and the sweep turns up
nothing beyond them.**

- `comlink/discovery/tally_copy.rye:4` and `region.rye:16` carry the English word *wraps*, once in
  a doc comment about trust and once about a symlink boundary -- prose, both times, standing plainly
  for what it says.
- `comlink/guest_pattern_rx.rye:21` reads `rx_queue.kick(); // ring the RX doorbell` -- the English
  verb *ring*, naming a hardware doorbell kick.
- `comlink/discovery/region.rye:42` and `tally_gardens.rye:340` carry *wrap* and *ceiling* inside
  `// invariant:` comments about a length cast staying under `u32`. A refusal at a ceiling is the
  opposite of a wrap: the code asserts the value stays under the point where wrapping would start
  to matter.
- `comlink/guest_open_asks_consent_rx.rye:155-156` reads `const cycle_len = log_len;`, the length
  of a fold-log slice, read once and passed straight to `oa.fold_log`. It is a plain count, held
  and passed, with an index touching it nowhere.
- `comlink/discovery/round_trip_wire.rye:44` -- `(ms % 1000) * 1_000_000` -- is the one real modulus
  in the set, and it repeats the same unit-conversion shape the thread has already catalogued twice
  (milliseconds into a nanosecond remainder for a timespec). It converts a unit alone.

**Two axes stay absent, and so does one.** Two of the eight files carry every hit the sweep found;
the other six -- `gossip.rye`, `introduce.rye`, `descriptor.rye`, `descriptor_test.rye`, `table.rye`,
`kumara.rye` -- read clean of all six patterns.

## Inference

The eighth read closes the same way the seventh did: everything here stays short of even one
bounded ring, let alone two independent ones. `guest_pattern_rx.rye` and
`guest_open_asks_consent_rx.rye` looked the most promising going in -- both names carry *pattern*
and the sweep's `ring` hit sat inside the RX path itself -- and both resolved to a doorbell kick and
a slice length, plain code rather than address arithmetic. The discovery room reads as six files of
gossip, introduction, and descriptor plumbing, bounded by name lookups and table scans rather than
modular indices.

This closes every module the prior synthesis named as unread inside Comlink proper. What remains of
the four-module list that piece opened is Tablecloth's real store, Amphora, and Brix, all three
untouched by this note.

## Falsifier for this finding

A future round finding a `%` (or an equivalent bitmask-and, `& (N - 1)`) inside
`comlink/discovery/table.rye` indexing a fixed-size peer table, or inside `gossip.rye` indexing a
fixed-size fanout set, would give the discovery room a real ring this note says it lacks, and this
finding would then want a correction rather than a ninth confirming entry. The bitmask form earns
this note's own naming because the four-pattern sweep this thread has run eight times running has
searched the bare modulus alone across every one of them, and a power-of-two ring is exactly the
shape that would reach for the mask instead.

## What remains unchecked, said plainly

**The bitmask gap above sits in the METHOD as much as in the coverage**, and it reaches every one of
the eight prior reads alongside this one. Tablecloth's real store, Amphora, and Brix stay open for a
future pass -- wider pattern included.

## Related

No tracked issue. This note adds zero dependency to any ship's Now line and leaves
`construction/ITINERARY.md` exactly as it stands.

May the next reader who widens the sweep for a shifted mask find the shape as plainly as six bare
moduli have read so far.
