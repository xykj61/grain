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
| Optional private mirror | separate `pier-flake` repo | No |

```bash
sudo mkdir -p /etc/nixos
sudo cp nixos-guide/templates/flake.nix nixos-guide/templates/disk-config.nix /etc/nixos/
sudo cp nixos-guide/templates/configuration.nix.example /etc/nixos/configuration.nix
# edit authorizedKeys, then:
sudo nixos-rebuild switch --flake /etc/nixos#pier
```

Keep a living `/etc/nixos/configuration.nix` with real keys out of public grain. Public keys may live in a private pier-flake mirror; product identity still goes through `PUBKEYS.md` when deliberate.

*May the template stay lean and the living file stay the machine's own sentence.*
