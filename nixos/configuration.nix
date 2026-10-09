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
  # to name America/New_York, and GLOW_PROFILE.kyri declared it -- yet this line was
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
    "ssh-ed25519 GRAIN_HOST_KEY_1 xykj61@gmail.com xykj61 jail-only vultr SEA VPS (Linux Framework, Livermore)"
    "ssh-ed25519 GRAIN_HOST_KEY_2 keaton@dc1"
  ];

  users.users.keeper = {
    isNormalUser = true;
    description = "first steward of this pier";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 GRAIN_HOST_KEY_1 xykj61@gmail.com xykj61 jail-only vultr SEA VPS (Linux Framework, Livermore)"
      "ssh-ed25519 GRAIN_HOST_KEY_2 keaton@dc1"
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

  # Mouse wheel on this pier. Termux on the Daylight tablet sends Up and Down
  # for the wheel while tmux mouse is off, and Cursor CLI and Claude Code spend
  # those keys on the input box's own history. Blink keeps the wheel and scrolls
  # the printout. mouse on turns the wheel into a mouse event. The two bindings
  # below always enter copy mode and never forward the wheel into the pane.
  # alternate-screen off keeps lines that scroll off the pane in tmux history;
  # with it on, prefix [ shows the lines from before the full-screen app started.
  # history-limit applies to windows created after this file loads. secureSocket
  # stays off so the socket remains /tmp/tmux-1000/default.
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 100000;
    secureSocket = false;
    withUtempter = false;
    extraConfig = ''
      set -g mouse on
      set -g alternate-screen off
      bind-key -n WheelUpPane {
        if -F '#{pane_in_mode}' {
          send-keys -M
        } {
          copy-mode -e
          send-keys -M
        }
      }
      bind-key -n WheelDownPane {
        if -F '#{pane_in_mode}' {
          send-keys -M
        }
      }
    '';
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Hotter Cursor CLI than nixos-26.05's May pin -- patchelf'd for NixOS.
  # Upstream website/hot update lands Aug builds under ~/.local, yet stub-ld
  # refuses those generic Linux binaries; this overlay is the declared road.
  #
  # claude-code: nixos-26.05's pin lags upstream.
  # This overlay pins the latest release, 2.1.295, fetching the same native binary
  # the nixpkgs derivation would, from the same downloads.claude.ai release path.
  # overrideAttrs (version + src) is used rather than .override { manifest = ...; }
  # because the LOCKED nixpkgs holds manifest as a let-binding, not an overridable
  # argument -- overrideAttrs works on both the locked rev and future ones. The
  # sha256 is the linux-x64 checksum from Anthropic's own per-version manifest,
  # read 20261009.150000 from downloads.claude.ai/claude-code-releases/2.1.295/
  # manifest.json's own linux-x64 field (checksum == 4503bfe1...6f358) -- a
  # published checksum rather than a hand's own sha256sum of a downloaded binary,
  # which this bump did not run. The elder 2.1.286 read fe503f65...fc73f,
  # 20261001.125300, verified on metal that round; 2.1.278 read 5c473593...47ab,
  # 20260917. The build self-checks twice: fetchurl fails loudly on any hash
  # mismatch, and versionCheckHook runs `claude --version`.
  #
  # The VERSION STRING is proven by that hook rather than here, and the reason is
  # this overlay's own subject: the downloaded binary is dynamically linked against
  # a generic Linux loader, so stub-ld refuses it until autoPatchelf has run. A
  # hand checking the download by running it reads `Could not start dynamically
  # linked executable` and learns nothing about the version. The checksum is what a
  # hand can verify before the build; the version is what the build verifies after.
  #
  # To bump: read github.com/anthropics/claude-code/releases/latest, then that
  # version's manifest.json for the linux-x64 checksum.
  nixpkgs.overlays = [
    (final: prev: {
      # kakoune: the steward editor, held at upstream's newest STABLE rather than
      # the channel's. `nixos-26.05` carries 2026.04.12 and upstream tags
      # 2026.05.21; moving the channel pin would move every package on the pier,
      # so this overrides one derivation and leaves the rest alone -- the same
      # declared road the three agent CLIs take below.
      #
      # overrideAttrs rather than a replacement, because the nixpkgs package is
      # already a source build of this same project: only the version and the
      # tarball move, and every build input, patch and hook stays as packaged.
      # The hash is the release tarball's own, read on 20260909 with
      # `nix store prefetch-file --hash-type sha256 --unpack`.
      kakoune-unwrapped = prev.kakoune-unwrapped.overrideAttrs (_old: {
        version = "2026.05.21";
        src = final.fetchurl {
          url = "https://github.com/mawww/kakoune/releases/download/v2026.05.21/kakoune-2026.05.21.tar.bz2";
          hash = "sha256-vh3rP+mAigczqxBXMJ2jgLt1cwfo/bsi3EeLZ0trrTQ=";
        };
      });

      # Soft wrap for reading. Kakoune's autowrap-enable command inserts a
      # newline into the buffer once a line passes autowrap_column, and its
      # own note says paragraph formatting can break markup. The wrap
      # highlighter leaves the file alone and folds the display at the
      # window width, on word boundaries, keeping the line's indent.
      # nixos-26.05 has no programs.kakoune module. The binary reads
      # ~/.config/kak/kakrc and, from the shipped kakrc, ${kak_runtime}/kakrc.local.
      # This wrapper is that site file. A kak already running keeps its old
      # display until it is quit and opened again.
      kakoune = prev.wrapKakoune final.kakoune-unwrapped {
        plugins = [
          (final.runCommand "kak-soft-wrap" { } ''
            mkdir -p "$out/share/kak"
            cat > "$out/share/kak/kakrc.local" <<'EOF'
            add-highlighter global/ wrap -word -indent
            EOF
          '')
        ];
      };

      cursor-cli = prev.cursor-cli.overrideAttrs (_old: {
        version = "0-unstable-2026-09-18";
        src = final.fetchurl {
          url = "https://downloads.cursor.com/lab/2026.09.18-9a7762b/linux/x64/agent-cli-package.tar.gz";
          hash = "sha256-sTCPWi/AVFi52JZnUphrsjqXG7zGfIQsHflMS4Eyutk=";
        };
      });
      claude-code = prev.claude-code.overrideAttrs (_old: {
        version = "2.1.295";
        src = final.fetchurl {
          url = "https://downloads.claude.ai/claude-code-releases/2.1.295/linux-x64/claude";
          sha256 = "4503bfe11a6c7fcc1e0b39b5e0d347c04248f750b03b0977b3ad6b531fe6f358";
        };
      });

      # codex: the OpenAI Codex CLI, and DREAM's whole seat on this pier -- the
      # dual star runs `codex exec --sandbox danger-full-access` inside ai-jail
      # (tools/l/launch-dream-dual-chapter.rish). nixos-26.05 pins 0.133.0 while
      # upstream ships 0.162.0, so this overlay is the same declared road the two
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
      # and asserts the string carries 0.162.0. The sha256 below is read
      # 20261009.150000 from GitHub's own release-asset digest field
      # (api.github.com/repos/openai/codex/releases/tags/rust-v0.162.0) rather
      # than from a hand's own sha256sum of a downloaded file, which this bump
      # did not run. The elder 0.155.1 read a0ef8b2d...d9115, verified on this
      # pier against the downloaded file, and the unpacked binary answered
      # `codex-cli 0.155.1`.
      #
      # To bump: read the newest rust-vX.Y.Z tag at github.com/openai/codex/releases,
      # then  nix store prefetch-file --hash-type sha256 <that tag's musl tarball>.
      codex = final.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "codex";
        version = "0.162.0";

        src = final.fetchurl {
          url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-x86_64-unknown-linux-musl.tar.gz";
          sha256 = "8daf67f6261161aa5939d8d42a516032d760406216779d7ce6040f242140ff73";
        };

        # codex-code-mode-host: the second binary 0.150 wants BESIDE codex. The
        # code_mode_host feature read stable-and-default-true in 0.155.1
        # (verified with `codex features list`, 20260828); this bump carries the
        # same artifact forward at the new tag without re-running that check on
        # the pier, so the next lap that touches DREAM's seat should confirm it
        # still reads stable before trusting this comment on its word alone. The
        # tool router spawns $out/bin/codex-code-mode-host for every tool call
        # when the feature is on -- DREAM's first lap on this pier died there
        # three bounded casts in a row, BLOCKED as a machine limit (correctly:
        # the binary was absent, not the tree wrong). Upstream ships it as its
        # own artifact under the same release tag; the sha256 below is read
        # 20261009.150000 from GitHub's own release-asset digest field, the same
        # source and the same honesty as the primary binary above. The elder
        # 0.155.1 asset read b476...4fc5, a hand's own local fetch, 20260828,
        # 21,208,013 bytes.
        codeModeHost = final.fetchurl {
          url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-code-mode-host-x86_64-unknown-linux-musl.tar.gz";
          sha256 = "dee8bf3df637c68e1495b928d643b76d4ad44f94e4f0ed79fe8482fa79e23d97";
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

      # Antigravity CLI: Google publishes a native Linux tarball and a manifest
      # with a SHA-512 digest. The upstream installer self-updates in ~/.local;
      # Nix keeps the pier reproducible by seating the current linux-amd64
      # release here and making future bumps explicit.
      antigravity-cli = final.stdenv.mkDerivation (finalAttrs: {
        pname = "antigravity-cli";
        version = "1.2.7";

        src = final.fetchurl {
          url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.2.7-6731160148115456/linux-x64/cli_linux_x64.tar.gz";
          hash = "sha512-/sdp1hHEr98K5y04vbJlLI4sjnHk9t6XonuA3aPFBCkWDZ4Dd2o2pZuIV8IOdng8SknLD+uLL1w7+SWwzAO7dw==";
        };

        sourceRoot = ".";
        nativeBuildInputs = [ final.autoPatchelfHook ];
        buildInputs = [ final.stdenv.cc.cc.lib ];

        installPhase = ''
          runHook preInstall
          install -Dm755 antigravity "$out/bin/agy"
          runHook postInstall
        '';

        doInstallCheck = true;
        installCheckPhase = ''
          runHook preInstallCheck
          "$out/bin/agy" --version
          runHook postInstallCheck
        '';

        meta = {
          description = "Google Antigravity CLI -- terminal agent client";
          homepage = "https://antigravity.google/";
          mainProgram = "agy";
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
  # vim - neovim - kakoune -- steward editors (seated 20260808). Kakoune takes an
  #   OVERLAY from `20260909` on Keaton's word -- "we definitely want the latest
  #   stable version of kakoune in both the tree and live" -- which supersedes the
  #   20260908 WAIT recorded here before it. Upstream's newest stable is
  #   2026.05.21; `nixos-26.05` carries 2026.04.12, and moving the channel pin
  #   would move every package on the pier. So this follows the same declared road
  #   the three agent CLIs above take: override version and src on the nixpkgs
  #   derivation, leaving every other package on its channel.
  #
  #   The build self-checks the way the others do: fetchurl fails loudly on a hash
  #   mismatch, and it did on the first attempt here. The hash was read with
  #   `--unpack`, which returns the NAR hash of the UNPACKED tree, where fetchurl
  #   wants the hash of the FILE. The build printed the file hash it computed, and
  #   an independent `prefetch-file` without `--unpack` returned the same string --
  #   so the correction is confirmed twice rather than copied from an error.
  #
  #   To bump: read the newest tag at github.com/mawww/kakoune/releases, then
  #   `nix store prefetch-file --hash-type sha256 <that tag's tarball>` -- WITHOUT
  #   `--unpack`, which is the whole of the mistake above.
  #   Gratitude: gratitude/maxime-coste-kakoune.md
  # perl - python3 -- outer-terminal interpreters for legacy scripts the pier
  #   still carries (the .sh/.pl fold to Rishi is in motion, not complete);
  #   available in the outer host shell for Keaton to run (seated 20260819).
  # ai-jail -- enclosure binary on /run/current-system/sw/bin after rebuild.
  #   Overlay above patchelfs the GitHub linux-x86_64 tarball (v1.20.2) and
  #   wraps BWRAP_BIN. Leave AIJAIL_BIN unset so command -v finds that path.
  # huggingfaceCli - llmWithOpenrouter -- open-weight-model tooling named in
  #   open/PROVIDER_SETUP.md and open/PROVIDER_COMPARISON.md (seated 20260920).
  #   Declared here rather than left as an ad-hoc `nix-shell -p` each time,
  #   since both were proven to actually resolve on this pier before being
  #   declared: python313Packages.huggingface-hub (the `hf` CLI, version
  #   1.16.0) and python313Packages.llm.withPlugins { llm-openrouter = true; }
  #   (the `llm` CLI, version 0.30, with the llm-openrouter plugin at 0.6 --
  #   `llm install <plugin>` is disabled under Nix on purpose, so the plugin
  #   is declared at build time here instead). Both versions are current as
  #   of this file's own nixpkgs pin, re-locked to the 2026-09-20 revision of
  #   nixos-26.05 in the same round that added these two lines -- neither
  #   package had moved in the seventeen days since the prior pin, which was
  #   confirmed by reading both versions again after the update rather than
  #   assumed. Two further plugin names, llm-together and llm-togetherai,
  #   were tried the same way and refused to load (an empty `llm plugins`
  #   list both times), so neither is declared here.
  # opencode -- the open-source Claude Code alternative named in
  #   open/HARNESS_SETUP.md (seated 20260920), set up against Together AI's
  #   deepseek-ai/DeepSeek-V4-Pro-0813 as the recommended starting model. This
  #   pin (nixpkgs' 1.15.10, confirmed curlable and confirmed to actually run
  #   `opencode run` end to end against a live Together AI call) sits one
  #   major version behind upstream's own newest tag, v2.0.11 as of
  #   2026-09-20 -- named honestly rather than silently carried, the same way
  #   the kakoune comment above names its own gap, and left as a future
  #   overlay lap rather than attempted here without a tested source hash.
  #   Provider config lives outside this file, at ~/.config/opencode/opencode.json
  #   and ~/.local/share/opencode/auth.json -- personal, untracked, documented
  #   in open/HARNESS_SETUP.md rather than declared here.
  # qemu -- qemu-system-riscv64, the binary aurora_run.rish wakes with
  #   `-machine virt`. The hosted channel-roster witness runs without it.
  #   The freestanding wake is the install this line exists to provide.
  environment.systemPackages = with pkgs; [
    opencode
    jq       # JSON -- live stream-json rendering for the season loop (agent visibility)
    git
    git-filter-repo  # deep-debride: safe history rewrite (git filter-repo)
    gh
    claude-code
    cursor-cli
    codex    # OpenAI Codex CLI -- DREAM's seat, run inside ai-jail on this pier
    antigravity-cli  # Google Antigravity CLI -- `agy`
    vim
    neovim
    kakoune
    gnupg
    bubblewrap
    s6
    s6-rc
    perl     # outer-terminal Perl -- legacy scripts pending the Rishi fold
    python3  # outer-terminal Python 3 -- absent on the pier before this (REDS memory)
    qemu     # qemu-system-riscv64 -- Aurora freestanding wake on -machine virt
    ai-jail  # enclosure -- GitHub release, patchelf'd; not a crates.io build
    python313Packages.huggingface-hub  # `hf` CLI -- open/PROVIDER_COMPARISON.md
    (python313Packages.llm.withPlugins { llm-openrouter = true; })  # `llm` CLI + OpenRouter
  ];

  system.stateVersion = "26.05";
}
