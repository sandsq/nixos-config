{
  lib,
  config,
  pkgs,
  ...
}:
{
  # so signins persist or something (like zed)
  services.gnome.gnome-keyring.enable = true;
  networking.networkmanager.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];
}
