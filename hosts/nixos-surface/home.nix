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
  hyprland_home_manager_module.conf_path = ../../dotfiles/hypr/hyprland.conf;
  hyprland_home_manager_module.include_basics = false;

  home.stateVersion = "26.05";
}
