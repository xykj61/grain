#!/usr/bin/env bash
# rebuild-outer.sh -- switch the pier to this repo's NixOS config.
#
# RUN FROM A HOST tmux, OUTSIDE ./tools/ag/agent-jail.sh.
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

# 2. Lock ai-jail if this checkout has not yet recorded the input. The Mac
#    bench has no nix, so flake.lock gains the nested rust-overlay nodes on
#    the pier. Then switch. The flake target is #pier (nixos/flake.nix).
if ! grep -q '"ai-jail"' "$REPO/flake.lock"; then
  echo "lock     -> nix flake lock --update-input ai-jail"
  ( cd "$REPO" && nix flake lock --update-input ai-jail )
  echo "lock     -> flake.lock is now dirty; copy it to the field tree and send so the next pull already holds the pin"
fi
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
