{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    dracula-icon-theme
  ];

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
}
