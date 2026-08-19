#!/usr/bin/env bash
# rebuild-outer.sh -- sync this repo's NixOS config to /etc/nixos and switch.
#
# RUN FROM A HOST tmux, OUTSIDE ./tools/agent-jail.sh.
# ai-jail sets "no new privileges", so sudo / nixos-rebuild escalates only from
# the outer host shell, never from inside the agent sandbox.
#
# This lap's change: perl + python3 added to environment.systemPackages
# (nixos/configuration.nix) for the outer terminal.
#
#   bash /home/keeper/grain/nixos/rebuild-outer.sh
#
set -euo pipefail

REPO=/home/keeper/grain/nixos
ETC=/etc/nixos
STAMP="$(TZ=America/New_York date +%Y%m%d-%H%M%S)"

echo "== rebuild-outer $STAMP =="

# 1. Back up the live config before touching it (accrete-never-break).
sudo cp -a "$ETC/configuration.nix" "$ETC/configuration.nix.bak-$STAMP"
echo "backed up -> $ETC/configuration.nix.bak-$STAMP"

# 2. Project the repo's configuration.nix onto the live machine config.
#    flake.nix + disk-config.nix in /etc/nixos are stable; only the
#    package list changed, so only configuration.nix is synced (APPLY convention).
sudo cp "$REPO/configuration.nix" "$ETC/configuration.nix"
echo "synced   -> $ETC/configuration.nix"

# 3. Switch. The flake target is #pier (nixos/flake.nix).
sudo nixos-rebuild switch --flake "$ETC#pier"

# 4. Witness the two new interpreters are on the system PATH.
echo "== witness =="
command -v perl    && perl    --version | head -n 2 | tail -n 1
command -v python3 && python3 --version

# 5. Report the claude-code version this build shipped. nixpkgs nixos-26.05
#    tracks its own pin, so this may LAG upstream -- latest upstream at this
#    writing is 2.1.235 (2026-08-18, code.claude.com/docs/en/changelog). If the
#    pin is too old, bump nixpkgs or add a version overlay like cursor-cli's.
command -v claude && claude --version || echo "claude not on PATH"

echo "== rebuild-outer GREEN if perl + python3 printed a version above =="
