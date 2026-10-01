# The unsaid-rostered population, read backward from its newest 81

**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Stamp:** `20261001.145851` (EDT)
**Status:** Living reverse-reading packet -- every count below is read off `shim_reason_scan.sh`
and the tracked tree on this checkout; the three-way split is a judgment grounded in those counts.
**Room:** checkable -- the population and its split are counted; which files to repair is handed
onward rather than decided here.

## The older premise

`construction/REDS.md`'s row `(20261001.143449)` names `unsaid_rostered=984` against a ceiling of
903. That is 81 over. The row names this "a different, much larger body of work," set aside for a
later lap. `recursion-prompts/grass-inner.md`'s new crux asks this seat to walk the population
backward, newest to oldest, and sort the over-ceiling bindings three ways: genuine process debt,
accrete shims correctly inheriting a target's own reason, and a family that should be exempted
outright.

## What "unsaid" actually names

A binding counts as `unsaid_rostered` when a rostered `.rish` guard runs a command and asserts on
its `.ok`. The command's own words stay uncaptured everywhere else -- no say line below the assert,
no interpolated `${var.out}` or `${var.err}`. A reader meeting the refusal sees only the assert's
fixed message and a line number. Whatever the process printed stays captured and unread.

## Walking backward: what actually grew

`construction/standing-equipment.kyri` carried 395 rostered paths on `974de702c`, the commit that
set the ceiling to 903 on `20260916`. It carries 488 today -- 94 newly rostered files. **22 of
those 94 carry unsaid bindings today, totaling 75 of the 81 bindings over ceiling.** The growth
concentrates in new witnesses that arrive with the shape already built in. It does not spread as
decay through old files.

```
comm -13 <(git show 974de702c:construction/standing-equipment.kyri | awk '/^path / {print $2}' | sort -u) \
         <(awk '/^path / {print $2}' construction/standing-equipment.kyri | sort -u)
```

The single largest contributor is `tools/gen/chapter/brush_parse_witness.rish` alone, at 22
bindings -- more than a quarter of the whole over-ceiling population by itself.

## Reading one file closely, then checking the ratio tree-wide

`brush_parse_witness.rish`'s 22 unsaid bindings split cleanly on direct inspection of each line:

| Shape | Bindings | Example |
|---|---|---|
| `grep -q '...' file && echo MARK` pattern probes | 8 (`helpers`, `lower_helpers`, `redraw_helpers`, `grid_helpers`, `begun`, `triad`, `ban`, `widths`) | `assert triad.ok else "brush-parse: opening triad scan failed"` |
| `test -f <counsel-seat-path>` presence probes | 6 (`seat`, `seat24`-`seat28`) | `assert seat.ok else "brush-parse: p23 counsel seat missing"` |
| Named counting helper script | 1 (`inv`, `brush_parse_tame_density.sh`) | `assert inv.ok else "brush-parse: need >=20 invariant markers"` |
| Real build/binary invocation | 7 (`mkdir`, `build`, `self`, `path`, `lower_run`, `redraw_run`, `grid_run`) | `assert build.ok else "brush-parse: rye build failed"` |

Fifteen of twenty-two (68%) are `grep -q` or `test -f` probes. Each one's failure message already
names the exact marker or file that is missing. A `grep -q` match failure produces zero bytes of
stderr. A `test -f` failure produces zero bytes too. Interpolating `${var.err}` on these would print
nothing -- the assert's own fixed message already carries the complete reason, stated once in the
probe and once in the message.

The other seven are real process calls: a directory creation, a compiler invocation, a built binary
run four different ways. Each one drops a real diagnostic on refusal -- the compiler's own error
text, or whatever the binary printed before failing to match an expected string.

**Checking the ratio against the full 984**, by classifying every bound line mechanically (`grep -q`,
`test -f/-d/-e`, `[ -f ... ]` as one bucket; `rye build`/`rye_build.sh` and `rishi/bin/rishi run`
sub-witness calls as a second; everything else as a third):

```
probe=213  build=93  subwitness=77  other=601  total=984
```

213 of 984 (22%) match the same pattern-probe shape by mechanical reading alone. That is a lower
bound: the mechanical pass misses compound `grep -q a && grep -q b && echo OK` lines that a close
read, as above, catches by hand. The worked file's own ratio, 68% probe-shaped, sits well above the
mechanical floor. The gap points to the mechanical count undercounting, rather than the worked file
being unusually clean.

## The three-way disposition

**Genuine process debt.** The `build`, `subwitness`, and most of `other` entries are real compiler
invocations, built-binary runs, and rostered-witness-calling-rostered-witness chains. Each one
silently drops a real diagnostic on refusal. This is REDS `%700`'s founding shape, recurring at
scale: a guard that named which leg broke and said nothing about why. Repair is cheap and local on
touch: `assert build.ok else "brush-parse: rye build failed -- ${build.err}"`. This bucket is large,
roughly 700 of 984 by the mechanical count, and belongs to each file's owning ship, one witness at a
time -- exactly as the row's own text already says.

**Accrete shims correctly inheriting a target's own reason -- this bucket reads zero, for a reason
worth stating.** This seat's working vocabulary for a shim is a file that IS one: a thin `run` +
`say r.out` + `exit r.code` wrapper, forwarding one target's whole verdict (`tools/am/amphora_lap1.rish`
and its 51 kin). Checked by set intersection, zero of the 52 files the scan already names as shims
appear anywhere in the 188 files carrying `unsaid_rostered` bindings:

```
comm -12 <(shim and swallow files, 52) <(unsaid_rostered files, 188)   # empty
```

The two shapes are structurally disjoint. A shim forwards or it swallows -- `forwards_reason=9`,
`swallow_rostered=0`, every rostered shim already forwards -- and that is a different metric,
already green. A witness carrying an inline `unsaid` binding stands in a different file shape than
these thin wrappers, every time. So this bucket's share of the 81 over ceiling reads as zero. A
future reading of this population can expect to meet a witness's own inline bindings throughout,
rather than a shim's thin wrapper.

**A family that should be exempted outright.** The `grep -q`/`test -f` pattern-and-presence probes
make up roughly a fifth of the full population by mechanical count, and over two-thirds of the
newest contributor's own bindings by close reading. A failing `grep -q` or `test -f` writes zero
bytes to stderr. The assert message already states the complete reason in plain words. Widening
`shim_reason_scan.sh`'s `unsaid` reading to recognize this shape -- a `run` whose program is `test`,
or whose `sh -c` body is one or more `grep -q`/`[ -f ]` clauses joined by `&&` -- would retire a real
fraction of the ratchet by naming it correctly, rather than by writing new `say` lines. That is a
genuine simplification, named here rather than built: changing the scan's own reading belongs to
whoever owns `tools/fixtures/s/shim_reason_scan.sh` next.

## Disposition

**Named, rather than built.** The 81-over population differentiates cleanly. Three-quarters of its
newest growth sits in one generated-witness family. A clear majority of that family's own bindings
are presence probes that already state their reason in full. The shim-shaped share reads zero. The
remainder is ordinary, scattered process debt, fixable one `say` at a time on touch. This reading
touches zero files. The repair for the genuine-debt bucket belongs to each file's owning ship; the
scan-widening option for the exempt bucket is a decision for `shim_reason_scan.sh`'s own owner to
weigh.
