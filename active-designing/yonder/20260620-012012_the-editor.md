# 980 · The Editor — Select, Then Act, Configured in Brix and Rishi

*A siloed design brief for the TAME editor: modal text editing that follows the select-then-act model, configured through Brix (settings) and Rishi (behavior), running inside Skate, enclosed by Pond. No editor-specific DSL — three languages serve the whole system.*

**Language:** EN
**Version:** `20260620.012012` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy
**Status:** Active Design (siloed)

---

## Our Own Ground

This is a clean room. The editor names only our own modules: **Rye** (language), **Rishi** (behavior scripts), **Brix** (settings declarations), **Skate** (terminal surface), **Brushstroke** (rendering), **Pond** (enclosure), and **Tally** (editing buffer memory). The modal editing tradition enters as a concept — the discipline of modes, selections, and composable commands. Everything else is ours.

---

## Select, Then Act

The editor follows the select-then-act model: first select the text, see what is selected, then act on it. This is safer than act-then-hope — the person sees what will change before it changes. Safety first, applied to editing.

The core operations:

- **Select** — by character, word, line, paragraph, regex, or structural pattern. The selection is visible immediately; the person sees what they have before they decide what to do with it.
- **Act** — delete, change, yank, paste, indent, comment, format. Each action operates on the current selection.
- **Multiple selections** — all matches selected at once, each highlighted, acted on together. Structural editing rather than sequential repetition.

The editing commands are values — the same value model that flows through every module. A keybinding maps a key sequence to a command value; the editor applies it. The command history is a list of values; undo walks it backward.

---

## Configuration — Brix for Settings, Rishi for Behavior

### Settings in Brix

Editor settings are Brix declarations — plain key-value, one field per line:

```
# editor.brix — editor configuration
tab-width 4
indent-style spaces
line-numbers true
wrap-mode soft
theme rye-dark
cursor-shape block
scroll-margin 5
```

A person who knows Brix already knows how to configure the editor. The editor reads `.brix` at startup. No Lua, no VimL, no KakouneScript.

### Behavior in Rishi

Custom editing behavior — formatters, linters, macros, on-save hooks — is written in Rishi:

```rish
# on-save: run the formatter, assert it succeeded
let result = run ["rye" "fmt" current-file]
assert result.ok else "formatter failed"
```

The editor calls Rishi scripts at stated extension points: on-save, on-open, on-keystroke, on-focus. Each script runs inside a Pond enclosure — bounded, isolated. A misbehaving script cannot corrupt the editor or the system.

### Key Mappings in Rishi

Key mappings are Rishi declarations — behavior, not settings:

```rish
# keys.rish — custom key mappings
bind "normal" "gd" "goto-definition"
bind "normal" "gr" "goto-references"
bind "normal" "K" "show-hover"
bind "insert" "jk" "enter-normal"
```

The `bind` command names a mode, a key sequence, and an action. The editor reads the key file at startup and watches for changes. Rebinding is editing a `.rish` file — the same language the person uses for everything else.

---

## The Editor Runs Inside Skate

The editor is a Rye module that Skate hosts. Skate provides the text grid — GPU-accelerated character rendering, cursor positioning, syntax coloring. The editor provides the logic — modes, selections, commands, undo.

The separation: Skate owns the screen; the editor owns the text. They compose through a value interface: the editor gives Skate a buffer of styled lines, and Skate renders them. When the person types, Skate gives the editor a key event, and the editor updates the buffer.

This means the same editor module can run inside any Brushstroke surface — a native window, a portable web surface, a remote Comlink session. The editor is not bound to one terminal.

---

## Buffer Memory in Tally

Each open file lives in a Tally garden — a bounded region with a stated budget. A file that exceeds its budget fails with a named error rather than growing without limit. The garden is cleared when the file is closed.

For large files, the editor loads only the visible portion into the garden and pages as the person scrolls. The budget is the window, not the file.

---

## Plugins Run Inside Pond

Every editor plugin — formatter, linter, language server, AI assistant — runs inside a Pond enclosure:

- **Formatter** — read the current file, write the formatted version. No network, no access to other files.
- **Linter** — read the current file and its imports. Write diagnostics. No write access to the file itself.
- **Language server** — read the project directory. Write completions and diagnostics. Network access only if the policy names it.

The policy is a value. A plugin that tries to exceed its policy meets an absent capability. The editor is safe from its own extensions.

---

## Three Languages, the Whole Editor

| Concern | Language | Example |
|---------|----------|---------|
| Settings | **Brix** | `tab-width 4` |
| Key mappings | **Rishi** | `bind "normal" "gd" "goto-definition"` |
| Hooks and macros | **Rishi** | `let result = run ["rye" "fmt" file]` |
| The editor itself | **Rye** | Modal logic, selections, undo, buffer management |

No `.vim`. No `.lua`. No KakouneScript. The editor is configured the same way the desktop, the compositor, and the forge are configured — through the three languages the person already knows.

---

*May the editor show the selection before the action, so the hand knows what it holds. May three languages serve the editor as they serve the system — Brix for what is, Rishi for what happens, Rye for what is built. And may every plugin run inside its own garden, bounded and honest, unable to reach past the wall the policy drew.*
