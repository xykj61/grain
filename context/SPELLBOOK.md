# The Spellbook -- Grain's Operator Words

**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)

> **Mirrored at `spellbook/README.md`**, declared in [`../context/document-mirrors.brix`](../context/document-mirrors.brix) and proven byte-identical. Every link here is written `../<room>/<file>` so it resolves from both homes (REDS %176).

**Language:** EN
**Seated:** `20260810.145033` on Keaton's word - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Purpose:** Gather the one-word gestures that steer this workspace, so a hand on any client -- phone, terminal, fresh agent -- can read the whole vocabulary in one place.
**Room:** checkable -- every spell names the rule file that carries it

---

## What a spell is

A spell is a single word that names a whole, repeatable gesture. Where ordinary prose would spend a paragraph, a spell spends a syllable -- and every spell here already has a home rule that governs it exactly. This page is the index; the rule is the law. Where a spell links `[[nothing]]` yet, it is emerging and earns its own rule when the chapter wants it.

## The command words -- verbs that act

| Spell | What it does | Home |
|---|---|---|
| **send** | commit (signed, CONTRIBUTING style), push `origin` + `xykj61`, merge to `main` | `.claude/rules/send-word.md` |
| **kg** | keep going -- the next mechanical lap (not a send by itself) | `.claude/rules/collaboration.md` |
| **seat** | make a proposal live -- write it as the standing thing, on Keaton's word | `.claude/rules/cell.md` |
| **cast** | assign a point its attributes -- a galaxy's element and mode, a chart's longitudes | astrology cast - council topology |
| **remember** | reprint the living operator card for the next hand | `.claude/rules/remember.md` |
| **align** | reconcile the plan with what is actually true, then fix the plan | `.claude/rules/align.md` |
| **molt** | prep a dated writing's fossil onto the shred list -- opens no cut | `.claude/rules/molt.md` |
| **shred** / **shed** | the authorized cut of a fossil that has a living mutant | `.claude/rules/molt.md` - SHRED_PREP |
| **add to molt queue** | note a document into `construction/SHRED_PREP.md` with its measurement -- prep only, the file itself untouched | `context/CHEMICAL_FORMULAS.md` |
| **mitra shed prep** | a fossil seen off like a friend -- mutant seated, living citers repointed, banner on its face, row written -- and the cut still RED | `construction/SHRED_PREP.md` Class M |
| **debride** | the sanctioned break of accrete-never-break -- remove named dead history | `.claude/rules/debride.md` |
| **checkpoint** | mark the way back before a debride rewrites a living card | `.claude/rules/checkpoint.md` |
| **baton** | write a handoff to disk so the vision survives a context reset | handoff batons in `expanding-prompts/` |
| **recur** | pass the baton onward -- cite the parent whole, fold in only the delta | this page - the baton chain |
| **prin** | print the live loop view -- scope, nib, sundial, matrix frame | `context/LEXICON.md` - `tools/p/prin.rish` |
| **tend** | a light keeping round -- freshen, ratchet-on-touch, add no new weight | tend rounds |
| **survey** | the looking pass that names sites and gaps before the first GREEN | `.claude/rules/vocabulary-survey.md` |
| **expand** | grow an intent into a runnable plan in `expanding-prompts/` | `expanding-prompts/` |
| **incense interactive** | begin a captain conversation; the next word names the door | this page |

## incense interactive

Run any line from the repository root, inside tmux on the pier. It opens a conversation. Each line sets `FLEET_BARE=1` and `FLEET_CAPTAIN=1`. The flag after the command is the permission grant that engine reads. The captain's gates stay manual: keys, funds, provisioning, identity, and the public seed.

The one-lap prints stay in their own scripts: [`../tools/l/launch-cursor-incense.sh`](../tools/l/launch-cursor-incense.sh), [`../tools/f/fleet-loop.sh`](../tools/f/fleet-loop.sh), [`../tools/f/fleet-loop-codex.sh`](../tools/f/fleet-loop-codex.sh), and [`../tools/f/fleet-loop-opencode.sh`](../tools/f/fleet-loop-opencode.sh).

### incense interactive cursor

