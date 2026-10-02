# The four pairs ride as one string, not four channels

**Stamp:** `20261002.004836` (America/New_York)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Landed -- a reading of code already in the tree; no new witness, no new build
**Room:** checkable -- every claim below cites a file and a line range, re-readable on this host
**Lane:** Diffuser research
**Kin:** [the whitepaper's own falsifier](../../date/20261001/20261001-144913_the-whitepapers-own-falsifier-fired-first.md), whose restated falsifier is tested here; [the ladder itself](../../date/20260910/20260910-060204_the-bounded-torus-moonshots.md), row 7 and row 11

## The claim in one sentence

The torus ladder's closing whitepaper named a standing falsifier -- *a future row finding a real
traffic weight between modules* could reopen row 11's question of whether a two-axis, metric claim
("a torus," "a radius") describes something real in this tree. Aurora's `roster_pairs` stage is the
one place in the tree that looks like it would carry that weight, since it names five domains and
four channels and wakes two QEMU guests to cross them. Reading `comlink/guest_roster_tx.rye` and
`comlink/guest_roster_rx.rye` end to end shows the four channel pairs travel together, inside one
transmission rather than four. They ride as one plain-text string, sealed once, sent once, and
opened once, by exactly two guests standing outside the roster's own five names. The traffic to
weigh here reads as zero, since the per-channel transport itself remains unbuilt -- a narrower and
more specific finding than "the weight is unmeasured," and one that further confirms rather than
reopens row 11.

## Observation: what the code actually does

**The roster is five domains and four declared edges, in `aurora/src/roster.rye:18-30`:**

```
domain_count = 5   (serial_driver, serial_virt, client_a, client_b, timer_driver)
channel_ends = {0,1} {1,2} {1,3} {4,2}
```

This is the structure row 7 already measured as a graph (diameter, mean hop), with every edge
carrying the same unweighted structure. `aurora/run.sh roster` wakes one freestanding hart that
recites this declared structure over the console and halts, moving zero bytes between the five
named domains. It is data one hart speaks about itself, rather than traffic passing between two
harts.

**The `roster_pairs` stage wakes two guests, read whole from `tools/co/comlink_roster_pairs_lab.rish:1-24`:**
one `roster-tx.elf`, one `roster-rx.elf`, one virtio-net socket between them (`127.0.0.1:15556`).
Two guests share one wire, where the roster's own picture calls for five domains and four.

**The payload sent across that one wire, read whole from `comlink/guest_roster_tx.rye:9-13`:**

```
const pairs =
    "serial_driver serial_virt\n" ++
    "serial_virt client_a\n" ++
    "serial_virt client_b\n" ++
    "client_a timer_driver";
```

This is a 93-byte ASCII string naming the four pairs as *text*. `kmain` (lines 24-45) seals this one
string with `wf.seal_message`, writes it into one Ethernet frame, and sends it once. The receiving
guest (`comlink/guest_roster_rx.rye:9-13, 32-57`) holds the identical string as its own expected
value, opens the one frame it receives, and byte-compares the opened text against it with
`same_pairs`. One frame carries the whole list, rather than four frames each carrying its own pair.

**The roster's own five domains stand apart from the two guests that actually send and receive
here.** The sender and receiver in `roster_pairs` are an unlabeled `roster-tx.elf` and
`roster-rx.elf`, playing the same Alice/Bob roles `guest_sealed_tx.rye`/`guest_sealed_rx.rye` already
play for an unrelated demo sentence, rather than `serial_driver`, `serial_virt`, `client_a`,
`client_b`, or `timer_driver` themselves. The roster's own domains stay declarative text: a domain
such as `serial_driver` or `timer_driver` has yet to receive its own process, address, or wire to
measure.

## Inference: what this means for row 11's restated falsifier

The falsifier asked for "a real traffic weight between modules" -- a number, per edge, read off
something that actually moves. Aurora's `roster_pairs` stage is the one code in this tree that
wakes real guests over a real wire while naming the roster's real domains, and reading it shows
exactly one measurement exists to take: one string, sent once, between two guests standing outside
the roster's own five names. A weight is a quantity that varies across edges, and four identical
zero-weight readings (every domain stays a bystander, since every domain stays apart from the two
guests that actually run) describe a single point rather than four. The one transmission speaks for
itself alone, rather than for the four edges individually.

This finding goes further than row 7's, which stopped at calling the weight *unmeasured* and
substituted a structural count (225 citation edges) in its place. This finding names the reason the
weight stays unmeasured: the implementation that would carry it waits to be built. `roster_pairs` is
named for the roster and tests only that its *text* survives a seal and an open -- a correctness
check on the wire-format code, wearing the roster's language.

## What survives, named plainly

- **The wire-format and seal code is real and already proven** -- `wf.seal_message` /
  `wf.open_datagram` carry a 93-byte string intact across a sealed, attested, content-named
  datagram, exactly as the sealed and posted stages already proved for an unrelated sentence. The
  cryptography stands sound and untouched by this finding.
- **The roster's structure (five domains, four edges) stays exactly what row 7 already measured.**
  This reading leaves that one standing as it was.

## What stays open, named plainly

**A real per-channel traffic weight for Aurora's placement map would need five domains that each
wake as their own guest or process, each sending and receiving its own messages, counted
separately.** That is a materially larger build than `roster_pairs` -- five QEMU guests (or five
Caravan-supervised dependents) wired through something closer to Comlink's own eventual multi-guest
fabric, five guests rather than two. This tree has yet to attempt that build, and this page leaves
it unattempted rather than proposing it speculatively; per the lane's own discipline, inventing five
guests to manufacture a traffic number would fit a premise to an answer rather than measure one.

## Falsifier, restated for the next reader

**This page's claim -- that per-channel traffic weight stays unbuilt rather than merely unmeasured
-- is itself falsifiable.** A future stage that wakes five separate domain guests, routes distinct
messages over the four declared channels, and counts bytes or frames per channel would produce the
first real traffic weight this ladder has asked for across five separate rows. If that weight then
varied meaningfully across the four edges *and* correlated with a radial or toroidal placement
rather than with the plain graph structure row 7 already read, row 11's question would be genuinely
reopened. Until such a stage exists, the honest reading stays: one string, one wire, zero per-edge
measurements.

## Confidence

High, on a narrow claim. Every line cited above is read directly from tracked source in this tree,
re-readable by any hand with the same three files open. The inference -- that one non-differentiated
transmission supplies a single point rather than a traffic *weight* -- is a definitional point
rather than a measured one, and it is the whole of what this page argues beyond the three files it
quotes.

## Related

- [The whitepaper's own falsifier fired first](../../date/20261001/20261001-144913_the-whitepapers-own-falsifier-fired-first.md) -- row 11's restated falsifier, tested here
- [The bounded-torus moonshots](../../date/20260910/20260910-060204_the-bounded-torus-moonshots.md) -- row 7, the structural proxy this page sharpens
- `aurora/src/roster.rye`, `tools/co/comlink_roster_pairs_lab.rish`, `comlink/guest_roster_tx.rye`, `comlink/guest_roster_rx.rye` -- the four files this page reads whole
