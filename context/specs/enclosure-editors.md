# Spec: Two Editors in One Enclosure — Cursor, Zed, ai-jail, and a Cloneable Template

**Language:** EN
**Version:** `20260619.081812` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living guide
**Builds on:** `../../SOURCE.md`, `../../gratitude/ai-jail/README.md`, `../../tools/enclosure.conf.example`

---

## What This Is

This spec answers a practical question: how do you run **Zed** inside **ai-jail** from your project folder, with **Claude Code** (Anthropic API billing), while **Cursor** keeps working — and how does anyone who clones the repository do the same for their own username?

The pattern matches `tools/key-card.conf`: copy the `.example`, fill in your values, run the launch script. Sensitive paths and keys stay gitignored; the template ships in git.

---

## Where We Stand on the Host OS

**Recommended target:** the latest **NixOS stable** release (check [nixos.org/download](https://nixos.org/download.html) at install time — as of early 2026 that is the **25.05** series; newer stables appear on a six-month rhythm).

NixOS gives bubblewrap, ai-jail, and editors as declarative packages, without the Ubuntu 24.04+ AppArmor userns workaround. ai-jail ships a Nix flake:

```bash
nix profile install github:akitaonrails/ai-jail
# or: nix run github:akitaonrails/ai-jail -- --help
```

**In transition:** this repository is still developed daily on **Ubuntu 24.04 LTS** (GNOME Wayland). The steps below include Ubuntu paths first; a short NixOS section at the end maps the same ideas. When our hosts finish migrating, `SOURCE.md` will lead with NixOS and keep Ubuntu as a footnote.

---

## The Concurrency Model

Two editors can share one repository if each keeps **its own state directory** inside the project. The project tree itself is the durable ground ai-jail preserves; host `$HOME`, `/tmp`, and parent paths reset when a jail exits.

| Setup | Cursor | Zed | Notes |
|--------|--------|-----|--------|
| **A — mixed** | Host (normal install) | ai-jail sandbox | Simplest for trying Zed; Cursor stays as you use it today. |
| **B — both enclosed** | ai-jail + `.cursor-state/` | ai-jail + `.zed-state/` | Strongest symmetry; two terminal tabs, two ai-jail processes. |
| **C — Cursor enclosed only** | ai-jail | Host Zed | Rare; use when Zed needs full desktop integration. |

**API billing is separate.** Cursor Pro/Ultra covers Cursor's agent. Zed's **Claude Agent** (ACP) uses **Anthropic API** credentials — an `ANTHROPIC_API_KEY`, or login via `/login` in a Claude thread. One key does not configure the other.

**Git courtesy:** two agents committing at once can contend for `.git/index.lock`. Let one editor own pushes, or serialize commits.

---

## Prerequisites

### All Linux hosts

- **bubblewrap** (`bwrap`) — namespaces for the sandbox.
- **ai-jail** — install per `gratitude/ai-jail/README.md` (`cargo install ai-jail`, GitHub release binary, Homebrew, or Nix flake).

### Ubuntu 24.04 LTS (our current host)

```bash
sudo apt install bubblewrap libwayland-dev libxkbcommon-dev
# ai-jail: pick one
cargo install ai-jail
# or download from https://github.com/akitaonrails/ai-jail/releases

# If ai-jail fails with "setting up uid map: Permission denied":
# see gratitude/ai-jail/README.md — sysctl or AppArmor profile for bwrap
sysctl kernel.apparmor_restrict_unprivileged_userns
# 0 = relaxed (works on this machine); 1 = needs the README workaround
```

### Zed (Ubuntu)

Install from [zed.dev](https://zed.dev) (`.deb` or install script). Confirm:

```bash
which zed
zed --version
```

### Cursor (AppImage in the project)

Documented in `SOURCE.md` Step 6–9. From the repo root:

```bash
./tools/cursor-jail.sh --extract ./Cursor-3.11.13-x86_64.AppImage   # once → squashfs-root/
./tools/cursor-jail.sh --gpu                                         # launch in ai-jail
# Rishi door (preferred):
rishi/bin/rishi run tools/launch-cursor.rish --extract ./Cursor-3.11.13-x86_64.AppImage --gpu
rishi/bin/rishi run tools/launch-cursor.rish --gpu
```

Or from Rishi (edit `apprun` in `tools/launch-cursor.rish` if needed):

```bash
rishi/bin/rishi run tools/launch-cursor.rish
```

---

## One-Time Template Setup (any clone)

```bash
cd ~/yourrepo

cp tools/enclosure.conf.example tools/enclosure.conf
# Edit: HANDLE, REPO, paths to zed and Cursor AppRun

cp tools/launch-zed.sh.example      tools/launch-zed.sh
chmod +x tools/cursor-jail.sh tools/launch-zed.sh
# Cursor: ./tools/cursor-jail.sh  (tracked; no personal copy required)
# Optional: cp tools/launch-cursor.sh.example tools/launch-cursor.sh
```

`tools/enclosure.conf` is gitignored. Only the `.example` files are tracked.

### `LANE_KVM` (A-narrow · counsel `20260712.090512`)

`LANE_KVM=false` by default. When true, our gate (`tools/lane_kvm.sh`) authorizes **`/dev/kvm` only** — no D-Bus, no systemd host units, no session buses. Teacher **ai-jail stays unmodified** (no `--kvm` flag — confirmed through release **v1.12.0**). Daily editor sessions keep the lane off; proven-seat one-shots use `tools/run_with_lane_kvm.sh` on a host that already has `/dev/kvm`. Refuse witness: `rishi/bin/rishi run tools/lane_kvm_refuse.rish`. On-path: `tools/proven_seat_g0_complete_jailed.rish`. Retirement of the D-Bus escape: `active-designing/20260712-113900_lane-kvm-retire-dbus-escape.md`. Pond customs graduate the same fact at supersede.

### `ENCLOSURE` (retreat flag · Claude `20260712.212412` · master-seal `213600`)

`ENCLOSURE=ai-jail` by default in `tools/enclosure.conf.example`. Wrappers (`cursor-jail.sh` · `launch-zed.sh`) honor it. `ENCLOSURE=pond` **refuses** unless `bron-resins/pond-supersede-exit.bron` is present-with-content **and** detached `pond-supersede-exit.bron.asc` verifies against master `0646 2132…` alone (`tools/pond_exit_bron_master_seal.sh` · keyring holds only `context/keys/gpg_signing_06462132.pub.asc`). Season-closed is measured by bron and `.asc` absent. Both `ENCLOSURE` values stay live one full season past the flip.

**Pinned teacher binary (`20260712.131200`):** release **v1.12.0** under gitignored `tools/.cache/bin/ai-jail` (tarball sha256 `91458f153c7b0a87d79aae9014b558a0cfc4b160b7e390008a00c1adfc3edc21`). Set `AIJAIL_BIN="$REPO/tools/.cache/bin/ai-jail"` in personal `enclosure.conf`. Takes effect on the next `./tools/cursor-jail.sh` launch. Study submodule `gratitude/ai-jail` tracks tag `v1.12.0`. Route one stays closed; Route two nest still on word.

### Claude API key for Zed (gitignored secrets file)

**Recommended:** persist the key on disk in a gitignored file the launch script reads:

```bash
cp tools/secrets.env.example tools/secrets.env
chmod 600 tools/secrets.env
# edit: ANTHROPIC_API_KEY="sk-ant-..."
./tools/launch-zed.sh
```

Create a key at [console.anthropic.com/settings/keys](https://console.anthropic.com/settings/keys) → **Create Key** → copy the `sk-ant-...` value once.

**Shell export does not persist** across new terminals or Zed relaunches unless you put it in `tools/secrets.env` or your shell profile. A one-time `export` in yesterday's terminal is gone today.

**Alternative:** `/login` in a Claude Agent thread (OAuth). Tokens land under `.zed-state/` (also gitignored). If `/login` loops or fails, stale OAuth can conflict with an empty API key — try `/logout`, then either log in again or use `tools/secrets.env` only (not both at once until auth is clean).

**Inside ai-jail:** the whole project mount is visible to agents. Use a dedicated Anthropic key with spend limits; rotate if exposed.

Inside Zed you can also set Claude Agent env in **Agent settings** (`agent_servers.claude-acp.env`). Project-local Zed config lives under `.zed-state/` when you use the launch script.

---

## Project Rules — Cursor vs Claude in Zed

Two editors, two rule surfaces, one **`context/`** home.

| Editor | Agent | Rules location | Loaded by |
|--------|-------|----------------|-----------|
| **Cursor** | Cursor Agent | `.cursor/rules/*.mdc` | Cursor (`alwaysApply` frontmatter) |
| **Zed** | **Claude Agent** (ACP / Claude Code) | `CLAUDE.md`, `.claude/rules/*.md` | Claude Code natively — Zed does **not** forward Cursor rules |
| **Zed** | **Zed Agent** (first-party) | `.rules`, `AGENTS.md`, Skills | Zed Agent only — separate from Claude Agent |

**This repository ships both:**

- `.cursor/rules/` — Reya 2, Radiant Style, TAME Guidance, session logs (for Cursor).
- `.claude/rules/` — same disciplines for Claude Code (Zed).
- `CLAUDE.md` + `.claude/rules/` — the same three themes for Claude in Zed.

Keep long-form guidance in `context/` (`REYA2.md`, `RADIANT_STYLE.md`, specs). Editor rule files stay thin pointers so Cursor and Zed stay aligned.

**Inside ai-jail:** `CLAUDE.md` and `.claude/` live in the project mount and persist. Host `~/.claude` is tmpfs under `--private-home`; API keys via `ANTHROPIC_API_KEY` (or Zed `/login` state under `.zed-state/`) are the durable auth paths.

**Verify in Zed:** open a **new** Claude Agent thread, run `/memory`, and confirm `CLAUDE.md` / `.claude/rules/` appear in context.

---

## Agent Panel vs Terminal Threads

Zed offers two different Claude experiences:

| UI | Kind | When to use |
|----|------|-------------|
| **Agent Panel** + **Threads Sidebar** (`Ctrl+Alt+J`) | **Claude Agent** (External Agent / ACP) | Rich sidebar feed — tool cards, edits, thread history (closest to Cursor's agent chat) |
| **Bottom terminal panel** | **Terminal Thread** or integrated terminal | Raw `claude` CLI / TUI scrollback |

**For the sidebar feed:**

1. Command Palette → `agent: open panel` (or the workspace agent icon).
2. Agent selector → **Claude** / **Claude Agent** (install from ACP Registry if missing: `agent: open settings` → Add Agent → Install from Registry).
3. New thread: `Ctrl+N` in the panel, or `Ctrl+Alt+Shift+N` for the new-thread menu.
4. Optional keybinding: `agent: new external agent thread` for Claude specifically.

**Terminal Threads** remain useful for one-off CLI work; they are not the same UI as the Agent Panel. If both are open, use the panel for the agent feed and close or hide the terminal thread when it is redundant.

Expanded prompt: `expanding-prompts/yonder/20260619-090512_zed-claude-rules-and-agent-panel.md`.

---

## Launch — Zed in ai-jail (Wayland)

From the repo root, with `tools/enclosure.conf` filled in:

```bash
./tools/launch-zed.sh
```

What the script does (equivalent manual command):

```bash
cd "$REPO"
ai-jail --private-home --no-docker -- \
  env \
    XDG_CONFIG_HOME="$REPO/.zed-state/config" \
    XDG_DATA_HOME="$REPO/.zed-state/data" \
    XDG_STATE_HOME="$REPO/.zed-state/state" \
    XDG_CACHE_HOME="$REPO/.zed-state/cache" \
    ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  zed "$REPO"
```

- **`--private-home`** — host `~/.config`, `~/.cache`, and Cursor's host state stay outside the jail.
- **`--no-docker`** — Docker socket stays closed (same as `SOURCE.md`).
- **XDG_* under `.zed-state/`** — Zed's config, cache, and Claude Agent state survive in the project.
- **Display** — ai-jail passes `WAYLAND_DISPLAY` and `XDG_RUNTIME_DIR` on GNOME Wayland; the window appears on your session.
- **`--gpu`** — add to the ai-jail invocation if you want GPU acceleration (may add EGL noise in the terminal; omit for quieter software rendering).

Dry-run without starting Zed:

```bash
ai-jail --dry-run --private-home --no-docker -- zed --version
```

---

## Launch — Cursor in ai-jail (same project, different state)

```bash
./tools/cursor-jail.sh
```

With a custom AppRun or a fresh extract:

```bash
./tools/cursor-jail.sh --appimage squashfs-root/AppRun
./tools/cursor-jail.sh --extract ./Cursor-3.9.16-x86_64.AppImage
```

Equivalent manual command:

```bash
ai-jail --private-home --no-docker -- \
  ./squashfs-root/AppRun --no-sandbox \
  --user-data-dir="$REPO/.cursor-state/user-data" \
  --extensions-dir="$REPO/.cursor-state/extensions" \
  "$REPO"
```

`--no-sandbox` disables Chromium's nested sandbox inside bwrap; **ai-jail** remains the real boundary (namespaces, Landlock, seccomp). See `SOURCE.md` Step 9.

---

## Running Both at Once

**Recommended first try (Setup A):**

1. Keep **Cursor** open on the host (or start it normally).
2. In a terminal: `export ANTHROPIC_API_KEY=...` then `./tools/launch-zed.sh`.
3. Open the same folder in both editors. Work in Zed's Claude Agent panel; keep Cursor for its agent when you prefer.

**Both enclosed (Setup B):**

1. Terminal 1: `./tools/launch-cursor.sh`
2. Terminal 2: `export ANTHROPIC_API_KEY=...` && `./tools/launch-zed.sh`

Each process has its own ai-jail tmpfs `$HOME`; only `.cursor-state/`, `.zed-state/`, and the rest of the repo persist.

---

## NixOS Quick Map (recommended target)

On NixOS stable, prefer declarative packages:

```nix
# configuration.nix excerpt — versions follow your channel
environment.systemPackages = with pkgs; [
  bubblewrap
  ai-jail
  zed-editor
  # cursor: often installed per-user from upstream AppImage into the project
];
```

Install ai-jail from the flake if nixpkgs lags:

```bash
nix profile install github:akitaonrails/ai-jail
```

User namespaces and bwrap behave as expected on NixOS; skip the Ubuntu AppArmor sysctl section. Wayland on GNOME is the same: launch scripts from the project root unchanged.

### Cursor on NixOS — extracted AppRun in ai-jail

The tracked launcher runs **`squashfs-root/AppRun`** after extract, not the raw `.AppImage` — so FUSE is not in the jail path. System config still benefits from:

```nix
programs.appimage.enable = true;
programs.appimage.binfmt = true;   # NixOS 24.05+
```

Binfmt registration applies to `.AppImage` files. The **extracted `AppRun`** is a dynamically linked binary; if it fails with loader or library errors inside ai-jail, wrap the launch with an FHS environment from nixpkgs:

```bash
./Cursor-3.9.16-x86_64.AppImage --appimage-extract    # once → squashfs-root/
./tools/cursor-jail.sh                               # tested on Framework NixOS
# if AppRun fails with loader errors:
steam-run ./tools/cursor-jail.sh
```

`--appimage` on `cursor-jail.sh` expects the extracted **`AppRun`**, not a `.AppImage` path — use **`--extract`** for a fresh download.

---

## Troubleshooting

| Symptom | Likely cause | What to try |
|---------|----------------|-------------|
| `bwrap: uid map: Permission denied` | Ubuntu AppArmor userns | `gratitude/ai-jail/README.md` Option A or B |
| Zed window does not appear | Display not passed | Confirm `echo $WAYLAND_DISPLAY`; run from a graphical terminal |
| Landlock enforced, then instant return to shell (no window) | GPU off — Zed cannot init Vulkan/WebGPU | Set `USE_GPU=true` in `tools/enclosure.conf` (default for Zed); confirm `~/.local/zed.app` is `--map`ped (launch script does this automatically) |
| Claude Agent: auth loop | Stale credentials | Clear `.zed-state/data` Claude paths; use `ANTHROPIC_API_KEY` or `/login` again |
| `unknown option: --ro-map` | Wrong flag name | ai-jail uses `--map` for read-only mounts, `--rw-map` for read-write |
| `env: 'zed': No such file or directory` | Zed not installed, or not visible in jail | `curl -f https://zed.dev/install.sh \| sh`; re-run `./tools/launch-zed.sh` (script resolves absolute path + `--map` for `zed.app`) |
| `Landlock: rw map .../py-out not found` | Stale `.ai-jail` rw_map | Remove the path from `.ai-jail` rw_maps (dropped in favor of project-only writes) |
| `exec: ai-jail: cannot execute: Is a directory` | `./ai-jail` source tree shadows the binary | Set `AIJAIL_BIN` in `tools/enclosure.conf` to the real binary path |
| Git lock errors | Two agents committing | Serialize commits; one editor owns git push |

---

## Related

- **`SOURCE.md`** — SSH, GPG, signing inside the sandbox, full Cursor launch.
- **`external-research/20260618-180812_pond-foundation.md`** — Pond re-grows ai-jail in Rye.
- **`tools/enclosure.conf.example`** — fill-in template for this spec.

---

*May two editors share one garden in peace. May the enclosure hold each hand safely, and may every clone find their name in the template.*
