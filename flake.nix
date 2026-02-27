{
  ###########
  ## To Dos
  ###########
  # modularize
  # webcam
  # home manager
  # fix file picker not working in zed
  # package a pixel art icon theme
  # write eww scripts with writeShellApplication
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware?rev=66e1a090ded57a0f88e2b381a7d4daf4a5722c3f";
    hyprland.url = "github:hyprwm/Hyprland"; # ?ref=v0.53.3";
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }:
    {
      nixosConfigurations = {

        nixos-surface = nixpkgs.lib.nixosSystem {
          # microsoft-surface.ipts.enable = true; # these are already enabled in the nixos-hardware modules for surface
          # config.microsoft-surface.surface-control.enable = true;
          specialArgs = { inherit inputs; };
          modules = [
            nixos-hardware.nixosModules.microsoft-surface-common
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            ./hosts/nixos-surface
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.sand = import ./hosts/nixos-surface/home.nix;
            }
          ];
        };
        nixos-L14 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-l14-amd
            ./hosts/nixos-L14
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.sand = import ./hosts/nixos-L14/home.nix;
            }
          ];
        };
      };
    };
}
