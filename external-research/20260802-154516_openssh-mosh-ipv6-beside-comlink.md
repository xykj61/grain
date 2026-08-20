# OpenSSH, Mosh, and IPv6 Beside Comlink — Study Notes for a Happy-Zone Remoting Lane

*Room one. Outside ideas held whole. Nothing here is a product face until a silo doorway names our modules only.*

**Stamp:** `20260802.154516` · **Voice:** Riyo · **Lens:** TAME  
**Status:** Research for understanding -- Exploration — gratitude clones held unmodified; silo lives in active-designing  
**Gratitude (unmodified):** [`../gratitude/openssh-portable/`](../gratitude/openssh-portable/) · [`../gratitude/mosh/`](../gratitude/mosh/)  
**VPS ops companion:** [`20260801-132929_nixos-vps-clean-energy-mosh-cursor.md`](20260801-132929_nixos-vps-clean-energy-mosh-cursor.md)  
**Comlink ground:** [`20260702-014112_comlink-beyond-dns-and-sockets.md`](20260702-014112_comlink-beyond-dns-and-sockets.md) · [`../comlink/README.md`](../comlink/README.md)

---

## What the world already solved

| Tool | Job | Wire | License note |
|------|-----|------|----------------|
| **OpenSSH** | Authenticated remote shell · port forward · agent | TCP · historically IPv4-first, dual-stack today | BSD-family (portable tree) — study and clean-room silo friendly |
| **Mosh** | Roaming shell · speculative local echo · intermittent links | SSH bootstrap → UDP session · AES-128 key over SSH then UDP | **GPL-3.0** — study only; never copy into Grain product trees |
| **IPv6** | End-to-end addressing without NAT theater | Dual-stack sockets · AAAA · happy-eyeballs at edges | Internet standard |

Mosh's insight (not its code): separate **authentication** (SSH) from **interactive carriage** (UDP with predictive echo), so a laptop can sleep, change networks, and resume without tearing the session. OpenSSH's insight: one well-audited authentication and channel multiplex that the world already trusts for keys.

## What Comlink already is

Comlink carries a **sealed datagram** — one `wire_format`, hosted UDP and virtio-net, identity-addressed facts. It is not a terminal emulator and not an SSH daemon. The VPS pier today still uses host OpenSSH + Mosh for *operator* access (SEA ritual); that is a host seam, named as such.

## Transferable ideas (silo candidates)

1. **Dual-stack first.** Bind and dial IPv6 and IPv4 with one policy; prefer IPv6 when both answer; never require NAT hairpins inside our world.
2. **Bootstrap ≠ carriage.** Authenticate and key-exchange on a trusted setup path; run the interactive or roaming lane on bounded UDP datagrams that Comlink already understands how to seal.
3. **Predictive local echo is a UX fold**, not a wire format — Mosh's local echo can inspire a *client-side* happy-zone behavior while the wire still carries sealed facts only.
4. **Port ranges and firewall honesty.** Mosh's UDP window (60000–61000) is an ops lesson: name the range in one place so firewall and server agree (already seated in the NixOS VPS note).
5. **GPL wall.** Mosh stays in `gratitude/` for reading. Any Grain remoting face is a **clean-room reimplementation** under our licenses, or a thin host-seam that shells out to system `ssh`/`mosh` without importing their trees.

## What we refuse

- Forking OpenSSH or Mosh into `comlink/` as living product code.
- Shipping GPL-3.0 into the Glow Tend happy zone.
- Pretending Comlink already is SSH.
- Cutting equality-rune or a2 on momentum while this lane is only research.

## Doorway to room two

Silo brief (our names only): [`../active-designing/20260802-154516_comlink-remoting-happy-zone-ssh-mosh-ipv6.md`](../active-designing/20260802-154516_comlink-remoting-happy-zone-ssh-mosh-ipv6.md).

---

*May the pier keep its trusted SSH keys cold and named. May Mosh teach roaming without lending its license. May Comlink stay one sealed letter on every carriage.*
