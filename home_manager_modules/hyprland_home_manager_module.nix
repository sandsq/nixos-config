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
      conf_path = mkOption {
        type = types.path;
        default = ../dotfiles/hypr/hyprland.conf;
      };
      include_basics = mkOption {
        type = types.bool;
        default = true;
        description = "include basic programs (kitty, fuzzel)";
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

      extraConfig = builtins.readFile cfg.conf_path;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # need for file picker
      config = {
        preferred = {
          default = [ "hyprland" ];
          "org.freedesktop.impl.portal.FileChooser" = [
            "gtk"
          ];
        };
      };
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
      wl-clipboard
      socat
    ];

    services.hyprpaper = {
      enable = true;
    };

    programs.kitty = mkIf cfg.include_basics {
      enable = true;
    };
    programs.fuzzel = mkIf cfg.include_basics {
      enable = true;
    };
  };
}
