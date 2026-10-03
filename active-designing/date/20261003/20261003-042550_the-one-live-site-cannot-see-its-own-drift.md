# The one live site cannot see its own drift

**Style:** Gauge, Field setting -- **Status:** Living, checkable -- **Stamp:** `20261003.042550`
**Kin:** [A fourth site that would never notice](20261003-040934_a-fourth-site-that-would-never-notice.md) - [A third ceiling the prior count never opened](20261003-035816_a-third-ceiling-the-prior-count-never-opened.md) - [Raising the ceiling crashes its own control](20261003-033159_raising-the-ceiling-crashes-its-own-control.md)

## The question

The prior essay's own falsifier for a later lap: does `glow/.cache/caravan` -- the directory
symlink `tools/g/glow_run_worker.sh` lays down before every build (`ln -sfn ../../caravan
glow/.cache/caravan`) -- feed any gate a **live** read of `caravan/capabilities.rye`'s constants,
rather than a bare literal copied in by hand? Four sites are catalogued so far, and all four read
`max_dependents` as a number typed into a `.glow` or `.rish` file. This essay reads the symlink's
actual consumer rather than its declared purpose.

## What the symlink is for

`glow/lower_shop_gate.rye` is the module that turns a Glow `|=` gate into runnable Rye. Two of its
functions name `caravan` directly:

```
fn vane_decide_import(gate: []const u8) ?[]const u8 {
    if (std.mem.eql(u8, gate, "gardens_lawful")) return "const gardens = @import(\"tally/gardens.rye\");\n\n";
    if (std.mem.eql(u8, gate, "caps_lawful") or std.mem.eql(u8, gate, "dependents_lawful")) return "const caravan = @import(\"caravan/capabilities.rye\");\n\n";
    return null;
}
```

and, in `call_body_expr`:

```
if (std.mem.eql(u8, gate, "caps_lawful")) {
    return std.fmt.bufPrint(buf, "if ({s} <= caravan.max_caps_per_dependent) 1 else 0", .{zface}) ...
}
if (std.mem.eql(u8, gate, "dependents_lawful")) {
    return std.fmt.bufPrint(buf, "if ({s} <= caravan.max_dependents) 1 else 0", .{zface}) ...
}
```

A gate named `dependents_lawful` or `caps_lawful` lowers to Rye source that imports
`caravan/capabilities.rye` by its real module path and reads `caravan.max_dependents` or
`caravan.max_caps_per_dependent` directly -- the symlink exists so that import, followed from
inside `glow/.cache/`, lands on the real file. Two tracked `.glow` files call these gate names:
`glow/gen/g/gate-dependents-lawful-u32.glow` and `glow/gen/g/gate-caps-lawful-u32.glow`, each one
line: `%-  dependents_lawful  sample` (or `caps_lawful`). Neither carries a literal anywhere.

## The falsifier, run on metal

`git status --porcelain` read clean before this essay began. `caravan/capabilities.rye:20` was
edited from `max_dependents: u32 = 4` to `max_dependents: u32 = 8`, and the gate was run directly
through the worker at the old wall's excluded value:

```
$ RYE_ZIG=... sh tools/g/glow_run_worker.sh glow/gen/g/gate-dependents-lawful-u32.glow 5
# before the edit:
0
EXIT:0
# after the edit:
1
EXIT:0
```

The answer flips. This is the first of the five sites now catalogued across this chain that
genuinely reads the Rye constant rather than a copy of it -- confirmed by changing the constant and
watching the gate's own decision change with it, not merely by reading the import line.

The edit was reverted immediately; the gate was run once more and read `0` again at sample `5`;
`git status --porcelain` read clean after.

## What the standing witness does with that liveness

This gate has a witness: `tools/g/glow_run_worker.sh`-driven calls inside
`tools/g/glow_compose_tend_unary_witness.rish`, STOA345's own leg:

```
let c3 = run [... "glow/gen/g/gate-dependents-lawful-u32.glow" "4"]
assert c3.ok else "345: dependents at the bound failed"
let c4 = run [... "glow/gen/g/gate-dependents-lawful-u32.glow" "5"]
assert c4.ok else "345: dependents beyond failed"
```

Both assertions read `.ok` -- whether the `rishi run` call itself succeeded -- and neither reads
`.out` for the printed `1` or `0`. `.ok` is the harness's verdict on the subprocess call, which the
worker always closes with `EXIT:0` regardless of which branch the lowered gate took (confirmed
above: both the `0` and `1` runs printed `EXIT:0`). So the witness cannot distinguish "sample 5
reads 0" from "sample 5 reads 1" -- it can only tell whether the call crashed.

The same edit used above was re-run with the whole witness in place, rather than the gate alone:
with `max_dependents` at 8, `RYE_ZIG=... rishi/bin/rishi run
tools/g/glow_compose_tend_unary_witness.rish` closed `GREEN`, unchanged, printing the same line it
prints today -- `"345: Caravan kin -- caps at 8 and 9, dependents at 4 and 5..."` -- while the gate
underneath that line had, in fact, just answered `1` at sample `5` instead of `0`. The edit was
reverted immediately; the witness was re-run and closed `GREEN` again; `git status --porcelain`
read clean before and after both runs.

## The shape, against the other four

| Site | Reads the Rye constant | Witness catches a raise |
|---|---|---|
| `wide_roster.kyri` + `roster.rye:393` | no (a fixed fixture) | yes -- panics |
| `caravan_glow_tend_limb1_witness.rish` | no (greps a literal string) | yes -- stops before lowering |
| `gate-caravan-dependents-bound-u32.glow` + its a1 witness | no (hardcoded `3`) | no -- stays GREEN, stale |
| `gate-caravan-exit-meanings-eq-u32.glow` and siblings | no (hardcoded) | not checked this chain |
| `gate-dependents-lawful-u32.glow` + the STOA345 leg | **yes** -- live `@import` | **no** -- stays GREEN, silently correct about the wrong thing checked |

The fourth row, from the prior essay, is a gate that never looks at the Rye source and so cannot
notice when it changes. This row is the opposite failure wearing the same outward GREEN: a gate
that *does* look at the Rye source, built for exactly the purpose of staying correct when
`capabilities.rye` changes, paired with a witness that cannot tell a correct answer from an
incorrect one, because it asks only whether the call ran. The mechanism built to solve staleness is
real and works -- the gate's own decision moved with the constant, on metal, in this essay -- and
the one thing standing between that mechanism and a caught drift is a single `.out contains "1"` or
`.out contains "0"` clause the witness never wrote. The `a1` sibling witness for the hardcoded gate
(`caravan_dependents_a1_gate_bound_witness.rish`) already carries exactly that clause --
`assert ok.out contains "1"` -- one file over, for a gate that has no constant to track at all.

## What this adds to the catalog

Five sites now read in this chain carry three distinct relationships to one constant: two crash
loudly on a raise (a fixture and a name-grep), two stay stale and silent because they never read
the constant at all, and this fifth reads the constant correctly and would still stay silent on a
*wrong* answer, because its witness checks the mechanism's pulse rather than its verdict. A future
lap repairing the two crash sites and widening the two stale literals would still leave this one
exactly as exposed as it is today -- not because the import is broken, but because the assertion
beside it never looked.

## Falsifier for a later lap

Whether `caps_lawful`'s own STOA345 pair (`c1`/`c2`, samples `8` and `9`) shares this same gap --
read above to share the identical `.ok`-only assertion shape, not run separately on metal here,
since the mechanism (`vane_decide_import` naming both gates in one branch) and the witness source
(one function, four assertions, one pattern) are already shown identical in the code quoted above.

## Grade

Composite 80, letter B, per `tools/fixtures/q/qa_report_card.sh --setting field --service 85`
(truth 100 counted, service 85 judged). No new witness, no new module; one tracked-file edit made
and reverted on this host, `git status --porcelain` confirmed clean before and after, run twice --
once against the bare gate, once against the full standing witness.
