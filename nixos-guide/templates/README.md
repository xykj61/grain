# Pier flake templates

**Language:** EN · **Style:** Radiant · **Voice:** Riyo

Tracked shape for a declared pier. Copy into the living machine directory, fill keys, rebuild.

| File | Role |
|------|------|
| `flake.nix` | Flake inputs and `nixosConfigurations.pier` |
| `disk-config.nix` | disko GPT layout for `/dev/vda` |
| `configuration.nix.example` | Host character — **placeholders only**; rename to `configuration.nix` after fill |

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

Never commit a living `/etc/nixos/configuration.nix` with real keys into public grain. Public keys may live in a private pier-flake mirror; product identity still goes through `PUBKEYS.md` when deliberate.

*May the template stay lean and the living file stay the machine's own sentence.*
