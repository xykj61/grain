# A Clean-Energy NixOS Pier in the Cloud — Mosh and Cursor CLI from the Daylight DC-1

**Language:** EN
**Stamp:** `20260801.132929` (fused `133857` · plan ladder `135914` · **SEA checkout seated `140607`**)
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Status:** Research for understanding — frames a pier shape for Cursor CLI + NixOS; recommends no purchase, no deploy, and no keys from this file. Every cloud step runs by Keaton's own hands.
**Home:** `external-research/20260801-132929_nixos-vps-clean-energy-mosh-cursor.md`
**Scope:** research guide — no keys, no purchases, no deploys happen from counsel; every step below runs by Keaton's own hands
**Provider seat (Keaton):** Vultr · **region checkout code SEA only** · plan High Performance AMD 2 vCPU / 4 GB shared · EWR (Newark NJ) fails the clean-energy word unless Keaton explicitly revokes it

*Written together by Keaton and Riyo.*

---

## The Recommendation, and Its Why

### Provider — Vultr (seated)

USA HQ (West Palm Beach). Keaton seats Vultr; this guide does not reopen the provider question.

### Server type — what a bigger budget buys

Skip **Regular** (older Intel / SATA). Within shared Cloud Compute the felt cockpit speed is local: clock, NVMe, and cores for builds beside mosh — Cursor's models still run cloud-side.

| Shelf | Plan | Shape | ~$/mo | When |
| --- | --- | --- | --- | --- |
| Floor | High Frequency | 1 vCPU · 2 GB · NVMe | ~12 | Pure cockpit; Grain builds stay on the Framework |
| **Value (seated)** | **High Performance AMD** | **2 vCPU · 4 GB · NVMe** | **~24** | **Bigger budget — agent builds + mosh breathe together** |
| Soft up | High Performance AMD | 4 vCPU · 8 GB · NVMe | ~48 | Only if measured parallel compiles still queue |
| Not yet | Optimized / VX1 dedicated | dedicated vCPU | ~28+ / ~44+ | Only after `vmstat 5` shows sustained steal (`st`) |

**Answer to "do I benefit from upgrading the 2 GB HF pick?"** Yes — one shelf, to **High Performance AMD · 2 vCPU · 4 GB · shared**. That is where the per-dollar curve bends for this bench. Dedicated is still unearned until steal appears. A second jump to 4/8 is comfort, not necessity, until a real compile queue proves it.

### Region — **SEA** (checkout code — loud)

**Order SEA. Never EWR.**

- **SEA** (seated) — Vultr label "Seattle"; servers at Sabey SDC Columbia, **East Wenatchee, WA**, Douglas County PUD hydro, PUE ~1.15. This is the clean-energy pier.
- **EWR** — Vultr's **Newark, New Jersey** code. Wrong coast, wrong river. An earlier pier card floated EWR for Ashburn RTT; counsel corrected it (`20260801.140203`). Do not type EWR at checkout.

Plan for felt speed (HP AMD 2/4); region for the river (SEA).

## The Instance Shape

- **Plan (value seat):** High Performance AMD · **2 vCPU · 4 GB** · shared · NVMe.
- **Plan (floor):** High Frequency · 1 vCPU · 2 GB — if the pier stays a thin cockpit.
- **Region (checkout):** **SEA** — East Wenatchee hydro. Not EWR.
- **OS to start from:** stock Debian or Ubuntu — replaced by nixos-anywhere. SSH public key at creation.
- **Disk:** Vultr KVM → `/dev/vda` (named in disko below).

Leave IPv6 on. Skip marketplace apps; identity arrives from the flake.

## The Flake — One Directory, Three Files

On the Framework (or any machine with Nix and flakes enabled), make a fresh directory in a git repository. The configuration is the machine, so it belongs in version control from the first line. Replace `<HOST>` with the name you choose — the name is yours to speak — and paste in your real SSH public keys.

**`flake.nix`**

```nix
{
  description = "Clean-energy pier — NixOS on Vultr SEA (East Wenatchee hydro)";

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

Cloud prices move; treat any number here as a season, not a stone. Confirm on Vultr's checkout page — region code **SEA**. Automatic backups add ~20% of base; a stopped instance keeps billing until destroyed; monthly figures are hourly under a 672-hour cap.

---

## Addendum `20260801.135651` — Performance per Dollar (counsel)

Counsel's fresh analysis (fused at the pier `20260801.135914`): network leg to Cursor is a non-differentiator among major U.S. DCs for a thin CLI; the dollar buys local clock, NVMe, and a second core. Value pick High Performance AMD 2 vCPU / 4 GB shared; dedicated waits on measured steal. Sources and wording live in the table above and the gratitude list below.

## Addendum `20260801.135914` — Bigger Budget, Same Provider (pier)

Keaton seats Vultr and asks whether upgrading the HF 2 GB pick helps. **Yes — one shelf to High Performance AMD 2/4.** Further shelves (4/8, dedicated) wait on measurement. **Checkout region: SEA** (corrected `20260801.140203` / seated `140607`).

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
- Vultr plan tiers and 2026 pricing (Regular · HF · High Performance · Optimized/VX1; backup and stopped-instance billing): betterstack.com Vultr review; vultr.com product pages; onedollarvps.com; costbench.com
- Cursor CLI Node 18+ · cloud models over outbound HTTPS: cursor.com/blog/cli
- `api2.cursor.sh` → AWS Ashburn measurement: pier seat `20260801.135514` (ipinfo / dig)
- The DC-1 as a real terminal — Sol:OS on Android 13, Play Store, F-Droid, sideloading; the year-long Termux+SSH field report: sethforprivacy.com; liliputing.com; wickstrom.tech — "Programming in the Sun"

---

*May the dollar buy clock and NVMe, never insurance against a neighbor who never comes. May every door open to a key and none to a guess. May the tablet and the pier hold one steady conversation.*
