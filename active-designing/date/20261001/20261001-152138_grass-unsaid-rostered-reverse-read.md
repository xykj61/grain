# The unsaid-rostered population, read backward from its newest guard

**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Stamp:** `20261001.152138` (EDT)
**Status:** Living reverse-reading packet -- every count below is read off `tools/fixtures/s/shim_reason_scan.sh list` run on this checkout; the three-way disposition is a judgment.
**Room:** checkable -- every claim is a grep or a file read a reader can repeat.

## The crux

`construction/REDS.md` (`20261001.143449`) names `unsaid_rostered=984` against a ceiling of 903.
That counts rostered bindings asserted on while their own capture goes unreported, the fourth of
`shim_reason`'s four shapes. The row names the size and leaves its composition open. This packet
reads that composition, walking backward from the newest-seated guard. It sorts the population
into the three buckets the crux asked for: genuine process debt, accrete shims whose reason the
meter skips past, and a family that earns an outright exemption.

Measured on this checkout, a day past the row: `unsaid_rostered=988` across **190** rostered guard
files. The population moves with every lap that seats a new guard. That growth is the ratchet's
own nature, not drift worth chasing.

## The walk, newest-seated first

`construction/standing-equipment.kyri` carries a `seated` stamp beside every guard's `path`.
Joining that against the 190 files in the population, sorted by `seated` descending, puts the
newest arrivals first. A binding that just landed is the one most likely to be a live author's own
choice, worth reading closely.

```
$ sh tools/fixtures/s/shim_reason_scan.sh list | grep '^unsaid rostered ' > /tmp/unsaid_rostered.txt
$ awk '{print $3}' /tmp/unsaid_rostered.txt | sort -u | wc -l
190
```

The six newest guards, all seated the same day as this packet, are the chapter-generator family
(`tools/gen/chapter/*_negative_witness.rish` and siblings). They turn out to be the cleanest case
of the third bucket, below.

## Bucket one -- already reported, under a spelling the meter skips past

The scan's own header already names this gap in prose. It credits a `say` inside a conditional as
honest -- the same promise a bare `say` makes, written one indent deeper than the meter reads. That
credit had stood only in prose. Here it meets the live count:

```
$ grep -cE '^if [a-z_]+\.(ok|err|out) == (false|true) then say [a-z_]+\.(err|out)' tools/am/*.rish tools/l/*.rish tools/t/*.rish
```

**83 of the 988 rostered bindings** (8.4%) sit immediately below a line of exactly this shape --
`if build_amphora.ok == false then say build_amphora.err` above `assert build_amphora.ok else
"..."`. Confirmed by reading `tools/am/amphora_contained_name_witness.rish` end to end: nine of its
26 flagged bindings (`build_amphora`, `build_core`, `build_seal`, `build_entry`, `selftest`, `eb1`,
`eb2`, `eb3`, `elder_forge`) carry this guard immediately above the line the scan reads. The scan's
own pattern matches only a bare `say` line, and the conditional's body sits one indent past it. So
these bindings report their target's reason on every refusing run, and the ratchet still marks them
silent.

**80 of the 83 sit in `tools/am/` alone** -- the Amphora build-and-elder-binary bindings. Each one
builds a program, and each one carries this guard because a build's own compiler output is exactly
what a reader wants, and exactly what the author already thought to forward. This reads as debt
only because the ratchet is re-reading its own documented blind spot.

**The repair is one scan widening**, cheaper than touching 83 files one at a time. Add the
conditional-say shape as a third credited form beside the two `unsaid.awk` already reads -- the
anchored `say` line and the `${...}` interpolation -- the same way `%768` widened the sibling
`late_say` pass. That is one `awk` pattern, proven against the 83 real sites already found. It sits
in Grass's own lane: the scan serves every module rather than one, so a sweep of its own family
stays here.

## Bucket two -- a family with structurally nothing left to report

`let p10 = run ["sh" "-c" "test -f tools/g/glow_lower_face_lit_witness.rish"]` followed by an
`assert p10.ok else` clause naming the path is the dominant shape in `tools/g/glow_choir_witness.rish`
(32 of its 64 flagged bindings) and `tools/co/compass_rose.rish` (20 of its 24). POSIX `test` leaves
both stdout and stderr empty on either exit code, win or lose alike. Both streams carry only
emptiness to forward. The assert's own else-message already names the path in question, which is
the whole of what a reader wants -- the command that ran says everything it is built to say.

