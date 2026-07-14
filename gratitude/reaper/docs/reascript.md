# ReaScript — scripting and extension API

**Source:** <https://www.reaper.fm/sdk/reascript/reascript.php>  
**Fetched:** 2026-06-30  
**License:** REAPER is proprietary software (Cockos). Public SDK documentation only.

---

## Introduction

ReaScript allows editing, running, and debugging scripts within REAPER. Scripts call REAPER actions and most of the REAPER Extension API (same API as compiled extensions).

**Supported languages:**

| Language | Notes |
|----------|-------|
| **EEL2** | In-house, open source; JSFX uses EEL; high runtime performance; basic UI and graphics |
| **Lua 5.4** | Embedded; good performance; UI/graphics like EEL; REAPER v6.x used Lua 5.3 |
| **Python 2.7–3.x** | External install; less portable; no UI/graphics in REAPER |

## Requirements

EEL and Lua work automatically. Python must be installed and enabled in Preferences (Plug-Ins → ReaScript); bit width must match REAPER (32/64).

## Documentation

- Help → ReaScript documentation (generated from installed REAPER — most up to date)
- EEL2 language reference; Lua 5.4 manual; Python docs online

## Running scripts

Scripts live in the REAPER/Scripts resource directory (Options → Show resource path). Actions window (? key): New… / Load… / Run. Scripts bind to shortcuts, MIDI, OSC, toolbars like any action.

## Editing and debugging

Actions → Edit opens ReaScript IDE with variable pane for debugging.

## Getting started

`APITest()` / `reaper.APITest()` / `RPR_APITest()` should show "Test OK".

Call built-in actions via `Main_OnCommand(actionID, 0)` — copy action ID from Actions context menu.

## Advanced

**Deferred scripts** — `defer()` / `atexit()` for background/event-driven scripts; dockable modeless windows.

**Persistence** — `SetExtState` / `GetExtState`; `SetProjExtState` / `GetProjExtState` in project RPP.

**Undo** — `Undo_BeginBlock` / `Undo_EndBlock` paired; bitmask flags for what changed.

**Toggle state** — ReaScript actions can have on/off; `set_action_options()` in v7.0+.

---

*Lotus may carry a scriptable extension surface; study ReaScript for the *shape* of deep user extensibility, in our own vocabulary.*
