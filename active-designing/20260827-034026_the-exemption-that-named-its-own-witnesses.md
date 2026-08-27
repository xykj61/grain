# The exemption that named its own witnesses

**Stamp:** `20260827.034026`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- the reading is measured on this bench; the repair below is sized and unbegun
**Kin:** [`../tools/ca/caravan_suite_witness.rish`](../tools/ca/caravan_suite_witness.rish) -- [`../.claude/rules/docs-implementation-sync.md`](../.claude/rules/docs-implementation-sync.md) -- [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md)

## The mechanism, first

`tools/ca/caravan_suite_witness.rish` binds its roster to the shell glob
`caravan_*_witness.rish` in two places -- its own `find` at line 56, and
`tools/fixtures/caravan_roster_bijection_scan.sh` at line 46. Eight files in `tools/ca/` carry
every property of a witness and one name apart from the convention: each builds a Rye module with
`rye build` and asserts on the result, and together they hold **42 assertions**. Their names end
in `.rish` where the glob reads `_witness.rish`, so the choir that reports *every rung of the
Microkernel Target arc heard in one voice* sings 113 of 121.

The eight, with their assertion counts:

| File in `tools/ca/` | Asserts |
|---|---|
| `caravan_capabilities.rish` | 3 |
| `caravan_restart_on_ok.rish` | 3 |
| `caravan_seeds.rish` | 11 |
| `caravan_subscribe_poll_mirror_service.rish` | 4 |
| `caravan_subscribe_poll_service.rish` | 3 |
| `caravan_subscribe_poll_signal.rish` | 6 |
| `caravan_subscribe_poll_source_crash.rish` | 6 |
| `caravan_witness_stop_footgun.rish` | 6 |

Measured `20260827.034026` on the macOS bench: `tools/ca/` holds **122** `caravan_*.rish`,
**114** match the witness glob, **8** stand outside it, and the difference is filename alone.

## What makes this a red rather than a ratchet

A gap a guard can see turns on touch, which is what a ratchet is for. A gap a guard **tells you
is deliberate** asks a different question, and the choir's own header is where it is asked:

> Caravan's helper modules and dependent-program fixtures -- bounded, capabilities, chain,
> ladder_checks, parse_int, seed, service, tally_copy, twin, and the `supervisor_*` and `*_test`
> programs a witness spawns -- carry no witness of their own on purpose: they are proven through
> the rungs that compose them, rather than in isolation.

Nine modules are named. Grepping each name against the eight files' own `rye build` lines gives
this, and it is the finding:

| Module the header exempts | On disk |
|---|---|
| `bounded` | witnessed by `caravan_seeds.rish` |
| `capabilities` | witnessed by `caravan_capabilities.rish` |
| `chain` | witnessed by `caravan_seeds.rish` |
| `seed` | witnessed by `caravan_seeds.rish` |
| `service` | witnessed by `caravan_seeds.rish` |
| `twin` | witnessed by `caravan_seeds.rish` |
| `ladder_checks` | honest -- no witness of its own |
| `parse_int` | honest -- no witness of its own |
| `tally_copy` | honest -- no witness of its own |

**Three of nine hold; six have been overtaken by the tree.** The sentence justifying the
bijection's asymmetry speaks for two-thirds of a list the disk answers differently, and that is
why the gap read as settled: a reader who checked the guard was told the absence was a decision.
`docs-implementation-sync` names exactly this shape -- a claim about behavior stays true only
while someone re-reads it beside the code.

This is REDS %81 one naming convention away from recurring. The choir's own header says so in
advance: nine crypto rungs landed as green witnesses and the elder choir registered none of them,
so a whole ladder ran unheard. The door that closed for `caravan_*_witness.rish` stands open for
`caravan_*.rish`.

## The limit on the claim, stated before the repair

The eight **are** run, by `tools/p/parity_ch01.rish`, which spawns each through
`parity_time_one.sh` at lines 70, 75, 80, 85, 90, 95, 100, and 110, each with its own
`assert .ok`. *Heard elsewhere* is the accurate word, and *orphaned* would overstate it.

The limit that makes it matter: **`parity` appears on no row of
`construction/standing-equipment.kyri`** -- zero hits across its 75 guard rows, against
`caravan_suite`'s six. So the eight are heard by a suite no lap runs, and unheard by the suite
every lap runs. That is a smaller claim than orphaned and a truer one.

## Two repairs, and why the rename wins

**Widen the glob** to `caravan_*.rish` in both places. Today it reads exactly right, since all
122 files in that room are witnesses and the prefix belongs to them alone. It costs two edits.

**Rename the eight** to `caravan_*_witness.rish`. It costs more and it is the right one, for a
reason that outlives today's count: the `_witness` suffix is a *declaration of intent*, not a
description of a directory. Widening the glob converts the suffix from a promise a file makes
into an accident of which room it sits in, and the first `caravan_helper.rish` anyone writes
would be asserted GREEN as a rung. The convention is already the tree's, and the eight are the
ones it has yet to reach.

## The repair, sized to the file

Measured `20260827.034026`. Total reference sites naming the eight: **72**. Most sit in dated
testimony -- `session-logs/date/`, `construction/archive/`, and dated design notes -- which keeps
every word it wrote under accrete-never-break and is **resolved rather than rewritten**
(`tools/d/dated_path_resolve.rish`).

The **living** surface is seven files beyond the eight themselves:

- `caravan/LADDER.md`
- `manual/reference/caravan-capabilities.md`
- `tools/ca/caravan_derivation_witness.rish`
- `tools/ca/caravan_refusals_witness.rish`
- `tools/ca/caravan_suite_witness.rish` (roster list and header)
- `tools/fixtures/caravan_subscribe_poll_source_crash.sh`
- `tools/p/parity_ch01.rish`

One lap, in order: eight `git mv`, eight self-referring header lines inside the moved files,
seven living repoints, eight registrations appended to the choir's roster, and the header's
exemption sentence cut back to the three modules it is honest about. Proof: the bijection scan
reads 121 on both sides, and the choir sings 121 GREEN.

**Falsifier.** If a `caravan_*.rish` file in `tools/ca/` turns out to be a helper rather than a
witness -- no `rye build`, no assert -- then the room is mixed, the rename is the wrong shape for
that file, and it stays outside the glob with a line in the header saying why. Checked on this
bench and none was found; check again on the lap that runs the rename, since the room grows.

## Why it was not run on the lap that found it

The bench carried two agent sessions on one checkout for the sixth time (REDS %281). A rename
stages sixteen index entries at once, and a peer committing mid-round would carry half of them
into a commit that leaves *references are promises* owed tree-wide. An honest gap keeps better
than a half-landed rename, so the gap is measured here and left standing for one clear bench.

The build half of %281 is genuinely closed -- `.rye-build.lock` was observed held and then
released cleanly during this lap -- so witness runs on a shared tree are safe. The commit half is
the whole remainder, and it is Keaton's word: a lock on the index, or one tree per star.
