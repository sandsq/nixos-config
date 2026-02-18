{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  options = {
    fonts = {
      enable = mkEnableOption "enable some fonts I like";
    };
  };
  config = mkIf config.fonts.enable {
    fonts.packages = with pkgs; [
      ubuntu-classic
      ubuntu-sans
      ubuntu-sans-mono
      nerd-fonts.fira-code
      departure-mono
      font-awesome
    ];
  };
}
