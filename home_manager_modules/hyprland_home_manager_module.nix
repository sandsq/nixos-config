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
        # inputs.hyprgrass.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      extraConfig = builtins.readFile cfg.conf_path;
    };

    # xdg.portal = {
    #   enable = true;
    #   extraPortals = [
    #     pkgs.xdg-desktop-portal-hyprland
    #     pkgs.xdg-desktop-portal-gtk
    #     pkgs.xdg-desktop-portal
    #   ];
    #   xdgOpenUsePortal = true;
    #   config = {
    #     preferred = {
    #       default = [
    #         "hyprland"
    #         "gtk"
    #       ];
    #       "org.freedesktop.impl.portal.FileChooser" = [
    #         "gtk"
    #       ];
    #       "org.freedesktop.impl.portal.OpenURI" = [
    #         "gtk"
    #       ];
    #     };
    #   };
    # };
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        # pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      # xdgOpenUsePortal = true;
      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.portal.OpenURI" = [ "gtk" ];
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
      xdg-utils
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
