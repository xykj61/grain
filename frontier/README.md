# Frontier -- the four agent CLIs at the pier door

**Language:** EN  
**Style:** Gauge, Door setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))  
**Voice:** Kyri  
**Status:** Built -- the NixOS configuration carries four pinned terminal agents; Cursor CLI's
terminal-only operating guide lives under [`cursor-cli/`](cursor-cli/README.md)
**Last updated:** `20260921.152230`
**Kin:** [`NIXOS_CLI_GUIDE.md`](NIXOS_CLI_GUIDE.md) - [`ANTIGRAVITY.md`](ANTIGRAVITY.md) - [`../nixos/configuration.nix`](../nixos/configuration.nix) - [`../open/README.md`](../open/README.md) - [`../fleet/README.md`](../fleet/README.md)

---

## What this room holds

This is the frontier room for the command-line agents installed on the NixOS pier:

| File | Reader | What it answers |
|---|---|---|
| This page | anyone opening the room | why these tools share one room, and where the facts live |
| [`NIXOS_CLI_GUIDE.md`](NIXOS_CLI_GUIDE.md) | someone rebuilding the pier | how the four packages are pinned, checked, and updated |
| [`ANTIGRAVITY.md`](ANTIGRAVITY.md) | someone trying Google's agent | how `agy` is installed, authenticated, and kept distinct from Gemini CLI |

The configuration is the source of truth for what the system installs. This room is the handrail:
it names the upstream release pages, the update path, and the boundary between a reproducible
system package and a user's private credentials.

## The four seats

- **Codex** -- OpenAI's terminal coding agent, pinned to `0.155.1`.
- **Cursor Agent** -- Cursor's terminal agent, pinned to installer build `2026.09.18-9a7762b`,
  with the Incense CLI lane defaulting to Cursor Grok `grok-4.7`.
- **Claude Code** -- Anthropic's terminal coding agent, pinned to `2.1.278`.
- **Antigravity CLI** -- Google's terminal agent, exposed as `agy`, pinned to `1.2.7`.

Each binary enters through the same NixOS `environment.systemPackages` list. The first three
override the channel's older packages; Antigravity is packaged from Google's signed-by-manifest
native Linux tarball because the upstream installer is a mutable per-user bootstrapper.

## What this room does not hold

It does not hold API keys, OAuth tokens, or user session state. It does not decide which agent
should take a fleet lap. [`open/`](../open/README.md) carries provider and harness choices;
[`fleet/`](../fleet/README.md) carries ships and their coordination.

May the binaries stay pinned enough to be trusted, and loose enough to be renewed when their
makers move the door.
