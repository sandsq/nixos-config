{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.touchscreen;
in
{
  options = {
    touchscreen = {
      enable = mkEnableOption "enable touchscreen things";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libwacom
      libwacom-surface
      wvkbd
    ];
  };
}
