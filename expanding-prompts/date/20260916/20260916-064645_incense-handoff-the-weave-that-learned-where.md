# Incense handoff -- the weave that learned where a line goes

**Language:** EN
**Status:** Living -- a handoff, read once at the top of a fresh incense session
**Room:** checkable -- every claim below names a witness or a command
**Style:** Bhakta with Radiant warmth; Gauge at Meter
**Voice:** Kyri

Read this first in a new incense session. It carries what one long session learned, in the order a
fresh hand needs it.

## What landed, and how to check it in one command each

**Two Mantra rows closed together**, because they were one problem.

```sh
rishi/bin/rishi run tools/m/mantra_diff_witness.rish        # a middle insert lands in the middle
for w in $(git ls-files 'tools/m/mantra_*witness.rish'); do rishi/bin/rishi run "$w" >/dev/null 2>&1 || echo "RED $w"; done
```

A weave line now carries **`ord`**, an order key asked apart from its identity. `Diff` carries
**`replaces`** (which delete an insert stands in for) and **`after`** (which kept line it follows).
`apply` inherits the run and order key from whichever of those names a line, keeps a fresh position
so the identity stays unique, and **inserts at its place** rather than appending. The record grew to
carry `ord` to disk, and its header is a **stamp** rather than a count.

**The composition surface is walled at zero.** Every refusal and report composes a bounded capture
(`${x.err_brief}`, `${x.out_brief}`), because a whole capture is dropped in silence past 4,096 bytes.

```sh
sh tools/fixtures/s/say_compose_bound_scan.sh | grep -E 'eager_per_mille|deferred_per_mille|verdict'
```

**Builds take a per-module lock**, and the lock covers every room a build writes into rather than
only the source's own -- a cross-room import writes a shadow beside the imported file.

```sh
sh tools/fixtures/r/rye_build_control.sh | tail -3
```

## The one thing to do before anything else

**`rishi/bin/` is gitignored, so a fresh clone or an unpulled ship runs an interpreter without the
bounded fields.** The rostered guard says so and names the cure:

```sh
rishi/bin/rishi run tools/r/rishi_brief_witness.rish
```

If it refuses, build `rishi/src/main.rye` with rye, emitting to `rishi/bin/rishi`, then re-run.

## What is open, and what each wants

- **REDS %765** -- 111 counted version strings across 42 record families; `mantra-weave` is the only
  one moved to a stamp. The remaining 41 want Keaton's word, since each writes bytes a store carries.
- **REDS %734** -- two `caravan_subscribe_poll` witnesses answer differently under parallel load and
  green alone. Its build-shadow cause is closed; what remains is uncaptured.
- **REDS %456** -- one login per ship. Keaton's hand at custody gate 3: the login must be made INSIDE
  each ship's jail, where `$HOME` differs, and `/logout` could revoke the session all eight share.

## The habits this session paid for, each in one line

- **Baseline before you change anything.** Running all 29 Mantra witnesses first is what separated
  three of my own breakages from two pre-existing reds and two absent toolchains.
- **Read the clock, never compose a stamp.** Nine logs carried round-numbered guesses; one stood a
  minute in the future.
- **A pattern that matches a neighbour answers confidently.** `pgrep -f` matched this session's own
  shell three times; `tmux` matched a different window; a `%N` matched a peer's row.
- **Reading one rule is not reading the rules.** A record version was ruled lawful from
  `stamp-and-name` alone while `context/specs/rye-versioning-style.md` had already settled it.
- **A witness that refuses your design is the cheapest hour you will spend.** The merge witness
  refused an ordering within the hour, on a case my own probe could not reach.
- **Scratch goes under this tree's own `.lap/`**, never a constant name in a shared `/tmp`.

## Where the reasoning lives

`construction/REDS.md` carries every row named above with its measurement. This day's session logs
stand under `session-logs/date/20260915/` and `session-logs/date/20260916/`, newest first in each
day's shelf index.

May the next hand find the tree greener than it was, and the reasons already written down.
