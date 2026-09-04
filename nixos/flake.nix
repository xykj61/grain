# Living Dallas flake -- NixOS 26.05, systemd PID 1, flakes + modules.
#
# infuse.nix (gratitude/infuse.nix, MIT) is a deep-override combinator, not a
# host OS. SixOS uses it *instead of* nixpkgs/lib/modules and s6 *instead of*
# systemd. This pier stays NixOS: flakes pin inputs, configuration.nix is the
# module. Grain's own infuse lives at brix/infuse.rye.
#
# ai-jail is a GitHub-release overlay in configuration.nix, not a flake input.
# Upstream's flake vendors crates.io during cargo-vendor; crates.io 403s the
# default curl User-Agent (landlock-0.4.4, 20260904 on this pier). The
# linux-x86_64 tarball is a glibc ELF; autoPatchelfHook is the stub-ld fix.
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, disko, ... }: {
    nixosConfigurations.pier = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./disk-config.nix
        ./configuration.nix
      ];
    };
  };
}
