{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{

  home.packages = with pkgs; [
    libnotify
    dunst

    zed-editor
    nil
    nixd
    package-version-server
    tree

    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.qtimageformats
    kdePackages.qtmultimedia
    kdePackages.qt5compat

    eww

    killall

    gh

    jq
    bc

    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    quickshell

    dropbox
    fastfetch
    libcamera
  ];

  programs.firefox.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      shell = "fish";
    };
    font.name = "Departure Mono";
    font.size = 16.0;
    themeFile = "GruvboxMaterialLightMedium";
  };

  programs.fish = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
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

}
