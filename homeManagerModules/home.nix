{ config, pkgs, inputs, ... }: {
  home.username = "sand";
  home.homeDirectory = "/home/sand";

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    plugins = [
      inputs.hyprgrass.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    extraConfig = builtins.readFile ../dotfiles/hypr/hyprland.conf;

  };

  home.packages = with pkgs; [
    inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
    hyprpicker
    hyprlock
    hypridle
    grimblast
  ];

  services.hyprpaper = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    # font.name = "ubuntu-sans-mono";
    font.name = "Departure Mono";
    font.size = 16.0;
    themeFile = "GruvboxMaterialLightMedium";
  };

  programs.yazi = {
    enable = true;
    settings = {
      mgr = {
        show_hidden = true;
      };
    };
  };

  home.stateVersion = "26.05";
}
