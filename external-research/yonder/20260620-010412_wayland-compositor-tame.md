# 972 · Wayland, Compositors, and the TAME Desktop — What Brushstroke Inherits

*Is the Wayland protocol the most TAME-aligned architecture for a window compositor? This research reads the protocol, three compositors — River's separated architecture, Hyprland's polished monolith, and the opinionated Omarchy setup — and asks what a TAME desktop built from Brushstroke, Skate, and Rishi would look like: how its windows are managed, how its keybindings are declared, and how its applications compose through Caravan and Pond.*

**Language:** EN
**Version:** `20260620.010412` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy
**Status:** Research

---

## Wayland Itself — The Protocol, Not the Compositor

Wayland is a protocol, not a program. It describes how a compositor and its clients communicate: a client asks for a surface, draws to it, and the compositor places it on the screen. The protocol is minimal by design — it replaces the vast, accumulated surface of X11 with a small, typed message set. Clients do their own rendering; the compositor places, transforms, and presents.

**TAME alignment:** Wayland's minimalism is deeply aligned. A small protocol with stated types is a narrow surface — the same discipline Tablecloth and Comlink keep. The compositor is the single authority over what appears on screen, the way Caravan is the single authority over what runs. The protocol's extensibility through typed extension protocols (each a small, self-contained addition) follows the accretion model: add beside, never break.

**What Wayland does not decide:** Wayland says nothing about how windows are arranged, how keybindings work, or how applications are launched. Those are compositor decisions. This is the right separation — the protocol carries surfaces; policy lives above it.

---

## River — The Separated Architecture

River, created by Isaac Freund, separates the compositor from the window manager into distinct processes that communicate through a Wayland protocol extension (`river-window-management-v1`). The compositor handles rendering, input dispatch, and surface management; the window manager handles layout, keybindings, and policy. They are separate programs, composed through a protocol.

**What this teaches (TAME-aligned):**

- **Single responsibility, composed.** The compositor is about one thing (surfaces); the window manager is about one thing (layout). Each is individually simple; together they compose a desktop. This is the same discipline `995` (single-stranded) names for every module.
- **The protocol is the boundary.** The compositor and window manager share no memory, no state, no code — they share a protocol. A bug in the window manager cannot corrupt the compositor. This is the same isolation Caravan's microkernel provides between services.
- **Pluggable policy.** A user can swap window managers without changing the compositor. The layout is a policy, expressed as a separate program, the same way a Pond enclosure's policy is a value.

**What River does that Brushstroke should inherit:**
- The separation of compositor and window manager
- The typed protocol extension for window management
- The discipline of rendering in one process, policy in another

**What to decline:**
- River uses wlroots (a C library) for the protocol and rendering plumbing. Brushstroke is written from scratch in Rye, using the Wayland protocol directly.

---

## Hyprland — The Polished Monolith

Hyprland is a monolithic tiling Wayland compositor: rendering, input, layout, animations, and configuration all in one process. It is written in C++ on its own Aquamarine backend (forked from wlroots). Its strength is visual polish: smooth animations, rounded corners, hardware-accelerated blur.

**What this teaches:**

- **Joy earns the investment.** Hyprland proves that a compositor can be beautiful — smooth enough that the experience is a pleasure, not just a utility. TAME's third value (joy) applies here: a desktop that feels good to use earns attention and sustains the builder.
- **A monolith can move fast.** Without protocol overhead between compositor and window manager, layout changes are instantaneous. The performance argument for a monolith is real when the surface and the policy share a frame.

**What to decline:**

- **The monolith couples surface and policy.** A bug in the layout engine can corrupt the renderer. Caravan's microkernel teaches the opposite: isolate by default, compose through boundaries. For TAME, safety wins over the latency gain.
- **C++ and a forked backend.** We write from scratch in Rye, on our own ground.

---

## Omarchy — The Opinionated Desktop

Omarchy is an Arch Linux derivative that ships Hyprland with opinionated defaults: keybindings, application choices, and a fast setup that gets a developer from install to working desktop in minutes.

**What Omarchy teaches about keybindings and applications:**

- **Super as the compositor key.** All window management lives behind the Super modifier — the compositor's own key, separate from application keys. This is a clean namespace: Super + direction moves windows; Super + number switches workspaces; Super + Enter opens a terminal; Super + Space opens the launcher.
- **Keyboard-first navigation.** Tiling, workspace switching, window focus — all from the keyboard, without the mouse. The hand stays on the keys; the desktop responds to typed intention.
- **Opinionated application choices.** Omarchy ships with a terminal (kitty/foot), a file manager, a browser, a launcher (rofi/wofi), and a status bar (waybar). Each is configured to work with the keybindings out of the box. The setup is fast because the choices are made.

