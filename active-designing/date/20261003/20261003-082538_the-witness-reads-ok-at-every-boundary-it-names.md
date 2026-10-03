# The witness reads ok at every boundary it names

**Style:** Gauge, Field setting -- **Status:** Living, checkable -- **Stamp:** `20261003.082538`
**Kin:** [The one live site cannot see its own drift](20261003-042550_the-one-live-site-cannot-see-its-own-drift.md) - [A fourth site that would never notice](20261003-040934_a-fourth-site-that-would-never-notice.md)

## The question

The prior essay found one gap in `tools/g/glow_compose_tend_unary_witness.rish`: its
`dependents_lawful` check (`c3`/`c4`) asserts `gate.ok` alone, leaving the printed digit unread,
so a wrong lawful/unlawful verdict at `max_dependents`'s own boundary would pass as readily as a
correct one. That finding named one gate and one sample pair. This essay widens the question: does
any assertion in this witness read the digit a "lawful" gate prints, for any of its boundary
pairs?

## What the witness actually asserts

`tools/g/glow_compose_tend_unary_witness.rish` carries ten assertions that run a `*-lawful-u32`
gate at a declared boundary and its first value past it:

```
let l1 = run [... "gate-sumto-lawful-u32.glow" "65535"]
assert l1.ok else "343: sumto_lawful at the bound failed"
let l2 = run [... "gate-sumto-lawful-u32.glow" "65536"]
assert l2.ok else "343: sumto_lawful beyond failed"
let l3 = run [... "gate-prodto-lawful-u32.glow" "12"]
assert l3.ok else "343: prodto_lawful at the bound failed"
let l4 = run [... "gate-prodto-lawful-u32.glow" "13"]
assert l4.ok else "343: prodto_lawful beyond failed"
let v1 = run [... "gate-gardens-lawful-u32.glow" "8"]
assert v1.ok else "344: gardens_lawful at the bound failed"
let v2 = run [... "gate-gardens-lawful-u32.glow" "9"]
assert v2.ok else "344: gardens_lawful beyond failed"
let c1 = run [... "gate-caps-lawful-u32.glow" "8"]
assert c1.ok else "345: caps at the bound failed"
let c2 = run [... "gate-caps-lawful-u32.glow" "9"]
assert c2.ok else "345: caps beyond failed"
let c3 = run [... "gate-dependents-lawful-u32.glow" "4"]
assert c3.ok else "345: dependents at the bound failed"
let c4 = run [... "gate-dependents-lawful-u32.glow" "5"]
assert c4.ok else "345: dependents beyond failed"
```

Every one of the ten stops at `.ok` and leaves `.out` unread. Each pair answers one question --
did the call survive -- and leaves the other, whether the call answered the right boundary, to the
reader's trust. The prior essay's finding about `c3`/`c4` turns out to be the shape of every
assertion labeled 343, 344, and 345 in this file, rather than a property special to
`dependents_lawful` alone.

## Why `.ok` cannot see a wrong digit

`glow_run.rish` sets `.ok` from the generated binary's own exit status, read through
`tools/g/glow_run_worker.sh`'s `"$BIN" "$@"; echo "EXIT:$?"`. Running the worker directly, rather
than through the two wrapping layers, shows both halves of what it prints:

```
$ env RYE_ZIG=vendor/zig-toolchain/zig sh tools/g/glow_run_worker.sh \
    glow/gen/g/gate-dependents-lawful-u32.glow 4
1
EXIT:0
$ env RYE_ZIG=vendor/zig-toolchain/zig sh tools/g/glow_run_worker.sh \
    glow/gen/g/gate-dependents-lawful-u32.glow 5
0
EXIT:0
```

