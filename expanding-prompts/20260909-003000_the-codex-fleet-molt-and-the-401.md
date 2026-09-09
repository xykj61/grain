# The Codex fleet molt, and the 401 that stops it

**Language:** EN - **Style:** [Gauge](../context/GAUGE_STYLE.md), Meter - **Voice:** Kyri
**Stamp:** `20260909.003000` - **Status:** Written, **unproven on metal** - **Room:** checkable
**Asked by:** Keaton, `20260909`, while the second Claude account runs out: Codex mutants of the
fleet loop and watcher, **bare**, **loose**, so laps keep going overnight.

## Read this first: nothing runs yet

**`codex` on this pier answers `401 Unauthorized: Missing bearer or basic authentication`.**
Measured `20260909.002500` with a live probe. No loop plumbing changes that.

```
codex login
```

That is interactive and wants your hands. Until it succeeds, every lap would fail in about a
second, and a loop with no auth check burns a whole night at three laps a minute doing nothing
while reporting a full night's work. The new loop therefore **probes auth once and refuses to
start** rather than looping past it.

## What was written

**`tools/f/fleet-loop-codex.sh`** -- a mutant of `fleet-loop.sh`, not a replacement. That file keeps
the Claude seats; this one carries the Codex seats, so neither has a branch the other reads past.

- **Bare by construction.** No enclosure branch at all -- not a flag defaulting to bare, which is a
  flag somebody can flip at 3am.
- **Loose, deliberately:** no `--strict-config`, approvals bypassed, and every failure short of a
  spent deadline is a **hold** rather than a stop. Eight failures buy a 300s hold and then the loop
  continues; failures reset after a clean lap.
- **Custody gates are the one thing NOT loosened.** `.loop-gates-only` and `.loop-drain` still stop
  it, because those are how an agent and a hand say stop, and a loop that cannot be stopped is
  worse than a loop that stopped early.
- **Its own `CODEX_HOME`** at `loops/codex/home`, inside this tree, so a lap cannot write into a
  host home nobody is watching -- the lesson `tools/c/chatgpt-mind.sh` already carried.

## Two things I could not do, said plainly

**I could not run or `chmod` that file.** The permission classifier blocks me from touching a script
containing `--dangerously-bypass-approvals-and-sandbox`, which is a reasonable wall and I did not
work around it. So:

```
chmod +x tools/f/fleet-loop-codex.sh && sh -n tools/f/fleet-loop-codex.sh
```

**Nothing here is proven on metal.** No lap has run, because of the 401. After this whole session
spent on the difference between a guard that runs and a guard that merely exists, this file is
firmly in the second category until you log in and watch one lap finish.

## The watcher

`tools/f/fleet_watch.sh` re-arms by reading `construction/fleet-roster.kyri` and discovering tmux
windows **by name**. A Codex watcher wants the same shape with one line changed -- the relaunch
command becomes `sh tools/f/fleet-loop-codex.sh <seat>`. That mutant is **not written yet**: the
loop is the piece that must exist first, and writing a watcher for a loop nobody has seen run once
would be building the second floor before the first.

## The paste block, for an interactive Codex incense session

Once `codex login` succeeds, open a Codex session in this tree and paste this:

```
You are Kyri at the incense seat of ~/grain-incense, running as Codex, bare on the pier.

Read tools/f/fleet_baton.txt first -- it is the opening every ship in this fleet reads, and
every rule it names applies to you exactly as to a Claude seat. Then read
construction/ITINERARY.md, its Standing block first and its Now section second.

Your first job is to prove one lap by hand before any loop starts:
  sh tools/f/fleet_round_open.sh
  sh tools/fixtures/s/standing_equipment_run.sh --detach
  (read the transcript path it prints; the pass is done when that file carries run_verdict=)

Then read expanding-prompts/20260909-003000_the-codex-fleet-molt-and-the-401.md, which records
what was built for you and what was never proven. Verify tools/f/fleet-loop-codex.sh yourself
before trusting it -- it was written by a hand that could not run it.

When one lap has landed whole -- commit, session log, push xy then debrided -- start the loop:
  chmod +x tools/f/fleet-loop-codex.sh
  LOOP_HOURS=10 sh tools/f/fleet-loop-codex.sh incense 2>&1 | tee session-output/incense.txt

To stop it at any hour:  touch .loop-drain
The loop finishes its current lap whole, then stops, and never removes that file itself.

End every reply with one line: kg, or a named check in.
```

## What waits for a word

The equinox guard repairs from the lap before this one stand **staged and uncommitted** in the
working tree: four scans moved from a snapshot equality to a floor, on the principle that an
append-only ledger's count only rises and an advancing metric revision only advances. One of them
correctly stays red -- `fascia` reads **57** against an expected **92**, which is a *fall*, so the
floor keeps its teeth exactly where it should.
