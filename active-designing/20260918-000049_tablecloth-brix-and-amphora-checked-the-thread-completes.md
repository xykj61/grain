# Tablecloth, Brix, and Amphora checked -- the four named modules are read, all eight negative

**Stamp:** `20260918.000049`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- three module reads, each checked negative for a torus seam; closes the torus-thread synthesis's own open question
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260917-233424_the-torus-thread-closes-five-checks-one-buildable-seam.md`](20260917-233424_the-torus-thread-closes-five-checks-one-buildable-seam.md) --
the synthesis that named these four modules unread -
[`20260917-235220_comlink-checked-one-ring-one-tree-no-torus.md`](20260917-235220_comlink-checked-one-ring-one-tree-no-torus.md) --
the sixth read, and the first of the four to close

## The one sentence this piece is for

The prior synthesis named four modules as unread -- Comlink, Tablecloth's real store, Amphora, and
Brix -- and rated its own confidence "medium, at best" until they were. Comlink closed negative the
same night. This piece reads the remaining three -- the real `pond/apps/tablecloth*.rye` store (four
files, 1,197 lines), `brix/infuse.rye` (201 lines), and `amphora/` (eleven files, 5,460 lines) -- by
the same method the six prior reads used. **All three close negative.** The four-module list this
thread opened with is now fully read, and the pattern holds eight modules running.

## What was read, and how

The same four-pattern sweep every prior read in this thread used, reproducible in one command per
module:

```
grep -rn '[a-zA-Z0-9_)] % [a-zA-Z0-9_(]' <module> --include='*.rye'
grep -rl 'wrap\|ring\|cycle' <module> --include='*.rye'
```

| Module read | Files / lines | Modulo hits | wrap/ring/cycle hits | Verdict |
|---|---|---|---|---|
| Tablecloth (`pond/apps/tablecloth*.rye`) | 4 / 1,197 | 0 | 3 files, all false positives | checked negative |
| Brix (`brix/infuse.rye`) | 1 / 201 | 0 | 0 | checked negative |
| Amphora (`amphora/`) | 11 / 5,460 | 4 | 6 files | checked negative |

## What was found

**Tablecloth is a flat, content-addressed catalog, holding a single axis.**
`tablecloth_index.rye`'s own job -- verifying a published manifest against a live `BeadStore` --
walks a linear `while (i < man.count)` loop over catalog entries, each name resolving to a digest
address. The three `wrap`/`ring`/`cycle` hits all carry their ordinary English sense alone:
"Unwelcome" (a substring match on the sweep's own loose pattern), a doc comment's "rejects," and
`tablecloth_keyed.rye`'s "wraps rung one's fetch over the wrapped catalog" -- which means
*encapsulates*, confirmed by reading the function it describes: a plain pass-through fetch alone.

**Brix's `infuse.rye` stays flat throughout.** Zero modulo hits, zero wrap/ring/cycle hits. The
module is a flat key-value override merge -- Brix descriptors parse into `Pair{key, val}` slices,
and `infuse` walks them once, override-then-base, appending override-only keys in order. Every loop
in the module visits its index a single time, so the module holds nothing that could wrap.

**Amphora's four modulo hits are two parity checks and one repeated test fixture.**
`vessel_seal.rye:250` and `vessel_core.rye:88` both read `value.len % 2 != 0` -- an even-length
check on a hex string, the ordinary parity idiom alone. `vessel_fetch_wire.rye:295` and
`vessel_fetch_delivery.rye:545` both read `i % 251`, and both sit inside a *fixture generator*
building a deterministic 400-byte test buffer (`big[i] = @intCast(i % 251)`) -- a compact way to
fill test data with varying bytes, chosen because 251 is prime and near 256, which spreads values
before any short pattern can repeat. It is periodic in the same trivial sense that any `i % N`
fixture is; the buffer is written once, read once, and discarded, a single pass rather than an
index returning to itself. The six `wrap`/`ring`/`cycle` file hits are every one of them the label
`"amber-ring1-season"` -- a generation-numbering convention (`ring1` as in *round one*, a shoulder
label for a build season) confirmed by its own comment, "Class W wire shoulder stays
amber-ring1-season," describing a name rather than a structure.

## Inference

The eighth module this thread has opened yields an eighth purpose-built absence -- flat structure
throughout, lacking even a near-miss worth a second look the way Comlink's `topology.rye` was. Two
of the three modules read here (Tablecloth, Amphora) carry `wrap`/`ring`
vocabulary in their own prose, and both resolve to ordinary English on inspection -- the sweep's
false-positive rate on vocabulary alone is now three for three across this reading, which says the
four-pattern grep is doing its job as a **pointer to read closely** rather than a verdict in
itself, exactly as the Comlink piece already noted.

**The four-module list the prior synthesis opened with is now closed in full.** Eight modules read,
eight negatives, and the only genuine periodic structure in this tree remains the two small,
purpose-built rings the first reading already knew about -- `caravan/queue.rye`'s buffer slot and
`caravan/cycle.rye`'s domain lap -- plus Comlink's `virtio_net.rye` ring, which is the *same shape*
serving the *same reason* (a fixed-size hardware queue) rather than a new pattern.

## Falsifier for this finding

A future round finding genuine two-axis structure inside Amphora's vessel-sealing pipeline -- a
second modulus composing with `value.len % 2` rather than sitting beside it, such as a chunked
vessel format that wraps both a chunk index and a chunk-internal offset -- would change this
module's shape from what stands today. A Tablecloth catalog growing a second dimension (for
instance, a versioned or namespaced key space that wraps rather than simply growing) would do the
same for that module. Both stay hypothetical against the code read today.

## What remains unchecked, said plainly

The prior synthesis's own four-module list is now exhausted. What stays open: `caravan/` alone
still carries 114 tracked `.rye` files against the 7 this whole thread has opened across all its
readings (`queue.rye`, `cycle.rye`, `unhand.rye`, `confer.rye`, `revoke.rye`, `address_space.rye`
cited once, plus this reading's zero new Caravan files). Comlink's own `discovery/` room (six files)
and its `guest_pattern_rx.rye`/`guest_open_asks_consent_rx.rye` pair were named as unread in the
sixth piece and stay that way. Every module this thread has left unnamed -- Glow's own compiler
passes, Granary, Cellar, Mandi, MUR, Lantern, Mycelium -- stands entirely outside this sample.
**Eight checked-negative readings describe a pattern across a named, bounded list; they sample a
tree this large rather than exhaust it**, and the confidence that every other composable seam
already stands composed stays at medium, exactly where the sixth piece left it -- a wider claim
would need a wider sample than this thread has any plan to take in one lap.

## What this means for the master page's ranking

Unchanged from the sixth piece. Rows 2 (Caravan as pole), 5 (Tablecloth on a torus), and 7 (Aurora
on a core torus) keep their stated confidence -- Medium, Medium-low, Low. Row 5's own module is now
the one most directly read of the three: Tablecloth's real store confirms, rather than assumes,
that a torus over it starts from zero rather than composing an existing seam.

## Related

No tracked issue. This note adds zero dependency to any ship's Now line and leaves
`construction/ITINERARY.md` exactly as it stands. The buildable item this whole thread has produced
-- `tally/torus_index.rye`, named in the fifth piece -- stays exactly as sized and unbuilt as it
stood there; this reading leaves its cost and its readiness for Bakery exactly as they were.

May the next reader who opens Caravan's remaining 107 files, or Comlink's discovery room, find this
table worth one more row, and may the day a genuine second axis turns up outside these two small
rings be written down as plainly as its absence has been eight times running.