The gate binary is a decision function: it prints `0` or `1` and exits `0` either way. `.ok` reads
the exit code alone, so it stands `true` whichever digit the boundary check actually printed.
Running the worker directly at every one of the witness's ten samples confirms the tree's current
digits all stand correct today -- `sumto_lawful` reads `1` then `0` across 65535/65536,
`prodto_lawful` the same across 12/13, `gardens_lawful` across 8/9, `caps_lawful` across 8/9,
`dependents_lawful` across 4/5. The gap sits entirely in what the witness checks: its ten
`.ok`-only assertions would read the same whether these answers held or one of them flipped.

## The falsifier, run and reverted

`glow/lower_shop_gate.rye`'s `call_body_expr` is what writes the comparison into the generated Rye
source for each `*_lawful` gate:

```
if (std.mem.eql(u8, gate, "sumto_lawful")) {
    return std.fmt.bufPrint(buf, "if ({s} <= {d}) 1 else 0", .{ zface, max_sumto_call }) catch ...
}
```

Changing this one line's `<=` to `<` moves `sumto_lawful`'s own boundary by one, so sample 65535
-- the exact value `l1` calls "at the bound" and expects to read `1` -- reads `0` instead:

```
$ env RYE_ZIG=vendor/zig-toolchain/zig sh tools/g/glow_run_worker.sh \
    glow/gen/g/gate-sumto-lawful-u32.glow 65535
0
EXIT:0
```

Running the full witness against this planted mutation:

```
$ rishi/bin/rishi run tools/g/glow_compose_tend_unary_witness.rish
339: fixture -- sumto lowers, builds, answers its baked welcome...
339: argv welcome -- sample 4 through the worker...
339: fold-law beyond the bound -- 65536 folds to 0, both sides agree...
342: prodto fixture -- the product fold answers its baked welcome...
342: prodto argv -- 4 through the worker; 13 folds to 0 by its own law...
343: the gatekeepers -- each fold's own bound answers 1 or 0 at the exact edge...
344: the vane wall answers through the import door -- both edges...
345: Caravan kin -- caps at 8 and 9, dependents at 4 and 5...
339: stranger stays refused -- negative space...
GREEN: the Tend unary family -- folds, gatekeepers, and the vanes' own walls all answer
as calls, one source each; strangers still refuse.
```

GREEN, unchanged, with `sumto_lawful`'s own boundary shifted by one and undetected. The edit was reverted
immediately; `tools/g/glow_compose_tend_unary_witness.rish` re-ran GREEN against the reverted
source, and `git status --porcelain` read clean both before the plant and after the revert.

## What this widens and what it does not

The prior essay named one such pair -- `c3`/`c4`, `dependents_lawful` at 4/5 -- inside a witness
its own reading had stopped short of opening further. This essay reads the whole file and finds
the same shape across all five `*_lawful` gates the witness exercises -- ten assertions in total,
against the two the prior essay's own scope could see -- so the repair this arc has been pricing
(adding real `.out` checks) runs five times larger. The fix stays mechanical and small: each pair
wants `assert lN.out contains "1"` / `assert lN.out contains "0"` (or the chained sibling's own
digit) beside the existing `.ok` check, reading the value every one of these ten calls already
prints to its own stdout. The repair stays entirely inside `glow_compose_tend_unary_witness.rish`
itself, which alone would carry the ten added lines, leaving every other module and witness
untouched; that edit belongs with whichever lap next opens this file, per the standing instruction
that keeps `caravan/cycle.rye` and this family's own modules reserved for the captain's word on the
ceiling-raise question the kin arc is still tracking.

What this leaves open is whether any other witness in this tree shares the same `.ok`-only shape
at a boundary assertion. `glow_compose_tend_unary_witness.rish` is one file among roughly twenty
Glow Tend limb witnesses (`tools/ca/`, `tools/au/`, `tools/m/`, `tools/t/`); this essay reads one of
them in full and generalizes within it, rather than surveying the family. That survey stands as the
next falsifier, named rather than attempted here.

## Grade

```
sh tools/fixtures/q/qa_report_card.sh active-designing/date/20261003/20261003-082538_the-witness-reads-ok-at-every-boundary-it-names.md --setting field --service 85
```
