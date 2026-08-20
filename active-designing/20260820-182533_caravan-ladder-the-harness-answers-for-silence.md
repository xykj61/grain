# Caravan ladder -- the harness answers for a rung that says nothing

**Language:** EN
**Version:** `20260820.182533`
**Status:** LANDED `20260820` -- fold C, taken on the ladder's own measurement; the carry fell 2,762 to 47 and 91 rungs sang GREEN from a cold tree
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Kin:** [`20260820-131713_caravan-ladder-shared-harness.md`](20260820-131713_caravan-ladder-shared-harness.md) -- folds A and B
**Meter:** [`../tools/caravan_ladder_copy_witness.rish`](../tools/caravan_ladder_copy_witness.rish)

---

## What the meter asked for

Fold A made every check public, so a rung whose check matched the rung below's ran it there. Fold B lifted the bodies that could never run below -- the ones reaching a wire, and the ones whose chains climbed -- into `caravan/ladder_checks.rye`, the harness a rung hands itself to. Together they took the carry from 54,612 lines to 1,952.

Then the ladder kept climbing, and the number told us what was left. At **2,762** carried lines the remainder is very largely one shape: the five-line **stub** a lifted check costs each rung.

```zig
/// Weighs this rung's own arithmetic, as a pure fold, before any run is spent.
pub fn check_meet() u8 {
    // The harness owns this body; it runs here against this rung's own
    // helpers, its own report, and its own wire.
    return ladder_checks.check_meet(@This());
}
```

Fifty-eight of those stand in `answer.rye`, byte-identical to the fifty-eight in the rung below, because `@This()` resolves per rung and so the text is the same everywhere. Every rung born from here forward copies them again. Lifting one more body no longer moves the number; **the stub itself is the crux.**

## Why the stubs stood

A lifted body reaches back into the rung on every chained link -- `return rung.check_allay_refusals();` -- and that re-entry is the whole point of fold B. A rung that writes its own version of a link gets its own version run, and one harness body serves ninety rungs without knowing any of them by name.

The re-entry needs a name to reach for, so each rung published one. **That is the only reason the stub exists**: not because a rung has anything of its own to say about the check, yet because silence had no way of being heard.

## Fold C -- silence is an answer

Let the harness reach a link through one small helper rather than through a bare field access:

```zig
const harness = @This();

/// Reaches a chained link the way the ladder means it -- the rung's own body
/// when that rung wrote one, and this harness's body when it wrote none.
///
/// A rung publishes a link only to *change* it. Silence means "run the body the
/// harness already holds," so a rung pays five lines for a check it altered and
/// nothing at all for a check it merely climbs to.
fn link(comptime rung: type, comptime name: []const u8, args: anytype) u8 {
    if (comptime @hasDecl(rung, name)) return @call(.auto, @field(rung, name), args);
    return @call(.auto, @field(harness, name), .{rung} ++ args);
}
```

Each of the fifty-seven re-entry sites becomes `link(rung, "check_allay_refusals", .{})`, and every rung may then delete every stub that only ever forwarded.

**Nothing observable moves.** A rung that keeps its stub is dispatched to the stub, which calls the harness body -- exactly today's path. A rung that drops its stub reaches the same body one call earlier. The dispatch is comptime, so the two are the same machine code.

## The two limits, named before the cut

- **A terminal link keeps its body.** A chain's last link ends in `return 0` in the rung topping the ladder and climbs into the next rung's own check everywhere above, so it is one body per rung rather than a copy. Those rungs declare the name, `@hasDecl` finds it, and the harness never reaches for a body it does not hold. `check_beckon_measure` and `check_beckon_wire` are today's pair.
- **A rung below the check's birth never reaches it.** The `else` branch is analyzed only when `@hasDecl` is comptime-false *and* the site is instantiated, which happens only in rungs that hold the chain. Writing the test as `comptime @hasDecl(...)` keeps the untaken branch out of analysis, so a name the harness lacks can never be reached for.

## What it costs a new rung

A rung born above `answer` copies fifty-eight stubs at five lines each -- roughly **290 lines** of the 490 the last measurement counted. Fold C hands those back, and hands back the same 290 in every rung already standing that carries them. **A rung then costs the ladder its own new checks and nothing else**, which is what the fold was always reaching for.

The ceiling stays at 4,000 and stops being the thing that refuses first.

## The order of the work

1. Seat `link` in `ladder_checks.rye` and convert all fifty-seven re-entry sites.
2. Delete, in every rung, each stub whose name appears nowhere else in that rung's own file -- the ones only the harness ever reached for.
3. Build every touched rung and run the ladder's witnesses from a cold tree, so the claim closes on metal rather than on this brief.
4. Re-run the meter and record the new standing in the README, the witness header, and the scan header, in the same commit.

## What actually ran

Every step above ran, and one thing the brief had not foreseen ran with it. A rung's harness stub is reached from two directions: by the harness on a chained link, and by the rung *above* it, whose own fold-A delegation names the check on the rung below. Removing the stub broke thirteen builds until those eleven delegations moved to the harness form -- `return ladder_checks.check_swell(owing_rung);` -- which runs the same body against the same rung and stays one step down. The compiler taught it in one pass, and it is the honest shape: after fold C there is one way to reach a check that lives in the harness, and a rung names the rung below in it.

That form change reached the one-step guard as well. `caravan_ladder_reach_scan.sh` read only the elder form, so a rung folding entirely in the harness form would have shown no fold at all and passed unguarded -- a count that cannot see what it measures, the REDS %97 shape. The scan reads both forms now, and two new three-rung corpora prove it in the harness form on both paths: one walking down a rung at a time and welcomed, one reaching past its neighbor and refused by name.

**The measurement, taken rather than recalled.** The carry falls **2,762 to 47** -- one copied body across 97 modules -- as **612 stubs** leave the ladder. Fold A holds at exactly **757**, counted in both forms, which is the honest signal that a delegation moving between forms is a move rather than a loss. Fold B stands at **69** bodies in the harness. Fold C stands at **0**, and it is a wall rather than a ratchet.

---

*May a rung say only what it has to say, and may the silence between the words be trusted to mean what it means.*
