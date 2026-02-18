{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.hyprland_home_manager_module;
in
{
  options = {
    hyprland_home_manager_module = {
      enable = mkEnableOption "enable my hyprland stuff";
      hyprland_conf_path = mkOption {
        type = types.path;
        default = ../dotfiles/hypr/hyprland.conf;
      };
    };
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      plugins = [
        inputs.hyprgrass.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      extraConfig = builtins.readFile cfg.hyprland_conf_path;

    };

    home.packages = with pkgs; [
      inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
      hyprpicker
      hyprlock
      hypridle
      grimblast
      hyprlang
      hyprls
      hyprsunset
    ];

    services.hyprpaper = {
      enable = true;
    };
  };
}
