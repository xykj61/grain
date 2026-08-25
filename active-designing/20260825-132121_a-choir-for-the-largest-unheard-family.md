# A Choir for the Largest Unheard Family

**Stamp:** `20260825.132121`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- both halves GREEN on metal, both roster rows seated
**Kin:** [`20260824-080208_the-roster-that-decides-what-gets-measured.md`](20260824-080208_the-roster-that-decides-what-gets-measured.md) - [`20260825-110922_a-tier-is-a-cadence.md`](20260825-110922_a-tier-is-a-cadence.md) - [`../construction/standing-equipment.kyri`](../construction/standing-equipment.kyri)

---

## What was measured, and when

On `20260825.092953` a new meter traced which witnesses on disk a runner actually runs. It read
**1,690** tracked `*_witness.rish` files and **1,178** standing outside every runner in the tree.
Seating the Caravan choir on that same lap carried the every-lap set from **56** to **167** and
brought the unheard count to **1,177**; the roster tier the lap after took it to **1,176**. Those
three numbers belong to three different moments, and reading any two of them side by side without
saying so is the same fault this round booked as REDS %222.

The family counts below were taken immediately before this round's own work, on the tree that read
**1,176** unheard. Grouped by name prefix, one family stood far above the rest:

| Family | Witnesses named by nothing, at 1,176 |
|---|---|
| **ales** -- Season C's Lotus creative suite | **239** |
| equinox | 123 |
| hunk | 86 |
| mycelium | 69 |
| glow | 61 |

Season C had built 240 audio modules in `lotus/` and written a witness for each rung as it landed.
Every one of them was GREEN the day it was written, and each has waited for a second reading ever since.

That is the shape REDS %81 wore in the crypto library and REDS %101 wore in Caravan, at a scale
neither reached. An unheard witness is a refusal nobody receives: the guard still knows how to say
no, and the tree has no way to hear it.

## The cost, and how this round got it wrong first

One ales witness builds its `lotus/<name>.rye` with the vendored Zig toolchain and runs the
selftest. The first sample taken on this pier read **5.97 seconds**, and multiplying by 240 gave
**twenty-four minutes** -- which is what this document said before the choir was ever run.

Three clean full sings then measured **233s, 303s, and 233s**: four to five minutes, six times
less. The sample was the session's first Rye build and paid the Zig toolchain's cold start once.
That cache sits at `~/.cache/zig`, outside the tree, and a single witness reads **1.27s** warm
against **7s** on a scoped cold cache. Since ai-jail resets `$HOME`, each session pays the cold
start once and then runs warm.

The lesson is booked as REDS %222 and it is worth stating plainly, because the number carried a
decision: **a measurement carries the conditions it was taken under.** Warm or cold, alone or
beside another run, one sample or three -- each belongs in the sentence with the figure.

| Reading | Conditions | Measured |
|---|---|---|
| one witness | first Rye build of the session | 5.97s |
| one witness | warm cache | 1.27s |
| one witness | scoped cold cache | 7s |
| **240 rungs, three passes** | **warm cache, run alone** | **233s, 303s, 233s** |
| the every-lap roster | warm, `caravan_suite` seated | 20m20s to 22m19s |

## The shape: one guard in two halves, on two clocks

The previous lap seated the piece this needed. A roster row now names its own **tier** -- `lap` for
every run, `cadence` for the fifth round where the council rota closes its cycle and the seed
ships. A tier is a cadence rather than an exemption: every rostered guard runs on some clock, and
the tier names which.

That splits this guard cleanly along its own cost seam.

**The singing is the long half and belongs on the slow clock.**
[`../tools/al/ales_suite_witness.rish`](../tools/al/ales_suite_witness.rish) registers all 240
witnesses, clears `lotus/bin` so the run proves cold-start self-sufficiency rather than inheriting
whatever an earlier run left warm, and asserts each one GREEN by name. It takes `tier cadence`.

**And the tier's real reason is worth saying rather than assuming.** At four to five minutes this
choir is *cheaper* than `caravan_suite` at 8m31s, which stands on the every-lap tier, so cost alone
would allow `tier lap`. It sits on `cadence` for a second reason: the every-lap roster already
measures 20m20s to 22m19s and a lap reads it twice, and Season C's Lotus rungs are stable while
Caravan is the arc actually moving. **The every-lap budget goes to the family that changes.** When
Lotus reopens, the row's tier is worth revisiting, and the roster header now says so.

