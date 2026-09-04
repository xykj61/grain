# Pier flake templates

**Where this sits:** home is [`../../README.md`](../../README.md) - a first hour in your hands is
[`../../docs-geode/tutorials/the-first-hour.md`](../../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../../SOURCE.md`](../../SOURCE.md)

**Language:** EN - **Style:** Gauge (see `../../context/GAUGE_STYLE.md`)

The tracked shape for a declared pier. Copy into the living machine directory, fill the keys, and rebuild.

| File | Role |
|------|------|
| `flake.nix` | Flake inputs and `nixosConfigurations.pier` |
| `disk-config.nix` | disko GPT layout for `/dev/vda` |
| `configuration.nix.example` | Host character -- **placeholders only**; rename to `configuration.nix` after fill |

## Living vs tracked

| Layer | Path | In grain? |
|-------|------|-----------|
| These templates | `nixos-guide/templates/` | Yes |
| Living machine config | `/etc/nixos/` | No |
| Field snapshot `nixos/` | private field only | Never copy onto a new box |

```bash
sudo mkdir -p /etc/nixos
sudo cp nixos-guide/templates/flake.nix nixos-guide/templates/disk-config.nix /etc/nixos/
# keeper cannot redirect into /etc/nixos; tee runs as root:
sudo tee /etc/nixos/configuration.nix < nixos-guide/templates/configuration.nix.example
# edit authorizedKeys, then:
sudo nixos-rebuild switch --flake /etc/nixos#pier
```

The public keys in the example are the token `REPLACE_WITH_YOUR_PUBLIC_KEY` -- not an `AAAA` blob -- so the grain-os and grain-ww seeds can ship this file. Paste your real `ssh-ed25519` line in the living `/etc/nixos` copy only.

## Witnessed extras (`20260903`, NixOS 26.05 cloud pier)

- **Springboard is Ubuntu 22.04**, first boot as `ssh -l root` with the panel password, then your laptop public key in `/root/.ssh/authorized_keys`.
- **Stand the host with kexec** from [`../20260803-164117_0-standing-a-declared-pier.md`](../20260803-164117_0-standing-a-declared-pier.md) (curl, tar, `/root/kexec/run`). Ghost SSH: Enter, then `~.`. `nixos-infect` is a convert-in-place reboot that left IPv4 silent on `20260903`.
- **After the first reboot `/etc/nixos` may be empty.** The flake lived on installer RAM. Write `flake.nix`, `disk-config.nix`, and `configuration.nix` back; `flake.lock` returns on the next eval.
- **NAR hash mismatch during `nixos-install`:** `rm -rf /root/.cache/nix` and run the same install again. Reboot only on `status=0`.
- **Do not copy the field's `nixos/`.** That snapshot carries real keys and `PermitRootLogin = "no"`. A laptop key that is not in it will not get in. The living overlay patchelfs the `ai-jail` GitHub linux-x86_64 release (GPL host tool). Templates stay lean for first boot; copy that overlay from `nixos/configuration.nix` after the steward can rebuild.
- **After steward:** `sudo -v` as `keeper`, then set `PermitRootLogin = "no"`. `sshd -T` prints nothing useful on OpenSSH 10 here. The generation's file is the witness:
  `grep -E 'PermitRootLogin|PasswordAuthentication' /run/current-system/etc/ssh/sshd_config`

*May the template stay lean and the living file stay the machine's own sentence.*
