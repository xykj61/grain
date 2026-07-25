# Setting Up the Self-Hosted VPN

**Language:** EN
**Version:** `20260714.011504` (Pacific)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Status:** Guide for the task — the client half is real and witnessed on this host; the server half is a real, tested-for-syntax deploy artifact, run once for real on a VPS

---

**Navigation:** [Manual home](../README.md)

---

This reifies [`external-research/20260713-212900_self-hosted-vpn-cto-credential-security.md`](../../external-research/20260713-212900_self-hosted-vpn-cto-credential-security.md) into two real artifacts, split honestly by what each machine can actually do: this Mac is the **client**, so its half runs here, in Rish; the **server** half is a deploy artifact you bring to a VPS you control, since no VPS exists to run it on from here.

## The Client Half — Runs Here, Right Now

```bash
rishi/bin/rishi run tools/vpn_wireguard_client_setup.rish
```

(Prefix with `./tools/glow_host_run.sh --` if `RYE_ZIG`/`RYE_LIB` aren't already set in your shell — see [`../../GLOW_HOST.template.bron`](../../GLOW_HOST.template.bron).)

On first run, if `wg` isn't installed, the script stops and tells you the exact command (`brew install wireguard-tools`) rather than installing networking software for you — that's a deliberate act, not something to happen silently. Run it again once installed, and it will:

1. Generate this laptop's WireGuard keypair (idempotent — a second run reuses an existing key rather than overwriting it; witnessed by re-running and confirming the same public key and file timestamp).
2. Print the public key (safe to share) and never print or re-read the private key.
3. Write a filled-in client config **template** to `.wireguard/wg0-client.conf.template` — real newlines, real structure, with the two values only the server run can supply (the server's public key, the server's IP) left as clear placeholders.
4. Print the exact next steps.

**Everything under `.wireguard/` is gitignored** — confirmed directly against `.gitignore`'s root catch-all before this guide was written; the private key and the filled config never enter git history.

## The Server Half — Bring This to Your VPS

```bash
scp tools/vpn_wireguard_server_setup.sh root@your-vps:/root/
ssh root@your-vps
bash vpn_wireguard_server_setup.sh <this-laptop's-public-key-from-step-above>
```

This installs WireGuard/`ufw`/`fail2ban`/`unattended-upgrades`, generates the server's own keypair (idempotently — safe to re-run), writes `/etc/wireguard/wg0.conf` with your laptop as the first peer, opens the firewall, and brings the interface up. It prints the server's public key and public IP at the end — paste both into `.wireguard/wg0-client.conf.template` on your Mac.

This script's syntax is checked (`bash -n`), yet it has not been run against a real VPS from this session, since no VPS exists here to run it on — it is a faithful transcription of the guide's own Steps 1–3, not yet an end-to-end-witnessed deploy. Treat the first real run on your own VPS as the actual proof.

**Deliberately not automated:** hardening `sshd_config` (`PasswordAuthentication no`, etc.) — a mistake there can lock you out of a box with no console access, so the guide's own advice stands: do that one by hand, watching the result, before anything else touches the box.

## Finishing the Handshake

1. Rename the filled template to `.wireguard/wg0.conf`.
2. Import it into the WireGuard macOS app, or run `sudo wg-quick up ./.wireguard/wg0.conf`.
3. `wg show` on both ends should show a recent handshake.
4. Split-tunnel (`AllowedIPs = 10.0.0.0/8, 172.16.0.0/12`) is the default in the template; swap to `0.0.0.0/0` for the full-tunnel profile the original guide names for higher-risk travel.

---

*May every key stay where it was made, and may the tunnel prove itself with a real handshake before you trust it with anything real.*
