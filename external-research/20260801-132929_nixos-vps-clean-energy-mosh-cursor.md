# A Clean-Energy NixOS Pier in the Cloud — Mosh and Cursor CLI from the Daylight DC-1

**Language:** EN
**Stamp:** `20260801.132929` (container one-clock; fused `20260801.133857`; Cursor-latency revise `20260801.135514`)
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Status:** Research for understanding — frames a pier shape for Cursor CLI + NixOS; recommends no purchase, no deploy, and no keys from this file. Every cloud step runs by Keaton's own hands.
**Home:** `external-research/20260801-132929_nixos-vps-clean-energy-mosh-cursor.md`
**Scope:** research guide — no keys, no purchases, no deploys happen from counsel; every step below runs by Keaton's own hands

*Written together by Keaton and Riyo.*

---

## The Recommendation, and Its Why

### Primary (Cursor CLI · performance value) — Vultr New Jersey, High Frequency, shared

**Measured this seat (`20260801.135514`):** `api2.cursor.sh` resolves to AWS **Ashburn, Virginia** (`us-east-1`, `18.215.206.165`). Cursor's agent stream goes straight to that US-East path without a regional CDN edge for the long-lived connection. Seattle adds a coast-to-coast hop on every CLI round-trip; New Jersey / New York sits next to Ashburn.

**Pick:** Vultr (USA HQ, West Palm Beach) · region **New Jersey (EWR)** or **New York** · plan **High Frequency Shared**, **2 GB RAM**, 1 vCPU. Shared is enough — Cursor CLI is latency- and single-core-bound more than noisy-neighbor-bound; dedicated is not the first dollar. High Frequency buys the clock speed that agent tooling feels. nixos-anywhere still wants ≥1.5 GB excluding swap, so 2 GB stays the floor.

**USA-HQ value ladder for this job:** Vultr EWR/NYC HF shared 2 GB (first seat) · DigitalOcean NYC Premium AMD 2 GB (polished DX, higher $/GB) · Akamai Cloud Newark (USA HQ second). **Hetzner Ashburn** wins raw $/RAM if German HQ is acceptable — it literally sits in Ashburn — yet it steps off the USA-headquarters line this guide keeps unless Keaton softens that word.

### Alternate (clean energy · Wenatchee poetry) — Vultr Seattle

When the Columbia River matters more than milliseconds to Cursor's API: Vultr **Seattle (SEA)** at Sabey SDC Columbia, East Wenatchee, Douglas County PUD hydro, PUE ~1.15. Washington's grid stays among the cleanest large grids in the nation. Same flake and disk shape; only the region label changes. Keep this as the second seat, not the Cursor-latency seat.

## The Instance Shape

Create the smallest shape that carries the work comfortably:

- **Plan:** **High Frequency Shared**, **2 GB RAM**, 1 vCPU (dedicated only if a later noisy-neighbor measurement asks).
- **Region (primary):** New Jersey (EWR) or New York — nearest USA-HQ Vultr to Ashburn / `api2.cursor.sh`.
- **Region (alternate):** Seattle (SEA) — clean-energy / Wenatchee seat.
- **OS to start from:** any stock Debian or Ubuntu image — it exists only long enough to be replaced. Add your SSH public key at creation so root logs in by key from the first minute.
- **Disk:** on Vultr's KVM the disk appears as `/dev/vda`; the disko file below names it.

Leave IPv6 on. Skip the marketplace apps; the whole point is that the machine's true identity arrives from your flake.

## The Flake — One Directory, Three Files

On the Framework (or any machine with Nix and flakes enabled), make a fresh directory in a git repository. The configuration is the machine, so it belongs in version control from the first line. Replace `<HOST>` with the name you choose — the name is yours to speak — and paste in your real SSH public keys.

**`flake.nix`**

