{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  options = {
    obs = {
      enable = mkEnableOption "enable obs";
    };
  };
  config = mkIf config.obs.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };
}
