{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  options = {
    steam = {
      enable = mkEnableOption "enable steam";
    };
  };
  config = mkIf config.obs.enable {
    programs.steam.enable = true;
  };
}