```nix
{
  description = "Cursor-near pier — NixOS on Vultr (EWR/NYC primary; SEA alternate)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, disko, ... }: {
    nixosConfigurations."<HOST>" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./disko.nix
        ./configuration.nix
      ];
    };
  };
}
```

**`disko.nix`** — a single GPT disk that boots on both BIOS and EFI, matching `/dev/vda`:

```nix
{
  disko.devices.disk.main = {
    device = "/dev/vda";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1M";
          type = "EF02"; # BIOS boot partition
        };
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
```

**`configuration.nix`** — SSH by key only, Mosh with its UDP range opened, tmux, Cursor CLI from nixpkgs, and nix-ld as the belt-and-braces for foreign binaries:

```nix
{ pkgs, lib, ... }:
{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostName = "<HOST>";
  time.timeZone = "America/Los_Angeles"; # the pier keeps Wenatchee's clock

  # --- The door: SSH by key, never by password -------------------------
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  # --- Mosh: the roaming shell; the module opens UDP 60000-61000 -------
  programs.mosh.enable = true;

  # --- The person ------------------------------------------------------
  users.users.keaton = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAA... framework"
      "ssh-ed25519 AAAA... dc1-termux"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAA... framework"
  ];
  security.sudo.wheelNeedsPassword = false; # tighten later if preferred

  # --- The workbench ---------------------------------------------------
  environment.systemPackages = with pkgs; [
    tmux
    git
    cursor-cli   # Cursor Agent CLI, packaged in nixpkgs (unfree)
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "cursor-cli" ];

  # Foreign dynamically-linked binaries (installer-dropped tools,
  # cursor-agent self-updates) find their loader through nix-ld.
  programs.nix-ld.enable = true;

  # --- Housekeeping ----------------------------------------------------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 21d";
  };

  system.stateVersion = "25.05";
}
```

Two notes woven in rather than left to surprise. First, `cursor-cli` now lives in nixpkgs as an official package — the community FHS wrapper that preceded it points there itself — so the declarative path is the clean one; the vendor's curl installer drops a dynamically linked binary that bare NixOS refuses, which is exactly the wound `nix-ld` and the package both close. Second, `programs.mosh.enable` opens the UDP 60000–61000 range in the firewall for you; if you ever tighten the range, tighten it in the same option so the firewall and the server agree.

## The One Command

From the flake directory, with the instance freshly created and reachable as root:

```sh
nix run github:nix-community/nixos-anywhere -- \
  --flake .#<HOST> root@<INSTANCE_IP>
```

nixos-anywhere connects over SSH, kexecs the stock image into a NixOS installer in RAM, lets disko cut `/dev/vda` exactly as written, installs the configuration, and reboots into it. The Debian that greeted you is gone without ceremony. When the prompt returns:

```sh
ssh keaton@<INSTANCE_IP>        # the door works
mosh keaton@<INSTANCE_IP>       # the roaming door works
cursor-agent --version          # the bench tool answers
```

Sign in to Cursor once on the server (`cursor-agent login`, or export `CURSOR_API_KEY` in your shell profile), and it stays signed in for every session after.

From this day forward the machine changes only through the flake: edit, commit, then `nixos-rebuild switch --flake .#<HOST> --target-host keaton@<INSTANCE_IP> --use-remote-sudo` from the Framework, or pull and switch on the pier itself. Disaster recovery is the same command that built it — that is the whole beauty of the method.

## The Tablet Lane — DC-1 to the Pier

The DC-1 runs Sol:OS, Daylight's fork of Android 13, and it behaves as a full Android tablet: Play Store, F-Droid, and sideloading all work. Two clean roads reach the pier, and they are happy side by side:

**Termux (recommended first).** Install Termux from F-Droid rather than the Play Store — the Play Store build is frozen, while F-Droid carries the living one. Then, inside Termux:

```sh
pkg install mosh openssh tmux
ssh-keygen -t ed25519 -C "dc1-termux"
cat ~/.ssh/id_ed25519.pub    # paste this key into configuration.nix, rebuild
mosh keaton@<INSTANCE_IP>
```

