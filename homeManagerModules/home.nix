{
  pkgs,
  inputs,
  ...
}:
{
  home.username = "sand";
  home.homeDirectory = "/home/sand";

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
    hyprlang
    hyprls
    hyprsunset
  ];

  services.hyprpaper = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    # font.name = "ubuntu-sans-mono";
    settings = {
      shell = "fish";
    };
    font.name = "Departure Mono";
    font.size = 16.0;
    themeFile = "GruvboxMaterialLightMedium";
  };

  programs.fish = {
    enable = true;
    # shellInitLast = "starship init fish | source";
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      mgr = {
        show_hidden = true;
      };
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Departure Mono:size=16";
        placeholder = "hello c:";
        icon-theme = "Dracula";
      };
      colors = {
        background = "#3e2861ee";
        border = "#fed078ee";
        text = "#fed078ee";
        input = "#fed078ee";
        prompt = "#fed078ee";
        placeholder = "#fed07866";
        match = "#9bc9a3ee";
        selection = "#fed078ee";
        selection-text = "#3e2861ee";
        # selection-match = "#607D65ee";
      };
      border = {
        width = 3;
        radius = 0;
      };
    };
  };

  home.stateVersion = "26.05";
}
