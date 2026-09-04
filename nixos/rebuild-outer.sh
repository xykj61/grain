#!/usr/bin/env bash
# rebuild-outer.sh -- switch the pier to THIS checkout's NixOS config.
#
# RUN FROM A HOST tmux, OUTSIDE ./tools/ag/agent-jail.sh.
# ai-jail sets "no new privileges", so sudo / nixos-rebuild escalates only from
# the outer host shell, never from inside the agent sandbox.
#
# Anchored to the directory that contains this script (same law as fleet-loop):
# a Host pier may have grain-incense / grain-pheromone / grain-petrichor and no
# ~/grain. Dallas as Petrichor: pull in grain-petrichor, then
#   bash nixos/rebuild-outer.sh
# from that tree's root. The flake path is this script's directory, never a
# hardcoded /home/keeper/grain.
#
# If /etc/nixos already points at this same configuration.nix inode, skip copy.
# If /etc/nixos is absent or a broken symlink (the old ~/grain path), skip copy
# and switch this checkout's flake anyway.
#
set -euo pipefail

REPO=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ETC=/etc/nixos
STAMP="$(TZ=America/New_York date +%Y%m%d-%H%M%S)"

echo "== rebuild-outer $STAMP =="
echo "flake    -> $REPO#pier"

# 1. Sync only when /etc/nixos is a SEPARATE live file from this checkout.
if [ ! -e "$ETC/configuration.nix" ]; then
  echo "sync     -> skipped; $ETC/configuration.nix absent (empty dir or broken symlink)"
elif [ "$REPO/configuration.nix" -ef "$ETC/configuration.nix" ]; then
  echo "sync     -> skipped; /etc/nixos already tracks this checkout (symlinked)"
else
  sudo cp -a "$ETC/configuration.nix" "$ETC/configuration.nix.bak-$STAMP"
  echo "backed up -> $ETC/configuration.nix.bak-$STAMP"
  sudo cp "$REPO/configuration.nix" "$ETC/configuration.nix"
  echo "synced   -> $ETC/configuration.nix"
fi

# 2. Switch. The flake target is #pier. ai-jail is an overlay on the GitHub
#    release tarball (configuration.nix), not a flake input -- no lock step.
sudo nixos-rebuild switch --flake "$REPO#pier"

# 3. Witness the two new interpreters are on the system PATH.
echo "== witness =="
command -v perl    && perl    --version | head -n 2 | tail -n 1
command -v python3 && python3 --version

# 4. Confirm the claude-code version overlay took effect. configuration.nix pins
#    claude-code to 2.1.235 (2026-08-18) via an overlay, past nixos-26.05's
#    lagging pin (the locked flake held 2.1.187). Expect 2.1.235 below; the build
#    already self-verified the binary hash and ran `claude --version` internally.
command -v claude && claude --version || echo "claude not on PATH"

# 5. Confirm the codex overlay took effect. configuration.nix replaces nixpkgs'
#    source-built codex (0.133.0 on nixos-26.05) with upstream's prebuilt static
#    musl binary at 0.150.1, because DREAM's seat runs `codex exec --sandbox
#    danger-full-access` inside ai-jail and the CLI moves faster than the channel.
#    Expect 0.150.1 below; the build already self-verified the tarball hash and
#    ran `codex --version` through versionCheckHook.
command -v codex && codex --version || echo "codex not on PATH"

# 6. Confirm ai-jail landed on the system PATH (command -v, not a store pin).
command -v ai-jail && ai-jail --version || echo "ai-jail not on PATH"

echo "== rebuild-outer GREEN if perl, python3, claude, codex, and ai-jail printed versions above =="
