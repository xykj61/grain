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

  # One clock, named rather than offset (REDS %90). The one-clock law asks the host
  # to name America/New_York, and GLOW_PROFILE.bron declared it -- yet this line was
  # never written, so the pier ran UTC by absence and one_clock_witness duty 3 stood
  # RED. Stamps stayed correct only because every caller passed TZ explicitly; the
  # ground now carries the claim the profile makes.
  time.timeZone = "America/New_York";

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

      # codex: the OpenAI Codex CLI, and DREAM's whole seat on this pier -- the
      # dual star runs `codex exec --sandbox danger-full-access` inside ai-jail
      # (tools/l/launch-dream-dual-chapter.rish). nixos-26.05 pins 0.133.0 while
      # upstream ships 0.150.1, so this overlay is the same declared road the two
      # entries above take, for the fastest-moving of the three agent CLIs.
      #
      # This one REPLACES the derivation rather than overrideAttrs'ing it, because
      # the nixpkgs package is a buildRustPackage compiled from source and this is
      # a prebuilt binary -- a version+src override across those two shapes would
      # leave a cargoHash describing a source tree that is no longer fetched.
      #
      # The x86_64-unknown-linux-musl asset is STATICALLY linked, checked on metal
      # 20260827 (`ldd` reports "statically linked"), which is why no autoPatchelf
      # and no interpreter fixup appear below -- the NixOS stub-ld problem that
      # forces patchelf on the cursor-cli tarball does not arise for a binary that
      # resolves no dynamic loader at all. stdenvNoCC is therefore honest: nothing
      # here compiles. dontStrip holds because stripping a 268 MB static Rust
      # binary buys little and risks its embedded metadata.
      #
      # The build self-checks twice, exactly as claude-code's does: fetchurl fails
      # loudly on any hash mismatch, and versionCheckHook runs `codex --version`
      # and asserts the string carries 0.150.1. The sha256 below is the release
      # asset's own checksum, verified on this pier against the downloaded file
      # (sha256sum == ab308870...5c7a, 20260827) and the unpacked binary answered
      # `codex-cli 0.150.1`.
      #
      # To bump: read the newest rust-vX.Y.Z tag at github.com/openai/codex/releases,
      # then  nix store prefetch-file --hash-type sha256 <that tag's musl tarball>.
      codex = final.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "codex";
        version = "0.150.1";

        src = final.fetchurl {
          url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-x86_64-unknown-linux-musl.tar.gz";
          sha256 = "ab308870bc7fc048c23dc49d03f6b8af9ce7fc99b9da882d6688be7a90155c7a";
        };

        # codex-code-mode-host: the second binary 0.150 wants BESIDE codex. The
        # code_mode_host feature reads stable-and-default-true in this release
        # (verified with `codex features list`, 20260828), and the tool router
        # spawns $out/bin/codex-code-mode-host for every tool call when it is on
        # -- DREAM's first lap on this pier died there three bounded casts in a
        # row, BLOCKED as a machine limit (correctly: the binary was absent, not
        # the tree wrong). Upstream ships it as its own artifact under the same
        # release tag; hash from a local fetch of that artifact, sha256sum ==
        # b476...4fc5, 20260828, 21,208,013 bytes.
        codeModeHost = final.fetchurl {
          url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-code-mode-host-x86_64-unknown-linux-musl.tar.gz";
          sha256 = "b47667846125cdf6dbc460c6fdc418afb2ef3926c54f4d999bbfbeb08dee4fc5";
        };

        # The tarball holds one bare file rather than a directory, so the default
        # sourceRoot guess ("the single subdirectory") finds nothing to enter.
        sourceRoot = ".";

        dontStrip = true;

        installPhase = ''
          runHook preInstall
          install -Dm755 codex-x86_64-unknown-linux-musl "$out/bin/codex"
          tar -xzf ${finalAttrs.codeModeHost}
          install -Dm755 codex-code-mode-host-x86_64-unknown-linux-musl "$out/bin/codex-code-mode-host"
          runHook postInstall
        '';

        doInstallCheck = true;
        nativeInstallCheckInputs = [ final.versionCheckHook ];
        versionCheckProgramArg = "--version";

        meta = {
          description = "OpenAI Codex CLI -- the coding agent DREAM runs inside ai-jail";
          homepage = "https://github.com/openai/codex";
          license = final.lib.licenses.asl20;
          mainProgram = "codex";
          platforms = [ "x86_64-linux" ];
          sourceProvenance = [ final.lib.sourceTypes.binaryNativeCode ];
        };
      });

      # ai-jail: GitHub linux-x86_64 release, patchelf'd, BWRAP_BIN wrapped.
      # The upstream flake builds from source and vendors crates.io; on this
      # pier (20260904) cargo-vendor 403'd crate-landlock-0.4.4.tar.gz --
      # crates.io blocks the default curl User-Agent (nixpkgs issue 558620).
      # The release tarball is a glibc ELF (interpreter /lib64/ld-linux,
      # NEEDED libgcc_s and libc, read on the Mac 20260904) so a bare extract
      # hits NixOS stub-ld; autoPatchelfHook is the same road cursor-cli takes.
      # Hash is the asset digest GitHub published for v1.20.2, sha256sum-checked
      # on this Mac the same morning (03ab6f00...5b1c).
      #
      # To bump: read github.com/akitaonrails/ai-jail/releases/latest, then the
      # ai-jail-linux-x86_64.tar.gz checksum on that page.
      ai-jail = final.stdenv.mkDerivation (finalAttrs: {
        pname = "ai-jail";
        version = "1.20.2";

        src = final.fetchurl {
          url = "https://github.com/akitaonrails/ai-jail/releases/download/v${finalAttrs.version}/ai-jail-linux-x86_64.tar.gz";
          sha256 = "03ab6f0066ba62d1fcf9085b171543cb5a23a349e1d3dd01c0222ab1aaed5b1c";
        };

        sourceRoot = ".";

        nativeBuildInputs = [
          final.autoPatchelfHook
          final.makeWrapper
        ];
        buildInputs = [ final.stdenv.cc.cc.lib ];

        dontStrip = true;

        installPhase = ''
          runHook preInstall
          install -Dm755 ai-jail "$out/bin/ai-jail"
          runHook postInstall
        '';

        postFixup = ''
          wrapProgram "$out/bin/ai-jail" \
            --set BWRAP_BIN "${final.lib.getExe final.bubblewrap}"
        '';

        doInstallCheck = true;
        installCheckPhase = ''
          runHook preInstallCheck
          "$out/bin/ai-jail" --version
          runHook postInstallCheck
        '';

        meta = {
          description = "Linux enclosure for CLI agents -- bwrap, patchelf'd for NixOS";
          homepage = "https://github.com/akitaonrails/ai-jail";
          license = final.lib.licenses.gpl3Only;
          mainProgram = "ai-jail";
          platforms = [ "x86_64-linux" ];
          sourceProvenance = [ final.lib.sourceTypes.binaryNativeCode ];
        };
      });
    })
  ];

  # ai-jail's bwrap recipe ro-binds /opt; keep an empty dir so NixOS boots still satisfy it.
  systemd.tmpfiles.rules = [ "d /opt 0755 root root -" ];

  # gnupg -- signed commits - bubblewrap -- enclosure study - s6 -- supervision study
  # (s6 packages do not replace systemd as PID 1 on this host)
  # gh -- GitHub handshake (guide 2) - claude-code -- agent on the pier (guide 2)
  # codex -- OpenAI Codex CLI; DREAM the dual star runs it inside ai-jail on this
  #   pier, holding the systems core (Caravan, Tally, the microkernel road, the
  #   constellation table); seated 20260827 with the role swap.
  # vim - neovim - kakoune -- steward editors (seated 20260808)
  # perl - python3 -- outer-terminal interpreters for legacy scripts the pier
  #   still carries (the .sh/.pl fold to Rishi is in motion, not complete);
  #   available in the outer host shell for Keaton to run (seated 20260819).
  # ai-jail -- enclosure binary on /run/current-system/sw/bin after rebuild.
  #   Overlay above patchelfs the GitHub linux-x86_64 tarball (v1.20.2) and
  #   wraps BWRAP_BIN. Leave AIJAIL_BIN unset so command -v finds that path.
  environment.systemPackages = with pkgs; [
    jq       # JSON -- live stream-json rendering for the season loop (agent visibility)
    tmux
    git
    git-filter-repo  # deep-debride: safe history rewrite (git filter-repo)
    gh
    claude-code
    cursor-cli
    codex    # OpenAI Codex CLI -- DREAM's seat, run inside ai-jail on this pier
    vim
    neovim
    kakoune
    gnupg
    bubblewrap
    s6
    s6-rc
    perl     # outer-terminal Perl -- legacy scripts pending the Rishi fold
    python3  # outer-terminal Python 3 -- absent on the pier before this (REDS memory)
    ai-jail  # enclosure -- GitHub release, patchelf'd; not a crates.io build
  ];

  system.stateVersion = "26.05";
}