**The asking is cheap and belongs on the fast clock.**
[`../tools/al/ales_roster_witness.rish`](../tools/al/ales_roster_witness.rish) runs
[`../tools/fixtures/ales_roster_bijection_scan.sh`](../tools/fixtures/ales_roster_bijection_scan.sh)
-- two greps -- and holds the roster whole in both directions. It takes `tier lap`.

The split follows from what each half catches. Singing proves the rungs still work, which is a
question about code that changed. Asking catches a witness **born unheard**, which is a question
about a lap that just happened, and it is the one worth answering the same day. Caravan's choir
already learned this and folded its bijection into a cheap every-lap meter for the same reason.

## Reading the registration from code rather than from prose

The elder caravan scan greps its whole roster file for registered names. That passes today because
its header happens to name no caravan witness -- an accident of prose, and an accident is a thing
that changes.

This scan strips comment lines first. The reason is REDS %218's rule one room over: a citation in
a comment is a promise rather than a call. A header naming a sibling witness would otherwise
register it without running it, and a header naming a witness not yet written would read as a
phantom. The distinction is proven from the welcome side as well as the refusal side, because a
scan that simply reads less looks identical from outside: a planted roster registers one witness in
code, names a second only in a comment, and the scan is watched to answer `registered=1`.

## The guard bit its own author, on its first run

`tools/al/ales_roster_witness.rish` is itself an `ales_*_witness.rish`. Its first run refused: the
scan read **240** witnesses on disk against **239** registered and named the new file unheard.

That is the promise working, on the lap the file was born, which is exactly what the cheap half
exists to do. The repair was to register it like any other rung rather than to grant it an
exemption -- the choir's own file is the single name the bijection leaves out, because a choir need
not register itself, and every further exemption is a hiding place.

## What moved

Measured `20260825.132121`, before and after:

| Reading | Before | After |
|---|---|---|
| tracked witnesses on disk | 1,690 | 1,692 |
| sung every lap (`standing`) | 167 | 168 |
| heard on the cadence lap | 82 | 322 |
| named by some runner (`sung`) | 514 | 755 |
| **named by nothing (`unheard`)** | **1,176** | **937** |

The ceiling in `tools/fixtures/witness_reach_scan.sh` fell from 1,176 to **937**, seated exactly at the reading. The
tree's largest unheard family joined the roster in one round, and the every-lap roster grew by two greps.

## One sing at a time

The choir clears `lotus/bin` and has 240 witnesses build into it, so two sings at once delete each
other's binaries. The second timing run in this round did exactly that: 28 seconds, and a per-rung
RED naming `ales_compress_witness`, a module that is perfectly sound.

A false RED costs more than a slow guard, because Standfast stops the line for it and the line was
never broken. So the choir takes a lock --
[`../tools/fixtures/ales_sing_lock.sh`](../tools/fixtures/ales_sing_lock.sh), which is
`sow_project.sh`'s already-proven shape held in its own file rather than copied: an atomic `mkdir`,
a refusal rather than a wait, and a lock left by a killed sing cleared by its dead pid. Twelve
behaviors, proven both ways, the held case planted against a genuinely live process.

The class showed up once more before the round closed, which is why it earns a section. The lock's
own control ended by checking that the living lock was **absent**, and went RED inside a perfectly
healthy sing -- because the choir sings the very witness that runs that control, and a sing holds
the lock. It checks **unchanged** now: recorded at the top, compared at the bottom.

## What this does not reach

**Whether the 240 Lotus rungs are the right 240.** The choir proves each rung still does what its
witness says. Whether the suite's shape serves a musician is a different reading, and the front
door in `lotus/` is where it belongs.

**The remaining 937.** `equinox` at 123 and `hunk` at 86 are the next two families by size, and
each wants its own round with its own cost measurement -- a choir is cheap to write and costs real
minutes to run, so the tier it earns should follow a stopwatch rather than a habit.

**Staleness on the slow clock.** A cadence guard can go quiet with everything around it green.
`cadence_never_run_here` reports the first run, and a gate on *how long since* wants a lap count to
measure against; that stays open and is named on the operator card.
