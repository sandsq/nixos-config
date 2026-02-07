{
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:8bitbuddhist/nixos-hardware?ref=surface-rust-target-spec-fix";
  };
  outputs = inputs@{ self, nixpkgs, nixos-hardware, ... }: {
    microsoft-surface.ipts.enable = true;
    config.microsoft-surface.surface-control.enable = true;
    # NOTE: 'nixos' is the default hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [ 
		  nixos-hardware.nixosModules.microsoft-surface-common
                  nixos-hardware.nixosModules.microsoft-surface-pro-intel
                  ./configuration.nix 
		];
    };
  };
}

