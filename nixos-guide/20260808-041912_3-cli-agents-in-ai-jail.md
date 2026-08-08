# CLI Agents in ai-jail — cursor-agent and claude on the Keeper Pier

**Language:** EN  
**Stamp:** `20260808.041912`  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Riyo  
**Status:** Witnessed on the Vultr SEA pier `20260808.041912` — `./tools/agent_jail_witness.sh` GREEN · jailed `claude -p pong` GREEN · auth persist GREEN `20260808.062123` (`~/.config/cursor` → `.cursor-agent-state/xdg-config/`)  
**Follows:** guide 2, `20260803-165931_2-github-hands-and-a-thinking-pier.md`

*Written together by Keaton and Riyo.*

---

Guide 2 left `gh` and Claude Code on the steward's PATH. This note wraps those CLI agents — and Cursor's `cursor-agent` — in the same **ai-jail** posture the house already uses for the Cursor GUI: `--private-home`, project-local auth, jail-local git keys under `~/grain`.

## Why a separate launcher

The GUI path ([`tools/cursor-jail.sh`](../tools/cursor-jail.sh)) expects an AppImage `AppRun`. The pier's daily hands are **headless CLIs**. [`tools/agent-jail.sh`](../tools/agent-jail.sh) is the bash elder for that road; Rish entries are [`tools/launch-claude.rish`](../tools/launch-claude.rish) and [`tools/launch-cursor-agent.rish`](../tools/launch-cursor-agent.rish).

## Seat ai-jail on NixOS

Release tarballs hit NixOS stub-ld. Prefer the upstream flake profile:

```bash
nix profile install github:akitaonrails/ai-jail
```

Then copy [`tools/enclosure.conf.example`](../tools/enclosure.conf.example) to gitignored `tools/enclosure.conf`, set `REPO=/home/keeper/grain`, `HANDLE=keeper`, `USE_GPU=false`, and `AIJAIL_BIN` to the profile binary (`~/.nix-profile/bin/ai-jail`).

ai-jail's bwrap recipe also ro-binds `/opt`. Keep an empty directory (living flake: `systemd.tmpfiles.rules = [ "d /opt 0755 root root -" ];`).

## Launch

From `~/grain`:

```bash
./tools/agent-jail.sh claude
./tools/agent-jail.sh cursor-agent
# Resume a Cursor Agent chat (either flag seat works):
./tools/agent-jail.sh agent --resume=83513e3f-ec89-4924-a12b-f11189b04927
./tools/agent-jail.sh --resume=83513e3f-ec89-4924-a12b-f11189b04927 agent
./tools/agent-jail.sh --continue agent
# or:
rishi/bin/rishi run tools/launch-claude.rish
rishi/bin/rishi run tools/launch-cursor-agent.rish
```

Witness (ordinary host shell, not already jailed):

```bash
./tools/agent_jail_witness.sh
```

## Project-local auth (survives tmpfs `$HOME`)

| Host path inside jail | Durable store in the repo (gitignored) |
|----------------------|----------------------------------------|
| `~/.claude` | `.claude-state/` |
| `~/.claude.json` | `.claude-state/dot-claude.json` (optional seed) |
| `~/.cursor` | `.cursor-agent-state/` |
| `~/.config/cursor` (OAuth `auth.json`) | `.cursor-agent-state/xdg-config/` |
| `GH_CONFIG_DIR` | `.gh/` |

**Browser login every launch is not the steady state.** `cursor-agent` keeps the session token in `~/.config/cursor/auth.json`. Under `--private-home` that path is tmpfs unless mapped — the launcher maps it to `.cursor-agent-state/xdg-config/` and, when that store is empty, seeds once from the host’s `~/.config/cursor/` if present. After one successful login (jailed or host-seeded), later `./tools/agent-jail.sh agent` / `--resume=…` starts should stay signed in. Never commit those state dirs.

Jail-local git identity stays under `.ssh/` and `.gnupg-rye/` — already inside the project mount.

## NixOS path note

ai-jail replaces `/run` with a tmpfs, which would hide `/run/current-system/sw/bin`. The launcher resolves `claude` / `cursor-agent` to their `/nix/store` realpaths and re-maps `/run/current-system` read-only so child tools on PATH still resolve.

---

*May the agent think inside clear edges. May the steward's host keys stay outside the tmpfs home. May every launch leave a witness behind.*