Termux ships upstream Mosh 1.4 — the genuine article, fully libre, and the option the Mosh community itself reaches for on Android.

**Termius (the polished alternative).** Termius on the Play Store supports Mosh on its free plan through its own implementation, with a comfortable key manager and multi-tab interface. It is closed-source and its Mosh is a re-implementation, so Termux keeps the primary seat; Termius earns the second for days when comfort wins. On the name "Moshi": no living Android app by that name surfaced in current research — the two living Mosh lanes on Android are Termux and Termius, so those are the ones this guide seats.

**The rhythm that makes it sing:** always land in tmux. Mosh gives you roaming and instant local echo; tmux gives you scrollback, splits, and sessions that survive everything. `mosh keaton@<HOST>` then `tmux new -A -s bench` is the whole ritual — put the tablet to sleep on the porch, wake it in the kitchen, and `cursor-agent` is still mid-thought exactly where you left it. A Bluetooth keyboard turns the DC-1 into a real terminal; a year-long field report of exactly this shape — Termux, Mosh, tmux, a Framework at home and a DC-1 in the sun — already exists in the world and reads like a promise kept.

## The Safety Posture, Stated Plainly

Keys open every door and passwords open none. The firewall passes SSH and the Mosh UDP range and nothing else until you say otherwise. The machine's whole identity lives in a git repository, so a compromised or corrupted pier is answered by one nixos-anywhere re-run rather than an archaeology dig. And nothing in this guide touches wallets, custody keys, or the Grain signing keys — the pier is a bench, and the cold keys stay cold at home, exactly as the standing law orders.

## Costs, Held Lightly

Cloud prices move; treat any number here as a season, not a stone. A 2 GB shared-CPU instance at a U.S. provider has recently lived in the ten-to-fifteen-dollars-a-month neighborhood. Check the current Seattle-region pricing on the provider's own page at purchase time, and let the clean-energy siting — not a dollar or two — be the deciding vote, since that was the whole point.

---

## Gratitude — Sources This Guide Stands On

- Vultr Seattle expansion at Sabey SDC Columbia, East Wenatchee — hydro via Douglas County PUD, PUE 1.15: datacenterdynamics.com; businesswire.com (Vultr press, West Palm Beach HQ); blogs.vultr.com
- Vultr company and headquarters: en.wikipedia.org/wiki/Vultr
- Washington's grid mix (63% hydro, ~84% low-carbon, quarter of U.S. hydro): lowcarbonpower.org/region/Washington; en.wikipedia.org/wiki/List_of_power_stations_in_Washington; seattletimes.com
- nixos-anywhere requirements and quickstart (kexec, 1.5 GB RAM, disko): github.com/nix-community/nixos-anywhere; nix-community.github.io/nixos-anywhere
- The worked Vultr example (`/dev/vda`, 2 GB choice): numtide.com — "We don't need NixOS cloud images anymore"
- Cursor Agent CLI packaged in nixpkgs (`cursor-cli`); FHS/nix-ld background: github.com/eisbaw/cursor-cli-nixified; mynixos.com/nixpkgs/package/cursor-cli
- Mosh on Android — Termux upstream 1.4, Termius's own implementation: mosh.org; mailman.mit.edu mosh-users list; termius.com; blog.dan.drown.org
- Termux from F-Droid rather than the frozen Play Store build: en.wikipedia.org/wiki/Termux
- The DC-1 as a real terminal — Sol:OS on Android 13, Play Store, F-Droid, sideloading; the year-long Termux+SSH field report: sethforprivacy.com; liliputing.com; wickstrom.tech — "Programming in the Sun"

---

*May the pier draw its power from the river and its identity from the flake. May every door open to a key and none to a guess. May the tablet in the sunlight and the server in Wenatchee hold one steady conversation, wherever the day carries you.*
