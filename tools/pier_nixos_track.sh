#!/bin/sh
# tools/pier_nixos_track.sh -- make the repo the single declarative source for
# the pier's NixOS config, and rebuild. Run as root, in the OUTER host terminal
# (NOT inside the jail, which sees /etc/nixos read-only and cannot sudo):
#
#   sudo sh ~/grain/tools/pier_nixos_track.sh
#
# Why: NixOS's whole point is a declarative, version-controlled config. Until now
# /etc/nixos lived only on the host, untracked. This points /etc/nixos at the
# repo's tracked nixos/ (via symlink), so the config is versioned, reviewable, and
# reproducible -- and it installs git-filter-repo (declared in nixos/configuration.nix)
# so the deep-debride history tool is present on every future boot.
#
# Symlink vs copy (Keaton's question): SYMLINK is chosen -- /etc/nixos -> repo/nixos --
# so the repo is the ONE source of truth and an edit in git applies on the next
# rebuild, with no drift. A copy would leave two divergent files. The script keeps
# a timestamped backup of the old /etc/nixos so the change is fully reversible.
#
# Safe by construction (same discipline as pier_jq_install.sh):
#   * GUARDED    -- refuses unless this is the pier (hostName pier) with the repo present.
#   * VALIDATED  -- parses the tracked configuration.nix BEFORE pointing at it.
#   * REVERSIBLE -- moves the old /etc/nixos aside to a timestamped backup; the atomic
#     `nixos-rebuild switch` leaves the running system as-is on any build failure.
#   * IDEMPOTENT -- if /etc/nixos already points at the repo, it just rebuilds.
set -eu

REPO="${HOME}/grain"
# resolve the real invoking user's home when run under sudo
if [ -n "${SUDO_USER:-}" ]; then REPO="$(eval echo "~${SUDO_USER}")/grain"; fi
SRC="${REPO}/nixos"
HOST=pier

# --- guards ---
[ -d "$SRC" ] || { echo "REFUSE: ${SRC} not found -- run from the pier with the repo cloned."; exit 2; }
[ -f "${SRC}/configuration.nix" ] || { echo "REFUSE: ${SRC}/configuration.nix missing."; exit 2; }
[ -f "${SRC}/flake.nix" ] || { echo "REFUSE: ${SRC}/flake.nix missing."; exit 2; }
grep -q 'hostName = "pier"' "${SRC}/configuration.nix" 2>/dev/null || { echo "REFUSE: tracked config is not the pier (hostName pier not found)."; exit 2; }
[ "$(id -u)" = "0" ] || { echo "REFUSE: run as root (sudo)."; exit 2; }

# --- validate the tracked config parses BEFORE switching to it ---
echo "validating ${SRC}/configuration.nix ..."
nix-instantiate --parse "${SRC}/configuration.nix" >/dev/null || { echo "REFUSE: tracked configuration.nix does not parse -- fix in the repo first."; exit 3; }

# --- point /etc/nixos at the repo (idempotent), backing up any real dir first ---
if [ -L /etc/nixos ] && [ "$(readlink -f /etc/nixos)" = "$(readlink -f "$SRC")" ]; then
  echo "/etc/nixos already tracks ${SRC} -- rebuilding only."
else
  TS="$(date +%Y%m%d-%H%M%S)"
  if [ -e /etc/nixos ] && [ ! -L /etc/nixos ]; then
    mv /etc/nixos "/etc/nixos.bak-${TS}"
    echo "backed up old /etc/nixos -> /etc/nixos.bak-${TS} (reversible: mv it back and rebuild)"
  else
    rm -f /etc/nixos
  fi
  ln -sfn "$SRC" /etc/nixos
  echo "linked /etc/nixos -> ${SRC} (repo is now the declarative source)"
fi

# --- rebuild atomically from the flake ---
echo "rebuilding: nixos-rebuild switch --flake /etc/nixos#${HOST}"
nixos-rebuild switch --flake "/etc/nixos#${HOST}"

echo "GREEN: /etc/nixos tracks the repo; system rebuilt. Verify: command -v git-filter-repo"
