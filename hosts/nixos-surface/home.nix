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
  # eww_symlink = {
  #   enable = true;
  #   home_directory = home_directory;
  # };
  # home.activation = {
  #   set_up_eww = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     run ln -sf /home/sand/nixos-config/dotfiles/eww /home/sand/.config/eww
  #   '';
  # };
  home.stateVersion = "26.05";
}
