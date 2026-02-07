{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:8bitbuddhist/nixos-hardware?ref=surface-rust-target-spec-fix";
    hyprland.url = "github:hyprwm/Hyprland"; # ?ref=v0.53.3";

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
  };
  outputs = inputs@{ self, nixpkgs, nixos-hardware, ... }: {
    microsoft-surface.ipts.enable = true;
    config.microsoft-surface.surface-control.enable = true;
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs; };
      modules = [
        nixos-hardware.nixosModules.microsoft-surface-common
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
        ./configuration.nix
      ];
    };
  };
}