```
$ sh -c 'test -f /nonexistent/path'; echo "out=[$(sh -c "test -f /x" 2>&1)]"
out=[]
```

Counted mechanically -- a binding whose `run` line opens `["sh" "-c" "test -f ...` /
`-d ...` / `-e ...` / `-s ...` / `! -e ...`, or the two-argument form `["test" "-f" ...]`:

```
$ sh /tmp/check_test_presence.sh < /tmp/unsaid_rostered.txt | wc -l
130
```

**130 of the 988** (13.2%), spread across 23 files. This set shares zero members with bucket one's
83. Together they total **213 bindings, 21.6% of the whole population**, resolved by two
mechanical rules ahead of any hand touching a single file.

This is the bucket the crux names *"a family that should be exempted outright."* `unsaid_rostered`
is built to catch a target's reason reaching nowhere a reader can see. That shape needs a target
with a reason worth carrying in the first place. A presence probe carries one answer: a path either
exists or it does not, and the assert already says which. Counting one here was a category error
from the start. The repair runs the same way as bucket one's: widen `unsaid.awk` to hold a `test`
presence binding out of `asserted` entirely, matching the shapes the scan's own header already
names as living outside its reach by design.

## Bucket three -- real, and correctly left to the ratchet

The remaining **775 bindings** (988 minus 213) are the honest residue. These are deterministic-plant
assertions on commands that genuinely can print something useful -- `cp`, `mkdir -p`, `sed`, a
built binary's own exit, a `grep -c` count. The assert's else-message states what was expected and
stops there; what the command actually printed stays unforwarded. Reading
`tools/am/amphora_contained_name_witness.rish`'s own `honest_check`, `ok_copy`, `forge`,
`listing_plant`, and `cargo_door` bindings (17 of its 26, past the nine already counted in bucket
one) shows the pattern. A `cp` that stops on a full disk and a `cp` that stops on a permission wall
both land on the same line, `"contained: honest restore copy must land"` -- so the evidence page
treats two different causes alike.

This bucket is genuine process debt, by the scan's own definition. It correctly stays a RATCHET
rather than a gate: closing 775 bindings in one lap sits well past what this seat can reach, and the
roster's own comment already names why a gate at zero would red every lap for a long while. The
right unit of repair is the module's own ship touching its own witness -- the same way the eight
late-say bindings closed this morning, on touch, one guard at a time, each one carrying its
command's own line into the assert message that already judges it.

## What this changes about the row

`construction/REDS.md` (`20261001.143449`) names the fourth shape's size. This packet gives its
composition:

| Reading | Count | Disposition |
|---|---|---|
| Already reported, blind-spot miscount | 83 | scan widening -- Grass's own lane |
| Structurally nothing to report | 130 | scan widening -- Grass's own lane |
| Genuine, ratchet-correct debt | 775 | owning ships, on touch |
| **Total measured this lap** | **988** | |

The two scan widenings move `unsaid_rostered` from 988 to roughly 775 in one lap, with zero module
files touched. That is a repair to the ceiling's own honesty, squarely a living crux rather than any
module's own repair. Naming the 775 that remain gives the next hand, opening a module's own
witness, a map of which flagged bindings are real.

## What this packet leaves for the next hand

`tools/fixtures/s/shim_reason_scan.sh`, `tools/s/shim_reason_witness.rish`, and all 190 flagged
files stand exactly as they stood. The scan widening is proposed and evidenced, ahead of landing. It
wants its own pen-proven control, the way every prior widening of this instrument has carried one
(REDS `%768`, the `(out|err)(_brief)?` widening), and building that control is real work past a
reverse-read's own lap. Naming the widening here, with its 213 sites already found and its two
detection rules already proven against them, is what the crux asked a reverse-read to bring
forward.

## A radiant wish

May the next hand who widens this scan find the two patterns waiting here already counted, and may
the 775 that remain shrink one honest `say` at a time, each one closing a gap a reader would
otherwise have had to guess across.