**What a TAME Rye OS desktop inherits from this pattern:**

The principle: **an opinionated default that a person can change.** The keybindings ship working; the applications are chosen for coherence; the whole desktop is usable on the first boot. Configuration is a value — a Rishi script that names the bindings and the applications — so changing any part is as simple as editing one file.

---

## The TAME Desktop — What It Looks Like in Our Names

### Brushstroke as Compositor

Brushstroke is the compositor: it owns the screen, places surfaces, handles input dispatch, and renders frames. It speaks the Wayland protocol (or our own protocol, grown from it) to clients. It does not manage layout — that is a separate concern.

The window manager is a **Rishi script** that speaks to Brushstroke through a typed protocol extension. The script declares: where windows go, what keybindings do, how workspaces are numbered. The script is a value; the compositor enforces it. Changing the layout means editing a `.rish` file, not recompiling the compositor.

### Skate as Terminal

Skate is the terminal: GPU-accelerated text rendering in a Brushstroke surface. A Rishi REPL runs inside it. Mantra commands are typed here. The terminal is an application inside a Pond enclosure — bounded, isolated, policy-as-a-value.

### The Keybindings — Declared in Rishi

A keybinding file is a Rishi script:

```rish
# desktop.rish — keybindings for the TAME desktop
# Super is the compositor key; all window management lives behind it.

# Windows
bind "super+enter" "open skate"
bind "super+q" "close focused"
bind "super+h" "focus left"
bind "super+l" "focus right"
bind "super+j" "focus down"
bind "super+k" "focus up"

# Workspaces
bind "super+1" "workspace 1"
bind "super+2" "workspace 2"
bind "super+3" "workspace 3"

# Layout
bind "super+t" "layout tiling"
bind "super+f" "layout fullscreen"

# Launcher
bind "super+space" "open launcher"
```

This is not executable Rishi today — `bind` is not yet a builtin. It is the design target: keybindings as typed values in a script, readable by hand, changeable by editing. The compositor reads the script at startup and watches it for changes.

### The Applications — TAME Equivalents

| Omarchy ships | TAME Rye OS equivalent | Module |
|--------------|----------------------|--------|
| Terminal (kitty/foot) | **Skate** | Brushstroke surface + GPU text |
| File manager | **Rishi `list-dir` + Brushstroke file view** | Rishi + Brushstroke |
| Browser | **Brushstroke portable surface** | Brushstroke wasm backend |
| Launcher | **Rishi command palette** | Rishi + Brushstroke |
| Status bar | **Brushstroke status strip** | Brushstroke widget |
| Compositor (Hyprland) | **Brushstroke** | Brushstroke + Wayland |
| Window manager | **Rishi layout script** | Rishi protocol extension |
| Package manager | **Brix** | Brix descriptor + Tablecloth store |
| Init system | **Caravan** | Microkernel supervision |
| Version control | **Mantra** | Weave + commit chain |

Each application is a Pond enclosure — bounded, isolated, supervised by Caravan. The policy names what each application may do. The desktop is a composition of enclosures, each about one thing, each placed beside the others.

---

## The Answer — Is Wayland TAME-Aligned?

Yes. Wayland's minimalism, its typed protocol, its separation of rendering from policy, and its extensibility through small protocol additions are all deeply aligned with TAME. The protocol carries surfaces; everything else — layout, keybindings, application management — lives above, in our own modules.

The most TAME-aligned compositor architecture is **River's separated model**: compositor and window manager as distinct processes, composed through a protocol. Brushstroke inherits this separation. The most TAME-aligned desktop setup is **Omarchy's opinionated-default model**: ship working keybindings, let the person change them by editing a value. Rishi inherits this discipline.

The monolith (Hyprland) earns its place in joy — the animations, the polish — and we carry that lesson into Brushstroke's rendering pipeline. Yet the architecture stays separated, because safety comes first.

---

## Sources

- River: Isaac Freund. Non-monolithic Wayland compositor in Zig. GPL-3.0. Studied through public documentation and protocol specs.
- Hyprland: Vaxry. Dynamic tiling Wayland compositor in C++. BSD-3-Clause.
- Omarchy: Basecamp. Opinionated Arch + Hyprland setup.
- Wayland: freedesktop.org. The display protocol.

All read for concepts. The design decisions are our own.

---

*May the desktop we build carry the protocol's minimalism, River's separation, Hyprland's joy, and Omarchy's opinionated kindness — each in our own name, each composed from the modules we already grow. May Brushstroke draw what is true, Skate carry the hand, and Rishi declare what the desktop does — all bounded, all proven, all belonging to the one who sits before the screen.*
