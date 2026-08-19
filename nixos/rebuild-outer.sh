#!/usr/bin/env bash
# rebuild-outer.sh -- switch the pier to this repo's NixOS config.
#
# RUN FROM A HOST tmux, OUTSIDE ./tools/agent-jail.sh.
# ai-jail sets "no new privileges", so sudo / nixos-rebuild escalates only from
# the outer host shell, never from inside the agent sandbox.
#
# On this pier /etc/nixos is a SYMLINK to /home/keeper/grain/nixos, so editing
# the repo already updates the live machine config -- no copy is needed and the
# flake reads the repo directly. The script detects that case and skips straight
# to the switch; only when the two configs are genuinely separate files does it
# back up and sync (the earlier deploy convention, kept for a non-symlinked host).
#
#   bash /home/keeper/grain/nixos/rebuild-outer.sh
#
set -euo pipefail

REPO=/home/keeper/grain/nixos
ETC=/etc/nixos
STAMP="$(TZ=America/New_York date +%Y%m%d-%H%M%S)"

echo "== rebuild-outer $STAMP =="

# 1. Sync only when /etc/nixos is a SEPARATE file from the repo. The -ef test is
#    true when both paths resolve to the same inode (the symlinked pier), in
#    which case a cp would error "same file" and a backup would litter the repo.
if [ "$REPO/configuration.nix" -ef "$ETC/configuration.nix" ]; then
  echo "sync     -> skipped; /etc/nixos already tracks the repo (symlinked)"
else
  sudo cp -a "$ETC/configuration.nix" "$ETC/configuration.nix.bak-$STAMP"
  echo "backed up -> $ETC/configuration.nix.bak-$STAMP"
  sudo cp "$REPO/configuration.nix" "$ETC/configuration.nix"
  echo "synced   -> $ETC/configuration.nix"
fi

# 2. Switch. The flake target is #pier (nixos/flake.nix). Using the repo path
#    directly works whether or not /etc/nixos is a symlink.
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

echo "== rebuild-outer GREEN if perl + python3 printed a version above =="