Cursor reads `--yolo` and `--model`. The shell also sets `CURSOR_FORCE=1`, which the print launcher turns into `--force`.

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_FORCE=1 cursor-agent --yolo --model grok-4.7-high "Read tools/f/fleet_baton.txt and tools/i/incense_seat_prompt.txt whole before acting. You are Incense with FLEET_CAPTAIN=1, running bare on the pier. Begin an interactive session."
```

Home: [`../frontier/cursor-cli/INCENSE-FLEET.md`](../frontier/cursor-cli/INCENSE-FLEET.md).

### incense interactive claude

Claude Code treats a prompt as an interactive session. It reads `--dangerously-skip-permissions`. `--print` is its one-lap door. The paste names `claude-sonnet-5` at `--effort medium`, the resolved model on the live seats. [`.claude/settings.json`](../.claude/settings.json) still declares `claude-opus-5` as the fleet default a clone's local settings can outrank.

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 claude --dangerously-skip-permissions --model claude-sonnet-5 --effort medium "Read tools/f/fleet_baton.txt and tools/i/incense_seat_prompt.txt whole before acting. You are Incense with FLEET_CAPTAIN=1, running bare on the pier in Claude Code. Begin an interactive session."
```

### incense interactive codex

Codex forwards these flags to the interactive CLI. `codex exec` is its one-lap door. The model is the default in [`../tools/f/fleet-loop-codex.sh`](../tools/f/fleet-loop-codex.sh).

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 codex -m gpt-5.6-luna --sandbox danger-full-access --dangerously-bypass-approvals-and-sandbox --dangerously-bypass-hook-trust "Read tools/f/fleet_baton.txt and tools/i/incense_seat_prompt.txt whole before acting. You are Incense with FLEET_CAPTAIN=1, running bare on the pier in Codex. Begin an interactive session."
```

### incense interactive antigravity

The command is `agy`. It reads `--dangerously-skip-permissions` and `--prompt-interactive`. The paste leaves the model to the signed-in account; `agy models` lists that account's models after sign-in. Home: [`../frontier/ANTIGRAVITY.md`](../frontier/ANTIGRAVITY.md).

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 agy --dangerously-skip-permissions --prompt-interactive "Read tools/f/fleet_baton.txt and tools/i/incense_seat_prompt.txt whole before acting. You are Incense with FLEET_CAPTAIN=1, running bare on the pier in Antigravity. Begin an interactive session."
```

### incense interactive opencode

OpenCode on Together is the interactive open door. The model is the one proven in [`../open/HARNESS_SETUP.md`](../open/HARNESS_SETUP.md) and named in [`../tools/f/fleet-loop-opencode.sh`](../tools/f/fleet-loop-opencode.sh). `opencode run --interactive` keeps the session open after the first message.

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 opencode run --interactive --dangerously-skip-permissions -m together/deepseek-ai/DeepSeek-V4-Pro-0813 "Read tools/f/fleet_baton.txt and tools/i/incense_seat_prompt.txt whole before acting. You are Incense with FLEET_CAPTAIN=1, running bare on the pier in OpenCode. Begin an interactive session."
```

OpenRouter and Hugging Face remain the request APIs in [`../open/PROVIDER_SETUP.md`](../open/PROVIDER_SETUP.md). This pier's OpenCode config seats Together only, so those two wait for their own model line before they earn a paste.

## The invoked kin -- tools and disciplines a chant calls by name

- **glow** -- the language - **rishi** -- the shell (`.rish`) - **rye** -- systems (Zig dialect) - **brix** -- composition - **kyri** -- the notation (`.kyri`) and the voice.
- **loom** -- where a lantern that fires twice becomes a standing pattern (`.claude/rules/reds-first.md`).
- **grain** -- the whole: the personal OS this all serves.
- **compass** -- the return habit; **council** -- the odd-quorum topology of named galaxies (`context/council-names.kyri`).

## Discipline the spellbook keeps

- **A spell names a gesture; the rule holds the law.** Reading a spell here never replaces reading its home rule before a large or destructive act.
- **The destructive spells are word-gated.** `shred` and `debride` run only on an explicit word naming *what* to remove, `checkpoint` first, and never as a default.
- **kg != send.** Keep going continues a lap; only `send` ships.

---

*One syllable, one whole gesture -- so a hand on any client can steer the work by its true names, and never lose the thread between phone, terminal, and the pier.*
