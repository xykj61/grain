# The map a guard writes for itself

**Stamp:** `20260907.061951`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- **research for understanding**: a measurement of whether a guard's watch set can be observed rather than
declared. Nothing here is bound by a witness yet; the proposed room is where it sits
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).
**Kin:** [`20260907-020817_what-the-fleet-spends-on-knowing-it-is-green.md`](20260907-020817_what-the-fleet-spends-on-knowing-it-is-green.md) -
[`../tools/fixtures/s/standing_equipment_scope_map.sh`](../tools/fixtures/s/standing_equipment_scope_map.sh) -
[`../active-designing/20260825-173153_reprove-only-what-moved.md`](../active-designing/20260825-173153_reprove-only-what-moved.md) -
[`../foundations/20260811-211431_the-lindy-effect-and-the-long-return.md`](../foundations/20260811-211431_the-lindy-effect-and-the-long-return.md)

## The question, and the mechanism that answers it

The elder paper measured that **80.2% of a roster pass's wall clock is unmapped**, and closed by
saying a shared verdict cache stays unbuildable while four fifths of the pass has no key. That
sentence assumed the map is something a hand writes. This paper tests the other possibility.

**The mechanism, in plain words.** Run a rostered witness under
`strace -f -y -e trace=openat`, read the resolved path each successful `openat` returns in its
`fd<...>` annotation, and keep the paths that begin with the repository root. That set is exactly
the files and directories the guard opened. Compared line by line against the guard's row in
`tools/fixtures/s/standing_equipment_scope_map.sh`, it answers two questions at once: whether a
watch set can be derived by observation, and whether the rows already written say what their
guards actually read.

**Bounds, before any number.** Every figure was measured on the Dallas pier on `20260907` between
`05:40` and `06:20` America/New_York, at git nib `e67a4453d1`, on an 8-thread AMD EPYC instance
carrying `15,982` tracked files by `git ls-files`. **Load average stood at 20.9 through the
window**, since seven peer ships and a full cold roster pass ran beside the measurement, so every
wall figure here is a loaded figure. Ratios between two timings taken back to back carry that load
in both terms and are the readings to trust; absolute seconds are the readings to discount. The
sample is **11 rostered guards**, chosen to hold both mapped and unmapped rows and to span the
cost range from 0.3 to 77 seconds.

## Observation: the read set is observable, and it is stable

For each sampled guard the traced run produced a path set. Two guards were run twice under the
same tree to test repeatability:

| Guard | Run 1 paths | Run 2 paths | Differing lines |
|---|---|---|---|
| `rule_twin` | 106 | 106 | **0** |
| `log_has_a_row` | 126 | 126 | **0** |

**The read set is byte-identical across runs on an unchanged tree**, which is the property a cache
key needs before anything else.

**Directories appear in the set beside files**, because a guard that walks a room opens the room.
`log_has_a_row` opened 76 directories and 50 files. That distinction matters for the key: a
directory's dependency is its listing rather than its bytes, so a correct key digests file
contents and directory entry names, and an added file is then caught by the room that would have
read it.

## Observation: what tracing costs

| Guard | plain (ms) | traced (ms) | ratio |
|---|---|---|---|
| `index_row_bound` | 311 | 2,054 | 6.6x |
| `rule_twin` | 2,447 | 7,381 | 3.0x |
| `log_has_a_row` | 2,877 | 19,179 | 6.7x |
| `prose_register` | 2,060 | 9,196 | 4.5x |
| `radiant_negation` | 5,935 | 19,910 | 3.4x |
| `tally_roster` | 25,871 | 68,647 | 2.7x |
| `living_card_ascii` | 29,927 | 31,933 | **1.1x** |
| `crushed_index` | 35,827 | 211,147 | 5.9x |
| `tame_style_check` | 37,195 | 60,252 | 1.6x |
| `reds_row_present` | 41,893 | 117,417 | 2.8x |
| `borrowed_number` | 77,467 | 198,417 | 2.6x |

**Tracing costs between 1.1x and 6.7x**, and the spread follows process count rather than file
count: a guard that forks per file pays per fork. This is a one-time cost per guard, paid when a
row is derived, rather than a cost the roster carries every lap.

## Observation: six of eight hand-written rows name less than their guard reads

