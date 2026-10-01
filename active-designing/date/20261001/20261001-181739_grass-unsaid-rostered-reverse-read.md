# unsaid_rostered, read backward: two exempt families and one real one

**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Stamp:** `20261001.181739` (EDT)
**Status:** Living reverse-reading packet -- every count below is read off a witness or a derived
script run on this checkout; the exemption claims are a judgment, named so a future lap can check
them rather than re-derive them from nothing.
**Room:** checkable -- every number cites its own command.

## The older premise

`construction/REDS.md` row `20261001.143449` (cited by stamp; not yet numbered on the anointed
spine) names `unsaid_rostered=984` against `unsaid_rostered_ceiling=903` -- 81 rostered bindings
that are asserted on and report only silence, across `tools/s/shim_reason_scan.sh`'s fourth shape.
The row calls it "a different, much larger body of work... named here rather than attempted in the
same lap," and leaves it **OPEN**. The crux handed to this lap was to walk that population backward
and sort it three ways: genuine process debt, an accrete shim that already carries its target's
reason, or a family that earns an outright exemption.

Read fresh on this checkout, the number has already moved up: `unsaid_rostered=988`, four more than
the row's own reading four hours earlier -- ordinary growth on a ratchet, exactly the shape this
scan's own header has already described eleven times.

```
sh tools/fixtures/s/shim_reason_scan.sh | grep unsaid_rostered
```

## The walk

The scan's own header already names its blind spot in words: *"a `say` inside a conditional, an
interpolation into a `run` argument -- reads as unsaid here."* That sentence names a shape the same
file already found and fixed, in the `amphora_carry_*` `if v.ok == false then say v.err` idiom. The
sentence stayed a comment, rather than a check against the 988 the scan still calls unsaid. Walking
the list backward from the biggest single files finds that exact shape standing unread across more
than a quarter of the population, plus a second shape the header leaves unnamed.

### Family one: already reported, through the door the scan's own comment names

```
if build_amphora.ok == false then say build_amphora.err
assert build_amphora.ok else "contained: amphora build failed -- read the line above"
```

This is the idiom `tools/am/amphora_contained_name_witness.rish` and its siblings write for every
build step: report the target's stderr, THEN judge it. It is the exact shape the scan's fourth-shape
header calls out as unreached -- a `say` that exists, guarded by an `if`, rather than standing bare
at column zero where the `unsaid.awk` pass can see it. Reading every rostered "unsaid" binding
against its own file for a conditional `say <binding>.(out|err)` (guarded, or indented inside the
`if`) finds **86** of the 988 already doing exactly what the law asks, misread as silent because the
report is one `if` deeper than the scanner looks.

### Family two: a presence check has nothing to report

```
let p1 = run ["sh" "-c" "test -f active-designing/docs/glow/glow_book_anchor_witness.rish"]
assert p1.ok else "glow-choir: member missing on disk -- active-designing/docs/glow/glow_book_anchor_witness.rish"
```

`test -f`, `test -d`, `test -x`, and their `[ ... ]` spellings stay silent on either branch, win or
lose. The assert's own else clause already names what is missing, in every instance checked
(`tools/g/glow_choir_witness.rish`'s 32 presence checks, `tools/co/compass_rose.rish`'s 20, and ten
more spread across `tools/t/`, `tools/e/`, `tools/g/`, `tools/m/`). A `say` of `.out`/`.err` here
would print two blank lines. "Say the target's reason" presumes the target has one, and a presence
test's whole reason already lives in its own else string. **70** of the 988 carry this shape.

The two families stay distinct -- a binding is either a presence check or a judged command output,
one or the other -- so together they account for **156** of the 988, leaving **832** standing.

```
sh tools/fixtures/s/shim_reason_scan.sh list | grep '^unsaid rostered' > /tmp/unsaid_rostered.txt
wc -l /tmp/unsaid_rostered.txt
```
(walked with a short Python pass over that list and each named file's own text; the sentences above
state the two patterns and the counting method plainly enough for a future lap to re-derive them.)

### What is left: real, and smaller than the row's own number

`832` sits under the `903` ceiling the row and the scan both carry. The remaining population still
mixes shapes. `tools/g/glow_choir_witness.rish`'s 32 `rN` bindings run a named sub-witness and report only
`"glow-choir: <name> RED"` on refusal. The sub-witness's own stderr stays behind -- exactly the
shape this law was written to catch. A reader learns WHICH witness in the choir failed, and stays
guessing about why, the same loss `REDS %700` booked one room away, over a fortnight of flaky
readings. Fixing that one file alone would move the genuine count by 32: each `assert rN.ok else
"..."` takes `${rN.err}` spliced in, the same single-line repair this scan's own header already
proved pays for itself on the green path.

## Disposition

**Stays OPEN -- the row keeps its verdict, and its number gets a correction.** The 81-over reading
the row carries is true to the scan's current math and overstates the law's own stated terms: 156 of
the 988 it counts are bindings the law already treats as satisfied (a conditional report) or exempts
by nature (a presence check with a reason that lives in its own else string). Widening
`tools/fixtures/s/shim_reason_scan.sh`'s `unsaid.awk` pass to credit a guarded
`if <v>.ok == false then say <v>.(out|err)` the way it already credits a bare one, and to pass over a
binding whose own `run` argv is a `test -f`/`test -d`/`test -x`/`[ -f ]`/`[ -d ]` check, would bring
the reading to roughly 832 against the 903 ceiling -- a pass rather than a breach -- by teaching the
scan to see what the tree already does, with the bar held exactly where it stands. That repair is
real work inside one shared, fleet-wide instrument: two `awk`/grep patterns, a pen leg proving each
direction, and the ceiling re-measured to meet the corrected reading. It belongs to whichever ship
next opens `tools/s/shim_reason_scan.sh` for this row, per this lap's own charge to hand a module's
own repair to its owning ship.

What this lap carries forward instead: the corrected shape of the population, named plainly enough
that the next hand opening `%829` does not have to re-walk 988 lines to find it -- two exempt
families (conditional-say, presence-check) accounting for 156, and one genuine, already-located
example (`glow_choir_witness.rish`'s 32 `rN` bindings) worth the first real repair when the row is
taken up.
