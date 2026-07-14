#!/usr/bin/env bash
# vpn_wireguard_server_setup.sh — the server half of the self-hosted
# WireGuard VPN guide (Steps 1-3 of
# external-research/20260713-212900_self-hosted-vpn-cto-credential-security.md).
#
# This is NOT meant to run on this Mac -- copy it to your VPS (Debian/Ubuntu
# LTS, root access) and run it there. It is the deploy artifact the client
# side (tools/vpn_wireguard_client_setup.rish) tells you to bring.
#
#   scp tools/vpn_wireguard_server_setup.sh root@your-vps:/root/
#   ssh root@your-vps
#   bash vpn_wireguard_server_setup.sh <this-laptops-public-key>
#
# What it does, plainly:
#   1. Installs and updates wireguard, ufw, fail2ban, unattended-upgrades.
#   2. Generates a server keypair (if one doesn't already exist).
#   3. Writes /etc/wireguard/wg0.conf with your laptop as the first peer.
#   4. Opens the firewall for WireGuard + SSH, enables the interface.
#
# What it deliberately does NOT do:
#   - Touch sshd_config (harden SSH yourself, per Step 1's own note, since
#     that risks locking you out if done wrong by an unattended script).
#   - Print the server's private key anywhere.

set -euo pipefail

CLIENT_PUBKEY="${1:-}"
if [ -z "$CLIENT_PUBKEY" ]; then
  cat <<'EOF' >&2
Usage: bash vpn_wireguard_server_setup.sh <client-public-key>

Paste this laptop's WireGuard public key -- printed by
tools/vpn_wireguard_client_setup.rish -- as the one argument.
EOF
  exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this as root (it configures the firewall and system packages)." >&2
  exit 1
fi

echo "== installing packages =="
apt update && apt upgrade -y
apt install -y wireguard ufw fail2ban unattended-upgrades
dpkg-reconfigure --priority=low unattended-upgrades

echo "== server keypair =="
mkdir -p /etc/wireguard
cd /etc/wireguard
umask 077
if [ ! -f server_private.key ]; then
  wg genkey | tee server_private.key | wg pubkey > server_public.key
  echo "New server keypair generated."
else
  echo "A server keypair already exists -- reused it, generated nothing new."
fi

SERVER_PRIVATE_KEY="$(cat server_private.key)"
SERVER_PUBLIC_KEY="$(cat server_public.key)"

echo "== writing wg0.conf =="
EXT_IFACE="$(ip -o -4 route show to default | awk '{print $5}' | head -1)"
EXT_IFACE="${EXT_IFACE:-eth0}"

cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
Address = 10.66.0.1/24
ListenPort = 51820
PrivateKey = ${SERVER_PRIVATE_KEY}
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ${EXT_IFACE} -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ${EXT_IFACE} -j MASQUERADE

[Peer]
PublicKey = ${CLIENT_PUBKEY}
AllowedIPs = 10.66.0.2/32
EOF
chmod 600 /etc/wireguard/wg0.conf

echo "== firewall and forwarding =="
sysctl -w net.ipv4.ip_forward=1
grep -q '^net.ipv4.ip_forward' /etc/sysctl.conf || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
ufw allow 51820/udp
ufw allow OpenSSH
ufw --force enable
systemctl enable --now "wg-quick@wg0"

echo ""
echo "Server public key (paste this into your laptop's wg0-client.conf.template):"
echo "  ${SERVER_PUBLIC_KEY}"
echo ""
echo "This server's public IP (use as Endpoint on the laptop side):"
curl -s https://ifconfig.me || echo "(could not auto-detect; check your provider's dashboard)"
echo ""
echo "GREEN: server-side WireGuard setup complete. wg show confirms the interface is up."
wg show
