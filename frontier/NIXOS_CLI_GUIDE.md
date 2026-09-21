# NixOS CLI Guide -- renewing the four agent seats

**Language:** EN  
**Style:** Gauge Field, Civic register, TAME lens  
**Voice:** Kyri  
**Status:** Built -- the commands below describe the tracked pier  
**Last updated:** `20260921.000000`  
**Kin:** [`README.md`](README.md) - [`ANTIGRAVITY.md`](ANTIGRAVITY.md) - [`../nixos/configuration.nix`](../nixos/configuration.nix)

## What is installed

The pier's [`nixos/configuration.nix`](../nixos/configuration.nix) installs these names:

| Command | Package | Pinned upstream release | Update evidence |
|---|---|---:|---|
| `codex` | `codex` overlay | `0.155.1` | OpenAI release asset, static musl binary |
| `agent` / `cursor-agent` | `cursor-cli` overlay | `2026.09.18-9a7762b` | Cursor's current installer URL |
| `claude` | `claude-code` overlay | `2.1.278` | Anthropic release and Linux x64 manifest |
| `agy` | `antigravity-cli` overlay | `1.2.7` | Google's Linux x64 manifest and SHA-512 |

The version strings are not guesses. Nix fetches each fixed artifact by URL and digest, and the
derivations run an install check where the binary supports one. A release bump is therefore a
small, reviewable change: version, source URL, hash, and the note that explains the source.

## Rebuild the pier

From the repository root:

```sh
sudo nixos-rebuild switch --flake ./nixos#pier
```

Then check the four doors:

```sh
codex --version
agent --version
claude --version
agy --version
```

Authentication is deliberately not in Nix. Complete each tool's own login flow as the user who
will run it, and keep keys and tokens outside this repository.

## How to renew a pin

1. Read the official release or installer source named below.
2. Fetch the exact Linux x86_64 artifact once and compute its digest.
3. Update the matching derivation in `nixos/configuration.nix`.
4. Rebuild and run all four version checks.
5. Update this room's table and the relevant tool page in the same change.

Official sources:

- [Codex releases](https://github.com/openai/codex/releases)
- [Cursor CLI installation](https://docs.cursor.com/en/cli/installation)
- [Claude Code setup](https://docs.anthropic.com/en/docs/claude-code/getting-started)
- [Antigravity CLI installation and auth](https://antigravity.google/docs/cli-install)

Do not replace a fixed Nix source with `curl | bash` inside the system build. Cursor and
Antigravity publish convenient user installers, but the pier's system closure needs a digest and
a named artifact. The mutable installer commands remain useful for a non-Nix workstation and are
documented only as upstream references.
