# Apply editors + Cursor CLI bump — host tmux only

**Stamp:** `20260808.060050`  
**Why host:** ai-jail sets `no new privileges`, so `sudo` / `nixos-rebuild` cannot escalate from inside the agent sandbox.

## What this seats

- `vim`, `neovim`, `kakoune` on the system PATH  
- `cursor-cli` overlay → upstream `2026.08.04-aaa8809` (patchelf'd), past nixpkgs 26.05's May pin  

## From host tmux (`pier` session, **outside** `./tools/agent-jail.sh`)

```bash
sudo cp -a /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak-pre-editors-cursor
sudo cp /home/keeper/grain/nixos-guide/pier-staging/configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch --flake /etc/nixos#pier
```

## Witness

```bash
vim --version | head -n 1
nvim --version | head -n 1
kak -version
cursor-agent --version
# expect: 2026.08.04-aaa8809 (or matching Aug stamp)
```

## Notes

- `cursor-agent update` already downloaded Aug into `~/.local`, yet NixOS stub-ld blocks that binary. Prefer the overlay above; ignore or remove the `~/.local` copy later if it confuses PATH.
- nixpkgs **unstable** carries July 23; website latest is Aug 4 — overlay tracks the website tarball.
