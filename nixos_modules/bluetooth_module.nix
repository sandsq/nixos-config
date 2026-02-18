{
  lib,
  config,
  ...
}:
with lib;
{
  options = {
    bluetooth_module = {
      enable = mkEnableOption "enable bluetooth";
    };
  };
  config = mkIf config.bluetooth_module.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;
  };
}
