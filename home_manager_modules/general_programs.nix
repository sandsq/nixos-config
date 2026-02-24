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

    zed-editor # has issue with file picker
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

    jq
    bc

    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    quickshell

    dropbox
    fastfetch
  ];
  programs.vscode.enable = true;

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
  xdg.desktopEntries = {
    yazi = {
      name = "Yazi";
      icon = "yazi";
      genericName = "TUI file manager";
      exec = "kitty yazi %u";
      terminal = false;
      categories = [
        "Utility"
        "Core"
        "System"
        "FileTools"
        "FileManager"
        "ConsoleOnly"
      ];
      mimeType = [ "inode/directory" ];
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

  # [Desktop Entry]
  # Name=Yazi
  # Icon=yazi
  # Comment=Blazing fast terminal file manager written in Rust, based on async I/O
  # Terminal=true
  # TryExec=yazi
  # Exec=yazi %u
  # Type=Application
  # MimeType=inode/directory
  # Categories=Utility;Core;System;FileTools;FileManager;ConsoleOnly
  # Keywords=File;Manager;Explorer;Browser;Launcher
}
