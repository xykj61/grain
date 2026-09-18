# Eight Modules Through the Optimization Spine

**Stamp:** `20260826.014902`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design; eight modules re-read through the five-insight spine, every move sized to one round; proposals only
**Kin:** [`20260826-001744_the-bound-in-the-shape.md`](20260826-001744_the-bound-in-the-shape.md) -- [`20260826-001747_the-wafer-rehearsed-in-software.md`](20260826-001747_the-wafer-rehearsed-in-software.md)

The five silo essays of `20260826.001744` through `20260826.001748` hand the tree five
working insights: **the bound in the shape** (a budget carried in a structure's
coordinates rather than in a runtime check), **coordinate-as-address** (a value's
position names its storage, so no translation table can disagree with the layout),
**pure-fold determinism** (the same inputs in the same order always leave the same
state, so any observer replays the run), **three op families plus a fuser** (every
computation lowered to elementwise, reduction, and movement, composed by a small
bounded compiler), and **signed-fact rounds** (every contribution an authored,
replayable fact, with exclusion by written rule). This essay walks eight modules
through that spine. Each section says what the module is, in the tree's own words,
names the insight that re-shapes it, and proposes one bounded move with a falsifier.
Each move is sized to one round of the new calendar (Keaton's word, `2026-08-26`).
Where an insight fits a module loosely, the section says so plainly.

## Brushstroke -- the bound in the shape

Brushstroke is the drawn surface: values to pixels, immediate-mode
(`context/LEXICON.md`). Its `.brush` parser already bounds everything by vigilance:
a source file at 16,384 bytes, a frame at 8 lines, a proof grid of 40 columns by 8
rows (`brushstroke/brush_parse.rye`, read `2026-08-26`). The insight that re-shapes
it is the bound in the shape. The proof grid is the humble form already: a cell's
(column, row) pair names its slot in a fixed array, so the coordinate is its own
range proof once the pair is checked at the edge. The bounded move: make the grid
fill a pure coordinate-addressed function -- cell index computed from (column, row)
alone, an `// invariant:` beside each of the two edge asserts, and a witness that
fills the grid twice from one `.brush` source and requires byte-identical buffers.
Falsifier: two fills of the same source producing grids that differ in any byte.

## Brix -- pure-fold determinism

Brix is the data side of the Glow/Brix pair: course descriptors, recursion
templates, rosters, aliases, with bond overrides carried by the infuse pattern
(`context/LEXICON.md`, seated `20260729.165912`). The insight is pure-fold
determinism. A cascade of sheets is a fold: `resolved = infuse(base, override)`,
applied per key, and `brushstroke/tokens.rye` already bounds the chain at a cascade
depth of 8 (read `2026-08-26`). What the fold lacks is a witness that says the
resolution depends on the sheets and their order alone. The bounded move: a
cascade-replay witness that folds a planted three-sheet chain twice, requires
identical resolved sheets, and folds a reordered chain to show the order is
load-bearing rather than incidental. Falsifier: one key whose resolved value
changes between two replays of the same chain in the same order. Signed-fact rounds
would be a stretch here; a descriptor is a value someone composes, and a round is a
thing many hands feed.

## Kyri -- coordinate-as-address, at the slice

Kyri is the immutable-value notation: key-value fields, one per line, comments by
`#`, with a zero-copy reader at `scribe/reader.rye` whose fields are slices into
the source, never copied (`context/LEXICON.md`, molted from Bron `20260810`). The
insight is coordinate-as-address in its software form: a field's offset in the
source buffer is its address, so the reader carries no copy that could disagree
with the document. The wafer essay's own bug names the risk in this pattern -- a
slice into a temporary outlives its buffer and every assert misses it. The bounded
move: a slice-containment witness that walks every parsed field and asserts its
slice begins and ends inside the source buffer's range, plus a stated lifetime rule
in the reader's header: the source outlives every field it yields. Falsifier: one
field slice whose bounds fall outside the source buffer, or a call path that frees
the source while fields remain live.

## Lattice -- three op families plus a fuser

Lattice holds f32 tensors in bounded Tally gardens, with laps 0 through 31 green and
an op roster grown one named op at a time -- elu, rsqrt, hard_sigmoid, and kin
(`lattice/README.md`, `2026-07-10`). The insight lands here with no stretch at all:
the teacher project reduces every neural computation to elementwise, reduction, and
movement, fused by a small compiler, and the essay proposes exactly that
inheritance for Lattice's building season. The roster as it stands is the
hand-tuned-library shape in miniature: each activation is its own function, and the
next model wants the next one. The bounded move for one round: classify the
existing roster into the three families in a table in the README, then add one
witness proving three representative ops (softmax, gelu, mean) equal their
family-composed forms on a planted tensor. Falsifier: one existing op that resists
expression as a bounded composition of the three families. The fuser itself, with
its named maximum graph size, stays a Lattice-season door; the classification is
the free first step.

## Lantern -- signed-fact rounds, on the meter side

Lantern is the bounded inference request and response: pins for temperature, seed,
stop sequences, token counts, with laps 0 through 33 green (`lantern/README.md`,
`2026-07-11`). The insight is signed-fact rounds, arriving from the meter's side of
the loop. The swarm essay draws bake-for-serve credit: hours a node gives Ember
become tokens Lantern meters back on one ledger. That loop settles only if the
meter's records are facts someone signed. The bounded move: a signed receipt per
completion -- request digest, tokens in, tokens out, stamp, author key -- appended
to a bounded log, with a witness that replays the log and requires the recomputed
totals to match the running totals, and requires every signature to verify.
Falsifier: two replays of one log disagreeing on a total, or one receipt whose
signature fails while the fold accepts it.

## Scribble -- three families, read as document ops

Scribble turns markdown into block values: headings, paragraphs, fenced code, with
eighteen named views landed across laps 0 through 7 (`scribble/README.md`,
`2026-07-10`). The tensor insight transfers by analogy, and the analogy is worth
naming honestly: blocks are the tensor, and the views are the op zoo. Each extract
is a filter (movement), each tally is a count (reduction), each view is a render
(elementwise), and the roster grew the way Lattice's did -- one special case per
lap, eighteen and counting. The bounded move: express three existing views (h1,
depth tally, fence kinds) as compositions of three primitives -- select, count,
render -- and prove parity against the landed outputs on the existing fixtures.
Falsifier: one composed view whose output differs from its landed original on the
same fixture. The fuser half of the insight stays a stretch here; document views
run cold, and fusing them buys nothing a witness can measure yet.

## Ember -- signed-fact rounds, on the bake side

Ember is the local forge and open-model bake seat, with corpus catalog and query
green and training on the horizon (`ember/README.md`, `2026-07-28`). The insight is
signed-fact rounds, whole. The swarm essay's pattern -- nodes of different sizes
joining a run, sparse deltas over gossip, time-based rounds, a deterministic
aggregate -- is a Mycelium cousin, and its poisoning gap closes with the tree's own
spine: every delta a signed fact, aggregation a pure fold, exclusion by a rule
written before the run, the round bounded by named maxima for nodes, delta bytes,
and timeout. The bounded move follows the wafer essay's rehearse-before-metal
habit: write the round record and its fold now, as a pure module proven on planted
signed deltas on ordinary metal, before any real cohort exists. Falsifier: two
honest replays of one planted round producing different weights, or an unsigned
delta entering the fold without a refusal. The language essay adds the materials
row when training arrives: corpus share per language, published as a dated table.

## Mantra -- coordinate-as-address, already home

Mantra is the version-control projection over Weave, growing the referential
namespace with recall and bolt (`context/LEXICON.md`, seated `20260706.032700`).
The insight is coordinate-as-address, and the bound-in-shape essay says Mantra
already lives it: a content address is the value's own digest, so no registry can
disagree with it. The re-shaping is a hardening rather than a change of shape. The
bounded move: a recall-integrity witness that recalls a planted value by digest,
recomputes the digest of the returned bytes, and requires equality -- proving the
address needs no side table and the store cannot silently substitute. Falsifier:
one recalled value whose recomputed digest differs from the address that fetched
it. The op-family insight has no purchase here; Mantra moves values whole, and a
fuser wants arithmetic to fuse.

## The spine, read across the eight

Three patterns repeat. Where a module already carries a coordinate that names its
storage -- Brushstroke's grid, Kyri's slices, Mantra's digests -- the move is a
witness that the coordinate stays honest. Where a module grew a roster one case at
a time -- Lattice's ops, Scribble's views -- the move is a classification into few
families and a parity proof, with the fuser waiting for a season that earns it.
Where a module will someday take contributions from many hands -- Ember's bake,
Lantern's meter -- the move is the signed fact and the replayable fold, rehearsed
on planted data now. Each move is one round, each closes on a witness, and every
falsifier is a single observable event. That is the spine doing what a spine does:
one discipline, read eight ways, with the stretch named wherever the fit is loose.
