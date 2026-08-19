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

  # mosh roam window: stock programs.mosh opens only 60000-61000, yet a roaming
  # client can land anywhere in the upper range - open 60000-65535 so a session
  # survives the roam. Additive: SSH (22) stays open via the ssh daemon.
  networking.firewall.allowedUDPPortRanges = [
    { from = 60000; to = 65535; }
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Hotter Cursor CLI than nixos-26.05's May pin -- patchelf'd for NixOS.
  # Upstream website/hot update lands Aug builds under ~/.local, yet stub-ld
  # refuses those generic Linux binaries; this overlay is the declared road.
  #
  # claude-code: nixos-26.05's pin lags upstream (the locked flake had 2.1.187).
  # This overlay pins the latest release, 2.1.235 (2026-08-18), fetching the same
  # native binary the nixpkgs derivation would, from the same downloads.claude.ai
  # release path. overrideAttrs (version + src) is used rather than .override
  # { manifest = ...; } because the LOCKED nixpkgs holds manifest as a let-binding,
  # not an overridable argument -- overrideAttrs works on both the locked rev and
  # future ones. The sha256 is the linux-x64 checksum from Anthropic's own
  # per-version manifest, verified on metal against the downloaded binary
  # (sha256sum == bfcf0ae2...d5d5, 20260819). The build self-checks twice: fetchurl
  # fails loudly on any hash mismatch, and versionCheckHook runs `claude --version`.
  # To bump: read downloads.claude.ai/claude-code-releases/latest, then that
  # version's manifest.json for the linux-x64 checksum.
  nixpkgs.overlays = [
    (final: prev: {
      cursor-cli = prev.cursor-cli.overrideAttrs (_old: {
        version = "0-unstable-2026-08-04";
        src = final.fetchurl {
          url = "https://downloads.cursor.com/lab/2026.08.04-aaa8809/linux/x64/agent-cli-package.tar.gz";
          hash = "sha256-4oIGjctc3WaLjOLjRWxYvhO7ZKg04a1J+FNLXNeqL+U=";
        };
      });
      claude-code = prev.claude-code.overrideAttrs (_old: {
        version = "2.1.235";
        src = final.fetchurl {
          url = "https://downloads.claude.ai/claude-code-releases/2.1.235/linux-x64/claude";
          sha256 = "bfcf0ae2dbf94b2b6a106074aabf3938b9a10889c3b678e4cb5a00c03274d5d5";
        };
      });
    })
  ];

  # ai-jail's bwrap recipe ro-binds /opt; keep an empty dir so NixOS boots still satisfy it.
  systemd.tmpfiles.rules = [ "d /opt 0755 root root -" ];

  # gnupg -- signed commits - bubblewrap -- enclosure study - s6 -- supervision study
  # (s6 packages do not replace systemd as PID 1 on this host)
  # gh -- GitHub handshake (guide 2) - claude-code -- agent on the pier (guide 2)
  # vim - neovim - kakoune -- steward editors (seated 20260808)
  # perl - python3 -- outer-terminal interpreters for legacy scripts the pier
  #   still carries (the .sh/.pl fold to Rishi is in motion, not complete);
  #   available in the outer host shell for Keaton to run (seated 20260819).
  environment.systemPackages = with pkgs; [
    jq       # JSON -- live stream-json rendering for the season loop (agent visibility)
    tmux
    git
    git-filter-repo  # deep-debride: safe history rewrite (git filter-repo)
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
    perl     # outer-terminal Perl -- legacy scripts pending the Rishi fold
    python3  # outer-terminal Python 3 -- absent on the pier before this (REDS memory)
  ];

  system.stateVersion = "26.05";
}
