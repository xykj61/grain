# Maxime Coste -- Kakoune, and the selection that comes before the verb

**Honors:** Maxime Coste (`mawww`), who began Kakoune in 2011 and has shepherded it since, along
with the contributors who keep it small. Kakoune is a modal editor in vi's lineage that changed one
thing on purpose and then followed that change everywhere it led.

**Role for us:** Kakoune is a **steward editor** on this pier, installed beside vim and neovim
(seated `20260808`, `nixos/configuration.nix`). We use it; we do not build on it. What we carry is
its shape, and the shape is worth naming rather than absorbing quietly.

**What we carry**

- **Object then verb, so the object is visible first.** vi says `d2w` -- delete two words -- and you
  learn what you deleted after it is gone. Kakoune says `2wd`: select two words, *see the selection
  highlighted*, then delete. The edit is a confirmation of something already shown. This tree's
  witnesses work the same way and for the same reason: a scan prints what it found, and the tool
  applies exactly that. `tools/f/fold_shelf_link_repoint.sh` names the repair the scan computed and
  applies nothing else -- selection, then verb.

- **Multiple selections as the ordinary case.** Kakoune has no separate macro language for the
  common job of doing one thing in many places; it makes many cursors the normal state and lets one
  keystroke reach all of them. Our answer to a fault that arrives four times from four hands is the
  same instinct: build the one instrument rather than repeat the one repair.

- **A client-server split with no protocol invented for it.** Kakoune sessions are a daemon and thin
  clients over a UNIX socket, and its scripting reaches for the shell rather than embedding an
  interpreter. `:%|sort` pipes selections through a real program. That is our own preference for
  reaching a seam through what already exists, and for `run` returning a status a caller must check
  before trusting the output.

- **Small on purpose, and willing to say no.** The project has kept its surface narrow for over a
  decade -- the same discipline we honor in [Zig](andrew-kelley-zig.md) and for the same reason: a
  small thing can be held whole in a reader's head, and a thing held whole is a thing that can be
  checked.

**What we do not take.** Kakoune's code is C++ under the Unlicense, and we neither vendor it nor
read it for implementation. Concepts enter through the clean room; code never does
(`.claude/rules/gratitude-licenses.md`). Its normal-mode grammar is its own, and we borrow the
*idea* of showing the object before acting on it, not a keymap.

**Measured `20260908.011935`.** Upstream stands at **`v2026.05.21`**; this pier runs
**`v2026.04.12`**, which is what the pinned `nixos-26.05` channel carries. `nixos-unstable` carries
the newer one. Nothing is wrong here -- a pinned channel moving deliberately is a pin doing its job,
and the gap is recorded so the next reader meets a fact rather than a guess.

*May the thing you are about to change always be visible before you change it.*
