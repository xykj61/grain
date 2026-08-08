{ modulesPath, pkgs, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostName = "pier";
  networking.useDHCP = true;

  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };

  users.users.root.hashedPassword = "!";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxLRFDtsG7DOKgqwzTT5ruhKTiHN+cITAsArWlYHFmG xykj61@gmail.com xykj61 jail-only vultr SEA VPS (Linux Framework, Livermore)"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtDMOF0YEwmV9a6nR5mt2oYE+em3VdBVeXm3/6OTTcX keaton@dc1"
  ];

  users.users.keeper = {
    isNormalUser = true;
    description = "first steward of this pier";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxLRFDtsG7DOKgqwzTT5ruhKTiHN+cITAsArWlYHFmG xykj61@gmail.com xykj61 jail-only vultr SEA VPS (Linux Framework, Livermore)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtDMOF0YEwmV9a6nR5mt2oYE+em3VdBVeXm3/6OTTcX keaton@dc1"
    ];
  };

  security.sudo.wheelNeedsPassword = true;

  programs.mosh.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Hotter Cursor CLI than nixos-26.05's May pin — patchelf'd for NixOS.
  # Upstream website/hot update lands Aug builds under ~/.local, yet stub-ld
  # refuses those generic Linux binaries; this overlay is the declared road.
  nixpkgs.overlays = [
    (final: prev: {
      cursor-cli = prev.cursor-cli.overrideAttrs (_old: {
        version = "0-unstable-2026-08-04";
        src = final.fetchurl {
          url = "https://downloads.cursor.com/lab/2026.08.04-aaa8809/linux/x64/agent-cli-package.tar.gz";
          hash = "sha256-4oIGjctc3WaLjOLjRWxYvhO7ZKg04a1J+FNLXNeqL+U=";
        };
      });
    })
  ];

  # ai-jail's bwrap recipe ro-binds /opt; keep an empty dir so NixOS boots still satisfy it.
  systemd.tmpfiles.rules = [ "d /opt 0755 root root -" ];

  # gnupg — signed commits · bubblewrap — enclosure study · s6 — supervision study
  # (s6 packages do not replace systemd as PID 1 on this host)
  # gh — GitHub handshake (guide 2) · claude-code — agent on the pier (guide 2)
  # vim · neovim · kakoune — steward editors (seated 20260808)
  environment.systemPackages = with pkgs; [
    tmux
    git
    gh
    claude-code
    cursor-cli
    vim
    neovim
    kakoune
    gnupg
    bubblewrap
    s6
    s6-rc
  ];

  system.stateVersion = "26.05";
}
