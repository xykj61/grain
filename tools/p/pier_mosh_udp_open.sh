#!/bin/sh
# tools/p/pier_mosh_udp_open.sh — open mosh's full UDP roam window on the SEA pier.
#
# Run as root, on the pier:   sudo sh tools/p/pier_mosh_udp_open.sh
#
# What it does, and why: stock `programs.mosh` opens only UDP 60000-61000, yet a
# roaming client (a laptop changing networks) can land anywhere in the upper range,
# so a session dies on the roam. This opens UDP 60000-65535 declaratively and rebuilds.
#
# Safe by construction:
#   * ADDITIVE — it adds one allowedUDPPortRanges block and touches no TCP port and no
#     SSH setting, so it cannot lock you out.
#   * IDEMPOTENT — if the range is already present it skips the edit and just rebuilds.
#   * GUARDED — it refuses unless this is the SEA pier (hostName pier + the SEA VPS
#     key), and refuses on a disabled firewall or a custom nftables roof rather than
#     guessing (SEA only, never EWR).
#   * REVERSIBLE — it backs up configuration.nix first; `nixos-rebuild switch` is
#     atomic, so a build failure leaves the running system unchanged.
#
# The Nix edit was validated (nix-instantiate --parse) on a scratch copy before this
# script was written; the awk insertion here is that same edit.
set -eu

CFG=/etc/nixos/configuration.nix
FLAKE=/etc/nixos
HOST=pier

# --- guards: the pier, SEA, one standard roof — else stop and report ---
[ -f "$CFG" ] || { echo "REFUSE: $CFG not found — this is not the pier."; exit 2; }
grep -q 'networking.hostName = "pier"' "$CFG" || { echo "REFUSE: hostName is not \"pier\"."; exit 2; }
grep -q 'vultr SEA VPS' "$CFG" || { echo "REFUSE: no SEA VPS marker — SEA only, never EWR."; exit 2; }
grep -q 'firewall.enable = false' "$CFG" && { echo "REFUSE: firewall is disabled — stop and report, do not guess."; exit 2; } || true
grep -rq 'networking.nftables' /etc/nixos/*.nix 2>/dev/null && { echo "REFUSE: a custom nftables roof is present — stop and report, do not guess."; exit 2; } || true

# --- idempotent edit ---
if grep -q 'allowedUDPPortRanges' "$CFG"; then
  echo "present already: allowedUDPPortRanges in $CFG — skipping edit, rebuilding to be sure."
else
  ts=$(date +%Y%m%d-%H%M%S)
  cp -a "$CFG" "$CFG.bak-$ts"
  echo "backup: $CFG.bak-$ts"
  awk '
    { print }
    /programs\.mosh\.enable = true;/ && !done {
      print ""
      print "  # mosh roam window: stock programs.mosh opens only 60000-61000, yet a roaming"
      print "  # client can land anywhere in the upper range - open 60000-65535 so a session"
      print "  # survives the roam. Additive: SSH (22) stays open via the ssh daemon."
      print "  networking.firewall.allowedUDPPortRanges = ["
      print "    { from = 60000; to = 65535; }"
      print "  ];"
      done=1
    }
  ' "$CFG" > "$CFG.new"
  mv "$CFG.new" "$CFG"
  echo "edited: added allowedUDPPortRanges 60000-65535 to $CFG"
fi

echo "=== the mosh + firewall region of $CFG ==="
grep -nE -A6 'programs\.mosh\.enable' "$CFG" || true

echo "=== rebuild: nixos-rebuild switch --flake $FLAKE#$HOST ==="
if nixos-rebuild switch --flake "$FLAKE#$HOST"; then
  echo "rebuild: OK"
else
  echo "rebuild: FAILED — the running system is unchanged (switch is atomic). Stop here."
  exit 1
fi

echo "=== proof ==="
nixos-version
systemctl is-active firewall.service || true
nft list ruleset 2>/dev/null | grep -nE '60000|65535' || iptables -L INPUT -n -v 2>/dev/null | head -40 || true
command -v mosh-server || true
ss -ulnp 2>/dev/null | grep -E '6000' || true

echo ""
echo "=== REMINDER: Vultr cloud-firewall panel ==="
echo "NixOS opened the OS firewall only. If Vultr's cloud-firewall panel is on, it must"
echo "also allow INBOUND UDP 60000-65535 (or at least 60000-61000). Then retry:  mosh vultr-sea"
echo "DONE"
