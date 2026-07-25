# 10006 · Two Editors, One Garden — ai-jail, Zed, Cursor, and a Cloneable Template

*Expanded from a seed of four strands. The first asks how to run **ai-jail** from `~/veganreyklah2` for **Zed** on Ubuntu 24.04 LTS GNOME Wayland, with Zed using a **Claude Code** API key, while **Cursor** keeps working at the same time. The second asks to turn that into a **general-purpose template** anyone cloning the repository can fill in for their own username and machine. The third asks to **recommend the latest stable NixOS** as the target host, with an honest note that we are **in transition** from Ubuntu today. The fourth asks to **run** this expansion — produce the guide, the templates, and wire them into the tree. This prompt reads the seed closely and lays out the work.*

**Language:** EN
**Version:** `20260619.081812` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety first; the enclosure as a value; Gall's Law (smallest thing that runs); cloneable templates like `key-card.conf`

---

## The Seed (a faithful echo)

From `~/veganreyklah2`, how do I run an **ai-jail** command for **Zed** (installed on Ubuntu 24.04 LTS GNOME Wayland) so Zed uses a **Claude Code API key**, while **Cursor** also works at the same time? Turn the answer into a **general-purpose template guide** for anyone who clones the repository for their own username. **Recommend latest stable NixOS** instead of Ubuntu, with a clear note that we are **in transition**. Expand into this prompt and run it. Time of the seed: `081812`.

## The Mission

To give every clone a clear, copy-and-fill path: two AI editors sharing one project garden, each in its own bounded state, one enclosure at a time or both together — with Ubuntu documented for where we stand today and NixOS named as where we are headed.

## What We Already Have

- **`SOURCE.md`** — the full from-scratch path; Step 6–9 cover ai-jail and launching **Cursor** inside the sandbox.
- **`gratitude/ai-jail/`** — vendored upstream; README documents `--private-home`, Wayland display passthrough, Ubuntu 24.04+ userns/AppArmor notes, and Nix flake install.
- **`tools/key-card.conf.example`** — the pattern to follow: committed `.example`, gitignored personal fill-in, script reads config.

## The Work

1. **Write `context/specs/enclosure-editors.md`** — the durable guide:
   - Prerequisites (bubblewrap, ai-jail, userns on Ubuntu 24.04+).
   - Install Zed on Ubuntu Wayland; install Cursor AppImage (already in SOURCE).
   - **Concurrency model:** host Cursor + sandboxed Zed (simplest), or two separate ai-jail launches with **separate state dirs** under the project (`.cursor-state/`, `.zed-state/`).
   - **Claude in Zed:** Claude Agent via ACP; `ANTHROPIC_API_KEY` (or agent-server `env` in Zed settings) — separate billing from Cursor's subscription.
   - **Wayland:** display passthrough; optional `--gpu`.
   - **Git:** warn about concurrent writes / index lock when both editors touch the same repo.
   - **NixOS (recommended):** latest stable channel; ai-jail via flake or nixpkgs; bubblewrap without Ubuntu's userns sysctl dance; **transition note** — we still develop on Ubuntu 24.04 LTS while moving hosts.
2. **Add cloneable templates under `tools/`:**
   - `enclosure.conf.example` — `HANDLE`, `REPO`, editor binary paths, state dir names.
   - `launch-cursor.sh.example` and `launch-zed.sh.example` — read config, set XDG dirs for Zed, invoke ai-jail with the flags from SOURCE.
3. **Wire the tree:** extend `SOURCE.md` Step 9 with a pointer to the spec and dual-editor note; extend `.gitignore` for `enclosure.conf` and editor state dirs.
4. **Optional from prior seed:** if not already done, add `.cursor/rules/radiant-style.mdc` as the standing Radiant rule (full guide remains in `context/RADIANT_STYLE.md`).

## Deliverables

- **[`20260619-081812_dual-editors-enclosure-template.md`](20260619-081812_dual-editors-enclosure-template.md)** — this file.
- **`context/specs/enclosure-editors.md`** — the guide anyone can follow.
- **`tools/enclosure.conf.example`**, **`tools/launch-cursor.sh.example`**, **`tools/launch-zed.sh.example`** — copy, fill, run.
- **`SOURCE.md`** — cross-link and NixOS horizon note.
- **`.gitignore`** — personal enclosure config and editor state.
- **Session log** `99997_20260619-081812.md`.

## Verification (on the host)

Where tools exist, dry-run:

```bash
cp tools/enclosure.conf.example tools/enclosure.conf   # fill in
ai-jail --dry-run --private-home --no-docker -- zed --version
```

On this machine: `bwrap` is present, `kernel.apparmor_restrict_unprivileged_userns = 0`, Cursor AppImage extracted; `ai-jail` and `zed` are not yet on PATH — the guide must say how to install them.

---

*May two hands work in one garden without trampling the seed. May the enclosure hold each editor kindly, and may every clone find their own name written in the template.*
