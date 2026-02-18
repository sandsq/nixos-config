{
  pkgs,
  inputs,
  ...
}:
{
  home.username = "sand";
  home.homeDirectory = "/home/sand";

  imports = [
    ../../home_manager_modules
  ];
  hyprland_home_manager_module.enable = true;

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
  gtk = {
    enable = true;
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    theme = {
      name = "Nightfox-Dark";
      package = pkgs.nightfox-gtk-theme;
    };
  };
  home.stateVersion = "26.05";
}
