# The OpenCode Fleet Loop -- DeepSeek at the helm, one loop for every ship

**Language:** EN
**Style:** Gauge Field, Bhakta opening (assume no background), Radiant warmth
**Voice:** Kyri
**Status:** Vision -- the loop is written and syntax-checked, not yet run overnight
**Last updated:** `20260921.035152`
**Kin:** [`README.md`](README.md) - [`HARNESS_SETUP.md`](HARNESS_SETUP.md) - [`../fleet/README.md`](../fleet/README.md) - [`../tools/f/fleet-loop-opencode.sh`](../tools/f/fleet-loop-opencode.sh) - [`../tools/f/fleet_watch_opencode.sh`](../tools/f/fleet_watch_opencode.sh)

---

## What this page is

This page documents the OpenCode fleet loop -- the script that lets a ship in this tree's Earth
fleet run its unattended laps on DeepSeek V4 Pro through OpenCode, the same way the Claude loop
runs them on Claude and the Codex loop runs them on Codex. It is the third engine in the fleet,
seated beside the other two.

## What a fleet loop is, in one paragraph

A fleet loop is a small shell script that runs one ship's work over and over, unattended, for as
long as a deadline allows. Each pass is a **lap**: the loop opens the round (pulling the shared
remotes), hands the ship its standing instructions, lets it work, and then closes the lap with a
commit and a session log. The loop keeps going until the deadline, a hand clocks the ship out, or
the ship's own custody gates say stop.

## The three engines, side by side

| Engine | Loop script | Model | Shape |
|---|---|---|---|
| `claude` | `tools/f/fleet-loop.sh` | Claude | the original, with a jail branch for Linux |
| `codex` | `tools/f/fleet-loop-codex.sh` | GPT-5.6-sol | bare, loose |
| `opencode` | `tools/f/fleet-loop-opencode.sh` | DeepSeek V4 Pro via Together | bare, loose |

The OpenCode loop is a **mutant** of the Claude loop, not a replacement -- the same word the Codex
loop already uses for itself. Each engine keeps its own script, so no script carries a branch the
others must read past. The three share one seat table, one baton, one round-open, and one set of
custody gates; only the invocation differs.

## What "bare" and "loose" mean here

The OpenCode loop inherits the two clauses Keaton named for the Codex molt:

- **Bare by construction.** This pier runs without jails (Keaton's word `20260906`), so there is no
  enclosure branch in the script at all. `opencode` runs on the host, in the ship's own tree, full
  stop. There is no flag to flip at 3am that would quietly put a ship back in a jail.
- **Loose on purpose.** The point of an overnight lap is that work keeps going while a hand sleeps.
  So approvals are bypassed (`--dangerously-skip-permissions`), and every failure short of a spent
  deadline is a hold rather than a stop.

The one thing not loosened is the custody gates. `.loop-gates-only` and `.loop-drain` still stop the
loop, because those are how an agent and a hand say stop, and a loop that cannot be stopped is worse
than a loop that stopped early.

## How the loop works, step by step

1. **It anchors to its own tree.** The script resolves the tree that contains it, never the caller's
   working directory, so a bench holding sibling trees can never run one seat's laps against another
   checkout.
2. **It reads the seat table.** `tools/fixtures/f/fleet_roster_scan.sh` answers which tree a seat
   belongs in and refuses if the names do not match.
3. **It proves the model is reachable before the first lap.** A one-line probe asks OpenCode to
   reply with exactly `OPENCODE_ALIVE`, on the same model the laps will run. An unauthenticated
   OpenCode answers in about a second, so an unchecked loop would otherwise burn a whole night doing
   nothing and report a full night's work.
4. **Each lap opens the round**, pulls the shared remotes, and adopts the anointed order -- the same
   `tools/f/fleet_round_open.sh` every engine shares.
5. **Each lap hands the ship its prompt** -- the shared baton, the seat's own lane stanza, and a few
   OpenCode-specific lines naming the model and the harness.
6. **Each lap closes with a commit and a session log**, then pushes to `xy` and `debrided`.

## How to run it

```sh
cd ~/grain-<seat> && sh tools/f/fleet-loop-opencode.sh <seat>          # the loop; LOOP_HOURS bounds it
cd ~/grain-<seat> && LOOP_LAPS=1 sh tools/f/fleet-loop-opencode.sh <seat>   # one lap
```

The interactive captain paste is **incense interactive opencode** in [`../context/SPELLBOOK.md`](../context/SPELLBOOK.md).

The recipe is also printed by the seat table itself, engine-aware:

```sh
sh tools/fixtures/f/fleet_roster_scan.sh --recipe <seat>
```

The model is named once, at the top of the script, and both the probe and the lap read the same
name: `together/deepseek-ai/DeepSeek-V4-Pro-0813`. An explicit `OPENCODE_MODEL` override remains
supported, the same way `CODEX_MODEL` overrides the Codex loop.

## How a ship switches engines

A ship's engine is one field in one row of `construction/fleet-roster.kyri`. To move a ship from
Claude to OpenCode, change `engine claude` to `engine opencode` in that ship's row. The loop, the
watcher, and the recipe all read that one field, so nothing else needs to change. The switch is
Keaton's word to give, the same way every other seating in this tree is.

## The watcher

`tools/f/fleet_watch_opencode.sh` is the OpenCode twin of the Codex watcher. It reads the tmux
windows by name, finds any live seat whose `fleet-loop-opencode.sh` process is gone, and re-arms it
-- refusing a running loop, a busy pane, a duplicated window name, a gated tree, and a seat that has
burned three arms without taking hold. It runs beside the ships in the same tmux session, the same
way the other two watchers do.

## What this page does not claim

**It does not claim the loop has run overnight.** The script is written and syntax-checked; the
proof that it holds a full night is a night it has actually held, which has not happened yet.

**It does not seat the fleet.** A ship's engine is the `engine` field in
`construction/fleet-roster.kyri`. From `20260922` the seven live ships besides incense read
`codex`. This page documents the OpenCode loop; the roster is the seating.

**It does not repeat `HARNESS_SETUP.md`.** That page proves the provider and harness connection;
this page assumes it and documents the loop that rides on top of it.

---

*May the third engine sit as steady as the first two, and may every ship that reaches for it find
the path already cleared.*
