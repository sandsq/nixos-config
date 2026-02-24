{
  pkgs,
  inputs,
  lib,
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

  # source ${config.system.build.setEnvironment}
  home.activation = {
    set_up_eww = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ln -sf $HOME/nixos-config-surface/dotfiles/eww $HOME/.config/eww
    '';
  };

  home.stateVersion = "26.05";
}