For the eight sampled guards the map already names, each observed **file** was matched against the
row's watch words under the runner's own glob semantics. Directories were counted apart, since a
changed path is always a file and a bare directory can never match.

| Guard | Files read | Covered by its row | **Gaps** | Directories |
|---|---|---|---|---|
| `rule_twin` | 104 | 104 | **0** | 2 |
| `log_has_a_row` | 50 | 50 | **0** | 76 |
| `index_row_bound` | 4 | 3 | **1** | 1 |
| `reds_row_present` | 266 | 264 | **2** | 1 |
| `prose_register` | 80 | 76 | **4** | 0 |
| `tame_style_check` | 1,135 | 1,128 | **7** | 220 |
| `radiant_negation` | 142 | 89 | **53** | 2 |
| `tally_roster` | 844 | 28 | **816** | 3 |

**Six of eight rows name less than their guard reads**, and the map's own header calls that the
one direction that skips real work. Each gap is a file whose change leaves the guard unrun under
`--scoped`. Named concretely:

- **`tally_roster`, 816 gaps, and 813 of them are `vendor/zig-toolchain/`.** Its row reads
  `tools/fixtures/t/tally_roster_scan.sh tally/ tools/t/tally_*` and carries no `[build]` word,
  while the guard compiles Rye and reads the vendored toolchain, `rye/bin/rye`, and a fixture
  outside its glob. The map's header states the build-edge rule in plain words; this row was
  written without it.
- **`radiant_negation`, 53 gaps, 51 of them `.claude/rules/`.** Its row names `foundations/` and
  three `context/` pages. Editing a rule file leaves this guard unrun.
- **`prose_register`, 4 gaps**, one a `foundations/` document its row reaches only as
  `foundations/README.md`, and three the git plumbing files `.git/config`, `.git/HEAD`,
  `.git/index` -- a dependency the map has no way to spell at all.
- **`reds_row_present` and `tame_style_check`** each read sibling fixture scripts their rows leave
  out: two and seven respectively.

**The direction of every gap is the same.** Not one sampled guard read *less* than its row claims
in a way that would cause a false skip in the other direction, so the rows are consistently
under-named rather than randomly wrong. That is what a hand writing from memory produces.

## Inference: the map is the one behavioral claim in the roster nobody checks

The roster exists because a claim in prose can be read and trusted and never run. The scope map is
prose of the same kind, one layer down: **a row asserts what a guard reads, and nothing compares
that assertion to the guard's behavior.** The Lindy foundation states the general form -- truth
that was checked stays checkable, and truth that was merely asserted decays -- and the crossing
foundation states the specific one: the content address is the wall, since verify reads the header
and never the pack. **A map row is a header. The observed read set is the pack.**

This also explains the direction of the gaps without blaming anyone. A row is written when a guard
is written, from the author's picture of what it reads; the guard then grows, gains a fixture,
gains a compile step, and the row stays where it was. A derived row moves with the guard by
construction.

## Observation: keying a verdict is cheap, even at tree scale

For each read set I timed the obvious key: `sha256sum` over every file in the set, `ls -a` over
every directory, the whole stream hashed once.

| Guard | Paths | Digest (ms) | Guard (ms) | Digest as share of guard |
|---|---|---|---|---|
| `borrowed_number` | 3,026 | 154 | 77,467 | **0.2%** |
| `crushed_index` | 512 | 85 | 35,827 | **0.2%** |
| `tally_roster` | 847 | 145 | 25,871 | **0.6%** |
| `rule_twin` | 106 | 43 | 2,447 | **1.8%** |
| `living_card_ascii` | 15,011 | 780 | 29,927 | **2.6%** |
| `index_row_bound` | 5 | 35 | 311 | 11.3% |
| `log_has_a_row` | 126 | 685 | 2,877 | 23.8% |

**Keying costs a few tenths of a percent of the work it would skip**, and the two high rows have
plain causes: `index_row_bound` is a 311 ms guard where a 35 ms floor is most of the reading, and
`log_has_a_row` pays 76 `ls` forks that an in-process `readdir` would remove.

**The expected boundary turned out to be somewhere else.** I expected a whole-tree reader to be
too expensive to key; `living_card_ascii` reads **15,011 of 15,982 tracked files, 93.9% of the
tree**, and keys in 780 ms against a 29,927 ms run. The cost is fine. What fails for that guard is
the **hit rate**: a read set covering 94% of the tree changes on essentially every commit, so its
cached verdict is stale as soon as it is written -- the same arithmetic the elder paper used
against a whole-tree key, now applying to one guard rather than to the design.

