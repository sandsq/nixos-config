{ config, pkgs, inputs, ... }:
{
  home.username = "sand";
  home.homeDirectory = "/home/sand";

  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprgrass.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  home.stateVersion = "26.05";
}
