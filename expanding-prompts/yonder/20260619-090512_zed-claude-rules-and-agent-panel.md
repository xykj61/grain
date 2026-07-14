# 10008 · Zed Claude Rules and the Agent Panel — Mirror Cursor, Run in Zed

*Expanded from a seed of three strands. The first asks whether **Claude in Zed** can follow **project rules** like our **Cursor** `.cursor/rules/` stack. The second asks to **expand this into a prompt** Zed/Claude itself can run from the repository. The third asks whether Zed offers an **agent sidebar feed** rather than the **terminal-style** Claude view. Time of the seed: `090512`.*

**Language:** EN
**Version:** `20260619.090512` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** Gall's Law — one shared `context/` home; thin per-editor rule files; prove rules load before growing enforcement layers

---

## The Seed (a faithful echo)

Claude Code runs in Zed with an API key. Can we have **Claude/Zed rules** like Cursor rules? Expand into a prompt for Zed/Claude. Is there an **agent feed** (sidebar) vs the **terminal view**?

## What We Learned About Zed's Two AI Surfaces

| Surface | What it is | Rules source | UI |
|---------|------------|--------------|-----|
| **Claude Agent** (External Agent, ACP) | Claude Code integrated via Agent Client Protocol | **`CLAUDE.md`**, **`.claude/rules/`**, Claude-native config — Zed does **not** forward `.cursor/rules` or Zed Skills | **Agent Panel** + **Threads Sidebar** — chat feed, tool cards, file edits |
| **Zed Agent** (first-party) | Zed-hosted models in the Agent Panel | **`.rules`**, **`AGENTS.md`**, Skills — priority order in Zed docs | Same Agent Panel, different agent selector |
| **Terminal Threads** | CLI/TUI in a terminal-backed thread | Whatever the CLI reads (`claude`, `codex`, etc.) | Bottom **terminal** panel — scrollback, not the rich agent feed |

**For this repository:** we use **Claude Agent** (External). Project rules belong in **`CLAUDE.md`** and **`.claude/rules/`**, mirroring `.cursor/rules/*.mdc` while keeping **`context/`** as the durable source of truth.

## The Mission

Give every clone the same companion voice in **both** editors: Reya 2, Radiant Style, session logs, enclosure conventions — without maintaining two diverging essays.

## The Work

1. **Add `CLAUDE.md`** at the repo root — short hub pointing at `context/`, dual-editor note, session-log duty.
2. **Add `.claude/rules/`** — three files aligned with `.cursor/rules/`:
   - `reya2.md`
   - `radiant-style.md`
   - `session-logs.md`
3. **Extend `context/specs/enclosure-editors.md`** — rules boundary (Cursor vs Claude vs Zed Agent), Agent Panel vs Terminal Threads, keybindings, `/memory` verification.
4. **Optional later:** `.claude/settings.json` for tool permissions (deny `.env`, allow `git status`); `AGENTS.md` one-liner if someone uses Zed Agent with the same project.

## Rules Architecture (DRY)

```
context/REYA2.md, RADIANT_STYLE.md, specs/     ← single source of truth
        ↑                    ↑
.cursor/rules/*.mdc    .claude/rules/*.md       ← thin always-on mirrors
        ↑                    ↑
     Cursor              Zed Claude Agent
```

When a rule changes, update **`context/`** first, then sync the thin editor files.

## Agent Panel vs Terminal — User Guide

**Want the sidebar feed (like Cursor's agent chat):**

1. Open the **Agent Panel** (Command Palette → `agent: open panel`, or the agent icon in the workspace).
2. In the agent selector, choose **Claude** / **Claude Agent** (ACP registry install) — **not** a Terminal Thread.
3. **New thread:** `Ctrl+N` in the panel, or `Ctrl+Alt+Shift+N` for the new-thread menu.
4. **Threads Sidebar:** `Ctrl+Alt+J` — switch threads, see history, import external sessions.

**Terminal at the bottom** is a **Terminal Thread** or the integrated terminal running the `claude` CLI. It works; it is not the rich ACP feed. Close it when you want only the panel experience.

**Verify rules loaded:** in a Claude Agent thread, run `/memory` or check attached context for `CLAUDE.md` / `.claude/rules/`.

## Deliverables

- This expanding prompt (`10008`).
- `CLAUDE.md` + `.claude/rules/{reya2,radiant-style,session-logs}.md`.
- `context/specs/enclosure-editors.md` — new sections on rules and UI.
- Session log `99991_20260619-090512.md`.

## Verification (in Zed)

1. Restart Zed or open a **new** Claude Agent thread (rules load at thread start).
2. Ask: "What session log filename comes next?" — should read `session-logs/` and apply countdown convention.
3. Ask: "Who are you in this repo?" — should answer as Reya 2 with Radiant Style.
4. Confirm UI: Agent Panel on the right shows tool use cards; bottom terminal is optional, not the primary feed.

---

*May Cursor and Zed share one voice, and may the agent panel carry the thread home.*