## Inference: observation gives the unmapped four fifths a key

The elder paper's closing sentence -- item 3 is unbuildable, because 80.2% of the pass has no key
-- rested on the map being handwritten. Three of the eleven guards sampled here are unmapped and
all three produced a read set on the first traced run, with no declaration and no judgment call.
**The unmapped share is unmapped for want of a writer rather than for want of a watch set**, and a
writer that costs one traced run per guard is affordable: at the measured 1.1x to 6.7x, deriving a
row for every guard on the roster costs on the order of one to six roster passes, once.

## Projection: what a derived map would buy, and what would kill it

**Horizon:** the next fifty laps, on a fleet of this size and commit rate.
**Assumptions:** the roster keeps its present shape; guards keep their present read sets between
edits; the derivation runs again whenever a guard's own source changes.

**Projection.** Deriving rows for the unmapped guards moves the mapped share of the pass from
19.8% toward the whole, and the elder measurement of touch rates says the *code* guards among them
skip most laps while the *record* guards skip almost none. The realistic gain sits between the
elder paper's 14.5% floor and its 49% ceiling, and a derived map earns the upper half of that band
only if the costly unmapped guards turn out to be code watchers.

**Falsifier, and it is cheap.** Take five guards, derive each row by tracing, then edit one file
inside each derived set and one file outside it, and run `--scoped`. **The derived map fails if a
guard stays unrun when a file in its own derived set changed**, and it fails just as hard if the
derived set proves unstable across two trees that differ only in an unrelated room. Either
outcome kills the approach outright, and both are answerable in a single afternoon.

**Confidence.** High that a read set is observable, deterministic, and cheap to digest -- three
measurements, all direct. Moderate that a derived row is safe enough to gate on, since the
soundness hazards below are named rather than measured. Low on any figure for the saving.

## What this does not reach, said plainly

**A failed open is a dependency this method misses.** A guard that checks that a file is absent
depends on that absence, and `-y` resolves successful opens alone. Measured on `index_row_bound`,
**zero** failed opens landed inside the repository -- all 16,647 sat in `/nix/` and `/sys/`, the
dynamic linker's search. One guard is one guard; across the roster this is unmeasured, and a
derived map should record repo-internal `ENOENT` paths beside the successful ones.

**A guard whose read set depends on its input is only as good as the trace's tree.** Observation
on one tree names what the guard read there. A guard that opens files a roster names will read
different files when the roster changes -- which the key catches, since the roster file is itself
in the set -- yet a guard branching on the *content* of a file to reach an entirely new room
deserves a second trace before its row is trusted.

**Whether the derived rows should replace the hand-written ones, or stand beside them.** The map's
header says its rows carry judgment: a row follows a guard's *gated* readings, so an advisory
ratchet the witness merely prints leaves the watch set alone. Observation cannot tell a gated read
from an advisory one. **The safe composition is union** -- derive, then add to the hand row, never
subtract -- since adding a watch word only ever makes a guard run more often.

**Watts.** My lane names electricity and this paper measures none. The pier's draw is unreadable
from inside the instance, so the compute share is measured and the energy claim is left unmade.

## What is buildable, for whoever takes it

1. **A trace-and-compare scan.** One fixture that runs a named guard under `strace -f -y`, prints
   its read set, and prints the rows the map omits. Everything in the tables above comes from that
   one program, and it makes the six gaps checkable rather than asserted.
2. **A derived-row proposal file**, written beside the curated map rather than into it, so a hand
   reads the derivation and unions what it accepts. This keeps the judgment the header asks for.
3. **The verdict cache**, keyed on the digest of the read set. This is the elder paper's item 3,
   and the measurement here removes the reason it was deferred.

Items 1 and 2 need no ruling. Item 3 wants item 1 first, and it wants the falsifier run.

**The two gaps a hand should look at today, whatever happens to the rest**: `tally_roster` missing
its build edge, and `radiant_negation` missing `.claude/rules/`. Both are one word each, both make
their guard run more often rather than less, and both are the kind of edit the map's own header
already invites.
