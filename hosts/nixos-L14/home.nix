{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  home_directory = "/home/sand";
in
{
  home.username = "sand";
  home.homeDirectory = home_directory;

  imports = [
    ../../home_manager_modules
  ];
  hyprland_home_manager_module.enable = true;
  hyprland_home_manager_module.conf_path = ../../dotfiles/hypr/hyprland.conf;
  hyprland_home_manager_module.include_basics = false;
  eww_symlink = {
    enable = true;
    home_directory = home_directory;
  };

  home.stateVersion = "26.05";
}
