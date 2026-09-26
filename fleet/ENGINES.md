# Fleet Engines -- the three ways a ship runs its laps

**Language:** EN
**Style:** Gauge Field, Bhakta opening (assume no background), Radiant warmth
**Voice:** Kyri
**Status:** Living -- three engines, and the seven live ships besides incense read codex
**Last updated:** `20260922.175159`
**Kin:** [`README.md`](README.md) - [`SETUP_GUIDE.md`](SETUP_GUIDE.md) - [`../open/FLEET_LOOP.md`](../open/FLEET_LOOP.md) - `../construction/fleet-roster.kyri`

---

## What an engine is, in one paragraph

A ship is a copy of this project's source code with its own running agent session. The **engine** is
the program that actually does the thinking and the typing inside that session -- the model and the
harness that turn a ship's instructions into real work. A ship's engine is one field in one row of
`construction/fleet-roster.kyri`, and every tool that launches
or watches a ship reads that one field.

## The three engines

| Engine | Harness | Model | Loop script |
|---|---|---|---|
| `claude` | Claude Code | Claude | `tools/f/fleet-loop.sh` |
| `codex` | Codex CLI | GPT-5.6-luna | `tools/f/fleet-loop-codex.sh` |
| `opencode` | OpenCode | DeepSeek V4 Pro via Together AI | `tools/f/fleet-loop-opencode.sh` |

The three loops are siblings, not rivals. Each is a **mutant** of the first -- the Claude loop is
the original, and the Codex and OpenCode loops each carry the same seat table, the same baton, the
same round-open, and the same custody gates, with only the invocation changed. A ship can move from
one engine to another by editing one word in its roster row.

## Why a ship would choose one engine over another

- **`claude`** is the original and the most proven. It carries a jail branch for Linux, so it is the
  engine that runs inside the enclosure when a host wants one.
- **`codex`** runs bare and loose -- no jail, and failures hold rather than stop -- chosen for a
  night where the point is that laps keep going while a hand sleeps.
- **`opencode`** runs bare and loose the same way, and reaches an open-weight model, DeepSeek V4
  Pro, through Together AI. It is the engine for a ship that wants its laps on a model this tree can
  study and audit rather than only call.

The full reasoning for the open-weight choice lives in [`open/`](../open/README.md); this page only
names the three engines and how a ship picks one.

## How a ship switches engines

1. Open `construction/fleet-roster.kyri` and find the ship's row.
2. Change the `engine` line -- `engine opencode` to `engine codex`, for example.
3. Commit the roster change and push, the same as any other work.

That is the whole switch. The loop, the watcher, and the recipe all read the engine field, so no
other file needs to change. The switch is Keaton's word to give, the same way every other seating in
this tree is.

## How to see what a ship would run

The seat table prints each ship's launch lines, engine-aware:

```sh
sh tools/fixtures/f/fleet_roster_scan.sh --recipe <seat>
```

A ship on `opencode` prints `fleet-loop-opencode.sh` lines; a ship on `claude` prints
`fleet-loop.sh` lines. The recipe is the one place a hand can read, at a glance, exactly what a
ship's next lap will run.

## What this page does not claim

**The seating is the roster.** From `20260922` the seven live ships besides incense read `codex`.
Incense reads `claude`. The parked aether rows keep the engine they already had. This page
describes the three engines; `construction/fleet-roster.kyri` is the word that seats one.

**It does not claim the OpenCode loop has run overnight.** The script is written and syntax-checked;
the proof that it holds a full night is a night it has actually held.

---

*May each ship find the engine that suits its work, and may the switch from one to another stay as
simple as one word.*
