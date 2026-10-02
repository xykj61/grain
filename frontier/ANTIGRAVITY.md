# Antigravity CLI -- Google's `agy` at the pier door

**Language:** EN  
**Style:** Gauge Field, Bhakta opening, Civic register  
**Voice:** Kyri  
**Status:** Built -- packaged in the pier's NixOS closure  
**Last updated:** `20261002.054813`  
**Kin:** [`README.md`](README.md) - [`NIXOS_CLI_GUIDE.md`](NIXOS_CLI_GUIDE.md)

## The short path

After the next NixOS rebuild, start the client with:

```sh
agy
```

The interactive captain paste is **fleet interactive incense antigravity** in `../context/SPELLBOOK.md`.

The package is named `antigravity-cli`, but the command is `agy`, matching Google's installer.
The current Linux x86_64 release in the configuration is `1.2.7`. Nix installs it as an immutable
system binary, living inside the closure rather than writing into `~/.local/bin` or self-updating
behind it.

## Authentication

On first launch, follow the interactive sign-in flow. Google's documentation describes native
keyring-backed sign-in on Linux and an API-key workflow for users who prefer a key. The credential
belongs to the user account alone, apart from this repository or the Nix derivation.

Keep `GEMINI_API_KEY`, OAuth material, and copied session files out of tracked configuration.
Use the platform's keyring or an environment mechanism whose permissions you understand.

## Upstream installer, for non-Nix machines

Google's supported macOS and Linux bootstrapper is:

```sh
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

That script installs `agy` under `~/.local/bin` and asks the binary to configure the shell. This
NixOS host takes a different path: the system package pins the Linux tarball listed by Google's
release manifest, verifies its SHA-512 digest, and lets a reviewed rebuild move it.

## Gemini CLI is a different door

Antigravity CLI is Google's newer terminal agent, a separate package from the former
`@google/gemini-cli` npm client. Keep the names separate in scripts, documentation, and
credentials. This room installs `agy` alone, apart from installing or migrating the old Gemini CLI.

## Sources

- [Antigravity installation and auth](https://antigravity.google/docs/cli-install)
- [Antigravity getting started](https://antigravity.google/docs/getting-started?tab=cli)
