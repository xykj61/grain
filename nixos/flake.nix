# Living Dallas flake -- NixOS 26.05, systemd PID 1, flakes + modules.
#
# infuse.nix (gratitude/infuse.nix, MIT) is a deep-override combinator, not a
# host OS. SixOS uses it *instead of* nixpkgs/lib/modules and s6 *instead of*
# systemd. This pier stays NixOS: flakes pin inputs, configuration.nix is the
# module. Grain's own infuse lives at brix/infuse.rye.
#
# ai-jail is an input of its own (not pkgs) because upstream builds with
# rust-overlay rustc 1.97.1 and wraps BWRAP_BIN. Following nixos-26.05 would
# miss that toolchain; the nested flake keeps its nixpkgs.
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    ai-jail.url = "github:akitaonrails/ai-jail";
  };

  outputs = { nixpkgs, disko, ai-jail, ... }: {
    nixosConfigurations.pier = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit ai-jail; };
      modules = [
        disko.nixosModules.disko
        ./disk-config.nix
        ./configuration.nix
      ];
    };
  };
}
