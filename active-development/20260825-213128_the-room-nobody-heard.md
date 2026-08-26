# The Room Nobody Heard, Put on a Stopwatch

**Language:** EN
**Stamp:** `20260825.213128`
**Voice:** Kyri
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- every figure below was taken on this pier on `20260825`, by running the
files it names
**Kin:** [`the roster that decides what gets measured`](../active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md) -
[`reds-first`](../.claude/rules/reds-first.md) - [`stamp-and-name`](../.claude/rules/stamp-and-name.md) -
REDS %231, %232

---

## The question the card asked

`construction/ITINERARY.md` named a next door and named its first move: `equinox` stood at 144
witnesses no clock carries, and before proposing a roster row for them, *do those
`tools/gen/season/` witnesses still pass, and what does a sing cost?*

Both halves have answers now, and the second one changed what the first one means.

## What was measured, and on what

All figures below: this pier (Vultr SEA, AMD 4 vCPU / 8 GB, `nproc` 4), `20260825`, EDT, tree at
`c1b2f33422`. Wall-clock milliseconds from `date +%s%N` around each run, sequential, one witness at
a time.

### Reading one -- how much of the room is heard

| Reading | Count |
|---|---|
| Tracked `*_witness.rish` under `tools/gen/season/` | **298** |
| Reached by a roster clock (standing or cadence) | **3** |
| Unreached | **295** |
| The tree's whole unreached population | 1,201 |
| This one room's share of it | **24.6%** |

The three that are heard are `dated_pattern`, `equinox_e123_living_pin_guard`, and
`reds_ledger_monotone`. Every other witness in the room stands proven exactly once: on the lap it was
written.

### Reading two -- what a sing costs

The `equinox_*` family is 144 of those 298. Its shape is the finding:

| Reading | Count |
|---|---|
| Witnesses that chain another witness | **111** |
| Leaf witnesses -- they call scans and chain nobody | **33** |
| Of the 144, files named `*_choir_witness.rish` | 82 |

A sequential sing of the first **47** cost **1,117,243 ms** -- eighteen and a half minutes for a
third of one family. Per witness the range is **178 ms to 204,250 ms**, and the rise is structural:
each rung runs its elder, which runs its elder. `e116` re-runs `e115`, which re-runs
`instrument_suite`, and so on down to `e102`. Singing this family rung by rung is quadratic in the
chain's depth, so the honest reading of the whole 144 is some other reading.

**The leaves are the cheap reading.** All 33 ran in **129,383 ms** -- two minutes -- and because
every chained failure resolves to a leaf or to a scan, the leaves are where a root actually lives.

### Reading three -- do they still pass

| When | Green | Red | Wall |
|---|---|---|---|
| At the lap's open | 16 | **17** | 129,383 ms |
| After this round's two repairs | **21** | 12 | 145,024 ms |

## What the reds traced to

**Two roots carried most of them, and both are the same fault wearing two coats.**

`construction/REDS.md` folds. The living pin holds the rows still flat, and every elder row moves
onto a shelf under `construction/archive/`. Row 42 has lived at
`archive/REDS-voice-season-rows-25-57.md` since its fold. Meanwhile:

- **19 call sites across 17 season scans** asked the *pin* for a numbered elder row --
  `rg -q '^| 42 |' "$REDS"`.
- **21 call sites across 15 season scans** asked the *pin* for that row's lesson in its own words --
  `rg -qi 'on-touch|campaign|ladder' "$REDS"` -- on the line right below.

Each has refused since the lap its row folded, in silence, because nothing runs them.

**The transferable finding: a fold repoints documents and leaves guards standing, because a guard's
citation is code rather than a link.** `tracked_link_scan.sh` reads links inside files, and an `rg`
pattern inside a shell script is a third thing: code that cites. The stamp-and-name law
already says a stale reference is resolved rather than rewritten -- what it had not yet said is that
the resolving must reach the code that cites.

## What this round changed

One question, one place, asked by both readings:

- [`../tools/fixtures/reds_spine_files.sh`](../tools/fixtures/reds_spine_files.sh) -- which files
  are the ledger's spine, right now. Shelves first, living pin last. Spelled **once**.
- [`../tools/fixtures/reds_row_present.sh`](../tools/fixtures/reds_row_present.sh) -- does the spine
  hold row N, in either row shape the ledger has ever written.
- [`../tools/fixtures/reds_spine_grep.sh`](../tools/fixtures/reds_spine_grep.sh) -- does the spine
  record this text.

All **40** call sites call them now. A misuse exits **2** where an absence exits **1**, so a caller
reading "absent" can trust the ledger was actually asked.

[`../tools/r/reds_row_present_witness.rish`](../tools/r/reds_row_present_witness.rish) holds it, and
it is on the roster. It proves agreement on metal, rather than asking a later hand to keep it: the sibling
`reds_ledger_monotone_scan.sh` counts the spine, and this witness asks the new reading for **every
one of those rows** plus the row past the end.
[`../tools/fixtures/reds_row_present_control.sh`](../tools/fixtures/reds_row_present_control.sh)
builds a two-file ledger in a throwaway pen and proves **13 cases -- 7 welcomes beside 6 refusals**,
because a refusal proven in both directions is the only kind that can be told from a bypass.

**It earned itself the same lap.** Booking REDS %231 and %232 pushed the living pin past its own
24,576-byte bound, so rows %226-%229 folded to a shelf -- and the new reading found row %226 at its
new home with no edit anywhere.

## What is still red, and why it is a lap rather than a line

Twelve leaves still refuse, and they are three kinds:

- **A living measurement below a season-era floor.** `equinox_e102_fascia_chase_scan.sh` wants
  `fascia_metric_v0` at **92 or better** with `signal:superseded=0`; the metric reads **51** today,
  with `ratchet_outstanding=2` and `over70=14`. This one is honest on both sides: the guard is right, and the tree
  moved. It is the deepest root -- `e102` is the elder of the whole `ch7` and `e1xx` chain.
- **More frozen censuses.** `equinox_e142_q2_cli_doc_scan.sh` reads
  `detail=want_amphora_10_got_11`: the property holds while the photograph keeps its moment, which is
  REDS %147's class exactly.
- **Living text that has moved on.** `equinox_e140_align_amphora_scan.sh` wants an Amphora line in
  `TASKS.md`, which fused into the card on `20260823.103804`.

## What follows, and what does not

**A roster row for this room waits on those reds.** Rostering 295 witnesses a majority of which
refuse would red the roster on every cadence lap, and a guard stays useful exactly as long as it
reds on faults rather than on ordinary work. The order is: close the roots, then roster the room, then lower the
`witness_reach` ceiling by what the row carries -- the same order `ales_suite` followed.

**And the sing, when it comes, is not the sequential one.** 111 of 144 chain an elder, so a choir
that runs each rung once -- topologically, elders first, each result reused -- costs the leaves plus
each chain once rather than each chain many times. The measurement above is the argument for
building that choir rather than looping over `git ls-files`.

*The room was quiet for a season, and quiet read as fine. It reads as measured now, which is the
better kind of quiet.*
